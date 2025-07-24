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
local FirstTab = nil
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
		TabButton.LayoutOrder = #TabButtonsFrame:GetChildren()
		
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
		TabPage.LayoutOrder = #Elements:GetChildren()
		
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
			ElementsPageLayout:JumpTo(TabPage)
			TabButton.BackgroundColor3 = SelectedTheme.TabBackgroundSelected
			TabButton.TextColor3 = SelectedTheme.SelectedTabTextColor
		end
		
		-- Tab button click handler
		TabButton.MouseButton1Click:Connect(function()
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
			
			-- Switch to this tab page
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
			local LabelText = Settings.Text or "Label"
			
			local LabelFrame = Instance.new("Frame")
			LabelFrame.Name = "Label"
			LabelFrame.Parent = TabPage
			LabelFrame.BackgroundColor3 = SelectedTheme.ElementBackground
			LabelFrame.BorderSizePixel = 0
			LabelFrame.Size = UDim2.new(1, 0, 0, 35)
			LabelFrame.ZIndex = 3
			
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
