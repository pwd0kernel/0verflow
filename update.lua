-- 0verflow Hub - Minecraft Edition UI Library
-- Dark Purple Theme with Minecraft-style aesthetics

local MinecraftUI = {}
MinecraftUI.__index = MinecraftUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")

-- Minecraft Dark Purple Theme
local Theme = {
    -- Main purple palette
    DeepPurple = Color3.fromRGB(25, 15, 35),      -- Deep background
    DarkPurple = Color3.fromRGB(45, 25, 65),      -- Main background
    Purple = Color3.fromRGB(85, 45, 125),         -- Primary purple
    BrightPurple = Color3.fromRGB(125, 65, 185),  -- Bright accent
    LightPurple = Color3.fromRGB(165, 105, 225),  -- Light purple
    GlowPurple = Color3.fromRGB(185, 125, 245),   -- Glow effect
    
    -- Minecraft-style colors
    Stone = Color3.fromRGB(55, 55, 65),           -- Stone gray
    Obsidian = Color3.fromRGB(15, 10, 25),        -- Obsidian black
    EnderPearl = Color3.fromRGB(105, 185, 175),   -- Ender pearl cyan
    EnchantGlow = Color3.fromRGB(165, 105, 255),  -- Enchantment purple
    
    -- Text colors
    TextWhite = Color3.fromRGB(245, 245, 245),
    TextGray = Color3.fromRGB(165, 165, 175),
    TextDark = Color3.fromRGB(85, 85, 95),
    TextGold = Color3.fromRGB(255, 215, 85),      -- Minecraft gold
    
    -- State colors
    Success = Color3.fromRGB(85, 255, 85),        -- Minecraft green
    Error = Color3.fromRGB(255, 85, 85),          -- Minecraft red
    Warning = Color3.fromRGB(255, 215, 85),       -- Gold warning
    
    -- Fonts
    PixelFont = Enum.Font.SourceSans,
    BoldFont = Enum.Font.SourceSansBold
}

-- Minecraft ASCII Art
local MINECRAFT_LOGO = [[
╔═══════════════════════════╗
║  0VERFLOW HUB - MC EDITION║
║     ⚒ ENCHANTED UI ⚒     ║
╚═══════════════════════════╝
]]

-- Utility Functions
local function PlayMinecraftSound(soundType)
    -- Placeholder for Minecraft-style sound effects
    local sound = Instance.new("Sound")
    sound.Volume = 0.3
    sound.Parent = workspace
    
    if soundType == "click" then
        sound.SoundId = "rbxasset://sounds/uuhhh.mp3"
        sound.PlaybackSpeed = 1.5
    elseif soundType == "hover" then
        sound.SoundId = "rbxasset://sounds/clickfast.mp3"
        sound.PlaybackSpeed = 2
    end
    
    sound:Play()
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
end

local function CreateBlockyTween(instance, properties, duration)
    -- Minecraft-style stepped animation
    local steps = 8
    local stepDuration = duration / steps
    
    task.spawn(function()
        local startProps = {}
        for prop, _ in pairs(properties) do
            startProps[prop] = instance[prop]
        end
        
        for i = 1, steps do
            local progress = i / steps
            for prop, targetValue in pairs(properties) do
                local startValue = startProps[prop]
                
                if typeof(targetValue) == "Color3" then
                    instance[prop] = startValue:Lerp(targetValue, progress)
                elseif typeof(targetValue) == "UDim2" then
                    instance[prop] = startValue:Lerp(targetValue, progress)
                elseif typeof(targetValue) == "number" then
                    instance[prop] = startValue + (targetValue - startValue) * progress
                end
            end
            task.wait(stepDuration)
        end
    end)
end

local function CreatePixelBorder(parent, thickness)
    -- Create Minecraft-style pixelated border
    local borders = {}
    
    -- Top border
    local topBorder = Instance.new("Frame")
    topBorder.BackgroundColor3 = Theme.Obsidian
    topBorder.BorderSizePixel = 0
    topBorder.Position = UDim2.new(0, 0, 0, 0)
    topBorder.Size = UDim2.new(1, 0, 0, thickness)
    topBorder.Parent = parent
    table.insert(borders, topBorder)
    
    -- Bottom border
    local bottomBorder = Instance.new("Frame")
    bottomBorder.BackgroundColor3 = Theme.Obsidian
    bottomBorder.BorderSizePixel = 0
    bottomBorder.Position = UDim2.new(0, 0, 1, -thickness)
    bottomBorder.Size = UDim2.new(1, 0, 0, thickness)
    bottomBorder.Parent = parent
    table.insert(borders, bottomBorder)
    
    -- Left border
    local leftBorder = Instance.new("Frame")
    leftBorder.BackgroundColor3 = Theme.Obsidian
    leftBorder.BorderSizePixel = 0
    leftBorder.Position = UDim2.new(0, 0, 0, 0)
    leftBorder.Size = UDim2.new(0, thickness, 1, 0)
    leftBorder.Parent = parent
    table.insert(borders, leftBorder)
    
    -- Right border
    local rightBorder = Instance.new("Frame")
    rightBorder.BackgroundColor3 = Theme.Obsidian
    rightBorder.BorderSizePixel = 0
    rightBorder.Position = UDim2.new(1, -thickness, 0, 0)
    rightBorder.Size = UDim2.new(0, thickness, 1, 0)
    rightBorder.Parent = parent
    table.insert(borders, rightBorder)
    
    return borders
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
function MinecraftUI:CreateWindow(config)
    config = config or {}
    local windowName = config.Name or "0VERFLOW HUB - MINECRAFT EDITION"
    local windowSize = config.Size or UDim2.new(0, 750, 0, 520)
    local hideKey = config.HideKey or Enum.KeyCode.RightShift
    
    -- Create ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "0verflowHub_MC_" .. HttpService:GenerateGUID(false)
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = CoreGui
    
    -- Main Frame (Minecraft window style)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.BackgroundColor3 = Theme.DarkPurple
    mainFrame.BorderSizePixel = 0
    mainFrame.Position = UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2)
    mainFrame.Size = windowSize
    mainFrame.Parent = screenGui
    
    -- Pixelated border
    CreatePixelBorder(mainFrame, 3)
    
    -- Inner shadow effect
    local innerShadow = Instance.new("Frame")
    innerShadow.BackgroundColor3 = Theme.Obsidian
    innerShadow.BackgroundTransparency = 0.3
    innerShadow.BorderSizePixel = 0
    innerShadow.Position = UDim2.new(0, 3, 0, 3)
    innerShadow.Size = UDim2.new(1, -6, 1, -6)
    innerShadow.Parent = mainFrame
    
    local shadowGradient = Instance.new("UIGradient")
    shadowGradient.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.1, 0.5),
        NumberSequenceKeypoint.new(1, 1)
    }
    shadowGradient.Parent = innerShadow
    
    -- Title Bar (Minecraft style)
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.BackgroundColor3 = Theme.Purple
    titleBar.BorderSizePixel = 0
    titleBar.Position = UDim2.new(0, 3, 0, 3)
    titleBar.Size = UDim2.new(1, -6, 0, 40)
    titleBar.Parent = mainFrame
    
    CreatePixelBorder(titleBar, 2)
    
    -- Minecraft block icon
    local blockIcon = Instance.new("Frame")
    blockIcon.BackgroundColor3 = Theme.BrightPurple
    blockIcon.BorderSizePixel = 0
    blockIcon.Position = UDim2.new(0, 10, 0.5, -8)
    blockIcon.Size = UDim2.new(0, 16, 0, 16)
    blockIcon.Parent = titleBar
    
    -- Block pattern
    local blockPattern = Instance.new("Frame")
    blockPattern.BackgroundColor3 = Theme.LightPurple
    blockPattern.BorderSizePixel = 0
    blockPattern.Position = UDim2.new(0, 4, 0, 4)
    blockPattern.Size = UDim2.new(0, 8, 0, 8)
    blockPattern.Parent = blockIcon
    
    -- Title text (Minecraft font style)
    local titleText = Instance.new("TextLabel")
    titleText.BackgroundTransparency = 1
    titleText.Position = UDim2.new(0, 35, 0, 0)
    titleText.Size = UDim2.new(0.6, 0, 1, 0)
    titleText.Font = Theme.BoldFont
    titleText.Text = windowName
    titleText.TextColor3 = Theme.TextWhite
    titleText.TextSize = 16
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.TextStrokeColor3 = Theme.Obsidian
    titleText.TextStrokeTransparency = 0.5
    titleText.Parent = titleBar
    
    -- Enchantment glow effect
    local enchantGlow = Instance.new("TextLabel")
    enchantGlow.BackgroundTransparency = 1
    enchantGlow.Position = UDim2.new(0, 35, 0, 0)
    enchantGlow.Size = UDim2.new(0.6, 0, 1, 0)
    enchantGlow.Font = Theme.BoldFont
    enchantGlow.Text = windowName
    enchantGlow.TextColor3 = Theme.EnchantGlow
    enchantGlow.TextSize = 16
    enchantGlow.TextXAlignment = Enum.TextXAlignment.Left
    enchantGlow.TextTransparency = 0.7
    enchantGlow.Parent = titleBar
    
    -- Animate enchantment glow
    task.spawn(function()
        while enchantGlow.Parent do
            for i = 0.7, 0.9, 0.01 do
                enchantGlow.TextTransparency = i
                task.wait(0.05)
            end
            for i = 0.9, 0.7, -0.01 do
                enchantGlow.TextTransparency = i
                task.wait(0.05)
            end
        end
    end)
    
    -- Close button (Minecraft X)
    local closeButton = Instance.new("TextButton")
    closeButton.BackgroundColor3 = Theme.Error
    closeButton.BorderSizePixel = 0
    closeButton.Position = UDim2.new(1, -30, 0.5, -10)
    closeButton.Size = UDim2.new(0, 20, 0, 20)
    closeButton.Font = Theme.BoldFont
    closeButton.Text = "X"
    closeButton.TextColor3 = Theme.TextWhite
    closeButton.TextSize = 14
    closeButton.Parent = titleBar
    
    CreatePixelBorder(closeButton, 1)
    
    closeButton.MouseEnter:Connect(function()
        CreateBlockyTween(closeButton, {BackgroundColor3 = Color3.fromRGB(255, 100, 100)}, 0.1)
    end)
    
    closeButton.MouseLeave:Connect(function()
        CreateBlockyTween(closeButton, {BackgroundColor3 = Theme.Error}, 0.1)
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        PlayMinecraftSound("click")
        
        -- Minecraft destroy animation
        for i = 1, 10 do
            mainFrame.Rotation = math.random(-5, 5)
            mainFrame.BackgroundTransparency = i * 0.1
            task.wait(0.05)
        end
        screenGui:Destroy()
    end)
    
    -- Hotbar-style navigation
    local hotbar = Instance.new("Frame")
    hotbar.BackgroundColor3 = Theme.Stone
    hotbar.BorderSizePixel = 0
    hotbar.Position = UDim2.new(0, 3, 0, 45)
    hotbar.Size = UDim2.new(1, -6, 0, 50)
    hotbar.Parent = mainFrame
    
    CreatePixelBorder(hotbar, 2)
    
    local hotbarLayout = Instance.new("UIListLayout")
    hotbarLayout.FillDirection = Enum.FillDirection.Horizontal
    hotbarLayout.Padding = UDim.new(0, 5)
    hotbarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    hotbarLayout.Parent = hotbar
    
    local hotbarPadding = Instance.new("UIPadding")
    hotbarPadding.PaddingLeft = UDim.new(0, 10)
    hotbarPadding.PaddingRight = UDim.new(0, 10)
    hotbarPadding.PaddingTop = UDim.new(0, 7)
    hotbarPadding.PaddingBottom = UDim.new(0, 7)
    hotbarPadding.Parent = hotbar
    
    -- Content area
    local contentArea = Instance.new("Frame")
    contentArea.BackgroundTransparency = 1
    contentArea.Position = UDim2.new(0, 3, 0, 98)
    contentArea.Size = UDim2.new(1, -6, 1, -101)
    contentArea.Parent = mainFrame
    
    AddDraggable(mainFrame, titleBar)
    
    -- Hide/Show with Minecraft animation
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == hideKey then
            if mainFrame.Visible then
                -- Minecraft close chest animation
                for i = 1, 0, -0.1 do
                    mainFrame.Size = UDim2.new(windowSize.X.Scale, windowSize.X.Offset, 0, windowSize.Y.Offset * i)
                    task.wait(0.02)
                end
                mainFrame.Visible = false
            else
                mainFrame.Visible = true
                -- Minecraft open chest animation
                for i = 0, 1, 0.1 do
                    mainFrame.Size = UDim2.new(windowSize.X.Scale, windowSize.X.Offset, 0, windowSize.Y.Offset * i)
                    task.wait(0.02)
                end
            end
        end
    end)
    
    local Window = {
        Tabs = {},
        CurrentTab = nil,
        TabButtons = {}
    }
    
    function Window:CreateTab(name, icon)
        local Tab = {}
        
        -- Hotbar slot button
        local slotButton = Instance.new("TextButton")
        slotButton.BackgroundColor3 = Theme.DarkPurple
        slotButton.BorderSizePixel = 0
        slotButton.Size = UDim2.new(0, 36, 0, 36)
        slotButton.Font = Theme.BoldFont
        slotButton.Text = icon or "◆"
        slotButton.TextColor3 = Theme.TextGray
        slotButton.TextSize = 18
        slotButton.AutoButtonColor = false
        slotButton.Parent = hotbar
        
        CreatePixelBorder(slotButton, 2)
        
        -- Tooltip
        local tooltip = Instance.new("Frame")
        tooltip.BackgroundColor3 = Theme.Obsidian
        tooltip.BorderSizePixel = 0
        tooltip.Position = UDim2.new(0.5, -40, -1, -5)
        tooltip.Size = UDim2.new(0, 80, 0, 25)
        tooltip.Visible = false
        tooltip.Parent = slotButton
        
        CreatePixelBorder(tooltip, 1)
        
        local tooltipText = Instance.new("TextLabel")
        tooltipText.BackgroundTransparency = 1
        tooltipText.Size = UDim2.new(1, 0, 1, 0)
        tooltipText.Font = Theme.PixelFont
        tooltipText.Text = name
        tooltipText.TextColor3 = Theme.TextWhite
        tooltipText.TextSize = 12
        tooltipText.Parent = tooltip
        
        slotButton.MouseEnter:Connect(function()
            tooltip.Visible = true
            CreateBlockyTween(slotButton, {BackgroundColor3 = Theme.Purple}, 0.1)
        end)
        
        slotButton.MouseLeave:Connect(function()
            tooltip.Visible = false
            if Window.CurrentTab ~= Tab then
                CreateBlockyTween(slotButton, {BackgroundColor3 = Theme.DarkPurple}, 0.1)
            end
        end)
        
        -- Tab content (Minecraft inventory style)
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.BackgroundColor3 = Theme.Stone
        tabContent.BorderSizePixel = 0
        tabContent.Position = UDim2.new(0, 0, 0, 0)
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.ScrollBarThickness = 8
        tabContent.ScrollBarImageColor3 = Theme.Purple
        tabContent.Visible = false
        tabContent.Parent = contentArea
        
        CreatePixelBorder(tabContent, 2)
        
        local contentLayout = Instance.new("UIListLayout")
        contentLayout.Padding = UDim.new(0, 10)
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Parent = tabContent
        
        local contentPadding = Instance.new("UIPadding")
        contentPadding.PaddingLeft = UDim.new(0, 15)
        contentPadding.PaddingRight = UDim.new(0, 15)
        contentPadding.PaddingTop = UDim.new(0, 15)
        contentPadding.PaddingBottom = UDim.new(0, 15)
        contentPadding.Parent = tabContent
        
        contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 30)
        end)
        
        -- Tab selection
        slotButton.MouseButton1Click:Connect(function()
            PlayMinecraftSound("click")
            
            if Window.CurrentTab then
                Window.CurrentTab.Button.BackgroundColor3 = Theme.DarkPurple
                Window.CurrentTab.Button.TextColor3 = Theme.TextGray
                Window.CurrentTab.Content.Visible = false
            end
            
            slotButton.BackgroundColor3 = Theme.BrightPurple
            slotButton.TextColor3 = Theme.TextWhite
            tabContent.Visible = true
            
            -- Selected slot glow
            local selectionGlow = Instance.new("Frame")
            selectionGlow.BackgroundColor3 = Theme.EnchantGlow
            selectionGlow.BackgroundTransparency = 0.5
            selectionGlow.Size = UDim2.new(1, 0, 1, 0)
            selectionGlow.Parent = slotButton
            
            CreateBlockyTween(selectionGlow, {BackgroundTransparency = 1}, 0.3)
            game:GetService("Debris"):AddItem(selectionGlow, 0.3)
            
            Window.CurrentTab = {Button = slotButton, Content = tabContent}
        end)
        
        -- Auto-select first tab
        if #Window.Tabs == 0 then
            slotButton.BackgroundColor3 = Theme.BrightPurple
            slotButton.TextColor3 = Theme.TextWhite
            tabContent.Visible = true
            Window.CurrentTab = {Button = slotButton, Content = tabContent}
        end
        
        -- Tab Elements
        function Tab:AddSection(name)
            local section = Instance.new("Frame")
            section.BackgroundColor3 = Theme.Purple
            section.BorderSizePixel = 0
            section.Size = UDim2.new(1, 0, 0, 30)
            section.Parent = tabContent
            
            CreatePixelBorder(section, 2)
            
            local sectionText = Instance.new("TextLabel")
            sectionText.BackgroundTransparency = 1
            sectionText.Position = UDim2.new(0, 10, 0, 0)
            sectionText.Size = UDim2.new(1, -20, 1, 0)
            sectionText.Font = Theme.BoldFont
            sectionText.Text = "▶ " .. name:upper()
            sectionText.TextColor3 = Theme.TextGold
            sectionText.TextSize = 14
            sectionText.TextXAlignment = Enum.TextXAlignment.Left
            sectionText.Parent = section
            
            return section
        end
        
        function Tab:AddButton(config)
            config = config or {}
            local name = config.Name or "Button"
            local callback = config.Callback or function() end
            
            local button = Instance.new("TextButton")
            button.BackgroundColor3 = Theme.DarkPurple
            button.BorderSizePixel = 0
            button.Size = UDim2.new(1, 0, 0, 40)
            button.Font = Theme.PixelFont
            button.Text = name
            button.TextColor3 = Theme.TextWhite
            button.TextSize = 14
            button.AutoButtonColor = false
            button.Parent = tabContent
            
            CreatePixelBorder(button, 2)
            
            button.MouseEnter:Connect(function()
                CreateBlockyTween(button, {BackgroundColor3 = Theme.Purple}, 0.1)
                PlayMinecraftSound("hover")
            end)
            
            button.MouseLeave:Connect(function()
                CreateBlockyTween(button, {BackgroundColor3 = Theme.DarkPurple}, 0.1)
            end)
            
            button.MouseButton1Click:Connect(function()
                PlayMinecraftSound("click")
                
                -- Minecraft button press effect
                button.Position = UDim2.new(0, 0, 0, button.Position.Y.Offset + 2)
                task.wait(0.1)
                button.Position = UDim2.new(0, 0, 0, button.Position.Y.Offset - 2)
                
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
            toggleFrame.BackgroundColor3 = Theme.DarkPurple
            toggleFrame.BorderSizePixel = 0
            toggleFrame.Size = UDim2.new(1, 0, 0, 40)
            toggleFrame.Parent = tabContent
            
            CreatePixelBorder(toggleFrame, 2)
            
            local toggleLabel = Instance.new("TextLabel")
            toggleLabel.BackgroundTransparency = 1
            toggleLabel.Position = UDim2.new(0, 10, 0, 0)
            toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
            toggleLabel.Font = Theme.PixelFont
            toggleLabel.Text = name
            toggleLabel.TextColor3 = Theme.TextWhite
            toggleLabel.TextSize = 14
            toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            toggleLabel.Parent = toggleFrame
            
            -- Minecraft lever style
            local lever = Instance.new("Frame")
            lever.BackgroundColor3 = Theme.Stone
            lever.Position = UDim2.new(1, -50, 0.5, -10)
            lever.Size = UDim2.new(0, 40, 0, 20)
            lever.Parent = toggleFrame
            
            CreatePixelBorder(lever, 1)
            
            local leverHandle = Instance.new("Frame")
            leverHandle.BackgroundColor3 = default and Theme.Success or Theme.Error
            leverHandle.Position = default and UDim2.new(0.5, 0, 0.5, -8) or UDim2.new(0, 0, 0.5, -8)
            leverHandle.Size = UDim2.new(0, 16, 0, 16)
            leverHandle.Parent = lever
            
            CreatePixelBorder(leverHandle, 1)
            
            local toggled = default
            
            local function updateToggle()
                PlayMinecraftSound("click")
                if toggled then
                    CreateBlockyTween(leverHandle, {
                        Position = UDim2.new(0.5, 0, 0.5, -8),
                        BackgroundColor3 = Theme.Success
                    }, 0.2)
                else
                    CreateBlockyTween(leverHandle, {
                        Position = UDim2.new(0, 0, 0.5, -8),
                        BackgroundColor3 = Theme.Error
                    }, 0.2)
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
            sliderFrame.BackgroundColor3 = Theme.DarkPurple
            sliderFrame.BorderSizePixel = 0
            sliderFrame.Size = UDim2.new(1, 0, 0, 60)
            sliderFrame.Parent = tabContent
            
            CreatePixelBorder(sliderFrame, 2)
            
            local sliderLabel = Instance.new("TextLabel")
            sliderLabel.BackgroundTransparency = 1
            sliderLabel.Position = UDim2.new(0, 10, 0, 5)
            sliderLabel.Size = UDim2.new(0.6, 0, 0, 20)
            sliderLabel.Font = Theme.PixelFont
            sliderLabel.Text = name
            sliderLabel.TextColor3 = Theme.TextWhite
            sliderLabel.TextSize = 14
            sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            sliderLabel.Parent = sliderFrame
            
            local sliderValue = Instance.new("TextLabel")
            sliderValue.BackgroundTransparency = 1
            sliderValue.Position = UDim2.new(0.6, 0, 0, 5)
            sliderValue.Size = UDim2.new(0.4, -10, 0, 20)
            sliderValue.Font = Theme.BoldFont
            sliderValue.Text = tostring(default)
            sliderValue.TextColor3 = Theme.TextGold
            sliderValue.TextSize = 14
            sliderValue.TextXAlignment = Enum.TextXAlignment.Right
            sliderValue.Parent = sliderFrame
            
            -- Minecraft XP bar style
            local sliderBar = Instance.new("Frame")
            sliderBar.BackgroundColor3 = Theme.Stone
            sliderBar.Position = UDim2.new(0, 10, 0, 30)
            sliderBar.Size = UDim2.new(1, -20, 0, 20)
            sliderBar.Parent = sliderFrame
            
            CreatePixelBorder(sliderBar, 1)
            
            local sliderFill = Instance.new("Frame")
            sliderFill.BackgroundColor3 = Theme.EnderPearl
            sliderFill.BorderSizePixel = 0
            sliderFill.Position = UDim2.new(0, 2, 0, 2)
            sliderFill.Size = UDim2.new((default - min) / (max - min), -4, 1, -4)
            sliderFill.Parent = sliderBar
            
            -- XP orb style indicator
            local sliderOrb = Instance.new("Frame")
            sliderOrb.BackgroundColor3 = Theme.TextGold
            sliderOrb.Position = UDim2.new((default - min) / (max - min), -6, 0.5, -6)
            sliderOrb.Size = UDim2.new(0, 12, 0, 12)
            sliderOrb.Parent = sliderBar
            
            CreatePixelBorder(sliderOrb, 1)
            
            local dragging = false
            
            sliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    PlayMinecraftSound("click")
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
                    
                    sliderFill.Size = UDim2.new(percent, -4, 1, -4)
                    sliderOrb.Position = UDim2.new(percent, -6, 0.5, -6)
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
            textboxFrame.BackgroundColor3 = Theme.DarkPurple
            textboxFrame.BorderSizePixel = 0
            textboxFrame.Size = UDim2.new(1, 0, 0, 40)
            textboxFrame.Parent = tabContent
            
            CreatePixelBorder(textboxFrame, 2)
            
            -- Minecraft sign style
            local signIcon = Instance.new("TextLabel")
            signIcon.BackgroundTransparency = 1
            signIcon.Position = UDim2.new(0, 10, 0.5, -8)
            signIcon.Size = UDim2.new(0, 16, 0, 16)
            signIcon.Font = Theme.BoldFont
            signIcon.Text = "📝"
            signIcon.TextColor3 = Theme.TextGray
            signIcon.TextSize = 14
            signIcon.Parent = textboxFrame
            
            local textbox = Instance.new("TextBox")
            textbox.BackgroundColor3 = Theme.Obsidian
            textbox.BorderSizePixel = 0
            textbox.Position = UDim2.new(0, 35, 0.5, -12)
            textbox.Size = UDim2.new(1, -45, 0, 24)
            textbox.Font = Theme.PixelFont
            textbox.PlaceholderText = placeholder
            textbox.PlaceholderColor3 = Theme.TextDark
            textbox.Text = ""
            textbox.TextColor3 = Theme.TextWhite
            textbox.TextSize = 12
            textbox.TextXAlignment = Enum.TextXAlignment.Left
            textbox.ClearTextOnFocus = false
            textbox.Parent = textboxFrame
            
            CreatePixelBorder(textbox, 1)
            
            local textPadding = Instance.new("UIPadding")
            textPadding.PaddingLeft = UDim.new(0, 5)
            textPadding.Parent = textbox
            
            textbox.Focused:Connect(function()
                PlayMinecraftSound("click")
                CreateBlockyTween(textbox, {BackgroundColor3 = Theme.Stone}, 0.1)
            end)
            
            textbox.FocusLost:Connect(function(enterPressed)
                CreateBlockyTween(textbox, {BackgroundColor3 = Theme.Obsidian}, 0.1)
                callback(textbox.Text, enterPressed)
            end)
            
            return textboxFrame
        end
        
        function Tab:AddDropdown(config)
            config = config or {}
            local name = config.Name or "Dropdown"
            local options = config.Options or {}
            local default = config.Default or options[1]
            local callback = config.Callback or function() end
            
            local dropdownFrame = Instance.new("Frame")
            dropdownFrame.BackgroundColor3 = Theme.DarkPurple
            dropdownFrame.BorderSizePixel = 0
            dropdownFrame.Size = UDim2.new(1, 0, 0, 40)
            dropdownFrame.Parent = tabContent
            
            CreatePixelBorder(dropdownFrame, 2)
            
            local dropdownLabel = Instance.new("TextLabel")
            dropdownLabel.BackgroundTransparency = 1
            dropdownLabel.Position = UDim2.new(0, 10, 0, 0)
            dropdownLabel.Size = UDim2.new(0.4, 0, 1, 0)
            dropdownLabel.Font = Theme.PixelFont
            dropdownLabel.Text = name
            dropdownLabel.TextColor3 = Theme.TextWhite
            dropdownLabel.TextSize = 14
            dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            dropdownLabel.Parent = dropdownFrame
            
            local dropdownButton = Instance.new("TextButton")
            dropdownButton.BackgroundColor3 = Theme.Stone
            dropdownButton.BorderSizePixel = 0
            dropdownButton.Position = UDim2.new(0.4, 5, 0.5, -12)
            dropdownButton.Size = UDim2.new(0.6, -15, 0, 24)
            dropdownButton.Font = Theme.PixelFont
            dropdownButton.Text = default or "Select..."
            dropdownButton.TextColor3 = Theme.TextWhite
            dropdownButton.TextSize = 12
            dropdownButton.AutoButtonColor = false
            dropdownButton.Parent = dropdownFrame
            
            CreatePixelBorder(dropdownButton, 1)
            
            local dropdownArrow = Instance.new("TextLabel")
            dropdownArrow.BackgroundTransparency = 1
            dropdownArrow.Position = UDim2.new(1, -20, 0, 0)
            dropdownArrow.Size = UDim2.new(0, 20, 1, 0)
            dropdownArrow.Font = Theme.BoldFont
            dropdownArrow.Text = "▼"
            dropdownArrow.TextColor3 = Theme.TextGray
            dropdownArrow.TextSize = 10
            dropdownArrow.Parent = dropdownButton
            
            local dropdownList = Instance.new("Frame")
            dropdownList.BackgroundColor3 = Theme.Obsidian
            dropdownList.BorderSizePixel = 0
            dropdownList.Position = UDim2.new(0, 0, 1, 2)
            dropdownList.Size = UDim2.new(1, 0, 0, 0)
            dropdownList.ClipsDescendants = true
            dropdownList.Visible = false
            dropdownList.Parent = dropdownButton
            
            CreatePixelBorder(dropdownList, 1)
            
            local listLayout = Instance.new("UIListLayout")
            listLayout.SortOrder = Enum.SortOrder.LayoutOrder
            listLayout.Parent = dropdownList
            
            local expanded = false
            
            for _, option in ipairs(options) do
                local optionButton = Instance.new("TextButton")
                optionButton.BackgroundColor3 = Theme.Stone
                optionButton.BorderSizePixel = 0
                optionButton.Size = UDim2.new(1, 0, 0, 24)
                optionButton.Font = Theme.PixelFont
                optionButton.Text = option
                optionButton.TextColor3 = Theme.TextWhite
                optionButton.TextSize = 12
                optionButton.AutoButtonColor = false
                optionButton.Parent = dropdownList
                
                optionButton.MouseEnter:Connect(function()
                    CreateBlockyTween(optionButton, {BackgroundColor3 = Theme.Purple}, 0.1)
                end)
                
                optionButton.MouseLeave:Connect(function()
                    CreateBlockyTween(optionButton, {BackgroundColor3 = Theme.Stone}, 0.1)
                end)
                
                optionButton.MouseButton1Click:Connect(function()
                    PlayMinecraftSound("click")
                    dropdownButton.Text = option
                    callback(option)
                    
                    expanded = false
                    dropdownList.Visible = false
                    dropdownList.Size = UDim2.new(1, 0, 0, 0)
                    dropdownArrow.Text = "▼"
                end)
            end
            
            dropdownButton.MouseButton1Click:Connect(function()
                PlayMinecraftSound("click")
                expanded = not expanded
                
                if expanded then
                    dropdownList.Visible = true
                    dropdownList.Size = UDim2.new(1, 0, 0, #options * 24)
                    dropdownArrow.Text = "▲"
                else
                    dropdownList.Visible = false
                    dropdownList.Size = UDim2.new(1, 0, 0, 0)
                    dropdownArrow.Text = "▼"
                end
            end)
            
            return dropdownFrame
        end
        
        table.insert(Window.Tabs, Tab)
        return Tab
    end
    
    -- Opening animation (Minecraft style)
    mainFrame.Size = UDim2.new(0, windowSize.X.Offset, 0, 0)
    mainFrame.ClipsDescendants = true
    
    for i = 0, windowSize.Y.Offset, windowSize.Y.Offset / 10 do
        mainFrame.Size = UDim2.new(0, windowSize.X.Offset, 0, i)
        task.wait(0.02)
    end
    
    return Window
end

return MinecraftUI
