local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GameConfig = require(ReplicatedStorage.Modules.GameConfig)
local DataManager = require(script.Parent.DataManager)

local Events = ReplicatedStorage:WaitForChild("Events")
local BuyCharacterEvent = Events:WaitForChild("BuyCharacter")
local ShopDataEvent = Events:WaitForChild("ShopData")

local ShopItems = {
	Characters = {
		{ Index = 3, Name = "Shadow", Price = 500 },
		{ Index = 4, Name = "Titan", Price = 750 },
		{ Index = 5, Name = "Volt", Price = 600 },
		{ Index = 6, Name = "Aqua", Price = 800 },
		{ Index = 7, Name = "Gaia", Price = 900 },
		{ Index = 8, Name = "Nova", Price = 1000 },
		{ Index = 9, Name = "Phantom", Price = 1200 },
		{ Index = 10, Name = "Rex", Price = 1500 },
	},
}

BuyCharacterEvent.OnServerEvent:Connect(function(player, charIndex)
	local data = DataManager.GetData(player)
	if not data then return end

	if table.find(data.UnlockedCharacters, charIndex) then
		ShopDataEvent:FireClient(player, "Error", "Ya tenés este personaje")
		return
	end

	local shopItem = nil
	for _, item in ipairs(ShopItems.Characters) do
		if item.Index == charIndex then
			shopItem = item
			break
		end
	end

	if not shopItem then
		ShopDataEvent:FireClient(player, "Error", "Personaje no encontrado")
		return
	end

	if data.Coins < shopItem.Price then
		ShopDataEvent:FireClient(player, "Error", "No tenés suficientes monedas")
		return
	end

	data.Coins = data.Coins - shopItem.Price
	DataManager.UnlockCharacter(player, charIndex)
	DataManager.SaveData(player)

	ShopDataEvent:FireClient(player, "Success", "Compraste a " .. shopItem.Name)
end)

-- Enviar datos de tienda cuando el jugador lo pida
local RequestShopEvent = Events:WaitForChild("RequestShop")
RequestShopEvent.OnServerEvent:Connect(function(player)
	local data = DataManager.GetData(player)
	if data then
		ShopDataEvent:FireClient(player, "ShopData", {
			Items = ShopItems,
			Coins = data.Coins,
			Unlocked = data.UnlockedCharacters,
		})
	end
end)

print("[ShopManager] Sistema de tienda cargado")
