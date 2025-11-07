local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("RiooHubUI") then
	PlayerGui.RiooHubUI:Destroy()
end

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RiooHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Show Button
local ShowButton = Instance.new("TextButton")
ShowButton.Size = UDim2.new(0,200,0,40)
ShowButton.Position = UDim2.new(0.5,0,0,10)
ShowButton.AnchorPoint = Vector2.new(0.5,0)
ShowButton.Text = "RiooHub - Fish It"
ShowButton.BackgroundColor3 = Color3.fromRGB(30,30,30)
ShowButton.TextColor3 = Color3.fromRGB(255,255,255)
ShowButton.Parent = ScreenGui

-- MainFrame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0,500,0,350)
MainFrame.Position = UDim2.new(0.5,0,0.5,0)
MainFrame.AnchorPoint = Vector2.new(0.5,0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame)

-- TitleBar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1,0,0,35)
TitleBar.BackgroundColor3 = Color3.fromRGB(35,35,35)
TitleBar.Parent = MainFrame

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1,0,1,0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "RiooHub - Fish It"
TitleText.TextColor3 = Color3.fromRGB(255,255,255)
TitleText.Parent = TitleBar

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0,130,1,-35)
Sidebar.Position = UDim2.new(0,0,0,35)
Sidebar.BackgroundColor3 = Color3.fromRGB(35,35,35)
Sidebar.Parent = MainFrame

-- Content
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1,-130,1,-35)
ContentFrame.Position = UDim2.new(0,130,0,35)
ContentFrame.BackgroundColor3 = Color3.fromRGB(45,45,45)
ContentFrame.Parent = MainFrame

-- Tab
local Tabs = {}
local function CreateTab(name)
	local Button = Instance.new("TextButton")
	Button.Size = UDim2.new(1,-10,0,35)
	Button.Position = UDim2.new(0,5,0,(#Sidebar:GetChildren()-1)*40)
	Button.BackgroundColor3 = Color3.fromRGB(50,50,50)
	Button.Text = name
	Button.TextColor3 = Color3.fromRGB(255,255,255)
	Button.Parent = Sidebar

	local TabFrame = Instance.new("Frame")
	TabFrame.Size = UDim2.new(1,0,1,0)
	TabFrame.BackgroundTransparency = 1
	TabFrame.Visible = false
	TabFrame.Parent = ContentFrame

	Button.MouseButton1Click:Connect(function()
		for _,t in pairs(Tabs) do t.Visible = false end
		TabFrame.Visible = true
	end)

	table.insert(Tabs, TabFrame)
	return TabFrame
end

local AutoTab = CreateTab("Auto")
local SettingsTab = CreateTab("Settings")
Tabs[1].Visible = true

-- Show/hide
local UIVisible = false
local tweenInfo = TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
ShowButton.MouseButton1Click:Connect(function()
	if UIVisible then
		UIVisible=false
		local tween=TweenService:Create(MainFrame,tweenInfo,{Position=UDim2.new(0.5,0,0.45,0),BackgroundTransparency=1})
		tween:Play()
		tween.Completed:Wait()
		MainFrame.Visible=false
	else
		UIVisible=true
		MainFrame.Visible=true
		MainFrame.Position=UDim2.new(0.5,0,0.45,0)
		MainFrame.BackgroundTransparency=1
		TweenService:Create(MainFrame,tweenInfo,{Position=UDim2.new(0.5,0,0.5,0),BackgroundTransparency=0}):Play()
	end
end)

-- DRAG (pasti jalan)
local dragging=false
local dragStart=Vector2.new()
local frameStart=Vector2.new()
TitleBar.InputBegan:Connect(function(input)
	if input.UserInputType==Enum.UserInputType.MouseButton1 then
		dragging=true
		dragStart=input.Position
		frameStart=Vector2.new(MainFrame.Position.X.Offset,MainFrame.Position.Y.Offset)
	end
end)
TitleBar.InputEnded:Connect(function(input)
	if input.UserInputType==Enum.UserInputType.MouseButton1 then
		dragging=false
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType==Enum.UserInputType.MouseMovement then
		local delta=input.Position-dragStart
		MainFrame.Position=UDim2.new(0,frameStart.X+delta.X,0,frameStart.Y+delta.Y)
	end
end)