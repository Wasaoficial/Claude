local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Events = ReplicatedStorage:WaitForChild("Events")
local DamageEvent = Events:WaitForChild("Damage")
local StockLostEvent = Events:WaitForChild("StockLost")
local MatchStartEvent = Events:WaitForChild("MatchStart")
local MatchEndEvent = Events:WaitForChild("MatchEnd")
local UpdateHUDEvent = Events:WaitForChild("UpdateHUD")
local SelectCharacterEvent = Events:WaitForChild("SelectCharacter")
local GameConfig = require(ReplicatedStorage.Modules.GameConfig)

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ============================================
-- CREAR HUD PRINCIPAL
-- ============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MainHUD"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- ============================================
-- PANEL DE DAÑO (abajo de la pantalla)
-- ============================================
local damagePanel = Instance.new("Frame")
damagePanel.Name = "DamagePanel"
damagePanel.Size = UDim2.new(1, 0, 0, 120)
damagePanel.Position = UDim2.new(0, 0, 1, -120)
damagePanel.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
damagePanel.BackgroundTransparency = 0.3
damagePanel.Visible = false
damagePanel.Parent = screenGui

local function createPlayerHUDSlot(index, totalPlayers)
	local width = 1 / totalPlayers
	local frame = Instance.new("Frame")
	frame.Name = "PlayerSlot_" .. index
	frame.Size = UDim2.new(width, -10, 1, -10)
	frame.Position = UDim2.new(width * (index - 1), 5, 0, 5)
	frame.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
	frame.BackgroundTransparency = 0.4
	frame.Parent = damagePanel

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = frame

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "PlayerName"
	nameLabel.Size = UDim2.new(1, 0, 0, 25)
	nameLabel.Position = UDim2.new(0, 0, 0, 5)
	nameLabel.BackgroundTransparency = 1
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.TextSize = 14
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.Text = ""
	nameLabel.Parent = frame

	local damageLabel = Instance.new("TextLabel")
	damageLabel.Name = "DamagePercent"
	damageLabel.Size = UDim2.new(1, 0, 0, 45)
	damageLabel.Position = UDim2.new(0, 0, 0, 28)
	damageLabel.BackgroundTransparency = 1
	damageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	damageLabel.TextSize = 36
	damageLabel.Font = Enum.Font.GothamBlack
	damageLabel.Text = "0%"
	damageLabel.Parent = frame

	local stocksLabel = Instance.new("TextLabel")
	stocksLabel.Name = "Stocks"
	stocksLabel.Size = UDim2.new(1, 0, 0, 20)
	stocksLabel.Position = UDim2.new(0, 0, 0, 75)
	stocksLabel.BackgroundTransparency = 1
	stocksLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	stocksLabel.TextSize = 16
	stocksLabel.Font = Enum.Font.GothamMedium
	stocksLabel.Text = ""
	stocksLabel.Parent = frame

	return frame
end

-- ============================================
-- TIMER
-- ============================================
local timerLabel = Instance.new("TextLabel")
timerLabel.Name = "Timer"
timerLabel.Size = UDim2.new(0, 120, 0, 50)
timerLabel.Position = UDim2.new(0.5, -60, 0, 10)
timerLabel.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
timerLabel.BackgroundTransparency = 0.3
timerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
timerLabel.TextSize = 28
timerLabel.Font = Enum.Font.GothamBlack
timerLabel.Text = "3:00"
timerLabel.Visible = false
timerLabel.Parent = screenGui

local timerCorner = Instance.new("UICorner")
timerCorner.CornerRadius = UDim.new(0, 10)
timerCorner.Parent = timerLabel

-- ============================================
-- PANTALLA DE SELECCIÓN DE PERSONAJE
-- ============================================
local charSelectScreen = Instance.new("Frame")
charSelectScreen.Name = "CharacterSelect"
charSelectScreen.Size = UDim2.new(1, 0, 1, 0)
charSelectScreen.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
charSelectScreen.BackgroundTransparency = 0.2
charSelectScreen.Visible = true
charSelectScreen.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 60)
title.Position = UDim2.new(0, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "RIVALS"
title.TextColor3 = Color3.fromRGB(255, 80, 80)
title.TextSize = 52
title.Font = Enum.Font.GothamBlack
title.Parent = charSelectScreen

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, 0, 0, 30)
subtitle.Position = UDim2.new(0, 0, 0, 90)
subtitle.BackgroundTransparency = 1
subtitle.Text = "SELECCIONÁ TU PERSONAJE"
subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
subtitle.TextSize = 18
subtitle.Font = Enum.Font.GothamMedium
subtitle.Parent = charSelectScreen

local charGrid = Instance.new("ScrollingFrame")
charGrid.Name = "CharGrid"
charGrid.Size = UDim2.new(0.9, 0, 0, 420)
charGrid.Position = UDim2.new(0.05, 0, 0, 140)
charGrid.BackgroundTransparency = 1
charGrid.ScrollBarThickness = 4
charGrid.ScrollingDirection = Enum.ScrollingDirection.Y
charGrid.AutomaticCanvasSize = Enum.AutomaticSize.Y
charGrid.CanvasSize = UDim2.new(0, 0, 0, 0)
charGrid.Parent = charSelectScreen

local gridLayout = Instance.new("UIGridLayout")
gridLayout.CellSize = UDim2.new(0, 130, 0, 180)
gridLayout.CellPadding = UDim2.new(0, 12, 0, 12)
gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
gridLayout.Parent = charGrid

local charColors = {
	Color3.fromRGB(255, 60, 30),   -- Blaze: rojo
	Color3.fromRGB(50, 150, 255),  -- Frost: azul
	Color3.fromRGB(80, 0, 120),    -- Shadow: morado
	Color3.fromRGB(180, 140, 50),  -- Titan: dorado
	Color3.fromRGB(255, 230, 0),   -- Volt: amarillo
	Color3.fromRGB(0, 180, 220),   -- Aqua: cyan
	Color3.fromRGB(80, 160, 50),   -- Gaia: verde
	Color3.fromRGB(200, 50, 200),  -- Nova: magenta
	Color3.fromRGB(60, 60, 80),    -- Phantom: gris oscuro
	Color3.fromRGB(150, 50, 30),   -- Rex: marrón
}

local selectedIndex = 1

for i, charData in ipairs(GameConfig.Characters) do
	local charButton = Instance.new("TextButton")
	charButton.Name = "Char_" .. charData.Name
	charButton.Size = UDim2.new(0, 130, 0, 180)
	charButton.BackgroundColor3 = charColors[i] or Color3.fromRGB(100, 100, 100)
	charButton.BackgroundTransparency = 0.3
	charButton.Text = ""
	charButton.Parent = charGrid

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = charButton

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(255, 255, 255)
	stroke.Thickness = i == 1 and 3 or 0
	stroke.Parent = charButton

	local nameL = Instance.new("TextLabel")
	nameL.Size = UDim2.new(1, 0, 0, 30)
	nameL.Position = UDim2.new(0, 0, 0, 10)
	nameL.BackgroundTransparency = 1
	nameL.Text = charData.Name
	nameL.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameL.TextSize = 20
	nameL.Font = Enum.Font.GothamBlack
	nameL.Parent = charButton

	local descL = Instance.new("TextLabel")
	descL.Size = UDim2.new(1, -10, 0, 50)
	descL.Position = UDim2.new(0, 5, 0, 45)
	descL.BackgroundTransparency = 1
	descL.Text = charData.Description
	descL.TextColor3 = Color3.fromRGB(220, 220, 220)
	descL.TextSize = 11
	descL.Font = Enum.Font.Gotham
	descL.TextWrapped = true
	descL.Parent = charButton

	local statsText = string.format("SPD: %d  JMP: %d", charData.Speed, charData.JumpPower)
	local statsL = Instance.new("TextLabel")
	statsL.Size = UDim2.new(1, -10, 0, 20)
	statsL.Position = UDim2.new(0, 5, 0, 100)
	statsL.BackgroundTransparency = 1
	statsL.Text = statsText
	statsL.TextColor3 = Color3.fromRGB(180, 180, 180)
	statsL.TextSize = 10
	statsL.Font = Enum.Font.GothamMedium
	statsL.Parent = charButton

	charButton.MouseButton1Click:Connect(function()
		selectedIndex = i
		SelectCharacterEvent:FireServer(i)

		for _, btn in ipairs(charGrid:GetChildren()) do
			if btn:IsA("TextButton") then
				local s = btn:FindFirstChildOfClass("UIStroke")
				if s then s.Thickness = 0 end
			end
		end
		stroke.Thickness = 3
	end)
end

-- Botón JUGAR
local playButton = Instance.new("TextButton")
playButton.Name = "PlayButton"
playButton.Size = UDim2.new(0, 220, 0, 55)
playButton.Position = UDim2.new(0.5, -110, 1, -120)
playButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
playButton.Text = "JUGAR"
playButton.TextColor3 = Color3.fromRGB(255, 255, 255)
playButton.TextSize = 28
playButton.Font = Enum.Font.GothamBlack
playButton.Parent = charSelectScreen

local playCorner = Instance.new("UICorner")
playCorner.CornerRadius = UDim.new(0, 12)
playCorner.Parent = playButton

-- Botón PRACTICA (jugar solo)
local practiceButton = Instance.new("TextButton")
practiceButton.Name = "PracticeButton"
practiceButton.Size = UDim2.new(0, 220, 0, 40)
practiceButton.Position = UDim2.new(0.5, -110, 1, -60)
practiceButton.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
practiceButton.Text = "PRACTICA (Solo)"
practiceButton.TextColor3 = Color3.fromRGB(200, 200, 200)
practiceButton.TextSize = 16
practiceButton.Font = Enum.Font.GothamBold
practiceButton.Parent = charSelectScreen

local practiceCorner = Instance.new("UICorner")
practiceCorner.CornerRadius = UDim.new(0, 10)
practiceCorner.Parent = practiceButton

-- Status label
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, 0, 0, 30)
statusLabel.Position = UDim2.new(0, 0, 1, -155)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.GothamMedium
statusLabel.Parent = charSelectScreen

local ReadyEvent = Events:WaitForChild("PlayerReady")

playButton.MouseButton1Click:Connect(function()
	ReadyEvent:FireServer("casual")
	statusLabel.Text = "Buscando partida... esperando jugadores"
	playButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
	playButton.Text = "BUSCANDO..."
end)

practiceButton.MouseButton1Click:Connect(function()
	ReadyEvent:FireServer("practice")
	statusLabel.Text = "Entrando a modo práctica..."
end)

-- ============================================
-- PANTALLA DE RESULTADO
-- ============================================
local resultScreen = Instance.new("Frame")
resultScreen.Name = "ResultScreen"
resultScreen.Size = UDim2.new(1, 0, 1, 0)
resultScreen.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
resultScreen.BackgroundTransparency = 0.4
resultScreen.Visible = false
resultScreen.Parent = screenGui

local resultLabel = Instance.new("TextLabel")
resultLabel.Name = "ResultText"
resultLabel.Size = UDim2.new(1, 0, 0, 80)
resultLabel.Position = UDim2.new(0, 0, 0.35, 0)
resultLabel.BackgroundTransparency = 1
resultLabel.Text = ""
resultLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
resultLabel.TextSize = 48
resultLabel.Font = Enum.Font.GothamBlack
resultLabel.Parent = resultScreen

-- ============================================
-- EVENTOS
-- ============================================

DamageEvent.OnClientEvent:Connect(function(damagedPlayer, damagePercent)
	-- Efecto visual de daño
	if damagedPlayer == player then
		local flash = Instance.new("Frame")
		flash.Size = UDim2.new(1, 0, 1, 0)
		flash.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
		flash.BackgroundTransparency = 0.7
		flash.Parent = screenGui

		TweenService:Create(flash, TweenInfo.new(0.3), { BackgroundTransparency = 1 }):Play()
		task.delay(0.3, function() flash:Destroy() end)
	end
end)

UpdateHUDEvent.OnClientEvent:Connect(function(playersData)
	-- Actualizar HUD
	for _, child in ipairs(damagePanel:GetChildren()) do
		if child:IsA("Frame") then child:Destroy() end
	end

	local index = 0
	local total = 0
	for _ in pairs(playersData) do total = total + 1 end

	for p, data in pairs(playersData) do
		index = index + 1
		local slot = createPlayerHUDSlot(index, total)

		local nameL = slot:FindFirstChild("PlayerName")
		local damageL = slot:FindFirstChild("DamagePercent")
		local stocksL = slot:FindFirstChild("Stocks")

		if nameL then nameL.Text = p.Name end
		if damageL then
			damageL.Text = math.floor(data.DamagePercent) .. "%"
			local r = math.min(255, data.DamagePercent * 2)
			damageL.TextColor3 = Color3.fromRGB(255, 255 - r, 255 - r)
		end
		if stocksL then
			local stockIcons = string.rep("● ", data.Stocks) .. string.rep("○ ", GameConfig.MAX_STOCKS - data.Stocks)
			stocksL.Text = stockIcons
		end
	end
end)

MatchStartEvent.OnClientEvent:Connect(function()
	charSelectScreen.Visible = false
	damagePanel.Visible = true
	timerLabel.Visible = true
	resultScreen.Visible = false
end)

MatchEndEvent.OnClientEvent:Connect(function(winnerName)
	damagePanel.Visible = false
	timerLabel.Visible = false
	resultScreen.Visible = true

	if winnerName == player.Name then
		resultLabel.Text = "¡GANASTE!"
		resultLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
	else
		resultLabel.Text = winnerName .. " GANA"
		resultLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	end

	task.delay(5, function()
		resultScreen.Visible = false
		charSelectScreen.Visible = true
		playButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
		playButton.Text = "JUGAR"
		statusLabel.Text = ""
	end)
end)

print("[MainHUD] HUD cargado")
