--== SLAUGHTER EXECUTOR GUI ==--

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local espConnection = nil
local inputConnection = nil
local aimConnection = nil
local _INTRO_CONNECTION = nil

-- ФОРВАРД-ДЕКЛАРАЦИИ ДЛЯ WAVE
local closeGUI, openGUI, showMiniHud, hideMiniHud
local _G = getgenv()
local _notify

-- Чистим старые
for _, name in ipairs({"SlaughterGUI", "SlaughterIntro", "SlaughterNotifications"}) do
    local old = CoreGui:FindFirstChild(name)
    if old then old:Destroy() end
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if pg then
        local old2 = pg:FindFirstChild(name)
        if old2 then old2:Destroy() end
    end
end

-- =========================================================
-- ГЛАВНЫЙ GUI
-- =========================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SlaughterGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Enabled = false
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 540, 0, 420)
Main.Position = UDim2.new(0.5, -270, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
Main.BorderSizePixel = 0
Main.Active = true
-- Draggable отключён — используем кастомный drag с clamp ниже
Main.BackgroundTransparency = 1
Main.ClipsDescendants = false
Main.Parent = ScreenGui

-- Кастомный drag с clamp — вешаем ТОЛЬКО на TopBar, чтобы клики по кнопкам не тащили окно
-- (TopBar создаётся ниже, поэтому drag подключим после его создания)
local MAIN_DRAG = {
    dragging = false,
    dragStart = nil,
    startPos = nil,
    connChanged = nil,
}

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 30, 30)
MainStroke.Thickness = 1
MainStroke.Transparency = 1
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainStroke.Parent = Main

-- Внешнее свечение (glow)
local GlowStroke = Instance.new("UIStroke")
GlowStroke.Color = Color3.fromRGB(255, 30, 30)
GlowStroke.Thickness = 3
GlowStroke.Transparency = 1
GlowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GlowStroke.Parent = Main

-- Внутренний градиент фона Main
local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 24)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(12, 12, 14)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 10)),
}
MainGradient.Rotation = 135
MainGradient.Parent = Main

-- ===== TOPBAR =====
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 44)
TopBar.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
TopBar.BorderSizePixel = 0
TopBar.BackgroundTransparency = 1
TopBar.Parent = Main

-- Drag только за TopBar — кнопки внутри не тащат окно
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        MAIN_DRAG.dragging = true
        MAIN_DRAG.dragStart = input.Position
        MAIN_DRAG.startPos = Main.Position
    end
end)

TopBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        MAIN_DRAG.dragging = false
    end
end)

MAIN_DRAG.connChanged = UserInputService.InputChanged:Connect(function(input)
    if not MAIN_DRAG.dragging then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - MAIN_DRAG.dragStart
        local vp = workspace.CurrentCamera.ViewportSize
        local newX = math.clamp(MAIN_DRAG.startPos.X.Offset + delta.X, -Main.AbsoluteSize.X + 60, vp.X - 60)
        local newY = math.clamp(MAIN_DRAG.startPos.Y.Offset + delta.Y, 0, vp.Y - 40)
        Main.Position = UDim2.new(0, newX, 0, newY)
    end
end)

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 14)
TopBarCorner.Parent = TopBar

local TopBarGradient = Instance.new("UIGradient")
TopBarGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 10, 10)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 10, 12)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(28, 10, 10)),
}
TopBarGradient.Rotation = 0
TopBarGradient.Parent = TopBar

-- Логотип-иконка
local LogoIcon = Instance.new("Frame")
LogoIcon.Size = UDim2.new(0, 26, 0, 26)
LogoIcon.Position = UDim2.new(0, 12, 0.5, -13)
LogoIcon.BackgroundColor3 = Color3.fromRGB(255, 30, 30)
LogoIcon.BorderSizePixel = 0
LogoIcon.Parent = TopBar

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(1, 0)
LogoCorner.Parent = LogoIcon

local LogoGradient = Instance.new("UIGradient")
LogoGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 60, 60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 0, 0)),
}
LogoGradient.Rotation = 135
LogoGradient.Parent = LogoIcon

local LogoText = Instance.new("TextLabel")
LogoText.Size = UDim2.new(1, 0, 1, 0)
LogoText.BackgroundTransparency = 1
LogoText.Text = "S"
LogoText.TextColor3 = Color3.fromRGB(255, 255, 255)
LogoText.TextSize = 16
LogoText.Font = Enum.Font.GothamBlack
LogoText.Parent = LogoIcon

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 46, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "SLAUGHTER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBlack
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Подпись версии
local NoSupportLabel = Instance.new("TextLabel")
NoSupportLabel.Size = UDim2.new(0, 60, 0, 18)
NoSupportLabel.Position = UDim2.new(0, 175, 0.5, -9)
NoSupportLabel.BackgroundColor3 = Color3.fromRGB(255, 140, 40)
NoSupportLabel.BackgroundTransparency = 0.85
NoSupportLabel.Text = " v3.0 "
NoSupportLabel.TextColor3 = Color3.fromRGB(255, 180, 100)
NoSupportLabel.TextSize = 10
NoSupportLabel.Font = Enum.Font.GothamBold
NoSupportLabel.Parent = TopBar

local NoSupportCorner = Instance.new("UICorner")
NoSupportCorner.CornerRadius = UDim.new(0, 4)
NoSupportCorner.Parent = NoSupportLabel

-- Акцент под топбаром
local Accent = Instance.new("Frame")
Accent.Size = UDim2.new(0, 120, 0, 2)
Accent.Position = UDim2.new(0, 46, 1, -3)
Accent.BackgroundColor3 = Color3.fromRGB(255, 30, 30)
Accent.BorderSizePixel = 0
Accent.Parent = TopBar

local AccentGradient = Instance.new("UIGradient")
AccentGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 30, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 140, 40)),
}
AccentGradient.Parent = Accent

-- Тонкая верхняя подсветка
local TopHighlight = Instance.new("Frame")
TopHighlight.Size = UDim2.new(1, -20, 0, 1)
TopHighlight.Position = UDim2.new(0, 10, 0, 0)
TopHighlight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TopHighlight.BackgroundTransparency = 0.9
TopHighlight.BorderSizePixel = 0
TopHighlight.Parent = Main

-- ===== КНОПКИ ЗАКРЫТЬ / СВЕРНУТЬ =====
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -38, 0.5, -14)
CloseBtn.BackgroundColor3 = Color3.fromRGB(35, 15, 15)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(220, 180, 180)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseBtn

local CloseStroke = Instance.new("UIStroke")
CloseStroke.Color = Color3.fromRGB(80, 20, 20)
CloseStroke.Thickness = 1
CloseStroke.Parent = CloseBtn

CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 30, 30), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    TweenService:Create(CloseStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(255, 100, 100)}):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 15, 15), TextColor3 = Color3.fromRGB(220, 180, 180)}):Play()
    TweenService:Create(CloseStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(80, 20, 20)}):Play()
end)

CloseBtn.MouseButton1Click:Connect(function()
    if closeGUI then task.defer(closeGUI) end
end)

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 28, 0, 28)
MinBtn.Position = UDim2.new(1, -72, 0.5, -14)
MinBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MinBtn.BorderSizePixel = 0
MinBtn.Text = "—"
MinBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MinBtn.TextSize = 14
MinBtn.Font = Enum.Font.GothamBold
MinBtn.AutoButtonColor = false
MinBtn.Parent = TopBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(1, 0)
MinCorner.Parent = MinBtn

local MinStroke = Instance.new("UIStroke")
MinStroke.Color = Color3.fromRGB(50, 50, 50)
MinStroke.Thickness = 1
MinStroke.Parent = MinBtn

MinBtn.MouseEnter:Connect(function()
    TweenService:Create(MinBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60), TextColor3 = Color3.fromRGB(255, 200, 100)}):Play()
    TweenService:Create(MinStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(255, 200, 100)}):Play()
end)
MinBtn.MouseLeave:Connect(function()
    TweenService:Create(MinBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 25), TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
    TweenService:Create(MinStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(50, 50, 50)}):Play()
end)

MinBtn.MouseButton1Click:Connect(function()
    if closeGUI then task.defer(closeGUI) end
end)

-- ===== SIDEBAR =====
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 140, 1, -58)
Sidebar.Position = UDim2.new(0, 10, 0, 48)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
Sidebar.BorderSizePixel = 0
Sidebar.BackgroundTransparency = 1
Sidebar.Parent = Main

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 10)
SidebarCorner.Parent = Sidebar

local SidebarGradient = Instance.new("UIGradient")
SidebarGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 22, 26)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 14, 16)),
}
SidebarGradient.Rotation = 90
SidebarGradient.Parent = Sidebar

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingTop = UDim.new(0, 8)
SidebarPadding.PaddingLeft = UDim.new(0, 8)
SidebarPadding.PaddingRight = UDim.new(0, 8)
SidebarPadding.PaddingBottom = UDim.new(0, 8)
SidebarPadding.Parent = Sidebar

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 6)
SidebarLayout.Parent = Sidebar

-- ===== CONTENT =====
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -170, 1, -58)
Content.Position = UDim2.new(0, 160, 0, 48)
Content.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
Content.BorderSizePixel = 0
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 4
Content.ScrollBarImageColor3 = Color3.fromRGB(255, 30, 30)
Content.ScrollBarImageTransparency = 0.3
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
Content.ScrollingDirection = Enum.ScrollingDirection.Y
Content.Parent = Main

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 10)
ContentCorner.Parent = Content

local ContentGradient = Instance.new("UIGradient")
ContentGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 24)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(13, 13, 15)),
}
ContentGradient.Rotation = 90
ContentGradient.Parent = Content

local ContentPadding = Instance.new("UIPadding")
ContentPadding.PaddingTop = UDim.new(0, 10)
ContentPadding.PaddingLeft = UDim.new(0, 10)
ContentPadding.PaddingRight = UDim.new(0, 10)
ContentPadding.PaddingBottom = UDim.new(0, 10)
ContentPadding.Parent = Content

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Padding = UDim.new(0, 8)
ContentLayout.Parent = Content

-- Заголовок вкладки с акцентной полоской
local ContentTitleHolder = Instance.new("Frame")
ContentTitleHolder.Size = UDim2.new(1, 0, 0, 30)
ContentTitleHolder.BackgroundTransparency = 1
ContentTitleHolder.LayoutOrder = 0
ContentTitleHolder.Parent = Content

local ContentTitleBar = Instance.new("Frame")
ContentTitleBar.Size = UDim2.new(0, 3, 0, 16)
ContentTitleBar.Position = UDim2.new(0, 0, 0.5, -8)
ContentTitleBar.BackgroundColor3 = Color3.fromRGB(255, 30, 30)
ContentTitleBar.BorderSizePixel = 0
ContentTitleBar.Parent = ContentTitleHolder

local CTBarCorner = Instance.new("UICorner")
CTBarCorner.CornerRadius = UDim.new(1, 0)
CTBarCorner.Parent = ContentTitleBar

local ContentTitle = Instance.new("TextLabel")
ContentTitle.Size = UDim2.new(1, -14, 1, 0)
ContentTitle.Position = UDim2.new(0, 14, 0, 0)
ContentTitle.BackgroundTransparency = 1
ContentTitle.Text = "COMBAT"
ContentTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
ContentTitle.TextSize = 16
ContentTitle.Font = Enum.Font.GothamBlack
ContentTitle.TextXAlignment = Enum.TextXAlignment.Left
ContentTitle.Parent = ContentTitleHolder

-- =========================================================
-- MINI-HUD (строчный, правый верхний угол)
-- SLAUGHTER  •  NICK  •  PING  •  FPS
-- =========================================================
local MiniHudGui = Instance.new("ScreenGui")
MiniHudGui.Name = "SlaughterMiniHudGui"
MiniHudGui.ResetOnSpawn = false
MiniHudGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MiniHudGui.IgnoreGuiInset = true
MiniHudGui.DisplayOrder = 100
pcall(function() MiniHudGui.Parent = CoreGui end)
if not MiniHudGui.Parent then MiniHudGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local MiniHud = Instance.new("Frame")
MiniHud.Name = "SlaughterMiniHud"
MiniHud.Size = UDim2.new(0, 340, 0, 32)
MiniHud.Position = UDim2.new(1, -355, 0, 10)
MiniHud.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
MiniHud.BackgroundTransparency = 0.15
MiniHud.BorderSizePixel = 0
MiniHud.Visible = false
MiniHud.ZIndex = 10
MiniHud.Parent = MiniHudGui

local MHCorner = Instance.new("UICorner")
MHCorner.CornerRadius = UDim.new(0, 8)
MHCorner.Parent = MiniHud

local MHStroke = Instance.new("UIStroke")
MHStroke.Color = Color3.fromRGB(255, 30, 30)
MHStroke.Thickness = 1
MHStroke.Transparency = 0.4
MHStroke.Parent = MiniHud

-- Красная точка слева
local MHDot = Instance.new("Frame")
MHDot.Size = UDim2.new(0, 6, 0, 6)
MHDot.Position = UDim2.new(0, 10, 0.5, -3)
MHDot.BackgroundColor3 = Color3.fromRGB(255, 30, 30)
MHDot.BorderSizePixel = 0
MHDot.Parent = MiniHud

local MHDotCorner = Instance.new("UICorner")
MHDotCorner.CornerRadius = UDim.new(1, 0)
MHDotCorner.Parent = MHDot

-- Логотип
local MHTitle = Instance.new("TextLabel")
MHTitle.Size = UDim2.new(0, 90, 1, 0)
MHTitle.Position = UDim2.new(0, 22, 0, 0)
MHTitle.BackgroundTransparency = 1
MHTitle.Text = "SLAUGHTER"
MHTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
MHTitle.TextSize = 11
MHTitle.Font = Enum.Font.GothamBlack
MHTitle.TextXAlignment = Enum.TextXAlignment.Left
MHTitle.Parent = MiniHud

-- Разделитель 1
local MHDiv1 = Instance.new("Frame")
MHDiv1.Size = UDim2.new(0, 1, 0, 14)
MHDiv1.Position = UDim2.new(0, 112, 0.5, -7)
MHDiv1.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
MHDiv1.BorderSizePixel = 0
MHDiv1.Parent = MiniHud

-- Ник
local MHNick = Instance.new("TextLabel")
MHNick.Size = UDim2.new(0, 90, 1, 0)
MHNick.Position = UDim2.new(0, 122, 0, 0)
MHNick.BackgroundTransparency = 1
MHNick.Text = LocalPlayer.DisplayName or LocalPlayer.Name
MHNick.TextColor3 = Color3.fromRGB(255, 140, 40)
MHNick.TextSize = 11
MHNick.Font = Enum.Font.GothamBold
MHNick.TextXAlignment = Enum.TextXAlignment.Left
MHNick.TextTruncate = Enum.TextTruncate.AtEnd
MHNick.Parent = MiniHud

-- Разделитель 2
local MHDiv2 = Instance.new("Frame")
MHDiv2.Size = UDim2.new(0, 1, 0, 14)
MHDiv2.Position = UDim2.new(0, 212, 0.5, -7)
MHDiv2.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
MHDiv2.BorderSizePixel = 0
MHDiv2.Parent = MiniHud

-- PING
local MHPing = Instance.new("TextLabel")
MHPing.Size = UDim2.new(0, 60, 1, 0)
MHPing.Position = UDim2.new(0, 222, 0, 0)
MHPing.BackgroundTransparency = 1
MHPing.Text = "PING --"
MHPing.TextColor3 = Color3.fromRGB(200, 200, 210)
MHPing.TextSize = 11
MHPing.Font = Enum.Font.GothamMedium
MHPing.TextXAlignment = Enum.TextXAlignment.Left
MHPing.Parent = MiniHud

-- Разделитель 3
local MHDiv3 = Instance.new("Frame")
MHDiv3.Size = UDim2.new(0, 1, 0, 14)
MHDiv3.Position = UDim2.new(0, 282, 0.5, -7)
MHDiv3.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
MHDiv3.BorderSizePixel = 0
MHDiv3.Parent = MiniHud

-- FPS
local MHFPS = Instance.new("TextLabel")
MHFPS.Size = UDim2.new(0, 55, 1, 0)
MHFPS.Position = UDim2.new(0, 292, 0, 0)
MHFPS.BackgroundTransparency = 1
MHFPS.Text = "FPS --"
MHFPS.TextColor3 = Color3.fromRGB(200, 200, 210)
MHFPS.TextSize = 11
MHFPS.Font = Enum.Font.GothamMedium
MHFPS.TextXAlignment = Enum.TextXAlignment.Left
MHFPS.Parent = MiniHud

-- ===== Обновление FPS и Ping =====
-- Соединения хранятся в переменных, чтобы отключать их в unloadScript
local fpsFrameConnection = nil
local fpsLoopTask = nil

fpsFrameConnection = RunService.RenderStepped:Connect(function()
    _G.MINI_HUD_FPS_FRAMES = (_G.MINI_HUD_FPS_FRAMES or 0) + 1
end)

fpsLoopTask = task.spawn(function()
    local lastTime = tick()
    local fps = 60

    while MiniHud.Parent do
        task.wait(0.5)
        local now = tick()
        local elapsed = now - lastTime
        if elapsed > 0 then
            fps = math.floor((_G.MINI_HUD_FPS_FRAMES or 0) / elapsed + 0.5)
        end
        _G.MINI_HUD_FPS_FRAMES = 0
        lastTime = now

        MHFPS.Text = "FPS " .. fps

        MHPing.Text = "PING 0"
    end
end)

-- =========================================================
-- PLAYER CARD (внутри Main, прижат к правому нижнему углу окна)
-- =========================================================
local PlayerCard = Instance.new("Frame")
PlayerCard.Name = "SlaughterPlayerCard"
PlayerCard.Size = UDim2.new(0, 155, 0, 50)
PlayerCard.Position = UDim2.new(0, 10, 1, -60)
PlayerCard.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
PlayerCard.BackgroundTransparency = 0.1
PlayerCard.BorderSizePixel = 0
PlayerCard.ZIndex = 20
PlayerCard.Parent = Main

local PCCorner = Instance.new("UICorner")
PCCorner.CornerRadius = UDim.new(0, 10)
PCCorner.Parent = PlayerCard

local PCStroke = Instance.new("UIStroke")
PCStroke.Color = Color3.fromRGB(255, 30, 30)
PCStroke.Thickness = 1
PCStroke.Transparency = 0.4
PCStroke.Parent = PlayerCard

local PCTop = Instance.new("Frame")
PCTop.Size = UDim2.new(1, -16, 0, 1)
PCTop.Position = UDim2.new(0, 8, 0, 1)
PCTop.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PCTop.BackgroundTransparency = 0.9
PCTop.BorderSizePixel = 0
PCTop.Parent = PlayerCard

local PCAvatarFrame = Instance.new("Frame")
PCAvatarFrame.Size = UDim2.new(0, 40, 0, 40)
PCAvatarFrame.Position = UDim2.new(0, 8, 0.5, -20)
PCAvatarFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
PCAvatarFrame.BorderSizePixel = 0
PCAvatarFrame.Parent = PlayerCard

local PCAvFrameCorner = Instance.new("UICorner")
PCAvFrameCorner.CornerRadius = UDim.new(0, 8)
PCAvFrameCorner.Parent = PCAvatarFrame

local PCAvFrameStroke = Instance.new("UIStroke")
PCAvFrameStroke.Color = Color3.fromRGB(255, 60, 60)
PCAvFrameStroke.Thickness = 1
PCAvFrameStroke.Parent = PCAvatarFrame

local PCAvatar = Instance.new("ImageLabel")
PCAvatar.Name = "Avatar"
PCAvatar.Size = UDim2.new(1, -4, 1, -4)
PCAvatar.Position = UDim2.new(0, 2, 0, 2)
PCAvatar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
PCAvatar.BorderSizePixel = 0
PCAvatar.Image = ""
PCAvatar.Parent = PCAvatarFrame

local PCAvCorner = Instance.new("UICorner")
PCAvCorner.CornerRadius = UDim.new(0, 6)
PCAvCorner.Parent = PCAvatar

local PCName = Instance.new("TextLabel")
PCName.TextSize = 12
PCName.BackgroundTransparency = 1
PCName.Text = LocalPlayer.DisplayName or LocalPlayer.Name
PCName.TextColor3 = Color3.fromRGB(255, 255, 255)
PCName.Size = UDim2.new(1, -60, 0, 15)
PCName.Position = UDim2.new(0, 56, 0, 12)
PCName.Font = Enum.Font.GothamBold
PCName.TextXAlignment = Enum.TextXAlignment.Left
PCName.TextTruncate = Enum.TextTruncate.AtEnd
PCName.Parent = PlayerCard

local PCDisplay = Instance.new("TextLabel")
PCDisplay.Size = UDim2.new(1, -60, 0, 13)
PCDisplay.Position = UDim2.new(0, 56, 0, 30)
PCDisplay.BackgroundTransparency = 1
PCDisplay.Text = "@" .. LocalPlayer.Name
PCDisplay.TextColor3 = Color3.fromRGB(160, 160, 170)
PCDisplay.TextSize = 10
PCDisplay.Font = Enum.Font.Gotham
PCDisplay.TextXAlignment = Enum.TextXAlignment.Left
PCDisplay.TextTruncate = Enum.TextTruncate.AtEnd
PCDisplay.Parent = PlayerCard

local PCOnline = Instance.new("Frame")
PCOnline.Size = UDim2.new(0, 7, 0, 7)
PCOnline.Position = UDim2.new(1, -14, 0, 12)
PCOnline.BackgroundColor3 = Color3.fromRGB(80, 255, 120)
PCOnline.BorderSizePixel = 0
PCOnline.Parent = PlayerCard

local PCOCorner = Instance.new("UICorner")
PCOCorner.CornerRadius = UDim.new(1, 0)
PCOCorner.Parent = PCOnline

pcall(function()
    PCAvatar.Image = ("rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150"):format(LocalPlayer.UserId)
end)

local tabs = {}

-- =========================================================
-- УТИЛИТЫ: СКРОЛЛ КОЛЕСИКОМ + ПОД-ОКНА
-- =========================================================

-- Хранилище активного ScrollingFrame, которое слушает колесо
local activeScrollFrame = nil

-- Устанавливает, какой ScrollingFrame сейчас крутится колесом
local function attachMouseWheelScroll(scrollingFrame)
    activeScrollFrame = scrollingFrame
end

-- Глобальный слушатель колеса — крутит активный ScrollingFrame
local scrollConnection = UserInputService.InputChanged:Connect(function(input, gameProcessed)
    if input.UserInputType ~= Enum.UserInputType.MouseWheel then return end
    if not ScreenGui.Enabled then return end

    local frame = activeScrollFrame
    if not frame or not frame.Parent then return end

    local delta = -input.Position.Z * 50
    local maxY = math.max(0, frame.AbsoluteCanvasSize.Y - frame.AbsoluteSize.Y)
    local newY = math.clamp(frame.CanvasPosition.Y + delta, 0, maxY)
    frame.CanvasPosition = Vector2.new(frame.CanvasPosition.X, newY)
end)

-- Создаёт раскрывающееся под-окно внутри родителя
-- parent: куда положить (Container вкладки)
-- title: надпись на кнопке-переключателе
-- initialOpen: открыто ли сразу
local function makeCollapsible(parent, title, initialOpen)
    local wrapper = Instance.new("Frame")
    wrapper.Size = UDim2.new(1, 0, 0, 36)
    wrapper.BackgroundTransparency = 1
    wrapper.Parent = parent
    wrapper.AutomaticSize = Enum.AutomaticSize.Y
    wrapper.ClipsDescendants = true

    local wrapperLayout = Instance.new("UIListLayout")
    wrapperLayout.SortOrder = Enum.SortOrder.LayoutOrder
    wrapperLayout.Padding = UDim.new(0, 6)
    wrapperLayout.Parent = wrapper

    local HeaderBtn = Instance.new("TextButton")
    HeaderBtn.Size = UDim2.new(1, 0, 0, 36)
    HeaderBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    HeaderBtn.BorderSizePixel = 0
    HeaderBtn.Text = "▶  " .. title
    HeaderBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
    HeaderBtn.TextSize = 13
    HeaderBtn.Font = Enum.Font.GothamMedium
    HeaderBtn.TextXAlignment = Enum.TextXAlignment.Left
    HeaderBtn.Active = false
    HeaderBtn.Parent = wrapper

    local HBC = Instance.new("UICorner")
    HBC.CornerRadius = UDim.new(0, 6)
    HBC.Parent = HeaderBtn

    local HBS = Instance.new("UIStroke")
    HBS.Color = Color3.fromRGB(40, 40, 40)
    HBS.Thickness = 1
    HBS.Parent = HeaderBtn

    local HBPad = Instance.new("UIPadding")
    HBPad.PaddingLeft = UDim.new(0, 12)
    HBPad.Parent = HeaderBtn

    local Body = Instance.new("Frame")
    Body.Size = UDim2.new(1, 0, 0, 0)
    Body.BackgroundTransparency = 1
    Body.Visible = initialOpen or false
    Body.AutomaticSize = Enum.AutomaticSize.Y
    Body.Parent = wrapper

    local BodyLayout = Instance.new("UIListLayout")
    BodyLayout.SortOrder = Enum.SortOrder.LayoutOrder
    BodyLayout.Padding = UDim.new(0, 6)
    BodyLayout.Parent = Body

    local BodyPad = Instance.new("UIPadding")
    BodyPad.PaddingLeft = UDim.new(0, 8)
    BodyPad.PaddingRight = UDim.new(0, 0)
    BodyPad.Parent = Body

    local isOpen = initialOpen or false

    local function updateHeader()
        HeaderBtn.Text = (isOpen and "▼  " or "▶  ") .. title
    end
    updateHeader()

    HeaderBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        Body.Visible = isOpen
        updateHeader()
    end)

    HeaderBtn.MouseEnter:Connect(function()
        TweenService:Create(HeaderBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
    end)
    HeaderBtn.MouseLeave:Connect(function()
        TweenService:Create(HeaderBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
    end)

    return Body
end

local function createTab(name, displayName)
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, 0, 0, 36)
    TabButton.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    TabButton.BorderSizePixel = 0
    TabButton.Text = ""
    TabButton.AutoButtonColor = false
    TabButton.Parent = Sidebar

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = TabButton

    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Color = Color3.fromRGB(30, 30, 35)
    BtnStroke.Thickness = 1
    BtnStroke.Parent = TabButton

    -- Индикатор слева (полоска) — появляется при выборе
    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 3, 0.5, 0)
    Indicator.Position = UDim2.new(0, 0, 0.5, 0)
    Indicator.AnchorPoint = Vector2.new(0, 0.5)
    Indicator.BackgroundColor3 = Color3.fromRGB(255, 30, 30)
    Indicator.BorderSizePixel = 0
    Indicator.BackgroundTransparency = 1
    Indicator.Parent = TabButton

    local IndCorner = Instance.new("UICorner")
    IndCorner.CornerRadius = UDim.new(1, 0)
    IndCorner.Parent = Indicator

    -- Иконка-точка
    local IconDot = Instance.new("Frame")
    IconDot.Size = UDim2.new(0, 6, 0, 6)
    IconDot.Position = UDim2.new(0, 12, 0.5, -3)
    IconDot.BackgroundColor3 = Color3.fromRGB(100, 100, 110)
    IconDot.BorderSizePixel = 0
    IconDot.Parent = TabButton

    local IconCorner = Instance.new("UICorner")
    IconCorner.CornerRadius = UDim.new(1, 0)
    IconCorner.Parent = IconDot

    local TabLabel = Instance.new("TextLabel")
    TabLabel.Size = UDim2.new(1, -30, 1, 0)
    TabLabel.Position = UDim2.new(0, 26, 0, 0)
    TabLabel.BackgroundTransparency = 1
    TabLabel.Text = displayName or name
    TabLabel.TextColor3 = Color3.fromRGB(170, 170, 180)
    TabLabel.TextSize = 13
    TabLabel.Font = Enum.Font.GothamMedium
    TabLabel.TextXAlignment = Enum.TextXAlignment.Left
    TabLabel.Parent = TabButton

    -- Свой ScrollingFrame на каждую вкладку
    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.Size = UDim2.new(1, 0, 1, -40)
    TabScroll.Position = UDim2.new(0, 0, 0, 40)
    TabScroll.BackgroundTransparency = 1
    TabScroll.BorderSizePixel = 0
    TabScroll.Visible = false
    TabScroll.ScrollBarThickness = 4
    TabScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 30, 30)
    TabScroll.ScrollBarImageTransparency = 0.3
    TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabScroll.ScrollingDirection = Enum.ScrollingDirection.Y
    TabScroll.Active = true
    TabScroll.Parent = Content

    local TabScrollPad = Instance.new("UIPadding")
    TabScrollPad.PaddingTop = UDim.new(0, 4)
    TabScrollPad.PaddingBottom = UDim.new(0, 8)
    TabScrollPad.PaddingRight = UDim.new(0, 4)
    TabScrollPad.Parent = TabScroll

    local TabScrollLayout = Instance.new("UIListLayout")
    TabScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabScrollLayout.Padding = UDim.new(0, 8)
    TabScrollLayout.Parent = TabScroll

    tabs[name] = { Button = TabButton, Container = TabScroll, Layout = TabScrollLayout, Label = TabLabel, Dot = IconDot, Ind = Indicator, Stroke = BtnStroke }

    TabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(tabs) do
            TweenService:Create(tab.Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20, 20, 24)}):Play()
            TweenService:Create(tab.Label, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(170, 170, 180)}):Play()
            TweenService:Create(tab.Dot, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 100, 110)}):Play()
            TweenService:Create(tab.Ind, TweenInfo.new(0.2), {BackgroundTransparency = 1, Size = UDim2.new(0, 3, 0.5, 0)}):Play()
            if tab.Stroke then
                TweenService:Create(tab.Stroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(30, 30, 35)}):Play()
            end
            tab.Container.Visible = false
        end
        TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 12, 12)}):Play()
        TweenService:Create(TabLabel, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        TweenService:Create(IconDot, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 30, 30)}):Play()
        TweenService:Create(Indicator, TweenInfo.new(0.25), {BackgroundTransparency = 0, Size = UDim2.new(0, 3, 0.7, 0)}):Play()
        TweenService:Create(BtnStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(255, 60, 60)}):Play()
        TabScroll.Visible = true
        ContentTitle.Text = (displayName or name):upper()

        attachMouseWheelScroll(TabScroll)
    end)

    -- Hover
    TabButton.MouseEnter:Connect(function()
        if TabScroll.Visible then return end
        TweenService:Create(TabButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(28, 28, 32)}):Play()
        TweenService:Create(TabLabel, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(220, 220, 230)}):Play()
    end)
    TabButton.MouseLeave:Connect(function()
        if TabScroll.Visible then return end
        TweenService:Create(TabButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(20, 20, 24)}):Play()
        TweenService:Create(TabLabel, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(170, 170, 180)}):Play()
    end)

    return tabs[name]
end

createTab("COMBAT", "COMBAT")
createTab("ESP", "ESP")
createTab("Misc", "Misc")
createTab("Places", "Places")
createTab("Settings", "Settings")

-- Красиво активируем стартовую вкладку
local startTab = tabs["COMBAT"]
startTab.Button.BackgroundColor3 = Color3.fromRGB(30, 12, 12)
startTab.Label.TextColor3 = Color3.fromRGB(255, 255, 255)
startTab.Dot.BackgroundColor3 = Color3.fromRGB(255, 30, 30)
startTab.Ind.BackgroundTransparency = 0
startTab.Ind.Size = UDim2.new(0, 3, 0.7, 0)
startTab.Stroke.Color = Color3.fromRGB(255, 60, 60)
startTab.Container.Visible = true

attachMouseWheelScroll(startTab.Container)

-- =========================================================
-- ХЕЛПЕР: Toggle
-- =========================================================
local function makeToggle(parent, labelText, default, callback)
    local state = default or false
    local lastClick = 0

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 38)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    Frame.BorderSizePixel = 0
    Frame.Parent = parent

    local FC = Instance.new("UICorner")
    FC.CornerRadius = UDim.new(0, 8)
    FC.Parent = Frame

    local FS = Instance.new("UIStroke")
    FS.Color = Color3.fromRGB(35, 35, 40)
    FS.Thickness = 1
    FS.Parent = Frame

    -- Индикатор-точка слева
    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.new(0, 6, 0, 6)
    Dot.Position = UDim2.new(0, 10, 0.5, -3)
    Dot.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
    Dot.BorderSizePixel = 0
    Dot.Parent = Frame

    local DotCorner = Instance.new("UICorner")
    DotCorner.CornerRadius = UDim.new(1, 0)
    DotCorner.Parent = Dot

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -90, 1, 0)
    Label.Position = UDim2.new(0, 24, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = labelText
    Label.TextColor3 = Color3.fromRGB(200, 200, 210)
    Label.TextSize = 13
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    -- Тонкий разделитель
    local Divider = Instance.new("Frame")
    Divider.Size = UDim2.new(1, -20, 0, 1)
    Divider.Position = UDim2.new(0, 10, 1, -1)
    Divider.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Divider.BorderSizePixel = 0
    Divider.Parent = Frame

    -- Switch (pill)
    local Switch = Instance.new("Frame")
    Switch.Size = UDim2.new(0, 42, 0, 22)
    Switch.Position = UDim2.new(1, -54, 0.5, -11)
    Switch.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    Switch.BorderSizePixel = 0
    Switch.Parent = Frame

    local SC = Instance.new("UICorner")
    SC.CornerRadius = UDim.new(1, 0)
    SC.Parent = Switch

    local SwitchStroke = Instance.new("UIStroke")
    SwitchStroke.Color = Color3.fromRGB(50, 50, 55)
    SwitchStroke.Thickness = 1
    SwitchStroke.Parent = Switch

    -- Внутренний glow в switch (для ON)
    local SwitchGlow = Instance.new("Frame")
    SwitchGlow.Size = UDim2.new(1, -4, 1, -4)
    SwitchGlow.Position = UDim2.new(0, 2, 0, 2)
    SwitchGlow.BackgroundColor3 = Color3.fromRGB(255, 30, 30)
    SwitchGlow.BorderSizePixel = 0
    SwitchGlow.BackgroundTransparency = 1
    SwitchGlow.Parent = Switch

    local SGCorner = Instance.new("UICorner")
    SGCorner.CornerRadius = UDim.new(1, 0)
    SGCorner.Parent = SwitchGlow

    -- Knob
    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 16, 0, 16)
    Knob.Position = UDim2.new(0, 3, 0.5, -8)
    Knob.BackgroundColor3 = Color3.fromRGB(130, 130, 140)
    Knob.BorderSizePixel = 0
    Knob.ZIndex = 2
    Knob.Parent = Switch

    local KC = Instance.new("UICorner")
    KC.CornerRadius = UDim.new(1, 0)
    KC.Parent = Knob

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.BackgroundTransparency = 1
    Btn.Text = ""
    Btn.Active = false
    Btn.Parent = Frame

    local function updateVisual()
        if state then
            TweenService:Create(Switch, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(200, 25, 25)}):Play()
            TweenService:Create(SwitchStroke, TweenInfo.new(0.25), {Color = Color3.fromRGB(255, 80, 80)}):Play()
            TweenService:Create(SwitchGlow, TweenInfo.new(0.25), {BackgroundTransparency = 0.7}):Play()
            TweenService:Create(Knob, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = UDim2.new(1, -19, 0.5, -8),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
            TweenService:Create(Dot, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(255, 30, 30), Size = UDim2.new(0, 8, 0, 8), Position = UDim2.new(0, 9, 0.5, -4)}):Play()
            TweenService:Create(Label, TweenInfo.new(0.25), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            TweenService:Create(FS, TweenInfo.new(0.25), {Color = Color3.fromRGB(80, 25, 25)}):Play()
        else
            TweenService:Create(Switch, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}):Play()
            TweenService:Create(SwitchStroke, TweenInfo.new(0.25), {Color = Color3.fromRGB(50, 50, 55)}):Play()
            TweenService:Create(SwitchGlow, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
            TweenService:Create(Knob, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 3, 0.5, -8),
                BackgroundColor3 = Color3.fromRGB(130, 130, 140)
            }):Play()
            TweenService:Create(Dot, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(80, 80, 90), Size = UDim2.new(0, 6, 0, 6), Position = UDim2.new(0, 10, 0.5, -3)}):Play()
            TweenService:Create(Label, TweenInfo.new(0.25), {TextColor3 = Color3.fromRGB(200, 200, 210)}):Play()
            TweenService:Create(FS, TweenInfo.new(0.25), {Color = Color3.fromRGB(35, 35, 40)}):Play()
        end
    end

    updateVisual()

    Btn.MouseButton1Click:Connect(function()
        local now = tick()
        if now - lastClick < 0.3 then return end
        lastClick = now
        state = not state
        updateVisual()
        if callback then pcall(callback, state) end
    end)

    -- Hover
    Btn.MouseEnter:Connect(function()
        TweenService:Create(Frame, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(26, 26, 30)}):Play()
        TweenService:Create(FS, TweenInfo.new(0.15), {Color = state and Color3.fromRGB(120, 30, 30) or Color3.fromRGB(50, 50, 58)}):Play()
    end)
    Btn.MouseLeave:Connect(function()
        TweenService:Create(Frame, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(20, 20, 24)}):Play()
        TweenService:Create(FS, TweenInfo.new(0.15), {Color = state and Color3.fromRGB(80, 25, 25) or Color3.fromRGB(35, 35, 40)}):Play()
    end)

    return {
        Set = function(v)
            state = v
            lastClick = 0   -- сброс cooldown, чтобы клики после Set не глотались
            updateVisual()
            if callback then pcall(callback, state) end
        end,
        Get = function() return state end
    }
end

-- =========================================================
-- ХЕЛПЕР: Slider (ползунок)
-- =========================================================
-- Хранилище drag-соединений для слайдеров (защита от утечек)
local sliderDragConnections = {}

local function makeSlider(parent, labelText, minVal, maxVal, default, callback)
    local value = default or minVal

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 52)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    Frame.BorderSizePixel = 0
    Frame.Parent = parent

    local FC = Instance.new("UICorner")
    FC.CornerRadius = UDim.new(0, 8)
    FC.Parent = Frame

    local FS = Instance.new("UIStroke")
    FS.Color = Color3.fromRGB(35, 35, 40)
    FS.Thickness = 1
    FS.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -90, 0, 20)
    Label.Position = UDim2.new(0, 12, 0, 6)
    Label.BackgroundTransparency = 1
    Label.Text = labelText
    Label.TextColor3 = Color3.fromRGB(200, 200, 210)
    Label.TextSize = 13
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    -- Pill для значения
    local ValuePill = Instance.new("Frame")
    ValuePill.Size = UDim2.new(0, 54, 0, 20)
    ValuePill.Position = UDim2.new(1, -66, 0, 6)
    ValuePill.BackgroundColor3 = Color3.fromRGB(35, 20, 20)
    ValuePill.BorderSizePixel = 0
    ValuePill.Parent = Frame

    local VPCorner = Instance.new("UICorner")
    VPCorner.CornerRadius = UDim.new(0, 6)
    VPCorner.Parent = ValuePill

    local VPStroke = Instance.new("UIStroke")
    VPStroke.Color = Color3.fromRGB(80, 30, 30)
    VPStroke.Thickness = 1
    VPStroke.Parent = ValuePill

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(1, 0, 1, 0)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(value)
    ValueLabel.TextColor3 = Color3.fromRGB(255, 140, 40)
    ValueLabel.TextSize = 12
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.Parent = ValuePill

    -- Track
    local TrackBg = Instance.new("Frame")
    TrackBg.Size = UDim2.new(1, -24, 0, 6)
    TrackBg.Position = UDim2.new(0, 12, 0, 36)
    TrackBg.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    TrackBg.BorderSizePixel = 0
    TrackBg.Parent = Frame

    local TrackCorner = Instance.new("UICorner")
    TrackCorner.CornerRadius = UDim.new(1, 0)
    TrackCorner.Parent = TrackBg

    local TrackStroke = Instance.new("UIStroke")
    TrackStroke.Color = Color3.fromRGB(45, 45, 50)
    TrackStroke.Thickness = 1
    TrackStroke.Parent = TrackBg

    -- Fill с градиентом
    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((value - minVal) / (maxVal - minVal), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(255, 30, 30)
    Fill.BorderSizePixel = 0
    Fill.Parent = TrackBg

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = Fill

    local FillGradient = Instance.new("UIGradient")
    FillGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 20, 20)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 100, 40)),
    }
    FillGradient.Parent = Fill

    -- Knob с glow
    local KnobGlow = Instance.new("Frame")
    KnobGlow.Size = UDim2.new(0, 18, 0, 18)
    KnobGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    KnobGlow.Position = UDim2.new((value - minVal) / (maxVal - minVal), 0, 0.5, 0)
    KnobGlow.BackgroundColor3 = Color3.fromRGB(255, 30, 30)
    KnobGlow.BackgroundTransparency = 0.7
    KnobGlow.BorderSizePixel = 0
    KnobGlow.ZIndex = 1
    KnobGlow.Parent = TrackBg

    local KGLCorner = Instance.new("UICorner")
    KGLCorner.CornerRadius = UDim.new(1, 0)
    KGLCorner.Parent = KnobGlow

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 12, 0, 12)
    Knob.AnchorPoint = Vector2.new(0.5, 0.5)
    Knob.Position = UDim2.new((value - minVal) / (maxVal - minVal), 0, 0.5, 0)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.BorderSizePixel = 0
    Knob.ZIndex = 2
    Knob.Parent = TrackBg

    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob

    local KnobStroke = Instance.new("UIStroke")
    KnobStroke.Color = Color3.fromRGB(255, 100, 100)
    KnobStroke.Thickness = 1
    KnobStroke.Parent = Knob

    local ClickArea = Instance.new("TextButton")
    ClickArea.Size = UDim2.new(1, 0, 1, 6)
    ClickArea.Position = UDim2.new(0, 0, 0.5, -3)
    ClickArea.BackgroundTransparency = 1
    ClickArea.Text = ""
    ClickArea.Active = false
    ClickArea.Parent = TrackBg

    local dragging = false

    local function updateFromMouse(mouseX)
        local trackAbsX = TrackBg.AbsolutePosition.X
        local trackAbsW = TrackBg.AbsoluteSize.X
        local relX = math.clamp((mouseX - trackAbsX) / trackAbsW, 0, 1)
        value = math.floor(minVal + relX * (maxVal - minVal))
        Fill.Size = UDim2.new(relX, 0, 1, 0)
        Knob.Position = UDim2.new(relX, 0, 0.5, 0)
        KnobGlow.Position = UDim2.new(relX, 0, 0.5, 0)
        ValueLabel.Text = tostring(value)
        if callback then pcall(callback, value) end
    end

    ClickArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            TweenService:Create(KnobGlow, TweenInfo.new(0.15), {BackgroundTransparency = 0.4, Size = UDim2.new(0, 22, 0, 22)}):Play()
            TweenService:Create(Knob, TweenInfo.new(0.15), {Size = UDim2.new(0, 14, 0, 14)}):Play()
            updateFromMouse(input.Position.X)
        end
    end)

    ClickArea.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            TweenService:Create(KnobGlow, TweenInfo.new(0.2), {BackgroundTransparency = 0.7, Size = UDim2.new(0, 18, 0, 18)}):Play()
            TweenService:Create(Knob, TweenInfo.new(0.2), {Size = UDim2.new(0, 12, 0, 12)}):Play()
        end
    end)

    -- Одно соединение на слайдер, отключается при уничтожении Frame
    local dragConn = UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateFromMouse(input.Position.X)
        end
    end)
    table.insert(sliderDragConnections, dragConn)
    Frame.Destroying:Connect(function()
        pcall(function() dragConn:Disconnect() end)
    end)

    -- Hover
    ClickArea.MouseEnter:Connect(function()
        TweenService:Create(FS, TweenInfo.new(0.15), {Color = Color3.fromRGB(60, 25, 25)}):Play()
    end)
    ClickArea.MouseLeave:Connect(function()
        TweenService:Create(FS, TweenInfo.new(0.15), {Color = Color3.fromRGB(35, 35, 40)}):Play()
    end)

    return {
        Set = function(v)
            value = math.clamp(v, minVal, maxVal)
            local relX = (value - minVal) / (maxVal - minVal)
            Fill.Size = UDim2.new(relX, 0, 1, 0)
            Knob.Position = UDim2.new(relX, 0, 0.5, 0)
            KnobGlow.Position = UDim2.new(relX, 0, 0.5, 0)
            ValueLabel.Text = tostring(value)
            if callback then pcall(callback, value) end
        end,
        Get = function() return value end
    }
end

-- =========================================================
-- AIMBOT МОДУЛЬ (RAGE)
-- =========================================================

local AIM = {
    Enabled = false,
    VisibleCheck = false,
    AutoFire = false,
    DrawFOV = false,
    FOV = 150,
    TargetPart = "Head",
    TeamCheck = false,
    TargetPlayers = true,
    TargetBots = true,
}

-- Отдельный ScreenGui для круга FOV
local FOVGui = Instance.new("ScreenGui")
FOVGui.Name = "SlaughterFOVCircle"
FOVGui.ResetOnSpawn = false
FOVGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
FOVGui.IgnoreGuiInset = true
FOVGui.DisplayOrder = 4
pcall(function() FOVGui.Parent = CoreGui end)
if not FOVGui.Parent then
    FOVGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local FOVCircle = Instance.new("Frame")
FOVCircle.Name = "FOVCircle"
FOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
FOVCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
FOVCircle.BackgroundTransparency = 1
FOVCircle.BorderSizePixel = 0
FOVCircle.Visible = false
FOVCircle.ZIndex = 3
FOVCircle.Parent = FOVGui

local FOVCircleCorner = Instance.new("UICorner")
FOVCircleCorner.CornerRadius = UDim.new(1, 0)
FOVCircleCorner.Parent = FOVCircle

local FOVCircleStroke = Instance.new("UIStroke")
FOVCircleStroke.Color = Color3.fromRGB(255, 140, 40)
FOVCircleStroke.Thickness = 1.5
FOVCircleStroke.Transparency = 0.2
FOVCircleStroke.Parent = FOVCircle

-- Обновление размера круга FOV (диаметр = 2 * FOV)
local function updateFOVCircle()
    if AIM.DrawFOV then
        FOVCircle.Visible = true
        FOVCircle.Size = UDim2.new(0, AIM.FOV * 2, 0, AIM.FOV * 2)
    else
        FOVCircle.Visible = false
    end
end

-- Проверка видимости цели
local function isVisible(targetPart, myChar)
    local camera = workspace.CurrentCamera
    local origin = camera.CFrame.Position
    local direction = targetPart.Position - origin

    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.FilterDescendantsInstances = { myChar, targetPart.Parent }
    rayParams.IgnoreWater = true

    local result = workspace:Raycast(origin, direction, rayParams)
    return result == nil
end

-- Кэш целей для аимбота
local AIM_TARGET_CACHE = {}
local AIM_CACHE_TIME = 0
local AIM_CACHE_INTERVAL = 0.15

local function collectAimTargets()
    local myChar = LocalPlayer.Character
    if not myChar then return {} end

    local potentialTargets = {}
    local seen = {}
    local wantPlayers = AIM.TargetPlayers
    local wantBots    = AIM.TargetBots

    if wantPlayers then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character ~= myChar then
                if not AIM.TeamCheck or (plr.Team ~= LocalPlayer.Team) then
                    potentialTargets[plr.Character] = true
                    seen[plr.Character] = true
                end
            end
        end
    end

    if wantBots then
        local function scan(container)
            for _, obj in ipairs(container:GetChildren()) do
                if obj:IsA("Model") and obj ~= myChar and not seen[obj] then
                    if not Players:GetPlayerFromCharacter(obj) then
                        if obj:FindFirstChildOfClass("Humanoid") then
                            potentialTargets[obj] = true
                            seen[obj] = true
                        end
                    end
                elseif obj:IsA("Folder") or (obj:IsA("Model") and not obj:FindFirstChildOfClass("Humanoid")) then
                    scan(obj)
                end
            end
        end
        scan(workspace)
    end

    local list = {}
    for model in pairs(potentialTargets) do
        table.insert(list, model)
    end
    return list
end

-- Получить ближайшую к прицелу цель
local function getAimTarget()
    local camera = workspace.CurrentCamera
    local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    local myChar = LocalPlayer.Character
    if not myChar then return nil end

    local now = tick()
    if now - AIM_CACHE_TIME > AIM_CACHE_INTERVAL or #AIM_TARGET_CACHE == 0 then
        AIM_TARGET_CACHE = collectAimTargets()
        AIM_CACHE_TIME = now
    end

    local bestTarget, bestPart, bestDist = nil, nil, AIM.FOV

    for _, model in ipairs(AIM_TARGET_CACHE) do
        if model and model.Parent then
            local hum = model:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local part = model:FindFirstChild(AIM.TargetPart)
                    or model:FindFirstChild("HumanoidRootPart")
                    or model:FindFirstChild("UpperTorso")
                    or model:FindFirstChild("Torso")
                    or model:FindFirstChild("Head")

                if part then
                    local screenPos, onScreen = camera:WorldToViewportPoint(part.Position)
                    if onScreen and screenPos.Z > 0 then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                        if dist < bestDist then
                            if not AIM.VisibleCheck or isVisible(part, myChar) then
                                bestDist = dist
                                bestTarget = model
                                bestPart = part
                            end
                        end
                    end
                end
            end
        end
    end

    return bestTarget, bestPart
end

-- =========================================================
-- AIMBOT: SMOOTH AIM + AUTO FIRE (v2)
-- =========================================================

-- Дополнительные настройки AIM
AIM.Smoothness = 0.35      -- 0 = мгновенно, 1 = не двигается
AIM.AutoFireDelay = 0.05   -- задержка между выстрелами
AIM.VisibleColor = false   -- красить цель в красный когда видно

-- Получаем пинг игрока (если есть) — заглушка для Wave
local function getPing()
    return 0
end

-- Автофайр: сначала пробуем executor-функции (mouse1click / mouse1press),
-- потом fallback на VirtualInputManager.
local autoFireLast = 0
local function doAutoFire()
    local now = tick()
    if now - autoFireLast < AIM.AutoFireDelay then return end
    autoFireLast = now

    -- 1) executor-функция mouse1click (лучший вариант)
    local ok = pcall(function()
        mouse1click()
    end)
    if ok then return end

    -- 2) mouse1press / mouse1release
    local ok2 = pcall(function()
        mouse1press()
        task.defer(function()
            task.wait(0.01)
            mouse1release()
        end)
    end)
    if ok2 then return end

    -- 3) fallback VirtualInputManager
    pcall(function()
        local VirtualInputManager = game:GetService("VirtualInputManager")
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
        task.defer(function()
            task.wait(0.01)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
        end)
    end)
end

-- Основной цикл AIMBOT
-- Камера НЕ переводится в Scriptable — движение не морозится.
-- Каждый кадр подмешиваем ТОЛЬКО поворот (позицию берём из текущей камеры),
-- и только когда цель в FOV. Когда цели нет — камера полностью у игрока.
local aimLastTargetPos = nil
local aimLastTargetTime = 0

aimConnection = RunService.RenderStepped:Connect(function(dt)
    local camera = workspace.CurrentCamera
    if not camera then return end

    if not AIM.Enabled then
        aimLastTargetPos = nil
        aimLastTargetTime = 0
        return
    end

    local target, part = getAimTarget()
    if not target or not part then
        -- Нет цели в FOV — вообще не трогаем камеру, игрок двигается свободно
        aimLastTargetPos = nil
        aimLastTargetTime = 0
        return
    end

    -- ===== Точка прицела =====
    local aimPos = part.Position

    -- ===== Подмешиваем ТОЛЬКО поворот =====
    -- Камера остаётся Custom → MoveDirection работает → движение не морозится.
    local camPos = camera.CFrame.Position
    local targetCF = CFrame.new(camPos, aimPos)

    if AIM.Smoothness <= 0.01 then
        camera.CFrame = targetCF
    else
        local alpha = math.clamp(1 - AIM.Smoothness, 0.05, 1)
        alpha = alpha * alpha
        -- CFrame:Lerp сохраняет позицию (обе CFrame имеют одинаковую позицию camPos)
        camera.CFrame = camera.CFrame:Lerp(targetCF, alpha)
    end

    if AIM.AutoFire then
        doAutoFire()
    end
end)

-- =========================================================
-- FAST SHOOT (KUSTOM CONSTANTS)
-- =========================================================

local RAPID_CONFIG = {
    Enabled = false,
    Speed = 50,
}

-- Подгружаем WeaponManager для изменения констант
local WeaponManager = nil
pcall(function()
    WeaponManager = require(game:GetService("ReplicatedStorage").Common.Managers.WeaponManager)
end)

local function applyRapidFire(enabled, speed)
    if not WeaponManager then return end
    
    if enabled then
        -- Врубаем пулемет
        WeaponManager.Constants.DEFAULT_FIRERATE = speed
        WeaponManager.Constants.DEFAULT_PISTOL_FIRERATE = speed
        WeaponManager.Constants.DEFAULT_RELOAD_TIME = 0.1
        WeaponManager.Constants.DEFAULT_MAGAZINE = 999
    else
        -- Возвращаем всё как было (снайперка снова болтовка)
        WeaponManager.Constants.DEFAULT_FIRERATE = 2
        WeaponManager.Constants.DEFAULT_PISTOL_FIRERATE = 4
        WeaponManager.Constants.DEFAULT_RELOAD_TIME = 0.75
        WeaponManager.Constants.DEFAULT_MAGAZINE = 1
    end
end

local rapidSettings = makeCollapsible(tabs["COMBAT"].Container, "Fast Shoot (Rapid Fire)", true)

local speedSlider

local rapidToggle = makeToggle(rapidSettings, "Enable Rapid Fire", false, function(v)
    RAPID_CONFIG.Enabled = v
    local currentSpeed = speedSlider and speedSlider.Get() or 50
    applyRapidFire(v, currentSpeed)
end)

speedSlider = makeSlider(rapidSettings, "Fire Rate Speed", 10, 100, 50, function(v)
    RAPID_CONFIG.Speed = v
    if RAPID_CONFIG.Enabled then
        applyRapidFire(true, v)
    end
end)

-- =========================================================
-- SILENT AIM (Bytenet Hook)
-- =========================================================

local SILENT_AIM = {
    Enabled = false,
    FOV = 200,
    TargetPart = "Head",
    TargetPlayers = true,
    TargetBots = true,
}

-- Безопасно ищем WeaponPackets в памяти
local WeaponPacketsTable = nil
for _, obj in ipairs(getgc(true)) do
    if type(obj) == "table" and rawget(obj, "startShoot") then
        WeaponPacketsTable = obj
        break
    end
end

-- Функция поиска цели
local function getSilentAimTarget()
    local camera = workspace.CurrentCamera
    local myChar = LocalPlayer.Character
    if not myChar then return nil end

    local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    local bestTarget, bestPart, bestDist = nil, nil, SILENT_AIM.FOV

    -- Игроки
    if SILENT_AIM.TargetPlayers then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    local part = plr.Character:FindFirstChild(SILENT_AIM.TargetPart) or plr.Character:FindFirstChild("HumanoidRootPart")
                    if part then
                        local sp, onScreen = camera:WorldToViewportPoint(part.Position)
                        if onScreen and sp.Z > 0 then
                            local dist = (Vector2.new(sp.X, sp.Y) - screenCenter).Magnitude
                            if dist < bestDist then
                                bestDist = dist
                                bestTarget = plr.Character
                                bestPart = part
                            end
                        end
                    end
                end
            end
        end
    end

    -- Боты
    if SILENT_AIM.TargetBots then
        local function scan(container)
            for _, obj in ipairs(container:GetChildren()) do
                if obj:IsA("Model") and obj ~= myChar and not Players:GetPlayerFromCharacter(obj) then
                    local hum = obj:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        local part = obj:FindFirstChild(SILENT_AIM.TargetPart) or obj:FindFirstChild("HumanoidRootPart")
                        if part then
                            local sp, onScreen = camera:WorldToViewportPoint(part.Position)
                            if onScreen and sp.Z > 0 then
                                local dist = (Vector2.new(sp.X, sp.Y) - screenCenter).Magnitude
                                if dist < bestDist then
                                    bestDist = dist
                                    bestTarget = obj
                                    bestPart = part
                                end
                            end
                        end
                    end
                elseif obj:IsA("Folder") then
                    scan(obj)
                end
            end
        end
        scan(workspace)
    end

    return bestTarget, bestPart
end

-- Устанавливаем хук на пакет выстрела
if WeaponPacketsTable and WeaponPacketsTable.startShoot then
    local oldSend = WeaponPacketsTable.startShoot.send
    
    WeaponPacketsTable.startShoot.send = function(data)
        if SILENT_AIM.Enabled and type(data) == "table" then
            local target, part = getSilentAimTarget()
            if target and part then
                -- Подменяем координаты выстрела на позицию врага
                local newData = table.clone(data)
                
                -- Наш выстрел начинается из камеры, но летит в голову
                newData.origin = workspace.CurrentCamera.CFrame.Position
                
                -- Направление на врага
                local dir = (part.Position - newData.origin).Unit
                newData.direction = dir
                
                -- Точка попадания (позиция головы)
                newData.position = part.Position
                newData.hitPoint = part.Position
                
                -- Некоторые игры требуют конкретный instance (hitPart)
                newData.hitPart = part
                newData.instance = part
                
                return oldSend(newData)
            end
        end
        return oldSend(data)
    end
    print("[SLAUGHTER] Silent Aim Hook установлен.")
else
    print("[SLAUGHTER] WeaponPackets не найден в памяти! Silent Aim не будет работать.")
end

-- UI для Silent Aim
local silentSettings = makeCollapsible(tabs["COMBAT"].Container, "Silent Aim Settings", true)

makeToggle(silentSettings, "Enable Silent Aim", false, function(v)
    SILENT_AIM.Enabled = v
end)

makeSlider(silentSettings, "Silent Aim FOV", 10, 500, 200, function(v)
    SILENT_AIM.FOV = v
end)

makeToggle(silentSettings, "Target Players", true, function(v)
    SILENT_AIM.TargetPlayers = v
end)

makeToggle(silentSettings, "Target Bots", true, function(v)
    SILENT_AIM.TargetBots = v
end)
-- =========================================================
-- RAGE: Aimbot главный тумблер + под-окно настроек
-- =========================================================

-- Главный тумблер Aimbot
makeToggle(tabs["COMBAT"].Container, "Aimbot", false, function(v) AIM.Enabled = v end)

-- Под-окно "Aimbot Settings"
local aimSettings = makeCollapsible(tabs["COMBAT"].Container, "Aimbot Settings", false)

makeToggle(aimSettings, "Visible Check", false, function(v) AIM.VisibleCheck = v end)
makeToggle(aimSettings, "Auto Fire", false, function(v) AIM.AutoFire = v end)
makeSlider(aimSettings, "Smoothness", 0, 95, 35, function(v)
    AIM.Smoothness = v / 100
end)

-- Под-окно "Target Settings" (Aimbot)
local aimTargetSettings = makeCollapsible(tabs["COMBAT"].Container, "Target Settings", false)

makeToggle(aimTargetSettings, "Players", AIM.TargetPlayers, function(v)
    AIM.TargetPlayers = v
end)
makeToggle(aimTargetSettings, "Bots", AIM.TargetBots, function(v)
    AIM.TargetBots = v
end)

-- =========================================================
-- MAGIC BULLET — телепорт всех целей в центр экрана + невидимость
-- =========================================================
local MAGIC = {
    Enabled = false,
    Connection = nil,
    Offset = 5,
    Interval = 50,
    TargetPlayers = true,
    TargetBots = true,
    SavedStates = {},
    LastTeleport = 0,
}

local function saveMagicState(model)
    if MAGIC.SavedStates[model] then return end
    local saved = { rootCFrame = nil, parts = {} }

    local root = model:FindFirstChild("HumanoidRootPart")
    if root then
        saved.rootCFrame = root.CFrame
    end

    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") then
            saved.parts[part] = {
                anchored = part.Anchored,
                cancollide = part.CanCollide,
                localTrans = part.LocalTransparencyModifier,
                size = part.Size,
            }
        end
    end

    MAGIC.SavedStates[model] = saved
end

local function restoreMagicState(model)
    local saved = MAGIC.SavedStates[model]
    if not saved then return end

    local hum = model:FindFirstChildOfClass("Humanoid")
    local isDead = (not hum) or hum.Health <= 0

    -- Всегда снимаем Anchored / возвращаем коллизию / прозрачность
    for part, data in pairs(saved.parts) do
        if part and part.Parent then
            pcall(function()
                part.Anchored = data.anchored
                part.CanCollide = data.cancollide
                part.LocalTransparencyModifier = data.localTrans
            end)
        end
    end

    -- CFrame возвращаем ТОЛЬКО живым (мёртвым — не трогаем ragdoll)
    if not isDead and saved.rootCFrame then
        local root = model:FindFirstChild("HumanoidRootPart")
        if root then
            pcall(function()
                root.Anchored = false
                root.CFrame = saved.rootCFrame
            end)
        end
    end

    MAGIC.SavedStates[model] = nil
end

local function restoreAllMagic()
    for model in pairs(MAGIC.SavedStates) do
        restoreMagicState(model)
    end
    MAGIC.SavedStates = {}
end

local function getMagicPoint()
    local cam = workspace.CurrentCamera
    if not cam then return nil end
    return cam.CFrame.Position + cam.CFrame.LookVector * MAGIC.Offset
end

local function teleportToMagicPoint(model, targetPos)
    if not model or not model.Parent then return end
    local myChar = LocalPlayer.Character
    if model == myChar then return end

    local hum = model:FindFirstChildOfClass("Humanoid")

    -- Если модель уже в SavedStates — значит она телепортирована ранее
    local alreadySaved = MAGIC.SavedStates[model] ~= nil

    -- Мёртвая цель: если она была сохранена — восстановить и выкинуть из SavedStates
    if not hum or hum.Health <= 0 then
        if alreadySaved then
            restoreMagicState(model)
        end
        return
    end

    saveMagicState(model)

    local targetCF = CFrame.new(targetPos)
    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") then
            pcall(function()
                part.CanCollide = false
                part.Anchored = true
                part.CFrame = targetCF
                part.LocalTransparencyModifier = 1
                part.AssemblyLinearVelocity = Vector3.zero
                part.AssemblyAngularVelocity = Vector3.zero
            end)
        end
    end
end

local function getMagicTargets()
    local targets = {}
    local myChar = LocalPlayer.Character

    if MAGIC.TargetPlayers then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character ~= myChar then
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    table.insert(targets, plr.Character)
                end
            end
        end
    end

    if MAGIC.TargetBots then
        local function scan(container)
            for _, obj in ipairs(container:GetChildren()) do
                if obj:IsA("Model") and obj ~= myChar then
                    if not Players:GetPlayerFromCharacter(obj) then
                        local hum = obj:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health > 0 then
                            table.insert(targets, obj)
                        end
                    end
                elseif obj:IsA("Folder") or (obj:IsA("Model") and not obj:FindFirstChildOfClass("Humanoid")) then
                    scan(obj)
                end
            end
        end
        scan(workspace)
    end

    return targets
end

local function startMagicBullet()
    if MAGIC.Connection then return end
    MAGIC.Connection = RunService.Heartbeat:Connect(function()
        if not MAGIC.Enabled then return end

        local now = tick()
        if now - MAGIC.LastTeleport < MAGIC.Interval / 1000 then return end
        MAGIC.LastTeleport = now

        -- 1) Чистим мёртвых/удалённых из SavedStates
        local toRestore = {}
        for model in pairs(MAGIC.SavedStates) do
            if not model or not model.Parent then
                table.insert(toRestore, model)
            else
                local hum = model:FindFirstChildOfClass("Humanoid")
                if not hum or hum.Health <= 0 then
                    table.insert(toRestore, model)
                end
            end
        end
        for _, model in ipairs(toRestore) do
            pcall(restoreMagicState, model)
        end

        -- 2) Телепортируем живых
        local targetPos = getMagicPoint()
        if not targetPos then return end

        for _, enemy in ipairs(getMagicTargets()) do
            pcall(teleportToMagicPoint, enemy, targetPos)
        end
    end)
end

local function stopMagicBullet()
    if MAGIC.Connection then
        MAGIC.Connection:Disconnect()
        MAGIC.Connection = nil
    end
    restoreAllMagic()
end

makeToggle(tabs["COMBAT"].Container, "Magic Bullet", false, function(v)
    MAGIC.Enabled = v
    if v then
        startMagicBullet()
    else
        stopMagicBullet()
    end
end)

local magicSettings = makeCollapsible(tabs["COMBAT"].Container, "Magic Bullet Settings", false)

makeToggle(magicSettings, "Target: Players", MAGIC.TargetPlayers, function(v)
    MAGIC.TargetPlayers = v
end)
makeToggle(magicSettings, "Target: Bots", MAGIC.TargetBots, function(v)
    MAGIC.TargetBots = v
end)
makeSlider(magicSettings, "Offset", 1, 20, 5, function(v)
    MAGIC.Offset = v
end)
makeSlider(magicSettings, "Interval (ms)", 20, 200, 50, function(v)
    MAGIC.Interval = v
end)

-- Draw FOV тумблер (сам по себе) + ползунок FOV Radius под ним
makeToggle(tabs["COMBAT"].Container, "Draw FOV", false, function(v)
    AIM.DrawFOV = v
    updateFOVCircle()
end)
makeSlider(tabs["COMBAT"].Container, "FOV Radius", 30, 600, 150, function(v)
    AIM.FOV = v
    updateFOVCircle()
end)

-- =========================================================
-- ESP МОДУЛЬ (Instance-based, работает везде)
-- =========================================================

-- Отдельный ScreenGui для боксов ESP (чтобы работал даже когда главное GUI скрыто)
local ESPBoxGui = Instance.new("ScreenGui")
ESPBoxGui.Name = "SlaughterESPBoxes"
ESPBoxGui.ResetOnSpawn = false
ESPBoxGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ESPBoxGui.IgnoreGuiInset = true
ESPBoxGui.DisplayOrder = 5
pcall(function() ESPBoxGui.Parent = CoreGui end)
if not ESPBoxGui.Parent then
    ESPBoxGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local ESP = {
    Enabled = {
        Box = false,
        Tracer = false,
        Highlight = false,
        Name = false,
        Distance = false,
    },
    TargetPlayers = true,
    TargetBots = true,
    Objects = {},
}

local ESP_COLOR = Color3.fromRGB(255, 140, 40)

-- Трассер (линия от низа экрана к цели)
local function createTracer()
    local frame = Instance.new("Frame")
    frame.Name = "SlaughterESP_Tracer"
    frame.BackgroundColor3 = ESP_COLOR
    frame.BorderSizePixel = 0
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.ZIndex = 4
    frame.Visible = false
    frame.Parent = ESPBoxGui
    return frame
end

-- Highlight (обводка модели сквозь стены)
local function createHighlight(model)
    local hl = Instance.new("Highlight")
    hl.Name = "SlaughterESP_HL"
    hl.Adornee = model
    hl.FillColor = ESP_COLOR
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.FillTransparency = 0.6
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = ESPBoxGui  -- держим в ScreenGui, а не в модели
    return hl
end

-- Создаёт красивый 2D-бокс (ScreenGui) — точно по хитбоксу модели
local function createBoxScreen()
    local frame = Instance.new("Frame")
    frame.Name = "SlaughterESP_Box"
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.Visible = false
    frame.ZIndex = 5
    frame.Parent = ESPBoxGui

    -- Верхняя линия
    local top = Instance.new("Frame")
    top.Name = "Top"
    top.BackgroundColor3 = ESP_COLOR
    top.BorderSizePixel = 0
    top.Parent = frame

    -- Нижняя линия
    local bottom = Instance.new("Frame")
    bottom.Name = "Bottom"
    bottom.BackgroundColor3 = ESP_COLOR
    bottom.BorderSizePixel = 0
    bottom.Parent = frame

    -- Левая линия
    local left = Instance.new("Frame")
    left.Name = "Left"
    left.BackgroundColor3 = ESP_COLOR
    left.BorderSizePixel = 0
    left.Parent = frame

    -- Правая линия
    local right = Instance.new("Frame")
    right.Name = "Right"
    right.BackgroundColor3 = ESP_COLOR
    right.BorderSizePixel = 0
    right.Parent = frame

    -- Верхние и нижние уголки для красоты
    local tl = Instance.new("Frame")
    tl.Name = "TL"
    tl.BackgroundColor3 = ESP_COLOR
    tl.BorderSizePixel = 0
    tl.Parent = frame

    local tr = Instance.new("Frame")
    tr.Name = "TR"
    tr.BackgroundColor3 = ESP_COLOR
    tr.BorderSizePixel = 0
    tr.Parent = frame

    local bl = Instance.new("Frame")
    bl.Name = "BL"
    bl.BackgroundColor3 = ESP_COLOR
    bl.BorderSizePixel = 0
    bl.Parent = frame

    local br = Instance.new("Frame")
    br.Name = "BR"
    br.BackgroundColor3 = ESP_COLOR
    br.BorderSizePixel = 0
    br.Parent = frame

    return frame
end

-- Имя над головой
local function createNameTag(model)
    local bb = Instance.new("BillboardGui")
    bb.Name = "SlaughterESP_Name"
    bb.Adornee = model
    bb.Size = UDim2.new(0, 200, 0, 20)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.AlwaysOnTop = true
    bb.LightInfluence = 0
    bb.MaxDistance = 1000
    bb.Parent = model

    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.Text = ""
    txt.TextColor3 = Color3.fromRGB(255, 255, 255)
    txt.TextStrokeTransparency = 0
    txt.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    txt.TextSize = 14
    txt.Font = Enum.Font.GothamBold
    txt.Parent = bb

    return bb, txt
end

-- Дистанция под ногами
local function createDistanceTag(model)
    local bb = Instance.new("BillboardGui")
    bb.Name = "SlaughterESP_Dist"
    bb.Adornee = model
    bb.Size = UDim2.new(0, 100, 0, 16)
    bb.StudsOffset = Vector3.new(0, -3, 0)
    bb.AlwaysOnTop = true
    bb.LightInfluence = 0
    bb.MaxDistance = 1000
    bb.Parent = model

    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.Text = ""
    txt.TextColor3 = Color3.fromRGB(220, 220, 220)
    txt.TextStrokeTransparency = 0
    txt.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    txt.TextSize = 12
    txt.Font = Enum.Font.Gotham
    txt.Parent = bb

    return bb, txt
end

local function attachESP(model)
    if not model or ESP.Objects[model] then return end
    local data = {
        Box = nil,
        Tracer = nil,
        NameTag = nil,
        NameText = nil,
        DistTag = nil,
        DistText = nil,
        Highlight = nil,
    }
    ESP.Objects[model] = data
end

local function detachESP(model)
    local data = ESP.Objects[model]
    if not data then return end

    -- Удаляем всё с pcall, даже если Parent уже nil
    if data.Box then
        pcall(function()
            data.Box.Visible = false
            data.Box:Destroy()
        end)
    end
    if data.Tracer then
        pcall(function()
            data.Tracer.Visible = false
            data.Tracer:Destroy()
        end)
    end
    if data.NameTag then pcall(function() data.NameTag:Destroy() end) end
    if data.DistTag then pcall(function() data.DistTag:Destroy() end) end

    -- Highlight лежит в ESPBoxGui — сбрасываем Adornee и удаляем
    if data.Highlight then
        pcall(function()
            data.Highlight.Adornee = nil
            data.Highlight:Destroy()
        end)
    end

    -- Дополнительная страховка: если Highlight остался в модели (старый формат) — чистим
    if model and model.Parent then
        local hl = model:FindFirstChild("SlaughterESP_HL")
        if hl then hl:Destroy() end
    end

    ESP.Objects[model] = nil
end

-- Хелперы: безопасно ищем Humanoid и RootPart
local function getRoot(model)
    if not model or not model.Parent then return nil end
    return model:FindFirstChild("HumanoidRootPart")
        or model:FindFirstChild("Torso")
        or model:FindFirstChild("UpperTorso")
        or model:FindFirstChild("Head")
end

local function getHumanoid(model)
    if not model or not model.Parent then return nil end
    return model:FindFirstChildOfClass("Humanoid")
end

-- ===== КЭШ ЦЕЛЕЙ ESP =====
local ESP_TARGET_CACHE = {}
local ESP_CACHE_TIME = 0
local ESP_CACHE_INTERVAL = 0.25

-- Рекурсивный сбор целей с учётом ESP.TargetType
local function getTargetsRaw()
    local targets = {}
    local myChar = LocalPlayer.Character
    local seen = {}
    local wantPlayers = ESP.TargetPlayers
    local wantBots    = ESP.TargetBots

    if wantPlayers then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character.Parent then
                local hum = getHumanoid(plr.Character)
                local root = getRoot(plr.Character)
                if hum and root and hum.Health > 0 then
                    seen[plr.Character] = true
                    table.insert(targets, {
                        model = plr.Character,
                        root = root,
                        hum = hum,
                        name = plr.Name,
                        isPlayer = true
                    })
                end
            end
        end
    end

    if wantBots then
        local function scan(container)
            for _, obj in ipairs(container:GetChildren()) do
                if obj:IsA("Model") and obj ~= myChar and not seen[obj] then
                    if not Players:GetPlayerFromCharacter(obj) then
                        local hum = getHumanoid(obj)
                        local root = getRoot(obj)
                        if hum and root and hum.Health > 0 then
                            seen[obj] = true
                            table.insert(targets, {
                                model = obj,
                                root = root,
                                hum = hum,
                                name = obj.Name,
                                isPlayer = false
                            })
                        end
                    end
                elseif obj:IsA("Folder") or (obj:IsA("Model") and not getHumanoid(obj)) then
                    scan(obj)
                end
            end
        end
        scan(workspace)
    end

    return targets
end

local function getTargets()
    local now = tick()
    if now - ESP_CACHE_TIME < ESP_CACHE_INTERVAL and #ESP_TARGET_CACHE > 0 then
        local filtered = {}
        for _, t in ipairs(ESP_TARGET_CACHE) do
            if t.model and t.model.Parent and t.hum and t.hum.Health > 0 then
                table.insert(filtered, t)
            end
        end
        ESP_TARGET_CACHE = filtered
        return filtered
    end
    ESP_TARGET_CACHE = getTargetsRaw()
    ESP_CACHE_TIME = now
    return ESP_TARGET_CACHE
end

-- Основной цикл обновления ESP
espConnection = RunService.RenderStepped:Connect(function()
    local targets = getTargets()
    local alive = {}

    for _, t in ipairs(targets) do
        alive[t.model] = true

        if not ESP.Objects[t.model] then attachESP(t.model) end
        local data = ESP.Objects[t.model]
        if data then

            -- ===================== BOX =====================
            if ESP.Enabled.Box then
                if not data.Box or not data.Box.Parent then
                    data.Box = createBoxScreen()
                end

                local box = data.Box
                if box and box.Parent then
                    -- Если цель мертва — прячем бокс сразу
                    if t.hum and t.hum.Health <= 0 then
                        box.Visible = false
                    else
                    local camera = workspace.CurrentCamera

                    local ok, cf, size = pcall(function()
                        return t.model:GetBoundingBox()
                    end)

                    if ok and cf and size then
                        local corners = {
                            cf * Vector3.new( size.X/2,  size.Y/2,  size.Z/2),
                            cf * Vector3.new(-size.X/2,  size.Y/2,  size.Z/2),
                            cf * Vector3.new( size.X/2, -size.Y/2,  size.Z/2),
                            cf * Vector3.new(-size.X/2, -size.Y/2,  size.Z/2),
                            cf * Vector3.new( size.X/2,  size.Y/2, -size.Z/2),
                            cf * Vector3.new(-size.X/2,  size.Y/2, -size.Z/2),
                            cf * Vector3.new( size.X/2, -size.Y/2, -size.Z/2),
                            cf * Vector3.new(-size.X/2, -size.Y/2, -size.Z/2),
                        }

                        local minX, minY = math.huge, math.huge
                        local maxX, maxY = -math.huge, -math.huge
                        local anyVisible = false

                        for _, worldPos in ipairs(corners) do
                            local sp, onScreen = camera:WorldToViewportPoint(worldPos)
                            if onScreen and sp.Z > 0 then
                                if sp.X < minX then minX = sp.X end
                                if sp.X > maxX then maxX = sp.X end
                                if sp.Y < minY then minY = sp.Y end
                                if sp.Y > maxY then maxY = sp.Y end
                                anyVisible = true
                            end
                        end

                        if anyVisible and minX < math.huge then
                            local width = maxX - minX
                            local height = maxY - minY

                            box.Visible = true
                            box.Position = UDim2.new(0, minX - 1, 0, minY - 1)
                            box.Size = UDim2.new(0, width + 2, 0, height + 2)

                            local thickness = 1
                            local cornerLen = 8

                            box.Top.Position = UDim2.new(0, 0, 0, 0)
                            box.Top.Size = UDim2.new(1, 0, 0, thickness)

                            box.Bottom.Position = UDim2.new(0, 0, 1, -thickness)
                            box.Bottom.Size = UDim2.new(1, 0, 0, thickness)

                            box.Left.Position = UDim2.new(0, 0, 0, 0)
                            box.Left.Size = UDim2.new(0, thickness, 1, 0)

                            box.Right.Position = UDim2.new(1, -thickness, 0, 0)
                            box.Right.Size = UDim2.new(0, thickness, 1, 0)

                            box.TL.Position = UDim2.new(0, 0, 0, 0)
                            box.TL.Size = UDim2.new(0, cornerLen, 0, thickness)
                            box.TR.Position = UDim2.new(1, -cornerLen, 0, 0)
                            box.TR.Size = UDim2.new(0, cornerLen, 0, thickness)
                            box.BL.Position = UDim2.new(0, 0, 1, -thickness)
                            box.BL.Size = UDim2.new(0, cornerLen, 0, thickness)
                            box.BR.Position = UDim2.new(1, -cornerLen, 1, -thickness)
                            box.BR.Size = UDim2.new(0, cornerLen, 0, thickness)
                        else
                            box.Visible = false
                        end
                    else
                        box.Visible = false
                    end
                    end
                end
            else
                if data.Box and data.Box.Parent then
                    data.Box:Destroy()
                    data.Box = nil
                end
            end

            -- ===================== TRACER =====================
            if ESP.Enabled.Tracer then
                if not data.Tracer or not data.Tracer.Parent then
                    data.Tracer = createTracer()
                end
                local tracer = data.Tracer
                if tracer and tracer.Parent then
                    local camera = workspace.CurrentCamera
                    local rootPart = t.root
                    if rootPart then
                        local sp, onScreen = camera:WorldToViewportPoint(rootPart.Position)
                        if onScreen and sp.Z > 0 then
                            local screenBottom = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                            local screenTarget = Vector2.new(sp.X, sp.Y)
                            local delta = screenTarget - screenBottom
                            local length = delta.Magnitude
                            local angle = math.deg(math.atan2(delta.Y, delta.X))

                            tracer.Visible = true
                            tracer.Position = UDim2.new(0, (screenBottom.X + screenTarget.X) / 2, 0, (screenBottom.Y + screenTarget.Y) / 2)
                            tracer.Size = UDim2.new(0, length, 0, 1)
                            tracer.Rotation = angle
                        else
                            tracer.Visible = false
                        end
                    end
                end
            else
                if data.Tracer and data.Tracer.Parent then
                    data.Tracer:Destroy()
                    data.Tracer = nil
                end
            end

            -- ===================== HIGHLIGHT =====================
            if ESP.Enabled.Highlight then
                -- Highlight надо пересоздать, если:
                -- 1) его нет
                -- 2) он удалён
                -- 3) Adornee мёртв или не совпадает с текущей моделью
                local needNew = false
                if not data.Highlight or not data.Highlight.Parent then
                    needNew = true
                elseif not data.Highlight.Adornee or data.Highlight.Adornee ~= t.model then
                    needNew = true
                end

                if needNew then
                    if data.Highlight then
                        pcall(function()
                            data.Highlight.Adornee = nil
                            data.Highlight:Destroy()
                        end)
                    end
                    data.Highlight = createHighlight(t.model)
                end
            else
                if data.Highlight then
                    pcall(function()
                        data.Highlight.Adornee = nil
                        data.Highlight:Destroy()
                    end)
                    data.Highlight = nil
                end
            end

            -- ===================== NAME =====================
            if ESP.Enabled.Name then
                if not data.NameTag or not data.NameTag.Parent then
                    data.NameTag, data.NameText = createNameTag(t.model)
                end
                if data.NameText then
                    data.NameText.Text = t.name
                end
            else
                if data.NameTag and data.NameTag.Parent then
                    data.NameTag:Destroy()
                    data.NameTag, data.NameText = nil, nil
                end
            end

            -- ===================== DISTANCE =====================
            if ESP.Enabled.Distance then
                if not data.DistTag or not data.DistTag.Parent then
                    data.DistTag, data.DistText = createDistanceTag(t.model)
                end
                if data.DistText then
                    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if myRoot then
                        local dist = math.floor((myRoot.Position - t.root.Position).Magnitude)
                        data.DistText.Text = dist .. "m"
                    end
                end
            else
                if data.DistTag and data.DistTag.Parent then
                    data.DistTag:Destroy()
                    data.DistTag, data.DistText = nil, nil
                end
            end

        end
    end

    -- Безопасная чистка моделей
    local toRemove = {}
    for model in pairs(ESP.Objects) do
        if not alive[model] or not model.Parent then
            table.insert(toRemove, model)
        end
    end
    for _, model in ipairs(toRemove) do
        detachESP(model)
    end

    -- ЖЁСТКАЯ чистка осиротевших боксов в ESPBoxGui
    -- Если бокс не принадлежит ни одной живой модели — прячем и удаляем
    local activeBoxes = {}
    for _, t in ipairs(targets) do
        local d = ESP.Objects[t.model]
        if d and d.Box then
            activeBoxes[d.Box] = true
        end
    end
    for _, child in ipairs(ESPBoxGui:GetChildren()) do
        if child.Name == "SlaughterESP_Box" and not activeBoxes[child] then
            child.Visible = false
            child:Destroy()
        end
    end

    -- То же для трассеров
    local activeTracers = {}
    for _, t in ipairs(targets) do
        local d = ESP.Objects[t.model]
        if d and d.Tracer then
            activeTracers[d.Tracer] = true
        end
    end
    for _, child in ipairs(ESPBoxGui:GetChildren()) do
        if child.Name == "SlaughterESP_Tracer" and not activeTracers[child] then
            child.Visible = false
            child:Destroy()
        end
    end

    -- ЖЁСТКАЯ чистка осиротевших Highlight'ов
    local activeHLs = {}
    for _, t in ipairs(targets) do
        local d = ESP.Objects[t.model]
        if d and d.Highlight then
            activeHLs[d.Highlight] = true
        end
    end
    for _, child in ipairs(ESPBoxGui:GetChildren()) do
        if child.Name == "SlaughterESP_HL" and not activeHLs[child] then
            child.Adornee = nil
            child:Destroy()
        end
    end
end)

-- UI кнопок ESP
makeToggle(tabs["ESP"].Container, "Box", false, function(v) ESP.Enabled.Box = v end)
makeToggle(tabs["ESP"].Container, "Tracer", false, function(v) ESP.Enabled.Tracer = v end)
makeToggle(tabs["ESP"].Container, "Highlight", false, function(v) ESP.Enabled.Highlight = v end)
makeToggle(tabs["ESP"].Container, "Name", false, function(v) ESP.Enabled.Name = v end)
makeToggle(tabs["ESP"].Container, "Distance", false, function(v) ESP.Enabled.Distance = v end)

-- Под-окно "Target Settings" (ESP)
local espTargetSettings = makeCollapsible(tabs["ESP"].Container, "Target Settings", false)

makeToggle(espTargetSettings, "Players", ESP.TargetPlayers, function(v)
    ESP.TargetPlayers = v
end)
makeToggle(espTargetSettings, "Bots", ESP.TargetBots, function(v)
    ESP.TargetBots = v
end)

-- =========================================================
-- MISC: BUNNY HOP (не сбрасывается при респавне)
-- =========================================================

local BUNNY_HOP = {
    Enabled = false,
    Connection = nil,
    LastJump = 0,
    Speed = 49,
    StrafeFix = true,
    StrafeConnection = nil,
}

local function onBunnyHop()
    if not BUNNY_HOP.Enabled then return end

    -- Проверяем РЕАЛЬНОЕ состояние клавиши (не переменную) — это надёжнее
    local holdingSpace = UserInputService:IsKeyDown(Enum.KeyCode.Space)
    if not holdingSpace then return end

    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end

    -- Прыгаем в момент приземления
    if hum.FloorMaterial ~= Enum.Material.Air then
        local now = tick()
        if now - BUNNY_HOP.LastJump > 0.05 then
            BUNNY_HOP.LastJump = now
            hum.Jump = true
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end

    -- Непрерывно держим выбранную скорость
    if hum.WalkSpeed ~= BUNNY_HOP.Speed then
        hum.WalkSpeed = BUNNY_HOP.Speed
    end
end

-- =========================================================
-- STRAFE FIX — реальный перехват штрафа скорости
-- =========================================================
-- Проблема: Roblox умножает WalkSpeed на "input scale":
--   - вперёд = 1.0
--   - назад = 0.7
--   - вбок = 0.7
-- Ни WalkSpeed, ни :Move() это НЕ перебивают в новой версии движка.
--
-- Решение: физически двигаем HumanoidRootPart через LinearVelocity
-- в направлении движения с полной скоростью, независимо от ввода.
--
-- ВАЖНО: MaxForce НЕ math.huge — иначе физика ломается
-- (выкидывает из стен, дёргает ragdoll, конфликтует с Humanoid).
-- 100000 достаточно, чтобы перебить input-scale, но не ломать физику.

local strafeAttachment = nil
local strafeLinearVel = nil

local function cleanupStrafePhysics()
    if strafeLinearVel then
        pcall(function() strafeLinearVel:Destroy() end)
        strafeLinearVel = nil
    end
    if strafeAttachment then
        pcall(function() strafeAttachment:Destroy() end)
        strafeAttachment = nil
    end
end

local function onStrafeFix()
    if not BUNNY_HOP.Enabled then return end
    if not BUNNY_HOP.StrafeFix then return end

    local char = LocalPlayer.Character
    if not char then cleanupStrafePhysics() return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then cleanupStrafePhysics() return end

    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then cleanupStrafePhysics() return end

    -- Держим WalkSpeed на всякий случай
    if hum.WalkSpeed ~= BUNNY_HOP.Speed then
        hum.WalkSpeed = BUNNY_HOP.Speed
    end

    -- Создаём Attachment + LinearVelocity, если их нет
    if not strafeAttachment or not strafeAttachment.Parent then
        cleanupStrafePhysics()
        strafeAttachment = Instance.new("Attachment")
        strafeAttachment.Name = "SlaughterStrafeAttach"
        strafeAttachment.Parent = root

        strafeLinearVel = Instance.new("LinearVelocity")
        strafeLinearVel.Name = "SlaughterStrafeLV"
        strafeLinearVel.Attachment0 = strafeAttachment
        -- НЕ math.huge! Ограничиваем силу — иначе физика ломается.
        strafeLinearVel.MaxForce = 100000
        strafeLinearVel.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
        strafeLinearVel.PlaneNormal = Vector3.new(0, 1, 0)
        strafeLinearVel.PlaneVelocity = Vector2.new(0, 0)
        strafeLinearVel.RelativeTo = Enum.ActuatorRelativeTo.World
        strafeLinearVel.Parent = root
    end

    -- Направление движения из Humanoid
    local md = hum.MoveDirection
    local speed = BUNNY_HOP.Speed

    -- Считаем целевую скорость: если игрок двигается — едем с полной speed
    if md.Magnitude > 0.05 then
        local targetVel = Vector3.new(md.X * speed, 0, md.Z * speed)
        strafeLinearVel.PlaneVelocity = Vector2.new(targetVel.X, targetVel.Z)
    else
        strafeLinearVel.PlaneVelocity = Vector2.new(0, 0)
    end
end

local function startStrafeFix()
    if BUNNY_HOP.StrafeConnection then return end
    BUNNY_HOP.StrafeConnection = RunService.RenderStepped:Connect(function()
        pcall(onStrafeFix)
    end)
end

local function stopStrafeFix()
    if BUNNY_HOP.StrafeConnection then
        BUNNY_HOP.StrafeConnection:Disconnect()
        BUNNY_HOP.StrafeConnection = nil
    end
    cleanupStrafePhysics()
end

local function startBunnyHop()
    if BUNNY_HOP.Connection then return end
    BUNNY_HOP.Connection = RunService.Heartbeat:Connect(function()
        pcall(onBunnyHop)
    end)
end

local function stopBunnyHop()
    if BUNNY_HOP.Connection then
        BUNNY_HOP.Connection:Disconnect()
        BUNNY_HOP.Connection = nil
    end
end

-- Главный тумблер Bunny Hop
makeToggle(tabs["Misc"].Container, "Bunny Hop", false, function(v)
    BUNNY_HOP.Enabled = v
    if v then
        startBunnyHop()
        if BUNNY_HOP.StrafeFix then startStrafeFix() end
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = BUNNY_HOP.Speed end
        end
    else
        stopBunnyHop()
        stopStrafeFix()
        -- ждём, чтобы Strafe успел почистить LinearVelocity, потом ставим дефолт
        task.delay(0.1, function()
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then hum.WalkSpeed = 16 end
            end
        end)
    end
end)

-- Под-окно "Bunny Hop Settings"
local bunnySettings = makeCollapsible(tabs["Misc"].Container, "Bunny Hop Settings", false)

makeSlider(bunnySettings, "Bunny Hop Speed", 1, 49, 49, function(v)
    BUNNY_HOP.Speed = v
    if BUNNY_HOP.Enabled then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = v end
        end
    end
end)

makeToggle(bunnySettings, "Strafe Fix", true, function(v)
    BUNNY_HOP.StrafeFix = v
    if BUNNY_HOP.Enabled then
        if v then startStrafeFix() else stopStrafeFix() end
    end
end)

-- При респавне — просто ждём и ставим скорость, ничего не сбрасываем
LocalPlayer.CharacterAdded:Connect(function(char)
    if not BUNNY_HOP.Enabled then return end
    local hum = char:WaitForChild("Humanoid", 5)
    if hum then
        hum.WalkSpeed = BUNNY_HOP.Speed
    end
    -- Strafe Fix перезапускаем на новом персонаже + чистим старые Attachment
    if BUNNY_HOP.StrafeFix then
        stopStrafeFix()
        task.wait(0.1)
        startStrafeFix()
    end
end)

-- =========================================================
-- PLACES: TELEPORT SAFE ZONE + BACK
-- =========================================================

local PLACES = {
    SavedPosition = nil,
    SafeZonePart = nil,
}

-- Создаёт квадрат-зону впереди игрока
local function createSafeZone(position)
    -- Удаляем старую зону
    if PLACES.SafeZonePart and PLACES.SafeZonePart.Parent then
        pcall(function() PLACES.SafeZonePart:Destroy() end)
    end

    local part = Instance.new("Part")
    part.Name = "SlaughterSafeZone"
    part.Size = Vector3.new(15, 4, 15)  -- толстая плита 4 студа
    part.Position = position
    part.Anchored = true
    part.CanCollide = true
    part.Material = Enum.Material.Neon
    part.Color = Color3.fromRGB(80, 255, 120)
    part.Transparency = 0.5
    part.Parent = workspace

    PLACES.SafeZonePart = part
    return part
end

-- Кнопка TELEPORT TO SAFE ZONE
local safeZoneBtn = Instance.new("TextButton")
safeZoneBtn.Size = UDim2.new(1, 0, 0, 40)
safeZoneBtn.BackgroundColor3 = Color3.fromRGB(20, 60, 30)
safeZoneBtn.BorderSizePixel = 0
safeZoneBtn.Text = "TELEPORT TO SAFE ZONE"
safeZoneBtn.TextColor3 = Color3.fromRGB(120, 255, 150)
safeZoneBtn.TextSize = 13
safeZoneBtn.Font = Enum.Font.GothamBold
safeZoneBtn.Parent = tabs["Places"].Container

local SZCorner = Instance.new("UICorner")
SZCorner.CornerRadius = UDim.new(0, 6)
SZCorner.Parent = safeZoneBtn

local SZStroke = Instance.new("UIStroke")
SZStroke.Color = Color3.fromRGB(40, 120, 60)
SZStroke.Thickness = 1
SZStroke.Parent = safeZoneBtn

safeZoneBtn.MouseEnter:Connect(function()
    TweenService:Create(safeZoneBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(80, 255, 120), TextColor3 = Color3.fromRGB(0, 0, 0)}):Play()
    TweenService:Create(SZStroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(80, 255, 120)}):Play()
end)
safeZoneBtn.MouseLeave:Connect(function()
    TweenService:Create(safeZoneBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(20, 60, 30), TextColor3 = Color3.fromRGB(120, 255, 150)}):Play()
    TweenService:Create(SZStroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(40, 120, 60)}):Play()
end)

safeZoneBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    -- Сохраняем текущую позицию (для Back)
    PLACES.SavedPosition = root.CFrame

    -- Телепорт ровно на 100 студов вниз от текущей позиции
    local currentPos = root.Position
    local targetPos = currentPos + Vector3.new(0, -100, 0)

    -- Создаём зону на целевой точке
    createSafeZone(targetPos)

    -- Телепорт
    root.CFrame = CFrame.new(targetPos)
end)

-- Кнопка BACK
local backBtn = Instance.new("TextButton")
backBtn.Size = UDim2.new(1, 0, 0, 40)
backBtn.BackgroundColor3 = Color3.fromRGB(60, 40, 10)
backBtn.BorderSizePixel = 0
backBtn.Text = "BACK TO PREVIOUS POSITION"
backBtn.TextColor3 = Color3.fromRGB(255, 200, 100)
backBtn.TextSize = 13
backBtn.Font = Enum.Font.GothamBold
backBtn.Parent = tabs["Places"].Container

local BBCorner = Instance.new("UICorner")
BBCorner.CornerRadius = UDim.new(0, 6)
BBCorner.Parent = backBtn

local BBStroke = Instance.new("UIStroke")
BBStroke.Color = Color3.fromRGB(120, 80, 20)
BBStroke.Thickness = 1
BBStroke.Parent = backBtn

backBtn.MouseEnter:Connect(function()
    TweenService:Create(backBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(255, 200, 100), TextColor3 = Color3.fromRGB(0, 0, 0)}):Play()
    TweenService:Create(BBStroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(255, 200, 100)}):Play()
end)
backBtn.MouseLeave:Connect(function()
    TweenService:Create(backBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(60, 40, 10), TextColor3 = Color3.fromRGB(255, 200, 100)}):Play()
    TweenService:Create(BBStroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(120, 80, 20)}):Play()
end)

backBtn.MouseButton1Click:Connect(function()
    if not PLACES.SavedPosition then return end
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    root.CFrame = PLACES.SavedPosition

    -- Убираем зону
    if PLACES.SafeZonePart and PLACES.SafeZonePart.Parent then
        pcall(function() PLACES.SafeZonePart:Destroy() end)
        PLACES.SafeZonePart = nil
    end
end)

-- Инфо-надпись
local placesInfo = Instance.new("TextLabel")
placesInfo.Size = UDim2.new(1, 0, 0, 30)
placesInfo.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
placesInfo.BorderSizePixel = 0
placesInfo.Text = "Zone created 20 studs in front of you"
placesInfo.TextColor3 = Color3.fromRGB(150, 150, 150)
placesInfo.TextSize = 11
placesInfo.Font = Enum.Font.Gotham
placesInfo.Parent = tabs["Places"].Container

local PICorner = Instance.new("UICorner")
PICorner.CornerRadius = UDim.new(0, 6)
PICorner.Parent = placesInfo

-- =========================================================
-- MISC: FAST ALIVE — авто-клик по кнопке "ВОЗРОЖДЕНИЕ"
-- =========================================================

local FAST_ALIVE = {
    Enabled = false,
    SpamTask = nil,
}

-- Эмулируем нажатие пробела: сначала executor keypress, потом VIM
local function pressSpace()
    local ok = pcall(function()
        keypress(32)
        task.wait(0.02)
        keyrelease(32)
    end)
    if ok then return end

    pcall(function()
        local VirtualInputManager = game:GetService("VirtualInputManager")
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
        task.wait(0.02)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
    end)
end

-- Основной цикл спама пробела пока мёртв
local function startSpamming()
    if FAST_ALIVE.SpamTask then return end
    FAST_ALIVE.SpamTask = task.spawn(function()
        while FAST_ALIVE.Enabled do
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")

            if not char or not hum or hum.Health <= 0 then
                -- Персонаж мёртв — СПАМИМ ПРОБЕЛ
                for i = 1, 30 do
                    if not FAST_ALIVE.Enabled then return end
                    pressSpace()
                    task.wait(0.03)
                end
            else
                -- Жив — проверяем через 0.5 сек
                task.wait(0.5)
            end
        end
    end)
end

local function stopSpamming()
    if FAST_ALIVE.SpamTask then
        pcall(function() task.cancel(FAST_ALIVE.SpamTask) end)
        FAST_ALIVE.SpamTask = nil
    end
end

-- UI тумблер
makeToggle(tabs["Misc"].Container, "Fast Alive", false, function(v)
    FAST_ALIVE.Enabled = v
    if v then
        startSpamming()
    else
        stopSpamming()
    end
end)

-- =========================================================
-- MISC: HITBOX EXPANDER (только Head, оптимизировано)
-- =========================================================

local HITBOX = {
    Enabled = false,
    Size = 10,           -- ФИКСИРОВАННЫЙ размер головы в студах (10 = норм)
    Connection = nil,
    Modified = {},       -- [head] = {Size, Transparency, Color, CanCollide, Massless}
    LastScan = 0,
}

-- Применяем расширение ТОЛЬКО к голове
local function expandHead(model)
    if not model or not model.Parent then return end
    if model == LocalPlayer.Character then return end

    local head = model:FindFirstChild("Head")
    if not head or not head:IsA("BasePart") then return end
    if HITBOX.Modified[head] then
        -- уже расширено — просто обновим размер, если слайдер двигали
        if HITBOX.Modified[head].Applied ~= HITBOX.Size then
            head.Size = Vector3.new(HITBOX.Size, HITBOX.Size, HITBOX.Size)
            HITBOX.Modified[head].Applied = HITBOX.Size
        end
        return
    end

    -- Запоминаем оригинал
    HITBOX.Modified[head] = {
        Size = head.Size,
        Transparency = head.Transparency,
        Color = head.Color,
        CanCollide = head.CanCollide,
        Massless = head.Massless,
        Applied = HITBOX.Size,
    }

    -- Расширяем до ФИКСИРОВАННОГО куба
    head.Size = Vector3.new(HITBOX.Size, HITBOX.Size, HITBOX.Size)
    head.CanCollide = false
    head.Massless = true
end

-- Возвращаем оригинальный размер
local function resetHead(head)
    local data = HITBOX.Modified[head]
    if not data then return end
    if head and head.Parent then
        pcall(function()
            head.Size = data.Size
            head.Transparency = data.Transparency
            head.Color = data.Color
            head.CanCollide = data.CanCollide
            head.Massless = data.Massless
        end)
    end
    HITBOX.Modified[head] = nil
end

local function resetAll()
    for head, _ in pairs(HITBOX.Modified) do
        resetHead(head)
    end
end

-- Сбор целей (игроки + боты)
local function getAllTargets()
    local targets = {}
    local myChar = LocalPlayer.Character

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character.Parent then
            table.insert(targets, plr.Character)
        end
    end

    local function scan(container)
        for _, obj in ipairs(container:GetChildren()) do
            if obj:IsA("Model") and obj ~= myChar and not Players:GetPlayerFromCharacter(obj) then
                if obj:FindFirstChild("Head") and obj:FindFirstChildOfClass("Humanoid") then
                    table.insert(targets, obj)
                end
            elseif obj:IsA("Folder") or (obj:IsA("Model") and not obj:FindFirstChildOfClass("Humanoid")) then
                scan(obj)
            end
        end
    end
    scan(workspace)

    return targets
end

local function startHitbox()
    if HITBOX.Connection then return end

    HITBOX.Connection = RunService.Heartbeat:Connect(function(dt)
        if not HITBOX.Enabled then return end

        -- Сканируем раз в 0.5 секунды — НЕ каждый кадр (убираем лаги)
        HITBOX.LastScan = HITBOX.LastScan + dt
        if HITBOX.LastScan < 0.5 then return end
        HITBOX.LastScan = 0

        local targets = getAllTargets()
        local aliveHeads = {}

        for _, model in ipairs(targets) do
            local head = model:FindFirstChild("Head")
            if head then
                aliveHeads[head] = true
                pcall(expandHead, model)
            end
        end

        -- Убираем расширение с мёртвых/удалённых
        for head, _ in pairs(HITBOX.Modified) do
            if not head.Parent or not aliveHeads[head] then
                resetHead(head)
            end
        end
    end)
end

local function stopHitbox()
    if HITBOX.Connection then
        HITBOX.Connection:Disconnect()
        HITBOX.Connection = nil
    end
    resetAll()
end

-- UI
makeToggle(tabs["Misc"].Container, "Hitbox Expander", false, function(v)
    HITBOX.Enabled = v
    if v then
        HITBOX.LastScan = 0 -- сразу сканируем
        startHitbox()
    else
        stopHitbox()
    end
end)

makeSlider(tabs["Misc"].Container, "Hitbox Size", 2, 30, 10, function(v)
    HITBOX.Size = v
    -- пересоздадим при следующем скане
    if HITBOX.Enabled then
        resetAll()
    end
end)

-- =========================================================
-- MISC: NOCLIP — проход сквозь стены
-- =========================================================

local NOCLIP = {
    Enabled = false,
    Connection = nil,
}

local function startNoclip()
    if NOCLIP.Connection then return end
    NOCLIP.Connection = RunService.Stepped:Connect(function()
        if not NOCLIP.Enabled then return end
        local char = LocalPlayer.Character
        if not char then return end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                -- НЕ трогаем HumanoidRootPart — иначе сломается FloorMaterial
                if part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = false
                end
            end
        end
    end)
end

local function stopNoclip()
    if NOCLIP.Connection then
        NOCLIP.Connection:Disconnect()
        NOCLIP.Connection = nil
    end
    -- Возвращаем коллизию
    local char = LocalPlayer.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                pcall(function()
                    if part.Name == "HumanoidRootPart" or part.Name == "Torso" or part.Name == "UpperTorso" or part.Name == "LowerTorso" then
                        part.CanCollide = true
                    elseif part.Name:find("Leg") or part.Name:find("Foot") or part.Name:find("Arm") or part.Name:find("Hand") then
                        part.CanCollide = false
                    end
                end)
            end
        end
    end
end

makeToggle(tabs["Misc"].Container, "Noclip", false, function(v)
    NOCLIP.Enabled = v
    if v then
        startNoclip()
    else
        stopNoclip()
    end
end)

-- =========================================================
-- MISC: FLY — полёт
-- =========================================================

local FLY = {
    Enabled = false,
    Connection = nil,
    Speed = 50,
    Velocity = nil,
    Gyro = nil,
    Attachment = nil,
}

local function startFly()
    if FLY.Connection then return end

    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    -- Убираем старые
    if FLY.Velocity then pcall(function() FLY.Velocity:Destroy() end) end
    if FLY.Gyro then pcall(function() FLY.Gyro:Destroy() end) end
    if FLY.Attachment then pcall(function() FLY.Attachment:Destroy() end) end

    -- Attachment
    FLY.Attachment = Instance.new("Attachment")
    FLY.Attachment.Name = "SlaughterFlyAttach"
    FLY.Attachment.Parent = root

    -- LinearVelocity — двигает по вектору
    FLY.Velocity = Instance.new("LinearVelocity")
    FLY.Velocity.Name = "SlaughterFlyVelocity"
    FLY.Velocity.Attachment0 = FLY.Attachment
    FLY.Velocity.MaxForce = math.huge
    FLY.Velocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
    FLY.Velocity.RelativeTo = Enum.ActuatorRelativeTo.World
    FLY.Velocity.VectorVelocity = Vector3.zero
    FLY.Velocity.Parent = root

    -- Сбрасываем гравитацию для root
    pcall(function()
        local bv = Instance.new("BodyForce")
        bv.Name = "SlaughterFlyAntiGrav"
        bv.Force = Vector3.new(0, workspace.Gravity * root:GetMass(), 0)
        bv.Parent = root
    end)

    FLY.Connection = RunService.RenderStepped:Connect(function()
        if not FLY.Enabled then return end
        local c = LocalPlayer.Character
        if not c then return end
        local r = c:FindFirstChild("HumanoidRootPart")
        if not r then return end
        local cam = workspace.CurrentCamera

        -- Направление движения
        local moveDir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0, 1, 0) end

        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit * FLY.Speed
        end

        FLY.Velocity.VectorVelocity = moveDir
    end)
end

local function stopFly()
    if FLY.Connection then
        FLY.Connection:Disconnect()
        FLY.Connection = nil
    end
    if FLY.Velocity then pcall(function() FLY.Velocity:Destroy() end); FLY.Velocity = nil end
    if FLY.Gyro then pcall(function() FLY.Gyro:Destroy() end); FLY.Gyro = nil end
    if FLY.Attachment then pcall(function() FLY.Attachment:Destroy() end); FLY.Attachment = nil end
    -- Убираем AntiGrav
    local char = LocalPlayer.Character
    if char then
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            local ag = root:FindFirstChild("SlaughterFlyAntiGrav")
            if ag then pcall(function() ag:Destroy() end) end
        end
    end
end

makeToggle(tabs["Misc"].Container, "Fly", false, function(v)
    FLY.Enabled = v
    if v then
        startFly()
    else
        stopFly()
    end
end)

-- Под-окно "Fly Settings"
local flySettings = makeCollapsible(tabs["Misc"].Container, "Fly Settings", false)
makeSlider(flySettings, "Fly Speed", 10, 300, 50, function(v)
    FLY.Speed = v
end)

guiVisible = false
local keybindLabel

-- Изначально GUI скрыт → MiniHud виден
MiniHud.Visible = true

-- =========================================================
-- СОЧНЫЕ АНИМАЦИИ ОТКРЫТИЯ / ЗАКРЫТИЯ
-- =========================================================

-- Открыть GUI с эффектом (scale-in + fade + flash)
function openGUI()
    if guiVisible then return end
    guiVisible = true
    ScreenGui.Enabled = true

    -- Сохраняем текущую позицию (после drag), чтобы окно не прыгало в центр
    local savedPos = Main.Position

    -- Сбрасываем состояние (размер — в дефолт, позицию НЕ трогаем)
    Main.Size = UDim2.new(0, 540, 0, 420)
    Main.BackgroundTransparency = 0.5
    MainStroke.Transparency = 1
    GlowStroke.Transparency = 1
    TopBar.BackgroundTransparency = 1
    Sidebar.BackgroundTransparency = 1
    Content.BackgroundTransparency = 1
    PlayerCard.BackgroundTransparency = 1

    -- Прячем MiniHud с fade
    hideMiniHud()

    -- Основной твин: fade-in
    TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0
    }):Play()

    -- Лёгкий scale-pop (от 0.95 → 1)
    Main.Size = UDim2.new(0, 540 * 0.95, 0, 420 * 0.95)
    TweenService:Create(Main, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 540, 0, 420),
        Position = savedPos
    }):Play()

    TweenService:Create(MainStroke, TweenInfo.new(0.4), {Transparency = 0}):Play()
    TweenService:Create(GlowStroke, TweenInfo.new(0.5), {Transparency = 0.8}):Play()
    TweenService:Create(TopBar, TweenInfo.new(0.4), {BackgroundTransparency = 0}):Play()
    TweenService:Create(Sidebar, TweenInfo.new(0.4), {BackgroundTransparency = 0}):Play()
    TweenService:Create(Content, TweenInfo.new(0.4), {BackgroundTransparency = 0}):Play()
    TweenService:Create(PlayerCard, TweenInfo.new(0.4), {BackgroundTransparency = 0.1}):Play()

    -- Вспышка красным по краям
    local flash = Instance.new("Frame")
    flash.Size = UDim2.new(1, 40, 1, 40)
    flash.Position = UDim2.new(0.5, 0, 0.5, 0)
    flash.AnchorPoint = Vector2.new(0.5, 0.5)
    flash.BackgroundTransparency = 1
    flash.BorderSizePixel = 0
    flash.ZIndex = 50
    flash.Parent = Main

    local flashStroke = Instance.new("UIStroke")
    flashStroke.Color = Color3.fromRGB(255, 30, 30)
    flashStroke.Thickness = 4
    flashStroke.Transparency = 0
    flashStroke.Parent = flash

    local flashCorner = Instance.new("UICorner")
    flashCorner.CornerRadius = UDim.new(0, 14)
    flashCorner.Parent = flash

    TweenService:Create(flashStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Transparency = 1
    }):Play()
    TweenService:Create(flash, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(1, 100, 1, 100)
    }):Play()

    task.delay(0.6, function()
        if flash.Parent then flash:Destroy() end
    end)
end

-- Закрыть GUI с эффектом (scale-out + fade)
function closeGUI()
    if not guiVisible then return end
    guiVisible = false

    -- Scale-out (сжатие вниз)
    -- Сохраняем позицию, чтобы не прыгало при следующем открытии
    local savedPos = Main.Position
    TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 540 * 0.9, 0, 420 * 0.9),
        BackgroundTransparency = 1
    }):Play()
    -- Position не трогаем — останется где было

    TweenService:Create(MainStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
    TweenService:Create(GlowStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
    TweenService:Create(TopBar, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
    TweenService:Create(Sidebar, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
    TweenService:Create(Content, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
    TweenService:Create(PlayerCard, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()

    -- Через задержку выключаем ScreenGui + показываем MiniHud
    task.delay(0.32, function()
        ScreenGui.Enabled = false
        -- Восстанавливаем прозрачности для следующего открытия
        Main.BackgroundTransparency = 0
        MainStroke.Transparency = 0
        GlowStroke.Transparency = 0.8
        TopBar.BackgroundTransparency = 0
        Sidebar.BackgroundTransparency = 0
        Content.BackgroundTransparency = 0
        PlayerCard.BackgroundTransparency = 0.1

        showMiniHud()
    end)
end

-- =========================================================
-- MINI-HUD показать/скрыть с анимацией
-- =========================================================
function showMiniHud()
    if not MiniHud or not MiniHud.Parent then return end
    MiniHud.Visible = true
    MiniHud.Position = UDim2.new(1, -355, 0, 10)
    MiniHud.BackgroundTransparency = 1

    -- Слайд слева + fade
    MiniHud.Position = UDim2.new(1, -280, 0, 10)
    TweenService:Create(MiniHud, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -355, 0, 10),
        BackgroundTransparency = 0.15
    }):Play()

    TweenService:Create(MHStroke, TweenInfo.new(0.4), {Transparency = 0.4}):Play()
end

function hideMiniHud()
    if not MiniHud or not MiniHud.Parent then return end
    if not MiniHud.Visible then return end

    -- Слайд вправо + fade
    TweenService:Create(MiniHud, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
        Position = UDim2.new(1, -280, 0, 10),
        BackgroundTransparency = 1
    }):Play()
    TweenService:Create(MHStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()

    task.delay(0.36, function()
        if MiniHud and MiniHud.Parent then
            MiniHud.Visible = false
            -- Сбрасываем на исходную для следующего показа
            MiniHud.Position = UDim2.new(1, -355, 0, 10)
            MiniHud.BackgroundTransparency = 0.15
            MHStroke.Transparency = 0.4
        end
    end)
end

-- =========================================================
-- Бинд K
-- =========================================================
inputConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.K then
        if guiVisible then
            closeGUI()
        else
            openGUI()
        end
    end
end)

-- =========================================================
-- ПОЛНЫЙ UNLOAD — убивает ВСЁ что связано со скриптом
-- =========================================================
local function unloadScript()
    -- =========================================================
    -- 1) Отключаем ВСЕ постоянные соединения
    -- =========================================================
    if espConnection then
        pcall(function() espConnection:Disconnect() end)
        espConnection = nil
    end
    if aimConnection then
        pcall(function() aimConnection:Disconnect() end)
        aimConnection = nil
    end
    if inputConnection then
        pcall(function() inputConnection:Disconnect() end)
        inputConnection = nil
    end
    if scrollConnection then
        pcall(function() scrollConnection:Disconnect() end)
        scrollConnection = nil
    end
    if MAIN_DRAG and MAIN_DRAG.connChanged then
        pcall(function() MAIN_DRAG.connChanged:Disconnect() end)
        MAIN_DRAG.connChanged = nil
    end

    -- =========================================================
    -- 1.5) RAPID FIRE — стоп + возврат оригинальной функции
    -- =========================================================
    if RAPID_CONFIG then RAPID_CONFIG.Enabled = false end
    if rapidFireConnection then
        pcall(function() rapidFireConnection:Disconnect() end)
        rapidFireConnection = nil
    end
    if WeaponClient and originalFire then
        pcall(function() WeaponClient.fire = originalFire end)
    end

    -- =========================================================
    -- 2) Bunny Hop — стоп + скорость на дефолт + Strafe стоп
    -- =========================================================
    if BUNNY_HOP then
        BUNNY_HOP.Enabled = false
        if BUNNY_HOP.Connection then
            pcall(function() BUNNY_HOP.Connection:Disconnect() end)
            BUNNY_HOP.Connection = nil
        end
        if BUNNY_HOP.StrafeConnection then
            pcall(function() BUNNY_HOP.StrafeConnection:Disconnect() end)
            BUNNY_HOP.StrafeConnection = nil
        end
        BUNNY_HOP.LastJump = 0
    end

    -- Чистим физику Strafe (LinearVelocity + Attachment)
    pcall(function()
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj.Name == "SlaughterStrafeLV" and obj:IsA("LinearVelocity") then
                obj:Destroy()
            end
            if obj.Name == "SlaughterStrafeAttach" and obj:IsA("Attachment") then
                obj:Destroy()
            end
        end
    end)

    -- =========================================================
    -- 3) Fast Alive — стоп + отмена таска
    -- =========================================================
    if FAST_ALIVE then
        FAST_ALIVE.Enabled = false
        if FAST_ALIVE.SpamTask then
            pcall(function() task.cancel(FAST_ALIVE.SpamTask) end)
            FAST_ALIVE.SpamTask = nil
        end
    end

    -- =========================================================
    -- 4) Hitbox Expander — стоп + восстановить головы
    -- =========================================================
    if HITBOX then
        HITBOX.Enabled = false
        if HITBOX.Connection then
            pcall(function() HITBOX.Connection:Disconnect() end)
            HITBOX.Connection = nil
        end
        pcall(function()
            for head, data in pairs(HITBOX.Modified) do
                if head and head.Parent then
                    head.Size = data.Size
                    head.Transparency = data.Transparency
                    head.Color = data.Color
                    head.CanCollide = data.CanCollide
                    head.Massless = data.Massless
                end
            end
            HITBOX.Modified = {}
        end)
    end

    -- =========================================================
    -- 5.0) Magic Bullet — стоп + восстановить цели
    -- =========================================================
    if MAGIC then
        MAGIC.Enabled = false
        if MAGIC.Connection then
            pcall(function() MAGIC.Connection:Disconnect() end)
            MAGIC.Connection = nil
        end
        pcall(restoreAllMagic)
    end

    -- =========================================================
    -- 5.1) Noclip — стоп
    -- =========================================================
    if NOCLIP then
        NOCLIP.Enabled = false
        if NOCLIP.Connection then
            pcall(function() NOCLIP.Connection:Disconnect() end)
            NOCLIP.Connection = nil
        end
    end

    -- =========================================================
    -- 5.2) Fly — стоп
    -- =========================================================
    if FLY then
        FLY.Enabled = false
        if FLY.Connection then
            pcall(function() FLY.Connection:Disconnect() end)
            FLY.Connection = nil
        end
        if FLY.Velocity then pcall(function() FLY.Velocity:Destroy() end) end
        if FLY.Gyro then pcall(function() FLY.Gyro:Destroy() end) end
        if FLY.Attachment then pcall(function() FLY.Attachment:Destroy() end) end
        FLY.Velocity = nil
        FLY.Gyro = nil
        FLY.Attachment = nil
    end

    -- =========================================================
    -- 5.3) Places — чистим SafeZone
    -- =========================================================
    if PLACES and PLACES.SafeZonePart and PLACES.SafeZonePart.Parent then
        pcall(function() PLACES.SafeZonePart:Destroy() end)
        PLACES.SafeZonePart = nil
    end

    -- =========================================================
    -- 6) Восстанавливаем скорость игрока на дефолт
    -- =========================================================
    pcall(function()
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 16 end
        end
    end)

    -- =========================================================
    -- 7) Удаляем ВСЕ объекты ESP из workspace
    --    Highlight + BillboardGui (NameTag / DistTag)
    -- =========================================================
    pcall(function()
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj.Name == "SlaughterESP_HL" and obj:IsA("Highlight") then
                obj.Adornee = nil
                obj:Destroy()
            end
            if obj.Name == "SlaughterESP_Name" and obj:IsA("BillboardGui") then
                obj.Adornee = nil
                obj:Destroy()
            end
            if obj.Name == "SlaughterESP_Dist" and obj:IsA("BillboardGui") then
                obj.Adornee = nil
                obj:Destroy()
            end
        end
    end)

    -- =========================================================
    -- 8) Чистим таблицу ESP
    -- =========================================================
    local keys = {}
    for model in pairs(ESP.Objects) do
        table.insert(keys, model)
    end
    for _, model in ipairs(keys) do
        pcall(function() detachESP(model) end)
    end
    ESP.Objects = {}

    -- =========================================================
    -- 9) Уничтожаем ВСЕ ScreenGui скрипта (CoreGui + PlayerGui)
    -- =========================================================
    for _, name in ipairs({
        "SlaughterGUI",
        "SlaughterIntro",
        "SlaughterNotifications",
        "SlaughterESPBoxes",
        "SlaughterFOVCircle",
        "SlaughterMiniHudGui",
    }) do
        local g = CoreGui:FindFirstChild(name)
        if g then pcall(function() g:Destroy() end) end
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        if pg then
            local g2 = pg:FindFirstChild(name)
            if g2 then pcall(function() g2:Destroy() end) end
        end
    end

    -- =========================================================
    -- 10) Финальный скан workspace — на остатки по имени
    -- =========================================================
    pcall(function()
        for _, obj in ipairs(workspace:GetDescendants()) do
            local n = obj.Name
            if n:sub(1, 12) == "SlaughterESP"
                or n:sub(1, 14) == "SlaughterTracer"
                or n == "SlaughterESP_HL"
                or n:sub(1, 14) == "SlaughterFly"
                or n:sub(1, 16) == "SlaughterStrafe"
                or n == "SlaughterSafeZone" then
                pcall(function() obj:Destroy() end)
            end
        end
    end)

    -- =========================================================
    -- 11) Сбрасываем флаги ESP
    -- =========================================================
    ESP.Enabled.Box = false
    ESP.Enabled.Tracer = false
    ESP.Enabled.Highlight = false
    ESP.Enabled.Name = false
    ESP.Enabled.Distance = false

    -- =========================================================
    -- 12) MiniHud FPS/Ping — отключаем соединение и таск
    -- =========================================================
    if fpsFrameConnection then
        pcall(function() fpsFrameConnection:Disconnect() end)
        fpsFrameConnection = nil
    end
    if fpsLoopTask then
        pcall(function() task.cancel(fpsLoopTask) end)
        fpsLoopTask = nil
    end
    _G.MINI_HUD_FPS_FRAMES = 0

    print("[SLAUGHTER] Fully unloaded. All GUI and connections removed.")
end

local UnloadBtn = Instance.new("TextButton")
UnloadBtn.Size = UDim2.new(1, 0, 0, 40)
UnloadBtn.BackgroundColor3 = Color3.fromRGB(40, 10, 10)
UnloadBtn.BorderSizePixel = 0
UnloadBtn.Text = "⛔ UNLOAD SCRIPT"
UnloadBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
UnloadBtn.TextSize = 14
UnloadBtn.Font = Enum.Font.GothamBold
UnloadBtn.Parent = tabs["Settings"].Container

local UnloadCorner = Instance.new("UICorner")
UnloadCorner.CornerRadius = UDim.new(0, 6)
UnloadCorner.Parent = UnloadBtn

local UnloadStroke = Instance.new("UIStroke")
UnloadStroke.Color = Color3.fromRGB(120, 20, 20)
UnloadStroke.Thickness = 1
UnloadStroke.Parent = UnloadBtn

UnloadBtn.MouseEnter:Connect(function()
    TweenService:Create(UnloadBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(255, 30, 30), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    TweenService:Create(UnloadStroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(255, 30, 30)}):Play()
end)
UnloadBtn.MouseLeave:Connect(function()
    TweenService:Create(UnloadBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40, 10, 10), TextColor3 = Color3.fromRGB(255, 80, 80)}):Play()
    TweenService:Create(UnloadStroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(120, 20, 20)}):Play()
end)

UnloadBtn.MouseButton1Click:Connect(unloadScript)

-- Кнопка-инфо о билнде в Settings
local KeybindInfo = Instance.new("Frame")
KeybindInfo.Size = UDim2.new(1, 0, 0, 36)
KeybindInfo.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
KeybindInfo.BorderSizePixel = 0
KeybindInfo.Parent = tabs["Settings"].Container

local KIC = Instance.new("UICorner")
KIC.CornerRadius = UDim.new(0, 6)
KIC.Parent = KeybindInfo

local KIS = Instance.new("UIStroke")
KIS.Color = Color3.fromRGB(40, 40, 40)
KIS.Thickness = 1
KIS.Parent = KeybindInfo

local KILabel = Instance.new("TextLabel")
KILabel.Size = UDim2.new(1, -70, 1, 0)
KILabel.Position = UDim2.new(0, 12, 0, 0)
KILabel.BackgroundTransparency = 1
KILabel.Text = "Toggle GUI"
KILabel.TextColor3 = Color3.fromRGB(220, 220, 220)
KILabel.TextSize = 13
KILabel.Font = Enum.Font.GothamMedium
KILabel.TextXAlignment = Enum.TextXAlignment.Left
KILabel.Parent = KeybindInfo

local KIKey = Instance.new("TextLabel")
KIKey.Size = UDim2.new(0, 40, 0, 20)
KIKey.Position = UDim2.new(1, -52, 0.5, -10)
KIKey.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
KIKey.BorderSizePixel = 0
KIKey.Text = "K"
KIKey.TextColor3 = Color3.fromRGB(255, 255, 255)
KIKey.TextSize = 13
KIKey.Font = Enum.Font.GothamBold
KIKey.Parent = KeybindInfo

local KIKeyC = Instance.new("UICorner")
KIKeyC.CornerRadius = UDim.new(0, 4)
KIKeyC.Parent = KIKey

-- =========================================================
-- УВЕДОМЛЕНИЯ v2 (слайд-ин + glow + прогресс-бар)
-- =========================================================
local NotifyGui = Instance.new("ScreenGui")
NotifyGui.Name = "SlaughterNotifications"
NotifyGui.ResetOnSpawn = false
NotifyGui.DisplayOrder = 999
NotifyGui.IgnoreGuiInset = true
pcall(function() NotifyGui.Parent = CoreGui end)
if not NotifyGui.Parent then NotifyGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local NotifyHolder = Instance.new("Frame")
NotifyHolder.Size = UDim2.new(0, 300, 0, 600)
NotifyHolder.Position = UDim2.new(1, -315, 0, 15)
NotifyHolder.BackgroundTransparency = 1
NotifyHolder.Parent = NotifyGui

local NotifyLayout = Instance.new("UIListLayout")
NotifyLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifyLayout.Padding = UDim.new(0, 10)
NotifyLayout.Parent = NotifyHolder

local function notify(title, text, duration, accentColor)
    accentColor = accentColor or Color3.fromRGB(255, 30, 30)
    duration = duration or 2

    local Holder = Instance.new("Frame")
    Holder.Size = UDim2.new(1, 0, 0, 64)
    Holder.BackgroundTransparency = 1
    Holder.ClipsDescendants = false
    Holder.Parent = NotifyHolder

    local Notif = Instance.new("Frame")
    Notif.Size = UDim2.new(1, 0, 1, 0)
    Notif.Position = UDim2.new(1, 320, 0, 0)
    Notif.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    Notif.BackgroundTransparency = 0.1
    Notif.BorderSizePixel = 0
    Notif.Parent = Holder

    local NC = Instance.new("UICorner")
    NC.CornerRadius = UDim.new(0, 10)
    NC.Parent = Notif

    local NS = Instance.new("UIStroke")
    NS.Color = accentColor
    NS.Thickness = 1
    NS.Transparency = 0.4
    NS.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    NS.Parent = Notif

    local NGlow = Instance.new("UIStroke")
    NGlow.Color = accentColor
    NGlow.Thickness = 3
    NGlow.Transparency = 0.85
    NGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    NGlow.Parent = Notif

    local NGrad = Instance.new("UIGradient")
    NGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 15)),
    }
    NGrad.Rotation = 90
    NGrad.Parent = Notif

    local AB = Instance.new("Frame")
    AB.Size = UDim2.new(0, 3, 1, -20)
    AB.Position = UDim2.new(0, 6, 0.5, 0)
    AB.AnchorPoint = Vector2.new(0, 0.5)
    AB.BackgroundColor3 = accentColor
    AB.BorderSizePixel = 0
    AB.Parent = Notif

    local ABC = Instance.new("UICorner")
    ABC.CornerRadius = UDim.new(1, 0)
    ABC.Parent = AB

    local Icon = Instance.new("Frame")
    Icon.Size = UDim2.new(0, 8, 0, 8)
    Icon.Position = UDim2.new(0, 16, 0, 16)
    Icon.BackgroundColor3 = accentColor
    Icon.BorderSizePixel = 0
    Icon.Parent = Notif

    local IconC = Instance.new("UICorner")
    IconC.CornerRadius = UDim.new(1, 0)
    IconC.Parent = Icon

    local NT = Instance.new("TextLabel")
    NT.Size = UDim2.new(1, -40, 0, 20)
    NT.Position = UDim2.new(0, 30, 0, 12)
    NT.BackgroundTransparency = 1
    NT.Text = title
    NT.TextColor3 = Color3.fromRGB(255, 255, 255)
    NT.TextSize = 14
    NT.Font = Enum.Font.GothamBlack
    NT.TextXAlignment = Enum.TextXAlignment.Left
    NT.Parent = Notif

    local NText = Instance.new("TextLabel")
    NText.Size = UDim2.new(1, -30, 0, 16)
    NText.Position = UDim2.new(0, 16, 0, 34)
    NText.BackgroundTransparency = 1
    NText.Text = text
    NText.TextColor3 = Color3.fromRGB(175, 175, 185)
    NText.TextSize = 11
    NText.Font = Enum.Font.Gotham
    NText.TextXAlignment = Enum.TextXAlignment.Left
    NText.TextTruncate = Enum.TextTruncate.AtEnd
    NText.Parent = Notif

    local ProgressTrack = Instance.new("Frame")
    ProgressTrack.Size = UDim2.new(1, -20, 0, 2)
    ProgressTrack.Position = UDim2.new(0, 10, 1, -5)
    ProgressTrack.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    ProgressTrack.BorderSizePixel = 0
    ProgressTrack.Parent = Notif

    local PTC = Instance.new("UICorner")
    PTC.CornerRadius = UDim.new(1, 0)
    PTC.Parent = ProgressTrack

    local ProgressFill = Instance.new("Frame")
    ProgressFill.Size = UDim2.new(1, 0, 1, 0)
    ProgressFill.BackgroundColor3 = accentColor
    ProgressFill.BorderSizePixel = 0
    ProgressFill.Parent = ProgressTrack

    local PFC = Instance.new("UICorner")
    PFC.CornerRadius = UDim.new(1, 0)
    PFC.Parent = ProgressFill

    TweenService:Create(Notif, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0, 0)
    }):Play()

    task.spawn(function()
        while Notif.Parent do
            TweenService:Create(Icon, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundTransparency = 0.7, Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(0, 14, 0, 14)}):Play()
            task.wait(0.6)
            TweenService:Create(Icon, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundTransparency = 0, Size = UDim2.new(0, 8, 0, 8), Position = UDim2.new(0, 16, 0, 16)}):Play()
            task.wait(0.6)
        end
    end)

    TweenService:Create(ProgressFill, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 1, 0)}):Play()

    task.delay(duration, function()
        if not Notif.Parent then return end
        TweenService:Create(Notif, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 320, 0, 0),
            BackgroundTransparency = 1
        }):Play()
        TweenService:Create(NS, TweenInfo.new(0.3), {Transparency = 1}):Play()
        TweenService:Create(NGlow, TweenInfo.new(0.3), {Transparency = 1}):Play()
        TweenService:Create(NT, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        TweenService:Create(NText, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        TweenService:Create(AB, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        TweenService:Create(Icon, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        TweenService:Create(ProgressTrack, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        TweenService:Create(ProgressFill, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        task.wait(0.4)
        if Holder.Parent then Holder:Destroy() end
    end)
end

-- =========================================================
-- СТАРТ
-- =========================================================
notify("SLAUGHTER", "Full Supported", 2, Color3.fromRGB(80, 255, 120))
task.wait(0.4)
notify("SLAUGHTER", "Injecting interface...", 2, Color3.fromRGB(255, 200, 50))
task.wait(0.3)
notify("SLAUGHTER", "3.0 — full support enabled", 3, Color3.fromRGB(255, 140, 40))
task.wait(0.6)

ScreenGui.Enabled = true
guiVisible = false
openGUI()

print("[SLAUGHTER] 3.0 загружен! Бинд на K — открыть/закрыть GUI.")
