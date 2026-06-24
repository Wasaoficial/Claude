local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Events = ReplicatedStorage:WaitForChild("Events")
local AttackEvent = Events:WaitForChild("Attack")

local player = Players.LocalPlayer
local isInMatch = false
local canAttack = true

-- Controles:
-- Click izquierdo / M = Light Attack
-- Click derecho / N = Heavy Attack
-- Q = Special Up
-- E = Special Side
-- R = Special Down
-- Espacio (en aire) = Aerial Attack

local function isInAir()
	local char = player.Character
	if not char then return false end
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if not humanoid then return false end
	return humanoid:GetState() == Enum.HumanoidStateType.Freefall
		or humanoid:GetState() == Enum.HumanoidStateType.Jumping
end

local function doAttack(attackType)
	if not canAttack then return end
	if not isInMatch then return end

	canAttack = false
	AttackEvent:FireServer(attackType)

	task.delay(0.15, function()
		canAttack = true
	end)
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		if isInAir() then
			doAttack("AerialAttack")
		else
			doAttack("LightAttack")
		end
	elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
		doAttack("HeavyAttack")
	elseif input.KeyCode == Enum.KeyCode.Q then
		doAttack("SpecialUp")
	elseif input.KeyCode == Enum.KeyCode.E then
		doAttack("SpecialSide")
	elseif input.KeyCode == Enum.KeyCode.R then
		doAttack("SpecialDown")
	elseif input.KeyCode == Enum.KeyCode.M then
		doAttack("LightAttack")
	elseif input.KeyCode == Enum.KeyCode.N then
		doAttack("HeavyAttack")
	end
end)

-- Touch controls para móvil
local function createMobileButton(name, position, attackType)
	local screenGui = player:WaitForChild("PlayerGui"):FindFirstChild("MobileControls")
	if not screenGui then
		screenGui = Instance.new("ScreenGui")
		screenGui.Name = "MobileControls"
		screenGui.Parent = player:WaitForChild("PlayerGui")
	end

	local button = Instance.new("TextButton")
	button.Name = name
	button.Text = name
	button.Size = UDim2.new(0, 70, 0, 70)
	button.Position = position
	button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	button.BackgroundTransparency = 0.3
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.TextSize = 12
	button.Font = Enum.Font.GothamBold
	button.Parent = screenGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 35)
	corner.Parent = button

	button.MouseButton1Click:Connect(function()
		doAttack(attackType)
	end)
end

if UserInputService.TouchEnabled then
	createMobileButton("Light", UDim2.new(1, -160, 1, -180), "LightAttack")
	createMobileButton("Heavy", UDim2.new(1, -80, 1, -180), "HeavyAttack")
	createMobileButton("Up", UDim2.new(1, -120, 1, -260), "SpecialUp")
	createMobileButton("Side", UDim2.new(1, -80, 1, -100), "SpecialSide")
	createMobileButton("Down", UDim2.new(1, -160, 1, -100), "SpecialDown")
end

-- Listen for match state
local MatchStartEvent = Events:WaitForChild("MatchStart")
local MatchEndEvent = Events:WaitForChild("MatchEnd")

MatchStartEvent.OnClientEvent:Connect(function()
	isInMatch = true
end)

MatchEndEvent.OnClientEvent:Connect(function()
	isInMatch = false
end)

print("[CombatClient] Sistema de combate del cliente cargado")
