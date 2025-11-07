-- Universal Script GUI Template full version
-- Place as LocalScript in StarterPlayerScripts
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Destroy existing UI
if PlayerGui:FindFirstChild("RiooHubUI") then
    PlayerGui.RiooHubUI:Destroy()
end

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RiooHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Main frame
local MAIN_WIDTH = 540
local MAIN_HEIGHT = 360
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, MAIN_WIDTH, 0, MAIN_HEIGHT)
MainFrame.Position = UDim2.new(0.5, -MAIN_WIDTH/2, 0.5, -MAIN_HEIGHT/2)
MainFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,10)
Instance.new("UIStroke", MainFrame).Thickness = 2

-- Title bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1,0,0,48)
TitleBar.BackgroundColor3 = Color3.fromRGB(28,28,28)
TitleBar.Parent = MainFrame
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0,8)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1,-120,1,0)
TitleLabel.Position = UDim2.new(0,12,0,0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "ZAMMSTR Hub Test"
TitleLabel.TextColor3 = Color3.fromRGB(240,240,240)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 20
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- Title buttons
local function makeTitleBtn(text, posX)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,38,0,30)
    btn.Position = UDim2.new(1,posX,0,9)
    btn.BackgroundColor3 = Color3.fromRGB(65,65,65)
    btn.TextColor3 = Color3.fromRGB(245,245,245)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.Parent = TitleBar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)
    return btn
end

local MinimizeBtn = makeTitleBtn("-", -80)
local CloseScriptBtn = makeTitleBtn("✕", -38)

-- Tab bar
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1,0,0,44)
TabBar.Position = UDim2.new(0,0,0,48)
TabBar.BackgroundColor3 = Color3.fromRGB(30,30,30)
TabBar.Parent = MainFrame
Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0,8)

-- Tab content
local TabContent = Instance.new("Frame")
TabContent.Size = UDim2.new(1,-24,0,MAIN_HEIGHT-110)
TabContent.Position = UDim2.new(0,12,0,94)
TabContent.BackgroundColor3 = Color3.fromRGB(48,48,48)
TabContent.Parent = MainFrame
Instance.new("UICorner", TabContent).CornerRadius = UDim.new(0,6)

-- Tabs
local tabs = {}
local function addTab(name, onActivate)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,110,0,32)
    btn.Position = UDim2.new(0, 8 + (#tabs*118), 0, 6)
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.TextColor3 = Color3.fromRGB(240,240,240)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15
    btn.Parent = TabBar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)

    table.insert(tabs, btn)
    btn.MouseButton1Click:Connect(function()
        for _,b in ipairs(tabs) do b.BackgroundColor3 = Color3.fromRGB(60,60,60) end
        btn.BackgroundColor3 = Color3.fromRGB(90,90,90)
        if onActivate then pcall(onActivate) end
    end)
    return btn
end

-- Add example tab
local mainTab = addTab("LocalPlayer", function()
    TabContent.Visible = true
end)
mainTab.BackgroundColor3 = Color3.fromRGB(90,90,90)

-- Example button: WalkSpeed
local WalkSpeedBtn = Instance.new("TextButton")
WalkSpeedBtn.Size = UDim2.new(0,200,0,36)
WalkSpeedBtn.Position = UDim2.new(0,12,0,12)
WalkSpeedBtn.BackgroundColor3 = Color3.fromRGB(72,72,72)
WalkSpeedBtn.TextColor3 = Color3.fromRGB(240,240,240)
WalkSpeedBtn.Text = "Increase WalkSpeed"
WalkSpeedBtn.Font = Enum.Font.Gotham
WalkSpeedBtn.TextSize = 16
WalkSpeedBtn.Parent = TabContent
Instance.new("UICorner", WalkSpeedBtn).CornerRadius = UDim.new(0,6)

WalkSpeedBtn.MouseButton1Click:Connect(function()
    Player.Character.Humanoid.WalkSpeed = 300
end)

-- Notification function
local function ShowNotification(title, content, duration)
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0,250,0,60)
    notif.Position = UDim2.new(0.5,-125,0,10)
    notif.BackgroundColor3 = Color3.fromRGB(60,60,60)
    notif.Parent = ScreenGui
    Instance.new("UICorner", notif).CornerRadius = UDim.new(0,6)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,-12,1,-12)
    label.Position = UDim2.new(0,6,0,6)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 16
    label.Text = title.."\n"..content
    label.TextWrapped = true
    label.Parent = notif

    delay(duration or 5, function() notif:Destroy() end)
end

-- Show welcome notification
ShowNotification("WELCOME", "Notification content... what will it say??", 5)

-- Show/Hide button (outside main frame)
local ShowBtn = Instance.new("TextButton")
ShowBtn.Size = UDim2.new(0,160,0,40)
ShowBtn.Position = UDim2.new(0, 18, 0, 18)
ShowBtn.AnchorPoint = Vector2.new(0,0)
ShowBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
ShowBtn.TextColor3 = Color3.fromRGB(240,240,240)
ShowBtn.Font = Enum.Font.GothamBold
ShowBtn.TextSize = 16
ShowBtn.Text = "Show Menu"
ShowBtn.Visible = false
ShowBtn.Parent = ScreenGui
Instance.new("UICorner", ShowBtn).CornerRadius = UDim.new(0,8)

-- Minimize button hides main frame & shows ShowBtn
MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ShowBtn.Visible = true
end)

-- Show button restores main frame & hides ShowBtn
ShowBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    ShowBtn.Visible = false
end)

-- Close Script button
CloseScriptBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

print("✅ RiooHub GUI loaded with Show/Hide button functionality!")