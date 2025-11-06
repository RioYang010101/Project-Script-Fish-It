-- RiooUI v1.2 (Dark Minimal, Draggable, Notify System)
local Rioo = {}
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

function Rioo:CreateWindow(config)
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "RiooUI"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = game:GetService("CoreGui")

	local Main = Instance.new("Frame")
	Main.Name = "Main"
	Main.Size = UDim2.new(0, 500, 0, 320)
	Main.Position = UDim2.new(0.5, -250, 0.5, -160)
	Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	Main.BorderSizePixel = 0
	Main.Active = true
	Main.Draggable = true
	Main.Parent = ScreenGui

	local UICorner = Instance.new("UICorner", Main)
	UICorner.CornerRadius = UDim.new(0, 8)

	local TitleBar = Instance.new("Frame")
	TitleBar.Size = UDim2.new(1, 0, 0, 35)
	TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	TitleBar.BorderSizePixel = 0
	TitleBar.Parent = Main

	local Title = Instance.new("TextLabel")
	Title.Size = UDim2.new(1, -10, 1, 0)
	Title.Position = UDim2.new(0, 10, 0, 0)
	Title.BackgroundTransparency = 1
	Title.Text = (config.Name or "Rioo Hub") .. (config.SubTitle and (" | " .. config.SubTitle) or "")
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.TextSize = 18
	Title.Font = Enum.Font.Roboto
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Parent = TitleBar

	local TabContainer = Instance.new("Frame")
	TabContainer.Size = UDim2.new(1, 0, 1, -35)
	TabContainer.Position = UDim2.new(0, 0, 0, 35)
	TabContainer.BackgroundTransparency = 1
	TabContainer.Parent = Main

	local Tabs = {}
	local ButtonsFrame = Instance.new("Frame")
	ButtonsFrame.Size = UDim2.new(0, 120, 1, 0)
	ButtonsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	ButtonsFrame.BorderSizePixel = 0
	ButtonsFrame.Parent = TabContainer

	local TabContent = Instance.new("Frame")
	TabContent.Size = UDim2.new(1, -120, 1, 0)
	TabContent.Position = UDim2.new(0, 120, 0, 0)
	TabContent.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	TabContent.BorderSizePixel = 0
	TabContent.Parent = TabContainer

	-- 🔔 Notify system
	local NotifyFrame = Instance.new("Frame")
	NotifyFrame.Size = UDim2.new(0, 250, 0, 40)
	NotifyFrame.Position = UDim2.new(0.5, -125, 0, -50)
	NotifyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	NotifyFrame.BorderSizePixel = 0
	NotifyFrame.Visible = false
	NotifyFrame.Parent = ScreenGui

	local NotifyCorner = Instance.new("UICorner", NotifyFrame)
	NotifyCorner.CornerRadius = UDim.new(0, 6)

	local NotifyLabel = Instance.new("TextLabel")
	NotifyLabel.Size = UDim2.new(1, -10, 1, 0)
	NotifyLabel.Position = UDim2.new(0, 5, 0, 0)
	NotifyLabel.BackgroundTransparency = 1
	NotifyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	NotifyLabel.TextSize = 16
	NotifyLabel.Font = Enum.Font.Roboto
	NotifyLabel.TextXAlignment = Enum.TextXAlignment.Center
	NotifyLabel.Parent = NotifyFrame

	function Rioo:Notify(text)
		NotifyLabel.Text = text
		NotifyFrame.Visible = true
		TweenService:Create(NotifyFrame, TweenInfo.new(0.2), {Position = UDim2.new(0.5, -125, 0.05, 0)}):Play()
		task.wait(2.5)
		TweenService:Create(NotifyFrame, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -125, 0, -50)}):Play()
		task.wait(0.3)
		NotifyFrame.Visible = false
	end

	function Rioo:CreateTab(tabName)
		local TabButton = Instance.new("TextButton")
		TabButton.Size = UDim2.new(1, 0, 0, 30)
		TabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
		TabButton.Text = tabName
		TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		TabButton.Font = Enum.Font.Roboto
		TabButton.TextSize = 16
		TabButton.BorderSizePixel = 0
		TabButton.Parent = ButtonsFrame

		local Page = Instance.new("ScrollingFrame")
		Page.Size = UDim2.new(1, 0, 1, 0)
		Page.BackgroundTransparency = 1
		Page.CanvasSize = UDim2.new(0, 0, 0, 0)
		Page.ScrollBarThickness = 3
		Page.Visible = false
		Page.Parent = TabContent

		local UIList = Instance.new("UIListLayout", Page)
		UIList.Padding = UDim.new(0, 6)
		UIList.FillDirection = Enum.FillDirection.Vertical
		UIList.SortOrder = Enum.SortOrder.LayoutOrder

		local UIPadding = Instance.new("UIPadding", Page)
		UIPadding.PaddingTop = UDim.new(0, 8)
		UIPadding.PaddingLeft = UDim.new(0, 8)

		local Tab = {}
		function Tab:CreateSection(title)
			local Label = Instance.new("TextLabel")
			Label.Text = "⟡ " .. title
			Label.Size = UDim2.new(1, -8, 0, 25)
			Label.BackgroundTransparency = 1
			Label.TextColor3 = Color3.fromRGB(170, 170, 170)
			Label.Font = Enum.Font.Roboto
			Label.TextSize = 15
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = Page

			local Section = {}
			function Section:CreateButton(text, callback)
				local Btn = Instance.new("TextButton")
				Btn.Size = UDim2.new(1, -8, 0, 30)
				Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
				Btn.Text = text
				Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
				Btn.Font = Enum.Font.Roboto
				Btn.TextSize = 16
				Btn.BorderSizePixel = 0
				Btn.Parent = Page

				local UIC = Instance.new("UICorner", Btn)
				UIC.CornerRadius = UDim.new(0, 4)

				Btn.MouseButton1Click:Connect(function()
					Rioo:Notify(text .. " clicked!")
					if callback then
						task.spawn(callback)
					end
				end)
			end

			function Section:CreateToggle(text, default, callback)
				local Btn = Instance.new("TextButton")
				Btn.Size = UDim2.new(1, -8, 0, 30)
				Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
				Btn.Text = text .. " [OFF]"
				Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
				Btn.Font = Enum.Font.Roboto
				Btn.TextSize = 16
				Btn.BorderSizePixel = 0
				Btn.Parent = Page

				local UIC = Instance.new("UICorner", Btn)
				UIC.CornerRadius = UDim.new(0, 4)

				local state = default or false
				Btn.MouseButton1Click:Connect(function()
					state = not state
					Btn.Text = text .. (state and " [ON]" or " [OFF]")
					Rioo:Notify(text .. (state and " ON" or " OFF"))
					if callback then
						task.spawn(callback, state)
					end
				end)
			end

			return Section
		end

		TabButton.MouseButton1Click:Connect(function()
			for _, t in pairs(Tabs) do
				t.Page.Visible = false
				t.Button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
			end
			Page.Visible = true
			TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		end)

		table.insert(Tabs, {Page = Page, Button = TabButton})
		if #Tabs == 1 then
			Page.Visible = true
			TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		end

		return Tab
	end

	return Rioo
end

return Rioo