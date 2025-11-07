-- ====================
-- RiooHub - Fish It Hub (Standalone)
-- ====================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- ====================
-- GLOBAL VARIABLES
-- ====================
local autoFishingActive = false
local autoFishingDelay = 10
local fishingCompleteDelay = 2
local autoFishingLoop = nil
local autoSellActive = false
local autoSellThreshold = 30
local autoSellLoop = nil

-- Dummy RemoteEvents (ganti sesuai game kamu)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteChargeRod = ReplicatedStorage:WaitForChild("RF/ChargeFishingRod",1)
local RemoteRequestMinigame = ReplicatedStorage:WaitForChild("RF/RequestFishingMinigameStarted",1)
local RemoteFishingCompleted = ReplicatedStorage:WaitForChild("RE/FishingCompleted",1)
local RemoteSellAllItems = ReplicatedStorage:WaitForChild("RF/SellAllItems",1)

-- ====================
-- FUNCTIONS
-- ====================
local function GetFishCount()
    local count = 0
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, item in ipairs(backpack:GetChildren()) do
            if item:IsA("Tool") and string.match(string.lower(item.Name),"fish") then
                count +=1
            end
        end
    end
    return count
end

local function SellAllNow()
    if RemoteSellAllItems then
        pcall(function()
            RemoteSellAllItems:InvokeServer()
            print("[SellAll] Success")
        end)
    end
end

local function ToggleAutoSell(state)
    autoSellActive = state
    if autoSellActive then
        if autoSellLoop then autoSellLoop:Disconnect() end
        autoSellLoop = RunService.Heartbeat:Connect(function()
            if GetFishCount() >= autoSellThreshold then
                SellAllNow()
            end
        end)
    else
        if autoSellLoop then autoSellLoop:Disconnect(); autoSellLoop=nil end
    end
end

local function RunMasterFarm(state)
    autoFishingActive = state
    if autoFishingActive then
        if autoFishingLoop then autoFishingLoop:Disconnect() end
        autoFishingLoop = RunService.Heartbeat:Connect(function()
            if RemoteChargeRod then pcall(function() RemoteChargeRod:InvokeServer() end) end
            if RemoteRequestMinigame then pcall(function() RemoteRequestMinigame:InvokeServer(1) end) end
            if RemoteFishingCompleted then pcall(function() RemoteFishingCompleted:FireServer() end) end
            wait(fishingCompleteDelay)
        end)
    else
        if autoFishingLoop then autoFishingLoop:Disconnect(); autoFishingLoop=nil end
    end
end

-- ====================
-- UI CREATION
-- ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RiooHubGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainWindow"
MainFrame.Size = UDim2.new(0,500,0,400)
MainFrame.Position = UDim2.new(0.25,0,0.25,0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1,0,0,30)
TopBar.Position = UDim2.new(0,0,0,0)
TopBar.BackgroundColor3 = Color3.fromRGB(45,45,45)
TopBar.Parent = MainFrame

-- Title
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text = "RiooHub - Fish It"
TitleLabel.Size = UDim2.new(0.7,0,1,0)
TitleLabel.Position = UDim2.new(0,5,0,0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.fromRGB(255,255,255)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 18
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "X"
CloseBtn.Size = UDim2.new(0,30,1,0)
CloseBtn.Position = UDim2.new(0.95,0,0,0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
CloseBtn.TextColor3 = Color3.fromRGB(255,255,255)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 18
CloseBtn.Parent = TopBar

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ShowButton.Visible = true
end)

-- Minimize Button
local MinBtn = Instance.new("TextButton")
MinBtn.Text = "-"
MinBtn.Size = UDim2.new(0,30,1,0)
MinBtn.Position = UDim2.new(0.9,0,0,0)
MinBtn.BackgroundColor3 = Color3.fromRGB(100,100,100)
MinBtn.TextColor3 = Color3.fromRGB(255,255,255)
MinBtn.Font = Enum.Font.SourceSansBold
MinBtn.TextSize = 18
MinBtn.Parent = TopBar

MinBtn.MouseButton1Click:Connect(function()
    MainFrame.Size = UDim2.new(0,200,0,30)
end)

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0,150,1,-30)
Sidebar.Position = UDim2.new(0,0,0,30)
Sidebar.BackgroundColor3 = Color3.fromRGB(40,40,40)
Sidebar.Parent = MainFrame

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1,-150,1,-30)
ContentFrame.Position = UDim2.new(0,150,0,30)
ContentFrame.BackgroundColor3 = Color3.fromRGB(60,60,60)
ContentFrame.Parent = MainFrame

-- Sidebar Buttons
local buttons = {"Auto Fishing","Auto Sell","Teleport","Event","Player Config","Shop"}
local yPos = 0
for i, name in ipairs(buttons) do
    local btn = Instance.new("TextButton")
    btn.Text = name
    btn.Size = UDim2.new(1,0,0,40)
    btn.Position = UDim2.new(0,0,0,yPos)
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    btn.Parent = Sidebar
    yPos += 45

    btn.MouseButton1Click:Connect(function()
        ContentFrame:ClearAllChildren()
        local label = Instance.new("TextLabel")
        label.Text = "Content for "..name.." (Test)"
        label.Size = UDim2.new(1,0,1,0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255,255,255)
        label.Font = Enum.Font.SourceSansBold
        label.TextSize = 18
        label.Parent = ContentFrame
    end)
end

-- Show/Hide Button
local ShowButton = Instance.new("TextButton")
ShowButton.Text = "RiooHub - Fish It"
ShowButton.Size = UDim2.new(0,150,0,30)
ShowButton.Position = UDim2.new(0,20,0,50)
ShowButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
ShowButton.TextColor3 = Color3.fromRGB(255,255,255)
ShowButton.Font = Enum.Font.SourceSansBold
ShowButton.TextSize = 16
ShowButton.Parent = ScreenGui

ShowButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    ShowButton.Visible = false
end)