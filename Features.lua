local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- Hapus UI lama
if PlayerGui:FindFirstChild("TestDragUI") then
	PlayerGui.TestDragUI:Destroy()
end

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "TestDragUI"

-- MainFrame tanpa AnchorPoint 0,0
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0,400,0,300)
MainFrame.Position = UDim2.new(0.3,0,0.3,0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
Instance.new("UICorner", MainFrame)

-- TitleBar
local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Size = UDim2.new(1,0,0,30)
TitleBar.BackgroundColor3 = Color3.fromRGB(35,35,35)

-- Drag system pakai AbsolutePosition
local dragging = false
local dragStart = Vector2.new()
local frameStart = Vector2.new()

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