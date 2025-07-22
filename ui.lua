-- Advanced Pro Grade Automatic Aimbot for Roblox Arsenal
-- Features: Silent Aim, Visible Aimbot with Smooth Lerp, ESP, Triggerbot, Prediction, Adjustable FOV, Wall Check, Target Priority (Closest or Low Health)
-- GUI for configuration using basic toggles (assume exploit supports Drawing and UserInput)
-- Handles death by checking character
-- Always locks to closest unless mouse moves, then reselects
-- Use at your own risk

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Settings
local Settings = {
    SilentAim = true, -- Enable silent aim (hooks raycast)
    VisibleAimbot = true, -- Enable visible camera snap
    ESP = true, -- Enable ESP highlights
    Triggerbot = true, -- Auto shoot when crosshair on enemy
    FOV = 300, -- Field of View for aiming
    AimPart = "Head", -- Part to aim at
    TeamCheck = true, -- Don't aim at teammates
    VisibilityCheck = true, -- Wall check
    Smoothness = 0.5, -- For visible aim (0-1, 1 instant)
    Prediction = 0.15, -- For moving targets
    Priority = "Closest", -- "Closest" or "LowHealth"
    MouseIdleTime = 0.2, -- Time to consider mouse idle
    TriggerKey = Enum.KeyCode.F -- Toggle whole aimbot
}

-- Variables
local Enabled = false
local lockedTarget = nil
local lastMouseMove = 0
local ESPDrawings = {}
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = true
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(255, 0, 0)
FOVCircle.Filled = false
FOVCircle.Radius = Settings.FOV
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

-- Function to get closest enemy based on priority
local function GetClosestEnemy()
    local Closest = nil
    local MinValue = math.huge
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            if Settings.TeamCheck and player.Team == LocalPlayer.Team then continue end
            
            local part = player.Character:FindFirstChild(Settings.AimPart)
            if not part then continue end
            
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if not root then continue end
            
            local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
            if not onScreen then continue end
            
            local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude
            if dist > Settings.FOV then continue end
            
            if Settings.VisibilityCheck then
                local rayParams = RaycastParams.new()
                rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                rayParams.FilterDescendantsInstances = {Camera, LocalPlayer.Character or {}}
                
                local result = Workspace:Raycast(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position).Unit * 5000, rayParams)
                if not result or result.Instance.Parent ~= player.Character then continue end
            end
            
            local value = (Settings.Priority == "LowHealth") and player.Character.Humanoid.Health or dist
            if value < MinValue then
                MinValue = value
                Closest = {Player = player, Part = part, Velocity = root.Velocity}
            end
        end
    end
    
    return Closest
end

-- Silent Aim Hook
local oldNamecall
if Settings.SilentAim then
    oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        if Enabled and not checkcaller() and self == Workspace and getnamecallmethod() == "Raycast" then
            local args = {...}
            local target = lockedTarget or GetClosestEnemy()
            if target then
                local predictedPos = target.Part.Position + target.Velocity * Settings.Prediction
                args[2] = (predictedPos - args[1]).Unit * (args[2].Magnitude or 9999)
            end
            return oldNamecall(self, unpack(args))
        end
        return oldNamecall(self, ...)
    end))
end

-- ESP Function
local function AddESP(player)
    if player == LocalPlayer or not Settings.ESP then return end
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Color3.fromRGB(255, 0, 0)
    box.Thickness = 2
    box.Filled = false
    
    local health = Drawing.new("Line")
    health.Visible = false
    health.Color = Color3.fromRGB(0, 255, 0)
    health.Thickness = 2
    
    ESPDrawings[player] = {Box = box, Health = health}
end

local function UpdateESP()
    for player, drawings in pairs(ESPDrawings) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
            local rootPos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen then
                local headPos = Camera:WorldToViewportPoint(player.Character.Head.Position + Vector3.new(0, 0.5, 0))
                local legPos = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position - Vector3.new(0, 3, 0))
                
                local height = math.abs(headPos.Y - legPos.Y)
                local width = height / 2
                
                drawings.Box.Size = Vector2.new(width, height)
                drawings.Box.Position = Vector2.new(rootPos.X - width / 2, rootPos.Y - height / 2)
                drawings.Box.Visible = true
                
                local healthPercent = player.Character.Humanoid.Health / player.Character.Humanoid.MaxHealth
                drawings.Health.From = Vector2.new(drawings.Box.Position.X - 5, drawings.Box.Position.Y + height)
                drawings.Health.To = Vector2.new(drawings.Box.Position.X - 5, drawings.Box.Position.Y + height * (1 - healthPercent))
                drawings.Health.Visible = true
            else
                drawings.Box.Visible = false
                drawings.Health.Visible = false
            end
        else
            drawings.Box.Visible = false
            drawings.Health.Visible = false
        end
    end
end

-- Add ESP to existing players
for _, player in ipairs(Players:GetPlayers()) do
    AddESP(player)
end

-- Add ESP to new players
Players.PlayerAdded:Connect(AddESP)

-- Detect mouse movement
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        lastMouseMove = os.clock()
    end
end)

-- Toggle aimbot
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Settings.TriggerKey then
        Enabled = not Enabled
        FOVCircle.Color = Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    end
end)

-- Main loop
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Radius = Settings.FOV
    
    if Enabled and LocalPlayer.Character then
        local currentTime = os.clock()
        local isMouseIdle = (currentTime - lastMouseMove > Settings.MouseIdleTime)
        
        if not isMouseIdle then
            lockedTarget = nil
        else
            if lockedTarget then
                if not lockedTarget.Player.Character or lockedTarget.Player.Character.Humanoid.Health <= 0 then
                    lockedTarget = nil
                end
            end
            
            if not lockedTarget then
                lockedTarget = GetClosestEnemy()
            end
        end
        
        if lockedTarget then
            local part = lockedTarget.Player.Character:FindFirstChild(Settings.AimPart)
            local root = lockedTarget.Player.Character:FindFirstChild("HumanoidRootPart")
            if part and root then
                lockedTarget.Part = part
                lockedTarget.Velocity = root.Velocity
                
                if Settings.VisibleAimbot then
                    local predictedPos = part.Position + root.Velocity * Settings.Prediction
                    local currentCFrame = Camera.CFrame
                    local targetCFrame = CFrame.lookAt(currentCFrame.Position, predictedPos)
                    Camera.CFrame = currentCFrame:Lerp(targetCFrame, Settings.Smoothness)
                end
                
                if Settings.Triggerbot then
                    -- Check if crosshair on enemy, auto shoot (simplify as if locked, shoot)
                    mouse1press()
                end
            else
                lockedTarget = nil
            end
        end
        
        if Settings.ESP then
            UpdateESP()
        end
    end
end)

print("Advanced Pro Grade Aimbot loaded! Press F to toggle.")
