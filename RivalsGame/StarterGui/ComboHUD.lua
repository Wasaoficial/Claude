local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Events = ReplicatedStorage:WaitForChild("Events")
local ComboEvent = Events:WaitForChild("ComboUpdate")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ComboHUD"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Combo counter (when you DO combos)
local comboFrame = Instance.new("Frame")
comboFrame.Name = "ComboFrame"
comboFrame.Size = UDim2.new(0, 200, 0, 80)
comboFrame.Position = UDim2.new(0.5, -100, 0.15, 0)
comboFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
comboFrame.BackgroundTransparency = 0.6
comboFrame.Visible = false
comboFrame.Parent = screenGui

local comboCorner = Instance.new("UICorner")
comboCorner.CornerRadius = UDim.new(0, 10)
comboCorner.Parent = comboFrame

local comboStroke = Instance.new("UIStroke")
comboStroke.Thickness = 2
comboStroke.Parent = comboFrame

local comboHitsLabel = Instance.new("TextLabel")
comboHitsLabel.Name = "Hits"
comboHitsLabel.Size = UDim2.new(1, 0, 0, 45)
comboHitsLabel.Position = UDim2.new(0, 0, 0, 5)
comboHitsLabel.BackgroundTransparency = 1
comboHitsLabel.Text = ""
comboHitsLabel.TextSize = 36
comboHitsLabel.Font = Enum.Font.GothamBlack
comboHitsLabel.Parent = comboFrame

local comboDamageLabel = Instance.new("TextLabel")
comboDamageLabel.Name = "Damage"
comboDamageLabel.Size = UDim2.new(1, 0, 0, 20)
comboDamageLabel.Position = UDim2.new(0, 0, 0, 50)
comboDamageLabel.BackgroundTransparency = 1
comboDamageLabel.Text = ""
comboDamageLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
comboDamageLabel.TextSize = 14
comboDamageLabel.Font = Enum.Font.GothamMedium
comboDamageLabel.Parent = comboFrame

local hideComboThread = nil

local comboColors = {
	Color3.fromRGB(255, 255, 255),  -- 1 hit
	Color3.fromRGB(255, 255, 100),  -- 2
	Color3.fromRGB(255, 200, 50),   -- 3
	Color3.fromRGB(255, 150, 0),    -- 4
	Color3.fromRGB(255, 80, 0),     -- 5
	Color3.fromRGB(255, 30, 30),    -- 6
	Color3.fromRGB(255, 0, 100),    -- 7
	Color3.fromRGB(200, 0, 255),    -- 8
	Color3.fromRGB(100, 0, 255),    -- 9
	Color3.fromRGB(255, 0, 255),    -- 10+
}

local function getComboColor(hits)
	return comboColors[math.min(hits, #comboColors)]
end

local function getComboText(hits)
	if hits >= 10 then return "LEGENDARIO"
	elseif hits >= 7 then return "BRUTAL"
	elseif hits >= 5 then return "INCREIBLE"
	elseif hits >= 3 then return "COMBO"
	else return "" end
end

-- Received combo text (when YOU get comboed)
local receivedFrame = Instance.new("Frame")
receivedFrame.Name = "ReceivedCombo"
receivedFrame.Size = UDim2.new(0, 160, 0, 40)
receivedFrame.Position = UDim2.new(0.5, -80, 0.7, 0)
receivedFrame.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
receivedFrame.BackgroundTransparency = 0.5
receivedFrame.Visible = false
receivedFrame.Parent = screenGui

local recCorner = Instance.new("UICorner")
recCorner.CornerRadius = UDim.new(0, 8)
recCorner.Parent = receivedFrame

local receivedLabel = Instance.new("TextLabel")
receivedLabel.Size = UDim2.new(1, 0, 1, 0)
receivedLabel.BackgroundTransparency = 1
receivedLabel.Text = ""
receivedLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
receivedLabel.TextSize = 18
receivedLabel.Font = Enum.Font.GothamBold
receivedLabel.Parent = receivedFrame

ComboEvent.OnClientEvent:Connect(function(attacker, victim, hits, damage)
	if hits < 2 then return end

	if attacker == player then
		-- You're doing the combo
		local color = getComboColor(hits)
		local text = getComboText(hits)

		comboHitsLabel.Text = hits .. " HITS!"
		comboHitsLabel.TextColor3 = color
		comboDamageLabel.Text = string.format("%.1f daño | %s", damage, text)
		comboStroke.Color = color
		comboFrame.Visible = true

		-- Scale animation
		comboFrame.Size = UDim2.new(0, 180, 0, 70)
		TweenService:Create(comboFrame, TweenInfo.new(0.15, Enum.EasingStyle.Back), {
			Size = UDim2.new(0, 200, 0, 80)
		}):Play()

		if hideComboThread then
			task.cancel(hideComboThread)
		end
		hideComboThread = task.delay(1.5, function()
			TweenService:Create(comboFrame, TweenInfo.new(0.3), {
				BackgroundTransparency = 1
			}):Play()
			task.wait(0.3)
			comboFrame.Visible = false
			comboFrame.BackgroundTransparency = 0.6
		end)

	elseif victim == player then
		-- You're getting comboed
		receivedLabel.Text = hits .. " HIT COMBO!"
		receivedFrame.Visible = true

		task.delay(1.2, function()
			receivedFrame.Visible = false
		end)
	end
end)

print("[ComboHUD] HUD de combos cargado")
