-- RiooHub GUI simple (Minimize + Close Script)
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
TitleLabel.Size = UDim2.new(1,-80,1,0)
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

local MinimizeBtn = makeBtn("-", -80)
local CloseScriptBtn = makeBtn("X", -38) -- Close Script pakai X

-- Tab content (simple)
local TabContent = Instance.new("Frame")
TabContent.Size = UDim2.new(1,-24,0,MAIN_HEIGHT-60)
TabContent.Position = UDim2.new(0,12,0,60)
TabContent.BackgroundColor3 = Color3.fromRGB(48,48,48)
TabContent.Parent = MainFrame
Instance.new("UICorner", TabContent).CornerRadius = UDim.new(0,6)

-- Show/Hide button saat minimized
local ShowBtn = Instance.new("TextButton")
ShowBtn.Size = UDim2.new(0,160,0,40)
ShowBtn.Position = UDim2.new(0, 18, 0, 18)
ShowBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
ShowBtn.TextColor3 = Color3.fromRGB(240,240,240)
ShowBtn.Font = Enum.Font.GothamBold
ShowBtn.TextSize = 16
ShowBtn.Text = "RiooHub - Fish It" -- tulisan Show menu diganti
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

print("✅ RiooHub simple loaded (Minimize + Close Script, Delta-friendly)")