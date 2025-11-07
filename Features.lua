-- RiooHub GUI final complete version (Delta-friendly, polos)
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- Hapus semua instance lama di PlayerGui & CoreGui
local PlayerGui = Player:WaitForChild("PlayerGui")
for i,v in pairs(PlayerGui:GetChildren()) do
    if v.Name == "RiooHubUI" then
        v:Destroy()
    end
end
for i,v in pairs(game:GetService("CoreGui"):GetChildren()) do
    if v.Name == "RiooHubUI" then
        v:Destroy()
    end
end

-- ScreenGui baru
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RiooHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MAIN_WIDTH, MAIN_HEIGHT = 540, 360

-- Main window
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, MAIN_WIDTH, 0, MAIN_HEIGHT)
MainFrame.Position = UDim2.new(0.5, -MAIN_WIDTH/2, 0.5, -MAIN_HEIGHT/2)
MainFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,8)

-- Title bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1,0,0,48)
TitleBar.BackgroundColor3 = Color3.fromRGB(28,28,28)
TitleBar.Parent = MainFrame
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0,8)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1,-180,1,0)
TitleLabel.Position = UDim2.new(0,12,0,0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "RiooHub - Fish It"
TitleLabel.TextColor3 = Color3.fromRGB(240,240,240)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 20
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- Buttons helper
local function makeBtn(txt, posX)
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

local MinimizeBtn = makeBtn("-", -138)
local CloseAllTabsBtn = makeBtn("✕", -95)
local CloseScriptBtn = makeBtn("✕", -38)

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

-- Tab system (example)
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
    btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(60,60,60) end)

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

-- Example button inside tab
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

-- Show/Hide button
local ShowBtn = Instance.new("TextButton")
ShowBtn.Size = UDim2.new(0,160,0,40)
ShowBtn.Position = UDim2.new(0, 18, 0, 18)
ShowBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
ShowBtn.TextColor3 = Color3.fromRGB(240,240,240)
ShowBtn.Font = Enum.Font.GothamBold
ShowBtn.TextSize = 16
ShowBtn.Text = "RiooHub - Fish It" -- tulisan sekarang
ShowBtn.Visible = false
ShowBtn.ZIndex = 10
ShowBtn.Parent = ScreenGui
Instance.new("UICorner", ShowBtn).CornerRadius = UDim.new(0,8)

-- Button actions
MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ShowBtn.Visible = true
end)

ShowBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    ShowBtn.Visible = false
end)

CloseScriptBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

CloseAllTabsBtn.MouseButton1Click:Connect(function()
    for i,v in pairs(TabContent:GetChildren()) do
        v:Destroy()
    end
    print("✅ All tab content cleared")
end)

print("✅ RiooHub final complete loaded (polos, Delta-friendly, Show/Hide = RiooHub - Fish It, Close All Tabs ready)")