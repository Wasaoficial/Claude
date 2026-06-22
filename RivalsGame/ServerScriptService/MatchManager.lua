local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GameConfig = require(ReplicatedStorage.Modules.GameConfig)
local CombatSystem = require(ReplicatedStorage.Modules.CombatSystem)
local ComboSystem = require(ReplicatedStorage.Modules.ComboSystem)

-- RemoteEvents
local Events = ReplicatedStorage:WaitForChild("Events")
local AttackEvent = Events:WaitForChild("Attack")
local DamageEvent = Events:WaitForChild("Damage")
local StockLostEvent = Events:WaitForChild("StockLost")
local MatchStartEvent = Events:WaitForChild("MatchStart")
local MatchEndEvent = Events:WaitForChild("MatchEnd")
local SelectCharacterEvent = Events:WaitForChild("SelectCharacter")
local UpdateHUDEvent = Events:WaitForChild("UpdateHUD")
local ComboEvent = Events:WaitForChild("ComboUpdate")

-- Estado del juego
local MatchState = {
	InProgress = false,
	Players = {}, -- { [player] = { Character, Stocks, DamagePercent, SelectedCharacter, Kills } }
	Mode = "FFA", -- "FFA" o "1v1"
	Arena = nil,
	Timer = 0,
}

local PlayerSelections = {}
local Cooldowns = {}
local LobbyPlayers = {}

-- Lobby
local function AddToLobby(player)
	LobbyPlayers[player] = true
end

local function RemoveFromLobby(player)
	LobbyPlayers[player] = nil
end

local function GetLobbyCount()
	local count = 0
	for _ in pairs(LobbyPlayers) do count = count + 1 end
	return count
end

-- Selección de personaje
SelectCharacterEvent.OnServerEvent:Connect(function(player, characterIndex)
	if characterIndex >= 1 and characterIndex <= #GameConfig.Characters then
		PlayerSelections[player] = characterIndex
	end
end)

-- Sistema de combate
local function ProcessAttack(attacker, attackType)
	local attackerData = MatchState.Players[attacker]
	if not attackerData then return end

	local charConfig = GameConfig.Characters[attackerData.SelectedCharacter]
	local attackData = charConfig.Attacks[attackType]
	if not attackData then return end

	-- Cooldown check
	local cooldownKey = attacker.UserId .. "_" .. attackType
	if Cooldowns[cooldownKey] and tick() - Cooldowns[cooldownKey] < attackData.Cooldown then
		return
	end
	Cooldowns[cooldownKey] = tick()

	local attackerChar = attacker.Character
	if not attackerChar or not attackerChar:FindFirstChild("HumanoidRootPart") then return end

	for player, data in pairs(MatchState.Players) do
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

					for p in pairs(MatchState.Players) do
						UpdateHUDEvent:FireClient(p, MatchState.Players)
					end
				end
			end
		end
	end
end

AttackEvent.OnServerEvent:Connect(function(player, attackType)
	if MatchState.InProgress then
		ProcessAttack(player, attackType)
	end
end)

-- Blast zone check
local function CheckAllBlastZones()
	for player, data in pairs(MatchState.Players) do
		local char = player.Character
		if char and CombatSystem.CheckBlastZone(char) then
			data.Stocks = data.Stocks - 1
			data.DamagePercent = 0
			ComboSystem.ResetAllForPlayer(player.UserId)

			StockLostEvent:FireAllClients(player, data.Stocks)

			if data.Stocks <= 0 then
				-- Eliminado
				for p in pairs(MatchState.Players) do
					UpdateHUDEvent:FireClient(p, MatchState.Players)
				end
			else
				-- Respawn
				task.delay(GameConfig.RESPAWN_TIME, function()
					if player.Character then
						local arena = GameConfig.Arenas[MatchState.Arena or 1]
						local spawnIndex = math.random(1, #arena.SpawnPoints)
						player.Character:MoveTo(arena.SpawnPoints[spawnIndex])
					end
				end)
			end

			for p in pairs(MatchState.Players) do
				UpdateHUDEvent:FireClient(p, MatchState.Players)
			end
		end
	end
end

-- Match logic
local function GetAlivePlayers()
	local alive = {}
	for player, data in pairs(MatchState.Players) do
		if data.Stocks > 0 then
			table.insert(alive, player)
		end
	end
	return alive
end

local function EndMatch(winner)
	MatchState.InProgress = false
	MatchEndEvent:FireAllClients(winner and winner.Name or "Nadie")

	task.wait(5)

	for player in pairs(MatchState.Players) do
		AddToLobby(player)
	end
	MatchState.Players = {}
end

local function ApplyCharacterStats(player, charIndex)
	local char = player.Character
	if not char then return end

	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end

	local config = GameConfig.Characters[charIndex]
	humanoid.WalkSpeed = config.Speed
	humanoid.JumpPower = config.JumpPower
end

local function StartMatch(players, mode)
	MatchState.InProgress = true
	MatchState.Mode = mode
	MatchState.Arena = math.random(1, #GameConfig.Arenas)
	MatchState.Timer = GameConfig.ROUND_TIME
	MatchState.Players = {}

	local arena = GameConfig.Arenas[MatchState.Arena]

	for i, player in ipairs(players) do
		local charIndex = PlayerSelections[player] or 1
		MatchState.Players[player] = {
			SelectedCharacter = charIndex,
			Stocks = GameConfig.MAX_STOCKS,
			DamagePercent = 0,
			Kills = 0,
		}

		RemoveFromLobby(player)

		if player.Character then
			local spawnPos = arena.SpawnPoints[((i - 1) % #arena.SpawnPoints) + 1]
			player.Character:MoveTo(spawnPos)
			ApplyCharacterStats(player, charIndex)
		end
	end

	MatchStartEvent:FireAllClients(MatchState.Mode, GameConfig.Characters, MatchState.Players)

	-- Game loop
	task.spawn(function()
		while MatchState.InProgress do
			task.wait(0.1)
			CheckAllBlastZones()
			ComboSystem.CleanupExpired()

			local alive = GetAlivePlayers()
			if #alive <= 1 then
				EndMatch(alive[1])
				return
			end

			MatchState.Timer = MatchState.Timer - 0.1
			if MatchState.Timer <= 0 then
				-- Gana el que tiene más stocks / menos daño
				local best = nil
				local bestScore = -1
				for player, data in pairs(MatchState.Players) do
					if data.Stocks > 0 then
						local score = data.Stocks * 1000 - data.DamagePercent
						if score > bestScore then
							bestScore = score
							best = player
						end
					end
				end
				EndMatch(best)
				return
			end
		end
	end)
end

-- Matchmaking loop
task.spawn(function()
	while true do
		task.wait(3)

		if not MatchState.InProgress then
			local lobbyList = {}
			for player in pairs(LobbyPlayers) do
				if player.Parent then
					table.insert(lobbyList, player)
				end
			end

			if #lobbyList >= 2 then
				-- 1v1 si hay 2-3, FFA si hay 4+
				local mode = #lobbyList >= 4 and "FFA" or "1v1"
				local count = math.min(#lobbyList, GameConfig.MAX_PLAYERS_PER_MATCH)
				local matchPlayers = {}
				for i = 1, count do
					table.insert(matchPlayers, lobbyList[i])
				end
				StartMatch(matchPlayers, mode)
			end
		end
	end
end)

-- Player join/leave
Players.PlayerAdded:Connect(function(player)
	AddToLobby(player)
	PlayerSelections[player] = 1
end)

Players.PlayerRemoving:Connect(function(player)
	RemoveFromLobby(player)
	PlayerSelections[player] = nil
	if MatchState.Players[player] then
		MatchState.Players[player] = nil
	end
end)

print("[MatchManager] Sistema de partidas cargado")
