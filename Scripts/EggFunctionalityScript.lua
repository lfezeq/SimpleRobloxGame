local eggsFolder = script.Parent
local respawnTime = 30 
for _, egg in pairs(eggsFolder:GetChildren()) do
	if egg:IsA("Model") and egg.PrimaryPart then
		local canCollect = true
		local mainPart = egg.PrimaryPart
		local function onTouched(hit)
			if not canCollect then return end
			local player = game.Players:GetPlayerFromCharacter(hit.Parent)
			if not player then return end
			canCollect = false
			mainPart.Transparency = 1
			mainPart.CanCollide = false
			task.wait(respawnTime)
			mainPart.Transparency = 0
			mainPart.CanCollide = true
			canCollect = true
		end
		mainPart.Touched:Connect(onTouched)
	end
end
