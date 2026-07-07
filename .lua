-- Защита от повторного запуска
local oldGui = game:GetService("CoreGui"):FindFirstChild("HitboxMenuGui")
if oldGui then oldGui:Destroy() end

-- Кэширование сервисов
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Глобальные настройки
_G.HeadSize = 5
_G.HitboxesActive = false
local currentBind = nil -- Переменная под выбранную клавишу
local isBinding = false -- Флаг режима ожидания клавиши

-- Создание GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HitboxMenuGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 260, 0, 140) -- Немного расширил меню под две кнопки
mainFrame.Position = UDim2.new(0, 20, 0, 20)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Кастомное плавное перетаскивание (Smooth Dragging)
local dragging, dragInput, dragStart, startPos
local function updateDrag(input)
    local delta = input.Position - dragStart
    local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    TweenService:Create(mainFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}):Play()
end

mainFrame.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not isBinding then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then updateDrag(input) end
end)

-- Заголовок меню
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 25)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Hitbox Menu [0 - Скрыть]"
titleLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
titleLabel.TextSize = 12
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Parent = mainFrame

-- Кнопка-Toggle (Переключатель)
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 140, 0, 30)
toggleButton.Position = UDim2.new(0, 15, 0, 30)
toggleButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
toggleButton.Text = "Хитбоксы: ВЫКЛ"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 13
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.Parent = mainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = toggleButton

-- Кнопка-Keybind (Назначение клавиши)
local bindButton = Instance.new("TextButton")
bindButton.Size = UDim2.new(0, 80, 0, 30)
bindButton.Position = UDim2.new(0, 165, 0, 30)
bindButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
bindButton.Text = "[NONE]"
bindButton.TextColor3 = Color3.fromRGB(200, 200, 200)
bindButton.TextSize = 12
bindButton.Font = Enum.Font.SourceSansBold
bindButton.Parent = mainFrame

local bindCorner = Instance.new("UICorner")
bindCorner.CornerRadius = UDim.new(0, 6)
bindCorner.Parent = bindButton

-- Текст текущего размера
local sizeLabel = Instance.new("TextLabel")
sizeLabel.Size = UDim2.new(1, 0, 0, 20)
sizeLabel.Position = UDim2.new(0, 0, 0, 70)
sizeLabel.BackgroundTransparency = 1
sizeLabel.Text = "Размер: " .. tostring(_G.HeadSize)
sizeLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
sizeLabel.TextSize = 14
sizeLabel.Font = Enum.Font.SourceSans
sizeLabel.Parent = mainFrame

-- Фоновый трек слайдера
local sliderBackground = Instance.new("Frame")
sliderBackground.Size = UDim2.new(0, 230, 0, 6)
sliderBackground.Position = UDim2.new(0, 15, 0, 105)
sliderBackground.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
sliderBackground.BorderSizePixel = 0
sliderBackground.Parent = mainFrame

-- Сама кнопка слайдера
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

-- Быстрый сброс хитбокса
local function resetPlayerHitbox(player)
    if player and player.Character then
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Size = Vector3.new(2, 2, 1)
            hrp.Transparency = 1
            hrp.CanCollide = true
        end
    end
end

local function resetAllPlayers()
    for _, player in next, Players:GetPlayers() do
        resetPlayerHitbox(player)
    end
end

-- Функция переключения состояния чита (вынесена отдельно для синхронизации)
local function toggleHitboxes()
    _G.HitboxesActive = not _G.HitboxesActive
    if _G.HitboxesActive then
        toggleButton.Text = "Хитбоксы: ВКЛ"
        toggleButton.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
    else
        toggleButton.Text = "Хитбоксы: ВЫКЛ"
        toggleButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        resetAllPlayers()
    end
end

-- Клик по Toggle в GUI
toggleButton.MouseButton1Click:Connect(toggleHitboxes)

-- Клик по кнопке бинда
bindButton.MouseButton1Click:Connect(function()
    if isBinding then return end
    isBinding = true
    bindButton.Text = "..."
    bindButton.TextColor3 = Color3.fromRGB(255, 150, 0)
end)

-- Отслеживание нажатий клавиатуры (Ввод бинда + активация)
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- Режим записи клавиши
    if isBinding then
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode ~= Enum.KeyCode.Zero then
            currentBind = input.KeyCode
            bindButton.Text = "[" .. input.KeyCode.Name .. "]"
            bindButton.TextColor3 = Color3.fromRGB(200, 200, 200)
            isBinding = false
        elseif input.KeyCode == Enum.KeyCode.Zero then
            -- Защищаем клавишу 0, чтобы её нельзя было перебиндить и сломать показ меню
            isBinding = false
            bindButton.Text = currentBind and ("[" .. currentBind.Name .. "]") or "[NONE]"
            bindButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        return
    end
    
    -- Скрытие/Показ меню на 0
    if input.KeyCode == Enum.KeyCode.Zero then
        mainFrame.Visible = not mainFrame.Visible
        return
    end
    
    -- Активация чита по забинженной клавише
    if currentBind and input.KeyCode == currentBind then
        toggleHitboxes()
    end
end)

-- Оптимизированный цикл отрисовки хитбоксов врагов
RunService.RenderStepped:Connect(function()
    local myTeam = LocalPlayer.Team
    local allPlayers = Players:GetPlayers()
    
    for i = 1, #allPlayers do
        local player = allPlayers[i]
        
        if player ~= LocalPlayer then
            if _G.HitboxesActive then
                if myTeam == nil or player.Team ~= myTeam then
                    local char = player.Character
                    if char then
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            hrp.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
                            hrp.Transparency = 1
                            hrp.BrickColor = BrickColor.new("Really blue")
                            hrp.Material = Enum.Material.Glass
                            hrp.CanCollide = false
                        end
                    end
                else
                    resetPlayerHitbox(player)
                end
            else
                resetPlayerHitbox(player)
            end
        end
    end
end)

-- Логика слайдера размера
local sliderDragging = false
sliderButton.MouseButton1Down:Connect(function() sliderDragging = true end)

UIS.InputChanged:Connect(function(input)
    if sliderDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
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
    if input.UserInputType == Enum.UserInputType.MouseButton1 then sliderDragging = false end
end)
