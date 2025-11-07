--[[
==============================================================
 RiooHub - Fish It | Sidebar + Fade + Drag
 By Rio Yang
 Style: Modern Rayfield Blue
==============================================================
--]]

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "RiooHubUI"
gui.ResetOnSpawn = false

--------------------------------------------------------------
-- 🔧 DRAG FUNCTION
--------------------------------------------------------------
local function makeDraggable(frame, dragArea)
	local UIS = game:GetService("UserInputService")
	local dragging, dragStart, startPos
	dragArea = dragArea or frame

	dragArea.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
		end
	end)

	dragArea.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
									   startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

--------------------------------------------------------------
-- 🪟 MAIN UI
--------------------------------------------------------------
local Main = Instance.new("Frame", gui)
Main.Size = UDim2.new(0, 600, 0, 350)
Main.Position = UDim2.new(0.35, 0, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(25, 35, 55)
Main.BackgroundTransparency = 0.1
Main.BorderSizePixel = 0
Main.Visible = true

local MainCorner = Instance.new("UICorner", Main)
MainCorner.CornerRadius = UDim.new(0, 12)

--------------------------------------------------------------
-- 🔵 HEADER
--------------------------------------------------------------
local Header = Instance.new("TextLabel", Main)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(35, 50, 80)
Header.Text = "RiooHub - Fish It"
Header.TextColor3 = Color3.fromRGB(255, 255, 255)
Header.TextSize = 20
Header.Font = Enum.Font.GothamBold
Header.BackgroundTransparency = 0.05
Header.Active = true

local HeaderCorner = Instance.new("UICorner", Header)
HeaderCorner.CornerRadius = UDim.new(0, 12)

makeDraggable(Main, Header)

--------------------------------------------------------------
-- 📜 SIDEBAR
--------------------------------------------------------------
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 140, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(30, 45, 70)
Sidebar.BackgroundTransparency = 0.05
Sidebar.BorderSizePixel = 0

local SidebarCorner = Instance.new("UICorner", Sidebar)
SidebarCorner.CornerRadius = UDim.new(0, 12)

--------------------------------------------------------------
-- 🧩 CONTENT
--------------------------------------------------------------
local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -150, 1, -50)
Content.Position = UDim2.new(0, 150, 0, 45)
Content.BackgroundColor3 = Color3.fromRGB(20, 30, 50)
Content.BackgroundTransparency = 0.15
Content.BorderSizePixel = 0

local ContentCorner = Instance.new("UICorner", Content)
ContentCorner.CornerRadius = UDim.new(0, 12)

--------------------------------------------------------------
-- 🏷️ TAB BUTTONS
--------------------------------------------------------------
local Tabs = {"Home", "Auto", "Shop", "Settings"}
local Buttons = {}

for i, name in ipairs(Tabs) do
	local btn = Instance.new("TextButton", Sidebar)
	btn.Size = UDim2.new(1, -20, 0, 40)
	btn.Position = UDim2.new(0, 10, 0, (i - 1) * 45 + 10)
	btn.Text = name
	btn.BackgroundColor3 = Color3.fromRGB(45, 65, 100)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextSize = 16
	btn.Font = Enum.Font.Gotham

	local btnCorner = Instance.new("UICorner", btn)
	btnCorner.CornerRadius = UDim.new(0, 8)

	btn.MouseButton1Click:Connect(function()
		for _, b in ipairs(Buttons) do
			b.BackgroundColor3 = Color3.fromRGB(45, 65, 100)
		end
		btn.BackgroundColor3 = Color3.fromRGB(65, 95, 145)

		for _, child in ipairs(Content:GetChildren()) do
			child:Destroy()
		end

		local label = Instance.new("TextLabel", Content)
		label.BackgroundTransparency = 1
		label.Size = UDim2.new(1, 0, 1, 0)
		label.Font = Enum.Font.GothamSemibold
		label.TextSize = 20
		label.TextColor3 = Color3.fromRGB(255, 255, 255)
		label.Text = "Kamu membuka tab: " .. name
	end)

	table.insert(Buttons, btn)
end

--------------------------------------------------------------
-- 🎛️ LAUNCHER BUTTON (POJOK KIRI ATAS)
--------------------------------------------------------------
local TweenService = game:GetService("TweenService")

local ToggleBtn = Instance.new("TextButton", gui)
ToggleBtn.Size = UDim2.new(0, 200, 0, 40)
ToggleBtn.Position = UDim2.new(0.02, 0, 0.05, 0)
ToggleBtn.Text = "RiooHub - Fish It"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 55, 95)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 17
ToggleBtn.Active = true

local ToggleCorner = Instance.new("UICorner", ToggleBtn)
ToggleCorner.CornerRadius = UDim.new(0, 10)

makeDraggable(ToggleBtn)

--------------------------------------------------------------
-- ✨ SHOW/HIDE DENGAN FADE
--------------------------------------------------------------
local visible = true
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

ToggleBtn.MouseButton1Click:Connect(function()
	visible = not visible

	if visible then
		Main.Visible = true
		Main.BackgroundTransparency = 1
		for _, obj in ipairs(Main:GetDescendants()) do
			if obj:IsA("GuiObject") then
				obj.BackgroundTransparency = 1
				obj.TextTransparency = 1
			end
		end
		TweenService:Create(Main, tweenInfo, {BackgroundTransparency = 0.1}):Play()
		for _, obj in ipairs(Main:GetDescendants()) do
			if obj:IsA("GuiObject") then
				TweenService:Create(obj, tweenInfo, {BackgroundTransparency = obj.BackgroundTransparency - 0.1, TextTransparency = 0}):Play()
			end
		end
	else
		local fadeOut = TweenService:Create(Main, tweenInfo, {BackgroundTransparency = 1})
		fadeOut:Play()
		fadeOut.Completed:Wait()
		Main.Visible = false
	end
end)

print("✅ RiooHub - Fish It (Fade + Drag) Loaded!")