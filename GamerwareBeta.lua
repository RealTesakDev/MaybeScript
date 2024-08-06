-- Initialize Flags
if not _G.Flags then
	_G.Flags = {
		ESP = {
			NotVisibleColor = Color3.fromRGB(255, 0, 0),
			VisibleColor = Color3.fromRGB(0, 255, 0),
			DistanceLimit = 1500,
			Box = true,
			Name = true,
			Weapon = true,
			Distance = true,
			VisibleCheck = true,
			Sleepers = false,
		},
		HitboxExpander = {
			Size = 7,
			Enabled = true,
			Transparency = 0.7,
			Part = "Head",
		},
	}
end

-- Load Script
if not _G.Loaded then
	_G.Loaded = true
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local RunService = game:GetService("RunService")
	local Players = game:GetService("Players")
	local CoreGui = game:GetService("CoreGui")
	local CurrentCamera = workspace.CurrentCamera
	local IgnoreFolder = workspace:WaitForChild("Ignore")
	local OriginalSizes = {}
	local WeaponInfo = {}
	local HasESP = {}

	-- Define Sleep Animation ID
	local SleepAnimationId = "rbxassetid://13280887764"

	-- Store Original Part Sizes
	for i, v in pairs(ReplicatedStorage.Shared.entities.Player.Model:GetChildren()) do
		if v:IsA("BasePart") then
			OriginalSizes[v.Name] = v.Size
		end
	end

	-- Set Real Names for Weapons
	for i, v in pairs(ReplicatedStorage.HandModels:GetChildren()) do
		v:SetAttribute("RealName", v.Name)
	end

	-- Check if Player is Sleeping
	local function IsSleeping(Player)
		local Animations = Player.AnimationController:GetPlayingAnimationTracks()
		for _, v in pairs(Animations) do
			if v.IsPlaying and v.Animation.AnimationId == SleepAnimationId then
				return true
			end
		end
		return false
	end

	-- Create ESP Elements
	local function CreateESP()
		local BillboardGui = Instance.new("BillboardGui")
		local Box = Instance.new("Frame")
		local PlayerName = Instance.new("TextLabel")
		local PlayerWeapon = Instance.new("TextLabel")
		local PlayerDistance = Instance.new("TextLabel")
		local UIStroke = Instance.new("UIStroke")

		-- Properties
		BillboardGui.Parent = CoreGui
		BillboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		BillboardGui.Active = true
		BillboardGui.AlwaysOnTop = true
		BillboardGui.LightInfluence = 1
		BillboardGui.Size = UDim2.new(500, 0, 800, 0)

		Box.Name = "Box"
		Box.Parent = BillboardGui
		Box.AnchorPoint = Vector2.new(0.5, 0.5)
		Box.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Box.BackgroundTransparency = 1
		Box.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Box.BorderSizePixel = 0
		Box.Position = UDim2.new(0.5, 0, 0.5, 0)
		Box.Size = UDim2.new(0.00899999961, 0, 0.00899999961, 0)

		UIStroke.Name = "UIStroke"
		UIStroke.Parent = Box
		UIStroke.Thickness = 1
		UIStroke.Color = _G.Flags.ESP.VisibleColor
		UIStroke.LineJoinMode = Enum.LineJoinMode.Miter

		PlayerName.Name = "PlayerName"
		PlayerName.Parent = BillboardGui
		PlayerName.AnchorPoint = Vector2.new(0.5, 1)
		PlayerName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		PlayerName.BackgroundTransparency = 1
		PlayerName.BorderColor3 = Color3.fromRGB(0, 0, 0)
		PlayerName.BorderSizePixel = 0
		PlayerName.Position = UDim2.new(0.5, 0, 0.495499998, 0)
		PlayerName.Size = UDim2.new(0, 100, 0, 10)
		PlayerName.Font = Enum.Font.SourceSans
		PlayerName.Text = "Player"
		PlayerName.TextColor3 = Color3.fromRGB(0, 255, 8)
		PlayerName.TextSize = 14
		PlayerName.TextYAlignment = Enum.TextYAlignment.Bottom

		PlayerWeapon.Name = "PlayerWeapon"
		PlayerWeapon.Parent = BillboardGui
		PlayerWeapon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		PlayerWeapon.BackgroundTransparency = 1
		PlayerWeapon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		PlayerWeapon.BorderSizePixel = 0
		PlayerWeapon.Position = UDim2.new(0.504499972, 0, 0.495499998, 0)
		PlayerWeapon.Size = UDim2.new(0, 100, 0, 10)
		PlayerWeapon.Font = Enum.Font.SourceSans
		PlayerWeapon.Text = "Weapon"
		PlayerWeapon.TextColor3 = Color3.fromRGB(0, 255, 8)
		PlayerWeapon.TextSize = 14
		PlayerWeapon.TextXAlignment = Enum.TextXAlignment.Left
		PlayerWeapon.TextYAlignment = Enum.TextYAlignment.Bottom
		PlayerWeapon.Visible = false

		PlayerDistance.Name = "PlayerDistance"
		PlayerDistance.Parent = BillboardGui
		PlayerDistance.AnchorPoint = Vector2.new(0.5, 0)
		PlayerDistance.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		PlayerDistance.BackgroundTransparency = 1
		PlayerDistance.BorderColor3 = Color3.fromRGB(0, 0, 0)
		PlayerDistance.BorderSizePixel = 0
		PlayerDistance.Position = UDim2.new(0.5, 0, 0.504999995, 5)
		PlayerDistance.Size = UDim2.new(0, 100, 0, 10)
		PlayerDistance.Font = Enum.Font.SourceSans
		PlayerDistance.Text = "500"
		PlayerDistance.TextColor3 = Color3.fromRGB(0, 255, 8)
		PlayerDistance.TextSize = 14
		PlayerDistance.TextYAlignment = Enum.TextYAlignment.Bottom

		return BillboardGui
	end

	-- Get Player Weapon
	local function GetPlayerWeapon(Player)
		local Model = Player:FindFirstChildOfClass("Model")
		return Model and Model:GetAttribute("RealName") or "None"
	end

	-- Check if Model is Player
	local function IsPlayer(Model)
		return Model.ClassName == "Model" and Model:FindFirstChild("Head") and Model.PrimaryPart ~= nil
	end

	-- Set ESP Color
	local function SetColor(Billboard, Color)
		Billboard.PlayerName.TextColor3 = Color
		Billboard.PlayerDistance.TextColor3 = Color
		Billboard.PlayerWeapon.TextColor3 = Color
		Billboard.Box.UIStroke.Color = Color
	end

	-- Hitbox Expander
	local function HitboxExpander(Model, Size, Hitbox)
		if Hitbox.Enabled then
			local Part = Model[Hitbox.Part]
			Part.Size = Vector3.new(Size, Size, Size)
			Part.Transparency = Hitbox.Transparency
			Part.CanCollide = false
		else
			local Part = Model[Hitbox.Part]
			Part.Size = OriginalSizes[Hitbox.Part]
			Part.Transparency = 0
			Part.CanCollide = true
		end
	end

	-- Create Draggable UI
	local function MakeDraggable(Frame)
		local Dragging, DragInput, DragStart, StartPos

		Frame.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				Dragging = true
				DragStart = input.Position
				StartPos = Frame.Position

				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						Dragging = false
					end
				end)
			end
		end)

		Frame.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				DragInput = input
			end
		end)

		game:GetService("UserInputService").InputChanged:Connect(function(input)
			if input == DragInput and Dragging then
				local Delta = input.Position - DragStart
				Frame.Position = UDim2.new(
					StartPos.X.Scale,
					StartPos.X.Offset + Delta.X,
					StartPos.Y.Scale,
					StartPos.Y.Offset + Delta.Y
				)
			end
		end)
	end

	-- Create UI
	local function CreateUI()
		local ScreenGui = Instance.new("ScreenGui")
		ScreenGui.Parent = CoreGui

		local Frame = Instance.new("Frame")
		Frame.Parent = ScreenGui
		Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		Frame.BackgroundTransparency = 0.5
		Frame.Size = UDim2.new(0, 300, 0, 200)
		Frame.Position = UDim2.new(0, 10, 0, 10)
		Frame.ClipsDescendants = true
		Frame.BorderSizePixel = 0
		MakeDraggable(Frame)

		local TabContainer = Instance.new("Frame")
		TabContainer.Parent = Frame
		TabContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		TabContainer.Size = UDim2.new(1, 0, 0, 30)
		TabContainer.BorderSizePixel = 0

		local ESPButton = Instance.new("TextButton")
		ESPButton.Parent = TabContainer
		ESPButton.Size = UDim2.new(0, 100, 1, 0)
		ESPButton.Text = "ESP"
		ESPButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		ESPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		ESPButton.TextSize = 18
		ESPButton.Position = UDim2.new(0, 0, 0, 0)

		local HitboxButton = Instance.new("TextButton")
		HitboxButton.Parent = TabContainer
		HitboxButton.Size = UDim2.new(0, 100, 1, 0)
		HitboxButton.Text = "Hitbox"
		HitboxButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		HitboxButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		HitboxButton.TextSize = 18
		HitboxButton.Position = UDim2.new(0, 100, 0, 0)

		local ESPFrame = Instance.new("Frame")
		ESPFrame.Parent = Frame
		ESPFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		ESPFrame.Size = UDim2.new(1, 0, 1, -30)
		ESPFrame.Position = UDim2.new(0, 0, 0, 30)
		ESPFrame.Visible = true

		local HitboxFrame = Instance.new("Frame")
		HitboxFrame.Parent = Frame
		HitboxFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		HitboxFrame.Size = UDim2.new(1, 0, 1, -30)
		HitboxFrame.Position = UDim2.new(0, 0, 0, 30)
		HitboxFrame.Visible = false

		ESPButton.MouseButton1Click:Connect(function()
			ESPFrame.Visible = true
			HitboxFrame.Visible = false
		end)

		HitboxButton.MouseButton1Click:Connect(function()
			ESPFrame.Visible = false
			HitboxFrame.Visible = true
		end)

		local ToggleESPButton = Instance.new("TextButton")
		ToggleESPButton.Parent = ESPFrame
		ToggleESPButton.Size = UDim2.new(1, 0, 0, 40)
		ToggleESPButton.Text = "Toggle ESP"
		ToggleESPButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		ToggleESPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		ToggleESPButton.TextSize = 18
		ToggleESPButton.Position = UDim2.new(0, 0, 0, 10)
		ToggleESPButton.MouseButton1Click:Connect(function()
			_G.Flags.ESP.VisibleCheck = not _G.Flags.ESP.VisibleCheck
			ToggleESPButton.Text = _G.Flags.ESP.VisibleCheck and "Disable ESP" or "Enable ESP"
		end)

		-- Additional UI elements like sliders for DistanceLimit, Hitbox size, etc., can be added similarly.
	end

	-- Connect Heartbeat to Update ESP
	RunService.Heartbeat:Connect(function()
		local ESP = _G.Flags.ESP
		local Hitbox = _G.Flags.HitboxExpander

		for _, v in pairs(workspace:GetChildren()) do
			if HasESP[v] or IsPlayer(v) then
				if HasESP[v] == nil then
					local Billboard = CreateESP()
					HasESP[v] = Billboard
					Billboard.Adornee = v.PrimaryPart
				elseif HasESP[v] ~= nil then
					local Billboard = HasESP[v]
					local PrimaryPosition = v.PrimaryPart.Position
					local Origin = CurrentCamera.CFrame.Position
					local Distance = (Origin - PrimaryPosition).Magnitude
					HitboxExpander(v, Hitbox.Size, Hitbox)

					if (Distance > ESP.DistanceLimit) or (not ESP.Sleepers and IsSleeping(v)) then
						Billboard.Enabled = false
						continue
					end

					Billboard.Enabled = true
					Billboard.Adornee = v.PrimaryPart

					Billboard.Box.Visible = ESP.Box
					Billboard.PlayerDistance.Visible = ESP.Distance
					Billboard.PlayerName.Visible = ESP.Name
					Billboard.PlayerWeapon.Visible = ESP.Weapon

					Billboard.PlayerDistance.Text = math.round(Distance) .. "s"
					Billboard.PlayerWeapon.Text = GetPlayerWeapon(v)

					local Params = RaycastParams.new()
					Params.FilterDescendantsInstances = { IgnoreFolder, v }
					local Direction = PrimaryPosition - Origin
					local Raycast = workspace:Raycast(Origin, Direction, Params)
					SetColor(Billboard, (not Raycast or not ESP.VisibleCheck) and ESP.VisibleColor or ESP.NotVisibleColor)
				end
			end
		end
	end)

	-- Create the UI
	CreateUI()
end
