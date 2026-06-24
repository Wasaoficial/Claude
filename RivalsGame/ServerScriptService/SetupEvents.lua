local ReplicatedStorage = game:GetService("ReplicatedStorage")

local eventsFolder = Instance.new("Folder")
eventsFolder.Name = "Events"
eventsFolder.Parent = ReplicatedStorage

local eventNames = {
	"Attack",
	"Damage",
	"StockLost",
	"MatchStart",
	"MatchEnd",
	"SelectCharacter",
	"UpdateHUD",
	"BuyCharacter",
	"ShopData",
	"RequestShop",
	"ComboUpdate",
	"RankedQueue",
	"RankedMatchStart",
	"RankedMatchEnd",
	"RankedUpdate",
	"PlayerReady",
}

for _, name in ipairs(eventNames) do
	local event = Instance.new("RemoteEvent")
	event.Name = name
	event.Parent = eventsFolder
end

print("[SetupEvents] " .. #eventNames .. " RemoteEvents creados")
