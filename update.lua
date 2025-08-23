-- 0verflow Hub UI Library
-- Professional Dark/Cyan Theme with Matrix-inspired elements
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

local function AddDraggable(frame, dragHandle)
    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPos = nil
    
    local function update(input)
        if not dragging then return end
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
    
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
            update(input)
        end
    end)
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
    
    -- Main Frame with glow effect
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.BackgroundColor3 = Theme.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.Position = UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2)
    mainFrame.Size = windowSize
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = mainFrame
    
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
    
    -- Optimized gradient animation
    local gradientConnection
    gradientConnection = RunService.Heartbeat:Connect(function()
        if mainFrame.Parent then
            strokeGradient.Rotation = (strokeGradient.Rotation + 2) % 360
        else
            gradientConnection:Disconnect()
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
    
    -- 0verflow Logo/Icon with glow
    local logoContainer = Instance.new("Frame")
    logoContainer.BackgroundColor3 = Theme.Primary
    logoContainer.BackgroundTransparency = 0.9
    logoContainer.Position = UDim2.new(0, 12, 0.5, -12)
    logoContainer.Size = UDim2.new(0, 24, 0, 24)
    logoContainer.Parent = titleBar
    
    local logoCorner = Instance.new("UICorner")
    logoCorner.CornerRadius = UDim.new(0, 6)
    logoCorner.Parent = logoContainer
    
    local logo = Instance.new("TextLabel")
    logo.BackgroundTransparency = 1
    logo.Size = UDim2.new(1, 0, 1, 0)
    logo.Font = Theme.FontBold
    logo.Text = "0"
    logo.TextColor3 = Theme.Primary
    logo.TextSize = 18
    logo.Parent = logoContainer
    
    -- Title text
    local titleText = Instance.new("TextLabel")
    titleText.BackgroundTransparency = 1
    titleText.Position = UDim2.new(0, 44, 0, 0)
    titleText.Size = UDim2.new(0.5, -44, 1, 0)
    titleText.Font = Theme.FontBold
    titleText.Text = windowName
    titleText.TextColor3 = Theme.TextPrimary
    titleText.TextSize = 16
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar
    
    -- Version badge
    local versionBadge = Instance.new("Frame")
    versionBadge.BackgroundColor3 = Theme.Primary
    versionBadge.BackgroundTransparency = 0.85
    versionBadge.Position = UDim2.new(0, 180, 0.5, -8)
    versionBadge.Size = UDim2.new(0, 40, 0, 16)
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
    versionText.Text = "v2.0"
    versionText.TextColor3 = Theme.Primary
    versionText.TextSize = 10
    versionText.Parent = versionBadge
    
    -- Status indicator (animated dot)
    local statusDot = Instance.new("Frame")
    statusDot.BackgroundColor3 = Theme.Success
    statusDot.Position = UDim2.new(1, -80, 0.5, -4)
    statusDot.Size = UDim2.new(0, 8, 0, 8)
    statusDot.Parent = titleBar
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(1, 0)
    statusCorner.Parent = statusDot
    
    -- Optimized pulse animation
    local pulseConnection
    pulseConnection = task.spawn(function()
        while statusDot.Parent do
            CreateTween(statusDot, {BackgroundTransparency = 0.3}, 1, Enum.EasingStyle.Sine)
            task.wait(1)
            CreateTween(statusDot, {BackgroundTransparency = 0}, 1, Enum.EasingStyle.Sine)
            task.wait(1)
        end
    end)
    
    local statusText = Instance.new("TextLabel")
    statusText.BackgroundTransparency = 1
    statusText.Position = UDim2.new(1, -70, 0.5, -8)
    statusText.Size = UDim2.new(0, 50, 0, 16)
    statusText.Font = Theme.Font
    statusText.Text = "Online"
    statusText.TextColor3 = Theme.TextSecondary
    statusText.TextSize = 11
    statusText.TextXAlignment = Enum.TextXAlignment.Right
    statusText.Parent = titleBar
    
    -- Window controls with hover effects
    local closeButton = Instance.new("TextButton")
    closeButton.BackgroundColor3 = Theme.Error
    closeButton.BackgroundTransparency = 0.8
    closeButton.Position = UDim2.new(1, -36, 0.5, -12)
    closeButton.Size = UDim2.new(0, 24, 0, 24)
    closeButton.Font = Theme.Font
    closeButton.Text = "×"
    closeButton.TextColor3 = Theme.TextPrimary
    closeButton.TextSize = 20
    closeButton.AutoButtonColor = false
    closeButton.Parent = titleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeButton
    
    closeButton.MouseEnter:Connect(function()
        CreateTween(closeButton, {
            BackgroundTransparency = 0.2,
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }, 0.15)
    end)
    
    closeButton.MouseLeave:Connect(function()
        CreateTween(closeButton, {
            BackgroundTransparency = 0.8,
            TextColor3 = Theme.TextPrimary
        }, 0.15)
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        -- Improved glitch effect
        for i = 1, 3 do
            mainFrame.BackgroundTransparency = 0.5
            task.wait(0.05)
            mainFrame.BackgroundTransparency = 0
            task.wait(0.05)
        end
        CreateTween(mainFrame, {
            Size = UDim2.new(0, windowSize.X.Offset, 0, 0),
            BackgroundTransparency = 1
        }, 0.3, Enum.EasingStyle.Back)
        task.wait(0.3)
        if gradientConnection then gradientConnection:Disconnect() end
        if pulseConnection then task.cancel(pulseConnection) end
        screenGui:Destroy()
    end)
    
    -- Navigation sidebar with 0verflow styling
    local sidebar = Instance.new("Frame")
    sidebar.BackgroundColor3 = Theme.Surface
    sidebar.BorderSizePixel = 0
    sidebar.Position = UDim2.new(0, 0, 0, 48)
    sidebar.Size = UDim2.new(0, 190, 1, -48)
    sidebar.Parent = mainFrame
    
    -- Sidebar separator line with glow
    local separator = Instance.new("Frame")
    separator.BackgroundColor3 = Theme.BorderLight
    separator.BackgroundTransparency = 0.7
    separator.Position = UDim2.new(1, -1, 0, 0)
    separator.Size = UDim2.new(0, 1, 1, 0)
    separator.Parent = sidebar
    
    -- Tab container
    local tabContainer = Instance.new("ScrollingFrame")
    tabContainer.BackgroundTransparency = 1
    tabContainer.BorderSizePixel = 0
    tabContainer.Position = UDim2.new(0, 0, 0, 0)
    tabContainer.Size = UDim2.new(1, 0, 1, -30)
    tabContainer.ScrollBarThickness = 2
    tabContainer.ScrollBarImageColor3 = Theme.Primary
    tabContainer.ScrollBarImageTransparency = 0.5
    tabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
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
    
    -- Update canvas size automatically
    tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabContainer.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 24)
    end)
    
    -- Watermark
    local watermark = Instance.new("TextLabel")
    watermark.BackgroundTransparency = 1
    watermark.Position = UDim2.new(0, 0, 1, -24)
    watermark.Size = UDim2.new(1, 0, 0, 20)
    watermark.Font = Theme.FontMono
    watermark.Text = "0VERFLOW HUB"
    watermark.TextColor3 = Theme.TextMuted
    watermark.TextSize = 10
    watermark.TextTransparency = 0.5
    watermark.Parent = sidebar
    
    -- Content area
    local contentArea = Instance.new("Frame")
    contentArea.BackgroundTransparency = 1
    contentArea.Position = UDim2.new(0, 190, 0, 48)
    contentArea.Size = UDim2.new(1, -190, 1, -48)
    contentArea.Parent = mainFrame
    
    AddDraggable(mainFrame, titleBar)
    
    -- Hide/Show functionality
    local hiddenConnection
    hiddenConnection = UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == hideKey then
            mainFrame.Visible = not mainFrame.Visible
            if mainFrame.Visible then
                CreateTween(mainFrame, {BackgroundTransparency = 0}, 0.2)
            end
        end
    end)
    
    local Window = {
        Tabs = {},
        CurrentTab = nil
    }
    
    function Window:CreateTab(name, icon)
        local Tab = {}
        
        -- Tab button
        local tabButton = Instance.new("TextButton")
        tabButton.BackgroundColor3 = Theme.SurfaceLight
        tabButton.BackgroundTransparency = 1
        tabButton.BorderSizePixel = 0
        tabButton.Size = UDim2.new(1, 0, 0, 36)
        tabButton.Font = Theme.Font
        tabButton.Text = ""
        tabButton.AutoButtonColor = false
        tabButton.Parent = tabContainer
        
        local tabText = Instance.new("TextLabel")
        tabText.BackgroundTransparency = 1
        tabText.Position = UDim2.new(0, 8, 0, 0)
        tabText.Size = UDim2.new(1, -8, 1, 0)
        tabText.Font = Theme.Font
        tabText.Text = (icon and icon .. "  " or "") .. name
        tabText.TextColor3 = Theme.TextSecondary
        tabText.TextSize = 14
        tabText.TextXAlignment = Enum.TextXAlignment.Left
        tabText.Parent = tabButton
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 8)
        tabCorner.Parent = tabButton
        
        -- Tab indicator
        local tabIndicator = Instance.new("Frame")
        tabIndicator.BackgroundColor3 = Theme.Primary
        tabIndicator.BackgroundTransparency = 1
        tabIndicator.Position = UDim2.new(0, 0, 0, 0)
        tabIndicator.Size = UDim2.new(0, 3, 1, 0)
        tabIndicator.Parent = tabButton
        
        local indicatorCorner = Instance.new("UICorner")
        indicatorCorner.CornerRadius = UDim.new(0, 2)
        indicatorCorner.Parent = tabIndicator
        
        -- Tab content
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.Position = UDim2.new(0, 0, 0, 0)
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.ScrollBarThickness = 3
        tabContent.ScrollBarImageColor3 = Theme.Primary
        tabContent.ScrollBarImageTransparency = 0.5
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
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
        
        -- Tab hover effect
        tabButton.MouseEnter:Connect(function()
            if Window.CurrentTab and Window.CurrentTab.Button == tabButton then return end
            CreateTween(tabButton, {BackgroundTransparency = 0.9}, 0.2)
        end)
        
        tabButton.MouseLeave:Connect(function()
            if Window.CurrentTab and Window.CurrentTab.Button == tabButton then return end
            CreateTween(tabButton, {BackgroundTransparency = 1}, 0.2)
        end)
        
        -- Tab selection
        tabButton.MouseButton1Click:Connect(function()
            if Window.CurrentTab then
                CreateTween(Window.CurrentTab.Button, {BackgroundTransparency = 1}, 0.2)
                CreateTween(Window.CurrentTab.Button.TabIndicator, {BackgroundTransparency = 1}, 0.2)
                Window.CurrentTab.Button.TabText.TextColor3 = Theme.TextSecondary
                Window.CurrentTab.Content.Visible = false
            end
            
            CreateTween(tabButton, {BackgroundTransparency = 0.85}, 0.2)
            CreateTween(tabIndicator, {BackgroundTransparency = 0}, 0.2)
            tabButton.BackgroundColor3 = Theme.Primary
            tabText.TextColor3 = Theme.TextPrimary
            tabContent.Visible = true
            
            Window.CurrentTab = {
                Button = tabButton, 
                Content = tabContent,
                TabIndicator = tabIndicator,
                TabText = tabText
            }
        end)
        
        -- Auto-select first tab
        if #Window.Tabs == 0 then
            tabButton.BackgroundTransparency = 0.85
            tabButton.BackgroundColor3 = Theme.Primary
            tabIndicator.BackgroundTransparency = 0
            tabText.TextColor3 = Theme.TextPrimary
            tabContent.Visible = true
            Window.CurrentTab = {
                Button = tabButton,
                Content = tabContent,
                TabIndicator = tabIndicator,
                TabText = tabText
            }
        end
        
        -- Tab elements (keeping all existing functions but with improvements)
        function Tab:AddSection(name)
            local section = Instance.new("Frame")
            section.BackgroundTransparency = 1
            section.Size = UDim2.new(1, 0, 0, 24)
            section.Parent = tabContent
            
            local sectionLabel = Instance.new("TextLabel")
            sectionLabel.BackgroundTransparency = 1
            sectionLabel.Size = UDim2.new(1, 0, 1, 0)
            sectionLabel.Font = Theme.FontBold
            sectionLabel.Text = name:upper()
            sectionLabel.TextColor3 = Theme.TextMuted
            sectionLabel.TextSize = 11
            sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            sectionLabel.Parent = section
            
            -- Section divider
            local divider = Instance.new("Frame")
            divider.BackgroundColor3 = Theme.Border
            divider.BackgroundTransparency = 0.7
            divider.Position = UDim2.new(0, 0, 1, -1)
            divider.Size = UDim2.new(1, 0, 0, 1)
            divider.Parent = section
            
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
                CreateTween(button, {BackgroundColor3 = Theme.SurfaceBright}, 0.15)
                CreateTween(buttonStroke, {
                    Color = Theme.Primary,
                    Transparency = 0.5
                }, 0.15)
            end)
            
            button.MouseLeave:Connect(function()
                CreateTween(button, {BackgroundColor3 = Theme.SurfaceLight}, 0.15)
                CreateTween(buttonStroke, {
                    Color = Theme.Border,
                    Transparency = 0.8
                }, 0.15)
            end)
            
            button.MouseButton1Click:Connect(function()
                -- Ripple effect
                local ripple = Instance.new("Frame")
                ripple.BackgroundColor3 = Theme.Primary
                ripple.BackgroundTransparency = 0.6
                ripple.BorderSizePixel = 0
                ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
                ripple.Size = UDim2.new(0, 0, 0, 0)
                ripple.AnchorPoint = Vector2.new(0.5, 0.5)
                ripple.Parent = button
                
                local rippleCorner = Instance.new("UICorner")
                rippleCorner.CornerRadius = UDim.new(0, 8)
                rippleCorner.Parent = ripple
                
                CreateTween(ripple, {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1
                }, 0.4)
                
                task.wait(0.4)
                ripple:Destroy()
                
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
            switch.BackgroundColor3 = default and Theme.Primary or Theme.Border
            switch.Position = UDim2.new(1, -48, 0.5, -10)
            switch.Size = UDim2.new(0, 36, 0, 20)
            switch.Parent = toggleFrame
            
            local switchCorner = Instance.new("UICorner")
            switchCorner.CornerRadius = UDim.new(1, 0)
            switchCorner.Parent = switch
            
            local switchDot = Instance.new("Frame")
            switchDot.BackgroundColor3 = Theme.TextPrimary
            switchDot.Position = default and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
            switchDot.Size = UDim2.new(0, 14, 0, 14)
            switchDot.Parent = switch
            
            local switchDotCorner = Instance.new("UICorner")
            switchDotCorner.CornerRadius = UDim.new(1, 0)
            switchDotCorner.Parent = switchDot
            
            local toggled = default
            
            local function updateToggle()
                if toggled then
                    CreateTween(switch, {BackgroundColor3 = Theme.Primary}, 0.2)
                    CreateTween(switchDot, {Position = UDim2.new(1, -16, 0.5, -7)}, 0.2, Enum.EasingStyle.Quart)
                else
                    CreateTween(switch, {BackgroundColor3 = Theme.Border}, 0.2)
                    CreateTween(switchDot, {Position = UDim2.new(0, 2, 0.5, -7)}, 0.2, Enum.EasingStyle.Quart)
                end
                callback(toggled)
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
            
            detector.MouseEnter:Connect(function()
                CreateTween(toggleStroke, {
                    Color = Theme.Primary,
                    Transparency = 0.5
                }, 0.15)
            end)
            
            detector.MouseLeave:Connect(function()
                CreateTween(toggleStroke, {
                    Color = Theme.Border,
                    Transparency = 0.8
                }, 0.15)
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
            sliderValue.Text = tostring(math.floor(default))
            sliderValue.TextColor3 = Theme.Primary
            sliderValue.TextSize = 14
            sliderValue.TextXAlignment = Enum.TextXAlignment.Right
            sliderValue.Parent = sliderFrame
            
            local sliderBar = Instance.new("TextButton")
            sliderBar.BackgroundColor3 = Theme.Border
            sliderBar.Position = UDim2.new(0, 12, 0, 32)
            sliderBar.Size = UDim2.new(1, -24, 0, 6)
            sliderBar.AutoButtonColor = false
            sliderBar.Text = ""
            sliderBar.Parent = sliderFrame
            
            local sliderBarCorner = Instance.new("UICorner")
            sliderBarCorner.CornerRadius = UDim.new(1, 0)
            sliderBarCorner.Parent = sliderBar
            
            local sliderFill = Instance.new("Frame")
            sliderFill.BackgroundColor3 = Theme.Primary
            sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            sliderFill.BorderSizePixel = 0
            sliderFill.Parent = sliderBar
            
            local sliderFillCorner = Instance.new("UICorner")
            sliderFillCorner.CornerRadius = UDim.new(1, 0)
            sliderFillCorner.Parent = sliderFill
            
            local sliderDot = Instance.new("Frame")
            sliderDot.BackgroundColor3 = Theme.TextPrimary
            sliderDot.Position = UDim2.new((default - min) / (max - min), -6, 0.5, -6)
            sliderDot.Size = UDim2.new(0, 12, 0, 12)
            sliderDot.Parent = sliderBar
            
            local sliderDotCorner = Instance.new("UICorner")
            sliderDotCorner.CornerRadius = UDim.new(1, 0)
            sliderDotCorner.Parent = sliderDot
            
            local dragging = false
            
            local function updateSlider(input)
                local percent = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
                local value = math.floor(min + (max - min) * percent)
                
                CreateTween(sliderFill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.05)
                CreateTween(sliderDot, {Position = UDim2.new(percent, -6, 0.5, -6)}, 0.05)
                sliderValue.Text = tostring(value)
                callback(value)
            end
            
            sliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    updateSlider(input)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(input)
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
                    Transparency = 0.3
                }, 0.15)
                CreateTween(textboxFrame, {
                    BackgroundColor3 = Theme.SurfaceBright
                }, 0.15)
            end)
            
            textbox.FocusLost:Connect(function(enterPressed)
                CreateTween(textboxStroke, {
                    Color = Theme.Border,
                    Transparency = 0.8
                }, 0.15)
                CreateTween(textboxFrame, {
                    BackgroundColor3 = Theme.SurfaceLight
                }, 0.15)
                callback(textbox.Text, enterPressed)
            end)
            
            return textboxFrame
        end
        
        table.insert(Window.Tabs, Tab)
        return Tab
    end
    
    -- Opening animation
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    CreateTween(mainFrame, {
        Size = windowSize,
        Position = UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2)
    }, 0.5, Enum.EasingStyle.Back)
    
    return Window
end

return Library
