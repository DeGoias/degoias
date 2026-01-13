local ball = workspace.ball
local tool = script.Parent.Parent
local handle = script.Parent

local canTouch = false
local touchConnection

tool.Activated:Connect(function()
	if touchConnection then
		touchConnection:Disconnect()
	end

	canTouch = true

	touchConnection = handle.Touched:Connect(function(hit)
		if canTouch and hit == ball then
			canTouch = false

			local character = tool.Parent
			local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

			if humanoidRootPart then
				local direction = humanoidRootPart.CFrame.LookVector
				local velocity = direction * 50 + Vector3.new(0, 30, 0)

				local body = Instance.new("BodyVelocity")
				body.Velocity = velocity
				body.MaxForce = Vector3.new(1e5, 1e5, 1e5)
				body.Parent = ball

				game:GetService("Debris"):AddItem(body, 0.5)
			end

			if touchConnection then
				touchConnection:Disconnect()
				touchConnection = nil
			end
		end
	end)
end)
