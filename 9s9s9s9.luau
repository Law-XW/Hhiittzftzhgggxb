local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer

local KeepAcHeartbeat = true

local wrapC = newcclosure or function(f)
	return f
end
local isOwnCall = checkcaller or function()
	return false
end
local hookF = hookfunction or replaceclosure
local getMethod = getnamecallmethod
local setMethod = setnamecallmethod

local SilentAim = {
	Enabled = false,
	Resolve = nil,
	Pending = nil,
	FireRemote = nil,
	Killaura = false,
}

task.spawn(function()
	local ok, remote = pcall(function()
		local modules = RS:WaitForChild("Modules", 30)
		local framework = modules:WaitForChild("GunFramework", 30)
		local remotes = framework:WaitForChild("Remotes", 30)
		return remotes:WaitForChild("Fire", 30)
	end)
	if ok and remote then
		SilentAim.FireRemote = remote
	end
end)

local BlacklistedAssets = {}
for _, id in ipairs({
	"103147620865081", "116048588333795", "83640716223541", "72579423244522", "10734950309", "3926305904", "12977615774", "18245826428",
	"116204929609664", "128155293790451", "95816097006870", "4996891970", "70449495580650", "1204397029", "529659138", "15861930865",
	"13329667664", "120330515197752", "11558559086", "14840862230", "13387627918", "13711943220", "19005999590", "80114840017452",
	"111833693501471", "74812558983299", "74360183964831", "91717322021928", "106985554407226", "137206543747815", "76383795824440", "111973669155622",
	"15088255768", "107845011312901", "6065821980", "11389137937", "6065821596", "6065775281", "5642383285", "1513966937",
	"1188942192", "483437370", "483448923", "4911962991", "130516018594923", "18406573371", "14122651741", "6014261993",
	"11520996670", "11520882762", "11436779516", "11435586663", "7734053495", "7734053426", "7733960981", "10723407389",
	"10723406299", "10723365457", "10137941941", "11036884234", "9619665977", "12978095818", "4155801252", "4031889928",
	"4805639000", "6035047409", "6035067836", "6031280882", "86292495586194", "3560564077", "9886659671", "6276641225",
	"10709791437", "18274452449", "130188194486745", "10734896206", "1316045217", "5554236805", "6031094682", "6282522798",
	"6031094678", "6031094677", "6031082527", "80999662900595", "117788349049947", "7733717447", "7733658504", "6034818372",
	"14768967526", "107372407704319", "92661965333918", "10709790948", "139785960036434", "126987373762224", "72824869889812", "103682857544461",
	"82522249020124",
}) do
	BlacklistedAssets["rbxassetid://" .. id] = true
end
for _, path in ipairs({ "rbxasset://velocity_assets", "rbxasset://wave", "rbxasset://wave_assets", "rbxasset://wavett" }) do
	BlacklistedAssets[path] = true
end

local HiddenServices = {
	EncodingService = true,
	MessagingService = true,
	UGCValidationService = true,
}

local CP = game:GetService("ContentProvider")

local function fakeSignal()
	return {
		Connect = function()
			return {
				Disconnect = function() end,
				Connected = true,
			}
		end,
		Wait = function() end,
		Once = function() end,
	}
end

local function isProtectedTarget(inst)
	if inst == nil then
		return false
	end
	if inst == lp then
		return true
	end
	local char = lp.Character
	if char and inst == char then
		return true
	end
	local map = workspace.FindFirstChild(workspace, "Map")
	if map and inst == map then
		return true
	end
	return false
end

local function unlockMeta(t)
	if setreadonly then
		setreadonly(t, false)
	elseif make_writeable then
		make_writeable(t)
	end
end

local function lockMeta(t)
	if setreadonly then
		setreadonly(t, true)
	elseif make_readonly then
		make_readonly(t)
	end
end

local function installMeta(name, build)
	local ok = pcall(function()
		local mt = getrawmetatable(game)
		unlockMeta(mt)
		local old = mt[name]
		mt[name] = wrapC(build(old))
		lockMeta(mt)
	end)
	if ok then
		return true
	end
	if hookmetamethod then
		local old
		local installed = pcall(function()
			old = hookmetamethod(game, name, wrapC(build(function(...)
				return old(...)
			end)))
		end)
		return installed
	end
	return false
end

installMeta("__namecall", function(oldNamecall)
	return function(self, ...)
		local method = getMethod and getMethod() or ""
		if not isOwnCall() then
			if method == "FireServer" then
				if (SilentAim.Enabled or SilentAim.Killaura) and SilentAim.Resolve and self == SilentAim.FireRemote then
					local code, origin, direction = ...
					if typeof(origin) == "Vector3" and typeof(direction) == "Vector3" then
						local newDirection = SilentAim.Resolve(origin)
						if newDirection then
							SilentAim.Pending = {
								Origin = origin,
								Old = direction,
								New = newDirection,
								Time = os.clock(),
							}
							if setMethod then
								setMethod(method)
							end
							return oldNamecall(self, code, origin, newDirection)
						end
					end
				end
				local action = tostring((...) or "")
				local arg1 = tostring((select(2, ...)) or "")
				if action == "SaveSettings" and arg1:sub(1, 1) == "{" then
					return
				end
			elseif method == "GetRealPhysicsFPS" then
				local fps = oldNamecall(self, ...)
				if type(fps) == "number" and fps > 70 then
					return 60
				end
				return fps
			elseif method == "GetAssetFetchStatus" then
				local asset = ...
				if type(asset) == "table" then
					error("blocked")
				end
				if KeepAcHeartbeat and BlacklistedAssets[asset] then
					return Enum.AssetFetchStatus.None
				end
			elseif method == "GetAssetFetchStatusChangedSignal" then
				return fakeSignal()
			elseif method == "FindService" then
				local name = ...
				if HiddenServices[name] then
					return nil
				end
			elseif method == "Destroy" or method == "Remove" or method == "ClearAllChildren" then
				if isProtectedTarget(self) then
					return
				end
				if setMethod then
					setMethod(method)
				end
			elseif method == "Kick" then
				if self == lp then
					return
				end
			end
		end
		return oldNamecall(self, ...)
	end
end)

installMeta("__newindex", function(oldNewIndex)
	return function(self, key, value)
		if key == "Parent" and value == nil and not isOwnCall() then
			if isProtectedTarget(self) then
				return
			end
		end
		return oldNewIndex(self, key, value)
	end
end)

pcall(function()
	local probe = game.Changed:Connect(function() end)
	local connMt = getrawmetatable(probe)
	probe:Disconnect()
	unlockMeta(connMt)
	local oldIndex = connMt.__index
	connMt.__index = wrapC(function(self, key)
		local result
		if type(oldIndex) == "function" then
			result = oldIndex(self, key)
		else
			result = oldIndex[key]
		end
		if result == nil and type(key) == "string" and key:sub(1, 9) == "Connected" then
			return true
		end
		return result
	end)
	lockMeta(connMt)
end)

if hookF then
	pcall(function()
		local oldGetStatus
		oldGetStatus = hookF(CP.GetAssetFetchStatus, wrapC(function(self, asset)
			if type(asset) == "table" then
				error("blocked")
			end
			if KeepAcHeartbeat and BlacklistedAssets[asset] then
				return Enum.AssetFetchStatus.None
			end
			return oldGetStatus(self, asset)
		end))
	end)
	pcall(function()
		hookF(CP.GetAssetFetchStatusChangedSignal, wrapC(function()
			return fakeSignal()
		end))
	end)
	pcall(function()
		local oldFPS
		oldFPS = hookF(workspace.GetRealPhysicsFPS, wrapC(function(self)
			local fps = oldFPS(self)
			if fps and fps > 70 then
				return 60
			end
			return fps
		end))
	end)
	pcall(function()
		local oldFindService
		oldFindService = hookF(game.FindService, wrapC(function(self, name)
			if HiddenServices[name] then
				return nil
			end
			return oldFindService(self, name)
		end))
	end)
end

local function isAcScript(s)
	if not s:IsA("LocalScript") then
		return false
	end
	if s.Name == "CharacterCleanup" then
		return true
	end
	if KeepAcHeartbeat then
		return false
	end
	return s.Name:match("^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$") ~= nil
end

local function killACScript()
	local scripts = lp:WaitForChild("PlayerScripts")
	for _, s in next, scripts:GetChildren() do
		if isAcScript(s) then
			s.Disabled = true
			s:Destroy()
		end
	end
	scripts.ChildAdded:Connect(function(s)
		task.defer(function()
			if isAcScript(s) then
				s.Disabled = true
				s:Destroy()
			end
		end)
	end)
end

killACScript()

task.wait(4)

local ok, executor = pcall(function()
	return identifyexecutor()
end)

if ok and executor then
	local name = string.lower(executor)
	if string.find(name, "xeno") then
		game.Players.LocalPlayer.Kick(game.Players.LocalPlayer, "Xeno Executor detected (" .. executor .. "). Please join without an executor.")
	end
end

local Zolar = loadstring(game:HttpGet("https://raw.githubusercontent.com/Ali-lov3/ZolarLib/refs/heads/main/Zolar.lua"))()

local Window = Zolar:Window({
	Name = "STREETLIFE",
	Icon = "77434646025119",
	Accent = Color3.fromRGB(179, 165, 255)
})

local T = {}
local S = {}

T.Main = Window:Tab({ Name = "Main", Icon = "home" })
T.Visual = Window:Tab({ Name = "Visual", Icon = "eye" })
T.Combat = Window:Tab({ Name = "Combat", Icon = "crosshair" })
T.GunMods = Window:Tab({ Name = "GunMods", Icon = "wrench" })
T.Player = Window:Tab({ Name = "Player", Icon = "user" })
T.Shop = Window:Tab({ Name = "Shop", Icon = "shopping-cart" })
T.Misc = Window:Tab({ Name = "Misc", Icon = "settings" })
T.Settings = Window:Tab({ Name = "Settings", Icon = "settings" })

T.MainSub = T.Main:SubTab({ Name = "Farm", Icon = "home" })
T.VisualSub = T.Visual:SubTab({ Name = "ESP", Icon = "scan-eye" })
T.CombatSub = T.Combat:SubTab({ Name = "Silent Aim", Icon = "crosshair" })
T.GunModsSub = T.GunMods:SubTab({ Name = "Mods", Icon = "wrench" })
T.PlayerSub = T.Player:SubTab({ Name = "Movement", Icon = "user" })
T.ShopSub = T.Shop:SubTab({ Name = "Buy", Icon = "shopping-cart" })
T.MiscSub = T.Misc:SubTab({ Name = "Utility", Icon = "settings" })
T.SettingsSub = T.Settings:SubTab({ Name = "Config", Icon = "save" })

local LabelState = {}

local function RegisterLabel(label, text)
	if label == nil then
		label = {}
	end
	LabelState[label] = { Text = text, Instance = nil, LastSearch = 0 }
	return label
end

local function LocateLabel(state)
	local roots = {}
	pcall(function()
		if gethui then
			table.insert(roots, gethui())
		end
	end)
	pcall(function()
		table.insert(roots, game:GetService("CoreGui"))
	end)
	pcall(function()
		table.insert(roots, lp:FindFirstChildOfClass("PlayerGui"))
	end)
	for _, root in ipairs(roots) do
		local ok, found = pcall(function()
			for _, d in ipairs(root:GetDescendants()) do
				if d:IsA("TextLabel") and string.find(d.Text, state.Text, 1, true) then
					return d
				end
			end
		end)
		if ok and found then
			return found
		end
	end
	return nil
end

local function SetLabel(label, text)
	local state = LabelState[label]
	if state and state.Instance and state.Instance.Parent then
		state.Instance.Text = text
		state.Text = text
		return
	end
	for _, method in ipairs({ "Set", "SetText", "SetName", "Update" }) do
		local ok, fn = pcall(function()
			return label[method]
		end)
		if ok and type(fn) == "function" then
			if pcall(fn, label, text) then
				if state then
					state.Text = text
				end
				return
			end
		end
	end
	if state and os.clock() - state.LastSearch > 3 then
		state.LastSearch = os.clock()
		state.Instance = LocateLabel(state)
		if state.Instance then
			state.Instance.Text = text
			state.Text = text
		end
	end
end

local function SetValue(control, value)
	for _, method in ipairs({ "Set", "SetValue" }) do
		local ok, fn = pcall(function()
			return control[method]
		end)
		if ok and type(fn) == "function" then
			if pcall(fn, control, value) then
				return
			end
		end
	end
end

local function RefreshItems(control, items)
	for _, method in ipairs({ "Refresh", "SetItems", "SetOptions", "UpdateItems" }) do
		local ok, fn = pcall(function()
			return control[method]
		end)
		if ok and type(fn) == "function" then
			if pcall(fn, control, items) then
				return
			end
		end
	end
end


local Settings = {
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
	WeaponGradient = false,
	Backpack = false,
	BackpackGradient = false,
	Distance = false,
	DistanceGradient = false,
	GradientColor1 = Color3.fromRGB(255, 255, 255),
	GradientColor2 = Color3.fromRGB(255, 80, 180)
}

local CombatSettings = {
	Enabled = false,
	ShowFov = false,
	FovColor = Color3.fromRGB(255, 255, 255),
	FovSize = 200,
	FovOrigin = "Cursor",
	TargetDot = false,
	TargetHighlight = false,
	FovSnapline = false,
	Wallcheck = false,
	Friendcheck = false,
	AutoShoot = false,
}

local TracerSettings = {
	Enabled = false,
	Color = Color3.fromRGB(255, 80, 180),
	Duration = 3,
}

local GunPrices = {
	["Scar-17"] = 10000,
	["AKS-74U"] = 8500,
	["BinaryG17"] = 7000,
	["TSR-15"] = 8000,
	["MP5"] = 7500,
	["Vector"] = 7000,
	["ARPistol"] = 5000,
	["HoneyBadger"] = 5500,
	["AK-47"] = 6500,
	["Draco"] = 5200,
	["AUG"] = 5000,
	["GlockSwitch"] = 5400,
	["UMP"] = 4800,
	["Glock19X"] = 5000,
	["Shotgun"] = 5000,
	["Glock17"] = 1200,
	["Mac"] = 3000,
	["Tec-9"] = 3500,
	["Ruger"] = 800,
	["Makarov"] = 1000
}

local GunNames = {
	"Scar-17",
	"AKS-74U",
	"BinaryG17",
	"TSR-15",
	"MP5",
	"Vector",
	"ARPistol",
	"HoneyBadger",
	"AK-47",
	"Draco",
	"AUG",
	"GlockSwitch",
	"UMP",
	"Glock19X",
	"Shotgun",
	"Glock17",
	"Mac",
	"Tec-9",
	"Ruger",
	"Makarov"
}

local AmmoPrices = {
	["Shotgun Ammo"] = 100,
	["SMG Ammo"] = 100,
	["Rifle Ammo"] = 100,
	["Pistol Ammo"] = 50
}

local AmmoNames = {
	"Shotgun Ammo",
	"SMG Ammo",
	"Rifle Ammo",
	"Pistol Ammo"
}

local AutoBuyGunEnabled = false
local AutoBuyAttempts = 0
local SelectedGun = "Glock17"
local SelectedAmmo = "Pistol Ammo"
local WithdrawAmount = 250000
local DepositInputAmount = 50000
local SelectedPlayerName = ""
local SendMoneyAmount = 1000

local Players = game.GetService(game, "Players")

local function GetPlayerNames()
	local list = {}
	for _, p in ipairs(Players.GetPlayers(Players)) do
		if p ~= Players.LocalPlayer then
			table.insert(list, p.Name)
		end
	end
	if #list == 0 then
		table.insert(list, "None")
	end
	return list
end

local function FirstOption(option)
	if type(option) == "table" then
		return option[1]
	end
	return option
end

S.EspToggles = T.VisualSub:Section({
	Name = "ESP Toggles",
	Side = 1
})

S.EspToggles:Toggle({
	Name = "Box ESP",
	Default = false,
	Flag = "ESPBox",
	Callback = function(state)
		Settings.Box = state
	end,
})

S.EspToggles:Toggle({
	Name = "Box Gradient",
	Default = false,
	Flag = "ESPBoxGradient",
	Callback = function(state)
		Settings.BoxGradient = state
	end,
})

S.EspToggles:Toggle({
	Name = "Glow",
	Default = false,
	Flag = "ESPGlow",
	Callback = function(state)
		Settings.Glow = state
	end,
})

S.EspToggles:Toggle({
	Name = "Glow Gradient",
	Default = false,
	Flag = "ESPGlowGradient",
	Callback = function(state)
		Settings.GlowGradient = state
	end,
})

S.EspToggles:Toggle({
	Name = "Health Bar",
	Default = false,
	Flag = "ESPHealthBar",
	Callback = function(state)
		Settings.HealthBar = state
	end,
})

S.EspToggles:Toggle({
	Name = "Health Bar Gradient",
	Default = false,
	Flag = "ESPHealthBarGradient",
	Callback = function(state)
		Settings.HealthBarGradient = state
	end,
})

S.EspToggles:Toggle({
	Name = "Health Text",
	Default = false,
	Flag = "ESPHealthText",
	Callback = function(state)
		Settings.HealthText = state
	end,
})

S.EspToggles:Toggle({
	Name = "Health Text Gradient",
	Default = false,
	Flag = "ESPHealthTextGradient",
	Callback = function(state)
		Settings.HealthTextGradient = state
	end,
})

S.EspToggles:Toggle({
	Name = "Name",
	Default = false,
	Flag = "ESPName",
	Callback = function(state)
		Settings.Name = state
	end,
})

S.EspToggles:Toggle({
	Name = "Display Name",
	Default = false,
	Flag = "ESPDisplayName",
	Callback = function(state)
		Settings.DisplayName = state
	end,
})

S.EspToggles:Toggle({
	Name = "Name Gradient",
	Default = false,
	Flag = "ESPNameGradient",
	Callback = function(state)
		Settings.NameGradient = state
	end,
})

S.EspStyles = T.VisualSub:Section({
	Name = "ESP Styles & Colors",
	Side = 2
})

S.EspStyles:Toggle({
	Name = "Avatar",
	Default = false,
	Flag = "ESPAvatar",
	Callback = function(state)
		Settings.Avatar = state
	end,
})

S.EspStyles:Toggle({
	Name = "Weapon",
	Default = false,
	Flag = "ESPWeapon",
	Callback = function(state)
		Settings.Weapon = state
	end,
})

S.EspStyles:Toggle({
	Name = "Weapon Gradient",
	Default = false,
	Flag = "ESPWeaponGradient",
	Callback = function(state)
		Settings.WeaponGradient = state
	end,
})

S.EspStyles:Toggle({
	Name = "Backpack",
	Default = false,
	Flag = "ESPBackpack",
	Callback = function(state)
		Settings.Backpack = state
	end,
})

S.EspStyles:Toggle({
	Name = "Backpack Gradient",
	Default = false,
	Flag = "ESPBackpackGradient",
	Callback = function(state)
		Settings.BackpackGradient = state
	end,
})

S.EspStyles:Toggle({
	Name = "Distance",
	Default = false,
	Flag = "ESPDistance",
	Callback = function(state)
		Settings.Distance = state
	end,
})

S.EspStyles:Toggle({
	Name = "Distance Gradient",
	Default = false,
	Flag = "ESPDistanceGradient",
	Callback = function(state)
		Settings.DistanceGradient = state
	end,
})

S.EspStyles:Colorpicker({
	Name = "Glow Color",
	Default = Color3.fromRGB(255, 80, 180),
	Flag = "ESPGlowColor",
	Callback = function(color)
		Settings.GlowColor = color
	end,
})

S.EspStyles:Colorpicker({
	Name = "Gradient Color 1",
	Default = Color3.fromRGB(255, 255, 255),
	Flag = "ESPGradientColor1",
	Callback = function(color)
		Settings.GradientColor1 = color
	end,
})

S.EspStyles:Colorpicker({
	Name = "Gradient Color 2",
	Default = Color3.fromRGB(255, 80, 180),
	Flag = "ESPGradientColor2",
	Callback = function(color)
		Settings.GradientColor2 = color
	end,
})

S.Tracer = T.VisualSub:Section({
	Name = "Bullet Tracer",
	Side = 1
})

S.Tracer:Toggle({
	Name = "Enable Tracer",
	Default = false,
	Flag = "VisualTracerEnabled",
	Callback = function(state)
		TracerSettings.Enabled = state
	end,
})

S.Tracer:Colorpicker({
	Name = "Tracer Color",
	Default = Color3.fromRGB(255, 80, 180),
	Flag = "VisualTracerColor",
	Callback = function(color)
		TracerSettings.Color = color
	end,
})

S.Tracer:Slider({
	Name = "Tracer Duration",
	Min = 1,
	Max = 10,
	Suffix = "s",
	Default = 3,
	Flag = "VisualTracerDuration",
	Callback = function(v)
		TracerSettings.Duration = v
	end,
})

S.SilentAim = T.CombatSub:Section({
	Name = "Silent Aim",
	Side = 1
})

S.SilentAim:Toggle({
	Name = "Enable Silent Aim",
	Default = false,
	Flag = "CombatEnabled",
	Callback = function(state)
		CombatSettings.Enabled = state
		SilentAim.Enabled = state
	end,
})

S.SilentAim:Toggle({
	Name = "Auto Shoot",
	Default = false,
	Flag = "CombatAutoShoot",
	Callback = function(state)
		CombatSettings.AutoShoot = state
	end,
})

S.SilentAim:Toggle({
	Name = "Show FOV",
	Default = false,
	Flag = "CombatShowFov",
	Callback = function(state)
		CombatSettings.ShowFov = state
	end,
})

S.SilentAim:Slider({
	Name = "FOV Size",
	Min = 50,
	Max = 800,
	Suffix = "px",
	Default = 200,
	Flag = "CombatFovSize",
	Callback = function(v)
		CombatSettings.FovSize = v
	end,
})

S.SilentAim:Dropdown({
	Name = "FOV Origin",
	Items = { "Cursor", "Screen Center" },
	Default = "Cursor",
	Flag = "CombatFovOrigin",
	Callback = function(option)
		CombatSettings.FovOrigin = FirstOption(option)
	end,
})

S.SilentAim:Colorpicker({
	Name = "FOV Color",
	Default = Color3.fromRGB(255, 255, 255),
	Flag = "CombatFovColor",
	Callback = function(color)
		CombatSettings.FovColor = color
	end,
})

S.FovVisuals = T.CombatSub:Section({
	Name = "FOV & Visuals",
	Side = 2
})

S.FovVisuals:Toggle({
	Name = "Target Dot",
	Default = false,
	Flag = "CombatTargetDot",
	Callback = function(state)
		CombatSettings.TargetDot = state
	end,
})

S.FovVisuals:Toggle({
	Name = "Target Highlight",
	Default = false,
	Flag = "CombatTargetHighlight",
	Callback = function(state)
		CombatSettings.TargetHighlight = state
	end,
})

S.FovVisuals:Toggle({
	Name = "FOV Snapline",
	Default = false,
	Flag = "CombatFovSnapline",
	Callback = function(state)
		CombatSettings.FovSnapline = state
	end,
})

S.FovVisuals:Toggle({
	Name = "Wallcheck",
	Default = false,
	Flag = "CombatWallcheck",
	Callback = function(state)
		CombatSettings.Wallcheck = state
	end,
})

S.FovVisuals:Toggle({
	Name = "Friendcheck",
	Default = false,
	Flag = "CombatFriendcheck",
	Callback = function(state)
		CombatSettings.Friendcheck = state
	end,
})

local function BuyItem(name, price)
	local remotes = RS.FindFirstChild(RS, "Remotes")
	local gunBuy = remotes and remotes.FindFirstChild(remotes, "GunBuy")
	if gunBuy and price then
		gunBuy.FireServer(gunBuy, name, price)
		return true
	end
	return false
end

local function OwnsTool(name)
	local backpack = lp.FindFirstChildOfClass(lp, "Backpack")
	if backpack and backpack.FindFirstChild(backpack, name) then
		return true
	end
	local character = lp.Character
	return character ~= nil and character.FindFirstChild(character, name) ~= nil
end

S.GunBuy = T.ShopSub:Section({
	Name = "Gun Buy",
	Side = 1
})

S.GunBuy:Dropdown({
	Name = "Select Gun",
	Items = GunNames,
	Default = "Glock17",
	Flag = "ShopGunSelect",
	Callback = function(option)
		SelectedGun = FirstOption(option)
	end,
})

S.GunBuy:Button({
	Name = "Buy Selected Gun",
	Callback = function()
		pcall(function()
			BuyItem(SelectedGun, GunPrices[SelectedGun])
		end)
	end,
})

local AutoBuyToggle = S.GunBuy:Toggle({
	Name = "Auto Buy Selected Gun",
	Default = false,
	Flag = "ShopAutoBuyGun",
	Callback = function(state)
		AutoBuyGunEnabled = state
		AutoBuyAttempts = 0
	end,
})

S.AmmoBuy = T.ShopSub:Section({
	Name = "Ammo Buy",
	Side = 2
})

S.AmmoBuy:Dropdown({
	Name = "Select Ammo",
	Items = AmmoNames,
	Default = "Pistol Ammo",
	Flag = "ShopAmmoSelect",
	Callback = function(option)
		SelectedAmmo = FirstOption(option)
	end,
})

S.AmmoBuy:Button({
	Name = "Buy Selected Ammo",
	Callback = function()
		pcall(function()
			BuyItem(SelectedAmmo, AmmoPrices[SelectedAmmo])
		end)
	end,
})

task.spawn(function()
	while true do
		if AutoBuyGunEnabled then
			pcall(function()
				if not OwnsTool(SelectedGun) then
					if AutoBuyAttempts >= 5 then
						AutoBuyGunEnabled = false
						SetValue(AutoBuyToggle, false)
						Zolar:Notification({
							Name = "Auto Buy",
							Description = "Stopped after 5 tries without receiving " .. SelectedGun,
							Icon = "shopping-cart",
							Duration = 5
						})
					else
						AutoBuyAttempts = AutoBuyAttempts + 1
						BuyItem(SelectedGun, GunPrices[SelectedGun])
					end
				end
			end)
		end
		task.wait(3)
	end
end)

S.Atm = T.MiscSub:Section({
	Name = "ATM Management",
	Side = 1
})

S.Atm:Textbox({
	Name = "Withdraw Amount",
	Default = "250000",
	Placeholder = "e.g. 250000",
	Finished = true,
	Flag = "AtmWithdrawAmount",
	Callback = function(text)
		local val = tonumber(text)
		if val then
			WithdrawAmount = val
		end
	end,
})

S.Atm:Button({
	Name = "Withdraw Money",
	Callback = function()
		pcall(function()
			local remotes = game.GetService(game, "ReplicatedStorage").FindFirstChild(game.GetService(game, "ReplicatedStorage"), "Remotes")
			local atm = remotes and remotes.FindFirstChild(remotes, "ATM")
			if atm then
				atm.FireServer(atm, "Withdraw", WithdrawAmount)
			end
		end)
	end,
})

S.Atm:Textbox({
	Name = "Deposit Amount",
	Default = "50000",
	Placeholder = "e.g. 50000",
	Finished = true,
	Flag = "AtmDepositAmountInput",
	Callback = function(text)
		local val = tonumber(text)
		if val then
			DepositInputAmount = val
		end
	end,
})

S.Atm:Button({
	Name = "Deposit Money",
	Callback = function()
		pcall(function()
			local remotes = game.GetService(game, "ReplicatedStorage").FindFirstChild(game.GetService(game, "ReplicatedStorage"), "Remotes")
			local atm = remotes and remotes.FindFirstChild(remotes, "ATM")
			if atm then
				atm.FireServer(atm, "Deposit", DepositInputAmount)
			end
		end)
	end,
})

S.Server = T.MiscSub:Section({
	Name = "Server",
	Side = 2
})

S.Server:Button({
	Name = "Serverhop",
	Callback = function()
		pcall(function()
			local ts = game.GetService(game, "TeleportService")
			local hs = game.GetService(game, "HttpService")
			local servers = hs.JSONDecode(hs, game.HttpGet(game, "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
			for _, s in ipairs(servers.data) do
				if s.playing < s.maxPlayers and s.id ~= game.JobId then
					ts.TeleportToPlaceInstance(ts, game.PlaceId, s.id)
					break
				end
			end
		end)
	end,
})

S.Server:Button({
	Name = "Rejoin Server",
	Callback = function()
		pcall(function()
			local ts = game.GetService(game, "TeleportService")
			ts.Teleport(ts, game.PlaceId, Players.LocalPlayer)
		end)
	end,
})

S.SendMoney = T.MiscSub:Section({
	Name = "Send Money",
	Side = 2
})

local PlayerDropdown = S.SendMoney:Dropdown({
	Name = "Select Player",
	Items = GetPlayerNames(),
	Flag = "MiscSelectPlayer",
	Callback = function(option)
		SelectedPlayerName = FirstOption(option) or ""
	end,
})

local function RefreshPlayerDropdown()
	pcall(function()
		RefreshItems(PlayerDropdown, GetPlayerNames())
	end)
end

Players.PlayerAdded:Connect(function()
	task.delay(0.5, RefreshPlayerDropdown)
end)

Players.PlayerRemoving:Connect(function()
	task.delay(0.5, RefreshPlayerDropdown)
end)

S.SendMoney:Textbox({
	Name = "Amount",
	Default = "1000",
	Placeholder = "e.g. 1000",
	Finished = true,
	Flag = "MiscSendAmount",
	Callback = function(text)
		local val = tonumber(text)
		if val then
			SendMoneyAmount = val
		end
	end,
})

S.SendMoney:Button({
	Name = "Send",
	Callback = function()
		pcall(function()
			local targetPlayer = Players.FindFirstChild(Players, SelectedPlayerName)
			if targetPlayer then
				local remotes = game.GetService(game, "ReplicatedStorage").FindFirstChild(game.GetService(game, "ReplicatedStorage"), "Remotes")
				local phone = remotes and remotes.FindFirstChild(remotes, "Phone")
				if phone then
					phone.FireServer(phone, "SendMoney", targetPlayer, SendMoneyAmount)
				end
			end
		end)
	end,
})

local PathfindingService = game.GetService(game, "PathfindingService")
local ReplicatedStorage = game.GetService(game, "ReplicatedStorage")
local TweenService = game.GetService(game, "TweenService")
local RunService = game.GetService(game, "RunService")
local UserInputService = game.GetService(game, "UserInputService")
local Camera = workspace.CurrentCamera

local CustomTween = nil
local successTween, resultTween = pcall(function()
	return loadstring(game.HttpGet(game, "https://raw.githubusercontent.com/Ali-lov3/Custom-Tween/refs/heads/main/CustomTweenSystem.luau"))()
end)

if successTween and type(resultTween) == "table" and resultTween.new then
	CustomTween = resultTween
else
	CustomTween = {
		new = function(object, duration, goal, easingStyle)
			local info = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
			local tw = TweenService.Create(TweenService, object, info, goal)
			local proxy = setmetatable({
				Play = function(self)
					tw.Play(tw)
				end,
				Cancel = function(self)
					tw.Cancel(tw)
				end
			}, {
				__index = function(_, k)
					if k == "PlaybackState" then
						return tw.PlaybackState
					end
					return nil
				end
			})
			return proxy
		end
	}
end

local LocalPlayer = Players.LocalPlayer
local TweenSpeed = 35

local BoxFarmEnabled = false
local BoxFarmMethod = "Legit"

local MopFarmEnabled = false
local MopFarmMethod = "Legit"

local AutoBankEnabled = false
local AutoBankAmount = 50000

local StartMoney = 0
local CurrentMoney = 0
local TotalDeposited = 0
local EarnedMoney = 0
local FarmTimeSeconds = 0
local FarmTimerRunning = false

local takePos = Vector3.new(205.29685974121094, 52.38993453979492, 339.0135803222656)
local deliverPos = Vector3.new(157.49252319335938, 53.04217529296875, 261.873779296875)
local boxWaypoints = {
	Vector3.new(166.3795166015625, 53.04216384887695, 273.505615234375),
	Vector3.new(130.12022399902344, 66.79084014892578, 271.1786804199219),
}

local CheckStartTimer
local StartMoneyLabel
local UpdateStatus

S.Farms = T.MainSub:Section({
	Name = "Farms",
	Side = 1
})

S.Farms:Toggle({
	Name = "Enable Box Farm",
	Default = false,
	Flag = "FarmBoxFarm",
	Callback = function(state)
		BoxFarmEnabled = state
		if CheckStartTimer then
			CheckStartTimer()
		end
	end,
})

S.Farms:Dropdown({
	Name = "Box Farm Method",
	Items = { "Legit", "Fast" },
	Default = "Legit",
	Flag = "FarmBoxMethod",
	Callback = function(option)
		BoxFarmMethod = FirstOption(option)
	end,
})

S.Farms:Toggle({
	Name = "Enable Clean Job Farm",
	Default = false,
	Flag = "FarmCleanFarm",
	Callback = function(state)
		MopFarmEnabled = state
		if CheckStartTimer then
			CheckStartTimer()
		end
	end,
})

S.Farms:Dropdown({
	Name = "Clean Job Method",
	Items = { "Legit", "Fast" },
	Default = "Legit",
	Flag = "FarmCleanMethod",
	Callback = function(option)
		MopFarmMethod = FirstOption(option)
	end,
})

S.Farms:Slider({
	Name = "Tween Speed",
	Min = 1,
	Max = 35,
	Suffix = "",
	Default = 35,
	Flag = "FarmSpeed",
	Callback = function(v)
		TweenSpeed = v
	end,
})

S.Farms:Toggle({
	Name = "Enable Auto Deposit",
	Default = false,
	Flag = "FarmAutoDeposit",
	Callback = function(state)
		AutoBankEnabled = state
	end,
})

S.Farms:Textbox({
	Name = "Deposit Target Amount",
	Default = "",
	Placeholder = "e.g. 50000",
	Finished = true,
	Flag = "FarmDepositAmount",
	Callback = function(text)
		local val = tonumber(text)
		if val then
			AutoBankAmount = val
		end
	end,
})

S.FarmInfos = T.MainSub:Section({
	Name = "Farm Infos",
	Side = 2
})

local StatusLabel = S.FarmInfos:Label({
	Name = "Status - Idle"
})
StatusLabel = RegisterLabel(StatusLabel, "Status - Idle")
StartMoneyLabel = S.FarmInfos:Label({
	Name = "Start Money - 0"
})
StartMoneyLabel = RegisterLabel(StartMoneyLabel, "Start Money - 0")
local CurrentMoneyLabel = S.FarmInfos:Label({
	Name = "Current Money - 0"
})
CurrentMoneyLabel = RegisterLabel(CurrentMoneyLabel, "Current Money - 0")
local EarnedMoneyLabel = S.FarmInfos:Label({
	Name = "Earned Money - 0"
})
EarnedMoneyLabel = RegisterLabel(EarnedMoneyLabel, "Earned Money - 0")
local TimeLabel = S.FarmInfos:Label({
	Name = "Time Elapsed - 00-00-00"
})
TimeLabel = RegisterLabel(TimeLabel, "Time Elapsed - 00-00-00")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BoxESP"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = gethui and gethui() or game.GetService(game, "CoreGui")

local ESPFolder = Instance.new("Folder")
ESPFolder.Parent = ScreenGui

local fovGui = Instance.new("ScreenGui")
fovGui.Name = "SilentAimFOV"
fovGui.ResetOnSpawn = false
fovGui.IgnoreGuiInset = true
fovGui.Parent = gethui and gethui() or game.GetService(game, "CoreGui")

local fovCircle = Drawing.new("Circle")
fovCircle.Filled = false
fovCircle.NumSides = 64
fovCircle.Thickness = 1.2
fovCircle.Transparency = 1
fovCircle.Color = CombatSettings.FovColor
fovCircle.Visible = false

local dot = Instance.new("Frame")
dot.Size = UDim2.fromOffset(8, 8)
dot.AnchorPoint = Vector2.new(0.5, 0.5)
dot.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
dot.BorderSizePixel = 0
dot.Visible = false
dot.ZIndex = 2
dot.Parent = fovGui
Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

local snapline = Drawing.new("Line")
snapline.Thickness = 1.2
snapline.Transparency = 1
snapline.Color = CombatSettings.FovColor
snapline.Visible = false

local activeHighlight = Instance.new("Highlight")
activeHighlight.FillTransparency = 0.5
activeHighlight.OutlineTransparency = 0
activeHighlight.FillColor = Color3.fromRGB(255, 80, 180)
activeHighlight.OutlineColor = Color3.fromRGB(255, 255, 255)
activeHighlight.Parent = nil
local currentHighlightTarget = nil

local Objects = {}

local function IsVisible(targetPart, character)
	if not CombatSettings.Wallcheck then return true end
	local origin = Camera.CFrame.Position
	local direction = targetPart.Position - origin
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	local excludeList = { LocalPlayer.Character }
	if character then
		table.insert(excludeList, character)
	end
	raycastParams.FilterDescendantsInstances = excludeList
	raycastParams.IgnoreWater = true
	local result = workspace.Raycast(workspace, origin, direction, raycastParams)
	if not result then
		return true
	end
	return result.Instance.IsDescendantOf(result.Instance, character)
end

local function IsValidPlayer(player)
	if player == LocalPlayer then return false end
	if CombatSettings.Friendcheck then
		local success, isFriend = pcall(function()
			return LocalPlayer.IsFriendsWith(LocalPlayer, player.UserId)
		end)
		if success and isFriend then
			return false
		end
	end
	return true
end

local function getClosestHead()
	local originPos
	if CombatSettings.FovOrigin == "Cursor" then
		originPos = UserInputService.GetMouseLocation(UserInputService)
	else
		originPos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
	end

	local bestDist = CombatSettings.FovSize
	local bestHead = nil
	local bestScreen = nil
	local bestCharacter = nil

	for _, player in ipairs(Players.GetPlayers(Players)) do
		if IsValidPlayer(player) and player.Character then
			local character = player.Character
			local head = character.FindFirstChild(character, "Head")
			local humanoid = character.FindFirstChildWhichIsA(character, "Humanoid")
			if head and humanoid and humanoid.Health > 0 then
				local screenPos, onScreen = Camera.WorldToViewportPoint(Camera, head.Position)
				if onScreen then
					local dist = (Vector2.new(screenPos.X, screenPos.Y) - originPos).Magnitude
					if dist < bestDist then
						if IsVisible(head, character) then
							bestDist = dist
							bestHead = head
							bestScreen = Vector2.new(screenPos.X, screenPos.Y)
							bestCharacter = character
						end
					end
				end
			end
		end
	end
	return bestHead, bestScreen, bestCharacter, originPos
end

local KillauraSettings = {
	Enabled = false,
	Range = 10,
	GunRange = 100,
}

local MeleeCooldowns = {
	Fist = 0.65,
	Knife = 1.25,
	Bat = 1.5,
	Katana = 1.4,
	Baton = 1.1,
}

local LastKillauraHit = 0

local function FindKillauraTarget(position, range)
	local bestHead = nil
	local bestDistance = range
	for _, player in ipairs(Players.GetPlayers(Players)) do
		if IsValidPlayer(player) and player.Character then
			local character = player.Character
			local head = character.FindFirstChild(character, "Head")
			local humanoid = character.FindFirstChildWhichIsA(character, "Humanoid")
			if head and humanoid and humanoid.Health > 0 and not character.FindFirstChild(character, "ForceField") then
				local distance = (head.Position - position).Magnitude
				if distance < bestDistance and IsVisible(head, character) then
					bestDistance = distance
					bestHead = head
				end
			end
		end
	end
	return bestHead
end

SilentAim.Resolve = function(origin)
	local head = nil
	if SilentAim.Killaura then
		head = FindKillauraTarget(origin, KillauraSettings.GunRange)
	end
	if not head and SilentAim.Enabled then
		head = getClosestHead()
	end
	if not head then
		return nil
	end
	local offset = head.Position - origin
	if offset.Magnitude < 0.001 then
		return nil
	end
	return offset.Unit
end

S.Killaura = T.CombatSub:Section({
	Name = "Killaura",
	Side = 1
})

S.Killaura:Toggle({
	Name = "Enable Killaura",
	Default = false,
	Flag = "CombatKillaura",
	Callback = function(state)
		KillauraSettings.Enabled = state
		if not state then
			SilentAim.Killaura = false
		end
	end,
})

S.Killaura:Slider({
	Name = "Melee Range",
	Min = 5,
	Max = 25,
	Default = 10,
	Suffix = " studs",
	Flag = "CombatKillauraRange",
	Callback = function(v)
		KillauraSettings.Range = v
	end,
})

S.Killaura:Slider({
	Name = "Gun Range",
	Min = 20,
	Max = 300,
	Default = 100,
	Suffix = " studs",
	Flag = "CombatKillauraGunRange",
	Callback = function(v)
		KillauraSettings.GunRange = v
	end,
})

local GunCache = { Tool = nil, Gun = nil, Searching = false, LastSearch = 0 }
local ForcedGun = nil

local function ScanForGun(tool)
	GunCache.Searching = true
	pcall(function()
		if filtergc then
			local list = filtergc("table", { Keys = { "_FireRequest", "Settings", "Instance" } }, false)
			if type(list) == "table" then
				for _, object in ipairs(list) do
					if rawget(object, "Instance") == tool then
						GunCache.Gun = object
						break
					end
				end
			end
		elseif getgc then
			local list = getgc(true)
			for index = 1, #list do
				local object = list[index]
				if type(object) == "table" and rawget(object, "Instance") == tool and rawget(object, "_FireRequest") ~= nil then
					GunCache.Gun = object
					break
				end
				if index % 3000 == 0 then
					task.wait()
				end
			end
		end
	end)
	GunCache.Searching = false
end

local function GetEquippedGun(tool)
	if GunCache.Tool ~= tool then
		GunCache.Tool = tool
		GunCache.Gun = nil
		GunCache.LastSearch = 0
	end
	local cached = GunCache.Gun
	if cached and rawget(cached, "IsEquipped") then
		return cached
	end
	GunCache.Gun = nil
	if GunCache.Searching or os.clock() - GunCache.LastSearch < 10 then
		return nil
	end
	if not (filtergc or getgc) then
		return nil
	end
	GunCache.LastSearch = os.clock()
	task.spawn(ScanForGun, tool)
	return nil
end

local function ReleaseGun()
	if ForcedGun then
		pcall(function()
			ForcedGun._FireRequest = false
		end)
		ForcedGun = nil
	end
	SilentAim.Killaura = false
end

local function MeleeKillaura(root, cooldown)
	if os.clock() - LastKillauraHit < cooldown then return end
	local remotes = ReplicatedStorage:FindFirstChild("Remotes")
	local combat = remotes and remotes:FindFirstChild("Combat")
	if not combat then return end
	local fired = false
	for _, player in ipairs(Players:GetPlayers()) do
		if IsValidPlayer(player) then
			local targetCharacter = player.Character
			local targetHumanoid = targetCharacter and targetCharacter:FindFirstChildOfClass("Humanoid")
			local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
			if targetHumanoid and targetRoot and targetHumanoid.Health > 0 and not targetCharacter:FindFirstChild("ForceField") then
				if (targetRoot.Position - root.Position).Magnitude <= KillauraSettings.Range then
					combat:FireServer("Hit", targetHumanoid, targetCharacter:FindFirstChild("Head") or targetRoot)
					fired = true
				end
			end
		end
	end
	if fired then
		LastKillauraHit = os.clock()
	end
end

local ShootToggle = false

task.spawn(function()
	while true do
		if not (KillauraSettings.Enabled or CombatSettings.AutoShoot) then
			ReleaseGun()
			task.wait(0.25)
		else
			task.wait(0.1)
			pcall(function()
				local character = LocalPlayer.Character
				local root = character and character:FindFirstChild("HumanoidRootPart")
				local humanoid = character and character:FindFirstChildOfClass("Humanoid")
				local tool = character and character:FindFirstChildOfClass("Tool")
				if not root or not humanoid or humanoid.Health <= 0 or not tool then
					ReleaseGun()
					return
				end

				local meleeCooldown = MeleeCooldowns[tool.Name]
				if meleeCooldown then
					ReleaseGun()
					if KillauraSettings.Enabled then
						MeleeKillaura(root, meleeCooldown)
					end
					return
				end

				if not (tool:FindFirstChild("Settings") and tool:FindFirstChild("Handle")) then
					ReleaseGun()
					return
				end

				local killauraTarget = nil
				if KillauraSettings.Enabled then
					killauraTarget = FindKillauraTarget(root.Position, KillauraSettings.GunRange)
				end
				SilentAim.Killaura = killauraTarget ~= nil

				local silentTarget = nil
				if CombatSettings.AutoShoot and CombatSettings.Enabled and SilentAim.Enabled then
					silentTarget = getClosestHead()
				end

				local target = killauraTarget or silentTarget

				local gun = target and GetEquippedGun(tool)
				if gun then
					local automatic = true
					pcall(function()
						automatic = gun.Settings.IsAutomatic ~= false
					end)
					if automatic then
						gun._FireRequest = true
					else
						ShootToggle = not ShootToggle
						gun._FireRequest = ShootToggle
					end
					ForcedGun = gun
				elseif ForcedGun then
					ReleaseGun()
				end
			end)
		end
	end
end)

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
		local content, isReady = Players.GetUserThumbnailAsync(
			Players,
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
	obj.Box.Destroy(obj.Box)
	Objects[player] = nil
end

local function updateESP(obj)
	local player = obj.Player
	local character = player.Character
	if not character then
		obj.Box.Visible = false
		return
	end

	local hrp = character.FindFirstChild(character, "HumanoidRootPart")
	local humanoid = character.FindFirstChildOfClass(character, "Humanoid")

	if not hrp or not humanoid or humanoid.Health <= 0 then
		obj.Box.Visible = false
		return
	end

	local hrpPos, onScreen = Camera.WorldToViewportPoint(Camera, hrp.Position)
	if not onScreen then
		obj.Box.Visible = false
		return
	end

	local head = character.FindFirstChild(character, "Head")
	local topPos = head and head.Position + Vector3.new(0, 0.5, 0) or (hrp.Position + Vector3.new(0, 3, 0))
	local bottomPos = hrp.Position - Vector3.new(0, 3.5, 0)

	local topScreen = Camera.WorldToViewportPoint(Camera, topPos)
	local bottomScreen = Camera.WorldToViewportPoint(Camera, bottomPos)

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

	if Settings.Weapon then
		local tool = character.FindFirstChildOfClass(character, "Tool")
		if tool then
			obj.WeaponText.Visible = true
			obj.WeaponText.Text = tool.Name
			obj.WeaponText.Position = UDim2.new(0, 0, 1, bottomOffset)
			obj.WeaponTextGradient.Enabled = Settings.WeaponGradient
			if Settings.WeaponGradient then
				obj.WeaponTextGradient.Color = colorSeq
				obj.WeaponText.TextColor3 = Color3.fromRGB(255, 255, 255)
			else
				obj.WeaponText.TextColor3 = Color3.fromRGB(255, 255, 255)
			end
			bottomOffset = bottomOffset + 14
		else
			obj.WeaponText.Visible = false
		end
	else
		obj.WeaponText.Visible = false
	end

	if Settings.Distance then
		local myChar = LocalPlayer.Character
		local myHrp = myChar and myChar.FindFirstChild(myChar, "HumanoidRootPart")
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
		local backpack = player.FindFirstChild(player, "Backpack")
		if backpack then
			local items = {}
			for _, item in ipairs(backpack.GetChildren(backpack)) do
				if item.IsA(item, "Tool") then
					table.insert(items, item.Name)
				end
			end
			if #items > 0 then
				obj.BackpackText.Visible = true
				obj.BackpackText.Text = "[" .. table.concat(items, ", ") .. "]"
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
	else
		obj.BackpackText.Visible = false
	end

	obj.Box.Visible = Settings.Box or Settings.Glow or Settings.HealthBar or Settings.HealthText or Settings.Name or Settings.DisplayName or Settings.Avatar or Settings.Weapon or Settings.Distance or Settings.Backpack
end

local function onPlayerAdded(player)
	if player == LocalPlayer then return end
	Objects[player] = createESP(player)
end

for _, p in ipairs(Players.GetPlayers(Players)) do
	onPlayerAdded(p)
end

Players.PlayerAdded.Connect(Players.PlayerAdded, onPlayerAdded)
Players.PlayerRemoving.Connect(Players.PlayerRemoving, removeESP)

local EspWasOn = false

RunService.RenderStepped.Connect(RunService.RenderStepped, function()
	local anyEsp = Settings.Box or Settings.Glow or Settings.HealthBar or Settings.HealthText or Settings.Name
		or Settings.DisplayName or Settings.Avatar or Settings.Weapon or Settings.Backpack or Settings.Distance
	if anyEsp then
		EspWasOn = true
		for _, obj in pairs(Objects) do
			updateESP(obj)
		end
	elseif EspWasOn then
		EspWasOn = false
		for _, obj in pairs(Objects) do
			obj.Box.Visible = false
		end
	end

	fovCircle.Radius = CombatSettings.FovSize
	fovCircle.Color = CombatSettings.FovColor

	local originPos
	if CombatSettings.FovOrigin == "Cursor" then
		originPos = UserInputService.GetMouseLocation(UserInputService)
	else
		originPos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
	end
	fovCircle.Position = originPos

	if CombatSettings.Enabled and CombatSettings.ShowFov then
		fovCircle.Visible = true
	else
		fovCircle.Visible = false
	end

	local head, screenPos, character, origin
	if CombatSettings.Enabled then
		head, screenPos, character, origin = getClosestHead()
	end

	if CombatSettings.Enabled and head and screenPos then
		if CombatSettings.TargetDot then
			dot.Visible = true
			dot.Position = UDim2.fromOffset(screenPos.X, screenPos.Y)
		else
			dot.Visible = false
		end

		if CombatSettings.TargetHighlight and character then
			if currentHighlightTarget ~= character then
				activeHighlight.Parent = character
				currentHighlightTarget = character
			end
		else
			activeHighlight.Parent = nil
			currentHighlightTarget = nil
		end

		if CombatSettings.FovSnapline then
			snapline.From = origin
			snapline.To = screenPos
			snapline.Color = CombatSettings.FovColor
			snapline.Visible = true
		else
			snapline.Visible = false
		end
	else
		dot.Visible = false
		snapline.Visible = false
		activeHighlight.Parent = nil
		currentHighlightTarget = nil
	end
end)

local okProj, Projectile = pcall(require, ReplicatedStorage.Modules.GunFramework.Modules.Projectile)
if okProj and Projectile and Projectile.new then
	local originalNew = Projectile.new
	Projectile.new = function(params)
		local pending = SilentAim.Pending
		if (CombatSettings.Enabled or SilentAim.Killaura) and pending and params and params.Origin and params.Direction
			and os.clock() - pending.Time < 0.1 and (params.Origin - pending.Origin).Magnitude < 0.01 then
			local rotation = CFrame.lookAt(Vector3.zero, pending.New) * CFrame.lookAt(Vector3.zero, pending.Old):Inverse()
			params.Direction = rotation:VectorToWorldSpace(params.Direction).Unit
		end

		if TracerSettings.Enabled and params and params.Origin and params.Direction then
			task.spawn(function()
				local origin = params.Origin
				local endpoint = origin + params.Direction * 300

				local tracerPart = Instance.new("Part")
				tracerPart.Name = "BulletTracer"
				tracerPart.Anchored = true
				tracerPart.CanCollide = false
				tracerPart.Material = Enum.Material.Neon
				tracerPart.Color = TracerSettings.Color
				tracerPart.Transparency = 0.2

				local distance = (origin - endpoint).Magnitude
				tracerPart.Size = Vector3.new(0.1, 0.1, distance)
				tracerPart.CFrame = CFrame.new(origin, endpoint) * CFrame.new(0, 0, -distance / 2)
				tracerPart.Parent = workspace

				task.wait(TracerSettings.Duration)

				local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
				local tween = TweenService.Create(TweenService, tracerPart, tweenInfo, {Transparency = 1})
				tween.Play(tween)
				tween.Completed.Connect(tween.Completed, function()
					tracerPart.Destroy(tracerPart)
				end)
			end)
		end

		return originalNew(params)
	end
end

local function GetMoney()
	local success, val = pcall(function()
		if LocalPlayer.FindFirstChild(LocalPlayer, "Data") and LocalPlayer.Data.FindFirstChild(LocalPlayer.Data, "Money") then
			return LocalPlayer.Data.Money.Value or 0
		end
		return 0
	end)
	return success and val or 0
end

local function FormatTime(seconds)
	local hours = math.floor(seconds / 3600)
	local mins = math.floor((seconds % 3600) / 60)
	local secs = seconds % 60
	return string.format("%02d-%02d-%02d", hours, mins, secs)
end

UpdateStatus = function(text)
	pcall(function()
		SetLabel(StatusLabel, "Status - " .. text)
	end)
end

local function CheckAutoBank()
	if AutoBankEnabled then
		local money = GetMoney()
		if money >= AutoBankAmount and money > 0 then
			pcall(function()
				local remotes = ReplicatedStorage.FindFirstChild(ReplicatedStorage, "Remotes")
				local atmRemote = remotes and remotes.FindFirstChild(remotes, "ATM")
				if atmRemote then
					atmRemote.FireServer(atmRemote, "Deposit", money)
					TotalDeposited = TotalDeposited + money
				end
			end)
		end
	end
end

local function GetCharacterParts()
	local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded.Wait(LocalPlayer.CharacterAdded)
	local Humanoid = Character.WaitForChild(Character, "Humanoid")
	local RootPart = Character.WaitForChild(Character, "HumanoidRootPart")
	return Character, Humanoid, RootPart
end

local function IsAlive()
	local success, result = pcall(function()
		local Character = LocalPlayer.Character
		if not Character then return false end
		local Humanoid = Character.FindFirstChild(Character, "Humanoid")
		return Humanoid and Humanoid.Health > 0
	end)
	return success and result or false
end

local function HoldPrompt(prompt)
	if not prompt or not prompt.Parent then return end
	local duration = prompt.HoldDuration or 0
	prompt:InputHoldBegin()
	if duration > 0 then
		task.wait(duration + 0.05)
	else
		task.wait()
	end
	prompt:InputHoldEnd()
end

local function ResetHumanoidRotation()
	pcall(function()
		if not IsAlive() then return end
		local _, Humanoid, RootPart = GetCharacterParts()
		Humanoid.AutoRotate = true
		RootPart.RotVelocity = Vector3.new(0, 0, 0)
		RootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
	end)
end

local function MoveToFast(targetPosition, checkEnabled)
	if not IsAlive() then return end
	local _, _, RootPart = GetCharacterParts()
	ResetHumanoidRotation()

	local distance = (RootPart.Position - targetPosition).Magnitude
	local speed = math.clamp(TweenSpeed, 1, 35)
	local duration = distance / speed

	local tween = CustomTween.new(RootPart, duration, { CFrame = CFrame.new(targetPosition) }, "Linear")
	if tween then
		tween.Play(tween)

		while tween.PlaybackState == Enum.PlaybackState.Playing do
			if not checkEnabled() or not IsAlive() then
				tween.Cancel(tween)
				break
			end
			ResetHumanoidRotation()
			task.wait(0.05)
		end
	end

	ResetHumanoidRotation()
end

local function MovePathfindingTween(targetPosition, checkEnabled)
	if not IsAlive() then return end
	local _, _, RootPart = GetCharacterParts()
	ResetHumanoidRotation()

	local path = PathfindingService.CreatePath(PathfindingService, {
		AgentRadius = 2,
		AgentHeight = 5,
		AgentCanJump = true
	})

	local success = pcall(function()
		path.ComputeAsync(path, RootPart.Position, targetPosition)
	end)

	if success and path.Status == Enum.PathStatus.Success then
		local waypoints = path.GetWaypoints(path)

		for _, waypoint in ipairs(waypoints) do
			if not checkEnabled() or not IsAlive() then break end

			local currentPos = RootPart.Position
			local waypointPos = waypoint.Position
			local distance = (currentPos - waypointPos).Magnitude
			local speed = math.clamp(TweenSpeed, 1, 35)
			local duration = distance / speed

			local tween = CustomTween.new(RootPart, duration, { CFrame = CFrame.new(waypointPos) }, "Linear")
			if tween then
				tween.Play(tween)

				while tween.PlaybackState == Enum.PlaybackState.Playing do
					if not checkEnabled() or not IsAlive() then
						tween.Cancel(tween)
						break
					end
					ResetHumanoidRotation()
					task.wait(0.05)
				end
			end

			if not checkEnabled() or not IsAlive() then break end
		end
	else
		MoveToFast(targetPosition, checkEnabled)
	end

	ResetHumanoidRotation()
end

local function MoveToLegit(targetPosition, checkEnabled)
	if not IsAlive() then return end
	local _, Humanoid, RootPart = GetCharacterParts()
	ResetHumanoidRotation()

	local path = PathfindingService.CreatePath(PathfindingService, {
		AgentRadius = 2,
		AgentHeight = 5,
		AgentCanJump = true
	})

	local success = pcall(function()
		path.ComputeAsync(path, RootPart.Position, targetPosition)
	end)

	if success and path.Status == Enum.PathStatus.Success then
		local waypoints = path.GetWaypoints(path)
		for _, waypoint in ipairs(waypoints) do
			if not checkEnabled() or not IsAlive() then break end

			if waypoint.Action == Enum.PathWaypointAction.Jump then
				Humanoid.Jump = true
			end

			Humanoid.MoveTo(Humanoid, waypoint.Position)
			Humanoid.MoveToFinished.Wait(Humanoid.MoveToFinished)
		end
	else
		if IsAlive() then
			Humanoid.MoveTo(Humanoid, targetPosition)
			Humanoid.MoveToFinished.Wait(Humanoid.MoveToFinished)
		end
	end

	ResetHumanoidRotation()
end

local function MoveToBox(targetPosition, method, checkEnabled)
	if method == "Legit" then
		MoveToLegit(targetPosition, checkEnabled)
	elseif method == "Fast" then
		MovePathfindingTween(targetPosition, checkEnabled)
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

local function GetPromptPosition(prompt)
	if not prompt then return nil end
	local parent = prompt.Parent
	if not parent then return nil end
	if parent:IsA("BasePart") then
		return parent.Position
	elseif parent:IsA("Attachment") then
		return parent.WorldPosition
	elseif parent:IsA("Model") then
		return parent:GetPivot().Position
	end
	return nil
end

local function FindTakePrompt()
	local map = workspace.FindFirstChild(workspace, "Map")
	local jobs = map and map.FindFirstChild(map, "Jobs")
	local boxJob = jobs and jobs.FindFirstChild(jobs, "BoxJob")
	local takeFolder = boxJob and boxJob.FindFirstChild(boxJob, "Take")
	local takePart = takeFolder and takeFolder.FindFirstChild(takeFolder, "Take")
	return takePart and takePart.FindFirstChild(takePart, "Interact")
end

local function FindDeliverPrompt()
	local map = workspace.FindFirstChild(workspace, "Map")
	local jobs = map and map.FindFirstChild(map, "Jobs")
	local boxJob = jobs and jobs.FindFirstChild(jobs, "BoxJob")
	local deliverFolder = boxJob and boxJob.FindFirstChild(boxJob, "Deliver")
	local deliverPart = deliverFolder and deliverFolder.FindFirstChild(deliverFolder, "Deliver")
	local deliverInteract = deliverPart and deliverPart.FindFirstChild(deliverPart, "Interact")
	if not deliverInteract then
		local altDeliver = jobs and jobs.FindFirstChild(jobs, "Deliver")
		local altDeliverPart = altDeliver and altDeliver.FindFirstChild(altDeliver, "Deliver")
		deliverInteract = altDeliverPart and altDeliverPart.FindFirstChild(altDeliverPart, "Interact")
	end
	return deliverInteract
end

CheckStartTimer = function()
	if (BoxFarmEnabled or MopFarmEnabled) and not FarmTimerRunning then
		StartMoney = GetMoney()
		TotalDeposited = 0
		EarnedMoney = 0
		FarmTimeSeconds = 0
		FarmTimerRunning = true
		UpdateStatus("Starting")
		SetLabel(StartMoneyLabel, "Start Money - $" .. tostring(StartMoney))
	elseif not BoxFarmEnabled and not MopFarmEnabled then
		FarmTimerRunning = false
		UpdateStatus("Idle")
	end
end

task.spawn(function()
	while true do
		pcall(function()
			if FarmTimerRunning then
				FarmTimeSeconds = FarmTimeSeconds + 1
				SetLabel(TimeLabel, "Time Elapsed - " .. FormatTime(FarmTimeSeconds))
			end

			CurrentMoney = GetMoney()
			SetLabel(CurrentMoneyLabel, "Current Money - $" .. tostring(CurrentMoney))

			if BoxFarmEnabled or MopFarmEnabled then
				EarnedMoney = (CurrentMoney + TotalDeposited) - StartMoney
				SetLabel(EarnedMoneyLabel, "Earned Money - $" .. tostring(EarnedMoney))
				CheckAutoBank()
			end
		end)
		task.wait(1)
	end
end)

task.spawn(function()
	while true do
		pcall(function()
			if BoxFarmEnabled then
				if not IsAlive() then
					UpdateStatus("Dead - Waiting for Respawn")
					local charAdded = LocalPlayer.CharacterAdded
					charAdded.Wait(charAdded)
					task.wait(1)
					UpdateStatus("Respawned - Restarting")
				else
					UpdateStatus("Moving to Take")
					local takePrompt = FindTakePrompt()
					for _ = 1, 10 do
						if takePrompt or not BoxFarmEnabled then
							break
						end
						UpdateStatus("Searching Take prompt")
						task.wait(0.5)
						takePrompt = FindTakePrompt()
					end
					UpdateStatus("Moving to Take")
					MoveToBox(GetPromptPosition(takePrompt) or takePos, BoxFarmMethod, function() return BoxFarmEnabled and IsAlive() end)

					if BoxFarmEnabled and IsAlive() then
						takePrompt = takePrompt or FindTakePrompt()

						if takePrompt then
							UpdateStatus("Taking Box")
							task.wait(0.2)
							HoldPrompt(takePrompt)
							task.wait(0.5)
						end
					end

					if BoxFarmEnabled and IsAlive() then
						for _, waypointPos in ipairs(boxWaypoints) do
							if not BoxFarmEnabled or not IsAlive() then break end
							UpdateStatus("Moving to Waypoint")
							MoveToBox(waypointPos, BoxFarmMethod, function() return BoxFarmEnabled and IsAlive() end)
						end
					end

					if BoxFarmEnabled and IsAlive() then
						UpdateStatus("Moving to Deliver")
						local deliverInteract = FindDeliverPrompt()
						MoveToBox(GetPromptPosition(deliverInteract) or deliverPos, BoxFarmMethod, function() return BoxFarmEnabled and IsAlive() end)

						if BoxFarmEnabled and IsAlive() then
							deliverInteract = deliverInteract or FindDeliverPrompt()

							if deliverInteract then
								UpdateStatus("Delivering Box")
								task.wait(0.2)
								HoldPrompt(deliverInteract)
								task.wait(0.5)
							end
						end
					end
				end
			end
		end)
		task.wait(1)
	end
end)

task.spawn(function()
	while true do
		pcall(function()
			if MopFarmEnabled then
				if not IsAlive() then
					UpdateStatus("Dead - Waiting for Respawn")
					local charAdded = LocalPlayer.CharacterAdded
					charAdded.Wait(charAdded)
					task.wait(1)
					UpdateStatus("Respawned - Restarting")
				else
					local map = workspace.FindFirstChild(workspace, "Map")
					local jobs = map and map.FindFirstChild(map, "Jobs")
					local cleanNPC = jobs and jobs.FindFirstChild(jobs, "CleanNPC")
					local cleanFolder = cleanNPC and cleanNPC.FindFirstChild(cleanNPC, "Clean")

					if cleanFolder then
						for _, item in ipairs(cleanFolder.GetChildren(cleanFolder)) do
							if not MopFarmEnabled or not IsAlive() then break end

							local prompt = item.FindFirstChildOfClass(item, "ProximityPrompt")
								or item.FindFirstChild(item, "ProximityPrompt")

							if item.IsA(item, "BasePart") or item.IsA(item, "Model") then
								local targetPos = item.IsA(item, "BasePart")
									and item.Position
									or item.GetPivot(item).Position

								UpdateStatus("Cleaning spot")
								MoveTo(targetPos, MopFarmMethod, function() return MopFarmEnabled and IsAlive() end)

								if MopFarmEnabled and IsAlive() and prompt then
									UpdateStatus("Interacting")
									task.wait(0.2)
									HoldPrompt(prompt)
									task.wait(0.5)
								end
							end
						end
					end
				end
			end
		end)
		task.wait(1)
	end
end)

local GunModsState = {
	NoRecoil = false,
	NoSpread = false,
	RapidFire = false,
}

local RapidFireMultiplier = 3

local GunSettingsFields = {
	NoRecoil = { "Recoil" },
	NoSpread = { "SprayAngle", "SpreadFactor" },
	RapidFire = { "FireRate" },
}

local GunSettingsOriginals = setmetatable({}, { __mode = "k" })

local function GetGunTools()
	local tools = {}
	local containers = { LocalPlayer.Character, LocalPlayer:FindFirstChildOfClass("Backpack") }
	for i = 1, 2 do
		local container = containers[i]
		if container then
			for _, child in ipairs(container:GetChildren()) do
				if child:IsA("Tool") then
					table.insert(tools, child)
				end
			end
		end
	end
	return tools
end

local function GetToolSettings(tool)
	local module = tool:FindFirstChild("Settings")
	if not module or not module:IsA("ModuleScript") then return nil end
	local ok, result = pcall(require, module)
	if ok and type(result) == "table" then
		return result
	end
	return nil
end

local function WriteSetting(settings, field, value)
	pcall(function()
		if isreadonly and isreadonly(settings) then
			setreadonly(settings, false)
		end
		rawset(settings, field, value)
	end)
end

local function ApplySettingsGroup(settings, groupName, enabled)
	local store = GunSettingsOriginals[settings]
	if not store then
		store = {}
		GunSettingsOriginals[settings] = store
	end

	for _, field in ipairs(GunSettingsFields[groupName]) do
		local current = rawget(settings, field)
		if type(current) == "number" then
			if enabled then
				if store[field] == nil then
					store[field] = current
				end
				local target = 0
				if groupName == "RapidFire" then
					target = store[field] * RapidFireMultiplier
				end
				if current ~= target then
					WriteSetting(settings, field, target)
				end
			elseif store[field] ~= nil then
				WriteSetting(settings, field, store[field])
				store[field] = nil
			end
		end
	end
end

local function ApplyGunSettings(groupName, enabled)
	for _, tool in ipairs(GetGunTools()) do
		local settings = GetToolSettings(tool)
		if settings then
			ApplySettingsGroup(settings, groupName, enabled)
		end
	end
end

local function ApplyGunGroup(groupName, enabled)
	ApplyGunSettings(groupName, enabled)
end

local function SetGunMod(groupName, state)
	GunModsState[groupName] = state
	task.spawn(function()
		pcall(ApplyGunGroup, groupName, state)
	end)
end

S.GunMods = T.GunModsSub:Section({
	Name = "Gun Mods",
	Side = 1
})

S.GunMods:Toggle({
	Name = "No Recoil",
	Default = false,
	Flag = "GunModNoRecoil",
	Callback = function(state)
		SetGunMod("NoRecoil", state)
	end,
})

S.GunMods:Toggle({
	Name = "No Spread",
	Default = false,
	Flag = "GunModNoSpread",
	Callback = function(state)
		SetGunMod("NoSpread", state)
	end,
})

S.GunMods:Toggle({
	Name = "Rapid Fire",
	Default = false,
	Flag = "GunModRapidFire",
	Callback = function(state)
		SetGunMod("RapidFire", state)
	end,
})

S.RapidFire = T.GunModsSub:Section({
	Name = "Rapid Fire",
	Side = 2
})
S.RapidFire:Slider({
	Name = "Rapid Fire Multiplier",
	Min = 1,
	Max = 10,
	Suffix = "x",
	Default = 3,
	Flag = "GunModRapidFireMultiplier",
	Callback = function(v)
		RapidFireMultiplier = v
		if GunModsState.RapidFire then
			for _, tool in ipairs(GetGunTools()) do
				local settings = GetToolSettings(tool)
				local store = settings and GunSettingsOriginals[settings]
				if store and store.FireRate ~= nil then
					WriteSetting(settings, "FireRate", store.FireRate * v)
				end
			end
		end
	end,
})

task.spawn(function()
	while true do
		local active = false
		pcall(function()
			for groupName, enabled in pairs(GunModsState) do
				if enabled then
					active = true
					ApplyGunGroup(groupName, true)
				end
			end
		end)
		task.wait(active and 0.5 or 1)
	end
end)

local PlayerState = {
	SpeedBoost = false,
	InfStamina = false,
	Speed = 10,
}

S.Movement = T.PlayerSub:Section({
	Name = "Movement",
	Side = 1
})

S.Movement:Toggle({
	Name = "SpeedBoost",
	Default = false,
	Flag = "PlayerSpeedBoost",
	Callback = function(state)
		PlayerState.SpeedBoost = state
	end,
})

S.Movement:Slider({
	Name = "Boost Speed",
	Min = 10,
	Max = 15,
	Suffix = " studs/s",
	Default = 10,
	Flag = "PlayerBoostSpeed",
	Callback = function(v)
		PlayerState.Speed = v
	end,
})

S.Stamina = T.PlayerSub:Section({
	Name = "Stamina",
	Side = 2
})
S.Stamina:Toggle({
	Name = "InfStamina",
	Default = false,
	Flag = "PlayerInfStamina",
	Callback = function(state)
		PlayerState.InfStamina = state
	end,
})

RunService.Heartbeat:Connect(function(dt)
	local character = LocalPlayer.Character
	if not character then return end

	if PlayerState.InfStamina and type(character:GetAttribute("Stamina")) == "number" then
		if character:GetAttribute("Stamina") < 100 then
			character:SetAttribute("Stamina", 100)
		end
	end

	if PlayerState.SpeedBoost then
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		local root = character:FindFirstChild("HumanoidRootPart")
		if humanoid and root and humanoid.Health > 0 and humanoid.MoveDirection.Magnitude > 0 then
			root.CFrame = root.CFrame + humanoid.MoveDirection * PlayerState.Speed * dt
		end
	end
end)

T.SettingsSub:ThemeConfig({ })

Window:Watermark({
	Name = "STREETLIFE"
})

Zolar:Notification({
	Name = "STREETLIFE loaded",
	Description = "Press G to toggle the menu.",
	Icon = "check",
	Duration = 6
})
