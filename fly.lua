local fly.lua = [[
-- SERVICES
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- PLAYER
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

-- SETTINGS
local flying = false
local baseSpeed = 60
local speedMult = 1

-- BODY MOVERS
local bv = nil
local bg = nil

-- SPEED UI
local gui = Instance.new("ScreenGui")
gui.Name = "FlySpeedGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local label = Instance.new("TextLabel")
label.Size = UDim2.new(0, 220, 0, 40)
label.Position = UDim2.new(0, 20, 0, 20)
label.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
label.BackgroundTransparency = 0.15
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextScaled = true
label.Font = Enum.Font.GothamBold
label.Text = "Fly Speed: 1×"
label.Visible = false
label.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = label

-- FLY FUNCTIONS
local function startFly()
	if bv or bg then return end
	humanoid.PlatformStand = true

	bv = Instance.new("BodyVelocity")
	bv.MaxForce = Vector3.new(1e9,1e9,1e9)
	bv.Velocity = Vector3.zero
	bv.Parent = hrp

	bg = Instance.new("BodyGyro")
	bg.MaxTorque = Vector3.new(1e9,1e9,1e9)
	bg.P = 9e4
	bg.CFrame = hrp.CFrame
	bg.Parent = hrp

	label.Visible = true
end

local function stopFly()
	humanoid.PlatformStand = false
	if bv then bv:Destroy() bv=nil end
	if bg then bg:Destroy() bg=nil end
	speedMult = 1
	label.Text = "Fly Speed: 1×"
	label.Visible = false
end

-- INPUT
UserInputService.InputBegan:Connect(function(input,gpe)
	if gpe then return end
	if input.KeyCode==Enum.KeyCode.E then
		flying = not flying
		if flying then startFly() else stopFly() end
	end
	if input.KeyCode==Enum.KeyCode.LeftControl then
		speedMult = speedMult * 2
		label.Text = "Fly Speed: "..speedMult.."×"
	end
	if input.KeyCode==Enum.KeyCode.R then
		speedMult = 1
		label.Text = "Fly Speed: 1×"
	end
end)

-- FLY LOOP
RunService.RenderStepped:Connect(function()
	if not flying or not bv then return end
	local cam = workspace.CurrentCamera
	local move = Vector3.zero
	if UserInputService:IsKeyDown(Enum.KeyCode.W) then move+=cam.CFrame.LookVector end
	if UserInputService:IsKeyDown(Enum.KeyCode.S) then move-=cam.CFrame.LookVector end
	if UserInputService:IsKeyDown(Enum.KeyCode.A) then move-=cam.CFrame.RightVector end
	if UserInputService:IsKeyDown(Enum.KeyCode.D) then move+=cam.CFrame.RightVector end
	if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move+=Vector3.new(0,1,0) end
	if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move-=Vector3.new(0,1,0) end
	if move.Magnitude>0 then move=move.Unit end
	bv.Velocity = move * baseSpeed * speedMult
	bg.CFrame = cam.CFrame
end)
]]
