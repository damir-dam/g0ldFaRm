--[[
    BLACK & WHITE HWID SYSTEM
    Чистый минимализм
]]

-- Реальное получение HWID
local function GetRealHWID()
    local success, hwid = pcall(function()
        return game:GetService("RbxAnalyticsService"):GetClientId()
    end)
    
    if success and hwid and hwid ~= "FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF" then
        return string.gsub(string.upper(hwid), "%-", "")
    else
        return "HWID-" .. game:GetService("Players").LocalPlayer.UserId .. "-" .. math.random(100000, 999999)
    end
end

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HWID_System"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

-- Основное окно
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 450, 0, 350)
Main.Position = UDim2.new(0.5, -225, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Main.BorderSizePixel = 2
Main.BorderColor3 = Color3.fromRGB(255, 255, 255)
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

-- Содержимое (чтобы не путать с границами)
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -4, 1, -4)
Content.Position = UDim2.new(0, 2, 0, 2)
Content.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Content.BorderSizePixel = 0
Content.Parent = Main

-- Заголовок
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TitleBar.BorderSizePixel = 1
TitleBar.BorderColor3 = Color3.fromRGB(255, 255, 255)
TitleBar.Parent = Content

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -40, 1, 0)
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "HWID AUTHENTICATION"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 16
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
CloseBtn.BorderSizePixel = 1
CloseBtn.BorderColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.Parent = TitleBar

-- HWID секция
local HWIDBox = Instance.new("Frame")
HWIDBox.Size = UDim2.new(1, -20, 0, 70)
HWIDBox.Position = UDim2.new(0, 10, 0, 45)
HWIDBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
HWIDBox.BorderSizePixel = 1
HWIDBox.BorderColor3 = Color3.fromRGB(255, 255, 255)
HWIDBox.Parent = Content

local HWIDLabel = Instance.new("TextLabel")
HWIDLabel.Size = UDim2.new(1, 0, 0, 25)
HWIDLabel.Position = UDim2.new(0, 10, 0, 5)
HWIDLabel.BackgroundTransparency = 1
HWIDLabel.Text = "YOUR HWID:"
HWIDLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
HWIDLabel.Font = Enum.Font.Gotham
HWIDLabel.TextSize = 12
HWIDLabel.TextXAlignment = Enum.TextXAlignment.Left
HWIDLabel.Parent = HWIDBox

local HWIDValue = Instance.new("TextLabel")
HWIDValue.Size = UDim2.new(1, -80, 0, 25)
HWIDValue.Position = UDim2.new(0, 10, 0, 30)
HWIDValue.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
HWIDValue.BorderSizePixel = 1
HWIDValue.BorderColor3 = Color3.fromRGB(255, 255, 255)
HWIDValue.Text = GetRealHWID()
HWIDValue.TextColor3 = Color3.fromRGB(255, 255, 255)
HWIDValue.Font = Enum.Font.Code
HWIDValue.TextSize = 12
HWIDValue.TextXAlignment = Enum.TextXAlignment.Center
HWIDValue.Parent = HWIDBox

local CopyHWID = Instance.new("TextButton")
CopyHWID.Size = UDim2.new(0, 60, 0, 25)
CopyHWID.Position = UDim2.new(1, -70, 0, 30)
CopyHWID.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
CopyHWID.BorderSizePixel = 1
CopyHWID.BorderColor3 = Color3.fromRGB(255, 255, 255)
CopyHWID.Text = "COPY"
CopyHWID.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyHWID.Font = Enum.Font.Gotham
CopyHWID.TextSize = 11
CopyHWID.Parent = HWIDBox

-- Статус секция
local StatusBox = Instance.new("Frame")
StatusBox.Size = UDim2.new(1, -20, 0, 60)
StatusBox.Position = UDim2.new(0, 10, 0, 125)
StatusBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
StatusBox.BorderSizePixel = 1
StatusBox.BorderColor3 = Color3.fromRGB(255, 255, 255)
StatusBox.Parent = Content

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Position = UDim2.new(0, 10, 0, 5)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "STATUS:"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = StatusBox

local StatusValue = Instance.new("TextLabel")
StatusValue.Size = UDim2.new(1, -20, 0, 25)
StatusValue.Position = UDim2.new(0, 10, 0, 25)
StatusValue.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
StatusValue.BorderSizePixel = 1
StatusValue.BorderColor3 = Color3.fromRGB(255, 255, 255)
StatusValue.Text = "CHECKING..."
StatusValue.TextColor3 = Color3.fromRGB(255, 255, 0)
StatusValue.Font = Enum.Font.GothamBold
StatusValue.TextSize = 12
StatusValue.TextXAlignment = Enum.TextXAlignment.Center
StatusValue.Parent = StatusBox

-- Кнопка Load Script
local LoadBtn = Instance.new("TextButton")
LoadBtn.Size = UDim2.new(1, -20, 0, 40)
LoadBtn.Position = UDim2.new(0, 10, 0, 195)
LoadBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
LoadBtn.BorderSizePixel = 2
LoadBtn.BorderColor3 = Color3.fromRGB(255, 255, 255)
LoadBtn.Text = "LOAD SCRIPT"
LoadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadBtn.Font = Enum.Font.GothamBold
LoadBtn.TextSize = 14
LoadBtn.Parent = Content

-- Дебаг консоль
local DebugBox = Instance.new("Frame")
DebugBox.Size = UDim2.new(1, -20, 0, 90)
DebugBox.Position = UDim2.new(0, 10, 0, 245)
DebugBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
DebugBox.BorderSizePixel = 1
DebugBox.BorderColor3 = Color3.fromRGB(255, 255, 255)
DebugBox.Parent = Content

local DebugTitle = Instance.new("TextLabel")
DebugTitle.Size = UDim2.new(1, -10, 0, 20)
DebugTitle.Position = UDim2.new(0, 5, 0, 2)
DebugTitle.BackgroundTransparency = 1
DebugTitle.Text = "DEBUG CONSOLE:"
DebugTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
DebugTitle.Font = Enum.Font.Gotham
DebugTitle.TextSize = 11
DebugTitle.TextXAlignment = Enum.TextXAlignment.Left
DebugTitle.Parent = DebugBox

local DebugScroll = Instance.new("ScrollingFrame")
DebugScroll.Size = UDim2.new(1, -10, 0, 60)
DebugScroll.Position = UDim2.new(0, 5, 0, 22)
DebugScroll.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
DebugScroll.BorderSizePixel = 1
DebugScroll.BorderColor3 = Color3.fromRGB(255, 255, 255)
DebugScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
DebugScroll.ScrollBarThickness = 3
DebugScroll.Parent = DebugBox

local DebugList = Instance.new("UIListLayout")
DebugList.Parent = DebugScroll

-- Переменные
local currentHWID = HWIDValue.Text
local isWhitelisted = false

-- Белый список (ЗАМЕНИ НА СВОИ HWID)
local whitelist = {
    ["0260DDEC4C2D46A1A30D63F6775AE068"] = true,
	["19FD2260D4CF48D98CCD12C901209862"] = true,
	["AA27CF59068D474EBE6605F3E44CA236"] = true,
	["CEA539E2606146019DAA87BC19D84606"] = true,
    ["2AC7E3C213AD4BCF9D7F39CDCA185803"] = true
}

-- Функция дебага
local function Debug(message, msgType)
    local color = Color3.fromRGB(200, 200, 200)
    if msgType == "success" then
        color = Color3.fromRGB(0, 255, 0)
    elseif msgType == "error" then
        color = Color3.fromRGB(255, 0, 0)
    elseif msgType == "warning" then
        color = Color3.fromRGB(255, 255, 0)
    end
    
    local line = Instance.new("TextLabel")
    line.Size = UDim2.new(1, 0, 0, 16)
    line.BackgroundTransparency = 1
    line.Text = "[" .. os.date("%H:%M:%S") .. "] " .. message
    line.TextColor3 = color
    line.Font = Enum.Font.Code
    line.TextSize = 10
    line.TextXAlignment = Enum.TextXAlignment.Left
    line.Parent = DebugScroll
    
    DebugScroll.CanvasSize = UDim2.new(0, 0, 0, DebugList.AbsoluteContentSize.Y)
    DebugScroll.CanvasPosition = Vector2.new(0, DebugScroll.CanvasSize.Y.Offset)
end

-- Проверка HWID
Debug("🔍 Проверка HWID: " .. currentHWID, "warning")

if whitelist[currentHWID] then
    StatusValue.Text = "✓ HWID IN WHITELIST"
    StatusValue.TextColor3 = Color3.fromRGB(0, 255, 0)
    Debug("✅ HWID одобрен! Доступ разрешен", "success")
    isWhitelisted = true
else
    StatusValue.Text = "✗ HWID NOT IN WHITELIST"
    StatusValue.TextColor3 = Color3.fromRGB(255, 0, 0)
    Debug("❌ HWID не найден в белом списке", "error")
    isWhitelisted = false
end

-- Обработчики
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

CopyHWID.MouseButton1Click:Connect(function()
    setclipboard(currentHWID)
    CopyHWID.Text = "DONE!"
    Debug("📋 HWID скопирован", "success")
    wait(1)
    CopyHWID.Text = "COPY"
end)

LoadBtn.MouseButton1Click:Connect(function()
    if isWhitelisted then
        Debug("📥 Загрузка скрипта...", "warning")
        wait(0.5)
        loadstring(game:HttpGet('https://raw.githubusercontent.com/damir-dam/fox/refs/heads/main/.lua'))()
        Debug("✅ Скрипт успешно загружен", "success")
        
        LoadBtn.Text = "LOADED!"
        LoadBtn.Active = false
        
        wait(2)
        ScreenGui:Destroy()
    else
        Debug("❌ ОШИБКА: HWID не в whitelist", "error")
        StatusValue.Text = "✗ ACCESS DENIED"
        StatusValue.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

-- Возвращаем библиотеку
return {
    HWID = currentHWID,
    Debug = Debug,
    Approve = function()
        isWhitelisted = true
        StatusValue.Text = "✓ HWID IN WHITELIST"
        StatusValue.TextColor3 = Color3.fromRGB(0, 255, 0)
        Debug("✅ HWID одобрен администратором", "success")
    end,
    Deny = function()
        isWhitelisted = false
        StatusValue.Text = "✗ HWID NOT IN WHITELIST"
        StatusValue.TextColor3 = Color3.fromRGB(255, 0, 0)
        Debug("❌ HWID отклонен администратором", "error")
    end
}
