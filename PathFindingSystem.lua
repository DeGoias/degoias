local module = require(game:GetService("ReplicatedStorage").Modules.CreateCharacter)
local replicated = game:GetService("ReplicatedStorage").Events.BuyWorker

replicated.OnServerEvent:Connect(function(plr, persoName)
    local newChc = module.New(persoName)
    
    local character: Model = newChc:CreateCharacter(plr)
    character.PrimaryPart = character:FindFirstChild("HumanoidRootPart")
    
    local PlayerPlot = workspace:WaitForChild("Plots"):FindFirstChild(plr.Name.."'s Plot")
    PlayerPlot:FindFirstChild("TPCharacter").Name = character.Name
    
    if PlayerPlot then
        warn("PlayerPlot is found")
    else
        return
    end
    
    local path = game:GetService("PathfindingService"):CreatePath({
        AgentRadius = 5,
        AgentHeight = 2,
        AgentCanJump = true,
        AgentCanClimb = true
    })
    
    path:ComputeAsync(character:WaitForChild("HumanoidRootPart").Position, PlayerPlot:FindFirstChild("NPCDestination").Position)
    
    local waypoints = path:GetWaypoints()
    local humanoid: Humanoid = character:FindFirstChildWhichIsA("Humanoid")
        
    local function findAvailableZone(plot)
        for _, zone in ipairs(plot:GetChildren()) do
            if zone:IsA("BasePart") and zone:FindFirstChild("Occuped") and zone.Occuped.Value == false then
                return zone
            end
        end
        return nil
    end

    local function teleportNPC()
        local availableZone = findAvailableZone(PlayerPlot)
        if availableZone then
            character:PivotTo(availableZone.CFrame)
            availableZone.Occuped.Value = true
        else
            warn("Not Found Zone for NPC")
        end
        humanoid.Animator:Destroy()
        character.PrimaryPart.Anchored = true
        character:FindFirstChild("Animate").Enabled = false
    end
    
    
    for index, waypoint in ipairs(waypoints) do
        humanoid:MoveTo(waypoint.Position)
        humanoid.MoveToFinished:Wait()

        if index == #waypoints then
            task.wait(0.2)
            teleportNPC()
        end
    end
end)
