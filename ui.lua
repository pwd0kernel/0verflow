--[[
	0verflow Hub - Modern Minimal UI
	Rebranded from Rayfield Interface Suite
	Features: Left-side tabs, modern design, custom color palette
	Compatible with Rayfield UI scripts
]]

local function getService(name)
	local service = game:GetService(name)
	return if cloneref then cloneref(service) else service
end

-- Services
local TweenService = getService('TweenService')
local UserInputService = getService('UserInputService')
local RunService = getService('RunService')
local CoreGui = getService('CoreGui')
local Players = getService('Players')

-- Main Library
local OverflowHub = {
	Flags = {},
	Elements = {},
	Theme = {
		-- Modern Dark Purple Theme
		Primary = Color3.fromRGB(111, 10, 214), -- #6f0ad6
		Secondary = Color3.fromRGB(80, 8, 150),
		Accent = Color3.fromRGB(140, 20, 255),
		
		-- Backgrounds
		Background = Color3.fromRGB(18, 18, 22),
		SidebarBackground = Color3.fromRGB(22, 22, 28),
		ContentBackground = Color3.fromRGB(25, 25, 30),
		ElementBackground = Color3.fromRGB(30, 30, 36),
		ElementHover = Color3.fromRGB(35, 35, 42),
		
		-- Text Colors
		TextPrimary = Color3.fromRGB(255, 255, 255),
		TextSecondary = Color3.fromRGB(180, 180, 190),
		TextMuted = Color3.fromRGB(130, 130, 140),
		
		-- Borders
		Border = Color3.fromRGB(40, 40, 48),
		BorderLight = Color3.fromRGB(50, 50, 60),
		
		-- States
		Success = Color3.fromRGB(34, 197, 94),
		Warning = Color3.fromRGB(251, 191, 36),
		Error = Color3.fromRGB(239, 68, 68),
	}
}

-- Create main GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "0verflowHub"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = OverflowHub.Theme.Background
MainFrame.Size = UDim2.new(0, 800, 0, 500)
MainFrame.Position = UDim2.new(0.5, -400, 0.5, -250)
MainFrame.ClipsDescendants = true

-- Corner for main frame
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Drop shadow effect
local Shadow = Instance.new("Frame")
Shadow.Name = "Shadow"
Shadow.Parent = MainFrame
Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Shadow.BackgroundTransparency = 0.8
Shadow.Size = UDim2.new(1, 20, 1, 20)
Shadow.Position = UDim2.new(0, -10, 0, -10)
Shadow.ZIndex = MainFrame.ZIndex - 1

local ShadowCorner = Instance.new("UICorner")
ShadowCorner.CornerRadius = UDim.new(0, 12)
ShadowCorner.Parent = Shadow

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = OverflowHub.Theme.SidebarBackground
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.Position = UDim2.new(0, 0, 0, 0)

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

-- Title bar bottom separator
local TitleSeparator = Instance.new("Frame")
TitleSeparator.Name = "Separator"
TitleSeparator.Parent = TitleBar
TitleSeparator.BackgroundColor3 = OverflowHub.Theme.SidebarBackground
TitleSeparator.Size = UDim2.new(1, 0, 0, 12)
TitleSeparator.Position = UDim2.new(0, 0, 1, -12)

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = TitleBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "0verflow Hub"
Title.TextColor3 = OverflowHub.Theme.TextPrimary
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Close button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = TitleBar
CloseButton.BackgroundColor3 = OverflowHub.Theme.Error
CloseButton.Size = UDim2.new(0, 30, 0, 20)
CloseButton.Position = UDim2.new(1, -40, 0.5, -10)
CloseButton.Font = Enum.Font.Gotham
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 4)
CloseCorner.Parent = CloseButton

-- Minimize button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = TitleBar
MinimizeButton.BackgroundColor3 = OverflowHub.Theme.Warning
MinimizeButton.Size = UDim2.new(0, 30, 0, 20)
MinimizeButton.Position = UDim2.new(1, -75, 0.5, -10)
MinimizeButton.Font = Enum.Font.Gotham
MinimizeButton.Text = "−"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 14

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 4)
MinimizeCorner.Parent = MinimizeButton

-- Sidebar (Left side for tabs)
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Parent = MainFrame
Sidebar.BackgroundColor3 = OverflowHub.Theme.SidebarBackground
Sidebar.Size = UDim2.new(0, 200, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)

-- Sidebar corner (only bottom left)
local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 12)
SidebarCorner.Parent = Sidebar

-- Cover top corners of sidebar
local SidebarCover = Instance.new("Frame")
SidebarCover.Name = "TopCover"
SidebarCover.Parent = Sidebar
SidebarCover.BackgroundColor3 = OverflowHub.Theme.SidebarBackground
SidebarCover.Size = UDim2.new(1, 0, 0, 12)
SidebarCover.Position = UDim2.new(0, 0, 0, 0)

-- Tab container
local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Name = "TabContainer"
TabContainer.Parent = Sidebar
TabContainer.BackgroundTransparency = 1
TabContainer.Size = UDim2.new(1, -10, 1, -20)
TabContainer.Position = UDim2.new(0, 5, 0, 10)
TabContainer.ScrollBarThickness = 4
TabContainer.ScrollBarImageColor3 = OverflowHub.Theme.Primary
TabContainer.BorderSizePixel = 0
TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Parent = TabContainer
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 5)

-- Content Area
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Parent = MainFrame
ContentArea.BackgroundColor3 = OverflowHub.Theme.ContentBackground
ContentArea.Size = UDim2.new(1, -200, 1, -40)
ContentArea.Position = UDim2.new(0, 200, 0, 40)

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 12)
ContentCorner.Parent = ContentArea

-- Cover left side of content area
local ContentCover = Instance.new("Frame")
ContentCover.Name = "LeftCover"
ContentCover.Parent = ContentArea
ContentCover.BackgroundColor3 = OverflowHub.Theme.ContentBackground
ContentCover.Size = UDim2.new(0, 12, 1, 0)
ContentCover.Position = UDim2.new(0, 0, 0, 0)

-- Content header
local ContentHeader = Instance.new("Frame")
ContentHeader.Name = "ContentHeader"
ContentHeader.Parent = ContentArea
ContentHeader.BackgroundTransparency = 1
ContentHeader.Size = UDim2.new(1, 0, 0, 50)
ContentHeader.Position = UDim2.new(0, 0, 0, 0)

local ContentTitle = Instance.new("TextLabel")
ContentTitle.Name = "ContentTitle"
ContentTitle.Parent = ContentHeader
ContentTitle.BackgroundTransparency = 1
ContentTitle.Position = UDim2.new(0, 20, 0, 0)
ContentTitle.Size = UDim2.new(1, -40, 1, 0)
ContentTitle.Font = Enum.Font.GothamBold
ContentTitle.Text = "Welcome"
ContentTitle.TextColor3 = OverflowHub.Theme.TextPrimary
ContentTitle.TextSize = 18
ContentTitle.TextXAlignment = Enum.TextXAlignment.Left
ContentTitle.TextYAlignment = Enum.TextYAlignment.Center

-- Tab Pages Container
local TabPages = Instance.new("Frame")
TabPages.Name = "TabPages"
TabPages.Parent = ContentArea
TabPages.BackgroundTransparency = 1
TabPages.Size = UDim2.new(1, -20, 1, -70)
TabPages.Position = UDim2.new(0, 10, 0, 60)

-- Drag functionality
local dragging = false
local dragStart = nil
local startPos = nil

TitleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

-- Window controls
local minimized = false

CloseButton.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

MinimizeButton.MouseButton1Click:Connect(function()
	minimized = not minimized
	if minimized then
		MainFrame:TweenSize(UDim2.new(0, 250, 0, 40), "Out", "Quart", 0.3, true)
		ContentArea.Visible = false
		Sidebar.Visible = false
	else
		MainFrame:TweenSize(UDim2.new(0, 800, 0, 500), "Out", "Quart", 0.3, true)
		ContentArea.Visible = true
		Sidebar.Visible = true
	end
end)

-- Button hover effects
CloseButton.MouseEnter:Connect(function()
	TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220, 50, 50)}):Play()
end)

CloseButton.MouseLeave:Connect(function()
	TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = OverflowHub.Theme.Error}):Play()
end)

MinimizeButton.MouseEnter:Connect(function()
	TweenService:Create(MinimizeButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220, 170, 20)}):Play()
end)

MinimizeButton.MouseLeave:Connect(function()
	TweenService:Create(MinimizeButton, TweenInfo.new(0.2), {BackgroundColor3 = OverflowHub.Theme.Warning}):Play()
end)

-- Utility Functions
local function CreateElement(elementType, properties)
	local element = Instance.new(elementType)
	for property, value in pairs(properties) do
		element[property] = value
	end
	return element
end

local function AddCorner(element, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius or 8)
	corner.Parent = element
	return corner
end

local function AddHoverEffect(element, hoverColor, normalColor)
	element.MouseEnter:Connect(function()
		TweenService:Create(element, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
	end)
	
	element.MouseLeave:Connect(function()
		TweenService:Create(element, TweenInfo.new(0.2), {BackgroundColor3 = normalColor}):Play()
	end)
end

-- Tab System
local tabs = {}
local activeTab = nil

local function CreateTab(name, icon)
	local tabButton = CreateElement("TextButton", {
		Name = name .. "Tab",
		Parent = TabContainer,
		BackgroundColor3 = OverflowHub.Theme.ElementBackground,
		Size = UDim2.new(1, -10, 0, 35),
		Font = Enum.Font.Gotham,
		Text = "  " .. name,
		TextColor3 = OverflowHub.Theme.TextSecondary,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
	})
	
	AddCorner(tabButton, 6)
	
	local tabPage = CreateElement("ScrollingFrame", {
		Name = name .. "Page",
		Parent = TabPages,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		ScrollBarThickness = 4,
		ScrollBarImageColor3 = OverflowHub.Theme.Primary,
		BorderSizePixel = 0,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		Visible = false,
	})
	
	local pageLayout = Instance.new("UIListLayout")
	pageLayout.Parent = tabPage
	pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
	pageLayout.Padding = UDim.new(0, 10)
	
	-- Tab selection logic
	tabButton.MouseButton1Click:Connect(function()
		-- Deselect all tabs
		for _, tab in pairs(tabs) do
			tab.button.BackgroundColor3 = OverflowHub.Theme.ElementBackground
			tab.button.TextColor3 = OverflowHub.Theme.TextSecondary
			tab.page.Visible = false
		end
		
		-- Select this tab
		tabButton.BackgroundColor3 = OverflowHub.Theme.Primary
		tabButton.TextColor3 = OverflowHub.Theme.TextPrimary
		tabPage.Visible = true
		activeTab = name
		
		ContentTitle.Text = name
		
		TweenService:Create(tabButton, TweenInfo.new(0.3), {BackgroundColor3 = OverflowHub.Theme.Primary}):Play()
	end)
	
	-- Hover effects for tabs
	tabButton.MouseEnter:Connect(function()
		if activeTab ~= name then
			TweenService:Create(tabButton, TweenInfo.new(0.2), {BackgroundColor3 = OverflowHub.Theme.ElementHover}):Play()
		end
	end)
	
	tabButton.MouseLeave:Connect(function()
		if activeTab ~= name then
			TweenService:Create(tabButton, TweenInfo.new(0.2), {BackgroundColor3 = OverflowHub.Theme.ElementBackground}):Play()
		end
	end)
	
	tabs[name] = {
		button = tabButton,
		page = tabPage,
		layout = pageLayout
	}
	
	-- Auto-select first tab
	if #TabContainer:GetChildren() == 2 then -- UIListLayout + first tab
		tabButton.MouseButton1Click()
	end
	
	return {
		Name = name,
		Page = tabPage,
		
		CreateButton = function(self, settings)
			local button = CreateElement("TextButton", {
				Name = settings.Name,
				Parent = tabPage,
				BackgroundColor3 = OverflowHub.Theme.ElementBackground,
				Size = UDim2.new(1, 0, 0, 40),
				Font = Enum.Font.Gotham,
				Text = settings.Name,
				TextColor3 = OverflowHub.Theme.TextPrimary,
				TextSize = 14,
			})
			
			AddCorner(button, 8)
			AddHoverEffect(button, OverflowHub.Theme.ElementHover, OverflowHub.Theme.ElementBackground)
			
			button.MouseButton1Click:Connect(function()
				if settings.Callback then
					settings.Callback()
				end
				
				-- Visual feedback
				TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = OverflowHub.Theme.Primary}):Play()
				task.wait(0.1)
				TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = OverflowHub.Theme.ElementBackground}):Play()
			end)
			
			-- Update canvas size
			tabPage.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y)
			pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				tabPage.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y)
			end)
			
			return button
		end,
		
		CreateToggle = function(self, settings)
			local toggleFrame = CreateElement("Frame", {
				Name = settings.Name,
				Parent = tabPage,
				BackgroundColor3 = OverflowHub.Theme.ElementBackground,
				Size = UDim2.new(1, 0, 0, 40),
			})
			
			AddCorner(toggleFrame, 8)
			
			local toggleLabel = CreateElement("TextLabel", {
				Name = "Label",
				Parent = toggleFrame,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 10, 0, 0),
				Size = UDim2.new(1, -60, 1, 0),
				Font = Enum.Font.Gotham,
				Text = settings.Name,
				TextColor3 = OverflowHub.Theme.TextPrimary,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
			})
			
			local toggleButton = CreateElement("TextButton", {
				Name = "ToggleButton",
				Parent = toggleFrame,
				BackgroundColor3 = settings.Default and OverflowHub.Theme.Primary or OverflowHub.Theme.Border,
				Position = UDim2.new(1, -40, 0.5, -10),
				Size = UDim2.new(0, 35, 0, 20),
				Text = "",
			})
			
			AddCorner(toggleButton, 10)
			
			local toggleIndicator = CreateElement("Frame", {
				Name = "Indicator",
				Parent = toggleButton,
				BackgroundColor3 = OverflowHub.Theme.TextPrimary,
				Position = settings.Default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
				Size = UDim2.new(0, 16, 0, 16),
			})
			
			AddCorner(toggleIndicator, 8)
			
			local toggled = settings.Default or false
			
			toggleButton.MouseButton1Click:Connect(function()
				toggled = not toggled
				
				if toggled then
					TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = OverflowHub.Theme.Primary}):Play()
					TweenService:Create(toggleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(1, -18, 0.5, -8)}):Play()
				else
					TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = OverflowHub.Theme.Border}):Play()
					TweenService:Create(toggleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -8)}):Play()
				end
				
				if settings.Callback then
					settings.Callback(toggled)
				end
			end)
			
			-- Update canvas size
			tabPage.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y)
			pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				tabPage.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y)
			end)
			
			return {
				Set = function(value)
					toggled = value
					if toggled then
						toggleButton.BackgroundColor3 = OverflowHub.Theme.Primary
						toggleIndicator.Position = UDim2.new(1, -18, 0.5, -8)
					else
						toggleButton.BackgroundColor3 = OverflowHub.Theme.Border
						toggleIndicator.Position = UDim2.new(0, 2, 0.5, -8)
					end
				end
			}
		end,
		
		CreateSlider = function(self, settings)
			local sliderFrame = CreateElement("Frame", {
				Name = settings.Name,
				Parent = tabPage,
				BackgroundColor3 = OverflowHub.Theme.ElementBackground,
				Size = UDim2.new(1, 0, 0, 60),
			})
			
			AddCorner(sliderFrame, 8)
			
			local sliderLabel = CreateElement("TextLabel", {
				Name = "Label",
				Parent = sliderFrame,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 10, 0, 5),
				Size = UDim2.new(1, -20, 0, 20),
				Font = Enum.Font.Gotham,
				Text = settings.Name,
				TextColor3 = OverflowHub.Theme.TextPrimary,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
			})
			
			local valueLabel = CreateElement("TextLabel", {
				Name = "ValueLabel",
				Parent = sliderFrame,
				BackgroundTransparency = 1,
				Position = UDim2.new(1, -60, 0, 5),
				Size = UDim2.new(0, 50, 0, 20),
				Font = Enum.Font.Gotham,
				Text = tostring(settings.Default or settings.Min),
				TextColor3 = OverflowHub.Theme.Primary,
				TextSize = 12,
				TextXAlignment = Enum.TextXAlignment.Right,
			})
			
			local sliderTrack = CreateElement("Frame", {
				Name = "Track",
				Parent = sliderFrame,
				BackgroundColor3 = OverflowHub.Theme.Border,
				Position = UDim2.new(0, 10, 0, 35),
				Size = UDim2.new(1, -20, 0, 4),
			})
			
			AddCorner(sliderTrack, 2)
			
			local sliderFill = CreateElement("Frame", {
				Name = "Fill",
				Parent = sliderTrack,
				BackgroundColor3 = OverflowHub.Theme.Primary,
				Size = UDim2.new(0, 0, 1, 0),
			})
			
			AddCorner(sliderFill, 2)
			
			local sliderHandle = CreateElement("TextButton", {
				Name = "Handle",
				Parent = sliderFrame,
				BackgroundColor3 = OverflowHub.Theme.Primary,
				Position = UDim2.new(0, 8, 0, 31),
				Size = UDim2.new(0, 12, 0, 12),
				Text = "",
			})
			
			AddCorner(sliderHandle, 6)
			
			local currentValue = settings.Default or settings.Min
			local draggingSlider = false
			
			local function updateSlider(value)
				currentValue = math.clamp(value, settings.Min, settings.Max)
				local percentage = (currentValue - settings.Min) / (settings.Max - settings.Min)
				
				sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
				sliderHandle.Position = UDim2.new(percentage, -2, 0, 31)
				valueLabel.Text = tostring(math.floor(currentValue * 100) / 100)
				
				if settings.Callback then
					settings.Callback(currentValue)
				end
			end
			
			sliderHandle.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					draggingSlider = true
				end
			end)
			
			UserInputService.InputChanged:Connect(function(input)
				if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
					local mousePos = UserInputService:GetMouseLocation().X
					local framePos = sliderTrack.AbsolutePosition.X
					local frameSize = sliderTrack.AbsoluteSize.X
					local percentage = math.clamp((mousePos - framePos) / frameSize, 0, 1)
					local value = settings.Min + (percentage * (settings.Max - settings.Min))
					updateSlider(value)
				end
			end)
			
			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					draggingSlider = false
				end
			end)
			
			sliderTrack.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					local mousePos = UserInputService:GetMouseLocation().X
					local framePos = sliderTrack.AbsolutePosition.X
					local frameSize = sliderTrack.AbsoluteSize.X
					local percentage = math.clamp((mousePos - framePos) / frameSize, 0, 1)
					local value = settings.Min + (percentage * (settings.Max - settings.Min))
					updateSlider(value)
				end
			end)
			
			-- Initialize slider
			updateSlider(currentValue)
			
			-- Update canvas size
			tabPage.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y)
			pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				tabPage.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y)
			end)
			
			return {
				Set = function(value)
					updateSlider(value)
				end
			}
		end,
		
		CreateInput = function(self, settings)
			local inputFrame = CreateElement("Frame", {
				Name = settings.Name,
				Parent = tabPage,
				BackgroundColor3 = OverflowHub.Theme.ElementBackground,
				Size = UDim2.new(1, 0, 0, 60),
			})
			
			AddCorner(inputFrame, 8)
			
			local inputLabel = CreateElement("TextLabel", {
				Name = "Label",
				Parent = inputFrame,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 10, 0, 5),
				Size = UDim2.new(1, -20, 0, 20),
				Font = Enum.Font.Gotham,
				Text = settings.Name,
				TextColor3 = OverflowHub.Theme.TextPrimary,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
			})
			
			local textBox = CreateElement("TextBox", {
				Name = "TextBox",
				Parent = inputFrame,
				BackgroundColor3 = OverflowHub.Theme.Background,
				Position = UDim2.new(0, 10, 0, 30),
				Size = UDim2.new(1, -20, 0, 25),
				Font = Enum.Font.Gotham,
				PlaceholderText = settings.PlaceholderText or "Enter text...",
				PlaceholderColor3 = OverflowHub.Theme.TextMuted,
				Text = settings.Default or "",
				TextColor3 = OverflowHub.Theme.TextPrimary,
				TextSize = 12,
				TextXAlignment = Enum.TextXAlignment.Left,
			})
			
			AddCorner(textBox, 6)
			
			local border = CreateElement("UIStroke", {
				Parent = textBox,
				Color = OverflowHub.Theme.Border,
				Thickness = 1,
			})
			
			textBox.Focused:Connect(function()
				TweenService:Create(border, TweenInfo.new(0.2), {Color = OverflowHub.Theme.Primary}):Play()
			end)
			
			textBox.FocusLost:Connect(function()
				TweenService:Create(border, TweenInfo.new(0.2), {Color = OverflowHub.Theme.Border}):Play()
				if settings.Callback then
					settings.Callback(textBox.Text)
				end
			end)
			
			-- Update canvas size
			tabPage.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y)
			pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				tabPage.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y)
			end)
			
			return {
				Set = function(text)
					textBox.Text = text
				end
			}
		end,
		
		CreateLabel = function(self, settings)
			local labelFrame = CreateElement("Frame", {
				Name = settings.Name,
				Parent = tabPage,
				BackgroundColor3 = OverflowHub.Theme.ElementBackground,
				Size = UDim2.new(1, 0, 0, 40),
			})
			
			AddCorner(labelFrame, 8)
			
			local label = CreateElement("TextLabel", {
				Name = "Label",
				Parent = labelFrame,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 10, 0, 0),
				Size = UDim2.new(1, -20, 1, 0),
				Font = Enum.Font.Gotham,
				Text = settings.Text or settings.Name,
				TextColor3 = OverflowHub.Theme.TextSecondary,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextWrapped = true,
			})
			
			-- Update canvas size
			tabPage.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y)
			pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				tabPage.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y)
			end)
			
			return {
				Set = function(text)
					label.Text = text
				end
			}
		end
	}
end

-- Main Library Functions (Rayfield Compatible)
function OverflowHub:CreateWindow(settings)
	Title.Text = settings.Name or "0verflow Hub"
	
	if settings.ConfigurationSaving and settings.ConfigurationSaving.Enabled then
		-- Configuration saving logic would go here
	end
	
	return {
		CreateTab = CreateTab,
		ModifyTheme = function(theme)
			-- Theme modification logic
		end,
		Minimize = function()
			MinimizeButton.MouseButton1Click()
		end,
		SetTitle = function(title)
			Title.Text = title
		end
	}
end

function OverflowHub:Notify(settings)
	-- Notification system (can be implemented later)
	print("Notification:", settings.Title, settings.Content)
end

function OverflowHub:Destroy()
	ScreenGui:Destroy()
end

-- Update tab container canvas size
TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y)
end)

-- Entrance animation
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

MainFrame:TweenSizeAndPosition(
	UDim2.new(0, 800, 0, 500),
	UDim2.new(0.5, -400, 0.5, -250),
	"Out",
	"Back",
	0.6,
	true
)

-- Return the library for compatibility
return OverflowHub
