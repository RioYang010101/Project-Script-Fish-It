--[[ 
    Rioo UI Library v1
    Modern minimal - Dark theme
    Font: Default Roblox
    Draggable window
    API (compat): 
      Rioo:CreateWindow(cfg) -> window
      window:CreateTab(name) -> tab
      tab:CreateSection(title)
      tab:CreateButton({Name=..., Callback=...})
      tab:CreateToggle({Name=..., CurrentValue=bool, Callback=fn})
      tab:CreateSlider({Name=..., Range={min,max}, Increment=..., CurrentValue=..., Suffix=..., Callback=fn})
      tab:CreateDropdown({Name=..., Options={}, CurrentOption=..., Callback=fn})
      tab:CreateInput({Name=..., PlaceholderText=..., RemoveTextAfterFocusLost=bool, Callback=fn})
      Rioo:Notify({Title=..., Content=..., Duration=...})
--]]

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- clear previous Rioo UI if reloading
pcall(function()
    local old = CoreGui:FindFirstChild("RiooUI")
    if old then old:Destroy() end
end)

local Rioo = {}
Rioo.__index = Rioo

-- simple notification implementation
local function showNotification(opts)
    opts = opts or {}
    local duration = opts.Duration or 3
    -- ensure ScreenGui exists
    local sg = CoreGui:FindFirstChild("RiooUI_Notifications")
    if not sg then
        sg = Instance.new("ScreenGui")
        sg.Name = "RiooUI_Notifications"
        sg.ResetOnSpawn = false
        sg.Parent = CoreGui
    end

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 320, 0, 64)
    frame.Position = UDim2.new(0.5, -160, 0.08, 0)
    frame.AnchorPoint = Vector2.new(0.5, 0)
    frame.BackgroundColor3 = Color3.fromRGB(28,28,32)
    frame.BorderSizePixel = 0
    frame.Parent = sg
    frame.ZIndex = 9999
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,8)

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, -16, 0, 22)
    title.Position = UDim2.new(0, 8, 0, 6)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 14
    title.Text = tostring(opts.Title or "Notification")
    title.TextColor3 = Color3.fromRGB(235,235,235)
    title.TextXAlignment = Enum.TextXAlignment.Left

    local content = Instance.new("TextLabel", frame)
    content.Size = UDim2.new(1, -16, 0, 28)
    content.Position = UDim2.new(0, 8, 0, 28)
    content.BackgroundTransparency = 1
    content.Font = Enum.Font.SourceSans
    content.TextSize = 13
    content.Text = tostring(opts.Content or "")
    content.TextColor3 = Color3.fromRGB(200,200,200)
    content.TextWrapped = true
    content.TextXAlignment = Enum.TextXAlignment.Left

    -- auto-destroy
    spawn(function()
        wait(duration)
        pcall(function() frame:Destroy() end)
    end)
end

function Rioo:Notify(opts) showNotification(opts) end

-- CreateWindow: returns window object with CreateTab
function Rioo:CreateWindow(cfg)
    cfg = cfg or {}
    local Window = {}
    Window.Tabs = {}

    local sg = Instance.new("ScreenGui")
    sg.Name = tostring(cfg.Name or "RiooUI")
    sg.ResetOnSpawn = false
    sg.Parent = CoreGui

    local main = Instance.new("Frame")
    main.Name = "Rioo_Main"
    main.Size = UDim2.new(0, 760, 0, 440)
    main.Position = UDim2.new(0.5, -380, 0.5, -220)
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.BackgroundColor3 = Color3.fromRGB(22,22,26)
    main.BorderSizePixel = 0
    main.Parent = sg
    Instance.new("UICorner", main).CornerRadius = UDim.new(0,10)
    local stroke = Instance.new("UIStroke", main)
    stroke.Color = Color3.fromRGB(38,38,42)
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    -- Draggable support
    do
        local dragging = false
        local dragInput, dragStart, startPos

        local function update(input)
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end

        main.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = main.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        main.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                dragInput = input
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                update(input)
            end
        end)
    end

    -- Title bar
    local titlebar = Instance.new("Frame", main)
    titlebar.Name = "Titlebar"
    titlebar.Size = UDim2.new(1, 0, 0, 36)
    titlebar.Position = UDim2.new(0, 0, 0, 0)
    titlebar.BackgroundTransparency = 1

    local title = Instance.new("TextLabel", titlebar)
    title.Size = UDim2.new(1, -16, 1, 0)
    title.Position = UDim2.new(0, 8, 0, 0)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextYAlignment = Enum.TextYAlignment.Center
    title.TextColor3 = Color3.fromRGB(240,240,240)
    title.Text = tostring(cfg.Name or cfg.LoadingTitle or "Rioo Hub")

    -- tab list (left)
    local tabList = Instance.new("Frame", main)
    tabList.Name = "TabList"
    tabList.Size = UDim2.new(0, 180, 1, -36)
    tabList.Position = UDim2.new(0, 0, 0, 36)
    tabList.BackgroundColor3 = Color3.fromRGB(18,18,22)
    tabList.BorderSizePixel = 0
    Instance.new("UICorner", tabList).CornerRadius = UDim.new(0,8)

    local tabListLayout = Instance.new("UIListLayout", tabList)
    tabListLayout.Padding = UDim.new(0,8)
    tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    local tabPadding = Instance.new("UIPadding", tabList)
    tabPadding.PaddingTop = UDim.new(0,10)
    tabPadding.PaddingLeft = UDim.new(0,8)
    tabPadding.PaddingRight = UDim.new(0,8)

    -- content area (right)
    local content = Instance.new("Frame", main)
    content.Name = "Content"
    content.Size = UDim2.new(1, -180, 1, -36)
    content.Position = UDim2.new(0, 180, 0, 36)
    content.BackgroundTransparency = 1

    -- scrollable pages will be parented to content
    Window._internal = { ScreenGui = sg, Main = main, TabList = tabList, Content = content }

    -- CreateTab method
    function Window:CreateTab(name)
        local Tab = {}
        Tab.Name = name

        -- tab button
        local btn = Instance.new("TextButton", tabList)
        btn.Size = UDim2.new(1, 0, 0, 36)
        btn.BackgroundColor3 = Color3.fromRGB(18,18,22)
        btn.BorderSizePixel = 0
        btn.Font = Enum.Font.SourceSans
        btn.TextSize = 14
        btn.TextColor3 = Color3.fromRGB(220,220,220)
        btn.Text = "  "..tostring(name)
        btn.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)

        -- page (scrolling frame)
        local page = Instance.new("ScrollingFrame", content)
        page.Size = UDim2.new(1, 0, 1, 0)
        page.Position = UDim2.new(0, 0, 0, 0)
        page.BackgroundTransparency = 1
        page.ScrollBarThickness = 6
        page.CanvasSize = UDim2.new(0,0,0,0)
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.Visible = false

        local layout = Instance.new("UIListLayout", page)
        layout.Padding = UDim.new(0,10)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        local pad = Instance.new("UIPadding", page)
        pad.PaddingTop = UDim.new(0,10)
        pad.PaddingLeft = UDim.new(0,10)
        pad.PaddingRight = UDim.new(0,10)

        -- select tab on click
        btn.MouseButton1Click:Connect(function()
            for _,t in ipairs(Window.Tabs) do
                if t.Page then t.Page.Visible = false end
                if t.Button then t.Button.BackgroundColor3 = Color3.fromRGB(18,18,22) end
            end
            page.Visible = true
            btn.BackgroundColor3 = Color3.fromRGB(30,30,36)
        end)

        -- first tab auto-show
        if #Window.Tabs == 0 then
            page.Visible = true
            btn.BackgroundColor3 = Color3.fromRGB(30,30,36)
        end

        -- Tab methods: CreateSection, CreateButton, CreateToggle, CreateSlider, CreateDropdown, CreateInput
        function Tab:CreateSection(title)
            local sec = Instance.new("Frame", page)
            sec.Size = UDim2.new(1, 0, 0, 26)
            sec.BackgroundTransparency = 1
            local label = Instance.new("TextLabel", sec)
            label.Size = UDim2.new(1,0,1,0)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.SourceSansBold
            label.TextSize = 14
            label.TextColor3 = Color3.fromRGB(220,220,220)
            label.Text = tostring(title)
            label.TextXAlignment = Enum.TextXAlignment.Left
            return sec
        end

        function Tab:CreateButton(opts)
            opts = type(opts) == "table" and opts or { Name = tostring(opts) }
            local btn = Instance.new("TextButton", page)
            btn.Size = UDim2.new(1, -8, 0, 34)
            btn.BackgroundColor3 = Color3.fromRGB(30,30,35)
            btn.BorderSizePixel = 0
            btn.Font = Enum.Font.SourceSans
            btn.TextSize = 14
            btn.TextColor3 = Color3.fromRGB(240,240,240)
            btn.Text = opts.Name or "Button"
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)
            btn.MouseButton1Click:Connect(function()
                pcall(function() if opts.Callback then opts.Callback() end end)
            end)
            return btn
        end

        function Tab:CreateToggle(opts)
            opts = opts or {}
            local name = opts.Name or "Toggle"
            local current = opts.CurrentValue == true

            local frame = Instance.new("Frame", page)
            frame.Size = UDim2.new(1, -8, 0, 36)
            frame.BackgroundTransparency = 1

            local label = Instance.new("TextLabel", frame)
            label.Size = UDim2.new(0.72, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.SourceSans
            label.TextSize = 14
            label.TextColor3 = Color3.fromRGB(230,230,230)
            label.Text = name
            label.TextXAlignment = Enum.TextXAlignment.Left

            local btn = Instance.new("TextButton", frame)
            btn.Size = UDim2.new(0.24, 0, 0.72, 0)
            btn.Position = UDim2.new(0.74, 0, 0.14, 0)
            btn.BackgroundColor3 = current and Color3.fromRGB(80,200,120) or Color3.fromRGB(50,50,55)
            btn.BorderSizePixel = 0
            btn.Font = Enum.Font.SourceSansBold
            btn.TextSize = 12
            btn.TextColor3 = Color3.fromRGB(18,18,18)
            btn.Text = current and "ON" or "OFF"
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)

            btn.MouseButton1Click:Connect(function()
                current = not current
                btn.BackgroundColor3 = current and Color3.fromRGB(80,200,120) or Color3.fromRGB(50,50,55)
                btn.Text = current and "ON" or "OFF"
                pcall(function() if opts.Callback then opts.Callback(current) end end)
            end)

            return { Frame = frame, GetValue = function() return current end, SetValue = function(v) current = v; btn.BackgroundColor3 = v and Color3.fromRGB(80,200,120) or Color3.fromRGB(50,50,55); btn.Text = v and "ON" or "OFF" end }
        end

        function Tab:CreateSlider(opts)
            opts = opts or {}
            local name = opts.Name or "Slider"
            local minv = (opts.Range and opts.Range[1]) or 0
            local maxv = (opts.Range and opts.Range[2]) or 100
            local inc = opts.Increment or 1
            local cur = tonumber(opts.CurrentValue) or minv

            local frame = Instance.new("Frame", page)
            frame.Size = UDim2.new(1, -8, 0, 36)
            frame.BackgroundTransparency = 1

            local label = Instance.new("TextLabel", frame)
            label.Size = UDim2.new(0.5,0,1,0)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.SourceSans
            label.TextSize = 14
            label.TextColor3 = Color3.fromRGB(230,230,230)
            label.Text = name
            label.TextXAlignment = Enum.TextXAlignment.Left

            local minus = Instance.new("TextButton", frame)
            minus.Size = UDim2.new(0,28,0,24)
            minus.Position = UDim2.new(0.55,0,0.12,0)
            minus.Text = "-"
            minus.Font = Enum.Font.SourceSansBold
            minus.TextSize = 18
            minus.BackgroundColor3 = Color3.fromRGB(32,32,36)
            Instance.new("UICorner", minus).CornerRadius = UDim.new(0,6)

            local valueLabel = Instance.new("TextLabel", frame)
            valueLabel.Size = UDim2.new(0,90,0,24)
            valueLabel.Position = UDim2.new(0.63, 8, 0.12, 0)
            valueLabel.BackgroundTransparency = 1
            valueLabel.Font = Enum.Font.SourceSans
            valueLabel.TextSize = 14
            valueLabel.TextColor3 = Color3.fromRGB(220,220,220)
            valueLabel.Text = tostring(cur) .. (opts.Suffix or "")

            local plus = Instance.new("TextButton", frame)
            plus.Size = UDim2.new(0,28,0,24)
            plus.Position = UDim2.new(0.85,0,0.12,0)
            plus.Text = "+"
            plus.Font = Enum.Font.SourceSansBold
            plus.TextSize = 18
            plus.BackgroundColor3 = Color3.fromRGB(32,32,36)
            Instance.new("UICorner", plus).CornerRadius = UDim.new(0,6)

            local function update()
                valueLabel.Text = tostring(cur) .. (opts.Suffix or "")
                pcall(function() if opts.Callback then opts.Callback(cur) end end)
            end

            minus.MouseButton1Click:Connect(function()
                cur = math.max(minv, cur - inc)
                update()
            end)
            plus.MouseButton1Click:Connect(function()
                cur = math.min(maxv, cur + inc)
                update()
            end)

            return { Frame = frame, GetValue = function() return cur end, SetValue = function(v) cur = math.clamp(tonumber(v) or cur, minv, maxv); update() end }
        end

        function Tab:CreateDropdown(opts)
            opts = opts or {}
            local name = opts.Name or "Dropdown"
            local options = opts.Options or {}
            local cur = opts.CurrentOption or options[1] or ""
            local idx = 1
            for i,v in ipairs(options) do if v == cur then idx = i; break end end

            local frame = Instance.new("Frame", page)
            frame.Size = UDim2.new(1, -8, 0, 34)
            frame.BackgroundTransparency = 1

            local label = Instance.new("TextLabel", frame)
            label.Size = UDim2.new(0.6,0,1,0)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.SourceSans
            label.TextSize = 14
            label.TextColor3 = Color3.fromRGB(230,230,230)
            label.Text = name
            label.TextXAlignment = Enum.TextXAlignment.Left

            local btn = Instance.new("TextButton", frame)
            btn.Size = UDim2.new(0.36, 0, 1, 0)
            btn.Position = UDim2.new(0.62, 0, 0, 0)
            btn.Text = tostring(cur)
            btn.Font = Enum.Font.SourceSans
            btn.TextSize = 14
            btn.BackgroundColor3 = Color3.fromRGB(30,30,35)
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)

            btn.MouseButton1Click:Connect(function()
                if #options == 0 then return end
                idx = idx + 1
                if idx > #options then idx = 1 end
                cur = options[idx]
                btn.Text = tostring(cur)
                pcall(function() if opts.Callback then opts.Callback(cur) end end)
            end)

            return { Frame = frame, GetValue = function() return cur end, SetValue = function(v) cur = v; btn.Text = tostring(v) end }
        end

        function Tab:CreateInput(opts)
            opts = opts or {}
            local frame = Instance.new("Frame", page)
            frame.Size = UDim2.new(1, -8, 0, 36)
            frame.BackgroundTransparency = 1

            local label = Instance.new("TextLabel", frame)
            label.Size = UDim2.new(0.48,0,1,0)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.SourceSans
            label.TextSize = 14
            label.TextColor3 = Color3.fromRGB(230,230,230)
            label.Text = opts.Name or "Input"
            label.TextXAlignment = Enum.TextXAlignment.Left

            local box = Instance.new("TextBox", frame)
            box.Size = UDim2.new(0.5, 0, 0.7, 0)
            box.Position = UDim2.new(0.5, 0, 0.15, 0)
            box.Text = opts.PlaceholderText or ""
            box.ClearTextOnFocus = not not opts.RemoveTextAfterFocusLost
            box.BackgroundColor3 = Color3.fromRGB(30,30,35)
            box.TextColor3 = Color3.fromRGB(230,230,230)
            box.Font = Enum.Font.SourceSans
            box.TextSize = 14
            Instance.new("UICorner", box).CornerRadius = UDim.new(0,6)

            box.FocusLost:Connect(function(enter)
                if opts.Callback then pcall(function() opts.Callback(box.Text) end) end
            end)

            local ret = { Frame = frame, TextBox = box }
            ret.GetValue = function() return box.Text end
            ret.SetValue = function(v) box.Text = tostring(v) end
            ret.CurrentValue = box.Text
            box:GetPropertyChangedSignal("Text"):Connect(function() ret.CurrentValue = box.Text end)
            return ret
        end

        Tab.Button = btn
        Tab.Page = page

        table.insert(Window.Tabs, Tab)
        return Tab
    end

    setmetatable(Window, { __index = function(t,k) return Rioo[k] end })
    return Window
end

-- Return Rioo library
return Rioo