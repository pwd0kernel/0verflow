-- Modern Dark Purple UI Library for Roblox
local Library = {}
Library.__index = Library

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Theme Configuration
local Theme = {
    Background = Color3.fromRGB(20, 20, 25),
    SecondaryBackground = Color3.fromRGB(25, 25, 32),
    TertiaryBackground = Color3.fromRGB(30, 30, 38),
    AccentColor = Color3.fromRGB(138, 43, 226), -- Dark Purple
    AccentColorDark = Color3.fromRGB(106, 13, 173),
    AccentColorLight = Color3.fromRGB(155, 89, 238),
    TextColor = Color3.fromRGB(220, 220, 220),
    SecondaryText = Color3.fromRGB(170, 170, 170),
    BorderColor = Color3.fromRGB(50, 50, 60),
    SuccessColor = Color3.fromRGB(67, 181, 129),
    ErrorColor = Color3.fromRGB(240, 71, 71),
    WarningColor = Color3.fromRGB(255, 170, 0),
    Font = Enum.Font.Gotham,
    FontBold = Enum.Font.GothamBold
}

-- Utility Functions
local function CreateTween(instance, properties, duration, easingStyle)
    easingStyle = easingStyle or Enum.EasingStyle.Quart
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(duration, easingStyle, Enum.EasingDirection.Out),
        properties
    )
    tween:Play()
    return tween
end

local function AddDraggable(frame, dragHandle)
    local dragging, dragInput, dragStart, startPos
    local dragSpeed = 0.25
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            CreateTween(frame, {BackgroundTransparency = frame.BackgroundTransparency - 0.1}, 0.2)
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    CreateTween(frame, {BackgroundTransparency = 0}, 0.2)
                end
            end)
        end
    end)
    
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            local targetPos = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
            CreateTween(frame, {Position = targetPos}, dragSpeed, Enum.EasingStyle.Exponential)
        end
    end)
end

local function CreateRipple(button, x, y)
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.Parent = button
    ripple.BackgroundColor3 = Theme.AccentColorLight
    ripple.BackgroundTransparency = 0.6
    ripple.BorderSizePixel = 0
    ripple.Position = UDim2.new(0, x or button.AbsoluteSize.X/2, 0, y or button.AbsoluteSize.Y/2)
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.ZIndex = button.ZIndex + 1
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple
    
    CreateTween(ripple, {
        Size = UDim2.new(0, button.AbsoluteSize.X * 2, 0, button.AbsoluteSize.X * 2),
        BackgroundTransparency = 1
    }, 0.6, Enum.EasingStyle.Quad)
    
    game:GetService("Debris"):AddItem(ripple, 0.6)
end

local function CreateNotification(text, duration, notifType)
    duration = duration or 3
    notifType = notifType or "Info"
    
    local colors = {
        Info = Theme.AccentColor,
        Success = Theme.SuccessColor,
        Error = Theme.ErrorColor,
        Warning = Theme.WarningColor
    }
    
    local notif = Instance.new("Frame")
    notif.Name = "Notification"
    notif.BackgroundColor3 = Theme.SecondaryBackground
    notif.BorderSizePixel = 0
    notif.Position = UDim2.new(1, 20, 1, -80)
    notif.Size = UDim2.new(0, 300, 0, 60)
    notif.ZIndex = 100
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 10)
    notifCorner.Parent = notif
    
    local notifStroke = Instance.new("UIStroke")
    notifStroke.Color = colors[notifType]
    notifStroke.Thickness = 2
    notifStroke.Parent = notif
    
    local notifBar = Instance.new("Frame")
    notifBar.BackgroundColor3 = colors[notifType]
    notifBar.BorderSizePixel = 0
    notifBar.Size = UDim2.new(0, 4, 1, 0)
    notifBar.Parent = notif
    
    local notifBarCorner = Instance.new("UICorner")
    notifBarCorner.CornerRadius = UDim.new(0, 10)
    notifBarCorner.Parent = notifBar
    
    local notifText = Instance.new("TextLabel")
    notifText.BackgroundTransparency = 1
    notifText.Position = UDim2.new(0, 15, 0, 0)
    notifText.Size = UDim2.new(1, -20, 1, 0)
    notifText.Font = Theme.Font
    notifText.Text = text
    notifText.TextColor3 = Theme.TextColor
    notifText.TextSize = 14
    notifText.TextWrapped = true
    notifText.TextXAlignment = Enum.TextXAlignment.Left
    notifText.Parent = notif
    
    CreateTween(notif, {Position = UDim2.new(1, -320, 1, -80)}, 0.5, Enum.EasingStyle.Back)
    
    task.wait(duration)
    CreateTween(notif, {Position = UDim2.new(1, 20, 1, -80)}, 0.5, Enum.EasingStyle.Back)
    task.wait(0.5)
    notif:Destroy()
end

-- Main Library
function Library:CreateWindow(config)
    config = config or {}
    local windowName = config.Name or "UI Library"
    local windowSize = config.Size or UDim2.new(0, 550, 0, 400)
    local hideKey = config.HideKey or Enum.KeyCode.RightShift
    
    -- Create ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = HttpService:GenerateGUID(false)
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = CoreGui
    
    -- Notification Container
    local notifContainer = Instance.new("Frame")
    notifContainer.BackgroundTransparency = 1
    notifContainer.Size = UDim2.new(1, 0, 1, 0)
    notifContainer.ZIndex = 99
    notifContainer.Parent = screenGui
    
    -- Main Frame
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
    
    -- Gradient Background
    local gradientFrame = Instance.new("Frame")
    gradientFrame.Name = "Gradient"
    gradientFrame.BackgroundColor3 = Theme.AccentColor
    gradientFrame.BackgroundTransparency = 0.95
    gradientFrame.BorderSizePixel = 0
    gradientFrame.Size = UDim2.new(1, 0, 1, 0)
    gradientFrame.ZIndex = 0
    gradientFrame.Parent = mainFrame
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 43, 226)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(106, 13, 173))
    }
    gradient.Rotation = 45
    gradient.Parent = gradientFrame
    
    local gradientCorner = Instance.new("UICorner")
    gradientCorner.CornerRadius = UDim.new(0, 12)
    gradientCorner.Parent = gradientFrame
    
    -- Shadow
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0, -20, 0, -20)
    shadow.Size = UDim2.new(1, 40, 1, 40)
    shadow.ZIndex = -1
    shadow.Image = "rbxassetid://5554236805"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.4
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    shadow.Parent = mainFrame
    
    -- Border Glow
    local borderGlow = Instance.new("UIStroke")
    borderGlow.Color = Theme.AccentColor
    borderGlow.Thickness = 1
    borderGlow.Transparency = 0.8
    borderGlow.Parent = mainFrame
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.BackgroundColor3 = Theme.SecondaryBackground
    titleBar.BackgroundTransparency = 0.2
    titleBar.BorderSizePixel = 0
    titleBar.Size = UDim2.new(1, 0, 0, 35)
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleBar
    
    local titleFix = Instance.new("Frame")
    titleFix.Name = "Fix"
    titleFix.BackgroundColor3 = Theme.SecondaryBackground
    titleFix.BackgroundTransparency = 0.2
    titleFix.BorderSizePixel = 0
    titleFix.Position = UDim2.new(0, 0, 0.5, 0)
    titleFix.Size = UDim2.new(1, 0, 0.5, 0)
    titleFix.Parent = titleBar
    
    local titleText = Instance.new("TextLabel")
    titleText.Name = "Title"
    titleText.BackgroundTransparency = 1
    titleText.Position = UDim2.new(0, 12, 0, 0)
    titleText.Size = UDim2.new(1, -100, 1, 0)
    titleText.Font = Theme.FontBold
    titleText.Text = windowName
    titleText.TextColor3 = Theme.TextColor
    titleText.TextSize = 16
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar
    
    -- Window Controls
    local controlsFrame = Instance.new("Frame")
    controlsFrame.BackgroundTransparency = 1
    controlsFrame.Position = UDim2.new(1, -85, 0, 0)
    controlsFrame.Size = UDim2.new(0, 85, 1, 0)
    controlsFrame.Parent = titleBar
    
    local controlsLayout = Instance.new("UIListLayout")
    controlsLayout.FillDirection = Enum.FillDirection.Horizontal
    controlsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    controlsLayout.Padding = UDim.new(0, 8)
    controlsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    controlsLayout.Parent = controlsFrame
    
    -- Minimize Button
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Name = "MinimizeButton"
    minimizeButton.BackgroundColor3 = Theme.WarningColor
    minimizeButton.BackgroundTransparency = 1
    minimizeButton.Size = UDim2.new(0, 16, 0, 16)
    minimizeButton.Position = UDim2.new(0, 0, 0.5, -8)
    minimizeButton.Font = Theme.Font
    minimizeButton.Text = "—"
    minimizeButton.TextColor3 = Theme.TextColor
    minimizeButton.TextSize = 16
    minimizeButton.Parent = controlsFrame
    
    local minimizeCorner = Instance.new("UICorner")
    minimizeCorner.CornerRadius = UDim.new(0, 4)
    minimizeCorner.Parent = minimizeButton
    
    local minimized = false
    local originalSize = windowSize
    
    minimizeButton.MouseEnter:Connect(function()
        CreateTween(minimizeButton, {BackgroundTransparency = 0}, 0.2)
    end)
    
    minimizeButton.MouseLeave:Connect(function()
        CreateTween(minimizeButton, {BackgroundTransparency = 1}, 0.2)
    end)
    
    minimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            CreateTween(mainFrame, {Size = UDim2.new(originalSize.X, 0, 35)}, 0.3)
        else
            CreateTween(mainFrame, {Size = originalSize}, 0.3)
        end
    end)
    
    -- Close Button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.BackgroundColor3 = Theme.ErrorColor
    closeButton.BackgroundTransparency = 1
    closeButton.Size = UDim2.new(0, 16, 0, 16)
    closeButton.Position = UDim2.new(0, 0, 0.5, -8)
    closeButton.Font = Theme.Font
    closeButton.Text = "×"
    closeButton.TextColor3 = Theme.TextColor
    closeButton.TextSize = 20
    closeButton.Parent = controlsFrame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 4)
    closeCorner.Parent = closeButton
    
    closeButton.MouseEnter:Connect(function()
        CreateTween(closeButton, {BackgroundTransparency = 0}, 0.2)
    end)
    
    closeButton.MouseLeave:Connect(function()
        CreateTween(closeButton, {BackgroundTransparency = 1}, 0.2)
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        CreateTween(mainFrame, {
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }, 0.3, Enum.EasingStyle.Back)
        CreateTween(shadow, {ImageTransparency = 1}, 0.3)
        task.wait(0.3)
        screenGui:Destroy()
    end)
    
    -- Tab Container
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.BackgroundColor3 = Theme.TertiaryBackground
    tabContainer.BackgroundTransparency = 0.3
    tabContainer.BorderSizePixel = 0
    tabContainer.Position = UDim2.new(0, 0, 0, 35)
    tabContainer.Size = UDim2.new(0, 140, 1, -35)
    tabContainer.Parent = mainFrame
    
    local tabScrolling = Instance.new("ScrollingFrame")
    tabScrolling.BackgroundTransparency = 1
    tabScrolling.BorderSizePixel = 0
    tabScrolling.Size = UDim2.new(1, 0, 1, 0)
    tabScrolling.ScrollBarThickness = 2
    tabScrolling.ScrollBarImageColor3 = Theme.AccentColor
    tabScrolling.Parent = tabContainer
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 5)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Parent = tabScrolling
    
    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingLeft = UDim.new(0, 10)
    tabPadding.PaddingRight = UDim.new(0, 10)
    tabPadding.PaddingTop = UDim.new(0, 10)
    tabPadding.Parent = tabScrolling
    
    tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabScrolling.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Content Container
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.BackgroundTransparency = 1
    contentContainer.Position = UDim2.new(0, 150, 0, 45)
    contentContainer.Size = UDim2.new(1, -160, 1, -55)
    contentContainer.Parent = mainFrame
    
    -- Hide/Show with key
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == hideKey then
            mainFrame.Visible = not mainFrame.Visible
            if mainFrame.Visible then
                mainFrame.Size = UDim2.new(0, 0, 0, 0)
                CreateTween(mainFrame, {Size = originalSize}, 0.3, Enum.EasingStyle.Back)
            end
        end
    end)
    
    AddDraggable(mainFrame, titleBar)
    
    local Window = {
        Tabs = {},
        CurrentTab = nil,
        GUI = screenGui,
        Notify = function(self, text, duration, notifType)
            task.spawn(function()
                CreateNotification(text, duration, notifType)
            end)
        end
    }
    
    function Window:CreateTab(tabName, tabIcon)
        local Tab = {}
        Tab.Elements = {}
        
        -- Tab Button
        local tabButton = Instance.new("TextButton")
        tabButton.Name = tabName
        tabButton.BackgroundColor3 = Theme.SecondaryBackground
        tabButton.BackgroundTransparency = 0.5
        tabButton.BorderSizePixel = 0
        tabButton.Size = UDim2.new(1, 0, 0, 35)
        tabButton.Font = Theme.Font
        tabButton.Text = (tabIcon and tabIcon .. "  " or "") .. tabName
        tabButton.TextColor3 = Theme.SecondaryText
        tabButton.TextSize = 14
        tabButton.AutoButtonColor = false
        tabButton.Parent = tabScrolling
        
        local tabButtonCorner = Instance.new("UICorner")
        tabButtonCorner.CornerRadius = UDim.new(0, 8)
        tabButtonCorner.Parent = tabButton
        
        local tabIndicator = Instance.new("Frame")
        tabIndicator.Name = "Indicator"
        tabIndicator.BackgroundColor3 = Theme.AccentColor
        tabIndicator.BorderSizePixel = 0
        tabIndicator.Position = UDim2.new(0, 0, 0, 0)
        tabIndicator.Size = UDim2.new(0, 3, 1, 0)
        tabIndicator.Visible = false
        tabIndicator.Parent = tabButton
        
        local indicatorCorner = Instance.new("UICorner")
        indicatorCorner.CornerRadius = UDim.new(0, 8)
        indicatorCorner.Parent = tabIndicator
        
        -- Tab Content
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = tabName .. "Content"
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.Position = UDim2.new(0, 0, 0, 0)
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.ScrollBarThickness = 4
        tabContent.ScrollBarImageColor3 = Theme.AccentColor
        tabContent.ScrollBarImageTransparency = 0.5
        tabContent.Visible = false
        tabContent.Parent = contentContainer
        
        local contentLayout = Instance.new("UIListLayout")
        contentLayout.Padding = UDim.new(0, 10)
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Parent = tabContent
        
        local contentPadding = Instance.new("UIPadding")
        contentPadding.PaddingLeft = UDim.new(0, 10)
        contentPadding.PaddingRight = UDim.new(0, 10)
        contentPadding.PaddingTop = UDim.new(0, 10)
        contentPadding.Parent = tabContent
        
        -- Auto-resize scrolling frame
        contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
        end)
        
        -- Tab hover effect
        tabButton.MouseEnter:Connect(function()
            if Window.CurrentTab and Window.CurrentTab.Button == tabButton then return end
            CreateTween(tabButton, {BackgroundTransparency = 0.3}, 0.2)
        end)
        
        tabButton.MouseLeave:Connect(function()
            if Window.CurrentTab and Window.CurrentTab.Button == tabButton then return end
            CreateTween(tabButton, {BackgroundTransparency = 0.5}, 0.2)
        end)
        
        -- Tab Selection
        tabButton.MouseButton1Click:Connect(function()
            if Window.CurrentTab then
                Window.CurrentTab.Button.BackgroundTransparency = 0.5
                Window.CurrentTab.Button.TextColor3 = Theme.SecondaryText
                Window.CurrentTab.Content.Visible = false
                Window.CurrentTab.Indicator.Visible = false
                CreateTween(Window.CurrentTab.Button, {BackgroundColor3 = Theme.SecondaryBackground}, 0.2)
            end
            
            tabButton.BackgroundTransparency = 0
            tabButton.TextColor3 = Theme.TextColor
            tabContent.Visible = true
            tabIndicator.Visible = true
            
            CreateTween(tabButton, {BackgroundColor3 = Theme.AccentColorDark}, 0.2)
            CreateRipple(tabButton)
            
            Window.CurrentTab = {Button = tabButton, Content = tabContent, Indicator = tabIndicator}
        end)
        
        -- Select first tab by default
        if #Window.Tabs == 0 then
            tabButton.BackgroundTransparency = 0
            tabButton.BackgroundColor3 = Theme.AccentColorDark
            tabButton.TextColor3 = Theme.TextColor
            tabContent.Visible = true
            tabIndicator.Visible = true
            Window.CurrentTab = {Button = tabButton, Content = tabContent, Indicator = tabIndicator}
        end
        
        -- Tab Elements with enhanced visuals
        function Tab:AddButton(config)
            config = config or {}
            local buttonText = config.Name or "Button"
            local callback = config.Callback or function() end
            local description = config.Description
            
            local buttonFrame = Instance.new("Frame")
            buttonFrame.Name = "ButtonFrame"
            buttonFrame.BackgroundColor3 = Theme.SecondaryBackground
            buttonFrame.BackgroundTransparency = 0.3
            buttonFrame.BorderSizePixel = 0
            buttonFrame.Size = UDim2.new(1, 0, 0, description and 50 or 38)
            buttonFrame.Parent = tabContent
            
            local buttonFrameCorner = Instance.new("UICorner")
            buttonFrameCorner.CornerRadius = UDim.new(0, 8)
            buttonFrameCorner.Parent = buttonFrame
            
            local buttonStroke = Instance.new("UIStroke")
            buttonStroke.Color = Theme.BorderColor
            buttonStroke.Thickness = 1
            buttonStroke.Transparency = 0.7
            buttonStroke.Parent = buttonFrame
            
            local button = Instance.new("TextButton")
            button.Name = "Button"
            button.BackgroundTransparency = 1
            button.Size = UDim2.new(1, 0, description and 0.6 or 1, 0)
            button.Font = Theme.Font
            button.Text = buttonText
            button.TextColor3 = Theme.TextColor
            button.TextSize = 14
            button.Parent = buttonFrame
            
            if description then
                local descLabel = Instance.new("TextLabel")
                descLabel.BackgroundTransparency = 1
                descLabel.Position = UDim2.new(0, 0, 0.6, 0)
                descLabel.Size = UDim2.new(1, 0, 0.4, 0)
                descLabel.Font = Theme.Font
                descLabel.Text = description
                descLabel.TextColor3 = Theme.SecondaryText
                descLabel.TextSize = 12
                descLabel.Parent = buttonFrame
            end
            
            button.MouseEnter:Connect(function()
                CreateTween(buttonFrame, {BackgroundColor3 = Theme.TertiaryBackground}, 0.2)
                CreateTween(buttonStroke, {Color = Theme.AccentColor}, 0.2)
            end)
            
            button.MouseLeave:Connect(function()
                CreateTween(buttonFrame, {BackgroundColor3 = Theme.SecondaryBackground}, 0.2)
                CreateTween(buttonStroke, {Color = Theme.BorderColor}, 0.2)
            end)
            
            button.MouseButton1Click:Connect(function()
                CreateRipple(buttonFrame)
                task.spawn(callback)
            end)
            
            return button
        end
        
        function Tab:AddToggle(config)
            config = config or {}
            local toggleText = config.Name or "Toggle"
            local default = config.Default or false
            local callback = config.Callback or function() end
            local description = config.Description
            
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Name = "ToggleFrame"
            toggleFrame.BackgroundColor3 = Theme.SecondaryBackground
            toggleFrame.BackgroundTransparency = 0.3
            toggleFrame.BorderSizePixel = 0
            toggleFrame.Size = UDim2.new(1, 0, 0, description and 50 or 38)
            toggleFrame.Parent = tabContent
            
            local toggleFrameCorner = Instance.new("UICorner")
            toggleFrameCorner.CornerRadius = UDim.new(0, 8)
            toggleFrameCorner.Parent = toggleFrame
            
            local toggleStroke = Instance.new("UIStroke")
            toggleStroke.Color = Theme.BorderColor
            toggleStroke.Thickness = 1
            toggleStroke.Transparency = 0.7
            toggleStroke.Parent = toggleFrame
            
            local toggleLabel = Instance.new("TextLabel")
            toggleLabel.Name = "Label"
            toggleLabel.BackgroundTransparency = 1
            toggleLabel.Position = UDim2.new(0, 12, 0, description and 5 or 0)
            toggleLabel.Size = UDim2.new(1, -60, description and 0.5 or 1, 0)
            toggleLabel.Font = Theme.Font
            toggleLabel.Text = toggleText
            toggleLabel.TextColor3 = Theme.TextColor
            toggleLabel.TextSize = 14
            toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            toggleLabel.Parent = toggleFrame
            
            if description then
                local descLabel = Instance.new("TextLabel")
                descLabel.BackgroundTransparency = 1
                descLabel.Position = UDim2.new(0, 12, 0.5, 0)
                descLabel.Size = UDim2.new(1, -60, 0.5, 0)
                descLabel.Font = Theme.Font
                descLabel.Text = description
                descLabel.TextColor3 = Theme.SecondaryText
                descLabel.TextSize = 12
                descLabel.TextXAlignment = Enum.TextXAlignment.Left
                descLabel.Parent = toggleFrame
            end
            
            local toggleButton = Instance.new("Frame")
            toggleButton.Name = "ToggleButton"
            toggleButton.BackgroundColor3 = Theme.BorderColor
            toggleButton.Position = UDim2.new(1, -50, 0.5, -10)
            toggleButton.Size = UDim2.new(0, 40, 0, 20)
            toggleButton.Parent = toggleFrame
            
            local toggleButtonCorner = Instance.new("UICorner")
            toggleButtonCorner.CornerRadius = UDim.new(1, 0)
            toggleButtonCorner.Parent = toggleButton
            
            local toggleCircle = Instance.new("Frame")
            toggleCircle.Name = "Circle"
            toggleCircle.BackgroundColor3 = Theme.TextColor
            toggleCircle.Position = UDim2.new(0, 2, 0.5, -8)
            toggleCircle.Size = UDim2.new(0, 16, 0, 16)
            toggleCircle.Parent = toggleButton
            
            local toggleCircleCorner = Instance.new("UICorner")
            toggleCircleCorner.CornerRadius = UDim.new(1, 0)
            toggleCircleCorner.Parent = toggleCircle
            
            local toggleShadow = Instance.new("ImageLabel")
            toggleShadow.BackgroundTransparency = 1
            toggleShadow.Position = UDim2.new(0, -2, 0, -2)
            toggleShadow.Size = UDim2.new(1, 4, 1, 4)
            toggleShadow.Image = "rbxassetid://5554236805"
            toggleShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
            toggleShadow.ImageTransparency = 0.7
            toggleShadow.ScaleType = Enum.ScaleType.Slice
            toggleShadow.SliceCenter = Rect.new(23, 23, 277, 277)
            toggleShadow.Parent = toggleCircle
            
            local toggled = default
            
            local function updateToggle()
                if toggled then
                    CreateTween(toggleButton, {BackgroundColor3 = Theme.AccentColor}, 0.3)
                    CreateTween(toggleCircle, {Position = UDim2.new(1, -18, 0.5, -8)}, 0.3, Enum.EasingStyle.Back)
                    CreateTween(toggleStroke, {Color = Theme.AccentColor}, 0.3)
                else
                    CreateTween(toggleButton, {BackgroundColor3 = Theme.BorderColor}, 0.3)
                    CreateTween(toggleCircle, {Position = UDim2.new(0, 2, 0.5, -8)}, 0.3, Enum.EasingStyle.Back)
                    CreateTween(toggleStroke, {Color = Theme.BorderColor}, 0.3)
                end
                task.spawn(function() callback(toggled) end)
            end
            
            if default then
                toggleButton.BackgroundColor3 = Theme.AccentColor
                toggleCircle.Position = UDim2.new(1, -18, 0.5, -8)
                toggleStroke.Color = Theme.AccentColor
                task.spawn(function() callback(true) end)
            end
            
            local toggleDetector = Instance.new("TextButton")
            toggleDetector.BackgroundTransparency = 1
            toggleDetector.Size = UDim2.new(1, 0, 1, 0)
            toggleDetector.Text = ""
            toggleDetector.Parent = toggleFrame
            
            toggleDetector.MouseButton1Click:Connect(function()
                toggled = not toggled
                updateToggle()
            end)
            
            return toggleFrame
        end
        
        -- Continue with other enhanced elements...
        
        table.insert(Window.Tabs, Tab)
        return Tab
    end
    
    -- Animate window opening
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    CreateTween(mainFrame, {
        Size = windowSize,
        Position = UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2)
    }, 0.5, Enum.EasingStyle.Back)
    
    -- Gradient animation
    task.spawn(function()
        while screenGui.Parent do
            CreateTween(gradient, {Rotation = gradient.Rotation + 360}, 10, Enum.EasingStyle.Linear)
            task.wait(10)
        end
    end)
    
    return Window
end

return Library
