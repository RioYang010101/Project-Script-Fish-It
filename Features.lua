-- Services
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RiooHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- =======================
-- [Main Frame]
-- =======================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Active = true
MainFrame.Draggable = true

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.BorderSizePixel = 0
Title.Text = "RiooHub Template"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Title.Parent = MainFrame

-- =======================
-- [Show/Hide Button Terpisah]
-- =======================
local ShowHideButton = Instance.new("TextButton")
ShowHideButton.Size = UDim2.new(0, 80, 0, 30)
ShowHideButton.Position = UDim2.new(0, 10, 0, 10) -- di pojok kiri atas layar
ShowHideButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
ShowHideButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ShowHideButton.Text = "Hide"
ShowHideButton.Parent = ScreenGui

local UIVisible = true
ShowHideButton.MouseButton1Click:Connect(function()
    UIVisible = not UIVisible
    MainFrame.Visible = UIVisible
    ShowHideButton.Text = UIVisible and "Hide" or "Show"
end)

-- =======================
-- [Contoh Toggle di MainFrame]
-- =======================
local AutoFarmToggle = Instance.new("TextButton")
AutoFarmToggle.Size = UDim2.new(0, 150, 0, 30)
AutoFarmToggle.Position = UDim2.new(0, 10, 0, 50)
AutoFarmToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
AutoFarmToggle.Text = "Auto Farm: OFF"
AutoFarmToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoFarmToggle.Parent = MainFrame

local AutoFarmEnabled = false
AutoFarmToggle.MouseButton1Click:Connect(function()
    AutoFarmEnabled = not AutoFarmEnabled
    AutoFarmToggle.Text = "Auto Farm: " .. (AutoFarmEnabled and "ON" or "OFF")
end)

print("RiooHub Template with Show/Hide Button Loaded Successfully!")