-- Защита от повторного запуска скрипта
local screenGui = game:GetService("CoreGui"):FindFirstChild("HitboxMenuGui")
if screenGui then screenGui:Destroy() end

-- Оптимизация: кэширование сервисов
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Глобальные настройки
_G.HeadSize = 5
_G.HitboxesActive = false

-- Создание GUI
screenGui = Instance.new("ScreenGui")
screenGui.Name = "HitboxMenuGui"
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 110)
mainFrame.Position = UDim2.new(0, 20, 0, 20)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 30)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Хитбоксы: ВЫКЛ (Нажмите Q)"
statusLabel.TextColor3 = Color3.fromRGB(220, 50, 50)
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.SourceSansBold
statusLabel.Parent = mainFrame

local sizeLabel = Instance.new("TextLabel")
sizeLabel.Size = UDim2.new(1, 0, 0, 20)
sizeLabel.Position = UDim2.new(0, 0, 0, 35)
sizeLabel.BackgroundTransparency = 1
sizeLabel.Text = "Размер: " .. tostring(_G.HeadSize)
sizeLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
sizeLabel.TextSize = 14
sizeLabel.Font = Enum.Font.SourceSans
sizeLabel.Parent = mainFrame

local sliderBackground = Instance.new("Frame")
sliderBackground.Size = UDim2.new(0, 180, 0, 6)
sliderBackground.Position = UDim2.new(0, 20, 0, 70)
sliderBackground.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
sliderBackground.BorderSizePixel = 0
sliderBackground.Parent = mainFrame

local sliderButton = Instance.new("TextButton")
sliderButton.Size = UDim2.new(0, 14, 0, 14)
sliderButton.Position = UDim2.new((_G.HeadSize - 1) / 13, -7, 0.5, -7)
sliderButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
sliderButton.Text = ""
sliderButton.BorderSizePixel = 0
sliderButton.Parent = sliderBackground

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(1, 0)
sliderCorner.Parent = sliderButton

-- Быстрая функция сброса одного игрока (без задержек)
local function resetPlayerHitbox(player)
    local char = player.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Size = Vector3.new(2, 2, 1)
            hrp.Transparency = 1
            hrp.CanCollide = true
        end
    end
end

-- Сброс абсолютно всех игроков
local function resetAllPlayers()
    for _, player in next, Players:GetPlayers() do
        resetPlayerHitbox(player)
    end
end

-- Оптимизированный цикл (выполняется только для врагов)
RunService.RenderStepped:Connect(function()
    if not _G.HitboxesActive then return end
    
    local myTeam = LocalPlayer.Team
    local allPlayers = Players:GetPlayers()
    
    for i = 1, #allPlayers do
        local player = allPlayers[i]
        
        if player ~= LocalPlayer then
            -- Проверка на команду (если команд нет или они разные — это враг)
            if myTeam == nil or player.Team ~= myTeam then
                local char = player.Character
                if char then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
                        hrp.Transparency = 0.7
                        hrp.BrickColor = BrickColor.new("Really blue")
                        hrp.Material = Enum.Material.Glass
                        hrp.CanCollide = false
                    end
                end
            else
                -- Если это тимейт, принудительно держим его хитбокс нормальным
                resetPlayerHitbox(player)
            end
        end
    end
end)

-- Логика слайдера
local dragging = false

sliderButton.MouseButton1Down:Connect(function()
    dragging = true
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = input.Position.X
        local sliderLeft = sliderBackground.AbsolutePosition.X
        local sliderWidth = sliderBackground.AbsoluteSize.X
        
        local percentage = math.clamp((mousePos - sliderLeft) / sliderWidth, 0, 1)
        local rawSize = 1 + (percentage * 13)
        _G.HeadSize = math.round(rawSize)
        
        sliderButton.Position = UDim2.new((_G.HeadSize - 1) / 13, -7, 0.5, -7)
        sizeLabel.Text = "Размер: " .. tostring(_G.HeadSize)
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Переключение режима по клавише "Q"
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end -- Игнорируем, если открыт чат
    
    if input.KeyCode == Enum.KeyCode.Q then
        _G.HitboxesActive = not _G.HitboxesActive
        
        if _G.HitboxesActive then
            statusLabel.Text = "Хитбоксы: ВКЛ (Нажмите Q)"
            statusLabel.TextColor3 = Color3.fromRGB(50, 220, 50)
        else
            statusLabel.Text = "Хитбоксы: ВЫКЛ (Нажмите Q)"
            statusLabel.TextColor3 = Color3.fromRGB(220, 50, 50)
            resetAllPlayers() -- Мгновенно убираем хитбоксы со всех при выключении
        end
    end
end)
