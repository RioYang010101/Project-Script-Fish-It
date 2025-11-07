--[[
============================================================
RiooHub - Roblox Script Template (Full Project Base)
Versi: 1.0
Fitur:
- Custom UI (draggable, tab, section)
- Sistem Key/Authorization
- Auto action hooks (placeholder)
- Webhook integration (placeholder)
============================================================
--]]

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- =======================
-- [UI Setup]
-- =======================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RiooHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Active = true
MainFrame.Draggable = true -- dragable

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

-- Tabs container
local TabsFrame = Instance.new("Frame")
TabsFrame.Size = UDim2.new(1, 0, 1, -40)
TabsFrame.Position = UDim2.new(0, 0, 0, 40)
TabsFrame.BackgroundTransparency = 1
TabsFrame.Parent = MainFrame

-- Example Tab Button
local TabButton = Instance.new("TextButton")
TabButton.Size = UDim2.new(0, 100, 0, 30)
TabButton.Position = UDim2.new(0, 10, 0, 10)
TabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TabButton.Text = "Auto Farm"
TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TabButton.Parent = TabsFrame

-- Tab Content Frame
local TabContent = Instance.new("Frame")
TabContent.Size = UDim2.new(1, -20, 1, -50)
TabContent.Position = UDim2.new(0, 10, 0, 50)
TabContent.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TabContent.BorderSizePixel = 0
TabContent.Parent = TabsFrame

-- Example toggle inside Tab
local AutoFarmToggle = Instance.new("TextButton")
AutoFarmToggle.Size = UDim2.new(0, 150, 0, 30)
AutoFarmToggle.Position = UDim2.new(0, 10, 0, 10)
AutoFarmToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
AutoFarmToggle.Text = "Auto Farm: OFF"
AutoFarmToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoFarmToggle.Parent = TabContent

local AutoFarmEnabled = false
AutoFarmToggle.MouseButton1Click:Connect(function()
    AutoFarmEnabled = not AutoFarmEnabled
    AutoFarmToggle.Text = "Auto Farm: " .. (AutoFarmEnabled and "ON" or "OFF")
end)

-- =======================
-- [Webhook Placeholder]
-- =======================
local WebhookURL = "PASTE_WEBHOOK_HERE"
local function SendWebhook(msg)
    -- placeholder function
    print("[Webhook] "..msg)
end

-- =======================
-- [Key System Placeholder]
-- =======================
local Key = "RIOO123" -- contoh key
local function CheckKey(inputKey)
    return inputKey == Key
end

-- =======================
-- [Auto Action Placeholder]
-- =======================
RunService.RenderStepped:Connect(function()
    if AutoFarmEnabled then
        -- contoh: print setiap frame, nanti diganti action game
        print("Auto action running...")
    end
end)

print("RiooHub Template Loaded Successfully!")