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
-- Main Window
-- =======================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MainFrame

local Shadow = Instance.new("UIStroke")
Shadow.Color = Color3.fromRGB(0,0,0)
Shadow.Thickness = 2
Shadow.Transparency = 0.5
Shadow.Parent = MainFrame

-- =======================
-- Title Bar
-- =======================
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
-- Show/Hide Menu Button
-- =======================
local ShowMenuBtn = Instance.new("TextButton")
ShowMenuBtn.Size = UDim2.new(0, 160, 0, 40)
ShowMenuBtn.Position = UDim2.new(0, 20, 0, 20)
ShowMenuBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
ShowMenuBtn.TextColor3 = Color3.fromRGB(255,255,255)
ShowMenuBtn.Text = "Hide Menu"
ShowMenuBtn.Font = Enum.Font.GothamBold
ShowMenuBtn.TextSize = 18
ShowMenuBtn.Parent = ScreenGui

local CornerBtn = Instance.new("UICorner")
CornerBtn.CornerRadius = UDim.new(0,8)
CornerBtn.Parent = ShowMenuBtn

local MenuVisible = true
ShowMenuBtn.MouseButton1Click:Connect(function()
    MenuVisible = not MenuVisible
    MainFrame.Visible = MenuVisible
    ShowMenuBtn.Text = MenuVisible and "Hide Menu" or "Show Menu"
end)

-- =======================
-- Tabs System
-- =======================
local Tabs = {}
local CurrentTab = nil

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(0, 200, 0, 40)
TabBar.Position = UDim2.new(0, 200, 0.5, -175)
TabBar.BackgroundColor3 = Color3.fromRGB(30,30,30)
TabBar.Parent = ScreenGui

local TabBarCorner = Instance.new("UICorner")
TabBarCorner.CornerRadius = UDim.new(0,8)
TabBarCorner.Parent = TabBar

local function CreateTab(name)
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(0, 180, 0, 35)
    TabButton.Position = UDim2.new(0, 10 + #Tabs*190, 0, 2)
    TabButton.BackgroundColor3 = Color3.fromRGB(60,60,60)
    TabButton.TextColor3 = Color3.fromRGB(255,255,255)
    TabButton.Text = name
    TabButton.Font = Enum.Font.GothamBold
    TabButton.TextSize = 16
    TabButton.Parent = TabBar

    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0,6)
    TabCorner.Parent = TabButton

    local TabContent = Instance.new("Frame")
    TabContent.Size = UDim2.new(0, 480, 0, 300)
    TabContent.Position = UDim2.new(0.5, -240, 0.5, -150)
    TabContent.BackgroundColor3 = Color3.fromRGB(45,45,45)
    TabContent.Visible = false
    TabContent.Parent = ScreenGui

    -- Close Tab Button
    local CloseTab = Instance.new("TextButton")
    CloseTab.Size = UDim2.new(0, 60, 0, 25)
    CloseTab.Position = UDim2.new(1, -70, 0, 5)
    CloseTab.BackgroundColor3 = Color3.fromRGB(100,30,30)
    CloseTab.TextColor3 = Color3.fromRGB(255,255,255)
    CloseTab.Text = "X"
    CloseTab.Font = Enum.Font.GothamBold
    CloseTab.TextSize = 16
    CloseTab.Parent = TabContent

    CloseTab.MouseButton1Click:Connect(function()
        TabContent.Visible = false
    end)

    -- Minimize/Maximize Button
    local MiniBtn = Instance.new("TextButton")
    MiniBtn.Size = UDim2.new(0, 25, 0, 25)
    MiniBtn.Position = UDim2.new(1, -35, 0, 5)
    MiniBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
    MiniBtn.TextColor3 = Color3.fromRGB(255,255,255)
    MiniBtn.Text = "-"
    MiniBtn.Font = Enum.Font.GothamBold
    MiniBtn.TextSize = 16
    MiniBtn.Parent = TabContent

    local Minimized = false
    MiniBtn.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        TabContent.Size = Minimized and UDim2.new(0, 480, 0, 50) or UDim2.new(0, 480, 0, 300)
    end)

    TabButton.MouseButton1Click:Connect(function()
        if CurrentTab then CurrentTab.Visible = false end
        TabContent.Visible = true
        CurrentTab = TabContent
    end)

    table.insert(Tabs, TabButton)
    return TabContent
end

-- Example Tab
local AutoTab = CreateTab("Auto Farm")

-- Close Script Button
local CloseScriptBtn = Instance.new("TextButton")
CloseScriptBtn.Size = UDim2.new(0, 160, 0, 35)
CloseScriptBtn.Position = UDim2.new(0, 20, 0, 70)
CloseScriptBtn.BackgroundColor3 = Color3.fromRGB(100,30,30)
CloseScriptBtn.TextColor3 = Color3.fromRGB(255,255,255)
CloseScriptBtn.Text = "Close Script"
CloseScriptBtn.Font = Enum.Font.GothamBold
CloseScriptBtn.TextSize = 18
CloseScriptBtn.Parent = ScreenGui

CloseScriptBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

print("✅ VinzHub-style UI template loaded! Show/Hide Menu, Minimize/Maximize Tabs, Close Tab, Close Script")