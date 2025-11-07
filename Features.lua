-- RiooHub GUI polished version
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("RiooHubUI") then
    PlayerGui.RiooHubUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RiooHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Constants
local MAIN_WIDTH, MAIN_HEIGHT = 540, 360
local MAIN_MIN_HEIGHT = 48
local ANIM_TIME = 0.25

-- Main container
local MainContainer = Instance.new("Frame")
MainContainer.Size = UDim2.new(0, MAIN_WIDTH, 0, MAIN_HEIGHT)
MainContainer.Position = UDim2.new(0.5, -MAIN_WIDTH/2, 0.5, -MAIN_HEIGHT/2)
MainContainer.BackgroundColor3 = Color3.fromRGB(40,40,40)
MainContainer.Active = true
MainContainer.Draggable = true
MainContainer.Parent = ScreenGui
Instance.new("UICorner", MainContainer).CornerRadius = UDim.new(0,10)
Instance.new("UIStroke", MainContainer).Thickness = 2

-- Title bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1,0,0,48)
TitleBar.BackgroundColor3 = Color3.fromRGB(28,28,28)
TitleBar.Parent = MainContainer
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0,8)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1,-140,1,0)
TitleLabel.Position = UDim2.new(0,12,0,0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "ZAMMSTR Hub Test"
TitleLabel.TextColor3 = Color3.fromRGB(240,240,240)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 20
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- Buttons: Minimize / Maximize / Close
local function makeTitleBtn(txt, posX)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,38,0,30)
    btn.Position = UDim2.new(1,posX,0,9)
    btn.BackgroundColor3 = Color3.fromRGB(65,65,65)
    btn.TextColor3 = Color3.fromRGB(245,245,245)
    btn.Text = txt
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.Parent = TitleBar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)
    return btn
end

local MinimizeBtn = makeTitleBtn("-", -114)
local MaximizeBtn = makeTitleBtn("□", -76)
local CloseBtn = makeTitleBtn("✕", -38)

-- Tab bar
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1,0,0,44)
TabBar.Position = UDim2.new(0,0,0,48)
TabBar.BackgroundColor3 = Color3.fromRGB(30,30,30)
TabBar.Parent = MainContainer
Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0,8)

-- Tab content
local TabContent = Instance.new("Frame")
TabContent.Size = UDim2.new(1,-24,0,MAIN_HEIGHT-110)
TabContent.Position = UDim2.new(0,12,0,94)
TabContent.BackgroundColor3 = Color3.fromRGB(48,48,48)
TabContent.Parent = MainContainer
Instance.new("UICorner", TabContent).CornerRadius = UDim.new(0,6)

-- Tabs system
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
    btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(90,90,90) end)
    btn.MouseLeave:Connect(function() 
        if TabContent.Visible then
            btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
        end
    end)

    btn.MouseButton1Click:Connect(function()
        for _,b in ipairs(tabs) do b.BackgroundColor3 = Color3.fromRGB(60,60,60) end
        btn.BackgroundColor3 = Color3.fromRGB(90,90,90)
        if onActivate then pcall(onActivate) end
    end)
    return btn
end

-- Example tab
local mainTab = addTab("LocalPlayer", function()
    TabContent.Visible = true
end)
mainTab.BackgroundColor3 = Color3.fromRGB(90,90,90)

-- Example button in tab
local WalkBtn = Instance.new("TextButton")
WalkBtn.Size = UDim2.new(0,200,0,36)
WalkBtn.Position = UDim2.new(0,12,0,12)
WalkBtn.BackgroundColor3 = Color3.fromRGB(72,72,72)
WalkBtn.TextColor3 = Color3.fromRGB(240,240,240)
WalkBtn.Text = "Increase WalkSpeed"
WalkBtn.Font = Enum.Font.Gotham
WalkBtn.TextSize = 16
WalkBtn.Parent = TabContent
Instance.new("UICorner", WalkBtn).CornerRadius = UDim.new(0,6)
WalkBtn.MouseButton1Click:Connect(function()
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.WalkSpeed = 300
    end
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

ShowNotification("WELCOME","RiooHub polished GUI loaded!",5)

-- Show/Hide button
local ShowBtn = Instance.new("TextButton")
ShowBtn.Size = UDim2.new(0,160,0,40)
ShowBtn.Position = UDim2.new(0,18,0,18)
ShowBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
ShowBtn.TextColor3 = Color3.fromRGB(240,240,240)
ShowBtn.Font = Enum.Font.GothamBold
ShowBtn.TextSize = 16
ShowBtn.Text = "Show Menu"
ShowBtn.Visible = false
ShowBtn.ZIndex = 10
ShowBtn.Parent = ScreenGui
Instance.new("UICorner", ShowBtn).CornerRadius = UDim.new(0,8)

-- Tweening helper
local function tweenFrame(frame, size, pos)
    TweenService:Create(frame, TweenInfo.new(ANIM_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = size, Position = pos}):Play()
end

-- Minimize button
MinimizeBtn.MouseButton1Click:Connect(function()
    tweenFrame(MainContainer, UDim2.new(0, MAIN_WIDTH,0,0), MainContainer.Position)
    wait(ANIM_TIME)
    MainContainer.Visible = false
    ShowBtn.Visible = true
end)

-- Maximize / Restore
local maximized = false
MaximizeBtn.MouseButton1Click:Connect(function()
    if not maximized then
        tweenFrame(MainContainer, UDim2.new(0, MAIN_WIDTH,0,MAIN_HEIGHT+100), MainContainer.Position)
        maximized = true
    else
        tweenFrame(MainContainer, UDim2.new(0, MAIN_WIDTH,0,MAIN_HEIGHT), MainContainer.Position)
        maximized = false
    end
end)

-- Show button
ShowBtn.MouseButton1Click:Connect(function()
    MainContainer.Visible = true
    ShowBtn.Visible = false
    tweenFrame(MainContainer, UDim2.new(0, MAIN_WIDTH,0,MAIN_HEIGHT), MainContainer.Position)
end)

-- Close button
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

print("✅ RiooHub polished GUI loaded with smooth Minimize/Maximize/Show functionality!")