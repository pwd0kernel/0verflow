-- 0verflow Hub UI Library v2.0
local Library = {}
Library.__index = Library

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 0verflow Hub Theme - Dark with Cyan accents
local Theme = {
    -- Base colors (Deep dark)
    Background = Color3.fromRGB(8, 8, 10),
    Surface = Color3.fromRGB(12, 12, 15),
    SurfaceLight = Color3.fromRGB(18, 18, 22),
    SurfaceBright = Color3.fromRGB(24, 24, 30),
    
    -- 0verflow Signature Colors (Cyan/Blue gradient)
    Primary = Color3.fromRGB(0, 220, 255),      -- Bright cyan
    PrimaryDim = Color3.fromRGB(0, 150, 200),   -- Darker cyan
    PrimaryBright = Color3.fromRGB(100, 240, 255), -- Light cyan
    Accent = Color3.fromRGB(0, 255, 200),       -- Teal accent
    
    -- Text colors
    TextPrimary = Color3.fromRGB(245, 245, 250),
    TextSecondary = Color3.fromRGB(140, 160, 180),
    TextMuted = Color3.fromRGB(80, 90, 100),
    TextAccent = Color3.fromRGB(0, 220, 255),
    
    -- State colors
    Success = Color3.fromRGB(0, 255, 150),
    Warning = Color3.fromRGB(255, 200, 0),
    Error = Color3.fromRGB(255, 50, 80),
    Info = Color3.fromRGB(0, 180, 255),
    
    -- Border colors with glow effect
    Border = Color3.fromRGB(30, 35, 40),
    BorderLight = Color3.fromRGB(0, 100, 120),
    GlowColor = Color3.fromRGB(0, 220, 255),
    
    -- Typography
    Font = Enum.Font.Gotham,
    FontBold = Enum.Font.GothamBold,
    FontMono = Enum.Font.Code
}

-- 0verflow Hub ASCII Art
local ASCII_LOGO = [[
 ___            __ _               
/ _ \__   _____ _ _| |_ _____ __ __
| | | \ \ / / _ \ '__| _/ _ \ \ V  V /
| |_| |\ V /  __/ |  | ||  __/  \_/\_/ 
 \___/  \_/ \___|_|  |_| \___|        
                HUB v2.0
]]

-- Utility Functions
local function CreateTween(instance, properties, duration, easingStyle)
    easingStyle = easingStyle or Enum.EasingStyle.Quint
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(duration, easingStyle, Enum.EasingDirection.Out),
        properties
    )
    tween:Play()
    return tween
end

local function AddRippleEffect(button)
    button.ClipsDescendants = true
    
    button.MouseButton1Click:Connect(function()
        local ripple = Instance.new("Frame")
        ripple.BackgroundColor3 = Theme.Primary
        ripple.BackgroundTransparency = 0.6
        ripple.BorderSizePixel = 0
        ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
        ripple.Size = UDim2.new(0, 0, 0, 0)
        ripple.Parent = button
        
        local rippleCorner = Instance.new("UICorner")
        rippleCorner.CornerRadius = UDim.new(1, 0)
        rippleCorner.Parent = ripple
        
        CreateTween(ripple, {
            Size = UDim2.new(2, 0, 2, 0),
            BackgroundTransparency = 1
        }, 0.5)
        
        game:GetService("Debris"):AddItem(ripple, 0.5)
    end)
end

local function AddDraggable(frame, dragHandle)
    local dragging, dragInput, dragStart, startPos
    
    dragHandle.InputBegan:Connect(function(input)
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
    
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Notification System
local function CreateNotification(text, duration, notifType)
    duration = duration or 3
    notifType = notifType or "Info"
    
    local notif = Instance.new("Frame")
    notif.BackgroundColor3 = Theme.Surface
    notif.BorderSizePixel = 0
    notif.Position = UDim2.new(1, 0, 1, -100)
    notif.Size = UDim2.new(0, 250, 0, 60)
    notif.Parent = game:GetService("CoreGui"):FindFirstChild("0verflowHub_Notifications") or Instance.new("ScreenGui", CoreGui)
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 8)
    notifCorner.Parent = notif
    
    local notifStroke = Instance.new("UIStroke")
    notifStroke.Color = Theme[notifType] or Theme.Info
    notifStroke.Thickness = 2
    notifStroke.Transparency = 0
    notifStroke.Parent = notif
    
    local notifText = Instance.new("TextLabel")
    notifText.BackgroundTransparency = 1
    notifText.Position = UDim2.new(0, 12, 0, 0)
    notifText.Size = UDim2.new(1, -24, 1, 0)
    notifText.Font = Theme.Font
    notifText.Text = text
    notifText.TextColor3 = Theme.TextPrimary
    notifText.TextSize = 14
    notifText.TextWrapped = true
    notifText.Parent = notif
    
    -- Slide in
    CreateTween(notif, {Position = UDim2.new(1, -260, 1, -100)}, 0.3)
    
    -- Fade out and remove
    task.wait(duration)
    CreateTween(notif, {Position = UDim2.new(1, 0, 1, -100)}, 0.3)
    task.wait(0.3)
    notif:Destroy()
end

-- Main Library
function Library:CreateWindow(config)
    config = config or {}
    local windowName = config.Name or "0verflow Hub"
    local windowSize = config.Size or UDim2.new(0, 720, 0, 500)
    local hideKey = config.HideKey or Enum.KeyCode.RightShift
    
    -- Create ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "0verflowHub_" .. HttpService:GenerateGUID(false)
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = CoreGui
    
    -- Shadow/Blur Background
    local shadowFrame = Instance.new("Frame")
    shadowFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadowFrame.BackgroundTransparency = 0.5
    shadowFrame.BorderSizePixel = 0
    shadowFrame.Position = UDim2.new(0, -50, 0, -50)
    shadowFrame.Size = UDim2.new(1, 100, 1, 100)
    shadowFrame.Visible = false
    shadowFrame.Parent = screenGui
    
    -- Main Frame with glow effect
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.BackgroundColor3 = Theme.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.Position = UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2)
    mainFrame.Size = windowSize
    mainFrame.Parent = screenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = mainFrame
    
    -- Drop shadow
    local shadow = Instance.new("ImageLabel")
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0, -20, 0, -20)
    shadow.Size = UDim2.new(1, 40, 1, 40)
    shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(20, 20, 20, 20)
    shadow.Parent = mainFrame
    
    -- Animated glow border
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Theme.GlowColor
    mainStroke.Thickness = 2
    mainStroke.Transparency = 0.3
    mainStroke.Parent = mainFrame
    
    -- Gradient for border
    local strokeGradient = Instance.new("UIGradient")
    strokeGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Theme.Primary),
        ColorSequenceKeypoint.new(0.5, Theme.Accent),
        ColorSequenceKeypoint.new(1, Theme.Primary)
    }
    strokeGradient.Parent = mainStroke
    
    -- Animate gradient with pulse effect
    task.spawn(function()
        local time = 0
        while mainFrame.Parent do
            strokeGradient.Rotation = (strokeGradient.Rotation + 1) % 360
            mainStroke.Transparency = 0.3 + math.sin(time) * 0.1
            time = time + 0.05
            task.wait(0.03)
        end
    end)
    
    -- Title Bar with 0verflow branding
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.BackgroundColor3 = Theme.Surface
    titleBar.BorderSizePixel = 0
    titleBar.Size = UDim2.new(1, 0, 0, 48)
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleBar
    
    local titleFix = Instance.new("Frame")
    titleFix.BackgroundColor3 = Theme.Surface
    titleFix.BorderSizePixel = 0
    titleFix.Position = UDim2.new(0, 0, 0.5, 0)
    titleFix.Size = UDim2.new(1, 0, 0.5, 1)
    titleFix.Parent = titleBar
    
    -- Title gradient overlay
    local titleGradient = Instance.new("UIGradient")
    titleGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
    }
    titleGradient.Rotation = 90
    titleGradient.Parent = titleBar
    
    -- 0verflow Logo with animation
    local logoContainer = Instance.new("Frame")
    logoContainer.BackgroundColor3 = Theme.Primary
    logoContainer.BackgroundTransparency = 0.9
    logoContainer.Position = UDim2.new(0, 12, 0.5, -14)
    logoContainer.Size = UDim2.new(0, 28, 0, 28)
    logoContainer.Parent = titleBar
    
    local logoCorner = Instance.new("UICorner")
    logoCorner.CornerRadius = UDim.new(0, 6)
    logoCorner.Parent = logoContainer
    
    local logo = Instance.new("TextLabel")
    logo.BackgroundTransparency = 1
    logo.Position = UDim2.new(0.5, 0, 0.5, 0)
    logo.Size = UDim2.new(0, 20, 0, 20)
    logo.AnchorPoint = Vector2.new(0.5, 0.5)
    logo.Font = Theme.FontBold
    logo.Text = "0"
    logo.TextColor3 = Theme.Primary
    logo.TextSize = 18
    logo.Parent = logoContainer
    
    -- Logo rotation animation
    task.spawn(function()
        while logo.Parent do
            CreateTween(logo, {Rotation = 360}, 10, Enum.EasingStyle.Linear)
            task.wait(10)
            logo.Rotation = 0
        end
    end)
    
    -- Title text with gradient
    local titleText = Instance.new("TextLabel")
    titleText.BackgroundTransparency = 1
    titleText.Position = UDim2.new(0, 48, 0, 0)
    titleText.Size = UDim2.new(0.5, 0, 1, 0)
    titleText.Font = Theme.FontBold
    titleText.Text = windowName
    titleText.TextColor3 = Theme.TextPrimary
    titleText.TextSize = 16
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar
    
    -- Version badge with glow
    local versionBadge = Instance.new("Frame")
    versionBadge.BackgroundColor3 = Theme.Primary
    versionBadge.BackgroundTransparency = 0.8
    versionBadge.Position = UDim2.new(0, 180, 0.5, -8)
    versionBadge.Size = UDim2.new(0, 50, 0, 16)
    versionBadge.Parent = titleBar
    
    local badgeCorner = Instance.new("UICorner")
    badgeCorner.CornerRadius = UDim.new(0, 4)
    badgeCorner.Parent = versionBadge
    
    local badgeStroke = Instance.new("UIStroke")
    badgeStroke.Color = Theme.Primary
    badgeStroke.Thickness = 1
    badgeStroke.Transparency = 0.5
    badgeStroke.Parent = versionBadge
    
    local versionText = Instance.new("TextLabel")
    versionText.BackgroundTransparency = 1
    versionText.Size = UDim2.new(1, 0, 1, 0)
    versionText.Font = Theme.FontMono
    versionText.Text = "v2.0.0"
    versionText.TextColor3 = Theme.Primary
    versionText.TextSize = 10
    versionText.Parent = versionBadge
    
    -- Status indicator with connection info
    local statusContainer = Instance.new("Frame")
    statusContainer.BackgroundTransparency = 1
    statusContainer.Position = UDim2.new(1, -100, 0.5, -8)
    statusContainer.Size = UDim2.new(0, 90, 0, 16)
    statusContainer.Parent = titleBar
    
    local statusDot = Instance.new("Frame")
    statusDot.BackgroundColor3 = Theme.Success
    statusDot.Position = UDim2.new(0, 0, 0.5, -4)
    statusDot.Size = UDim2.new(0, 8, 0, 8)
    statusDot.Parent = statusContainer
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(1, 0)
    statusCorner.Parent = statusDot
    
    -- Glow effect for status
    local statusGlow = Instance.new("ImageLabel")
    statusGlow.BackgroundTransparency = 1
    statusGlow.Position = UDim2.new(0.5, -12, 0.5, -12)
    statusGlow.Size = UDim2.new(0, 24, 0, 24)
    statusGlow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    statusGlow.ImageColor3 = Theme.Success
    statusGlow.ImageTransparency = 0.8
    statusGlow.Parent = statusDot
    
    -- Pulse animation for status
    task.spawn(function()
        while statusDot.Parent do
            CreateTween(statusGlow, {ImageTransparency = 0.5, Size = UDim2.new(0, 30, 0, 30)}, 1)
            task.wait(1)
            CreateTween(statusGlow, {ImageTransparency = 0.9, Size = UDim2.new(0, 24, 0, 24)}, 1)
            task.wait(1)
        end
    end)
    
    local statusText = Instance.new("TextLabel")
    statusText.BackgroundTransparency = 1
    statusText.Position = UDim2.new(0, 14, 0, 0)
    statusText.Size = UDim2.new(1, -14, 1, 0)
    statusText.Font = Theme.Font
    statusText.Text = "Connected"
    statusText.TextColor3 = Theme.TextSecondary
    statusText.TextSize = 11
    statusText.TextXAlignment = Enum.TextXAlignment.Left
    statusText.Parent = statusContainer
    
    -- Window controls
    local controlsContainer = Instance.new("Frame")
    controlsContainer.BackgroundTransparency = 1
    controlsContainer.Position = UDim2.new(1, -36, 0.5, -12)
    controlsContainer.Size = UDim2.new(0, 24, 0, 24)
    controlsContainer.Parent = titleBar
    
    local closeButton = Instance.new("TextButton")
    closeButton.BackgroundColor3 = Theme.Error
    closeButton.BackgroundTransparency = 0.8
    closeButton.Size = UDim2.new(1, 0, 1, 0)
    closeButton.Font = Theme.Font
    closeButton.Text = "×"
    closeButton.TextColor3 = Theme.TextPrimary
    closeButton.TextSize = 18
    closeButton.Parent = controlsContainer
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeButton
    
    closeButton.MouseEnter:Connect(function()
        CreateTween(closeButton, {
            BackgroundTransparency = 0.2,
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }, 0.2)
    end)
    
    closeButton.MouseLeave:Connect(function()
        CreateTween(closeButton, {
            BackgroundTransparency = 0.8,
            TextColor3 = Theme.TextPrimary
        }, 0.2)
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        -- Matrix-style close animation
        for i = 1, 5 do
            mainFrame.BackgroundTransparency = i * 0.2
            for _, v in pairs(mainFrame:GetDescendants()) do
                if v:IsA("TextLabel") then
                    v.TextTransparency = i * 0.2
                elseif v:IsA("Frame") then
                    v.BackgroundTransparency = math.min(1, v.BackgroundTransparency + 0.2)
                end
            end
            task.wait(0.05)
        end
        screenGui:Destroy()
    end)
    
    -- Navigation sidebar
    local sidebar = Instance.new("Frame")
    sidebar.BackgroundColor3 = Theme.Surface
    sidebar.BorderSizePixel = 0
    sidebar.Position = UDim2.new(0, 0, 0, 48)
    sidebar.Size = UDim2.new(0, 190, 1, -48)
    sidebar.Parent = mainFrame
    
    -- Sidebar accent line
    local accentLine = Instance.new("Frame")
    accentLine.BackgroundColor3 = Theme.Primary
    accentLine.BorderSizePixel = 0
    accentLine.Position = UDim2.new(0, 0, 0, 0)
    accentLine.Size = UDim2.new(0, 2, 1, 0)
    accentLine.Parent = sidebar
    
    local accentGradient = Instance.new("UIGradient")
    accentGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Theme.Primary),
        ColorSequenceKeypoint.new(0.5, Theme.Accent),
        ColorSequenceKeypoint.new(1, Theme.Primary)
    }
    accentGradient.Rotation = 90
    accentGradient.Parent = accentLine
    
    -- Tab container
    local tabContainer = Instance.new("ScrollingFrame")
    tabContainer.BackgroundTransparency = 1
    tabContainer.BorderSizePixel = 0
    tabContainer.Position = UDim2.new(0, 0, 0, 0)
    tabContainer.Size = UDim2.new(1, 0, 1, -30)
    tabContainer.ScrollBarThickness = 3
    tabContainer.ScrollBarImageColor3 = Theme.Primary
    tabContainer.ScrollBarImageTransparency = 0.5
    tabContainer.Parent = sidebar
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 4)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Parent = tabContainer
    
    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingLeft = UDim.new(0, 12)
    tabPadding.PaddingRight = UDim.new(0, 12)
    tabPadding.PaddingTop = UDim.new(0, 12)
    tabPadding.PaddingBottom = UDim.new(0, 12)
    tabPadding.Parent = tabContainer
    
    -- Footer watermark
    local footer = Instance.new("Frame")
    footer.BackgroundColor3 = Theme.SurfaceLight
    footer.BackgroundTransparency = 0.5
    footer.Position = UDim2.new(0, 0, 1, -30)
    footer.Size = UDim2.new(1, 0, 0, 30)
    footer.Parent = sidebar
    
    local watermark = Instance.new("TextLabel")
    watermark.BackgroundTransparency = 1
    watermark.Size = UDim2.new(1, 0, 1, 0)
    watermark.Font = Theme.FontMono
    watermark.Text = "0VERFLOW © 2025"
    watermark.TextColor3 = Theme.TextMuted
    watermark.TextSize = 9
    watermark.Parent = footer
    
    -- Content area
    local contentArea = Instance.new("Frame")
    contentArea.BackgroundTransparency = 1
    contentArea.Position = UDim2.new(0, 190, 0, 48)
    contentArea.Size = UDim2.new(1, -190, 1, -48)
    contentArea.Parent = mainFrame
    
    AddDraggable(mainFrame, titleBar)
    
    -- Hide/Show with animation
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == hideKey then
            if mainFrame.Visible then
                CreateTween(mainFrame, {Size = UDim2.new(0, windowSize.X.Offset, 0, 0)}, 0.3)
                task.wait(0.3)
                mainFrame.Visible = false
            else
                mainFrame.Visible = true
                mainFrame.Size = UDim2.new(0, windowSize.X.Offset, 0, 0)
                CreateTween(mainFrame, {Size = windowSize}, 0.3)
            end
        end
    end)
    
    local Window = {
        Tabs = {},
        CurrentTab = nil
    }
    
    function Window:Notify(text, duration, notifType)
        CreateNotification(text, duration, notifType)
    end
    
    function Window:CreateTab(name, icon)
        local Tab = {}
        
        -- Tab button with hover effect
        local tabButton = Instance.new("TextButton")
        tabButton.BackgroundColor3 = Theme.Surface
        tabButton.BackgroundTransparency = 1
        tabButton.BorderSizePixel = 0
        tabButton.Size = UDim2.new(1, 0, 0, 36)
        tabButton.Font = Theme.Font
        tabButton.Text = ""
        tabButton.AutoButtonColor = false
        tabButton.Parent = tabContainer
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 8)
        tabCorner.Parent = tabButton
        
        -- Tab icon
        local tabIcon = Instance.new("TextLabel")
        tabIcon.BackgroundTransparency = 1
        tabIcon.Position = UDim2.new(0, 8, 0.5, -8)
        tabIcon.Size = UDim2.new(0, 16, 0, 16)
        tabIcon.Font = Theme.Font
        tabIcon.Text = icon or "📁"
        tabIcon.TextColor3 = Theme.TextSecondary
        tabIcon.TextSize = 14
        tabIcon.Parent = tabButton
        
        -- Tab name
        local tabName = Instance.new("TextLabel")
        tabName.BackgroundTransparency = 1
        tabName.Position = UDim2.new(0, 32, 0.5, -8)
        tabName.Size = UDim2.new(1, -40, 0, 16)
        tabName.Font = Theme.Font
        tabName.Text = name
        tabName.TextColor3 = Theme.TextSecondary
        tabName.TextSize = 14
        tabName.TextXAlignment = Enum.TextXAlignment.Left
        tabName.Parent = tabButton
        
        -- Selection indicator
        local indicator = Instance.new("Frame")
        indicator.BackgroundColor3 = Theme.Primary
        indicator.BorderSizePixel = 0
        indicator.Position = UDim2.new(0, 0, 0.5, -8)
        indicator.Size = UDim2.new(0, 2, 0, 16)
        indicator.Visible = false
        indicator.Parent = tabButton
        
        local indicatorCorner = Instance.new("UICorner")
        indicatorCorner.CornerRadius = UDim.new(1, 0)
        indicatorCorner.Parent = indicator
        
        -- Tab content
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.Position = UDim2.new(0, 0, 0, 0)
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.ScrollBarThickness = 3
        tabContent.ScrollBarImageColor3 = Theme.Primary
        tabContent.ScrollBarImageTransparency = 0.5
        tabContent.Visible = false
        tabContent.Parent = contentArea
        
        local contentLayout = Instance.new("UIListLayout")
        contentLayout.Padding = UDim.new(0, 12)
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Parent = tabContent
        
        local contentPadding = Instance.new("UIPadding")
        contentPadding.PaddingLeft = UDim.new(0, 24)
        contentPadding.PaddingRight = UDim.new(0, 24)
        contentPadding.PaddingTop = UDim.new(0, 24)
        contentPadding.PaddingBottom = UDim.new(0, 24)
        contentPadding.Parent = tabContent
        
        contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 48)
        end)
        
        -- Tab selection with animation
        tabButton.MouseButton1Click:Connect(function()
            if Window.CurrentTab then
                Window.CurrentTab.Button.BackgroundTransparency = 1
                Window.CurrentTab.Icon.TextColor3 = Theme.TextSecondary
                Window.CurrentTab.Name.TextColor3 = Theme.TextSecondary
                Window.CurrentTab.Indicator.Visible = false
                Window.CurrentTab.Content.Visible = false
            end
            
            CreateTween(tabButton, {BackgroundTransparency = 0.9}, 0.2)
            tabButton.BackgroundColor3 = Theme.Primary
            tabIcon.TextColor3 = Theme.Primary
            tabName.TextColor3 = Theme.TextPrimary
            indicator.Visible = true
            tabContent.Visible = true
            
            Window.CurrentTab = {
                Button = tabButton,
                Icon = tabIcon,
                Name = tabName,
                Indicator = indicator,
                Content = tabContent
            }
        end)
        
        -- Hover effects
        tabButton.MouseEnter:Connect(function()
            if Window.CurrentTab and Window.CurrentTab.Button == tabButton then return end
            CreateTween(tabButton, {BackgroundTransparency = 0.95}, 0.2)
            tabButton.BackgroundColor3 = Theme.SurfaceLight
        end)
        
        tabButton.MouseLeave:Connect(function()
            if Window.CurrentTab and Window.CurrentTab.Button == tabButton then return end
            CreateTween(tabButton, {BackgroundTransparency = 1}, 0.2)
        end)
        
        -- Auto-select first tab
        if #Window.Tabs == 0 then
            tabButton:GetPropertyChangedSignal("Parent"):Connect(function()
                task.wait()
                tabButton.MouseButton1Click:Fire()
            end)
        end
        
        -- Tab elements
        function Tab:AddSection(name)
            local section = Instance.new("Frame")
            section.BackgroundTransparency = 1
            section.Size = UDim2.new(1, 0, 0, 24)
            section.Parent = tabContent
            
            local sectionLabel = Instance.new("TextLabel")
            sectionLabel.BackgroundTransparency = 1
            sectionLabel.Size = UDim2.new(1, 0, 1, 0)
            sectionLabel.Font = Theme.Font
            sectionLabel.Text = name:upper()
            sectionLabel.TextColor3 = Theme.TextMuted
            sectionLabel.TextSize = 12
            sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            sectionLabel.Parent = section
            
            return section
        end
        
        function Tab:AddButton(config)
            config = config or {}
            local name = config.Name or "Button"
            local callback = config.Callback or function() end
            
            local button = Instance.new("TextButton")
            button.BackgroundColor3 = Theme.SurfaceLight
            button.BorderSizePixel = 0
            button.Size = UDim2.new(1, 0, 0, 42)
            button.Font = Theme.Font
            button.Text = name
            button.TextColor3 = Theme.TextPrimary
            button.TextSize = 14
            button.AutoButtonColor = false
            button.Parent = tabContent
            
            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(0, 8)
            buttonCorner.Parent = button
            
            local buttonStroke = Instance.new("UIStroke")
            buttonStroke.Color = Theme.Border
            buttonStroke.Thickness = 1
            buttonStroke.Transparency = 0.8
            buttonStroke.Parent = button
            
            button.MouseEnter:Connect(function()
                CreateTween(button, {BackgroundColor3 = Theme.SurfaceBright}, 0.2)
                CreateTween(buttonStroke, {Transparency = 0.6}, 0.2)
            end)
            
            button.MouseLeave:Connect(function()
                CreateTween(button, {BackgroundColor3 = Theme.SurfaceLight}, 0.2)
                CreateTween(buttonStroke, {Transparency = 0.8}, 0.2)
            end)
            
            button.MouseButton1Click:Connect(function()
                -- Click effect
                local clickEffect = Instance.new("Frame")
                clickEffect.BackgroundColor3 = Theme.Primary
                clickEffect.BackgroundTransparency = 0.7
                clickEffect.BorderSizePixel = 0
                clickEffect.Size = UDim2.new(1, 0, 1, 0)
                clickEffect.Parent = button
                
                local effectCorner = Instance.new("UICorner")
                effectCorner.CornerRadius = UDim.new(0, 8)
                effectCorner.Parent = clickEffect
                
                CreateTween(clickEffect, {BackgroundTransparency = 1}, 0.3)
                game:GetService("Debris"):AddItem(clickEffect, 0.3)
                
                task.spawn(callback)
            end)
            
            return button
        end
        
        function Tab:AddToggle(config)
            config = config or {}
            local name = config.Name or "Toggle"
            local default = config.Default or false
            local callback = config.Callback or function() end
            
            local toggleFrame = Instance.new("Frame")
            toggleFrame.BackgroundColor3 = Theme.SurfaceLight
            toggleFrame.BorderSizePixel = 0
            toggleFrame.Size = UDim2.new(1, 0, 0, 42)
            toggleFrame.Parent = tabContent
            
            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(0, 8)
            toggleCorner.Parent = toggleFrame
            
            local toggleStroke = Instance.new("UIStroke")
            toggleStroke.Color = Theme.Border
            toggleStroke.Thickness = 1
            toggleStroke.Transparency = 0.8
            toggleStroke.Parent = toggleFrame
            
            local toggleLabel = Instance.new("TextLabel")
            toggleLabel.BackgroundTransparency = 1
            toggleLabel.Position = UDim2.new(0, 12, 0, 0)
            toggleLabel.Size = UDim2.new(1, -60, 1, 0)
            toggleLabel.Font = Theme.Font
            toggleLabel.Text = name
            toggleLabel.TextColor3 = Theme.TextPrimary
            toggleLabel.TextSize = 14
            toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            toggleLabel.Parent = toggleFrame
            
            local switch = Instance.new("Frame")
            switch.BackgroundColor3 = Theme.Border
            switch.Position = UDim2.new(1, -48, 0.5, -10)
            switch.Size = UDim2.new(0, 36, 0, 20)
            switch.Parent = toggleFrame
            
            local switchCorner = Instance.new("UICorner")
            switchCorner.CornerRadius = UDim.new(1, 0)
            switchCorner.Parent = switch
            
            local switchDot = Instance.new("Frame")
            switchDot.BackgroundColor3 = Theme.TextPrimary
            switchDot.Position = UDim2.new(0, 2, 0.5, -7)
            switchDot.Size = UDim2.new(0, 14, 0, 14)
            switchDot.Parent = switch
            
            local switchDotCorner = Instance.new("UICorner")
            switchDotCorner.CornerRadius = UDim.new(1, 0)
            switchDotCorner.Parent = switchDot
            
            local toggled = default
            
            local function updateToggle()
                if toggled then
                    CreateTween(switch, {BackgroundColor3 = Theme.Primary}, 0.2)
                    CreateTween(switchDot, {Position = UDim2.new(1, -16, 0.5, -7)}, 0.2)
                else
                    CreateTween(switch, {BackgroundColor3 = Theme.Border}, 0.2)
                    CreateTween(switchDot, {Position = UDim2.new(0, 2, 0.5, -7)}, 0.2)
                end
                callback(toggled)
            end
            
            if default then
                switch.BackgroundColor3 = Theme.Primary
                switchDot.Position = UDim2.new(1, -16, 0.5, -7)
            end
            
            local detector = Instance.new("TextButton")
            detector.BackgroundTransparency = 1
            detector.Size = UDim2.new(1, 0, 1, 0)
            detector.Text = ""
            detector.Parent = toggleFrame
            
            detector.MouseButton1Click:Connect(function()
                toggled = not toggled
                updateToggle()
            end)
            
            return toggleFrame
        end
        
        function Tab:AddSlider(config)
            config = config or {}
            local name = config.Name or "Slider"
            local min = config.Min or 0
            local max = config.Max or 100
            local default = config.Default or min
            local callback = config.Callback or function() end
            
            local sliderFrame = Instance.new("Frame")
            sliderFrame.BackgroundColor3 = Theme.SurfaceLight
            sliderFrame.BorderSizePixel = 0
            sliderFrame.Size = UDim2.new(1, 0, 0, 56)
            sliderFrame.Parent = tabContent
            
            local sliderCorner = Instance.new("UICorner")
            sliderCorner.CornerRadius = UDim.new(0, 8)
            sliderCorner.Parent = sliderFrame
            
            local sliderStroke = Instance.new("UIStroke")
            sliderStroke.Color = Theme.Border
            sliderStroke.Thickness = 1
            sliderStroke.Transparency = 0.8
            sliderStroke.Parent = sliderFrame
            
            local sliderLabel = Instance.new("TextLabel")
            sliderLabel.BackgroundTransparency = 1
            sliderLabel.Position = UDim2.new(0, 12, 0, 8)
            sliderLabel.Size = UDim2.new(0.7, -12, 0, 20)
            sliderLabel.Font = Theme.Font
            sliderLabel.Text = name
            sliderLabel.TextColor3 = Theme.TextPrimary
            sliderLabel.TextSize = 14
            sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            sliderLabel.Parent = sliderFrame
            
            local sliderValue = Instance.new("TextLabel")
            sliderValue.BackgroundTransparency = 1
            sliderValue.Position = UDim2.new(0.7, 0, 0, 8)
            sliderValue.Size = UDim2.new(0.3, -12, 0, 20)
            sliderValue.Font = Theme.FontMono
            sliderValue.Text = tostring(default)
            sliderValue.TextColor3 = Theme.Primary
            sliderValue.TextSize = 14
            sliderValue.TextXAlignment = Enum.TextXAlignment.Right
            sliderValue.Parent = sliderFrame
            
            local sliderBar = Instance.new("Frame")
            sliderBar.BackgroundColor3 = Theme.Border
            sliderBar.Position = UDim2.new(0, 12, 0, 32)
            sliderBar.Size = UDim2.new(1, -24, 0, 4)
            sliderBar.Parent = sliderFrame
            
            local sliderBarCorner = Instance.new("UICorner")
            sliderBarCorner.CornerRadius = UDim.new(1, 0)
            sliderBarCorner.Parent = sliderBar
            
            local sliderFill = Instance.new("Frame")
            sliderFill.BackgroundColor3 = Theme.Primary
            sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            sliderFill.Parent = sliderBar
            
            local sliderFillCorner = Instance.new("UICorner")
            sliderFillCorner.CornerRadius = UDim.new(1, 0)
            sliderFillCorner.Parent = sliderFill
            
            local dragging = false
            
            sliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local percent = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
                    local value = math.floor(min + (max - min) * percent)
                    
                    sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                    sliderValue.Text = tostring(value)
                    callback(value)
                end
            end)
            
            return sliderFrame
        end
        
        function Tab:AddTextbox(config)
            config = config or {}
            local name = config.Name or "Textbox"
            local placeholder = config.Placeholder or "Enter text..."
            local callback = config.Callback or function() end
            
            local textboxFrame = Instance.new("Frame")
            textboxFrame.BackgroundColor3 = Theme.SurfaceLight
            textboxFrame.BorderSizePixel = 0
            textboxFrame.Size = UDim2.new(1, 0, 0, 42)
            textboxFrame.Parent = tabContent
            
            local textboxCorner = Instance.new("UICorner")
            textboxCorner.CornerRadius = UDim.new(0, 8)
            textboxCorner.Parent = textboxFrame
            
            local textboxStroke = Instance.new("UIStroke")
            textboxStroke.Color = Theme.Border
            textboxStroke.Thickness = 1
            textboxStroke.Transparency = 0.8
            textboxStroke.Parent = textboxFrame
            
            local textbox = Instance.new("TextBox")
            textbox.BackgroundTransparency = 1
            textbox.Position = UDim2.new(0, 12, 0, 0)
            textbox.Size = UDim2.new(1, -24, 1, 0)
            textbox.Font = Theme.Font
            textbox.PlaceholderText = placeholder
            textbox.PlaceholderColor3 = Theme.TextMuted
            textbox.Text = ""
            textbox.TextColor3 = Theme.TextPrimary
            textbox.TextSize = 14
            textbox.TextXAlignment = Enum.TextXAlignment.Left
            textbox.ClearTextOnFocus = false
            textbox.Parent = textboxFrame
            
            textbox.Focused:Connect(function()
                CreateTween(textboxStroke, {
                    Color = Theme.Primary,
                    Transparency = 0
                }, 0.2)
            end)
            
            textbox.FocusLost:Connect(function(enterPressed)
                CreateTween(textboxStroke, {
                    Color = Theme.Border,
                    Transparency = 0.8
                }, 0.2)
                callback(textbox.Text, enterPressed)
            end)
            
            return textboxFrame
        end
        
        table.insert(Window.Tabs, Tab)
        return Tab
    end
    
    -- Opening animation
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.ClipsDescendants = true
    CreateTween(mainFrame, {Size = windowSize}, 0.5, Enum.EasingStyle.Back)
    
    -- Show welcome notification
    Window:Notify("Welcome to 0verflow Hub v2.0", 3, "Success")
    
    return Window
end

return Library
