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
