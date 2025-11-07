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
-- Ganti teks tombol Show/Hide default Rayfield
-- =======================
if Window.Toggle and Window.Toggle.TextButton then
    Window.Toggle.TextButton.Text = "RiooHub - Fish It"
end

-- =======================
-- Tab Example: Auto Farm
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

print("✅ Rayfield Template Loaded dengan tombol Show/Hide = RiooHub - Fish It")