--[[
    0verflow Hub UI Components
    Contains all UI elements: Buttons, Toggles, Labels, etc.
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Components = {}

-- Theme (shared with main library)
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

local function CreateStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Theme.Border
    stroke.Thickness = thickness or 1
    stroke.Parent = parent
    return stroke
end

-- Button Component
function Components:CreateButton(tab, config)
    config = config or {}
    local buttonText = config.Text or "Button"
    local callback = config.Callback or function() end
    
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Name = "ButtonFrame"
    buttonFrame.Size = UDim2.new(1, -30, 0, 40)
    buttonFrame.BackgroundTransparency = 1
    buttonFrame.Parent = tab.Content
    
    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundColor3 = Theme.Secondary
    button.BorderSizePixel = 0
    button.Text = buttonText
    button.TextColor3 = Theme.Text
    button.TextSize = 14
    button.Font = Enum.Font.GothamBold
    button.Parent = buttonFrame
    
    CreateCorner(button, 8)
    CreateStroke(button, Theme.Accent, 1)
    
    -- Button Effects
    button.MouseEnter:Connect(function()
        CreateTween(button, {
            BackgroundColor3 = Theme.Accent,
            Size = UDim2.new(1, 0, 1, 2)
        }, AnimationSettings.HoverSpeed):Play()
    end)
    
    button.MouseLeave:Connect(function()
        CreateTween(button, {
            BackgroundColor3 = Theme.Secondary,
            Size = UDim2.new(1, 0, 1, 0)
        }, AnimationSettings.HoverSpeed):Play()
    end)
    
    button.MouseButton1Down:Connect(function()
        CreateTween(button, {
            Size = UDim2.new(0.98, 0, 0.95, 0),
            BackgroundColor3 = Theme.Primary
        }, AnimationSettings.ClickSpeed):Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        CreateTween(button, {
            Size = UDim2.new(1, 0, 1, 2),
            BackgroundColor3 = Theme.Accent
        }, AnimationSettings.ClickSpeed):Play()
    end)
    
    button.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
    
    return button
end

-- Toggle Component
function Components:CreateToggle(tab, config)
    config = config or {}
    local toggleText = config.Text or "Toggle"
    local defaultValue = config.Default or false
    local callback = config.Callback or function() end
    
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = "ToggleFrame"
    toggleFrame.Size = UDim2.new(1, -30, 0, 40)
    toggleFrame.BackgroundColor3 = Theme.Surface
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = tab.Content
    
    CreateCorner(toggleFrame, 8)
    CreateStroke(toggleFrame, Theme.Border, 1)
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Name = "ToggleLabel"
    toggleLabel.Size = UDim2.new(1, -60, 1, 0)
    toggleLabel.Position = UDim2.new(0, 15, 0, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = toggleText
    toggleLabel.TextColor3 = Theme.Text
    toggleLabel.TextSize = 14
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Font = Enum.Font.Gotham
    toggleLabel.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 45, 0, 20)
    toggleButton.Position = UDim2.new(1, -55, 0.5, -10)
    toggleButton.BackgroundColor3 = defaultValue and Theme.Success or Theme.Border
    toggleButton.BorderSizePixel = 0
    toggleButton.Text = ""
    toggleButton.Parent = toggleFrame
    
    CreateCorner(toggleButton, 10)
    
    local toggleSlider = Instance.new("Frame")
    toggleSlider.Name = "ToggleSlider"
    toggleSlider.Size = UDim2.new(0, 16, 0, 16)
    toggleSlider.Position = defaultValue and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    toggleSlider.BackgroundColor3 = Theme.Text
    toggleSlider.BorderSizePixel = 0
    toggleSlider.Parent = toggleButton
    
    CreateCorner(toggleSlider, 8)
    
    local isToggled = defaultValue
    
    local function updateToggle()
        local targetColor = isToggled and Theme.Success or Theme.Border
        local targetPosition = isToggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        
        CreateTween(toggleButton, {BackgroundColor3 = targetColor}, AnimationSettings.ToggleSpeed):Play()
        CreateTween(toggleSlider, {Position = targetPosition}, AnimationSettings.ToggleSpeed):Play()
        
        pcall(callback, isToggled)
    end
    
    toggleButton.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        updateToggle()
    end)
    
    -- Hover effect
    toggleFrame.MouseEnter:Connect(function()
        CreateTween(toggleFrame, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}, AnimationSettings.HoverSpeed):Play()
    end)
    
    toggleFrame.MouseLeave:Connect(function()
        CreateTween(toggleFrame, {BackgroundColor3 = Theme.Surface}, AnimationSettings.HoverSpeed):Play()
    end)
    
    return {
        Frame = toggleFrame,
        GetValue = function() return isToggled end,
        SetValue = function(value)
            isToggled = value
            updateToggle()
        end
    }
end

-- Label Component
function Components:CreateLabel(tab, config)
    config = config or {}
    local labelText = config.Text or "Label"
    local textSize = config.TextSize or 14
    local textColor = config.TextColor or Theme.Text
    
    local labelFrame = Instance.new("Frame")
    labelFrame.Name = "LabelFrame"
    labelFrame.Size = UDim2.new(1, -30, 0, 30)
    labelFrame.BackgroundTransparency = 1
    labelFrame.Parent = tab.Content
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = textColor
    label.TextSize = textSize
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.TextWrapped = true
    label.Parent = labelFrame
    
    return {
        Frame = labelFrame,
        Label = label,
        SetText = function(text)
            label.Text = text
        end,
        SetColor = function(color)
            label.TextColor3 = color
        end
    }
end

-- Section Component (for grouping elements)
function Components:CreateSection(tab, config)
    config = config or {}
    local sectionText = config.Text or "Section"
    
    local sectionFrame = Instance.new("Frame")
    sectionFrame.Name = "SectionFrame"
    sectionFrame.Size = UDim2.new(1, -30, 0, 50)
    sectionFrame.BackgroundTransparency = 1
    sectionFrame.Parent = tab.Content
    
    local sectionLabel = Instance.new("TextLabel")
    sectionLabel.Name = "SectionLabel"
    sectionLabel.Size = UDim2.new(1, 0, 0, 25)
    sectionLabel.BackgroundTransparency = 1
    sectionLabel.Text = sectionText
    sectionLabel.TextColor3 = Theme.Accent
    sectionLabel.TextSize = 16
    sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    sectionLabel.Font = Enum.Font.GothamBold
    sectionLabel.Parent = sectionFrame
    
    local separator = Instance.new("Frame")
    separator.Name = "Separator"
    separator.Size = UDim2.new(1, 0, 0, 1)
    separator.Position = UDim2.new(0, 0, 0, 30)
    separator.BackgroundColor3 = Theme.Border
    separator.BorderSizePixel = 0
    separator.Parent = sectionFrame
    
    return sectionFrame
end

-- Slider Component
function Components:CreateSlider(tab, config)
    config = config or {}
    local sliderText = config.Text or "Slider"
    local minValue = config.Min or 0
    local maxValue = config.Max or 100
    local defaultValue = config.Default or minValue
    local callback = config.Callback or function() end
    
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = "SliderFrame"
    sliderFrame.Size = UDim2.new(1, -30, 0, 60)
    sliderFrame.BackgroundColor3 = Theme.Surface
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = tab.Content
    
    CreateCorner(sliderFrame, 8)
    CreateStroke(sliderFrame, Theme.Border, 1)
    
    local sliderLabel = Instance.new("TextLabel")
    sliderLabel.Name = "SliderLabel"
    sliderLabel.Size = UDim2.new(1, -20, 0, 25)
    sliderLabel.Position = UDim2.new(0, 10, 0, 5)
    sliderLabel.BackgroundTransparency = 1
    sliderLabel.Text = sliderText .. ": " .. defaultValue
    sliderLabel.TextColor3 = Theme.Text
    sliderLabel.TextSize = 14
    sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    sliderLabel.Font = Enum.Font.Gotham
    sliderLabel.Parent = sliderFrame
    
    local sliderTrack = Instance.new("Frame")
    sliderTrack.Name = "SliderTrack"
    sliderTrack.Size = UDim2.new(1, -40, 0, 6)
    sliderTrack.Position = UDim2.new(0, 20, 1, -20)
    sliderTrack.BackgroundColor3 = Theme.Border
    sliderTrack.BorderSizePixel = 0
    sliderTrack.Parent = sliderFrame
    
    CreateCorner(sliderTrack, 3)
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "SliderFill"
    sliderFill.Size = UDim2.new((defaultValue - minValue) / (maxValue - minValue), 0, 1, 0)
    sliderFill.BackgroundColor3 = Theme.Secondary
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderTrack
    
    CreateCorner(sliderFill, 3)
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Name = "SliderButton"
    sliderButton.Size = UDim2.new(0, 16, 0, 16)
    sliderButton.Position = UDim2.new((defaultValue - minValue) / (maxValue - minValue), -8, 0.5, -8)
    sliderButton.BackgroundColor3 = Theme.Text
    sliderButton.BorderSizePixel = 0
    sliderButton.Text = ""
    sliderButton.Parent = sliderTrack
    
    CreateCorner(sliderButton, 8)
    
    local currentValue = defaultValue
    local dragging = false
    
    local function updateSlider(value)
        currentValue = math.clamp(value, minValue, maxValue)
        local percentage = (currentValue - minValue) / (maxValue - minValue)
        
        sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        sliderButton.Position = UDim2.new(percentage, -8, 0.5, -8)
        sliderLabel.Text = sliderText .. ": " .. math.floor(currentValue + 0.5)
        
        pcall(callback, currentValue)
    end
    
    sliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relativeX = (input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X
            relativeX = math.clamp(relativeX, 0, 1)
            local newValue = minValue + (maxValue - minValue) * relativeX
            updateSlider(newValue)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    return {
        Frame = sliderFrame,
        GetValue = function() return currentValue end,
        SetValue = function(value) updateSlider(value) end
    }
end

-- Dropdown Component
function Components:CreateDropdown(tab, config)
    config = config or {}
    local dropdownText = config.Text or "Dropdown"
    local options = config.Options or {"Option 1", "Option 2", "Option 3"}
    local defaultValue = config.Default or options[1]
    local callback = config.Callback or function() end
    
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Name = "DropdownFrame"
    dropdownFrame.Size = UDim2.new(1, -30, 0, 40)
    dropdownFrame.BackgroundColor3 = Theme.Surface
    dropdownFrame.BorderSizePixel = 0
    dropdownFrame.Parent = tab.Content
    
    CreateCorner(dropdownFrame, 8)
    CreateStroke(dropdownFrame, Theme.Border, 1)
    
    local dropdownLabel = Instance.new("TextLabel")
    dropdownLabel.Name = "DropdownLabel"
    dropdownLabel.Size = UDim2.new(0.4, 0, 1, 0)
    dropdownLabel.Position = UDim2.new(0, 15, 0, 0)
    dropdownLabel.BackgroundTransparency = 1
    dropdownLabel.Text = dropdownText
    dropdownLabel.TextColor3 = Theme.Text
    dropdownLabel.TextSize = 14
    dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
    dropdownLabel.Font = Enum.Font.Gotham
    dropdownLabel.Parent = dropdownFrame
    
    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Name = "DropdownButton"
    dropdownButton.Size = UDim2.new(0.5, -20, 0, 30)
    dropdownButton.Position = UDim2.new(0.5, 0, 0, 5)
    dropdownButton.BackgroundColor3 = Theme.Background
    dropdownButton.BorderSizePixel = 0
    dropdownButton.Text = defaultValue .. " ▼"
    dropdownButton.TextColor3 = Theme.Text
    dropdownButton.TextSize = 12
    dropdownButton.Font = Enum.Font.Gotham
    dropdownButton.Parent = dropdownFrame
    
    CreateCorner(dropdownButton, 6)
    CreateStroke(dropdownButton, Theme.Border, 1)
    
    local currentValue = defaultValue
    local isOpen = false
    
    local function createOptionsList()
        local optionsList = Instance.new("Frame")
        optionsList.Name = "OptionsList"
        optionsList.Size = UDim2.new(0.5, -20, 0, #options * 30)
        optionsList.Position = UDim2.new(0.5, 0, 1, 5)
        optionsList.BackgroundColor3 = Theme.Background
        optionsList.BorderSizePixel = 0
        optionsList.Visible = false
        optionsList.ZIndex = 10
        optionsList.Parent = dropdownFrame
        
        CreateCorner(optionsList, 6)
        CreateStroke(optionsList, Theme.Border, 1)
        
        local optionsLayout = Instance.new("UIListLayout")
        optionsLayout.FillDirection = Enum.FillDirection.Vertical
        optionsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        optionsLayout.VerticalAlignment = Enum.VerticalAlignment.Top
        optionsLayout.Parent = optionsList
        
        for i, option in ipairs(options) do
            local optionButton = Instance.new("TextButton")
            optionButton.Name = "Option" .. i
            optionButton.Size = UDim2.new(1, 0, 0, 30)
            optionButton.BackgroundColor3 = Theme.Background
            optionButton.BorderSizePixel = 0
            optionButton.Text = option
            optionButton.TextColor3 = Theme.Text
            optionButton.TextSize = 12
            optionButton.Font = Enum.Font.Gotham
            optionButton.Parent = optionsList
            
            optionButton.MouseEnter:Connect(function()
                CreateTween(optionButton, {BackgroundColor3 = Theme.Surface}, AnimationSettings.HoverSpeed):Play()
            end)
            
            optionButton.MouseLeave:Connect(function()
                CreateTween(optionButton, {BackgroundColor3 = Theme.Background}, AnimationSettings.HoverSpeed):Play()
            end)
            
            optionButton.MouseButton1Click:Connect(function()
                currentValue = option
                dropdownButton.Text = option .. " ▼"
                optionsList.Visible = false
                isOpen = false
                pcall(callback, option)
            end)
        end
        
        return optionsList
    end
    
    local optionsList = createOptionsList()
    
    dropdownButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        optionsList.Visible = isOpen
        dropdownButton.Text = currentValue .. (isOpen and " ▲" or " ▼")
    end)
    
    return {
        Frame = dropdownFrame,
        GetValue = function() return currentValue end,
        SetValue = function(value)
            currentValue = value
            dropdownButton.Text = value .. " ▼"
        end
    }
end

-- Add components to tab
function Components:AddToTab(tab)
    tab.CreateButton = function(config) return self:CreateButton(tab, config) end
    tab.CreateToggle = function(config) return self:CreateToggle(tab, config) end
    tab.CreateLabel = function(config) return self:CreateLabel(tab, config) end
    tab.CreateSection = function(config) return self:CreateSection(tab, config) end
    tab.CreateSlider = function(config) return self:CreateSlider(tab, config) end
    tab.CreateDropdown = function(config) return self:CreateDropdown(tab, config) end
end

return Components
