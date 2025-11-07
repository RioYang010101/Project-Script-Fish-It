-- RiooHub Rayfield-style sidebar + main content test
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- Bersihkan UI lama
local PlayerGui = Player:WaitForChild("PlayerGui")
for i,v in pairs(PlayerGui:GetChildren()) do
    if v.Name == "RiooHubUI" then v:Destroy() end
end

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RiooHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local SCREEN_WIDTH, SCREEN_HEIGHT = 600, 400

-- Main window
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, SCREEN_WIDTH, 0, SCREEN_HEIGHT)
MainFrame.Position = UDim2.new(0.5, -SCREEN_WIDTH/2, 0.5, -SCREEN_HEIGHT/2)
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
TitleLabel.Size = UDim2.new(1,-80,1,0)
TitleLabel.Position = UDim2.new(0,12,0,0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "RiooHub - Fish It"
TitleLabel.TextColor3 = Color3.fromRGB(240,240,240)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 20
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- Title bar buttons
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

local MinimizeBtn = makeBtn("-", -80)
local CloseScriptBtn = makeBtn("X", -38)

-- Sidebar kiri
local SIDEBAR_WIDTH = 150
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, SIDEBAR_WIDTH, 1, -48)
Sidebar.Position = UDim2.new(0,0,0,48)
Sidebar.BackgroundColor3 = Color3.fromRGB(30,30,30)
Sidebar.Parent = MainFrame
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0,8)

-- Main content kanan
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -SIDEBAR_WIDTH - 12, 1, -48)
ContentFrame.Position = UDim2.new(0, SIDEBAR_WIDTH + 12, 0, 48)
ContentFrame.BackgroundColor3 = Color3.fromRGB(48,48,48)
ContentFrame.Parent = MainFrame
Instance.new("UICorner", ContentFrame).CornerRadius = UDim.new(0,6)

-- Fungsi buat menu sidebar
local function addMenu(name, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,0,40)
    btn.Position = UDim2.new(0,0,0,yPos)
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.TextColor3 = Color3.fromRGB(240,240,240)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.Parent = Sidebar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)
    
    btn.MouseButton1Click:Connect(function()
        -- Clear previous content
        for i,v in pairs(ContentFrame:GetChildren()) do
            if v:IsA("GuiObject") then v:Destroy() end
        end
        -- Tambahkan test content
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1,0,0,40)
        label.Position = UDim2.new(0,0,0,0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(240,240,240)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 18
        label.Text = "Content for "..name
        label.Parent = ContentFrame
    end)
end

-- Tambahkan menu
addMenu("Auto Farm", 0)
addMenu("Teleport", 50)
addMenu("Shop", 100)

-- Show/Hide button saat minimized
local ShowBtn = Instance.new("TextButton")
ShowBtn.Size = UDim2.new(0,160,0,40)
ShowBtn.Position = UDim2.new(0, 18, 0, 18)
ShowBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
ShowBtn.TextColor3 = Color3.fromRGB(240,240,240)
ShowBtn.Font = Enum.Font.GothamBold
ShowBtn.TextSize = 16
ShowBtn.Text = "RiooHub - Fish It"
ShowBtn.Visible = false
ShowBtn.ZIndex = 10
ShowBtn.Parent = ScreenGui
Instance.new("UICorner", ShowBtn).CornerRadius = UDim.new(0,8)

-- Tombol actions
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

print("✅ RiooHub Rayfield-style sidebar + main content loaded (test content)")