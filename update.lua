
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
    TextColor = Color3.fromRGB(220, 220, 220),
    SecondaryText = Color3.fromRGB(170, 170, 170),
    BorderColor = Color3.fromRGB(50, 50, 60),
    SuccessColor = Color3.fromRGB(67, 181, 129),
    ErrorColor = Color3.fromRGB(240, 71, 71),
    Font = Enum.Font.Gotham,
    FontBold = Enum.Font.GothamBold
}

-- Utility Functions
local function CreateTween(instance, properties, duration, easingStyle)
    easingStyle = easingStyle or Enum.EasingStyle.Quad
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

local function CreateRipple(button)
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.Parent = button
    ripple.BackgroundColor3 = Theme.AccentColor
    ripple.BackgroundTransparency = 0.7
    ripple.BorderSizePixel = 0
    ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
    ripple.Size = UDim2.new(0, 0, 0, 0)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple
    
    CreateTween(ripple, {
        Size = UDim2.new(2, 0, 2, 0),
        BackgroundTransparency = 1
    }, 0.5)
    
    game:GetService("Debris"):AddItem(ripple, 0.5)
end

-- Main Library
function Library:CreateWindow(config)
    config = config or {}
    local windowName = config.Name or "UI Library"
    local windowSize = config.Size or UDim2.new(0, 550, 0, 400)
    
    -- Create ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = HttpService:GenerateGUID(false)
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = CoreGui
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.BackgroundColor3 = Theme.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.Position = UDim2.new(0.5, -275, 0.5, -200)
    mainFrame.Size = windowSize
    mainFrame.Parent = screenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = mainFrame
    
    -- Shadow
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0, -20, 0, -20)
    shadow.Size = UDim2.new(1, 40, 1, 40)
    shadow.ZIndex = -1
    shadow.Image = "rbxassetid://5554236805"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    shadow.Parent = mainFrame
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.BackgroundColor3 = Theme.SecondaryBackground
    titleBar.BorderSizePixel = 0
    titleBar.Size = UDim2.new(1, 0, 0, 35)
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleBar
    
    local titleFix = Instance.new("Frame")
    titleFix.Name = "Fix"
    titleFix.BackgroundColor3 = Theme.SecondaryBackground
    titleFix.BorderSizePixel = 0
    titleFix.Position = UDim2.new(0, 0, 0.5, 0)
    titleFix.Size = UDim2.new(1, 0, 0.5, 0)
    titleFix.Parent = titleBar
    
    local titleText = Instance.new("TextLabel")
    titleText.Name = "Title"
    titleText.BackgroundTransparency = 1
    titleText.Position = UDim2.new(0, 12, 0, 0)
    titleText.Size = UDim2.new(1, -40, 1, 0)
    titleText.Font = Theme.FontBold
    titleText.Text = windowName
    titleText.TextColor3 = Theme.TextColor
    titleText.TextSize = 16
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar
    
    -- Close Button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.BackgroundColor3 = Theme.ErrorColor
    closeButton.BackgroundTransparency = 1
    closeButton.Position = UDim2.new(1, -30, 0.5, -8)
    closeButton.Size = UDim2.new(0, 16, 0, 16)
    closeButton.Font = Theme.Font
    closeButton.Text = "×"
    closeButton.TextColor3 = Theme.TextColor
    closeButton.TextSize = 20
    closeButton.Parent = titleBar
    
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
        CreateTween(mainFrame, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, 0.3)
        wait(0.3)
        screenGui:Destroy()
    end)
    
    -- Tab Container
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.BackgroundColor3 = Theme.TertiaryBackground
    tabContainer.BorderSizePixel = 0
    tabContainer.Position = UDim2.new(0, 0, 0, 35)
    tabContainer.Size = UDim2.new(0, 140, 1, -35)
    tabContainer.Parent = mainFrame
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 5)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Parent = tabContainer
    
    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingLeft = UDim.new(0, 10)
    tabPadding.PaddingRight = UDim.new(0, 10)
    tabPadding.PaddingTop = UDim.new(0, 10)
    tabPadding.Parent = tabContainer
    
    -- Content Container
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.BackgroundTransparency = 1
    contentContainer.Position = UDim2.new(0, 150, 0, 45)
    contentContainer.Size = UDim2.new(1, -160, 1, -55)
    contentContainer.Parent = mainFrame
    
    AddDraggable(mainFrame, titleBar)
    
    local Window = {}
    Window.Tabs = {}
    Window.CurrentTab = nil
    
    function Window:CreateTab(tabName)
        local Tab = {}
        Tab.Elements = {}
        
        -- Tab Button
        local tabButton = Instance.new("TextButton")
        tabButton.Name = tabName
        tabButton.BackgroundColor3 = Theme.SecondaryBackground
        tabButton.BorderSizePixel = 0
        tabButton.Size = UDim2.new(1, 0, 0, 35)
        tabButton.Font = Theme.Font
        tabButton.Text = tabName
        tabButton.TextColor3 = Theme.SecondaryText
        tabButton.TextSize = 14
        tabButton.AutoButtonColor = false
        tabButton.Parent = tabContainer
        
        local tabButtonCorner = Instance.new("UICorner")
        tabButtonCorner.CornerRadius = UDim.new(0, 8)
        tabButtonCorner.Parent = tabButton
        
        -- Tab Content
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = tabName .. "Content"
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.Position = UDim2.new(0, 0, 0, 0)
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.ScrollBarThickness = 4
        tabContent.ScrollBarImageColor3 = Theme.AccentColor
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
        
        -- Tab Selection
        tabButton.MouseButton1Click:Connect(function()
            if Window.CurrentTab then
                Window.CurrentTab.Button.BackgroundColor3 = Theme.SecondaryBackground
                Window.CurrentTab.Button.TextColor3 = Theme.SecondaryText
                Window.CurrentTab.Content.Visible = false
            end
            
            tabButton.BackgroundColor3 = Theme.AccentColor
            tabButton.TextColor3 = Theme.TextColor
            tabContent.Visible = true
            
            Window.CurrentTab = {Button = tabButton, Content = tabContent}
            CreateRipple(tabButton)
        end)
        
        -- Select first tab by default
        if #Window.Tabs == 0 then
            tabButton.BackgroundColor3 = Theme.AccentColor
            tabButton.TextColor3 = Theme.TextColor
            tabContent.Visible = true
            Window.CurrentTab = {Button = tabButton, Content = tabContent}
        end
        
        -- Tab Elements
        function Tab:AddButton(config)
            config = config or {}
            local buttonText = config.Name or "Button"
            local callback = config.Callback or function() end
            
            local buttonFrame = Instance.new("Frame")
            buttonFrame.Name = "ButtonFrame"
            buttonFrame.BackgroundColor3 = Theme.SecondaryBackground
            buttonFrame.BorderSizePixel = 0
            buttonFrame.Size = UDim2.new(1, 0, 0, 38)
            buttonFrame.Parent = tabContent
            
            local buttonFrameCorner = Instance.new("UICorner")
            buttonFrameCorner.CornerRadius = UDim.new(0, 8)
            buttonFrameCorner.Parent = buttonFrame
            
            local button = Instance.new("TextButton")
            button.Name = "Button"
            button.BackgroundTransparency = 1
            button.Size = UDim2.new(1, 0, 1, 0)
            button.Font = Theme.Font
            button.Text = buttonText
            button.TextColor3 = Theme.TextColor
            button.TextSize = 14
            button.Parent = buttonFrame
            
            button.MouseEnter:Connect(function()
                CreateTween(buttonFrame, {BackgroundColor3 = Theme.TertiaryBackground}, 0.2)
            end)
            
            button.MouseLeave:Connect(function()
                CreateTween(buttonFrame, {BackgroundColor3 = Theme.SecondaryBackground}, 0.2)
            end)
            
            button.MouseButton1Click:Connect(function()
                CreateRipple(buttonFrame)
                callback()
            end)
            
            return button
        end
        
        function Tab:AddToggle(config)
            config = config or {}
            local toggleText = config.Name or "Toggle"
            local default = config.Default or false
            local callback = config.Callback or function() end
            
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Name = "ToggleFrame"
            toggleFrame.BackgroundColor3 = Theme.SecondaryBackground
            toggleFrame.BorderSizePixel = 0
            toggleFrame.Size = UDim2.new(1, 0, 0, 38)
            toggleFrame.Parent = tabContent
            
            local toggleFrameCorner = Instance.new("UICorner")
            toggleFrameCorner.CornerRadius = UDim.new(0, 8)
            toggleFrameCorner.Parent = toggleFrame
            
            local toggleLabel = Instance.new("TextLabel")
            toggleLabel.Name = "Label"
            toggleLabel.BackgroundTransparency = 1
            toggleLabel.Position = UDim2.new(0, 12, 0, 0)
            toggleLabel.Size = UDim2.new(1, -60, 1, 0)
            toggleLabel.Font = Theme.Font
            toggleLabel.Text = toggleText
            toggleLabel.TextColor3 = Theme.TextColor
            toggleLabel.TextSize = 14
            toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            toggleLabel.Parent = toggleFrame
            
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
            
            local toggled = default
            
            local function updateToggle()
                if toggled then
                    CreateTween(toggleButton, {BackgroundColor3 = Theme.AccentColor}, 0.2)
                    CreateTween(toggleCircle, {Position = UDim2.new(1, -18, 0.5, -8)}, 0.2)
                else
                    CreateTween(toggleButton, {BackgroundColor3 = Theme.BorderColor}, 0.2)
                    CreateTween(toggleCircle, {Position = UDim2.new(0, 2, 0.5, -8)}, 0.2)
                end
                callback(toggled)
            end
            
            if default then
                updateToggle()
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
        
        function Tab:AddSlider(config)
            config = config or {}
            local sliderText = config.Name or "Slider"
            local min = config.Min or 0
            local max = config.Max or 100
            local default = config.Default or min
            local increment = config.Increment or 1
            local callback = config.Callback or function() end
            
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Name = "SliderFrame"
            sliderFrame.BackgroundColor3 = Theme.SecondaryBackground
            sliderFrame.BorderSizePixel = 0
            sliderFrame.Size = UDim2.new(1, 0, 0, 55)
            sliderFrame.Parent = tabContent
            
            local sliderFrameCorner = Instance.new("UICorner")
            sliderFrameCorner.CornerRadius = UDim.new(0, 8)
            sliderFrameCorner.Parent = sliderFrame
            
            local sliderLabel = Instance.new("TextLabel")
            sliderLabel.Name = "Label"
            sliderLabel.BackgroundTransparency = 1
            sliderLabel.Position = UDim2.new(0, 12, 0, 5)
            sliderLabel.Size = UDim2.new(1, -70, 0, 20)
            sliderLabel.Font = Theme.Font
            sliderLabel.Text = sliderText
            sliderLabel.TextColor3 = Theme.TextColor
            sliderLabel.TextSize = 14
            sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            sliderLabel.Parent = sliderFrame
            
            local sliderValue = Instance.new("TextLabel")
            sliderValue.Name = "Value"
            sliderValue.BackgroundTransparency = 1
            sliderValue.Position = UDim2.new(1, -60, 0, 5)
            sliderValue.Size = UDim2.new(0, 50, 0, 20)
            sliderValue.Font = Theme.Font
            sliderValue.Text = tostring(default)
            sliderValue.TextColor3 = Theme.AccentColor
            sliderValue.TextSize = 14
            sliderValue.TextXAlignment = Enum.TextXAlignment.Right
            sliderValue.Parent = sliderFrame
            
            local sliderBar = Instance.new("Frame")
            sliderBar.Name = "SliderBar"
            sliderBar.BackgroundColor3 = Theme.BorderColor
            sliderBar.Position = UDim2.new(0, 12, 0, 30)
            sliderBar.Size = UDim2.new(1, -24, 0, 6)
            sliderBar.Parent = sliderFrame
            
            local sliderBarCorner = Instance.new("UICorner")
            sliderBarCorner.CornerRadius = UDim.new(1, 0)
            sliderBarCorner.Parent = sliderBar
            
            local sliderFill = Instance.new("Frame")
            sliderFill.Name = "Fill"
            sliderFill.BackgroundColor3 = Theme.AccentColor
            sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            sliderFill.Parent = sliderBar
            
            local sliderFillCorner = Instance.new("UICorner")
            sliderFillCorner.CornerRadius = UDim.new(1, 0)
            sliderFillCorner.Parent = sliderFill
            
            local sliderDot = Instance.new("Frame")
            sliderDot.Name = "Dot"
            sliderDot.BackgroundColor3 = Theme.TextColor
            sliderDot.Position = UDim2.new((default - min) / (max - min), -6, 0.5, -6)
            sliderDot.Size = UDim2.new(0, 12, 0, 12)
            sliderDot.Parent = sliderBar
            
            local sliderDotCorner = Instance.new("UICorner")
            sliderDotCorner.CornerRadius = UDim.new(1, 0)
            sliderDotCorner.Parent = sliderDot
            
            local dragging = false
            
            local function updateSlider(input)
                local pos = UDim2.new(math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1), -6, 0.5, -6)
                sliderDot.Position = pos
                sliderFill.Size = UDim2.new(math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1), 0, 1, 0)
                
                local value = math.floor(((pos.X.Scale * (max - min)) + min) / increment + 0.5) * increment
                sliderValue.Text = tostring(value)
                callback(value)
            end
            
            sliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    updateSlider(input)
                end
            end)
            
            sliderBar.InputEnded:Connect(function(input)
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
        
        function Tab:AddDropdown(config)
            config = config or {}
            local dropdownText = config.Name or "Dropdown"
            local options = config.Options or {}
            local default = config.Default or options[1]
            local callback = config.Callback or function() end
            
            local dropdownFrame = Instance.new("Frame")
            dropdownFrame.Name = "DropdownFrame"
            dropdownFrame.BackgroundColor3 = Theme.SecondaryBackground
            dropdownFrame.BorderSizePixel = 0
            dropdownFrame.Size = UDim2.new(1, 0, 0, 38)
            dropdownFrame.Parent = tabContent
            
            local dropdownFrameCorner = Instance.new("UICorner")
            dropdownFrameCorner.CornerRadius = UDim.new(0, 8)
            dropdownFrameCorner.Parent = dropdownFrame
            
            local dropdownLabel = Instance.new("TextLabel")
            dropdownLabel.Name = "Label"
            dropdownLabel.BackgroundTransparency = 1
            dropdownLabel.Position = UDim2.new(0, 12, 0, 0)
            dropdownLabel.Size = UDim2.new(0.5, -12, 1, 0)
            dropdownLabel.Font = Theme.Font
            dropdownLabel.Text = dropdownText
            dropdownLabel.TextColor3 = Theme.TextColor
            dropdownLabel.TextSize = 14
            dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            dropdownLabel.Parent = dropdownFrame
            
            local dropdownSelected = Instance.new("TextLabel")
            dropdownSelected.Name = "Selected"
            dropdownSelected.BackgroundTransparency = 1
            dropdownSelected.Position = UDim2.new(0.5, 0, 0, 0)
            dropdownSelected.Size = UDim2.new(0.5, -32, 1, 0)
            dropdownSelected.Font = Theme.Font
            dropdownSelected.Text = default or "None"
            dropdownSelected.TextColor3 = Theme.AccentColor
            dropdownSelected.TextSize = 14
            dropdownSelected.TextXAlignment = Enum.TextXAlignment.Right
            dropdownSelected.Parent = dropdownFrame
            
            local dropdownArrow = Instance.new("TextLabel")
            dropdownArrow.Name = "Arrow"
            dropdownArrow.BackgroundTransparency = 1
            dropdownArrow.Position = UDim2.new(1, -25, 0, 0)
            dropdownArrow.Size = UDim2.new(0, 20, 1, 0)
            dropdownArrow.Font = Theme.Font
            dropdownArrow.Text = "▼"
            dropdownArrow.TextColor3 = Theme.SecondaryText
            dropdownArrow.TextSize = 12
            dropdownArrow.Parent = dropdownFrame
            
            local dropdownList = Instance.new("Frame")
            dropdownList.Name = "DropdownList"
            dropdownList.BackgroundColor3 = Theme.TertiaryBackground
            dropdownList.BorderSizePixel = 0
            dropdownList.Position = UDim2.new(0, 0, 1, 5)
            dropdownList.Size = UDim2.new(1, 0, 0, 0)
            dropdownList.Visible = false
            dropdownList.ZIndex = 10
            dropdownList.Parent = dropdownFrame
            
            local dropdownListCorner = Instance.new("UICorner")
            dropdownListCorner.CornerRadius = UDim.new(0, 8)
            dropdownListCorner.Parent = dropdownList
            
            local dropdownListLayout = Instance.new("UIListLayout")
            dropdownListLayout.Padding = UDim.new(0, 2)
            dropdownListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            dropdownListLayout.Parent = dropdownList
            
            local dropdownListPadding = Instance.new("UIPadding")
            dropdownListPadding.PaddingLeft = UDim.new(0, 5)
            dropdownListPadding.PaddingRight = UDim.new(0, 5)
            dropdownListPadding.PaddingTop = UDim.new(0, 5)
            dropdownListPadding.PaddingBottom = UDim.new(0, 5)
            dropdownListPadding.Parent = dropdownList
            
            local dropdownOpen = false
            
            local function toggleDropdown()
                dropdownOpen = not dropdownOpen
                if dropdownOpen then
                    dropdownList.Visible = true
                    CreateTween(dropdownList, {Size = UDim2.new(1, 0, 0, #options * 30 + 10)}, 0.2)
                    CreateTween(dropdownArrow, {Rotation = 180}, 0.2)
                else
                    CreateTween(dropdownList, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                    CreateTween(dropdownArrow, {Rotation = 0}, 0.2)
                    wait(0.2)
                    dropdownList.Visible = false
                end
            end
            
            for _, option in ipairs(options) do
                local optionButton = Instance.new("TextButton")
                optionButton.Name = option
                optionButton.BackgroundColor3 = Theme.SecondaryBackground
                optionButton.BorderSizePixel = 0
                optionButton.Size = UDim2.new(1, 0, 0, 26)
                optionButton.Font = Theme.Font
                optionButton.Text = option
                optionButton.TextColor3 = Theme.TextColor
                optionButton.TextSize = 13
                optionButton.AutoButtonColor = false
                optionButton.Parent = dropdownList
                
                local optionCorner = Instance.new("UICorner")
                optionCorner.CornerRadius = UDim.new(0, 6)
                optionCorner.Parent = optionButton
                
                optionButton.MouseEnter:Connect(function()
                    CreateTween(optionButton, {BackgroundColor3 = Theme.AccentColor}, 0.2)
                end)
                
                optionButton.MouseLeave:Connect(function()
                    CreateTween(optionButton, {BackgroundColor3 = Theme.SecondaryBackground}, 0.2)
                end)
                
                optionButton.MouseButton1Click:Connect(function()
                    dropdownSelected.Text = option
                    callback(option)
                    toggleDropdown()
                end)
            end
            
            local dropdownButton = Instance.new("TextButton")
            dropdownButton.BackgroundTransparency = 1
            dropdownButton.Size = UDim2.new(1, 0, 1, 0)
            dropdownButton.Text = ""
            dropdownButton.Parent = dropdownFrame
            
            dropdownButton.MouseButton1Click:Connect(toggleDropdown)
            
            return dropdownFrame
        end
        
        function Tab:AddTextbox(config)
            config = config or {}
            local textboxText = config.Name or "Textbox"
            local placeholder = config.Placeholder or "Enter text..."
            local default = config.Default or ""
            local callback = config.Callback or function() end
            
            local textboxFrame = Instance.new("Frame")
            textboxFrame.Name = "TextboxFrame"
            textboxFrame.BackgroundColor3 = Theme.SecondaryBackground
            textboxFrame.BorderSizePixel = 0
            textboxFrame.Size = UDim2.new(1, 0, 0, 38)
            textboxFrame.Parent = tabContent
            
            local textboxFrameCorner = Instance.new("UICorner")
            textboxFrameCorner.CornerRadius = UDim.new(0, 8)
            textboxFrameCorner.Parent = textboxFrame
            
            local textboxLabel = Instance.new("TextLabel")
            textboxLabel.Name = "Label"
            textboxLabel.BackgroundTransparency = 1
            textboxLabel.Position = UDim2.new(0, 12, 0, 0)
            textboxLabel.Size = UDim2.new(0.4, -12, 1, 0)
            textboxLabel.Font = Theme.Font
            textboxLabel.Text = textboxText
            textboxLabel.TextColor3 = Theme.TextColor
            textboxLabel.TextSize = 14
            textboxLabel.TextXAlignment = Enum.TextXAlignment.Left
            textboxLabel.Parent = textboxFrame
            
            local textbox = Instance.new("TextBox")
            textbox.Name = "Textbox"
            textbox.BackgroundColor3 = Theme.TertiaryBackground
            textbox.BorderSizePixel = 0
            textbox.Position = UDim2.new(0.4, 5, 0.5, -12)
            textbox.Size = UDim2.new(0.6, -15, 0, 24)
            textbox.Font = Theme.Font
            textbox.PlaceholderText = placeholder
            textbox.PlaceholderColor3 = Theme.SecondaryText
            textbox.Text = default
            textbox.TextColor3 = Theme.TextColor
            textbox.TextSize = 13
            textbox.Parent = textboxFrame
            
            local textboxCorner = Instance.new("UICorner")
            textboxCorner.CornerRadius = UDim.new(0, 6)
            textboxCorner.Parent = textbox
            
            textbox.FocusLost:Connect(function(enterPressed)
                callback(textbox.Text, enterPressed)
            end)
            
            return textboxFrame
        end
        
        function Tab:AddLabel(text)
            local labelFrame = Instance.new("Frame")
            labelFrame.Name = "LabelFrame"
            labelFrame.BackgroundTransparency = 1
            labelFrame.Size = UDim2.new(1, 0, 0, 20)
            labelFrame.Parent = tabContent
            
            local label = Instance.new("TextLabel")
            label.Name = "Label"
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(1, 0, 1, 0)
            label.Font = Theme.Font
            label.Text = text
            label.TextColor3 = Theme.SecondaryText
            label.TextSize = 13
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = labelFrame
            
            return label
        end
        
        function Tab:AddSeparator()
            local separator = Instance.new("Frame")
            separator.Name = "Separator"
            separator.BackgroundColor3 = Theme.BorderColor
            separator.BorderSizePixel = 0
            separator.Size = UDim2.new(1, 0, 0, 1)
            separator.Parent = tabContent
            
            return separator
        end
        
        table.insert(Window.Tabs, Tab)
        return Tab
    end
    
    -- Animate window opening
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.BackgroundTransparency = 1
    CreateTween(mainFrame, {Size = windowSize, BackgroundTransparency = 0}, 0.3)
    
    return Window
end

return Library
