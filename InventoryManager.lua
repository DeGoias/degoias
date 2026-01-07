local InventoryManager = {}    
InventoryManager.__index = InventoryManager

local serverStorage = game:GetService("ServerStorage")
local replicatedStorage = game:GetService("ReplicatedStorage")
local sessoes = {}


function InventoryManager.New(player)
    
    if sessoes[player.UserId] then
        return sessoes[player.UserId]
    end
    
    
    local self = setmetatable({},InventoryManager)
    
    self.Player = player
    
    self.folder_Inventory = Instance.new("Folder")
    
    self.folder_Inventory.Name = "Inventory_"..player.Name
    self.folder_Inventory.Parent = game:GetService("ServerStorage")
    
    self.folder_ToolsInventory = Instance.new("Folder")
    
    self.folder_ToolsInventory.Name = "Tools_"..player.Name
    self.folder_ToolsInventory.Parent = serverStorage
    
    
    sessoes[player.UserId] = self
    
    game.Players.PlayerRemoving:Connect(function(lPlr)
        if lPlr.UserId == player.UserId then
            sessoes[player.UserId] = nil
        end
    end)
    
    return self
end

function InventoryManager:RemoveTool(plr, tool)
    if not tool then print("[no tool RT]") return end
    if not serverStorage:WaitForChild("Tools_"..plr.Name) then print("[InventoryManager] Player "..plr.Name.." não tem Inventory") return end
    tool.Parent = serverStorage:WaitForChild("Tools_"..plr.Name)
end

function InventoryManager:AddTool(tool)
    if not tool then print("[no tool AT]") return end
    local toolClone = tool:Clone()
    toolClone.Parent = self.Player.Backpack
        end

function InventoryManager:AddItem(model)
    if not model then print("[no model AI]") end
    local model_Item = model
    local toolModel = replicatedStorage:WaitForChild("ToolsBrain"):FindFirstChild(model_Item.Name)
    if not toolModel then print("[IM AI] Sem tools pro betinha") return end
    
    local toolClone = toolModel:Clone()
    toolClone.Parent = self.Player.Backpack
    
    model_Item.Parent = serverStorage:WaitForChild("Inventory_"..self.Player.Name)
    return model_Item    
end

function InventoryManager:RemoveItem(model)
    if not model then print("[no model RI]") return end
    if not serverStorage:WaitForChild("Inventory_"..self.Player.Name) then print("[InventoryManager] Player não tem brainrot "..model.Name.." No Inventário") return end
    if not serverStorage:WaitForChild("Tools_"..self.Player.Name):FindFirstChild(model.Name) then print("[InventoryManager] Player não tem tool "..model.Name.." No Inventário Tools") return end 
    
    
    local model_Item = model
    local toolModel = serverStorage:WaitForChild("Tools_"..self.Player.Name):FindFirstChild(model_Item.Name)
    if not toolModel then return end 
    
    toolModel:Destroy()
    
    local modelInventory = serverStorage:WaitForChild("Inventory_"..self.Player.Name):FindFirstChild(model_Item.Name)
    
    modelInventory:Destroy()
end

function InventoryManager:VerifyInventory(model)
    if not model then print("[no model VI]") return end
    local status = nil
    
    if serverStorage:WaitForChild("Inventory_"..self.Player.Name):FindFirstChild(model.Name) then
        status = true
    else 
        status = false
    end
    
    return status
end

function InventoryManager:VerifyWorkspace(model)
    if not model then print("[no model VI]") return end
    local status = nil

    if workspace:WaitForChild("BrainrotsPlayer_"..self.Player.Name):FindFirstChild(model.Name) then
        status = true
    else 
        status = false
    end

    return status
end

print("[InventoryManager] Carregado")

return InventoryManager