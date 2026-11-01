local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Law-XW/7777777/refs/heads/main/Source.lua"))()

local Window = Library:CreateWindow({
	Title = "Zero.gg",
	Logo = "97669122739360",
	ConfigFolder = "Zero.ggRivals",
	Version = "Beta",
	Footer = "Rivals",
	Intro = true,
	IntroText = "Loading...",
	Anonymous = true,
})

Window:SetWatermark("Zero.gg")

Window:AddHomeManager()

local Rage = Window:AddTab("Rage", "114754373397661")
local Legit = Window:AddTab("Legit", "70713954642233")
local Esp = Window:AddTab("Esp", "eye")
local Visual = Window:AddTab("Visual", "palette")
local World = Window:AddTab("World", "globe")
local Player = Window:AddTab("Player", "user")

local Settings = {
	Enabled = false,

	Box = false,
	BoxGradient = false,
	
	Glow = false,
	GlowGradient = false,
	GlowColor = Color3.fromRGB(255, 80, 180),
	GlowTransparency = 0.4,
	
	HealthBar = false,
	HealthBarGradient = false,
	
	HealthText = false,
	HealthTextGradient = false,
	
	Name = false,
	DisplayName = false,
	NameGradient = false,
	
	Avatar = false,
	
	Weapon = false,
	WeaponText = false,
	WeaponImage = false,
	WeaponImageSize = 48,
	LastShotTime = 0,
	WeaponAmmo = false,
	WeaponGradient = false,
	
	Backpack = false,
	BackpackGradient = false,
	
	Distance = false,
	DistanceGradient = false,
	
	TeamCheck = true,
	MaxDistance = 2000,

	GradientColor1 = Color3.fromRGB(255, 255, 255),
	GradientColor2 = Color3.fromRGB(255, 80, 180)
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local FighterController = require(LocalPlayer.PlayerScripts.Controllers.FighterController)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BoxESP"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = gethui and gethui() or game:GetService("CoreGui")

local ESPFolder = Instance.new("Folder")
ESPFolder.Parent = ScreenGui

local Objects = {}

local function createESP(player)
	local box = Instance.new("Frame")
	box.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	box.BackgroundTransparency = 1
	box.BorderSizePixel = 0
	box.Visible = false
	box.Parent = ESPFolder

	local glow = Instance.new("ImageLabel")
	glow.Name = "Glow"
	glow.BackgroundTransparency = 1
	glow.Position = UDim2.new(0, -15, 0, -15)
	glow.Size = UDim2.new(1, 30, 1, 30)
	glow.Image = "rbxassetid://5028857084"
	glow.ScaleType = Enum.ScaleType.Slice
	glow.SliceCenter = Rect.new(24, 24, 276, 276)
	glow.ImageColor3 = Color3.fromRGB(255, 255, 255)
	glow.ImageTransparency = Settings.GlowTransparency
	glow.ZIndex = 0
	glow.Parent = box

	local glowGradient = Instance.new("UIGradient")
	glowGradient.Name = "GlowGradient"
	glowGradient.Parent = glow

	local stroke = Instance.new("UIStroke")
	stroke.Name = "BoxStroke"
	stroke.Color = Color3.fromRGB(255, 255, 255)
	stroke.Thickness = 1
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = box

	local strokeGradient = Instance.new("UIGradient")
	strokeGradient.Name = "StrokeGradient"
	strokeGradient.Parent = stroke

	local fill = Instance.new("Frame")
	fill.Name = "Fill"
	fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	fill.BackgroundTransparency = 0.65
	fill.BorderSizePixel = 0
	fill.Size = UDim2.fromScale(1, 1)
	fill.Position = UDim2.fromScale(0, 0)
	fill.Parent = box

	local fillGradient = Instance.new("UIGradient")
	fillGradient.Name = "FillGradient"
	fillGradient.Rotation = 90
	fillGradient.Parent = fill

	local healthBarBg = Instance.new("Frame")
	healthBarBg.Name = "HealthBarBg"
	healthBarBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	healthBarBg.BackgroundTransparency = 0.4
	healthBarBg.BorderSizePixel = 0
	healthBarBg.Size = UDim2.new(0, 2, 1, 0)
	healthBarBg.Position = UDim2.new(0, -5, 0, 0)
	healthBarBg.Parent = box

	local healthBar = Instance.new("Frame")
	healthBar.Name = "HealthBar"
	healthBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	healthBar.BorderSizePixel = 0
	healthBar.Size = UDim2.fromScale(1, 1)
	healthBar.Position = UDim2.fromScale(0, 0)
	healthBar.Parent = healthBarBg

	local healthBarGradient = Instance.new("UIGradient")
	healthBarGradient.Name = "HealthBarGradient"
	healthBarGradient.Rotation = 90
	healthBarGradient.Parent = healthBar

	local healthText = Instance.new("TextLabel")
	healthText.Name = "HealthText"
	healthText.BackgroundTransparency = 1
	healthText.Size = UDim2.new(0, 40, 0, 12)
	healthText.Position = UDim2.new(0, -47, 0, -2)
	healthText.Font = Enum.Font.SourceSansBold
	healthText.TextSize = 11
	healthText.TextColor3 = Color3.fromRGB(255, 255, 255)
	healthText.TextXAlignment = Enum.TextXAlignment.Right
	healthText.Parent = box

	local healthTextGradient = Instance.new("UIGradient")
	healthTextGradient.Name = "HealthTextGradient"
	healthTextGradient.Parent = healthText

	local textStroke = Instance.new("UIStroke")
	textStroke.Thickness = 1
	textStroke.Color = Color3.fromRGB(0, 0, 0)
	textStroke.Parent = healthText

	local nameText = Instance.new("TextLabel")
	nameText.Name = "NameText"
	nameText.BackgroundTransparency = 1
	nameText.Size = UDim2.new(1, 0, 0, 14)
	nameText.Position = UDim2.new(0, 0, 0, -16)
	nameText.Font = Enum.Font.SourceSansBold
	nameText.TextSize = 12
	nameText.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameText.TextXAlignment = Enum.TextXAlignment.Center
	nameText.Parent = box

	local nameTextGradient = Instance.new("UIGradient")
	nameTextGradient.Name = "NameTextGradient"
	nameTextGradient.Parent = nameText

	local nameStroke = Instance.new("UIStroke")
	nameStroke.Thickness = 1
	nameStroke.Color = Color3.fromRGB(0, 0, 0)
	nameStroke.Parent = nameText

	local avatarImage = Instance.new("ImageLabel")
	avatarImage.Name = "AvatarImage"
	avatarImage.BackgroundTransparency = 1
	avatarImage.Size = UDim2.new(0, 25, 0, 25)
	avatarImage.Position = UDim2.new(0.5, -12.5, 0, -43)
	avatarImage.BorderSizePixel = 0
	avatarImage.Parent = box

	local weaponText = Instance.new("TextLabel")
	weaponText.Name = "WeaponText"
	weaponText.BackgroundTransparency = 1
	weaponText.Size = UDim2.new(1, 0, 0, 14)
	weaponText.Font = Enum.Font.SourceSansBold
	weaponText.TextSize = 11
	weaponText.TextColor3 = Color3.fromRGB(255, 255, 255)
	weaponText.TextXAlignment = Enum.TextXAlignment.Center
	weaponText.Parent = box

	local weaponImage = Instance.new("ImageLabel")
	weaponImage.Name = "WeaponImage"
	weaponImage.BackgroundTransparency = 1
	weaponImage.AnchorPoint = Vector2.new(0.5, 0)
	weaponImage.Size = UDim2.new(0, 144, 0, 48)
	weaponImage.ScaleType = Enum.ScaleType.Fit
	weaponImage.Visible = false
	weaponImage.Parent = box

	local weaponImageGradient = Instance.new("UIGradient")
	weaponImageGradient.Name = "WeaponImageGradient"
	weaponImageGradient.Rotation = 90
	weaponImageGradient.Parent = weaponImage

	local weaponTextGradient = Instance.new("UIGradient")
	weaponTextGradient.Name = "WeaponTextGradient"
	weaponTextGradient.Parent = weaponText

	local weaponStroke = Instance.new("UIStroke")
	weaponStroke.Thickness = 1
	weaponStroke.Color = Color3.fromRGB(0, 0, 0)
	weaponStroke.Parent = weaponText

	local distanceText = Instance.new("TextLabel")
	distanceText.Name = "DistanceText"
	distanceText.BackgroundTransparency = 1
	distanceText.Size = UDim2.new(1, 0, 0, 14)
	distanceText.Font = Enum.Font.SourceSansBold
	distanceText.TextSize = 11
	distanceText.TextColor3 = Color3.fromRGB(255, 255, 255)
	distanceText.TextXAlignment = Enum.TextXAlignment.Center
	distanceText.Parent = box

	local distanceTextGradient = Instance.new("UIGradient")
	distanceTextGradient.Name = "DistanceTextGradient"
	distanceTextGradient.Parent = distanceText

	local distanceStroke = Instance.new("UIStroke")
	distanceStroke.Thickness = 1
	distanceStroke.Color = Color3.fromRGB(0, 0, 0)
	distanceStroke.Parent = distanceText

	local backpackText = Instance.new("TextLabel")
	backpackText.Name = "BackpackText"
	backpackText.BackgroundTransparency = 1
	backpackText.Size = UDim2.new(1, 0, 0, 14)
	backpackText.Font = Enum.Font.SourceSans
	backpackText.TextSize = 10
	backpackText.TextColor3 = Color3.fromRGB(255, 255, 255)
	backpackText.TextXAlignment = Enum.TextXAlignment.Center
	backpackText.Parent = box

	local backpackTextGradient = Instance.new("UIGradient")
	backpackTextGradient.Name = "BackpackTextGradient"
	backpackTextGradient.Parent = backpackText

	local backpackStroke = Instance.new("UIStroke")
	backpackStroke.Thickness = 1
	backpackStroke.Color = Color3.fromRGB(0, 0, 0)
	backpackStroke.Parent = backpackText

	task.spawn(function()
		local content, isReady = Players:GetUserThumbnailAsync(
			player.UserId, 
			Enum.ThumbnailType.HeadShot, 
			Enum.ThumbnailSize.Size100x100
		)
		if isReady and avatarImage then
			avatarImage.Image = content
		end
	end)

	return {
		Box = box,
		Glow = glow,
		GlowGradient = glowGradient,
		Stroke = stroke,
		StrokeGradient = strokeGradient,
		Fill = fill,
		FillGradient = fillGradient,
		HealthBarBg = healthBarBg,
		HealthBar = healthBar,
		HealthBarGradient = healthBarGradient,
		HealthText = healthText,
		HealthTextGradient = healthTextGradient,
		NameText = nameText,
		NameTextGradient = nameTextGradient,
		AvatarImage = avatarImage,
		WeaponImage = weaponImage,
		WeaponImageGradient = weaponImageGradient,
		WeaponText = weaponText,
		WeaponTextGradient = weaponTextGradient,
		DistanceText = distanceText,
		DistanceTextGradient = distanceTextGradient,
		BackpackText = backpackText,
		BackpackTextGradient = backpackTextGradient,
		Player = player
	}
end

local function removeESP(player)
	local obj = Objects[player]
	if not obj then return end
	obj.Box:Destroy()
	Objects[player] = nil
end

local function getFighter(player)
	local ok, fighter = pcall(function()
		return FighterController:GetFighter(player)
	end)
	if ok then
		return fighter
	end
	return nil
end

local function isHeld(item)
	local ok, held = pcall(function()
		return item:IsMainItem()
	end)
	return ok and held or false
end

local function getAmmoText(item)
	local ok, ammo, reserve, infiniteAmmo, infiniteReserve = pcall(function()
		return item:GetAmmoVariables()
	end)
	if not ok or ammo == nil then
		return nil
	end
	local ammoText = infiniteAmmo and "inf" or tostring(ammo)
	if reserve == nil then
		return ammoText
	end
	return ammoText .. "/" .. (infiniteReserve and "inf" or tostring(reserve))
end

local function getItemImage(item)
	local ok, image = pcall(function()
		return item.ViewModel:GetImage()
	end)
	if ok and image and image ~= "" then
		return tostring(image)
	end
	ok, image = pcall(function()
		return item.Info.Image
	end)
	if ok and image and image ~= "" then
		return tostring(image)
	end
	return nil
end

local function getHeldItem(fighter)
	if not fighter or not fighter.Items then
		return nil
	end
	for _, item in ipairs(fighter.Items) do
		if isHeld(item) then
			return item
		end
	end
	return nil
end

local function getBackpackNames(fighter)
	local names = {}
	if not fighter or not fighter.Items then
		return names
	end
	for _, item in ipairs(fighter.Items) do
		if not isHeld(item) then
			table.insert(names, tostring(item.Name))
		end
	end
	return names
end

local function isTeammate(player)
	local localTeam = LocalPlayer:GetAttribute("TeamID")
	return localTeam ~= nil and player:GetAttribute("TeamID") == localTeam
end

local function updateESP(obj)
	local player = obj.Player
	if not Settings.Enabled then
		obj.Box.Visible = false
		return
	end

	local fighter = getFighter(player)
	local character = fighter and fighter.Entity and fighter.Entity.Model or player.Character
	if Settings.TeamCheck and isTeammate(player) then
		obj.Box.Visible = false
		return
	end
	if not character then
		obj.Box.Visible = false
		return
	end

	local hrp = character:FindFirstChild("HumanoidRootPart")
	local humanoid = character:FindFirstChildOfClass("Humanoid")

	if not hrp or not humanoid or humanoid.Health <= 0 then
		obj.Box.Visible = false
		return
	end

	Camera = workspace.CurrentCamera
	if (hrp.Position - Camera.CFrame.Position).Magnitude > Settings.MaxDistance then
		obj.Box.Visible = false
		return
	end

	local hrpPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
	if not onScreen then
		obj.Box.Visible = false
		return
	end

	local head = character:FindFirstChild("Head")
	local topPos = head and head.Position + Vector3.new(0, 0.5, 0) or (hrp.Position + Vector3.new(0, 3, 0))
	local bottomPos = hrp.Position - Vector3.new(0, 3.5, 0)

	local topScreen = Camera:WorldToViewportPoint(topPos)
	local bottomScreen = Camera:WorldToViewportPoint(bottomPos)

	local height = math.abs(topScreen.Y - bottomScreen.Y)
	local width = height * 0.65

	local x = hrpPos.X - (width / 2)
	local y = topScreen.Y

	obj.Box.Position = UDim2.fromOffset(x, y)
	obj.Box.Size = UDim2.fromOffset(width, height)

	local colorSeq = ColorSequence.new(Settings.GradientColor1, Settings.GradientColor2)

	if Settings.Glow then
		obj.Glow.Visible = true
		obj.Glow.ImageTransparency = Settings.GlowTransparency
		obj.GlowGradient.Enabled = Settings.GlowGradient
		if Settings.GlowGradient then
			obj.GlowGradient.Color = colorSeq
			obj.Glow.ImageColor3 = Color3.fromRGB(255, 255, 255)
		else
			obj.Glow.ImageColor3 = Settings.GlowColor
		end
	else
		obj.Glow.Visible = false
	end

	obj.Stroke.Enabled = Settings.Box
	obj.StrokeGradient.Enabled = Settings.Box and Settings.BoxGradient
	if Settings.BoxGradient then
		obj.StrokeGradient.Color = colorSeq
	end

	obj.Fill.Visible = Settings.Box
	obj.FillGradient.Enabled = Settings.Box and Settings.BoxGradient
	if Settings.BoxGradient then
		obj.FillGradient.Color = colorSeq
	end

	local health = math.clamp(humanoid.Health, 0, humanoid.MaxHealth)
	local healthPercent = health / humanoid.MaxHealth

	if Settings.HealthBar then
		obj.HealthBarBg.Visible = true
		obj.HealthBar.Size = UDim2.fromScale(1, healthPercent)
		obj.HealthBar.Position = UDim2.fromScale(0, 1 - healthPercent)
		obj.HealthBarGradient.Enabled = Settings.HealthBarGradient
		if Settings.HealthBarGradient then
			obj.HealthBarGradient.Color = colorSeq
			obj.HealthBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		else
			obj.HealthBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0):Lerp(Color3.fromRGB(0, 255, 0), healthPercent)
		end
	else
		obj.HealthBarBg.Visible = false
	end

	if Settings.HealthText then
		obj.HealthText.Visible = true
		obj.HealthText.Text = math.floor(health) .. " HP"
		obj.HealthTextGradient.Enabled = Settings.HealthTextGradient
		if Settings.HealthTextGradient then
			obj.HealthTextGradient.Color = colorSeq
			obj.HealthText.TextColor3 = Color3.fromRGB(255, 255, 255)
		else
			obj.HealthText.TextColor3 = Color3.fromRGB(255, 0, 0):Lerp(Color3.fromRGB(0, 255, 0), healthPercent)
		end
	else
		obj.HealthText.Visible = false
	end

	local nameVisible = Settings.DisplayName or Settings.Name
	if Settings.DisplayName and Settings.Name then
		obj.NameText.Visible = true
		obj.NameText.Text = player.DisplayName .. " (@" .. player.Name .. ")"
	elseif Settings.DisplayName then
		obj.NameText.Visible = true
		obj.NameText.Text = player.DisplayName
	elseif Settings.Name then
		obj.NameText.Visible = true
		obj.NameText.Text = "@" .. player.Name
	else
		obj.NameText.Visible = false
	end
	
	obj.NameTextGradient.Enabled = Settings.NameGradient
	if Settings.NameGradient then
		obj.NameTextGradient.Color = colorSeq
		obj.NameText.TextColor3 = Color3.fromRGB(255, 255, 255)
	else
		obj.NameText.TextColor3 = Color3.fromRGB(255, 255, 255)
	end

	if Settings.Avatar then
		obj.AvatarImage.Visible = true
		if nameVisible then
			obj.AvatarImage.Position = UDim2.new(0.5, -12.5, 0, -43)
		else
			obj.AvatarImage.Position = UDim2.new(0.5, -12.5, 0, -27)
		end
	else
		obj.AvatarImage.Visible = false
	end

	local bottomOffset = 2

	obj.WeaponImage.Visible = false
	obj.WeaponText.Visible = false

	if Settings.Weapon then
		local held = getHeldItem(fighter)
		if held then
			local image = Settings.WeaponImage and getItemImage(held) or nil
			if image then
				local imageHeight = Settings.WeaponImageSize
				obj.WeaponImage.Image = image
				obj.WeaponImage.Size = UDim2.new(0, imageHeight * 3, 0, imageHeight)
				obj.WeaponImage.Position = UDim2.new(0.5, 0, 1, bottomOffset)
				obj.WeaponImage.Visible = true
				obj.WeaponImageGradient.Enabled = Settings.WeaponGradient
				if Settings.WeaponGradient then
					obj.WeaponImageGradient.Color = colorSeq
				end
				bottomOffset = bottomOffset + imageHeight + 2
			end

			local parts = {}
			if Settings.WeaponText then
				table.insert(parts, tostring(held.Name))
			end
			if Settings.WeaponAmmo then
				local ammoText = getAmmoText(held)
				if ammoText then
					table.insert(parts, "[" .. ammoText .. "]")
				end
			end
			if #parts > 0 then
				obj.WeaponText.Visible = true
				obj.WeaponText.Text = table.concat(parts, " ")
				obj.WeaponText.Position = UDim2.new(0, 0, 1, bottomOffset)
				obj.WeaponTextGradient.Enabled = Settings.WeaponGradient
				if Settings.WeaponGradient then
					obj.WeaponTextGradient.Color = colorSeq
				end
				obj.WeaponText.TextColor3 = Color3.fromRGB(255, 255, 255)
				bottomOffset = bottomOffset + 14
			end
		end
	end

	if Settings.Distance then
		local myChar = LocalPlayer.Character
		local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
		local dist = myHrp and math.floor((hrp.Position - myHrp.Position).Magnitude) or math.floor((hrp.Position - Camera.CFrame.Position).Magnitude)
		
		obj.DistanceText.Visible = true
		obj.DistanceText.Text = dist .. " Studs"
		obj.DistanceText.Position = UDim2.new(0, 0, 1, bottomOffset)
		obj.DistanceTextGradient.Enabled = Settings.DistanceGradient
		if Settings.DistanceGradient then
			obj.DistanceTextGradient.Color = colorSeq
			obj.DistanceText.TextColor3 = Color3.fromRGB(255, 255, 255)
		else
			obj.DistanceText.TextColor3 = Color3.fromRGB(200, 200, 200)
		end
		bottomOffset = bottomOffset + 14
	else
		obj.DistanceText.Visible = false
	end

	if Settings.Backpack then
		local names = getBackpackNames(fighter)
		if #names > 0 then
			obj.BackpackText.Visible = true
			obj.BackpackText.Text = "[" .. table.concat(names, ", ") .. "]"
			obj.BackpackText.Position = UDim2.new(0, 0, 1, bottomOffset)
			obj.BackpackTextGradient.Enabled = Settings.BackpackGradient
			if Settings.BackpackGradient then
				obj.BackpackTextGradient.Color = colorSeq
				obj.BackpackText.TextColor3 = Color3.fromRGB(255, 255, 255)
			else
				obj.BackpackText.TextColor3 = Color3.fromRGB(180, 180, 180)
			end
		else
			obj.BackpackText.Visible = false
		end
	else
		obj.BackpackText.Visible = false
	end

	obj.Box.Visible = Settings.Box or Settings.Glow or Settings.HealthBar or Settings.HealthText or Settings.Name or Settings.DisplayName or Settings.Avatar or Settings.Weapon or Settings.Distance or Settings.Backpack
end

local function onPlayerAdded(player)
	if player == LocalPlayer then return end
	Objects[player] = createESP(player)
end

for _, p in ipairs(Players:GetPlayers()) do
	onPlayerAdded(p)
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(removeESP)

RunService:BindToRenderStep("ESPUpdate", Enum.RenderPriority.Camera.Value + 1, function()
	for _, obj in pairs(Objects) do
		updateESP(obj)
	end
end)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

local Utility = require(ReplicatedStorage.Modules.Utility)
local EnumLibrary = require(ReplicatedStorage.Modules.EnumLibrary)
local GameplayUtility = require(ReplicatedStorage.Modules.GameplayUtility)

local DuelSpectateController = require(LocalPlayer.PlayerScripts.Controllers:WaitForChild("SpectateController"))

local function isDuelEnemy(player)
	if not player or player == LocalPlayer then
		return false
	end
	local ok, result = pcall(function()
		local duel = DuelSpectateController.CurrentDuelSubject
		if not duel then
			return false
		end
		local localDueler = duel:GetDueler(LocalPlayer)
		if not localDueler then
			return false
		end
		local dueler = duel:GetDueler(player)
		if not dueler then
			return false
		end
		return dueler:Get("TeamID") ~= localDueler:Get("TeamID")
	end)
	return ok and result or false
end

local SilentAim = {
	DuelOnly = true,
	Enabled = false,
	ShowFov = false,
	FovColor = Color3.fromRGB(255, 255, 255),
	FovColor2 = Color3.fromRGB(255, 80, 180),
	FovFill = false,
	FovGradient = false,
	FovFollow = false,
	TargetMode = "Fov",
	FovRadius = 300,
	Snapline = false,
	HighlightTarget = false,
	Wallcheck = false,
	TargetHud = false,
	TeamCheck = true,
	HitPart = "Head",
}

local FovGui = Instance.new("ScreenGui")
FovGui.Name = "SilentFov"
FovGui.ResetOnSpawn = false
FovGui.IgnoreGuiInset = true
FovGui.Parent = gethui and gethui() or game:GetService("CoreGui")

local FovFrame = Instance.new("Frame")
FovFrame.AnchorPoint = Vector2.new(0.5, 0.5)
FovFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
FovFrame.BackgroundTransparency = 1
FovFrame.BorderSizePixel = 0
FovFrame.Visible = false
FovFrame.Parent = FovGui

local FovCorner = Instance.new("UICorner")
FovCorner.CornerRadius = UDim.new(1, 0)
FovCorner.Parent = FovFrame

local FovStroke = Instance.new("UIStroke")
FovStroke.Thickness = 1
FovStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
FovStroke.Parent = FovFrame

local FovFillGradient = Instance.new("UIGradient")
FovFillGradient.Rotation = 90
FovFillGradient.Enabled = false
FovFillGradient.Parent = FovFrame

local FovStrokeGradient = Instance.new("UIGradient")
FovStrokeGradient.Rotation = 90
FovStrokeGradient.Enabled = false
FovStrokeGradient.Parent = FovStroke

local SnapLine = Drawing.new("Line")
SnapLine.Color = SilentAim.FovColor
SnapLine.Thickness = 1
SnapLine.Visible = false

local TargetHighlight = Instance.new("Highlight")
TargetHighlight.FillColor = Color3.fromRGB(255, 80, 180)
TargetHighlight.OutlineColor = Color3.fromRGB(255, 255, 255)
TargetHighlight.FillTransparency = 0.6
TargetHighlight.OutlineTransparency = 0
TargetHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
TargetHighlight.Enabled = false
TargetHighlight.Parent = ScreenGui

local HudGui = Instance.new("ScreenGui")
HudGui.Name = "TargetHud"
HudGui.ResetOnSpawn = false
HudGui.IgnoreGuiInset = true
HudGui.Parent = gethui and gethui() or game:GetService("CoreGui")

local HudFrame = Instance.new("Frame")
HudFrame.AnchorPoint = Vector2.new(0.5, 0)
HudFrame.Position = UDim2.new(0.5, 0, 0.66, 0)
HudFrame.Size = UDim2.fromOffset(260, 72)
HudFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
HudFrame.BackgroundTransparency = 0.15
HudFrame.BorderSizePixel = 0
HudFrame.Visible = false
HudFrame.Parent = HudGui

local HudCorner = Instance.new("UICorner")
HudCorner.CornerRadius = UDim.new(0, 8)
HudCorner.Parent = HudFrame

local HudStroke = Instance.new("UIStroke")
HudStroke.Color = Color3.fromRGB(50, 130, 255)
HudStroke.Thickness = 1
HudStroke.Parent = HudFrame

local HudAvatar = Instance.new("ImageLabel")
HudAvatar.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
HudAvatar.BorderSizePixel = 0
HudAvatar.Position = UDim2.fromOffset(8, 8)
HudAvatar.Size = UDim2.fromOffset(56, 56)
HudAvatar.Parent = HudFrame

local HudAvatarCorner = Instance.new("UICorner")
HudAvatarCorner.CornerRadius = UDim.new(0, 6)
HudAvatarCorner.Parent = HudAvatar

local HudName = Instance.new("TextLabel")
HudName.BackgroundTransparency = 1
HudName.Position = UDim2.fromOffset(72, 6)
HudName.Size = UDim2.new(1, -80, 0, 16)
HudName.Font = Enum.Font.GothamBold
HudName.TextSize = 13
HudName.TextColor3 = Color3.fromRGB(255, 255, 255)
HudName.TextXAlignment = Enum.TextXAlignment.Left
HudName.TextTruncate = Enum.TextTruncate.AtEnd
HudName.Parent = HudFrame

local HudInfo = Instance.new("TextLabel")
HudInfo.BackgroundTransparency = 1
HudInfo.Position = UDim2.fromOffset(72, 24)
HudInfo.Size = UDim2.new(1, -80, 0, 14)
HudInfo.Font = Enum.Font.Gotham
HudInfo.TextSize = 11
HudInfo.TextColor3 = Color3.fromRGB(190, 190, 200)
HudInfo.TextXAlignment = Enum.TextXAlignment.Left
HudInfo.TextTruncate = Enum.TextTruncate.AtEnd
HudInfo.Parent = HudFrame

do
	local icon = Instance.new("ImageLabel")
	icon.Name = "WeaponIcon"
	icon.BackgroundTransparency = 1
	icon.BorderSizePixel = 0
	icon.Position = UDim2.fromOffset(72, 23)
	icon.Size = UDim2.fromOffset(30, 16)
	icon.ScaleType = Enum.ScaleType.Fit
	icon.Visible = false
	icon.Parent = HudFrame
end

local HudBarBg = Instance.new("Frame")
HudBarBg.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
HudBarBg.BorderSizePixel = 0
HudBarBg.Position = UDim2.fromOffset(72, 44)
HudBarBg.Size = UDim2.new(1, -80, 0, 8)
HudBarBg.Parent = HudFrame

local HudBarCorner = Instance.new("UICorner")
HudBarCorner.CornerRadius = UDim.new(1, 0)
HudBarCorner.Parent = HudBarBg

local HudBar = Instance.new("Frame")
HudBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
HudBar.BorderSizePixel = 0
HudBar.Size = UDim2.fromScale(1, 1)
HudBar.Parent = HudBarBg

local HudBarFillCorner = Instance.new("UICorner")
HudBarFillCorner.CornerRadius = UDim.new(1, 0)
HudBarFillCorner.Parent = HudBar

local HudHealth = Instance.new("TextLabel")
HudHealth.BackgroundTransparency = 1
HudHealth.Position = UDim2.fromOffset(72, 54)
HudHealth.Size = UDim2.new(1, -80, 0, 14)
HudHealth.Font = Enum.Font.GothamBold
HudHealth.TextSize = 11
HudHealth.TextColor3 = Color3.fromRGB(255, 255, 255)
HudHealth.TextXAlignment = Enum.TextXAlignment.Left
HudHealth.Parent = HudFrame

local function isVisibleTarget(part, model, origin)
	local ignore = { workspace.CurrentCamera }
	if LocalPlayer.Character then
		table.insert(ignore, LocalPlayer.Character)
	end
	local viewModels = workspace:FindFirstChild("ViewModels")
	if viewModels then
		table.insert(ignore, viewModels)
	end
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.IgnoreWater = true
	params.FilterDescendantsInstances = ignore
	for _ = 1, 8 do
		local result = workspace:Raycast(origin, part.Position - origin, params)
		if not result then
			return true
		end
		local hit = result.Instance
		if hit:IsDescendantOf(model) then
			return true
		end
		if hit.CanCollide == false or hit.Transparency >= 0.9 then
			table.insert(ignore, hit)
			params.FilterDescendantsInstances = ignore
			origin = result.Position
		else
			return false
		end
	end
	return false
end

local function getSilentTarget()
	if not SilentAim.Enabled then
		return nil
	end
	local camera = workspace.CurrentCamera
	local center = camera.ViewportSize / 2
	local nearest = SilentAim.TargetMode == "Nearest"
	local bestPart, bestModel, bestPlayer = nil, nil, nil
	local bestScore = nearest and math.huge or SilentAim.FovRadius
	for _, entity in ipairs(CollectionService:GetTagged("Entity")) do
		if entity == LocalPlayer.Character then
			continue
		end
		local fighter = getFighter(entity)
		local owner = fighter and fighter.Player
		if fighter and fighter.IsLocalPlayer then
			continue
		end
		if SilentAim.TeamCheck and owner and isTeammate(owner) then
			continue
		end
		if SilentAim.DuelOnly and not isDuelEnemy(owner) then
			continue
		end
		local humanoid = entity:FindFirstChildOfClass("Humanoid")
		if humanoid and humanoid.Health <= 0 then
			continue
		end
		local part = entity:FindFirstChild(SilentAim.HitPart, true)
		if not part or not part:IsA("BasePart") then
			continue
		end
		local score
		if nearest then
			score = (part.Position - camera.CFrame.Position).Magnitude
		else
			local screen, onScreen = camera:WorldToViewportPoint(part.Position)
			if not onScreen then
				continue
			end
			score = (Vector2.new(screen.X, screen.Y) - center).Magnitude
		end
		if score >= bestScore then
			continue
		end
		if SilentAim.Wallcheck and not isVisibleTarget(part, entity, camera.CFrame.Position) then
			continue
		end
		bestScore, bestPart, bestModel, bestPlayer = score, part, entity, owner
	end
	return bestPart, bestModel, bestPlayer
end

local function buildCameraData(origin, part)
	local cf = part.CFrame
	local data = {}
	data[utf8.char(1)] = {
		[utf8.char(0)] = Utility:EncodeCFrame(CFrame.lookAt(origin, part.Position)),
		[utf8.char(1)] = Utility:EncodeCFrame(cf),
		[utf8.char(2)] = part,
		[utf8.char(3)] = Utility:EncodeCFrame(cf:ToObjectSpace(CFrame.new(part.Position))),
	}
	return data
end

local gunOk, gunModule = pcall(require, LocalPlayer.PlayerScripts.Modules.ItemTypes.Gun)
if gunOk and gunModule and gunModule.IsFullyAiming then
	local originalAiming = gunModule.IsFullyAiming
	gunModule.IsFullyAiming = function(...)
		if SilentAim.Enabled then
			return true
		end
		return originalAiming(...)
	end
end

local originalRaycast = GameplayUtility.GetEntitiesFromRaycast
GameplayUtility.GetEntitiesFromRaycast = function(self, envID, params, origin, dir, maxDist, ...)
	local part = getSilentTarget()
	if part then
		local dist = (part.Position - origin).Magnitude
		dir = (part.Position - origin).Unit
		if dist > maxDist then
			maxDist = dist + 5
		end
	end
	return originalRaycast(self, envID, params, origin, dir, maxDist, ...)
end

local UseItem = ReplicatedStorage.Remotes.Replication.Fighter.UseItem
local originalFire
originalFire = hookfunction(UseItem.FireServer, newcclosure(function(self, objID, enumVal, camdata, extra)
	Settings.LastShotTime = os.clock()
	if SilentAim.Enabled and enumVal == EnumLibrary:ToEnum("StartShooting") then
		local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		local part = getSilentTarget()
		if root and part then
			camdata = buildCameraData(root.Position, part)
		end
	end
	return originalFire(self, objID, enumVal, camdata, extra)
end))

RunService.RenderStepped:Connect(function()
	local camera = workspace.CurrentCamera
	local center = camera.ViewportSize / 2

	local part, model, owner = getSilentTarget()

	local fovPosition = center
	if part and SilentAim.FovFollow then
		local screen = camera:WorldToViewportPoint(part.Position)
		fovPosition = Vector2.new(screen.X, screen.Y)
	end
	local diameter = SilentAim.FovRadius * 2
	local sequence = ColorSequence.new(SilentAim.FovColor, SilentAim.FovColor2)
	FovFrame.Position = UDim2.fromOffset(fovPosition.X, fovPosition.Y)
	FovFrame.Size = UDim2.fromOffset(diameter, diameter)
	FovFrame.BackgroundTransparency = SilentAim.FovFill and 0.75 or 1
	FovFillGradient.Enabled = SilentAim.FovFill and SilentAim.FovGradient
	FovStrokeGradient.Enabled = SilentAim.FovGradient
	if SilentAim.FovGradient then
		FovFillGradient.Color = sequence
		FovStrokeGradient.Color = sequence
		FovFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		FovStroke.Color = Color3.fromRGB(255, 255, 255)
	else
		FovFrame.BackgroundColor3 = SilentAim.FovColor
		FovStroke.Color = SilentAim.FovColor
	end
	FovFrame.Visible = SilentAim.Enabled and SilentAim.ShowFov

	if part and SilentAim.Snapline then
		local screen = camera:WorldToViewportPoint(part.Position)
		SnapLine.From = center
		SnapLine.To = Vector2.new(screen.X, screen.Y)
		SnapLine.Color = SilentAim.FovColor
		SnapLine.Visible = true
	else
		SnapLine.Visible = false
	end

	if part and SilentAim.HighlightTarget then
		TargetHighlight.Adornee = model
		TargetHighlight.Enabled = true
	else
		TargetHighlight.Adornee = nil
		TargetHighlight.Enabled = false
	end

	if part and SilentAim.TargetHud then
		local humanoid = model:FindFirstChildOfClass("Humanoid")
		local health = humanoid and math.clamp(humanoid.Health, 0, humanoid.MaxHealth) or 0
		local maxHealth = humanoid and humanoid.MaxHealth or 100
		local percent = maxHealth > 0 and health / maxHealth or 0
		local fighter = getFighter(model)
		local held = getHeldItem(fighter)
		local distance = math.floor((part.Position - camera.CFrame.Position).Magnitude)

		HudName.Text = owner and owner.DisplayName or model.Name
		HudInfo.Text = (held and tostring(held.Name) or "No Weapon") .. "  |  " .. distance .. " st"
		local weaponIcon = HudFrame.WeaponIcon
		local weaponImage = held and getItemImage(held) or nil
		if weaponImage then
			weaponIcon.Image = weaponImage
			weaponIcon.Visible = true
			HudInfo.Position = UDim2.fromOffset(106, 24)
			HudInfo.Size = UDim2.new(1, -114, 0, 14)
		else
			weaponIcon.Visible = false
			HudInfo.Position = UDim2.fromOffset(72, 24)
			HudInfo.Size = UDim2.new(1, -80, 0, 14)
		end
		HudBar.Size = UDim2.fromScale(percent, 1)
		HudBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0):Lerp(Color3.fromRGB(0, 255, 0), percent)
		HudHealth.Text = math.floor(health) .. " / " .. math.floor(maxHealth) .. " HP"
		if owner then
			HudAvatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. owner.UserId .. "&w=150&h=150"
		else
			HudAvatar.Image = ""
		end
		HudFrame.Visible = true
	else
		HudFrame.Visible = false
	end
end)

local GradientAnim = {
	Enabled = false,
	Speed = 2,
}

local BaseRotations = setmetatable({}, { __mode = "k" })

local function animateGradient(gradient, elapsed)
	if not gradient or not gradient.Parent then
		return
	end
	if BaseRotations[gradient] == nil then
		BaseRotations[gradient] = gradient.Rotation
	end
	local target = BaseRotations[gradient]
	if GradientAnim.Enabled then
		target = (target + elapsed * 90 * GradientAnim.Speed) % 360
	end
	if gradient.Rotation ~= target then
		gradient.Rotation = target
	end
end

RunService.RenderStepped:Connect(function()
	local elapsed = os.clock()
	for _, obj in pairs(Objects) do
		for _, value in pairs(obj) do
			if typeof(value) == "Instance" and value:IsA("UIGradient") then
				animateGradient(value, elapsed)
			end
		end
	end
	animateGradient(FovFillGradient, elapsed)
	animateGradient(FovStrokeGradient, elapsed)
end)

local UserInputService = game:GetService("UserInputService")

local Trigger = {
	Enabled = false,
	TeamCheck = true,
	HitPart = "Any",
	MaxDistance = 500,
	Delay = 0,
	HoldTime = 40,
	Cooldown = 80,
}

local triggerBusy = false
local lastShot = 0

local function shootStart()
	local fighter = FighterController.LocalFighter
	if not fighter then
		return false
	end
	return (pcall(function()
		fighter:Input("StartShooting")
	end))
end

local function shootEnd()
	local fighter = FighterController.LocalFighter
	if not fighter then
		return false
	end
	return (pcall(function()
		fighter:Input("FinishShooting")
	end))
end

local function getTriggerTarget()
	local camera = workspace.CurrentCamera
	local center = camera.ViewportSize / 2
	local ray = camera:ViewportPointToRay(center.X, center.Y)
	local ignore = { camera }
	if LocalPlayer.Character then
		table.insert(ignore, LocalPlayer.Character)
	end
	local viewModels = workspace:FindFirstChild("ViewModels")
	if viewModels then
		table.insert(ignore, viewModels)
	end
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.IgnoreWater = true
	params.FilterDescendantsInstances = ignore

	local origin = ray.Origin
	local remaining = Trigger.MaxDistance

	for _ = 1, 10 do
		local result = workspace:Raycast(origin, ray.Direction * remaining, params)
		if not result then
			return false
		end
		local hit = result.Instance
		local entity = hit
		while entity and not CollectionService:HasTag(entity, "Entity") do
			entity = entity.Parent
		end
		if entity then
			if entity == LocalPlayer.Character then
				return false
			end
			local fighter = getFighter(entity)
			local owner = fighter and fighter.Player
			if fighter and fighter.IsLocalPlayer then
				return false
			end
			if Trigger.TeamCheck and owner and isTeammate(owner) then
				return false
			end
			local humanoid = entity:FindFirstChildOfClass("Humanoid")
			if humanoid and humanoid.Health <= 0 then
				return false
			end
			local isHead = string.find(string.lower(hit.Name), "head") ~= nil
			if Trigger.HitPart == "Head" and not isHead then
				return false
			end
			if Trigger.HitPart == "Body" and isHead then
				return false
			end
			return true
		end
		if hit.CanCollide == false or hit.Transparency >= 0.9 then
			table.insert(ignore, hit)
			params.FilterDescendantsInstances = ignore
			remaining = remaining - (result.Position - origin).Magnitude
			origin = result.Position
			if remaining <= 0 then
				return false
			end
		else
			return false
		end
	end
	return false
end

RunService.Heartbeat:Connect(function()
	if not Trigger.Enabled or triggerBusy then
		return
	end
	if UserInputService:GetFocusedTextBox() then
		return
	end
	if os.clock() - lastShot < Trigger.Cooldown / 1000 then
		return
	end
	if not getTriggerTarget() then
		return
	end
	triggerBusy = true
	task.spawn(function()
		if Trigger.Delay > 0 then
			task.wait(Trigger.Delay / 1000)
		end
		if Trigger.Enabled and getTriggerTarget() then
			shootStart()
			task.wait(Trigger.HoldTime / 1000)
			shootEnd()
			lastShot = os.clock()
		end
		triggerBusy = false
	end)
end)

local function addToggle(section, name, key)
	section:AddToggle({
		Name = name,
		Default = Settings[key],
		Flag = "Esp" .. key,
		Callback = function(Value)
			Settings[key] = Value
		end,
	})
end

local function addColor(section, name, key)
	section:AddColorPicker({
		Name = name,
		Default = Settings[key],
		Flag = "Esp" .. key,
		Callback = function(Color)
			Settings[key] = Color
		end,
	})
end

local General = Esp:AddSection("General", "Left", "settings", "espgeneral")
addToggle(General, "Enable ESP", "Enabled")
addToggle(General, "Team Check", "TeamCheck")
General:AddSlider({
	Name = "Max Distance",
	Min = 50,
	Max = 5000,
	Default = Settings.MaxDistance,
	Increment = 10,
	Suffix = " st",
	Flag = "EspMaxDistance",
	Callback = function(Value)
		Settings.MaxDistance = Value
	end,
})
addColor(General, "Gradient Color 1", "GradientColor1")
addColor(General, "Gradient Color 2", "GradientColor2")
General:AddToggle({
	Name = "Gradient Animation",
	Default = GradientAnim.Enabled,
	Flag = "GradientAnimEnabled",
	Callback = function(Value)
		GradientAnim.Enabled = Value
	end,
})
General:AddSlider({
	Name = "Animation Speed",
	Min = 1,
	Max = 10,
	Default = GradientAnim.Speed,
	Increment = 1,
	Suffix = "x",
	Flag = "GradientAnimSpeed",
	Callback = function(Value)
		GradientAnim.Speed = Value
	end,
})

local BoxSection = Esp:AddSection("Box", "Left", "square", "espbox")
addToggle(BoxSection, "Box", "Box")
addToggle(BoxSection, "Box Gradient", "BoxGradient")
addToggle(BoxSection, "Glow", "Glow")
addToggle(BoxSection, "Glow Gradient", "GlowGradient")
addColor(BoxSection, "Glow Color", "GlowColor")
BoxSection:AddSlider({
	Name = "Glow Transparency",
	Min = 0,
	Max = 100,
	Default = Settings.GlowTransparency * 100,
	Increment = 1,
	Suffix = "%",
	Flag = "EspGlowTransparency",
	Callback = function(Value)
		Settings.GlowTransparency = Value / 100
	end,
})

local InfoSection = Esp:AddSection("Info", "Right", "user", "espinfo")
addToggle(InfoSection, "Name", "Name")
addToggle(InfoSection, "Display Name", "DisplayName")
addToggle(InfoSection, "Name Gradient", "NameGradient")
addToggle(InfoSection, "Avatar", "Avatar")
addToggle(InfoSection, "Distance", "Distance")
addToggle(InfoSection, "Distance Gradient", "DistanceGradient")

local HealthSection = Esp:AddSection("Health", "Right", "heart", "esphealth")
addToggle(HealthSection, "Health Bar", "HealthBar")
addToggle(HealthSection, "Health Bar Gradient", "HealthBarGradient")
addToggle(HealthSection, "Health Text", "HealthText")
addToggle(HealthSection, "Health Text Gradient", "HealthTextGradient")

local ItemSection = Esp:AddSection("Items", "Right", "backpack", "espitems")
addToggle(ItemSection, "Weapon", "Weapon")
addToggle(ItemSection, "Weapon Text", "WeaponText")
addToggle(ItemSection, "Weapon Image", "WeaponImage")
ItemSection:AddSlider({
	Name = "Weapon Image Size",
	Min = 20,
	Max = 120,
	Default = Settings.WeaponImageSize,
	Increment = 2,
	Suffix = " px",
	Flag = "EspWeaponImageSize",
	Callback = function(Value)
		Settings.WeaponImageSize = Value
	end,
})
addToggle(ItemSection, "Weapon Ammo", "WeaponAmmo")
addToggle(ItemSection, "Weapon Gradient", "WeaponGradient")
addToggle(ItemSection, "Backpack", "Backpack")
addToggle(ItemSection, "Backpack Gradient", "BackpackGradient")

local function addSilentToggle(section, name, key)
	section:AddToggle({
		Name = name,
		Default = SilentAim[key],
		Flag = "Silent" .. key,
		Callback = function(Value)
			SilentAim[key] = Value
		end,
	})
end

local SilentTab = Rage:AddSubTab("Silent Aim", "crosshair")
local SilentSection = SilentTab:AddSection("Silent Aim", "Left", "crosshair", "silentaim")
addSilentToggle(SilentSection, "Enable", "Enabled")
addSilentToggle(SilentSection, "Show FOV", "ShowFov")
SilentSection:AddColorPicker({
	Name = "FOV Color",
	Default = SilentAim.FovColor,
	Flag = "SilentFovColor",
	Callback = function(Color)
		SilentAim.FovColor = Color
	end,
})
SilentSection:AddColorPicker({
	Name = "FOV Color 2",
	Default = SilentAim.FovColor2,
	Flag = "SilentFovColor2",
	Callback = function(Color)
		SilentAim.FovColor2 = Color
	end,
})
addSilentToggle(SilentSection, "FOV Fill", "FovFill")
addSilentToggle(SilentSection, "FOV Gradient", "FovGradient")
addSilentToggle(SilentSection, "FOV Follow Enemy", "FovFollow")
SilentSection:AddDropdown({
	Name = "Target Mode",
	Options = { "Fov", "Nearest" },
	Default = SilentAim.TargetMode,
	Flag = "SilentTargetMode",
	Callback = function(Value)
		SilentAim.TargetMode = Value
	end,
})
SilentSection:AddSlider({
	Name = "FOV Radius",
	Min = 20,
	Max = 800,
	Default = SilentAim.FovRadius,
	Increment = 1,
	Suffix = " px",
	Flag = "SilentFovRadius",
	Callback = function(Value)
		SilentAim.FovRadius = Value
	end,
})
SilentSection:AddDropdown({
	Name = "Hit Part",
	Options = { "Head", "UpperTorso", "HumanoidRootPart" },
	Default = SilentAim.HitPart,
	Flag = "SilentHitPart",
	Callback = function(Value)
		SilentAim.HitPart = Value
	end,
})

local SilentExtras = SilentTab:AddSection("Silent Aim Extras", "Right", "sliders-horizontal", "silentextras")
addSilentToggle(SilentExtras, "FOV Snapline", "Snapline")
addSilentToggle(SilentExtras, "Highlight Target", "HighlightTarget")
addSilentToggle(SilentExtras, "Wallcheck", "Wallcheck")
addSilentToggle(SilentExtras, "Target HUD", "TargetHud")
addSilentToggle(SilentExtras, "Team Check", "TeamCheck")
addSilentToggle(SilentExtras, "Duel Enemies Only", "DuelOnly")


do
	local repS = cloneref(game:GetService("ReplicatedStorage"))
	local plrs = cloneref(game:GetService("Players"))
	local runS = cloneref(game:GetService("RunService"))
	local ws = cloneref(game:GetService("Workspace"))
	local lplr = plrs.LocalPlayer
	local util = require(repS.Modules.Utility)
	local enum = require(repS.Modules.EnumLibrary)
	local FighterController = require(lplr.PlayerScripts.Controllers.FighterController)

	local RageBot = {
		Enabled = false,
		ChangeOnReload = false,
		FireRate = 0.0005,
		TargetMode = "Closest",
		HitPart = "Head",
		MaxDistance = 500,
		WallCheck = false,
		AntiHit = true,
		Jitter = true,
		Height = 22,
		Radius = 24,
		FirePad = 0,
		SkipImmune = true,
		MaxShotsPerStep = 3,
		GapScale = 0.92,
	}

	local stickyPlayer = nil
	local cachedKnife = {}
	local cachedEnemies = {}
	local cacheTime = 0

	local chain = { 1, 2, 3 }
	local pending = nil
	local rng = Random.new()
	local infoOriginals = setmetatable({}, { __mode = "k" })

	local function isItemEmpty(item)
		local ok, ammo, reserve, infAmmo, infReserve = pcall(function()
			return item:GetAmmoVariables()
		end)
		if not ok or ammo == nil or infAmmo then
			return false
		end
		if ammo > 0 then
			return false
		end
		if infReserve then
			return false
		end
		return reserve == nil or reserve <= 0
	end

	local reloadUntil = {}

	local function getSlotNumber()
		local localFighter = FighterController.LocalFighter
		local items = localFighter and localFighter.Items
		if not items then
			return chain[1]
		end
		for _, slot in ipairs(chain) do
			local item = items[slot]
			if item and not isItemEmpty(item) then
				local busy = RageBot.ChangeOnReload and reloadUntil[slot] and tick() < reloadUntil[slot]
				if not busy then
					return slot
				end
			end
		end
		return 3
	end

	task.spawn(function()
		local localFighter = FighterController.LocalFighter
		while not localFighter do
			task.wait(0.1)
			localFighter = FighterController.LocalFighter
		end
		pcall(function()
			localFighter:EquipItem(getSlotNumber())
		end)
	end)

	local lastEquipCheck = 0

	local function ensureEquipped()
		if tick() - lastEquipCheck < 0.2 then return end
		lastEquipCheck = tick()
		local localFighter = FighterController.LocalFighter
		if not localFighter or not localFighter.Items then return end
		local wanted = getSlotNumber()
		local current = localFighter.EquippedItem and table.find(localFighter.Items, localFighter.EquippedItem)
		if current ~= wanted then
			pcall(function()
				localFighter:EquipItem(wanted)
			end)
		end
	end

	local lastFire = 0
	local deflecting = {}
	plrs.PlayerRemoving:Connect(function(player)
		deflecting[player] = nil
	end)

	local function updateDeflection()
		if not FighterController or not FighterController.Objects then return end
		for _, fighterObj in FighterController.Objects do
			local player = fighterObj.Player
			if not player then continue end
			if not fighterObj.Entity or not fighterObj.Entity:IsAlive() or fighterObj:Get("IsSpectating") then
				deflecting[player] = false
				continue
			end
			local equipped = fighterObj.EquippedItem
			local isKatana = equipped and equipped.ViewModel and equipped.ViewModel.Name == "Katana"
			local isDeflecting = false
			if isKatana then
				isDeflecting = (equipped._attack_cooldown and equipped._attack_cooldown > tick()) or false
			end
			deflecting[player] = isDeflecting
		end
	end

	local function isEnemy(player)
		if player == lplr then return false end
		return isDuelEnemy(player)
	end

	local function isTargetImmune(player)
		local ok, immune = pcall(function()
			local fighter = FighterController:GetFighter(player)
			local entity = fighter and fighter.Entity
			return entity and entity:Get("IsInvincible")
		end)
		return ok and immune and true or false
	end

	local function getHitPart(pChar)
		local part = pChar:FindFirstChild(RageBot.HitPart, true)
		if part and part:IsA("BasePart") then
			return part
		end
		local head = pChar:FindFirstChild("Head")
		if head and head:IsA("BasePart") then
			return head
		end
		return nil
	end

	local function collectTargets(myRoot)
		local list = {}
		local camera = ws.CurrentCamera
		local viewport = camera and camera.ViewportSize / 2
		for _, player in plrs:GetPlayers() do
			if not isEnemy(player) then continue end
			if deflecting[player] then continue end
			if RageBot.SkipImmune and isTargetImmune(player) then continue end
			local pChar = player.Character
			if not pChar then continue end
			local pRoot = pChar:FindFirstChild("HumanoidRootPart")
			local pHum = pChar:FindFirstChildWhichIsA("Humanoid")
			local part = getHitPart(pChar)
			if not (pRoot and part and pHum and pHum.Health > 0) then continue end
			local dist = (myRoot.Position - pRoot.Position).Magnitude
			if dist > RageBot.MaxDistance then continue end
			local score = dist
			if player == stickyPlayer then
				score = score * 0.6
			end
			if RageBot.TargetMode == "Lowest Health" then
				score = pHum.Health * 1000 + dist
			elseif RageBot.TargetMode == "Crosshair" and camera then
				local screen, onScreen = camera:WorldToViewportPoint(pRoot.Position)
				if onScreen and screen.Z > 0 then
					score = (Vector2.new(screen.X, screen.Y) - viewport).Magnitude
				else
					score = 100000 + dist
				end
			end
			table.insert(list, {
				player = player,
				model = pChar,
				root = pRoot,
				part = part,
				score = score,
			})
		end
		table.sort(list, function(a, b)
			return a.score < b.score
		end)
		return list
	end

	local knifeSafeRange = 16

	local function getKnifeRoots()
		local roots = {}
		local viewModels = ws:FindFirstChild("ViewModels")
		if not viewModels then
			return roots
		end
		for _, model in viewModels:GetChildren() do
			if model:IsA("Model") and string.find(model.Name, "Knife", 1, true) then
				for _, player in plrs:GetPlayers() do
					if player ~= lplr and string.find(model.Name, player.Name, 1, true) then
						local pChar = player.Character
						local pRoot = pChar and pChar:FindFirstChild("HumanoidRootPart")
						if pRoot and isEnemy(player) then
							table.insert(roots, pRoot)
						end
						break
					end
				end
			end
		end
		return roots
	end

	local function getEnemyRoots(exclude)
		local roots = {}
		for _, player in plrs:GetPlayers() do
			if player ~= exclude and isEnemy(player) then
				local pChar = player.Character
				local pRoot = pChar and pChar:FindFirstChild("HumanoidRootPart")
				if pRoot then
					table.insert(roots, pRoot)
				end
			end
		end
		return roots
	end

	local function minDistance(position, roots)
		local best = math.huge
		for _, root in roots do
			local d = (root.Position - position).Magnitude
			if d < best then
				best = d
			end
		end
		return best
	end

	local rayParams = RaycastParams.new()
	rayParams.FilterType = Enum.RaycastFilterType.Exclude
	rayParams.IgnoreWater = true
	local rayTime = 0
	local lastDesync = nil
	local cachedThreats = {}

	local function refreshRayFilter()
		local now = tick()
		if now - rayTime < 0.25 then
			return
		end
		rayTime = now
		local ignore = {}
		for _, player in plrs:GetPlayers() do
			if player.Character then
				table.insert(ignore, player.Character)
			end
		end
		local camera = ws.CurrentCamera
		if camera then
			table.insert(ignore, camera)
		end
		local viewModels = ws:FindFirstChild("ViewModels")
		if viewModels then
			table.insert(ignore, viewModels)
		end
		rayParams.FilterDescendantsInstances = ignore
	end

	local function isBlocked(fromPos, toPos)
		local result = ws:Raycast(fromPos, toPos - fromPos, rayParams)
		if not result then
			return false
		end
		local hit = result.Instance
		return hit.CanCollide and hit.Transparency < 0.9
	end

	local function getThreats()
		local list = {}
		local now = tick()
		if not FighterController.Objects then
			return list
		end
		for _, fighterObj in FighterController.Objects do
			local player = fighterObj.Player
			if player and isEnemy(player) then
				local pChar = player.Character
				local pHead = pChar and pChar:FindFirstChild("Head")
				local equipped = fighterObj.EquippedItem
				if pHead and equipped then
					local ok, cooldown = pcall(function()
						return equipped._shoot_cooldown or equipped._attack_cooldown or 0
					end)
					local ready = not ok or (cooldown - now) < 0.25
					table.insert(list, { pos = pHead.Position, ready = ready })
				end
			end
		end
		return list
	end

	local function refreshCache()
		local now = tick()
		if now - cacheTime < 0.03 then
			return
		end
		cacheTime = now
		cachedKnife = getKnifeRoots()
		cachedEnemies = getEnemyRoots(nil)
		cachedThreats = getThreats()
	end

	local function pickDesyncPosition(target)
		local base = target.part.Position
		if not RageBot.AntiHit then
			return (target.root.CFrame * CFrame.new(0, 1, 2)).Position
		end
		refreshRayFilter()
		local readyThreats = {}
		for _, threat in cachedThreats do
			if threat.ready and #readyThreats < 3 then
				table.insert(readyThreats, threat)
			end
		end
		local attempts = #readyThreats > 0 and 12 or 6
		local bestPos = nil
		local bestScore = -math.huge
		for _ = 1, attempts do
			local angle = rng:NextNumber(0, math.pi * 2)
			local radius = rng:NextNumber(4, RageBot.Radius)
			local height = RageBot.Height + rng:NextNumber(0, 14)
			local position = base + Vector3.new(math.cos(angle) * radius, height, math.sin(angle) * radius)
			if minDistance(position, cachedKnife) >= knifeSafeRange then
				local score = math.min(minDistance(position, cachedEnemies), 150) * 0.5
				if lastDesync then
					score = score + math.min((position - lastDesync).Magnitude, 40)
				end
				for _, threat in readyThreats do
					if isBlocked(threat.pos, position) then
						score = score + 40
					end
				end
				if score > bestScore then
					bestScore = score
					bestPos = position
				end
			end
		end
		if not bestPos then
			bestPos = base + Vector3.new(0, RageBot.Height + 24, 0)
		end
		lastDesync = bestPos
		return bestPos
	end

	local burstShots = 0
	local lastItem = nil

	local function getReloadRemaining(item)
		local ok, remaining = pcall(function()
			if item.Info.MaxAmmo and item._reload_cooldown then
				return item._reload_cooldown - tick()
			end
			return 0
		end)
		if ok and remaining then
			return remaining
		end
		return 0
	end

	local function needsReload(item)
		local ok, need = pcall(function()
			if not item.Info.MaxAmmo then
				return false
			end
			local ammo, reserve, infAmmo, infReserve = item:GetAmmoVariables()
			if ammo == nil or infAmmo or ammo > 0 then
				return false
			end
			return infReserve or (reserve ~= nil and reserve > 0)
		end)
		return ok and need or false
	end

	local function handleReload()
		local localFighter = FighterController.LocalFighter
		local item = localFighter and localFighter.EquippedItem
		if not item then
			return
		end
		local remaining = getReloadRemaining(item)
		if remaining > 0 then
			if RageBot.ChangeOnReload and localFighter.Items then
				local slot = table.find(localFighter.Items, item)
				if slot then
					reloadUntil[slot] = tick() + remaining
				end
			end
			return
		end
		if needsReload(item) then
			pcall(function()
				item:SimulateInputFromGameplayMechanic("StartReloading")
			end)
		end
	end

	local function isLocalFrozen()
		local localFighter = FighterController.LocalFighter
		local entity = localFighter and localFighter.Entity
		if not entity then
			return false
		end
		local ok, frozen = pcall(function()
			return entity:Get("IsFrozen")
		end)
		return ok and frozen and true or false
	end

	local function isItemReady(item)
		local ok, ready = pcall(function()
			if item:IsEquipping() then
				return false
			end
			local ammo = item:Get("Ammo")
			if type(ammo) == "number" and ammo <= 0 then
				return false
			end
			if item.Info.MaxAmmo and item._reload_cooldown and tick() < item._reload_cooldown then
				return false
			end
			return true
		end)
		if not ok then
			return true
		end
		return ready
	end

	local function getFireGap(item)
		local pad = RageBot.FirePad / 1000
		local ok, gap = pcall(function()
			local info = item.Info
			local saved = infoOriginals[info] or {}
			local base = saved.ShootCooldown or info.ShootCooldown or info.AttackCooldown
			if not base or base <= 0 then
				return RageBot.FireRate
			end
			local burst = info.BurstCount
			local burstCooldown = saved.BurstCooldown or info.BurstCooldown
			if burst and burst > 1 and burstCooldown and burstShots % burst ~= 0 then
				return burstCooldown * RageBot.GapScale + pad
			end
			return base * RageBot.GapScale + pad
		end)
		if ok and gap then
			return gap
		end
		return RageBot.FireRate
	end

	local function restore()
		if pending then
			local data = pending
			pending = nil
			if data.root and data.root.Parent then
				data.root.CFrame = data.cf
				data.root.AssemblyLinearVelocity = data.vel
				data.root.AssemblyAngularVelocity = data.rot
			end
		end
	end

	runS:BindToRenderStep("__ragerestore", 101, restore)

	local function step()
		if not RageBot.Enabled then
			return
		end

		restore()
		handleReload()
		ensureEquipped()
		updateDeflection()

		if isLocalFrozen() then
			return
		end

		local char = lplr.Character
		local myRoot = char and char:FindFirstChild("HumanoidRootPart")
		if not myRoot then return end
		local localFighter = FighterController.LocalFighter
		if not localFighter then return end
		local item = localFighter.EquippedItem
		if not item then return end

		local targets = collectTargets(myRoot)
		local target = targets[1]
		if not target then
			stickyPlayer = nil
			return
		end
		stickyPlayer = target.player

		refreshCache()
		local desyncPos = pickDesyncPosition(target)
		local desyncCF = CFrame.lookAt(desyncPos, target.part.Position)
		pending = {
			root = myRoot,
			cf = myRoot.CFrame,
			vel = myRoot.AssemblyLinearVelocity,
			rot = myRoot.AssemblyAngularVelocity,
		}
		myRoot.CFrame = desyncCF
		myRoot.AssemblyLinearVelocity = Vector3.zero
		myRoot.AssemblyAngularVelocity = Vector3.zero

		if item ~= lastItem then
			lastItem = item
			burstShots = 0
		end
		if not isItemReady(item) then return end

		local now = tick()
		local gap = getFireGap(item)
		local elapsed = now - lastFire
		if elapsed < gap then return end
		local shots = math.min(math.floor(elapsed / gap), RageBot.MaxShotsPerStep)
		if shots < 1 then shots = 1 end
		lastFire = now

		local targetPart = target.part
		local targetPos = targetPart.Position
		local aimCF = CFrame.lookAt(desyncPos, targetPos)
		local targetCF = targetPart.CFrame
		local objSpaceOffset = targetCF:ToObjectSpace(CFrame.new(targetPos))
		local encodedAim = util:EncodeCFrame(aimCF)
		local encodedTarget = util:EncodeCFrame(targetCF)
		local encodedOffset = util:EncodeCFrame(objSpaceOffset)
		local objectId = item:Get("ObjectID")
		local startShooting = enum:ToEnum("StartShooting")
		local remote = repS.Remotes.Replication.Fighter.UseItem

		for _ = 1, shots do
			burstShots = burstShots + 1
			local cameradata = {}
			cameradata[utf8.char(1)] = {
				[utf8.char(0)] = encodedAim,
				[utf8.char(1)] = encodedTarget,
				[utf8.char(2)] = targetPart,
				[utf8.char(3)] = encodedOffset
			}
			remote:FireServer(objectId, startShooting, cameradata, nil)
		end
	end

	local function safeStep()
		local ok = pcall(step)
		if not ok then
			restore()
		end
	end

	runS.PreSimulation:Connect(safeStep)
	runS.Heartbeat:Connect(safeStep)

	local RageBotTab = Rage:AddSubTab("Ragebot", "skull")
	local RageBotSection = RageBotTab:AddSection("Ragebot", "Left", "skull", "ragebotmain")
	RageBotSection:AddToggle({
		Name = "Ragebot",
		Default = RageBot.Enabled,
		Flag = "RagebotEnabled",
		Callback = function(Value)
			RageBot.Enabled = Value
			if Value then
				local localFighter = FighterController.LocalFighter
				if localFighter then
					pcall(function()
						localFighter:EquipItem(getSlotNumber())
					end)
				end
			end
		end,
	})
	RageBotSection:AddToggle({
		Name = "Change Gun On Reload",
		Default = RageBot.ChangeOnReload,
		Flag = "RagebotChangeOnReload",
		Callback = function(Value)
			RageBot.ChangeOnReload = Value
			for slot in pairs(reloadUntil) do
				reloadUntil[slot] = nil
			end
		end,
	})

	local GunMods = {
		NoRecoil = false,
		NoSpread = false,
		FireRate = false,
		FireRateMultiplier = 1.5,
	}

	if gunOk and type(gunModule) == "table" then
		if type(gunModule._Recoil) == "function" then
			local originalRecoil = gunModule._Recoil

			gunModule._Recoil = function(self, ...)
				if GunMods.NoRecoil then
					return
				end

				return originalRecoil(self, ...)
			end
		end

		if type(gunModule.StartShooting) == "function" then
			local originalStartShooting = gunModule.StartShooting

			gunModule.StartShooting = function(self, ...)
				local results = table.pack(originalStartShooting(self, ...))

				if GunMods.FireRate and results[1] then
					pcall(function()
						local remaining = self._shoot_cooldown - tick()

						if remaining > 0 then
							self._shoot_cooldown = tick() + remaining / GunMods.FireRateMultiplier
						end
					end)
				end

				return table.unpack(results, 1, results.n)
			end
		end
	end

	if type(GameplayUtility.GetSpread) == "function" then
		local originalGetSpread = GameplayUtility.GetSpread

		GameplayUtility.GetSpread = function(self, ...)
			if GunMods.NoSpread then
				return CFrame.identity
			end

			return originalGetSpread(self, ...)
		end
	end

	local GunModsSection = RageBotTab:AddSection("Gun Mods", "Right", "crosshair", "ragebotgunmods")
	GunModsSection:AddToggle({
		Name = "No Recoil",
		Default = GunMods.NoRecoil,
		Flag = "GunModsNoRecoil",
		Callback = function(Value)
			GunMods.NoRecoil = Value
		end,
	})
	GunModsSection:AddToggle({
		Name = "No Spread",
		Default = GunMods.NoSpread,
		Flag = "GunModsNoSpread",
		Callback = function(Value)
			GunMods.NoSpread = Value
		end,
	})
	GunModsSection:AddToggle({
		Name = "Fire Rate",
		Default = GunMods.FireRate,
		Flag = "GunModsFireRate",
		Callback = function(Value)
			GunMods.FireRate = Value
		end,
	})
	GunModsSection:AddSlider({
		Name = "Fire Rate Multiplier",
		Min = 1,
		Max = 3,
		Default = GunMods.FireRateMultiplier,
		Increment = 0.1,
		Suffix = "x",
		Flag = "GunModsFireRateMultiplier",
		Callback = function(Value)
			GunMods.FireRateMultiplier = Value
		end,
	})

	local InfoMods = {
		NoRecoil = false,
		NoSpread = false,
		InstantProjectile = false,
		NoCooldown = false,
		FastReload = false,
		FastEquip = false,
		ExtendedRange = false,
	}

	local fixedRules = {
		{ mod = "NoRecoil", keys = { "ShootRecoil" }, value = 0 },
		{ mod = "NoSpread", keys = { "ShootSpread" }, value = 0 },
		{ mod = "InstantProjectile", keys = { "ProjectileSpeed" }, value = 99999999 },
		{ mod = "NoCooldown", keys = { "ShootCooldown", "QuickShotCooldown", "BurstCooldown" }, value = 0 },
	}

	local function matchReload(key)
		return string.find(key, "Reload", 1, true) and (string.find(key, "Time", 1, true) or string.find(key, "Cooldown", 1, true)) and not string.find(key, "Ammo", 1, true)
	end

	local function matchEquip(key)
		return string.find(key, "Equip", 1, true) and (string.find(key, "Time", 1, true) or string.find(key, "Cooldown", 1, true) or string.find(key, "Duration", 1, true))
	end

	local function matchRange(key)
		return string.find(key, "Range", 1, true) or string.find(key, "MaxDistance", 1, true)
	end

	local scaleRules = {
		{ mod = "FastReload", match = matchReload, scale = 0.25 },
		{ mod = "FastEquip", match = matchEquip, scale = 0.1 },
		{ mod = "ExtendedRange", match = matchRange, scale = 5 },
	}

	local function applyInfoMods(item)
		local info = type(item) == "table" and item.Info
		if type(info) ~= "table" then
			return
		end
		local saved = infoOriginals[info]
		if not saved then
			saved = {}
			infoOriginals[info] = saved
		end
		local function setField(key, enabled, value, scale)
			local current = info[key]
			if type(current) ~= "number" then
				return
			end
			if saved[key] == nil then
				saved[key] = current
			end
			if enabled then
				info[key] = value or saved[key] * scale
			else
				info[key] = saved[key]
			end
		end
		for _, rule in ipairs(fixedRules) do
			for _, key in ipairs(rule.keys) do
				setField(key, InfoMods[rule.mod], rule.value, nil)
			end
		end
		local keys = {}
		for key, value in pairs(info) do
			if type(key) == "string" and type(value) == "number" then
				table.insert(keys, key)
			end
		end
		for _, rule in ipairs(scaleRules) do
			for _, key in ipairs(keys) do
				if rule.match(key) then
					setField(key, InfoMods[rule.mod], nil, rule.scale)
				end
			end
		end
	end

	local infoModule = nil
	local inputOld = nil

	local function anyInfoMod()
		for _, enabled in pairs(InfoMods) do
			if enabled then
				return true
			end
		end
		return false
	end

	local function ensureInfoHook()
		if inputOld then
			return
		end
		local ok, mod = pcall(function()
			return require(lplr.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem)
		end)
		if not ok or type(mod) ~= "table" or type(mod.Input) ~= "function" then
			return
		end
		infoModule = mod
		inputOld = hookfunction(mod.Input, function(self, ...)
			applyInfoMods(self)
			return inputOld(self, ...)
		end)
	end

	local function removeInfoHook()
		if not inputOld or not infoModule then
			return
		end
		pcall(function()
			hookfunction(infoModule.Input, inputOld)
		end)
		inputOld = nil
		infoModule = nil
	end

	local function refreshInfoMods()
		local localFighter = FighterController.LocalFighter
		local items = localFighter and localFighter.Items
		if items then
			for _, item in pairs(items) do
				applyInfoMods(item)
			end
		end
		if anyInfoMod() then
			ensureInfoHook()
		else
			removeInfoHook()
		end
	end

	local function addInfoToggle(name, key, flag)
		GunModsSection:AddToggle({
			Name = name,
			Default = InfoMods[key],
			Flag = flag,
			Callback = function(Value)
				InfoMods[key] = Value
				refreshInfoMods()
			end,
		})
	end

	addInfoToggle("Instant Projectile", "InstantProjectile", "GunModsInstantProjectile")
	addInfoToggle("No Cooldown", "NoCooldown", "GunModsNoCooldown")
	addInfoToggle("Fast Reload", "FastReload", "GunModsFastReload")
	addInfoToggle("Fast Equip", "FastEquip", "GunModsFastEquip")
	addInfoToggle("Extended Range", "ExtendedRange", "GunModsExtendedRange")
	addInfoToggle("Info No Recoil", "NoRecoil", "GunModsInfoNoRecoil")
	addInfoToggle("Info No Spread", "NoSpread", "GunModsInfoNoSpread")
end

do
	local Aimbot = {
		Enabled = false,
		Mode = "While Shooting",
		HitPart = "Closest",
		TeamCheck = true,
		DuelOnly = false,
		VisibleCheck = true,
		Sticky = true,
		MaxDistance = 500,
		FovRadius = 120,
		ShowFov = true,
		FovColor = Color3.fromRGB(255, 255, 255),
		Speed = 30,
		Horizontal = 100,
		Vertical = 70,
		Humanize = true,
		YieldToInput = true,
	}

	local okAimCamera, AimCamera = pcall(function()
		return require(LocalPlayer.PlayerScripts.Controllers.CameraController)
	end)

	local AimbotGui = Instance.new("ScreenGui")
	AimbotGui.Name = "LegitAimbotFov"
	AimbotGui.ResetOnSpawn = false
	AimbotGui.IgnoreGuiInset = true
	AimbotGui.DisplayOrder = 49
	AimbotGui.Parent = gethui and gethui() or game:GetService("CoreGui")

	local AimbotFov = Instance.new("Frame")
	AimbotFov.AnchorPoint = Vector2.new(0.5, 0.5)
	AimbotFov.BackgroundTransparency = 1
	AimbotFov.BorderSizePixel = 0
	AimbotFov.Visible = false
	AimbotFov.Parent = AimbotGui

	local AimbotFovCorner = Instance.new("UICorner")
	AimbotFovCorner.CornerRadius = UDim.new(1, 0)
	AimbotFovCorner.Parent = AimbotFov

	local AimbotFovStroke = Instance.new("UIStroke")
	AimbotFovStroke.Thickness = 1.5
	AimbotFovStroke.Color = Aimbot.FovColor
	AimbotFovStroke.Parent = AimbotFov

	local aimbotTarget = nil
	local lastUserInput = 0
	local noiseSeed = math.random() * 100

	local function getAimParts(entity)
		local parts = {}

		if Aimbot.HitPart == "Closest" then
			for _, name in ipairs({ "Head", "UpperTorso", "HumanoidRootPart" }) do
				local part = entity:FindFirstChild(name, true)

				if part and part:IsA("BasePart") then
					table.insert(parts, part)
				end
			end
		else
			local part = entity:FindFirstChild(Aimbot.HitPart, true)

			if part and part:IsA("BasePart") then
				table.insert(parts, part)
			end
		end

		return parts
	end

	local function isAimEntityValid(entity)
		if not entity.Parent or entity == LocalPlayer.Character then
			return false
		end

		local fighter = getFighter(entity)
		local owner = fighter and fighter.Player

		if fighter and fighter.IsLocalPlayer then
			return false
		end

		if Aimbot.TeamCheck and owner and isTeammate(owner) then
			return false
		end

		if Aimbot.DuelOnly and not isDuelEnemy(owner) then
			return false
		end

		local humanoid = entity:FindFirstChildOfClass("Humanoid")

		if humanoid and humanoid.Health <= 0 then
			return false
		end

		return true
	end

	local function evaluateEntity(entity, camera, center, radius)
		local bestPart, bestScore
		local origin = camera.CFrame.Position

		for _, part in ipairs(getAimParts(entity)) do
			local screen, onScreen = camera:WorldToViewportPoint(part.Position)

			if onScreen then
				local score = (Vector2.new(screen.X, screen.Y) - center).Magnitude

				if score <= radius and (not bestScore or score < bestScore) then
					if (part.Position - origin).Magnitude <= Aimbot.MaxDistance then
						if not Aimbot.VisibleCheck or isVisibleTarget(part, entity, origin) then
							bestPart, bestScore = part, score
						end
					end
				end
			end
		end

		return bestPart, bestScore
	end

	local function findAimTarget(camera, center)
		if Aimbot.Sticky and aimbotTarget and isAimEntityValid(aimbotTarget) then
			local part = evaluateEntity(aimbotTarget, camera, center, Aimbot.FovRadius * 1.25)

			if part then
				return aimbotTarget, part
			end
		end

		local bestEntity, bestPart, bestScore

		for _, entity in ipairs(CollectionService:GetTagged("Entity")) do
			if isAimEntityValid(entity) then
				local part, score = evaluateEntity(entity, camera, center, Aimbot.FovRadius)

				if part and (not bestScore or score < bestScore) then
					bestEntity, bestPart, bestScore = entity, part, score
				end
			end
		end

		return bestEntity, bestPart
	end

	local function isAimActive()
		if Aimbot.Mode == "Always" then
			return true
		end

		if os.clock() - Settings.LastShotTime < 0.35 then
			return true
		end

		return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
	end

	UserInputService.InputChanged:Connect(function(input, processed)
		if processed then
			return
		end

		local inputType = input.UserInputType

		if inputType == Enum.UserInputType.MouseMovement or inputType == Enum.UserInputType.Touch then
			if input.Delta.Magnitude > 2 then
				lastUserInput = os.clock()
			end
		end
	end)

	RunService.RenderStepped:Connect(function(dt)
		local camera = workspace.CurrentCamera

		if not camera then
			return
		end

		local center = camera.ViewportSize / 2

		AimbotFov.Visible = Aimbot.Enabled and Aimbot.ShowFov

		if AimbotFov.Visible then
			local diameter = Aimbot.FovRadius * 2
			AimbotFov.Position = UDim2.fromOffset(center.X, center.Y)
			AimbotFov.Size = UDim2.fromOffset(diameter, diameter)
			AimbotFovStroke.Color = Aimbot.FovColor
		end

		if not Aimbot.Enabled or not okAimCamera or type(AimCamera) ~= "table" then
			aimbotTarget = nil
			return
		end

		if UserInputService:GetFocusedTextBox() then
			return
		end

		if Aimbot.YieldToInput and os.clock() - lastUserInput < 0.12 then
			return
		end

		if not isAimActive() then
			aimbotTarget = nil
			return
		end

		local entity, part = findAimTarget(camera, center)
		aimbotTarget = entity

		if not entity or not part then
			return
		end

		local targetPosition = part.Position

		if Aimbot.Humanize then
			local now = os.clock()
			targetPosition = targetPosition + Vector3.new(
				math.noise(now * 1.3, noiseSeed, 0),
				math.noise(now * 1.1, noiseSeed + 10, 0),
				math.noise(now * 1.7, noiseSeed + 20, 0)
			) * 0.6
		end

		local pitch, yaw = CFrame.lookAt(camera.CFrame.Position, targetPosition):ToOrientation()
		local current = AimCamera.Rotation
		local deltaYaw = ((yaw - current.Y + math.pi) % (math.pi * 2)) - math.pi
		local deltaPitch = pitch - current.X
		local alpha = 1 - math.exp(-Aimbot.Speed * 0.25 * dt)

		pcall(function()
			AimCamera:SetRotation(Vector2.new(
				current.X + deltaPitch * alpha * (Aimbot.Vertical / 100),
				current.Y + deltaYaw * alpha * (Aimbot.Horizontal / 100)
			))
		end)
	end)

	local AimbotTab = Legit:AddSubTab("Aimbot", "crosshair")

	local AimbotMain = AimbotTab:AddSection("Aimbot", "Left", "crosshair", "aimbotmain")
	AimbotMain:AddToggle({
		Name = "Enable",
		Default = Aimbot.Enabled,
		Flag = "AimbotEnabled",
		Callback = function(Value)
			Aimbot.Enabled = Value
		end,
	})
	AimbotMain:AddDropdown({
		Name = "Activation",
		Options = { "While Shooting", "Always" },
		Default = Aimbot.Mode,
		Flag = "AimbotMode",
		Callback = function(Value)
			Aimbot.Mode = Value
		end,
	})
	AimbotMain:AddDropdown({
		Name = "Hit Part",
		Options = { "Closest", "Head", "UpperTorso", "HumanoidRootPart" },
		Default = Aimbot.HitPart,
		Flag = "AimbotHitPart",
		Callback = function(Value)
			Aimbot.HitPart = Value
		end,
	})
	AimbotMain:AddToggle({
		Name = "Team Check",
		Default = Aimbot.TeamCheck,
		Flag = "AimbotTeamCheck",
		Callback = function(Value)
			Aimbot.TeamCheck = Value
		end,
	})
	AimbotMain:AddToggle({
		Name = "Duel Enemies Only",
		Default = Aimbot.DuelOnly,
		Flag = "AimbotDuelOnly",
		Callback = function(Value)
			Aimbot.DuelOnly = Value
		end,
	})
	AimbotMain:AddToggle({
		Name = "Visible Check",
		Default = Aimbot.VisibleCheck,
		Flag = "AimbotVisibleCheck",
		Callback = function(Value)
			Aimbot.VisibleCheck = Value
		end,
	})
	AimbotMain:AddToggle({
		Name = "Sticky Target",
		Default = Aimbot.Sticky,
		Flag = "AimbotSticky",
		Callback = function(Value)
			Aimbot.Sticky = Value
		end,
	})
	AimbotMain:AddSlider({
		Name = "Max Distance",
		Min = 50,
		Max = 2000,
		Default = Aimbot.MaxDistance,
		Increment = 10,
		Suffix = " st",
		Flag = "AimbotMaxDistance",
		Callback = function(Value)
			Aimbot.MaxDistance = Value
		end,
	})

	local AimbotSmooth = AimbotTab:AddSection("Smoothing", "Right", "sliders-horizontal", "aimbotsmooth")
	AimbotSmooth:AddSlider({
		Name = "Aim Speed",
		Min = 1,
		Max = 100,
		Default = Aimbot.Speed,
		Increment = 1,
		Flag = "AimbotSpeed",
		Callback = function(Value)
			Aimbot.Speed = Value
		end,
	})
	AimbotSmooth:AddSlider({
		Name = "Horizontal Strength",
		Min = 0,
		Max = 100,
		Default = Aimbot.Horizontal,
		Increment = 1,
		Suffix = "%",
		Flag = "AimbotHorizontal",
		Callback = function(Value)
			Aimbot.Horizontal = Value
		end,
	})
	AimbotSmooth:AddSlider({
		Name = "Vertical Strength",
		Min = 0,
		Max = 100,
		Default = Aimbot.Vertical,
		Increment = 1,
		Suffix = "%",
		Flag = "AimbotVertical",
		Callback = function(Value)
			Aimbot.Vertical = Value
		end,
	})
	AimbotSmooth:AddToggle({
		Name = "Humanize",
		Default = Aimbot.Humanize,
		Flag = "AimbotHumanize",
		Callback = function(Value)
			Aimbot.Humanize = Value
		end,
	})
	AimbotSmooth:AddToggle({
		Name = "Yield To Player Input",
		Default = Aimbot.YieldToInput,
		Flag = "AimbotYieldToInput",
		Callback = function(Value)
			Aimbot.YieldToInput = Value
		end,
	})

	local AimbotFovSection = AimbotTab:AddSection("FOV", "Right", "circle", "aimbotfov")
	AimbotFovSection:AddToggle({
		Name = "Show FOV",
		Default = Aimbot.ShowFov,
		Flag = "AimbotShowFov",
		Callback = function(Value)
			Aimbot.ShowFov = Value
		end,
	})
	AimbotFovSection:AddSlider({
		Name = "FOV Radius",
		Min = 20,
		Max = 500,
		Default = Aimbot.FovRadius,
		Increment = 5,
		Suffix = " px",
		Flag = "AimbotFovRadius",
		Callback = function(Value)
			Aimbot.FovRadius = Value
		end,
	})
	AimbotFovSection:AddColorPicker({
		Name = "FOV Color",
		Default = Aimbot.FovColor,
		Flag = "AimbotFovColor",
		Callback = function(Color)
			Aimbot.FovColor = Color
		end,
	})
end

local TriggerTab = Legit:AddSubTab("Triggerbot", "mouse-pointer-click")

local TriggerMain = TriggerTab:AddSection("Triggerbot", "Left", "mouse-pointer-click", "triggermain")
TriggerMain:AddToggle({
	Name = "Enable",
	Default = Trigger.Enabled,
	Flag = "TriggerEnabled",
	Callback = function(Value)
		Trigger.Enabled = Value
	end,
})
TriggerMain:AddToggle({
	Name = "Team Check",
	Default = Trigger.TeamCheck,
	Flag = "TriggerTeamCheck",
	Callback = function(Value)
		Trigger.TeamCheck = Value
	end,
})
TriggerMain:AddDropdown({
	Name = "Hit Part",
	Options = { "Any", "Head", "Body" },
	Default = Trigger.HitPart,
	Flag = "TriggerHitPart",
	Callback = function(Value)
		Trigger.HitPart = Value
	end,
})
TriggerMain:AddSlider({
	Name = "Max Distance",
	Min = 25,
	Max = 2000,
	Default = Trigger.MaxDistance,
	Increment = 5,
	Suffix = " st",
	Flag = "TriggerMaxDistance",
	Callback = function(Value)
		Trigger.MaxDistance = Value
	end,
})

local TriggerTiming = TriggerTab:AddSection("Timing", "Right", "timer", "triggertiming")
TriggerTiming:AddSlider({
	Name = "Reaction Delay",
	Min = 0,
	Max = 300,
	Default = Trigger.Delay,
	Increment = 5,
	Suffix = " ms",
	Flag = "TriggerDelay",
	Callback = function(Value)
		Trigger.Delay = Value
	end,
})
TriggerTiming:AddSlider({
	Name = "Click Duration",
	Min = 10,
	Max = 200,
	Default = Trigger.HoldTime,
	Increment = 5,
	Suffix = " ms",
	Flag = "TriggerHoldTime",
	Callback = function(Value)
		Trigger.HoldTime = Value
	end,
})
TriggerTiming:AddSlider({
	Name = "Shot Cooldown",
	Min = 0,
	Max = 500,
	Default = Trigger.Cooldown,
	Increment = 5,
	Suffix = " ms",
	Flag = "TriggerCooldown",
	Callback = function(Value)
		Trigger.Cooldown = Value
	end,
})

local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")

local HitsoundPresets = {
	{ "Neverlose", "8679627751" },
	{ "Baimware", "6607339542" },
	{ "Osu", "7147454322" },
	{ "Bruh", "5044897021" },
	{ "Vine Boom", "5058160717" },
	{ "Oof", "5943191430" },
	{ "Katana", "7122613461" },
	{ "Perfect", "4467682848" },
}

local HitsoundNames = {}
local HitsoundIds = {}
for _, preset in ipairs(HitsoundPresets) do
	table.insert(HitsoundNames, preset[1])
	HitsoundIds[preset[1]] = preset[2]
end
table.insert(HitsoundNames, "Custom")

local Hitsound = {
	Enabled = false,
	Preset = "Neverlose",
	SoundId = "",
	Volume = 100,
	Pitch = 100,
}

local function resolveSoundId(value)
	value = tostring(value or ""):gsub("^%s+", ""):gsub("%s+$", "")
	if value == "" then
		return nil
	end
	if tonumber(value) then
		return "rbxassetid://" .. value
	end
	if string.find(value, "rbxassetid://", 1, true) or string.find(value, "rbxasset://", 1, true) or string.find(value, "http", 1, true) then
		return value
	end
	if isfile and getcustomasset then
		local ok, exists = pcall(isfile, value)
		if ok and exists then
			local okAsset, asset = pcall(getcustomasset, value)
			if okAsset then
				return asset
			end
		end
	end
	return nil
end

local function playSoundFrom(source, volume, pitch)
	local id = resolveSoundId(source)
	if not id then
		return false
	end
	local sound = Instance.new("Sound")
	sound.SoundId = id
	sound.Volume = volume / 100 * 2
	sound.PlaybackSpeed = pitch / 100
	sound.Parent = SoundService
	sound:Play()
	Debris:AddItem(sound, 5)
	return true
end

local function playHitsound()
	local source = Hitsound.Preset == "Custom" and Hitsound.SoundId or HitsoundIds[Hitsound.Preset]
	return playSoundFrom(source, Hitsound.Volume, Hitsound.Pitch)
end

local ShootSound = {
	Enabled = false,
	Preset = "Neverlose",
	SoundId = "",
	Volume = 100,
	Pitch = 100,
}

local function playShootSound()
	local source = ShootSound.Preset == "Custom" and ShootSound.SoundId or HitsoundIds[ShootSound.Preset]
	return playSoundFrom(source, ShootSound.Volume, ShootSound.Pitch)
end

local mutedViewModel = nil
local mutedUntil = 0

local okAnimator, AnimatorClass = pcall(function()
	return require(LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem.ClientViewModel.ViewModelAnimator)
end)

if okAnimator and type(AnimatorClass) == "table" and type(AnimatorClass.PlayAnimation) == "function" then
	local originalPlayAnimation = AnimatorClass.PlayAnimation
	AnimatorClass.PlayAnimation = function(self, key, ...)
		if ShootSound.Enabled and type(key) == "string" then
			local lowered = string.lower(key)
			if string.find(lowered, "shoot", 1, true) or string.find(lowered, "quickshot", 1, true) then
				local okLocal, isLocal = pcall(function()
					return self.ClientViewModel.ClientItem.ClientFighter.IsLocalPlayer
				end)
				if okLocal and isLocal and playShootSound() then
					mutedViewModel = self.ClientViewModel
					mutedUntil = tick() + 0.25
				end
			end
		end
		return originalPlayAnimation(self, key, ...)
	end
end

local okViewModel, ViewModelClass = pcall(function()
	return require(LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem.ClientViewModel)
end)

if okViewModel and type(ViewModelClass) == "table" then
	if type(ViewModelClass.PlayHitmarkerSound) == "function" then
		local originalHitmarker = ViewModelClass.PlayHitmarkerSound
		ViewModelClass.PlayHitmarkerSound = function(self, ...)
			if Hitsound.Enabled and playHitsound() then
				return
			end
			return originalHitmarker(self, ...)
		end
	end
	if type(ViewModelClass.CreateSound) == "function" then
		local originalCreateSound = ViewModelClass.CreateSound
		ViewModelClass.CreateSound = function(self, ...)
			if mutedViewModel == self and tick() < mutedUntil then
				return Instance.new("Sound")
			end
			return originalCreateSound(self, ...)
		end
	end
end

local HitTrack = {
	DamageEnabled = false,
	Ray = nil,
	Near = nil,
}

HitTrack.LastInput = 0
HitTrack.wrapped = setmetatable({}, { __mode = "k" })

if okViewModel and type(ViewModelClass) == "table" and type(rawget(ViewModelClass, "PlayHitmarkerSound")) == "function" then
	HitTrack.wrapped[ViewModelClass] = true
end

do
	local UserInputService = game:GetService("UserInputService")
	UserInputService.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			HitTrack.LastInput = os.clock()
		end
	end)
	RunService.RenderStepped:Connect(function()
		if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
			HitTrack.LastInput = os.clock()
		end
	end)
end

HitTrack.healthLast = setmetatable({}, { __mode = "k" })
HitTrack.healthDrops = {}
HitTrack.deathStamp = setmetatable({}, { __mode = "k" })

function HitTrack.entityOf(instance)
	local node = instance
	while node and node ~= workspace do
		if CollectionService:HasTag(node, "Entity") then
			return node
		end
		node = node.Parent
	end
	node = instance
	while node and node ~= workspace do
		if node:IsA("Model") and node:FindFirstChildOfClass("Humanoid") then
			return node
		end
		node = node.Parent
	end
	return nil
end

function HitTrack.isLocalEntity(model)
	if model == LocalPlayer.Character then
		return true
	end
	local fighter = getFighter(model)
	return fighter ~= nil and fighter.IsLocalPlayer == true
end

HitTrack.enemyCache = setmetatable({}, { __mode = "k" })

function HitTrack.isEnemy(model)
	local now = os.clock()
	local cached = HitTrack.enemyCache[model]
	if cached and now - cached.Time < 0.5 then
		return cached.Value
	end
	local value = true
	local fighter = getFighter(model)
	local owner = fighter and fighter.Player or Players:GetPlayerFromCharacter(model)
	if owner then
		if isTeammate(owner) then
			value = false
		else
			local okDuel, inDuel = pcall(function()
				local duel = DuelSpectateController.CurrentDuelSubject
				return duel ~= nil and duel:GetDueler(LocalPlayer) ~= nil
			end)
			if okDuel and inDuel then
				value = isDuelEnemy(owner)
			end
		end
	end
	HitTrack.enemyCache[model] = { Value = value, Time = now }
	return value
end

function HitTrack.isMine(model)
	local now = os.clock()
	local lastAction = math.max(Settings.LastShotTime or 0, HitTrack.LastInput or 0, HitTrack.LastFire or 0)
	if now - lastAction > 1.2 then
		return false, false
	end
	local ray = HitTrack.Ray
	if ray and ray.Model == model and now - ray.Time < 0.5 then
		local crit = ray.Part ~= nil and ray.Part.Name == "Head"
		return true, crit
	end
	local okSilent, _, silentModel = pcall(getSilentTarget)
	if okSilent and silentModel == model then
		return true, false
	end
	local okNear, nearest, score = pcall(HitTrack.nearestToCrosshair)
	if okNear and nearest == model and score and score < 350 then
		return true, false
	end
	return false, false
end

function HitTrack.listEnemies()
	local models, seen = {}, {}
	for _, model in ipairs(CollectionService:GetTagged("Entity")) do
		if not seen[model] and not HitTrack.isLocalEntity(model) and HitTrack.isEnemy(model) then
			seen[model] = true
			table.insert(models, model)
		end
	end
	for _, player in ipairs(Players:GetPlayers()) do
		local character = player.Character
		if player ~= LocalPlayer and character and not seen[character] and HitTrack.isEnemy(character) then
			seen[character] = true
			table.insert(models, character)
		end
	end
	return models
end

function HitTrack.pickPart(model, crit)
	if not model or not model.Parent then
		return nil
	end
	local head = model:FindFirstChild("Head", true)
	local root = model:FindFirstChild("HumanoidRootPart", true)
		or model:FindFirstChild("UpperTorso", true)
		or model:FindFirstChild("Torso", true)
	local primary
	if crit then
		primary = head or root
	else
		primary = root or head
	end
	if primary and primary:IsA("BasePart") then
		return primary
	end
	return model:FindFirstChildWhichIsA("BasePart", true)
end

function HitTrack.castCenterRay()
	local camera = workspace.CurrentCamera
	local center = camera.ViewportSize / 2
	local ray = camera:ViewportPointToRay(center.X, center.Y)
	local ignore = { camera }
	if LocalPlayer.Character then
		table.insert(ignore, LocalPlayer.Character)
	end
	local viewModels = workspace:FindFirstChild("ViewModels")
	if viewModels then
		table.insert(ignore, viewModels)
	end
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.IgnoreWater = true
	params.FilterDescendantsInstances = ignore
	local result = workspace:Raycast(ray.Origin, ray.Direction * 1500, params)
	if not result then
		return nil, nil, ray
	end
	local entity = HitTrack.entityOf(result.Instance)
	if entity and not HitTrack.isLocalEntity(entity) then
		return entity, result, ray
	end
	return nil, result, ray
end

function HitTrack.nearestToCrosshair()
	local camera = workspace.CurrentCamera
	local center = camera.ViewportSize / 2
	local bestModel, bestScore = nil, math.huge
	local now = os.clock()
	for _, model in ipairs(HitTrack.listEnemies()) do
		local humanoid = model:FindFirstChildOfClass("Humanoid")
		local alive = not humanoid or humanoid.Health > 0 or (HitTrack.deathStamp[model] and now - HitTrack.deathStamp[model] < 1)
		if alive then
			local part = HitTrack.pickPart(model, false)
			if part then
				local screen, onScreen = camera:WorldToViewportPoint(part.Position)
				if onScreen and screen.Z > 0 then
					local score = (Vector2.new(screen.X, screen.Y) - center).Magnitude
					if score < bestScore then
						bestModel, bestScore = model, score
					end
				end
			end
		end
	end
	return bestModel, bestScore
end

function HitTrack.snapshotModel(model)
	local head = model:FindFirstChild("Head", true)
	local root = HitTrack.pickPart(model, false)
	return {
		Model = model,
		HeadPosition = head and head:IsA("BasePart") and head.Position or nil,
		RootPosition = root and root.Position or nil,
		Time = os.clock(),
	}
end

RunService.RenderStepped:Connect(function()
	if not HitTrack.DamageEnabled then
		return
	end
	local okTrack = pcall(function()
		local now = os.clock()
		local entity, result = HitTrack.castCenterRay()
		if entity and result then
			HitTrack.Ray = {
				Model = entity,
				Part = result.Instance,
				Position = result.Position,
				Offset = result.Position - result.Instance.Position,
				Time = now,
			}
		end
		local model = HitTrack.nearestToCrosshair()
		if model then
			HitTrack.Near = HitTrack.snapshotModel(model)
		end
	end)
	if not okTrack then
		HitTrack.Ray = nil
	end
end)

RunService.Heartbeat:Connect(function()
	if not HitTrack.DamageEnabled then
		return
	end
	pcall(function()
		local now = os.clock()
		for _, model in ipairs(HitTrack.listEnemies()) do
			local humanoid = model:FindFirstChildOfClass("Humanoid")
			if humanoid then
				local health = humanoid.Health
				local last = HitTrack.healthLast[model]
				if last and last - health >= 0.5 then
					table.insert(HitTrack.healthDrops, { Model = model, Amount = last - health, Time = now })
					pcall(HitTrack.onDrop, model, last - health, now)
					if #HitTrack.healthDrops > 30 then
						table.remove(HitTrack.healthDrops, 1)
					end
					if health <= 0 then
						HitTrack.deathStamp[model] = now
					end
				end
				HitTrack.healthLast[model] = health
			end
		end
	end)
end)

function HitTrack.matchDrop(amount)
	local now = os.clock()
	local best, bestDelta
	for index = #HitTrack.healthDrops, 1, -1 do
		local drop = HitTrack.healthDrops[index]
		if now - drop.Time > 0.6 then
			table.remove(HitTrack.healthDrops, index)
		elseif drop.Model then
			local delta = amount and math.abs(drop.Amount - amount) or 0
			local tolerance = amount and math.max(3, amount * 0.2) or math.huge
			if delta <= tolerance and (not bestDelta or delta < bestDelta) then
				best, bestDelta = drop, delta
			end
		end
	end
	return best
end

function HitTrack.locateModel(model, crit)
	if model and model.Parent then
		local ray = HitTrack.Ray
		if ray and ray.Model == model and ray.Part and ray.Part.Parent and os.clock() - ray.Time < 0.5 and not crit then
			return ray.Part.Position + ray.Offset, ray.Part
		end
		local part = HitTrack.pickPart(model, crit)
		if part then
			return part.Position, part
		end
	end
	local near = HitTrack.Near
	if near and near.Model == model then
		local position = crit and near.HeadPosition or near.RootPosition
		if position then
			return position, nil
		end
	end
	return nil, nil
end

function HitTrack.getHitInfo(crit, amount)
	local silentPart, silentModel = getSilentTarget()
	if silentPart and silentModel then
		local head = crit and silentModel:FindFirstChild("Head", true)
		local target = head and head:IsA("BasePart") and head or silentPart
		return target.Position, target
	end

	local drop = HitTrack.matchDrop(amount)
	if drop then
		local position, part = HitTrack.locateModel(drop.Model, crit)
		if position then
			return position, part
		end
	end

	local entity = HitTrack.castCenterRay()
	if entity then
		local position, part = HitTrack.locateModel(entity, crit)
		if position then
			return position, part
		end
	end

	local now = os.clock()
	local ray = HitTrack.Ray
	if ray and now - ray.Time < 0.6 then
		local position, part = HitTrack.locateModel(ray.Model, crit)
		if position then
			return position, part
		end
		return ray.Position, nil
	end

	local near = HitTrack.Near
	if near and now - near.Time < 0.6 then
		local position, part = HitTrack.locateModel(near.Model, crit)
		if position then
			return position, part
		end
	end

	local model = HitTrack.nearestToCrosshair()
	if model then
		return HitTrack.locateModel(model, crit)
	end

	return nil, nil
end

local CustomCrosshair = {
	Enabled = false,
	Bars = true,
	Dot = false,
	Circle = false,
	Outline = true,
	TShape = false,
	Dynamic = true,
	DynamicStrength = 1,
	Spin = false,
	SpinSpeed = 90,
	Rainbow = false,
	RainbowSpeed = 0.4,
	Color = Color3.fromRGB(255, 255, 255),
	OutlineColor = Color3.fromRGB(0, 0, 0),
	Transparency = 0,
	Length = 8,
	Thickness = 2,
	Gap = 4,
	OutlineThickness = 1,
	DotSize = 3,
	CircleSize = 28,
	CircleThickness = 1,
	View = nil,
	Spacing = 16,
	GameVisible = true,
	NativeHidden = false,
}

do
	local gui = Instance.new("ScreenGui")
	gui.Name = "CustomCrosshair"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.DisplayOrder = 49
	gui.Enabled = false
	gui.Parent = gethui and gethui() or game:GetService("CoreGui")

	local root = Instance.new("Frame")
	root.AnchorPoint = Vector2.new(0.5, 0.5)
	root.Position = UDim2.fromScale(0.5, 0.5)
	root.Size = UDim2.fromOffset(0, 0)
	root.BackgroundTransparency = 1
	root.BorderSizePixel = 0
	root.Parent = gui

	local function makePart(round, filled)
		local frame = Instance.new("Frame")
		frame.AnchorPoint = Vector2.new(0.5, 0.5)
		frame.BorderSizePixel = 0
		frame.BackgroundTransparency = filled and 0 or 1
		frame.ZIndex = 2
		frame.Parent = root
		local stroke = Instance.new("UIStroke")
		stroke.LineJoinMode = Enum.LineJoinMode.Miter
		stroke.Parent = frame
		if round then
			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(1, 0)
			corner.Parent = frame
		end
		return frame, stroke
	end

	local up, upStroke = makePart(false, true)
	local down, downStroke = makePart(false, true)
	local left, leftStroke = makePart(false, true)
	local right, rightStroke = makePart(false, true)
	local dot, dotStroke = makePart(false, true)
	local ringOutline, ringOutlineStroke = makePart(true, false)
	local ring, ringStroke = makePart(true, false)
	ring.ZIndex = 3

	local spin = 0
	local smooth = 0

	RunService.RenderStepped:Connect(function(dt)
		local c = CustomCrosshair
		local show = c.Enabled and c.GameVisible
		if gui.Enabled ~= show then
			gui.Enabled = show
		end
		if not show then
			return
		end

		local color = c.Color
		if c.Rainbow then
			color = Color3.fromHSV((os.clock() * c.RainbowSpeed) % 1, 1, 1)
		end

		local target = c.Dynamic and math.max(0, c.Spacing - 16) * c.DynamicStrength or 0
		smooth = smooth + (target - smooth) * math.min(1, dt * 20)

		if c.Spin then
			spin = (spin + c.SpinSpeed * dt) % 360
		else
			spin = 0
		end
		root.Rotation = spin

		local length = math.round(c.Length)
		local thick = math.round(c.Thickness)
		local half = math.round(length / 2 + c.Gap + smooth)
		local transparency = c.Transparency
		local outline = c.Outline
		local outlineThickness = c.OutlineThickness

		local function style(frame, stroke, visible, size, position)
			frame.Visible = visible
			if not visible then
				return
			end
			frame.Size = size
			frame.Position = position
			frame.BackgroundColor3 = color
			frame.BackgroundTransparency = transparency
			stroke.Enabled = outline and outlineThickness > 0
			stroke.Color = c.OutlineColor
			stroke.Thickness = outlineThickness
			stroke.Transparency = transparency
		end

		local bars = c.Bars
		style(up, upStroke, bars and not c.TShape, UDim2.fromOffset(thick, length), UDim2.fromOffset(0, -half))
		style(down, downStroke, bars, UDim2.fromOffset(thick, length), UDim2.fromOffset(0, half))
		style(left, leftStroke, bars, UDim2.fromOffset(length, thick), UDim2.fromOffset(-half, 0))
		style(right, rightStroke, bars, UDim2.fromOffset(length, thick), UDim2.fromOffset(half, 0))

		local dotSize = math.round(c.DotSize)
		style(dot, dotStroke, c.Dot, UDim2.fromOffset(dotSize, dotSize), UDim2.new())

		local ringSize = UDim2.fromOffset(math.round(c.CircleSize), math.round(c.CircleSize))
		ring.Visible = c.Circle
		ringOutline.Visible = c.Circle and outline and outlineThickness > 0
		if c.Circle then
			ring.Size = ringSize
			ring.Position = UDim2.new()
			ringStroke.Color = color
			ringStroke.Thickness = c.CircleThickness
			ringStroke.Transparency = transparency
			ringOutline.Size = ringSize
			ringOutline.Position = UDim2.new()
			ringOutlineStroke.Color = c.OutlineColor
			ringOutlineStroke.Thickness = c.CircleThickness + outlineThickness * 2
			ringOutlineStroke.Transparency = transparency
		end
	end)
end

local okCrosshair, CrosshairClass = pcall(function()
	return require(LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem.ItemInterface.Mouse.MouseCrosshair)
end)

local okCrosshairView, CrosshairView = pcall(function()
	return require(LocalPlayer.PlayerScripts.Modules.Crosshair)
end)

if okCrosshairView and type(CrosshairView) == "table" and type(CrosshairView._Update) == "function" then
	local originalViewUpdate = CrosshairView._Update
	CrosshairView._Update = function(self, ...)
		originalViewUpdate(self, ...)
		if CustomCrosshair.Enabled and CustomCrosshair.View == self then
			pcall(function()
				self.Frame.Foreground.Visible = false
				self.Frame.Background.Visible = false
			end)
		end
	end
end

function HitTrack.onDrop(model, amount, stamp)
	local mine, crit = HitTrack.isMine(model)
	if not mine then
		return
	end
	task.delay(0.1, function()
		local position, anchor = HitTrack.locateModel(model, crit)
		if HitTrack.DamageEnabled and HitTrack.spawnDamage and (HitTrack.LastDamage or 0) < stamp then
			HitTrack.LastDamage = os.clock()
			HitTrack.FallbackDamage = os.clock()
			local world = HitTrack.damageMode() == "Enemy" and position ~= nil
			pcall(HitTrack.spawnDamage, amount, crit, world and position or nil, world and anchor or nil)
		end
	end)
end

function HitTrack.wrapSound(class)
	if type(class) ~= "table" or HitTrack.wrapped[class] then
		return
	end
	local original = class.PlayHitmarkerSound
	if type(original) ~= "function" then
		return
	end
	HitTrack.wrapped[class] = true
	local function wrapper(self, ...)
		if Hitsound.Enabled and playHitsound() then
			return
		end
		return original(self, ...)
	end
	local okSet = pcall(function()
		class.PlayHitmarkerSound = wrapper
	end)
	if not okSet then
		pcall(rawset, class, "PlayHitmarkerSound", wrapper)
	end
end

function HitTrack.hookItem(item)
	pcall(function()
		HitTrack.wrapSound(getmetatable(item.ViewModel))
	end)
end

do
	local lastAmmo = setmetatable({}, { __mode = "k" })
	RunService.RenderStepped:Connect(function()
		if not HitTrack.DamageEnabled then
			return
		end
		local fighter = getFighter(LocalPlayer)
		if not fighter or type(fighter.Items) ~= "table" then
			return
		end
		for _, item in pairs(fighter.Items) do
			HitTrack.hookItem(item)
			local okAmmo, ammo = pcall(function()
				return (item:GetAmmoVariables())
			end)
			if okAmmo and type(ammo) == "number" then
				local previousAmmo = lastAmmo[item]
				lastAmmo[item] = ammo
				if previousAmmo and ammo < previousAmmo then
					HitTrack.LastFire = os.clock()
				end
			end
		end
	end)
end

if okCrosshair and type(CrosshairClass) == "table" and type(CrosshairClass.Update) == "function" then
	local originalUpdate = CrosshairClass.Update
	CrosshairClass.Update = function(self, ...)
		local okLocal, isLocal = pcall(function()
			return self.Mouse.ItemInterface.ClientItem.ClientFighter.IsLocalPlayer
		end)
		local ok, err = pcall(originalUpdate, self, ...)
		if okLocal and isLocal then
			local view = self.Crosshair
			if view then
				CustomCrosshair.View = view
				CustomCrosshair.Spacing = (view._spacing or 16) * (view._spacing_multiplier or 1)
				CustomCrosshair.GameVisible = view._visible ~= false and not (view.Appearance and view.Appearance.IsDisabled)
				if CustomCrosshair.Enabled then
					CustomCrosshair.NativeHidden = true
					pcall(function()
						view.Frame.Foreground.Visible = false
						view.Frame.Background.Visible = false
					end)
				elseif CustomCrosshair.NativeHidden then
					CustomCrosshair.NativeHidden = false
					pcall(function()
						view:_Update()
					end)
				end
			end
		end
		if not ok then
			error(err, 0)
		end
	end
end

local CustomTab = Visual:AddSubTab("Custom", "sliders-horizontal")

local HitsoundSection = CustomTab:AddSection("Custom Hitsound", "Left", "volume-2", "customhitsound")
HitsoundSection:AddToggle({
	Name = "Custom Hitsound",
	Default = Hitsound.Enabled,
	Flag = "HitsoundEnabled",
	Callback = function(Value)
		Hitsound.Enabled = Value
	end,
})
HitsoundSection:AddDropdown({
	Name = "Sound",
	Options = HitsoundNames,
	Default = Hitsound.Preset,
	Flag = "HitsoundPreset",
	Callback = function(Value)
		Hitsound.Preset = Value
	end,
})
HitsoundSection:AddTextbox({
	Name = "Custom Sound ID / File",
	Placeholder = "rbxassetid or file name",
	Flag = "HitsoundId",
	Callback = function(Text)
		Hitsound.SoundId = Text
	end,
})
HitsoundSection:AddSlider({
	Name = "Volume",
	Min = 0,
	Max = 100,
	Default = Hitsound.Volume,
	Increment = 1,
	Suffix = "%",
	Flag = "HitsoundVolume",
	Callback = function(Value)
		Hitsound.Volume = Value
	end,
})
HitsoundSection:AddSlider({
	Name = "Pitch",
	Min = 50,
	Max = 200,
	Default = Hitsound.Pitch,
	Increment = 5,
	Suffix = "%",
	Flag = "HitsoundPitch",
	Callback = function(Value)
		Hitsound.Pitch = Value
	end,
})
HitsoundSection:AddButton({
	Name = "Test Hitsound",
	Callback = function()
		if not playHitsound() then
			Window:Notify({ Title = "Hitsound", Content = "Invalid sound ID or file", Duration = 3 })
		end
	end,
})

local ShootSection = CustomTab:AddSection("Custom Shoot Sound", "Right", "crosshair", "customshootsound")
ShootSection:AddToggle({
	Name = "Custom Shoot Sound",
	Default = ShootSound.Enabled,
	Flag = "ShootSoundEnabled",
	Callback = function(Value)
		ShootSound.Enabled = Value
	end,
})
ShootSection:AddDropdown({
	Name = "Sound",
	Options = HitsoundNames,
	Default = ShootSound.Preset,
	Flag = "ShootSoundPreset",
	Callback = function(Value)
		ShootSound.Preset = Value
	end,
})
ShootSection:AddTextbox({
	Name = "Custom Sound ID / File",
	Placeholder = "rbxassetid or file name",
	Flag = "ShootSoundId",
	Callback = function(Text)
		ShootSound.SoundId = Text
	end,
})
ShootSection:AddSlider({
	Name = "Volume",
	Min = 0,
	Max = 100,
	Default = ShootSound.Volume,
	Increment = 1,
	Suffix = "%",
	Flag = "ShootSoundVolume",
	Callback = function(Value)
		ShootSound.Volume = Value
	end,
})
ShootSection:AddSlider({
	Name = "Pitch",
	Min = 50,
	Max = 200,
	Default = ShootSound.Pitch,
	Increment = 5,
	Suffix = "%",
	Flag = "ShootSoundPitch",
	Callback = function(Value)
		ShootSound.Pitch = Value
	end,
})
ShootSection:AddButton({
	Name = "Test Shoot Sound",
	Callback = function()
		if not playShootSound() then
			Window:Notify({ Title = "Shoot Sound", Content = "Invalid sound ID or file", Duration = 3 })
		end
	end,
})

do
	local ViewTab = Visual:AddSubTab("View", "eye")

	local ThirdPerson = {
		Enabled = false,
		Mode = "Right",
		Distance = 7.5,
		Height = 1.5,
		Side = 3,
		Controller = nil,
	}

	task.spawn(function()
		local ok, controller = pcall(function()
			return require(LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("Controllers"):WaitForChild("CameraController"))
		end)

		if ok then
			ThirdPerson.Controller = controller
		end
	end)

	local function release()
		local controller = ThirdPerson.Controller

		if not controller then
			return
		end

		pcall(function()
			controller:SetThirdPersonOverride(nil)
			controller.CameraState:VerifyPOV()
		end)
	end

	RunService.Heartbeat:Connect(function()
		if not ThirdPerson.Enabled then
			return
		end

		local controller = ThirdPerson.Controller

		if not controller then
			return
		end

		pcall(function()
			if controller._third_person_override ~= true then
				controller:SetThirdPersonOverride(true)
			end

			local states = controller.CameraState.States
			local wanted = ThirdPerson.Mode == "Left" and states.ThirdPersonMirrored or states.ThirdPerson

			if controller.CameraState._pov_state ~= wanted then
				controller.CameraState:_SetPOVState(wanted)
			end

			local side = ThirdPerson.Mode == "Left" and -ThirdPerson.Side or ThirdPerson.Side

			controller._pov_spring.Target = Vector3.new(side, ThirdPerson.Height, ThirdPerson.Distance)
		end)
	end)

	local ThirdSection = ViewTab:AddSection("Thirdperson", "Left", "user", "thirdperson")

	local ThirdToggle = ThirdSection:AddToggle({
		Name = "Thirdperson",
		Default = false,
		Flag = "ThirdpersonEnabled",
		Callback = function(Value)
			ThirdPerson.Enabled = Value

			if not Value then
				release()
			end
		end,
	})

	ThirdSection:AddKeybind({
		Name = "Thirdperson Key",
		Flag = "ThirdpersonKey",
		Pressed = function()
			ThirdToggle:Set(not ThirdToggle:Get())
		end,
	})

	ThirdSection:AddDropdown({
		Name = "Side",
		Options = { "Right", "Left" },
		Default = ThirdPerson.Mode,
		Flag = "ThirdpersonSide",
		Callback = function(Value)
			ThirdPerson.Mode = Value
		end,
	})

	local CameraSection = ViewTab:AddSection("Camera", "Right", "camera", "thirdpersoncamera")

	CameraSection:AddSlider({
		Name = "Distance",
		Min = 2,
		Max = 30,
		Default = ThirdPerson.Distance,
		Increment = 0.5,
		Suffix = " st",
		Flag = "ThirdpersonDistance",
		Callback = function(Value)
			ThirdPerson.Distance = Value
		end,
	})

	CameraSection:AddSlider({
		Name = "Height",
		Min = -3,
		Max = 10,
		Default = ThirdPerson.Height,
		Increment = 0.5,
		Suffix = " st",
		Flag = "ThirdpersonHeight",
		Callback = function(Value)
			ThirdPerson.Height = Value
		end,
	})

	CameraSection:AddSlider({
		Name = "Side Offset",
		Min = 0,
		Max = 10,
		Default = ThirdPerson.Side,
		Increment = 0.5,
		Suffix = " st",
		Flag = "ThirdpersonSideOffset",
		Callback = function(Value)
			ThirdPerson.Side = Value
		end,
	})
end

do
	local CrosshairTab = Visual:AddSubTab("Crosshair", "crosshair")
	local controls = {}

	local function addToggle(section, label, key)
		controls[key] = section:AddToggle({
			Name = label,
			Default = CustomCrosshair[key],
			Flag = "Crosshair" .. key,
			Callback = function(Value)
				CustomCrosshair[key] = Value
			end,
		})
	end

	local function addSlider(section, label, key, min, max, increment, suffix, scale)
		scale = scale or 1
		controls[key] = section:AddSlider({
			Name = label,
			Min = min,
			Max = max,
			Default = CustomCrosshair[key] / scale,
			Increment = increment,
			Suffix = suffix,
			Flag = "Crosshair" .. key,
			Callback = function(Value)
				CustomCrosshair[key] = Value * scale
			end,
		})
	end

	local General = CrosshairTab:AddSection("Custom Crosshair", "Left", "crosshair", "customcrosshair")
	addToggle(General, "Enabled", "Enabled")
	addToggle(General, "Bars", "Bars")
	addToggle(General, "Center Dot", "Dot")
	addToggle(General, "Circle", "Circle")
	addToggle(General, "Outline", "Outline")
	addToggle(General, "T Shape", "TShape")

	local BarsSection = CrosshairTab:AddSection("Bars", "Left", "sliders-horizontal", "crosshairbars")
	addSlider(BarsSection, "Length", "Length", 1, 40, 1, " px")
	addSlider(BarsSection, "Thickness", "Thickness", 1, 10, 1, " px")
	addSlider(BarsSection, "Gap", "Gap", 0, 40, 1, " px")
	addSlider(BarsSection, "Outline Thickness", "OutlineThickness", 0, 4, 1, " px")

	local CenterSection = CrosshairTab:AddSection("Center", "Left", "target", "crosshaircenter")
	addSlider(CenterSection, "Dot Size", "DotSize", 1, 12, 1, " px")
	addSlider(CenterSection, "Circle Size", "CircleSize", 8, 100, 1, " px")
	addSlider(CenterSection, "Circle Thickness", "CircleThickness", 1, 6, 1, " px")

	local presets = {
		Classic = { Bars = true, Dot = false, Circle = false, TShape = false, Outline = true, Length = 8, Thickness = 2, Gap = 4 },
		Dot = { Bars = false, Dot = true, Circle = false, TShape = false, Outline = true, DotSize = 4 },
		Ring = { Bars = false, Dot = true, Circle = true, TShape = false, Outline = true, DotSize = 3, CircleSize = 30, CircleThickness = 2 },
		["T Shape"] = { Bars = true, Dot = false, Circle = false, TShape = true, Outline = true, Length = 7, Thickness = 2, Gap = 3 },
		Sniper = { Bars = true, Dot = true, Circle = false, TShape = false, Outline = true, Length = 14, Thickness = 1, Gap = 6, DotSize = 2 },
	}

	local PresetSection = CrosshairTab:AddSection("Presets", "Right", "layout-grid", "crosshairpresets")
	for _, presetName in ipairs({ "Classic", "Dot", "Ring", "T Shape", "Sniper" }) do
		PresetSection:AddButton({
			Name = presetName,
			Callback = function()
				for key, value in pairs(presets[presetName]) do
					if controls[key] then
						controls[key]:Set(value)
					end
				end
			end,
		})
	end

	local ColorSection = CrosshairTab:AddSection("Colors", "Right", "palette", "crosshaircolors")
	ColorSection:AddColorPicker({
		Name = "Color",
		Default = CustomCrosshair.Color,
		Flag = "CrosshairColor",
		Callback = function(Color)
			CustomCrosshair.Color = Color
		end,
	})
	ColorSection:AddColorPicker({
		Name = "Outline Color",
		Default = CustomCrosshair.OutlineColor,
		Flag = "CrosshairOutlineColor",
		Callback = function(Color)
			CustomCrosshair.OutlineColor = Color
		end,
	})
	addSlider(ColorSection, "Transparency", "Transparency", 0, 90, 1, "%", 0.01)

	local MotionSection = CrosshairTab:AddSection("Motion", "Right", "settings", "crosshairmotion")
	addToggle(MotionSection, "Dynamic Spread", "Dynamic")
	addSlider(MotionSection, "Spread Strength", "DynamicStrength", 0, 3, 0.1, "x")
	addToggle(MotionSection, "Spin", "Spin")
	addSlider(MotionSection, "Spin Speed", "SpinSpeed", 10, 720, 10, " deg")
	addToggle(MotionSection, "Rainbow", "Rainbow")
	addSlider(MotionSection, "Rainbow Speed", "RainbowSpeed", 0.1, 3, 0.1, "x")
end

do
	local TracerTab = Visual:AddSubTab("Bullet Tracer", "zap")

	local Tracer = {
		Enabled = false,
		HideDefault = true,
		Duration = 3,
		FadeTime = 1.5,
		Travel = true,
		Speed = 1500,
		Width = 0.12,
		Taper = true,
		Transparency = 0.1,
		LightEmission = 1,
		ColorMode = "Gradient",
		Color1 = Color3.fromRGB(255, 80, 180),
		Color2 = Color3.fromRGB(120, 200, 255),
		RainbowSpeed = 1,
		Glow = true,
		GlowWidth = 3,
		GlowTransparency = 0.65,
		Impact = true,
		ImpactSize = 0.6,
		MaxActive = 80,
	}

	local container = workspace.Terrain
	local active = {}

	local function destroyEntry(entry)
		for _, object in ipairs({ entry.Beam, entry.GlowBeam, entry.Head, entry.Tail, entry.Dot }) do
			pcall(function()
				object:Destroy()
			end)
		end
	end

	local function getDelay(result, muzzle)
		if not Tracer.Travel then
			return 0
		end

		local total = 0
		local node = result.LastRaycastResult
		local guard = 0

		while node and guard < 8 do
			local from = node.StartPosition or muzzle
			total = total + (node.Position - from).Magnitude
			node = node.LastRaycastResult
			guard = guard + 1
		end

		return total / Tracer.Speed
	end

	local function spawnTracer(data, muzzle)
		local now = os.clock()

		for _, result in pairs(data.RaycastResults) do
			local endPos = result.Position
			local startPos = result.StartPosition or muzzle

			if typeof(endPos) == "Vector3" and typeof(startPos) == "Vector3" then
				local length = (endPos - startPos).Magnitude

				if length > 0.5 then
					while #active >= Tracer.MaxActive do
						destroyEntry(table.remove(active, 1))
					end

					local head = Instance.new("Attachment")
					head.Parent = container
					head.WorldPosition = startPos

					local tail = Instance.new("Attachment")
					tail.Parent = container
					tail.WorldPosition = startPos

					local glowBeam = Instance.new("Beam")
					glowBeam.Attachment0 = head
					glowBeam.Attachment1 = tail
					glowBeam.FaceCamera = true
					glowBeam.LightInfluence = 0
					glowBeam.Segments = 1
					glowBeam.Enabled = false
					glowBeam.Parent = container

					local beam = Instance.new("Beam")
					beam.Attachment0 = head
					beam.Attachment1 = tail
					beam.FaceCamera = true
					beam.LightInfluence = 0
					beam.Segments = 1
					beam.Enabled = false
					beam.Parent = container

					local dot = Instance.new("Part")
					dot.Shape = Enum.PartType.Ball
					dot.Material = Enum.Material.Neon
					dot.Anchored = true
					dot.CanCollide = false
					dot.CanQuery = false
					dot.CanTouch = false
					dot.CastShadow = false
					dot.Transparency = 1
					dot.Size = Vector3.one * Tracer.ImpactSize
					dot.Position = endPos
					dot.Parent = container

					table.insert(active, {
						Start = startPos,
						End = endPos,
						Length = length,
						Born = now + getDelay(result, muzzle),
						Head = head,
						Tail = tail,
						Beam = beam,
						GlowBeam = glowBeam,
						Dot = dot,
						Live = false,
					})
				end
			end
		end
	end

	local function smooth(x)
		return x * x * (3 - 2 * x)
	end

	RunService.RenderStepped:Connect(function()
		local count = #active

		if count == 0 then
			return
		end

		local now = os.clock()
		local hue = (now * Tracer.RainbowSpeed * 0.25) % 1
		local sequence

		if Tracer.ColorMode == "Rainbow" then
			sequence = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromHSV(hue, 0.75, 1)),
				ColorSequenceKeypoint.new(1, Color3.fromHSV((hue + 0.2) % 1, 0.75, 1)),
			})
		elseif Tracer.ColorMode == "Gradient" then
			sequence = ColorSequence.new(Tracer.Color1, Tracer.Color2)
		else
			sequence = ColorSequence.new(Tracer.Color1)
		end

		local dotColor = Tracer.ColorMode == "Rainbow" and Color3.fromHSV(hue, 0.75, 1) or Tracer.Color1
		local duration = Tracer.Duration
		local fadeTime = math.clamp(Tracer.FadeTime, 0.05, duration)
		local fadeStart = duration - fadeTime

		for index = count, 1, -1 do
			local entry = active[index]
			local age = now - entry.Born

			if age >= duration then
				destroyEntry(entry)
				table.remove(active, index)
			elseif age >= 0 then
				if not entry.Live then
					entry.Live = true
					entry.Beam.Enabled = true
					entry.GlowBeam.Enabled = Tracer.Glow
				end

				local progress = 1

				if Tracer.Travel then
					progress = math.clamp(age * Tracer.Speed / entry.Length, 0, 1)
				end

				entry.Head.WorldPosition = entry.Start:Lerp(entry.End, progress)

				local alpha = 0

				if age > fadeStart then
					alpha = smooth(math.clamp((age - fadeStart) / fadeTime, 0, 1))
				end

				local width = Tracer.Width * (1 - 0.5 * alpha)
				local base = Tracer.Transparency
				local transparency = base + (1 - base) * alpha

				local beam = entry.Beam
				beam.Color = sequence
				beam.LightEmission = Tracer.LightEmission
				beam.Transparency = NumberSequence.new(transparency)
				beam.Width0 = width
				beam.Width1 = Tracer.Taper and width * 0.2 or width

				local glowBeam = entry.GlowBeam
				glowBeam.Enabled = Tracer.Glow
				glowBeam.Color = sequence
				glowBeam.LightEmission = 1
				glowBeam.Transparency = NumberSequence.new(Tracer.GlowTransparency + (1 - Tracer.GlowTransparency) * alpha)
				glowBeam.Width0 = width * Tracer.GlowWidth
				glowBeam.Width1 = (Tracer.Taper and width * 0.2 or width) * Tracer.GlowWidth

				local dot = entry.Dot

				if Tracer.Impact and progress >= 1 then
					dot.Color = dotColor
					dot.Size = Vector3.one * Tracer.ImpactSize * (1 - 0.5 * alpha)
					dot.Transparency = 0.15 + 0.85 * alpha
				else
					dot.Transparency = 1
				end
			end
		end
	end)

	local okGun, GunClass = pcall(function()
		return require(LocalPlayer.PlayerScripts.Modules.ItemTypes.Gun)
	end)

	if okGun and type(GunClass) == "table" and type(GunClass._Tracers) == "function" then
		local originalTracers = GunClass._Tracers

		GunClass._Tracers = function(self, data, ...)
			if Tracer.Enabled and type(data) == "table" and data.IsLocal and type(data.RaycastResults) == "table" then
				local okMuzzle, muzzle = pcall(function()
					return self.ViewModel:GetMuzzlePosition()
				end)

				if okMuzzle and typeof(muzzle) == "Vector3" then
					pcall(spawnTracer, data, muzzle)
				end

				if Tracer.HideDefault then
					return
				end
			end

			return originalTracers(self, data, ...)
		end
	end

	local MainSection = TracerTab:AddSection("Bullet Tracer", "Left", "zap", "bullettracer")

	MainSection:AddToggle({
		Name = "Enabled",
		Default = Tracer.Enabled,
		Flag = "BulletTracerEnabled",
		Callback = function(Value)
			Tracer.Enabled = Value
		end,
	})

	MainSection:AddToggle({
		Name = "Hide Default Tracer",
		Default = Tracer.HideDefault,
		Flag = "BulletTracerHideDefault",
		Callback = function(Value)
			Tracer.HideDefault = Value
		end,
	})

	MainSection:AddToggle({
		Name = "Follow Bullet",
		Default = Tracer.Travel,
		Flag = "BulletTracerTravel",
		Callback = function(Value)
			Tracer.Travel = Value
		end,
	})

	MainSection:AddSlider({
		Name = "Bullet Speed",
		Min = 200,
		Max = 5000,
		Default = Tracer.Speed,
		Increment = 50,
		Suffix = " st/s",
		Flag = "BulletTracerSpeed",
		Callback = function(Value)
			Tracer.Speed = Value
		end,
	})

	MainSection:AddSlider({
		Name = "Lifetime",
		Min = 0.5,
		Max = 10,
		Default = Tracer.Duration,
		Increment = 0.1,
		Suffix = " s",
		Flag = "BulletTracerDuration",
		Callback = function(Value)
			Tracer.Duration = Value
		end,
	})

	MainSection:AddSlider({
		Name = "Fade Out Time",
		Min = 0.1,
		Max = 10,
		Default = Tracer.FadeTime,
		Increment = 0.1,
		Suffix = " s",
		Flag = "BulletTracerFade",
		Callback = function(Value)
			Tracer.FadeTime = Value
		end,
	})

	MainSection:AddSlider({
		Name = "Max Tracers",
		Min = 10,
		Max = 200,
		Default = Tracer.MaxActive,
		Increment = 5,
		Flag = "BulletTracerMax",
		Callback = function(Value)
			Tracer.MaxActive = Value
		end,
	})

	local StyleSection = TracerTab:AddSection("Style", "Right", "sliders-horizontal", "bullettracerstyle")

	StyleSection:AddSlider({
		Name = "Width",
		Min = 0.02,
		Max = 1,
		Default = Tracer.Width,
		Increment = 0.01,
		Suffix = " st",
		Flag = "BulletTracerWidth",
		Callback = function(Value)
			Tracer.Width = Value
		end,
	})

	StyleSection:AddToggle({
		Name = "Taper",
		Default = Tracer.Taper,
		Flag = "BulletTracerTaper",
		Callback = function(Value)
			Tracer.Taper = Value
		end,
	})

	StyleSection:AddSlider({
		Name = "Transparency",
		Min = 0,
		Max = 90,
		Default = Tracer.Transparency * 100,
		Increment = 1,
		Suffix = "%",
		Flag = "BulletTracerTransparency",
		Callback = function(Value)
			Tracer.Transparency = Value / 100
		end,
	})

	StyleSection:AddSlider({
		Name = "Light Emission",
		Min = 0,
		Max = 1,
		Default = Tracer.LightEmission,
		Increment = 0.05,
		Flag = "BulletTracerEmission",
		Callback = function(Value)
			Tracer.LightEmission = Value
		end,
	})

	StyleSection:AddToggle({
		Name = "Glow",
		Default = Tracer.Glow,
		Flag = "BulletTracerGlow",
		Callback = function(Value)
			Tracer.Glow = Value
		end,
	})

	StyleSection:AddSlider({
		Name = "Glow Size",
		Min = 1,
		Max = 8,
		Default = Tracer.GlowWidth,
		Increment = 0.5,
		Suffix = "x",
		Flag = "BulletTracerGlowSize",
		Callback = function(Value)
			Tracer.GlowWidth = Value
		end,
	})

	local ColorSection = TracerTab:AddSection("Colors", "Right", "palette", "bullettracercolors")

	ColorSection:AddDropdown({
		Name = "Color Mode",
		Options = { "Static", "Gradient", "Rainbow" },
		Default = Tracer.ColorMode,
		Flag = "BulletTracerColorMode",
		Callback = function(Value)
			Tracer.ColorMode = Value
		end,
	})

	ColorSection:AddColorPicker({
		Name = "Color",
		Default = Tracer.Color1,
		Flag = "BulletTracerColor1",
		Callback = function(Color)
			Tracer.Color1 = Color
		end,
	})

	ColorSection:AddColorPicker({
		Name = "Gradient Color",
		Default = Tracer.Color2,
		Flag = "BulletTracerColor2",
		Callback = function(Color)
			Tracer.Color2 = Color
		end,
	})

	ColorSection:AddSlider({
		Name = "Rainbow Speed",
		Min = 0.1,
		Max = 3,
		Default = Tracer.RainbowSpeed,
		Increment = 0.1,
		Suffix = "x",
		Flag = "BulletTracerRainbowSpeed",
		Callback = function(Value)
			Tracer.RainbowSpeed = Value
		end,
	})

	local ImpactSection = TracerTab:AddSection("Impact", "Left", "target", "bullettracerimpact")

	ImpactSection:AddToggle({
		Name = "Impact Dot",
		Default = Tracer.Impact,
		Flag = "BulletTracerImpact",
		Callback = function(Value)
			Tracer.Impact = Value
		end,
	})

	ImpactSection:AddSlider({
		Name = "Impact Size",
		Min = 0.1,
		Max = 2,
		Default = Tracer.ImpactSize,
		Increment = 0.05,
		Suffix = " st",
		Flag = "BulletTracerImpactSize",
		Callback = function(Value)
			Tracer.ImpactSize = Value
		end,
	})

	ImpactSection:AddButton({
		Name = "Test Tracer",
		Callback = function()
			local camera = workspace.CurrentCamera
			local cf = camera.CFrame
			local startPos = (cf * CFrame.new(0.9, -0.7, -2)).Position
			local params = RaycastParams.new()
			params.FilterType = Enum.RaycastFilterType.Exclude
			params.FilterDescendantsInstances = { camera, LocalPlayer.Character, container }
			local hit = workspace:Raycast(cf.Position, cf.LookVector * 400, params)
			local endPos = hit and hit.Position or cf.Position + cf.LookVector * 400
			spawnTracer({ RaycastResults = { { Position = endPos } } }, startPos)
		end,
	})

	ImpactSection:AddButton({
		Name = "Clear Tracers",
		Callback = function()
			for index = #active, 1, -1 do
				destroyEntry(active[index])
				active[index] = nil
			end
		end,
	})
end

do
	local DamageTab = Visual:AddSubTab("Damage Indicator", "hash")

	local Damage = {
		Enabled = false,
		Mode = "Enemy",
		DuelOnly = true,
		Animation = "Float Up",
		Font = "GothamBlack",
		Format = "Plain",
		CritMarker = true,
		TextSize = 26,
		CritScale = 1.35,
		Duration = 1.3,
		Rise = 70,
		Spread = 25,
		HeightOffset = 1,
		Follow = false,
		DistanceScale = true,
		ColorMode = "Static",
		Color1 = Color3.fromRGB(255, 255, 255),
		Color2 = Color3.fromRGB(255, 80, 180),
		CritColor1 = Color3.fromRGB(255, 220, 60),
		CritColor2 = Color3.fromRGB(255, 60, 60),
		RainbowSpeed = 1,
		Outline = true,
		OutlineColor = Color3.fromRGB(0, 0, 0),
		OutlineThickness = 2,
		MaxActive = 40,
	}

	local fonts = {
		"GothamBlack",
		"GothamBold",
		"Arcade",
		"Bangers",
		"LuckiestGuy",
		"PermanentMarker",
		"FredokaOne",
		"Oswald",
		"SciFi",
		"Michroma",
		"Creepster",
		"SpecialElite",
		"Code",
		"RobotoMono",
		"Cartoon",
		"Fantasy",
		"Highway",
	}

	local animations = {
		"Float Up",
		"Pop",
		"Bounce",
		"Arc",
		"Drift",
		"Drop",
		"Spiral",
		"Shake",
		"Zoom Out",
	}

	local DamageGui = Instance.new("ScreenGui")
	DamageGui.Name = "CustomDamageIndicator"
	DamageGui.ResetOnSpawn = false
	DamageGui.IgnoreGuiInset = true
	DamageGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	DamageGui.DisplayOrder = 51
	DamageGui.Parent = gethui and gethui() or game:GetService("CoreGui")

	local active = {}

	local function easeOut(x)
		return 1 - (1 - x) ^ 3
	end

	local function easeOutBack(x)
		local c1 = 1.70158
		local c3 = c1 + 1
		return 1 + c3 * (x - 1) ^ 3 + c1 * (x - 1) ^ 2
	end

	local function animate(name, t, side, rise)
		local dx, dy, scale, rotation = 0, 0, 1, 0

		if name == "Float Up" then
			dy = -easeOut(t) * rise
			scale = 0.6 + 0.4 * easeOut(math.min(t / 0.12, 1))
		elseif name == "Pop" then
			scale = 0.2 + 0.8 * easeOutBack(math.min(t / 0.22, 1))
			dy = -t * rise * 0.35
		elseif name == "Bounce" then
			dy = -math.abs(math.sin(t * math.pi * 2.5)) * rise * 0.7 * (1 - t)
			scale = 0.7 + 0.3 * easeOut(math.min(t / 0.1, 1))
		elseif name == "Arc" then
			dx = side * rise * 1.2 * t
			dy = -(rise * 2 * t - rise * 2.2 * t * t)
			scale = 0.7 + 0.3 * easeOut(math.min(t / 0.1, 1))
			rotation = side * 12 * t
		elseif name == "Drift" then
			dx = side * rise * 0.9 * easeOut(t)
			dy = -rise * 0.5 * t
			scale = 0.8 + 0.2 * easeOut(math.min(t / 0.15, 1))
			rotation = side * 8 * (1 - t)
		elseif name == "Drop" then
			dy = -rise * 0.45 + rise * 1.2 * t * t
			scale = 0.8 + 0.2 * easeOut(math.min(t / 0.1, 1))
		elseif name == "Spiral" then
			local angle = t * math.pi * 2 * side
			local radius = rise * 0.6 * t
			dx = math.cos(angle) * radius
			dy = -math.sin(angle) * radius - rise * 0.4 * t
			scale = 0.6 + 0.4 * easeOut(math.min(t / 0.15, 1))
		elseif name == "Shake" then
			local power = (1 - t) * 7
			dx = math.sin(t * 70) * power
			dy = math.cos(t * 55) * power - rise * 0.5 * t
			scale = 0.8 + 0.2 * easeOut(math.min(t / 0.1, 1))
			rotation = math.sin(t * 45) * 6 * (1 - t)
		elseif name == "Zoom Out" then
			scale = 2.4 - 1.4 * easeOut(math.min(t / 0.25, 1))
			dy = -rise * 0.5 * t
		end

		return dx, dy, scale, rotation
	end

	local function destroyEntry(entry)
		pcall(function()
			entry.Label:Destroy()
		end)
	end

	local function formatText(amount, crit)
		local number = tostring(math.floor(amount + 0.5))
		local text = number

		if Damage.Format == "Minus" then
			text = "-" .. number
		elseif Damage.Format == "Plus" then
			text = "+" .. number
		elseif Damage.Format == "HP" then
			text = number .. " HP"
		end

		if crit and Damage.CritMarker then
			text = text .. "!"
		end

		return text
	end

	local function damageColor(amount)
		local alpha = math.clamp(amount / 100, 0, 1)

		if alpha < 0.5 then
			return Color3.fromRGB(80, 255, 120):Lerp(Color3.fromRGB(255, 230, 60), alpha * 2)
		end

		return Color3.fromRGB(255, 230, 60):Lerp(Color3.fromRGB(255, 60, 60), (alpha - 0.5) * 2)
	end

	local function spawnIndicator(amount, crit, position, part, screenPos, overrideColor)
		if position then
			local screen, onScreen = workspace.CurrentCamera:WorldToViewportPoint(position)

			if not onScreen or screen.Z <= 0 then
				position, part = nil, nil
			end
		end

		while #active >= Damage.MaxActive do
			destroyEntry(table.remove(active, 1))
		end

		local label = Instance.new("TextLabel")
		label.AnchorPoint = Vector2.new(0.5, 0.5)
		label.BackgroundTransparency = 1
		label.Size = UDim2.fromOffset(240, 80)
		label.Text = formatText(amount, crit)
		label.TextColor3 = Color3.new(1, 1, 1)
		label.TextSize = math.floor(Damage.TextSize * (crit and Damage.CritScale or 1))
		label.TextWrapped = false
		label.ZIndex = 60
		label.Visible = false
		pcall(function()
			label.Font = Enum.Font[Damage.Font]
		end)

		local stroke = Instance.new("UIStroke")
		stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
		stroke.Color = Damage.OutlineColor
		stroke.Thickness = Damage.OutlineThickness
		stroke.Enabled = Damage.Outline
		stroke.Parent = label

		local gradient = Instance.new("UIGradient")
		gradient.Rotation = 90
		gradient.Parent = label

		local uiScale = Instance.new("UIScale")
		uiScale.Parent = label

		label.Parent = DamageGui

		local offset = Vector3.zero

		if part and part.Parent and position then
			offset = position - part.Position
		end

		table.insert(active, {
			Label = label,
			Stroke = stroke,
			Gradient = gradient,
			Scale = uiScale,
			Amount = amount,
			Crit = crit,
			Position = position,
			Part = part,
			Offset = offset,
			Screen = screenPos,
			Override = overrideColor,
			Born = os.clock(),
			Side = math.random() < 0.5 and -1 or 1,
			Jitter = (math.random() - 0.5) * 2 * Damage.Spread,
			Seed = math.random(),
			Animation = Damage.Animation,
		})
	end

	HitTrack.spawnDamage = spawnIndicator
	HitTrack.damageMode = function()
		return Damage.Mode
	end

	RunService.RenderStepped:Connect(function()
		local count = #active

		if count == 0 then
			return
		end

		local camera = workspace.CurrentCamera
		local now = os.clock()
		local duration = math.max(Damage.Duration, 0.1)

		for index = count, 1, -1 do
			local entry = active[index]
			local t = (now - entry.Born) / duration

			if t >= 1 or not entry.Label.Parent then
				destroyEntry(entry)
				table.remove(active, index)
			else
				local label = entry.Label
				local worldPosition = entry.Position
				local screenX, screenY, visible, distance

				if entry.Screen then
					screenX, screenY = entry.Screen.X, entry.Screen.Y
					visible = true
					distance = 30
				elseif worldPosition then
					if Damage.Follow and entry.Part and entry.Part.Parent then
						worldPosition = entry.Part.Position + entry.Offset
					end

					local lifted = worldPosition + Vector3.new(0, Damage.HeightOffset, 0)
					local screen, onScreen = camera:WorldToViewportPoint(lifted)
					screenX, screenY = screen.X, screen.Y
					visible = onScreen and screen.Z > 0
					distance = screen.Z
				else
					local size = camera.ViewportSize
					screenX, screenY = size.X / 2, size.Y / 2 - 40
					visible = true
					distance = 30
				end

				if not visible then
					label.Visible = false
				else
					local distanceScale = 1

					if Damage.DistanceScale and worldPosition then
						distanceScale = math.clamp(45 / math.max(distance, 1), 0.5, 1.5)
					end

					local rise = Damage.Rise * distanceScale
					local dx, dy, scale, rotation = animate(entry.Animation, t, entry.Side, rise)

					label.Position = UDim2.fromOffset(screenX + dx + entry.Jitter * distanceScale, screenY + dy)
					label.Rotation = rotation
					entry.Scale.Scale = scale * distanceScale
					label.Visible = true

					local alpha = 0

					if t < 0.08 then
						alpha = 1 - t / 0.08
					elseif t > 0.55 then
						local fade = (t - 0.55) / 0.45
						alpha = fade * fade * (3 - 2 * fade)
					end

					label.TextTransparency = alpha
					entry.Stroke.Transparency = alpha
					entry.Stroke.Enabled = Damage.Outline
					entry.Stroke.Color = Damage.OutlineColor
					entry.Stroke.Thickness = Damage.OutlineThickness

					local mode = Damage.ColorMode
					local crit = entry.Crit

					if entry.Override then
						label.TextColor3 = Color3.new(1, 1, 1)
						entry.Gradient.Color = ColorSequence.new(entry.Override)
					elseif mode == "Gradient" then
						label.TextColor3 = Color3.new(1, 1, 1)
						entry.Gradient.Color = ColorSequence.new(
							crit and Damage.CritColor1 or Damage.Color1,
							crit and Damage.CritColor2 or Damage.Color2
						)
					elseif mode == "Rainbow" then
						label.TextColor3 = Color3.new(1, 1, 1)
						local hue = (now * Damage.RainbowSpeed * 0.5 + entry.Seed) % 1
						entry.Gradient.Color = ColorSequence.new(
							Color3.fromHSV(hue, 0.75, 1),
							Color3.fromHSV((hue + 0.25) % 1, 0.75, 1)
						)
					elseif mode == "By Damage" then
						label.TextColor3 = Color3.new(1, 1, 1)
						local color = damageColor(entry.Amount)
						entry.Gradient.Color = ColorSequence.new(color, color:Lerp(Color3.new(0, 0, 0), 0.25))
					else
						label.TextColor3 = Color3.new(1, 1, 1)
						local color = crit and Damage.CritColor1 or Damage.Color1
						entry.Gradient.Color = ColorSequence.new(color)
					end
				end
			end
		end
	end)

	local okUtility, PlayerDataUtility = pcall(function()
		return require(ReplicatedStorage.Modules.PlayerDataUtility)
	end)

	if okUtility and type(PlayerDataUtility) == "table" and type(PlayerDataUtility.GetSetting) == "function" then
		local originalGetSetting = PlayerDataUtility.GetSetting

		PlayerDataUtility.GetSetting = function(self, controller, name, ...)
			if Damage.Enabled and name == "Damage Numbers" then
				return false
			end

			return originalGetSetting(self, controller, name, ...)
		end
	end

	local lastSpawn = 0
	local enemyLast = setmetatable({}, { __mode = "k" })
	local damageStamp = setmetatable({}, { __mode = "k" })
	local drops = {}
	local dealt = nil

	local function getEntityOf(instance)
		local entity = instance

		while entity and not CollectionService:HasTag(entity, "Entity") do
			entity = entity.Parent
		end

		if entity then
			return entity
		end

		local model = instance and instance:FindFirstAncestorOfClass("Model")

		if model and model:FindFirstChildOfClass("Humanoid") then
			return model
		end

		return nil
	end

	local function isDuelEnemyModel(instance)
		if not instance then
			return false
		end

		local entity = getEntityOf(instance)

		if not entity then
			return false
		end

		local fighter = getFighter(entity)
		local owner = fighter and fighter.Player

		return owner ~= nil and isDuelEnemy(owner)
	end

	local function duelContextKnown()
		local ok, result = pcall(function()
			local duel = DuelSpectateController.CurrentDuelSubject
			return duel ~= nil and duel:GetDueler(LocalPlayer) ~= nil
		end)

		return ok and result or false
	end

	local function passesDuelFilter(model)
		if not Damage.DuelOnly or not duelContextKnown() then
			return true
		end

		return isDuelEnemyModel(model)
	end

	local function pickHitPart(model, crit)
		local okInfo, infoPosition, infoPart = pcall(HitTrack.getHitInfo, crit)

		if okInfo and infoPart and infoPart:IsDescendantOf(model) then
			return infoPosition, infoPart
		end

		local part

		if crit then
			part = model:FindFirstChild("Head", true) or model:FindFirstChild("HumanoidRootPart", true)
		else
			part = model:FindFirstChild("HumanoidRootPart", true) or model:FindFirstChild("Head", true)
		end

		if part and part:IsA("BasePart") then
			return part.Position, part
		end

		return nil, nil
	end

	local function emit(model, amount, crit)
		local position, part

		if Damage.Mode == "Enemy" then
			position, part = pickHitPart(model, crit)
		end

		lastSpawn = os.clock()
		HitTrack.LastDamage = os.clock()

		if not pcall(spawnIndicator, amount, crit, position, part) then
			pcall(spawnIndicator, amount, crit, nil, nil)
		end
	end

	local function centerDistance(model)
		local root = model:FindFirstChild("HumanoidRootPart", true) or model:FindFirstChild("Head", true)

		if not root or not root:IsA("BasePart") then
			return math.huge
		end

		local camera = workspace.CurrentCamera
		local screen = camera:WorldToViewportPoint(root.Position)

		if screen.Z <= 0 then
			return math.huge
		end

		local center = camera.ViewportSize / 2

		return (Vector2.new(screen.X, screen.Y) - center).Magnitude
	end

	local function resolveDealt()
		if not dealt then
			return
		end

		local now = os.clock()

		if now - lastSpawn < 0.25 or now - (HitTrack.FallbackDamage or 0) < 0.4 then
			dealt = nil
			return
		end

		local best, bestScore

		for index = #drops, 1, -1 do
			local drop = drops[index]

			if now - drop.Time > 0.8 then
				table.remove(drops, index)
			elseif math.abs(drop.Time - dealt.Time) <= 0.5 then
				local score = centerDistance(drop.Model)

				if not bestScore or score < bestScore then
					best, bestScore = drop, score
				end
			end
		end

		if best then
			local crit = dealt.Crit
			table.remove(drops, table.find(drops, best))
			dealt = nil

			if passesDuelFilter(best.Model) then
				emit(best.Model, best.Amount, crit)
			end
		elseif now - dealt.Time > 0.7 then
			dealt = nil
		end
	end

	RunService.Heartbeat:Connect(function()
		if not Damage.Enabled then
			dealt = nil
			table.clear(drops)
			return
		end

		local models = {}
		local seen = {}

		for _, model in ipairs(CollectionService:GetTagged("Entity")) do
			if not seen[model] then
				seen[model] = true
				table.insert(models, model)
			end
		end

		for _, player in ipairs(Players:GetPlayers()) do
			local character = player.Character

			if player ~= LocalPlayer and character and not seen[character] then
				seen[character] = true
				table.insert(models, character)
			end
		end

		for _, model in ipairs(models) do
			if model ~= LocalPlayer.Character then
				local humanoid = model:FindFirstChildOfClass("Humanoid")

				if humanoid then
					local health = humanoid.Health
					local last = enemyLast[model]

					if last and last - health >= 0.5 and HitTrack.isEnemy(model) then
						table.insert(drops, { Model = model, Amount = last - health, Time = os.clock() })

						if #drops > 30 then
							table.remove(drops, 1)
						end
					end

					enemyLast[model] = health
				end
			end
		end

		resolveDealt()
	end)

	local function readDamage(data)
		local amount = tonumber(data[utf8.char(0)])

		if amount then
			return amount
		end

		for _, value in pairs(data) do
			if type(value) == "number" and value ~= 0 then
				return value
			end
		end

		return nil
	end

	local function readCrit(data)
		local flag = data[utf8.char(1)]

		if type(flag) == "number" then
			return flag ~= 0
		end

		return flag == true
	end

	if okCrosshair and type(CrosshairClass) == "table" and type(CrosshairClass.DamageEffect) == "function" then
		local originalDamageEffect = CrosshairClass.DamageEffect

		CrosshairClass.DamageEffect = function(self, data, ...)
			if Damage.Enabled and type(data) == "table" then
				local okLocal, isLocal = pcall(function()
					return self.Mouse.ItemInterface.ClientItem.ClientFighter.IsLocalPlayer
				end)

				if okLocal and isLocal then
					local okRead, amount = pcall(readDamage, data)

					if okRead and amount and amount ~= 0 then
						dealt = { Time = os.clock(), Crit = readCrit(data) }
					end
				end
			end

			return originalDamageEffect(self, data, ...)
		end
	end

	if okCrosshair and type(CrosshairClass) == "table" and type(CrosshairClass.Update) == "function" then
		local previousUpdate = CrosshairClass.Update

		CrosshairClass.Update = function(self, ...)
			if Damage.Enabled then
				local okLocal, isLocal = pcall(function()
					return self.Mouse.ItemInterface.ClientItem.ClientFighter.IsLocalPlayer
				end)

				if okLocal and isLocal then
					local stamp = self._last_damage_dealt_time

					if stamp and stamp ~= 0 and stamp ~= damageStamp[self] then
						damageStamp[self] = stamp

						if tick() - stamp < 0.5 then
							local crit = false

							pcall(function()
								crit = self.Crosshair._last_hitmarker_crit_set and true or false
							end)

							dealt = { Time = os.clock(), Crit = crit }
						end
					end
				end
			end

			return previousUpdate(self, ...)
		end
	end

	local MainSection = DamageTab:AddSection("Damage Indicator", "Left", "hash", "damageindicator")

	MainSection:AddToggle({
		Name = "Custom Damage Indicator",
		Default = Damage.Enabled,
		Flag = "DamageIndicatorEnabled",
		Callback = function(Value)
			Damage.Enabled = Value
			HitTrack.DamageEnabled = Value
		end,
	})

	MainSection:AddToggle({
		Name = "Duel Enemy Only",
		Default = Damage.DuelOnly,
		Flag = "DamageIndicatorDuelOnly",
		Callback = function(Value)
			Damage.DuelOnly = Value
		end,
	})

	MainSection:AddDropdown({
		Name = "Position",
		Options = { "Enemy", "Crosshair" },
		Default = Damage.Mode,
		Flag = "DamageIndicatorMode",
		Callback = function(Value)
			Damage.Mode = Value
		end,
	})

	MainSection:AddDropdown({
		Name = "Animation",
		Options = animations,
		Default = Damage.Animation,
		Flag = "DamageIndicatorAnimation",
		Callback = function(Value)
			Damage.Animation = Value
		end,
	})

	MainSection:AddDropdown({
		Name = "Format",
		Options = { "Plain", "Minus", "Plus", "HP" },
		Default = Damage.Format,
		Flag = "DamageIndicatorFormat",
		Callback = function(Value)
			Damage.Format = Value
		end,
	})

	MainSection:AddToggle({
		Name = "Crit Marker (!)",
		Default = Damage.CritMarker,
		Flag = "DamageIndicatorCritMarker",
		Callback = function(Value)
			Damage.CritMarker = Value
		end,
	})

	MainSection:AddSlider({
		Name = "Duration",
		Min = 0.3,
		Max = 4,
		Default = Damage.Duration,
		Increment = 0.1,
		Suffix = " s",
		Flag = "DamageIndicatorDuration",
		Callback = function(Value)
			Damage.Duration = Value
		end,
	})

	MainSection:AddSlider({
		Name = "Travel Distance",
		Min = 10,
		Max = 200,
		Default = Damage.Rise,
		Increment = 5,
		Suffix = " px",
		Flag = "DamageIndicatorRise",
		Callback = function(Value)
			Damage.Rise = Value
		end,
	})

	MainSection:AddSlider({
		Name = "Random Spread",
		Min = 0,
		Max = 100,
		Default = Damage.Spread,
		Increment = 1,
		Suffix = " px",
		Flag = "DamageIndicatorSpread",
		Callback = function(Value)
			Damage.Spread = Value
		end,
	})

	MainSection:AddSlider({
		Name = "Height Offset",
		Min = -2,
		Max = 5,
		Default = Damage.HeightOffset,
		Increment = 0.25,
		Suffix = " st",
		Flag = "DamageIndicatorHeight",
		Callback = function(Value)
			Damage.HeightOffset = Value
		end,
	})

	MainSection:AddToggle({
		Name = "Follow Enemy",
		Default = Damage.Follow,
		Flag = "DamageIndicatorFollow",
		Callback = function(Value)
			Damage.Follow = Value
		end,
	})

	MainSection:AddToggle({
		Name = "Distance Scale",
		Default = Damage.DistanceScale,
		Flag = "DamageIndicatorDistanceScale",
		Callback = function(Value)
			Damage.DistanceScale = Value
		end,
	})

	local TextSection = DamageTab:AddSection("Text", "Right", "type", "damageindicatortext")

	TextSection:AddDropdown({
		Name = "Font",
		Options = fonts,
		Default = Damage.Font,
		Flag = "DamageIndicatorFont",
		Callback = function(Value)
			Damage.Font = Value
		end,
	})

	TextSection:AddSlider({
		Name = "Text Size",
		Min = 12,
		Max = 60,
		Default = Damage.TextSize,
		Increment = 1,
		Suffix = " px",
		Flag = "DamageIndicatorSize",
		Callback = function(Value)
			Damage.TextSize = Value
		end,
	})

	TextSection:AddSlider({
		Name = "Crit Scale",
		Min = 1,
		Max = 2.5,
		Default = Damage.CritScale,
		Increment = 0.05,
		Suffix = "x",
		Flag = "DamageIndicatorCritScale",
		Callback = function(Value)
			Damage.CritScale = Value
		end,
	})

	TextSection:AddToggle({
		Name = "Outline",
		Default = Damage.Outline,
		Flag = "DamageIndicatorOutline",
		Callback = function(Value)
			Damage.Outline = Value
		end,
	})

	TextSection:AddSlider({
		Name = "Outline Thickness",
		Min = 0.5,
		Max = 5,
		Default = Damage.OutlineThickness,
		Increment = 0.5,
		Suffix = " px",
		Flag = "DamageIndicatorOutlineThickness",
		Callback = function(Value)
			Damage.OutlineThickness = Value
		end,
	})

	TextSection:AddColorPicker({
		Name = "Outline Color",
		Default = Damage.OutlineColor,
		Flag = "DamageIndicatorOutlineColor",
		Callback = function(Color)
			Damage.OutlineColor = Color
		end,
	})

	local ColorSection = DamageTab:AddSection("Colors", "Right", "palette", "damageindicatorcolors")

	ColorSection:AddDropdown({
		Name = "Color Mode",
		Options = { "Static", "Gradient", "By Damage", "Rainbow" },
		Default = Damage.ColorMode,
		Flag = "DamageIndicatorColorMode",
		Callback = function(Value)
			Damage.ColorMode = Value
		end,
	})

	ColorSection:AddColorPicker({
		Name = "Color",
		Default = Damage.Color1,
		Flag = "DamageIndicatorColor1",
		Callback = function(Color)
			Damage.Color1 = Color
		end,
	})

	ColorSection:AddColorPicker({
		Name = "Gradient Color",
		Default = Damage.Color2,
		Flag = "DamageIndicatorColor2",
		Callback = function(Color)
			Damage.Color2 = Color
		end,
	})

	ColorSection:AddColorPicker({
		Name = "Crit Color",
		Default = Damage.CritColor1,
		Flag = "DamageIndicatorCritColor1",
		Callback = function(Color)
			Damage.CritColor1 = Color
		end,
	})

	ColorSection:AddColorPicker({
		Name = "Crit Gradient Color",
		Default = Damage.CritColor2,
		Flag = "DamageIndicatorCritColor2",
		Callback = function(Color)
			Damage.CritColor2 = Color
		end,
	})

	ColorSection:AddSlider({
		Name = "Rainbow Speed",
		Min = 0.1,
		Max = 3,
		Default = Damage.RainbowSpeed,
		Increment = 0.1,
		Suffix = "x",
		Flag = "DamageIndicatorRainbowSpeed",
		Callback = function(Value)
			Damage.RainbowSpeed = Value
		end,
	})

	local TestSection = DamageTab:AddSection("Test", "Left", "flask-conical", "damageindicatortest")

	TestSection:AddButton({
		Name = "Test Damage",
		Callback = function()
			local camera = workspace.CurrentCamera
			local crit = math.random() < 0.35
			local amount = crit and math.random(90, 180) or math.random(15, 85)
			local position = camera.CFrame.Position + camera.CFrame.LookVector * 18
			spawnIndicator(amount, crit, position, nil)
		end,
	})

	TestSection:AddButton({
		Name = "Test Crit",
		Callback = function()
			local camera = workspace.CurrentCamera
			local position = camera.CFrame.Position + camera.CFrame.LookVector * 18
			spawnIndicator(math.random(110, 190), true, position, nil)
		end,
	})

	TestSection:AddButton({
		Name = "Clear",
		Callback = function()
			for index = #active, 1, -1 do
				destroyEntry(active[index])
				active[index] = nil
			end
		end,
	})
end

do
	local Players = game:GetService("Players")
	local LP = Players.LocalPlayer

	local Spoof = {
		NameSpoof = false,
		YourName = "ZeroUser",
		EnemyName = "Victim",
		LevelSpoof = false,
		Level = 10,
		WinstreakSpoof = false,
		Winstreak = 10,
	}

	local realName = LP.Name
	local realDisplay = LP.DisplayName
	local localTexts = {
		[realName] = true,
		[realDisplay] = true,
		[Spoof.YourName] = true,
	}
	local originals = {}
	local labelOriginals = setmetatable({}, { __mode = "k" })
	local originalLevel = nil
	local originalLevelAttr = nil
	local originalStreak = nil
	local originalStreakAttr = nil

	local GUI_PATH = {
		"PlayerGui", "MainGui", "PlayerList", "Container",
		"Elements", "Container", "Middle", "List", "Container",
	}

	local function getListContainer()
		local node = LP
		for _, name in ipairs(GUI_PATH) do
			if not node then
				return nil
			end
			node = node:FindFirstChild(name)
		end
		return node
	end

	local function spoofPlayer(player)
		if not Spoof.NameSpoof then
			return
		end
		if not originals[player] then
			originals[player] = { Name = player.Name, DisplayName = player.DisplayName }
		end
		local newName = player == LP and Spoof.YourName or Spoof.EnemyName
		pcall(function()
			player.Name = newName
			player.DisplayName = newName
		end)
	end

	local function spoofLabel(label)
		local current = label.Text
		local target = localTexts[current] and Spoof.YourName or Spoof.EnemyName
		if current ~= target then
			labelOriginals[label] = current
			label.Text = target
		end
	end

	local function collectTitleLabels(instance, results)
		for _, child in ipairs(instance:GetChildren()) do
			if child:IsA("TextLabel") and child.Name == "Title" then
				table.insert(results, child)
			end
			collectTitleLabels(child, results)
		end
		return results
	end

	local function spoofList()
		local container = getListContainer()
		if not container then
			return
		end
		for _, playerFrame in ipairs(container:GetChildren()) do
			if playerFrame:IsA("Frame") then
				for _, label in ipairs(collectTitleLabels(playerFrame, {})) do
					spoofLabel(label)
				end
			end
		end
	end

	local function applyNames()
		for _, player in ipairs(Players:GetPlayers()) do
			spoofPlayer(player)
		end
		pcall(spoofList)
	end

	local function restoreNames()
		for player, saved in pairs(originals) do
			pcall(function()
				player.Name = saved.Name
				player.DisplayName = saved.DisplayName
			end)
		end
		originals = {}
		for label, text in pairs(labelOriginals) do
			if label.Parent then
				label.Text = text
			end
		end
		labelOriginals = setmetatable({}, { __mode = "k" })
	end

	local function getLeaderstats()
		return LP:FindFirstChild("CustomLeaderstats")
	end

	local function getStreakValue(leaderstats)
		local node = leaderstats and leaderstats:FindFirstChild("Win Streak")
		if not node then
			return nil
		end
		if node:IsA("IntValue") then
			return node
		end
		return node:FindFirstChildWhichIsA("IntValue")
	end

	local function applyStats()
		local leaderstats = getLeaderstats()
		if not leaderstats then
			return
		end
		if Spoof.LevelSpoof then
			local levelVal = leaderstats:FindFirstChild("Level")
			if levelVal and levelVal:IsA("IntValue") then
				if originalLevel == nil then
					originalLevel = levelVal.Value
				end
				levelVal.Value = Spoof.Level
			end
			pcall(function()
				if originalLevelAttr == nil then
					originalLevelAttr = LP:GetAttribute("Level")
				end
				LP:SetAttribute("Level", Spoof.Level)
			end)
		end
		if Spoof.WinstreakSpoof then
			local streakVal = getStreakValue(leaderstats)
			if streakVal then
				if originalStreak == nil then
					originalStreak = streakVal.Value
				end
				streakVal.Value = Spoof.Winstreak
			end
			pcall(function()
				if originalStreakAttr == nil then
					originalStreakAttr = LP:GetAttribute("StatisticDuelsWinStreak")
				end
				LP:SetAttribute("StatisticDuelsWinStreak", Spoof.Winstreak)
			end)
		end
	end

	local function restoreLevel()
		local leaderstats = getLeaderstats()
		local levelVal = leaderstats and leaderstats:FindFirstChild("Level")
		if levelVal and levelVal:IsA("IntValue") and originalLevel ~= nil then
			levelVal.Value = originalLevel
		end
		pcall(function()
			LP:SetAttribute("Level", originalLevelAttr)
		end)
		originalLevel = nil
		originalLevelAttr = nil
	end

	local function restoreStreak()
		local streakVal = getStreakValue(getLeaderstats())
		if streakVal and originalStreak ~= nil then
			streakVal.Value = originalStreak
		end
		pcall(function()
			LP:SetAttribute("StatisticDuelsWinStreak", originalStreakAttr)
		end)
		originalStreak = nil
		originalStreakAttr = nil
	end

	Players.PlayerAdded:Connect(spoofPlayer)

	task.spawn(function()
		while task.wait(0.5) do
			if Spoof.NameSpoof then
				pcall(spoofList)
			end
		end
	end)

	task.spawn(function()
		while task.wait(1) do
			if Spoof.LevelSpoof or Spoof.WinstreakSpoof then
				pcall(applyStats)
			end
		end
	end)

	local SpooferTab = Window:AddTab("Spoofer", "users")

	local NameSection = SpooferTab:AddSection("Name Spoofer", "Left", "user", "spoofername")
	NameSection:AddToggle({
		Name = "Name Spoofer",
		Default = false,
		Flag = "SpooferNameEnabled",
		Callback = function(Value)
			Spoof.NameSpoof = Value
			if Value then
				applyNames()
			else
				restoreNames()
			end
		end,
	})
	NameSection:AddTextbox({
		Name = "Your Name",
		Placeholder = "ZeroUser",
		Default = Spoof.YourName,
		Flag = "SpooferYourName",
		Callback = function(Text)
			if Text == "" then
				return
			end
			Spoof.YourName = Text
			localTexts[Text] = true
			if Spoof.NameSpoof then
				applyNames()
			end
		end,
	})
	NameSection:AddTextbox({
		Name = "Enemy Name",
		Placeholder = "Victim",
		Default = Spoof.EnemyName,
		Flag = "SpooferEnemyName",
		Callback = function(Text)
			if Text == "" then
				return
			end
			Spoof.EnemyName = Text
			if Spoof.NameSpoof then
				applyNames()
			end
		end,
	})

	local StatsSection = SpooferTab:AddSection("Stats Spoofer", "Right", "bar-chart", "spooferstats")
	StatsSection:AddToggle({
		Name = "Level Spoofer",
		Default = false,
		Flag = "SpooferLevelEnabled",
		Callback = function(Value)
			Spoof.LevelSpoof = Value
			if Value then
				applyStats()
			else
				restoreLevel()
			end
		end,
	})
	StatsSection:AddSlider({
		Name = "Level",
		Min = 0,
		Max = 1000,
		Default = Spoof.Level,
		Increment = 1,
		Flag = "SpooferLevel",
		Callback = function(Value)
			Spoof.Level = Value
			if Spoof.LevelSpoof then
				applyStats()
			end
		end,
	})
	StatsSection:AddToggle({
		Name = "Winstreak Spoofer",
		Default = false,
		Flag = "SpooferWinstreakEnabled",
		Callback = function(Value)
			Spoof.WinstreakSpoof = Value
			if Value then
				applyStats()
			else
				restoreStreak()
			end
		end,
	})
	StatsSection:AddSlider({
		Name = "Winstreak",
		Min = 0,
		Max = 500,
		Default = Spoof.Winstreak,
		Increment = 1,
		Flag = "SpooferWinstreak",
		Callback = function(Value)
			Spoof.Winstreak = Value
			if Spoof.WinstreakSpoof then
				applyStats()
			end
		end,
	})
end

do
	local Movement = {
		Speed = false,
		SpeedAmount = 30,
		Fly = false,
		FlySpeed = 60,
		Jump = false,
		JumpPower = 60,
	}

	local jumpHeldUntil = 0
	local lastBoost = 0
	local controls

	pcall(function()
		controls = require(LocalPlayer.PlayerScripts:WaitForChild("PlayerModule", 3)):GetControls()
	end)

	local function getRoot()
		local character = LocalPlayer.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")
		return root, character
	end

	local function getDirection()
		local camera = workspace.CurrentCamera
		local move = Vector3.zero

		if controls then
			local ok, result = pcall(controls.GetMoveVector, controls)

			if ok and typeof(result) == "Vector3" then
				move = result
			end
		end

		if move.Magnitude > 0.01 and camera then
			return camera.CFrame:VectorToWorldSpace(move)
		end

		local _, character = getRoot()
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")

		if humanoid and humanoid.MoveDirection.Magnitude > 0.01 then
			return humanoid.MoveDirection
		end

		return Vector3.zero
	end

	RunService.Heartbeat:Connect(function(dt)
		if not (Movement.Fly or Movement.Speed) then
			return
		end

		local root = getRoot()

		if not root then
			return
		end

		local direction = getDirection()

		if Movement.Fly then
			local velocity = Vector3.zero

			if direction.Magnitude > 0.01 then
				velocity = direction.Unit * Movement.FlySpeed
			end

			if os.clock() < jumpHeldUntil then
				velocity = velocity + Vector3.new(0, Movement.FlySpeed, 0)
			end

			root.AssemblyLinearVelocity = Vector3.zero

			if velocity.Magnitude > 0 then
				root.CFrame = root.CFrame + velocity * dt
			end
		else
			local flat = Vector3.new(direction.X, 0, direction.Z)

			if flat.Magnitude > 0.01 then
				root.CFrame = root.CFrame + flat.Unit * Movement.SpeedAmount * dt
			end
		end
	end)

	UserInputService.JumpRequest:Connect(function()
		jumpHeldUntil = os.clock() + 0.2

		if not Movement.Jump or Movement.Fly then
			return
		end

		local root, character = getRoot()

		if not root or os.clock() - lastBoost < 0.25 then
			return
		end

		local params = RaycastParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.FilterDescendantsInstances = { character }

		if not workspace:Raycast(root.Position, Vector3.new(0, -5, 0), params) then
			return
		end

		lastBoost = os.clock()

		task.defer(function()
			local velocity = root.AssemblyLinearVelocity
			root.AssemblyLinearVelocity = Vector3.new(velocity.X, Movement.JumpPower, velocity.Z)
		end)
	end)

	local MovementSection = Player:AddSection("Movement", "Left", "zap", "playermovement")

	MovementSection:AddToggle({
		Name = "Speed Boost",
		Default = Movement.Speed,
		Flag = "PlayerSpeedBoost",
		Callback = function(Value)
			Movement.Speed = Value
		end,
	})

	MovementSection:AddSlider({
		Name = "Speed Boost Amount",
		Min = 5,
		Max = 150,
		Default = Movement.SpeedAmount,
		Increment = 1,
		Suffix = " st/s",
		Flag = "PlayerSpeedBoostAmount",
		Callback = function(Value)
			Movement.SpeedAmount = Value
		end,
	})

	MovementSection:AddToggle({
		Name = "Fly",
		Default = Movement.Fly,
		Flag = "PlayerFly",
		Callback = function(Value)
			Movement.Fly = Value
		end,
	})

	MovementSection:AddSlider({
		Name = "Fly Speed",
		Min = 10,
		Max = 250,
		Default = Movement.FlySpeed,
		Increment = 1,
		Suffix = " st/s",
		Flag = "PlayerFlySpeed",
		Callback = function(Value)
			Movement.FlySpeed = Value
		end,
	})

	MovementSection:AddToggle({
		Name = "Jump Boost",
		Default = Movement.Jump,
		Flag = "PlayerJumpBoost",
		Callback = function(Value)
			Movement.Jump = Value
		end,
	})

	MovementSection:AddSlider({
		Name = "Jump Boost Power",
		Min = 20,
		Max = 250,
		Default = Movement.JumpPower,
		Increment = 1,
		Flag = "PlayerJumpBoostPower",
		Callback = function(Value)
			Movement.JumpPower = Value
		end,
	})
end

do
	local Lighting = game:GetService("Lighting")

	local EnvTab = World:AddSubTab("Environment", "sun")
	local SkyTab = World:AddSubTab("Sky & Weather", "cloud-rain")
	local GradeTab = World:AddSubTab("Color Grading", "palette")
	local ViewmodelTab = World:AddSubTab("Viewmodel", "hand")

	local function bindToggle(section, label, flag, target, key)
		return section:AddToggle({
			Name = label,
			Default = target[key],
			Flag = flag,
			Callback = function(Value)
				target[key] = Value
			end,
		})
	end

	local function bindSlider(section, label, flag, target, key, min, max, increment, suffix, scale, onChange)
		scale = scale or 1
		return section:AddSlider({
			Name = label,
			Min = min,
			Max = max,
			Default = target[key] / scale,
			Increment = increment,
			Suffix = suffix,
			Flag = flag,
			Callback = function(Value)
				target[key] = Value * scale
				if onChange then
					onChange(Value * scale)
				end
			end,
		})
	end

	local function bindColor(section, label, flag, target, key, onChange)
		return section:AddColorPicker({
			Name = label,
			Default = target[key],
			Flag = flag,
			Callback = function(Color)
				target[key] = Color
				if onChange then
					onChange(Color)
				end
			end,
		})
	end

	local function bindDropdown(section, label, flag, options, target, key, onChange)
		return section:AddDropdown({
			Name = label,
			Options = options,
			Default = target[key],
			Flag = flag,
			Callback = function(Value)
				target[key] = Value
				if onChange then
					onChange(Value)
				end
			end,
		})
	end

	local Env = {
		Fullbright = false,
		NoShadows = false,
		BrightnessEnabled = false,
		Brightness = 2,
		ExposureEnabled = false,
		Exposure = 0,
		TimeEnabled = false,
		Time = 12,
		TimeCycle = false,
		CycleSpeed = 0.5,
		AmbientEnabled = false,
		Ambient = Color3.fromRGB(110, 90, 190),
		OutdoorAmbient = Color3.fromRGB(140, 120, 220),
		RainbowAmbient = false,
		RainbowSpeed = 5,
		ColorShiftEnabled = false,
		ColorShiftTop = Color3.fromRGB(255, 170, 120),
		ColorShiftBottom = Color3.fromRGB(120, 150, 255),
		FogEnabled = false,
		FogColor = Color3.fromRGB(160, 160, 190),
		FogStart = 0,
		FogEnd = 300,
		FovEnabled = false,
		Fov = 90,
	}

	local Atmosphere = {
		Enabled = false,
		Values = {
			Density = 0.3,
			Offset = 0.25,
			Color = Color3.fromRGB(199, 170, 200),
			Decay = Color3.fromRGB(106, 112, 125),
			Glare = 0,
			Haze = 0,
		},
	}

	local Sky = {
		Enabled = false,
		Values = {
			StarCount = 3000,
			SunAngularSize = 21,
			MoonAngularSize = 11,
			CelestialBodiesShown = true,
		},
	}

	local Grade = { Enabled = false, Saturation = 0.2, Contrast = 0.1, Brightness = 0, Tint = Color3.fromRGB(255, 255, 255) }
	local Bloom = { Enabled = false, Intensity = 0.6, Size = 24, Threshold = 1.5 }
	local SunRays = { Enabled = false, Intensity = 0.25, Spread = 1 }
	local Blur = { Enabled = false, Size = 8 }
	local Dof = { Enabled = false, FocusDistance = 40, InFocusRadius = 30, FarIntensity = 0.4, NearIntensity = 0 }

	local saved = {}

	local function hold(property, enabled, value)
		if enabled then
			if saved[property] == nil then
				saved[property] = Lighting[property]
			end
			if Lighting[property] ~= value then
				Lighting[property] = value
			end
		elseif saved[property] ~= nil then
			Lighting[property] = saved[property]
			saved[property] = nil
		end
	end

	local function instanceOverride(className)
		local state = { Instance = nil, Created = false, Saved = nil }

		function state.Apply(enabled, values)
			if enabled then
				if not state.Instance or not state.Instance.Parent then
					local found = Lighting:FindFirstChildOfClass(className)
					if found then
						state.Instance = found
						state.Created = false
						state.Saved = {}
						for key in values do
							state.Saved[key] = found[key]
						end
					else
						state.Instance = Instance.new(className)
						state.Instance.Parent = Lighting
						state.Created = true
						state.Saved = nil
					end
				end
				for key, value in values do
					if state.Instance[key] ~= value then
						state.Instance[key] = value
					end
				end
			elseif state.Instance then
				if state.Created then
					state.Instance:Destroy()
				elseif state.Saved and state.Instance.Parent then
					for key, value in state.Saved do
						pcall(function()
							state.Instance[key] = value
						end)
					end
				end
				state.Instance = nil
				state.Saved = nil
			end
		end

		return state
	end

	local AtmosphereOverride = instanceOverride("Atmosphere")
	local SkyOverride = instanceOverride("Sky")

	local function newEffect(className, name)
		local effect = Instance.new(className)
		effect.Name = name
		effect.Enabled = false
		effect.Parent = Lighting
		return effect
	end

	local ColorEffect = newEffect("ColorCorrectionEffect", "ZeroColorGrade")
	local BloomEffect = newEffect("BloomEffect", "ZeroBloom")
	local SunRaysEffect = newEffect("SunRaysEffect", "ZeroSunRays")
	local BlurEffect = newEffect("BlurEffect", "ZeroBlur")
	local DofEffect = newEffect("DepthOfFieldEffect", "ZeroDepth")

	local Weather = {
		Mode = "Off",
		Amount = 300,
		Speed = 1,
		Size = 1,
		Radius = 60,
		Wind = 0,
		Color = Color3.fromRGB(255, 255, 255),
	}

	local WeatherModes = {
		Rain = {
			Height = 40,
			Thickness = 1,
			Direction = Enum.NormalId.Bottom,
			SpeedMin = 85,
			SpeedMax = 110,
			LifeMin = 0.7,
			LifeMax = 0.9,
			Size = 0.1,
			Light = 0,
			Rate = 1.6,
			Orientation = Enum.ParticleOrientation.VelocityParallel,
			Squash = -7,
			Transparency = 0.45,
			Accel = Vector3.new(0, -20, 0),
			Color = Color3.fromRGB(190, 210, 255),
		},
		Snow = {
			Height = 40,
			Thickness = 1,
			Direction = Enum.NormalId.Bottom,
			SpeedMin = 6,
			SpeedMax = 11,
			LifeMin = 5,
			LifeMax = 7,
			Size = 0.28,
			Light = 0.2,
			Rate = 1,
			Orientation = Enum.ParticleOrientation.FacingCamera,
			Squash = 0,
			Transparency = 0.1,
			Accel = Vector3.new(0, 0, 0),
			Color = Color3.fromRGB(255, 255, 255),
		},
		Embers = {
			Height = -4,
			Thickness = 8,
			Direction = Enum.NormalId.Top,
			SpeedMin = 3,
			SpeedMax = 7,
			LifeMin = 3,
			LifeMax = 5,
			Size = 0.18,
			Light = 1,
			Rate = 0.6,
			Orientation = Enum.ParticleOrientation.FacingCamera,
			Squash = 0,
			Transparency = 0.2,
			Accel = Vector3.new(0, 2, 0),
			Color = Color3.fromRGB(255, 140, 50),
		},
		Fireflies = {
			Height = 0,
			Thickness = 14,
			Direction = Enum.NormalId.Top,
			SpeedMin = 0.5,
			SpeedMax = 2,
			LifeMin = 4,
			LifeMax = 7,
			Size = 0.22,
			Light = 1,
			Rate = 0.25,
			Orientation = Enum.ParticleOrientation.FacingCamera,
			Squash = 0,
			Transparency = 0.15,
			Accel = Vector3.new(0, 0, 0),
			Color = Color3.fromRGB(255, 240, 120),
		},
	}

	local weatherPart = nil
	local weatherEmitter = nil

	local function destroyWeather()
		if weatherPart then
			weatherPart:Destroy()
		end
		weatherPart = nil
		weatherEmitter = nil
	end

	local function styleWeather()
		local cfg = WeatherModes[Weather.Mode]
		if not cfg or not weatherEmitter or not weatherPart then
			return
		end
		weatherPart.Size = Vector3.new(Weather.Radius * 2, cfg.Thickness, Weather.Radius * 2)
		weatherEmitter.EmissionDirection = cfg.Direction
		weatherEmitter.Rate = Weather.Amount * cfg.Rate
		weatherEmitter.Lifetime = NumberRange.new(cfg.LifeMin, cfg.LifeMax)
		weatherEmitter.Speed = NumberRange.new(cfg.SpeedMin * Weather.Speed, cfg.SpeedMax * Weather.Speed)
		weatherEmitter.Size = NumberSequence.new(cfg.Size * Weather.Size)
		weatherEmitter.Color = ColorSequence.new(Weather.Color)
		weatherEmitter.LightEmission = cfg.Light
		weatherEmitter.Orientation = cfg.Orientation
		weatherEmitter.Squash = NumberSequence.new(cfg.Squash)
		weatherEmitter.Acceleration = cfg.Accel + Vector3.new(Weather.Wind, 0, 0)
		weatherEmitter.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(0.1, cfg.Transparency),
			NumberSequenceKeypoint.new(0.9, cfg.Transparency),
			NumberSequenceKeypoint.new(1, 1),
		})
		weatherEmitter.Rotation = NumberRange.new(0, 360)
		weatherEmitter.RotSpeed = NumberRange.new(-60, 60)
	end

	local WeatherColorControl = nil

	local function setWeatherMode(mode)
		Weather.Mode = mode
		destroyWeather()
		local cfg = WeatherModes[mode]
		if not cfg then
			return
		end
		Weather.Color = cfg.Color
		if WeatherColorControl then
			pcall(function()
				WeatherColorControl:Set(cfg.Color)
			end)
		end
		local part = Instance.new("Part")
		part.Name = "ZeroWeather"
		part.Anchored = true
		part.CanCollide = false
		part.CanQuery = false
		part.CanTouch = false
		part.CastShadow = false
		part.Transparency = 1
		part.Parent = workspace.CurrentCamera
		local emitter = Instance.new("ParticleEmitter")
		emitter.Shape = Enum.ParticleEmitterShape.Box
		emitter.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
		emitter.LockedToPart = false
		emitter.LightInfluence = 0
		emitter.Parent = part
		weatherPart = part
		weatherEmitter = emitter
		styleWeather()
	end

	local Viewmodel = {
		Enabled = false,
		ApplyWhileAiming = false,
		X = 0,
		Y = 0,
		Z = 0,
		RotX = 0,
		RotY = 0,
		RotZ = 0,
		Float = false,
		FloatAmount = 1,
		FloatSpeed = 1.5,
		ArmsEnabled = false,
		ArmsHidden = false,
		RemoveSleeves = true,
		ArmColor = Color3.fromRGB(255, 120, 200),
		ArmMaterial = "ForceField",
		ArmTransparency = 0,
		ArmRainbow = false,
		Glow = false,
		GlowFill = Color3.fromRGB(255, 80, 180),
		GlowFillTransparency = 0.7,
		GlowOutline = Color3.fromRGB(255, 255, 255),
		GlowOutlineTransparency = 0,
		GlowPulse = false,
		GlowRainbow = false,
	}

	local Layouts = {
		Default = { X = 0, Y = 0, Z = 0, RotX = 0, RotY = 0, RotZ = 0 },
		["Low Right"] = { X = 0.35, Y = -0.25, Z = 0, RotX = 0, RotY = 0, RotZ = 0 },
		["Close Up"] = { X = 0.1, Y = -0.1, Z = -0.4, RotX = 0, RotY = 0, RotZ = 0 },
		["Far Out"] = { X = 0.15, Y = 0, Z = 0.6, RotX = 0, RotY = 0, RotZ = 0 },
		Tilted = { X = 0.3, Y = -0.2, Z = 0, RotX = 0, RotY = -12, RotZ = 14 },
		Cinematic = { X = 0.45, Y = -0.3, Z = 0.25, RotX = 4, RotY = -10, RotZ = 8 },
		["Left Side"] = { X = -0.55, Y = -0.2, Z = 0, RotX = 0, RotY = 12, RotZ = -10 },
	}

	local LayoutOrder = { "Default", "Low Right", "Close Up", "Far Out", "Tilted", "Cinematic", "Left Side" }

	local ViewmodelControls = {}
	local GradeControls = {}

	local EnvLighting = EnvTab:AddSection("Lighting", "Left", "sun", "worldlighting")
	bindToggle(EnvLighting, "Fullbright", "WorldFullbright", Env, "Fullbright")
	bindToggle(EnvLighting, "Disable Shadows", "WorldNoShadows", Env, "NoShadows")
	bindToggle(EnvLighting, "Custom Brightness", "WorldBrightnessEnabled", Env, "BrightnessEnabled")
	bindSlider(EnvLighting, "Brightness", "WorldBrightness", Env, "Brightness", 0, 10, 0.1)
	bindToggle(EnvLighting, "Custom Exposure", "WorldExposureEnabled", Env, "ExposureEnabled")
	bindSlider(EnvLighting, "Exposure", "WorldExposure", Env, "Exposure", -3, 3, 0.1)

	local EnvTime = EnvTab:AddSection("Time Of Day", "Left", "clock", "worldtime")
	bindToggle(EnvTime, "Change Time", "WorldTimeEnabled", Env, "TimeEnabled")
	bindSlider(EnvTime, "Time", "WorldTime", Env, "Time", 0, 24, 0.1, " h")
	bindToggle(EnvTime, "Time Cycle", "WorldTimeCycle", Env, "TimeCycle")
	bindSlider(EnvTime, "Cycle Speed", "WorldCycleSpeed", Env, "CycleSpeed", 0.1, 5, 0.1, "x")

	local EnvCamera = EnvTab:AddSection("Camera", "Left", "camera", "worldcamera")
	bindToggle(EnvCamera, "Custom FOV", "WorldFovEnabled", Env, "FovEnabled")
	bindSlider(EnvCamera, "Field Of View", "WorldFov", Env, "Fov", 30, 120, 1, " deg")

	local EnvAmbient = EnvTab:AddSection("Ambient", "Right", "palette", "worldambient")
	bindToggle(EnvAmbient, "Custom Ambient", "WorldAmbientEnabled", Env, "AmbientEnabled")
	bindColor(EnvAmbient, "Ambient Color", "WorldAmbient", Env, "Ambient")
	bindColor(EnvAmbient, "Outdoor Color", "WorldOutdoorAmbient", Env, "OutdoorAmbient")
	bindToggle(EnvAmbient, "Rainbow Ambient", "WorldRainbowAmbient", Env, "RainbowAmbient")
	bindSlider(EnvAmbient, "Rainbow Speed", "WorldRainbowSpeed", Env, "RainbowSpeed", 1, 20, 1)
	bindToggle(EnvAmbient, "Color Shift", "WorldColorShiftEnabled", Env, "ColorShiftEnabled")
	bindColor(EnvAmbient, "Shift Top", "WorldColorShiftTop", Env, "ColorShiftTop")
	bindColor(EnvAmbient, "Shift Bottom", "WorldColorShiftBottom", Env, "ColorShiftBottom")

	local EnvFog = EnvTab:AddSection("Fog", "Right", "cloud-fog", "worldfog")
	bindToggle(EnvFog, "Custom Fog", "WorldFogEnabled", Env, "FogEnabled")
	bindColor(EnvFog, "Fog Color", "WorldFogColor", Env, "FogColor")
	bindSlider(EnvFog, "Fog Start", "WorldFogStart", Env, "FogStart", 0, 1000, 10, " st")
	bindSlider(EnvFog, "Fog End", "WorldFogEnd", Env, "FogEnd", 10, 2000, 10, " st")

	local WeatherSection = SkyTab:AddSection("Weather", "Left", "cloud-rain", "worldweather")
	WeatherSection:AddDropdown({
		Name = "Weather",
		Options = { "Off", "Rain", "Snow", "Embers", "Fireflies" },
		Default = Weather.Mode,
		Flag = "WorldWeatherMode",
		Callback = function(Value)
			setWeatherMode(Value)
		end,
	})
	bindSlider(WeatherSection, "Amount", "WorldWeatherAmount", Weather, "Amount", 50, 1500, 50, nil, 1, styleWeather)
	bindSlider(WeatherSection, "Speed", "WorldWeatherSpeed", Weather, "Speed", 0.2, 3, 0.1, "x", 1, styleWeather)
	bindSlider(WeatherSection, "Particle Size", "WorldWeatherSize", Weather, "Size", 0.2, 4, 0.1, "x", 1, styleWeather)
	bindSlider(WeatherSection, "Radius", "WorldWeatherRadius", Weather, "Radius", 20, 150, 5, " st", 1, styleWeather)
	bindSlider(WeatherSection, "Wind", "WorldWeatherWind", Weather, "Wind", -30, 30, 1, nil, 1, styleWeather)
	WeatherColorControl = bindColor(WeatherSection, "Color", "WorldWeatherColor", Weather, "Color", styleWeather)

	local AtmosphereSection = SkyTab:AddSection("Atmosphere", "Right", "cloud", "worldatmosphere")
	bindToggle(AtmosphereSection, "Custom Atmosphere", "WorldAtmosphereEnabled", Atmosphere, "Enabled")
	bindSlider(AtmosphereSection, "Density", "WorldAtmosphereDensity", Atmosphere.Values, "Density", 0, 1, 0.01)
	bindSlider(AtmosphereSection, "Offset", "WorldAtmosphereOffset", Atmosphere.Values, "Offset", 0, 1, 0.01)
	bindSlider(AtmosphereSection, "Glare", "WorldAtmosphereGlare", Atmosphere.Values, "Glare", 0, 10, 0.1)
	bindSlider(AtmosphereSection, "Haze", "WorldAtmosphereHaze", Atmosphere.Values, "Haze", 0, 10, 0.1)
	bindColor(AtmosphereSection, "Color", "WorldAtmosphereColor", Atmosphere.Values, "Color")
	bindColor(AtmosphereSection, "Decay Color", "WorldAtmosphereDecay", Atmosphere.Values, "Decay")

	local SkySection = SkyTab:AddSection("Sky", "Left", "moon", "worldsky")
	bindToggle(SkySection, "Custom Sky", "WorldSkyEnabled", Sky, "Enabled")
	bindToggle(SkySection, "Show Sun And Moon", "WorldSkyCelestial", Sky.Values, "CelestialBodiesShown")
	bindSlider(SkySection, "Stars", "WorldSkyStars", Sky.Values, "StarCount", 0, 5000, 100)
	bindSlider(SkySection, "Sun Size", "WorldSkySun", Sky.Values, "SunAngularSize", 0, 60, 1)
	bindSlider(SkySection, "Moon Size", "WorldSkyMoon", Sky.Values, "MoonAngularSize", 0, 60, 1)

	local GradeMain = GradeTab:AddSection("Color Grading", "Left", "palette", "worldgrade")
	GradeControls.Enabled = bindToggle(GradeMain, "Enabled", "WorldGradeEnabled", Grade, "Enabled")
	GradeControls.Saturation = bindSlider(GradeMain, "Saturation", "WorldGradeSaturation", Grade, "Saturation", -1, 3, 0.05)
	GradeControls.Contrast = bindSlider(GradeMain, "Contrast", "WorldGradeContrast", Grade, "Contrast", -1, 2, 0.05)
	GradeControls.Brightness = bindSlider(GradeMain, "Brightness", "WorldGradeBrightness", Grade, "Brightness", -0.5, 0.5, 0.01)
	GradeControls.Tint = bindColor(GradeMain, "Tint", "WorldGradeTint", Grade, "Tint")

	local GradePresets = {
		Vibrant = { Saturation = 0.5, Contrast = 0.15, Brightness = 0, Tint = Color3.fromRGB(255, 255, 255) },
		Cinematic = { Saturation = -0.1, Contrast = 0.25, Brightness = -0.02, Tint = Color3.fromRGB(255, 235, 215) },
		Noir = { Saturation = -1, Contrast = 0.35, Brightness = 0, Tint = Color3.fromRGB(255, 255, 255) },
		Sunset = { Saturation = 0.3, Contrast = 0.1, Brightness = 0.02, Tint = Color3.fromRGB(255, 200, 160) },
		Frost = { Saturation = -0.1, Contrast = 0.1, Brightness = 0.03, Tint = Color3.fromRGB(190, 225, 255) },
		Neon = { Saturation = 1.2, Contrast = 0.3, Brightness = -0.02, Tint = Color3.fromRGB(225, 200, 255) },
	}

	local GradePresetSection = GradeTab:AddSection("Looks", "Left", "layout-grid", "worldgradelooks")
	for _, name in ipairs({ "Vibrant", "Cinematic", "Noir", "Sunset", "Frost", "Neon" }) do
		GradePresetSection:AddButton({
			Name = name,
			Callback = function()
				local preset = GradePresets[name]
				GradeControls.Enabled:Set(true)
				for key, value in pairs(preset) do
					pcall(function()
						GradeControls[key]:Set(value)
					end)
				end
			end,
		})
	end

	local BloomSection = GradeTab:AddSection("Bloom", "Right", "sparkles", "worldbloom")
	bindToggle(BloomSection, "Bloom", "WorldBloomEnabled", Bloom, "Enabled")
	bindSlider(BloomSection, "Intensity", "WorldBloomIntensity", Bloom, "Intensity", 0, 3, 0.05)
	bindSlider(BloomSection, "Size", "WorldBloomSize", Bloom, "Size", 0, 56, 1)
	bindSlider(BloomSection, "Threshold", "WorldBloomThreshold", Bloom, "Threshold", 0, 3, 0.05)

	local RaysSection = GradeTab:AddSection("Sun Rays", "Right", "sun", "worldsunrays")
	bindToggle(RaysSection, "Sun Rays", "WorldSunRaysEnabled", SunRays, "Enabled")
	bindSlider(RaysSection, "Intensity", "WorldSunRaysIntensity", SunRays, "Intensity", 0, 1, 0.01)
	bindSlider(RaysSection, "Spread", "WorldSunRaysSpread", SunRays, "Spread", 0, 1, 0.01)

	local DepthSection = GradeTab:AddSection("Depth And Blur", "Right", "circle", "worlddepth")
	bindToggle(DepthSection, "Depth Of Field", "WorldDofEnabled", Dof, "Enabled")
	bindSlider(DepthSection, "Focus Distance", "WorldDofFocus", Dof, "FocusDistance", 0, 200, 1, " st")
	bindSlider(DepthSection, "Focus Radius", "WorldDofRadius", Dof, "InFocusRadius", 0, 200, 1, " st")
	bindSlider(DepthSection, "Far Blur", "WorldDofFar", Dof, "FarIntensity", 0, 1, 0.01)
	bindSlider(DepthSection, "Near Blur", "WorldDofNear", Dof, "NearIntensity", 0, 1, 0.01)
	bindToggle(DepthSection, "Screen Blur", "WorldBlurEnabled", Blur, "Enabled")
	bindSlider(DepthSection, "Blur Size", "WorldBlurSize", Blur, "Size", 0, 56, 1)

	local VmMain = ViewmodelTab:AddSection("Custom Viewmodel", "Left", "hand", "worldviewmodel")
	ViewmodelControls.Enabled = bindToggle(VmMain, "Enabled", "ViewmodelEnabled", Viewmodel, "Enabled")
	bindToggle(VmMain, "Apply While Aiming", "ViewmodelAiming", Viewmodel, "ApplyWhileAiming")

	local VmPosition = ViewmodelTab:AddSection("Position", "Left", "move", "viewmodelposition")
	ViewmodelControls.X = bindSlider(VmPosition, "Right / Left", "ViewmodelX", Viewmodel, "X", -3, 3, 0.05, " st")
	ViewmodelControls.Y = bindSlider(VmPosition, "Up / Down", "ViewmodelY", Viewmodel, "Y", -3, 3, 0.05, " st")
	ViewmodelControls.Z = bindSlider(VmPosition, "Forward / Back", "ViewmodelZ", Viewmodel, "Z", -3, 3, 0.05, " st")

	local VmRotation = ViewmodelTab:AddSection("Rotation", "Left", "rotate-3d", "viewmodelrotation")
	ViewmodelControls.RotX = bindSlider(VmRotation, "Pitch", "ViewmodelRotX", Viewmodel, "RotX", -180, 180, 1, " deg")
	ViewmodelControls.RotY = bindSlider(VmRotation, "Yaw", "ViewmodelRotY", Viewmodel, "RotY", -180, 180, 1, " deg")
	ViewmodelControls.RotZ = bindSlider(VmRotation, "Roll", "ViewmodelRotZ", Viewmodel, "RotZ", -180, 180, 1, " deg")

	local VmLayouts = ViewmodelTab:AddSection("Layouts", "Right", "layout-grid", "viewmodellayouts")
	for _, name in ipairs(LayoutOrder) do
		VmLayouts:AddButton({
			Name = name,
			Callback = function()
				ViewmodelControls.Enabled:Set(true)
				for key, value in pairs(Layouts[name]) do
					pcall(function()
						ViewmodelControls[key]:Set(value)
					end)
				end
			end,
		})
	end

	local VmMotion = ViewmodelTab:AddSection("Motion", "Right", "wind", "viewmodelmotion")
	bindToggle(VmMotion, "Idle Float", "ViewmodelFloat", Viewmodel, "Float")
	bindSlider(VmMotion, "Float Amount", "ViewmodelFloatAmount", Viewmodel, "FloatAmount", 0.1, 5, 0.1, "x")
	bindSlider(VmMotion, "Float Speed", "ViewmodelFloatSpeed", Viewmodel, "FloatSpeed", 0.2, 6, 0.1, "x")

	local VmArms = ViewmodelTab:AddSection("Arms", "Right", "user", "viewmodelarms")
	bindToggle(VmArms, "Custom Arms", "ViewmodelArmsEnabled", Viewmodel, "ArmsEnabled")
	bindToggle(VmArms, "Hide Arms", "ViewmodelArmsHidden", Viewmodel, "ArmsHidden")
	bindToggle(VmArms, "Remove Sleeves", "ViewmodelRemoveSleeves", Viewmodel, "RemoveSleeves")
	bindColor(VmArms, "Arm Color", "ViewmodelArmColor", Viewmodel, "ArmColor")
	bindDropdown(VmArms, "Material", "ViewmodelArmMaterial", { "ForceField", "Neon", "Glass", "SmoothPlastic", "Plastic", "Metal", "Foil", "Ice", "Marble" }, Viewmodel, "ArmMaterial")
	bindSlider(VmArms, "Transparency", "ViewmodelArmTransparency", Viewmodel, "ArmTransparency", 0, 90, 1, "%", 0.01)
	bindToggle(VmArms, "Rainbow Arms", "ViewmodelArmRainbow", Viewmodel, "ArmRainbow")

	local VmGlow = ViewmodelTab:AddSection("Weapon Glow", "Left", "sparkles", "viewmodelglow")
	bindToggle(VmGlow, "Enabled", "ViewmodelGlow", Viewmodel, "Glow")
	bindColor(VmGlow, "Fill Color", "ViewmodelGlowFill", Viewmodel, "GlowFill")
	bindSlider(VmGlow, "Fill Transparency", "ViewmodelGlowFillTransparency", Viewmodel, "GlowFillTransparency", 0, 100, 1, "%", 0.01)
	bindColor(VmGlow, "Outline Color", "ViewmodelGlowOutline", Viewmodel, "GlowOutline")
	bindSlider(VmGlow, "Outline Transparency", "ViewmodelGlowOutlineTransparency", Viewmodel, "GlowOutlineTransparency", 0, 100, 1, "%", 0.01)
	bindToggle(VmGlow, "Pulse", "ViewmodelGlowPulse", Viewmodel, "GlowPulse")
	bindToggle(VmGlow, "Rainbow", "ViewmodelGlowRainbow", Viewmodel, "GlowRainbow")

	local function readAim()
		return FighterController.LocalFighter.EquippedItem.ViewModel.CurrentAimValue
	end

	local function getAim()
		local ok, value = pcall(readAim)
		if ok and type(value) == "number" then
			return value
		end
		return 0
	end

	local function getFirstPersonFolder()
		local root = workspace:FindFirstChild("ViewModels")
		return root and root:FindFirstChild("FirstPerson")
	end

	local armCache = setmetatable({}, { __mode = "k" })
	local armNames = { "LeftArm", "RightArm" }

	local function applyArm(arm)
		local cache = armCache[arm]
		if Viewmodel.ArmsEnabled then
			if not cache then
				cache = { Color = arm.Color, Material = arm.Material }
				armCache[arm] = cache
			end
			local color = Viewmodel.ArmColor
			if Viewmodel.ArmRainbow then
				color = Color3.fromHSV((os.clock() * 0.25) % 1, 0.8, 1)
			end
			arm.Color = color
			arm.Material = Enum.Material[Viewmodel.ArmMaterial]
			local transparency = Viewmodel.ArmsHidden and 1 or Viewmodel.ArmTransparency
			arm.Transparency = math.max(arm.Transparency, transparency)
			local sleeve = arm:FindFirstChild("ShirtTexture")
			if sleeve then
				sleeve.Transparency = math.max(sleeve.Transparency, (Viewmodel.RemoveSleeves or Viewmodel.ArmsHidden) and 1 or transparency)
			end
		elseif cache then
			arm.Color = cache.Color
			arm.Material = cache.Material
			armCache[arm] = nil
		end
	end

	local Glow = Instance.new("Highlight")
	Glow.Name = "ZeroViewmodelGlow"
	Glow.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	Glow.Enabled = false

	RunService.RenderStepped:Connect(function(dt)
		local now = os.clock()

		if Env.TimeCycle then
			Env.Time = (Env.Time + dt * Env.CycleSpeed) % 24
		end

		local ambientOn = Env.Fullbright or Env.RainbowAmbient or Env.AmbientEnabled
		local ambientValue = Env.Ambient
		local outdoorValue = Env.OutdoorAmbient
		if Env.Fullbright then
			ambientValue = Color3.new(1, 1, 1)
			outdoorValue = ambientValue
		elseif Env.RainbowAmbient then
			ambientValue = Color3.fromHSV((now * Env.RainbowSpeed * 0.05) % 1, 0.6, 1)
			outdoorValue = ambientValue
		end

		hold("Ambient", ambientOn, ambientValue)
		hold("OutdoorAmbient", ambientOn, outdoorValue)
		hold("Brightness", Env.Fullbright or Env.BrightnessEnabled, Env.Fullbright and 3 or Env.Brightness)
		hold("ClockTime", Env.TimeEnabled, Env.Time)
		hold("ExposureCompensation", Env.ExposureEnabled, Env.Exposure)
		hold("GlobalShadows", Env.Fullbright or Env.NoShadows, false)
		hold("FogColor", Env.FogEnabled, Env.FogColor)
		hold("FogStart", Env.FogEnabled, Env.FogStart)
		hold("FogEnd", Env.FogEnabled, Env.FogEnd)
		hold("ColorShift_Top", Env.ColorShiftEnabled, Env.ColorShiftTop)
		hold("ColorShift_Bottom", Env.ColorShiftEnabled, Env.ColorShiftBottom)

		AtmosphereOverride.Apply(Atmosphere.Enabled, Atmosphere.Values)
		SkyOverride.Apply(Sky.Enabled, Sky.Values)

		ColorEffect.Enabled = Grade.Enabled
		ColorEffect.Saturation = Grade.Saturation
		ColorEffect.Contrast = Grade.Contrast
		ColorEffect.Brightness = Grade.Brightness
		ColorEffect.TintColor = Grade.Tint

		BloomEffect.Enabled = Bloom.Enabled
		BloomEffect.Intensity = Bloom.Intensity
		BloomEffect.Size = Bloom.Size
		BloomEffect.Threshold = Bloom.Threshold

		SunRaysEffect.Enabled = SunRays.Enabled
		SunRaysEffect.Intensity = SunRays.Intensity
		SunRaysEffect.Spread = SunRays.Spread

		BlurEffect.Enabled = Blur.Enabled
		BlurEffect.Size = Blur.Size

		DofEffect.Enabled = Dof.Enabled
		DofEffect.FocusDistance = Dof.FocusDistance
		DofEffect.InFocusRadius = Dof.InFocusRadius
		DofEffect.FarIntensity = Dof.FarIntensity
		DofEffect.NearIntensity = Dof.NearIntensity
	end)

	RunService:BindToRenderStep("ZeroWorldLast", Enum.RenderPriority.Last.Value, function()
		local cam = workspace.CurrentCamera
		if not cam then
			return
		end

		local now = os.clock()
		local aim = getAim()

		if Env.FovEnabled and aim < 0.5 then
			cam.FieldOfView = Env.Fov
		end

		if weatherPart then
			local cfg = WeatherModes[Weather.Mode]
			if weatherPart.Parent ~= cam then
				weatherPart.Parent = cam
			end
			if cfg then
				weatherPart.CFrame = CFrame.new(cam.CFrame.Position + Vector3.new(0, cfg.Height, 0))
			end
		end

		local folder = getFirstPersonFolder()
		local firstModel = nil

		if folder then
			for _, child in folder:GetChildren() do
				if child:IsA("Model") then
					firstModel = firstModel or child

					if Viewmodel.Enabled then
						local factor = Viewmodel.ApplyWhileAiming and 1 or (1 - aim)
						local x = Viewmodel.X
						local y = Viewmodel.Y
						local z = Viewmodel.Z
						if Viewmodel.Float then
							local amount = Viewmodel.FloatAmount * 0.02
							x += math.sin(now * Viewmodel.FloatSpeed * 0.8) * amount * 0.5
							y += math.sin(now * Viewmodel.FloatSpeed) * amount
						end
						local camCF = cam.CFrame
						local offset = camCF:VectorToWorldSpace(Vector3.new(x, y, -z) * factor)
						local rotation = camCF.Rotation
							* CFrame.Angles(math.rad(Viewmodel.RotX) * factor, math.rad(Viewmodel.RotY) * factor, math.rad(Viewmodel.RotZ) * factor)
							* camCF.Rotation:Inverse()
						local pivot = child:GetPivot()
						child:PivotTo(CFrame.new(pivot.Position + offset) * rotation * pivot.Rotation)
					end

					for _, armName in ipairs(armNames) do
						local arm = child:FindFirstChild(armName)
						if arm and arm:IsA("BasePart") then
							applyArm(arm)
						end
					end
				end
			end
		end

		if Viewmodel.Glow and firstModel then
			if Glow.Parent ~= cam then
				Glow.Parent = cam
			end
			Glow.Adornee = firstModel
			local fill = Viewmodel.GlowFill
			local outline = Viewmodel.GlowOutline
			if Viewmodel.GlowRainbow then
				fill = Color3.fromHSV((now * 0.25) % 1, 0.8, 1)
				outline = Color3.fromHSV((now * 0.25 + 0.5) % 1, 0.8, 1)
			end
			local fillTransparency = Viewmodel.GlowFillTransparency
			if Viewmodel.GlowPulse then
				fillTransparency = math.clamp(fillTransparency + math.sin(now * 3) * 0.25, 0, 1)
			end
			Glow.FillColor = fill
			Glow.OutlineColor = outline
			Glow.FillTransparency = fillTransparency
			Glow.OutlineTransparency = Viewmodel.GlowOutlineTransparency
			Glow.Enabled = true
		else
			Glow.Enabled = false
		end
	end)
end

do
	local Emotes = {
		{ "Take The L", "122624487269599" },
		{ "Pretty Kawaii Profile Pose", "97800675098217" },
		{ "Brazilian Forro Dance", "90823210049664" },
		{ "Jamal Dancing", "117290583615305" },
		{ "Wish NLE Dance", "85753915767287" },
	}

	local EmoteIds = {}
	local EmoteNames = {}
	for _, emote in ipairs(Emotes) do
		EmoteIds[emote[1]] = emote[2]
		table.insert(EmoteNames, emote[1])
	end

	local EmotePlayer = {
		Enabled = false,
		Selected = EmoteNames[1],
		Speed = 1,
		Looped = true,
		Track = nil,
		TrackKey = nil,
		Resolved = {},
	}

	local function resolveAnimationId(id)
		if EmotePlayer.Resolved[id] then
			return EmotePlayer.Resolved[id]
		end
		local resolved = "rbxassetid://" .. id
		local ok, objects = pcall(function()
			return game:GetObjects("rbxassetid://" .. id)
		end)
		if ok and type(objects) == "table" and objects[1] then
			local object = objects[1]
			local animation = object:IsA("Animation") and object or object:FindFirstChildWhichIsA("Animation", true)
			if animation and animation.AnimationId ~= "" then
				resolved = animation.AnimationId
			end
		end
		EmotePlayer.Resolved[id] = resolved
		return resolved
	end

	local function stopEmote()
		if EmotePlayer.Track then
			pcall(function()
				EmotePlayer.Track:Stop(0.2)
				EmotePlayer.Track:Destroy()
			end)
		end
		EmotePlayer.Track = nil
		EmotePlayer.TrackKey = nil
	end

	local function getAnimator()
		local character = LocalPlayer.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		if not humanoid or humanoid.Health <= 0 then
			return nil
		end
		local animator = humanoid:FindFirstChildOfClass("Animator")
		if not animator then
			animator = Instance.new("Animator")
			animator.Parent = humanoid
		end
		return animator
	end

	local function playEmote()
		local id = EmoteIds[EmotePlayer.Selected]
		local animator = getAnimator()
		if not id or not animator then
			return
		end
		stopEmote()
		local animation = Instance.new("Animation")
		animation.AnimationId = resolveAnimationId(id)
		local ok, track = pcall(function()
			return animator:LoadAnimation(animation)
		end)
		if not ok or not track then
			return
		end
		track.Priority = Enum.AnimationPriority.Action4
		track.Looped = EmotePlayer.Looped
		track:Play(0.2, 1, EmotePlayer.Speed)
		EmotePlayer.Track = track
		EmotePlayer.TrackKey = EmotePlayer.Selected
	end

	local lastCheck = 0

	RunService.Heartbeat:Connect(function()
		if not EmotePlayer.Enabled then
			return
		end
		local now = os.clock()
		if now - lastCheck < 0.1 then
			return
		end
		lastCheck = now
		local track = EmotePlayer.Track
		if track and EmotePlayer.TrackKey == EmotePlayer.Selected then
			if track.Priority ~= Enum.AnimationPriority.Action4 then
				track.Priority = Enum.AnimationPriority.Action4
			end
			if not track.IsPlaying and EmotePlayer.Looped then
				pcall(function()
					track:Play(0.2, 1, EmotePlayer.Speed)
				end)
			end
			return
		end
		playEmote()
	end)

	LocalPlayer.CharacterAdded:Connect(function()
		EmotePlayer.Track = nil
		EmotePlayer.TrackKey = nil
	end)

	local EmoteSection = Player:AddSection("Emotes", "Right", "smile", "playeremotes")
	EmoteSection:AddToggle({
		Name = "Emote Player",
		Default = EmotePlayer.Enabled,
		Flag = "EmotePlayerEnabled",
		Callback = function(Value)
			EmotePlayer.Enabled = Value
			if not Value then
				stopEmote()
			end
		end,
	})
	EmoteSection:AddDropdown({
		Name = "Emote",
		Options = EmoteNames,
		Default = EmotePlayer.Selected,
		Flag = "EmotePlayerSelected",
		Callback = function(Value)
			EmotePlayer.Selected = Value
			if EmotePlayer.Enabled then
				playEmote()
			end
		end,
	})
	EmoteSection:AddSlider({
		Name = "Speed",
		Min = 0.1,
		Max = 3,
		Default = EmotePlayer.Speed,
		Increment = 0.1,
		Suffix = "x",
		Flag = "EmotePlayerSpeed",
		Callback = function(Value)
			EmotePlayer.Speed = Value
			if EmotePlayer.Track then
				pcall(function()
					EmotePlayer.Track:AdjustSpeed(Value)
				end)
			end
		end,
	})
	EmoteSection:AddToggle({
		Name = "Loop",
		Default = EmotePlayer.Looped,
		Flag = "EmotePlayerLoop",
		Callback = function(Value)
			EmotePlayer.Looped = Value
			if EmotePlayer.Track then
				EmotePlayer.Track.Looped = Value
			end
		end,
	})
	EmoteSection:AddButton({
		Name = "Replay Emote",
		Callback = function()
			EmotePlayer.Enabled = true
			playEmote()
		end,
	})
	EmoteSection:AddButton({
		Name = "Stop Emote",
		Callback = function()
			stopEmote()
		end,
	})
end

if Window:ApplyRivalsProtection() then
	task.wait(4)
end

Window:AddSettingsManager()
