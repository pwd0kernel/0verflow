

local VapeUI = {}
VapeUI.__index = VapeUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Vape-Style Dark Purple Theme
local Theme = {
    -- Primary Colors
    Background = Color3.fromRGB(15, 10, 20),
    MainFrame = Color3.fromRGB(25, 18, 35),
    Secondary = Color3.fromRGB(35, 25, 45),
    Accent = Color3.fromRGB(140, 90, 205),
    AccentDark = Color3.fromRGB(110, 70, 165),
    AccentLight = Color3.fromRGB(170, 120, 235),
    
    -- Module Colors
    ModuleOn = Color3.fromRGB(140, 90, 205),
    ModuleOff = Color3.fromRGB(45, 35, 55),
    ModuleHover = Color3.fromRGB(55, 45, 65),
    
    -- Text Colors
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(180, 180, 190),
    TextDark = Color3.fromRGB(120, 120, 130),
    
    -- Status Colors
    Success = Color3.fromRGB(100, 255, 100),
    Warning = Color3.fromRGB(255, 200, 100),
    Error = Color3.fromRGB(255, 100, 100),
    
    -- Fonts
    Font = Enum.Font.Gotham,
    FontBold = Enum.Font.GothamBold,
    FontMono = Enum.Font.Code
}

-- Utility Functions
local function CreateTween(obj, props, duration, style)
    style = style or Enum.EasingStyle.Quart
    local tween = TweenService:Create(
        obj,
        TweenInfo.new(duration, style, Enum.EasingDirection.Out),
        props
    )
    tween:Play()
    return tween
end

local function AddDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    
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
function VapeUI:CreateWindow()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "0verflowHub_Vape"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = CoreGui
    
    local Window = {
        Modules = {},
        ArraylistItems = {},
        Notifications = {}
    }
    
    -- Watermark
    local watermark = Instance.new("Frame")
    watermark.BackgroundColor3 = Theme.MainFrame
    watermark.BorderSizePixel = 0
    watermark.Position = UDim2.new(0, 10, 0, 10)
    watermark.Size = UDim2.new(0, 200, 0, 35)
    watermark.Parent = screenGui
    
    local watermarkCorner = Instance.new("UICorner")
    watermarkCorner.CornerRadius = UDim.new(0, 6)
    watermarkCorner.Parent = watermark
    
    local watermarkStroke = Instance.new("UIStroke")
    watermarkStroke.Color = Theme.Accent
    watermarkStroke.Thickness = 1
    watermarkStroke.Transparency = 0.5
    watermarkStroke.Parent = watermark
    
    local watermarkText = Instance.new("TextLabel")
    watermarkText.BackgroundTransparency = 1
    watermarkText.Position = UDim2.new(0, 10, 0, 0)
    watermarkText.Size = UDim2.new(1, -20, 1, 0)
    watermarkText.Font = Theme.FontBold
    watermarkText.Text = "0VERFLOW HUB"
    watermarkText.TextColor3 = Theme.Accent
    watermarkText.TextSize = 16
    watermarkText.TextXAlignment = Enum.TextXAlignment.Left
    watermarkText.Parent = watermark
    
    local watermarkSubtext = Instance.new("TextLabel")
    watermarkSubtext.BackgroundTransparency = 1
    watermarkSubtext.Position = UDim2.new(0, 10, 0.5, 0)
    watermarkSubtext.Size = UDim2.new(1, -20, 0.5, 0)
    watermarkSubtext.Font = Theme.Font
    watermarkSubtext.Text = "v3.0 | FPS: 60"
    watermarkSubtext.TextColor3 = Theme.TextDim
    watermarkSubtext.TextSize = 11
    watermarkSubtext.TextXAlignment = Enum.TextXAlignment.Left
    watermarkSubtext.Parent = watermark
    
    -- Update FPS
    task.spawn(function()
        local lastUpdate = 0
        local fps = 0
        RunService.RenderStepped:Connect(function()
            fps = fps + 1
            if tick() - lastUpdate >= 1 then
                watermarkSubtext.Text = string.format("v3.0 | FPS: %d", fps)
                fps = 0
                lastUpdate = tick()
            end
        end)
    end)
    
    -- Arraylist Container
    local arraylist = Instance.new("Frame")
    arraylist.BackgroundTransparency = 1
    arraylist.Position = UDim2.new(1, -5, 0, 5)
    arraylist.Size = UDim2.new(0, 200, 1, -10)
    arraylist.Parent = screenGui
    
    local arraylistLayout = Instance.new("UIListLayout")
    arraylistLayout.SortOrder = Enum.SortOrder.LayoutOrder
    arraylistLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    arraylistLayout.Padding = UDim.new(0, 2)
    arraylistLayout.Parent = arraylist
    
    -- Module Windows Container
    local moduleContainer = Instance.new("Frame")
    moduleContainer.BackgroundTransparency = 1
    moduleContainer.Size = UDim2.new(1, 0, 1, 0)
    moduleContainer.Parent = screenGui
    
    -- Notification Container
    local notificationContainer = Instance.new("Frame")
    notificationContainer.BackgroundTransparency = 1
    notificationContainer.Position = UDim2.new(0.5, -150, 1, -200)
    notificationContainer.Size = UDim2.new(0, 300, 0, 200)
    notificationContainer.Parent = screenGui
    
    local notificationLayout = Instance.new("UIListLayout")
    notificationLayout.SortOrder = Enum.SortOrder.LayoutOrder
    notificationLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    notificationLayout.Padding = UDim.new(0, 5)
    notificationLayout.Parent = notificationContainer
    
    -- Click GUI Toggle
    local guiVisible = true
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Enum.KeyCode.RightShift then
            guiVisible = not guiVisible
            for _, module in pairs(Window.Modules) do
                module.Frame.Visible = guiVisible
            end
            watermark.Visible = guiVisible
        end
    end)
    
    function Window:CreateModule(config)
        config = config or {}
        local name = config.Name or "Module"
        local icon = config.Icon or "⚡"
        local posX = config.PosX or 100
        local posY = config.PosY or 100
        
        local Module = {
            Elements = {},
            Toggles = {},
            Expanded = true
        }
        
        -- Main Module Frame
        local moduleFrame = Instance.new("Frame")
        moduleFrame.BackgroundColor3 = Theme.MainFrame
        moduleFrame.BorderSizePixel = 0
        moduleFrame.Position = UDim2.new(0, posX, 0, posY)
        moduleFrame.Size = UDim2.new(0, 200, 0, 35)
        moduleFrame.ClipsDescendants = true
        moduleFrame.Parent = moduleContainer
        
        Module.Frame = moduleFrame
        
        local moduleCorner = Instance.new("UICorner")
        moduleCorner.CornerRadius = UDim.new(0, 8)
        moduleCorner.Parent = moduleFrame
        
        local moduleStroke = Instance.new("UIStroke")
        moduleStroke.Color = Theme.Accent
        moduleStroke.Thickness = 2
        moduleStroke.Transparency = 0.3
        moduleStroke.Parent = moduleFrame
        
        -- Module Header
        local header = Instance.new("Frame")
        header.BackgroundColor3 = Theme.Secondary
        header.BorderSizePixel = 0
        header.Size = UDim2.new(1, 0, 0, 35)
        header.Parent = moduleFrame
        
        local headerCorner = Instance.new("UICorner")
        headerCorner.CornerRadius = UDim.new(0, 8)
        headerCorner.Parent = header
        
        -- Module Icon
        local moduleIcon = Instance.new("TextLabel")
        moduleIcon.BackgroundTransparency = 1
        moduleIcon.Position = UDim2.new(0, 10, 0, 0)
        moduleIcon.Size = UDim2.new(0, 25, 1, 0)
        moduleIcon.Font = Theme.Font
        moduleIcon.Text = icon
        moduleIcon.TextColor3 = Theme.Accent
        moduleIcon.TextSize = 16
        moduleIcon.Parent = header
        
        -- Module Title
        local moduleTitle = Instance.new("TextLabel")
        moduleTitle.BackgroundTransparency = 1
        moduleTitle.Position = UDim2.new(0, 35, 0, 0)
        moduleTitle.Size = UDim2.new(1, -70, 1, 0)
        moduleTitle.Font = Theme.FontBold
        moduleTitle.Text = name
        moduleTitle.TextColor3 = Theme.Text
        moduleTitle.TextSize = 14
        moduleTitle.TextXAlignment = Enum.TextXAlignment.Left
        moduleTitle.Parent = header
        
        -- Expand/Collapse Button
        local expandButton = Instance.new("TextButton")
        expandButton.BackgroundTransparency = 1
        expandButton.Position = UDim2.new(1, -30, 0, 0)
        expandButton.Size = UDim2.new(0, 30, 1, 0)
        expandButton.Font = Theme.Font
        expandButton.Text = "▼"
        expandButton.TextColor3 = Theme.TextDim
        expandButton.TextSize = 12
        expandButton.Parent = header
        
        -- Content Container
        local content = Instance.new("Frame")
        content.BackgroundTransparency = 1
        content.Position = UDim2.new(0, 0, 0, 35)
        content.Size = UDim2.new(1, 0, 0, 0)
        content.Parent = moduleFrame
        
        local contentLayout = Instance.new("UIListLayout")
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Padding = UDim.new(0, 5)
        contentLayout.Parent = content
        
        local contentPadding = Instance.new("UIPadding")
        contentPadding.PaddingLeft = UDim.new(0, 10)
        contentPadding.PaddingRight = UDim.new(0, 10)
        contentPadding.PaddingTop = UDim.new(0, 5)
        contentPadding.PaddingBottom = UDim.new(0, 10)
        contentPadding.Parent = content
        
        -- Auto-resize
        contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            content.Size = UDim2.new(1, 0, 0, contentLayout.AbsoluteContentSize.Y + 15)
            if Module.Expanded then
                moduleFrame.Size = UDim2.new(0, 200, 0, 35 + content.Size.Y.Offset)
            end
        end)
        
        -- Expand/Collapse
        expandButton.MouseButton1Click:Connect(function()
            Module.Expanded = not Module.Expanded
            if Module.Expanded then
                expandButton.Text = "▼"
                CreateTween(moduleFrame, {Size = UDim2.new(0, 200, 0, 35 + content.Size.Y.Offset)}, 0.2)
            else
                expandButton.Text = "▶"
                CreateTween(moduleFrame, {Size = UDim2.new(0, 200, 0, 35)}, 0.2)
            end
        end)
        
        -- Draggable
        AddDraggable(moduleFrame, header)
        
        -- Module Elements
        function Module:AddToggle(config)
            config = config or {}
            local toggleName = config.Name or "Toggle"
            local default = config.Default or false
            local callback = config.Callback or function() end
            local keybind = config.Keybind
            
            local toggleFrame = Instance.new("Frame")
            toggleFrame.BackgroundColor3 = Theme.ModuleOff
            toggleFrame.BorderSizePixel = 0
            toggleFrame.Size = UDim2.new(1, 0, 0, 30)
            toggleFrame.Parent = content
            
            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(0, 6)
            toggleCorner.Parent = toggleFrame
            
            local toggleLabel = Instance.new("TextLabel")
            toggleLabel.BackgroundTransparency = 1
            toggleLabel.Position = UDim2.new(0, 10, 0, 0)
            toggleLabel.Size = UDim2.new(1, -50, 1, 0)
            toggleLabel.Font = Theme.Font
            toggleLabel.Text = toggleName
            toggleLabel.TextColor3 = Theme.Text
            toggleLabel.TextSize = 13
            toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            toggleLabel.Parent = toggleFrame
            
            local toggleStatus = Instance.new("Frame")
            toggleStatus.BackgroundColor3 = default and Theme.Success or Theme.Error
            toggleStatus.Position = UDim2.new(1, -35, 0.5, -6)
            toggleStatus.Size = UDim2.new(0, 25, 0, 12)
            toggleStatus.Parent = toggleFrame
            
            local statusCorner = Instance.new("UICorner")
            statusCorner.CornerRadius = UDim.new(1, 0)
            statusCorner.Parent = toggleStatus
            
            local toggled = default
            local arraylistItem = nil
            
            local function updateToggle()
                if toggled then
                    CreateTween(toggleFrame, {BackgroundColor3 = Theme.ModuleOn}, 0.15)
                    CreateTween(toggleStatus, {BackgroundColor3 = Theme.Success}, 0.15)
                    
                    -- Add to arraylist
                    if not arraylistItem then
                        arraylistItem = Instance.new("Frame")
                        arraylistItem.BackgroundColor3 = Theme.Accent
                        arraylistItem.BackgroundTransparency = 0.1
                        arraylistItem.BorderSizePixel = 0
                        arraylistItem.Size = UDim2.new(0, 0, 0, 22)
                        arraylistItem.Parent = arraylist
                        
                        local itemCorner = Instance.new("UICorner")
                        itemCorner.CornerRadius = UDim.new(0, 4)
                        itemCorner.Parent = arraylistItem
                        
                        local itemText = Instance.new("TextLabel")
                        itemText.BackgroundTransparency = 1
                        itemText.Size = UDim2.new(1, 0, 1, 0)
                        itemText.Font = Theme.Font
                        itemText.Text = toggleName
                        itemText.TextColor3 = Theme.Text
                        itemText.TextSize = 13
                        itemText.Parent = arraylistItem
                        
                        local textBounds = itemText.TextBounds
                        CreateTween(arraylistItem, {Size = UDim2.new(0, textBounds.X + 20, 0, 22)}, 0.2)
                    end
                else
                    CreateTween(toggleFrame, {BackgroundColor3 = Theme.ModuleOff}, 0.15)
                    CreateTween(toggleStatus, {BackgroundColor3 = Theme.Error}, 0.15)
                    
                    -- Remove from arraylist
                    if arraylistItem then
                        CreateTween(arraylistItem, {Size = UDim2.new(0, 0, 0, 22)}, 0.2)
                        task.wait(0.2)
                        if arraylistItem then
                            arraylistItem:Destroy()
                            arraylistItem = nil
                        end
                    end
                end
                callback(toggled)
            end
            
            -- Click detection
            local button = Instance.new("TextButton")
            button.BackgroundTransparency = 1
            button.Size = UDim2.new(1, 0, 1, 0)
            button.Text = ""
            button.Parent = toggleFrame
            
            button.MouseButton1Click:Connect(function()
                toggled = not toggled
                updateToggle()
            end)
            
            button.MouseEnter:Connect(function()
                if not toggled then
                    CreateTween(toggleFrame, {BackgroundColor3 = Theme.ModuleHover}, 0.1)
                end
            end)
            
            button.MouseLeave:Connect(function()
                if not toggled then
                    CreateTween(toggleFrame, {BackgroundColor3 = Theme.ModuleOff}, 0.1)
                end
            end)
            
            -- Keybind support
            if keybind then
                UserInputService.InputBegan:Connect(function(input, processed)
                    if not processed and input.KeyCode == keybind then
                        toggled = not toggled
                        updateToggle()
                    end
                end)
                
                local keybindLabel = Instance.new("TextLabel")
                keybindLabel.BackgroundTransparency = 1
                keybindLabel.Position = UDim2.new(1, -70, 0, 0)
                keybindLabel.Size = UDim2.new(0, 30, 1, 0)
                keybindLabel.Font = Theme.Font
                keybindLabel.Text = "[" .. keybind.Name .. "]"
                keybindLabel.TextColor3 = Theme.TextDark
                keybindLabel.TextSize = 11
                keybindLabel.Parent = toggleFrame
            end
            
            if default then
                updateToggle()
            end
            
            Module.Toggles[toggleName] = {Frame = toggleFrame, Toggled = toggled}
            return toggleFrame
        end
        
        function Module:AddSlider(config)
            config = config or {}
            local sliderName = config.Name or "Slider"
            local min = config.Min or 0
            local max = config.Max or 100
            local default = config.Default or min
            local callback = config.Callback or function() end
            
            local sliderFrame = Instance.new("Frame")
            sliderFrame.BackgroundColor3 = Theme.ModuleOff
            sliderFrame.BorderSizePixel = 0
            sliderFrame.Size = UDim2.new(1, 0, 0, 45)
            sliderFrame.Parent = content
            
            local sliderCorner = Instance.new("UICorner")
            sliderCorner.CornerRadius = UDim.new(0, 6)
            sliderCorner.Parent = sliderFrame
            
            local sliderLabel = Instance.new("TextLabel")
            sliderLabel.BackgroundTransparency = 1
            sliderLabel.Position = UDim2.new(0, 10, 0, 5)
            sliderLabel.Size = UDim2.new(0.6, 0, 0, 15)
            sliderLabel.Font = Theme.Font
            sliderLabel.Text = sliderName
            sliderLabel.TextColor3 = Theme.Text
            sliderLabel.TextSize = 13
            sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            sliderLabel.Parent = sliderFrame
            
            local sliderValue = Instance.new("TextLabel")
            sliderValue.BackgroundTransparency = 1
            sliderValue.Position = UDim2.new(0.6, 0, 0, 5)
            sliderValue.Size = UDim2.new(0.4, -10, 0, 15)
            sliderValue.Font = Theme.FontMono
            sliderValue.Text = tostring(default)
            sliderValue.TextColor3 = Theme.Accent
            sliderValue.TextSize = 13
            sliderValue.TextXAlignment = Enum.TextXAlignment.Right
            sliderValue.Parent = sliderFrame
            
            local sliderBar = Instance.new("Frame")
            sliderBar.BackgroundColor3 = Theme.Background
            sliderBar.BorderSizePixel = 0
            sliderBar.Position = UDim2.new(0, 10, 0, 25)
            sliderBar.Size = UDim2.new(1, -20, 0, 6)
            sliderBar.Parent = sliderFrame
            
            local barCorner = Instance.new("UICorner")
            barCorner.CornerRadius = UDim.new(1, 0)
            barCorner.Parent = sliderBar
            
            local sliderFill = Instance.new("Frame")
            sliderFill.BackgroundColor3 = Theme.Accent
            sliderFill.BorderSizePixel = 0
            sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            sliderFill.Parent = sliderBar
            
            local fillCorner = Instance.new("UICorner")
            fillCorner.CornerRadius = UDim.new(1, 0)
            fillCorner.Parent = sliderFill
            
            local sliderButton = Instance.new("TextButton")
            sliderButton.BackgroundTransparency = 1
            sliderButton.Size = UDim2.new(1, 0, 1, 0)
            sliderButton.Text = ""
            sliderButton.Parent = sliderBar
            
            local dragging = false
            
            sliderButton.MouseButton1Down:Connect(function()
                dragging = true
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local mousePos = UserInputService:GetMouseLocation()
                    local relativePos = mousePos.X - sliderBar.AbsolutePosition.X
                    local percent = math.clamp(relativePos / sliderBar.AbsoluteSize.X, 0, 1)
                    local value = math.floor(min + (max - min) * percent)
                    
                    sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                    sliderValue.Text = tostring(value)
                    callback(value)
                end
            end)
            
            return sliderFrame
        end
        
        function Module:AddDropdown(config)
            config = config or {}
            local dropName = config.Name or "Dropdown"
            local options = config.Options or {}
            local default = config.Default or options[1]
            local callback = config.Callback or function() end
            
            local dropFrame = Instance.new("Frame")
            dropFrame.BackgroundColor3 = Theme.ModuleOff
            dropFrame.BorderSizePixel = 0
            dropFrame.Size = UDim2.new(1, 0, 0, 30)
            dropFrame.ClipsDescendants = true
            dropFrame.Parent = content
            
            local dropCorner = Instance.new("UICorner")
            dropCorner.CornerRadius = UDim.new(0, 6)
            dropCorner.Parent = dropFrame
            
            local dropLabel = Instance.new("TextLabel")
            dropLabel.BackgroundTransparency = 1
            dropLabel.Position = UDim2.new(0, 10, 0, 0)
            dropLabel.Size = UDim2.new(1, -30, 0, 30)
            dropLabel.Font = Theme.Font
            dropLabel.Text = dropName .. ": " .. (default or "None")
            dropLabel.TextColor3 = Theme.Text
            dropLabel.TextSize = 13
            dropLabel.TextXAlignment = Enum.TextXAlignment.Left
            dropLabel.Parent = dropFrame
            
            local dropArrow = Instance.new("TextLabel")
            dropArrow.BackgroundTransparency = 1
            dropArrow.Position = UDim2.new(1, -25, 0, 0)
            dropArrow.Size = UDim2.new(0, 20, 0, 30)
            dropArrow.Font = Theme.Font
            dropArrow.Text = "▼"
            dropArrow.TextColor3 = Theme.TextDim
            dropArrow.TextSize = 10
            dropArrow.Parent = dropFrame
            
            local optionContainer = Instance.new("Frame")
            optionContainer.BackgroundTransparency = 1
            optionContainer.Position = UDim2.new(0, 0, 0, 30)
            optionContainer.Size = UDim2.new(1, 0, 0, #options * 25)
            optionContainer.Parent = dropFrame
            
            local optionLayout = Instance.new("UIListLayout")
            optionLayout.SortOrder = Enum.SortOrder.LayoutOrder
            optionLayout.Parent = optionContainer
            
            for i, option in ipairs(options) do
                local optionButton = Instance.new("TextButton")
                optionButton.BackgroundColor3 = Theme.Secondary
                optionButton.BorderSizePixel = 0
                optionButton.Size = UDim2.new(1, 0, 0, 25)
                optionButton.Font = Theme.Font
                optionButton.Text = option
                optionButton.TextColor3 = Theme.TextDim
                optionButton.TextSize = 12
                optionButton.Parent = optionContainer
                
                optionButton.MouseButton1Click:Connect(function()
                    dropLabel.Text = dropName .. ": " .. option
                    callback(option)
                    CreateTween(dropFrame, {Size = UDim2.new(1, 0, 0, 30)}, 0.15)
                    dropArrow.Text = "▼"
                end)
                
                optionButton.MouseEnter:Connect(function()
                    CreateTween(optionButton, {BackgroundColor3 = Theme.Accent}, 0.1)
                    CreateTween(optionButton, {TextColor3 = Theme.Text}, 0.1)
                end)
                
                optionButton.MouseLeave:Connect(function()
                    CreateTween(optionButton, {BackgroundColor3 = Theme.Secondary}, 0.1)
                    CreateTween(optionButton, {TextColor3 = Theme.TextDim}, 0.1)
                end)
            end
            
            local expanded = false
            local dropButton = Instance.new("TextButton")
            dropButton.BackgroundTransparency = 1
            dropButton.Size = UDim2.new(1, 0, 0, 30)
            dropButton.Text = ""
            dropButton.Parent = dropFrame
            
            dropButton.MouseButton1Click:Connect(function()
                expanded = not expanded
                if expanded then
                    CreateTween(dropFrame, {Size = UDim2.new(1, 0, 0, 30 + #options * 25)}, 0.15)
                    dropArrow.Text = "▲"
                else
                    CreateTween(dropFrame, {Size = UDim2.new(1, 0, 0, 30)}, 0.15)
                    dropArrow.Text = "▼"
                end
            end)
            
            return dropFrame
        end
        
        table.insert(Window.Modules, Module)
        return Module
    end
    
    function Window:Notify(text, duration)
        duration = duration or 3
        
        local notification = Instance.new("Frame")
        notification.BackgroundColor3 = Theme.MainFrame
        notification.BorderSizePixel = 0
        notification.Size = UDim2.new(1, 0, 0, 40)
        notification.BackgroundTransparency = 1
        notification.Parent = notificationContainer
        
        local notifCorner = Instance.new("UICorner")
        notifCorner.CornerRadius = UDim.new(0, 6)
        notifCorner.Parent = notification
        
        local notifStroke = Instance.new("UIStroke")
        notifStroke.Color = Theme.Accent
        notifStroke.Thickness = 1
        notifStroke.Transparency = 1
        notifStroke.Parent = notification
        
        local notifText = Instance.new("TextLabel")
        notifText.BackgroundTransparency = 1
        notifText.Size = UDim2.new(1, 0, 1, 0)
        notifText.Font = Theme.Font
        notifText.Text = text
        notifText.TextColor3 = Theme.Text
        notifText.TextSize = 13
        notifText.TextTransparency = 1
        notifText.Parent = notification
        
        -- Fade in
        CreateTween(notification, {BackgroundTransparency = 0.1}, 0.3)
        CreateTween(notifStroke, {Transparency = 0.3}, 0.3)
        CreateTween(notifText, {TextTransparency = 0}, 0.3)
        
        task.wait(duration)
        
        -- Fade out
        CreateTween(notification, {BackgroundTransparency = 1}, 0.3)
        CreateTween(notifStroke, {Transparency = 1}, 0.3)
        CreateTween(notifText, {TextTransparency = 1}, 0.3)
        
        task.wait(0.3)
        notification:Destroy()
    end
    
    return Window
end

return VapeUI
