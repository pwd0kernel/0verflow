local Library = {}
Library.__index = Library

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Professional Dark Theme
local Theme = {
    -- Base colors
    Background = Color3.fromRGB(13, 13, 15),
    Surface = Color3.fromRGB(18, 18, 21),
    SurfaceLight = Color3.fromRGB(24, 24, 28),
    SurfaceBright = Color3.fromRGB(32, 32, 38),
    
    -- Accent colors (subtle purple)
    Primary = Color3.fromRGB(99, 102, 241),
    PrimaryDim = Color3.fromRGB(67, 56, 202),
    PrimaryBright = Color3.fromRGB(129, 140, 248),
    
    -- Text colors
    TextPrimary = Color3.fromRGB(244, 244, 245),
    TextSecondary = Color3.fromRGB(161, 161, 170),
    TextMuted = Color3.fromRGB(113, 113, 122),
    
    -- State colors
    Success = Color3.fromRGB(34, 197, 94),
    Warning = Color3.fromRGB(251, 146, 60),
    Error = Color3.fromRGB(239, 68, 68),
    Info = Color3.fromRGB(59, 130, 246),
    
    -- Border colors
    Border = Color3.fromRGB(39, 39, 42),
    BorderLight = Color3.fromRGB(63, 63, 70),
    
    -- Typography
    Font = Enum.Font.Ubuntu,
    FontMono = Enum.Font.RobotoMono
}

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

-- Main Library
function Library:CreateWindow(config)
    config = config or {}
    local windowName = config.Name or "Interface"
    local windowSize = config.Size or UDim2.new(0, 680, 0, 460)
    local hideKey = config.HideKey or Enum.KeyCode.RightShift
    
    -- Create ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = HttpService:GenerateGUID(false)
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = CoreGui
    
    -- Main Frame with subtle shadow
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.BackgroundColor3 = Theme.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.Position = UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2)
    mainFrame.Size = windowSize
    mainFrame.Parent = screenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 10)
    mainCorner.Parent = mainFrame
    
    -- Subtle border
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Theme.Border
    mainStroke.Thickness = 1
    mainStroke.Transparency = 0.5
    mainStroke.Parent = mainFrame
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.BackgroundColor3 = Theme.Surface
    titleBar.BorderSizePixel = 0
    titleBar.Size = UDim2.new(1, 0, 0, 42)
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = titleBar
    
    local titleFix = Instance.new("Frame")
    titleFix.BackgroundColor3 = Theme.Surface
    titleFix.BorderSizePixel = 0
    titleFix.Position = UDim2.new(0, 0, 0.5, 0)
    titleFix.Size = UDim2.new(1, 0, 0.5, 1)
    titleFix.Parent = titleBar
    
    -- Title text
    local titleText = Instance.new("TextLabel")
    titleText.BackgroundTransparency = 1
    titleText.Position = UDim2.new(0, 16, 0, 0)
    titleText.Size = UDim2.new(0.5, 0, 1, 0)
    titleText.Font = Theme.Font
    titleText.Text = windowName
    titleText.TextColor3 = Theme.TextPrimary
    titleText.TextSize = 15
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar
    
    -- Window controls
    local closeButton = Instance.new("TextButton")
    closeButton.BackgroundColor3 = Theme.SurfaceLight
    closeButton.BackgroundTransparency = 1
    closeButton.Position = UDim2.new(1, -36, 0.5, -12)
    closeButton.Size = UDim2.new(0, 24, 0, 24)
    closeButton.Font = Theme.Font
    closeButton.Text = "×"
    closeButton.TextColor3 = Theme.TextSecondary
    closeButton.TextSize = 18
    closeButton.Parent = titleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeButton
    
    closeButton.MouseEnter:Connect(function()
        CreateTween(closeButton, {
            BackgroundTransparency = 0,
            TextColor3 = Theme.TextPrimary
        }, 0.2)
    end)
    
    closeButton.MouseLeave:Connect(function()
        CreateTween(closeButton, {
            BackgroundTransparency = 1,
            TextColor3 = Theme.TextSecondary
        }, 0.2)
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        CreateTween(mainFrame, {
            Size = UDim2.new(0, windowSize.X.Offset, 0, 0),
            BackgroundTransparency = 1
        }, 0.3)
        task.wait(0.3)
        screenGui:Destroy()
    end)
    
    -- Navigation sidebar
    local sidebar = Instance.new("Frame")
    sidebar.BackgroundColor3 = Theme.Surface
    sidebar.BorderSizePixel = 0
    sidebar.Position = UDim2.new(0, 0, 0, 42)
    sidebar.Size = UDim2.new(0, 180, 1, -42)
    sidebar.Parent = mainFrame
    
    local sidebarCorner = Instance.new("UICorner")
    sidebarCorner.CornerRadius = UDim.new(0, 10)
    sidebarCorner.Parent = sidebar
    
    local sidebarFix = Instance.new("Frame")
    sidebarFix.BackgroundColor3 = Theme.Surface
    sidebarFix.BorderSizePixel = 0
    sidebarFix.Position = UDim2.new(0, 0, 0, -10)
    sidebarFix.Size = UDim2.new(1, 0, 0, 10)
    sidebarFix.Parent = sidebar
    
    local sidebarFix2 = Instance.new("Frame")
    sidebarFix2.BackgroundColor3 = Theme.Surface
    sidebarFix2.BorderSizePixel = 0
    sidebarFix2.Position = UDim2.new(0.8, 0, 0, 0)
    sidebarFix2.Size = UDim2.new(0.2, 0, 1, 0)
    sidebarFix2.Parent = sidebar
    
    -- Tab container
    local tabContainer = Instance.new("ScrollingFrame")
    tabContainer.BackgroundTransparency = 1
    tabContainer.BorderSizePixel = 0
    tabContainer.Position = UDim2.new(0, 0, 0, 0)
    tabContainer.Size = UDim2.new(1, 0, 1, 0)
    tabContainer.ScrollBarThickness = 0
    tabContainer.Parent = sidebar
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 2)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Parent = tabContainer
    
    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingLeft = UDim.new(0, 12)
    tabPadding.PaddingRight = UDim.new(0, 12)
    tabPadding.PaddingTop = UDim.new(0, 12)
    tabPadding.PaddingBottom = UDim.new(0, 12)
    tabPadding.Parent = tabContainer
    
    -- Content area
    local contentArea = Instance.new("Frame")
    contentArea.BackgroundTransparency = 1
    contentArea.Position = UDim2.new(0, 180, 0, 42)
    contentArea.Size = UDim2.new(1, -180, 1, -42)
    contentArea.Parent = mainFrame
    
    AddDraggable(mainFrame, titleBar)
    
    -- Hide/Show
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == hideKey then
            mainFrame.Visible = not mainFrame.Visible
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
        tabButton.BackgroundColor3 = Theme.Surface
        tabButton.BackgroundTransparency = 1
        tabButton.BorderSizePixel = 0
        tabButton.Size = UDim2.new(1, 0, 0, 36)
        tabButton.Font = Theme.Font
        tabButton.Text = "  " .. (icon or "") .. "  " .. name
        tabButton.TextColor3 = Theme.TextSecondary
        tabButton.TextSize = 14
        tabButton.TextXAlignment = Enum.TextXAlignment.Left
        tabButton.AutoButtonColor = false
        tabButton.Parent = tabContainer
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 8)
        tabCorner.Parent = tabButton
        
        -- Tab content
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.Position = UDim2.new(0, 0, 0, 0)
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.ScrollBarThickness = 3
        tabContent.ScrollBarImageColor3 = Theme.Border
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
        
        -- Tab selection
        tabButton.MouseButton1Click:Connect(function()
            if Window.CurrentTab then
                Window.CurrentTab.Button.BackgroundTransparency = 1
                Window.CurrentTab.Button.TextColor3 = Theme.TextSecondary
                Window.CurrentTab.Content.Visible = false
            end
            
            tabButton.BackgroundTransparency = 0.8
            tabButton.BackgroundColor3 = Theme.Primary
            tabButton.TextColor3 = Theme.TextPrimary
            tabContent.Visible = true
            
            Window.CurrentTab = {Button = tabButton, Content = tabContent}
        end)
        
        -- Auto-select first tab
        if #Window.Tabs == 0 then
            tabButton.BackgroundTransparency = 0.8
            tabButton.BackgroundColor3 = Theme.Primary
            tabButton.TextColor3 = Theme.TextPrimary
            tabContent.Visible = true
            Window.CurrentTab = {Button = tabButton, Content = tabContent}
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
    
    -- Open animation
    mainFrame.Size = UDim2.new(0, windowSize.X.Offset, 0, 0)
    mainFrame.ClipsDescendants = true
    CreateTween(mainFrame, {Size = windowSize}, 0.4, Enum.EasingStyle.Quint)
    
    return Window
end

return Library
