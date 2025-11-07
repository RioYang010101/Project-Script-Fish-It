local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- =======================
-- ScreenGui
-- =======================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RiooHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- =======================
-- Main Window (Rayfield style)
-- =======================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true

-- Rounded corners + shadow
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MainFrame

local Shadow = Instance.new("UIStroke")
Shadow.Color = Color3.fromRGB(0,0,0)
Shadow.Thickness = 2
Shadow.Transparency = 0.5
Shadow.Parent = MainFrame

-- Gradient background
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(50,50,50)), ColorSequenceKeypoint.new(1, Color3.fromRGB(35,35,35))}
Gradient.Rotation = 45
Gradient.Parent = MainFrame

-- Title Bar
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,40)
Title.Position = UDim2.new(0,0,0,0)
Title.BackgroundColor3 = Color3.fromRGB(30,30,30)
Title.BorderSizePixel = 0
Title.Text = "RiooHub - Fish It"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- =======================
-- Open/Close Menu Button
-- =======================
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 160, 0, 40)
ToggleButton.Position = UDim2.new(0, 20, 0, 20)
ToggleButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
ToggleButton.TextColor3 = Color3.fromRGB(255,255,255)
ToggleButton.Text = "RiooHub - Fish It"
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 18
ToggleButton.Parent = ScreenGui

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0,8)
ButtonCorner.Parent = ToggleButton

local UIVisible = true
ToggleButton.MouseButton1Click:Connect(function()
    UIVisible = not UIVisible
    MainFrame.Visible = UIVisible
    ToggleButton.Text = UIVisible and "RiooHub - Fish It" or "Open Menu"
end)

-- =======================
-- Tabs System
-- =======================
local Tabs = {}
local CurrentTab = nil

local function CreateTab(name)
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(0, 120, 0, 35)
    TabButton.Position = UDim2.new(0, 10 + #Tabs*130, 0, 50)
    TabButton.BackgroundColor3 = Color3.fromRGB(60,60,60)
    TabButton.TextColor3 = Color3.fromRGB(255,255,255)
    TabButton.Text = name
    TabButton.Font = Enum.Font.GothamBold
    TabButton.TextSize = 16
    TabButton.Parent = MainFrame

    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0,6)
    TabCorner.Parent = TabButton

    local TabContent = Instance.new("Frame")
    TabContent.Size = UDim2.new(1,-20,1,-100)
    TabContent.Position = UDim2.new(0,10,0,90)
    TabContent.BackgroundColor3 = Color3.fromRGB(45,45,45)
    TabContent.Visible = false
    TabContent.Parent = MainFrame

    TabButton.MouseEnter:Connect(function()
        TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80,80,80)}):Play()
    end)
    TabButton.MouseLeave:Connect(function()
        TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = (CurrentTab == TabContent and Color3.fromRGB(100,100,100) or Color3.fromRGB(60,60,60))}):Play()
    end)

    TabButton.MouseButton1Click:Connect(function()
        if CurrentTab then CurrentTab.Visible = false end
        TabContent.Visible = true
        CurrentTab = TabContent

        -- highlight active tab
        for _,btn in ipairs(Tabs) do
            btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
        end
        TabButton.BackgroundColor3 = Color3.fromRGB(100,100,100)
    end)

    table.insert(Tabs, TabButton)
    return TabContent
end

-- Example Tab: Auto Farm
local AutoTab = CreateTab("Auto Farm")

local AutoToggle = Instance.new("TextButton")
AutoToggle.Size = UDim2.new(0,150,0,30)
AutoToggle.Position = UDim2.new(0,10,0,10)
AutoToggle.BackgroundColor3 = Color3.fromRGB(70,70,70)
AutoToggle.TextColor3 = Color3.fromRGB(255,255,255)
AutoToggle.Text = "Auto Farm: OFF"
AutoToggle.Font = Enum.Font.Gotham
AutoToggle.TextSize = 16
AutoToggle.Parent = AutoTab

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0,6)
ToggleCorner.Parent = AutoToggle

local Enabled = false
AutoToggle.MouseButton1Click:Connect(function()
    Enabled = not Enabled
    AutoToggle.Text = "Auto Farm: "..(Enabled and "ON" or "OFF")
end)

print("✅ Full Rayfield-style UI template loaded! Dragable, Tabs, Toggle, Open/Close Menu, Gradient+Shadow+Animation")