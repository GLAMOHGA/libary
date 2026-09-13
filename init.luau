-- init.luau
-- Night UI Library — публичная точка входа

local BASE_URL = "https://raw.githubusercontent.com/GLAMOHGA/libary/refs/heads/main"

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

getgenv().Night = Night

local ok, err = pcall(function()
    loadstring(game:HttpGet(BASE_URL .. "/main.luau"))()
end)

if not ok then
    warn("[Night] Не удалось загрузить main.luau: " .. tostring(err))
    return nil
end

task.wait(0.2)

if not Night.Assets or not Night.Assets.Functions then
    warn("[Night] main.luau не выставил Night.Assets.Functions")
    return nil
end

local Fn = Night.Assets.Functions

local Library = {}
Library.__index = Library

Library.Version = "1.0.0"
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
    assert(Data.Name, "[Night] CreateTab: поле Name обязательно")
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

return Library
