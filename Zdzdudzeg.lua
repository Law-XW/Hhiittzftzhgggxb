if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Ali-lov3/HighLib/refs/heads/main/Source.lua"))()

local Logo = "rbxassetid://77434646025119"

local Window = Library:Window({
    Name = "StreetLife by Xeioa",
    Logo = Logo,
    ShowTabName = false
})

local Watermark = Library:Watermark("StreetLife by Xeioa", Logo)
local KeyList = Library:KeybindList()

local CombatPage = Window:Page({
    Name = "Combat",
    Icon = "crosshair"
})

local ShopPage = Window:Page({
    Name = "Shop",
    Icon = "shopping-cart"
})

local FarmPage = Window:Page({
    Name = "Farm",
    Icon = "layout-dashboard"
})

local PlayerPage = Window:Page({
    Name = "Player",
    Icon = "user"
})

local CombatSection = CombatPage:Section({
    Name = "Silent Aim",
    Icon = "target",
    Side = 1
})

local ShopSection = ShopPage:Section({
    Name = "Gun Shop",
    Icon = "shopping-bag",
    Side = 1
})

local AmmoSection = ShopPage:Section({
    Name = "Ammo Shop",
    Icon = "box",
    Side = 2
})

local MopSection = FarmPage:Section({
    Name = "MopFarm",
    Icon = "sparkles",
    Side = 1
})

MopSection:Label("be near the job")

local BoxSection = FarmPage:Section({
    Name = "BoxFarm",
    Icon = "package",
    Side = 1
})

BoxSection:Label("be near the job")

local CarRobSection = FarmPage:Section({
    Name = "CarRobFarm",
    Icon = "car",
    Side = 1
})

CarRobSection:Label("be near the job")

local SettingSection = FarmPage:Section({
    Name = "Setting",
    Icon = "settings",
    Side = 2
})

local PlayerSection = PlayerPage:Section({
    Name = "Player Options",
    Icon = "user-check",
    Side = 1
})

local PathfindingService = game:GetService("PathfindingService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local MopFarmEnabled = false
local MopFarmMethod = "Legit"

local BoxFarmEnabled = false
local BoxFarmMethod = "Legit"

local CarRobEnabled = false
local CarRobMethod = "Legit"

local TweenSpeed = 35

local SilentAimEnabled = false
local FOVMode = "Follow Mouse"
local FOVRadius = 100
local VisibleFOV = false
local FOVColor = Color3.fromRGB(255, 255, 255)
local FOVTracer = false
local HighlightTarget = false
local WallCheckEnabled = false

local SpeedBoostEnabled = false

local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.NumSides = 64
FOVCircle.Filled = false
FOVCircle.Visible = false

local TracerLine = Drawing.new("Line")
TracerLine.Thickness = 1
TracerLine.Visible = false

local CurrentHighlight = nil

local GunPrices = {
    ["Vector"] = 7000,
    ["AK-47"] = 6500,
    ["HoneyBadger"] = 5500,
    ["ARPistol"] = 5000,
    ["GlockSwitch"] = 5400,
    ["Glock19X"] = 5000,
    ["AUG"] = 5000,
    ["Draco"] = 5200,
    ["Tec-9"] = 3500,
    ["UMP"] = 4800,
    ["Shotgun"] = 5000,
    ["Mac"] = 3000,
    ["Makarov"] = 1000,
    ["Glock17"] = 1200
}

local AmmoPrices = {
    ["Shotgun Ammo"] = 100,
    ["SMG Ammo"] = 100,
    ["Rifle Ammo"] = 100,
    ["Pistol Ammo"] = 50
}

local SelectedGun = "Vector"
local SelectedAmmo = "Pistol Ammo"

local Success, Projectile = pcall(function()
    return require(ReplicatedStorage.Modules.GunFramework.Modules.Projectile)
end)

if Success and Projectile and Projectile.new then
    local oldNew = Projectile.new
    Projectile.new = function(p10)
        if SilentAimEnabled then
            local target = GetSilentAimTarget()
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                p10.Direction = (target.Character.HumanoidRootPart.Position - p10.Origin).Unit
            end
        end
        return oldNew(p10)
    end
end

function GetFOVPosition()
    if FOVMode == "Center" then
        return Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    else
        return UserInputService:GetMouseLocation()
    end
end

function IsTargetVisible(targetCharacter)
    if not WallCheckEnabled then return true end
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("Head") then return false end
    
    local targetPart = targetCharacter:FindFirstChild("HumanoidRootPart") or targetCharacter:FindFirstChild("Head")
    if not targetPart then return false end

    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, targetCharacter}
    raycastParams.IgnoreWater = true

    local origin = Camera.CFrame.Position
    local direction = targetPart.Position - origin

    local result = workspace:Raycast(origin, direction, raycastParams)
    return result == nil
end

function GetSilentAimTarget()
    local closestPlayer = nil
    local shortestDistance = FOVRadius
    local fovPos = GetFOVPosition()

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                if IsTargetVisible(player.Character) then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                    if onScreen then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - fovPos).Magnitude
                        if dist < shortestDistance then
                            shortestDistance = dist
                            closestPlayer = player
                        end
                    end
                end
            end
        end
    end
    return closestPlayer
end

local function updateHighlight(target)
    if CurrentHighlight and CurrentHighlight.Parent then 
        CurrentHighlight:Destroy() 
        CurrentHighlight = nil
    end
    if HighlightTarget and target and target.Character then
        CurrentHighlight = Instance.new("Highlight")
        CurrentHighlight.FillColor = Color3.fromRGB(255, 0, 0)
        CurrentHighlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        CurrentHighlight.Adornee = target.Character
        CurrentHighlight.Parent = target.Character
    end
end

RunService.Heartbeat:Connect(function(deltaTime)
    if SpeedBoostEnabled and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        
        if humanoid and rootPart and humanoid.MoveDirection.Magnitude > 0 then
            rootPart.CFrame = rootPart.CFrame + (humanoid.MoveDirection * humanoid.WalkSpeed * deltaTime)
        end
    end
end)

RunService.RenderStepped:Connect(function()
    local fovPos = GetFOVPosition()

    if VisibleFOV and SilentAimEnabled then
        FOVCircle.Position = fovPos
        FOVCircle.Radius = FOVRadius
        FOVCircle.Color = FOVColor
        FOVCircle.Visible = true
    else
        FOVCircle.Visible = false
    end

    local target = GetSilentAimTarget()

    if SilentAimEnabled and FOVTracer and target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local screenPos, onScreen = Camera:WorldToViewportPoint(target.Character.HumanoidRootPart.Position)
        if onScreen then
            TracerLine.From = fovPos
            TracerLine.To = Vector2.new(screenPos.X, screenPos.Y)
            TracerLine.Color = FOVColor
            TracerLine.Visible = true
        else
            TracerLine.Visible = false
        end
    else
        TracerLine.Visible = false
    end

    if SilentAimEnabled then
        updateHighlight(target)
    else
        updateHighlight(nil)
    end
end)

CombatSection:Toggle({
    Name = "Enable Silent Aim",
    Flag = "SilentAimEnable",
    Default = false,
    Callback = function(Value)
        SilentAimEnabled = Value
    end
})

CombatSection:Checkbox({
    Name = "Wall Check",
    Flag = "WallCheckCheck",
    Default = false,
    Callback = function(Value)
        WallCheckEnabled = Value
    end
})

CombatSection:Dropdown({
    Name = "FOV Mode",
    Flag = "FOVModeDropdown",
    Default = "Follow Mouse",
    Items = {"Follow Mouse", "Center"},
    Multi = false,
    Callback = function(Value)
        FOVMode = Value
    end
})

CombatSection:Checkbox({
    Name = "Draw FOV",
    Flag = "DrawFOVCheck",
    Default = false,
    Callback = function(Value)
        VisibleFOV = Value
    end
})

CombatSection:Slider({
    Name = "FOV Size",
    Flag = "FOVSizeSlider",
    Default = 100,
    Min = 10,
    Max = 500,
    Decimals = 1,
    Suffix = "",
    Callback = function(Value)
        FOVRadius = Value
    end
})

CombatSection:Label("FOV Color"):Colorpicker({
    Flag = "FOVColorPicker",
    Default = Color3.fromRGB(255, 255, 255),
    Alpha = 1,
    Callback = function(Value)
        FOVColor = Value
    end
})

CombatSection:Checkbox({
    Name = "FOV Tracer",
    Flag = "FOVTracerCheck",
    Default = false,
    Callback = function(Value)
        FOVTracer = Value
    end
})

CombatSection:Checkbox({
    Name = "Highlight Target",
    Flag = "HighlightTargetCheck",
    Default = false,
    Callback = function(Value)
        HighlightTarget = Value
    end
})

local CombatButtons = CombatSection:Button()
CombatButtons:Add("Inf Ammo", function()
    local function InfAmmo(Tool)
        if Tool:IsA("Tool") and Tool:GetAttribute("Ammo_Client") ~= nil then
            local function Keep()
                if Tool:GetAttribute("Ammo_Client") < 999 then
                    Tool:SetAttribute("Ammo_Client", 999)
                end
            end
            Keep()
            Tool:GetAttributeChangedSignal("Ammo_Client"):Connect(Keep)
        end
    end

    for _, Tool in ipairs(CollectionService:GetTagged("Gun")) do
        InfAmmo(Tool)
    end

    CollectionService:GetInstanceAddedSignal("Gun"):Connect(InfAmmo)
end)

ShopSection:Dropdown({
    Name = "Gun",
    Flag = "ShopGunSelection",
    Default = "Vector",
    Items = {"Vector", "AK-47", "HoneyBadger", "ARPistol", "GlockSwitch", "Glock19X", "AUG", "Draco", "Tec-9", "UMP", "Shotgun", "Mac", "Makarov", "Glock17"},
    Multi = false,
    Callback = function(Value)
        SelectedGun = Value
    end
})

local ShopButtons = ShopSection:Button()
ShopButtons:Add("Buy Gun", function()
    local gunRemote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("GunBuy")
    if gunRemote and SelectedGun then
        local price = GunPrices[SelectedGun] or 0
        gunRemote:FireServer(SelectedGun, price)
    end
end)

AmmoSection:Dropdown({
    Name = "Ammo",
    Flag = "ShopAmmoSelection",
    Default = "Pistol Ammo",
    Items = {"Shotgun Ammo", "SMG Ammo", "Rifle Ammo", "Pistol Ammo"},
    Multi = false,
    Callback = function(Value)
        SelectedAmmo = Value
    end
})

local AmmoButtons = AmmoSection:Button()
AmmoButtons:Add("Buy Ammo", function()
    local gunRemote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("GunBuy")
    if gunRemote and SelectedAmmo then
        local price = AmmoPrices[SelectedAmmo] or 0
        gunRemote:FireServer(SelectedAmmo, price)
    end
end)

PlayerSection:Toggle({
    Name = "SpeedBoost",
    Flag = "SpeedBoostToggle",
    Default = false,
    Callback = function(Value)
        SpeedBoostEnabled = Value
    end
})

SettingSection:Slider({
    Name = "Tween Speed",
    Flag = "TweenSpeedSetting",
    Default = 35,
    Min = 1,
    Max = 35,
    Decimals = 1,
    Suffix = "",
    Callback = function(Value)
        TweenSpeed = Value
    end
})

local function GetCharacterParts()
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local Humanoid = Character:WaitForChild("Humanoid")
    local RootPart = Character:WaitForChild("HumanoidRootPart")
    return Character, Humanoid, RootPart
end

local function ResetHumanoidRotation()
    local _, Humanoid, RootPart = GetCharacterParts()
    Humanoid.AutoRotate = true
    RootPart.RotVelocity = Vector3.new(0, 0, 0)
    RootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
end

local function MoveToLegit(targetPosition, checkEnabled)
    local _, Humanoid, RootPart = GetCharacterParts()
    ResetHumanoidRotation()

    local path = PathfindingService:CreatePath({
        AgentRadius = 2,
        AgentHeight = 5,
        AgentCanJump = true
    })

    local success, _ = pcall(function()
        path:ComputeAsync(RootPart.Position, targetPosition)
    end)

    if success and path.Status == Enum.PathStatus.Success then
        local waypoints = path:GetWaypoints()
        for _, waypoint in ipairs(waypoints) do
            if not checkEnabled() then break end
            if waypoint.Action == Enum.PathWaypointAction.Jump then
                Humanoid.Jump = true
            end
            Humanoid:MoveTo(waypoint.Position)
            Humanoid.MoveToFinished:Wait()
        end
    else
        Humanoid:MoveTo(targetPosition)
        Humanoid.MoveToFinished:Wait()
    end
end

local function MoveToFast(targetPosition, checkEnabled)
    local _, _, RootPart = GetCharacterParts()
    ResetHumanoidRotation()

    local distance = (RootPart.Position - targetPosition).Magnitude
    local speed = math.clamp(TweenSpeed, 1, 35)
    local tweenInfo = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)
    local targetCFrame = CFrame.new(targetPosition)
    local tween = TweenService:Create(RootPart, tweenInfo, {CFrame = targetCFrame})
    
    tween:Play()
    
    while tween.PlaybackState == Enum.PlaybackState.Playing do
        if not checkEnabled() then
            tween:Cancel()
            break
        end
        ResetHumanoidRotation()
        task.wait(0.05)
    end
    ResetHumanoidRotation()
end

local function MovePathfindingTween(targetPosition, checkEnabled)
    local _, _, RootPart = GetCharacterParts()
    ResetHumanoidRotation()

    local path = PathfindingService:CreatePath({
        AgentRadius = 2,
        AgentHeight = 5,
        AgentCanJump = true
    })

    local success, _ = pcall(function()
        path:ComputeAsync(RootPart.Position, targetPosition)
    end)

    if success and path.Status == Enum.PathStatus.Success then
        local waypoints = path:GetWaypoints()
        for _, waypoint in ipairs(waypoints) do
            if not checkEnabled() then break end
            
            local currentPos = RootPart.Position
            local waypointPos = waypoint.Position
            local distance = (currentPos - waypointPos).Magnitude
            local speed = math.clamp(TweenSpeed, 1, 35)
            local tweenInfo = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)
            local tween = TweenService:Create(RootPart, tweenInfo, {CFrame = CFrame.new(waypointPos)})
            
            tween:Play()

            while tween.PlaybackState == Enum.PlaybackState.Playing do
                if not checkEnabled() then
                    tween:Cancel()
                    break
                end
                ResetHumanoidRotation()
                task.wait(0.05)
            end
            if not checkEnabled() then break end
        end
    else
        MoveToFast(targetPosition, checkEnabled)
    end
    ResetHumanoidRotation()
end

local function MoveTo(targetPosition, method, checkEnabled)
    if method == "Legit" then
        MoveToLegit(targetPosition, checkEnabled)
    elseif method == "Fast" then
        MoveToFast(targetPosition, checkEnabled)
    end
    ResetHumanoidRotation()
end

local function MoveToPathfinding(targetPosition, method, checkEnabled)
    if method == "Legit" then
        MoveToLegit(targetPosition, checkEnabled)
    elseif method == "Fast" then
        MovePathfindingTween(targetPosition, checkEnabled)
    end
    ResetHumanoidRotation()
end

task.spawn(function()
    while true do
        if MopFarmEnabled then
            local cleanFolder = workspace:FindFirstChild("Map") 
                and workspace.Map:FindFirstChild("Jobs") 
                and workspace.Map.Jobs:FindFirstChild("CleanNPC") 
                and workspace.Map.Jobs.CleanNPC:FindFirstChild("Clean")

            if cleanFolder then
                local items = cleanFolder:GetChildren()
                for _, item in ipairs(items) do
                    if not MopFarmEnabled then break end

                    local prompt = item:FindFirstChildOfClass("ProximityPrompt") or item:FindFirstChild("ProximityPrompt")
                    
                    if item:IsA("BasePart") or item:IsA("Model") then
                        local targetPos = item:IsA("BasePart") and item.Position or item:GetPivot().Position

                        MoveTo(targetPos, MopFarmMethod, function() return MopFarmEnabled end)

                        if MopFarmEnabled and prompt then
                            task.wait(0.2)
                            fireproximityprompt(prompt)
                            task.wait(0.5)
                        end
                    end
                end
            end
        end
        task.wait(1)
    end
end)

task.spawn(function()
    local takePos = Vector3.new(205.29685974121094, 52.38993453979492, 339.0135803222656)
    local deliverPos = Vector3.new(157.49252319335938, 53.04217529296875, 261.873779296875)

    while true do
        if BoxFarmEnabled then
            MoveToPathfinding(takePos, BoxFarmMethod, function() return BoxFarmEnabled end)

            if BoxFarmEnabled then
                local takePrompt = workspace:FindFirstChild("Map")
                    and workspace.Map:FindFirstChild("Jobs")
                    and workspace.Map.Jobs:FindFirstChild("BoxJob")
                    and workspace.Map.Jobs.BoxJob:FindFirstChild("Take")
                    and workspace.Map.Jobs.BoxJob.Take.Take:FindFirstChild("Interact")

                if takePrompt then
                    task.wait(0.2)
                    fireproximityprompt(takePrompt)
                    task.wait(0.5)
                end
            end

            if BoxFarmEnabled then
                MoveToPathfinding(deliverPos, BoxFarmMethod, function() return BoxFarmEnabled end)

                if BoxFarmEnabled then
                    local deliverPrompt = workspace:FindFirstChild("Map")
                        and workspace.Map:FindFirstChild("Jobs")
                        and workspace.Map.Jobs:FindFirstChild("BoxJob")
                        and workspace.Map.Jobs.BoxJob:FindFirstChild("Deliver")
                        and workspace.Map.Jobs.BoxJob.Deliver.Deliver:FindFirstChild("Interact")

                    if deliverPrompt then
                        task.wait(0.2)
                        fireproximityprompt(deliverPrompt)
                        task.wait(0.5)
                    end
                end
            end
        end
        task.wait(1)
    end
end)

local function GetClosestCarRob()
    local interactions = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Interactions")
    if not interactions then return nil end

    local _, _, rootPart = GetCharacterParts()
    local closestCar = nil
    local shortestDistance = math.huge

    for _, obj in ipairs(interactions:GetChildren()) do
        if obj.Name == "Car Rob" then
            local window = obj:FindFirstChild("Window")
            local h = window and window:FindFirstChild("H")
            local prompt = h and h:FindFirstChildOfClass("ProximityPrompt")

            if prompt and prompt.Enabled then
                local partPos = h:IsA("BasePart") and h.Position or obj:GetPivot().Position
                local dist = (rootPart.Position - partPos).Magnitude
                if dist < shortestDistance then
                    shortestDistance = dist
                    closestCar = {
                        Object = obj,
                        Prompt = prompt,
                        Position = partPos
                    }
                end
            end
        end
    end

    return closestCar
end

task.spawn(function()
    while true do
        if CarRobEnabled then
            local targetCar = GetClosestCarRob()

            if targetCar and targetCar.Prompt and targetCar.Prompt.Enabled then
                MoveToPathfinding(targetCar.Position, CarRobMethod, function() return CarRobEnabled end)

                if CarRobEnabled and targetCar.Prompt and targetCar.Prompt.Enabled then
                    task.wait(0.2)
                    fireproximityprompt(targetCar.Prompt)
                    
                    repeat
                        task.wait(0.1)
                    until not CarRobEnabled or not targetCar.Prompt or not targetCar.Prompt.Enabled or (targetCar.Prompt.ObjectText ~= "" and string.lower(targetCar.Prompt.ObjectText) == "grab cash")

                    if CarRobEnabled and targetCar.Prompt and targetCar.Prompt.Enabled and string.lower(targetCar.Prompt.ObjectText) == "grab cash" then
                        task.wait(0.2)
                        fireproximityprompt(targetCar.Prompt)
                        task.wait(0.5)

                        while CarRobEnabled and targetCar.Prompt and targetCar.Prompt.Enabled do
                            fireproximityprompt(targetCar.Prompt)
                            task.wait(0.5)
                        end

                        task.wait(1)
                    end
                end
            end
        end
        task.wait(1)
    end
end)

MopSection:Toggle({
    Name = "Enable",
    Flag = "MopFarmEnable",
    Default = false,
    Callback = function(Value)
        MopFarmEnabled = Value
    end
})

MopSection:Dropdown({
    Name = "Method",
    Flag = "MopFarmMethod",
    Default = "Legit",
    Items = {"Legit", "Fast"},
    Multi = false,
    Callback = function(Value)
        MopFarmMethod = Value
    end
})

BoxSection:Toggle({
    Name = "Enable",
    Flag = "BoxFarmEnable",
    Default = false,
    Callback = function(Value)
        BoxFarmEnabled = Value
    end
})

BoxSection:Dropdown({
    Name = "Method",
    Flag = "BoxFarmMethod",
    Default = "Legit",
    Items = {"Legit", "Fast"},
    Multi = false,
    Callback = function(Value)
        BoxFarmMethod = Value
    end
})

CarRobSection:Toggle({
    Name = "Enable",
    Flag = "CarRobEnable",
    Default = false,
    Callback = function(Value)
        CarRobEnabled = Value
    end
})

CarRobSection:Dropdown({
    Name = "Method",
    Flag = "CarRobMethod",
    Default = "Legit",
    Items = {"Legit", "Fast"},
    Multi = false,
    Callback = function(Value)
        CarRobMethod = Value
    end
})

Library:CreateSettingsPage(Window, Watermark, KeyList)
