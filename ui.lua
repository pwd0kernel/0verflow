--[[
	0verflow Hub - Modern Minimal UI Library
	Based on Rayfield Interface Suite
	Rebranded with custom design and left-side tabs
	Compatible with Rayfield UI scripts
]]

local function getService(name)
	local service = game:GetService(name)
	return if cloneref then cloneref(service) else service
end

local function loadWithTimeout(url: string, timeout: number?): ...any
	assert(type(url) == "string", "Expected string, got " .. type(url))
	timeout = timeout or 5
	local requestCompleted = false
	local success, result = false, nil

	local requestThread = task.spawn(function()
		local fetchSuccess, fetchResult = pcall(game.HttpGet, game, url)
		if not fetchSuccess or #fetchResult == 0 then
			if #fetchResult == 0 then
				fetchResult = "Empty response"
			end
			success, result = false, fetchResult
			requestCompleted = true
			return
		end
		local content = fetchResult
		local execSuccess, execResult = pcall(function()
			return loadstring(content)()
		end)
		success, result = execSuccess, execResult
		requestCompleted = true
	end)

	local timeoutThread = task.delay(timeout, function()
		if not requestCompleted then
			warn(`Request for {url} timed out after {timeout} seconds`)
			task.cancel(requestThread)
			result = "Request timed out"
			requestCompleted = true
		end
	end)

	while not requestCompleted do
		task.wait()
	end
	
	if coroutine.status(timeoutThread) ~= "dead" then
		task.cancel(timeoutThread)
	end
	
	if not success then
		warn(`Failed to process {url}: {result}`)
	end
	
	return if success then result else nil
end

local TweenService = getService('TweenService')
local UserInputService = getService('UserInputService')
local RunService = getService('RunService')
local HttpService = getService('HttpService')

-- 0verflow Hub Library
local OverflowHub = {
	Flags = {},
	Theme = {
		Modern = {
			-- Main Colors
			Primary = Color3.fromRGB(111, 10, 214), -- #6f0ad6 - Your requested dark purple
			PrimaryHover = Color3.fromRGB(131, 30, 234), -- Lighter version for hover
			PrimaryActive = Color3.fromRGB(91, 0, 194), -- Darker version for active
			
			-- Background Colors
			Background = Color3.fromRGB(15, 15, 20), -- Very dark background
			SecondaryBackground = Color3.fromRGB(20, 20, 25), -- Slightly lighter
			TertiaryBackground = Color3.fromRGB(25, 25, 30), -- For cards/elements
			
			-- Text Colors
			TextPrimary = Color3.fromRGB(255, 255, 255), -- White text
			TextSecondary = Color3.fromRGB(200, 200, 200), -- Slightly dimmed
			TextMuted = Color3.fromRGB(150, 150, 150), -- Muted text
			
			-- Border/Stroke Colors
			Border = Color3.fromRGB(40, 40, 45),
			BorderHover = Color3.fromRGB(60, 60, 65),
			
			-- Component Specific Colors
			ElementBackground = Color3.fromRGB(25, 25, 30),
			ElementBackgroundHover = Color3.fromRGB(30, 30, 35),
			ElementStroke = Color3.fromRGB(40, 40, 45),
			
			-- Legacy compatibility colors
			Topbar = Color3.fromRGB(20, 20, 25),
			Shadow = Color3.fromRGB(10, 10, 15),
			
			TabBackground = Color3.fromRGB(25, 25, 30),
			TabBackgroundSelected = Color3.fromRGB(111, 10, 214),
			TabStroke = Color3.fromRGB(40, 40, 45),
			TabTextColor = Color3.fromRGB(200, 200, 200),
			SelectedTabTextColor = Color3.fromRGB(255, 255, 255),
			
			ToggleBackground = Color3.fromRGB(30, 30, 35),
			ToggleEnabled = Color3.fromRGB(111, 10, 214),
			ToggleDisabled = Color3.fromRGB(60, 60, 65),
			ToggleEnabledStroke = Color3.fromRGB(131, 30, 234),
			ToggleDisabledStroke = Color3.fromRGB(80, 80, 85),
			ToggleEnabledOuterStroke = Color3.fromRGB(91, 0, 194),
			ToggleDisabledOuterStroke = Color3.fromRGB(50, 50, 55),
			
			SliderBackground = Color3.fromRGB(111, 10, 214),
			SliderProgress = Color3.fromRGB(131, 30, 234),
			SliderStroke = Color3.fromRGB(91, 0, 194),
			
			DropdownSelected = Color3.fromRGB(30, 30, 35),
			DropdownUnselected = Color3.fromRGB(25, 25, 30),
			
			InputBackground = Color3.fromRGB(25, 25, 30),
			InputStroke = Color3.fromRGB(40, 40, 45),
			PlaceholderColor = Color3.fromRGB(150, 150, 150),
			
			NotificationBackground = Color3.fromRGB(20, 20, 25),
			NotificationActionsBackground = Color3.fromRGB(25, 25, 30),
			
			TextColor = Color3.fromRGB(255, 255, 255) -- Main text color for compatibility
		}
	}
}

local SelectedTheme = OverflowHub.Theme.Modern
local FirstTab = nil
local Minimised = false

-- Create the main ScreenGui
local function CreateScreenGui()
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "0verflowHub"
	ScreenGui.Parent = game:GetService("CoreGui")
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.ResetOnSpawn = false
	
	return ScreenGui
end

-- Create main window frame
local function CreateMainFrame(parent)
	local Main = Instance.new("Frame")
	Main.Name = "Main"
	Main.Parent = parent
	Main.AnchorPoint = Vector2.new(0.5, 0.5)
	Main.Position = UDim2.new(0.5, 0, 0.5, 0)
	Main.Size = UDim2.new(0, 700, 0, 500)
	Main.BackgroundColor3 = SelectedTheme.Background
	Main.BorderSizePixel = 0
	Main.ClipsDescendants = true
	
	-- Add corner radius
	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 12)
	Corner.Parent = Main
	
	-- Add stroke
	local Stroke = Instance.new("UIStroke")
	Stroke.Color = SelectedTheme.Border
	Stroke.Thickness = 1
	Stroke.Parent = Main
	
	-- Add shadow effect
	local Shadow = Instance.new("Frame")
	Shadow.Name = "Shadow"
	Shadow.Parent = parent
	Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
	Shadow.Position = UDim2.new(0.5, 2, 0.5, 2)
	Shadow.Size = UDim2.new(0, 700, 0, 500)
	Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Shadow.BackgroundTransparency = 0.7
	Shadow.BorderSizePixel = 0
	Shadow.ZIndex = Main.ZIndex - 1
	
	local ShadowCorner = Instance.new("UICorner")
	ShadowCorner.CornerRadius = UDim.new(0, 12)
	ShadowCorner.Parent = Shadow
	
	return Main
end

-- Create topbar
local function CreateTopbar(parent, title)
	local Topbar = Instance.new("Frame")
	Topbar.Name = "Topbar"
	Topbar.Parent = parent
	Topbar.Size = UDim2.new(1, 0, 0, 50)
	Topbar.Position = UDim2.new(0, 0, 0, 0)
	Topbar.BackgroundColor3 = SelectedTheme.SecondaryBackground
	Topbar.BorderSizePixel = 0
	
	-- Corner radius for topbar
	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 12)
	Corner.Parent = Topbar
	
	-- Hide bottom corners
	local BottomFill = Instance.new("Frame")
	BottomFill.Parent = Topbar
	BottomFill.Size = UDim2.new(1, 0, 0, 12)
	BottomFill.Position = UDim2.new(0, 0, 1, -12)
	BottomFill.BackgroundColor3 = SelectedTheme.SecondaryBackground
	BottomFill.BorderSizePixel = 0
	
	-- Title
	local Title = Instance.new("TextLabel")
	Title.Name = "Title"
	Title.Parent = Topbar
	Title.Size = UDim2.new(1, -100, 1, 0)
	Title.Position = UDim2.new(0, 20, 0, 0)
	Title.BackgroundTransparency = 1
	Title.Text = title or "0verflow Hub"
	Title.TextColor3 = SelectedTheme.TextPrimary
	Title.TextSize = 18
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Font = Enum.Font.GothamBold
	
	-- Close button
	local CloseButton = Instance.new("TextButton")
	CloseButton.Name = "Close"
	CloseButton.Parent = Topbar
	CloseButton.Size = UDim2.new(0, 40, 0, 40)
	CloseButton.Position = UDim2.new(1, -50, 0.5, -20)
	CloseButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
	CloseButton.Text = "×"
	CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	CloseButton.TextSize = 20
	CloseButton.Font = Enum.Font.GothamBold
	CloseButton.BorderSizePixel = 0
	
	local CloseCorner = Instance.new("UICorner")
	CloseCorner.CornerRadius = UDim.new(0, 8)
	CloseCorner.Parent = CloseButton
	
	-- Minimize button
	local MinimizeButton = Instance.new("TextButton")
	MinimizeButton.Name = "Minimize"
	MinimizeButton.Parent = Topbar
	MinimizeButton.Size = UDim2.new(0, 40, 0, 40)
	MinimizeButton.Position = UDim2.new(1, -95, 0.5, -20)
	MinimizeButton.BackgroundColor3 = SelectedTheme.Primary
	MinimizeButton.Text = "−"
	MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	MinimizeButton.TextSize = 20
	MinimizeButton.Font = Enum.Font.GothamBold
	MinimizeButton.BorderSizePixel = 0
	
	local MinCorner = Instance.new("UICorner")
	MinCorner.CornerRadius = UDim.new(0, 8)
	MinCorner.Parent = MinimizeButton
	
	return Topbar
end

-- Create left sidebar for tabs
local function CreateSidebar(parent)
	local Sidebar = Instance.new("Frame")
	Sidebar.Name = "Sidebar"
	Sidebar.Parent = parent
	Sidebar.Size = UDim2.new(0, 200, 1, -50)
	Sidebar.Position = UDim2.new(0, 0, 0, 50)
	Sidebar.BackgroundColor3 = SelectedTheme.SecondaryBackground
	Sidebar.BorderSizePixel = 0
	
	-- Tab list container
	local TabList = Instance.new("ScrollingFrame")
	TabList.Name = "TabList"
	TabList.Parent = Sidebar
	TabList.Size = UDim2.new(1, -10, 1, -20)
	TabList.Position = UDim2.new(0, 5, 0, 10)
	TabList.BackgroundTransparency = 1
	TabList.BorderSizePixel = 0
	TabList.ScrollBarThickness = 4
	TabList.ScrollBarImageColor3 = SelectedTheme.Primary
	TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
	
	-- List layout for tabs
	local ListLayout = Instance.new("UIListLayout")
	ListLayout.Parent = TabList
	ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	ListLayout.Padding = UDim.new(0, 5)
	
	-- Auto-resize canvas
	ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		TabList.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
	end)
	
	-- Template tab button
	local Template = Instance.new("Frame")
	Template.Name = "Template"
	Template.Parent = TabList
	Template.Size = UDim2.new(1, 0, 0, 40)
	Template.BackgroundColor3 = SelectedTheme.TabBackground
	Template.BorderSizePixel = 0
	Template.Visible = false
	
	local TemplateCorner = Instance.new("UICorner")
	TemplateCorner.CornerRadius = UDim.new(0, 8)
	TemplateCorner.Parent = Template
	
	local TemplateStroke = Instance.new("UIStroke")
	TemplateStroke.Color = SelectedTheme.TabStroke
	TemplateStroke.Thickness = 1
	TemplateStroke.Parent = Template
	
	local TemplateTitle = Instance.new("TextLabel")
	TemplateTitle.Name = "Title"
	TemplateTitle.Parent = Template
	TemplateTitle.Size = UDim2.new(1, -15, 1, 0)
	TemplateTitle.Position = UDim2.new(0, 15, 0, 0)
	TemplateTitle.BackgroundTransparency = 1
	TemplateTitle.Text = "Tab"
	TemplateTitle.TextColor3 = SelectedTheme.TabTextColor
	TemplateTitle.TextSize = 14
	TemplateTitle.TextXAlignment = Enum.TextXAlignment.Left
	TemplateTitle.Font = Enum.Font.Gotham
	
	local TemplateButton = Instance.new("TextButton")
	TemplateButton.Name = "Interact"
	TemplateButton.Parent = Template
	TemplateButton.Size = UDim2.new(1, 0, 1, 0)
	TemplateButton.BackgroundTransparency = 1
	TemplateButton.Text = ""
	
	return Sidebar, TabList
end

-- Create main content area
local function CreateContent(parent)
	local ContentArea = Instance.new("Frame")
	ContentArea.Name = "ContentArea"
	ContentArea.Parent = parent
	ContentArea.Size = UDim2.new(1, -200, 1, -50)
	ContentArea.Position = UDim2.new(0, 200, 0, 50)
	ContentArea.BackgroundColor3 = SelectedTheme.Background
	ContentArea.BorderSizePixel = 0
	
	-- Elements container
	local Elements = Instance.new("Frame")
	Elements.Name = "Elements"
	Elements.Parent = ContentArea
	Elements.Size = UDim2.new(1, 0, 1, 0)
	Elements.BackgroundTransparency = 1
	Elements.BorderSizePixel = 0
	
	-- Page layout for switching between tabs
	local PageLayout = Instance.new("UIPageLayout")
	PageLayout.Name = "UIPageLayout"
	PageLayout.Parent = Elements
	PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
	PageLayout.Animated = true
	PageLayout.AnimationDirection = Enum.AnimationDirection.Left
	PageLayout.EasingDirection = Enum.EasingDirection.Out
	PageLayout.EasingStyle = Enum.EasingStyle.Exponential
	PageLayout.TweenTime = 0.3
	
	-- Template page
	local Template = Instance.new("ScrollingFrame")
	Template.Name = "Template"
	Template.Parent = Elements
	Template.Size = UDim2.new(1, 0, 1, 0)
	Template.BackgroundTransparency = 1
	Template.BorderSizePixel = 0
	Template.ScrollBarThickness = 6
	Template.ScrollBarImageColor3 = SelectedTheme.Primary
	Template.CanvasSize = UDim2.new(0, 0, 0, 0)
	Template.Visible = false
	
	local TemplateLayout = Instance.new("UIListLayout")
	TemplateLayout.Parent = Template
	TemplateLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TemplateLayout.Padding = UDim.new(0, 10)
	
	local TemplatePadding = Instance.new("UIPadding")
	TemplatePadding.Parent = Template
	TemplatePadding.PaddingTop = UDim.new(0, 15)
	TemplatePadding.PaddingBottom = UDim.new(0, 15)
	TemplatePadding.PaddingLeft = UDim.new(0, 15)
	TemplatePadding.PaddingRight = UDim.new(0, 15)
	
	-- Auto-resize canvas
	TemplateLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		Template.CanvasSize = UDim2.new(0, 0, 0, TemplateLayout.AbsoluteContentSize.Y + 30)
	end)
	
	return Elements
end

-- Create element templates
local function CreateElementTemplates(parent)
	local ElementsFolder = Instance.new("Folder")
	ElementsFolder.Name = "ElementTemplates"
	ElementsFolder.Parent = parent
	
	-- Button template
	local Button = Instance.new("Frame")
	Button.Name = "Button"
	Button.Parent = ElementsFolder
	Button.Size = UDim2.new(1, 0, 0, 45)
	Button.BackgroundColor3 = SelectedTheme.ElementBackground
	Button.BorderSizePixel = 0
	
	local ButtonCorner = Instance.new("UICorner")
	ButtonCorner.CornerRadius = UDim.new(0, 8)
	ButtonCorner.Parent = Button
	
	local ButtonStroke = Instance.new("UIStroke")
	ButtonStroke.Name = "UIStroke"
	ButtonStroke.Color = SelectedTheme.ElementStroke
	ButtonStroke.Thickness = 1
	ButtonStroke.Parent = Button
	
	local ButtonTitle = Instance.new("TextLabel")
	ButtonTitle.Name = "Title"
	ButtonTitle.Parent = Button
	ButtonTitle.Size = UDim2.new(1, -20, 1, 0)
	ButtonTitle.Position = UDim2.new(0, 20, 0, 0)
	ButtonTitle.BackgroundTransparency = 1
	ButtonTitle.Text = "Button"
	ButtonTitle.TextColor3 = SelectedTheme.TextPrimary
	ButtonTitle.TextSize = 14
	ButtonTitle.TextXAlignment = Enum.TextXAlignment.Left
	ButtonTitle.Font = Enum.Font.Gotham
	
	local ButtonInteract = Instance.new("TextButton")
	ButtonInteract.Name = "Interact"
	ButtonInteract.Parent = Button
	ButtonInteract.Size = UDim2.new(1, 0, 1, 0)
	ButtonInteract.BackgroundTransparency = 1
	ButtonInteract.Text = ""
	
	-- Toggle template
	local Toggle = Instance.new("Frame")
	Toggle.Name = "Toggle"
	Toggle.Parent = ElementsFolder
	Toggle.Size = UDim2.new(1, 0, 0, 45)
	Toggle.BackgroundColor3 = SelectedTheme.ElementBackground
	Toggle.BorderSizePixel = 0
	
	local ToggleCorner = Instance.new("UICorner")
	ToggleCorner.CornerRadius = UDim.new(0, 8)
	ToggleCorner.Parent = Toggle
	
	local ToggleStroke = Instance.new("UIStroke")
	ToggleStroke.Name = "UIStroke"
	ToggleStroke.Color = SelectedTheme.ElementStroke
	ToggleStroke.Thickness = 1
	ToggleStroke.Parent = Toggle
	
	local ToggleTitle = Instance.new("TextLabel")
	ToggleTitle.Name = "Title"
	ToggleTitle.Parent = Toggle
	ToggleTitle.Size = UDim2.new(1, -70, 1, 0)
	ToggleTitle.Position = UDim2.new(0, 20, 0, 0)
	ToggleTitle.BackgroundTransparency = 1
	ToggleTitle.Text = "Toggle"
	ToggleTitle.TextColor3 = SelectedTheme.TextPrimary
	ToggleTitle.TextSize = 14
	ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
	ToggleTitle.Font = Enum.Font.Gotham
	
	local ToggleSwitch = Instance.new("Frame")
	ToggleSwitch.Name = "Switch"
	ToggleSwitch.Parent = Toggle
	ToggleSwitch.Size = UDim2.new(0, 45, 0, 25)
	ToggleSwitch.Position = UDim2.new(1, -60, 0.5, -12.5)
	ToggleSwitch.BackgroundColor3 = SelectedTheme.ToggleBackground
	ToggleSwitch.BorderSizePixel = 0
	
	local SwitchCorner = Instance.new("UICorner")
	SwitchCorner.CornerRadius = UDim.new(0.5, 0)
	SwitchCorner.Parent = ToggleSwitch
	
	local SwitchStroke = Instance.new("UIStroke")
	SwitchStroke.Name = "SwitchStroke"
	SwitchStroke.Color = SelectedTheme.ToggleDisabledStroke
	SwitchStroke.Thickness = 1
	SwitchStroke.Parent = ToggleSwitch
	
	local SwitchKnob = Instance.new("Frame")
	SwitchKnob.Name = "Knob"
	SwitchKnob.Parent = ToggleSwitch
	SwitchKnob.Size = UDim2.new(0, 19, 0, 19)
	SwitchKnob.Position = UDim2.new(0, 3, 0.5, -9.5)
	SwitchKnob.BackgroundColor3 = SelectedTheme.ToggleDisabled
	SwitchKnob.BorderSizePixel = 0
	
	local KnobCorner = Instance.new("UICorner")
	KnobCorner.CornerRadius = UDim.new(0.5, 0)
	KnobCorner.Parent = SwitchKnob
	
	local ToggleInteract = Instance.new("TextButton")
	ToggleInteract.Name = "Interact"
	ToggleInteract.Parent = Toggle
	ToggleInteract.Size = UDim2.new(1, 0, 1, 0)
	ToggleInteract.BackgroundTransparency = 1
	ToggleInteract.Text = ""
	
	return ElementsFolder
end

-- Main library functions
function OverflowHub:CreateWindow(Settings)
	Settings = Settings or {}
	
	local ScreenGui = CreateScreenGui()
	local Main = CreateMainFrame(ScreenGui)
	local Topbar = CreateTopbar(Main, Settings.Name)
	local Sidebar, TabList = CreateSidebar(Main)
	local Elements = CreateContent(Main)
	local ElementTemplates = CreateElementTemplates(ScreenGui)
	
	-- Make window draggable
	local dragging = false
	local dragStart = nil
	local startPos = nil
	
	Topbar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = Main.Position
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
	
	-- Close and minimize functionality
	Topbar.Close.MouseButton1Click:Connect(function()
		ScreenGui:Destroy()
	end)
	
	Topbar.Minimize.MouseButton1Click:Connect(function()
		if not Minimised then
			TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {
				Size = UDim2.new(0, 700, 0, 50)
			}):Play()
			Minimised = true
		else
			TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {
				Size = UDim2.new(0, 700, 0, 500)
			}):Play()
			Minimised = false
		end
	end)
	
	-- Window object
	local Window = {}
	
	function Window:CreateTab(Name, Image, Ext)
		local TabButton = TabList.Template:Clone()
		TabButton.Name = Name
		TabButton.Title.Text = Name
		TabButton.Parent = TabList
		TabButton.Visible = true
		
		-- Create tab page
		local TabPage = Elements.Template:Clone()
		TabPage.Name = Name
		TabPage.Visible = true
		TabPage.Parent = Elements
		
		-- Remove template elements
		for _, child in ipairs(TabPage:GetChildren()) do
			if child.ClassName == "Frame" and child.Name ~= "Placeholder" then
				child:Destroy()
			end
		end
		
		-- Set as first tab if none exists
		if not FirstTab then
			FirstTab = Name
			Elements.UIPageLayout:JumpTo(TabPage)
			
			-- Style as selected tab
			TabButton.BackgroundColor3 = SelectedTheme.TabBackgroundSelected
			TabButton.Title.TextColor3 = SelectedTheme.SelectedTabTextColor
			TweenService:Create(TabButton, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
			TweenService:Create(TabButton.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
		else
			-- Style as unselected tab
			TabButton.BackgroundColor3 = SelectedTheme.TabBackground
			TabButton.Title.TextColor3 = SelectedTheme.TabTextColor
			TweenService:Create(TabButton, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.3}):Play()
			TweenService:Create(TabButton.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0.2}):Play()
		end
		
		-- Tab button click handler
		TabButton.Interact.MouseButton1Click:Connect(function()
			if Minimised then return end
			
			-- Update current tab appearance
			TweenService:Create(TabButton, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {
				BackgroundColor3 = SelectedTheme.TabBackgroundSelected,
				BackgroundTransparency = 0
			}):Play()
			TweenService:Create(TabButton.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {
				TextColor3 = SelectedTheme.SelectedTabTextColor,
				TextTransparency = 0
			}):Play()
			
			-- Update other tabs appearance
			for _, otherTab in ipairs(TabList:GetChildren()) do
				if otherTab.Name ~= "Template" and otherTab ~= TabButton and otherTab.ClassName == "Frame" then
					TweenService:Create(otherTab, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {
						BackgroundColor3 = SelectedTheme.TabBackground,
						BackgroundTransparency = 0.3
					}):Play()
					TweenService:Create(otherTab.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {
						TextColor3 = SelectedTheme.TabTextColor,
						TextTransparency = 0.2
					}):Play()
				end
			end
			
			-- Switch to tab page
			Elements.UIPageLayout:JumpTo(TabPage)
		end)
		
		-- Tab object
		local Tab = {}
		
		-- Create Button
		function Tab:CreateButton(ButtonSettings)
			local Button = ElementTemplates.Button:Clone()
			Button.Name = ButtonSettings.Name
			Button.Title.Text = ButtonSettings.Name
			Button.Parent = TabPage
			Button.Visible = true
			
			-- Animation
			Button.BackgroundTransparency = 1
			Button.UIStroke.Transparency = 1
			Button.Title.TextTransparency = 1
			
			TweenService:Create(Button, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
			TweenService:Create(Button.UIStroke, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
			TweenService:Create(Button.Title, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
			
			-- Button functionality
			Button.Interact.MouseButton1Click:Connect(function()
				local success, result = pcall(ButtonSettings.Callback)
				if success then
					-- Success animation
					TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), {
						BackgroundColor3 = SelectedTheme.PrimaryHover
					}):Play()
					task.wait(0.1)
					TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), {
						BackgroundColor3 = SelectedTheme.ElementBackground
					}):Play()
				else
					-- Error animation
					TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), {
						BackgroundColor3 = Color3.fromRGB(220, 50, 50)
					}):Play()
					warn("Button callback error:", result)
					task.wait(0.5)
					TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), {
						BackgroundColor3 = SelectedTheme.ElementBackground
					}):Play()
				end
			end)
			
			-- Hover effects
			Button.Interact.MouseEnter:Connect(function()
				TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), {
					BackgroundColor3 = SelectedTheme.ElementBackgroundHover
				}):Play()
			end)
			
			Button.Interact.MouseLeave:Connect(function()
				TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), {
					BackgroundColor3 = SelectedTheme.ElementBackground
				}):Play()
			end)
			
			return {
				Set = function(self, NewText)
					Button.Title.Text = NewText
					Button.Name = NewText
				end
			}
		end
		
		-- Create Toggle
		function Tab:CreateToggle(ToggleSettings)
			local Toggle = ElementTemplates.Toggle:Clone()
			Toggle.Name = ToggleSettings.Name
			Toggle.Title.Text = ToggleSettings.Name
			Toggle.Parent = TabPage
			Toggle.Visible = true
			
			local CurrentValue = ToggleSettings.CurrentValue or false
			
			-- Set initial state
			if CurrentValue then
				Toggle.Switch.BackgroundColor3 = SelectedTheme.ToggleEnabled
				Toggle.Switch.SwitchStroke.Color = SelectedTheme.ToggleEnabledStroke
				Toggle.Switch.Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Toggle.Switch.Knob.Position = UDim2.new(0, 23, 0.5, -9.5)
			end
			
			-- Animation
			Toggle.BackgroundTransparency = 1
			Toggle.UIStroke.Transparency = 1
			Toggle.Title.TextTransparency = 1
			
			TweenService:Create(Toggle, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
			TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
			TweenService:Create(Toggle.Title, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
			
			-- Toggle functionality
			Toggle.Interact.MouseButton1Click:Connect(function()
				CurrentValue = not CurrentValue
				
				if CurrentValue then
					-- Enable animation
					TweenService:Create(Toggle.Switch, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), {
						BackgroundColor3 = SelectedTheme.ToggleEnabled
					}):Play()
					TweenService:Create(Toggle.Switch.SwitchStroke, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), {
						Color = SelectedTheme.ToggleEnabledStroke
					}):Play()
					TweenService:Create(Toggle.Switch.Knob, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), {
						Position = UDim2.new(0, 23, 0.5, -9.5),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					}):Play()
				else
					-- Disable animation
					TweenService:Create(Toggle.Switch, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), {
						BackgroundColor3 = SelectedTheme.ToggleBackground
					}):Play()
					TweenService:Create(Toggle.Switch.SwitchStroke, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), {
						Color = SelectedTheme.ToggleDisabledStroke
					}):Play()
					TweenService:Create(Toggle.Switch.Knob, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), {
						Position = UDim2.new(0, 3, 0.5, -9.5),
						BackgroundColor3 = SelectedTheme.ToggleDisabled
					}):Play()
				end
				
				-- Call callback
				local success, result = pcall(ToggleSettings.Callback, CurrentValue)
				if not success then
					warn("Toggle callback error:", result)
				end
			end)
			
			-- Hover effects
			Toggle.Interact.MouseEnter:Connect(function()
				TweenService:Create(Toggle, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), {
					BackgroundColor3 = SelectedTheme.ElementBackgroundHover
				}):Play()
			end)
			
			Toggle.Interact.MouseLeave:Connect(function()
				TweenService:Create(Toggle, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), {
					BackgroundColor3 = SelectedTheme.ElementBackground
				}):Play()
			end)
			
			return {
				Set = function(self, Value)
					CurrentValue = Value
					if CurrentValue then
						TweenService:Create(Toggle.Switch, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), {
							BackgroundColor3 = SelectedTheme.ToggleEnabled
						}):Play()
						TweenService:Create(Toggle.Switch.Knob, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), {
							Position = UDim2.new(0, 23, 0.5, -9.5),
							BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						}):Play()
					else
						TweenService:Create(Toggle.Switch, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), {
							BackgroundColor3 = SelectedTheme.ToggleBackground
						}):Play()
						TweenService:Create(Toggle.Switch.Knob, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), {
							Position = UDim2.new(0, 3, 0.5, -9.5),
							BackgroundColor3 = SelectedTheme.ToggleDisabled
						}):Play()
					end
				end
			}
		end
		
		return Tab
	end
	
	return Window
end

-- Notification system (for compatibility)
function OverflowHub:Notify(NotificationSettings)
	-- Simple notification implementation
	warn("Notification:", NotificationSettings.Title, "-", NotificationSettings.Content)
end

-- Destroy function
function OverflowHub:Destroy()
	local screenGui = game.CoreGui:FindFirstChild("0verflowHub")
	if screenGui then
		screenGui:Destroy()
	end
end

-- Make it compatible with Rayfield naming
local RayfieldLibrary = OverflowHub

return OverflowHub
