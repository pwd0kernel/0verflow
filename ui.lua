--[[
	0verflow Hub - Modern UI Library
	Based on Rayfield Interface Suite
	Dark Purple Theme (#6f0ad6) with Left-Side Tabs
	Modern Minimal Design
]]

local function getService(name)
	return game:GetService(name)
end

local TweenService = getService('TweenService')
local UserInputService = getService('UserInputService')
local RunService = getService('RunService')
local HttpService = getService('HttpService')
local Players = getService("Players")
local CoreGui = getService("CoreGui")

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
			SecondaryElementBackground = Color3.fromRGB(20, 20, 25),
			SecondaryElementStroke = Color3.fromRGB(35, 35, 40),
			
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
local Minimised = false
local Hidden = false
local Debounce = false

-- Create Rayfield-style draggable function
local function makeDraggable(object, dragObject)
	local dragging = false
	local dragStart = nil
	local startPos = nil
	
	dragObject.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = object.Position
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
	
	-- Alternative method for mobile/touch
	dragObject.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	
	dragObject.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
end

-- Hide/Show functions like Rayfield
local function Hide()
	if Debounce then return end
	Debounce = true
	Hidden = true
	
	local Main = OverflowHub.Main
	if Main then
		TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = UDim2.new(0, 470, 0, 0)}):Play()
		TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
		
		task.wait(0.5)
		Main.Visible = false
	end
	
	Debounce = false
end

local function Unhide()
	if Debounce then return end
	Debounce = true
	Hidden = false
	
	local Main = OverflowHub.Main
	if Main then
		Main.Visible = true
		TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = UDim2.new(0, 600, 0, 500)}):Play()
		TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
	end
	
	task.wait(0.5)
	Debounce = false
end

local function Minimise()
	if Debounce then return end
	Debounce = true
	Minimised = true
	
	local Main = OverflowHub.Main
	if Main then
		TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = UDim2.new(0, 600, 0, 50)}):Play()
	end
	
	task.wait(0.5)
	Debounce = false
end

local function Maximise()
	if Debounce then return end
	Debounce = true
	Minimised = false
	
	local Main = OverflowHub.Main
	if Main then
		TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = UDim2.new(0, 600, 0, 500)}):Play()
	end
	
	task.wait(0.5)
	Debounce = false
end

function OverflowHub:CreateWindow(WindowSettings)
	local Settings = WindowSettings or {}
	local windowName = Settings.Name or "0verflow Hub"
	local FirstTab = nil
	
	-- Create ScreenGui similar to Rayfield
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "OverflowHub"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.DisplayOrder = 100
	
	-- Parent to appropriate location (like Rayfield)
	if gethui then
		ScreenGui.Parent = gethui()
	elseif syn and syn.protect_gui then
		syn.protect_gui(ScreenGui)
		ScreenGui.Parent = CoreGui
	else
		ScreenGui.Parent = CoreGui
	end
	
	-- Create shadow frame first (like Rayfield)
	local Shadow = Instance.new("Frame")
	Shadow.Name = "Shadow"
	Shadow.Parent = ScreenGui
	Shadow.BackgroundTransparency = 1
	Shadow.BorderSizePixel = 0
	Shadow.Position = UDim2.new(0.5, -305, 0.5, -255)
	Shadow.Size = UDim2.new(0, 610, 0, 510)
	Shadow.ZIndex = 1
	
	local ShadowImage = Instance.new("ImageLabel")
	ShadowImage.Name = "Image"
	ShadowImage.Parent = Shadow
	ShadowImage.BackgroundTransparency = 1
	ShadowImage.Size = UDim2.new(1, 0, 1, 0)
	ShadowImage.Image = "rbxassetid://8992230677"
	ShadowImage.ImageColor3 = SelectedTheme.Shadow
	ShadowImage.ImageTransparency = 0.6
	ShadowImage.ScaleType = Enum.ScaleType.Slice
	ShadowImage.SliceCenter = Rect.new(99, 99, 99, 99)
	
	-- Main Frame (like Rayfield)
	local Main = Instance.new("Frame")
	Main.Name = "Main"
	Main.Parent = ScreenGui
	Main.BackgroundColor3 = SelectedTheme.Background
	Main.BorderSizePixel = 0
	Main.Position = UDim2.new(0.5, -300, 0.5, -250)
	Main.Size = UDim2.new(0, 600, 0, 500)
	Main.ZIndex = 2
	Main.Active = true
	
	local MainCorner = Instance.new("UICorner")
	MainCorner.CornerRadius = UDim.new(0, 10)
	MainCorner.Parent = Main
	
	-- Store references
	OverflowHub.Main = Main
	OverflowHub.ScreenGui = ScreenGui
	OverflowHub.Shadow = Shadow
	
	-- Topbar (like Rayfield)
	local Topbar = Instance.new("Frame")
	Topbar.Name = "Topbar"
	Topbar.Parent = Main
	Topbar.BackgroundColor3 = SelectedTheme.Topbar
	Topbar.BorderSizePixel = 0
	Topbar.Size = UDim2.new(1, 0, 0, 45)
	Topbar.ZIndex = 3
	Topbar.Active = true
	
	local TopbarCorner = Instance.new("UICorner")
	TopbarCorner.CornerRadius = UDim.new(0, 10)
	TopbarCorner.Parent = Topbar
	
	-- Topbar corner repair
	local TopbarCornerRepair = Instance.new("Frame")
	TopbarCornerRepair.Name = "CornerRepair"
	TopbarCornerRepair.Parent = Topbar
	TopbarCornerRepair.BackgroundColor3 = SelectedTheme.Topbar
	TopbarCornerRepair.BorderSizePixel = 0
	TopbarCornerRepair.Position = UDim2.new(0, 0, 1, -10)
	TopbarCornerRepair.Size = UDim2.new(1, 0, 0, 10)
	TopbarCornerRepair.ZIndex = 3
	
	-- Topbar divider (like Rayfield)
	local TopbarDivider = Instance.new("Frame")
	TopbarDivider.Name = "Divider"
	TopbarDivider.Parent = Topbar
	TopbarDivider.BackgroundColor3 = SelectedTheme.ElementStroke
	TopbarDivider.BorderSizePixel = 0
	TopbarDivider.Position = UDim2.new(0, 0, 1, -1)
	TopbarDivider.Size = UDim2.new(1, 0, 0, 1)
	TopbarDivider.ZIndex = 3
	
	-- Title
	local Title = Instance.new("TextLabel")
	Title.Name = "Title"
	Title.Parent = Topbar
	Title.BackgroundTransparency = 1
	Title.Position = UDim2.new(0, 15, 0, 0)
	Title.Size = UDim2.new(1, -100, 1, 0)
	Title.Font = Enum.Font.GothamMedium
	Title.Text = windowName
	Title.TextColor3 = SelectedTheme.TextColor
	Title.TextSize = 16
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.ZIndex = 4
	
	-- Hide Button (like Rayfield)
	local HideButton = Instance.new("ImageButton")
	HideButton.Name = "Hide"
	HideButton.Parent = Topbar
	HideButton.BackgroundTransparency = 1
	HideButton.Position = UDim2.new(1, -45, 0, 10)
	HideButton.Size = UDim2.new(0, 25, 0, 25)
	HideButton.Image = "rbxassetid://11036884234"
	HideButton.ImageColor3 = SelectedTheme.TextColor
	HideButton.ImageTransparency = 0.2
	HideButton.ZIndex = 4
	
	-- Change Size Button (Minimize/Maximize like Rayfield)
	local ChangeSizeButton = Instance.new("ImageButton")
	ChangeSizeButton.Name = "ChangeSize"
	ChangeSizeButton.Parent = Topbar
	ChangeSizeButton.BackgroundTransparency = 1
	ChangeSizeButton.Position = UDim2.new(1, -80, 0, 10)
	ChangeSizeButton.Size = UDim2.new(0, 25, 0, 25)
	ChangeSizeButton.Image = "rbxassetid://11036941941"
	ChangeSizeButton.ImageColor3 = SelectedTheme.TextColor
	ChangeSizeButton.ImageTransparency = 0.2
	ChangeSizeButton.ZIndex = 4
	
	-- Make draggable (Rayfield style)
	makeDraggable(Main, Topbar)
	
	-- Left Sidebar (Tab List like Rayfield)
	local TabList = Instance.new("Frame")
	TabList.Name = "TabList"
	TabList.Parent = Main
	TabList.BackgroundColor3 = SelectedTheme.SecondaryElementBackground
	TabList.BorderSizePixel = 0
	TabList.Position = UDim2.new(0, 0, 0, 45)
	TabList.Size = UDim2.new(0, 200, 1, -45)
	TabList.ZIndex = 2
	
	local TabListCorner = Instance.new("UICorner")
	TabListCorner.CornerRadius = UDim.new(0, 10)
	TabListCorner.Parent = TabList
	
	-- Corner repairs for TabList
	local TabListTopRepair = Instance.new("Frame")
	TabListTopRepair.Name = "TopRepair"
	TabListTopRepair.Parent = TabList
	TabListTopRepair.BackgroundColor3 = SelectedTheme.SecondaryElementBackground
	TabListTopRepair.BorderSizePixel = 0
	TabListTopRepair.Position = UDim2.new(0, 0, 0, 0)
	TabListTopRepair.Size = UDim2.new(1, 0, 0, 10)
	TabListTopRepair.ZIndex = 2
	
	local TabListRightRepair = Instance.new("Frame")
	TabListRightRepair.Name = "RightRepair"
	TabListRightRepair.Parent = TabList
	TabListRightRepair.BackgroundColor3 = SelectedTheme.SecondaryElementBackground
	TabListRightRepair.BorderSizePixel = 0
	TabListRightRepair.Position = UDim2.new(1, -10, 0, 0)
	TabListRightRepair.Size = UDim2.new(0, 10, 1, 0)
	TabListRightRepair.ZIndex = 2
	
	-- Tab buttons container
	local TabButtonsFrame = Instance.new("ScrollingFrame")
	TabButtonsFrame.Name = "TabButtonsFrame"
	TabButtonsFrame.Parent = TabList
	TabButtonsFrame.BackgroundTransparency = 1
	TabButtonsFrame.BorderSizePixel = 0
	TabButtonsFrame.Position = UDim2.new(0, 10, 0, 10)
	TabButtonsFrame.Size = UDim2.new(1, -20, 1, -20)
	TabButtonsFrame.ScrollBarThickness = 2
	TabButtonsFrame.ScrollBarImageColor3 = SelectedTheme.Primary
	TabButtonsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	TabButtonsFrame.ZIndex = 3
	
	local TabButtonsLayout = Instance.new("UIListLayout")
	TabButtonsLayout.Parent = TabButtonsFrame
	TabButtonsLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TabButtonsLayout.Padding = UDim.new(0, 5)
	
	-- Elements container (like Rayfield)
	local Elements = Instance.new("Frame")
	Elements.Name = "Elements"
	Elements.Parent = Main
	Elements.BackgroundTransparency = 1
	Elements.Position = UDim2.new(0, 210, 0, 55)
	Elements.Size = UDim2.new(1, -220, 1, -65)
	Elements.ZIndex = 2
	
	local ElementsPageLayout = Instance.new("UIPageLayout")
	ElementsPageLayout.Parent = Elements
	ElementsPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
	ElementsPageLayout.EasingStyle = Enum.EasingStyle.Quint
	ElementsPageLayout.EasingDirection = Enum.EasingDirection.Out
	ElementsPageLayout.TweenTime = 0.3
	
	-- Update tab list canvas size
	local function updateTabListCanvas()
		local contentSize = TabButtonsLayout.AbsoluteContentSize
		TabButtonsFrame.CanvasSize = UDim2.new(0, 0, 0, contentSize.Y)
	end
	
	TabButtonsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateTabListCanvas)
	
	-- Button connections (like Rayfield)
	HideButton.MouseButton1Click:Connect(function()
		if not Debounce then
			if Hidden then
				Unhide()
			else
				Hide()
			end
		end
	end)
	
	ChangeSizeButton.MouseButton1Click:Connect(function()
		if not Debounce then
			if Minimised then
				Maximise()
			else
				Minimise()
			end
		end
	end)
	
	-- Window object
	local Window = {
		ScreenGui = ScreenGui,
		Main = Main,
		TabList = TabList,
		TabButtonsFrame = TabButtonsFrame,
		Elements = Elements,
		ElementsPageLayout = ElementsPageLayout,
		TabButtonsLayout = TabButtonsLayout
	}
	
	-- CreateTab function (like Rayfield)
	function Window:CreateTab(Name, Image, Ext)
		local TabName = Name or "Tab"
		
		-- Create Tab Button
		local TabButton = Instance.new("TextButton")
		TabButton.Name = TabName
		TabButton.Parent = TabButtonsFrame
		TabButton.BackgroundColor3 = SelectedTheme.TabBackground
		TabButton.BorderSizePixel = 0
		TabButton.Size = UDim2.new(1, 0, 0, 40)
		TabButton.Font = Enum.Font.Gotham
		TabButton.Text = TabName
		TabButton.TextColor3 = SelectedTheme.TabTextColor
		TabButton.TextSize = 14
		TabButton.ZIndex = 4
		TabButton.Active = true
		
		-- Get proper layout order
		local tabCount = 1
		for _, child in ipairs(TabButtonsFrame:GetChildren()) do
			if child:IsA("TextButton") then
				tabCount = tabCount + 1
			end
		end
		TabButton.LayoutOrder = tabCount
		
		local TabButtonCorner = Instance.new("UICorner")
		TabButtonCorner.CornerRadius = UDim.new(0, 8)
		TabButtonCorner.Parent = TabButton
		
		-- Create Tab Page
		local TabPage = Instance.new("ScrollingFrame")
		TabPage.Name = TabName
		TabPage.Parent = Elements
		TabPage.BackgroundTransparency = 1
		TabPage.BorderSizePixel = 0
		TabPage.Size = UDim2.new(1, 0, 1, 0)
		TabPage.ScrollBarThickness = 3
		TabPage.ScrollBarImageColor3 = SelectedTheme.Primary
		TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
		TabPage.ZIndex = 2
		TabPage.Visible = false
		
		-- Get proper layout order for page
		local pageCount = 1
		for _, child in ipairs(Elements:GetChildren()) do
			if child:IsA("ScrollingFrame") and child.Name ~= "Template" then
				pageCount = pageCount + 1
			end
		end
		TabPage.LayoutOrder = pageCount
		
		local TabPageLayout = Instance.new("UIListLayout")
		TabPageLayout.Parent = TabPage
		TabPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
		TabPageLayout.Padding = UDim.new(0, 8)
		
		local TabPagePadding = Instance.new("UIPadding")
		TabPagePadding.Parent = TabPage
		TabPagePadding.PaddingTop = UDim.new(0, 10)
		TabPagePadding.PaddingLeft = UDim.new(0, 10)
		TabPagePadding.PaddingRight = UDim.new(0, 10)
		TabPagePadding.PaddingBottom = UDim.new(0, 10)
		
		-- Update canvas size when elements are added
		local function updateCanvasSize()
			local contentSize = TabPageLayout.AbsoluteContentSize
			TabPage.CanvasSize = UDim2.new(0, 0, 0, contentSize.Y + 20)
		end
		
		TabPageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvasSize)
		
		-- Set as first tab if none exists
		if not FirstTab then
			FirstTab = TabName
			TabPage.Visible = true
			ElementsPageLayout:JumpTo(TabPage)
			TabButton.BackgroundColor3 = SelectedTheme.TabBackgroundSelected
			TabButton.TextColor3 = SelectedTheme.SelectedTabTextColor
		end
		
		-- Tab button click handler
		TabButton.MouseButton1Click:Connect(function()
			-- Hide all tab pages first
			for _, page in ipairs(Elements:GetChildren()) do
				if page:IsA("ScrollingFrame") then
					page.Visible = false
				end
			end
			
			-- Reset all tab buttons
			for _, button in ipairs(TabButtonsFrame:GetChildren()) do
				if button:IsA("TextButton") then
					button.BackgroundColor3 = SelectedTheme.TabBackground
					button.TextColor3 = SelectedTheme.TabTextColor
				end
			end
			
			-- Set this tab as selected
			TabButton.BackgroundColor3 = SelectedTheme.TabBackgroundSelected
			TabButton.TextColor3 = SelectedTheme.SelectedTabTextColor
			
			-- Show this tab page
			TabPage.Visible = true
			ElementsPageLayout:JumpTo(TabPage)
		end)
		
		-- Tab object
		local Tab = {
			Button = TabButton,
			Page = TabPage,
			Layout = TabPageLayout
		}
		
		-- CreateButton function (like Rayfield)
		function Tab:CreateButton(ButtonSettings)
			local Settings = ButtonSettings or {}
			local ButtonName = Settings.Name or "Button"
			local ButtonCallback = Settings.Callback or function() end
			
			local ButtonFrame = Instance.new("Frame")
			ButtonFrame.Name = ButtonName
			ButtonFrame.Parent = TabPage
			ButtonFrame.BackgroundColor3 = SelectedTheme.ElementBackground
			ButtonFrame.BorderSizePixel = 0
			ButtonFrame.Size = UDim2.new(1, 0, 0, 45)
			ButtonFrame.ZIndex = 3
			
			-- Set layout order
			local elementCount = 0
			for _, child in ipairs(TabPage:GetChildren()) do
				if child:IsA("Frame") or child:IsA("ScrollingFrame") then
					elementCount = elementCount + 1
				end
			end
			ButtonFrame.LayoutOrder = elementCount
			
			local ButtonCorner = Instance.new("UICorner")
			ButtonCorner.CornerRadius = UDim.new(0, 8)
			ButtonCorner.Parent = ButtonFrame
			
			local ButtonStroke = Instance.new("UIStroke")
			ButtonStroke.Color = SelectedTheme.ElementStroke
			ButtonStroke.Thickness = 1
			ButtonStroke.Parent = ButtonFrame
			
			local Button = Instance.new("TextButton")
			Button.Name = "Button"
			Button.Parent = ButtonFrame
			Button.BackgroundTransparency = 1
			Button.Size = UDim2.new(1, 0, 1, 0)
			Button.Font = Enum.Font.Gotham
			Button.Text = ButtonName
			Button.TextColor3 = SelectedTheme.TextColor
			Button.TextSize = 14
			Button.ZIndex = 4
			
			-- Button interactions
			Button.MouseEnter:Connect(function()
				TweenService:Create(ButtonFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
					BackgroundColor3 = SelectedTheme.ElementBackgroundHover
				}):Play()
			end)
			
			Button.MouseLeave:Connect(function()
				TweenService:Create(ButtonFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
					BackgroundColor3 = SelectedTheme.ElementBackground
				}):Play()
			end)
			
			Button.MouseButton1Click:Connect(function()
				ButtonCallback()
			end)
			
			updateCanvasSize()
			
			local ButtonObject = {
				Frame = ButtonFrame,
				Button = Button
			}
			
			return ButtonObject
		end
		
		-- CreateToggle function (like Rayfield)
		function Tab:CreateToggle(ToggleSettings)
			local Settings = ToggleSettings or {}
			local ToggleName = Settings.Name or "Toggle"
			local ToggleDefault = Settings.CurrentValue or false
			local ToggleCallback = Settings.Callback or function() end
			local ToggleFlag = Settings.Flag or ToggleName
			
			local ToggleFrame = Instance.new("Frame")
			ToggleFrame.Name = ToggleName
			ToggleFrame.Parent = TabPage
			ToggleFrame.BackgroundColor3 = SelectedTheme.ElementBackground
			ToggleFrame.BorderSizePixel = 0
			ToggleFrame.Size = UDim2.new(1, 0, 0, 45)
			ToggleFrame.ZIndex = 3
			
			-- Set layout order
			local elementCount = 0
			for _, child in ipairs(TabPage:GetChildren()) do
				if child:IsA("Frame") or child:IsA("ScrollingFrame") then
					elementCount = elementCount + 1
				end
			end
			ToggleFrame.LayoutOrder = elementCount
			
			local ToggleCorner = Instance.new("UICorner")
			ToggleCorner.CornerRadius = UDim.new(0, 8)
			ToggleCorner.Parent = ToggleFrame
			
			local ToggleStroke = Instance.new("UIStroke")
			ToggleStroke.Color = SelectedTheme.ElementStroke
			ToggleStroke.Thickness = 1
			ToggleStroke.Parent = ToggleFrame
			
			local ToggleLabel = Instance.new("TextLabel")
			ToggleLabel.Name = "Label"
			ToggleLabel.Parent = ToggleFrame
			ToggleLabel.BackgroundTransparency = 1
			ToggleLabel.Position = UDim2.new(0, 15, 0, 0)
			ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
			ToggleLabel.Font = Enum.Font.Gotham
			ToggleLabel.Text = ToggleName
			ToggleLabel.TextColor3 = SelectedTheme.TextColor
			ToggleLabel.TextSize = 14
			ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
			ToggleLabel.ZIndex = 4
			
			local ToggleButton = Instance.new("TextButton")
			ToggleButton.Name = "Toggle"
			ToggleButton.Parent = ToggleFrame
			ToggleButton.BackgroundColor3 = ToggleDefault and SelectedTheme.ToggleEnabled or SelectedTheme.ToggleDisabled
			ToggleButton.BorderSizePixel = 0
			ToggleButton.Position = UDim2.new(1, -40, 0.5, -10)
			ToggleButton.Size = UDim2.new(0, 35, 0, 20)
			ToggleButton.Text = ""
			ToggleButton.ZIndex = 4
			
			local ToggleButtonCorner = Instance.new("UICorner")
			ToggleButtonCorner.CornerRadius = UDim.new(0, 10)
			ToggleButtonCorner.Parent = ToggleButton
			
			local ToggleCircle = Instance.new("Frame")
			ToggleCircle.Name = "Circle"
			ToggleCircle.Parent = ToggleButton
			ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ToggleCircle.BorderSizePixel = 0
			ToggleCircle.Position = ToggleDefault and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
			ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
			ToggleCircle.ZIndex = 5
			
			local ToggleCircleCorner = Instance.new("UICorner")
			ToggleCircleCorner.CornerRadius = UDim.new(0, 8)
			ToggleCircleCorner.Parent = ToggleCircle
			
			local CurrentValue = ToggleDefault
			
			-- Store in flags
			OverflowHub.Flags[ToggleFlag] = {
				Value = CurrentValue,
				Type = "Toggle",
				Set = function(value)
					CurrentValue = value
					TweenService:Create(ToggleButton, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
						BackgroundColor3 = CurrentValue and SelectedTheme.ToggleEnabled or SelectedTheme.ToggleDisabled
					}):Play()
					TweenService:Create(ToggleCircle, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
						Position = CurrentValue and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
					}):Play()
					ToggleCallback(CurrentValue)
				end
			}
			
			-- Toggle interactions
			ToggleButton.MouseButton1Click:Connect(function()
				CurrentValue = not CurrentValue
				OverflowHub.Flags[ToggleFlag].Value = CurrentValue
				
				TweenService:Create(ToggleButton, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
					BackgroundColor3 = CurrentValue and SelectedTheme.ToggleEnabled or SelectedTheme.ToggleDisabled
				}):Play()
				TweenService:Create(ToggleCircle, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
					Position = CurrentValue and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
				}):Play()
				
				ToggleCallback(CurrentValue)
			end)
			
			updateCanvasSize()
			
			local ToggleObject = {
				Frame = ToggleFrame,
				Button = ToggleButton,
				CurrentValue = CurrentValue,
				Set = OverflowHub.Flags[ToggleFlag].Set
			}
			
			return ToggleObject
		end
		
		-- CreateLabel function (like Rayfield)
		function Tab:CreateLabel(LabelSettings)
			local Settings = LabelSettings or {}
			local LabelText = Settings.Text or Settings.Name or "Label"
			
			local LabelFrame = Instance.new("Frame")
			LabelFrame.Name = "Label"
			LabelFrame.Parent = TabPage
			LabelFrame.BackgroundColor3 = SelectedTheme.ElementBackground
			LabelFrame.BorderSizePixel = 0
			LabelFrame.Size = UDim2.new(1, 0, 0, 35)
			LabelFrame.ZIndex = 3
			
			-- Set layout order
			local elementCount = 0
			for _, child in ipairs(TabPage:GetChildren()) do
				if child:IsA("Frame") or child:IsA("ScrollingFrame") then
					elementCount = elementCount + 1
				end
			end
			LabelFrame.LayoutOrder = elementCount
			
			local LabelCorner = Instance.new("UICorner")
			LabelCorner.CornerRadius = UDim.new(0, 8)
			LabelCorner.Parent = LabelFrame
			
			local LabelStroke = Instance.new("UIStroke")
			LabelStroke.Color = SelectedTheme.ElementStroke
			LabelStroke.Thickness = 1
			LabelStroke.Parent = LabelFrame
			
			local Label = Instance.new("TextLabel")
			Label.Name = "Label"
			Label.Parent = LabelFrame
			Label.BackgroundTransparency = 1
			Label.Position = UDim2.new(0, 15, 0, 0)
			Label.Size = UDim2.new(1, -30, 1, 0)
			Label.Font = Enum.Font.Gotham
			Label.Text = LabelText
			Label.TextColor3 = SelectedTheme.TextColor
			Label.TextSize = 14
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.TextYAlignment = Enum.TextYAlignment.Center
			Label.TextWrapped = true
			Label.ZIndex = 4
			
			updateCanvasSize()
			
			local LabelObject = {
				Frame = LabelFrame,
				Label = Label,
				Set = function(newText)
					Label.Text = newText
				end
			}
			
			return LabelObject
		end
		
		-- CreateSection function (like Rayfield)
		function Tab:CreateSection(SectionSettings)
			local Settings = SectionSettings or {}
			local SectionName = Settings.Name or "Section"
			
			local SectionFrame = Instance.new("Frame")
			SectionFrame.Name = SectionName
			SectionFrame.Parent = TabPage
			SectionFrame.BackgroundTransparency = 1
			SectionFrame.BorderSizePixel = 0
			SectionFrame.Size = UDim2.new(1, 0, 0, 30)
			SectionFrame.ZIndex = 3
			
			-- Set layout order
			local elementCount = 0
			for _, child in ipairs(TabPage:GetChildren()) do
				if child:IsA("Frame") or child:IsA("ScrollingFrame") then
					elementCount = elementCount + 1
				end
			end
			SectionFrame.LayoutOrder = elementCount
			
			local SectionLabel = Instance.new("TextLabel")
			SectionLabel.Name = "Label"
			SectionLabel.Parent = SectionFrame
			SectionLabel.BackgroundTransparency = 1
			SectionLabel.Position = UDim2.new(0, 0, 0, 0)
			SectionLabel.Size = UDim2.new(1, 0, 1, 0)
			SectionLabel.Font = Enum.Font.GothamBold
			SectionLabel.Text = SectionName
			SectionLabel.TextColor3 = SelectedTheme.Primary
			SectionLabel.TextSize = 16
			SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
			SectionLabel.ZIndex = 4
			
			updateCanvasSize()
			
			local SectionObject = {
				Frame = SectionFrame,
				Label = SectionLabel
			}
			
			return SectionObject
		end
		
		-- CreateParagraph function (like Rayfield)
		function Tab:CreateParagraph(ParagraphSettings)
			local Settings = ParagraphSettings or {}
			local ParagraphTitle = Settings.Title or "Paragraph"
			local ParagraphContent = Settings.Content or "Content"
			
			local ParagraphFrame = Instance.new("Frame")
			ParagraphFrame.Name = ParagraphTitle
			ParagraphFrame.Parent = TabPage
			ParagraphFrame.BackgroundColor3 = SelectedTheme.ElementBackground
			ParagraphFrame.BorderSizePixel = 0
			ParagraphFrame.Size = UDim2.new(1, 0, 0, 80)
			ParagraphFrame.ZIndex = 3
			
			-- Set layout order
			local elementCount = 0
			for _, child in ipairs(TabPage:GetChildren()) do
				if child:IsA("Frame") or child:IsA("ScrollingFrame") then
					elementCount = elementCount + 1
				end
			end
			ParagraphFrame.LayoutOrder = elementCount
			
			local ParagraphCorner = Instance.new("UICorner")
			ParagraphCorner.CornerRadius = UDim.new(0, 8)
			ParagraphCorner.Parent = ParagraphFrame
			
			local ParagraphStroke = Instance.new("UIStroke")
			ParagraphStroke.Color = SelectedTheme.ElementStroke
			ParagraphStroke.Thickness = 1
			ParagraphStroke.Parent = ParagraphFrame
			
			local TitleLabel = Instance.new("TextLabel")
			TitleLabel.Name = "Title"
			TitleLabel.Parent = ParagraphFrame
			TitleLabel.BackgroundTransparency = 1
			TitleLabel.Position = UDim2.new(0, 15, 0, 5)
			TitleLabel.Size = UDim2.new(1, -30, 0, 20)
			TitleLabel.Font = Enum.Font.GothamBold
			TitleLabel.Text = ParagraphTitle
			TitleLabel.TextColor3 = SelectedTheme.TextColor
			TitleLabel.TextSize = 15
			TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
			TitleLabel.ZIndex = 4
			
			local ContentLabel = Instance.new("TextLabel")
			ContentLabel.Name = "Content"
			ContentLabel.Parent = ParagraphFrame
			ContentLabel.BackgroundTransparency = 1
			ContentLabel.Position = UDim2.new(0, 15, 0, 25)
			ContentLabel.Size = UDim2.new(1, -30, 1, -30)
			ContentLabel.Font = Enum.Font.Gotham
			ContentLabel.Text = ParagraphContent
			ContentLabel.TextColor3 = SelectedTheme.TextSecondary
			ContentLabel.TextSize = 13
			ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
			ContentLabel.TextYAlignment = Enum.TextYAlignment.Top
			ContentLabel.TextWrapped = true
			ContentLabel.ZIndex = 4
			
			updateCanvasSize()
			
			local ParagraphObject = {
				Frame = ParagraphFrame,
				Title = TitleLabel,
				Content = ContentLabel,
				Set = function(newTitle, newContent)
					if newTitle then TitleLabel.Text = newTitle end
					if newContent then ContentLabel.Text = newContent end
				end
			}
			
			return ParagraphObject
		end
		
		-- CreateSlider function (like Rayfield)
		function Tab:CreateSlider(SliderSettings)
			local Settings = SliderSettings or {}
			local SliderName = Settings.Name or "Slider"
			local SliderMin = Settings.Min or 0
			local SliderMax = Settings.Max or 100
			local SliderDefault = Settings.CurrentValue or SliderMin
			local SliderCallback = Settings.Callback or function() end
			local SliderFlag = Settings.Flag or SliderName
			local SliderSuffix = Settings.Suffix or ""
			
			local SliderFrame = Instance.new("Frame")
			SliderFrame.Name = SliderName
			SliderFrame.Parent = TabPage
			SliderFrame.BackgroundColor3 = SelectedTheme.ElementBackground
			SliderFrame.BorderSizePixel = 0
			SliderFrame.Size = UDim2.new(1, 0, 0, 60)
			SliderFrame.ZIndex = 3
			
			-- Set layout order
			local elementCount = 0
			for _, child in ipairs(TabPage:GetChildren()) do
				if child:IsA("Frame") or child:IsA("ScrollingFrame") then
					elementCount = elementCount + 1
				end
			end
			SliderFrame.LayoutOrder = elementCount
			
			local SliderCorner = Instance.new("UICorner")
			SliderCorner.CornerRadius = UDim.new(0, 8)
			SliderCorner.Parent = SliderFrame
			
			local SliderStroke = Instance.new("UIStroke")
			SliderStroke.Color = SelectedTheme.ElementStroke
			SliderStroke.Thickness = 1
			SliderStroke.Parent = SliderFrame
			
			local SliderLabel = Instance.new("TextLabel")
			SliderLabel.Name = "Label"
			SliderLabel.Parent = SliderFrame
			SliderLabel.BackgroundTransparency = 1
			SliderLabel.Position = UDim2.new(0, 15, 0, 5)
			SliderLabel.Size = UDim2.new(1, -60, 0, 20)
			SliderLabel.Font = Enum.Font.Gotham
			SliderLabel.Text = SliderName
			SliderLabel.TextColor3 = SelectedTheme.TextColor
			SliderLabel.TextSize = 14
			SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
			SliderLabel.ZIndex = 4
			
			local SliderValue = Instance.new("TextLabel")
			SliderValue.Name = "Value"
			SliderValue.Parent = SliderFrame
			SliderValue.BackgroundTransparency = 1
			SliderValue.Position = UDim2.new(1, -50, 0, 5)
			SliderValue.Size = UDim2.new(0, 45, 0, 20)
			SliderValue.Font = Enum.Font.Gotham
			SliderValue.Text = tostring(SliderDefault) .. SliderSuffix
			SliderValue.TextColor3 = SelectedTheme.Primary
			SliderValue.TextSize = 14
			SliderValue.TextXAlignment = Enum.TextXAlignment.Right
			SliderValue.ZIndex = 4
			
			local SliderTrack = Instance.new("Frame")
			SliderTrack.Name = "Track"
			SliderTrack.Parent = SliderFrame
			SliderTrack.BackgroundColor3 = SelectedTheme.SecondaryElementBackground
			SliderTrack.BorderSizePixel = 0
			SliderTrack.Position = UDim2.new(0, 15, 0, 35)
			SliderTrack.Size = UDim2.new(1, -30, 0, 6)
			SliderTrack.ZIndex = 4
			
			local SliderTrackCorner = Instance.new("UICorner")
			SliderTrackCorner.CornerRadius = UDim.new(0, 3)
			SliderTrackCorner.Parent = SliderTrack
			
			local SliderFill = Instance.new("Frame")
			SliderFill.Name = "Fill"
			SliderFill.Parent = SliderTrack
			SliderFill.BackgroundColor3 = SelectedTheme.Primary
			SliderFill.BorderSizePixel = 0
			SliderFill.Size = UDim2.new((SliderDefault - SliderMin) / (SliderMax - SliderMin), 0, 1, 0)
			SliderFill.ZIndex = 5
			
			local SliderFillCorner = Instance.new("UICorner")
			SliderFillCorner.CornerRadius = UDim.new(0, 3)
			SliderFillCorner.Parent = SliderFill
			
			local SliderKnob = Instance.new("Frame")
			SliderKnob.Name = "Knob"
			SliderKnob.Parent = SliderTrack
			SliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SliderKnob.BorderSizePixel = 0
			SliderKnob.Position = UDim2.new((SliderDefault - SliderMin) / (SliderMax - SliderMin), -6, 0.5, -6)
			SliderKnob.Size = UDim2.new(0, 12, 0, 12)
			SliderKnob.ZIndex = 6
			
			local SliderKnobCorner = Instance.new("UICorner")
			SliderKnobCorner.CornerRadius = UDim.new(0, 6)
			SliderKnobCorner.Parent = SliderKnob
			
			local CurrentValue = SliderDefault
			local Dragging = false
			
			-- Store in flags
			OverflowHub.Flags[SliderFlag] = {
				Value = CurrentValue,
				Type = "Slider",
				Set = function(value)
					CurrentValue = math.clamp(value, SliderMin, SliderMax)
					local percent = (CurrentValue - SliderMin) / (SliderMax - SliderMin)
					
					SliderValue.Text = tostring(CurrentValue) .. SliderSuffix
					TweenService:Create(SliderFill, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
						Size = UDim2.new(percent, 0, 1, 0)
					}):Play()
					TweenService:Create(SliderKnob, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
						Position = UDim2.new(percent, -6, 0.5, -6)
					}):Play()
					
					SliderCallback(CurrentValue)
				end
			}
			
			-- Slider interactions
			SliderTrack.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					Dragging = true
					local percent = math.clamp((input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
					CurrentValue = math.floor(SliderMin + (SliderMax - SliderMin) * percent)
					OverflowHub.Flags[SliderFlag].Set(CurrentValue)
				end
			end)
			
			UserInputService.InputChanged:Connect(function(input)
				if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					local percent = math.clamp((input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
					CurrentValue = math.floor(SliderMin + (SliderMax - SliderMin) * percent)
					OverflowHub.Flags[SliderFlag].Set(CurrentValue)
				end
			end)
			
			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					Dragging = false
				end
			end)
			
			updateCanvasSize()
			
			local SliderObject = {
				Frame = SliderFrame,
				Track = SliderTrack,
				Fill = SliderFill,
				Knob = SliderKnob,
				CurrentValue = CurrentValue,
				Set = OverflowHub.Flags[SliderFlag].Set
			}
			
			return SliderObject
		end
		
		-- CreateDropdown function (like Rayfield)
		function Tab:CreateDropdown(DropdownSettings)
			local Settings = DropdownSettings or {}
			local DropdownName = Settings.Name or "Dropdown"
			local DropdownOptions = Settings.Options or {"Option 1", "Option 2"}
			local DropdownDefault = Settings.CurrentOption or DropdownOptions[1]
			local DropdownCallback = Settings.Callback or function() end
			local DropdownFlag = Settings.Flag or DropdownName
			
			local DropdownFrame = Instance.new("Frame")
			DropdownFrame.Name = DropdownName
			DropdownFrame.Parent = TabPage
			DropdownFrame.BackgroundColor3 = SelectedTheme.ElementBackground
			DropdownFrame.BorderSizePixel = 0
			DropdownFrame.Size = UDim2.new(1, 0, 0, 45)
			DropdownFrame.ZIndex = 3
			
			-- Set layout order
			local elementCount = 0
			for _, child in ipairs(TabPage:GetChildren()) do
				if child:IsA("Frame") or child:IsA("ScrollingFrame") then
					elementCount = elementCount + 1
				end
			end
			DropdownFrame.LayoutOrder = elementCount
			
			local DropdownCorner = Instance.new("UICorner")
			DropdownCorner.CornerRadius = UDim.new(0, 8)
			DropdownCorner.Parent = DropdownFrame
			
			local DropdownStroke = Instance.new("UIStroke")
			DropdownStroke.Color = SelectedTheme.ElementStroke
			DropdownStroke.Thickness = 1
			DropdownStroke.Parent = DropdownFrame
			
			local DropdownLabel = Instance.new("TextLabel")
			DropdownLabel.Name = "Label"
			DropdownLabel.Parent = DropdownFrame
			DropdownLabel.BackgroundTransparency = 1
			DropdownLabel.Position = UDim2.new(0, 15, 0, 0)
			DropdownLabel.Size = UDim2.new(0.5, -10, 1, 0)
			DropdownLabel.Font = Enum.Font.Gotham
			DropdownLabel.Text = DropdownName
			DropdownLabel.TextColor3 = SelectedTheme.TextColor
			DropdownLabel.TextSize = 14
			DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
			DropdownLabel.ZIndex = 4
			
			local DropdownButton = Instance.new("TextButton")
			DropdownButton.Name = "Button"
			DropdownButton.Parent = DropdownFrame
			DropdownButton.BackgroundColor3 = SelectedTheme.SecondaryElementBackground
			DropdownButton.BorderSizePixel = 0
			DropdownButton.Position = UDim2.new(0.5, 5, 0, 8)
			DropdownButton.Size = UDim2.new(0.5, -20, 0, 29)
			DropdownButton.Font = Enum.Font.Gotham
			DropdownButton.Text = DropdownDefault
			DropdownButton.TextColor3 = SelectedTheme.TextColor
			DropdownButton.TextSize = 13
			DropdownButton.ZIndex = 4
			
			local DropdownButtonCorner = Instance.new("UICorner")
			DropdownButtonCorner.CornerRadius = UDim.new(0, 6)
			DropdownButtonCorner.Parent = DropdownButton
			
			local CurrentOption = DropdownDefault
			local IsOpen = false
			
			-- Store in flags
			OverflowHub.Flags[DropdownFlag] = {
				Value = CurrentOption,
				Type = "Dropdown",
				Set = function(option)
					CurrentOption = option
					DropdownButton.Text = CurrentOption
					DropdownCallback(CurrentOption)
				end
			}
			
			-- Dropdown interactions (simplified)
			DropdownButton.MouseButton1Click:Connect(function()
				-- Cycle through options for simplicity
				local currentIndex = 1
				for i, option in ipairs(DropdownOptions) do
					if option == CurrentOption then
						currentIndex = i
						break
					end
				end
				
				local nextIndex = currentIndex + 1
				if nextIndex > #DropdownOptions then
					nextIndex = 1
				end
				
				OverflowHub.Flags[DropdownFlag].Set(DropdownOptions[nextIndex])
			end)
			
			updateCanvasSize()
			
			local DropdownObject = {
				Frame = DropdownFrame,
				Button = DropdownButton,
				CurrentOption = CurrentOption,
				Set = OverflowHub.Flags[DropdownFlag].Set
			}
			
			return DropdownObject
		end
		
		-- CreateInput function (like Rayfield)
		function Tab:CreateInput(InputSettings)
			local Settings = InputSettings or {}
			local InputName = Settings.Name or "Input"
			local InputPlaceholder = Settings.PlaceholderText or "Enter text..."
			local InputDefault = Settings.Text or ""
			local InputCallback = Settings.Callback or function() end
			local InputFlag = Settings.Flag or InputName
			
			local InputFrame = Instance.new("Frame")
			InputFrame.Name = InputName
			InputFrame.Parent = TabPage
			InputFrame.BackgroundColor3 = SelectedTheme.ElementBackground
			InputFrame.BorderSizePixel = 0
			InputFrame.Size = UDim2.new(1, 0, 0, 45)
			InputFrame.ZIndex = 3
			
			-- Set layout order
			local elementCount = 0
			for _, child in ipairs(TabPage:GetChildren()) do
				if child:IsA("Frame") or child:IsA("ScrollingFrame") then
					elementCount = elementCount + 1
				end
			end
			InputFrame.LayoutOrder = elementCount
			
			local InputCorner = Instance.new("UICorner")
			InputCorner.CornerRadius = UDim.new(0, 8)
			InputCorner.Parent = InputFrame
			
			local InputStroke = Instance.new("UIStroke")
			InputStroke.Color = SelectedTheme.ElementStroke
			InputStroke.Thickness = 1
			InputStroke.Parent = InputFrame
			
			local InputLabel = Instance.new("TextLabel")
			InputLabel.Name = "Label"
			InputLabel.Parent = InputFrame
			InputLabel.BackgroundTransparency = 1
			InputLabel.Position = UDim2.new(0, 15, 0, 0)
			InputLabel.Size = UDim2.new(0.4, -10, 1, 0)
			InputLabel.Font = Enum.Font.Gotham
			InputLabel.Text = InputName
			InputLabel.TextColor3 = SelectedTheme.TextColor
			InputLabel.TextSize = 14
			InputLabel.TextXAlignment = Enum.TextXAlignment.Left
			InputLabel.ZIndex = 4
			
			local InputBox = Instance.new("TextBox")
			InputBox.Name = "Input"
			InputBox.Parent = InputFrame
			InputBox.BackgroundColor3 = SelectedTheme.InputBackground
			InputBox.BorderSizePixel = 0
			InputBox.Position = UDim2.new(0.4, 5, 0, 8)
			InputBox.Size = UDim2.new(0.6, -20, 0, 29)
			InputBox.Font = Enum.Font.Gotham
			InputBox.PlaceholderText = InputPlaceholder
			InputBox.PlaceholderColor3 = SelectedTheme.PlaceholderColor
			InputBox.Text = InputDefault
			InputBox.TextColor3 = SelectedTheme.TextColor
			InputBox.TextSize = 13
			InputBox.ZIndex = 4
			
			local InputBoxCorner = Instance.new("UICorner")
			InputBoxCorner.CornerRadius = UDim.new(0, 6)
			InputBoxCorner.Parent = InputBox
			
			local InputBoxStroke = Instance.new("UIStroke")
			InputBoxStroke.Color = SelectedTheme.InputStroke
			InputBoxStroke.Thickness = 1
			InputBoxStroke.Parent = InputBox
			
			local CurrentText = InputDefault
			
			-- Store in flags
			OverflowHub.Flags[InputFlag] = {
				Value = CurrentText,
				Type = "Input",
				Set = function(text)
					CurrentText = text
					InputBox.Text = CurrentText
					InputCallback(CurrentText)
				end
			}
			
			-- Input interactions
			InputBox.FocusLost:Connect(function(enterPressed)
				CurrentText = InputBox.Text
				OverflowHub.Flags[InputFlag].Value = CurrentText
				InputCallback(CurrentText)
			end)
			
			updateCanvasSize()
			
			local InputObject = {
				Frame = InputFrame,
				Input = InputBox,
				CurrentText = CurrentText,
				Set = OverflowHub.Flags[InputFlag].Set
			}
			
			return InputObject
		end
		
		-- CreateKeybind function (like Rayfield)
		function Tab:CreateKeybind(KeybindSettings)
			local Settings = KeybindSettings or {}
			local KeybindName = Settings.Name or "Keybind"
			local KeybindDefault = Settings.CurrentKeybind or "None"
			local KeybindCallback = Settings.Callback or function() end
			local KeybindFlag = Settings.Flag or KeybindName
			local HoldToInteract = Settings.HoldToInteract or false
			
			local KeybindFrame = Instance.new("Frame")
			KeybindFrame.Name = KeybindName
			KeybindFrame.Parent = TabPage
			KeybindFrame.BackgroundColor3 = SelectedTheme.ElementBackground
			KeybindFrame.BorderSizePixel = 0
			KeybindFrame.Size = UDim2.new(1, 0, 0, 45)
			KeybindFrame.ZIndex = 3
			
			-- Set layout order
			local elementCount = 0
			for _, child in ipairs(TabPage:GetChildren()) do
				if child:IsA("Frame") or child:IsA("ScrollingFrame") then
					elementCount = elementCount + 1
				end
			end
			KeybindFrame.LayoutOrder = elementCount
			
			local KeybindCorner = Instance.new("UICorner")
			KeybindCorner.CornerRadius = UDim.new(0, 8)
			KeybindCorner.Parent = KeybindFrame
			
			local KeybindStroke = Instance.new("UIStroke")
			KeybindStroke.Color = SelectedTheme.ElementStroke
			KeybindStroke.Thickness = 1
			KeybindStroke.Parent = KeybindFrame
			
			local KeybindLabel = Instance.new("TextLabel")
			KeybindLabel.Name = "Label"
			KeybindLabel.Parent = KeybindFrame
			KeybindLabel.BackgroundTransparency = 1
			KeybindLabel.Position = UDim2.new(0, 15, 0, 0)
			KeybindLabel.Size = UDim2.new(0.6, -10, 1, 0)
			KeybindLabel.Font = Enum.Font.Gotham
			KeybindLabel.Text = KeybindName
			KeybindLabel.TextColor3 = SelectedTheme.TextColor
			KeybindLabel.TextSize = 14
			KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
			KeybindLabel.ZIndex = 4
			
			local KeybindButton = Instance.new("TextButton")
			KeybindButton.Name = "Button"
			KeybindButton.Parent = KeybindFrame
			KeybindButton.BackgroundColor3 = SelectedTheme.SecondaryElementBackground
			KeybindButton.BorderSizePixel = 0
			KeybindButton.Position = UDim2.new(0.6, 5, 0, 8)
			KeybindButton.Size = UDim2.new(0.4, -20, 0, 29)
			KeybindButton.Font = Enum.Font.Gotham
			KeybindButton.Text = KeybindDefault
			KeybindButton.TextColor3 = SelectedTheme.TextColor
			KeybindButton.TextSize = 13
			KeybindButton.ZIndex = 4
			
			local KeybindButtonCorner = Instance.new("UICorner")
			KeybindButtonCorner.CornerRadius = UDim.new(0, 6)
			KeybindButtonCorner.Parent = KeybindButton
			
			local CurrentKeybind = KeybindDefault
			local Listening = false
			
			-- Store in flags
			OverflowHub.Flags[KeybindFlag] = {
				Value = CurrentKeybind,
				Type = "Keybind",
				Set = function(keybind)
					CurrentKeybind = keybind
					KeybindButton.Text = CurrentKeybind
				end
			}
			
			-- Keybind interactions (simplified)
			KeybindButton.MouseButton1Click:Connect(function()
				if not Listening then
					Listening = true
					KeybindButton.Text = "Press a key..."
					
					local connection
					connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
						if not gameProcessed then
							local keyName = input.KeyCode.Name
							if keyName ~= "Unknown" then
								CurrentKeybind = keyName
								OverflowHub.Flags[KeybindFlag].Value = CurrentKeybind
								KeybindButton.Text = CurrentKeybind
								Listening = false
								connection:Disconnect()
							end
						end
					end)
				end
			end)
			
			updateCanvasSize()
			
			local KeybindObject = {
				Frame = KeybindFrame,
				Button = KeybindButton,
				CurrentKeybind = CurrentKeybind,
				Set = OverflowHub.Flags[KeybindFlag].Set
			}
			
			return KeybindObject
		end
		
		return Tab
	end
	
	return Window
end

-- Additional utility functions
function OverflowHub:Notify(NotificationSettings)
	-- Placeholder for notifications
	print("Notification:", NotificationSettings.Title or "Notification", NotificationSettings.Content or "No content")
end

function OverflowHub:Destroy()
	if OverflowHub.ScreenGui then
		OverflowHub.ScreenGui:Destroy()
	end
end

function OverflowHub:LoadConfiguration(ConfigName)
	-- Placeholder for configuration loading
	return {}
end

function OverflowHub:SaveConfiguration(ConfigName)
	-- Placeholder for configuration saving
	print("Configuration saved:", ConfigName)
end

-- Make it compatible with Rayfield naming
local RayfieldLibrary = {
	CreateWindow = function(self, Settings)
		return OverflowHub:CreateWindow(Settings)
	end,
	Notify = function(self, NotificationSettings)
		return OverflowHub:Notify(NotificationSettings)
	end,
	Destroy = function(self)
		return OverflowHub:Destroy()
	end,
	LoadConfiguration = function(self, ConfigName)
		return OverflowHub:LoadConfiguration(ConfigName)
	end,
	SaveConfiguration = function(self, ConfigName)
		return OverflowHub:SaveConfiguration(ConfigName)
	end,
	Flags = OverflowHub.Flags,
	Theme = OverflowHub.Theme
}

-- Set metatable for compatibility
setmetatable(RayfieldLibrary, {
	__index = OverflowHub
})

return RayfieldLibrary

--[[
-- 0verflow Hub Test Example:
local Library = loadstring(game:HttpGet("path_to_your_script"))()

local Window = Library:CreateWindow({
    Name = "0verflow Hub"
})

local MainTab = Window:CreateTab("Main")

MainTab:CreateSection({Name = "Testing Section"})

MainTab:CreateLabel({
    Text = "Welcome to 0verflow Hub!"
})

MainTab:CreateButton({
    Name = "Test Button",
    Callback = function()
        print("Button clicked!")
        Library:Notify({
            Title = "Success!",
            Content = "Button was clicked successfully",
            Duration = 3
        })
    end
})

MainTab:CreateToggle({
    Name = "Enable Feature",
    CurrentValue = false,
    Callback = function(Value)
        print("Toggle state:", Value)
    end
})

MainTab:CreateParagraph({
    Title = "About",
    Content = "This is 0verflow Hub - a modern, minimal UI library based on Rayfield with left-side tabs and a dark purple theme."
})

-- Additional tabs
local SettingsTab = Window:CreateTab("Settings")

SettingsTab:CreateSection({Name = "Configuration"})

SettingsTab:CreateToggle({
    Name = "Dark Mode",
    CurrentValue = true,
    Callback = function(Value)
        print("Dark mode:", Value)
    end
})
--]]
