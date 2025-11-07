--[[
========================================================
 RiooHub - Fish It (v1.2)
 UI Custom mirip Rayfield, full tanpa library.
========================================================
]]

-- Layanan Roblox
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- PlayerGui
local player = game.Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- Hapus UI lama kalau ada
if PlayerGui:FindFirstChild("RiooHubUI") then
	PlayerGui.RiooHubUI:Destroy()
end

-- Buat ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RiooHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Tombol Show Menu (atas tengah)
local ShowButton = Instance.new("TextButton")
ShowButton.Name = "ShowButton"
ShowButton.Size = UDim2.new(0, 200, 0, 40)
ShowButton.Position = UDim2.new(0.5, 0, 0, 10)
ShowButton.AnchorPoint = Vector2.new(0.5, 0)
ShowButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ShowButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ShowButton.Font = Enum.Font.GothamBold
ShowButton.TextSize = 16
ShowButton.Text = "RiooHub - Fish It"
ShowButton.Parent = ScreenGui
ShowButton.AutoButtonColor = true
ShowButton.ZIndex = 2
ShowButton.BorderSizePixel = 0
ShowButton.Visible = true
ShowButton.Active = true

-- Frame utama
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

-- UI Corner + Shadow
local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 12)

local Shadow = Instance.new("ImageLabel", MainFrame)
Shadow.Image = "rbxassetid://1316045217"
Shadow.ImageTransparency = 0.5
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
Shadow.Size = UDim2.new(1, 20, 1, 20)
Shadow.Position = UDim2.new(0, -10, 0, -10)
Shadow.ZIndex = 0
Shadow.BackgroundTransparency = 1

-- === TITLEBAR UNTUK DRAG ===
local DragBar = Instance.new("Frame")
DragBar.Name = "DragBar"
DragBar.Size = UDim2.new(1, 0, 0, 35)
DragBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
DragBar.BorderSizePixel = 0
DragBar.Parent = MainFrame
DragBar.ZIndex = 3

local DragText = Instance.new("TextLabel")
DragText.Size = UDim2.new(1, 0, 1, 0)
DragText.BackgroundTransparency = 1
DragText.Text = "RiooHub - Fish It"
DragText.Font = Enum.Font.GothamBold
DragText.TextSize = 16
DragText.TextColor3 = Color3.fromRGB(255, 255, 255)
DragText.Parent = DragBar

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 150, 1, -35)
Sidebar.Position = UDim2.new(0, 0, 0, 35)
Sidebar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner", Sidebar)
SidebarCorner.CornerRadius = UDim.new(0, 12)

-- Container isi tab
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -150, 1, -35)
ContentFrame.Position = UDim2.new(0, 150, 0, 35)
ContentFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = MainFrame

-- Fungsi buat bikin tab
local Tabs = {}
local function CreateTab(name)
	local Button = Instance.new("TextButton")
	Button.Size = UDim2.new(1, -20, 0, 40)
	Button.Position = UDim2.new(0, 10, 0, (#Sidebar:GetChildren() - 1) * 45)
	Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	Button.TextColor3 = Color3.fromRGB(255, 255, 255)
	Button.Font = Enum.Font.GothamBold
	Button.TextSize = 14
	Button.Text = name
	Button.Parent = Sidebar

	local TabFrame = Instance.new("Frame")
	TabFrame.Size = UDim2.new(1, 0, 1, 0)
	TabFrame.BackgroundTransparency = 1
	TabFrame.Visible = false
	TabFrame.Parent = ContentFrame

	Button.MouseButton1Click:Connect(function()
		for _, tab in pairs(Tabs) do
			tab.Visible = false
		end
		TabFrame.Visible = true
	end)

	table.insert(Tabs, TabFrame)
	return TabFrame
end

-- Contoh Tab
local AutoTab = CreateTab("Auto")
local SettingsTab = CreateTab("Settings")

-- Isi Tab Auto
local AutoLabel = Instance.new("TextLabel")
AutoLabel.Size = UDim2.new(1, -20, 0, 30)
AutoLabel.Position = UDim2.new(0, 10, 0, 10)
AutoLabel.BackgroundTransparency = 1
AutoLabel.Text = "Auto Tab Content"
AutoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoLabel.TextSize = 14
AutoLabel.Font = Enum.Font.Gotham
AutoLabel.Parent = AutoTab

-- Default Tab yang tampil
Tabs[1].Visible = true

-- === Animasi Show / Hide ===
local UIVisible = false
local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function ShowUI()
	UIVisible = true
	MainFrame.Visible = true
	MainFrame.Position = UDim2.new(0.5, 0, 0.4, 0)
	MainFrame.BackgroundTransparency = 1
	TweenService:Create(MainFrame, tweenInfo, {
		Position = UDim2.new(0.5, 0, 0.5, 0),
		BackgroundTransparency = 0
	}):Play()
end

local function HideUI()
	UIVisible = false
	TweenService:Create(MainFrame, tweenInfo, {
		Position = UDim2.new(0.5, 0, 0.4, 0),
		BackgroundTransparency = 1
	}):Play()
	task.wait(0.4)
	MainFrame.Visible = false
end

ShowButton.MouseButton1Click:Connect(function()
	if UIVisible then
		HideUI()
	else
		ShowUI()
	end
end)

-- === DRAG SYSTEM (FIXED TITLEBAR) ===
local dragging, dragInput, dragStart, startPos

local function update(input)
	local delta = input.Position - dragStart
	MainFrame.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

DragBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

DragBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)