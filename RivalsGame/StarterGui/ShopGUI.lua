local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Events = ReplicatedStorage:WaitForChild("Events")
local BuyCharacterEvent = Events:WaitForChild("BuyCharacter")
local ShopDataEvent = Events:WaitForChild("ShopData")
local RequestShopEvent = Events:WaitForChild("RequestShop")
local GameConfig = require(ReplicatedStorage.Modules.GameConfig)

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ShopGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Botón para abrir tienda
local shopButton = Instance.new("TextButton")
shopButton.Name = "OpenShop"
shopButton.Size = UDim2.new(0, 100, 0, 40)
shopButton.Position = UDim2.new(0, 15, 0, 15)
shopButton.BackgroundColor3 = Color3.fromRGB(255, 180, 0)
shopButton.Text = "TIENDA"
shopButton.TextColor3 = Color3.fromRGB(0, 0, 0)
shopButton.TextSize = 16
shopButton.Font = Enum.Font.GothamBlack
shopButton.Parent = screenGui

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = shopButton

-- Panel de tienda
local shopPanel = Instance.new("Frame")
shopPanel.Name = "ShopPanel"
shopPanel.Size = UDim2.new(0.6, 0, 0.7, 0)
shopPanel.Position = UDim2.new(0.2, 0, 0.15, 0)
shopPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
shopPanel.BackgroundTransparency = 0.1
shopPanel.Visible = false
shopPanel.Parent = screenGui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 12)
panelCorner.Parent = shopPanel

local shopTitle = Instance.new("TextLabel")
shopTitle.Size = UDim2.new(1, 0, 0, 50)
shopTitle.BackgroundTransparency = 1
shopTitle.Text = "TIENDA DE PERSONAJES"
shopTitle.TextColor3 = Color3.fromRGB(255, 200, 50)
shopTitle.TextSize = 24
shopTitle.Font = Enum.Font.GothamBlack
shopTitle.Parent = shopPanel

local coinsLabel = Instance.new("TextLabel")
coinsLabel.Name = "CoinsLabel"
coinsLabel.Size = UDim2.new(0, 200, 0, 30)
coinsLabel.Position = UDim2.new(1, -210, 0, 10)
coinsLabel.BackgroundTransparency = 1
coinsLabel.Text = "Monedas: 0"
coinsLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
coinsLabel.TextSize = 16
coinsLabel.Font = Enum.Font.GothamBold
coinsLabel.TextXAlignment = Enum.TextXAlignment.Right
coinsLabel.Parent = shopPanel

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -45, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBlack
closeBtn.Parent = shopPanel

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 20)
closeBtnCorner.Parent = closeBtn

local itemsFrame = Instance.new("ScrollingFrame")
itemsFrame.Name = "Items"
itemsFrame.Size = UDim2.new(1, -20, 1, -70)
itemsFrame.Position = UDim2.new(0, 10, 0, 60)
itemsFrame.BackgroundTransparency = 1
itemsFrame.ScrollBarThickness = 4
itemsFrame.Parent = shopPanel

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 10)
listLayout.FillDirection = Enum.FillDirection.Horizontal
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.Parent = itemsFrame

local charColors = {
	Color3.fromRGB(255, 60, 30),
	Color3.fromRGB(50, 150, 255),
	Color3.fromRGB(80, 0, 120),
	Color3.fromRGB(180, 140, 50),
	Color3.fromRGB(255, 230, 0),
}

local function populateShop(shopData)
	for _, child in ipairs(itemsFrame:GetChildren()) do
		if child:IsA("Frame") then child:Destroy() end
	end

	coinsLabel.Text = "Monedas: " .. tostring(shopData.Coins)

	for _, item in ipairs(shopData.Items.Characters) do
		local charData = GameConfig.Characters[item.Index]
		local owned = table.find(shopData.Unlocked, item.Index) ~= nil

		local card = Instance.new("Frame")
		card.Size = UDim2.new(0, 160, 0, 220)
		card.BackgroundColor3 = charColors[item.Index] or Color3.fromRGB(60, 60, 60)
		card.BackgroundTransparency = 0.4
		card.Parent = itemsFrame

		local cardCorner = Instance.new("UICorner")
		cardCorner.CornerRadius = UDim.new(0, 10)
		cardCorner.Parent = card

		local nameL = Instance.new("TextLabel")
		nameL.Size = UDim2.new(1, 0, 0, 30)
		nameL.Position = UDim2.new(0, 0, 0, 10)
		nameL.BackgroundTransparency = 1
		nameL.Text = charData.Name
		nameL.TextColor3 = Color3.fromRGB(255, 255, 255)
		nameL.TextSize = 18
		nameL.Font = Enum.Font.GothamBlack
		nameL.Parent = card

		local descL = Instance.new("TextLabel")
		descL.Size = UDim2.new(1, -10, 0, 60)
		descL.Position = UDim2.new(0, 5, 0, 45)
		descL.BackgroundTransparency = 1
		descL.Text = charData.Description
		descL.TextColor3 = Color3.fromRGB(220, 220, 220)
		descL.TextSize = 11
		descL.Font = Enum.Font.Gotham
		descL.TextWrapped = true
		descL.Parent = card

		local buyBtn = Instance.new("TextButton")
		buyBtn.Size = UDim2.new(0.8, 0, 0, 40)
		buyBtn.Position = UDim2.new(0.1, 0, 1, -55)
		buyBtn.Font = Enum.Font.GothamBold
		buyBtn.TextSize = 14
		buyBtn.Parent = card

		local buyCorner = Instance.new("UICorner")
		buyCorner.CornerRadius = UDim.new(0, 8)
		buyCorner.Parent = buyBtn

		if owned then
			buyBtn.Text = "DESBLOQUEADO"
			buyBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
			buyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		else
			buyBtn.Text = item.Price .. " monedas"
			buyBtn.BackgroundColor3 = Color3.fromRGB(255, 180, 0)
			buyBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
			buyBtn.MouseButton1Click:Connect(function()
				BuyCharacterEvent:FireServer(item.Index)
			end)
		end
	end
end

-- Notificación
local notification = Instance.new("TextLabel")
notification.Name = "Notification"
notification.Size = UDim2.new(0, 300, 0, 40)
notification.Position = UDim2.new(0.5, -150, 0, 80)
notification.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
notification.BackgroundTransparency = 0.2
notification.TextColor3 = Color3.fromRGB(255, 255, 255)
notification.TextSize = 14
notification.Font = Enum.Font.GothamMedium
notification.Text = ""
notification.Visible = false
notification.Parent = screenGui

local notifCorner = Instance.new("UICorner")
notifCorner.CornerRadius = UDim.new(0, 8)
notifCorner.Parent = notification

ShopDataEvent.OnClientEvent:Connect(function(msgType, data)
	if msgType == "ShopData" then
		populateShop(data)
	elseif msgType == "Success" or msgType == "Error" then
		notification.Text = data
		notification.TextColor3 = msgType == "Success" and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 80, 80)
		notification.Visible = true
		task.delay(3, function()
			notification.Visible = false
		end)
		if msgType == "Success" then
			RequestShopEvent:FireServer()
		end
	end
end)

shopButton.MouseButton1Click:Connect(function()
	shopPanel.Visible = not shopPanel.Visible
	if shopPanel.Visible then
		RequestShopEvent:FireServer()
	end
end)

closeBtn.MouseButton1Click:Connect(function()
	shopPanel.Visible = false
end)

print("[ShopGUI] Tienda cargada")
