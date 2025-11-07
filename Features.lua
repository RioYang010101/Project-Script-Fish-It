--[[
========================================================
 RiooHub - Fish It (v1.6)
 UI Custom mirip Rayfield, drag fix & tab proporsional ✅
========================================================
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- Hapus UI lama
if PlayerGui:FindFirstChild("RiooHubUI") then
	PlayerGui.RiooHubUI:Destroy()
end

-- ScreenGui utama
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RiooHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

-- Tombol Show Menu (atas tengah)
local ShowButton = Instance.new("TextButton")
ShowButton.Size = UDim2.new(0, 200, 0, 40)
ShowButton.Position = UDim2.new(0.5, 0, 0, 10)
ShowButton.AnchorPoint = Vector2.new(0.5, 0)
ShowButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ShowButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ShowButton.Font = Enum.Font.GothamBold
ShowButton.TextSize = 16
ShowButton.Text = "RiooHub - Fish It"
ShowButton.BorderSizePixel = 0
ShowButton.Parent = ScreenGui

-- Frame utama
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Visible = false
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

-- Title bar (buat drag)
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 10
TitleBar.Parent = MainFrame

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, 0, 1, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "RiooHub - Fish It"
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 16
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.ZIndex = 11
TitleText.Parent = TitleBar

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 150, 1, -35)
Sidebar.Position = UDim2.new(0, 0, 0, 35)
Sidebar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

-- Content area (proporsional)
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -160, 1, -50)
ContentFrame.Position = UDim2.new(0, 150, 0, 35)
ContentFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = MainFrame

-- Fungsi buat tab
local Tabs = {}
local function CreateTab(name)
	local Button = Instance.new("TextButton")
	Button.Size = UDim2.new(1, -20, 0, 35)
	Button.Position = UDim2.new(0, 10, 0, (#Sidebar:GetChildren() - 1) * 40)
	Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	Button.TextColor3 = Color3.fromRGB(255, 255, 255)
	Button.Font = Enum.Font.GothamBold
	Button.TextSize = 14
	Button.Text = name
	Button.BorderSizePixel = 0
	Button.Parent = Sidebar

	local TabFrame = Instance.new("Frame")
	TabFrame.Size = UDim2.new(1, 0, 1, 0)
	TabFrame.BackgroundTransparency = 1
	TabFrame.Visible = false
	TabFrame.Parent = ContentFrame

	Button.MouseButton1Click:Connect(function()
		for _, t in pairs(Tabs) do t.Visible = false end
		TabFrame.Visible = true
	end)

	table.insert(Tabs, TabFrame)
	return TabFrame
end

-- Contoh tab
local AutoTab = CreateTab("Auto")
local SettingsTab = CreateTab("Settings")

local AutoLabel = Instance.new("TextLabel")
AutoLabel.Size = UDim2.new(1, -20, 0, 30)
AutoLabel.Position = UDim2.new(0, 10, 0, 10)
AutoLabel.BackgroundTransparency = 1
AutoLabel.Text = "Auto Tab Content"
AutoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoLabel.TextSize = 14
AutoLabel.Font = Enum.Font.Gotham
AutoLabel.Parent = AutoTab

Tabs[1].Visible = true

-- Animasi show/hide
local UIVisible = false
local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function ShowUI()
	UIVisible = true
	MainFrame.Visible = true
	MainFrame.BackgroundTransparency = 1
	MainFrame.Position = UDim2.new(0.5, 0, 0.45, 0)
	TweenService:Create(MainFrame, tweenInfo, {
		Position = UDim2.new(0.5, 0, 0.5, 0),
		BackgroundTransparency = 0
	}):Play()
end

local function HideUI()
	UIVisible = false
	local tween = TweenService:Create(MainFrame, tweenInfo, {
		Position = UDim2.new(0.5, 0, 0.45, 0),
		BackgroundTransparency = 1
	})
	tween:Play()
	tween.Completed:Wait()
	MainFrame.Visible = false
end

ShowButton.MouseButton1Click:Connect(function()
	if UIVisible then HideUI() else ShowUI() end
end)

-- DRAG SYSTEM FIX (pakai offset murni, pasti jalan)
local dragging = false
local dragStart = Vector2.new()
local frameStart = Vector2.new()

TitleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		frameStart = Vector2.new(MainFrame.Position.X.Offset, MainFrame.Position.Y.Offset)
	end
end)

TitleBar.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(0, frameStart.X + delta.X, 0, frameStart.Y + delta.Y)
	end
end)