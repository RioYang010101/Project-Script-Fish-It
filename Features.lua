-- Load Rayfield
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua"))()

-- Buat Window utama
local Window = Rayfield:CreateWindow({
    Name = "RiooHub",
    LoadingTitle = "RiooHub Loading",
    LoadingSubtitle = "By Rio",
    ConfigurationSaving = { Enabled = true, FolderName = nil, FileName = "RiooHubConfig" },
    Discord = { Enabled = false, Invite = "", RememberJoins = true },
    KeySystem = false
})

-- =======================
-- Buat tombol Show/Hide sendiri
-- =======================
local CoreGui = game:GetService("CoreGui")
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 160, 0, 40)
ToggleButton.Position = UDim2.new(0, 20, 0, 20)
ToggleButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
ToggleButton.TextColor3 = Color3.fromRGB(255,255,255)
ToggleButton.Text = "RiooHub - Fish It"
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 18
ToggleButton.Parent = CoreGui -- selalu terlihat

local UIVisible = true
ToggleButton.MouseButton1Click:Connect(function()
    UIVisible = not UIVisible
    Window:SetVisible(UIVisible)
    ToggleButton.Text = UIVisible and "RiooHub - Fish It" or "Open Menu"
end)

-- =======================
-- Tab contoh: Auto Farm
-- =======================
local AutoTab = Window:CreateTab("Auto Farm")

AutoTab:CreateToggle({
    Name = "Enable Auto Farm",
    CurrentValue = false,
    Flag = "AutoFarmToggle",
    Callback = function(value)
        if value then
            print("Auto Farm Enabled")
        else
            print("Auto Farm Disabled")
        end
    end
})

print("✅ Working: Tombol Show/Hide dibuat sendiri, teks: 'RiooHub - Fish It'")