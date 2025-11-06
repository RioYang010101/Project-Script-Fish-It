-- MainFeature.lua
-- ServerScript (ServerScriptService)
-- Implements instant fish logic, auto-fish per-player, teleport requests,
-- webhook sending, and sends InstantFishResult to client.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

-- RemoteEvents names (will create if missing)
local function getOrCreateEvent(name)
    local ev = ReplicatedStorage:FindFirstChild(name)
    if not ev then
        ev = Instance.new("RemoteEvent")
        ev.Name = name
        ev.Parent = ReplicatedStorage
    end
    return ev
end

local InstantFishRE = getOrCreateEvent("InstantFish")            -- client -> server (single cast)
local InstantFishResultRE = getOrCreateEvent("InstantFishResult")-- server -> client (result)
local SetAutoFishRE = getOrCreateEvent("SetAutoFish")            -- client -> server (bool)
local RequestTeleportRE = getOrCreateEvent("RequestTeleport")    -- client -> server (string)
local SetWebhookRE = getOrCreateEvent("SetWebhook")              -- client -> server (string)
local ToggleAntiAFKRE = getOrCreateEvent("ToggleAntiAFK")        -- client -> server (bool) (optional)

-- CONFIG
local WEBHOOK_DEFAULT = "" -- leave empty or set a default webhook
local AUTOFISH_DELAY = 1.0 -- seconds between auto-casts (adjust)

-- Example fish pool (you can replace these with your original names/weights)
local FishPool = {
    {name = "Small Perch", rarity = "Common", weight = 60, coins = 10},
    {name = "River Carp", rarity = "Common", weight = 40, coins = 12},

    {name = "Blue Snapper", rarity = "Uncommon", weight = 25, coins = 25},
    {name = "Golden Trout", rarity = "Uncommon", weight = 15, coins = 30},

    {name = "Silver Marlin", rarity = "Rare", weight = 6, coins = 100},
    {name = "Rock Lobster", rarity = "Rare", weight = 4, coins = 140},

    {name = "Shadow Shark", rarity = "Legendary", weight = 0.8, coins = 800},
    {name = "Mythic Leviathan", rarity = "Mythic", weight = 0.2, coins = 2500},
}

-- Build weighted list for selection
local weighted = {}
do
    for _, fish in ipairs(FishPool) do
        local count = math.max(1, math.floor(fish.weight * 10))
        for i=1,count do
            table.insert(weighted, fish)
        end
    end
end

local function chooseFish()
    if #weighted == 0 then
        return FishPool[1]
    end
    local idx = math.random(1, #weighted)
    return weighted[idx]
end

-- Per-player state (auto-fish coroutines, webhook url)
local playerState = {} -- player -> {auto = bool, autoHandle = thread, webhook = string, lastCast = number}

-- Helper: reward player coins and fish count
local function rewardPlayer(player, fish)
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local coins = leaderstats:FindFirstChild("Coins")
        if coins and coins:IsA("IntValue") then
            coins.Value = coins.Value + (fish.coins or 0)
        end
        local fc = leaderstats:FindFirstChild("FishCaught")
        if not fc then
            fc = Instance.new("IntValue")
            fc.Name = "FishCaught"
            fc.Value = 0
            fc.Parent = leaderstats
        end
        fc.Value = fc.Value + 1
    end
end

-- Webhook sender
local function sendWebhook(player, fish, url)
    url = url or WEBHOOK_DEFAULT
    if not url or url == "" then return end
    local payload = {
        username = "RiooFishing",
        embeds = {
            {
                title = player.Name .. " caught " .. fish.name,
                fields = {
                    {name = "Rarity", value = fish.rarity or "Unknown", inline = true},
                    {name = "Coins", value = tostring(fish.coins or 0), inline = true},
                },
                color = 16753920
            }
        }
    }
    local ok, err = pcall(function()
        HttpService:PostAsync(url, HttpService:JSONEncode(payload), Enum.HttpContentType.ApplicationJson)
    end)
    if not ok then
        warn("Webhook failed for", player.Name, err)
    end
end

-- Handle a single cast for a player (safe server-side)
local function handleCast(player)
    if not player or not player.Parent then return end
    local now = tick()
    local st = playerState[player]
    st = st or {}
    playerState[player] = st
    st.lastCast = st.lastCast or 0
    if now - st.lastCast < 0.5 then
        -- too fast
        InstantFishResultRE:FireClient(player, {name = "Too Fast", rarity = "-", coins = 0})
        return
    end
    st.lastCast = now

    local fish = chooseFish()
    rewardPlayer(player, fish)

    -- send result to client
    InstantFishResultRE:FireClient(player, {name = fish.name, rarity = fish.rarity, coins = fish.coins})

    -- webhook if rare+
    local rareLevels = {Rare=true, Legendary=true, Mythic=true}
    if rareLevels[fish.rarity] then
        local url = st and st.webhook or nil
        sendWebhook(player, fish, url)
    end
end

-- InstantFish event handler (single cast)
InstantFishRE.OnServerEvent:Connect(function(player)
    -- basic anti-spam & validation
    handleCast(player)
end)

-- AutoFish toggling
SetAutoFishRE.OnServerEvent:Connect(function(player, state)
    state = not not state
    local st = playerState[player] or {}
    playerState[player] = st
    st.auto = state
    -- stop existing loop if any
    if st.autoHandle then
        -- mark to stop; autoHandle coroutine will check st.auto
        st.auto = state
        -- no direct cancel; coroutine uses st.auto to exit
    end
    if state then
        -- start auto loop
        st.autoHandle = coroutine.create(function()
            while st.auto and player and player.Parent do
                handleCast(player)
                wait(AUTOFISH_DELAY)
            end
            st.autoHandle = nil
        end)
        coroutine.resume(st.autoHandle)
    end
end)

-- Teleport request handling (best-effort)
RequestTeleportRE.OnServerEvent:Connect(function(player, target)
    if not player or not player.Character or not player.Character.PrimaryPart then return end
    local hrp = player.Character.PrimaryPart
    target = tostring(target or "")
    if target == "Spawn" then
        local spawn = workspace:FindFirstChild("SpawnLocation") or workspace:FindFirstChildOfClass("SpawnLocation") or workspace:FindFirstChild("Spawn")
        if spawn and spawn.Position then
            hrp.CFrame = CFrame.new(spawn.Position + Vector3.new(0,5,0))
            return
        end
    elseif target == "NearestBoat" then
        -- try to find nearest model with "Boat" in name
        local nearest, ndist = nil, math.huge
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj.PrimaryPart and string.find(obj.Name:lower(), "boat") then
                local d = (obj.PrimaryPart.Position - hrp.Position).magnitude
                if d < ndist then
                    ndist = d
                    nearest = obj
                end
            end
        end
        if nearest and nearest.PrimaryPart then
            hrp.CFrame = nearest.PrimaryPart.CFrame + Vector3.new(0,5,0)
            return
        end
    elseif target == "Shop" then
        -- try find object named Shop or ShopSpawn
        local shop = workspace:FindFirstChild("Shop") or workspace:FindFirstChild("ShopSpawn")
        if shop and shop:IsA("BasePart") then
            hrp.CFrame = CFrame.new(shop.Position + Vector3.new(0,5,0))
            return
        elseif shop and shop.PrimaryPart then
            hrp.CFrame = shop.PrimaryPart.CFrame + Vector3.new(0,5,0)
            return
        end
    end
    -- fallback: teleport to player's spawn
    -- if nothing found, do nothing
end)

-- Webhook setting
SetWebhookRE.OnServerEvent:Connect(function(player, url)
    local st = playerState[player] or {}
    playerState[player] = st
    if tostring(url or "") == "" then
        st.webhook = nil
    else
        st.webhook = tostring(url)
    end
end)

-- ToggleAntiAFK: server just stores state if wanted
ToggleAntiAFKRE.OnServerEvent:Connect(function(player, state)
    local st = playerState[player] or {}
    playerState[player] = st
    st.antiAFK = not not state
end)

-- Cleanup on player removing
Players.PlayerRemoving:Connect(function(player)
    playerState[player] = nil
end)

-- Ensure leaderstats exists for players (if your game already has leaderstats, you can remove this block)
Players.PlayerAdded:Connect(function(player)
    -- try to not overwrite existing leaderstats
    if not player:FindFirstChild("leaderstats") then
        local ls = Instance.new("Folder")
        ls.Name = "leaderstats"
        ls.Parent = player
        local coins = Instance.new("IntValue")
        coins.Name = "Coins"
        coins.Value = 0
        coins.Parent = ls
    end
end)