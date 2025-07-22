local OverflowHub = {}
OverflowHub.__index = OverflowHub

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Theme Configuration
local Theme = {
    Background = Color3.fromRGB(30, 30, 30), -- #1E1E1E
    Accent = Color3.fromRGB(0, 123, 255), -- #007BFF
    Text = Color3.fromRGB(255, 255, 255),
    Secondary = Color3.fromRGB(50, 50, 50),
    Border = Color3.fromRGB(100, 100, 100),
    Font = Enum.Font.Gotham,
    CornerRadius = 8,
    Padding = 5,
    AnimationDuration = 0.3,
    EasingStyle = Enum.EasingStyle.Quad,
    EasingDirection = Enum.EasingDirection.Out
}

-- Utility Functions
local function CreateUICorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or Theme.CornerRadius)
    corner.Parent = parent
    return corner
end

local function Tween(object, properties, duration, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(duration or Theme.AnimationDuration, easingStyle or Theme.EasingStyle, easingDirection or Theme.EasingDirection)
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

local function MakeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

local function MakeResizable(frame, handle)
    local resizing, resizeInput, resizeStart, startSize
    local minSize = Vector2.new(200, 150)
    local function update(input)
        local delta = input.Position - resizeStart
        local newSize = UDim2.new(0, math.max(minSize.X, startSize.X.Offset + delta.X), 0, math.max(minSize.Y, startSize.Y.Offset + delta.Y))
        frame.Size = newSize
    end
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true
            resizeStart = input.Position
            startSize = frame.Size
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    resizing = false
                end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            resizeInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == resizeInput and resizing then
            update(input)
        end
    end)
end

-- Config System (Placeholder; extend with file I/O)
local Configs = {}
function OverflowHub:SaveConfig(name)
    Configs[name] = {} -- Populate with component states
    print("Config saved: " .. name)
end
function OverflowHub:LoadConfig(name)
    if Configs[name] then
        -- Apply states
        print("Config loaded: " .. name)
    end
end

-- Window Class
local Window = {}
Window.__index = Window

function Window.new(library, title)
    local self = setmetatable({}, Window)
    self.Library = library
    self.Title = title
    self.Tabs = {}
    self.ActiveTab = nil

    -- Main Frame
    self.Frame = Instance.new("Frame")
    self.Frame.Size = UDim2.new(0, 400, 0, 300)
    self.Frame.Position = UDim2.new(0.5, -200, 0.5, -150)
    self.Frame.BackgroundColor3 = Theme.Background
    self.Frame.BorderSizePixel = 0
    CreateUICorner(self.Frame)
    self.Frame.Parent = library.ScreenGui
    self.Frame.Visible = false

    -- Title Bar
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Size = UDim2.new(1, 0, 0, 30)
    self.TitleBar.BackgroundColor3 = Theme.Secondary
    self.TitleBar.BorderSizePixel = 0
    CreateUICorner(self.TitleBar, Theme.CornerRadius / 2)
    self.TitleBar.Parent = self.Frame

    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Size = UDim2.new(1, -60, 1, 0)
    self.TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = title
    self.TitleLabel.TextColor3 = Theme.Text
    self.TitleLabel.Font = Theme.Font
    self.TitleLabel.TextSize = 14
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.Parent = self.TitleBar

    -- Close Button
    self.CloseButton = Instance.new("TextButton")
    self.CloseButton.Size = UDim2.new(0, 30, 0, 30)
    self.CloseButton.Position = UDim2.new(1, -30, 0, 0)
    self.CloseButton.BackgroundTransparency = 1
    self.CloseButton.Text = "X"
    self.CloseButton.TextColor3 = Theme.Text
    self.CloseButton.Font = Theme.Font
    self.CloseButton.TextSize = 14
    self.CloseButton.Parent = self.TitleBar
    self.CloseButton.MouseButton1Click:Connect(function()
        self.Library:ToggleVisibility()
    end)

    -- Minimize Button (Placeholder; toggles visibility for now)
    self.MinimizeButton = Instance.new("TextButton")
    self.MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    self.MinimizeButton.Position = UDim2.new(1, -60, 0, 0)
    self.MinimizeButton.BackgroundTransparency = 1
    self.MinimizeButton.Text = "-"
    self.MinimizeButton.TextColor3 = Theme.Text
    self.MinimizeButton.Font = Theme.Font
    self.MinimizeButton.TextSize = 14
    self.MinimizeButton.Parent = self.TitleBar
    self.MinimizeButton.MouseButton1Click:Connect(function()
        self.Library:ToggleVisibility()
    end)

    -- Tab Container
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Size = UDim2.new(1, 0, 0, 30)
    self.TabContainer.Position = UDim2.new(0, 0, 0, 30)
    self.TabContainer.BackgroundColor3 = Theme.Secondary
    self.TabContainer.BorderSizePixel = 0
    self.TabContainer.Parent = self.Frame

    self.TabLayout = Instance.new("UIListLayout")
    self.TabLayout.FillDirection = Enum.FillDirection.Horizontal
    self.TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    self.TabLayout.Padding = UDim.new(0, Theme.Padding)
    self.TabLayout.Parent = self.TabContainer

    -- Content Container
    self.ContentContainer = Instance.new("Frame")
    self.ContentContainer.Size = UDim2.new(1, 0, 1, -60)
    self.ContentContainer.Position = UDim2.new(0, 0, 0, 60)
    self.ContentContainer.BackgroundTransparency = 1
    self.ContentContainer.Parent = self.Frame

    -- Resize Handle
    self.ResizeHandle = Instance.new("Frame")
    self.ResizeHandle.Size = UDim2.new(0, 10, 0, 10)
    self.ResizeHandle.Position = UDim2.new(1, -10, 1, -10)
    self.ResizeHandle.BackgroundColor3 = Theme.Border
    self.ResizeHandle.BorderSizePixel = 0
    CreateUICorner(self.ResizeHandle, 2)
    self.ResizeHandle.Parent = self.Frame

    -- Make Draggable and Resizable
    MakeDraggable(self.Frame, self.TitleBar)
    MakeResizable(self.Frame, self.ResizeHandle)

    return self
end

function Window:CreateTab(name)
    local tab = {}
    tab.Name = name
    tab.Button = Instance.new("TextButton")
    tab.Button.Size = UDim2.new(0, 100, 1, 0)
    tab.Button.BackgroundColor3 = Theme.Background
    tab.Button.BorderSizePixel = 0
    tab.Button.Text = name
    tab.Button.TextColor3 = Theme.Text
    tab.Button.Font = Theme.Font
    tab.Button.TextSize = 12
    CreateUICorner(tab.Button, Theme.CornerRadius / 2)
    tab.Button.Parent = self.TabContainer

    tab.Content = Instance.new("ScrollingFrame")
    tab.Content.Size = UDim2.new(1, 0, 1, 0)
    tab.Content.BackgroundTransparency = 1
    tab.Content.ScrollBarThickness = 5
    tab.Content.Visible = false
    tab.Content.Parent = self.ContentContainer

    tab.Layout = Instance.new("UIListLayout")
    tab.Layout.SortOrder = Enum.SortOrder.LayoutOrder
    tab.Layout.Padding = UDim.new(0, Theme.Padding)
    tab.Layout.Parent = tab.Content

    tab.Padding = Instance.new("UIPadding")
    tab.Padding.PaddingLeft = UDim.new(0, Theme.Padding)
    tab.Padding.PaddingRight = UDim.new(0, Theme.Padding)
    tab.Padding.PaddingTop = UDim.new(0, Theme.Padding)
    tab.Padding.PaddingBottom = UDim.new(0, Theme.Padding)
    tab.Padding.Parent = tab.Content

    -- Tab Click Event
    tab.Button.MouseButton1Click:Connect(function()
        self:SetActiveTab(name)
    end)

    table.insert(self.Tabs, tab)
    if not self.ActiveTab then
        self:SetActiveTab(name)
    end

    -- Component Creation Methods
    function tab:CreateLabel(text)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 20)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Theme.Text
        label.Font = Theme.Font
        label.TextSize = 14
        label.TextWrapped = true
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = self.Content
        self:UpdateSize()
        return label
    end

    function tab:CreateText(text)
        return self:CreateLabel(text) -- Alias
    end

    function tab:CreateToggle(name, callback)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, 0, 0, 30)
        container.BackgroundTransparency = 1
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -50, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = Theme.Text
        label.Font = Theme.Font
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = container

        local toggle = Instance.new("Frame")
        toggle.Size = UDim2.new(0, 40, 0, 20)
        toggle.Position = UDim2.new(1, -40, 0.5, -10)
        toggle.BackgroundColor3 = Theme.Secondary
        CreateUICorner(toggle, 10)
        toggle.Parent = container

        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, 20, 1, 0)
        knob.BackgroundColor3 = Theme.Accent
        CreateUICorner(knob, 10)
        knob.Parent = toggle

        local enabled = false
        local function setState(state)
            enabled = state
            Tween(knob, {Position = UDim2.new(state and 0.5 or 0, 0, 0, 0)}, 0.2)
            callback(state)
        end

        toggle.MouseButton1Click:Connect(function()
            setState(not enabled)
        end)

        container.Parent = self.Content
        self:UpdateSize()

        return { Set = setState, Get = function() return enabled end }
    end

    function tab:CreateSlider(name, min, max, step, callback)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, 0, 0, 40)
        container.BackgroundTransparency = 1

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 20)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = Theme.Text
        label.Font = Theme.Font
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = container

        local sliderBar = Instance.new("Frame")
        sliderBar.Size = UDim2.new(1, 0, 0, 10)
        sliderBar.Position = UDim2.new(0, 0, 0, 20)
        sliderBar.BackgroundColor3 = Theme.Secondary
        CreateUICorner(sliderBar, 5)
        sliderBar.Parent = container

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new(0, 0, 0, 1, 0)
        fill.BackgroundColor3 = Theme.Accent
        CreateUICorner(fill, 5)
        fill.Parent = sliderBar

        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(0, 50, 0, 20)
        valueLabel.Position = UDim2.new(1, -50, 0, 20)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = tostring(min)
        valueLabel.TextColor3 = Theme.Text
        valueLabel.Font = Theme.Font
        valueLabel.TextSize = 12
        valueLabel.Parent = container

        local value = min
        local function updateValue(newValue)
            newValue = math.clamp(newValue, min, max)
            if step then newValue = math.round(newValue / step) * step end
            fill.Size = UDim2.new((newValue - min) / (max - min), 0, 1, 0)
            valueLabel.Text = tostring(newValue)
            callback(newValue)
        end

        sliderBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                drag = true
            end
        end)
        sliderBar.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                drag = false
            end
        end)
        RunService.RenderStepped:Connect(function()
            if drag then
                local relative = math.clamp((Mouse.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
                updateValue(min + relative * (max - min))
            end
        end)

        container.Parent = self.Content
        self:UpdateSize()

        return { SetValue = updateValue, GetValue = function() return value end
    end

    function tab:CreateButton(text, callback)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 0, 30)
        button.BackgroundColor3 = Theme.Accent
        button.Text = text
        button.TextColor3 = Theme.Text
        button.Font = Theme.Font
        button.TextSize = 14
        CreateUICorner(button)
        button.Parent = self.Content

        button.MouseEnter:Connect(function()
            Tween(button, {BackgroundColor3 = Theme.Accent:lerp(Color3.fromRGB(255,255,255), 0.1)})
        end
        button.MouseLeave:Connect(function()
            Tween(button, {BackgroundColor3 = Theme.Accent})
        end)
        button.MouseButton1Click:Connect(callback)

        self:UpdateSize()
        return button
    end

    function tab:CreateTextbox(name, placeholder, callback)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, 0, 0, 30)
        container.BackgroundTransparency = 1

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0,0,20)
        label.Text = name
        label.TextColor3 = Theme.Text
        label.Font = Theme.Font
        label.TextSize = 14
        label.Parent = container

        local textbox = Instance.new("TextBox")
        textbox.Size = UDim2.new(1, 0,0,30)
        textbox.Position = UDim2.new(0,0,0,20)
        textbox.BackgroundColor3 = Theme.Secondary
        textbox.TextColor3 = ""
        textbox.PlaceholderText = placeholder
        textbox.TextColor3 = Theme.Text
        textbox.Font = Theme.Font
        textbox.TextSize = 14
        CreateUICorner(textbox)
        textbox.FocusLost:Connect(function(enter)
            if enter then
                callback(textbox.Text)
            end
        end)

        textbox.Parent = container
        container.Parent = self.Content
        self:UpdateSize()

        return textbox
    end

    function tab:CreateDropdown(name, options, callback)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1,0,0,30)
        container.BackgroundTransparency = 1

        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1,0,0,30)
        button.BackgroundColor3 = Theme.Secondary
        button.Text = name
        button.TextColor3 = Theme.Text
        button.Font = Theme.Font
        button.TextSize = 14
        CreateUICorner(button)
        button.Parent = container

        local dropFrame = Instance.new("Frame")
        dropFrame.Size = UDim2.new(1,0,0,0)
        dropFrame.Position = UDim2.new(0,0,1,0)
        dropFrame.BackgroundColor3 = Theme.Secondary
        dropFrame.Visible = false
        dropFrame.ClipsDescendants = true
        CreateUICorner(dropFrame)
        dropFrame.Parent = container

        local dropLayout = Instance.new("UIListLayout")
        dropLayout.SortOrder = Enum.SortOrder.LayoutOrder
        dropLayout.Padding = UDim.new(0,2)
        dropLayout.Parent = dropFrame

        local selected = options[1]
        local open = false

        local function toggleDrop()
            open = not open
            Tween(dropFrame, {Size = UDim2.new(1,0,0, open and (#options * 25) or 0)})
            dropFrame.Visible = open
        end

        button.MouseButton1Click:Connect(toggleDrop)

        for _, option in ipairs(options) do
            local optBtn = Instance.new("TextButton")
            optBtn.Size = UDim2.new(1,0,0,25)
            optBtn.BackgroundTransparency = 1
            optBtn.Text = option
            optBtn.TextColor3 = Theme.Text
            optBtn.Font = Theme.Font
            optBtn.TextSize = 14
            optBtn.Parent = dropFrame

            optBtn.MouseButton1Click:Connect(function()
                selected = option
                button.Text = name .. ": " .. selected
                callback(selected)
                toggleDrop()
            end)
        end

        container.Parent = self.Content
        self:UpdateSize()

        return { SetSelected = function(value) selected = value; button.Text = name .. ": " .. selected end, Get = function() return selected end

    end

    function tab:UpdateSize()
        local height = self.Layout.AbsoluteContentSize.Y + Theme.Padding * 2
        self.Content.CanvasSize = UDim2.new(0,0,0, height)
    end

    return tab
end

function Window:SetActiveTab(name)
    for _, tab in ipairs(self.Tabs) do
        if tab.Name == name then
            if self.ActiveTab ~= tab then
                if self.ActiveTab then
                    Tween(self.ActiveTab.Content, {BackgroundTransparency = 1})
                    self.ActiveTab.Content.Visible = false
                    self.ActiveTab.Button.BackgroundColor3 = Theme.Background
                end
                self.ActiveTab = tab
                tab.Content.Visible = true
                Tween(tab.Content, {BackgroundTransparency = 0}, 0.2)
                tab.Button.BackgroundColor3 = Theme.Secondary
            end
        else
            tab.Content.Visible = false
            tab.Button.BackgroundColor3 = Theme.Background
        end
    end
end

-- Library Main
function OverflowHub.new()
    local self = setmetatable({}, OverflowHub)

    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.Parent = game:WaitForChild("CoreGui") -- For exploits, may be PlayerGui

    self.Visible = true
    -- Hotkey Toggle (Insert)
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Insert then
            self:ToggleVisibility()
        end
    end)

    -- Loading Screen
    local loadingFrame = Instance.new("Frame")
    loadingFrame.Size = UDim2.new(0, 200, 0, 100)
    loadingFrame.Position = UDim2.new(0.5, -100, 0.5, -50)
    loadingFrame.BackgroundColor3 = Theme.Background
    CreateUICorner(loadingFrame)
    loadingFrame.Parent = self.ScreenGui

    local loadingText = Instance.new("TextLabel")
    loadingText.Size = UDim2.new(1,0,0,50)
    loadingText.Text = "Overflow Hub"
    loadingText.TextColor3 = Theme.Text
    loadingText.Font = Theme.Font
    loadingText.TextSize = 24
    loadingText.Parent = loadingFrame

    local spinner = Instance.new("Frame")
    spinner.Size = UDim2.new(0,0 40,0,40)
    spinner.Position = UDim2.new(0.5, -20, 0.5, 10)
    spinner.BackgroundTransparency = 1
    spinner.Parent = loadingFrame

    -- Simple spinner: rotating line
    local line = Instance.new("Frame")
    line.Size = UDim2.new(0,20,0,2)
    line.Position = UDim2.new(0.5,0,0.5)
    line.AnchorPoint = Vector2.new(0,0.5)
    line.BackgroundColor3 = Theme.Accent
    line.Parent = spinner

    local rotation = 0
    spawn(function()
        while loadingFrame.Visible do
            rotation = rotation + 10
            line.Rotation = rotation % 360
            wait(0.01)
        end
    end)

    -- Loading Animation
    Tween(loadingFrame, {BackgroundTransparency = 0})
    wait(2.5) -- 2-3 seconds
    Tween(loadingFrame, {BackgroundTransparency = 1}, 0.5).Completed:Wait()
    loadingFrame:Destroy()

    return self
end

function OverflowHub:CreateWindow(title)
    local window = Window.new(self, title)
    Tween(window.Frame, {Transparency = 0, Position = UDim2.new(0.5, -200, 0.5, -150)}, 0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In)
    window.Frame.Visible = true
    return window
end

function OverflowHub:ToggleVisibility()
    self.Visible = not self.Visible
    self.ScreenGui.Enabled = self.Visible -- Toggle entire GUI
end

function OverflowHub:SetTheme(newTheme)
    for key, value in pairs(newTheme) do
        Theme[key] = value
    end
    -- Note: To apply, would need to update all elements; omitted for brevity
end

return OverflowHub.new()
