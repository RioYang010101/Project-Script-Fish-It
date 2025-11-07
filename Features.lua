-- Delta Executor friendly UI (tested)
local CoreGui = game:GetService("CoreGui")

-- ScreenGui wajib untuk Delta
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RiooHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- =======================
-- Main Frame
-- =======================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.BorderSizePixel = 0
Title.Text = "RiooHub Template"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Title.Parent = MainFrame

-- =======================
-- Open/Close Menu Button
-- =======================
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 120, 0, 40)
ToggleButton.Position = UDim2.new(0, 20, 0, 20)
ToggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Text = "Close Menu"
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 18
ToggleButton.Parent = ScreenGui -- penting: parent ScreenGui, bukan MainFrame

local UIVisible = true
ToggleButton.MouseButton1Click:Connect(function()
    UIVisible = not UIVisible
    MainFrame.Visible = UIVisible
    ToggleButton.Text = UIVisible and "Close Menu" or "Open Menu"
end)

-- =======================
-- Contoh Toggle di MainFrame
-- =======================
local AutoFarmToggle = Instance.new("TextButton")
AutoFarmToggle.Size = UDim2.new(0, 150, 0, 30)
AutoFarmToggle.Position = UDim2.new(0, 20, 0, 60)
AutoFarmToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
AutoFarmToggle.Text = "Auto Farm: OFF"
AutoFarmToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoFarmToggle.Parent = MainFrame

local AutoFarmEnabled = false
AutoFarmToggle.MouseButton1Click:Connect(function()
    AutoFarmEnabled = not AutoFarmEnabled
    AutoFarmToggle.Text = "Auto Farm: " .. (AutoFarmEnabled and "ON" or "OFF")
end)

print("✅ Delta Executor UI Loaded! MainFrame + Open/Close Menu Button harus muncul sekarang.")