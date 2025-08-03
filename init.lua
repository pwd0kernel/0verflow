--[[
    0verflow Hub UI Library
    A modern dark purple themed UI library for Roblox
    
    Features:
    - Modern top navigation tabs
    - Toggles, Labels, Buttons
    - Dark purple theme
    - Smooth animations
    - Clean design
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local UILibrary = {}
UILibrary.__index = UILibrary

-- Theme Configuration
local Theme = {
    Primary = Color3.fromRGB(88, 24, 131),      -- Dark Purple
    Secondary = Color3.fromRGB(124, 58, 237),   -- Medium Purple
    Accent = Color3.fromRGB(147, 51, 234),      -- Light Purple
    Background = Color3.fromRGB(17, 17, 17),    -- Dark Background
    Surface = Color3.fromRGB(30, 30, 30),       -- Surface
    Text = Color3.fromRGB(255, 255, 255),       -- White Text
    TextSecondary = Color3.fromRGB(156, 163, 175), -- Gray Text
    Success = Color3.fromRGB(34, 197, 94),      -- Green
    Warning = Color3.fromRGB(251, 191, 36),     -- Yellow
    Error = Color3.fromRGB(239, 68, 68),        -- Red
    Border = Color3.fromRGB(55, 55, 55),        -- Border
}

-- Animation Settings
local AnimationSettings = {
    HoverSpeed = 0.2,
    ClickSpeed = 0.1,
    TabSwitchSpeed = 0.3,
    ToggleSpeed = 0.2,
}

-- Utility Functions
local function CreateTween(object, properties, duration, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(
        duration or 0.2,
        easingStyle or Enum.EasingStyle.Quint,
        easingDirection or Enum.EasingDirection.Out
    )
    return TweenService:Create(object, tweenInfo, properties)
end

local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function CreatePadding(parent, padding)
    local uiPadding = Instance.new("UIPadding")
    if typeof(padding) == "number" then
        uiPadding.PaddingTop = UDim.new(0, padding)
        uiPadding.PaddingBottom = UDim.new(0, padding)
        uiPadding.PaddingLeft = UDim.new(0, padding)
        uiPadding.PaddingRight = UDim.new(0, padding)
    else
        uiPadding.PaddingTop = UDim.new(0, padding.Top or 0)
        uiPadding.PaddingBottom = UDim.new(0, padding.Bottom or 0)
        uiPadding.PaddingLeft = UDim.new(0, padding.Left or 0)
        uiPadding.PaddingRight = UDim.new(0, padding.Right or 0)
    end
    uiPadding.Parent = parent
    return uiPadding
end

local function CreateStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Theme.Border
    stroke.Thickness = thickness or 1
    stroke.Parent = parent
    return stroke
end

-- Main Library Functions
function UILibrary.new(config)
    local self = setmetatable({}, UILibrary)
    
    config = config or {}
    self.Title = config.Title or "0verflow Hub"
    self.Size = config.Size or UDim2.new(0, 600, 0, 400)
    self.Position = config.Position or UDim2.new(0.5, -300, 0.5, -200)
    
    self.Tabs = {}
    self.CurrentTab = nil
    
    self:CreateMainFrame()
    self:CreateTopBar()
    self:CreateTabContainer()
    self:CreateContentContainer()
    
    return self
end

function UILibrary:CreateMainFrame()
    -- Create ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "0verflowHub"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Create Main Frame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = self.Size
    self.MainFrame.Position = self.Position
    self.MainFrame.BackgroundColor3 = Theme.Background
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Parent = self.ScreenGui
    
    CreateCorner(self.MainFrame, 12)
    CreateStroke(self.MainFrame, Theme.Primary, 2)
    
    -- Drop Shadow Effect
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.8
    shadow.ZIndex = -1
    shadow.Parent = self.MainFrame
    
    self.ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- Make draggable
    self:MakeDraggable()
end

function UILibrary:CreateTopBar()
    self.TopBar = Instance.new("Frame")
    self.TopBar.Name = "TopBar"
    self.TopBar.Size = UDim2.new(1, 0, 0, 50)
    self.TopBar.Position = UDim2.new(0, 0, 0, 0)
    self.TopBar.BackgroundColor3 = Theme.Primary
    self.TopBar.BorderSizePixel = 0
    self.TopBar.Parent = self.MainFrame
    
    CreateCorner(self.TopBar, 12)
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(0, 200, 1, 0)
    title.Position = UDim2.new(0, 20, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = self.Title
    title.TextColor3 = Theme.Text
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.GothamBold
    title.Parent = self.TopBar
    
    -- Close Button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -40, 0, 10)
    closeButton.BackgroundColor3 = Theme.Error
    closeButton.BorderSizePixel = 0
    closeButton.Text = "×"
    closeButton.TextColor3 = Theme.Text
    closeButton.TextSize = 20
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = self.TopBar
    
    CreateCorner(closeButton, 6)
    
    closeButton.MouseButton1Click:Connect(function()
        self:Close()
    end)
    
    -- Hover effect for close button
    closeButton.MouseEnter:Connect(function()
        CreateTween(closeButton, {BackgroundColor3 = Color3.fromRGB(220, 38, 38)}, AnimationSettings.HoverSpeed):Play()
    end)
    
    closeButton.MouseLeave:Connect(function()
        CreateTween(closeButton, {BackgroundColor3 = Theme.Error}, AnimationSettings.HoverSpeed):Play()
    end)
end

function UILibrary:CreateTabContainer()
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Name = "TabContainer"
    self.TabContainer.Size = UDim2.new(1, -20, 0, 40)
    self.TabContainer.Position = UDim2.new(0, 10, 0, 60)
    self.TabContainer.BackgroundTransparency = 1
    self.TabContainer.Parent = self.MainFrame
    
    self.TabLayout = Instance.new("UIListLayout")
    self.TabLayout.FillDirection = Enum.FillDirection.Horizontal
    self.TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    self.TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    self.TabLayout.Padding = UDim.new(0, 5)
    self.TabLayout.Parent = self.TabContainer
end

function UILibrary:CreateContentContainer()
    self.ContentContainer = Instance.new("Frame")
    self.ContentContainer.Name = "ContentContainer"
    self.ContentContainer.Size = UDim2.new(1, -20, 1, -120)
    self.ContentContainer.Position = UDim2.new(0, 10, 0, 110)
    self.ContentContainer.BackgroundColor3 = Theme.Surface
    self.ContentContainer.BorderSizePixel = 0
    self.ContentContainer.Parent = self.MainFrame
    
    CreateCorner(self.ContentContainer, 8)
    CreateStroke(self.ContentContainer, Theme.Border, 1)
end

function UILibrary:MakeDraggable()
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    self.TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            self.MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

function UILibrary:CreateTab(name)
    local tab = {
        Name = name,
        Button = nil,
        Content = nil,
        Elements = {},
        Library = self
    }
    
    -- Create Tab Button
    tab.Button = Instance.new("TextButton")
    tab.Button.Name = name .. "Tab"
    tab.Button.Size = UDim2.new(0, 120, 1, 0)
    tab.Button.BackgroundColor3 = Theme.Surface
    tab.Button.BorderSizePixel = 0
    tab.Button.Text = name
    tab.Button.TextColor3 = Theme.TextSecondary
    tab.Button.TextSize = 14
    tab.Button.Font = Enum.Font.Gotham
    tab.Button.Parent = self.TabContainer
    
    CreateCorner(tab.Button, 6)
    
    -- Create Tab Content
    tab.Content = Instance.new("ScrollingFrame")
    tab.Content.Name = name .. "Content"
    tab.Content.Size = UDim2.new(1, 0, 1, 0)
    tab.Content.Position = UDim2.new(0, 0, 0, 0)
    tab.Content.BackgroundTransparency = 1
    tab.Content.BorderSizePixel = 0
    tab.Content.ScrollBarThickness = 6
    tab.Content.ScrollBarImageColor3 = Theme.Secondary
    tab.Content.CanvasSize = UDim2.new(0, 0, 0, 0)
    tab.Content.Visible = false
    tab.Content.Parent = self.ContentContainer
    
    CreatePadding(tab.Content, 15)
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.FillDirection = Enum.FillDirection.Vertical
    contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    contentLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout.Parent = tab.Content
    
    -- Auto-resize canvas
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tab.Content.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 30)
    end)
    
    -- Tab Button Click
    tab.Button.MouseButton1Click:Connect(function()
        self:SwitchTab(name)
    end)
    
    -- Tab Button Hover Effects
    tab.Button.MouseEnter:Connect(function()
        if self.CurrentTab ~= name then
            CreateTween(tab.Button, {BackgroundColor3 = Theme.Border}, AnimationSettings.HoverSpeed):Play()
        end
    end)
    
    tab.Button.MouseLeave:Connect(function()
        if self.CurrentTab ~= name then
            CreateTween(tab.Button, {BackgroundColor3 = Theme.Surface}, AnimationSettings.HoverSpeed):Play()
        end
    end)
    
    self.Tabs[name] = tab
    
    -- Switch to first tab automatically
    local tabCount = 0
    for _ in pairs(self.Tabs) do tabCount = tabCount + 1 end
    if tabCount == 1 then
        self:SwitchTab(name)
    end
    
    return tab
end

function UILibrary:SwitchTab(tabName)
    for name, tab in pairs(self.Tabs) do
        if name == tabName then
            -- Activate tab
            tab.Content.Visible = true
            CreateTween(tab.Button, {
                BackgroundColor3 = Theme.Secondary,
                TextColor3 = Theme.Text
            }, AnimationSettings.TabSwitchSpeed):Play()
            self.CurrentTab = name
        else
            -- Deactivate tab
            tab.Content.Visible = false
            CreateTween(tab.Button, {
                BackgroundColor3 = Theme.Surface,
                TextColor3 = Theme.TextSecondary
            }, AnimationSettings.TabSwitchSpeed):Play()
        end
    end
end

function UILibrary:Close()
    CreateTween(self.MainFrame, {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }, 0.3):Play()
    
    wait(0.3)
    self.ScreenGui:Destroy()
end

-- Export the library
return UILibrary
