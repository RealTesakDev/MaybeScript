-- Start Timer
local startTime = tick()

local HttpService = game:GetService("HttpService")

local response = game:HttpGet("https://secureauths.vercel.app/init-hwid?hwid=" .. gethwid())
local success, result = pcall(function() return HttpService:JSONDecode(response) end)

if success and result.success then
    print("HWID Valid.")
else
    print("HWID Invalid.")
    game.Players.LocalPlayer:Kick("HWID Invalid.")
end

--// Services //--
local Workspace = cloneref(game:GetService("Workspace"))
local RunService = cloneref(game:GetService("RunService"))
local Players = cloneref(game:GetService("Players"))
local CoreGui = game:GetService("CoreGui")
local Lighting = cloneref(game:GetService("Lighting"))
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))

--// Player and Camera //--
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

--// Weapons //--
local Weapons = ReplicatedStorage.Weapons

--// URL Repositories for Library and Addons //--
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

--// Library and Managers //--
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

--// Aimbot and Triggerbot Variables //--
local triggerBotEnabled = false



-- Configuration for gun modifications
local GunMods = {
    Enabled = true,
    Settings = {
        Ammo = {
            Enabled = false,
            Value = 9999999999
        },
        StoredAmmo = {
            Enabled = false,
            Value = 9999999999
        },
        EquipTime = {
            Enabled = false,
            Value = 0.05
        },
        ReloadTime = {
            Enabled = false,
            Value = 0.05
        },
        Range = {
            Enabled = false,
            Value = 999
        },
        Penetration = {
            Enabled = false,
            Value = 999
        },
        Spread = {
            Enabled = false,
            Value = 0
        },
        FireRate = {
            Enabled = false,
            Value = 0
        },
        Auto = {
            Enabled = false
        },
        GunChams = {
            Enabled = false,
            Color = Color3.fromRGB(200, 200, 200),
            Material = Enum.Material.ForceField
        },
        ArmsChams = {
            Enabled = false,
            Material = Enum.Material.ForceField,
            Transparency = 1
        }
    }
}


-- Silent Aim Features
local SilentAim = {
    Enabled = false,
    FOV = 150,
    ShowFOV = false,
    Wallbang = false,
    Snaplines = false,
    TargetPart = "Random", -- Can be "Random" or any valid part name
    ValidParts = {"Head", "HumanoidRootPart", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"},
    HitChance = 75,
    HitSound = {
        Enabled = false,
        AssetID = "4753603610"
    }
}

-- Define Tracers table with options
local Tracers = {
    Options = {
        Enabled = false,  -- Start with tracers disabled
        Distance = 1000,  -- Max range of tracers
    },
    Colors = {
        Material = Enum.Material.ForceField,  -- Default material
        Color = Color3.fromRGB(255, 0, 0),    -- Default color
    }
}




Library:Notify("Loading Esp", 2)

local ESP = {
    Enabled = true,
    TeamCheck = false,
    MaxDistance = 200,
    FontSize = 11,
    FadeOut = {
        OnDistance = false,
        OnDeath = false,
        OnLeave = false,
    },
    Options = { 
        Teamcheck = false, TeamcheckRGB = Color3.fromRGB(0, 255, 0),
        Friendcheck = true, FriendcheckRGB = Color3.fromRGB(0, 255, 0),
        Highlight = false, HighlightRGB = Color3.fromRGB(255, 0, 0),
    },
    Drawing = {
        Chams = {
            Enabled = false,
            -- Visual Effects
            Thermal = false,  -- Breathing effect
            Pulse = true,   -- Pulsing effect
            Rainbow = false, -- Rainbow color cycle
            Wireframe = false, -- Wireframe rendering mode
            
            -- Colors and Transparency
            FillRGB = Color3.fromRGB(119, 120, 255),
            Fill_Transparency = 100,
            OutlineRGB = Color3.fromRGB(119, 120, 255),
            Outline_Transparency = 100,
            
            -- Thermal Effect Settings
            ThermalSpeed = 2,      -- Speed of thermal breathing
            ThermalIntensity = 3,  -- Intensity of thermal effect
            
            -- Pulse Effect Settings
            PulseSpeed = 1,        -- Speed of pulsing
            PulseMinTransparency = 0.2,
            PulseMaxTransparency = 0.5,
            
            -- Rainbow Effect Settings
            RainbowSpeed = 0.3,      -- Speed of color cycling
            RainbowSaturation = 1, -- Color saturation (0-1)
            RainbowBrightness = 1, -- Color brightness (0-1)
            
            -- Visibility Settings
            VisibleCheck = true,   -- Check if target is visible
            VisibleOnly = false,   -- Only show chams when target is visible
            OccludedColor = Color3.fromRGB(255, 0, 0),  -- Color when behind walls
            NonOccludedColor = Color3.fromRGB(0, 255, 0), -- Color when visible
            
            -- Team Settings
            TeamColorVisible = true, -- Use team colors for visible players
            TeamColorOccluded = true, -- Use team colors for occluded players
            
            -- Distance Settings
            MaxDistance = 1000,    -- Maximum distance to render chams
            FadeStartDistance = 500, -- Distance at which fade starts
            
            -- Performance Settings
            UpdateRate = 1,        -- Update rate for effects (1 = every frame)
        },
        Names = {
            Enabled = false,
            RGB = Color3.fromRGB(255, 255, 255),
        },
        Flags = {
            Enabled = false,
        },
        Distances = {
            Enabled = false, 
            Position = "Text",
            RGB = Color3.fromRGB(255, 255, 255),
        },
        Weapons = {
            Enabled = false, WeaponTextRGB = Color3.fromRGB(119, 120, 255),
            Outlined = true,
            Gradient = false,
            GradientRGB1 = Color3.fromRGB(255, 255, 255), GradientRGB2 = Color3.fromRGB(119, 120, 255),
        },
        Healthbar = {
            Enabled = false,  
            HealthText = true, Lerp = false, HealthTextRGB = Color3.fromRGB(119, 120, 255),
            Width = 2.5,
            Gradient = true, GradientRGB1 = Color3.fromRGB(200, 0, 0), GradientRGB2 = Color3.fromRGB(60, 60, 125), GradientRGB3 = Color3.fromRGB(119, 120, 255), 
        },
        Boxes = {
            Animate = true,
            RotationSpeed = 300,
            Gradient = false, GradientRGB1 = Color3.fromRGB(119, 120, 255), GradientRGB2 = Color3.fromRGB(0, 0, 0), 
            GradientFill = true, GradientFillRGB1 = Color3.fromRGB(119, 120, 255), GradientFillRGB2 = Color3.fromRGB(0, 0, 0), 
            Filled = {
                Enabled = false,
                Transparency = 0.75,
                RGB = Color3.fromRGB(0, 0, 0),
            },
            Full = {
                Enabled = false,
                RGB = Color3.fromRGB(255, 255, 255),
            },
            Corner = {
                Enabled = false,
                RGB = Color3.fromRGB(255, 255, 255),
            },
        };
    };
    Connections = {
        RunService = RunService;
    };
    Fonts = {};
}

local ChamsEffects = {}

-- Convert HSV to RGB for rainbow effect
ChamsEffects.HSVtoRGB = function(h, s, v)
    local r, g, b
    local i = math.floor(h * 6)
    local f = h * 6 - i
    local p = v * (1 - s)
    local q = v * (1 - f * s)
    local t = v * (1 - (1 - f) * s)

    i = i % 6

    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    elseif i == 5 then r, g, b = v, p, q
    end

    return Color3.new(r, g, b)
end

-- Calculate thermal effect
ChamsEffects.GetThermalEffect = function(settings, currentTime)
    local breathe_effect = math.atan(math.sin(currentTime * settings.ThermalSpeed)) * 2 / math.pi
    return breathe_effect * settings.ThermalIntensity
end

-- Calculate pulse effect
ChamsEffects.GetPulseEffect = function(settings, currentTime)
    local min, max = settings.PulseMinTransparency, settings.PulseMaxTransparency
    return min + (max - min) * (math.sin(currentTime * settings.PulseSpeed) + 1) / 2
end

-- Calculate rainbow color
ChamsEffects.GetRainbowColor = function(settings, currentTime)
    local hue = (currentTime * settings.RainbowSpeed) % 1
    -- Now, ChamsEffects is fully defined, and this call will work
    return ChamsEffects.HSVtoRGB(hue, settings.RainbowSaturation, settings.RainbowBrightness)
end

-- Test call
local ChamColor = ChamsEffects.HSVtoRGB(0.5, 1, 1)
print(ChamColor)  -- This should print the RGB color correctly

-- Def & Vars
local Euphoria = ESP.Connections;
local lplayer = Players.LocalPlayer;
local Cam = Workspace.CurrentCamera;
local RotationAngle, Tick = -45, tick();

-- Weapon Images
local Weapon_Icons = {
    ["Wooden Bow"] = "http://www.roblox.com/asset/?id=17677465400",
    ["Crossbow"] = "http://www.roblox.com/asset/?id=17677473017",
    ["Salvaged SMG"] = "http://www.roblox.com/asset/?id=17677463033",
    ["Salvaged AK47"] = "http://www.roblox.com/asset/?id=17677455113",
    ["Salvaged AK74u"] = "http://www.roblox.com/asset/?id=17677442346",
    ["Salvaged M14"] = "http://www.roblox.com/asset/?id=17677444642",
    ["Salvaged Python"] = "http://www.roblox.com/asset/?id=17677451737",
    ["Military PKM"] = "http://www.roblox.com/asset/?id=17677449448",
    ["Military M4A1"] = "http://www.roblox.com/asset/?id=17677479536",
    ["Bruno's M4A1"] = "http://www.roblox.com/asset/?id=17677471185",
    ["Military Barrett"] = "http://www.roblox.com/asset/?id=17677482998",
    ["Salvaged Skorpion"] = "http://www.roblox.com/asset/?id=17677459658",
    ["Salvaged Pump Action"] = "http://www.roblox.com/asset/?id=17677457186",
    ["Military AA12"] = "http://www.roblox.com/asset/?id=17677475227",
    ["Salvaged Break Action"] = "http://www.roblox.com/asset/?id=17677468751",
    ["Salvaged Pipe Rifle"] = "http://www.roblox.com/asset/?id=17677468751",
    ["Salvaged P250"] = "http://www.roblox.com/asset/?id=17677447257",
    ["Nail Gun"] = "http://www.roblox.com/asset/?id=17677484756",
    ["M249"] = "http://www.roblox.com/asset/?id=1760461955",  -- Replaced
    ["AWP"] = "http://www.roblox.com/asset/?id=1760466582",  -- Replaced
    ["CTKnife"] = "http://www.roblox.com/asset/?id=537583937",  -- Replaced
    ["DualBerettas"] = "http://www.roblox.com/asset/?id=1760451496",  -- Replaced
    ["R8"] = "http://www.roblox.com/asset/?id=1760453855",  -- Replaced
    ["FiveSeven"] = "http://www.roblox.com/asset/?id=1760452565",  -- Replaced
    ["DesertEagle"] = "http://www.roblox.com/asset/?id=1760453517",  -- Replaced
    ["Famas"] = "http://www.roblox.com/asset/?id=929141778",  -- Replaced
    ["Bizon"] = "http://www.roblox.com/asset/?id=929142284",  -- Replaced
    ["USP"] = "http://www.roblox.com/asset/?id=516703037",  -- Replaced
    ["MP7"] = "http://www.roblox.com/asset/?id=1760465938",  -- Replaced
    ["UMP"] = "http://www.roblox.com/asset/?id=1760462699",  -- Replaced
    ["MP7-SD"] = "http://www.roblox.com/asset/?id=1760464318",  -- Replaced
    ["Negev"] = "http://www.roblox.com/asset/?id=1760462131",  -- Replaced
    ["Nova"] = "http://www.roblox.com/asset/?id=1760461314",  -- Replaced
    ["M4A1"] = "http://www.roblox.com/asset/?id=1760463598",  -- Replaced
    ["CZ"] = "http://www.roblox.com/asset/?id=929140982",  -- Replaced
    ["CTGlove"] = "http://www.roblox.com/asset/?id=2135888079",  -- Replaced
    ["Scout"] = "http://www.roblox.com/asset/?id=929142913",  -- Replaced
    ["MP9"] = "http://www.roblox.com/asset/?id=1760466841",  -- Replaced
    ["P90"] = "http://www.roblox.com/asset/?id=929105150",  -- Replaced
    ["P2000"] = "http://www.roblox.com/asset/?id=929141651",  -- Replaced
    ["M4A4"] = "http://www.roblox.com/asset/?id=1760463859",  -- Replaced
    ["P250"] = "http://www.roblox.com/asset/?id=929141651",  -- Replaced
    ["AUG"] = "http://www.roblox.com/asset/?id=929141651",  -- Replaced
    ["MAG7"] = "http://www.roblox.com/asset/?id=1760461555",  -- Replaced
    ["XM"] = "http://www.roblox.com/asset/?id=929142464",  -- Replaced
    ["G3SG1"] = "http://www.roblox.com/asset/?id=929147844"  -- Replaced
};



-- Functions
local Functions = {}
do
    function Functions:Create(Class, Properties)
        local _Instance = typeof(Class) == 'string' and Instance.new(Class) or Class
        for Property, Value in pairs(Properties) do
            _Instance[Property] = Value
        end
        return _Instance;
    end
    --
    function Functions:FadeOutOnDist(element, distance)
        local transparency = math.max(0.1, 1 - (distance / ESP.MaxDistance))
        if element:IsA("TextLabel") then
            element.TextTransparency = 1 - transparency
        elseif element:IsA("ImageLabel") then
            element.ImageTransparency = 1 - transparency
        elseif element:IsA("UIStroke") then
            element.Transparency = 1 - transparency
        elseif element:IsA("Frame") and (element == Healthbar or element == BehindHealthbar) then
            element.BackgroundTransparency = 1 - transparency
        elseif element:IsA("Frame") then
            element.BackgroundTransparency = 1 - transparency
        elseif element:IsA("Highlight") then
            element.FillTransparency = 1 - transparency
            element.OutlineTransparency = 1 - transparency
        end;
    end;  
end;

do -- Initalize
    local ScreenGui = Functions:Create("ScreenGui", {
        Parent = CoreGui,
        Name = "ESPHolder",
    });

    local DupeCheck = function(plr)
        if ScreenGui:FindFirstChild(plr.Name) then
            ScreenGui[plr.Name]:Destroy()
        end
    end

    local ESP = function(plr)
        coroutine.wrap(DupeCheck)(plr) -- Dupecheck
        local Name = Functions:Create("TextLabel", {Parent = ScreenGui, Position = UDim2.new(0.5, 0, 0, -11), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0), RichText = true})
        local Distance = Functions:Create("TextLabel", {Parent = ScreenGui, Position = UDim2.new(0.5, 0, 0, 11), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0), RichText = true})
        local Weapon = Functions:Create("TextLabel", {Parent = ScreenGui, Position = UDim2.new(0.5, 0, 0, 31), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0), RichText = true})
        local Box = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 0.75, BorderSizePixel = 0})
        local Gradient1 = Functions:Create("UIGradient", {Parent = Box, Enabled = ESP.Drawing.Boxes.GradientFill, Color = ColorSequence.new{ColorSequenceKeypoint.new(0, ESP.Drawing.Boxes.GradientFillRGB1), ColorSequenceKeypoint.new(1, ESP.Drawing.Boxes.GradientFillRGB2)}})
        local Outline = Functions:Create("UIStroke", {Parent = Box, Enabled = ESP.Drawing.Boxes.Gradient, Transparency = 0, Color = Color3.fromRGB(255, 255, 255), LineJoinMode = Enum.LineJoinMode.Miter})
        local Gradient2 = Functions:Create("UIGradient", {Parent = Outline, Enabled = ESP.Drawing.Boxes.Gradient, Color = ColorSequence.new{ColorSequenceKeypoint.new(0, ESP.Drawing.Boxes.GradientRGB1), ColorSequenceKeypoint.new(1, ESP.Drawing.Boxes.GradientRGB2)}})
        local Healthbar = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0})
        local BehindHealthbar = Functions:Create("Frame", {Parent = ScreenGui, ZIndex = -1, BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 0})
        local HealthbarGradient = Functions:Create("UIGradient", {Parent = Healthbar, Enabled = ESP.Drawing.Healthbar.Gradient, Rotation = -90, Color = ColorSequence.new{ColorSequenceKeypoint.new(0, ESP.Drawing.Healthbar.GradientRGB1), ColorSequenceKeypoint.new(0.5, ESP.Drawing.Healthbar.GradientRGB2), ColorSequenceKeypoint.new(1, ESP.Drawing.Healthbar.GradientRGB3)}})
        local HealthText = Functions:Create("TextLabel", {Parent = ScreenGui, Position = UDim2.new(0.5, 0, 0, 31), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0)})
        local Chams = Functions:Create("Highlight", {Parent = ScreenGui, FillTransparency = 1, OutlineTransparency = 0, OutlineColor = Color3.fromRGB(119, 120, 255), DepthMode = "AlwaysOnTop"})
        local WeaponIcon = Functions:Create("ImageLabel", {Parent = ScreenGui, BackgroundTransparency = 1, BorderColor3 = Color3.fromRGB(0, 0, 0), BorderSizePixel = 0, Size = UDim2.new(0, 40, 0, 40)})
        local Gradient3 = Functions:Create("UIGradient", {Parent = WeaponIcon, Rotation = -90, Enabled = ESP.Drawing.Weapons.Gradient, Color = ColorSequence.new{ColorSequenceKeypoint.new(0, ESP.Drawing.Weapons.GradientRGB1), ColorSequenceKeypoint.new(1, ESP.Drawing.Weapons.GradientRGB2)}})
        local LeftTop = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
        local LeftSide = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
        local RightTop = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
        local RightSide = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
        local BottomSide = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
        local BottomDown = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
        local BottomRightSide = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
        local BottomRightDown = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
        local Flag1 = Functions:Create("TextLabel", {Parent = ScreenGui, Position = UDim2.new(1, 0, 0, 0), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0)})
        local Flag2 = Functions:Create("TextLabel", {Parent = ScreenGui, Position = UDim2.new(1, 0, 0, 0), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0)})
        --local DroppedItems = Functions:Create("TextLabel", {Parent = ScreenGui, AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0)})
        --
        local Updater = function()
            local Connection;
            local function HideESP()
                Box.Visible = false;
                Name.Visible = false;
                Distance.Visible = false;
                Weapon.Visible = false;
                Healthbar.Visible = false;
                BehindHealthbar.Visible = false;
                HealthText.Visible = false;
                WeaponIcon.Visible = false;
                LeftTop.Visible = false;
                LeftSide.Visible = false;
                BottomSide.Visible = false;
                BottomDown.Visible = false;
                RightTop.Visible = false;
                RightSide.Visible = false;
                BottomRightSide.Visible = false;
                BottomRightDown.Visible = false;
                Flag1.Visible = false;
                Chams.Enabled = false;
                Flag2.Visible = false;
                if not plr then
                    ScreenGui:Destroy();
                    Connection:Disconnect();
                end
            end
            --
            Connection = Euphoria.RunService.RenderStepped:Connect(function()
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local HRP = plr.Character.HumanoidRootPart
                    local Humanoid = plr.Character:WaitForChild("Humanoid");
                    local Pos, OnScreen = Cam:WorldToScreenPoint(HRP.Position)
                    local Dist = (Cam.CFrame.Position - HRP.Position).Magnitude / 3.5714285714
                    
                    if OnScreen and Dist <= ESP.MaxDistance then
                        local Size = HRP.Size.Y
                        local scaleFactor = (Size * Cam.ViewportSize.Y) / (Pos.Z * 2)
                        local w, h = 3 * scaleFactor, 4.5 * scaleFactor

                        -- Fade-out effect --
                        if ESP.FadeOut.OnDistance then
                            Functions:FadeOutOnDist(Box, Dist)
                            Functions:FadeOutOnDist(Outline, Dist)
                            Functions:FadeOutOnDist(Name, Dist)
                            Functions:FadeOutOnDist(Distance, Dist)
                            Functions:FadeOutOnDist(Weapon, Dist)
                            Functions:FadeOutOnDist(Healthbar, Dist)
                            Functions:FadeOutOnDist(BehindHealthbar, Dist)
                            Functions:FadeOutOnDist(HealthText, Dist)
                            Functions:FadeOutOnDist(WeaponIcon, Dist)
                            Functions:FadeOutOnDist(LeftTop, Dist)
                            Functions:FadeOutOnDist(LeftSide, Dist)
                            Functions:FadeOutOnDist(BottomSide, Dist)
                            Functions:FadeOutOnDist(BottomDown, Dist)
                            Functions:FadeOutOnDist(RightTop, Dist)
                            Functions:FadeOutOnDist(RightSide, Dist)
                            Functions:FadeOutOnDist(BottomRightSide, Dist)
                            Functions:FadeOutOnDist(BottomRightDown, Dist)
                            Functions:FadeOutOnDist(Chams, Dist)
                            Functions:FadeOutOnDist(Flag1, Dist)
                            Functions:FadeOutOnDist(Flag2, Dist)
                        end

                        -- Teamcheck
                        if ESP.TeamCheck and plr ~= lplayer and ((lplayer.Team ~= plr.Team and plr.Team) or (not lplayer.Team and not plr.Team)) and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") then

                                                            do -- Chams
                                    if ESP.Drawing.Chams.Enabled then
                                        local settings = ESP.Drawing.Chams
                                        local currentTime = tick()
                                        
                                        -- Base setup
                                        Chams.Adornee = plr.Character
                                        Chams.Enabled = true
                                        
                                        -- Distance calculations
                                        local distance = (Cam.CFrame.Position - HRP.Position).Magnitude
                                        local distanceFade = math.clamp((settings.MaxDistance - distance) / (settings.MaxDistance - settings.FadeStartDistance), 0, 1)
                                        
                                        -- Visibility check
                                        local isVisible = true
                                        if settings.VisibleCheck then
                                            local ray = Ray.new(Cam.CFrame.Position, (HRP.Position - Cam.CFrame.Position).Unit * 500)
                                            local hit = workspace:FindPartOnRayWithIgnoreList(ray, {Cam, lplayer.Character})
                                            isVisible = hit and hit:IsDescendantOf(plr.Character) or false
                                        end
                                        
                                        -- Color determination
                                        local baseColor = settings.FillRGB
                                        if settings.Rainbow then
                                            baseColor = ChamsEffects.GetRainbowColor(settings, currentTime)
                                        elseif settings.VisibleCheck and settings.TeamColorVisible then
                                            baseColor = isVisible and settings.NonOccludedColor or settings.OccludedColor
                                        end
                                        
                                        -- Apply effects
                                        local finalTransparency = settings.Fill_Transparency * 0.01
                                        if settings.Thermal then
                                            finalTransparency = finalTransparency * ChamsEffects.GetThermalEffect(settings, currentTime)
                                        end
                                        if settings.Pulse then
                                            finalTransparency = finalTransparency * ChamsEffects.GetPulseEffect(settings, currentTime)
                                        end
                                        
                                        -- Apply distance fade
                                        finalTransparency = finalTransparency * distanceFade
                                        
                                        -- Update highlight properties
                                        Chams.FillColor = baseColor
                                        Chams.OutlineColor = settings.OutlineRGB
                                        Chams.FillTransparency = finalTransparency
                                        Chams.OutlineTransparency = settings.Outline_Transparency * 0.01 * distanceFade
                                        
                                        -- Update visibility mode
                                        if settings.VisibleCheck then
                                            Chams.DepthMode = settings.VisibleOnly and "Occluded" or "AlwaysOnTop"
                                        else
                                            Chams.DepthMode = "AlwaysOnTop"
                                        end
                                    else
                                        Chams.Enabled = false
                                    end
                                end

                            do -- Corner Boxes
                                LeftTop.Visible = ESP.Drawing.Boxes.Corner.Enabled
                                LeftTop.Position = UDim2.new(0, Pos.X - w / 2, 0, Pos.Y - h / 2)
                                LeftTop.Size = UDim2.new(0, w / 5, 0, 1)
                                
                                LeftSide.Visible = ESP.Drawing.Boxes.Corner.Enabled
                                LeftSide.Position = UDim2.new(0, Pos.X - w / 2, 0, Pos.Y - h / 2)
                                LeftSide.Size = UDim2.new(0, 1, 0, h / 5)
                                
                                BottomSide.Visible = ESP.Drawing.Boxes.Corner.Enabled
                                BottomSide.Position = UDim2.new(0, Pos.X - w / 2, 0, Pos.Y + h / 2)
                                BottomSide.Size = UDim2.new(0, 1, 0, h / 5)
                                BottomSide.AnchorPoint = Vector2.new(0, 5)
                                
                                BottomDown.Visible = ESP.Drawing.Boxes.Corner.Enabled
                                BottomDown.Position = UDim2.new(0, Pos.X - w / 2, 0, Pos.Y + h / 2)
                                BottomDown.Size = UDim2.new(0, w / 5, 0, 1)
                                BottomDown.AnchorPoint = Vector2.new(0, 1)
                                
                                RightTop.Visible = ESP.Drawing.Boxes.Corner.Enabled
                                RightTop.Position = UDim2.new(0, Pos.X + w / 2, 0, Pos.Y - h / 2)
                                RightTop.Size = UDim2.new(0, w / 5, 0, 1)
                                RightTop.AnchorPoint = Vector2.new(1, 0)
                                
                                RightSide.Visible = ESP.Drawing.Boxes.Corner.Enabled
                                RightSide.Position = UDim2.new(0, Pos.X + w / 2 - 1, 0, Pos.Y - h / 2)
                                RightSide.Size = UDim2.new(0, 1, 0, h / 5)
                                RightSide.AnchorPoint = Vector2.new(0, 0)
                                
                                BottomRightSide.Visible = ESP.Drawing.Boxes.Corner.Enabled
                                BottomRightSide.Position = UDim2.new(0, Pos.X + w / 2, 0, Pos.Y + h / 2)
                                BottomRightSide.Size = UDim2.new(0, 1, 0, h / 5)
                                BottomRightSide.AnchorPoint = Vector2.new(1, 1)
                                
                                BottomRightDown.Visible = ESP.Drawing.Boxes.Corner.Enabled
                                BottomRightDown.Position = UDim2.new(0, Pos.X + w / 2, 0, Pos.Y + h / 2)
                                BottomRightDown.Size = UDim2.new(0, w / 5, 0, 1)
                                BottomRightDown.AnchorPoint = Vector2.new(1, 1)                                                            
                            end

                            do -- Boxes
                                Box.Position = UDim2.new(0, Pos.X - w / 2, 0, Pos.Y - h / 2)
                                Box.Size = UDim2.new(0, w, 0, h)
                                Box.Visible = ESP.Drawing.Boxes.Full.Enabled;

                                -- Gradient
                                if ESP.Drawing.Boxes.Filled.Enabled then
                                    Box.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                                    if ESP.Drawing.Boxes.GradientFill then
                                        Box.BackgroundTransparency = ESP.Drawing.Boxes.Filled.Transparency;
                                    else
                                        Box.BackgroundTransparency = 1
                                    end
                                    Box.BorderSizePixel = 1
                                else
                                    Box.BackgroundTransparency = 1
                                end
                                -- Animation
                                RotationAngle = RotationAngle + (tick() - Tick) * ESP.Drawing.Boxes.RotationSpeed * math.cos(math.pi / 4 * tick() - math.pi / 2)
                                if ESP.Drawing.Boxes.Animate then
                                    Gradient1.Rotation = RotationAngle
                                    Gradient2.Rotation = RotationAngle
                                else
                                    Gradient1.Rotation = -45
                                    Gradient2.Rotation = -45
                                end
                                Tick = tick()
                            end

                            -- Healthbar
                            do  
                                local health = Humanoid.Health / Humanoid.MaxHealth;
                                Healthbar.Visible = ESP.Drawing.Healthbar.Enabled;
                                Healthbar.Position = UDim2.new(0, Pos.X - w / 2 - 6, 0, Pos.Y - h / 2 + h * (1 - health))  
                                Healthbar.Size = UDim2.new(0, ESP.Drawing.Healthbar.Width, 0, h * health)  
                                --
                                BehindHealthbar.Visible = ESP.Drawing.Healthbar.Enabled;
                                BehindHealthbar.Position = UDim2.new(0, Pos.X - w / 2 - 6, 0, Pos.Y - h / 2)  
                                BehindHealthbar.Size = UDim2.new(0, ESP.Drawing.Healthbar.Width, 0, h)
                                -- Health Text
                                do
                                    if ESP.Drawing.Healthbar.HealthText then
                                        local healthPercentage = math.floor(Humanoid.Health / Humanoid.MaxHealth * 100)
                                        HealthText.Position = UDim2.new(0, Pos.X - w / 2 - 6, 0, Pos.Y - h / 2 + h * (1 - healthPercentage / 100) + 3)
                                        HealthText.Text = tostring(healthPercentage)
                                        HealthText.Visible = Humanoid.Health < Humanoid.MaxHealth
                                        if ESP.Drawing.Healthbar.Lerp then
                                            local color = health >= 0.75 and Color3.fromRGB(0, 255, 0) or health >= 0.5 and Color3.fromRGB(255, 255, 0) or health >= 0.25 and Color3.fromRGB(255, 170, 0) or Color3.fromRGB(255, 0, 0)
                                            HealthText.TextColor3 = color
                                        else
                                            HealthText.TextColor3 = ESP.Drawing.Healthbar.HealthTextRGB
                                        end
                                    end                        
                                end
                            end

                            do -- Names
                                Name.Visible = ESP.Drawing.Names.Enabled
                                if ESP.Options.Friendcheck and lplayer:IsFriendsWith(plr.UserId) then
                                    Name.Text = string.format('(<font color="rgb(%d, %d, %d)">F</font>) %s', ESP.Options.FriendcheckRGB.R * 255, ESP.Options.FriendcheckRGB.G * 255, ESP.Options.FriendcheckRGB.B * 255, plr.Name)
                                else
                                    Name.Text = string.format('(<font color="rgb(%d, %d, %d)">E</font>) %s', 255, 0, 0, plr.Name)
                                end
                                Name.Position = UDim2.new(0, Pos.X, 0, Pos.Y - h / 2 - 9)
                            end
                            
                            do -- Distance
                                if ESP.Drawing.Distances.Enabled then
                                    if ESP.Drawing.Distances.Position == "Bottom" then
                                        Weapon.Position = UDim2.new(0, Pos.X, 0, Pos.Y + h / 2 + 18)
                                        WeaponIcon.Position = UDim2.new(0, Pos.X - 21, 0, Pos.Y + h / 2 + 15);
                                        Distance.Position = UDim2.new(0, Pos.X, 0, Pos.Y + h / 2 + 7)
                                        Distance.Text = string.format("%d meters", math.floor(Dist))
                                        Distance.Visible = true
                                    elseif ESP.Drawing.Distances.Position == "Text" then
                                        Weapon.Position = UDim2.new(0, Pos.X, 0, Pos.Y + h / 2 + 8)
                                        WeaponIcon.Position = UDim2.new(0, Pos.X - 21, 0, Pos.Y + h / 2 + 5);
                                        Distance.Visible = false
                                        if ESP.Options.Friendcheck and lplayer:IsFriendsWith(plr.UserId) then
                                            Name.Text = string.format('(<font color="rgb(%d, %d, %d)">F</font>) %s [%d]', ESP.Options.FriendcheckRGB.R * 255, ESP.Options.FriendcheckRGB.G * 255, ESP.Options.FriendcheckRGB.B * 255, plr.Name, math.floor(Dist))
                                        else
                                            Name.Text = string.format('(<font color="rgb(%d, %d, %d)">E</font>) %s [%d]', 255, 0, 0, plr.Name, math.floor(Dist))
                                        end
                                        Name.Visible = ESP.Drawing.Names.Enabled
                                    end
                                end
                            end

                                                        do -- Weapons
                                if ESP.Drawing.Weapons.Enabled then
                                    -- Check workspace.PlayerName.EquippedTool
                                    local weaponFound = false
                                    
                                    -- Get the player's workspace folder
                                    local playerFolder = Workspace:FindFirstChild(plr.Name)
                                    if playerFolder then
                                        -- Check for EquippedTool value
                                        local equippedTool = playerFolder:FindFirstChild("EquippedTool")
                                        if equippedTool then
                                            local weaponName = equippedTool.Value
                                            Weapon.Text = weaponName
                                            
                                            -- Check if we have an icon for this weapon
                                            if Weapon_Icons[weaponName] then
                                                WeaponIcon.Image = Weapon_Icons[weaponName]
                                                WeaponIcon.Visible = true
                                            else
                                                WeaponIcon.Visible = false
                                            end
                                            weaponFound = true
                                        end
                                    end

                                    -- If no weapon is found
                                    if not weaponFound then
                                        Weapon.Text = "Unarmed"
                                        WeaponIcon.Visible = false
                                    end

                                    Weapon.Visible = true
                                    if ESP.Drawing.Weapons.Outlined then
                                        Weapon.TextStrokeTransparency = 0
                                    else
                                        Weapon.TextStrokeTransparency = 1
                                    end
                                else
                                    Weapon.Visible = false
                                    WeaponIcon.Visible = false
                                end
                            end                         
                        else
                            HideESP();
                        end
                    else
                        HideESP();
                    end
                else
                    HideESP();
                end
            end)
        end
        coroutine.wrap(Updater)();
    end
    do -- Update ESP
        for _, v in pairs(game:GetService("Players"):GetPlayers()) do
            if v.Name ~= lplayer.Name then
                coroutine.wrap(ESP)(v)
            end      
        end
        --
        game:GetService("Players").PlayerAdded:Connect(function(v)
            coroutine.wrap(ESP)(v)
        end);
    end;
end;


-- Library


Library:Notify("Loading UI", 2)


local Window = Library:CreateWindow({
    Title = 'CBsploit',
    Center = true,
    AutoShow = true,
})

local Tabs = {
    Combat = Window:AddTab('Combat'),
    Visuals = Window:AddTab('Visuals'),
    Movement = Window:AddTab('Movement'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

-- Combat Features
local SilentAimBox = Tabs.Combat:AddLeftGroupbox('Silent Aim')
local TriggerBox = Tabs.Combat:AddRightGroupbox('Triggerbot')
local GunModsBox = Tabs.Combat:AddRightGroupbox('Weapon Modifications')


-- Silent Aim Settings
SilentAimBox:AddToggle('SilentAimEnabled', {
    Text = 'Enable Silent Aim',
    Default = SilentAim.Enabled,
    Tooltip = 'Toggles silent aim assistance',

    Callback = function(Value)
        SilentAim.Enabled = Value
    end
})

SilentAimBox:AddToggle('ShowFOV', {
    Text = 'Show FOV Circle',
    Default = SilentAim.ShowFOV,
    Tooltip = 'Shows or hides the FOV circle',

    Callback = function(Value)
        SilentAim.ShowFOV = Value
    end
})

SilentAimBox:AddToggle('WallbangEnabled', {
    Text = 'Wallbang',
    Default = SilentAim.Wallbang,
    Tooltip = 'Enables shooting through walls',

    Callback = function(Value)
        SilentAim.Wallbang = Value
    end
})

SilentAimBox:AddToggle('SnaplinesEnabled', {
    Text = 'Show Snaplines',
    Default = SilentAim.Snaplines,
    Tooltip = 'Shows lines to target',

    Callback = function(Value)
        SilentAim.Snaplines = Value
    end
})

SilentAimBox:AddDivider()

SilentAimBox:AddSlider('SilentAimFOV', {
    Text = 'FOV',
    Default = SilentAim.FOV,
    Min = 0,
    Max = 360,
    Rounding = 1,

    Callback = function(Value)
        SilentAim.FOV = Value
    end
})

SilentAimBox:AddSlider('HitChance', {
    Text = 'Hit Chance',
    Default = SilentAim.HitChance,
    Min = 0,
    Max = 100,
    Rounding = 1,

    Callback = function(Value)
        SilentAim.HitChance = Value
    end
})

SilentAimBox:AddDropdown('TargetPart', {
    Values = {'Random', 'Head', 'HumanoidRootPart', 'Torso', 'Left Arm', 'Right Arm', 'Left Leg', 'Right Leg'},
    Default = 1,
    Text = 'Target Part',

    Callback = function(Value)
        SilentAim.TargetPart = Value
    end
})

SilentAimBox:AddToggle('HitSoundEnabled', {
    Text = 'Hit Sound',
    Default = SilentAim.HitSound.Enabled,
    Tooltip = 'Plays sound on hit',

    Callback = function(Value)
        SilentAim.HitSound.Enabled = Value
    end
})

SilentAimBox:AddInput('HitSoundID', {
    Default = SilentAim.HitSound.AssetID,
    Numeric = true,
    Finished = true,
    Text = 'Hit Sound ID',
    Tooltip = 'Roblox sound ID for hit marker',

    Callback = function(Value)
        SilentAim.HitSound.AssetID = Value
    end
})

-- Adding the Keybind to the UI
TriggerBox:AddLabel('Keybind'):AddKeyPicker('TriggerBotKeyPicker', {
    Default = 'X', -- Change as needed (MB1, MB2 for mouse buttons)
    SyncToggleState = false,
    Mode = 'Toggle', -- Modes: Always, Toggle, Hold
    Text = 'Trigger Bot',
    NoUI = false, -- Set to true if you want to hide from the Keybind menu

    -- Keybind toggled
    Callback = function(Value)
        triggerBotEnabled = Value
        print("Trigger Bot Enabled:", triggerBotEnabled)
    end,

    -- Keybind changed
    ChangedCallback = function(New)
        print("Keybind changed to:", New)
    end
})

-- Function to modify a single weapon property
local function ModifyWeaponProperty(weapon, propertyName, settings)
    if not settings.Enabled then return end
    
    local property = weapon:FindFirstChild(propertyName)
    if property then
        if propertyName == "Spread" then
            property.Value = settings.Value
            for _, spread in ipairs(property:GetChildren()) do
                spread.Value = settings.Value
            end
        elseif propertyName == "Auto" then
            property.Value = true
        else
            property.Value = settings.Value
        end
    end
end

-- Function to apply all modifications to weapons
local function ApplyGunMods()
    if not GunMods.Enabled then return end
    
    for _, weapon in ipairs(Weapons:GetChildren()) do
        for propertyName, settings in pairs(GunMods.Settings) do
            if propertyName ~= "GunChams" and propertyName ~= "ArmsChams" then
                ModifyWeaponProperty(weapon, propertyName, settings)
            end
        end
    end
end

-- Function to update a specific mod setting
local function UpdateModSetting(modName, enabled, value)
    if GunMods.Settings[modName] then
        GunMods.Settings[modName].Enabled = enabled
        if value ~= nil and modName ~= "Auto" then
            GunMods.Settings[modName].Value = value
        end
        ApplyGunMods()
    end
end

-- Function to update chams color
local function UpdateChamsColor(color)
    GunMods.Settings.GunChams.Color = color
end

-- Handle gun and arms chams
RunService.RenderStepped:Connect(function()
    local camera = workspace.Camera
    if not camera then return end

    -- Gun Chams
    if GunMods.Settings.GunChams.Enabled then
        for _, stuff in ipairs(camera:GetChildren()) do
            if stuff:IsA("Model") and stuff.Name == "Arms" then
                for _, item in ipairs(stuff:GetChildren()) do
                    if item:IsA("MeshPart") or item:IsA("BasePart") then
                        item.Color = GunMods.Settings.GunChams.Color
                        item.Material = GunMods.Settings.GunChams.Material
                    end
                end
            end
        end
    end

    -- Arms Chams
    if GunMods.Settings.ArmsChams.Enabled then
        for _, stuff in ipairs(camera:GetChildren()) do
            if stuff:IsA("Model") and stuff.Name == "Arms" then
                for _, item in ipairs(stuff:GetChildren()) do
                    if item:IsA("Model") and item.Name ~= "AnimSaves" then
                        for _, arm in ipairs(item:GetChildren()) do
                            if arm:IsA("BasePart") then
                                arm.Transparency = GunMods.Settings.ArmsChams.Transparency
                                for _, part in ipairs(arm:GetChildren()) do
                                    if part:IsA("BasePart") then
                                        part.Material = GunMods.Settings.ArmsChams.Material
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- Reset chams when disabled
local function ResetChams()
    local camera = workspace.Camera
    if not camera then return end

    for _, stuff in ipairs(camera:GetChildren()) do
        if stuff:IsA("Model") and stuff.Name == "Arms" then
            -- Reset gun parts
            for _, item in ipairs(stuff:GetChildren()) do
                if item:IsA("MeshPart") or item:IsA("BasePart") then
                    item.Color = Color3.fromRGB(200, 200, 200)
                    item.Material = Enum.Material.Plastic
                end
            end
            
            -- Reset arms
            for _, item in ipairs(stuff:GetChildren()) do
                if item:IsA("Model") and item.Name ~= "AnimSaves" then
                    for _, arm in ipairs(item:GetChildren()) do
                        if arm:IsA("BasePart") then
                            arm.Transparency = 0
                            for _, part in ipairs(arm:GetChildren()) do
                                if part:IsA("BasePart") then
                                    part.Material = Enum.Material.Plastic
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

-- Connect to weapon added event
Weapons.ChildAdded:Connect(function(weapon)
    if GunMods.Enabled then
        task.wait()
        for propertyName, settings in pairs(GunMods.Settings) do
            if propertyName ~= "GunChams" and propertyName ~= "ArmsChams" then
                ModifyWeaponProperty(weapon, propertyName, settings)
            end
        end
    end
end)

-- Initial application of mods
ApplyGunMods()

GunModsBox:AddToggle('InfiniteAmmo', {
    Text = 'Infinite Ammo',
    Default = false,
    Callback = function(Value)
        GunMods.Settings.Ammo.Enabled = Value
        GunMods.Settings.Ammo.Value = 9999
        GunMods.Settings.StoredAmmo.Enabled = Value
        GunMods.Settings.StoredAmmo.Value = 9999
        ApplyGunMods()
    end
})

GunModsBox:AddToggle('AutoFire', {
    Text = 'Automatic',
    Default = false,
    Callback = function(Value)
        GunMods.Settings.Auto.Enabled = Value
        ApplyGunMods()
    end
})

-- Spread Settings
GunModsBox:AddToggle('SpreadToggle', {
    Text = 'No Spread',
    Default = false,
    Callback = function(Value)
        GunMods.Settings.Spread.Enabled = Value
        ApplyGunMods()
    end
})

GunModsBox:AddSlider('SpreadValue', {
    Text = 'Spread Value',
    Default = 100,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Callback = function(Value)
            GunMods.Settings.Spread.Value = Value
            ApplyGunMods()
    end
})

-- Fire Rate Settings
GunModsBox:AddToggle('FireRateToggle', {
    Text = 'Fire Rate',
    Default = false,
    Callback = function(Value)
        GunMods.Settings.FireRate.Enabled = Value
        ApplyGunMods()
    end
})

GunModsBox:AddSlider('FireRateValue', {
    Text = 'Fire Rate',
    Default = 0.2,
    Min = 0,
    Max = 0.2,
    Rounding = 0,
    Callback = function(Value)
            GunMods.Settings.FireRate.Value = Value / 10
            ApplyGunMods()
    end
})

-- Range Settings
GunModsBox:AddToggle('RangeToggle', {
    Text = 'Max Range',
    Default = false,
    Callback = function(Value)
        GunMods.Settings.Range.Enabled = Value
        GunMods.Settings.Range.Value = 999
        ApplyGunMods()
    end
})



-- Penetration Settings
GunModsBox:AddToggle('PenetrationToggle', {
    Text = 'Max Penetration',
    Default = false,
    Callback = function(Value)
        GunMods.Settings.Penetration.Enabled = Value
        GunMods.Settings.Penetration.Enabled = 99999
        ApplyGunMods()
    end
})

-- Equipment Time Settings
GunModsBox:AddToggle('EquipTimeToggle', {
    Text = 'Instant Equip',
    Default = false,
    Callback = function(Value)
        GunMods.Settings.EquipTime.Enabled = Value
        GunMods.Settings.EquipTime.Value = 0
        ApplyGunMods()
    end
})

-- Reload Time Settings
GunModsBox:AddToggle('ReloadTimeToggle', {
    Text = 'Instant Reload',
    Default = false,
    Callback = function(Value)
        GunMods.Settings.ReloadTime.Enabled = Value
        GunMods.Settings.ReloadTime.Value = 0
        ApplyGunMods()
    end
})


-- Silent aim circle
local SilentFOVCircle = Drawing.new("Circle")
SilentFOVCircle.Thickness = 1
SilentFOVCircle.Color = Color3.new(1,1,1)

local SilentSnapline = Drawing.new("Line")
SilentSnapline.Thickness = 1
SilentSnapline.Color = Color3.new(1,1,1)

-- Hitmarker setup
local SilentHitmarker = Instance.new("Sound")
SilentHitmarker.Name = "SilentHitmarker"
SilentHitmarker.Parent = game:GetService("SoundService")
SilentHitmarker.Volume = 5

-- Silent aim targeting
local SilentTarget
local SilentTargetPart
local LastHitTime = 0

-- Function to get target part based on settings
local function GetTargetPart(character)
    if SilentAim.TargetPart == "Random" then
        local validPartsInCharacter = {}
        for _, partName in ipairs(SilentAim.ValidParts) do
            local part = character:FindFirstChild(partName)
            if part then
                table.insert(validPartsInCharacter, part)
            end
        end
        return #validPartsInCharacter > 0 and validPartsInCharacter[math.random(1, #validPartsInCharacter)] or nil
    else
        return character:FindFirstChild(SilentAim.TargetPart)
    end
end

-- Function to get multiplier 
local function GetScalingMultiplier()
    local baseMultiplier = (100 - SilentAim.HitChance)
    return baseMultiplier * (0.5 + math.random())
end

-- Modified targeting function to use selected part
local function GetSilentTarget()
    local ClosestPlayer
    local ShortestDistance = math.huge
    local MousePos = UserInputService:GetMouseLocation()
    
    for _, Player in pairs(Players:GetPlayers()) do
        if Player == LocalPlayer or not Player.Character then 
            continue 
        end
        
        local TargetPart = GetTargetPart(Player.Character)
        if not TargetPart then 
            continue 
        end
        
        local Position, IsVisible = Camera:WorldToViewportPoint(TargetPart.Position)
        if not IsVisible then 
            continue 
        end
        
        local Distance = (Vector2.new(Position.X, Position.Y) - MousePos).Magnitude
        if Distance <= SilentAim.FOV and Distance < ShortestDistance then
            ClosestPlayer = Player
            ShortestDistance = Distance
            SilentTargetPart = TargetPart
        end
    end
    
    return ClosestPlayer
end

-- Hit sound function
local function PlayHitSound()
    if SilentAim.HitSound.Enabled then
        local currentTime = tick()
        -- Prevent sound spam by adding a small delay
        if currentTime - LastHitTime > 0.05 then
            local HitmarkerClone = SilentHitmarker:Clone()
            HitmarkerClone.SoundId = "rbxassetid://" .. SilentAim.HitSound.AssetID
            HitmarkerClone.Parent = game:GetService("SoundService")
            HitmarkerClone:Play()
            game.Debris:AddItem(HitmarkerClone, 2)
            LastHitTime = currentTime
        end
    end
end

-- Connect hit detection events
LocalPlayer.Additionals.TotalDamage.Changed:Connect(function(Value)
    if Value ~= 0 then
        PlayHitSound()
    end
end)

-- Modified loop to use selected target part
spawn(function()
    while task.wait() do
        -- Silent FOV Circle
        SilentFOVCircle.Visible = SilentAim.ShowFOV
        SilentFOVCircle.Radius = SilentAim.FOV
        SilentFOVCircle.Position = UserInputService:GetMouseLocation()
        
        -- Silent targeting
        if SilentAim.Enabled then
            SilentTarget = GetSilentTarget()
            if not SilentTarget then
                SilentTargetPart = nil
            end
        else
            SilentTarget = nil
            SilentTargetPart = nil
        end
        
        -- Silent snaplines
        if SilentTarget and SilentAim.Snaplines and SilentTargetPart then
            local Position, IsVisible = Camera:WorldToViewportPoint(SilentTargetPart.Position)
            SilentSnapline.From = UserInputService:GetMouseLocation()
            SilentSnapline.To = Vector2.new(Position.X, Position.Y)
            SilentSnapline.Visible = true
        else
            SilentSnapline.Visible = false
        end
    end
end)

-- Modified namecall hook with hit chance and selective position scaling
local SilentOldNameCall
SilentOldNameCall = hookmetamethod(game, '__namecall', function(Self, ...)
    local Args = {...}
    local Method = getnamecallmethod()
    
    if SilentAim.Enabled and Self == workspace and Method == "FindPartOnRayWithIgnoreList" and getcallingscript().Name == "Client" then
        if SilentTarget and SilentTargetPart then
            local HitRoll = math.random(1, 100)
            
            if HitRoll <= SilentAim.HitChance then
                -- Use direct silent aim
                if SilentAim.Wallbang then
                    Args[1] = Ray.new(SilentTargetPart.Position + SilentTargetPart.CFrame.LookVector, -SilentTargetPart.CFrame.LookVector)
                else
                    Args[1] = Ray.new(Camera.CFrame.p, (CFrame.new(Camera.CFrame.p, SilentTargetPart.Position).LookVector) * 1000000)
                end
            else
                -- Missed hit chance - apply scaling
                local ScaledPosition = SilentTargetPart.Position + Vector3.new(
                    math.random(-GetScalingMultiplier(), GetScalingMultiplier()),
                    math.random(-GetScalingMultiplier(), GetScalingMultiplier()),
                    math.random(-GetScalingMultiplier(), GetScalingMultiplier())
                )
                Args[1] = Ray.new(Camera.CFrame.p, (ScaledPosition - Camera.CFrame.p).Unit * 1000000)
            end
            return SilentOldNameCall(Self, unpack(Args))
        end
    end
    
    return SilentOldNameCall(Self, ...)
end)

-- Visuals Features
local ESPBox = Tabs.Visuals:AddLeftGroupbox('ESP')
local ChamsBox = Tabs.Visuals:AddRightGroupbox('Chams')
local VisualsBox = Tabs.Visuals:AddRightGroupbox('Additional Visuals')
local WorldBox = Tabs.Visuals:AddLeftGroupbox('World Settings')
-- Gun Chams UI Section
local GunChamsBox = Tabs.Visuals:AddRightGroupbox('Gun Chams')

-- Main Gun Chams Toggle
local GunChamsToggle = GunChamsBox:AddToggle('GunChams', {
    Text = 'Gun Chams',
    Default = false,
    Callback = function(Value)
        GunMods.Settings.GunChams.Enabled = Value
    end
})

-- Arms Chams Toggle
local ArmsChamsToggle = GunChamsBox:AddToggle('ArmsChams', {
    Text = 'Arms Chams',
    Default = false,
    Callback = function(Value)
        GunMods.Settings.ArmsChams.Enabled = Value
    end
})

-- Gun Color Picker
GunChamsToggle:AddColorPicker('GunChamsColor', {
    Default = Color3.fromRGB(200, 200, 200),
    Title = 'Gun Color',
    Callback = function(Value)
        GunMods.Settings.GunChams.Color = Value
    end
})

-- Material Dropdown for Gun
GunChamsBox:AddDropdown('GunChamsMaterial', {
    Values = {'ForceField', 'Neon', 'Glass', 'SmoothPlastic'},
    Default = 1,
    Text = 'Gun Material',
    Callback = function(Value)
        GunMods.Settings.GunChams.Material = Enum.Material[Value]
    end
})

-- Arms Material Dropdown
GunChamsBox:AddDropdown('ArmsChamsMaterial', {
    Values = {'ForceField', 'Neon', 'Glass', 'SmoothPlastic'},
    Default = 1,
    Text = 'Arms Material',
    Callback = function(Value)
        GunMods.Settings.ArmsChams.Material = Enum.Material[Value]
    end
})

-- Arms Transparency Slider
GunChamsBox:AddSlider('ArmsTransparency', {
    Text = 'Arms Transparency',
    Default = 0,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Callback = function(Value)
        GunMods.Settings.ArmsChams.Transparency = Value
    end
})

-- General ESP Settings
ESPBox:AddToggle('ESPEnabled', {
    Text = 'ESP Enabled',
    Default = true,
    Callback = function(Value)
        ESP.Enabled = Value
    end
})

ESPBox:AddSlider('MaxESPDistance', {
    Text = 'Max ESP Distance',
    Default = 1000,
    Min = 100,
    Max = 5000,
    Rounding = 100,
    Callback = function(Value)
        ESP.MaxDistance = Value
    end
})

ESPBox:AddToggle('TeamCheck', {
    Text = 'Team Check',
    Default = false,
    Callback = function(Value)
        ESP.TeamCheck = Value
    end
})

-- Name ESP
local NameESPToggle = ESPBox:AddToggle('NameESP', {
    Text = 'Player Names',
    Default = false,
    Callback = function(Value)
        ESP.Drawing.Names.Enabled = Value
    end
})

NameESPToggle:AddColorPicker('NameESPColor', {
    Default = Color3.fromRGB(255, 255, 255),
    Title = 'Name Color',
    Callback = function(Value)
        ESP.Drawing.Names.RGB = Value
    end
})

-- Health ESP
local HealthESPToggle = ESPBox:AddToggle('HealthESP', {
    Text = 'Health Bars',
    Default = false,
    Callback = function(Value)
        ESP.Drawing.Healthbar.Enabled = Value
    end
})

HealthESPToggle:AddColorPicker('HealthESPColor', {
    Default = Color3.fromRGB(0, 255, 0),
    Title = 'Health Bar Color',
    Callback = function(Value)
        ESP.Drawing.Healthbar.HealthTextRGB = Value
    end
})

-- Box ESP
local BoxESPToggle = ESPBox:AddToggle('BoxESP', {
    Text = 'Box ESP',
    Default = false,
    Callback = function(Value)
        ESP.Drawing.Boxes.Corner.Enabled = Value
    end
})

BoxESPToggle:AddColorPicker('BoxESPColor', {
    Default = Color3.fromRGB(255, 0, 0),
    Title = 'Box Color',
    Callback = function(Value)
        ESP.Drawing.Boxes.Corner.RGB = Value
    end
})

-- Skeleton ESP
local SkeletonESPToggle = ESPBox:AddToggle('SkeletonESP', {
    Text = 'Skeleton ESP',
    Default = false,
    Callback = function(Value)
        ESP.Drawing.Flags.Enabled = Value
    end
})

SkeletonESPToggle:AddColorPicker('SkeletonESPColor', {
    Default = Color3.fromRGB(0, 255, 0),
    Title = 'Skeleton Color',
    Callback = function(Value)
        ESP.Drawing.Flags.RGB = Value
    end
})

-- Distance ESP
ESPBox:AddToggle('DistanceESP', {
    Text = 'Distance ESP',
    Default = false,
    Callback = function(Value: boolean)
        ESP.Drawing.Distances.Enabled = Value
    end
})

-- Weapon ESP
ESPBox:AddToggle('WeaponESP', {
    Text = 'Weapon ESP',
    Default = false,
    Callback = function(Value)
        ESP.Drawing.Weapons.Enabled = Value
    end
})

-- Chams
local PlayerChamsToggle = ChamsBox:AddToggle('PlayerChams', {
    Text = 'Player Chams',
    Default = false,
    Callback = function(Value)
        ESP.Drawing.Chams.Enabled = Value
    end
})

local ChamsVisibleCheck = ChamsBox:AddToggle('ChamsVisibleCheck', {
    Text = 'Visible Check',
    Default = false,
    Callback = function(Value)
        ESP.Drawing.Chams.VisibleCheck = Value
    end
})

local ChamsVisibleCOnly = ChamsBox:AddToggle('PlayerChamsVisOnly', {
    Text = 'Visible Only',
    Default = false,
    Callback = function(Value)
        ESP.Drawing.Chams.VisibleOnly = Value
    end
})

PlayerChamsToggle:AddColorPicker('ChamsVisibleColor', {
    Default = Color3.fromRGB(0, 255, 0),
    Title = 'Visible Color',
    Callback = function(Value)
        ESP.Drawing.Chams.NonOccludedColor = Value
    end
})

PlayerChamsToggle:AddColorPicker('ChamsHiddenColor', {
    Default = Color3.fromRGB(255, 0, 0),
    Title = 'Hidden Color',
    Callback = function(Value)
        ESP.Drawing.Chams.OccludedColor = Value
    end
})

ChamsBox:AddSlider('PulseSpeed', {
    Text = 'Pulse Speed',
    Default = 1,
    Min = 1,
    Max = 10,
    Rounding = 0,
    Callback = function(Value)
        ESP.Drawing.Chams.PulseSpeed = Value
    end
})

ChamsBox:AddSlider('RainbowSpeed', {
    Text = 'Rainbow Speed',
    Default = 0.3,
    Min = 0,
    Max = 5,
    Rounding = 0,
    Callback = function(Value)
        ESP.Drawing.Chams.RainbowSpeed = Value
    end
})

ChamsBox:AddSlider('ThermalSpeed', {
    Text = 'Thermal Speed',
    Default = 0.5,
    Min = 0,
    Max = 5,
    Rounding = 0,
    Callback = function(Value)
        ESP.Drawing.Chams.ThermalSpeed = Value
    end
})

ChamsBox:AddDropdown('ChamsStyle', {
    Values = { 'Pulse', 'Rainbow', 'Wireframe', 'Thermal' },
    Default = 1,
    Text = 'Chams Effect',

    Callback = function(Value)
        -- Disable all effects first
        ESP.Drawing.Chams.Pulse = false
        ESP.Drawing.Chams.Rainbow = false
        
        -- Enable the selected effect
        ESP.Drawing.Chams[Value] = true
    end
})


--// Fullbright Toggle Callback
WorldBox:AddToggle('FullBright', {
    Text = 'Full Bright',
    Default = false,
    Callback = function(Value)
        if Value then
            Lighting.Brightness = 2
            Lighting.GlobalShadows = false
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        else
            -- Reset to game defaults
            Lighting.Brightness = 1
            Lighting.GlobalShadows = true
            Lighting.Ambient = Color3.fromRGB(127, 127, 127)
            Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
        end
    end
})

--// No Fog Toggle Callback
WorldBox:AddToggle('NoFog', {
    Text = 'No Fog',
    Default = false,
    Callback = function(Value)
        if Value then
            Lighting.FogEnd = 1e9
            Lighting.FogStart = 0
        else
            -- Reset to game defaults
            Lighting.FogEnd = 100000
            Lighting.FogStart = 0
        end
    end
})

local FOVValue = 70 -- Default value

--// Field of View Slider Callback
WorldBox:AddSlider('FOVSlider', {
    Text = 'Field of View',
    Default = 70,
    Min = 60,
    Max = 120,
    Rounding = 0,
    Callback = function(Value)
        FOVValue = Value
    end
})

--// Continuously Apply FOV
game:GetService("RunService").RenderStepped:Connect(function()
    if Workspace.CurrentCamera then
        Workspace.CurrentCamera.FieldOfView = FOVValue
    end
end)

--// Time of Day Slider Callback
WorldBox:AddSlider('TimeOfDay', {
    Text = 'Time of Day',
    Default = 14,
    Min = 0,
    Max = 24,
    Rounding = 1,
    Callback = function(Value)
        Lighting.ClockTime = Value
    end
})

--// Ambient Color Picker Callback
WorldBox:AddLabel('Ambient Color'):AddColorPicker('AmbientColor', {
    Default = Color3.fromRGB(255, 255, 255),
    Title = 'Ambient Color',
    Callback = function(Value)
        Lighting.Ambient = Value
    end
})

--// Outdoor Ambient Color Picker Callback
WorldBox:AddLabel('Outdoor Ambient'):AddColorPicker('OutdoorAmbient', {
    Default = Color3.fromRGB(127, 127, 127),
    Title = 'Outdoor Ambient',
    Callback = function(Value)
        Lighting.OutdoorAmbient = Value
    end
})

--// Fog Color Picker Callback
WorldBox:AddLabel('Fog Color'):AddColorPicker('FogColor', {
    Default = Color3.fromRGB(192, 192, 192),
    Title = 'Fog Color',
    Callback = function(Value)
        Lighting.FogColor = Value
    end
})

--// Fog Start Slider Callback
WorldBox:AddSlider('FogStart', {
    Text = 'Fog Start',
    Default = 0,
    Min = 0,
    Max = 1000,
    Rounding = 0,
    Callback = function(Value)
        Lighting.FogStart = Value
    end
})

--// Fog End Slider Callback
WorldBox:AddSlider('FogEnd', {
    Text = 'Fog End',
    Default = 100000,
    Min = 0,
    Max = 100000,
    Rounding = 0,
    Callback = function(Value)
        Lighting.FogEnd = Value
    end
})


-- Crosshair
local BulletTracer = VisualsBox:AddToggle('BulletTracer', {
    Text = 'Bullet Tracers',
    Default = false,
    Callback = function(Value)
        Tracers.Options.Enabled = Value
    end
})

-- Function to fire bullets and create effects
local function FireBullet()
    local flashPart = workspace.Camera:FindFirstChild("Arms") and workspace.Camera.Arms:FindFirstChild("Flash")
    if not flashPart then
        warn("Flash part not found!")
        return
    end

-- Function to handle bullet effects (tracers)
local function HandleBulletEffects(targetPosition)
    if targetPosition and Tracers.Options.Enabled then
        spawn(function()
            -- Create a tracer part
            local BulletTracers = Instance.new("Part")
            BulletTracers.Anchored = true
            BulletTracers.CanCollide = false
            BulletTracers.Material = Tracers.Colors.Material
            BulletTracers.Color = Tracers.Colors.Color
            BulletTracers.Transparency = 0.5  -- Slight transparency
            BulletTracers.Size = Vector3.new(0.1, 0.1, (workspace.Camera.Arms.Flash.Position - targetPosition).magnitude)
            BulletTracers.CFrame = CFrame.new(workspace.Camera.Arms.Flash.Position, targetPosition) * CFrame.new(0, 0, -BulletTracers.Size.Z / 2)
            BulletTracers.Name = "BulletTracers"
            BulletTracers.Parent = workspace
            print("Tracer created at:", BulletTracers.Position)
            wait(3)
            BulletTracers:Destroy()
        end)
    else
        warn("Invalid target position or tracers disabled.")
    end
end


    local cameraPosition = flashPart.Position
    local lookDirection = workspace.CurrentCamera.CFrame.LookVector
    local rayOrigin = cameraPosition + lookDirection * 0.5
    local rayDirection = lookDirection * Tracers.Options.Distance

    local raycastResult = workspace:Raycast(rayOrigin, rayDirection)
    local targetPosition = raycastResult and raycastResult.Position or (rayOrigin + rayDirection)

    print("Target Position:", targetPosition)  -- Debug target position
    HandleBulletEffects(targetPosition)
end

-- Mouse setup and firing
local Player = game.Players.LocalPlayer
local Mouse2 = Player:GetMouse()
Mouse2.Button1Down:Connect(function()
    if Tracers.Options.Enabled then
        FireBullet()
    end
end)


-- Movement Features
local MovementBox = Tabs.Movement:AddLeftGroupbox('Movement')

MovementBox:AddToggle('BHopEnabled', {
    Text = 'Bunny Hop',
    Default = false,

    Callback = function(Value)
        print('[cb] Color changed!', Value)
    end
})

MovementBox:AddToggle('SpeedHack', {
    Text = 'Speed Hack',
    Default = false,

    Callback = function(Value)
        print('[cb] Color changed!', Value)
    end
})

MovementBox:AddSlider('SpeedValue', {
    Text = 'Speed Multiplier',
    Default = 2,
    Min = 1,
    Max = 10,
    Rounding = 1,

    Callback = function(Value)
        print('[cb] Color changed!', Value)
    end
})

-- UI Settings
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')
MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })

Library.KeybindFrame.Visible = true; -- todo: add a function for this

-- Theme/Save Manager
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })
ThemeManager:SetFolder('CBsploit')
SaveManager:SetFolder('CBsploit/configs')
SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyToTab(Tabs['UI Settings'])
ThemeManager:ApplyTheme('BBot')

local endTime = tick()
local elapsedTime = endTime - startTime

Library:Notify(string.format("Script Loaded in %.2fs", elapsedTime), 10)



-- Main loop for the trigger bot
while true do
    wait()
    if triggerBotEnabled then
        pcall(function()
            for _, v in pairs(game.Players:GetPlayers()) do  
                if v ~= game.Players.LocalPlayer and v.Character and v.Team ~= game.Players.LocalPlayer.Team and v.Character.Humanoid.Health > 0 then
                    local equippedTool = game.Players.LocalPlayer.Character:FindFirstChild("EquippedTool")
                    if equippedTool and game.ReplicatedStorage.Weapons[equippedTool.Value]:FindFirstChild("Chamber") then
                        return
                    end

                    local bodyParts = {
                        v.Character.HeadHB, v.Character.HumanoidRootPart,
                        v.Character.LeftHand, v.Character.LeftLowerArm, v.Character.LeftUpperArm,
                        v.Character.RightHand, v.Character.RightLowerArm, v.Character.RightUpperArm,
                        v.Character.UpperTorso, v.Character.LeftFoot, v.Character.LeftLowerLeg,
                        v.Character.LeftUpperLeg, v.Character.RightFoot, v.Character.RightLowerLeg,
                        v.Character.RightUpperLeg, v.Character.LowerTorso
                    }

                    for _, part in pairs(bodyParts) do
                        if Mouse.Target == part then
                            local cooldown = game.ReplicatedStorage.Weapons[equippedTool.Value].FireRate.Value
                            local client = game.Players.LocalPlayer.PlayerGui.Client
                            getsenv(client).firebullet()
                            print("Fired at:", v.Name)
                            wait(cooldown)
                            break
                        end
                    end
                end
            end
        end)
    end
end
