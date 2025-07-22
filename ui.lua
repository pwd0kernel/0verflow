local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")

local Overflow = {}
Overflow.__index = Overflow

-- Theme
local Theme = {
    Background = Color3.fromRGB(30,30,30),
    Accent = Color3.fromRGB(0,123,255),
    Accent2 = Color3.fromRGB(40,40,40),
    Text = Color3.fromRGB(230,230,230),
    Border = Color3.fromRGB(50,50,50),
    Font = Enum.Font.Gotham,
    CornerRadius = UDim.new(0,10),
    Padding = 8,
    Shadow = true,
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

-- Create base ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "OverflowHub"
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
screenGui.Parent = PlayerGui

-- Loading Screen
local loadingFrame = Instance.new("Frame")
loadingFrame.Name = "LoadingFrame"
loadingFrame.Size = UDim2.new(0, 350, 0, 120)
loadingFrame.Position = UDim2.new(0.5, -175, 0.5, -60)
loadingFrame.BackgroundColor3 = Theme.Background
loadingFrame.BorderSizePixel = 0
loadingFrame.AnchorPoint = Vector2.new(0.5,0.5)
loadingFrame.Parent = screenGui
createCorner(UDim.new(0,12)).Parent = loadingFrame
createShadow(loadingFrame)

local loadingLabel = Instance.new("TextLabel")
loadingLabel.Size = UDim2.new(1,0,0,50)
loadingLabel.Position = UDim2.new(0,0,0,10)
loadingLabel.BackgroundTransparency = 1
loadingLabel.Text = "Overflow Hub"
loadingLabel.Font = Theme.Font
loadingLabel.TextColor3 = Theme.Text
loadingLabel.TextSize = 32
loadingLabel.Parent = loadingFrame

local spinner = Instance.new("ImageLabel")
spinner.Size = UDim2.new(0,36,0,36)
spinner.Position = UDim2.new(0.5,-18,1,-46)
spinner.BackgroundTransparency = 1
spinner.Image = "rbxassetid://2790382286" -- spinning circle asset
spinner.ImageColor3 = Theme.Accent
spinner.Parent = loadingFrame

-- Spinner Animation
local spinning = true
spawn(function()
    while spinning do
        spinner.Rotation = (spinner.Rotation + 6) % 360
        wait(0.016)
    end
end)

-- Loading Animation (2.5s)
wait(2.5)
spinning = false
tween(loadingFrame, {BackgroundTransparency=1}, 0.4)
tween(loadingLabel, {TextTransparency=1}, 0.4)
tween(spinner, {ImageTransparency=1}, 0.4)
wait(0.45)
loadingFrame:Destroy()

-- Main Window
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 500, 0, 400)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
mainFrame.BackgroundColor3 = Theme.Background
mainFrame.BorderSizePixel = 0
mainFrame.AnchorPoint = Vector2.new(0.5,0.5)
mainFrame.Visible = false
mainFrame.Parent = screenGui
createCorner(UDim.new(0,12)).Parent = mainFrame
createShadow(mainFrame)

-- Top Bar
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1,0,0,38)
topBar.BackgroundColor3 = Theme.Accent2
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame
createCorner(UDim.new(0,12)).Parent = topBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1,-48,1,0)
titleLabel.Position = UDim2.new(0,12,0,0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Overflow Hub"
titleLabel.Font = Theme.Font
titleLabel.TextColor3 = Theme.Text
titleLabel.TextSize = 22
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = topBar

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0,32,0,32)
closeButton.Position = UDim2.new(1,-40,0,3)
closeButton.BackgroundColor3 = Theme.Accent2
closeButton.Text = "✕"
closeButton.Font = Theme.Font
closeButton.TextColor3 = Theme.Text
closeButton.TextSize = 22
closeButton.AutoButtonColor = false
closeButton.Parent = topBar
createCorner(UDim.new(0,8)).Parent = closeButton

closeButton.MouseEnter:Connect(function()
    tween(closeButton, {BackgroundColor3=Theme.Accent}, 0.2)
end)
closeButton.MouseLeave:Connect(function()
    tween(closeButton, {BackgroundColor3=Theme.Accent2}, 0.2)
end)
closeButton.MouseButton1Click:Connect(function()
    tween(mainFrame, {BackgroundTransparency=1}, 0.3)
    wait(0.3)
    mainFrame.Visible = false
end)

-- Draggable
makeDraggable(mainFrame, topBar)

-- Tabs
local tabBar = Instance.new("Frame")
tabBar.Name = "TabBar"
tabBar.Size = UDim2.new(1,0,0,36)
tabBar.Position = UDim2.new(0,0,0,38)
tabBar.BackgroundTransparency = 1
tabBar.Parent = mainFrame

local tabList = Instance.new("UIListLayout")
tabList.FillDirection = Enum.FillDirection.Horizontal
tabList.SortOrder = Enum.SortOrder.LayoutOrder
tabList.Padding = UDim.new(0,Theme.Padding)
tabList.Parent = tabBar

local tabContent = Instance.new("Frame")
tabContent.Name = "TabContent"
tabContent.Size = UDim2.new(1,0,1,-74)
tabContent.Position = UDim2.new(0,0,0,74)
tabContent.BackgroundTransparency = 1
tabContent.ClipsDescendants = true
tabContent.Parent = mainFrame

-- Show main window with animation
mainFrame.Visible = true
mainFrame.BackgroundTransparency = 1
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
    tabBtn.Size = UDim2.new(0,110,1,0)
    tabBtn.BackgroundColor3 = Theme.Accent2
    tabBtn.Text = tabName
    tabBtn.Font = Theme.Font
    tabBtn.TextColor3 = Theme.Text
    tabBtn.TextSize = 18
    tabBtn.AutoButtonColor = false
    tabBtn.Parent = tabBar
    createCorner(UDim.new(0,8)).Parent = tabBtn

    local tabFrame = Instance.new("Frame")
    tabFrame.Name = tabName .. "_Tab"
    tabFrame.Size = UDim2.new(1,0,1,0)
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
        for n,btn in pairs(self._tabButtons) do
            tween(btn, {BackgroundColor3=Theme.Accent2}, 0.2)
            self._tabs[n]._frame.Visible = false
        end
        tween(tabBtn, {BackgroundColor3=Theme.Accent}, 0.2)
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
        label.Size = UDim2.new(1,-Theme.Padding*2,0,28)
        label.Position = UDim2.new(0,Theme.Padding,0,Theme.Padding + #self._components*38)
        label.BackgroundTransparency = 1
        label.Text = text
        label.Font = Theme.Font
        label.TextColor3 = Theme.Text
        label.TextSize = 18
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = tabFrame
        table.insert(self._components, label)
        return label
    end

    function tabApi:CreateToggle(text, callback, description)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Size = UDim2.new(1,-Theme.Padding*2,0,38)
        toggleFrame.Position = UDim2.new(0,Theme.Padding,0,Theme.Padding + #self._components*44)
        toggleFrame.BackgroundTransparency = 1
        toggleFrame.Parent = tabFrame

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1,-50,1,0)
        label.Position = UDim2.new(0,0,0,0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.Font = Theme.Font
        label.TextColor3 = Theme.Text
        label.TextSize = 17
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = toggleFrame

        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Size = UDim2.new(0,40,0,24)
        toggleBtn.Position = UDim2.new(1,-44,0.5,-12)
        toggleBtn.BackgroundColor3 = Theme.Accent2
        toggleBtn.Text = ""
        toggleBtn.AutoButtonColor = false
        toggleBtn.Parent = toggleFrame
        createCorner(UDim.new(0,12)).Parent = toggleBtn

        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0,20,1,-8)
        knob.Position = UDim2.new(0,4,0,4)
        knob.BackgroundColor3 = Theme.Border
        knob.Parent = toggleBtn
        createCorner(UDim.new(0,10)).Parent = knob

        local enabled = false
        local function setToggle(state)
            enabled = state
            if enabled then
                tween(toggleBtn, {BackgroundColor3=Theme.Accent}, 0.2)
                tween(knob, {Position=UDim2.new(1,-24,0,4), BackgroundColor3=Theme.Accent2}, 0.2)
            else
                tween(toggleBtn, {BackgroundColor3=Theme.Accent2}, 0.2)
                tween(knob, {Position=UDim2.new(0,4,0,4), BackgroundColor3=Theme.Border}, 0.2)
            end
        end
        toggleBtn.MouseButton1Click:Connect(function()
            setToggle(not enabled)
            if callback then pcall(callback, enabled) end
        end)
        setToggle(false)

        if description then
            local desc = Instance.new("TextLabel")
            desc.Size = UDim2.new(1,0,0,16)
            desc.Position = UDim2.new(0,0,1,-16)
            desc.BackgroundTransparency = 1
            desc.Text = description
            desc.Font = Theme.Font
            desc.TextColor3 = Theme.Border
            desc.TextSize = 13
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
