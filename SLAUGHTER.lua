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
local INTRO_CONNECTION = nil

-- Bunny Hop переменные
local BUNNY_HOP = {
    Enabled = false,
    Connection = nil,
}

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
Main.Size = UDim2.new(0, 520, 0, 400)
Main.Position = UDim2.new(0.5, -260, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.BackgroundTransparency = 1
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(35, 35, 35)
MainStroke.Thickness = 1
MainStroke.Transparency = 1
MainStroke.Parent = Main

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
TopBar.BorderSizePixel = 0
TopBar.BackgroundTransparency = 1
TopBar.Parent = Main

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 10)
TopBarCorner.Parent = TopBar

local TopBarFix = Instance.new("Frame")
TopBarFix.Size = UDim2.new(1, 0, 0, 15)
TopBarFix.Position = UDim2.new(0, 0, 1, -15)
TopBarFix.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
TopBarFix.BorderSizePixel = 0
TopBarFix.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "SLAUGHTER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Подпись версии рядом с SLAUGHTER
local NoSupportLabel = Instance.new("TextLabel")
NoSupportLabel.Size = UDim2.new(0, 160, 0, 20)
NoSupportLabel.Position = UDim2.new(0, 135, 0.5, -10)
NoSupportLabel.BackgroundTransparency = 1
NoSupportLabel.Text = "2.0"
NoSupportLabel.TextColor3 = Color3.fromRGB(255, 140, 40)
NoSupportLabel.TextSize = 11
NoSupportLabel.Font = Enum.Font.GothamMedium
NoSupportLabel.TextXAlignment = Enum.TextXAlignment.Left
NoSupportLabel.Parent = TopBar

local Accent = Instance.new("Frame")
Accent.Size = UDim2.new(0, 100, 0, 2)
Accent.Position = UDim2.new(0, 15, 1, -4)
Accent.BackgroundColor3 = Color3.fromRGB(255, 30, 30)
Accent.BorderSizePixel = 0
Accent.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0.5, -15)
CloseBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 30, 30), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 25), TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
end)

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -75, 0.5, -15)
MinBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MinBtn.BorderSizePixel = 0
MinBtn.Text = "—"
MinBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MinBtn.TextSize = 16
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Parent = TopBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinBtn

MinBtn.MouseEnter:Connect(function()
    TweenService:Create(MinBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
end)
MinBtn.MouseLeave:Connect(function()
    TweenService:Create(MinBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
end)

local isMinimized = false
local originalSize = Main.Size
MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    TweenService:Create(Main, TweenInfo.new(0.25), {
        Size = isMinimized and UDim2.new(0, 520, 0, 40) or originalSize
    }):Play()
end)

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 140, 1, -50)
Sidebar.Position = UDim2.new(0, 10, 0, 45)
Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Sidebar.BorderSizePixel = 0
Sidebar.BackgroundTransparency = 1
Sidebar.Parent = Main

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 8)
SidebarCorner.Parent = Sidebar

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

local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -165, 1, -50)
Content.Position = UDim2.new(0, 155, 0, 45)
Content.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Content.BorderSizePixel = 0
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 4
Content.ScrollBarImageColor3 = Color3.fromRGB(255, 140, 40)
Content.ScrollBarImageTransparency = 0.3
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
Content.ScrollingDirection = Enum.ScrollingDirection.Y
Content.Parent = Main

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 8)
ContentCorner.Parent = Content

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

-- Контейнер для вкладок (внутри ScrollingFrame)
-- Вкладки создаются как отдельные Frame'ы внутри Content

local ContentTitle = Instance.new("TextLabel")
ContentTitle.Size = UDim2.new(1, 0, 0, 25)
ContentTitle.BackgroundTransparency = 1
ContentTitle.Text = "RAGE"
ContentTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
ContentTitle.TextSize = 16
ContentTitle.Font = Enum.Font.GothamBold
ContentTitle.TextXAlignment = Enum.TextXAlignment.Left
ContentTitle.LayoutOrder = 0
ContentTitle.Parent = Content

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
    TabButton.Size = UDim2.new(1, 0, 0, 32)
    TabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TabButton.BorderSizePixel = 0
    TabButton.Text = displayName or name
    TabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabButton.TextSize = 13
    TabButton.Font = Enum.Font.GothamMedium
    TabButton.TextXAlignment = Enum.TextXAlignment.Left
    TabButton.Parent = Sidebar

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = TabButton

    local BtnPad = Instance.new("UIPadding")
    BtnPad.PaddingLeft = UDim.new(0, 10)
    BtnPad.Parent = TabButton

    -- Свой ScrollingFrame на каждую вкладку
    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.Size = UDim2.new(1, 0, 1, -35)
    TabScroll.Position = UDim2.new(0, 0, 0, 35)
    TabScroll.BackgroundTransparency = 1
    TabScroll.BorderSizePixel = 0
    TabScroll.Visible = false
    TabScroll.ScrollBarThickness = 4
    TabScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 140, 40)
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

    tabs[name] = { Button = TabButton, Container = TabScroll, Layout = TabScrollLayout }

    TabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(tabs) do
            TweenService:Create(tab.Button, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                TextColor3 = Color3.fromRGB(180, 180, 180)
            }):Play()
            tab.Container.Visible = false
        end
        TweenService:Create(TabButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(35, 35, 35),
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
        TabScroll.Visible = true
        ContentTitle.Text = displayName or name

        -- Назначаем эту вкладку для скролла колесом
        attachMouseWheelScroll(TabScroll)
    end)

    return tabs[name]
end

createTab("COMBAT", "COMBAT")
createTab("ESP", "ESP")
createTab("Misc", "Misc")
createTab("Places", "Places")
createTab("Settings", "Settings")

tabs["COMBAT"].Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
tabs["COMBAT"].Button.TextColor3 = Color3.fromRGB(255, 255, 255)
tabs["COMBAT"].Container.Visible = true

-- Активируем скролл колесом для стартовой вкладки COMBAT
attachMouseWheelScroll(tabs["COMBAT"].Container)

-- =========================================================
-- ХЕЛПЕР: Toggle
-- =========================================================
local function makeToggle(parent, labelText, default, callback)
    local state = default or false
    local lastClick = 0

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 36)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Frame.BorderSizePixel = 0
    Frame.Parent = parent

    local FC = Instance.new("UICorner")
    FC.CornerRadius = UDim.new(0, 6)
    FC.Parent = Frame

    local FS = Instance.new("UIStroke")
    FS.Color = Color3.fromRGB(40, 40, 40)
    FS.Thickness = 1
    FS.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -70, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = labelText
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.TextSize = 13
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local Switch = Instance.new("Frame")
    Switch.Size = UDim2.new(0, 40, 0, 20)
    Switch.Position = UDim2.new(1, -52, 0.5, -10)
    Switch.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Switch.BorderSizePixel = 0
    Switch.Parent = Frame

    local SC = Instance.new("UICorner")
    SC.CornerRadius = UDim.new(1, 0)
    SC.Parent = Switch

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 14, 0, 14)
    Knob.Position = UDim2.new(0, 3, 0.5, -7)
    Knob.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
    Knob.BorderSizePixel = 0
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
            TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 30, 30)}):Play()
            TweenService:Create(Knob, TweenInfo.new(0.2), {
                Position = UDim2.new(1, -17, 0.5, -7),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
        else
            TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
            TweenService:Create(Knob, TweenInfo.new(0.2), {
                Position = UDim2.new(0, 3, 0.5, -7),
                BackgroundColor3 = Color3.fromRGB(150, 150, 150)
            }):Play()
        end
    end

    updateVisual()

    Btn.MouseButton1Click:Connect(function()
        local now = tick()
        if now - lastClick < 0.3 then return end  -- анти-двойной клик
        lastClick = now
        state = not state
        updateVisual()
        if callback then pcall(callback, state) end
    end)

    return {
        Set = function(v) state = v; updateVisual(); if callback then pcall(callback, state) end end,
        Get = function() return state end
    }
end

-- =========================================================
-- ХЕЛПЕР: Slider (ползунок)
-- =========================================================
local function makeSlider(parent, labelText, minVal, maxVal, default, callback)
    local value = default or minVal

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 46)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Frame.BorderSizePixel = 0
    Frame.Parent = parent

    local FC = Instance.new("UICorner")
    FC.CornerRadius = UDim.new(0, 6)
    FC.Parent = Frame

    local FS = Instance.new("UIStroke")
    FS.Color = Color3.fromRGB(40, 40, 40)
    FS.Thickness = 1
    FS.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -70, 0, 20)
    Label.Position = UDim2.new(0, 12, 0, 4)
    Label.BackgroundTransparency = 1
    Label.Text = labelText
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.TextSize = 13
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0, 50, 0, 20)
    ValueLabel.Position = UDim2.new(1, -58, 0, 4)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(value)
    ValueLabel.TextColor3 = Color3.fromRGB(255, 140, 40)
    ValueLabel.TextSize = 13
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = Frame

    local TrackBg = Instance.new("Frame")
    TrackBg.Size = UDim2.new(1, -24, 0, 5)
    TrackBg.Position = UDim2.new(0, 12, 0, 32)
    TrackBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TrackBg.BorderSizePixel = 0
    TrackBg.Parent = Frame

    local TrackCorner = Instance.new("UICorner")
    TrackCorner.CornerRadius = UDim.new(1, 0)
    TrackCorner.Parent = TrackBg

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((value - minVal) / (maxVal - minVal), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(255, 140, 40)
    Fill.BorderSizePixel = 0
    Fill.Parent = TrackBg

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = Fill

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 12, 0, 12)
    Knob.AnchorPoint = Vector2.new(0.5, 0.5)
    Knob.Position = UDim2.new((value - minVal) / (maxVal - minVal), 0, 0.5, 0)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.BorderSizePixel = 0
    Knob.Parent = TrackBg

    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob

    local ClickArea = Instance.new("TextButton")
    ClickArea.Size = UDim2.new(1, 0, 1, 0)
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
        ValueLabel.Text = tostring(value)
        if callback then pcall(callback, value) end
    end

    ClickArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateFromMouse(input.Position.X)
        end
    end)

    ClickArea.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateFromMouse(input.Position.X)
        end
    end)

    return {
        Set = function(v)
            value = math.clamp(v, minVal, maxVal)
            local relX = (value - minVal) / (maxVal - minVal)
            Fill.Size = UDim2.new(relX, 0, 1, 0)
            Knob.Position = UDim2.new(relX, 0, 0.5, 0)
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
    PredictionEnabled = false,
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

-- Получить ближайшую к прицелу цель
local function getAimTarget()
    local camera = workspace.CurrentCamera
    local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    local myChar = LocalPlayer.Character
    if not myChar then return nil end

    local bestTarget, bestPart, bestDist = nil, nil, AIM.FOV
    local potentialTargets = {}

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character ~= myChar then
            if not AIM.TeamCheck or (plr.Team ~= LocalPlayer.Team) then
                table.insert(potentialTargets, plr.Character)
            end
        end
    end

    local function scan(container)
        for _, obj in ipairs(container:GetChildren()) do
            if obj:IsA("Model") and obj ~= myChar and not Players:GetPlayerFromCharacter(obj) then
                if obj:FindFirstChildOfClass("Humanoid") then
                    table.insert(potentialTargets, obj)
                end
            elseif obj:IsA("Folder") or (obj:IsA("Model") and not obj:FindFirstChildOfClass("Humanoid")) then
                scan(obj)
            end
        end
    end
    scan(workspace)

    for _, model in ipairs(potentialTargets) do
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

    return bestTarget, bestPart
end

-- =========================================================
-- AIMBOT: SMOOTH AIM + AUTO FIRE (v2)
-- =========================================================

-- Дополнительные настройки AIM
AIM.Smoothness = 0.35      -- 0 = мгновенно, 1 = не двигается
AIM.Prediction = 0.12      -- предсказание движения цели (сек)
AIM.AutoFireDelay = 0.05   -- задержка между выстрелами
AIM.VisibleColor = false   -- красить цель в красный когда видно

-- Хранилище скорости цели для prediction
local targetVelocityCache = {}

-- Предсказание позиции цели (учёт движения) — только если тумблер включён
local function predictPosition(part, velocity, ping)
    if not part or not velocity then return part.Position end
    if not AIM.PredictionEnabled then return part.Position end
    return part.Position + velocity * (AIM.Prediction + ping)
end

-- Получаем пинг игрока (если есть)
local function getPing()
    local ok, ping = pcall(function()
        return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
    end)
    return ok and ping or 0
end

-- Автофайр через mousemoverel (работает в большинстве игр без античита)
local autoFireLast = 0
local function doAutoFire()
    local now = tick()
    if now - autoFireLast < AIM.AutoFireDelay then return end
    autoFireLast = now

    pcall(function()
        local VirtualInputManager = game:GetService("VirtualInputManager")
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
        task.defer(function()
            task.wait(0.01)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
        end)
    end)
end

-- Основной цикл AIMBOT (RenderStepped для максимальной отзывчивости)
aimConnection = RunService.RenderStepped:Connect(function(dt)
    if not AIM.Enabled then return end

    local target, part = getAimTarget()
    if not target or not part then return end

    local camera = workspace.CurrentCamera

    -- Считаем скорость цели для prediction
    local rootPart = target:FindFirstChild("HumanoidRootPart") or target.PrimaryPart
    local velocity = Vector3.zero
    if rootPart then
        local cached = targetVelocityCache[target]
        if cached and cached.lastPos then
            velocity = (rootPart.Position - cached.lastPos) / math.max(dt, 0.001)
        end
        targetVelocityCache[target] = { lastPos = rootPart.Position }
    end

    -- Предсказанная позиция
    local aimPos = predictPosition(part, velocity, getPing())

    -- Smooth lerp
    local targetCF = CFrame.new(camera.CFrame.Position, aimPos)
    if AIM.Smoothness <= 0.01 then
        camera.CFrame = targetCF
    else
        -- Нормализуем smoothness: 0 = мгновенно, 1 = почти не двигается
        local alpha = math.clamp(1 - AIM.Smoothness, 0.05, 1)
        camera.CFrame = camera.CFrame:Lerp(targetCF, alpha)
    end

    if AIM.AutoFire then
        doAutoFire()
    end
end)

-- Очистка кэша скорости
task.spawn(function()
    while aimConnection do
        task.wait(5)
        for model in pairs(targetVelocityCache) do
            if not model.Parent then
                targetVelocityCache[model] = nil
            end
        end
    end
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

-- Тумблер Prediction + ползунок под ним
makeToggle(aimSettings, "Prediction", false, function(v)
    AIM.PredictionEnabled = v
end)
makeSlider(aimSettings, "Prediction Amount", 0, 50, 12, function(v)
    AIM.Prediction = v / 100
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

-- Рекурсивный сбор ВСЕХ целей (игроки + боты в любой папке)
local function getTargets()
    local targets = {}
    local myChar = LocalPlayer.Character
    local seen = {} -- защита от дубликатов

    -- 1) Игроки
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

    -- 2) Боты / NPC — рекурсивно обходим ВЕСЬ workspace
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
                -- Углубляемся в папки и вложенные модели (Bots, NPCs, Mobs, Enemies...)
                scan(obj)
            end
        end
    end
    scan(workspace)

    return targets
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
        strafeLinearVel.MaxForce = math.huge
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
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 16 end
        end
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

-- Эмулируем нажатие пробела (реальная клавиша)
local function pressSpace()
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
    Size = 30,           -- во сколько раз увеличить (30x = огромная голова)
    Transparency = false, -- не портим вид, оставляем как есть
    Connection = nil,
    Modified = {},       -- [head] = {Size, Transparency, Color, CanCollide}
    LastScan = 0,
}

-- Применяем расширение ТОЛЬКО к голове
local function expandHead(model)
    if not model or not model.Parent then return end
    if model == LocalPlayer.Character then return end

    local head = model:FindFirstChild("Head")
    if not head or not head:IsA("BasePart") then return end
    if HITBOX.Modified[head] then return end  -- уже расширено

    -- Запоминаем оригинал
    HITBOX.Modified[head] = {
        Size = head.Size,
        Transparency = head.Transparency,
        Color = head.Color,
        CanCollide = head.CanCollide,
        Massless = head.Massless,
    }

    -- Расширяем
    head.Size = head.Size * HITBOX.Size
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

makeSlider(tabs["Misc"].Container, "Hitbox Size", 5, 100, 30, function(v)
    HITBOX.Size = v
    if HITBOX.Enabled then
        resetAll() -- пересоздаст с новым размером при следующем скане
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
                part.CanCollide = false
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

-- =========================================================
-- MISC: MAGNET v2 — телепорт врагов + автофаер + режимы
-- =========================================================

local MAGNET = {
    Enabled = false,
    Connection = nil,
    AutoFire = false,
    Mode = "Aim",
    Offset = 3,
    TargetBots = true,      -- телепорт ботов
    TargetPlayers = true,   -- телепорт живых игроков
}

local magnetFireLast = 0

local function getAimPoint()
    local camera = workspace.CurrentCamera
    if not camera then return nil end
    return camera.CFrame.Position + camera.CFrame.LookVector * MAGNET.Offset
end

local function getPlayerPoint()
    local char = LocalPlayer.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart
    return root and root.Position or nil
end

local function teleportModel(model, targetPos)
    if not model or not model.Parent then return end
    local myChar = LocalPlayer.Character
    if model == myChar then return end

    local hum = model:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end

    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") then
            pcall(function()
                part.CanCollide = false
                part.CFrame = CFrame.new(targetPos)
            end)
        end
    end
end

local function getPlayerEnemies()
    local enemies = {}
    local myChar = LocalPlayer.Character
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character ~= myChar then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                table.insert(enemies, plr.Character)
            end
        end
    end
    return enemies
end

local function getBotEnemies()
    local enemies = {}
    local myChar = LocalPlayer.Character
    local function scan(container)
        for _, obj in ipairs(container:GetChildren()) do
            if obj:IsA("Model") and obj ~= myChar then
                if not Players:GetPlayerFromCharacter(obj) then
                    local hum = obj:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        table.insert(enemies, obj)
                    end
                end
            elseif obj:IsA("Folder") or (obj:IsA("Model") and not obj:FindFirstChildOfClass("Humanoid")) then
                scan(obj)
            end
        end
    end
    scan(workspace)
    return enemies
end

local function getAllEnemies()
    local enemies = {}
    if MAGNET.TargetPlayers then
        for _, e in ipairs(getPlayerEnemies()) do
            table.insert(enemies, e)
        end
    end
    if MAGNET.TargetBots then
        for _, e in ipairs(getBotEnemies()) do
            table.insert(enemies, e)
        end
    end
    return enemies
end

local function magnetAutoFire()
    if not MAGNET.AutoFire then return end
    local now = tick()
    if now - magnetFireLast < 0.05 then return end
    magnetFireLast = now

    pcall(function()
        local VirtualInputManager = game:GetService("VirtualInputManager")
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
        task.defer(function()
            task.wait(0.01)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
        end)
    end)
end

local function startMagnet()
    if MAGNET.Connection then return end

    MAGNET.Connection = RunService.Heartbeat:Connect(function()
        if not MAGNET.Enabled then return end

        local target
        if MAGNET.Mode == "Player" then
            target = getPlayerPoint()
        else
            target = getAimPoint()
        end
        if not target then return end

        for _, enemy in ipairs(getAllEnemies()) do
            pcall(teleportModel, enemy, target)
        end

        magnetAutoFire()
    end)
end

local function stopMagnet()
    if MAGNET.Connection then
        MAGNET.Connection:Disconnect()
        MAGNET.Connection = nil
    end
end

-- Главный тумблер Magnet
makeToggle(tabs["Misc"].Container, "Magnet", false, function(v)
    MAGNET.Enabled = v
    if v then startMagnet() else stopMagnet() end
end)

-- Под-окно "Magnet Mode"
local magnetSettings = makeCollapsible(tabs["Misc"].Container, "Magnet Mode", false)

makeToggle(magnetSettings, "Auto Fire", false, function(v)
    MAGNET.AutoFire = v
end)

makeToggle(magnetSettings, "Mode: to Me", false, function(v)
    MAGNET.Mode = v and "Player" or "Aim"
end)

makeSlider(magnetSettings, "Magnet Offset", 1, 15, 3, function(v)
    MAGNET.Offset = v
end)

-- Цели телепорта
makeToggle(magnetSettings, "Target Bots", true, function(v)
    MAGNET.TargetBots = v
end)

makeToggle(magnetSettings, "Target Players", true, function(v)
    MAGNET.TargetPlayers = v
end)

-- =========================================================
-- KEYBIND: K — открыть/закрыть GUI
-- =========================================================
local guiVisible = false
local keybindLabel

inputConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.K then
        guiVisible = not guiVisible
        ScreenGui.Enabled = guiVisible
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
    if INTRO_CONNECTION then
        pcall(function() INTRO_CONNECTION:Disconnect() end)
        INTRO_CONNECTION = nil
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
    -- 5) Magnet — стоп
    -- =========================================================
    if MAGNET then
        MAGNET.Enabled = false
        if MAGNET.Connection then
            pcall(function() MAGNET.Connection:Disconnect() end)
            MAGNET.Connection = nil
        end
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

    -- Чистим всё Fly-связанное из workspace
    pcall(function()
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj.Name == "SlaughterFlyVelocity" and obj:IsA("LinearVelocity") then obj:Destroy() end
            if obj.Name == "SlaughterFlyAttach" and obj:IsA("Attachment") then obj:Destroy() end
            if obj.Name == "SlaughterFlyAntiGrav" and obj:IsA("BodyForce") then obj:Destroy() end
            if obj.Name == "SlaughterSafeZone" and obj:IsA("Part") then obj:Destroy() end
        end
    end)

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
-- УВЕДОМЛЕНИЯ
-- =========================================================
local NotifyGui = Instance.new("ScreenGui")
NotifyGui.Name = "SlaughterNotifications"
NotifyGui.ResetOnSpawn = false
NotifyGui.DisplayOrder = 999
pcall(function() NotifyGui.Parent = CoreGui end)
if not NotifyGui.Parent then NotifyGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local NotifyHolder = Instance.new("Frame")
NotifyHolder.Size = UDim2.new(0, 280, 0, 500)
NotifyHolder.Position = UDim2.new(1, -300, 0, 20)
NotifyHolder.BackgroundTransparency = 1
NotifyHolder.Parent = NotifyGui

local NotifyLayout = Instance.new("UIListLayout")
NotifyLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifyLayout.Padding = UDim.new(0, 8)
NotifyLayout.Parent = NotifyHolder

local function notify(title, text, duration, accentColor)
    accentColor = accentColor or Color3.fromRGB(255, 30, 30)
    duration = duration or 2

    local Notif = Instance.new("Frame")
    Notif.Size = UDim2.new(1, 0, 0, 55)
    Notif.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Notif.BorderSizePixel = 0
    Notif.BackgroundTransparency = 1
    Notif.Parent = NotifyHolder

    local NC = Instance.new("UICorner")
    NC.CornerRadius = UDim.new(0, 8)
    NC.Parent = Notif

    local NS = Instance.new("UIStroke")
    NS.Color = Color3.fromRGB(35, 35, 35)
    NS.Thickness = 1
    NS.Transparency = 1
    NS.Parent = Notif

    local AB = Instance.new("Frame")
    AB.Size = UDim2.new(0, 3, 1, -16)
    AB.Position = UDim2.new(0, 0, 0.5, 0)
    AB.AnchorPoint = Vector2.new(0, 0.5)
    AB.BackgroundColor3 = accentColor
    AB.BorderSizePixel = 0
    AB.BackgroundTransparency = 1
    AB.Parent = Notif

    local ABC = Instance.new("UICorner")
    ABC.CornerRadius = UDim.new(1, 0)
    ABC.Parent = AB

    local NT = Instance.new("TextLabel")
    NT.Size = UDim2.new(1, -20, 0, 22)
    NT.Position = UDim2.new(0, 14, 0, 8)
    NT.BackgroundTransparency = 1
    NT.Text = title
    NT.TextColor3 = Color3.fromRGB(255, 255, 255)
    NT.TextSize = 14
    NT.Font = Enum.Font.GothamBold
    NT.TextXAlignment = Enum.TextXAlignment.Left
    NT.TextTransparency = 1
    NT.Parent = Notif

    local NText = Instance.new("TextLabel")
    NText.Size = UDim2.new(1, -20, 0, 18)
    NText.Position = UDim2.new(0, 14, 0, 28)
    NText.BackgroundTransparency = 1
    NText.Text = text
    NText.TextColor3 = Color3.fromRGB(170, 170, 170)
    NText.TextSize = 12
    NText.Font = Enum.Font.Gotham
    NText.TextXAlignment = Enum.TextXAlignment.Left
    NText.TextTransparency = 1
    NText.Parent = Notif

    TweenService:Create(Notif, TweenInfo.new(0.25), {BackgroundTransparency = 0}):Play()
    TweenService:Create(NS, TweenInfo.new(0.25), {Transparency = 0}):Play()
    TweenService:Create(AB, TweenInfo.new(0.25), {BackgroundTransparency = 0}):Play()
    TweenService:Create(NT, TweenInfo.new(0.25), {TextTransparency = 0}):Play()
    TweenService:Create(NText, TweenInfo.new(0.25), {TextTransparency = 0}):Play()

    task.delay(duration, function()
        if not Notif.Parent then return end
        TweenService:Create(Notif, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
        TweenService:Create(NS, TweenInfo.new(0.25), {Transparency = 1}):Play()
        TweenService:Create(AB, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
        TweenService:Create(NT, TweenInfo.new(0.25), {TextTransparency = 1}):Play()
        TweenService:Create(NText, TweenInfo.new(0.25), {TextTransparency = 1}):Play()
        task.wait(0.3)
        if Notif.Parent then Notif:Destroy() end
    end)
end

-- =========================================================
-- ИНТРО
-- =========================================================
local function runIntro()
    local IntroGui = Instance.new("ScreenGui")
    IntroGui.Name = "SlaughterIntro"
    IntroGui.ResetOnSpawn = false
    IntroGui.IgnoreGuiInset = true
    IntroGui.DisplayOrder = 998
    pcall(function() IntroGui.Parent = CoreGui end)
    if not IntroGui.Parent then IntroGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    local Backdrop = Instance.new("Frame")
    Backdrop.Size = UDim2.new(1, 0, 1, 0)
    Backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Backdrop.BackgroundTransparency = 1
    Backdrop.BorderSizePixel = 0
    Backdrop.Parent = IntroGui

    local LoadWindow = Instance.new("Frame")
    LoadWindow.Size = UDim2.new(0, 320, 0, 130)
    LoadWindow.Position = UDim2.new(0.5, -160, 0.5, -65)
    LoadWindow.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    LoadWindow.BorderSizePixel = 0
    LoadWindow.BackgroundTransparency = 1
    LoadWindow.Parent = IntroGui

    local LC = Instance.new("UICorner")
    LC.CornerRadius = UDim.new(0, 10)
    LC.Parent = LoadWindow

    local LS = Instance.new("UIStroke")
    LS.Color = Color3.fromRGB(35, 35, 35)
    LS.Thickness = 1
    LS.Transparency = 1
    LS.Parent = LoadWindow

    local LT = Instance.new("TextLabel")
    LT.Size = UDim2.new(1, -40, 0, 30)
    LT.Position = UDim2.new(0, 20, 0, 18)
    LT.BackgroundTransparency = 1
    LT.Text = "SLAUGHTER"
    LT.TextColor3 = Color3.fromRGB(255, 255, 255)
    LT.TextSize = 22
    LT.Font = Enum.Font.GothamBold
    LT.TextXAlignment = Enum.TextXAlignment.Left
    LT.TextTransparency = 1
    LT.Parent = LoadWindow

    local LA = Instance.new("Frame")
    LA.Size = UDim2.new(0, 60, 0, 2)
    LA.Position = UDim2.new(0, 20, 0, 48)
    LA.BackgroundColor3 = Color3.fromRGB(255, 30, 30)
    LA.BorderSizePixel = 0
    LA.BackgroundTransparency = 1
    LA.Parent = LoadWindow

    local LStatus = Instance.new("TextLabel")
    LStatus.Size = UDim2.new(1, -40, 0, 16)
    LStatus.Position = UDim2.new(0, 20, 0, 58)
    LStatus.BackgroundTransparency = 1
    LStatus.Text = "Initializing..."
    LStatus.TextColor3 = Color3.fromRGB(170, 170, 170)
    LStatus.TextSize = 12
    LStatus.Font = Enum.Font.Gotham
    LStatus.TextXAlignment = Enum.TextXAlignment.Left
    LStatus.TextTransparency = 1
    LStatus.Parent = LoadWindow

    -- ========= КРУГОВАЯ ЗАГРУЗКА =========
    local SpinnerContainer = Instance.new("Frame")
    SpinnerContainer.Size = UDim2.new(0, 60, 0, 60)
    SpinnerContainer.Position = UDim2.new(1, -80, 0, 35)
    SpinnerContainer.BackgroundTransparency = 1
    SpinnerContainer.Parent = LoadWindow

    -- Внешнее кольцо (фон)
    local OuterRing = Instance.new("Frame")
    OuterRing.Size = UDim2.new(1, 0, 1, 0)
    OuterRing.Position = UDim2.new(0, 0, 0, 0)
    OuterRing.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    OuterRing.BorderSizePixel = 0
    OuterRing.BackgroundTransparency = 1
    OuterRing.Parent = SpinnerContainer

    local OuterRingCorner = Instance.new("UICorner")
    OuterRingCorner.CornerRadius = UDim.new(1, 0)
    OuterRingCorner.Parent = OuterRing

    local OuterRingStroke = Instance.new("UIStroke")
    OuterRingStroke.Color = Color3.fromRGB(40, 40, 40)
    OuterRingStroke.Thickness = 3
    OuterRingStroke.Transparency = 1
    OuterRingStroke.Parent = OuterRing

    -- Вращающийся сегмент (имитация круговой загрузки)
    local Spinner = Instance.new("Frame")
    Spinner.Size = UDim2.new(1, 0, 1, 0)
    Spinner.Position = UDim2.new(0, 0, 0, 0)
    Spinner.BackgroundTransparency = 1
    Spinner.Parent = SpinnerContainer

    local SpinnerCorner = Instance.new("UICorner")
    SpinnerCorner.CornerRadius = UDim.new(1, 0)
    SpinnerCorner.Parent = Spinner

    -- Крутящийся индикатор через UIStroke с градиентом
    local SpinnerStroke = Instance.new("UIStroke")
    SpinnerStroke.Color = Color3.fromRGB(255, 140, 40)
    SpinnerStroke.Thickness = 3
    SpinnerStroke.Transparency = 1
    SpinnerStroke.Parent = Spinner

    -- Проценты в центре круга
    local PercentLabel = Instance.new("TextLabel")
    PercentLabel.Size = UDim2.new(1, 0, 1, 0)
    PercentLabel.Position = UDim2.new(0, 0, 0, 0)
    PercentLabel.BackgroundTransparency = 1
    PercentLabel.Text = "0%"
    PercentLabel.TextColor3 = Color3.fromRGB(255, 140, 40)
    PercentLabel.TextSize = 13
    PercentLabel.Font = Enum.Font.GothamBold
    PercentLabel.TextTransparency = 1
    PercentLabel.Parent = SpinnerContainer

    -- Маленькая точка-индикатор на вращающемся кольце
    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.new(0, 8, 0, 8)
    Dot.Position = UDim2.new(0.5, -4, 0, -4)
    Dot.AnchorPoint = Vector2.new(0.5, 0.5)
    Dot.BackgroundColor3 = Color3.fromRGB(255, 140, 40)
    Dot.BorderSizePixel = 0
    Dot.BackgroundTransparency = 1
    Dot.Parent = SpinnerContainer

    local DotCorner = Instance.new("UICorner")
    DotCorner.CornerRadius = UDim.new(1, 0)
    DotCorner.Parent = Dot

    -- Анимация вращения (запускаем сразу)
    local spinning = true
    task.spawn(function()
        while spinning do
            Spinner.Rotation = (Spinner.Rotation + 8) % 360
            Dot.Position = UDim2.new(
                0.5 + math.cos(math.rad(Spinner.Rotation)) * 0.5 - 0.06,
                0,
                0.5 + math.sin(math.rad(Spinner.Rotation)) * 0.5 - 0.06,
                0
            )
            task.wait(0.016)
        end
    end)

    TweenService:Create(Backdrop, TweenInfo.new(0.3), {BackgroundTransparency = 0.5}):Play()
    TweenService:Create(LoadWindow, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    TweenService:Create(LS, TweenInfo.new(0.3), {Transparency = 0}):Play()
    TweenService:Create(LT, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    TweenService:Create(LA, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    TweenService:Create(LStatus, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    TweenService:Create(OuterRingStroke, TweenInfo.new(0.3), {Transparency = 0}):Play()
    TweenService:Create(SpinnerStroke, TweenInfo.new(0.3), {Transparency = 0}):Play()
    TweenService:Create(Dot, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    TweenService:Create(PercentLabel, TweenInfo.new(0.3), {TextTransparency = 0}):Play()

    task.wait(0.35)

    local totalDuration = 2.2
    local elapsed = 0
    local lastStatusIdx = -1

    local statuses = {
        {p = 0.20, t = "Injecting..."},
        {p = 0.45, t = "Loading modules..."},
        {p = 0.70, t = "Building interface..."},
        {p = 0.90, t = "Applying theme..."},
        {p = 1.00, t = "Ready!"},
    }

    local conn
    conn = RunService.Heartbeat:Connect(function(dt)
        INTRO_CONNECTION = conn
        elapsed = elapsed + dt
        local progress = math.clamp(elapsed / totalDuration, 0, 1)

        -- Процент в центре круга
        PercentLabel.Text = tostring(math.floor(progress * 100)) .. "%"

        -- Прогресс тоже отображается через прозрачность кольца
        SpinnerStroke.Transparency = 1 - progress * 0.5

        for i, s in ipairs(statuses) do
            if progress >= s.p - 0.15 and i > lastStatusIdx then
                lastStatusIdx = i
                LStatus.Text = s.t
            end
        end

        if progress >= 1 then
            conn:Disconnect()

            task.wait(0.3)

            spinning = false -- останавливаем вращение

            TweenService:Create(Backdrop, TweenInfo.new(0.35), {BackgroundTransparency = 1}):Play()
            TweenService:Create(LoadWindow, TweenInfo.new(0.35), {BackgroundTransparency = 1}):Play()
            TweenService:Create(LS, TweenInfo.new(0.35), {Transparency = 1}):Play()
            TweenService:Create(LT, TweenInfo.new(0.35), {TextTransparency = 1}):Play()
            TweenService:Create(LA, TweenInfo.new(0.35), {BackgroundTransparency = 1}):Play()
            TweenService:Create(LStatus, TweenInfo.new(0.35), {TextTransparency = 1}):Play()
            TweenService:Create(OuterRingStroke, TweenInfo.new(0.35), {Transparency = 1}):Play()
            TweenService:Create(SpinnerStroke, TweenInfo.new(0.35), {Transparency = 1}):Play()
            TweenService:Create(Dot, TweenInfo.new(0.35), {BackgroundTransparency = 1}):Play()
            TweenService:Create(PercentLabel, TweenInfo.new(0.35), {TextTransparency = 1}):Play()

            task.wait(0.4)

            if IntroGui.Parent then IntroGui:Destroy() end

            ScreenGui.Enabled = true
            guiVisible = true
            TweenService:Create(Main, TweenInfo.new(0.4), {BackgroundTransparency = 0}):Play()
            TweenService:Create(MainStroke, TweenInfo.new(0.4), {Transparency = 0}):Play()
            TweenService:Create(TopBar, TweenInfo.new(0.4), {BackgroundTransparency = 0}):Play()
            TweenService:Create(Sidebar, TweenInfo.new(0.4), {BackgroundTransparency = 0}):Play()
            TweenService:Create(Content, TweenInfo.new(0.4), {BackgroundTransparency = 0}):Play()
        end
    end)
end

-- =========================================================
-- СТАРТ
-- =========================================================
notify("SLAUGHTER", "Xeno Full Supported", 2, Color3.fromRGB(80, 255, 120))
task.wait(0.4)
notify("SLAUGHTER", "Injecting interface...", 2, Color3.fromRGB(255, 200, 50))
task.wait(0.3)
notify("SLAUGHTER", "2.0 — full support enabled", 3, Color3.fromRGB(255, 140, 40))
task.wait(0.6)

runIntro()

print("[SLAUGHTER] 2.0 загружен! Бинд на K — открыть/закрыть GUI.")
