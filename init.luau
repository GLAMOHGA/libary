-- init.luau
-- Night UI Library — публичная точка входа
-- Юзер: local Library = loadstring(game:HttpGet(".../init.luau"))()

local BASE_URL = "https://raw.githubusercontent.com/GLAMOHGA/libary/refs/heads/main"

-- 1. Готовим окружение, которое ожидает main.luau
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

-- 2. Грузим внутренний main.luau (он заполнит Night.Assets, Night.MainWindow и т.д.)
local ok, err = pcall(function()
    loadstring(game:HttpGet(BASE_URL .. "/main.luau"))()
end)

if not ok then
    warn("[Night] Не удалось загрузить main.luau: " .. tostring(err))
    return nil
end

task.wait(0.1) -- даём main.luau доинициализироваться

-- 3. Собираем фасад — то, что получит юзер
local Library = {}
Library.__index = Library

Library.Version = "1.0.0"
Library.Night   = Night

-- Создать окно
function Library:Window(Data)
    Data = Data or {}
    Data.Name    = Data.Name or "Night"
    Data.SubName = Data.SubName or ""

    return Night.MainWindow
end

-- Создать вкладку
function Library:CreateTab(Data)
    Data = Data or {}
    assert(Data.Name, "[Night] CreateTab: поле Name обязательно")
    Data.Flag = Data.Flag or (Data.Name:gsub("%s+", "_") .. "_" .. tostring(math.random(1000, 9999)))
    Data.Icon = Data.Icon or "Utility"

    return Night.CreateTab({
        Name  = Data.Name,
        Flag  = Data.Flag,
        Icon  = Data.Icon,
        Order = Data.Order,
    })
end

-- Уведомление
function Library:Notification(Data)
    Data = Data or {}
    Data.Title       = Data.Title or "Night"
    Data.Description = Data.Description or ""
    Data.Duration    = Data.Duration or 3

    return Night.CreateNotification({
        Title       = Data.Title,
        Description = Data.Description,
        Duration    = Data.Duration,
        Module      = Data.Module,
    })
end

-- Выгрузить библиотеку
function Library:Uninject()
    if Night.Uninject then
        Night.Uninject()
    end
end

-- 4. Возвращаем фасад
return Library
