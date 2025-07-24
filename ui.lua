--[[
	0verflow Hub UI Library
	Modern Minimal Design with Left-Side Navigation
	Compatible with Rayfield UI Scripts
]]

local function getService(name)
	local service = game:GetService(name)
	return if cloneref then cloneref(service) else service
end

-- Services
local UserInputService = getService("UserInputService")
local TweenService = getService("TweenService")
local Players = getService("Players")
local CoreGui = getService("CoreGui")
local HttpService = getService("HttpService")
local RunService = getService("RunService")

-- Environment Check
local useStudio = RunService:IsStudio() or false

local OverflowLibrary = {
	Flags = {},
	Theme = {
		Default = {
			-- 0verflow Hub Dark Purple Theme
			Primary = Color3.fromRGB(111, 10, 214), -- #6f0ad6
			PrimaryDark = Color3.fromRGB(85, 8, 162),
			PrimaryLight = Color3.fromRGB(130, 30, 240),
			
			TextColor = Color3.fromRGB(255, 255, 255),
			TextColorSecondary = Color3.fromRGB(180, 180, 180),
			TextColorDim = Color3.fromRGB(120, 120, 120),

			Background = Color3.fromRGB(18, 18, 22), -- Very dark background
			BackgroundSecondary = Color3.fromRGB(25, 25, 30),
			BackgroundTertiary = Color3.fromRGB(30, 30, 36),
			
			SidebarBackground = Color3.fromRGB(22, 22, 28),
			SidebarHover = Color3.fromRGB(35, 35, 42),
			
			ElementBackground = Color3.fromRGB(28, 28, 34),
			ElementBackgroundHover = Color3.fromRGB(35, 35, 42),
			ElementStroke = Color3.fromRGB(45, 45, 52),
			
			TabBackground = Color3.fromRGB(28, 28, 34),
			TabBackgroundSelected = Color3.fromRGB(111, 10, 214),
			TabStroke = Color3.fromRGB(45, 45, 52),
			TabTextColor = Color3.fromRGB(180, 180, 180),
			SelectedTabTextColor = Color3.fromRGB(255, 255, 255),

			ToggleEnabled = Color3.fromRGB(111, 10, 214),
			ToggleDisabled = Color3.fromRGB(60, 60, 66),
			ToggleKnob = Color3.fromRGB(255, 255, 255),
			
			SliderTrack = Color3.fromRGB(45, 45, 52),
			SliderFill = Color3.fromRGB(111, 10, 214),
			SliderKnob = Color3.fromRGB(255, 255, 255),
			
			InputBackground = Color3.fromRGB(28, 28, 34),
			InputStroke = Color3.fromRGB(45, 45, 52),
			InputStrokeFocused = Color3.fromRGB(111, 10, 214),
			PlaceholderColor = Color3.fromRGB(120, 120, 120),
			
			ButtonBackground = Color3.fromRGB(111, 10, 214),
			ButtonBackgroundHover = Color3.fromRGB(130, 30, 240),
			ButtonText = Color3.fromRGB(255, 255, 255),
			
			DropdownBackground = Color3.fromRGB(28, 28, 34),
			DropdownHover = Color3.fromRGB(35, 35, 42),
			DropdownSelected = Color3.fromRGB(111, 10, 214),
			
			AccentGradient = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(111, 10, 214)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(130, 30, 240))
			})
		}
	}
}

-- Create the main GUI
local function createMainGUI()
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "0verflowHub"
	ScreenGui.ResetOnSpawn = false
	
	if gethui then
		ScreenGui.Parent = gethui()
	elseif syn and syn.protect_gui then 
		syn.protect_gui(ScreenGui)
		ScreenGui.Parent = CoreGui
	elseif not useStudio and CoreGui:FindFirstChild("RobloxGui") then
		ScreenGui.Parent = CoreGui:FindFirstChild("RobloxGui")
	elseif not useStudio then
		ScreenGui.Parent = CoreGui
	end
	
	-- Main Container
	local Main = Instance.new("Frame")
	Main.Name = "Main"
	Main.Size = UDim2.new(0, 850, 0, 550)
	Main.Position = UDim2.new(0.5, 0, 0.5, 0)
	Main.AnchorPoint = Vector2.new(0.5, 0.5)
	Main.BackgroundColor3 = OverflowLibrary.Theme.Default.Background
	Main.BorderSizePixel = 0
	Main.Parent = ScreenGui
	
	-- Corner radius
	local MainCorner = Instance.new("UICorner")
	MainCorner.CornerRadius = UDim.new(0, 12)
	MainCorner.Parent = Main
	
	-- Drop shadow
	local Shadow = Instance.new("ImageLabel")
	Shadow.Name = "Shadow"
	Shadow.Size = UDim2.new(1, 20, 1, 20)
	Shadow.Position = UDim2.new(0, -10, 0, -10)
	Shadow.BackgroundTransparency = 1
	Shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
	Shadow.ImageTransparency = 0.7
	Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	Shadow.ZIndex = 0
	Shadow.Parent = Main
	
	-- Sidebar
	local Sidebar = Instance.new("Frame")
	Sidebar.Name = "Sidebar"
	Sidebar.Size = UDim2.new(0, 220, 1, 0)
	Sidebar.Position = UDim2.new(0, 0, 0, 0)
	Sidebar.BackgroundColor3 = OverflowLibrary.Theme.Default.SidebarBackground
	Sidebar.BorderSizePixel = 0
	Sidebar.Parent = Main
	
	local SidebarCorner = Instance.new("UICorner")
	SidebarCorner.CornerRadius = UDim.new(0, 12)
	SidebarCorner.Parent = Sidebar
	
	-- Sidebar header
	local SidebarHeader = Instance.new("Frame")
	SidebarHeader.Name = "Header"
	SidebarHeader.Size = UDim2.new(1, 0, 0, 60)
	SidebarHeader.BackgroundTransparency = 1
	SidebarHeader.Parent = Sidebar
	
	local Title = Instance.new("TextLabel")
	Title.Name = "Title"
	Title.Size = UDim2.new(1, -20, 1, 0)
	Title.Position = UDim2.new(0, 20, 0, 0)
	Title.BackgroundTransparency = 1
	Title.Text = "0verflow Hub"
	Title.TextColor3 = OverflowLibrary.Theme.Default.TextColor
	Title.TextSize = 22
	Title.Font = Enum.Font.GothamBold
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Parent = SidebarHeader
	
	-- Accent line under title
	local AccentLine = Instance.new("Frame")
	AccentLine.Name = "AccentLine"
	AccentLine.Size = UDim2.new(0, 60, 0, 3)
	AccentLine.Position = UDim2.new(0, 20, 1, -3)
	AccentLine.BackgroundColor3 = OverflowLibrary.Theme.Default.Primary
	AccentLine.BorderSizePixel = 0
	AccentLine.Parent = SidebarHeader
	
	local AccentCorner = Instance.new("UICorner")
	AccentCorner.CornerRadius = UDim.new(0, 2)
	AccentCorner.Parent = AccentLine
	
	-- Tab list container
	local TabList = Instance.new("ScrollingFrame")
	TabList.Name = "TabList"
	TabList.Size = UDim2.new(1, 0, 1, -80)
	TabList.Position = UDim2.new(0, 0, 0, 80)
	TabList.BackgroundTransparency = 1
	TabList.ScrollBarThickness = 4
	TabList.ScrollBarImageColor3 = OverflowLibrary.Theme.Default.Primary
	TabList.BorderSizePixel = 0
	TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
	TabList.Parent = Sidebar
	
	local TabListLayout = Instance.new("UIListLayout")
	TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TabListLayout.Padding = UDim.new(0, 2)
	TabListLayout.Parent = TabList
	
	-- Auto-resize canvas
	TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		TabList.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y + 10)
	end)
	
	-- Content area
	local Content = Instance.new("Frame")
	Content.Name = "Content"
	Content.Size = UDim2.new(1, -220, 1, 0)
	Content.Position = UDim2.new(0, 220, 0, 0)
	Content.BackgroundColor3 = OverflowLibrary.Theme.Default.BackgroundSecondary
	Content.BorderSizePixel = 0
	Content.Parent = Main
	
	local ContentCorner = Instance.new("UICorner")
	ContentCorner.CornerRadius = UDim.new(0, 12)
	ContentCorner.Parent = Content
	
	-- Content header
	local ContentHeader = Instance.new("Frame")
	ContentHeader.Name = "Header"
	ContentHeader.Size = UDim2.new(1, 0, 0, 60)
	ContentHeader.BackgroundTransparency = 1
	ContentHeader.Parent = Content
	
	local PageTitle = Instance.new("TextLabel")
	PageTitle.Name = "PageTitle"
	PageTitle.Size = UDim2.new(1, -40, 1, 0)
	PageTitle.Position = UDim2.new(0, 20, 0, 0)
	PageTitle.BackgroundTransparency = 1
	PageTitle.Text = "Welcome"
	PageTitle.TextColor3 = OverflowLibrary.Theme.Default.TextColor
	PageTitle.TextSize = 20
	PageTitle.Font = Enum.Font.GothamSemibold
	PageTitle.TextXAlignment = Enum.TextXAlignment.Left
	PageTitle.Parent = ContentHeader
	
	-- Content pages container
	local Pages = Instance.new("Frame")
	Pages.Name = "Pages"
	Pages.Size = UDim2.new(1, 0, 1, -60)
	Pages.Position = UDim2.new(0, 0, 0, 60)
	Pages.BackgroundTransparency = 1
	Pages.Parent = Content
	
	-- Page layout
	local PageLayout = Instance.new("UIPageLayout")
	PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
	PageLayout.EasingStyle = Enum.EasingStyle.Exponential
	PageLayout.EasingDirection = Enum.EasingDirection.Out
	PageLayout.TweenTime = 0.3
	PageLayout.FillDirection = Enum.FillDirection.Horizontal
	PageLayout.Parent = Pages
	
	-- Make window draggable
	local dragging = false
	local dragInput
	local dragStart
	local startPos
	
	local function updateInput(input)
		local delta = input.Position - dragStart
		Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
	
	SidebarHeader.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = Main.Position
			
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	
	SidebarHeader.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			updateInput(input)
		end
	end)
	
	return ScreenGui, Main, Sidebar, Content, TabList, Pages, PageTitle
end

-- Utility functions
local function createTweenInfo(duration, style, direction)
	return TweenInfo.new(duration or 0.3, style or Enum.EasingStyle.Exponential, direction or Enum.EasingDirection.Out)
end

local function animateHover(element, hoverColor, normalColor, property)
	property = property or "BackgroundColor3"
	
	element.MouseEnter:Connect(function()
		local tween = TweenService:Create(element, createTweenInfo(0.2), {[property] = hoverColor})
		tween:Play()
	end)
	
	element.MouseLeave:Connect(function()
		local tween = TweenService:Create(element, createTweenInfo(0.2), {[property] = normalColor})
		tween:Play()
	end)
end

-- Component creation functions
local function createTabButton(parent, name, icon)
	local TabButton = Instance.new("Frame")
	TabButton.Name = name
	TabButton.Size = UDim2.new(1, -10, 0, 45)
	TabButton.BackgroundColor3 = OverflowLibrary.Theme.Default.TabBackground
	TabButton.BorderSizePixel = 0
	TabButton.Parent = parent
	
	local TabCorner = Instance.new("UICorner")
	TabCorner.CornerRadius = UDim.new(0, 8)
	TabCorner.Parent = TabButton
	
	-- Selection indicator
	local Indicator = Instance.new("Frame")
	Indicator.Name = "Indicator"
	Indicator.Size = UDim2.new(0, 4, 0, 25)
	Indicator.Position = UDim2.new(0, 0, 0.5, 0)
	Indicator.AnchorPoint = Vector2.new(0, 0.5)
	Indicator.BackgroundColor3 = OverflowLibrary.Theme.Default.Primary
	Indicator.BorderSizePixel = 0
	Indicator.BackgroundTransparency = 1
	Indicator.Parent = TabButton
	
	local IndicatorCorner = Instance.new("UICorner")
	IndicatorCorner.CornerRadius = UDim.new(0, 2)
	IndicatorCorner.Parent = Indicator
	
	-- Icon (if provided)
	local Icon
	if icon then
		Icon = Instance.new("ImageLabel")
		Icon.Name = "Icon"
		Icon.Size = UDim2.new(0, 20, 0, 20)
		Icon.Position = UDim2.new(0, 15, 0.5, 0)
		Icon.AnchorPoint = Vector2.new(0, 0.5)
		Icon.BackgroundTransparency = 1
		Icon.Image = typeof(icon) == "string" and icon or ("rbxassetid://" .. tostring(icon))
		Icon.ImageColor3 = OverflowLibrary.Theme.Default.TabTextColor
		Icon.Parent = TabButton
	end
	
	-- Title
	local TabTitle = Instance.new("TextLabel")
	TabTitle.Name = "Title"
	TabTitle.Size = UDim2.new(1, icon and -50 or -20, 1, 0)
	TabTitle.Position = UDim2.new(0, icon and 45 or 20, 0, 0)
	TabTitle.BackgroundTransparency = 1
	TabTitle.Text = name
	TabTitle.TextColor3 = OverflowLibrary.Theme.Default.TabTextColor
	TabTitle.TextSize = 14
	TabTitle.Font = Enum.Font.Gotham
	TabTitle.TextXAlignment = Enum.TextXAlignment.Left
	TabTitle.Parent = TabButton
	
	-- Click detector
	local Button = Instance.new("TextButton")
	Button.Name = "Button"
	Button.Size = UDim2.new(1, 0, 1, 0)
	Button.BackgroundTransparency = 1
	Button.Text = ""
	Button.Parent = TabButton
	
	-- Hover animation
	animateHover(Button, OverflowLibrary.Theme.Default.SidebarHover, OverflowLibrary.Theme.Default.TabBackground, "BackgroundColor3")
	
	return TabButton, Button, Indicator, Icon, TabTitle
end

local function createScrollingFrame(parent)
	local ScrollFrame = Instance.new("ScrollingFrame")
	ScrollFrame.Size = UDim2.new(1, -20, 1, -20)
	ScrollFrame.Position = UDim2.new(0, 10, 0, 10)
	ScrollFrame.BackgroundTransparency = 1
	ScrollFrame.ScrollBarThickness = 6
	ScrollFrame.ScrollBarImageColor3 = OverflowLibrary.Theme.Default.Primary
	ScrollFrame.BorderSizePixel = 0
	ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	ScrollFrame.Parent = parent
	
	local Layout = Instance.new("UIListLayout")
	Layout.SortOrder = Enum.SortOrder.LayoutOrder
	Layout.Padding = UDim.new(0, 8)
	Layout.Parent = ScrollFrame
	
	-- Auto-resize canvas
	Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 20)
	end)
	
	return ScrollFrame
end

-- Main library function
function OverflowLibrary:CreateWindow(Settings)
	Settings = Settings or {}
	
	local ScreenGui, Main, Sidebar, Content, TabList, Pages, PageTitle = createMainGUI()
	
	-- Set window title
	if Settings.Name then
		Sidebar.Header.Title.Text = Settings.Name
	end
	
	-- Initial animations
	Main.BackgroundTransparency = 1
	Main.Size = UDim2.new(0, 800, 0, 500)
	
	-- Animate window in
	task.wait(0.1)
	local openTween = TweenService:Create(Main, createTweenInfo(0.6), {
		BackgroundTransparency = 0,
		Size = UDim2.new(0, 850, 0, 550)
	})
	openTween:Play()
	
	local tabCount = 0
	local firstTab = true
	local selectedTab = nil
	
	local Window = {}
	
	function Window:CreateTab(Name, Image, Ext)
		tabCount = tabCount + 1
		
		-- Create tab button
		local TabButton, Button, Indicator, Icon, TabTitle = createTabButton(TabList, Name, Image)
		TabButton.LayoutOrder = tabCount
		
		-- Create page
		local Page = Instance.new("Frame")
		Page.Name = Name
		Page.Size = UDim2.new(1, 0, 1, 0)
		Page.BackgroundTransparency = 1
		Page.LayoutOrder = tabCount
		Page.Parent = Pages
		
		local PageScrollFrame = createScrollingFrame(Page)
		
		-- Tab selection logic
		local function selectTab()
			-- Update page title
			PageTitle.Text = Name
			
			-- Update selected tab appearance
			if selectedTab then
				-- Deselect previous tab
				TweenService:Create(selectedTab.button, createTweenInfo(), {BackgroundColor3 = OverflowLibrary.Theme.Default.TabBackground}):Play()
				TweenService:Create(selectedTab.title, createTweenInfo(), {TextColor3 = OverflowLibrary.Theme.Default.TabTextColor}):Play()
				TweenService:Create(selectedTab.indicator, createTweenInfo(), {BackgroundTransparency = 1}):Play()
				if selectedTab.icon then
					TweenService:Create(selectedTab.icon, createTweenInfo(), {ImageColor3 = OverflowLibrary.Theme.Default.TabTextColor}):Play()
				end
			end
			
			-- Select current tab
			TweenService:Create(TabButton, createTweenInfo(), {BackgroundColor3 = OverflowLibrary.Theme.Default.TabBackgroundSelected}):Play()
			TweenService:Create(TabTitle, createTweenInfo(), {TextColor3 = OverflowLibrary.Theme.Default.SelectedTabTextColor}):Play()
			TweenService:Create(Indicator, createTweenInfo(), {BackgroundTransparency = 0}):Play()
			if Icon then
				TweenService:Create(Icon, createTweenInfo(), {ImageColor3 = OverflowLibrary.Theme.Default.SelectedTabTextColor}):Play()
			end
			
			selectedTab = {
				button = TabButton,
				title = TabTitle,
				indicator = Indicator,
				icon = Icon
			}
			
			-- Switch page
			Pages.UIPageLayout:JumpTo(Page)
		end
		
		Button.MouseButton1Click:Connect(selectTab)
		
		-- Select first tab by default
		if firstTab then
			firstTab = false
			task.wait(0.1)
			selectTab()
		end
		
		-- Tab object for creating elements
		local Tab = {}
		
		function Tab:CreateButton(ButtonSettings)
			ButtonSettings = ButtonSettings or {}
			
			local Button = Instance.new("Frame")
			Button.Name = "Button"
			Button.Size = UDim2.new(1, 0, 0, 45)
			Button.BackgroundColor3 = OverflowLibrary.Theme.Default.ButtonBackground
			Button.BorderSizePixel = 0
			Button.Parent = PageScrollFrame
			
			local ButtonCorner = Instance.new("UICorner")
			ButtonCorner.CornerRadius = UDim.new(0, 8)
			ButtonCorner.Parent = Button
			
			local ButtonText = Instance.new("TextLabel")
			ButtonText.Size = UDim2.new(1, -20, 1, 0)
			ButtonText.Position = UDim2.new(0, 20, 0, 0)
			ButtonText.BackgroundTransparency = 1
			ButtonText.Text = ButtonSettings.Name or "Button"
			ButtonText.TextColor3 = OverflowLibrary.Theme.Default.ButtonText
			ButtonText.TextSize = 14
			ButtonText.Font = Enum.Font.GothamSemibold
			ButtonText.TextXAlignment = Enum.TextXAlignment.Left
			ButtonText.Parent = Button
			
			local ClickButton = Instance.new("TextButton")
			ClickButton.Size = UDim2.new(1, 0, 1, 0)
			ClickButton.BackgroundTransparency = 1
			ClickButton.Text = ""
			ClickButton.Parent = Button
			
			-- Hover animation
			animateHover(ClickButton, OverflowLibrary.Theme.Default.ButtonBackgroundHover, OverflowLibrary.Theme.Default.ButtonBackground, "BackgroundColor3")
			
			-- Click handler
			if ButtonSettings.Callback then
				ClickButton.MouseButton1Click:Connect(ButtonSettings.Callback)
			end
			
			local ButtonValue = {}
			function ButtonValue:Set(newText)
				ButtonText.Text = newText
			end
			
			return ButtonValue
		end
		
		function Tab:CreateToggle(ToggleSettings)
			ToggleSettings = ToggleSettings or {}
			
			local Toggle = Instance.new("Frame")
			Toggle.Name = "Toggle"
			Toggle.Size = UDim2.new(1, 0, 0, 50)
			Toggle.BackgroundColor3 = OverflowLibrary.Theme.Default.ElementBackground
			Toggle.BorderSizePixel = 0
			Toggle.Parent = PageScrollFrame
			
			local ToggleCorner = Instance.new("UICorner")
			ToggleCorner.CornerRadius = UDim.new(0, 8)
			ToggleCorner.Parent = Toggle
			
			local ToggleTitle = Instance.new("TextLabel")
			ToggleTitle.Size = UDim2.new(1, -70, 1, 0)
			ToggleTitle.Position = UDim2.new(0, 20, 0, 0)
			ToggleTitle.BackgroundTransparency = 1
			ToggleTitle.Text = ToggleSettings.Name or "Toggle"
			ToggleTitle.TextColor3 = OverflowLibrary.Theme.Default.TextColor
			ToggleTitle.TextSize = 14
			ToggleTitle.Font = Enum.Font.Gotham
			ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
			ToggleTitle.Parent = Toggle
			
			-- Toggle switch
			local ToggleFrame = Instance.new("Frame")
			ToggleFrame.Size = UDim2.new(0, 44, 0, 24)
			ToggleFrame.Position = UDim2.new(1, -60, 0.5, 0)
			ToggleFrame.AnchorPoint = Vector2.new(0, 0.5)
			ToggleFrame.BackgroundColor3 = OverflowLibrary.Theme.Default.ToggleDisabled
			ToggleFrame.BorderSizePixel = 0
			ToggleFrame.Parent = Toggle
			
			local ToggleFrameCorner = Instance.new("UICorner")
			ToggleFrameCorner.CornerRadius = UDim.new(0, 12)
			ToggleFrameCorner.Parent = ToggleFrame
			
			local ToggleKnob = Instance.new("Frame")
			ToggleKnob.Size = UDim2.new(0, 20, 0, 20)
			ToggleKnob.Position = UDim2.new(0, 2, 0.5, 0)
			ToggleKnob.AnchorPoint = Vector2.new(0, 0.5)
			ToggleKnob.BackgroundColor3 = OverflowLibrary.Theme.Default.ToggleKnob
			ToggleKnob.BorderSizePixel = 0
			ToggleKnob.Parent = ToggleFrame
			
			local ToggleKnobCorner = Instance.new("UICorner")
			ToggleKnobCorner.CornerRadius = UDim.new(0, 10)
			ToggleKnobCorner.Parent = ToggleKnob
			
			local ClickDetector = Instance.new("TextButton")
			ClickDetector.Size = UDim2.new(1, 0, 1, 0)
			ClickDetector.BackgroundTransparency = 1
			ClickDetector.Text = ""
			ClickDetector.Parent = Toggle
			
			-- State
			local enabled = ToggleSettings.Default or false
			
			local function updateToggle()
				if enabled then
					TweenService:Create(ToggleFrame, createTweenInfo(), {BackgroundColor3 = OverflowLibrary.Theme.Default.ToggleEnabled}):Play()
					TweenService:Create(ToggleKnob, createTweenInfo(), {Position = UDim2.new(1, -22, 0.5, 0)}):Play()
				else
					TweenService:Create(ToggleFrame, createTweenInfo(), {BackgroundColor3 = OverflowLibrary.Theme.Default.ToggleDisabled}):Play()
					TweenService:Create(ToggleKnob, createTweenInfo(), {Position = UDim2.new(0, 2, 0.5, 0)}):Play()
				end
			end
			
			updateToggle()
			
			ClickDetector.MouseButton1Click:Connect(function()
				enabled = not enabled
				updateToggle()
				if ToggleSettings.Callback then
					ToggleSettings.Callback(enabled)
				end
			end)
			
			-- Hover animation
			animateHover(ClickDetector, OverflowLibrary.Theme.Default.ElementBackgroundHover, OverflowLibrary.Theme.Default.ElementBackground, "BackgroundColor3")
			
			local ToggleValue = {}
			function ToggleValue:Set(value)
				enabled = value
				updateToggle()
			end
			
			return ToggleValue
		end
		
		function Tab:CreateSlider(SliderSettings)
			SliderSettings = SliderSettings or {}
			
			local Slider = Instance.new("Frame")
			Slider.Name = "Slider"
			Slider.Size = UDim2.new(1, 0, 0, 60)
			Slider.BackgroundColor3 = OverflowLibrary.Theme.Default.ElementBackground
			Slider.BorderSizePixel = 0
			Slider.Parent = PageScrollFrame
			
			local SliderCorner = Instance.new("UICorner")
			SliderCorner.CornerRadius = UDim.new(0, 8)
			SliderCorner.Parent = Slider
			
			local SliderTitle = Instance.new("TextLabel")
			SliderTitle.Size = UDim2.new(1, -20, 0, 25)
			SliderTitle.Position = UDim2.new(0, 20, 0, 5)
			SliderTitle.BackgroundTransparency = 1
			SliderTitle.Text = SliderSettings.Name or "Slider"
			SliderTitle.TextColor3 = OverflowLibrary.Theme.Default.TextColor
			SliderTitle.TextSize = 14
			SliderTitle.Font = Enum.Font.Gotham
			SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
			SliderTitle.Parent = Slider
			
			local ValueLabel = Instance.new("TextLabel")
			ValueLabel.Size = UDim2.new(0, 60, 0, 25)
			ValueLabel.Position = UDim2.new(1, -80, 0, 5)
			ValueLabel.BackgroundTransparency = 1
			ValueLabel.Text = tostring(SliderSettings.Default or SliderSettings.Min or 0)
			ValueLabel.TextColor3 = OverflowLibrary.Theme.Default.Primary
			ValueLabel.TextSize = 12
			ValueLabel.Font = Enum.Font.GothamSemibold
			ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
			ValueLabel.Parent = Slider
			
			-- Slider track
			local SliderTrack = Instance.new("Frame")
			SliderTrack.Size = UDim2.new(1, -40, 0, 6)
			SliderTrack.Position = UDim2.new(0, 20, 1, -20)
			SliderTrack.BackgroundColor3 = OverflowLibrary.Theme.Default.SliderTrack
			SliderTrack.BorderSizePixel = 0
			SliderTrack.Parent = Slider
			
			local TrackCorner = Instance.new("UICorner")
			TrackCorner.CornerRadius = UDim.new(0, 3)
			TrackCorner.Parent = SliderTrack
			
			-- Slider fill
			local SliderFill = Instance.new("Frame")
			SliderFill.Size = UDim2.new(0, 0, 1, 0)
			SliderFill.BackgroundColor3 = OverflowLibrary.Theme.Default.SliderFill
			SliderFill.BorderSizePixel = 0
			SliderFill.Parent = SliderTrack
			
			local FillCorner = Instance.new("UICorner")
			FillCorner.CornerRadius = UDim.new(0, 3)
			FillCorner.Parent = SliderFill
			
			-- Slider knob
			local SliderKnob = Instance.new("Frame")
			SliderKnob.Size = UDim2.new(0, 16, 0, 16)
			SliderKnob.Position = UDim2.new(0, 0, 0.5, 0)
			SliderKnob.AnchorPoint = Vector2.new(0.5, 0.5)
			SliderKnob.BackgroundColor3 = OverflowLibrary.Theme.Default.SliderKnob
			SliderKnob.BorderSizePixel = 0
			SliderKnob.Parent = SliderTrack
			
			local KnobCorner = Instance.new("UICorner")
			KnobCorner.CornerRadius = UDim.new(0, 8)
			KnobCorner.Parent = SliderKnob
			
			-- Slider logic
			local min = SliderSettings.Min or 0
			local max = SliderSettings.Max or 100
			local default = SliderSettings.Default or min
			local value = default
			
			local function updateSlider()
				local percentage = (value - min) / (max - min)
				SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
				SliderKnob.Position = UDim2.new(percentage, 0, 0.5, 0)
				ValueLabel.Text = tostring(math.floor(value * 100) / 100)
			end
			
			updateSlider()
			
			local dragging = false
			
			SliderTrack.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = true
					local function update()
						local mouse = Players.LocalPlayer:GetMouse()
						local percentage = math.clamp((mouse.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
						value = min + (max - min) * percentage
						updateSlider()
						if SliderSettings.Callback then
							SliderSettings.Callback(value)
						end
					end
					update()
					
					local connection
					connection = UserInputService.InputEnded:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							dragging = false
							connection:Disconnect()
						end
					end)
				end
			end)
			
			UserInputService.InputChanged:Connect(function(input)
				if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					local mouse = Players.LocalPlayer:GetMouse()
					local percentage = math.clamp((mouse.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
					value = min + (max - min) * percentage
					updateSlider()
					if SliderSettings.Callback then
						SliderSettings.Callback(value)
					end
				end
			end)
			
			local SliderValue = {}
			function SliderValue:Set(newValue)
				value = math.clamp(newValue, min, max)
				updateSlider()
			end
			
			return SliderValue
		end
		
		function Tab:CreateInput(InputSettings)
			InputSettings = InputSettings or {}
			
			local Input = Instance.new("Frame")
			Input.Name = "Input"
			Input.Size = UDim2.new(1, 0, 0, 50)
			Input.BackgroundColor3 = OverflowLibrary.Theme.Default.ElementBackground
			Input.BorderSizePixel = 0
			Input.Parent = PageScrollFrame
			
			local InputCorner = Instance.new("UICorner")
			InputCorner.CornerRadius = UDim.new(0, 8)
			InputCorner.Parent = Input
			
			local InputTitle = Instance.new("TextLabel")
			InputTitle.Size = UDim2.new(0.4, 0, 1, 0)
			InputTitle.Position = UDim2.new(0, 20, 0, 0)
			InputTitle.BackgroundTransparency = 1
			InputTitle.Text = InputSettings.Name or "Input"
			InputTitle.TextColor3 = OverflowLibrary.Theme.Default.TextColor
			InputTitle.TextSize = 14
			InputTitle.Font = Enum.Font.Gotham
			InputTitle.TextXAlignment = Enum.TextXAlignment.Left
			InputTitle.Parent = Input
			
			-- Input field
			local InputField = Instance.new("TextBox")
			InputField.Size = UDim2.new(0.55, -20, 0, 30)
			InputField.Position = UDim2.new(0.45, 0, 0.5, 0)
			InputField.AnchorPoint = Vector2.new(0, 0.5)
			InputField.BackgroundColor3 = OverflowLibrary.Theme.Default.InputBackground
			InputField.BorderSizePixel = 0
			InputField.Text = InputSettings.Default or ""
			InputField.PlaceholderText = InputSettings.PlaceholderText or "Enter text..."
			InputField.PlaceholderColor3 = OverflowLibrary.Theme.Default.PlaceholderColor
			InputField.TextColor3 = OverflowLibrary.Theme.Default.TextColor
			InputField.TextSize = 12
			InputField.Font = Enum.Font.Gotham
			InputField.Parent = Input
			
			local InputFieldCorner = Instance.new("UICorner")
			InputFieldCorner.CornerRadius = UDim.new(0, 6)
			InputFieldCorner.Parent = InputField
			
			local InputStroke = Instance.new("UIStroke")
			InputStroke.Color = OverflowLibrary.Theme.Default.InputStroke
			InputStroke.Thickness = 1
			InputStroke.Parent = InputField
			
			-- Focus animations
			InputField.Focused:Connect(function()
				TweenService:Create(InputStroke, createTweenInfo(), {Color = OverflowLibrary.Theme.Default.InputStrokeFocused}):Play()
			end)
			
			InputField.FocusLost:Connect(function()
				TweenService:Create(InputStroke, createTweenInfo(), {Color = OverflowLibrary.Theme.Default.InputStroke}):Play()
				if InputSettings.Callback then
					InputSettings.Callback(InputField.Text)
				end
			end)
			
			local InputValue = {}
			function InputValue:Set(text)
				InputField.Text = text
			end
			
			return InputValue
		end
		
		function Tab:CreateDropdown(DropdownSettings)
			DropdownSettings = DropdownSettings or {}
			
			local Dropdown = Instance.new("Frame")
			Dropdown.Name = "Dropdown"
			Dropdown.Size = UDim2.new(1, 0, 0, 50)
			Dropdown.BackgroundColor3 = OverflowLibrary.Theme.Default.ElementBackground
			Dropdown.BorderSizePixel = 0
			Dropdown.Parent = PageScrollFrame
			
			local DropdownCorner = Instance.new("UICorner")
			DropdownCorner.CornerRadius = UDim.new(0, 8)
			DropdownCorner.Parent = Dropdown
			
			local DropdownTitle = Instance.new("TextLabel")
			DropdownTitle.Size = UDim2.new(0.4, 0, 1, 0)
			DropdownTitle.Position = UDim2.new(0, 20, 0, 0)
			DropdownTitle.BackgroundTransparency = 1
			DropdownTitle.Text = DropdownSettings.Name or "Dropdown"
			DropdownTitle.TextColor3 = OverflowLibrary.Theme.Default.TextColor
			DropdownTitle.TextSize = 14
			DropdownTitle.Font = Enum.Font.Gotham
			DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
			DropdownTitle.Parent = Dropdown
			
			-- Dropdown button
			local DropdownButton = Instance.new("TextButton")
			DropdownButton.Size = UDim2.new(0.55, -20, 0, 30)
			DropdownButton.Position = UDim2.new(0.45, 0, 0.5, 0)
			DropdownButton.AnchorPoint = Vector2.new(0, 0.5)
			DropdownButton.BackgroundColor3 = OverflowLibrary.Theme.Default.DropdownBackground
			DropdownButton.BorderSizePixel = 0
			DropdownButton.Text = DropdownSettings.Default or "Select..."
			DropdownButton.TextColor3 = OverflowLibrary.Theme.Default.TextColor
			DropdownButton.TextSize = 12
			DropdownButton.Font = Enum.Font.Gotham
			DropdownButton.TextXAlignment = Enum.TextXAlignment.Left
			DropdownButton.Parent = Dropdown
			
			local DropdownButtonCorner = Instance.new("UICorner")
			DropdownButtonCorner.CornerRadius = UDim.new(0, 6)
			DropdownButtonCorner.Parent = DropdownButton
			
			-- Arrow icon
			local Arrow = Instance.new("TextLabel")
			Arrow.Size = UDim2.new(0, 20, 1, 0)
			Arrow.Position = UDim2.new(1, -25, 0, 0)
			Arrow.BackgroundTransparency = 1
			Arrow.Text = "▼"
			Arrow.TextColor3 = OverflowLibrary.Theme.Default.TextColorSecondary
			Arrow.TextSize = 10
			Arrow.Font = Enum.Font.Gotham
			Arrow.Parent = DropdownButton
			
			-- Dropdown list
			local DropdownList = Instance.new("Frame")
			DropdownList.Size = UDim2.new(0.55, -20, 0, 0)
			DropdownList.Position = UDim2.new(0.45, 0, 1, 5)
			DropdownList.BackgroundColor3 = OverflowLibrary.Theme.Default.DropdownBackground
			DropdownList.BorderSizePixel = 0
			DropdownList.Visible = false
			DropdownList.ZIndex = 10
			DropdownList.Parent = Dropdown
			
			local DropdownListCorner = Instance.new("UICorner")
			DropdownListCorner.CornerRadius = UDim.new(0, 6)
			DropdownListCorner.Parent = DropdownList
			
			local ListLayout = Instance.new("UIListLayout")
			ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			ListLayout.Parent = DropdownList
			
			local isOpen = false
			local selectedValue = DropdownSettings.Default
			
			local function toggleDropdown()
				isOpen = not isOpen
				if isOpen then
					local itemCount = #(DropdownSettings.Options or {})
					local listHeight = math.min(itemCount * 30, 150)
					DropdownList.Size = UDim2.new(0.55, -20, 0, listHeight)
					DropdownList.Visible = true
					Dropdown.Size = UDim2.new(1, 0, 0, 50 + listHeight + 5)
					TweenService:Create(Arrow, createTweenInfo(), {Rotation = 180}):Play()
				else
					DropdownList.Visible = false
					Dropdown.Size = UDim2.new(1, 0, 0, 50)
					TweenService:Create(Arrow, createTweenInfo(), {Rotation = 0}):Play()
				end
			end
			
			DropdownButton.MouseButton1Click:Connect(toggleDropdown)
			
			-- Create options
			if DropdownSettings.Options then
				for i, option in ipairs(DropdownSettings.Options) do
					local OptionButton = Instance.new("TextButton")
					OptionButton.Size = UDim2.new(1, 0, 0, 30)
					OptionButton.BackgroundColor3 = Color3.new(0, 0, 0)
					OptionButton.BackgroundTransparency = 1
					OptionButton.BorderSizePixel = 0
					OptionButton.Text = option
					OptionButton.TextColor3 = OverflowLibrary.Theme.Default.TextColor
					OptionButton.TextSize = 12
					OptionButton.Font = Enum.Font.Gotham
					OptionButton.TextXAlignment = Enum.TextXAlignment.Left
					OptionButton.LayoutOrder = i
					OptionButton.Parent = DropdownList
					
					-- Hover effect
					animateHover(OptionButton, OverflowLibrary.Theme.Default.DropdownHover, Color3.new(0, 0, 0), "BackgroundColor3")
					
					OptionButton.MouseButton1Click:Connect(function()
						selectedValue = option
						DropdownButton.Text = option
						toggleDropdown()
						if DropdownSettings.Callback then
							DropdownSettings.Callback(option)
						end
					end)
				end
			end
			
			local DropdownValue = {}
			function DropdownValue:Set(value)
				selectedValue = value
				DropdownButton.Text = value
			end
			
			function DropdownValue:Refresh(newOptions)
				-- Clear existing options
				for _, child in ipairs(DropdownList:GetChildren()) do
					if child:IsA("TextButton") then
						child:Destroy()
					end
				end
				
				-- Create new options
				for i, option in ipairs(newOptions) do
					local OptionButton = Instance.new("TextButton")
					OptionButton.Size = UDim2.new(1, 0, 0, 30)
					OptionButton.BackgroundColor3 = Color3.new(0, 0, 0)
					OptionButton.BackgroundTransparency = 1
					OptionButton.BorderSizePixel = 0
					OptionButton.Text = option
					OptionButton.TextColor3 = OverflowLibrary.Theme.Default.TextColor
					OptionButton.TextSize = 12
					OptionButton.Font = Enum.Font.Gotham
					OptionButton.TextXAlignment = Enum.TextXAlignment.Left
					OptionButton.LayoutOrder = i
					OptionButton.Parent = DropdownList
					
					animateHover(OptionButton, OverflowLibrary.Theme.Default.DropdownHover, Color3.new(0, 0, 0), "BackgroundColor3")
					
					OptionButton.MouseButton1Click:Connect(function()
						selectedValue = option
						DropdownButton.Text = option
						toggleDropdown()
						if DropdownSettings.Callback then
							DropdownSettings.Callback(option)
						end
					end)
				end
			end
			
			return DropdownValue
		end
		
		function Tab:CreateSection(Name)
			local Section = Instance.new("Frame")
			Section.Name = "Section"
			Section.Size = UDim2.new(1, 0, 0, 30)
			Section.BackgroundTransparency = 1
			Section.Parent = PageScrollFrame
			
			local SectionTitle = Instance.new("TextLabel")
			SectionTitle.Size = UDim2.new(1, -20, 1, 0)
			SectionTitle.Position = UDim2.new(0, 20, 0, 0)
			SectionTitle.BackgroundTransparency = 1
			SectionTitle.Text = Name or "Section"
			SectionTitle.TextColor3 = OverflowLibrary.Theme.Default.Primary
			SectionTitle.TextSize = 16
			SectionTitle.Font = Enum.Font.GothamSemibold
			SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
			SectionTitle.Parent = Section
			
			return {}
		end
		
		function Tab:CreateLabel(Text)
			local Label = Instance.new("Frame")
			Label.Name = "Label"
			Label.Size = UDim2.new(1, 0, 0, 35)
			Label.BackgroundTransparency = 1
			Label.Parent = PageScrollFrame
			
			local LabelText = Instance.new("TextLabel")
			LabelText.Size = UDim2.new(1, -20, 1, 0)
			LabelText.Position = UDim2.new(0, 20, 0, 0)
			LabelText.BackgroundTransparency = 1
			LabelText.Text = Text or "Label"
			LabelText.TextColor3 = OverflowLibrary.Theme.Default.TextColorSecondary
			LabelText.TextSize = 13
			LabelText.Font = Enum.Font.Gotham
			LabelText.TextXAlignment = Enum.TextXAlignment.Left
			LabelText.TextWrapped = true
			LabelText.Parent = Label
			
			local LabelValue = {}
			function LabelValue:Set(newText)
				LabelText.Text = newText
			end
			
			return LabelValue
		end
		
		return Tab
	end
	
	-- Destroy function
	function Window:Destroy()
		ScreenGui:Destroy()
	end
	
	return Window
end

-- Notification system (simplified)
function OverflowLibrary:Notify(Settings)
	-- Simple notification implementation
	print("Notification:", Settings.Title or "Notification", "-", Settings.Content or "No content")
end

return OverflowLibrary
