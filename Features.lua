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
MainFrame.Size = UDim2.new(0, 500, 0, 300)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Rounded corners + shadow
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MainFrame

local Shadow = Instance.new("UIStroke")
Shadow.Color = Color3.fromRGB(0,0,0)
Shadow.Thickness = 2
Shadow.Transparency = 0.5
Shadow.Parent = MainFrame

-- Gradient
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(50,50,50)), ColorSequenceKeypoint.new(1, Color3.fromRGB(35,35,35))}
Gradient.Rotation = 45
Gradient.Parent = MainFrame

-- =======================
-- Title Bar
-- =======================
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1,0,0,40)
TitleBar.Position = UDim2.new(0,0,0,0)
TitleBar.BackgroundColor3 = Color3.fromRGB(30,30,30)
TitleBar.Parent = MainFrame

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1,-120,1,0)
TitleText.Position = UDim2.new(0,0,0,0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "RiooHub - Fish It"
TitleText.TextColor3 = Color3.fromRGB(255,255,255)
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 22
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

-- Rounded corners for title
local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0,10)
TitleCorner.Parent = TitleBar

-- =======================
-- Control Buttons (Minimize, Close Tab, Close Script)
-- =======================
local function createTitleButton(text, position)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 35, 0, 30)
    btn.Position = position
    btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.Parent = TitleBar
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,6)
    corner.Parent = btn
    return btn
end

local MinimizeBtn = createTitleButton("_", UDim2.new(1, -105, 0, 5))
local CloseTabBtn = createTitleButton("X", UDim2.new(1, -70, 0, 5))
local CloseScriptBtn = createTitleButton("C", UDim2.new(1, -35, 0, 5))

-- =======================
-- Tab Bar
-- =======================
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1,0,0,40)
TabBar.Position = UDim2.new(0,0,0,40)
TabBar.BackgroundColor3 = Color3.fromRGB(30,30,30)
TabBar.Parent = MainFrame

-- Example Tab Button
local TabButton1 = Instance.new("TextButton")
TabButton1.Size = UDim2.new(0, 100, 0, 30)
TabButton1.Position = UDim2.new(0,10,0,5)
TabButton1.BackgroundColor3 = Color3.fromRGB(60,60,60)
TabButton1.TextColor3 = Color3.fromRGB(255,255,255)
TabButton1.Text = "Auto Farm"
TabButton1.Font = Enum.Font.GothamBold
TabButton1.TextSize = 16
TabButton1.Parent = TabBar

-- =======================
-- Tab Content
-- =======================
local TabContent = Instance.new("Frame")
TabContent.Size = UDim2.new(1,-20,1,-90)
TabContent.Position = UDim2.new(0,10,0,90)
TabContent.BackgroundColor3 = Color3.fromRGB(45,45,45)
TabContent.Parent = MainFrame

-- Example Toggle
local AutoToggle = Instance.new("TextButton")
AutoToggle.Size = UDim2.new(0,150,0,30)
AutoToggle.Position = UDim2.new(0,10,0,10)
AutoToggle.BackgroundColor3 = Color3.fromRGB(70,70,70)
AutoToggle.TextColor3 = Color3.fromRGB(255,255,255)
AutoToggle.Text = "Auto Farm: OFF"
AutoToggle.Font = Enum.Font.Gotham
AutoToggle.TextSize = 16
AutoToggle.Parent = TabContent

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0,6)
ToggleCorner.Parent = AutoToggle

local Enabled = false
AutoToggle.MouseButton1Click:Connect(function()
    Enabled = not Enabled
    AutoToggle.Text = "Auto Farm: "..(Enabled and "ON" or "OFF")
end)

-- =======================
-- Button Functionalities
-- =======================
-- Minimize/UpSize
local Minimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    Minimized = not Minimized
    TabContent.Visible = not Minimized
    MainFrame.Size = Minimized and UDim2.new(0, 500, 0, 50) or UDim2.new(0, 500, 0, 300)
end)

-- Close Tab (hide content, keep main frame)
CloseTabBtn.MouseButton1Click:Connect(function()
    TabContent.Visible = false
end)

-- Close Script
CloseScriptBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- =======================
-- Show/Hide Menu Outside Main Frame
-- =======================
local ShowMenuBtn = Instance.new("TextButton")
ShowMenuBtn.Size = UDim2.new(0,160,0,40)
ShowMenuBtn.Position = UDim2.new(0,20,0,20)
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

print("✅ VinzHub-style UI loaded! Show/Hide Menu, Minimize/UpSize/Close Tab, Close Script, Tab Bar")