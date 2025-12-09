local player = game.Players.LocalPlayer
local textLabel = script.Parent:WaitForChild("TextLabel")
local distanceTravelled = 0
local lastPosition = nil
local hrp = nil
local function setupCharacter(char)
	hrp = char:WaitForChild("HumanoidRootPart")
	lastPosition = Vector3.new(hrp.Position.X, 0, hrp.Position.Z) -- ignorujemy Y
end
if player.Character then
	setupCharacter(player.Character)
end
player.CharacterAdded:Connect(function(char)
	setupCharacter(char)
end)
game:GetService("RunService").RenderStepped:Connect(function()
	if hrp and lastPosition then
		local currentPosition = Vector3.new(hrp.Position.X, 0, hrp.Position.Z) -- ignorujemy Y
		local distance = (currentPosition - lastPosition).Magnitude
		distanceTravelled = distanceTravelled + distance
		lastPosition = currentPosition
		textLabel.Text = "Distance Travelled: " .. math.floor(distanceTravelled) .. " m"
		player:SetAttribute("DistanceTravelled", distanceTravelled)
	end
end)
