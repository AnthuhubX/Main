local Frosty = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local HttpService = game:GetService("HttpService")
local pfp
local user
local tag
local userinfo = {}

pcall(function()
	userinfo = HttpService:JSONDecode(readfile("FrostyUIData.json"))
end)

pfp = userinfo["pfp"] or "https://www.roblox.com/headshot-thumbnail/image?userId=".. LocalPlayer.UserId .."&width=420&height=420&format=png"
user =  userinfo["user"] or LocalPlayer.Name
tag = userinfo["tag"] or ""

local function SaveInfo()
	userinfo["pfp"] = pfp
	userinfo["user"] = user
	userinfo["tag"] = tag
	writefile("FrostyUIData.json", HttpService:JSONEncode(userinfo))
end

local function MakeDraggable(topbarobject, object)
	local Dragging = nil
	local DragInput = nil
	local DragStart = nil
	local StartPosition = nil

	local function Update(input)
		local Delta = input.Position - DragStart
		local pos =
			UDim2.new(
				StartPosition.X.Scale,
				StartPosition.X.Offset + Delta.X,
				StartPosition.Y.Scale,
				StartPosition.Y.Offset + Delta.Y
			)
		object.Position = pos
	end

	topbarobject.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			DragStart = input.Position
			StartPosition = object.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					Dragging = false
				end
			end)
		end
	end)

	topbarobject.InputChanged:Connect(function(input)
		if
			input.UserInputType == Enum.UserInputType.MouseMovement or
			input.UserInputType == Enum.UserInputType.Touch
		then
			DragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == DragInput and Dragging then
			Update(input)
		end
	end)
end

local FrostyLib = Instance.new("ScreenGui")
FrostyLib.Name = "FrostyLib"
FrostyLib.Parent = game.CoreGui
FrostyLib.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

function Frosty:CreateWindow(config)
	config.Name = config.Name or "Frosty"
	config.LoadingTitle = config.LoadingTitle or "Frosty Interface Suite"
	config.LoadingSubtitle = config.LoadingSubtitle or "by Frosty!"
	config.ConfigurationSaving = config.ConfigurationSaving or {
		Enabled = false,
		FolderName = nil, 
		FileName = "Frosty"
	}
    
	local FirstTab = true
	local Minimized = false
	local Loaded = false
	local Hidden = false

	local ScreenGui = FrostyLib
	local Container = Instance.new("Frame")
	local ContainerCorner = Instance.new("UICorner")
	local Sidebar = Instance.new("Frame")
	local SidebarCorner = Instance.new("UICorner")
	local Title = Instance.new("TextLabel")
	local SidebarLine = Instance.new("Frame")
	local TabContainer = Instance.new("ScrollingFrame")
	local TabListLayout = Instance.new("UIListLayout")
	local ContainerLine = Instance.new("Frame")
	local Topbar = Instance.new("Frame")
	local TopbarCorner = Instance.new("UICorner")
	local TopbarLine = Instance.new("Frame")
	local WindowTitle = Instance.new("TextLabel")
	local CloseButton = Instance.new("TextButton")
	local MinimizeButton = Instance.new("TextButton")
	local TabHolder = Instance.new("Frame")
	local FrostyLogoOutline = Instance.new("ImageLabel")
	local FrostyLogo = Instance.new("ImageLabel")
	local ProfilePicture = Instance.new("ImageLabel")
	local ProfilePictureCorner = Instance.new("UICorner")
	local Username = Instance.new("TextLabel")

	if config.ConfigurationSaving.Enabled and config.ConfigurationSaving.FolderName and config.ConfigurationSaving.FileName then
		if not isfolder(config.ConfigurationSaving.FolderName) then
			makefolder(config.ConfigurationSaving.FolderName)
		end
	end

	Container.Name = "Container"
	Container.Parent = ScreenGui
	Container.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
	Container.Position = UDim2.new(0.5, 0, 0.5, 0)
	Container.Size = UDim2.new(0, 700, 0, 500)
	Container.AnchorPoint = Vector2.new(0.5, 0.5)
	Container.Active = true
	Container.Visible = false

	ContainerCorner.Name = "ContainerCorner"
	ContainerCorner.Parent = Container

	Sidebar.Name = "Sidebar"
	Sidebar.Parent = Container
	Sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	Sidebar.Position = UDim2.new(0, 0, 0, 0)
	Sidebar.Size = UDim2.new(0, 200, 0, 500)

	SidebarCorner.CornerRadius = UDim.new(0, 4)
	SidebarCorner.Name = "SidebarCorner"
	SidebarCorner.Parent = Sidebar

	Title.Name = "Title"
	Title.Parent = Sidebar
	Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Title.BackgroundTransparency = 1.000
	Title.Position = UDim2.new(0, 50, 0, 40)
	Title.Size = UDim2.new(0, 175, 0, 25)
	Title.Font = Enum.Font.GothamBold
	Title.Text = config.Name
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.TextSize = 25.000
	Title.TextXAlignment = Enum.TextXAlignment.Left

	SidebarLine.Name = "SidebarLine"
	SidebarLine.Parent = Sidebar
	SidebarLine.BackgroundColor3 = Color3.fromRGB(52, 52, 52)
	SidebarLine.BorderSizePixel = 0
	SidebarLine.Position = UDim2.new(0, 0, 0, 80)
	SidebarLine.Size = UDim2.new(1, 0, 0, 1)

	TabContainer.Name = "TabContainer"
	TabContainer.Parent = Sidebar
	TabContainer.Active = true
	TabContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TabContainer.BackgroundTransparency = 1.000
	TabContainer.Position = UDim2.new(0, 0, 0, 86)
	TabContainer.Size = UDim2.new(1, 0, 0, 344)
	TabContainer.ScrollBarThickness = 0

	TabListLayout.Name = "TabListLayout"
	TabListLayout.Parent = TabContainer
	TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TabListLayout.Padding = UDim.new(0, 3)
    
	TabHolder.Name = "TabHolder"
	TabHolder.Parent = Container
	TabHolder.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
	TabHolder.BackgroundTransparency = 1.000
	TabHolder.ClipsDescendants = true
	TabHolder.Position = UDim2.new(0, 200, 0, 35)
	TabHolder.Size = UDim2.new(0, 500, 0, 465)

	ContainerLine.Name = "ContainerLine"
	ContainerLine.Parent = Container
	ContainerLine.BackgroundColor3 = Color3.fromRGB(52, 52, 52)
	ContainerLine.BorderSizePixel = 0
	ContainerLine.Position = UDim2.new(0, 0, 0, 35)
	ContainerLine.Size = UDim2.new(1, 0, 0, 1)

	Topbar.Name = "Topbar"
	Topbar.Parent = Container
	Topbar.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
	Topbar.Size = UDim2.new(0, 700, 0, 35)

	TopbarCorner.CornerRadius = UDim.new(0, 4)
	TopbarCorner.Name = "TopbarCorner"
	TopbarCorner.Parent = Topbar

	TopbarLine.Name = "TopbarLine"
	TopbarLine.Parent = Topbar
	TopbarLine.BackgroundColor3 = Color3.fromRGB(52, 52, 52)
	TopbarLine.BorderSizePixel = 0
	TopbarLine.Position = UDim2.new(0, 0, 0, 35)
	TopbarLine.Size = UDim2.new(1, 0, 0, 1)

	WindowTitle.Name = "WindowTitle"
	WindowTitle.Parent = Topbar
	WindowTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	WindowTitle.BackgroundTransparency = 1.000
	WindowTitle.Position = UDim2.new(0, 15, 0, 0)
	WindowTitle.Size = UDim2.new(0, 700, 0, 35)
	WindowTitle.Font = Enum.Font.GothamBold
	WindowTitle.Text = config.Name
	WindowTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	WindowTitle.TextSize = 14.000
	WindowTitle.TextXAlignment = Enum.TextXAlignment.Left

	CloseButton.Name = "CloseButton"
	CloseButton.Parent = Topbar
	CloseButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	CloseButton.BackgroundTransparency = 1.000
	CloseButton.Position = UDim2.new(0, 675, 0, 10)
	CloseButton.Size = UDim2.new(0, 15, 0, 15)
	CloseButton.Font = Enum.Font.GothamBold
	CloseButton.Text = "X"
	CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	CloseButton.TextSize = 15.000
	CloseButton.Visible = config.CloseButton or false

	MinimizeButton.Name = "MinimizeButton"
	MinimizeButton.Parent = Topbar
	MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	MinimizeButton.BackgroundTransparency = 1.000
	MinimizeButton.Position = UDim2.new(0, 655, 0, 10)
	MinimizeButton.Size = UDim2.new(0, 15, 0, 15)
	MinimizeButton.Font = Enum.Font.GothamBold
	MinimizeButton.Text = "-"
	MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	MinimizeButton.TextSize = 25.000

	FrostyLogoOutline.Name = "FrostyLogoOutline"
	FrostyLogoOutline.Parent = Sidebar
	FrostyLogoOutline.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	FrostyLogoOutline.BackgroundTransparency = 1.000
	FrostyLogoOutline.Position = UDim2.new(0, 20, 0, 35)
	FrostyLogoOutline.Size = UDim2.new(0, 25, 0, 25)
	FrostyLogoOutline.Image = "rbxassetid://5539709632"
	FrostyLogoOutline.ImageColor3 = Color3.fromRGB(52, 52, 52)

	FrostyLogo.Name = "FrostyLogo"
	FrostyLogo.Parent = Sidebar
	FrostyLogo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	FrostyLogo.BackgroundTransparency = 1.000
	FrostyLogo.Position = UDim2.new(0, 20, 0, 35)
	FrostyLogo.Size = UDim2.new(0, 25, 0, 25)
	FrostyLogo.Image = "rbxassetid://5539709632"
	FrostyLogo.ImageColor3 = Color3.fromRGB(255, 255, 255)

	ProfilePicture.Name = "ProfilePicture"
	ProfilePicture.Parent = Sidebar
	ProfilePicture.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ProfilePicture.BackgroundTransparency = 1.000
	ProfilePicture.Position = UDim2.new(0, 20, 0, 440)
	ProfilePicture.Size = UDim2.new(0, 25, 0, 25)
	ProfilePicture.Image = pfp

	ProfilePictureCorner.CornerRadius = UDim.new(1, 0)
	ProfilePictureCorner.Name = "ProfilePictureCorner"
	ProfilePictureCorner.Parent = ProfilePicture

	Username.Name = "Username"
	Username.Parent = Sidebar
	Username.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Username.BackgroundTransparency = 1.000
	Username.Position = UDim2.new(0, 50, 0, 440)
	Username.Size = UDim2.new(0, 100, 0, 25)
	Username.Font = Enum.Font.GothamBold
	Username.Text = user
	Username.TextColor3 = Color3.fromRGB(255, 255, 255)
	Username.TextSize = 14.000
	Username.TextXAlignment = Enum.TextXAlignment.Left

	-- Loading UI elements
	local LoadingFrame = Instance.new("Frame")
	local LoadingFrameCorner = Instance.new("UICorner")
	local NameLabel = Instance.new("TextLabel")
	local LoadingTitle = Instance.new("TextLabel")
	local LoadingSubtitle = Instance.new("TextLabel")
	local LoadingBar = Instance.new("Frame")
	local LoadingBarCorner = Instance.new("UICorner")
	local LoadingBarFill = Instance.new("Frame")
	local LoadingBarFillCorner = Instance.new("UICorner")

	LoadingFrame.Name = "LoadingFrame"
	LoadingFrame.Parent = ScreenGui
	LoadingFrame.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
	LoadingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	LoadingFrame.Size = UDim2.new(0, 400, 0, 200)
	LoadingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	LoadingFrame.Active = true
	LoadingFrame.Visible = false

	LoadingFrameCorner.CornerRadius = UDim.new(0, 6)
	LoadingFrameCorner.Name = "LoadingFrameCorner"
	LoadingFrameCorner.Parent = LoadingFrame

	NameLabel.Name = "NameLabel"
	NameLabel.Parent = LoadingFrame
	NameLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	NameLabel.BackgroundTransparency = 1.000
	NameLabel.Position = UDim2.new(0, 0, 0, 20)
	NameLabel.Size = UDim2.new(1, 0, 0, 25)
	NameLabel.Font = Enum.Font.GothamBold
	NameLabel.Text = config.Name
	NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	NameLabel.TextSize = 24.000

	LoadingTitle.Name = "LoadingTitle"
	LoadingTitle.Parent = LoadingFrame
	LoadingTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	LoadingTitle.BackgroundTransparency = 1.000
	LoadingTitle.Position = UDim2.new(0, 0, 0, 55)
	LoadingTitle.Size = UDim2.new(1, 0, 0, 25)
	LoadingTitle.Font = Enum.Font.GothamBold
	LoadingTitle.Text = config.LoadingTitle
	LoadingTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	LoadingTitle.TextSize = 16.000

	LoadingSubtitle.Name = "LoadingSubtitle"
	LoadingSubtitle.Parent = LoadingFrame
	LoadingSubtitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	LoadingSubtitle.BackgroundTransparency = 1.000
	LoadingSubtitle.Position = UDim2.new(0, 0, 0, 80)
	LoadingSubtitle.Size = UDim2.new(1, 0, 0, 25)
	LoadingSubtitle.Font = Enum.Font.Gotham
	LoadingSubtitle.Text = config.LoadingSubtitle
	LoadingSubtitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	LoadingSubtitle.TextSize = 14.000

	LoadingBar.Name = "LoadingBar"
	LoadingBar.Parent = LoadingFrame
	LoadingBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	LoadingBar.Position = UDim2.new(0, 50, 0, 140)
	LoadingBar.Size = UDim2.new(0, 300, 0, 15)

	LoadingBarCorner.CornerRadius = UDim.new(0, 6)
	LoadingBarCorner.Name = "LoadingBarCorner"
	LoadingBarCorner.Parent = LoadingBar

	LoadingBarFill.Name = "LoadingBarFill"
	LoadingBarFill.Parent = LoadingBar
	LoadingBarFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	LoadingBarFill.Size = UDim2.new(0, 0, 1, 0)

	LoadingBarFillCorner.CornerRadius = UDim.new(0, 6)
	LoadingBarFillCorner.Name = "LoadingBarFillCorner"
	LoadingBarFillCorner.Parent = LoadingBarFill

	-- Show the loading screen
	LoadingFrame.Visible = true
	
	MakeDraggable(Topbar, Container)
	RunService.RenderStepped:Connect(function()
		if Minimized then
			Container.Size = Container.Size:Lerp(UDim2.new(0, 700, 0, 35), 0.1)
		else
			Container.Size = Container.Size:Lerp(UDim2.new(0, 700, 0, 500), 0.1)
		end
	end)

	MinimizeButton.MouseButton1Click:Connect(function()
		Minimized = not Minimized
		if Minimized then
			MinimizeButton.Text = "+"
		else
			MinimizeButton.Text = "-"
		end
	end)

	CloseButton.MouseButton1Click:Connect(function()
		Container.Visible = false
	end)

	-- Loading bar animation
	for i = 1, 100 do
		LoadingBarFill:TweenSize(UDim2.new(i/100, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.05, true)
		wait(0.05)
	end
	
	wait(0.5)
	LoadingFrame:TweenPosition(UDim2.new(0.5, 0, 1.5, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.5, true)
	wait(0.5)
	LoadingFrame.Visible = false
	Container.Visible = true
	Container.Position = UDim2.new(0.5, 0, -0.5, 0)
	Container:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.5, true)
	wait(0.5)
	Loaded = true

	local Window = {}
	
	function Window:CreateTab(Name, IconId)
		local TabButton = Instance.new("TextButton")
		local TabButtonCorner = Instance.new("UICorner")
		local TabIcon = Instance.new("ImageLabel")
		local TabTitle = Instance.new("TextLabel")
		local Tab = Instance.new("ScrollingFrame")
		local TabListLayout = Instance.new("UIListLayout")
		local TabPadding = Instance.new("UIPadding")

		TabButton.Name = "TabButton"
		TabButton.Parent = TabContainer
		TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		TabButton.Size = UDim2.new(0, 180, 0, 40)
		TabButton.AutoButtonColor = false
		TabButton.Font = Enum.Font.SourceSans
		TabButton.Text = ""
		TabButton.TextColor3 = Color3.fromRGB(0, 0, 0)
		TabButton.TextSize = 14.000

		TabButtonCorner.CornerRadius = UDim.new(0, 4)
		TabButtonCorner.Name = "TabButtonCorner"
		TabButtonCorner.Parent = TabButton

		TabIcon.Name = "TabIcon"
		TabIcon.Parent = TabButton
		TabIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabIcon.BackgroundTransparency = 1.000
		TabIcon.Position = UDim2.new(0, 10, 0, 8)
		TabIcon.Size = UDim2.new(0, 25, 0, 25)
		TabIcon.Image = "rbxassetid://" .. tostring(IconId)

		TabTitle.Name = "TabTitle"
		TabTitle.Parent = TabButton
		TabTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabTitle.BackgroundTransparency = 1.000
		TabTitle.Position = UDim2.new(0, 40, 0, 0)
		TabTitle.Size = UDim2.new(0, 140, 0, 40)
		TabTitle.Font = Enum.Font.Gotham
		TabTitle.Text = Name
		TabTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
		TabTitle.TextSize = 14.000
		TabTitle.TextXAlignment = Enum.TextXAlignment.Left

		Tab.Name = "Tab"
		Tab.Parent = TabHolder
		Tab.Active = true
		Tab.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
		Tab.BackgroundTransparency = 1.000
		Tab.BorderSizePixel = 0
		Tab.Size = UDim2.new(1, 0, 1, 0)
		Tab.CanvasSize = UDim2.new(0, 0, 0, 0)
		Tab.ScrollBarThickness = 2
		Tab.Visible = false

		TabListLayout.Name = "TabListLayout"
		TabListLayout.Parent = Tab
		TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		TabListLayout.Padding = UDim.new(0, 5)

		TabPadding.Name = "TabPadding"
		TabPadding.Parent = Tab
		TabPadding.PaddingTop = UDim.new(0, 5)

		if FirstTab then
			FirstTab = false
			Tab.Visible = true
			TabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		end

		TabButton.MouseButton1Click:Connect(function()
			for _, v in next, TabHolder:GetChildren() do
				if v:IsA("ScrollingFrame") then
					v.Visible = false
				end
			end
			
			for _, v in next, TabContainer:GetChildren() do
				if v:IsA("TextButton") then
					v.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
				end
			end
			
			Tab.Visible = true
			TabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		end)

		-- Auto-adjust canvas size based on content
		Tab.ChildAdded:Connect(function()
			Tab.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y + 10)
		end)
		Tab.ChildRemoved:Connect(function()
			Tab.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y + 10)
		end)

		local TabElements = {}

		function TabElements:CreateSection(Name)
			local Section = Instance.new("Frame")
			local SectionTitle = Instance.new("TextLabel")
			local SectionLine = Instance.new("Frame")
			local SectionContent = Instance.new("Frame")
			local SectionContentLayout = Instance.new("UIListLayout")

			Section.Name = "Section"
			Section.Parent = Tab
			Section.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			Section.Size = UDim2.new(0, 475, 0, 35)

			SectionTitle.Name = "SectionTitle"
			SectionTitle.Parent = Section
			SectionTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionTitle.BackgroundTransparency = 1.000
			SectionTitle.Position = UDim2.new(0, 10, 0, 0)
			SectionTitle.Size = UDim2.new(0, 475, 0, 35)
			SectionTitle.Font = Enum.Font.GothamBold
			SectionTitle.Text = Name
			SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
			SectionTitle.TextSize = 14.000
			SectionTitle.TextXAlignment = Enum.TextXAlignment.Left

			SectionLine.Name = "SectionLine"
			SectionLine.Parent = Section
			SectionLine.BackgroundColor3 = Color3.fromRGB(52, 52, 52)
			SectionLine.BorderSizePixel = 0
			SectionLine.Position = UDim2.new(0, 0, 0, 35)
			SectionLine.Size = UDim2.new(1, 0, 0, 1)

			SectionContent.Name = "SectionContent"
			SectionContent.Parent = Section
			SectionContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionContent.BackgroundTransparency = 1.000
			SectionContent.Position = UDim2.new(0, 0, 0, 36)
			SectionContent.Size = UDim2.new(0, 475, 0, 0) -- Will auto-adjust

			SectionContentLayout.Name = "SectionContentLayout"
			SectionContentLayout.Parent = SectionContent
			SectionContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			SectionContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
			SectionContentLayout.Padding = UDim.new(0, 5)

			-- Auto-adjust section size based on content
			SectionContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				SectionContent.Size = UDim2.new(0, 475, 0, SectionContentLayout.AbsoluteContentSize.Y)
				Section.Size = UDim2.new(0, 475, 0, 35 + SectionContentLayout.AbsoluteContentSize.Y)
			end)

			return "Section created"
		end

		function TabElements:CreateButton(options)
			options = options or {}
			options.Name = options.Name or "Button"
			options.Callback = options.Callback or function() end
			options.Info = options.Info or ""
			options.Interact = options.Interact or "Click"

			local Button = Instance.new("Frame")
			local ButtonTitle = Instance.new("TextLabel")
			local ButtonInteractable = Instance.new("TextButton")
			local ButtonCorner = Instance.new("UICorner")
			local ButtonInfo = Instance.new("ImageButton")

			Button.Name = "Button"
			Button.Parent = Tab
			Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			Button.Size = UDim2.new(0, 475, 0, 35)

			ButtonTitle.Name = "ButtonTitle"
			ButtonTitle.Parent = Button
			ButtonTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ButtonTitle.BackgroundTransparency = 1.000
			ButtonTitle.Position = UDim2.new(0, 10, 0, 0)
			ButtonTitle.Size = UDim2.new(0, 350, 0, 35)
			ButtonTitle.Font = Enum.Font.Gotham
			ButtonTitle.Text = options.Name
			ButtonTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
			ButtonTitle.TextSize = 14.000
			ButtonTitle.TextXAlignment = Enum.TextXAlignment.Left

			ButtonInteractable.Name = "ButtonInteractable"
			ButtonInteractable.Parent = Button
			ButtonInteractable.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			ButtonInteractable.Position = UDim2.new(0, 370, 0, 5)
			ButtonInteractable.Size = UDim2.new(0, 100, 0, 25)
			ButtonInteractable.Font = Enum.Font.Gotham
			ButtonInteractable.Text = options.Interact
			ButtonInteractable.TextColor3 = Color3.fromRGB(255, 255, 255)
			ButtonInteractable.TextSize = 14.000
			ButtonInteractable.AutoButtonColor = false

			ButtonCorner.CornerRadius = UDim.new(0, 4)
			ButtonCorner.Name = "ButtonCorner"
			ButtonCorner.Parent = ButtonInteractable

			ButtonInfo.Name = "ButtonInfo"
			ButtonInfo.Parent = Button
			ButtonInfo.BackgroundTransparency = 1.000
			ButtonInfo.LayoutOrder = 3
			ButtonInfo.Position = UDim2.new(0, 350, 0, 10)
			ButtonInfo.Size = UDim2.new(0, 15, 0, 15)
			ButtonInfo.ZIndex = 2
			ButtonInfo.Image = "rbxassetid://3926305904"
			ButtonInfo.ImageRectOffset = Vector2.new(4, 804)
			ButtonInfo.ImageRectSize = Vector2.new(36, 36)
			ButtonInfo.Visible = options.Info ~= ""

			ButtonInteractable.MouseButton1Click:Connect(function()
				options.Callback()
			end)

			if options.Info ~= "" then
				local InfoFrame = Instance.new("Frame")
				local InfoFrameCorner = Instance.new("UICorner")
				local InfoText = Instance.new("TextLabel")
				
				InfoFrame.Name = "InfoFrame"
				InfoFrame.Parent = ScreenGui
				InfoFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
				InfoFrame.Position = UDim2.new(0, Mouse.X + 15, 0, Mouse.Y + 15)
				InfoFrame.Size = UDim2.new(0, 200, 0, 0)
				InfoFrame.Visible = false
				InfoFrame.ZIndex = 100
				
				InfoFrameCorner.CornerRadius = UDim.new(0, 4)
				InfoFrameCorner.Name = "InfoFrameCorner"
				InfoFrameCorner.Parent = InfoFrame
				
				InfoText.Name = "InfoText"
				InfoText.Parent = InfoFrame
				InfoText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				InfoText.BackgroundTransparency = 1.000
				InfoText.Position = UDim2.new(0, 5, 0, 5)
				InfoText.Size = UDim2.new(0, 190, 0, 0)
				InfoText.Font = Enum.Font.Gotham
				InfoText.Text = options.Info
				InfoText.TextColor3 = Color3.fromRGB(255, 255, 255)
				InfoText.TextSize = 14.000
				InfoText.TextWrapped = true
				InfoText.ZIndex = 100
				InfoText.TextXAlignment = Enum.TextXAlignment.Left
				InfoText.TextYAlignment = Enum.TextYAlignment.Top
				
				ButtonInfo.MouseEnter:Connect(function()
					InfoText.Text = options.Info
					InfoFrame.Size = UDim2.new(0, 200, 0, InfoText.TextBounds.Y + 10)
					InfoText.Size = UDim2.new(0, 190, 0, InfoText.TextBounds.Y)
					InfoFrame.Position = UDim2.new(0, Mouse.X + 15, 0, Mouse.Y + 15)
					InfoFrame.Visible = true
				end)
				
				ButtonInfo.MouseLeave:Connect(function()
					InfoFrame.Visible = false
				end)
				
				RunService.RenderStepped:Connect(function()
					if InfoFrame.Visible then
						InfoFrame.Position = UDim2.new(0, Mouse.X + 15, 0, Mouse.Y + 15)
					end
				end)
			end

			return Button
		end

		function TabElements:CreateToggle(options)
			options = options or {}
			options.Name = options.Name or "Toggle"
			options.CurrentValue = options.CurrentValue or false
			options.Flag = options.Flag or nil
			options.Callback = options.Callback or function() end
			options.Info = options.Info or ""

			local Toggle = Instance.new("Frame")
			local ToggleTitle = Instance.new("TextLabel")
			local ToggleFrame = Instance.new("Frame")
			local ToggleFrameCorner = Instance.new("UICorner")
			local ToggleButton = Instance.new("Frame")
			local ToggleButtonCorner = Instance.new("UICorner")
			local ToggleInfo = Instance.new("ImageButton")
			
			Toggle.Name = "Toggle"
			Toggle.Parent = Tab
			Toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			Toggle.Size = UDim2.new(0, 475, 0, 35)
			
			ToggleTitle.Name = "ToggleTitle"
			ToggleTitle.Parent = Toggle
			ToggleTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ToggleTitle.BackgroundTransparency = 1.000
			ToggleTitle.Position = UDim2.new(0, 10, 0, 0)
			ToggleTitle.Size = UDim2.new(0, 350, 0, 35)
			ToggleTitle.Font = Enum.Font.Gotham
			ToggleTitle.Text = options.Name
			ToggleTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
			ToggleTitle.TextSize = 14.000
			ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
			
			ToggleFrame.Name = "ToggleFrame"
			ToggleFrame.Parent = Toggle
			ToggleFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			ToggleFrame.Position = UDim2.new(0, 425, 0, 8)
			ToggleFrame.Size = UDim2.new(0, 45, 0, 20)
			
			ToggleFrameCorner.CornerRadius = UDim.new(1, 0)
			ToggleFrameCorner.Name = "ToggleFrameCorner"
			ToggleFrameCorner.Parent = ToggleFrame
			
			ToggleButton.Name = "ToggleButton"
			ToggleButton.Parent = ToggleFrame
			ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ToggleButton.Position = UDim2.new(0, 2, 0, 2)
			ToggleButton.Size = UDim2.new(0, 16, 0, 16)
			
			ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
			ToggleButtonCorner.Name = "ToggleButtonCorner"
			ToggleButtonCorner.Parent = ToggleButton
			
			ToggleInfo.Name = "ToggleInfo"
			ToggleInfo.Parent = Toggle
			ToggleInfo.BackgroundTransparency = 1.000
			ToggleInfo.LayoutOrder = 3
			ToggleInfo.Position = UDim2.new(0, 350, 0, 10)
			ToggleInfo.Size = UDim2.new(0, 15, 0, 15)
			ToggleInfo.ZIndex = 2
			ToggleInfo.Image = "rbxassetid://3926305904"
			ToggleInfo.ImageRectOffset = Vector2.new(4, 804)
			ToggleInfo.ImageRectSize = Vector2.new(36, 36)
			ToggleInfo.Visible = options.Info ~= ""

			if options.CurrentValue then
				ToggleButton.Position = UDim2.new(0, 27, 0, 2)
				ToggleFrame.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
			end

			local function Trigger()
				options.CurrentValue = not options.CurrentValue
				options.Callback(options.CurrentValue)
				if options.CurrentValue then
					ToggleButton:TweenPosition(UDim2.new(0, 27, 0, 2), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.2, true)
					ToggleFrame:TweenSize(UDim2.new(0, 45, 0, 20), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.2, true)
					ToggleFrame.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
				else
					ToggleButton:TweenPosition(UDim2.new(0, 2, 0, 2), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.2, true)
					ToggleFrame:TweenSize(UDim2.new(0, 45, 0, 20), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.2, true)
					ToggleFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
				end
				
				if options.Flag and config.ConfigurationSaving.Enabled and config.ConfigurationSaving.FolderName and config.ConfigurationSaving.FileName then
					if not isfolder(config.ConfigurationSaving.FolderName) then 
						makefolder(config.ConfigurationSaving.FolderName)
					end
					
					local configData = {}
					if isfile(config.ConfigurationSaving.FolderName .. "/" .. config.ConfigurationSaving.FileName .. ".json") then
						local fileContent = readfile(config.ConfigurationSaving.FolderName .. "/" .. config.ConfigurationSaving.FileName .. ".json")
						configData = HttpService:JSONDecode(fileContent)
					end
					
					configData[options.Flag] = options.CurrentValue
					
					writefile(config.ConfigurationSaving.FolderName .. "/" .. config.ConfigurationSaving.FileName .. ".json", HttpService:JSONEncode(configData))
				end
			end

			ToggleFrame.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 then
					Trigger()
				end
			end)

			if options.Info ~= "" then
				local InfoFrame = Instance.new("Frame")
				local InfoFrameCorner = Instance.new("UICorner")
				local InfoText = Instance.new("TextLabel")
				
				InfoFrame.Name = "InfoFrame"
				InfoFrame.Parent = ScreenGui
				InfoFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
				InfoFrame.Position = UDim2.new(0, Mouse.X + 15, 0, Mouse.Y + 15)
				InfoFrame.Size = UDim2.new(0, 200, 0, 0)
				InfoFrame.Visible = false
				InfoFrame.ZIndex = 100
				
				InfoFrameCorner.CornerRadius = UDim.new(0, 4)
				InfoFrameCorner.Name = "InfoFrameCorner"
				InfoFrameCorner.Parent = InfoFrame
				
				InfoText.Name = "InfoText"
				InfoText.Parent = InfoFrame
				InfoText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				InfoText.BackgroundTransparency = 1.000
				InfoText.Position = UDim2.new(0, 5, 0, 5)
				InfoText.Size = UDim2.new(0, 190, 0, 0)
				InfoText.Font = Enum.Font.Gotham
				InfoText.Text = options.Info
				InfoText.TextColor3 = Color3.fromRGB(255, 255, 255)
				InfoText.TextSize = 14.000
				InfoText.TextWrapped = true
				InfoText.ZIndex = 100
				InfoText.TextXAlignment = Enum.TextXAlignment.Left
				InfoText.TextYAlignment = Enum.TextYAlignment.Top
				
				ToggleInfo.MouseEnter:Connect(function()
					InfoText.Text = options.Info
					InfoFrame.Size = UDim2.new(0, 200, 0, InfoText.TextBounds.Y + 10)
					InfoText.Size = UDim2.new(0, 190, 0, InfoText.TextBounds.Y)
					InfoFrame.Position = UDim2.new(0, Mouse.X + 15, 0, Mouse.Y + 15)
					InfoFrame.Visible = true
				end)
				
				ToggleInfo.MouseLeave:Connect(function()
					InfoFrame.Visible = false
				end)
				
				RunService.RenderStepped:Connect(function()
					if InfoFrame.Visible then
						InfoFrame.Position = UDim2.new(0, Mouse.X + 15, 0, Mouse.Y + 15)
					end
				end)
			end

			return Toggle
		end

		function TabElements:CreateSlider(options)
			options = options or {}
			options.Name = options.Name or "Slider"
			options.Range = options.Range or {0, 100}
			options.Increment = options.Increment or 1
			options.CurrentValue = options.CurrentValue or options.Range[1]
			options.Flag = options.Flag or nil
			options.Callback = options.Callback or function() end
			options.Info = options.Info or ""
			options.Suffix = options.Suffix or ""

			local Slider = Instance.new("Frame")
			local SliderTitle = Instance.new("TextLabel")
			local SliderValue = Instance.new("TextLabel")
			local SliderFrame = Instance.new("Frame")
			local SliderFrameCorner = Instance.new("UICorner")
			local SliderIndicator = Instance.new("Frame")
			local SliderIndicatorCorner = Instance.new("UICorner")
			local SliderInfo = Instance.new("ImageButton")

			Slider.Name = "Slider"
			Slider.Parent = Tab
			Slider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			Slider.Size = UDim2.new(0, 475, 0, 50)

			SliderTitle.Name = "SliderTitle"
			SliderTitle.Parent = Slider
			SliderTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SliderTitle.BackgroundTransparency = 1.000
			SliderTitle.Position = UDim2.new(0, 10, 0, 0)
			SliderTitle.Size = UDim2.new(0, 350, 0, 30)
			SliderTitle.Font = Enum.Font.Gotham
			SliderTitle.Text = options.Name
			SliderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
			SliderTitle.TextSize = 14.000
			SliderTitle.TextXAlignment = Enum.TextXAlignment.Left

			SliderValue.Name = "SliderValue"
			SliderValue.Parent = Slider
			SliderValue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SliderValue.BackgroundTransparency = 1.000
			SliderValue.Position = UDim2.new(0, 410, 0, 0)
			SliderValue.Size = UDim2.new(0, 60, 0, 30)
			SliderValue.Font = Enum.Font.Gotham
			SliderValue.Text = tostring(options.CurrentValue) .. options.Suffix
			SliderValue.TextColor3 = Color3.fromRGB(255, 255, 255)
			SliderValue.TextSize = 14.000
			SliderValue.TextXAlignment = Enum.TextXAlignment.Right

			SliderFrame.Name = "SliderFrame"
			SliderFrame.Parent = Slider
			SliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			SliderFrame.Position = UDim2.new(0, 10, 0, 35)
			SliderFrame.Size = UDim2.new(0, 455, 0, 10)

			SliderFrameCorner.CornerRadius = UDim.new(0, 4)
			SliderFrameCorner.Name = "SliderFrameCorner"
			SliderFrameCorner.Parent = SliderFrame

			SliderIndicator.Name = "SliderIndicator"
			SliderIndicator.Parent = SliderFrame
			SliderIndicator.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
			SliderIndicator.Size = UDim2.new(((options.CurrentValue - options.Range[1]) / (options.Range[2] - options.Range[1])), 0, 1, 0)

			SliderIndicatorCorner.CornerRadius = UDim.new(0, 4)
			SliderIndicatorCorner.Name = "SliderIndicatorCorner"
			SliderIndicatorCorner.Parent = SliderIndicator

			SliderInfo.Name = "SliderInfo"
			SliderInfo.Parent = Slider
			SliderInfo.BackgroundTransparency = 1.000
			SliderInfo.LayoutOrder = 3
			SliderInfo.Position = UDim2.new(0, 350, 0, 10)
			SliderInfo.Size = UDim2.new(0, 15, 0, 15)
			SliderInfo.ZIndex = 2
			SliderInfo.Image = "rbxassetid://3926305904"
			SliderInfo.ImageRectOffset = Vector2.new(4, 804)
			SliderInfo.ImageRectSize = Vector2.new(36, 36)
			SliderInfo.Visible = options.Info ~= ""

			if options.Info ~= "" then
				local InfoFrame = Instance.new("Frame")
				local InfoFrameCorner = Instance.new("UICorner")
				local InfoText = Instance.new("TextLabel")
				
				InfoFrame.Name = "InfoFrame"
				InfoFrame.Parent = ScreenGui
				InfoFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
				InfoFrame.Position = UDim2.new(0, Mouse.X + 15, 0, Mouse.Y + 15)
				InfoFrame.Size = UDim2.new(0, 200, 0, 0)
				InfoFrame.Visible = false
				InfoFrame.ZIndex = 100
				
				InfoFrameCorner.CornerRadius = UDim.new(0, 4)
				InfoFrameCorner.Name = "InfoFrameCorner"
				InfoFrameCorner.Parent = InfoFrame
				
				InfoText.Name = "InfoText"
				InfoText.Parent = InfoFrame
				InfoText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				InfoText.BackgroundTransparency = 1.000
				InfoText.Position = UDim2.new(0, 5, 0, 5)
				InfoText.Size = UDim2.new(0, 190, 0, 0)
				InfoText.Font = Enum.Font.Gotham
				InfoText.Text = options.Info
				InfoText.TextColor3 = Color3.fromRGB(255, 255, 255)
				InfoText.TextSize = 14.000
				InfoText.TextWrapped = true
				InfoText.ZIndex = 100
				InfoText.TextXAlignment = Enum.TextXAlignment.Left
				InfoText.TextYAlignment = Enum.TextYAlignment.Top
				
				SliderInfo.MouseEnter:Connect(function()
					InfoText.Text = options.Info
					InfoFrame.Size = UDim2.new(0, 200, 0, InfoText.TextBounds.Y + 10)
					InfoText.Size = UDim2.new(0, 190, 0, InfoText.TextBounds.Y)
					InfoFrame.Position = UDim2.new(0, Mouse.X + 15, 0, Mouse.Y + 15)
					InfoFrame.Visible = true
				end)
				
				SliderInfo.MouseLeave:Connect(function()
					InfoFrame.Visible = false
				end)
				
				RunService.RenderStepped:Connect(function()
					if InfoFrame.Visible then
						InfoFrame.Position = UDim2.new(0, Mouse.X + 15, 0, Mouse.Y + 15)
					end
				end)
			end

			local Dragging = false

			local function Round(number, factor)
				return math.floor(number / factor + 0.5) * factor
			end

			local function UpdateSlider(input)
				local sizeX = math.clamp((input.Position.X - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X, 0, 1)
				SliderIndicator:TweenSize(UDim2.new(sizeX, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.2, true)

				local value = Round(((options.Range[2] - options.Range[1]) * sizeX) + options.Range[1], options.Increment)
				SliderValue.Text = tostring(value) .. options.Suffix
				options.CurrentValue = value
				options.Callback(value)
				
				if options.Flag and config.ConfigurationSaving.Enabled and config.ConfigurationSaving.FolderName and config.ConfigurationSaving.FileName then
					if not isfolder(config.ConfigurationSaving.FolderName) then 
						makefolder(config.ConfigurationSaving.FolderName)
					end
					
					local configData = {}
					if isfile(config.ConfigurationSaving.FolderName .. "/" .. config.ConfigurationSaving.FileName .. ".json") then
						local fileContent = readfile(config.ConfigurationSaving.FolderName .. "/" .. config.ConfigurationSaving.FileName .. ".json")
						configData = HttpService:JSONDecode(fileContent)
					end
					
					configData[options.Flag] = value
					
					writefile(config.ConfigurationSaving.FolderName .. "/" .. config.ConfigurationSaving.FileName .. ".json", HttpService:JSONEncode(configData))
				end
			end

			SliderFrame.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					Dragging = true
					UpdateSlider(input)
				end
			end)

			SliderFrame.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					Dragging = false
				end
			end)

			UserInputService.InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement and Dragging then
					UpdateSlider(input)
				end
			end)

			return Slider
		end

		function TabElements:CreateDropdown(options)
			options = options or {}
			options.Name = options.Name or "Dropdown"
			options.Options = options.Options or {}
			options.CurrentOption = options.CurrentOption or options.Options[1] or ""
			options.Flag = options.Flag or nil
			options.Callback = options.Callback or function() end
			options.Info = options.Info or ""

			local Dropdown = Instance.new("Frame")
			local DropdownTitle = Instance.new("TextLabel")
			local DropdownButton = Instance.new("TextButton")
			local DropdownButtonCorner = Instance.new("UICorner")
			local DropdownIcon = Instance.new("ImageLabel")
			local DropdownFrameContainer = Instance.new("Frame")
			local DropdownFrameContainerLayout = Instance.new("UIListLayout")
			local DropdownInfo = Instance.new("ImageButton")

			Dropdown.Name = "Dropdown"
			Dropdown.Parent = Tab
			Dropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			Dropdown.Size = UDim2.new(0, 475, 0, 35)

			DropdownTitle.Name = "DropdownTitle"
			DropdownTitle.Parent = Dropdown
			DropdownTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			DropdownTitle.BackgroundTransparency = 1.000
			DropdownTitle.Position = UDim2.new(0, 10, 0, 0)
			DropdownTitle.Size = UDim2.new(0, 350, 0, 35)
			DropdownTitle.Font = Enum.Font.Gotham
			DropdownTitle.Text = options.Name
			DropdownTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
			DropdownTitle.TextSize = 14.000
			DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left

			DropdownButton.Name = "DropdownButton"
			DropdownButton.Parent = Dropdown
			DropdownButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			DropdownButton.Position = UDim2.new(0, 370, 0, 5)
			DropdownButton.Size = UDim2.new(0, 100, 0, 25)
			DropdownButton.Font = Enum.Font.Gotham
			DropdownButton.Text = options.CurrentOption
			DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			DropdownButton.TextSize = 14.000
			DropdownButton.AutoButtonColor = false

			DropdownButtonCorner.CornerRadius = UDim.new(0, 4)
			DropdownButtonCorner.Name = "DropdownButtonCorner"
			DropdownButtonCorner.Parent = DropdownButton

			DropdownIcon.Name = "DropdownIcon"
			DropdownIcon.Parent = DropdownButton
			DropdownIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			DropdownIcon.BackgroundTransparency = 1.000
			DropdownIcon.Position = UDim2.new(0, 80, 0, 5)
			DropdownIcon.Size = UDim2.new(0, 15, 0, 15)
			DropdownIcon.Image = "rbxassetid://3926305904"
			DropdownIcon.ImageRectOffset = Vector2.new(524, 764)
			DropdownIcon.ImageRectSize = Vector2.new(36, 36)

			DropdownFrameContainer.Name = "DropdownFrameContainer"
			DropdownFrameContainer.Parent = Tab
			DropdownFrameContainer.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
			DropdownFrameContainer.BorderSizePixel = 0
			DropdownFrameContainer.Position = UDim2.new(0, 370, 0, 35)
			DropdownFrameContainer.Size = UDim2.new(0, 100, 0, 0)
			DropdownFrameContainer.ClipsDescendants = true
			DropdownFrameContainer.Visible = false
			DropdownFrameContainer.ZIndex = 5

			DropdownFrameContainerLayout.Name = "DropdownFrameContainerLayout"
			DropdownFrameContainerLayout.Parent = DropdownFrameContainer
			DropdownFrameContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder

			DropdownInfo.Name = "DropdownInfo"
			DropdownInfo.Parent = Dropdown
			DropdownInfo.BackgroundTransparency = 1.000
			DropdownInfo.LayoutOrder = 3
			DropdownInfo.Position = UDim2.new(0, 350, 0, 10)
			DropdownInfo.Size = UDim2.new(0, 15, 0, 15)
			DropdownInfo.ZIndex = 2
			DropdownInfo.Image = "rbxassetid://3926305904"
			DropdownInfo.ImageRectOffset = Vector2.new(4, 804)
			DropdownInfo.ImageRectSize = Vector2.new(36, 36)
			DropdownInfo.Visible = options.Info ~= ""

			if options.Info ~= "" then
				local InfoFrame = Instance.new("Frame")
				local InfoFrameCorner = Instance.new("UICorner")
				local InfoText = Instance.new("TextLabel")
				
				InfoFrame.Name = "InfoFrame"
				InfoFrame.Parent = ScreenGui
				InfoFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
				InfoFrame.Position = UDim2.new(0, Mouse.X + 15, 0, Mouse.Y + 15)
				InfoFrame.Size = UDim2.new(0, 200, 0, 0)
				InfoFrame.Visible = false
				InfoFrame.ZIndex = 100
				
				InfoFrameCorner.CornerRadius = UDim.new(0, 4)
				InfoFrameCorner.Name = "InfoFrameCorner"
				InfoFrameCorner.Parent = InfoFrame
				
				InfoText.Name = "InfoText"
				InfoText.Parent = InfoFrame
				InfoText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				InfoText.BackgroundTransparency = 1.000
				InfoText.Position = UDim2.new(0, 5, 0, 5)
				InfoText.Size = UDim2.new(0, 190, 0, 0)
				InfoText.Font = Enum.Font.Gotham
				InfoText.Text = options.Info
				InfoText.TextColor3 = Color3.fromRGB(255, 255, 255)
				InfoText.TextSize = 14.000
				InfoText.TextWrapped = true
				InfoText.ZIndex = 100
				InfoText.TextXAlignment = Enum.TextXAlignment.Left
				InfoText.TextYAlignment = Enum.TextYAlignment.Top
				
				DropdownInfo.MouseEnter:Connect(function()
					InfoText.Text = options.Info
					InfoFrame.Size = UDim2.new(0, 200, 0, InfoText.TextBounds.Y + 10)
					InfoText.Size = UDim2.new(0, 190, 0, InfoText.TextBounds.Y)
					InfoFrame.Position = UDim2.new(0, Mouse.X + 15, 0, Mouse.Y + 15)
					InfoFrame.Visible = true
				end)
				
				DropdownInfo.MouseLeave:Connect(function()
					InfoFrame.Visible = false
				end)
				
				RunService.RenderStepped:Connect(function()
					if InfoFrame.Visible then
						InfoFrame.Position = UDim2.new(0, Mouse.X + 15, 0, Mouse.Y + 15)
					end
				end)
			end

			local Dropped = false

			local function CreateOptions()
				for _, Option in pairs(options.Options) do
					local DropdownOption = Instance.new("TextButton")
					local DropdownOptionPadding = Instance.new("UIPadding")

					DropdownOption.Name = "DropdownOption"
					DropdownOption.Parent = DropdownFrameContainer
					DropdownOption.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
					DropdownOption.BackgroundTransparency = 1.000
					DropdownOption.Size = UDim2.new(0, 100, 0, 25)
					DropdownOption.Font = Enum.Font.Gotham
					DropdownOption.Text = Option
					DropdownOption.TextColor3 = Color3.fromRGB(255, 255, 255)
					DropdownOption.TextSize = 14.000
					DropdownOption.ZIndex = 6

					DropdownOptionPadding.Name = "DropdownOptionPadding"
					DropdownOptionPadding.Parent = DropdownOption
					DropdownOptionPadding.PaddingLeft = UDim.new(0, 5)

					DropdownOption.MouseButton1Click:Connect(function()
						DropdownButton.Text = Option
						options.CurrentOption = Option
						options.Callback(Option)
						Dropped = false
						DropdownFrameContainer.Visible = false
						DropdownFrameContainer:TweenSize(UDim2.new(0, 100, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.2, true)
						DropdownIcon.ImageRectOffset = Vector2.new(524, 764)
						
						if options.Flag and config.ConfigurationSaving.Enabled and config.ConfigurationSaving.FolderName and config.ConfigurationSaving.FileName then
							if not isfolder(config.ConfigurationSaving.FolderName) then 
								makefolder(config.ConfigurationSaving.FolderName)
							end
							
							local configData = {}
							if isfile(config.ConfigurationSaving.FolderName .. "/" .. config.ConfigurationSaving.FileName .. ".json") then
								local fileContent = readfile(config.ConfigurationSaving.FolderName .. "/" .. config.ConfigurationSaving.FileName .. ".json")
								configData = HttpService:JSONDecode(fileContent)
							end
							
							configData[options.Flag] = Option
							
							writefile(config.ConfigurationSaving.FolderName .. "/" .. config.ConfigurationSaving.FileName .. ".json", HttpService:JSONEncode(configData))
						end
					end)
				end
			end

			DropdownButton.MouseButton1Click:Connect(function()
				if Dropped then
					Dropped = false
					DropdownFrameContainer.Visible = false
					DropdownFrameContainer:TweenSize(UDim2.new(0, 100, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.2, true)
					DropdownIcon.ImageRectOffset = Vector2.new(524, 764)
				else
					Dropped = true
					DropdownFrameContainer.Visible = true
					DropdownFrameContainer:TweenSize(UDim2.new(0, 100, 0, #options.Options * 25), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.2, true)
					DropdownIcon.ImageRectOffset = Vector2.new(564, 764)
				end
			end)

			CreateOptions()

			return Dropdown
		end

		function TabElements:CreateColorPicker(options)
			options = options or {}
			options.Name = options.Name or "ColorPicker"
			options.Color = options.Color or Color3.fromRGB(255, 255, 255)
			options.Flag = options.Flag or nil
			options.Callback = options.Callback or function() end
			options.Info = options.Info or ""

			local ColorPicker = Instance.new("Frame")
			local ColorPickerTitle = Instance.new("TextLabel")
			local ColorPickerButton = Instance.new("TextButton")
			local ColorPickerButtonCorner = Instance.new("UICorner")
			local ColorPickerInfo = Instance.new("ImageButton")

			ColorPicker.Name = "ColorPicker"
			ColorPicker.Parent = Tab
			ColorPicker.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			ColorPicker.Size = UDim2.new(0, 475, 0, 35)

			ColorPickerTitle.Name = "ColorPickerTitle"
			ColorPickerTitle.Parent = ColorPicker
			ColorPickerTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ColorPickerTitle.BackgroundTransparency = 1.000
			ColorPickerTitle.Position = UDim2.new(0, 10, 0, 0)
			ColorPickerTitle.Size = UDim2.new(0, 350, 0, 35)
			ColorPickerTitle.Font = Enum.Font.Gotham
			ColorPickerTitle.Text = options.Name
			ColorPickerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
			ColorPickerTitle.TextSize = 14.000
			ColorPickerTitle.TextXAlignment = Enum.TextXAlignment.Left

			ColorPickerButton.Name = "ColorPickerButton"
			ColorPickerButton.Parent = ColorPicker
			ColorPickerButton.BackgroundColor3 = options.Color
			ColorPickerButton.Position = UDim2.new(0, 370, 0, 5)
			ColorPickerButton.Size = UDim2.new(0, 100, 0, 25)
			ColorPickerButton.Font = Enum.Font.Gotham
			ColorPickerButton.Text = ""
			ColorPickerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			ColorPickerButton.TextSize = 14.000
			ColorPickerButton.AutoButtonColor = false

			ColorPickerButtonCorner.CornerRadius = UDim.new(0, 4)
			ColorPickerButtonCorner.Name = "ColorPickerButtonCorner"
			ColorPickerButtonCorner.Parent = ColorPickerButton

			ColorPickerInfo.Name = "ColorPickerInfo"
			ColorPickerInfo.Parent = ColorPicker
			ColorPickerInfo.BackgroundTransparency = 1.000
			ColorPickerInfo.LayoutOrder = 3
			ColorPickerInfo.Position = UDim2.new(0, 350, 0, 10)
			ColorPickerInfo.Size = UDim2.new(0, 15, 0, 15)
			ColorPickerInfo.ZIndex = 2
			ColorPickerInfo.Image = "rbxassetid://3926305904"
			ColorPickerInfo.ImageRectOffset = Vector2.new(4, 804)
			ColorPickerInfo.ImageRectSize = Vector2.new(36, 36)
			ColorPickerInfo.Visible = options.Info ~= ""

			if options.Info ~= "" then
				local InfoFrame = Instance.new("Frame")
				local InfoFrameCorner = Instance.new("UICorner")
				local InfoText = Instance.new("TextLabel")
				
				InfoFrame.Name = "InfoFrame"
				InfoFrame.Parent = ScreenGui
				InfoFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
				InfoFrame.Position = UDim2.new(0, Mouse.X + 15, 0, Mouse.Y + 15)
				InfoFrame.Size = UDim2.new(0, 200, 0, 0)
				InfoFrame.Visible = false
				InfoFrame.ZIndex = 100
				
				InfoFrameCorner.CornerRadius = UDim.new(0, 4)
				InfoFrameCorner.Name = "InfoFrameCorner"
				InfoFrameCorner.Parent = InfoFrame
				
				InfoText.Name = "InfoText"
				InfoText.Parent = InfoFrame
				InfoText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				InfoText.BackgroundTransparency = 1.000
				InfoText.Position = UDim2.new(0, 5, 0, 5)
				InfoText.Size = UDim2.new(0, 190, 0, 0)
				InfoText.Font = Enum.Font.Gotham
				InfoText.Text = options.Info
				InfoText.TextColor3 = Color3.fromRGB(255, 255, 255)
				InfoText.TextSize = 14.000
				InfoText.TextWrapped = true
				InfoText.ZIndex = 100
				InfoText.TextXAlignment = Enum.TextXAlignment.Left
				InfoText.TextYAlignment = Enum.TextYAlignment.Top
				
				ColorPickerInfo.MouseEnter:Connect(function()
					InfoText.Text = options.Info
					InfoFrame.Size = UDim2.new(0, 200, 0, InfoText.TextBounds.Y + 10)
					InfoText.Size = UDim2.new(0, 190, 0, InfoText.TextBounds.Y)
					InfoFrame.Position = UDim2.new(0, Mouse.X + 15, 0, Mouse.Y + 15)
					InfoFrame.Visible = true
				end)
				
				ColorPickerInfo.MouseLeave:Connect(function()
					InfoFrame.Visible = false
				end)
				
				RunService.RenderStepped:Connect(function()
					if InfoFrame.Visible then
						InfoFrame.Position = UDim2.new(0, Mouse.X + 15, 0, Mouse.Y + 15)
					end
				end)
			end

			ColorPickerButton.MouseButton1Click:Connect(function()
				local ColorPickerFrame = Instance.new("Frame")
				local ColorPickerFrameCorner = Instance.new("UICorner")
				local Hue = Instance.new("ImageLabel")
				local HueCorner = Instance.new("UICorner")
				local HueGradient = Instance.new("UIGradient")
				local HueSelection = Instance.new("ImageLabel")
				local Saturation = Instance.new("ImageLabel")
				local SaturationCorner = Instance.new("UICorner")
				local SaturationGradient = Instance.new("UIGradient")
				local SaturationSelection = Instance.new("ImageLabel")
				local ColorPreview = Instance.new("Frame")
				local ColorPreviewCorner = Instance.new("UICorner")
				local RainbowToggle = Instance.new("TextButton")
				local RainbowToggleCorner = Instance.new("UICorner")
				local RainbowToggleTitle = Instance.new("TextLabel")
				local RainbowToggleFrame = Instance.new("Frame")
				local RainbowToggleFrameCorner = Instance.new("UICorner")
				local RainbowToggleButton = Instance.new("Frame")
				local RainbowToggleButtonCorner = Instance.new("UICorner")
				local ConfirmButton = Instance.new("TextButton")
				local ConfirmButtonCorner = Instance.new("UICorner")

				ColorPickerFrame.Name = "ColorPickerFrame"
				ColorPickerFrame.Parent = ScreenGui
				ColorPickerFrame.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
				ColorPickerFrame.Position = UDim2.new(0, Mouse.X + 15, 0, Mouse.Y + 15)
				ColorPickerFrame.Size = UDim2.new(0, 250, 0, 200)
				ColorPickerFrame.ZIndex = 10

				ColorPickerFrameCorner.CornerRadius = UDim.new(0, 4)
				ColorPickerFrameCorner.Name = "ColorPickerFrameCorner"
				ColorPickerFrameCorner.Parent = ColorPickerFrame

				Hue.Name = "Hue"
				Hue.Parent = ColorPickerFrame
				Hue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Hue.Position = UDim2.new(0, 10, 0, 10)
				Hue.Size = UDim2.new(0, 20, 0, 150)
				Hue.Image = "rbxassetid://4155801252"
				Hue.ZIndex = 10

				HueCorner.CornerRadius = UDim.new(0, 4)
				HueCorner.Name = "HueCorner"
				HueCorner.Parent = Hue

				HueGradient.Color = ColorSequence.new {
					ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
					ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
					ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
					ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
					ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
					ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
					ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0))
				}
				HueGradient.Rotation = 90
				HueGradient.Name = "HueGradient"
				HueGradient.Parent = Hue

				HueSelection.Name = "HueSelection"
				HueSelection.Parent = Hue
				HueSelection.AnchorPoint = Vector2.new(0.5, 0.5)
				HueSelection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				HueSelection.BackgroundTransparency = 1.000
				HueSelection.Position = UDim2.new(0.5, 0, 1 - select(1, Color3.toHSV(options.Color)), 0)
				HueSelection.Size = UDim2.new(0, 18, 0, 18)
				HueSelection.Image = "rbxassetid://4805639000"
				HueSelection.ZIndex = 11

				Saturation.Name = "Saturation"
				Saturation.Parent = ColorPickerFrame
				Saturation.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Saturation.Position = UDim2.new(0, 40, 0, 10)
				Saturation.Size = UDim2.new(0, 150, 0, 150)
				Saturation.Image = "rbxassetid://4155801252"
				Saturation.ZIndex = 10

				SaturationCorner.CornerRadius = UDim.new(0, 4)
				SaturationCorner.Name = "SaturationCorner"
				SaturationCorner.Parent = Saturation

				SaturationGradient.Color = ColorSequence.new {
					ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)),
					ColorSequenceKeypoint.new(1.00, Color3.fromHSV(select(1, Color3.toHSV(options.Color)), 1, 1))
				}
				SaturationGradient.Name = "SaturationGradient"
				SaturationGradient.Parent = Saturation

				SaturationSelection.Name = "SaturationSelection"
				SaturationSelection.Parent = Saturation
				SaturationSelection.AnchorPoint = Vector2.new(0.5, 0.5)
				SaturationSelection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SaturationSelection.BackgroundTransparency = 1.000
				SaturationSelection.Position = UDim2.new(select(2, Color3.toHSV(options.Color)), 0, 1 - select(3, Color3.toHSV(options.Color)), 0)
				SaturationSelection.Size = UDim2.new(0, 18, 0, 18)
				SaturationSelection.Image = "rbxassetid://4805639000"
				SaturationSelection.ZIndex = 11

				ColorPreview.Name = "ColorPreview"
				ColorPreview.Parent = ColorPickerFrame
				ColorPreview.BackgroundColor3 = options.Color
				ColorPreview.Position = UDim2.new(0, 200, 0, 10)
				ColorPreview.Size = UDim2.new(0, 40, 0, 25)
				ColorPreview.ZIndex = 10

				ColorPreviewCorner.CornerRadius = UDim.new(0, 4)
				ColorPreviewCorner.Name = "ColorPreviewCorner"
				ColorPreviewCorner.Parent = ColorPreview

				RainbowToggle.Name = "RainbowToggle"
				RainbowToggle.Parent = ColorPickerFrame
				RainbowToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
				RainbowToggle.Position = UDim2.new(0, 200, 0, 45)
				RainbowToggle.Size = UDim2.new(0, 40, 0, 25)
				RainbowToggle.Text = ""
				RainbowToggle.ZIndex = 10

				RainbowToggleCorner.CornerRadius = UDim.new(0, 4)
				RainbowToggleCorner.Name = "RainbowToggleCorner"
				RainbowToggleCorner.Parent = RainbowToggle

				RainbowToggleTitle.Name = "RainbowToggleTitle"
				RainbowToggleTitle.Parent = RainbowToggle
				RainbowToggleTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				RainbowToggleTitle.BackgroundTransparency = 1.000
				RainbowToggleTitle.Size = UDim2.new(0, 40, 0, 25)
				RainbowToggleTitle.Font = Enum.Font.Gotham
				RainbowToggleTitle.Text = "Rainbow"
				RainbowToggleTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
				RainbowToggleTitle.TextSize = 10.000
				RainbowToggleTitle.ZIndex = 10

				RainbowToggleFrame.Name = "RainbowToggleFrame"
				RainbowToggleFrame.Parent = ColorPickerFrame
				RainbowToggleFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
				RainbowToggleFrame.Position = UDim2.new(0, 200, 0, 80)
				RainbowToggleFrame.Size = UDim2.new(0, 40, 0, 20)
				RainbowToggleFrame.ZIndex = 10

				RainbowToggleFrameCorner.CornerRadius = UDim.new(1, 0)
				RainbowToggleFrameCorner.Name = "RainbowToggleFrameCorner"
				RainbowToggleFrameCorner.Parent = RainbowToggleFrame

				RainbowToggleButton.Name = "RainbowToggleButton"
				RainbowToggleButton.Parent = RainbowToggleFrame
				RainbowToggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				RainbowToggleButton.Position = UDim2.new(0, 2, 0, 2)
				RainbowToggleButton.Size = UDim2.new(0, 16, 0, 16)
				RainbowToggleButton.ZIndex = 10

				RainbowToggleButtonCorner.CornerRadius = UDim.new(1, 0)
				RainbowToggleButtonCorner.Name = "RainbowToggleButtonCorner"
				RainbowToggleButtonCorner.Parent = RainbowToggleButton

				ConfirmButton.Name = "ConfirmButton"
				ConfirmButton.Parent = ColorPickerFrame
				ConfirmButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
				ConfirmButton.Position = UDim2.new(0, 200, 0, 110)
				ConfirmButton.Size = UDim2.new(0, 40, 0, 25)
				ConfirmButton.Font = Enum.Font.Gotham
				ConfirmButton.Text = "Confirm"
				ConfirmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
				ConfirmButton.TextSize = 10.000
				ConfirmButton.ZIndex = 10

				ConfirmButtonCorner.CornerRadius = UDim.new(0, 4)
				ConfirmButtonCorner.Name = "ConfirmButtonCorner"
				ConfirmButtonCorner.Parent = ConfirmButton

				local RainbowToggled = false
				local RainbowConnection = nil

				local function UpdateColorPicker()
					local H, S, V = Color3.toHSV(options.Color)
					options.Color = Color3.fromHSV(H, S, V)
					HueSelection.Position = UDim2.new(0.5, 0, 1 - H, 0)
					SaturationSelection.Position = UDim2.new(S, 0, 1 - V, 0)
					SaturationGradient.Color = ColorSequence.new {
						ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)),
						ColorSequenceKeypoint.new(1.00, Color3.fromHSV(H, 1, 1))
					}
					ColorPreview.BackgroundColor3 = options.Color
					ColorPickerButton.BackgroundColor3 = options.Color
					options.Callback(options.Color)
					
					if options.Flag and config.ConfigurationSaving.Enabled and config.ConfigurationSaving.FolderName and config.ConfigurationSaving.FileName then
						if not isfolder(config.ConfigurationSaving.FolderName) then 
							makefolder(config.ConfigurationSaving.FolderName)
						end
						
						local configData = {}
						if isfile(config.ConfigurationSaving.FolderName .. "/" .. config.ConfigurationSaving.FileName .. ".json") then
							local fileContent = readfile(config.ConfigurationSaving.FolderName .. "/" .. config.ConfigurationSaving.FileName .. ".json")
							configData = HttpService:JSONDecode(fileContent)
						end
						
						configData[options.Flag] = {
							H = H,
							S = S,
							V = V
						}
						
						writefile(config.ConfigurationSaving.FolderName .. "/" .. config.ConfigurationSaving.FileName .. ".json", HttpService:JSONEncode(configData))
					end
				end

				RainbowToggleFrame.InputBegan:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 then
						RainbowToggled = not RainbowToggled
						if RainbowToggled then
							RainbowToggleButton:TweenPosition(UDim2.new(0, 22, 0, 2), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.2, true)
							RainbowToggleFrame.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
						else
							RainbowToggleButton:TweenPosition(UDim2.new(0, 2, 0, 2), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.2, true)
							RainbowToggleFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
						end
						
						if RainbowConnection then
							RainbowConnection:Disconnect()
							RainbowConnection = nil
						end
						
						if RainbowToggled then
							RainbowConnection = RunService.Heartbeat:Connect(function()
								options.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
								UpdateColorPicker()
							end)
						end
					end
				end)

				Saturation.InputBegan:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 then
						if RainbowConnection then
							RainbowConnection:Disconnect()
							RainbowConnection = nil
							RainbowToggled = false
							RainbowToggleButton:TweenPosition(UDim2.new(0, 2, 0, 2), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.2, true)
							RainbowToggleFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
						end
						
						local MouseX, MouseY = UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y
						local RelativeMouseX = math.clamp((MouseX - Saturation.AbsolutePosition.X) / Saturation.AbsoluteSize.X, 0, 1)
						local RelativeMouseY = math.clamp((MouseY - Saturation.AbsolutePosition.Y) / Saturation.AbsoluteSize.Y, 0, 1)
						
						SaturationSelection.Position = UDim2.new(RelativeMouseX, 0, RelativeMouseY, 0)
						options.Color = Color3.fromHSV(select(1, Color3.toHSV(options.Color)), RelativeMouseX, 1 - RelativeMouseY)
						UpdateColorPicker()
						
						local SaturationDrag = nil
						SaturationDrag = UserInputService.InputChanged:Connect(function(Input)
							if Input.UserInputType == Enum.UserInputType.MouseMovement then
								local MouseX, MouseY = UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y
								local RelativeMouseX = math.clamp((MouseX - Saturation.AbsolutePosition.X) / Saturation.AbsoluteSize.X, 0, 1)
								local RelativeMouseY = math.clamp((MouseY - Saturation.AbsolutePosition.Y) / Saturation.AbsoluteSize.Y, 0, 1)
								
								SaturationSelection.Position = UDim2.new(RelativeMouseX, 0, RelativeMouseY, 0)
								options.Color = Color3.fromHSV(select(1, Color3.toHSV(options.Color)), RelativeMouseX, 1 - RelativeMouseY)
								UpdateColorPicker()
							end
						end)
						
						UserInputService.InputEnded:Connect(function(Input)
							if Input.UserInputType == Enum.UserInputType.MouseButton1 then
								if SaturationDrag then
									SaturationDrag:Disconnect()
									SaturationDrag = nil
								end
							end
						end)
					end
				end)

				Hue.InputBegan:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 then
						if RainbowConnection then
							RainbowConnection:Disconnect()
							RainbowConnection = nil
							RainbowToggled = false
							RainbowToggleButton:TweenPosition(UDim2.new(0, 2, 0, 2), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.2, true)
							RainbowToggleFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
						end
						
						local MouseY = UserInputService:GetMouseLocation().Y
						local RelativeMouseY = math.clamp((MouseY - Hue.AbsolutePosition.Y) / Hue.AbsoluteSize.Y, 0, 1)
						
						HueSelection.Position = UDim2.new(0.5, 0, RelativeMouseY, 0)
						options.Color = Color3.fromHSV(1 - RelativeMouseY, select(2, Color3.toHSV(options.Color)), select(3, Color3.toHSV(options.Color)))
						SaturationGradient.Color = ColorSequence.new {
							ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)),
							ColorSequenceKeypoint.new(1.00, Color3.fromHSV(1 - RelativeMouseY, 1, 1))
						}
						UpdateColorPicker()
						
						local HueDrag = nil
						HueDrag = UserInputService.InputChanged:Connect(function(Input)
							if Input.UserInputType == Enum.UserInputType.MouseMovement then
								local MouseY = UserInputService:GetMouseLocation().Y
								local RelativeMouseY = math.clamp((MouseY - Hue.AbsolutePosition.Y) / Hue.AbsoluteSize.Y, 0, 1)
								
								HueSelection.Position = UDim2.new(0.5, 0, RelativeMouseY, 0)
								options.Color = Color3.fromHSV(1 - RelativeMouseY, select(2, Color3.toHSV(options.Color)), select(3, Color3.toHSV(options.Color)))
								SaturationGradient.Color = ColorSequence.new {
									ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)),
									ColorSequenceKeypoint.new(1.00, Color3.fromHSV(1 - RelativeMouseY, 1, 1))
								}
								UpdateColorPicker()
							end
						end)
						
						UserInputService.InputEnded:Connect(function(Input)
							if Input.UserInputType == Enum.UserInputType.MouseButton1 then
								if HueDrag then
									HueDrag:Disconnect()
									HueDrag = nil
								end
							end
						end)
					end
				end)

				ConfirmButton.MouseButton1Click:Connect(function()
					if RainbowConnection then
						RainbowConnection:Disconnect()
						RainbowConnection = nil
					end
					ColorPickerFrame:Destroy()
				end)
			end)

			return ColorPicker
		end

		function TabElements:CreateKeybind(options)
			options = options or {}
			options.Name = options.Name or "Keybind"
			options.CurrentKeybind = options.CurrentKeybind or "None"
			options.HoldToInteract = options.HoldToInteract or false
			options.Flag = options.Flag or nil
			options.Callback = options.Callback or function() end
			options.Info = options.Info or ""

			local Keybind = Instance.new("Frame")
			local KeybindTitle = Instance.new("TextLabel")
			local KeybindButton = Instance.new("TextButton")
			local KeybindButtonCorner = Instance.new("UICorner")
			local KeybindInfo = Instance.new("ImageButton")

			Keybind.Name = "Keybind"
			Keybind.Parent = Tab
			Keybind.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			Keybind.Size = UDim2.new(0, 475, 0, 35)

			KeybindTitle.Name = "KeybindTitle"
			KeybindTitle.Parent = Keybind
			KeybindTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			KeybindTitle.BackgroundTransparency = 1.000
			KeybindTitle.Position = UDim2.new(0, 10, 0, 0)
			KeybindTitle.Size = UDim2.new(0, 350, 0, 35)
			KeybindTitle.Font = Enum.Font.Gotham
			KeybindTitle.Text = options.Name
			KeybindTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
			KeybindTitle.TextSize = 14.000
			KeybindTitle.TextXAlignment = Enum.TextXAlignment.Left

			KeybindButton.Name = "KeybindButton"
			KeybindButton.Parent = Keybind
			KeybindButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			KeybindButton.Position = UDim2.new(0, 370, 0, 5)
			KeybindButton.Size = UDim2.new(0, 100, 0, 25)
			KeybindButton.Font = Enum.Font.Gotham
			KeybindButton.Text = options.CurrentKeybind
			KeybindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			KeybindButton.TextSize = 14.000
			KeybindButton.AutoButtonColor = false

			KeybindButtonCorner.CornerRadius = UDim.new(0, 4)
			KeybindButtonCorner.Name = "KeybindButtonCorner"
			KeybindButtonCorner.Parent = KeybindButton

			KeybindInfo.Name = "KeybindInfo"
			KeybindInfo.Parent = Keybind
			KeybindInfo.BackgroundTransparency = 1.000
			KeybindInfo.LayoutOrder = 3
			KeybindInfo.Position = UDim2.new(0, 350, 0, 10)
			KeybindInfo.Size = UDim2.new(0, 15, 0, 15)
			KeybindInfo.ZIndex = 2
			KeybindInfo.Image = "rbxassetid://3926305904"
			KeybindInfo.ImageRectOffset = Vector2.new(4, 804)
			KeybindInfo.ImageRectSize = Vector2.new(36, 36)
			KeybindInfo.Visible = options.Info ~= ""

			if options.Info ~= "" then
				local InfoFrame = Instance.new("Frame")
				local InfoFrameCorner = Instance.new("UICorner")
				local InfoText = Instance.new("TextLabel")
				
				InfoFrame.Name = "InfoFrame"
				InfoFrame.Parent = ScreenGui
				InfoFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
				InfoFrame.Position = UDim2.new(0, Mouse.X + 15, 0, Mouse.Y + 15)
				InfoFrame.Size = UDim2.new(0, 200, 0, 0)
				InfoFrame.Visible = false
				InfoFrame.ZIndex = 100
				
				InfoFrameCorner.CornerRadius = UDim.new(0, 4)
				InfoFrameCorner.Name = "InfoFrameCorner"
				InfoFrameCorner.Parent = InfoFrame
				
				InfoText.Name = "InfoText"
				InfoText.Parent = InfoFrame
				InfoText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				InfoText.BackgroundTransparency = 1.000
				InfoText.Position = UDim2.new(0, 5, 0, 5)
				InfoText.Size = UDim2.new(0, 190, 0, 0)
				InfoText.Font = Enum.Font.Gotham
				InfoText.Text = options.Info
				InfoText.TextColor3 = Color3.fromRGB(255, 255, 255)
				InfoText.TextSize = 14.000
				InfoText.TextWrapped = true
				InfoText.ZIndex = 100
				InfoText.TextXAlignment = Enum.TextXAlignment.Left
				InfoText.TextYAlignment = Enum.TextYAlignment.Top
				
				KeybindInfo.MouseEnter:Connect(function()
					InfoText.Text = options.Info
					InfoFrame.Size = UDim2.new(0, 200, 0, InfoText.TextBounds.Y + 10)
					InfoText.Size = UDim2.new(0, 190, 0, InfoText.TextBounds.Y)
					InfoFrame.Position = UDim2.new(0, Mouse.X + 15, 0, Mouse.Y + 15)
					InfoFrame.Visible = true
				end)
				
				KeybindInfo.MouseLeave:Connect(function()
					InfoFrame.Visible = false
				end)
				
				RunService.RenderStepped:Connect(function()
					if InfoFrame.Visible then
						InfoFrame.Position = UDim2.new(0, Mouse.X + 15, 0, Mouse.Y + 15)
					end
				end)
			end

			local WaitingForBind = false

			KeybindButton.MouseButton1Click:Connect(function()
				KeybindButton.Text = "..."
				WaitingForBind = true
			end)

			UserInputService.InputBegan:Connect(function(Input)
				if WaitingForBind then
					if Input.UserInputType == Enum.UserInputType.Keyboard then
						KeybindButton.Text = Input.KeyCode.Name
						options.CurrentKeybind = Input.KeyCode.Name
						WaitingForBind = false
						
						if options.Flag and config.ConfigurationSaving.Enabled and config.ConfigurationSaving.FolderName and config.ConfigurationSaving.FileName then
							if not isfolder(config.ConfigurationSaving.FolderName) then 
								makefolder(config.ConfigurationSaving.FolderName)
							end
							
							local configData = {}
							if isfile(config.ConfigurationSaving.FolderName .. "/" .. config.ConfigurationSaving.FileName .. ".json") then
								local fileContent = readfile(config.ConfigurationSaving.FolderName .. "/" .. config.ConfigurationSaving.FileName .. ".json")
								configData = HttpService:JSONDecode(fileContent)
							end
							
							configData[options.Flag] = options.CurrentKeybind
							
							writefile(config.ConfigurationSaving.FolderName .. "/" .. config.ConfigurationSaving.FileName .. ".json", HttpService:JSONEncode(configData))
						end
					end
				else
					if Input.KeyCode.Name == options.CurrentKeybind then
						if options.HoldToInteract then
							options.Callback(true)
							
							local Connection = nil
							Connection = Input.Changed:Connect(function(property)
								if property == "UserInputState" and Input.UserInputState == Enum.UserInputState.End then
									options.Callback(false)
									Connection:Disconnect()
								end
							end)
						else
							options.Callback()
						end
					end
				end
			end)

			return Keybind
		end
		
		function TabElements:CreateParagraph(options)
			options = options or {}
			options.Title = options.Title or "Title"
			options.Content = options.Content or "Content"

			local Paragraph = Instance.new("Frame")
			local ParagraphTitle = Instance.new("TextLabel")
			local ParagraphContent = Instance.new("TextLabel")

			Paragraph.Name = "Paragraph"
			Paragraph.Parent = Tab
			Paragraph.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			Paragraph.Size = UDim2.new(0, 475, 0, 50) -- Initially set, will adjust based on content

			ParagraphTitle.Name = "ParagraphTitle"
			ParagraphTitle.Parent = Paragraph
			ParagraphTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ParagraphTitle.BackgroundTransparency = 1.000
			ParagraphTitle.Position = UDim2.new(0, 10, 0, 5)
			ParagraphTitle.Size = UDim2.new(0, 455, 0, 20)
			ParagraphTitle.Font = Enum.Font.GothamBold
			ParagraphTitle.Text = options.Title
			ParagraphTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
			ParagraphTitle.TextSize = 14.000
			ParagraphTitle.TextXAlignment = Enum.TextXAlignment.Left

			ParagraphContent.Name = "ParagraphContent"
			ParagraphContent.Parent = Paragraph
			ParagraphContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ParagraphContent.BackgroundTransparency = 1.000
			ParagraphContent.Position = UDim2.new(0, 10, 0, 25)
			ParagraphContent.Size = UDim2.new(0, 455, 0, 20)
			ParagraphContent.Font = Enum.Font.Gotham
			ParagraphContent.Text = options.Content
			ParagraphContent.TextColor3 = Color3.fromRGB(200, 200, 200)
			ParagraphContent.TextSize = 14.000
			ParagraphContent.TextWrapped = true
			ParagraphContent.TextXAlignment = Enum.TextXAlignment.Left
			ParagraphContent.TextYAlignment = Enum.TextYAlignment.Top

			-- Adjust the size based on content
			ParagraphContent.Size = UDim2.new(0, 455, 0, math.max(20, ParagraphContent.TextBounds.Y))
			Paragraph.Size = UDim2.new(0, 475, 0, 30 + ParagraphContent.TextBounds.Y)

			return Paragraph
		end

		return TabElements
	end

	function Window:Notify(options)
		options = options or {}
		options.Title = options.Title or "Notification"
		options.Content = options.Content or "This is a notification"
		options.Duration = options.Duration or 5
		options.Image = options.Image or nil

		local Notification = Instance.new("Frame")
		local NotificationCorner = Instance.new("UICorner")
		local Title = Instance.new("TextLabel")
		local Content = Instance.new("TextLabel")
		local Image = Instance.new("ImageLabel")

		Notification.Name = "Notification"
		Notification.Parent = ScreenGui
		Notification.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
		Notification.Position = UDim2.new(1, 300, 0.5, 0)
		Notification.Size = UDim2.new(0, 300, 0, 100)
		Notification.AnchorPoint = Vector2.new(0.5, 0.5)
		Notification.ZIndex = 100

		NotificationCorner.CornerRadius = UDim.new(0, 4)
		NotificationCorner.Name = "NotificationCorner"
		NotificationCorner.Parent = Notification

		Title.Name = "Title"
		Title.Parent = Notification
		Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Title.BackgroundTransparency = 1.000
		Title.Position = options.Image and UDim2.new(0, 60, 0, 10) or UDim2.new(0, 10, 0, 10)
		Title.Size = UDim2.new(0, 230, 0, 25)
		Title.Font = Enum.Font.GothamBold
		Title.Text = options.Title
		Title.TextColor3 = Color3.fromRGB(255, 255, 255)
		Title.TextSize = 16.000
		Title.TextXAlignment = Enum.TextXAlignment.Left
		Title.ZIndex = 100

		Content.Name = "Content"
		Content.Parent = Notification
		Content.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Content.BackgroundTransparency = 1.000
		Content.Position = options.Image and UDim2.new(0, 60, 0, 35) or UDim2.new(0, 10, 0, 35)
		Content.Size = UDim2.new(0, 230, 0, 55)
		Content.Font = Enum.Font.Gotham
		Content.Text = options.Content
		Content.TextColor3 = Color3.fromRGB(200, 200, 200)
		Content.TextSize = 14.000
		Content.TextWrapped = true
		Content.TextXAlignment = Enum.TextXAlignment.Left
		Content.TextYAlignment = Enum.TextYAlignment.Top
		Content.ZIndex = 100

		if options.Image then
			Image.Name = "Image"
			Image.Parent = Notification
			Image.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Image.BackgroundTransparency = 1.000
			Image.Position = UDim2.new(0, 10, 0, 20)
			Image.Size = UDim2.new(0, 40, 0, 40)
			Image.Image = "rbxassetid://" .. tostring(options.Image)
			Image.ZIndex = 100
		end

		Notification:TweenPosition(UDim2.new(1, -20, 0.5, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.5, true, function()
			wait(options.Duration)
			Notification:TweenPosition(UDim2.new(1, 300, 0.5, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.5, true, function()
				Notification:Destroy()
			end)
		end)
	end

	return Window
end

return Frosty
