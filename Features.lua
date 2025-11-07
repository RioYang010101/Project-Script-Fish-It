-- Load Rayfield
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua"))()

-- =======================
-- Create Main Window
-- =======================
local Window = Rayfield:CreateWindow({
    Name = "RiooHub",
    LoadingTitle = "RiooHub Loading",
    LoadingSubtitle = "By Rio",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "RiooHubConfig"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = true
    },
    KeySystem = false
})

-- =======================
-- Open/Close Menu Button (Manual)
-- =======================
local CoreGui = game:GetService("CoreGui")
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 140, 0, 40)
ToggleButton.Position = UDim2.new(0, 20, 0, 20)
ToggleButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
ToggleButton.TextColor3 = Color3.fromRGB(255,255,255)
ToggleButton.Text = "Close Menu"
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 18
ToggleButton.Parent = CoreGui

ToggleButton.MouseButton1Click:Connect(function()
    local visible = Window.Visible
    Window:SetVisible(not visible)
    ToggleButton.Text = visible and "Open Menu" or "Close Menu"
end)

-- =======================
-- Tab Example: Auto Farm
-- =======================
local AutoTab = Window:CreateTab("Auto Farm")

-- Toggle Example
AutoTab:CreateToggle({
    Name = "Enable Auto Farm",
    CurrentValue = false,
    Flag = "AutoFarmToggle",
    Callback = function(value)
        if value then
            print("Auto Farm Enabled")
            -- tulis fungsi auto farm di sini
        else
            print("Auto Farm Disabled")
            -- stop auto farm di sini
        end
    end
})

print("✅ Rayfield Template Loaded! Open/Close Menu + Auto Farm toggle siap pakai.")