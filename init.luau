local BASE_URL = "https://raw.githubusercontent.com/GLAMOHGA/libary/v1.0.0"

if getgenv().Night and getgenv().Night.__Library then
    return getgenv().Night.__Library
end

local Night = getgenv().Night or {}
Night.Scale         = Night.Scale or 1
Night.Game          = Night.Game or (game.PlaceId ~= 0 and tostring(game.PlaceId)) or "Universal"
Night.Dev           = Night.Dev or false
Night.Premium       = Night.Premium or false
Night.Mobile        = Night.Mobile or false
Night.IgnoreConfigs = Night.IgnoreConfigs or {}
Night.Connections   = Night.Connections or {}
Night.Load          = Night.Load or { Loaded = false }
Night.Init          = Night.Init or {}
Night.Version       = "1.0.0"

getgenv().Night = Night

local ok, err = pcall(function()
    loadstring(game:HttpGet(BASE_URL .. "/main.luau"))()
end)

if not ok then
    error("[Night] Failed to load core: " .. tostring(err), 0)
end

task.wait(0.2)

if not Night.Assets or not Night.Assets.Functions then
    error("[Night] Core did not expose Assets.Functions", 0)
end

local Fn = Night.Assets.Functions

local Library = {}
Library.__index = Library

Library.Version = Night.Version
Library.License = "MIT"
Library.Author  = "GLAMOHGA"
Library.Night   = Night

function Library:Window(Data)
    Data = Data or {}
    if Night.MainWindow and Night.MainWindow.Functions and Night.MainWindow.Functions.ChangeText then
        Night.MainWindow:ChangeText({ Text = Data.Name or "Night" })
    end
    return Night.MainWindow
end

function Library:CreateTab(Data)
    Data = Data or {}
    assert(type(Data.Name) == "string", "[Night] CreateTab: Name is required")
    Data.Flag = Data.Flag or (Data.Name:gsub("%s+", "_") .. "_" .. tostring(math.random(1000, 9999)))
    Data.Icon = Data.Icon or "Utility"

    return Fn:CreateTab({
        Name  = Data.Name,
        Flag  = Data.Flag,
        Icon  = Data.Icon,
        Order = Data.Order,
    })
end

function Library:Notification(Data)
    Data = Data or {}
    return Fn:CreateNotification({
        Title       = Data.Title or "Night",
        Description = Data.Description or "",
        Duration    = Data.Duration or 3,
        Module      = Data.Module,
    })
end

function Library:Uninject()
    if Fn.Uninject then
        Fn.Uninject()
    end
end

function Library:GetVersion()
    return Library.Version
end

Night.__Library = Library

return Library
