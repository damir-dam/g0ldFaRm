-- Настройки хитбоксов
_G.HeadSize = 13
_G.HitboxesActive = false -- По умолчанию выключены

-- Функция для сброса хитбокса одного игрока
local function resetPlayerHitbox(player)
    pcall(function()
        local hrp = player.Character:WaitForChild("HumanoidRootPart", 2)
        if hrp then
            hrp.Size = Vector3.new(2, 2, 1) -- Стандартный размер
            hrp.Transparency = 1            -- Невидимый
            hrp.CanCollide = true           -- Обычная физика
        end
    end)
end

-- Функция для сброса всех игроков
local function resetAllPlayers()
    for _, player in next, game:GetService('Players'):GetPlayers() do
        if player.Name ~= game:GetService('Players').LocalPlayer.Name then
            resetPlayerHitbox(player)
        end
    end
end

-- Постоянный цикл изменения размеров (работает только когда _G.HitboxesActive = true)
game:GetService('RunService').RenderStepped:Connect(function()
    if _G.HitboxesActive then
        for _, player in next, game:GetService('Players'):GetPlayers() do
            if player.Name ~= game:GetService('Players').LocalPlayer.Name then
                pcall(function()
                    local hrp = player.Character.HumanoidRootPart
                    hrp.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
                    hrp.Transparency = 0.7
                    hrp.BrickColor = BrickColor.new("Really blue")
                    hrp.Material = Enum.Material.Glass
                    hrp.CanCollide = false
                end)
            end
        end
    end
end)

-- Отслеживание нажатия клавиши "0"
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end -- Игнорируем нажатия, если открыт чат
    
    if input.KeyCode == Enum.KeyCode.Zero then
        _G.HitboxesActive = not _G.HitboxesActive -- Переключаем режим (true/false)
        
        if _G.HitboxesActive then
        else
            resetAllPlayers() -- Моментально возвращаем стандартный вид
        end
    end
end)
