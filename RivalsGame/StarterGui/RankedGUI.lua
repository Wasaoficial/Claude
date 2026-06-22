local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Events = ReplicatedStorage:WaitForChild("Events")
local RankedQueueEvent = Events:WaitForChild("RankedQueue")
local RankedMatchStartEvent = Events:WaitForChild("RankedMatchStart")
local RankedMatchEndEvent = Events:WaitForChild("RankedMatchEnd")
local RankedUpdateEvent = Events:WaitForChild("RankedUpdate")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RankedGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Botón RANKED
local rankedButton = Instance.new("TextButton")
rankedButton.Name = "RankedButton"
rankedButton.Size = UDim2.new(0, 120, 0, 40)
rankedButton.Position = UDim2.new(0, 15, 0, 65)
rankedButton.BackgroundColor3 = Color3.fromRGB(180, 50, 255)
rankedButton.Text = "RANKED"
rankedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
rankedButton.TextSize = 16
rankedButton.Font = Enum.Font.GothamBlack
rankedButton.Parent = screenGui

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = rankedButton

-- Panel de cola ranked
local queuePanel = Instance.new("Frame")
queuePanel.Name = "QueuePanel"
queuePanel.Size = UDim2.new(0, 350, 0, 250)
queuePanel.Position = UDim2.new(0.5, -175, 0.5, -125)
queuePanel.BackgroundColor3 = Color3.fromRGB(15, 10, 30)
queuePanel.BackgroundTransparency = 0.1
queuePanel.Visible = false
queuePanel.Parent = screenGui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 12)
panelCorner.Parent = queuePanel

local panelStroke = Instance.new("UIStroke")
panelStroke.Color = Color3.fromRGB(180, 50, 255)
panelStroke.Thickness = 2
panelStroke.Parent = queuePanel

local queueTitle = Instance.new("TextLabel")
queueTitle.Size = UDim2.new(1, 0, 0, 40)
queueTitle.Position = UDim2.new(0, 0, 0, 10)
queueTitle.BackgroundTransparency = 1
queueTitle.Text = "MODO RANKED"
queueTitle.TextColor3 = Color3.fromRGB(180, 50, 255)
queueTitle.TextSize = 24
queueTitle.Font = Enum.Font.GothamBlack
queueTitle.Parent = queuePanel

local eloLabel = Instance.new("TextLabel")
eloLabel.Name = "EloLabel"
eloLabel.Size = UDim2.new(1, 0, 0, 30)
eloLabel.Position = UDim2.new(0, 0, 0, 55)
eloLabel.BackgroundTransparency = 1
eloLabel.Text = "ELO: 1000 | Rango: Oro"
eloLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
eloLabel.TextSize = 16
eloLabel.Font = Enum.Font.GothamBold
eloLabel.Parent = queuePanel

local queueStatus = Instance.new("TextLabel")
queueStatus.Name = "QueueStatus"
queueStatus.Size = UDim2.new(1, 0, 0, 30)
queueStatus.Position = UDim2.new(0, 0, 0, 90)
queueStatus.BackgroundTransparency = 1
queueStatus.Text = "1v1 Competitivo"
queueStatus.TextColor3 = Color3.fromRGB(200, 200, 200)
queueStatus.TextSize = 14
queueStatus.Font = Enum.Font.Gotham
queueStatus.Parent = queuePanel

local searchingLabel = Instance.new("TextLabel")
searchingLabel.Name = "SearchingLabel"
searchingLabel.Size = UDim2.new(1, 0, 0, 25)
searchingLabel.Position = UDim2.new(0, 0, 0, 120)
searchingLabel.BackgroundTransparency = 1
searchingLabel.Text = ""
searchingLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
searchingLabel.TextSize = 13
searchingLabel.Font = Enum.Font.GothamMedium
searchingLabel.Visible = false
searchingLabel.Parent = queuePanel

local joinQueueBtn = Instance.new("TextButton")
joinQueueBtn.Name = "JoinQueue"
joinQueueBtn.Size = UDim2.new(0.7, 0, 0, 45)
joinQueueBtn.Position = UDim2.new(0.15, 0, 1, -70)
joinQueueBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 255)
joinQueueBtn.Text = "BUSCAR PARTIDA"
joinQueueBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
joinQueueBtn.TextSize = 16
joinQueueBtn.Font = Enum.Font.GothamBlack
joinQueueBtn.Parent = queuePanel

local joinCorner = Instance.new("UICorner")
joinCorner.CornerRadius = UDim.new(0, 10)
joinCorner.Parent = joinQueueBtn

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -40, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBlack
closeBtn.Parent = queuePanel

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 17)
closeBtnCorner.Parent = closeBtn

-- VS Screen
local vsScreen = Instance.new("Frame")
vsScreen.Name = "VSScreen"
vsScreen.Size = UDim2.new(1, 0, 1, 0)
vsScreen.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
vsScreen.BackgroundTransparency = 0.2
vsScreen.Visible = false
vsScreen.Parent = screenGui

local vsLabel = Instance.new("TextLabel")
vsLabel.Size = UDim2.new(1, 0, 0, 80)
vsLabel.Position = UDim2.new(0, 0, 0.3, 0)
vsLabel.BackgroundTransparency = 1
vsLabel.Text = "VS"
vsLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
vsLabel.TextSize = 72
vsLabel.Font = Enum.Font.GothamBlack
vsLabel.Parent = vsScreen

local playerNameLabel = Instance.new("TextLabel")
playerNameLabel.Size = UDim2.new(0.4, 0, 0, 40)
playerNameLabel.Position = UDim2.new(0.05, 0, 0.45, 0)
playerNameLabel.BackgroundTransparency = 1
playerNameLabel.Text = ""
playerNameLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
playerNameLabel.TextSize = 24
playerNameLabel.Font = Enum.Font.GothamBlack
playerNameLabel.Parent = vsScreen

local opponentNameLabel = Instance.new("TextLabel")
opponentNameLabel.Size = UDim2.new(0.4, 0, 0, 40)
opponentNameLabel.Position = UDim2.new(0.55, 0, 0.45, 0)
opponentNameLabel.BackgroundTransparency = 1
opponentNameLabel.Text = ""
opponentNameLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
opponentNameLabel.TextSize = 24
opponentNameLabel.Font = Enum.Font.GothamBlack
opponentNameLabel.Parent = vsScreen

local playerEloLabel = Instance.new("TextLabel")
playerEloLabel.Size = UDim2.new(0.4, 0, 0, 25)
playerEloLabel.Position = UDim2.new(0.05, 0, 0.52, 0)
playerEloLabel.BackgroundTransparency = 1
playerEloLabel.Text = ""
playerEloLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
playerEloLabel.TextSize = 16
playerEloLabel.Font = Enum.Font.GothamMedium
playerEloLabel.Parent = vsScreen

local opponentEloLabel = Instance.new("TextLabel")
opponentEloLabel.Size = UDim2.new(0.4, 0, 0, 25)
opponentEloLabel.Position = UDim2.new(0.55, 0, 0.52, 0)
opponentEloLabel.BackgroundTransparency = 1
opponentEloLabel.Text = ""
opponentEloLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
opponentEloLabel.TextSize = 16
opponentEloLabel.Font = Enum.Font.GothamMedium
opponentEloLabel.Parent = vsScreen

-- Ranked Result Screen
local rankedResult = Instance.new("Frame")
rankedResult.Name = "RankedResult"
rankedResult.Size = UDim2.new(1, 0, 1, 0)
rankedResult.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
rankedResult.BackgroundTransparency = 0.3
rankedResult.Visible = false
rankedResult.Parent = screenGui

local resultTitle = Instance.new("TextLabel")
resultTitle.Size = UDim2.new(1, 0, 0, 70)
resultTitle.Position = UDim2.new(0, 0, 0.25, 0)
resultTitle.BackgroundTransparency = 1
resultTitle.Text = ""
resultTitle.TextSize = 52
resultTitle.Font = Enum.Font.GothamBlack
resultTitle.Parent = rankedResult

local eloChangeLabel = Instance.new("TextLabel")
eloChangeLabel.Size = UDim2.new(1, 0, 0, 40)
eloChangeLabel.Position = UDim2.new(0, 0, 0.38, 0)
eloChangeLabel.BackgroundTransparency = 1
eloChangeLabel.Text = ""
eloChangeLabel.TextSize = 28
eloChangeLabel.Font = Enum.Font.GothamBold
eloChangeLabel.Parent = rankedResult

local newEloLabel = Instance.new("TextLabel")
newEloLabel.Size = UDim2.new(1, 0, 0, 30)
newEloLabel.Position = UDim2.new(0, 0, 0.45, 0)
newEloLabel.BackgroundTransparency = 1
newEloLabel.Text = ""
newEloLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
newEloLabel.TextSize = 20
newEloLabel.Font = Enum.Font.GothamMedium
newEloLabel.Parent = rankedResult

local tierLabel = Instance.new("TextLabel")
tierLabel.Size = UDim2.new(1, 0, 0, 35)
tierLabel.Position = UDim2.new(0, 0, 0.52, 0)
tierLabel.BackgroundTransparency = 1
tierLabel.Text = ""
tierLabel.TextSize = 24
tierLabel.Font = Enum.Font.GothamBlack
tierLabel.Parent = rankedResult

-- State
local inQueue = false
local searchTimer = 0

rankedButton.MouseButton1Click:Connect(function()
	queuePanel.Visible = not queuePanel.Visible
end)

closeBtn.MouseButton1Click:Connect(function()
	queuePanel.Visible = false
end)

joinQueueBtn.MouseButton1Click:Connect(function()
	if not inQueue then
		RankedQueueEvent:FireServer("join")
		inQueue = true
		joinQueueBtn.Text = "CANCELAR"
		joinQueueBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
		searchingLabel.Visible = true
		searchTimer = 0

		task.spawn(function()
			while inQueue do
				searchTimer = searchTimer + 1
				local mins = math.floor(searchTimer / 60)
				local secs = searchTimer % 60
				searchingLabel.Text = string.format("Buscando oponente... %d:%02d", mins, secs)
				task.wait(1)
			end
		end)
	else
		RankedQueueEvent:FireServer("leave")
		inQueue = false
		joinQueueBtn.Text = "BUSCAR PARTIDA"
		joinQueueBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 255)
		searchingLabel.Visible = false
	end
end)

RankedUpdateEvent.OnClientEvent:Connect(function(msgType, data)
	if msgType == "QueueJoined" then
		eloLabel.Text = string.format("ELO: %d | Rango: %s", data.Elo, data.Tier.Name)
		eloLabel.TextColor3 = data.Tier.Color
	elseif msgType == "QueueLeft" then
		inQueue = false
		joinQueueBtn.Text = "BUSCAR PARTIDA"
		joinQueueBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 255)
		searchingLabel.Visible = false
	end
end)

RankedMatchStartEvent.OnClientEvent:Connect(function(data)
	inQueue = false
	queuePanel.Visible = false
	searchingLabel.Visible = false
	joinQueueBtn.Text = "BUSCAR PARTIDA"
	joinQueueBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 255)

	-- Mostrar VS screen
	playerNameLabel.Text = player.Name
	opponentNameLabel.Text = data.Opponent
	playerEloLabel.Text = string.format("%s (%d)", data.YourTier.Name, data.YourElo)
	playerEloLabel.TextColor3 = data.YourTier.Color
	opponentEloLabel.Text = string.format("%s (%d)", data.OpponentTier.Name, data.OpponentElo)
	opponentEloLabel.TextColor3 = data.OpponentTier.Color

	vsScreen.Visible = true
	task.delay(4, function()
		vsScreen.Visible = false
	end)
end)

RankedMatchEndEvent.OnClientEvent:Connect(function(data)
	rankedResult.Visible = true

	if data.Result == "WIN" then
		resultTitle.Text = "VICTORIA"
		resultTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
		eloChangeLabel.Text = "+" .. data.EloChange .. " ELO"
		eloChangeLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
	else
		resultTitle.Text = "DERROTA"
		resultTitle.TextColor3 = Color3.fromRGB(200, 50, 50)
		eloChangeLabel.Text = data.EloChange .. " ELO"
		eloChangeLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
	end

	newEloLabel.Text = "Nuevo ELO: " .. data.NewElo
	tierLabel.Text = data.Tier.Name
	tierLabel.TextColor3 = data.Tier.Color

	task.delay(6, function()
		rankedResult.Visible = false
	end)
end)

print("[RankedGUI] Interfaz ranked cargada")
