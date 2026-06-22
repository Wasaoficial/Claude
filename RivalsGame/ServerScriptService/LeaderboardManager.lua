local Players = game:GetService("Players")
local DataManager = require(script.Parent.DataManager)

local function SetupLeaderboard(player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local wins = Instance.new("IntValue")
	wins.Name = "Wins"
	wins.Parent = leaderstats

	local kills = Instance.new("IntValue")
	kills.Name = "Kills"
	kills.Parent = leaderstats

	local level = Instance.new("IntValue")
	level.Name = "Level"
	level.Parent = leaderstats

	-- Actualizar con datos guardados
	task.spawn(function()
		task.wait(2)
		local data = DataManager.GetData(player)
		if data then
			wins.Value = data.Wins
			kills.Value = data.TotalKills
			level.Value = data.Level
		end
	end)
end

Players.PlayerAdded:Connect(function(player)
	SetupLeaderboard(player)
end)

-- Actualizar periodicamente
task.spawn(function()
	while true do
		task.wait(10)
		for _, player in ipairs(Players:GetPlayers()) do
			local data = DataManager.GetData(player)
			local leaderstats = player:FindFirstChild("leaderstats")
			if data and leaderstats then
				leaderstats.Wins.Value = data.Wins
				leaderstats.Kills.Value = data.TotalKills
				leaderstats.Level.Value = data.Level
			end
		end
	end
end)

print("[LeaderboardManager] Leaderboard cargado")
