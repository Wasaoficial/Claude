local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")

local GameConfig = require(ReplicatedStorage.Modules.GameConfig)
local CombatSystem = require(ReplicatedStorage.Modules.CombatSystem)
local ComboSystem = require(ReplicatedStorage.Modules.ComboSystem)

local RankedStore = DataStoreService:GetOrderedDataStore("RankedElo_v1")

local Events = ReplicatedStorage:WaitForChild("Events")
local AttackEvent = Events:WaitForChild("Attack")
local DamageEvent = Events:WaitForChild("Damage")
local StockLostEvent = Events:WaitForChild("StockLost")
local UpdateHUDEvent = Events:WaitForChild("UpdateHUD")
local RankedQueueEvent = Events:WaitForChild("RankedQueue")
local RankedMatchStartEvent = Events:WaitForChild("RankedMatchStart")
local RankedMatchEndEvent = Events:WaitForChild("RankedMatchEnd")
local RankedUpdateEvent = Events:WaitForChild("RankedUpdate")
local ComboEvent = Events:WaitForChild("ComboUpdate")

local RankedElo = {} -- { [player] = elo }
local RankedQueue = {} -- { player1, player2, ... }
local RankedMatch = {
	InProgress = false,
	Players = {},
	Timer = 0,
	Arena = nil,
}
local Cooldowns = {}

-- Load/Save ELO
local function LoadElo(player)
	local success, elo = pcall(function()
		return RankedStore:GetAsync("Player_" .. player.UserId)
	end)
	RankedElo[player] = (success and elo) or GameConfig.RANKED_STARTING_ELO
end

local function SaveElo(player)
	local elo = RankedElo[player]
	if not elo then return end
	pcall(function()
		RankedStore:SetAsync("Player_" .. player.UserId, elo)
	end)
end

local function CalculateEloChange(winnerElo, loserElo)
	local expected = 1 / (1 + 10 ^ ((loserElo - winnerElo) / 400))
	local change = math.floor(GameConfig.RANKED_K_FACTOR * (1 - expected))
	return math.max(change, 5)
end

-- Queue system
RankedQueueEvent.OnServerEvent:Connect(function(player, action)
	if action == "join" then
		if table.find(RankedQueue, player) then return end
		if RankedMatch.InProgress and RankedMatch.Players[player] then return end

		table.insert(RankedQueue, player)
		RankedUpdateEvent:FireClient(player, "QueueJoined", {
			Position = #RankedQueue,
			Elo = RankedElo[player] or GameConfig.RANKED_STARTING_ELO,
			Tier = GameConfig.GetTier(RankedElo[player] or GameConfig.RANKED_STARTING_ELO),
		})

	elseif action == "leave" then
		for i, p in ipairs(RankedQueue) do
			if p == player then
				table.remove(RankedQueue, i)
				RankedUpdateEvent:FireClient(player, "QueueLeft", {})
				break
			end
		end
	end
end)

-- Combat for ranked
local function ProcessRankedAttack(attacker, attackType)
	local attackerData = RankedMatch.Players[attacker]
	if not attackerData then return end

	local charConfig = GameConfig.Characters[attackerData.SelectedCharacter]
	local attackData = charConfig.Attacks[attackType]
	if not attackData then return end

	local cooldownKey = attacker.UserId .. "_ranked_" .. attackType
	if Cooldowns[cooldownKey] and tick() - Cooldowns[cooldownKey] < attackData.Cooldown then
		return
	end
	Cooldowns[cooldownKey] = tick()

	local attackerChar = attacker.Character
	if not attackerChar or not attackerChar:FindFirstChild("HumanoidRootPart") then return end

	for player, data in pairs(RankedMatch.Players) do
		if player ~= attacker then
			local victimChar = player.Character
			if victimChar and victimChar:FindFirstChild("HumanoidRootPart") then
				if CombatSystem.IsInRange(attackerChar, victimChar, attackData.Range) then
					local combo = ComboSystem.RegisterHit(attacker.UserId, player.UserId, attackType)
					local damageMultiplier = ComboSystem.GetDamageMultiplier(combo)
					local kbMultiplier = ComboSystem.GetKnockbackMultiplier(combo)

					local finalDamage = attackData.Damage * damageMultiplier
					data.DamagePercent = data.DamagePercent + finalDamage

					local direction = CombatSystem.GetKnockbackDirection(attackerChar, victimChar, attackType)
					local force = CombatSystem.CalculateKnockback(data.DamagePercent, attackData.Knockback) * kbMultiplier
					CombatSystem.ApplyKnockback(victimChar, direction, force)

					DamageEvent:FireAllClients(player, data.DamagePercent, attacker)
					ComboEvent:FireAllClients(attacker, player, combo.Hits, finalDamage)

					for p in pairs(RankedMatch.Players) do
						UpdateHUDEvent:FireClient(p, RankedMatch.Players)
					end
				end
			end
		end
	end
end

local function CheckRankedBlastZones()
	for player, data in pairs(RankedMatch.Players) do
		local char = player.Character
		if char and CombatSystem.CheckBlastZone(char) then
			data.Stocks = data.Stocks - 1
			data.DamagePercent = 0
			ComboSystem.ResetAllForPlayer(player.UserId)

			StockLostEvent:FireAllClients(player, data.Stocks)

			if data.Stocks > 0 then
				task.delay(GameConfig.RESPAWN_TIME, function()
					if player.Character then
						local arena = GameConfig.Arenas[RankedMatch.Arena or 1]
						local spawnIndex = math.random(1, #arena.SpawnPoints)
						player.Character:MoveTo(arena.SpawnPoints[spawnIndex])
					end
				end)
			end

			for p in pairs(RankedMatch.Players) do
				UpdateHUDEvent:FireClient(p, RankedMatch.Players)
			end
		end
	end
end

local function GetRankedAlivePlayers()
	local alive = {}
	for player, data in pairs(RankedMatch.Players) do
		if data.Stocks > 0 then
			table.insert(alive, player)
		end
	end
	return alive
end

local function EndRankedMatch(winner)
	RankedMatch.InProgress = false

	local loser = nil
	for player in pairs(RankedMatch.Players) do
		if player ~= winner then
			loser = player
			break
		end
	end

	if winner and loser then
		local winnerElo = RankedElo[winner] or GameConfig.RANKED_STARTING_ELO
		local loserElo = RankedElo[loser] or GameConfig.RANKED_STARTING_ELO

		local eloChange = CalculateEloChange(winnerElo, loserElo)

		RankedElo[winner] = winnerElo + eloChange
		RankedElo[loser] = math.max(0, loserElo - eloChange)

		SaveElo(winner)
		SaveElo(loser)

		local winnerTier = GameConfig.GetTier(RankedElo[winner])
		local loserTier = GameConfig.GetTier(RankedElo[loser])

		RankedMatchEndEvent:FireClient(winner, {
			Result = "WIN",
			EloChange = eloChange,
			NewElo = RankedElo[winner],
			Tier = winnerTier,
		})
		RankedMatchEndEvent:FireClient(loser, {
			Result = "LOSS",
			EloChange = -eloChange,
			NewElo = RankedElo[loser],
			Tier = loserTier,
		})
	end

	RankedMatch.Players = {}
end

local function StartRankedMatch(player1, player2)
	RankedMatch.InProgress = true
	RankedMatch.Arena = math.random(1, #GameConfig.Arenas)
	RankedMatch.Timer = GameConfig.RANKED_ROUND_TIME
	RankedMatch.Players = {}

	local arena = GameConfig.Arenas[RankedMatch.Arena]

	local players = { player1, player2 }
	for i, player in ipairs(players) do
		local charIndex = 1
		-- Use player's selection if available
		local SelectCharacterEvent = Events:FindFirstChild("SelectCharacter")
		if SelectCharacterEvent then
			charIndex = player:GetAttribute("SelectedCharacter") or 1
		end

		RankedMatch.Players[player] = {
			SelectedCharacter = charIndex,
			Stocks = GameConfig.RANKED_STOCKS,
			DamagePercent = 0,
			Kills = 0,
		}

		if player.Character then
			local spawnPos = arena.SpawnPoints[i]
			player.Character:MoveTo(spawnPos)
			local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				local config = GameConfig.Characters[charIndex]
				humanoid.WalkSpeed = config.Speed
				humanoid.JumpPower = config.JumpPower
			end
		end
	end

	local elo1 = RankedElo[player1] or GameConfig.RANKED_STARTING_ELO
	local elo2 = RankedElo[player2] or GameConfig.RANKED_STARTING_ELO

	RankedMatchStartEvent:FireClient(player1, {
		Opponent = player2.Name,
		OpponentElo = elo2,
		OpponentTier = GameConfig.GetTier(elo2),
		YourElo = elo1,
		YourTier = GameConfig.GetTier(elo1),
	})
	RankedMatchStartEvent:FireClient(player2, {
		Opponent = player1.Name,
		OpponentElo = elo1,
		OpponentTier = GameConfig.GetTier(elo1),
		YourElo = elo2,
		YourTier = GameConfig.GetTier(elo2),
	})

	-- Ranked game loop
	task.spawn(function()
		while RankedMatch.InProgress do
			task.wait(0.1)
			CheckRankedBlastZones()
			ComboSystem.CleanupExpired()

			local alive = GetRankedAlivePlayers()
			if #alive <= 1 then
				EndRankedMatch(alive[1])
				return
			end

			RankedMatch.Timer = RankedMatch.Timer - 0.1
			if RankedMatch.Timer <= 0 then
				local best = nil
				local bestScore = -1
				for player, data in pairs(RankedMatch.Players) do
					if data.Stocks > 0 then
						local score = data.Stocks * 1000 - data.DamagePercent
						if score > bestScore then
							bestScore = score
							best = player
						end
					end
				end
				EndRankedMatch(best)
				return
			end
		end
	end)
end

-- Route ranked attacks
AttackEvent.OnServerEvent:Connect(function(player, attackType)
	if RankedMatch.InProgress and RankedMatch.Players[player] then
		ProcessRankedAttack(player, attackType)
	end
end)

-- Matchmaking loop for ranked
task.spawn(function()
	while true do
		task.wait(3)

		if not RankedMatch.InProgress and #RankedQueue >= 2 then
			local player1 = table.remove(RankedQueue, 1)
			local player2 = table.remove(RankedQueue, 1)

			if player1.Parent and player2.Parent then
				StartRankedMatch(player1, player2)
			else
				if player1.Parent then table.insert(RankedQueue, 1, player1) end
				if player2.Parent then table.insert(RankedQueue, 1, player2) end
			end
		end
	end
end)

-- Player management
Players.PlayerAdded:Connect(function(player)
	LoadElo(player)
end)

Players.PlayerRemoving:Connect(function(player)
	SaveElo(player)
	RankedElo[player] = nil

	for i, p in ipairs(RankedQueue) do
		if p == player then
			table.remove(RankedQueue, i)
			break
		end
	end

	if RankedMatch.Players[player] then
		RankedMatch.Players[player] = nil
		local alive = GetRankedAlivePlayers()
		if #alive <= 1 then
			EndRankedMatch(alive[1])
		end
	end
end)

print("[RankedManager] Sistema ranked cargado")
