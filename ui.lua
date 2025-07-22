local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")

local Overflow = {}
Overflow.__index = Overflow

-- Theme (Polished, modern, better spacing/colors)

-- Multi-theme system (Rayfield-inspired)
local Themes = {
    Default = {
        Name = "Default",
        -- Loader palette
        Background = Color3.fromRGB(18, 20, 28), -- deep dark
        Accent = Color3.fromRGB(64, 120, 242), -- premium blue
        Accent2 = Color3.fromRGB(28, 32, 40), -- dark secondary
        Accent3 = Color3.fromRGB(24, 26, 34), -- dark tertiary
        Text = Color3.fromRGB(230, 235, 245), -- soft white
        Border = Color3.fromRGB(38, 44, 60),
        Font = Enum.Font.Gotham,
        CornerRadius = UDim.new(0, 12),
        Padding = 16,
        Shadow = false,
        TabHeight = 40,
        TopBarHeight = 46,
        TabFontSize = 20,
        TitleFontSize = 28,
        LabelFontSize = 20,
        DescFontSize = 15,
        ToggleHeight = 44,
        LabelHeight = 32,
        WindowWidth = 540,
        WindowHeight = 440,
        LoadingWidth = 420,
        LoadingHeight = 160,
        TabSpacing = 12,
        TabTopSpacing = 10,
    },
    Light = {
        Name = "Light",
        Background = Color3.fromRGB(240, 240, 245),
        Accent = Color3.fromRGB(64, 120, 242),
        Accent2 = Color3.fromRGB(220, 220, 230),
        Accent3 = Color3.fromRGB(200, 200, 210),
        Text = Color3.fromRGB(24, 26, 32),
        Border = Color3.fromRGB(180, 180, 200),
        Font = Enum.Font.Gotham,
        CornerRadius = UDim.new(0, 12),
        Padding = 14,
        Shadow = false,
        TabHeight = 40,
        TopBarHeight = 46,
        TabFontSize = 20,
        TitleFontSize = 28,
        LabelFontSize = 20,
        DescFontSize = 15,
        ToggleHeight = 44,
        LabelHeight = 32,
        WindowWidth = 540,
        WindowHeight = 440,
        LoadingWidth = 420,
        LoadingHeight = 160,
    },
    -- Add more themes here as needed
}

local Theme = Themes.Default

-- Theme switcher
function Overflow.SetTheme(name)
    if Themes[name] then
        Theme = Themes[name]
    end
end


-- Component templates (Rayfield-inspired)
local Templates = {}

function Templates.Corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = radius or Theme.CornerRadius
    c.Parent = parent
    return c
end

function Templates.Shadow(parent)
    -- Shadow disabled for clean look
    return nil
end

function Templates.Label(text, size, color, parent, font, align, rich)
    local label = Instance.new("TextLabel")
    label.Size = size or UDim2.new(1, 0, 0, Theme.LabelHeight)
    label.BackgroundTransparency = 1
    label.Text = text or "Label"
    label.Font = font or Theme.Font
    label.TextColor3 = color or Theme.Text
    label.TextSize = Theme.LabelFontSize
    label.TextXAlignment = align or Enum.TextXAlignment.Left
    label.RichText = rich or false
    label.Parent = parent
    return label
end

function Templates.Button(text, size, color, parent, font)
    local btn = Instance.new("TextButton")
    btn.Size = size or UDim2.new(0, 120, 1, 0)
    btn.BackgroundColor3 = color or Theme.Accent3
    btn.Text = text or "Button"
    btn.Font = font or Theme.Font
    btn.TextColor3 = Theme.Text
    btn.TextSize = Theme.TabFontSize
    btn.AutoButtonColor = false
    btn.Parent = parent
    Templates.Corner(btn, UDim.new(0, 10))
    return btn
end

-- Replace all createCorner/createShadow calls below with Templates.Corner/Templates.Shadow as you expand components

local function tween(obj, props, time, style, dir)
    local t = TweenService:Create(obj, TweenInfo.new(time or 0.3, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

local function makeDraggable(frame, dragBar)
    local dragging, dragInput, startPos, startInput
    dragBar = dragBar or frame
    dragBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            startPos = frame.Position
            startInput = input.Position
        end
    end)
    dragBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    dragBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - startInput
            frame.Position = startPos + UDim2.new(0, delta.X, 0, delta.Y)
        end
    end)
end

-- Main Library Table
local Library = {}
Library.__index = Library

-- Utility: Remove old GUIs
for _,v in ipairs(PlayerGui:GetChildren()) do
    if v.Name == "OverflowHub" then v:Destroy() end
end


local screenGui = Instance.new("ScreenGui")
screenGui.Name = "OverflowHub"
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui


-- Loading Screen (Polished)


-- New Minimalist Loading Screen (user design)


local loadingFrame = Instance.new("Frame")
loadingFrame.Name = "LoadingFrame"
loadingFrame.Size = UDim2.new(0, 374, 0, 114)
loadingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
loadingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
loadingFrame.BackgroundColor3 = Theme.Background -- flat premium dark
loadingFrame.BorderSizePixel = 0
loadingFrame.Parent = screenGui



-- (Removed white drop shadow for cleaner look)

-- Gradient background
-- Remove old gradient (now replaced by loaderGradient above)

local loadingCorner = Instance.new("UICorner")
loadingCorner.CornerRadius = UDim.new(0, 12)
loadingCorner.Parent = loadingFrame

local nameLabel = Instance.new("TextLabel")
nameLabel.Name = "Name"
nameLabel.Parent = loadingFrame
nameLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
nameLabel.BackgroundTransparency = 1
nameLabel.BorderSizePixel = 0
nameLabel.Position = UDim2.new(0.1417, 0, 0.1491, 0)
nameLabel.Size = UDim2.new(0, 268, 0, 50)
nameLabel.Font = Enum.Font.GothamBold
nameLabel.Text = "0verflow Hub"
nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
nameLabel.TextSize = 44
nameLabel.TextWrapped = true
nameLabel.TextTransparency = 1

local versionLabel = Instance.new("TextLabel")
versionLabel.Name = "Version"
versionLabel.Parent = loadingFrame
versionLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
versionLabel.BackgroundTransparency = 1
versionLabel.BorderSizePixel = 0
versionLabel.Position = UDim2.new(0.7995, 0, 0.8509, 0)
versionLabel.Size = UDim2.new(0, 75, 0, 17)
versionLabel.Font = Enum.Font.Ubuntu
versionLabel.Text = "0.0.1 alpha"
versionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
versionLabel.TextTransparency = 1


-- Animated dots as separate labels for fade/scale
local dotObjs = {}
local dotCount = 3
local dotSpacing = 54
for i = 1, dotCount do
    local dot = Instance.new("TextLabel")
    dot.Name = "Dot"..i
    dot.Parent = loadingFrame
    dot.BackgroundTransparency = 1
    dot.BorderSizePixel = 0
    dot.Position = UDim2.new(0, 88 + (i-1)*dotSpacing, 0, 51)
    dot.Size = UDim2.new(0, 40, 0, 40)
    dot.Font = Enum.Font.GothamBold
    dot.Text = "."
    dot.TextColor3 = Color3.fromRGB(255, 255, 255)
    dot.TextSize = 54
    dot.TextTransparency = 1
    dot.ZIndex = 2
    dotObjs[i] = dot
end


-- Animate fade/scale in
loadingFrame.BackgroundTransparency = 1
loadingFrame.Size = UDim2.new(0, 320, 0, 80)
tween(loadingFrame, {BackgroundTransparency=0, Size=UDim2.new(0, 374, 0, 114)}, 0.32, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
tween(nameLabel, {TextTransparency=0}, 0.32)
tween(versionLabel, {TextTransparency=0.18}, 0.32)
for i, dot in ipairs(dotObjs) do
    tween(dot, {TextTransparency=0.08}, 0.32)
end


-- Animated loading dots (fade/scale in sequence)
local running = true
spawn(function()
    local t = 0
    while running do
        for i, dot in ipairs(dotObjs) do
            local delay = (i-1)*0.08
            spawn(function()
                tween(dot, {TextTransparency=0.08, Size=UDim2.new(0, 48, 0, 48)}, 0.13)
                wait(0.13)
                tween(dot, {TextTransparency=0.35, Size=UDim2.new(0, 40, 0, 40)}, 0.13)
            end)
            wait(0.11)
        end
        wait(0.18)
    end
end)

wait(2.1)
running = false
tween(loadingFrame, {BackgroundTransparency=1, Size=UDim2.new(0, 420, 0, 130)}, 0.36, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
tween(nameLabel, {TextTransparency=1}, 0.36)
tween(versionLabel, {TextTransparency=1}, 0.36)
for i, dot in ipairs(dotObjs) do
    tween(dot, {TextTransparency=1}, 0.36)
end
wait(0.38)
loadingFrame:Destroy()


-- Main Window (Polished, perfectly centered)



local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, Theme.WindowWidth, 0, Theme.WindowHeight)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Theme.Background -- flat premium dark
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui
Templates.Corner(mainFrame, Theme.CornerRadius)
-- (Removed white drop shadow from main window for cleaner look)


-- Top Bar (Polished)



local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, Theme.TopBarHeight)
topBar.BackgroundColor3 = Theme.Accent2
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame
-- Only round top corners for topBar
local topBarCorner = Instance.new("UICorner")
topBarCorner.CornerRadius = Theme.CornerRadius
topBarCorner.TopLeft = true
topBarCorner.TopRight = true
topBarCorner.BottomLeft = false
topBarCorner.BottomRight = false
topBarCorner.Parent = topBar
-- (Removed white drop shadow from top bar for cleaner look)


local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -60, 1, 0)
titleLabel.Position = UDim2.new(0, Theme.Padding, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "<b>Overflow Hub</b>"
titleLabel.Font = Theme.Font
titleLabel.TextColor3 = Theme.Text
titleLabel.TextSize = Theme.TitleFontSize
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.RichText = true
titleLabel.Parent = topBar


-- Modern Exit button (icon, only hides UI)
-- MacOS-style close button (red circle with white X)
local closeButton = Instance.new("Frame")
closeButton.Size = UDim2.new(0, 22, 0, 22)
closeButton.Position = UDim2.new(0, 16, 0.5, -11)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 95, 86) -- MacOS red
closeButton.BorderSizePixel = 0
closeButton.Parent = topBar
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeButton
local xIcon = Instance.new("ImageLabel")
xIcon.Size = UDim2.new(0, 12, 0, 12)
xIcon.Position = UDim2.new(0.5, -6, 0.5, -6)
xIcon.BackgroundTransparency = 1
xIcon.Image = "rbxassetid://7072719332" -- Simple white X icon
xIcon.ImageColor3 = Color3.fromRGB(255,255,255)
xIcon.Parent = closeButton
closeButton.MouseEnter:Connect(function()
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 120, 110)
end)
closeButton.MouseLeave:Connect(function()
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 95, 86)
end)
closeButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        tween(mainFrame, {BackgroundTransparency=1}, 0.3)
        wait(0.3)
        mainFrame.Visible = false
    end
end)

-- Draggable
makeDraggable(mainFrame, topBar)


-- Tabs (Polished)


local tabBar = Instance.new("Frame")
tabBar.Name = "TabBar"
tabBar.Size = UDim2.new(1, -Theme.Padding*2, 0, Theme.TabHeight)
tabBar.Position = UDim2.new(0, Theme.Padding, 0, Theme.TopBarHeight + Theme.TabTopSpacing)
tabBar.BackgroundTransparency = 1
tabBar.Parent = mainFrame
-- Optionally, add a subtle border or shadow for tabBar for more loader-like look

local tabList = Instance.new("UIListLayout")
tabList.FillDirection = Enum.FillDirection.Horizontal
tabList.SortOrder = Enum.SortOrder.LayoutOrder
tabList.Padding = UDim.new(0, Theme.TabSpacing)
tabList.Parent = tabBar

local tabContent = Instance.new("Frame")
tabContent.Name = "TabContent"
tabContent.Size = UDim2.new(1, 0, 1, -(Theme.TopBarHeight + Theme.TabHeight + Theme.Padding))
tabContent.Position = UDim2.new(0, 0, 0, Theme.TopBarHeight + Theme.TabHeight + Theme.Padding)
tabContent.BackgroundTransparency = 1
tabContent.ClipsDescendants = true
tabContent.Parent = mainFrame


-- Show main window with animation (centered)
mainFrame.Visible = true
mainFrame.BackgroundTransparency = 1
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
tween(mainFrame, {BackgroundTransparency=0}, 0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Hotkey toggle (Insert)
local hotkey = Enum.KeyCode.Insert
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == hotkey then
        mainFrame.Visible = not mainFrame.Visible
        if mainFrame.Visible then
            mainFrame.BackgroundTransparency = 1
            tween(mainFrame, {BackgroundTransparency=0}, 0.3)
        end
    end
end)

-- Window API
local Window = {}
Window.__index = Window

function Library:CreateWindow(title)
    titleLabel.Text = title or "Overflow Hub"
    local self = setmetatable({
        _tabs = {},
        _tabButtons = {},
        _activeTab = nil,
    }, Window)
    return self
end

function Window:CreateTab(tabName)

    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0, 120, 1, 0)
    tabBtn.BackgroundColor3 = Theme.Accent3
    tabBtn.Text = tabName
    tabBtn.Font = Theme.Font
    tabBtn.TextColor3 = Theme.Text
    tabBtn.TextSize = Theme.TabFontSize
    tabBtn.AutoButtonColor = false
    tabBtn.Parent = tabBar
    Templates.Corner(tabBtn, UDim.new(0, 10))


    local tabFrame = Instance.new("Frame")
    tabFrame.Name = tabName .. "_Tab"
    tabFrame.Size = UDim2.new(1, 0, 1, 0)
    tabFrame.BackgroundTransparency = 1
    tabFrame.Visible = false
    tabFrame.Parent = tabContent

    local tabApi = setmetatable({
        _frame = tabFrame,
        _components = {},
    }, {
        __index = function(t, k)
            return Window[k] or nil
        end
    })

    self._tabs[tabName] = tabApi
    self._tabButtons[tabName] = tabBtn


    tabBtn.MouseButton1Click:Connect(function()
        for n, btn in pairs(self._tabButtons) do
            tween(btn, {BackgroundColor3 = Theme.Accent3}, 0.2)
            self._tabs[n]._frame.Visible = false
        end
        tween(tabBtn, {BackgroundColor3 = Theme.Accent}, 0.22)
        tabFrame.Visible = true
    end)

    if not self._activeTab then
        self._activeTab = tabName
        tabBtn.BackgroundColor3 = Theme.Accent
        tabFrame.Visible = true
    end

    -- Component API

    function tabApi:CreateLabel(text)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -Theme.Padding * 2, 0, Theme.LabelHeight)
        label.Position = UDim2.new(0, Theme.Padding, 0, Theme.Padding + #self._components * (Theme.LabelHeight + Theme.Padding))
        label.BackgroundTransparency = 1
        label.Text = "<b>" .. tostring(text) .. "</b>"
        label.Font = Theme.Font
        label.TextColor3 = Theme.Text
        label.TextSize = Theme.LabelFontSize
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.RichText = true
        label.Parent = tabFrame
        table.insert(self._components, label)
        return label
    end


    function tabApi:CreateToggle(text, callback, description)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Size = UDim2.new(1, -Theme.Padding * 2, 0, Theme.ToggleHeight)
        toggleFrame.Position = UDim2.new(0, Theme.Padding, 0, Theme.Padding + #self._components * (Theme.ToggleHeight + Theme.Padding))
        toggleFrame.BackgroundTransparency = 1
        toggleFrame.Parent = tabFrame

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -60, 1, 0)
        label.Position = UDim2.new(0, 0, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.Font = Theme.Font
        label.TextColor3 = Theme.Text
        label.TextSize = Theme.LabelFontSize
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = toggleFrame

        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Size = UDim2.new(0, 48, 0, 28)
        toggleBtn.Position = UDim2.new(1, -54, 0.5, -14)
        toggleBtn.BackgroundColor3 = Theme.Accent3
        toggleBtn.Text = ""
        toggleBtn.AutoButtonColor = false
        toggleBtn.Parent = toggleFrame
        Templates.Corner(toggleBtn, UDim.new(0, 14))

        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, 22, 1, -10)
        knob.Position = UDim2.new(0, 5, 0, 5)
        knob.BackgroundColor3 = Theme.Border
        knob.Parent = toggleBtn
        Templates.Corner(knob, UDim.new(0, 11))

        local enabled = false
        local function setToggle(state)
            enabled = state
            if enabled then
                tween(toggleBtn, {BackgroundColor3 = Theme.Accent}, 0.18)
                tween(knob, {Position = UDim2.new(1, -27, 0, 5), BackgroundColor3 = Theme.Accent2}, 0.18)
            else
                tween(toggleBtn, {BackgroundColor3 = Theme.Accent3}, 0.18)
                tween(knob, {Position = UDim2.new(0, 5, 0, 5), BackgroundColor3 = Theme.Border}, 0.18)
            end
        end
        toggleBtn.MouseButton1Click:Connect(function()
            setToggle(not enabled)
            if callback then pcall(callback, enabled) end
        end)
        setToggle(false)

        if description then
            local desc = Instance.new("TextLabel")
            desc.Size = UDim2.new(1, 0, 0, Theme.DescFontSize + 4)
            desc.Position = UDim2.new(0, 0, 1, -Theme.DescFontSize - 2)
            desc.BackgroundTransparency = 1
            desc.Text = description
            desc.Font = Theme.Font
            desc.TextColor3 = Theme.Border
            desc.TextSize = Theme.DescFontSize
            desc.TextXAlignment = Enum.TextXAlignment.Left
            desc.Parent = toggleFrame
        end

        table.insert(self._components, toggleFrame)
        return {
            Set = setToggle,
            Get = function() return enabled end
        }
    end

    -- More components (Slider, Button, Textbox, Dropdown) can be added here...

    return tabApi
end

-- Theme customization

-- New: SetTheme supports both table and named theme
function Library:SetTheme(theme)
    if type(theme) == "string" and Themes[theme] then
        Theme = Themes[theme]
    elseif type(theme) == "table" then
        for k,v in pairs(theme) do
            if Theme[k] ~= nil then Theme[k] = v end
        end
    end
end

-- Config save/load (file or DataStore)
function Library:SaveConfig(name, data)
    local success, err
    if writefile then
        success, err = pcall(function()
            writefile("OverflowHub_"..name..".json", HttpService:JSONEncode(data))
        end)
    end
    return success, err
end

function Library:LoadConfig(name)
    if readfile then
        local success, result = pcall(function()
            return HttpService:JSONDecode(readfile("OverflowHub_"..name..".json"))
        end)
        if success then return result end
    end
    return nil
end


-- Fix: Return a callable library that returns the Library table (with correct API)
return setmetatable(Library, {
    __call = function(_, ...)
        return Library
    end
})
