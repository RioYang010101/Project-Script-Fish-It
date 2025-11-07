--[[
==============================================================
 RiooHub - Fish It | Modern Sidebar UI (Dummy Version)
 By Rio Yang
 Style: Rayfield Blue Theme, Sidebar Left, Animated Tabs
==============================================================
--]]

-- GUI Setup
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "RiooHubUI"
gui.ResetOnSpawn = false

-- Main Frame
local Main = Instance.new("Frame", gui)
Main.Size = UDim2.new(0, 600, 0, 350)
Main.Position = UDim2.new(0.5, -300, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(25, 35, 55)
Main.BackgroundTransparency = 0.1
Main.BorderSizePixel = 0
Main.Visible = true

-- Corner
local MainCorner = Instance.new("UICorner", Main)
MainCorner.CornerRadius = UDim.new(0, 12)

-- Header
local Header = Instance.new("TextLabel", Main)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(35, 50, 80)
Header.Text = "RiooHub - Fish It"
Header.TextColor3 = Color3.fromRGB(255, 255, 255)
Header.TextSize = 20
Header.Font = Enum.Font.GothamBold
Header.BackgroundTransparency = 0.05

local HeaderCorner = Instance.new("UICorner", Header)
HeaderCorner.CornerRadius = UDim.new(0, 12)

-- Sidebar
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 140, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(30, 45, 70)
Sidebar.BackgroundTransparency = 0.05
Sidebar.BorderSizePixel = 0

local SidebarCorner = Instance.new("UICorner", Sidebar)
SidebarCorner.CornerRadius = UDim.new(0, 12)

-- Content Frame
local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -150, 1, -50)
Content.Position = UDim2.new(0, 150, 0, 45)
Content.BackgroundColor3 = Color3.fromRGB(20, 30, 50)
Content.BackgroundTransparency = 0.15
Content.BorderSizePixel = 0

local ContentCorner = Instance.new("UICorner", Content)
ContentCorner.CornerRadius = UDim.new(0, 12)

-- Tab Buttons
local Tabs = {"Home", "Auto", "Shop", "Settings"}
local Buttons = {}
local ActiveTab = nil

for i, name in ipairs(Tabs) do
	local btn = Instance.new("TextButton", Sidebar)
	btn.Size = UDim2.new(1, -20, 0, 40)
	btn.Position = UDim2.new(0, 10, 0, (i - 1) * 45 + 10)
	btn.Text = name
	btn.BackgroundColor3 = Color3.fromRGB(45, 65, 100)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextSize = 16
	btn.Font = Enum.Font.Gotham
	btn.AutoButtonColor = true
	btn.BackgroundTransparency = 0.15

	local btnCorner = Instance.new("UICorner", btn)
	btnCorner.CornerRadius = UDim.new(0, 8)

	btn.MouseButton1Click:Connect(function()
		for _, other in ipairs(Buttons) do
			other.BackgroundColor3 = Color3.fromRGB(45, 65, 100)
		end
		btn.BackgroundColor3 = Color3.fromRGB(65, 95, 145)
		ActiveTab = name

		-- Ganti isi konten
		for _, child in ipairs(Content:GetChildren()) do
			child:Destroy()
		end

		local label = Instance.new("TextLabel", Content)
		label.Size = UDim2.new(1, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.Text = "Kamu membuka tab: " .. name
		label.TextColor3 = Color3.fromRGB(255, 255, 255)
		label.TextSize = 20
		label.Font = Enum.Font.GothamSemibold
		label.TextTransparency = 1

		-- Animasi masuk
		label:TweenPosition(UDim2.new(0, 0, 0, 0), "Out", "Sine", 0.2, true)
		game:GetService("TweenService"):Create(label, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
	end)

	table.insert(Buttons, btn)
end

-- Tombol untuk hide/show UI
local ToggleBtn = Instance.new("TextButton", gui)
ToggleBtn.Size = UDim2.new(0, 200, 0, 40)
ToggleBtn.Position = UDim2.new(0.5, -100, 1, -60)
ToggleBtn.Text = "RiooHub - Fish It"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 55, 95)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 18
ToggleBtn.AutoButtonColor = true
ToggleBtn.BackgroundTransparency = 0.1

local ToggleCorner = Instance.new("UICorner", ToggleBtn)
ToggleCorner.CornerRadius = UDim.new(0, 10)

local visible = true
ToggleBtn.MouseButton1Click:Connect(function()
	visible = not visible
	Main.Visible = visible
end)

print("✅ RiooHub - Fish It UI berhasil dimuat!")