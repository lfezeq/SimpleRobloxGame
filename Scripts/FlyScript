local player = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local physicsService = game:GetService("PhysicsService")

local flying = false
local speed = 100
local move = Vector3.new()
local vertical = 0
local smoothFactor = 0.15

local collisionGroup = "NoCollideFly"

pcall(function()
	if not physicsService:CollisionGroupExists(collisionGroup) then
		physicsService:CreateCollisionGroup(collisionGroup)
		physicsService:CollisionGroupSetCollidable(collisionGroup, collisionGroup, false)
	end
end)

local function getRoot(character)
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if hrp then return hrp end
	local torso = character:FindFirstChild("Torso")
	if torso then return torso end
	return character:FindFirstChildWhichIsA("BasePart")
end

local function setCharacterCollision(character, enable)
	for i, part in character:GetChildren() do
		if part:IsA("BasePart") then
			if enable then
				physicsService:SetPartCollisionGroup(part, "Default")
			else
				physicsService:SetPartCollisionGroup(part, collisionGroup)
			end
		end
	end
end

local function enableFlying(character)
	local root = getRoot(character)
	if not root then return end
	if root:FindFirstChild("FlyForce") then return end

	local bv = Instance.new("BodyVelocity")
	bv.Name = "FlyForce"
	bv.MaxForce = Vector3.new(1e6,1e6,1e6)
	bv.Velocity = Vector3.new(0,0,0)
	bv.Parent = root

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid:ChangeState(Enum.HumanoidStateType.Physics)
		humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
		humanoid.AutoRotate = false
	end

	setCharacterCollision(character, false)
end

local function disableFlying(character)
	local root = getRoot(character)
	if not root then return end
	local bv = root:FindFirstChild("FlyForce")
	if bv then bv:Destroy() end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
		humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, true)
		humanoid.AutoRotate = true
	end

	setCharacterCollision(character, true)
end

local function setFlying(state)
	flying = state

	local char = player.Character or player.CharacterAdded:Wait()
	local root = getRoot(char)

	if not root then
		char:WaitForChild("HumanoidRootPart")
		root = getRoot(char)
	end

	if state then
		enableFlying(char)
	else
		disableFlying(char)
	end
end

uis.InputBegan:Connect(function(input, gpe)
	if gpe then return end

	if input.KeyCode == Enum.KeyCode.F then
		setFlying(not flying)
	end
	if input.KeyCode == Enum.KeyCode.W then move = move + Vector3.new(0,0,1) end
	if input.KeyCode == Enum.KeyCode.S then move = move + Vector3.new(0,0,-1) end
	if input.KeyCode == Enum.KeyCode.A then move = move + Vector3.new(-1,0,0) end
	if input.KeyCode == Enum.KeyCode.D then move = move + Vector3.new(1,0,0) end
	if input.KeyCode == Enum.KeyCode.Space then vertical = vertical + 1 end
	if input.KeyCode == Enum.KeyCode.LeftShift then vertical = vertical - 1 end
end)

uis.InputEnded:Connect(function(input, gpe)
	if gpe then return end

	if input.KeyCode == Enum.KeyCode.W then move = move - Vector3.new(0,0,1) end
	if input.KeyCode == Enum.KeyCode.S then move = move - Vector3.new(0,0,-1) end
	if input.KeyCode == Enum.KeyCode.A then move = move - Vector3.new(-1,0,0) end
	if input.KeyCode == Enum.KeyCode.D then move = move - Vector3.new(1,0,0) end
	if input.KeyCode == Enum.KeyCode.Space then vertical = vertical - 1 end
	if input.KeyCode == Enum.KeyCode.LeftShift then vertical = vertical + 1 end
end)

runService.RenderStepped:Connect(function(dt)
	if not flying then return end
	local character = player.Character
	if not character then return end
	local root = getRoot(character)
	if not root then return end
	local bv = root:FindFirstChild("FlyForce")
	if not bv then return end

	local cam = workspace.CurrentCamera
	local inputDir = Vector3.new(move.X, 0, move.Z)
	local camRight = Vector3.new(cam.CFrame.RightVector.X, 0, cam.CFrame.RightVector.Z)
	local camLook = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z)
	local moveDir = (camLook * inputDir.Z + camRight * inputDir.X)

	if moveDir.Magnitude > 0 then
		moveDir = moveDir.Unit
		bv.Velocity = Vector3.new(moveDir.X * speed, vertical * speed, moveDir.Z * speed)
		local currentLook = Vector3.new(root.CFrame.LookVector.X, 0, root.CFrame.LookVector.Z)
		local smoothLook = currentLook:Lerp(moveDir, smoothFactor)
		root.CFrame = CFrame.lookAt(root.Position, root.Position + smoothLook)
	else
		bv.Velocity = Vector3.new(0, vertical * speed, 0)
		root.AssemblyAngularVelocity = Vector3.new(0,0,0)
		root.RotVelocity = Vector3.new(0,0,0)
	end
end)

player.CharacterAdded:Connect(function(character)
	if flying then
		enableFlying(character)
	else
		disableFlying(character)
	end
end)
