local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

local PlayerDataStore = DataStoreService:GetDataStore("PlayerData_v1")

local DataManager = {}
local PlayerData = {}

local DEFAULT_DATA = {
	Coins = 100,
	Wins = 0,
	Losses = 0,
	TotalKills = 0,
	GamesPlayed = 0,
	UnlockedCharacters = {1, 2}, -- Blaze y Frost gratis
	UnlockedSkins = {},
	EquippedSkin = {},
	Level = 1,
	XP = 0,
	XPToNextLevel = 100,
}

function DataManager.LoadData(player)
	local key = "Player_" .. player.UserId
	local success, data = pcall(function()
		return PlayerDataStore:GetAsync(key)
	end)

	if success and data then
		for k, v in pairs(DEFAULT_DATA) do
			if data[k] == nil then
				data[k] = v
			end
		end
		PlayerData[player] = data
	else
		PlayerData[player] = table.clone(DEFAULT_DATA)
	end

	print("[DataManager] Datos cargados para " .. player.Name)
end

function DataManager.SaveData(player)
	local data = PlayerData[player]
	if not data then return end

	local key = "Player_" .. player.UserId
	local success, err = pcall(function()
		PlayerDataStore:SetAsync(key, data)
	end)

	if not success then
		warn("[DataManager] Error guardando datos de " .. player.Name .. ": " .. tostring(err))
	end
end

function DataManager.GetData(player)
	return PlayerData[player]
end

function DataManager.AddCoins(player, amount)
	local data = PlayerData[player]
	if data then
		data.Coins = data.Coins + amount
	end
end

function DataManager.AddXP(player, amount)
	local data = PlayerData[player]
	if not data then return end

	data.XP = data.XP + amount
	while data.XP >= data.XPToNextLevel do
		data.XP = data.XP - data.XPToNextLevel
		data.Level = data.Level + 1
		data.XPToNextLevel = math.floor(data.XPToNextLevel * 1.3)
		DataManager.AddCoins(player, 50)
	end
end

function DataManager.UnlockCharacter(player, charIndex)
	local data = PlayerData[player]
	if not data then return false end

	if table.find(data.UnlockedCharacters, charIndex) then
		return false
	end

	table.insert(data.UnlockedCharacters, charIndex)
	return true
end

function DataManager.RecordWin(player)
	local data = PlayerData[player]
	if not data then return end
	data.Wins = data.Wins + 1
	data.GamesPlayed = data.GamesPlayed + 1
	DataManager.AddCoins(player, 100)
	DataManager.AddXP(player, 50)
end

function DataManager.RecordLoss(player)
	local data = PlayerData[player]
	if not data then return end
	data.Losses = data.Losses + 1
	data.GamesPlayed = data.GamesPlayed + 1
	DataManager.AddCoins(player, 25)
	DataManager.AddXP(player, 20)
end

-- Auto save cada 60 segundos
task.spawn(function()
	while true do
		task.wait(60)
		for player in pairs(PlayerData) do
			if player.Parent then
				DataManager.SaveData(player)
			end
		end
	end
end)

Players.PlayerAdded:Connect(function(player)
	DataManager.LoadData(player)
end)

Players.PlayerRemoving:Connect(function(player)
	DataManager.SaveData(player)
	PlayerData[player] = nil
end)

game:BindToClose(function()
	for player in pairs(PlayerData) do
		DataManager.SaveData(player)
	end
end)

print("[DataManager] Sistema de datos cargado")

return DataManager
