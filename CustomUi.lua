-- CustomUI.lua
-- LocalScript (StarterGui)
-- UI hitam-putih, draggable window + draggable logo (logo opens/closes window)
-- Sends RemoteEvents to server:
--  - InstantFish (fire once)
--  - SetAutoFish (bool)
--  - RequestTeleport (string)
--  - SetWebhookURL (string)
-- Server returns InstantFishResult via InstantFishResult remote event

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- RemoteEvent references (server will create if absent)
local InstantFishRE = ReplicatedStorage:FindFirstChild("InstantFish")
local InstantFishResultRE = ReplicatedStorage:FindFirstChild("InstantFishResult")
local SetAutoFishRE = ReplicatedStorage:FindFirstChild("SetAutoFish")
local RequestTeleportRE = ReplicatedStorage:FindFirstChild("RequestTeleport")
local SetWebhookRE = ReplicatedStorage:FindFirstChild("SetWebhook")

-- UI constants
local LOGO_ASSET = "rbxassetid://111280907966644"
local UI_NAME = "RiooHubCustomUI"

-- Helper ensure events exist locally (they will be created server-side if nil)
local function ensureEvent(name)
    local ev = ReplicatedStorage:FindFirstChild(name)
    if not ev then
        ev = Instance.new("RemoteEvent")
        ev.Name = name
        ev.Parent = ReplicatedStorage
    end
    return ev
end

InstantFishRE = ensureEvent("InstantFish")
InstantFishResultRE = ensureEvent("InstantFishResult")
SetAutoFishRE = ensureEvent("SetAutoFish")
RequestTeleportRE = ensureEvent("RequestTeleport")
SetWebhookRE = ensureEvent("SetWebhook")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = UI_NAME
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- DRAG UTILS
local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- Small draggable logo (open/close)
local logoBtn = Instance.new("ImageButton")
logoBtn.Name = "RIOO_LogoBtn"
logoBtn.Image = LOGO_ASSET
logoBtn.Size = UDim2.new(0, 48, 0, 48)
logoBtn.Position = UDim2.new(0.02, 0, 0.85, 0)
logoBtn.BackgroundTransparency = 0
logoBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
logoBtn.BorderSizePixel = 0
logoBtn.Parent = screenGui
local logoCorner = Instance.new("UICorner", logoBtn)
logoCorner.CornerRadius = UDim.new(0, 10)
local logoPadding = Instance.new("UIPadding", logoBtn)
logoPadding.PaddingTop = UDim.new(0,6)
logoPadding.PaddingBottom = UDim.new(0,6)
logoPadding.PaddingLeft = UDim.new(0,6)
logoPadding.PaddingRight = UDim.new(0,6)
makeDraggable(logoBtn)

-- Main floating window
local main = Instance.new("Frame")
main.Name = "RiooMain"
main.Size = UDim2.new(0, 420, 0, 300)
main.Position = UDim2.new(0.3, 0, 0.2, 0)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)
main.BorderSizePixel = 0
main.Parent = screenGui
local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0, 12)
makeDraggable(main)

-- Title bar
local titleBar = Instance.new("Frame", main)
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 36)
titleBar.Position = UDim2.new(0,0,0,0)
titleBar.BackgroundTransparency = 1

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "RiooHub - Fish It"
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = Color3.fromRGB(240,240,240)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

-- Close button
local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0, 60, 0, 26)
closeBtn.Position = UDim2.new(1, -70, 0.12, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
closeBtn.TextColor3 = Color3.fromRGB(220,220,220)
closeBtn.Text = "Close"
closeBtn.Font = Enum.Font.Gotham
closeBtn.TextSize = 13
local closeCorner = Instance.new("UICorner", closeBtn)
closeCorner.CornerRadius = UDim.new(0,8)

-- Body layout
local body = Instance.new("Frame", main)
body.Size = UDim2.new(1, -24, 1, -64)
body.Position = UDim2.new(0,12,0,44)
body.BackgroundTransparency = 1

local vLayout = Instance.new("UIListLayout", body)
vLayout.Padding = UDim.new(0,10)
vLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- small helper to create toggle button (polos berubah warna)
local function createToggle(text, parent)
    local container = Instance.new("Frame", parent)
    container.Size = UDim2.new(1, 0, 0, 36)
    container.BackgroundTransparency = 1

    local lbl = Instance.new("TextLabel", container)
    lbl.Size = UDim2.new(0.7, 0, 1, 0)
    lbl.Position = UDim2.new(0,0,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextColor3 = Color3.fromRGB(230,230,230)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 14

    local btn = Instance.new("TextButton", container)
    btn.Size = UDim2.new(0.28, 0, 0.9, 0)
    btn.Position = UDim2.new(0.72, 0, 0.05, 0)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.Text = "OFF"
    btn.TextColor3 = Color3.fromRGB(200,200,200)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    local c = Instance.new("UICorner", btn)
    c.CornerRadius = UDim.new(0,8)

    local state = false
    local function setState(s)
        state = s
        if state then
            btn.BackgroundColor3 = Color3.fromRGB(236,236,236) -- putih saat on
            btn.Text = "ON"
            btn.TextColor3 = Color3.fromRGB(20,20,20)
        else
            btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
            btn.Text = "OFF"
            btn.TextColor3 = Color3.fromRGB(200,200,200)
        end
    end

    btn.MouseButton1Click:Connect(function()
        setState(not state)
    end)

    return container, btn, function() return state end, setState
end

-- Create toggles & buttons
local autoContainer, autoBtn, autoGetState, autoSetState = createToggle("Auto Fishing", body)
local instantContainer = Instance.new("Frame", body)
instantContainer.Size = UDim2.new(1,0,0,36)
instantContainer.BackgroundTransparency = 1

local instantLabel = Instance.new("TextLabel", instantContainer)
instantLabel.Size = UDim2.new(0.6,0,1,0)
instantLabel.BackgroundTransparency = 1
instantLabel.Text = "Instant Fishing (single cast)"
instantLabel.TextColor3 = Color3.fromRGB(230,230,230)
instantLabel.Font = Enum.Font.Gotham
instantLabel.TextSize = 14
instantLabel.TextXAlignment = Enum.TextXAlignment.Left

local instantBtn = Instance.new("TextButton", instantContainer)
instantBtn.Size = UDim2.new(0.35,0,0.9,0)
instantBtn.Position = UDim2.new(0.63,0,0.05,0)
instantBtn.BackgroundColor3 = Color3.fromRGB(90,90,90)
instantBtn.Text = "CAST"
instantBtn.TextColor3 = Color3.fromRGB(230,230,230)
instantBtn.Font = Enum.Font.GothamBold
instantBtn.TextSize = 14
local instantCorner = Instance.new("UICorner", instantBtn)
instantCorner.CornerRadius = UDim.new(0,8)

-- Teleport button (opens small submenu)
local teleportBtn = Instance.new("TextButton", body)
teleportBtn.Size = UDim2.new(1, 0, 0, 36)
teleportBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
teleportBtn.Text = "Teleport (open menu)"
teleportBtn.Font = Enum.Font.GothamBold
teleportBtn.TextSize = 14
teleportBtn.TextColor3 = Color3.fromRGB(230,230,230)
local tpCorner = Instance.new("UICorner", teleportBtn)
tpCorner.CornerRadius = UDim.new(0,8)

-- Teleport submenu (hidden by default)
local tpMenu = Instance.new("Frame", body)
tpMenu.Size = UDim2.new(1,0,0,0)
tpMenu.BackgroundTransparency = 1
tpMenu.ClipsDescendants = true

local tpLayout = Instance.new("UIListLayout", tpMenu)
tpLayout.Padding = UDim.new(0,6)

local function addTPOption(name)
    local b = Instance.new("TextButton", tpMenu)
    b.Size = UDim2.new(1,0,0,30)
    b.BackgroundColor3 = Color3.fromRGB(60,60,60)
    b.Text = name
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    b.TextColor3 = Color3.fromRGB(230,230,230)
    local c = Instance.new("UICorner", b)
    c.CornerRadius = UDim.new(0,8)
    b.MouseButton1Click:Connect(function()
        RequestTeleportRE:FireServer(name)
    end)
    return b
end

-- Typical teleport options (you can add more depending on map)
addTPOption("NearestBoat")
addTPOption("Spawn")
addTPOption("Shop")

-- Anti AFK toggle
local antiContainer, antiBtn, antiGetState, antiSetState = createToggle("Anti AFK", body)

-- Webhook settings (open small input)
local webhookFrame = Instance.new("Frame", body)
webhookFrame.Size = UDim2.new(1,0,0,36)
webhookFrame.BackgroundTransparency = 1
local webhookLabel = Instance.new("TextLabel", webhookFrame)
webhookLabel.Size = UDim2.new(0.5,0,1,0)
webhookLabel.BackgroundTransparency = 1
webhookLabel.Text = "Webhook URL"
webhookLabel.TextColor3 = Color3.fromRGB(230,230,230)
webhookLabel.Font = Enum.Font.Gotham
webhookLabel.TextSize = 14
webhookLabel.TextXAlignment = Enum.TextXAlignment.Left

local webhookInput = Instance.new("TextBox", webhookFrame)
webhookInput.Size = UDim2.new(0.46,0,0.8,0)
webhookInput.Position = UDim2.new(0.52,0,0.1,0)
webhookInput.PlaceholderText = "paste webhook url..."
webhookInput.Text = ""
webhookInput.BackgroundColor3 = Color3.fromRGB(40,40,40)
webhookInput.TextColor3 = Color3.fromRGB(230,230,230)
webhookInput.Font = Enum.Font.Gotham
webhookInput.TextSize = 13
local wCorner = Instance.new("UICorner", webhookInput)
wCorner.CornerRadius = UDim.new(0,6)

local webhookSetBtn = Instance.new("TextButton", webhookFrame)
webhookSetBtn.Size = UDim2.new(0.25,0,1,0)
webhookSetBtn.Position = UDim2.new(0.75,0,0,0)
webhookSetBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
webhookSetBtn.Text = "Set"
webhookSetBtn.Font = Enum.Font.GothamBold
webhookSetBtn.TextSize = 13
webhookSetBtn.TextColor3 = Color3.fromRGB(230,230,230)
local setCorner = Instance.new("UICorner", webhookSetBtn)
setCorner.CornerRadius = UDim.new(0,6)

-- Close button behaviour
closeBtn.MouseButton1Click:Connect(function()
    main.Visible = false
    logoBtn.Visible = true
end)

-- Logo opens/closes
logoBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
    logoBtn.Visible = not main.Visible
end)

-- Teleport menu toggle open/close simple expand/collapse
local tpOpen = false
teleportBtn.MouseButton1Click:Connect(function()
    tpOpen = not tpOpen
    if tpOpen then
        tpMenu:TweenSize(UDim2.new(1,0,0, (tpLayout.AbsoluteContentSize.Y + 12)), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
    else
        tpMenu:TweenSize(UDim2.new(1,0,0,0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.12, true)
    end
end)

-- Hook up InstantFish cast button
instantBtn.MouseButton1Click:Connect(function()
    instantBtn.Text = "WAIT..."
    instantBtn.Active = false
    InstantFishRE:FireServer()
    -- re-enable on result from server
end)

-- Hook up AutoFish toggle: send to server when changed
autoBtn.MouseButton1Click:Connect(function()
    -- toggle already visually updated by createToggle
    local state = (autoBtn.Text == "ON")
    SetAutoFishRE:FireServer(state)
end)

-- Hook up Anti AFK toggle: handled client side (simulate input)
antiBtn.MouseButton1Click:Connect(function()
    local state = (antiBtn.Text == "ON")
    -- we also notify server (optional) - server may log/store
    local ev = ReplicatedStorage:FindFirstChild("ToggleAntiAFK")
    if not ev then
        ev = Instance.new("RemoteEvent")
        ev.Name = "ToggleAntiAFK"
        ev.Parent = ReplicatedStorage
    end
    ev:FireServer(state)
end)

-- Webhook set
webhookSetBtn.MouseButton1Click:Connect(function()
    local url = tostring(webhookInput.Text or "")
    SetWebhookRE:FireServer(url)
end)

-- Listen server results for InstantFishResult to update UI and re-enable buttons
InstantFishResultRE.OnClientEvent:Connect(function(result)
    -- result: {name=..., rarity=..., coins=number}
    if not result then return end
    instantBtn.Text = "CAST"
    instantBtn.Active = true
    -- quick toast: replace title temporarily
    local prev = title.Text
    title.Text = string.format("Last: %s — %s (+%d)", result.name or "?", result.rarity or "?", result.coins or 0)
    delay(2.5, function() title.Text = prev end)
end)

-- CLIENT-SIDE ANTI-AFK: simulate input using VirtualUser every ~50s while enabled
do
    local anti = false
    local toggleEv = ReplicatedStorage:FindFirstChild("ToggleAntiAFK")
    if not toggleEv then
        toggleEv = Instance.new("RemoteEvent")
        toggleEv.Name = "ToggleAntiAFK"
        toggleEv.Parent = ReplicatedStorage
    end

    local vu = nil
    local heartbeatConn = nil

    local function startAntiAFK()
        if vu then return end
        -- VirtualUser usage
        local Success, VirtualUser = pcall(function() return game:GetService("VirtualUser") end)
        if Success and VirtualUser then
            vu = VirtualUser
            -- spawn loop every ~50 seconds
            heartbeatConn = game:GetService("RunService").Heartbeat:Connect(function(dt)
                -- do nothing each frame, we'll use delay loop
            end)
            -- loop in coroutine
            spawn(function()
                while anti do
                    -- simulate a mouse button down/up to avoid idle kick
                    pcall(function()
                        vu:CaptureController()
                        vu:ClickButton2(Vector2.new(0,0))
                    end)
                    wait(50)
                end
            end)
        end
    end

    local function stopAntiAFK()
        anti = false
        if heartbeatConn then
            heartbeatConn:Disconnect()
            heartbeatConn = nil
        end
        vu = nil
    end

    -- toggle when player clicks antiAFK UI
    toggleEv.OnClientEvent:Connect(function(state)
        anti = state
        if anti then startAntiAFK() else stopAntiAFK() end
    end)

    -- also listen to local toggle button so UI reacts immediately
    antiBtn.MouseButton1Click:Connect(function()
        local s = (antiBtn.Text == "ON")
        anti = s
        if anti then startAntiAFK() else stopAntiAFK() end
    end)
end

-- Initially show only logo; main hidden
main.Visible = false
logoBtn.Visible = true

-- Simple cleanup on character added to re-apply title text etc
player.CharacterAdded:Connect(function()
    title.Text = "RiooHub - Fish It"
end)