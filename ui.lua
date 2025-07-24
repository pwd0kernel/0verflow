--[[
	0verflow Hub Interface Suite
	Rebranded and redesigned from Rayfield
	Custom UI with left-side navigation and dark purple theme
]]

local function getService(name)
	local service = game:GetService(name)
	return if cloneref then cloneref(service) else service
end

local TweenService = getService("TweenService")
local UserInputService = getService("UserInputService")
local RunService = getService("RunService") 
local HttpService = getService("HttpService")
local CoreGui = getService("CoreGui")

-- 0verflow Hub Theme with Dark Purple
local OverflowTheme = {
	-- Primary Colors
	PrimaryPurple = Color3.fromRGB(111, 10, 214), -- #6f0ad6
	DarkPurple = Color3.fromRGB(85, 8, 163),
	LightPurple = Color3.fromRGB(135, 15, 255),
	
	-- Background Colors
	MainBackground = Color3.fromRGB(20, 15, 25),
	SidebarBackground = Color3.fromRGB(25, 18, 32),
	ContentBackground = Color3.fromRGB(30, 22, 38),
	
	-- Element Colors
	ElementBackground = Color3.fromRGB(35, 25, 45),
	ElementHover = Color3.fromRGB(45, 32, 58),
	ElementStroke = Color3.fromRGB(55, 40, 70),
	
	-- Text Colors
	PrimaryText = Color3.fromRGB(255, 255, 255),
	SecondaryText = Color3.fromRGB(200, 190, 210),
	AccentText = Color3.fromRGB(185, 120, 255),
	
	-- Tab Colors
	TabActive = Color3.fromRGB(111, 10, 214),
	TabInactive = Color3.fromRGB(40, 30, 50),
	TabHover = Color3.fromRGB(60, 45, 75),
	
	-- Toggle Colors
	ToggleOn = Color3.fromRGB(111, 10, 214),
	ToggleOff = Color3.fromRGB(60, 45, 75),
	ToggleThumb = Color3.fromRGB(255, 255, 255),
	
	-- Button Colors
	ButtonBackground = Color3.fromRGB(111, 10, 214),
	ButtonHover = Color3.fromRGB(135, 15, 255),
	ButtonText = Color3.fromRGB(255, 255, 255),
	
	-- Slider Colors
	SliderBackground = Color3.fromRGB(40, 30, 50),
	SliderFill = Color3.fromRGB(111, 10, 214),
	SliderThumb = Color3.fromRGB(255, 255, 255),
}

local OverflowLibrary = {
	Flags = {},
	Elements = {}
}

-- Create main ScreenGui
local function createScreenGui()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "0verflowHub"
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	
	if gethui then
		screenGui.Parent = gethui()
	elseif syn and syn.protect_gui then
		syn.protect_gui(screenGui)
		screenGui.Parent = CoreGui
	else
		screenGui.Parent = CoreGui
	end
	
	return screenGui
end

-- Create main frame structure
local function createMainFrame(parent, title)
	-- Main container
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(0, 850, 0, 550)
	mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	mainFrame.BackgroundColor3 = OverflowTheme.MainBackground
	mainFrame.BorderSizePixel = 0
	mainFrame.Parent = parent
	
	-- Corner rounding
	local mainCorner = Instance.new("UICorner")
	mainCorner.CornerRadius = UDim.new(0, 12)
	mainCorner.Parent = mainFrame
	
	-- Drop shadow
	local shadow = Instance.new("ImageLabel")
	shadow.Name = "Shadow"
	shadow.Size = UDim2.new(1, 30, 1, 30)
	shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	shadow.AnchorPoint = Vector2.new(0.5, 0.5)
	shadow.BackgroundTransparency = 1
	shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
	shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	shadow.ImageTransparency = 0.7
	shadow.ZIndex = mainFrame.ZIndex - 1
	shadow.Parent = parent
	
	-- Top bar
	local topBar = Instance.new("Frame")
	topBar.Name = "TopBar"
	topBar.Size = UDim2.new(1, 0, 0, 50)
	topBar.Position = UDim2.new(0, 0, 0, 0)
	topBar.BackgroundColor3 = OverflowTheme.SidebarBackground
	topBar.BorderSizePixel = 0
	topBar.Parent = mainFrame
	
	local topBarCorner = Instance.new("UICorner")
	topBarCorner.CornerRadius = UDim.new(0, 12)
	topBarCorner.Parent = topBar
	
	-- Title
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Size = UDim2.new(1, -120, 1, 0)
	titleLabel.Position = UDim2.new(0, 20, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = title or "0verflow Hub"
	titleLabel.TextColor3 = OverflowTheme.PrimaryText
	titleLabel.TextScaled = true
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.Parent = topBar
	
	-- Close button
	local closeButton = Instance.new("TextButton")
	closeButton.Name = "CloseButton"
	closeButton.Size = UDim2.new(0, 30, 0, 30)
	closeButton.Position = UDim2.new(1, -40, 0.5, 0)
	closeButton.AnchorPoint = Vector2.new(0.5, 0.5)
	closeButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
	closeButton.BorderSizePixel = 0
	closeButton.Text = "×"
	closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeButton.TextScaled = true
	closeButton.Font = Enum.Font.GothamBold
	closeButton.Parent = topBar
	
	local closeCorner = Instance.new("UICorner")
	closeCorner.CornerRadius = UDim.new(0, 6)
	closeCorner.Parent = closeButton
	
	-- Sidebar for tabs (LEFT SIDE)
	local sideBar = Instance.new("Frame") 
	sideBar.Name = "SideBar"
	sideBar.Size = UDim2.new(0, 200, 1, -50)
	sideBar.Position = UDim2.new(0, 0, 0, 50)
	sideBar.BackgroundColor3 = OverflowTheme.SidebarBackground
	sideBar.BorderSizePixel = 0
	sideBar.Parent = mainFrame
	
	-- Sidebar corner (only bottom left)
	local sideCorner = Instance.new("UICorner")
	sideCorner.CornerRadius = UDim.new(0, 12)
	sideCorner.Parent = sideBar
	
	-- Tab container in sidebar
	local tabContainer = Instance.new("ScrollingFrame")
	tabContainer.Name = "TabContainer"
	tabContainer.Size = UDim2.new(1, -10, 1, -20)
	tabContainer.Position = UDim2.new(0, 5, 0, 10)
	tabContainer.BackgroundTransparency = 1
	tabContainer.BorderSizePixel = 0
	tabContainer.ScrollBarThickness = 4
	tabContainer.ScrollBarImageColor3 = OverflowTheme.PrimaryPurple
	tabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
	tabContainer.Parent = sideBar
	
	local tabLayout = Instance.new("UIListLayout")
	tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
	tabLayout.Padding = UDim.new(0, 5)
	tabLayout.Parent = tabContainer
	
	-- Content area (RIGHT SIDE)
	local contentArea = Instance.new("Frame")
	contentArea.Name = "ContentArea"  
	contentArea.Size = UDim2.new(1, -200, 1, -50)
	contentArea.Position = UDim2.new(0, 200, 0, 50)
	contentArea.BackgroundColor3 = OverflowTheme.ContentBackground
	contentArea.BorderSizePixel = 0
	contentArea.Parent = mainFrame
	
	local contentCorner = Instance.new("UICorner")
	contentCorner.CornerRadius = UDim.new(0, 12)  
	contentCorner.Parent = contentArea
	
	-- Content pages container
	local pagesContainer = Instance.new("Frame")
	pagesContainer.Name = "PagesContainer"
	pagesContainer.Size = UDim2.new(1, -20, 1, -20)
	pagesContainer.Position = UDim2.new(0, 10, 0, 10)
	pagesContainer.BackgroundTransparency = 1
	pagesContainer.Parent = contentArea
	
	return mainFrame, sideBar, contentArea, tabContainer, pagesContainer, closeButton
end

-- Create tab button in sidebar
local function createTabButton(parent, name, icon, isActive)
	local tabButton = Instance.new("TextButton")
	tabButton.Name = name
	tabButton.Size = UDim2.new(1, 0, 0, 45)
	tabButton.BackgroundColor3 = isActive and OverflowTheme.TabActive or OverflowTheme.TabInactive
	tabButton.BorderSizePixel = 0
	tabButton.Text = ""
	tabButton.Parent = parent
	
	local tabCorner = Instance.new("UICorner")
	tabCorner.CornerRadius = UDim.new(0, 8)
	tabCorner.Parent = tabButton
	
	-- Tab icon (if provided)
	local tabIcon = Instance.new("ImageLabel")
	tabIcon.Name = "Icon"
	tabIcon.Size = UDim2.new(0, 20, 0, 20)
	tabIcon.Position = UDim2.new(0, 15, 0.5, 0)
	tabIcon.AnchorPoint = Vector2.new(0, 0.5)
	tabIcon.BackgroundTransparency = 1
	tabIcon.Image = icon or ""
	tabIcon.ImageColor3 = OverflowTheme.PrimaryText
	tabIcon.Parent = tabButton
	
	-- Tab text
	local tabText = Instance.new("TextLabel")
	tabText.Name = "TabText"
	tabText.Size = UDim2.new(1, -50, 1, 0)
	tabText.Position = UDim2.new(0, 45, 0, 0)
	tabText.BackgroundTransparency = 1
	tabText.Text = name
	tabText.TextColor3 = OverflowTheme.PrimaryText
	tabText.TextScaled = true
	tabText.TextXAlignment = Enum.TextXAlignment.Left
	tabText.Font = Enum.Font.Gotham
	tabText.Parent = tabButton
	
	-- Active indicator
	local activeIndicator = Instance.new("Frame")
	activeIndicator.Name = "ActiveIndicator"
	activeIndicator.Size = UDim2.new(0, 3, 0.7, 0)
	activeIndicator.Position = UDim2.new(0, 0, 0.5, 0)
	activeIndicator.AnchorPoint = Vector2.new(0, 0.5)
	activeIndicator.BackgroundColor3 = OverflowTheme.LightPurple
	activeIndicator.BorderSizePixel = 0
	activeIndicator.Visible = isActive or false
	activeIndicator.Parent = tabButton
	
	local indicatorCorner = Instance.new("UICorner")
	indicatorCorner.CornerRadius = UDim.new(0, 2)
	indicatorCorner.Parent = activeIndicator
	
	return tabButton
end

-- Create content page
local function createContentPage(parent, name)
	local page = Instance.new("ScrollingFrame")
	page.Name = name
	page.Size = UDim2.new(1, 0, 1, 0)
	page.Position = UDim2.new(0, 0, 0, 0)
	page.BackgroundTransparency = 1
	page.BorderSizePixel = 0
	page.ScrollBarThickness = 6
	page.ScrollBarImageColor3 = OverflowTheme.PrimaryPurple
	page.CanvasSize = UDim2.new(0, 0, 0, 0)
	page.Visible = false
	page.Parent = parent
	
	local pageLayout = Instance.new("UIListLayout")
	pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
	pageLayout.Padding = UDim.new(0, 10)
	pageLayout.Parent = page
	
	-- Auto-resize canvas
	pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 20)
	end)
	
	return page
end

-- Create section header
local function createSection(parent, title)
	local section = Instance.new("Frame")
	section.Name = "Section_" .. title
	section.Size = UDim2.new(1, 0, 0, 35)
	section.BackgroundTransparency = 1
	section.Parent = parent
	
	local sectionTitle = Instance.new("TextLabel")
	sectionTitle.Name = "Title"
	sectionTitle.Size = UDim2.new(1, 0, 1, 0)
	sectionTitle.BackgroundTransparency = 1
	sectionTitle.Text = title
	sectionTitle.TextColor3 = OverflowTheme.AccentText
	sectionTitle.TextScaled = true
	sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
	sectionTitle.Font = Enum.Font.GothamBold
	sectionTitle.Parent = section
	
	-- Divider line
	local divider = Instance.new("Frame")
	divider.Name = "Divider"
	divider.Size = UDim2.new(1, 0, 0, 1)
	divider.Position = UDim2.new(0, 0, 1, -1)
	divider.BackgroundColor3 = OverflowTheme.ElementStroke
	divider.BorderSizePixel = 0
	divider.Parent = section
	
	return section
end

-- Create button element
local function createButton(parent, settings)
	local button = Instance.new("TextButton")
	button.Name = settings.Name or "Button"
	button.Size = UDim2.new(1, 0, 0, 40)
	button.BackgroundColor3 = OverflowTheme.ButtonBackground
	button.BorderSizePixel = 0
	button.Text = settings.Name or "Button"
	button.TextColor3 = OverflowTheme.ButtonText
	button.TextScaled = true
	button.Font = Enum.Font.Gotham
	button.Parent = parent
	
	local buttonCorner = Instance.new("UICorner")
	buttonCorner.CornerRadius = UDim.new(0, 8)
	buttonCorner.Parent = button
	
	-- Hover effects
	button.MouseEnter:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.2), {
			BackgroundColor3 = OverflowTheme.ButtonHover
		}):Play()
	end)
	
	button.MouseLeave:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.2), {
			BackgroundColor3 = OverflowTheme.ButtonBackground
		}):Play()
	end)
	
	-- Click handler
	if settings.Callback then
		button.MouseButton1Click:Connect(settings.Callback)
	end
	
	return button
end

-- Create toggle element  
local function createToggle(parent, settings)
	local toggleFrame = Instance.new("Frame")
	toggleFrame.Name = settings.Name or "Toggle"
	toggleFrame.Size = UDim2.new(1, 0, 0, 40)
	toggleFrame.BackgroundColor3 = OverflowTheme.ElementBackground
	toggleFrame.BorderSizePixel = 0
	toggleFrame.Parent = parent
	
	local toggleCorner = Instance.new("UICorner")
	toggleCorner.CornerRadius = UDim.new(0, 8)
	toggleCorner.Parent = toggleFrame
	
	-- Toggle label
	local toggleLabel = Instance.new("TextLabel")
	toggleLabel.Name = "Label"
	toggleLabel.Size = UDim2.new(1, -60, 1, 0)
	toggleLabel.Position = UDim2.new(0, 10, 0, 0)
	toggleLabel.BackgroundTransparency = 1
	toggleLabel.Text = settings.Name or "Toggle"
	toggleLabel.TextColor3 = OverflowTheme.PrimaryText  
	toggleLabel.TextScaled = true
	toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
	toggleLabel.Font = Enum.Font.Gotham
	toggleLabel.Parent = toggleFrame
	
	-- Toggle switch
	local toggleSwitch = Instance.new("TextButton")
	toggleSwitch.Name = "Switch"
	toggleSwitch.Size = UDim2.new(0, 40, 0, 20)
	toggleSwitch.Position = UDim2.new(1, -50, 0.5, 0)
	toggleSwitch.AnchorPoint = Vector2.new(0, 0.5)
	toggleSwitch.BackgroundColor3 = settings.Default and OverflowTheme.ToggleOn or OverflowTheme.ToggleOff
	toggleSwitch.BorderSizePixel = 0
	toggleSwitch.Text = ""
	toggleSwitch.Parent = toggleFrame
	
	local switchCorner = Instance.new("UICorner")
	switchCorner.CornerRadius = UDim.new(0, 10)
	switchCorner.Parent = toggleSwitch
	
	-- Toggle thumb
	local toggleThumb = Instance.new("Frame")
	toggleThumb.Name = "Thumb"
	toggleThumb.Size = UDim2.new(0, 16, 0, 16)
	toggleThumb.Position = settings.Default and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
	toggleThumb.AnchorPoint = Vector2.new(0, 0.5)
	toggleThumb.BackgroundColor3 = OverflowTheme.ToggleThumb
	toggleThumb.BorderSizePixel = 0
	toggleThumb.Parent = toggleSwitch
	
	local thumbCorner = Instance.new("UICorner")
	thumbCorner.CornerRadius = UDim.new(0, 8)
	thumbCorner.Parent = toggleThumb
	
	-- Toggle state
	local isToggled = settings.Default or false
	
	-- Toggle functionality
	toggleSwitch.MouseButton1Click:Connect(function()
		isToggled = not isToggled
		
		TweenService:Create(toggleSwitch, TweenInfo.new(0.2), {
			BackgroundColor3 = isToggled and OverflowTheme.ToggleOn or OverflowTheme.ToggleOff
		}):Play()
		
		TweenService:Create(toggleThumb, TweenInfo.new(0.2), {
			Position = isToggled and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
		}):Play()
		
		if settings.Callback then
			settings.Callback(isToggled)
		end
	end)
	
	-- Hover effect
	toggleFrame.MouseEnter:Connect(function()
		TweenService:Create(toggleFrame, TweenInfo.new(0.2), {
			BackgroundColor3 = OverflowTheme.ElementHover
		}):Play()
	end)
	
	toggleFrame.MouseLeave:Connect(function()
		TweenService:Create(toggleFrame, TweenInfo.new(0.2), {
			BackgroundColor3 = OverflowTheme.ElementBackground
		}):Play()
	end)
	
	return toggleFrame
end

-- Create slider element
local function createSlider(parent, settings)
	local sliderFrame = Instance.new("Frame")
	sliderFrame.Name = settings.Name or "Slider"
	sliderFrame.Size = UDim2.new(1, 0, 0, 60)
	sliderFrame.BackgroundColor3 = OverflowTheme.ElementBackground
	sliderFrame.BorderSizePixel = 0
	sliderFrame.Parent = parent
	
	local sliderCorner = Instance.new("UICorner")
	sliderCorner.CornerRadius = UDim.new(0, 8)
	sliderCorner.Parent = sliderFrame
	
	-- Slider label
	local sliderLabel = Instance.new("TextLabel")
	sliderLabel.Name = "Label"
	sliderLabel.Size = UDim2.new(1, -10, 0, 20)
	sliderLabel.Position = UDim2.new(0, 5, 0, 5)
	sliderLabel.BackgroundTransparency = 1
	sliderLabel.Text = settings.Name or "Slider"
	sliderLabel.TextColor3 = OverflowTheme.PrimaryText
	sliderLabel.TextScaled = true
	sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
	sliderLabel.Font = Enum.Font.Gotham
	sliderLabel.Parent = sliderFrame
	
	-- Value label
	local valueLabel = Instance.new("TextLabel")
	valueLabel.Name = "Value"
	valueLabel.Size = UDim2.new(0, 50, 0, 20)
	valueLabel.Position = UDim2.new(1, -55, 0, 5)
	valueLabel.BackgroundTransparency = 1
	valueLabel.Text = tostring(settings.Default or settings.Min or 0)
	valueLabel.TextColor3 = OverflowTheme.AccentText
	valueLabel.TextScaled = true
	valueLabel.Font = Enum.Font.GothamBold
	valueLabel.Parent = sliderFrame
	
	-- Slider track
	local sliderTrack = Instance.new("Frame")
	sliderTrack.Name = "Track"
	sliderTrack.Size = UDim2.new(1, -20, 0, 6)
	sliderTrack.Position = UDim2.new(0, 10, 0, 35)
	sliderTrack.BackgroundColor3 = OverflowTheme.SliderBackground
	sliderTrack.BorderSizePixel = 0
	sliderTrack.Parent = sliderFrame
	
	local trackCorner = Instance.new("UICorner")
	trackCorner.CornerRadius = UDim.new(0, 3)
	trackCorner.Parent = sliderTrack
	
	-- Slider fill
	local sliderFill = Instance.new("Frame")
	sliderFill.Name = "Fill"
	sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
	sliderFill.BackgroundColor3 = OverflowTheme.SliderFill
	sliderFill.BorderSizePixel = 0
	sliderFill.Parent = sliderTrack
	
	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(0, 3)
	fillCorner.Parent = sliderFill
	
	-- Slider thumb
	local sliderThumb = Instance.new("Frame")
	sliderThumb.Name = "Thumb"
	sliderThumb.Size = UDim2.new(0, 16, 0, 16)
	sliderThumb.Position = UDim2.new(0.5, -8, 0.5, -8)
	sliderThumb.BackgroundColor3 = OverflowTheme.SliderThumb
	sliderThumb.BorderSizePixel = 0
	sliderThumb.Parent = sliderTrack
	
	local thumbCorner = Instance.new("UICorner")
	thumbCorner.CornerRadius = UDim.new(0, 8)
	thumbCorner.Parent = sliderThumb
	
	-- Slider functionality
	local dragging = false
	local minVal = settings.Min or 0
	local maxVal = settings.Max or 100
	local currentVal = settings.Default or minVal
	
	local function updateSlider(value)
		currentVal = math.clamp(value, minVal, maxVal)
		local percentage = (currentVal - minVal) / (maxVal - minVal)
		
		sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
		sliderThumb.Position = UDim2.new(percentage, -8, 0.5, -8)
		valueLabel.Text = settings.Suffix and (currentVal .. settings.Suffix) or tostring(currentVal)
		
		if settings.Callback then
			settings.Callback(currentVal)
		end
	end
	
	sliderTrack.InputBegan:Connect(function(input)
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
			local percentage = math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
			local value = minVal + (percentage * (maxVal - minVal))
			updateSlider(math.floor(value))
		end
	end)
	
	-- Initialize slider
	updateSlider(currentVal)
	
	return sliderFrame
end

-- Make window draggable
local function makeDraggable(frame, dragHandle)
	local dragging = false
	local dragStart = nil
	local startPos = nil
	
	dragHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
end

-- Main library functions
function OverflowLibrary:CreateWindow(settings)
	local windowSettings = settings or {}
	local title = windowSettings.Name or "0verflow Hub"
	
	-- Create GUI
	local screenGui = createScreenGui()
	local mainFrame, sideBar, contentArea, tabContainer, pagesContainer, closeButton = createMainFrame(screenGui, title)
	
	-- Make draggable
	makeDraggable(mainFrame, mainFrame:FindFirstChild("TopBar"))
	
	-- Close functionality
	closeButton.MouseButton1Click:Connect(function()
		screenGui:Destroy()
	end)
	
	-- Window object
	local Window = {
		GUI = screenGui,
		Main = mainFrame,
		TabContainer = tabContainer,
		PagesContainer = pagesContainer,
		CurrentTab = nil,
		Tabs = {}
	}
	
	function Window:CreateTab(name, icon)
		-- Create tab button
		local isFirstTab = #self.Tabs == 0
		local tabButton = createTabButton(self.TabContainer, name, icon, isFirstTab)
		
		-- Create content page
		local contentPage = createContentPage(self.PagesContainer, name)
		
		if isFirstTab then
			contentPage.Visible = true
			self.CurrentTab = name
		end
		
		-- Tab switching
		tabButton.MouseButton1Click:Connect(function()
			-- Hide all pages
			for _, page in pairs(self.PagesContainer:GetChildren()) do
				if page:IsA("ScrollingFrame") then
					page.Visible = false
				end
			end
			
			-- Update all tab buttons
			for _, tab in pairs(self.TabContainer:GetChildren()) do
				if tab:IsA("TextButton") then
					TweenService:Create(tab, TweenInfo.new(0.2), {
						BackgroundColor3 = OverflowTheme.TabInactive
					}):Play()
					
					if tab:FindFirstChild("ActiveIndicator") then
						tab.ActiveIndicator.Visible = false
					end
				end
			end
			
			-- Show selected page and update button
			contentPage.Visible = true
			self.CurrentTab = name
			
			TweenService:Create(tabButton, TweenInfo.new(0.2), {
				BackgroundColor3 = OverflowTheme.TabActive
			}):Play()
			
			if tabButton:FindFirstChild("ActiveIndicator") then
				tabButton.ActiveIndicator.Visible = true
			end
		end)
		
		-- Tab object
		local Tab = {
			Name = name,
			Page = contentPage,
			Button = tabButton
		}
		
		-- Tab methods
		function Tab:CreateSection(title)
			return createSection(self.Page, title)
		end
		
		function Tab:CreateButton(settings)
			return createButton(self.Page, settings)
		end
		
		function Tab:CreateToggle(settings)
			return createToggle(self.Page, settings)
		end
		
		function Tab:CreateSlider(settings)
			return createSlider(self.Page, settings)
		end
		
		table.insert(self.Tabs, Tab)
		return Tab
	end
	
	return Window
end

return OverflowLibrary
