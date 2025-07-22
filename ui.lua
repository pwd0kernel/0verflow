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
local Theme = {
    Background = Color3.fromRGB(24, 26, 32),
    Accent = Color3.fromRGB(0, 140, 255),
    Accent2 = Color3.fromRGB(36, 38, 48),
    Accent3 = Color3.fromRGB(18, 20, 26),
    Text = Color3.fromRGB(235, 240, 255),
    Border = Color3.fromRGB(60, 70, 90),
    Font = Enum.Font.Gotham,
    CornerRadius = UDim.new(0, 12),
    Padding = 14,
    Shadow = true,
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
}

local function createCorner(radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = radius or Theme.CornerRadius
    return c
end

local function createShadow(parent)
    if not Theme.Shadow then return end
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageTransparency = 0.7
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10,10,118,118)
    shadow.Size = UDim2.new(1,24,1,24)
    shadow.Position = UDim2.new(0,-12,0,-12)
    shadow.ZIndex = 0
    shadow.Parent = parent
end

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
local loadingFrame = Instance.new("Frame")
loadingFrame.Name = "LoadingFrame"
loadingFrame.Size = UDim2.new(0, Theme.LoadingWidth, 0, Theme.LoadingHeight)
loadingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
loadingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
loadingFrame.BackgroundColor3 = Theme.Accent3
loadingFrame.BorderSizePixel = 0
loadingFrame.Parent = screenGui
createCorner(Theme.CornerRadius).Parent = loadingFrame
createShadow(loadingFrame)

local loadingLabel = Instance.new("TextLabel")
loadingLabel.Size = UDim2.new(1, 0, 0, 60)
loadingLabel.Position = UDim2.new(0, 0, 0, Theme.Padding)
loadingLabel.BackgroundTransparency = 1
loadingLabel.Text = "<b>Overflow Hub</b>"
loadingLabel.Font = Theme.Font
loadingLabel.TextColor3 = Theme.Accent
loadingLabel.TextSize = Theme.TitleFontSize
loadingLabel.TextStrokeTransparency = 0.7
loadingLabel.TextStrokeColor3 = Theme.Border
loadingLabel.TextXAlignment = Enum.TextXAlignment.Center
loadingLabel.TextYAlignment = Enum.TextYAlignment.Top
loadingLabel.RichText = true
loadingLabel.Parent = loadingFrame

local loadingSub = Instance.new("TextLabel")
loadingSub.Size = UDim2.new(1, 0, 0, 28)
loadingSub.Position = UDim2.new(0, 0, 0, Theme.Padding + 54)
loadingSub.BackgroundTransparency = 1
loadingSub.Text = "Loading, please wait..."
loadingSub.Font = Theme.Font
loadingSub.TextColor3 = Theme.Text
loadingSub.TextSize = Theme.DescFontSize
loadingSub.TextTransparency = 0.15
loadingSub.TextXAlignment = Enum.TextXAlignment.Center
loadingSub.TextYAlignment = Enum.TextYAlignment.Top
loadingSub.Parent = loadingFrame

local spinner = Instance.new("ImageLabel")
spinner.Size = UDim2.new(0, 48, 0, 48)
spinner.Position = UDim2.new(0.5, -24, 1, -64)
spinner.BackgroundTransparency = 1
spinner.Image = "rbxassetid://2790382286"
spinner.ImageColor3 = Theme.Accent
spinner.ImageTransparency = 0.05
spinner.Parent = loadingFrame

-- Spinner Animation (smoother)
local spinning = true
spawn(function()
    while spinning do
        spinner.Rotation = (spinner.Rotation + 8) % 360
        RunService.RenderStepped:Wait()
    end
end)

-- Loading Animation (2.5s, fade/scale)
loadingFrame.BackgroundTransparency = 1
tween(loadingFrame, {BackgroundTransparency=0}, 0.4)
tween(loadingLabel, {TextTransparency=0}, 0.4)
tween(loadingSub, {TextTransparency=0.15}, 0.4)
tween(spinner, {ImageTransparency=0.05}, 0.4)
wait(2.5)
spinning = false
tween(loadingFrame, {BackgroundTransparency=1}, 0.5)
tween(loadingLabel, {TextTransparency=1}, 0.5)
tween(loadingSub, {TextTransparency=1}, 0.5)
tween(spinner, {ImageTransparency=1}, 0.5)
wait(0.55)
loadingFrame:Destroy()


-- Main Window (Polished, perfectly centered)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, Theme.WindowWidth, 0, Theme.WindowHeight)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Theme.Background
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui
createCorner(Theme.CornerRadius).Parent = mainFrame
createShadow(mainFrame)


-- Top Bar (Polished)
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, Theme.TopBarHeight)
topBar.BackgroundColor3 = Theme.Accent2
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame
createCorner(Theme.CornerRadius).Parent = topBar

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

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 38, 0, 38)
closeButton.Position = UDim2.new(1, -46, 0.5, -19)
closeButton.BackgroundColor3 = Theme.Accent3
closeButton.Text = "✕"
closeButton.Font = Theme.Font
closeButton.TextColor3 = Theme.Text
closeButton.TextSize = 22
closeButton.AutoButtonColor = false
closeButton.Parent = topBar
createCorner(UDim.new(0, 10)).Parent = closeButton

closeButton.MouseEnter:Connect(function()
    tween(closeButton, {BackgroundColor3=Theme.Accent}, 0.18)
end)
closeButton.MouseLeave:Connect(function()
    tween(closeButton, {BackgroundColor3=Theme.Accent3}, 0.18)
end)
closeButton.MouseButton1Click:Connect(function()
    tween(mainFrame, {BackgroundTransparency=1}, 0.3)
    wait(0.3)
    mainFrame.Visible = false
end)

-- Draggable
makeDraggable(mainFrame, topBar)


-- Tabs (Polished)
local tabBar = Instance.new("Frame")
tabBar.Name = "TabBar"
tabBar.Size = UDim2.new(1, 0, 0, Theme.TabHeight)
tabBar.Position = UDim2.new(0, 0, 0, Theme.TopBarHeight)
tabBar.BackgroundTransparency = 1
tabBar.Parent = mainFrame

local tabList = Instance.new("UIListLayout")
tabList.FillDirection = Enum.FillDirection.Horizontal
tabList.SortOrder = Enum.SortOrder.LayoutOrder
tabList.Padding = UDim.new(0, Theme.Padding)
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
    createCorner(UDim.new(0, 10)).Parent = tabBtn


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
        createCorner(UDim.new(0, 14)).Parent = toggleBtn

        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, 22, 1, -10)
        knob.Position = UDim2.new(0, 5, 0, 5)
        knob.BackgroundColor3 = Theme.Border
        knob.Parent = toggleBtn
        createCorner(UDim.new(0, 11)).Parent = knob

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
function Library:SetTheme(tbl)
    for k,v in pairs(tbl) do
        if Theme[k] ~= nil then Theme[k] = v end
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

return setmetatable(Library, {__call=function(_,...) return Library end})
