-- Created for pwd0kernel

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer

-- Minimal Color Palette
local Theme = {
    Background = Color3.fromRGB(15, 15, 17),      -- Almost black
    Surface = Color3.fromRGB(20, 20, 23),         -- Slightly lighter
    Card = Color3.fromRGB(25, 25, 28),            -- Card background
    
    Accent = Color3.fromRGB(120, 80, 255),        -- Soft purple
    AccentHover = Color3.fromRGB(140, 100, 255),  -- Lighter purple
    AccentDim = Color3.fromRGB(80, 50, 180),      -- Darker purple
    
    Text = Color3.fromRGB(255, 255, 255),         -- Pure white
    TextDim = Color3.fromRGB(160, 160, 165),      -- Muted text
    TextDark = Color3.fromRGB(100, 100, 105),     -- Dark text
    
    Success = Color3.fromRGB(80, 250, 150),       -- Soft green
    Warning = Color3.fromRGB(255, 200, 100),      -- Soft orange
    Error = Color3.fromRGB(255, 100, 100),        -- Soft red
    
    Transparent = Color3.fromRGB(0, 0, 0)
}

-- Detect if mobile
local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Create ScreenGui with ZIndex management
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "0verflowMinimal"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999999 -- Always on top

pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
end

-- Utility Functions
local function Tween(obj, props, duration)
    duration = duration or 0.2
    local tween = TweenService:Create(
        obj,
        TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        props
    )
    tween:Play()
    return tween
end

-- Main Library
local Library = {}
Library.Windows = {}

function Library:CreateWindow(title)
    local Window = {}
    Window.Tabs = {}
    Window.ActiveTab = nil
    Window.Minimized = false
    
    -- Calculate responsive sizes
    local screenSize = workspace.CurrentCamera.ViewportSize
    local windowWidth = IsMobile and math.min(screenSize.X - 40, 500) or 560
    local windowHeight = IsMobile and math.min(screenSize.Y - 100, 420) or 480
    
    -- Minimal Floating Bar (Clean and sleek)
    local ToggleBar = Instance.new("Frame")
    ToggleBar.Name = "ToggleBar"
    ToggleBar.Parent = ScreenGui
    ToggleBar.BackgroundColor3 = Theme.Background
    ToggleBar.BackgroundTransparency = 0.1
    ToggleBar.BorderSizePixel = 0
    ToggleBar.Position = UDim2.new(0.5, -60, 1, -50)
    ToggleBar.Size = UDim2.new(0, 120, 0, 32)
    ToggleBar.Visible = false
    ToggleBar.ZIndex = 999
    ToggleBar.ClipsDescendants = true
    
    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(0, 16)
    BarCorner.Parent = ToggleBar
    
    -- Subtle border stroke
    local BarStroke = Instance.new("UIStroke")
    BarStroke.Parent = ToggleBar
    BarStroke.Color = Theme.Accent
    BarStroke.Thickness = 1
    BarStroke.Transparency = 0.7
    
    -- Text container for proper alignment
    local TextContainer = Instance.new("Frame")
    TextContainer.Parent = ToggleBar
    TextContainer.BackgroundTransparency = 1
    TextContainer.Size = UDim2.new(1, 0, 1, 0)
    TextContainer.Position = UDim2.new(0, 0, 0, 0)
    
    -- "0verflow" text in purple
    local Text0verflow = Instance.new("TextLabel")
    Text0verflow.Parent = TextContainer
    Text0verflow.BackgroundTransparency = 1
    Text0verflow.Position = UDim2.new(0.5, -30, 0.5, -8)
    Text0verflow.Size = UDim2.new(0, 50, 0, 16)
    Text0verflow.Font = Enum.Font.GothamBold
    Text0verflow.Text = "0verflow"
    Text0verflow.TextColor3 = Theme.Accent
    Text0verflow.TextSize = 13
    Text0verflow.TextXAlignment = Enum.TextXAlignment.Right
    Text0verflow.ZIndex = 1000
    
    -- "Hub" text in white
    local TextHub = Instance.new("TextLabel")
    TextHub.Parent = TextContainer
    TextHub.BackgroundTransparency = 1
    TextHub.Position = UDim2.new(0.5, 22, 0.5, -8)
    TextHub.Size = UDim2.new(0, 25, 0, 16)
    TextHub.Font = Enum.Font.Gotham
    TextHub.Text = "Hub"
    TextHub.TextColor3 = Theme.Text
    TextHub.TextSize = 13
    TextHub.TextXAlignment = Enum.TextXAlignment.Left
    TextHub.ZIndex = 1000
    
    -- Small dot indicator (shows UI is minimized)
    local Indicator = Instance.new("Frame")
    Indicator.Parent = ToggleBar
    Indicator.BackgroundColor3 = Theme.Success
    Indicator.BorderSizePixel = 0
    Indicator.Position = UDim2.new(0, 10, 0.5, -3)
    Indicator.Size = UDim2.new(0, 6, 0, 6)
    Indicator.ZIndex = 1000
    
    local IndicatorCorner = Instance.new("UICorner")
    IndicatorCorner.CornerRadius = UDim.new(1, 0)
    IndicatorCorner.Parent = Indicator
    
    -- Pulse animation for indicator
    spawn(function()
        while ToggleBar.Parent do
            if ToggleBar.Visible then
                Tween(Indicator, {BackgroundTransparency = 0.3}, 1)
                wait(1)
                Tween(Indicator, {BackgroundTransparency = 0}, 1)
                wait(1)
            else
                wait(0.5)
            end
        end
    end)
    
    -- Make toggle bar interactive
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Parent = ToggleBar
    ToggleBtn.BackgroundTransparency = 1
    ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
    ToggleBtn.Text = ""
    ToggleBtn.ZIndex = 1001
    
    -- Hover effects
    ToggleBtn.MouseEnter:Connect(function()
        Tween(ToggleBar, {BackgroundTransparency = 0})
        Tween(BarStroke, {Transparency = 0.3})
        Tween(Text0verflow, {TextColor3 = Theme.AccentHover})
    end)
    
    ToggleBtn.MouseLeave:Connect(function()
        Tween(ToggleBar, {BackgroundTransparency = 0.1})
        Tween(BarStroke, {Transparency = 0.7})
        Tween(Text0verflow, {TextColor3 = Theme.Accent})
    end)
    
    -- Main Container with proper rounded corners
    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Parent = ScreenGui
    Container.BackgroundColor3 = Theme.Background
    Container.BorderSizePixel = 0
    Container.Position = UDim2.new(0.5, -windowWidth/2, 0.5, -windowHeight/2)
    Container.Size = UDim2.new(0, windowWidth, 0, windowHeight)
    Container.ClipsDescendants = true
    
    local ContainerCorner = Instance.new("UICorner")
    ContainerCorner.CornerRadius = UDim.new(0, 10)
    ContainerCorner.Parent = Container
    
    -- Header (completely transparent)
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Parent = Container
    Header.BackgroundTransparency = 1
    Header.BorderSizePixel = 0
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.ZIndex = 2
    
    -- Header separator line
    local HeaderSeparator = Instance.new("Frame")
    HeaderSeparator.Parent = Container
    HeaderSeparator.BackgroundColor3 = Theme.Accent
    HeaderSeparator.BackgroundTransparency = 0.8
    HeaderSeparator.BorderSizePixel = 0
    HeaderSeparator.Position = UDim2.new(0, 0, 0, 40)
    HeaderSeparator.Size = UDim2.new(1, 0, 0, 1)
    HeaderSeparator.ZIndex = 3
    
    -- Title Container
    local TitleContainer = Instance.new("Frame")
    TitleContainer.Parent = Header
    TitleContainer.BackgroundTransparency = 1
    TitleContainer.Position = UDim2.new(0, 16, 0, 0)
    TitleContainer.Size = UDim2.new(0.5, 0, 1, 0)
    TitleContainer.ZIndex = 3
    
    -- "0verflow" in purple
    local Title0verflow = Instance.new("TextLabel")
    Title0verflow.Parent = TitleContainer
    Title0verflow.BackgroundTransparency = 1
    Title0verflow.Position = UDim2.new(0, 0, 0, 0)
    Title0verflow.Size = UDim2.new(0, 0, 1, 0)
    Title0verflow.AutomaticSize = Enum.AutomaticSize.X
    Title0verflow.Font = Enum.Font.GothamBold
    Title0verflow.Text = "0verflow"
    Title0verflow.TextColor3 = Theme.Accent
    Title0verflow.TextSize = IsMobile and 13 or 14
    Title0verflow.TextXAlignment = Enum.TextXAlignment.Left
    Title0verflow.ZIndex = 3
    
    -- "Hub" in white
    local TitleHub = Instance.new("TextLabel")
    TitleHub.Parent = TitleContainer
    TitleHub.BackgroundTransparency = 1
    TitleHub.Position = UDim2.new(0, IsMobile and 52 or 58, 0, 0)
    TitleHub.Size = UDim2.new(0, 0, 1, 0)
    TitleHub.AutomaticSize = Enum.AutomaticSize.X
    TitleHub.Font = Enum.Font.Gotham
    TitleHub.Text = " Hub"
    TitleHub.TextColor3 = Theme.Text
    TitleHub.TextSize = IsMobile and 13 or 14
    TitleHub.TextXAlignment = Enum.TextXAlignment.Left
    TitleHub.ZIndex = 3
    
    -- Close button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Parent = Header
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Position = UDim2.new(1, -40, 0.5, -12)
    CloseBtn.Size = UDim2.new(0, 24, 0, 24)
    CloseBtn.Font = Enum.Font.Gotham
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = Theme.TextDim
    CloseBtn.TextSize = 20
    CloseBtn.ZIndex = 3
    
    CloseBtn.MouseEnter:Connect(function()
        Tween(CloseBtn, {TextColor3 = Theme.Error})
    end)
    
    CloseBtn.MouseLeave:Connect(function()
        Tween(CloseBtn, {TextColor3 = Theme.TextDim})
    end)
    
    CloseBtn.MouseButton1Click:Connect(function()
        Tween(Container, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.3)
        Tween(ToggleBar, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, 0.3)
        wait(0.3)
        ScreenGui:Destroy()
    end)
    
    -- Minimize button
    local MinBtn = Instance.new("TextButton")
    MinBtn.Parent = Header
    MinBtn.BackgroundTransparency = 1
    MinBtn.Position = UDim2.new(1, -70, 0.5, -12)
    MinBtn.Size = UDim2.new(0, 24, 0, 24)
    MinBtn.Font = Enum.Font.Gotham
    MinBtn.Text = "—"
    MinBtn.TextColor3 = Theme.TextDim
    MinBtn.TextSize = 16
    MinBtn.ZIndex = 3
    
    MinBtn.MouseEnter:Connect(function()
        Tween(MinBtn, {TextColor3 = Theme.Text})
    end)
    
    MinBtn.MouseLeave:Connect(function()
        Tween(MinBtn, {TextColor3 = Theme.TextDim})
    end)
    
    -- Minimize function
    local function Minimize()
        Window.Minimized = true
        -- Smooth minimize animation
        Tween(Container, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 1, -25)
        }, 0.3)
        
        wait(0.3)
        Container.Visible = false
        ToggleBar.Visible = true
        
        -- Animate toggle bar in from bottom
        ToggleBar.Position = UDim2.new(0.5, -60, 1, 0)
        Tween(ToggleBar, {
            Position = UDim2.new(0.5, -60, 1, -50)
        }, 0.3, Enum.EasingStyle.Back)
    end
    
    -- Restore function
    local function Restore()
        Window.Minimized = false
        -- Animate toggle bar out
        Tween(ToggleBar, {
            Position = UDim2.new(0.5, -60, 1, 0)
        }, 0.3)
        
        wait(0.3)
        ToggleBar.Visible = false
        Container.Visible = true
        
        -- Animate container in
        Container.Size = UDim2.new(0, 0, 0, 0)
        Container.Position = UDim2.new(0.5, 0, 0.5, 0)
        
        Tween(Container, {
            Size = UDim2.new(0, windowWidth, 0, windowHeight),
            Position = UDim2.new(0.5, -windowWidth/2, 0.5, -windowHeight/2)
        }, 0.3, Enum.EasingStyle.Back)
    end
    
    MinBtn.MouseButton1Click:Connect(Minimize)
    ToggleBtn.MouseButton1Click:Connect(Restore)
    
    -- Small purple accent under title
    local HeaderAccent = Instance.new("Frame")
    HeaderAccent.Parent = Container
    HeaderAccent.BackgroundColor3 = Theme.Accent
    HeaderAccent.BorderSizePixel = 0
    HeaderAccent.Position = UDim2.new(0, 16, 0, 39)
    HeaderAccent.Size = UDim2.new(0, 30, 0, 1)
    HeaderAccent.BackgroundTransparency = 0.3
    HeaderAccent.ZIndex = 3
    
    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Parent = Container
    TabContainer.BackgroundTransparency = 1
    TabContainer.Position = UDim2.new(0, 0, 0, 41)
    TabContainer.Size = UDim2.new(1, 0, 0, 36)
    
    local TabList = Instance.new("ScrollingFrame")
    TabList.Parent = TabContainer
    TabList.BackgroundTransparency = 1
    TabList.BorderSizePixel = 0
    TabList.Position = UDim2.new(0, IsMobile and 8 or 16, 0, 0)
    TabList.Size = UDim2.new(1, IsMobile and -16 or -32, 1, 0)
    TabList.ScrollBarThickness = 0
    TabList.ScrollingDirection = Enum.ScrollingDirection.X
    TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Parent = TabList
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, IsMobile and 4 or 8)
    
    -- Content Area
    local Content = Instance.new("Frame")
    Content.Parent = Container
    Content.BackgroundTransparency = 1
    Content.Position = UDim2.new(0, 0, 0, 77)
    Content.Size = UDim2.new(1, 0, 1, -77)
    
    -- Dragging for desktop
    if not IsMobile then
        local dragging, dragStart, startPos
        
        Header.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = Container.Position
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                Container.Position = UDim2.new(
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
        
        -- Allow dragging the minimize bar
        local barDragging, barDragStart, barStartPos
        
        ToggleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                barDragging = true
                barDragStart = input.Position
                barStartPos = ToggleBar.Position
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if barDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - barDragStart
                -- Only allow horizontal movement
                ToggleBar.Position = UDim2.new(
                    barStartPos.X.Scale,
                    barStartPos.X.Offset + delta.X,
                    barStartPos.Y.Scale,
                    barStartPos.Y.Offset
                )
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                barDragging = false
            end
        end)
    end
    
    -- Create Tab Function
    function Window:Tab(name)
        local Tab = {}
        Tab.Name = name
        
        -- Tab Button
        local TabBtn = Instance.new("TextButton")
        TabBtn.Parent = TabList
        TabBtn.BackgroundTransparency = 1
        TabBtn.Size = UDim2.new(0, 0, 1, 0)
        TabBtn.AutomaticSize = Enum.AutomaticSize.X
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.Text = name
        TabBtn.TextColor3 = Theme.TextDim
        TabBtn.TextSize = IsMobile and 12 or 13
        
        local TabPadding = Instance.new("UIPadding")
        TabPadding.Parent = TabBtn
        TabPadding.PaddingLeft = UDim.new(0, IsMobile and 8 or 12)
        TabPadding.PaddingRight = UDim.new(0, IsMobile and 8 or 12)
        
        -- Tab Underline
        local Underline = Instance.new("Frame")
        Underline.Parent = TabBtn
        Underline.BackgroundColor3 = Theme.Accent
        Underline.BorderSizePixel = 0
        Underline.Position = UDim2.new(0, 0, 1, -2)
        Underline.Size = UDim2.new(1, 0, 0, 2)
        Underline.Visible = false
        
        -- Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Parent = Content
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.Position = UDim2.new(0, IsMobile and 8 or 16, 0, 0)
        TabContent.Size = UDim2.new(1, IsMobile and -16 or -32, 1, IsMobile and -8 or -16)
        TabContent.ScrollBarThickness = IsMobile and 3 or 2
        TabContent.ScrollBarImageColor3 = Theme.Accent
        TabContent.ScrollBarImageTransparency = 0.5
        TabContent.Visible = false
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Parent = TabContent
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Padding = UDim.new(0, 8)
        
        -- Auto-resize canvas
        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
        end)
        
        -- Tab Selection
        TabBtn.MouseButton1Click:Connect(function()
            for _, tab in pairs(Window.Tabs) do
                tab.Button.TextColor3 = Theme.TextDim
                tab.Underline.Visible = false
                tab.Content.Visible = false
            end
            
            TabBtn.TextColor3 = Theme.Text
            Underline.Visible = true
            TabContent.Visible = true
            Window.ActiveTab = Tab
        end)
        
        -- Hover effect (Desktop only)
        if not IsMobile then
            TabBtn.MouseEnter:Connect(function()
                if Window.ActiveTab ~= Tab then
                    Tween(TabBtn, {TextColor3 = Theme.Text})
                end
            end)
            
            TabBtn.MouseLeave:Connect(function()
                if Window.ActiveTab ~= Tab then
                    Tween(TabBtn, {TextColor3 = Theme.TextDim})
                end
            end)
        end
        
        -- Section Function
        function Tab:Section(title)
            local Section = {}
            
            -- Section Container
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Parent = TabContent
            SectionFrame.BackgroundColor3 = Theme.Surface
            SectionFrame.BorderSizePixel = 0
            SectionFrame.Size = UDim2.new(1, 0, 0, 0)
            SectionFrame.AutomaticSize = Enum.AutomaticSize.Y
            SectionFrame.ClipsDescendants = true
            
            local SectionCorner = Instance.new("UICorner")
            SectionCorner.CornerRadius = UDim.new(0, 8)
            SectionCorner.Parent = SectionFrame
            
            -- Section Title
            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Parent = SectionFrame
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Position = UDim2.new(0, 12, 0, 12)
            SectionTitle.Size = UDim2.new(1, -24, 0, 14)
            SectionTitle.Font = Enum.Font.Gotham
            SectionTitle.Text = title
            SectionTitle.TextColor3 = Theme.TextDim
            SectionTitle.TextSize = IsMobile and 11 or 12
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            -- Section Accent
            local SectionAccent = Instance.new("Frame")
            SectionAccent.Parent = SectionFrame
            SectionAccent.BackgroundColor3 = Theme.Accent
            SectionAccent.BorderSizePixel = 0
            SectionAccent.Position = UDim2.new(0, 4, 0, 14)
            SectionAccent.Size = UDim2.new(0, 2, 0, 10)
            
            local AccentCorner = Instance.new("UICorner")
            AccentCorner.CornerRadius = UDim.new(1, 0)
            AccentCorner.Parent = SectionAccent
            
            -- Elements Container
            local Elements = Instance.new("Frame")
            Elements.Parent = SectionFrame
            Elements.BackgroundTransparency = 1
            Elements.Position = UDim2.new(0, 12, 0, 32)
            Elements.Size = UDim2.new(1, -24, 0, 0)
            Elements.AutomaticSize = Enum.AutomaticSize.Y
            
            local ElementLayout = Instance.new("UIListLayout")
            ElementLayout.Parent = Elements
            ElementLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ElementLayout.Padding = UDim.new(0, 6)
            
            local ElementPadding = Instance.new("UIPadding")
            ElementPadding.Parent = Elements
            ElementPadding.PaddingBottom = UDim.new(0, 12)
            
            -- Toggle
            function Section:Toggle(name, default, callback)
                local toggled = default or false
                
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Parent = Elements
                ToggleFrame.BackgroundTransparency = 1
                ToggleFrame.Size = UDim2.new(1, 0, 0, IsMobile and 36 or 32)
                
                local Label = Instance.new("TextLabel")
                Label.Parent = ToggleFrame
                Label.BackgroundTransparency = 1
                Label.Position = UDim2.new(0, 0, 0, 0)
                Label.Size = UDim2.new(1, -44, 1, 0)
                Label.Font = Enum.Font.Gotham
                Label.Text = name
                Label.TextColor3 = Theme.Text
                Label.TextSize = IsMobile and 12 or 13
                Label.TextXAlignment = Enum.TextXAlignment.Left
                
                local Switch = Instance.new("TextButton")
                Switch.Parent = ToggleFrame
                Switch.BackgroundColor3 = Theme.Card
                Switch.Position = UDim2.new(1, -38, 0.5, -10)
                Switch.Size = UDim2.new(0, 34, 0, 20)
                Switch.Text = ""
                Switch.ClipsDescendants = true
                
                local SwitchCorner = Instance.new("UICorner")
                SwitchCorner.CornerRadius = UDim.new(1, 0)
                SwitchCorner.Parent = Switch
                
                local Knob = Instance.new("Frame")
                Knob.Parent = Switch
                Knob.BackgroundColor3 = Theme.TextDim
                Knob.Position = UDim2.new(0, 2, 0.5, -8)
                Knob.Size = UDim2.new(0, 16, 0, 16)
                
                local KnobCorner = Instance.new("UICorner")
                KnobCorner.CornerRadius = UDim.new(1, 0)
                KnobCorner.Parent = Knob
                
                local function UpdateToggle()
                    if toggled then
                        Tween(Switch, {BackgroundColor3 = Theme.Accent})
                        Tween(Knob, {Position = UDim2.new(1, -18, 0.5, -8), BackgroundColor3 = Theme.Text})
                    else
                        Tween(Switch, {BackgroundColor3 = Theme.Card})
                        Tween(Knob, {Position = UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = Theme.TextDim})
                    end
                    if callback then callback(toggled) end
                end
                
                if default then UpdateToggle() end
                
                Switch.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    UpdateToggle()
                end)
                
                return {
                    Set = function(value)
                        toggled = value
                        UpdateToggle()
                    end
                }
            end
            
            -- Button
            function Section:Button(name, callback)
                local BtnFrame = Instance.new("TextButton")
                BtnFrame.Parent = Elements
                BtnFrame.BackgroundColor3 = Theme.Card
                BtnFrame.Size = UDim2.new(1, 0, 0, IsMobile and 36 or 32)
                BtnFrame.Font = Enum.Font.Gotham
                BtnFrame.Text = name
                BtnFrame.TextColor3 = Theme.Text
                BtnFrame.TextSize = IsMobile and 12 or 13
                BtnFrame.ClipsDescendants = true
                
                local BtnCorner = Instance.new("UICorner")
                BtnCorner.CornerRadius = UDim.new(0, 6)
                BtnCorner.Parent = BtnFrame
                
                BtnFrame.MouseEnter:Connect(function()
                    Tween(BtnFrame, {BackgroundColor3 = Theme.Accent})
                end)
                
                BtnFrame.MouseLeave:Connect(function()
                    Tween(BtnFrame, {BackgroundColor3 = Theme.Card})
                end)
                
                BtnFrame.MouseButton1Click:Connect(function()
                    if callback then callback() end
                end)
            end
            
            return Section
        end
        
        -- Store tab
        Tab.Button = TabBtn
        Tab.Content = TabContent
        Tab.Underline = Underline
        table.insert(Window.Tabs, Tab)
        
        -- Auto-select first tab
        if #Window.Tabs == 1 then
            TabBtn.TextColor3 = Theme.Text
            Underline.Visible = true
            TabContent.Visible = true
            Window.ActiveTab = Tab
        end
        
        -- Update tab list canvas
        TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabList.CanvasSize = UDim2.new(0, TabLayout.AbsoluteContentSize.X + 20, 0, 0)
        end)
        
        return Tab
    end
    
    -- Notification
    function Window:Notify(text, duration)
        duration = duration or 2
        
        local Notif = Instance.new("Frame")
        Notif.Parent = ScreenGui
        Notif.BackgroundColor3 = Theme.Surface
        Notif.BorderSizePixel = 0
        Notif.Position = UDim2.new(0.5, -100, 1, 0)
        Notif.Size = UDim2.new(0, 200, 0, 40)
        Notif.ZIndex = 1000
        Notif.ClipsDescendants = true
        
        local NotifCorner = Instance.new("UICorner")
        NotifCorner.CornerRadius = UDim.new(0, 8)
        NotifCorner.Parent = Notif
        
        local NotifText = Instance.new("TextLabel")
        NotifText.Parent = Notif
        NotifText.BackgroundTransparency = 1
        NotifText.Size = UDim2.new(1, 0, 1, 0)
        NotifText.Font = Enum.Font.Gotham
        NotifText.Text = text
        NotifText.TextColor3 = Theme.Text
        NotifText.TextSize = IsMobile and 12 or 13
        NotifText.ZIndex = 1001
        
        local AccentLine = Instance.new("Frame")
        AccentLine.Parent = Notif
        AccentLine.BackgroundColor3 = Theme.Accent
        AccentLine.BorderSizePixel = 0
        AccentLine.Position = UDim2.new(0, 0, 0, 0)
        AccentLine.Size = UDim2.new(0, 2, 1, 0)
        AccentLine.ZIndex = 1001
        
        -- Position above toggle bar if minimized
        local yPos = Window.Minimized and -100 or -60
        Tween(Notif, {Position = UDim2.new(0.5, -100, 1, yPos)}, 0.3)
        
        task.wait(duration)
        
        Tween(Notif, {Position = UDim2.new(0.5, -100, 1, 0)}, 0.3)
        task.wait(0.3)
        Notif:Destroy()
    end
    
    -- Entrance animation
    Container.Size = UDim2.new(0, 0, 0, 0)
    Container.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    Tween(Container, {
        Size = UDim2.new(0, windowWidth, 0, windowHeight),
        Position = UDim2.new(0.5, -windowWidth/2, 0.5, -windowHeight/2)
    }, 0.4, Enum.EasingStyle.Back)
    
    return Window
end

return Library
