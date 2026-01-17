local InventoryManager = {}

export type InventoryClass = {
	Items: {},
	Tool: {},
	Brainrots: {}
}

local PlayerCache: {[Player]: InventoryClass} = {}

function InventoryManager:DefaultInventory(Player: Player)
	PlayerCache[Player] = {
		Items = {},
		Tool = {},
		Brainrots = {}
	}
end

function InventoryManager:GetInventory(Player: Player , Type: "Items" | "Tool" | "Brainrots")
	return PlayerCache[Player][Type]
end

function InventoryManager:VerifyCache(Player: Player)
	if not PlayerCache[Player] then
		InventoryManager:DefaultInventory(Player)
	else
		warn("[InventoryManager] Player already has a cache")
	end
end

function InventoryManager:UpdateCache(Player: Player)
	PlayerCache[Player].Items = InventoryManager:GetInventory(Player, "Items")
	PlayerCache[Player].Tool = InventoryManager:GetInventory(Player, "Tool")
	PlayerCache[Player].Brainrots = InventoryManager:GetInventory(Player, "Brainrots")
end

return InventoryManager

-------------------INVENTORY CLASS!!------------------ (ANOTHER MODULE)


local CoinsClass = {}
CoinsClass.__index = CoinsClass

local CoinManager = require(script.Parent)

function CoinsClass.new(plr: Player)
	local self = setmetatable({}, CoinsClass)
	CoinManager:VerifyCache(plr)
	
	self.Player = plr
	self.Coins = CoinManager:GetCoin(self.Player)
	self.Gems = CoinManager:GetGems(self.Player)
	
	return self
end

function CoinsClass:Add(Amount: number, Type: "Coins" | "Gems")
	self[Type] += Amount
	CoinManager:UpdateCache(self.Player)
end

function CoinsClass:Remove(Amount: number, Type: "Coins" | "Gems")
	self[Type] -= Amount
	CoinManager:UpdateCache(self.Player)
end

function CoinsClass:Reset(Type: "Coins" | "Gems")
	self[Type] = 0
	CoinManager:UpdateCache(self.Player)
end

return CoinsClass
