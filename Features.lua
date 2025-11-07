-- Load Rayfield
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua"))()

-- Create Main Window
local Window = Rayfield:CreateWindow({
    Name = "RiooHub",
    LoadingTitle = "RiooHub Loading",
    LoadingSubtitle = "By Rio",
    ConfigurationSaving = { Enabled = true, FolderName = nil, FileName = "RiooHubConfig" },
    Discord = { Enabled = false, Invite = "", RememberJoins = true },
    KeySystem = false
})

-- Wait until the Toggle button exists, then change the text
spawn(function()
    repeat wait() until Window.Toggle and Window.Toggle.TextButton
    Window.Toggle.TextButton.Text = "RiooHub - Fish It"
end)

-- Example Tab: Auto Farm
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

print("✅ Rayfield Template Loaded, Show/Hide button text should now be 'RiooHub - Fish It'")