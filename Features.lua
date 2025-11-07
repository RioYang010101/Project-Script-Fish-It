--[[
==================================================================================
 RiooHub - Fish It
 Versi: 1.0.0
 Gaya: Modern Sidebar (Mirip Rayfield)
 Dibuat oleh Rio Yang
==================================================================================
--]]

if game.CoreGui:FindFirstChild("RiooHubUI") then
	game.CoreGui.RiooHubUI:Destroy()
end

local TweenService = game:GetService("TweenService")

local gui = Instance.new("ScreenGui")
gui.Name = "RiooHubUI"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

local minimized = false

-- Frame utama
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 550, 0, 340)
main.Position = UDim2.new(0.5, -275, 0.5, -170)
main.BackgroundColor3 = Color3.fromRGB(22, 25, 35)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

-- Header
local topbar = Instance.new("Frame")
topbar.Size = UDim2.new(1, 0, 0, 36)
topbar.BackgroundColor3 = Color3.fromRGB(30, 35, 50)
topbar.BorderSizePixel = 0
topbar.Parent = main

local title = Instance.new("TextLabel")
title.Text = "RiooHub - Fish It"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topbar

local minimize = Instance.new("TextButton")
minimize.Text = "-"
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 22
minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
minimize.Size = UDim2.new(0, 40, 1, 0)
minimize.Position = UDim2.new(1, -40, 0, 0)
minimize.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
minimize.Parent = topbar

-- Sidebar kiri
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 140, 1, -36)
sidebar.Position = UDim2.new(0, 0, 0, 36)
sidebar.BackgroundColor3 = Color3.fromRGB(30, 35, 50)
sidebar.BorderSizePixel = 0
sidebar.Parent = main

-- Container isi tab (kanan)
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -140, 1, -36)
content.Position = UDim2.new(0, 140, 0, 36)
content.BackgroundColor3 = Color3.fromRGB(25, 28, 40)
content.BorderSizePixel = 0
content.ClipsDescendants = true
content.Parent = main

-- Tombol reopen
local reopen = Instance.new("TextButton")
reopen.Text = "RiooHub - Fish It"
reopen.Font = Enum.Font.GothamBold
reopen.TextSize = 14
reopen.TextColor3 = Color3.fromRGB(255, 255, 255)
reopen.Size = UDim2.new(0, 180, 0, 40)
reopen.Position = UDim2.new(0, 20, 1, -60)
reopen.BackgroundColor3 = Color3.fromRGB(35, 40, 60)
reopen.Visible = false
reopen.Parent = gui

-- Fungsi untuk buat konten tab
local function createTabContent(name, text)
	local frame = Instance.new("Frame")
	frame.Name = name
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.BackgroundTransparency = 1
	frame.Visible = false
	frame.Parent = content

	local label = Instance.new("TextLabel")
	label.Text = text
	label.Font = Enum.Font.GothamSemibold
	label.TextSize = 20
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.BackgroundTransparency = 1
	label.Position = UDim2.new(0, 20, 0, 20)
	label.Size = UDim2.new(1, -40, 0, 30)
	label.Parent = frame

	return frame
end

-- Buat isi dummy per-tab
local pages = {
	Home = createTabContent("Home", "Selamat datang di RiooHub - Fish It!"),
	Auto = createTabContent("Auto", "Fitur otomatisasi (contoh: Auto Fish)"),
	Shop = createTabContent("Shop", "Menu belanja item (coming soon)"),
	Settings = createTabContent("Settings", "Pengaturan UI dan preferensi")
}

-- Fungsi buka tab dengan animasi
local currentTab = nil
local function openTab(name)
	if currentTab == name then return end
	for _, frame in pairs(pages) do
		if frame.Visible then
			TweenService:Create(frame, TweenInfo.new(0.25), {Position = UDim2.new(0.1, 0, 0, 0), BackgroundTransparency = 1}):Play()
			wait(0.1)
			frame.Visible = false
		end
	end

	local newTab = pages[name]
	if newTab then
		newTab.Visible = true
		newTab.BackgroundTransparency = 1
		newTab.Position = UDim2.new(0.1, 0, 0, 0)
		TweenService:Create(newTab, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
			BackgroundTransparency = 0,
			Position = UDim2.new(0, 0, 0, 0)
		}):Play()
		currentTab = name
	end
end

-- Buat tombol sidebar
local yPos = 10
for _, name in ipairs({"Home", "Auto", "Shop", "Settings"}) do
	local btn = Instance.new("TextButton")
	btn.Text = name
	btn.Font = Enum.Font.GothamSemibold
	btn.TextSize = 15
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Size = UDim2.new(1, -20, 0, 32)
	btn.Position = UDim2.new(0, 10, 0, yPos)
	btn.BackgroundColor3 = Color3.fromRGB(45, 50, 70)
	btn.AutoButtonColor = false
	btn.Parent = sidebar

	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(55, 60, 85)}):Play()
	end)

	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(45, 50, 70)}):Play()
	end)

	btn.MouseButton1Click:Connect(function()
		openTab(name)
	end)

	yPos = yPos + 38
end

-- Default tab
openTab("Home")

-- Minimize / Reopen logic
minimize.MouseButton1Click:Connect(function()
	minimized = not minimized
	main.Visible = not minimized
	reopen.Visible = minimized
end)

reopen.MouseButton1Click:Connect(function()
	minimized = false
	main.Visible = true
	reopen.Visible = false
end)