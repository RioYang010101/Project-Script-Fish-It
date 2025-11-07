--[[
==================================================================================
 RiooHub - Fish It (Custom UI v1.0.0)
 Gaya: Modern (Mirip Rayfield, tapi 100% manual)
 Dibuat oleh Rio Yang
==================================================================================
--]]

-- Pastikan GUI lama dihapus dulu
if game.CoreGui:FindFirstChild("RiooHubUI") then
	game.CoreGui.RiooHubUI:Destroy()
end

-- Buat ScreenGui utama
local gui = Instance.new("ScreenGui")
gui.Name = "RiooHubUI"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

-- Variabel untuk show/hide
local minimized = false

-- Frame utama
local main = Instance.new("Frame")
main.Name = "MainFrame"
main.Size = UDim2.new(0, 450, 0, 320)
main.Position = UDim2.new(0.5, -225, 0.5, -160)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
main.BorderSizePixel = 0
main.BackgroundTransparency = 0.05
main.Active = true
main.Draggable = true
main.Parent = gui

-- Shadow
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.5
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(0, -10, 0, -10)
shadow.BackgroundTransparency = 1
shadow.Parent = main

-- Title bar
local topbar = Instance.new("Frame")
topbar.Size = UDim2.new(1, 0, 0, 36)
topbar.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
topbar.BorderSizePixel = 0
topbar.Parent = main

-- Title text
local title = Instance.new("TextLabel")
title.Text = "RiooHub - Fish It"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topbar

-- Tombol minimize
local minimize = Instance.new("TextButton")
minimize.Text = "-"
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 22
minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
minimize.Size = UDim2.new(0, 40, 1, 0)
minimize.Position = UDim2.new(1, -40, 0, 0)
minimize.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
minimize.Parent = topbar

-- Tab container
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, -20, 0, 30)
tabFrame.Position = UDim2.new(0, 10, 0, 46)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = main

-- Contoh tombol tab
local tabs = {"Home", "Auto", "Shop", "Settings"}
for i, name in ipairs(tabs) do
	local tab = Instance.new("TextButton")
	tab.Text = name
	tab.Font = Enum.Font.GothamSemibold
	tab.TextSize = 14
	tab.TextColor3 = Color3.fromRGB(255, 255, 255)
	tab.Size = UDim2.new(0, 90, 1, 0)
	tab.Position = UDim2.new(0, (i - 1) * 95, 0, 0)
	tab.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
	tab.Parent = tabFrame
end

-- Tombol untuk membuka lagi saat minimize
local reopenBtn = Instance.new("TextButton")
reopenBtn.Text = "RiooHub - Fish It"
reopenBtn.Font = Enum.Font.GothamBold
reopenBtn.TextSize = 14
reopenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
reopenBtn.Size = UDim2.new(0, 150, 0, 36)
reopenBtn.Position = UDim2.new(0, 20, 1, -60)
reopenBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
reopenBtn.Visible = false
reopenBtn.Parent = gui

-- Fungsi minimize & reopen
minimize.MouseButton1Click:Connect(function()
	minimized = not minimized
	main.Visible = not minimized
	reopenBtn.Visible = minimized
end)

reopenBtn.MouseButton1Click:Connect(function()
	minimized = false
	main.Visible = true
	reopenBtn.Visible = false
end)