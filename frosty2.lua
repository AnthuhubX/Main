
-- Frosty UI Library with fixed minimize functionality
local Frosty = {}

-- Library Configuration
Frosty.Settings = {
    Theme = "Dark",
    ToggleKey = Enum.KeyCode.RightControl,
    MinimizeKey = Enum.KeyCode.RightAlt,
    SaveConfig = false
}

-- Local Variables
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Interface Management
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = HttpService:GenerateGUID(false)
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.ResetOnSpawn = false

-- Ensure proper parent based on execution context
if RunService:IsStudio() then
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
else
    if syn then
        syn.protect_gui(ScreenGui)
    end
    ScreenGui.Parent = CoreGui
end

-- UI Elements
local Windows = {}
local MinimizedWindows = {}
local Notifications = {}
local isMinimized = false  -- Track minimize state

-- Utility Functions
local function AddRippleEffect(Button, RippleColor)
    Button.ClipsDescendants = true
    
    local function CreateRipple()
        local Ripple = Instance.new("Frame")
        Ripple.Name = "Ripple"
        Ripple.Parent = Button
        Ripple.BackgroundColor3 = RippleColor or Color3.fromRGB(255, 255, 255)
        Ripple.BackgroundTransparency = 0.8
        Ripple.BorderSizePixel = 0
        Ripple.ZIndex = Button.ZIndex + 1
        Ripple.AnchorPoint = Vector2.new(0.5, 0.5)
        Ripple.Size = UDim2.new(0, 0, 0, 0)
        Ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
        
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(1, 0)
        Corner.Parent = Ripple
        
        local TargetSize = UDim2.new(2, 0, 2, 0)
        local RippleTween = TweenService:Create(
            Ripple, 
            TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), 
            {Size = TargetSize, BackgroundTransparency = 1}
        )
        RippleTween:Play()
        
        RippleTween.Completed:Connect(function()
            Ripple:Destroy()
        end)
    end
    
    Button.MouseButton1Down:Connect(CreateRipple)
end

local function DraggableFrame(frame, handle)
    local dragging, dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
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
            update(input)
        end
    end)
end

-- Notification System
function Frosty:Notify(options)
    options = options or {}
    options.Title = options.Title or "Notification"
    options.Content = options.Content or "Content"
    options.Duration = options.Duration or 5
    options.Image = options.Image or nil
    
    local Notification = Instance.new("Frame")
    Notification.Name = "Notification"
    Notification.Parent = ScreenGui
    Notification.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Notification.BorderSizePixel = 0
    Notification.Position = UDim2.new(1, 300, 0.5, 0)
    Notification.Size = UDim2.new(0, 300, 0, 100)
    Notification.AnchorPoint = Vector2.new(0.5, 0.5)
    Notification.ZIndex = 100
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 5)
    Corner.Parent = Notification
    
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Parent = Notification
    Header.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Header.BorderSizePixel = 0
    Header.Size = UDim2.new(1, 0, 0, 30)
    Header.ZIndex = 101
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 5)
    HeaderCorner.Parent = Header
    
    local HeaderFix = Instance.new("Frame")
    HeaderFix.Name = "HeaderFix"
    HeaderFix.Parent = Header
    HeaderFix.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    HeaderFix.BorderSizePixel = 0
    HeaderFix.Position = UDim2.new(0, 0, 0.5, 0)
    HeaderFix.Size = UDim2.new(1, 0, 0.5, 0)
    HeaderFix.ZIndex = 101
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = Header
    Title.BackgroundTransparency = 1
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.Font = Enum.Font.SourceSansBold
    Title.Text = options.Title
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16
    Title.ZIndex = 102
    
    local Close = Instance.new("TextButton")
    Close.Name = "Close"
    Close.Parent = Header
    Close.BackgroundTransparency = 1
    Close.Position = UDim2.new(1, -25, 0, 0)
    Close.Size = UDim2.new(0, 25, 1, 0)
    Close.Font = Enum.Font.SourceSansBold
    Close.Text = "×"
    Close.TextColor3 = Color3.fromRGB(255, 255, 255)
    Close.TextSize = 20
    Close.ZIndex = 102
    
    local Body = Instance.new("Frame")
    Body.Name = "Body"
    Body.Parent = Notification
    Body.BackgroundTransparency = 1
    Body.Position = UDim2.new(0, 0, 0, 30)
    Body.Size = UDim2.new(1, 0, 0, 70)
    Body.ZIndex = 101
    
    local Content = Instance.new("TextLabel")
    Content.Name = "Content"
    Content.Parent = Body
    Content.BackgroundTransparency = 1
    Content.Size = UDim2.new(1, 0, 1, 0)
    Content.Font = Enum.Font.SourceSans
    Content.Text = options.Content
    Content.TextColor3 = Color3.fromRGB(255, 255, 255)
    Content.TextSize = 14
    Content.TextWrapped = true
    Content.TextXAlignment = Enum.TextXAlignment.Left
    Content.TextYAlignment = Enum.TextYAlignment.Top
    Content.ZIndex = 102
    Content.Padding = UDim.new(0, 10)
    
    local UIPadding = Instance.new("UIPadding")
    UIPadding.Parent = Content
    UIPadding.PaddingLeft = UDim.new(0, 10)
    UIPadding.PaddingRight = UDim.new(0, 10)
    UIPadding.PaddingTop = UDim.new(0, 10)
    UIPadding.PaddingBottom = UDim.new(0, 10)
    
    if options.Image then
        Content.Position = UDim2.new(0, 70, 0, 0)
        Content.Size = UDim2.new(1, -70, 1, 0)
        
        local Image = Instance.new("ImageLabel")
        Image.Name = "Image"
        Image.Parent = Body
        Image.BackgroundTransparency = 1
        Image.Position = UDim2.new(0, 10, 0, 10)
        Image.Size = UDim2.new(0, 50, 0, 50)
        Image.Image = options.Image
        Image.ZIndex = 102
    end
    
    -- Animation
    local entryTween = TweenService:Create(
        Notification, 
        TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), 
        {Position = UDim2.new(1, -20, 0.5, 0)}
    )
    entryTween:Play()
    
    -- Position management for multiple notifications
    table.insert(Notifications, Notification)
    
    -- Update positions of all notifications
    local function UpdatePositions()
        local yOffset = 20
        for i, notification in ipairs(Notifications) do
            local targetPosition = UDim2.new(1, -20, 0, yOffset)
            TweenService:Create(
                notification, 
                TweenInfo.new(0.3, Enum.EasingStyle.Quint), 
                {Position = targetPosition}
            ):Play()
            yOffset = yOffset + notification.AbsoluteSize.Y + 10
        end
    end
    
    UpdatePositions()
    
    -- Handle closing
    Close.MouseButton1Click:Connect(function()
        local index = table.find(Notifications, Notification)
        if index then
            table.remove(Notifications, index)
        end
        
        local exitTween = TweenService:Create(
            Notification, 
            TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), 
            {Position = UDim2.new(1, 300, Notification.Position.Y.Scale, Notification.Position.Y.Offset)}
        )
        exitTween:Play()
        
        exitTween.Completed:Connect(function()
            Notification:Destroy()
            UpdatePositions()
        end)
    end)
    
    -- Auto close after duration
    task.spawn(function()
        task.wait(options.Duration)
        if Notification and Notification.Parent then
            local index = table.find(Notifications, Notification)
            if index then
                table.remove(Notifications, index)
            end
            
            local exitTween = TweenService:Create(
                Notification, 
                TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), 
                {Position = UDim2.new(1, 300, Notification.Position.Y.Scale, Notification.Position.Y.Offset)}
            )
            exitTween:Play()
            
            exitTween.Completed:Connect(function()
                Notification:Destroy()
                UpdatePositions()
            end)
        end
    end)
    
    AddRippleEffect(Close, Color3.fromRGB(255, 255, 255))
end

-- Window Creation
function Frosty:CreateWindow(config)
    config = config or {}
    config.Name = config.Name or "Frosty"
    config.LoadingTitle = config.LoadingTitle or "Frosty Loading"
    config.LoadingSubtitle = config.LoadingSubtitle or "by The Frosty Team"
    config.ConfigurationSaving = config.ConfigurationSaving or {
        Enabled = false,
        FolderName = nil,
        FileName = nil
    }
    config.Discord = config.Discord or {
        Enabled = false,
        Invite = nil,
        RememberJoins = true
    }
    config.KeybindNote = config.KeybindNote or "RightControl"
    
    -- Create main Window container
    local Window = Instance.new("Frame")
    Window.Name = "Window"
    Window.Parent = ScreenGui
    Window.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Window.BorderSizePixel = 0
    Window.Position = UDim2.new(0.5, 0, 0.5, 0)
    Window.Size = UDim2.new(0, 700, 0, 500)
    Window.AnchorPoint = Vector2.new(0.5, 0.5)
    Window.Active = true
    Window.Visible = false
    
    local WindowCorner = Instance.new("UICorner")
    WindowCorner.CornerRadius = UDim.new(0, 5)
    WindowCorner.Parent = Window
    
    -- Create Window Shadow
    local WindowShadow = Instance.new("ImageLabel")
    WindowShadow.Name = "WindowShadow"
    WindowShadow.Parent = Window
    WindowShadow.BackgroundTransparency = 1
    WindowShadow.Position = UDim2.new(0, -15, 0, -15)
    WindowShadow.Size = UDim2.new(1, 30, 1, 30)
    WindowShadow.Image = "rbxassetid://5554236805"
    WindowShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    WindowShadow.ScaleType = Enum.ScaleType.Slice
    WindowShadow.SliceCenter = Rect.new(23, 23, 277, 277)
    WindowShadow.ImageTransparency = 0.5
    WindowShadow.ZIndex = -1
    
    -- Create Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Parent = Window
    TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TitleBar.BorderSizePixel = 0
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    
    local TitleBarCorner = Instance.new("UICorner")
    TitleBarCorner.CornerRadius = UDim.new(0, 5)
    TitleBarCorner.Parent = TitleBar
    
    local TitleBarFix = Instance.new("Frame")
    TitleBarFix.Name = "TitleBarFix"
    TitleBarFix.Parent = TitleBar
    TitleBarFix.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TitleBarFix.BorderSizePixel = 0
    TitleBarFix.Position = UDim2.new(0, 0, 0.5, 0)
    TitleBarFix.Size = UDim2.new(1, 0, 0.5, 0)
    
    local WindowTitle = Instance.new("TextLabel")
    WindowTitle.Name = "WindowTitle"
    WindowTitle.Parent = TitleBar
    WindowTitle.BackgroundTransparency = 1
    WindowTitle.Size = UDim2.new(1, -60, 1, 0)
    WindowTitle.Font = Enum.Font.SourceSansBold
    WindowTitle.Text = config.Name
    WindowTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    WindowTitle.TextSize = 16
    WindowTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local UIPadding = Instance.new("UIPadding")
    UIPadding.Parent = WindowTitle
    UIPadding.PaddingLeft = UDim.new(0, 10)
    
    -- Create window control buttons
    local ControlButtons = Instance.new("Frame")
    ControlButtons.Name = "ControlButtons"
    ControlButtons.Parent = TitleBar
    ControlButtons.BackgroundTransparency = 1
    ControlButtons.Position = UDim2.new(1, -60, 0, 0)
    ControlButtons.Size = UDim2.new(0, 60, 1, 0)
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = ControlButtons
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -20, 0, 0)
    CloseButton.Size = UDim2.new(0, 20, 1, 0)
    CloseButton.Font = Enum.Font.SourceSansBold
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 20
    
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Parent = ControlButtons
    MinimizeButton.BackgroundTransparency = 1
    MinimizeButton.Position = UDim2.new(1, -40, 0, 0)
    MinimizeButton.Size = UDim2.new(0, 20, 1, 0)
    MinimizeButton.Font = Enum.Font.SourceSansBold
    MinimizeButton.Text = "-"
    MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.TextSize = 20
    
    -- Main Content
    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Parent = Window
    Content.BackgroundTransparency = 1
    Content.Position = UDim2.new(0, 0, 0, 30)
    Content.Size = UDim2.new(1, 0, 1, -30)
    
    -- Tab System
    local TabHolder = Instance.new("Frame")
    TabHolder.Name = "TabHolder"
    TabHolder.Parent = Content
    TabHolder.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TabHolder.BorderSizePixel = 0
    TabHolder.Position = UDim2.new(0, 0, 0, 0)
    TabHolder.Size = UDim2.new(0, 150, 1, 0)
    
    local TabHolderCorner = Instance.new("UICorner")
    TabHolderCorner.CornerRadius = UDim.new(0, 5)
    TabHolderCorner.Parent = TabHolder
    
    local TabHolderFix = Instance.new("Frame")
    TabHolderFix.Name = "TabHolderFix"
    TabHolderFix.Parent = TabHolder
    TabHolderFix.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TabHolderFix.BorderSizePixel = 0
    TabHolderFix.Position = UDim2.new(1, -5, 0, 0)
    TabHolderFix.Size = UDim2.new(0, 5, 1, 0)
    
    local TabHolderPadding = Instance.new("UIPadding")
    TabHolderPadding.Parent = TabHolder
    TabHolderPadding.PaddingTop = UDim.new(0, 10)
    TabHolderPadding.PaddingBottom = UDim.new(0, 10)
    
    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.Name = "TabScroll"
    TabScroll.Parent = TabHolder
    TabScroll.Active = true
    TabScroll.BackgroundTransparency = 1
    TabScroll.Size = UDim2.new(1, 0, 1, 0)
    TabScroll.ScrollBarThickness = 0
    TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Parent = TabScroll
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 5)
    TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    local TabPadding = Instance.new("UIPadding")
    TabPadding.Parent = TabScroll
    TabPadding.PaddingTop = UDim.new(0, 5)
    TabPadding.PaddingBottom = UDim.new(0, 5)
    
    -- Tab Container (where the tab content is displayed)
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = Content
    TabContainer.BackgroundTransparency = 1
    TabContainer.Position = UDim2.new(0, 150, 0, 0)
    TabContainer.Size = UDim2.new(1, -150, 1, 0)
    
    -- Window Functions
    local WindowFunctions = {}
    WindowFunctions.Tabs = {}
    WindowFunctions.TabsObjects = {}
    WindowFunctions.ActiveTab = nil
    WindowFunctions.ActiveTabObj = nil
    
    -- Button Effects
    AddRippleEffect(CloseButton, Color3.fromRGB(255, 255, 255))
    AddRippleEffect(MinimizeButton, Color3.fromRGB(255, 255, 255))
    
    -- Make window draggable
    DraggableFrame(Window, TitleBar)
    
    -- Handle button clicks
    CloseButton.MouseButton1Click:Connect(function()
        Window.Visible = false
    end)
    
    -- Fix for minimize button functionality
    MinimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        
        if isMinimized then
            -- Save the original size before minimizing
            WindowFunctions.OriginalSize = Window.Size
            
            -- Minimize the window (hide everything except title bar)
            local minimizeTween = TweenService:Create(
                Window,
                TweenInfo.new(0.3, Enum.EasingStyle.Quint),
                {Size = UDim2.new(0, 700, 0, 30)}
            )
            minimizeTween:Play()
            
            -- Hide content
            Content.Visible = false
        else
            -- Restore to original size
            local restoreTween = TweenService:Create(
                Window,
                TweenInfo.new(0.3, Enum.EasingStyle.Quint),
                {Size = WindowFunctions.OriginalSize or UDim2.new(0, 700, 0, 500)}
            )
            restoreTween:Play()
            
            -- Show content
            Content.Visible = true
        end
    end)
    
    -- Window Visibility Toggle with Keybind
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Frosty.Settings.ToggleKey then
            Window.Visible = not Window.Visible
        end
    end)
    
    -- Function to create tabs
    function WindowFunctions:CreateTab(name, icon)
        name = name or "Tab"
        icon = icon or 0
        
        -- Create Tab Button
        local Tab = Instance.new("TextButton")
        Tab.Name = name
        Tab.Parent = TabScroll
        Tab.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        Tab.BorderSizePixel = 0
        Tab.Size = UDim2.new(0.9, 0, 0, 30)
        Tab.Font = Enum.Font.SourceSansSemibold
        Tab.Text = name
        Tab.TextColor3 = Color3.fromRGB(255, 255, 255)
        Tab.TextSize = 14
        Tab.AutoButtonColor = false
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 5)
        TabCorner.Parent = Tab
        
        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Name = "TabIcon"
        TabIcon.Parent = Tab
        TabIcon.BackgroundTransparency = 1
        TabIcon.Position = UDim2.new(0, 5, 0, 5)
        TabIcon.Size = UDim2.new(0, 20, 0, 20)
        TabIcon.Image = "rbxassetid://" .. icon
        
        local TabPadding = Instance.new("UIPadding")
        TabPadding.Parent = Tab
        TabPadding.PaddingLeft = UDim.new(0, 30)
        
        -- Create Tab Content
        local TabFrame = Instance.new("ScrollingFrame")
        TabFrame.Name = name .. "Tab"
        TabFrame.Parent = TabContainer
        TabFrame.Active = true
        TabFrame.BackgroundTransparency = 1
        TabFrame.Size = UDim2.new(1, 0, 1, 0)
        TabFrame.ScrollBarThickness = 3
        TabFrame.Visible = false
        TabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
        
        local TabFramePadding = Instance.new("UIPadding")
        TabFramePadding.Parent = TabFrame
        TabFramePadding.PaddingLeft = UDim.new(0, 10)
        TabFramePadding.PaddingRight = UDim.new(0, 10)
        TabFramePadding.PaddingTop = UDim.new(0, 10)
        TabFramePadding.PaddingBottom = UDim.new(0, 10)
        
        local TabFrameListLayout = Instance.new("UIListLayout")
        TabFrameListLayout.Parent = TabFrame
        TabFrameListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabFrameListLayout.Padding = UDim.new(0, 10)
        
        -- Auto-update canvas size
        TabFrameListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabFrame.CanvasSize = UDim2.new(0, 0, 0, TabFrameListLayout.AbsoluteContentSize.Y + 20)
        end)
        
        -- Tab Selection Logic
        Tab.MouseButton1Click:Connect(function()
            for _, tabObject in pairs(WindowFunctions.TabsObjects) do
                tabObject.Visible = false
            end
            
            for _, tabButton in pairs(WindowFunctions.Tabs) do
                if tabButton ~= Tab then
                    TweenService:Create(tabButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
                end
            end
            
            TweenService:Create(Tab, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
            TabFrame.Visible = true
            WindowFunctions.ActiveTab = name
            WindowFunctions.ActiveTabObj = TabFrame
        end)
        
        -- Add to tabs table
        table.insert(WindowFunctions.Tabs, Tab)
        WindowFunctions.TabsObjects[name] = TabFrame
        
        -- If first tab, select it
        if #WindowFunctions.Tabs == 1 then
            Tab.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            TabFrame.Visible = true
            WindowFunctions.ActiveTab = name
            WindowFunctions.ActiveTabObj = TabFrame
        end
        
        -- Add Ripple Effect
        AddRippleEffect(Tab, Color3.fromRGB(255, 255, 255))
        
        -- Tab UI Element Creation Functions
        local TabElements = {}
        
        -- Create a section header
        function TabElements:CreateSection(sectionName)
            sectionName = sectionName or "Section"
            
            local SectionLabel = Instance.new("TextLabel")
            SectionLabel.Name = sectionName .. "Section"
            SectionLabel.Parent = TabFrame
            SectionLabel.BackgroundTransparency = 1
            SectionLabel.Size = UDim2.new(1, 0, 0, 30)
            SectionLabel.Font = Enum.Font.SourceSansBold
            SectionLabel.Text = sectionName
            SectionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            SectionLabel.TextSize = 16
            SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            return sectionName
        end
        
        -- Create a button
        function TabElements:CreateButton(options)
            options = options or {}
            options.Name = options.Name or "Button"
            options.Callback = options.Callback or function() end
            
            local Button = Instance.new("Frame")
            Button.Name = options.Name .. "Button"
            Button.Parent = TabFrame
            Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Button.BorderSizePixel = 0
            Button.Size = UDim2.new(1, 0, 0, 40)
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 5)
            ButtonCorner.Parent = Button
            
            local ButtonLabel = Instance.new("TextLabel")
            ButtonLabel.Name = "ButtonLabel"
            ButtonLabel.Parent = Button
            ButtonLabel.BackgroundTransparency = 1
            ButtonLabel.Size = UDim2.new(1, -40, 1, 0)
            ButtonLabel.Font = Enum.Font.SourceSansSemibold
            ButtonLabel.Text = options.Name
            ButtonLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            ButtonLabel.TextSize = 14
            ButtonLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local ButtonPadding = Instance.new("UIPadding")
            ButtonPadding.Parent = ButtonLabel
            ButtonPadding.PaddingLeft = UDim.new(0, 10)
            
            local ButtonIcon = Instance.new("ImageLabel")
            ButtonIcon.Name = "ButtonIcon"
            ButtonIcon.Parent = Button
            ButtonIcon.BackgroundTransparency = 1
            ButtonIcon.Position = UDim2.new(1, -40, 0, 0)
            ButtonIcon.Size = UDim2.new(0, 40, 0, 40)
            ButtonIcon.Image = "rbxassetid://3926307971"
            ButtonIcon.ImageRectOffset = Vector2.new(764, 764)
            ButtonIcon.ImageRectSize = Vector2.new(36, 36)
            
            local ButtonActivator = Instance.new("TextButton")
            ButtonActivator.Name = "ButtonActivator"
            ButtonActivator.Parent = Button
            ButtonActivator.BackgroundTransparency = 1
            ButtonActivator.Size = UDim2.new(1, 0, 1, 0)
            ButtonActivator.Font = Enum.Font.SourceSans
            ButtonActivator.Text = ""
            ButtonActivator.TextTransparency = 1
            
            ButtonActivator.MouseButton1Click:Connect(function()
                options.Callback()
            end)
            
            -- Add ripple effect
            AddRippleEffect(ButtonActivator, Color3.fromRGB(255, 255, 255))
            
            return Button
        end
        
        -- Create a toggle
        function TabElements:CreateToggle(options)
            options = options or {}
            options.Name = options.Name or "Toggle"
            options.CurrentValue = options.CurrentValue or false
            options.Callback = options.Callback or function() end
            
            local Toggle = Instance.new("Frame")
            Toggle.Name = options.Name .. "Toggle"
            Toggle.Parent = TabFrame
            Toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Toggle.BorderSizePixel = 0
            Toggle.Size = UDim2.new(1, 0, 0, 40)
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 5)
            ToggleCorner.Parent = Toggle
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Name = "ToggleLabel"
            ToggleLabel.Parent = Toggle
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
            ToggleLabel.Font = Enum.Font.SourceSansSemibold
            ToggleLabel.Text = options.Name
            ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            ToggleLabel.TextSize = 14
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local TogglePadding = Instance.new("UIPadding")
            TogglePadding.Parent = ToggleLabel
            TogglePadding.PaddingLeft = UDim.new(0, 10)
            
            local ToggleSwitch = Instance.new("Frame")
            ToggleSwitch.Name = "ToggleSwitch"
            ToggleSwitch.Parent = Toggle
            ToggleSwitch.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            ToggleSwitch.BorderSizePixel = 0
            ToggleSwitch.Position = UDim2.new(1, -50, 0.5, -10)
            ToggleSwitch.Size = UDim2.new(0, 40, 0, 20)
            
            local ToggleSwitchCorner = Instance.new("UICorner")
            ToggleSwitchCorner.CornerRadius = UDim.new(1, 0)
            ToggleSwitchCorner.Parent = ToggleSwitch
            
            local ToggleBall = Instance.new("Frame")
            ToggleBall.Name = "ToggleBall"
            ToggleBall.Parent = ToggleSwitch
            ToggleBall.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleBall.BorderSizePixel = 0
            ToggleBall.Position = UDim2.new(0, 2, 0, 2)
            ToggleBall.Size = UDim2.new(0, 16, 0, 16)
            
            local ToggleBallCorner = Instance.new("UICorner")
            ToggleBallCorner.CornerRadius = UDim.new(1, 0)
            ToggleBallCorner.Parent = ToggleBall
            
            local ToggleActivator = Instance.new("TextButton")
            ToggleActivator.Name = "ToggleActivator"
            ToggleActivator.Parent = Toggle
            ToggleActivator.BackgroundTransparency = 1
            ToggleActivator.Size = UDim2.new(1, 0, 1, 0)
            ToggleActivator.Font = Enum.Font.SourceSans
            ToggleActivator.Text = ""
            ToggleActivator.TextTransparency = 1
            
            -- Set initial state
            local toggleState = options.CurrentValue
            if toggleState then
                ToggleSwitch.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
                ToggleBall.Position = UDim2.new(1, -18, 0, 2)
            end
            
            -- Toggle function
            local function updateToggle()
                toggleState = not toggleState
                
                if toggleState then
                    TweenService:Create(ToggleSwitch, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(0, 120, 255)}):Play()
                    TweenService:Create(ToggleBall, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = UDim2.new(1, -18, 0, 2)}):Play()
                else
                    TweenService:Create(ToggleSwitch, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
                    TweenService:Create(ToggleBall, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = UDim2.new(0, 2, 0, 2)}):Play()
                end
                
                options.Callback(toggleState)
            end
            
            ToggleActivator.MouseButton1Click:Connect(updateToggle)
            
            -- Add ripple effect
            AddRippleEffect(ToggleActivator, Color3.fromRGB(255, 255, 255))
            
            -- Methods for this toggle
            local ToggleElement = {}
            
            function ToggleElement:Set(newState)
                if newState ~= toggleState then
                    updateToggle()
                end
            end
            
            return ToggleElement
        end
        
        -- Create a slider
        function TabElements:CreateSlider(options)
            options = options or {}
            options.Name = options.Name or "Slider"
            options.Range = options.Range or {0, 100}
            options.Increment = options.Increment or 1
            options.CurrentValue = options.CurrentValue or 50
            options.Callback = options.Callback or function() end
            options.Suffix = options.Suffix or ""
            
            local Slider = Instance.new("Frame")
            Slider.Name = options.Name .. "Slider"
            Slider.Parent = TabFrame
            Slider.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Slider.BorderSizePixel = 0
            Slider.Size = UDim2.new(1, 0, 0, 60)
            
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 5)
            SliderCorner.Parent = Slider
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Name = "SliderLabel"
            SliderLabel.Parent = Slider
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Position = UDim2.new(0, 0, 0, 0)
            SliderLabel.Size = UDim2.new(1, 0, 0, 30)
            SliderLabel.Font = Enum.Font.SourceSansSemibold
            SliderLabel.Text = options.Name
            SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            SliderLabel.TextSize = 14
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local SliderPadding = Instance.new("UIPadding")
            SliderPadding.Parent = SliderLabel
            SliderPadding.PaddingLeft = UDim.new(0, 10)
            
            local SliderValue = Instance.new("TextLabel")
            SliderValue.Name = "SliderValue"
            SliderValue.Parent = SliderLabel
            SliderValue.BackgroundTransparency = 1
            SliderValue.Position = UDim2.new(1, -60, 0, 0)
            SliderValue.Size = UDim2.new(0, 50, 1, 0)
            SliderValue.Font = Enum.Font.SourceSansSemibold
            SliderValue.Text = options.CurrentValue .. options.Suffix
            SliderValue.TextColor3 = Color3.fromRGB(255, 255, 255)
            SliderValue.TextSize = 14
            SliderValue.TextXAlignment = Enum.TextXAlignment.Right
            
            local SliderBar = Instance.new("Frame")
            SliderBar.Name = "SliderBar"
            SliderBar.Parent = Slider
            SliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            SliderBar.BorderSizePixel = 0
            SliderBar.Position = UDim2.new(0, 10, 0, 40)
            SliderBar.Size = UDim2.new(1, -20, 0, 5)
            
            local SliderBarCorner = Instance.new("UICorner")
            SliderBarCorner.CornerRadius = UDim.new(1, 0)
            SliderBarCorner.Parent = SliderBar
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Name = "SliderFill"
            SliderFill.Parent = SliderBar
            SliderFill.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
            SliderFill.BorderSizePixel = 0
            SliderFill.Size = UDim2.new(0, 0, 1, 0)
            
            local SliderFillCorner = Instance.new("UICorner")
            SliderFillCorner.CornerRadius = UDim.new(1, 0)
            SliderFillCorner.Parent = SliderFill
            
            local SliderBall = Instance.new("Frame")
            SliderBall.Name = "SliderBall"
            SliderBall.Parent = SliderFill
            SliderBall.AnchorPoint = Vector2.new(0.5, 0.5)
            SliderBall.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SliderBall.BorderSizePixel = 0
            SliderBall.Position = UDim2.new(1, 0, 0.5, 0)
            SliderBall.Size = UDim2.new(0, 15, 0, 15)
            
            local SliderBallCorner = Instance.new("UICorner")
            SliderBallCorner.CornerRadius = UDim.new(1, 0)
            SliderBallCorner.Parent = SliderBall
            
            local SliderButton = Instance.new("TextButton")
            SliderButton.Name = "SliderButton"
            SliderButton.Parent = Slider
            SliderButton.BackgroundTransparency = 1
            SliderButton.Size = UDim2.new(1, 0, 1, 0)
            SliderButton.Font = Enum.Font.SourceSans
            SliderButton.Text = ""
            SliderButton.TextTransparency = 1
            
            -- Calculate initial fill based on current value
            local min, max = options.Range[1], options.Range[2]
            local currentValue = options.CurrentValue
            local increment = options.Increment
            
            local function updateSlider(value)
                local percent = (value - min) / (max - min)
                SliderFill.Size = UDim2.new(percent, 0, 1, 0)
                SliderValue.Text = value .. options.Suffix
                options.Callback(value)
            end
            
            updateSlider(currentValue)
            
            -- Slider interaction
            local isDragging = false
            
            SliderButton.MouseButton1Down:Connect(function()
                isDragging = true
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    isDragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement and isDragging then
                    local mousePosition = input.Position.X
                    local sliderPosition = SliderBar.AbsolutePosition.X
                    local sliderWidth = SliderBar.AbsoluteSize.X
                    
                    local percent = math.clamp((mousePosition - sliderPosition) / sliderWidth, 0, 1)
                    local value = min + ((max - min) * percent)
                    
                    -- Apply increment
                    value = math.floor((value / increment) + 0.5) * increment
                    value = math.clamp(value, min, max)
                    
                    updateSlider(value)
                end
            end)
            
            -- Methods for this slider
            local SliderElement = {}
            
            function SliderElement:Set(value)
                value = math.clamp(value, min, max)
                value = math.floor((value / increment) + 0.5) * increment
                updateSlider(value)
            end
            
            return SliderElement
        end
        
        -- Create a dropdown
        function TabElements:CreateDropdown(options)
            options = options or {}
            options.Name = options.Name or "Dropdown"
            options.Options = options.Options or {}
            options.CurrentOption = options.CurrentOption or ""
            options.Callback = options.Callback or function() end
            
            local Dropdown = Instance.new("Frame")
            Dropdown.Name = options.Name .. "Dropdown"
            Dropdown.Parent = TabFrame
            Dropdown.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Dropdown.BorderSizePixel = 0
            Dropdown.Size = UDim2.new(1, 0, 0, 40)
            Dropdown.ClipsDescendants = true
            
            local DropdownCorner = Instance.new("UICorner")
            DropdownCorner.CornerRadius = UDim.new(0, 5)
            DropdownCorner.Parent = Dropdown
            
            local DropdownLabel = Instance.new("TextLabel")
            DropdownLabel.Name = "DropdownLabel"
            DropdownLabel.Parent = Dropdown
            DropdownLabel.BackgroundTransparency = 1
            DropdownLabel.Size = UDim2.new(1, -40, 0, 40)
            DropdownLabel.Font = Enum.Font.SourceSansSemibold
            DropdownLabel.Text = options.Name
            DropdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            DropdownLabel.TextSize = 14
            DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local DropdownPadding = Instance.new("UIPadding")
            DropdownPadding.Parent = DropdownLabel
            DropdownPadding.PaddingLeft = UDim.new(0, 10)
            
            local DropdownSelected = Instance.new("TextLabel")
            DropdownSelected.Name = "DropdownSelected"
            DropdownSelected.Parent = Dropdown
            DropdownSelected.BackgroundTransparency = 1
            DropdownSelected.Position = UDim2.new(1, -150, 0, 0)
            DropdownSelected.Size = UDim2.new(0, 110, 0, 40)
            DropdownSelected.Font = Enum.Font.SourceSans
            DropdownSelected.Text = options.CurrentOption
            DropdownSelected.TextColor3 = Color3.fromRGB(180, 180, 180)
            DropdownSelected.TextSize = 14
            DropdownSelected.TextXAlignment = Enum.TextXAlignment.Right
            
            local DropdownIcon = Instance.new("ImageLabel")
            DropdownIcon.Name = "DropdownIcon"
            DropdownIcon.Parent = Dropdown
            DropdownIcon.BackgroundTransparency = 1
            DropdownIcon.Position = UDim2.new(1, -40, 0, 0)
            DropdownIcon.Size = UDim2.new(0, 40, 0, 40)
            DropdownIcon.Image = "rbxassetid://3926305904"
            DropdownIcon.ImageRectOffset = Vector2.new(564, 284)
            DropdownIcon.ImageRectSize = Vector2.new(36, 36)
            DropdownIcon.Rotation = 0
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Name = "DropdownButton"
            DropdownButton.Parent = Dropdown
            DropdownButton.BackgroundTransparency = 1
            DropdownButton.Size = UDim2.new(1, 0, 0, 40)
            DropdownButton.Font = Enum.Font.SourceSans
            DropdownButton.Text = ""
            DropdownButton.TextTransparency = 1
            
            local ItemsHolder = Instance.new("Frame")
            ItemsHolder.Name = "ItemsHolder"
            ItemsHolder.Parent = Dropdown
            ItemsHolder.BackgroundTransparency = 1
            ItemsHolder.Position = UDim2.new(0, 0, 0, 40)
            ItemsHolder.Size = UDim2.new(1, 0, 0, 0)
            
            local ItemsList = Instance.new("UIListLayout")
            ItemsList.Parent = ItemsHolder
            ItemsList.SortOrder = Enum.SortOrder.LayoutOrder
            
            -- Add options to the dropdown
            local dropdownItems = {}
            local isOpen = false
            
            local function updateDropdown()
                if isOpen then
                    Dropdown:TweenSize(UDim2.new(1, 0, 0, 40 + (#options.Options * 30)), "Out", "Quad", 0.3, true)
                    TweenService:Create(DropdownIcon, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Rotation = 180}):Play()
                else
                    Dropdown:TweenSize(UDim2.new(1, 0, 0, 40), "Out", "Quad", 0.3, true)
                    TweenService:Create(DropdownIcon, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Rotation = 0}):Play()
                end
            end
            
            local function createDropdownItem(itemName)
                local Item = Instance.new("TextButton")
                Item.Name = itemName .. "Item"
                Item.Parent = ItemsHolder
                Item.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                Item.BorderSizePixel = 0
                Item.Size = UDim2.new(1, 0, 0, 30)
                Item.Font = Enum.Font.SourceSans
                Item.Text = itemName
                Item.TextColor3 = Color3.fromRGB(255, 255, 255)
                Item.TextSize = 14
                
                local ItemPadding = Instance.new("UIPadding")
                ItemPadding.Parent = Item
                ItemPadding.PaddingLeft = UDim.new(0, 10)
                
                Item.MouseButton1Click:Connect(function()
                    DropdownSelected.Text = itemName
                    isOpen = false
                    updateDropdown()
                    options.Callback(itemName)
                end)
                
                -- Add ripple effect
                AddRippleEffect(Item, Color3.fromRGB(255, 255, 255))
                
                return Item
            end
            
            for _, item in ipairs(options.Options) do
                local dropdownItem = createDropdownItem(item)
                table.insert(dropdownItems, dropdownItem)
            end
            
            DropdownButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                updateDropdown()
            end)
            
            -- Add ripple effect
            AddRippleEffect(DropdownButton, Color3.fromRGB(255, 255, 255))
            
            -- Methods for dropdown
            local DropdownElement = {}
            
            function DropdownElement:Refresh(newOptions)
                -- Clear existing options
                for _, item in ipairs(dropdownItems) do
                    item:Destroy()
                end
                
                dropdownItems = {}
                options.Options = newOptions
                
                -- Add new options
                for _, item in ipairs(newOptions) do
                    local dropdownItem = createDropdownItem(item)
                    table.insert(dropdownItems, dropdownItem)
                end
                
                if isOpen then
                    updateDropdown()
                end
            end
            
            function DropdownElement:Set(option)
                if table.find(options.Options, option) then
                    DropdownSelected.Text = option
                    options.Callback(option)
                end
            end
            
            return DropdownElement
        end
        
        -- Create a color picker
        function TabElements:CreateColorPicker(options)
            options = options or {}
            options.Name = options.Name or "Color Picker"
            options.Color = options.Color or Color3.fromRGB(255, 0, 0)
            options.Callback = options.Callback or function() end
            
            local ColorPicker = Instance.new("Frame")
            ColorPicker.Name = options.Name .. "ColorPicker"
            ColorPicker.Parent = TabFrame
            ColorPicker.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            ColorPicker.BorderSizePixel = 0
            ColorPicker.Size = UDim2.new(1, 0, 0, 40)
            ColorPicker.ClipsDescendants = true
            
            local ColorPickerCorner = Instance.new("UICorner")
            ColorPickerCorner.CornerRadius = UDim.new(0, 5)
            ColorPickerCorner.Parent = ColorPicker
            
            local ColorPickerLabel = Instance.new("TextLabel")
            ColorPickerLabel.Name = "ColorPickerLabel"
            ColorPickerLabel.Parent = ColorPicker
            ColorPickerLabel.BackgroundTransparency = 1
            ColorPickerLabel.Size = UDim2.new(1, -60, 0, 40)
            ColorPickerLabel.Font = Enum.Font.SourceSansSemibold
            ColorPickerLabel.Text = options.Name
            ColorPickerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            ColorPickerLabel.TextSize = 14
            ColorPickerLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local ColorPickerPadding = Instance.new("UIPadding")
            ColorPickerPadding.Parent = ColorPickerLabel
            ColorPickerPadding.PaddingLeft = UDim.new(0, 10)
            
            local ColorDisplay = Instance.new("Frame")
            ColorDisplay.Name = "ColorDisplay"
            ColorDisplay.Parent = ColorPicker
            ColorDisplay.BackgroundColor3 = options.Color
            ColorDisplay.BorderSizePixel = 0
            ColorDisplay.Position = UDim2.new(1, -50, 0.5, -10)
            ColorDisplay.Size = UDim2.new(0, 40, 0, 20)
            
            local ColorDisplayCorner = Instance.new("UICorner")
            ColorDisplayCorner.CornerRadius = UDim.new(0, 4)
            ColorDisplayCorner.Parent = ColorDisplay
            
            local ColorPickerButton = Instance.new("TextButton")
            ColorPickerButton.Name = "ColorPickerButton"
            ColorPickerButton.Parent = ColorPicker
            ColorPickerButton.BackgroundTransparency = 1
            ColorPickerButton.Size = UDim2.new(1, 0, 0, 40)
            ColorPickerButton.Font = Enum.Font.SourceSans
            ColorPickerButton.Text = ""
            ColorPickerButton.TextTransparency = 1
            
            local isOpen = false
            local currentColor = options.Color
            
            -- Add ripple effect
            AddRippleEffect(ColorPickerButton, Color3.fromRGB(255, 255, 255))
            
            -- Create the color picker interface
            local ColorPickerUI = Instance.new("Frame")
            ColorPickerUI.Name = "ColorPickerUI"
            ColorPickerUI.Parent = ColorPicker
            ColorPickerUI.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            ColorPickerUI.BorderSizePixel = 0
            ColorPickerUI.Position = UDim2.new(0, 0, 0, 40)
            ColorPickerUI.Size = UDim2.new(1, 0, 0, 120)
            ColorPickerUI.Visible = false
            
            local ColorPickerUICorner = Instance.new("UICorner")
            ColorPickerUICorner.CornerRadius = UDim.new(0, 5)
            ColorPickerUICorner.Parent = ColorPickerUI
            
            -- Methods for color picker
            local ColorPickerElement = {}
            
            function ColorPickerElement:Set(newColor)
                currentColor = newColor
                ColorDisplay.BackgroundColor3 = newColor
                options.Callback(newColor)
            end
            
            ColorPickerButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                
                if isOpen then
                    ColorPicker:TweenSize(UDim2.new(1, 0, 0, 160), "Out", "Quad", 0.3, true)
                    ColorPickerUI.Visible = true
                else
                    ColorPicker:TweenSize(UDim2.new(1, 0, 0, 40), "Out", "Quad", 0.3, true)
                    ColorPickerUI.Visible = false
                end
            end)
            
            return ColorPickerElement
        end
        
        -- Create a keybind
        function TabElements:CreateKeybind(options)
            options = options or {}
            options.Name = options.Name or "Keybind"
            options.CurrentKeybind = options.CurrentKeybind or "None"
            options.HoldToInteract = options.HoldToInteract or false
            options.Callback = options.Callback or function() end
            
            local Keybind = Instance.new("Frame")
            Keybind.Name = options.Name .. "Keybind"
            Keybind.Parent = TabFrame
            Keybind.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Keybind.BorderSizePixel = 0
            Keybind.Size = UDim2.new(1, 0, 0, 40)
            
            local KeybindCorner = Instance.new("UICorner")
            KeybindCorner.CornerRadius = UDim.new(0, 5)
            KeybindCorner.Parent = Keybind
            
            local KeybindLabel = Instance.new("TextLabel")
            KeybindLabel.Name = "KeybindLabel"
            KeybindLabel.Parent = Keybind
            KeybindLabel.BackgroundTransparency = 1
            KeybindLabel.Size = UDim2.new(1, -80, 1, 0)
            KeybindLabel.Font = Enum.Font.SourceSansSemibold
            KeybindLabel.Text = options.Name
            KeybindLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            KeybindLabel.TextSize = 14
            KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local KeybindPadding = Instance.new("UIPadding")
            KeybindPadding.Parent = KeybindLabel
            KeybindPadding.PaddingLeft = UDim.new(0, 10)
            
            local KeybindButton = Instance.new("TextButton")
            KeybindButton.Name = "KeybindButton"
            KeybindButton.Parent = Keybind
            KeybindButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            KeybindButton.BorderSizePixel = 0
            KeybindButton.Position = UDim2.new(1, -80, 0.5, -15)
            KeybindButton.Size = UDim2.new(0, 70, 0, 30)
            KeybindButton.Font = Enum.Font.SourceSans
            KeybindButton.Text = options.CurrentKeybind
            KeybindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            KeybindButton.TextSize = 14
            
            local KeybindButtonCorner = Instance.new("UICorner")
            KeybindButtonCorner.CornerRadius = UDim.new(0, 4)
            KeybindButtonCorner.Parent = KeybindButton
            
            -- Add ripple effect
            AddRippleEffect(KeybindButton, Color3.fromRGB(255, 255, 255))
            
            -- Variables
            local currentKeybind = options.CurrentKeybind
            local keyPressed = false
            local listeningForKey = false
            
            -- Functions
            local function updateKeybind(key)
                currentKeybind = key
                KeybindButton.Text = key
            end
            
            -- Input handling
            KeybindButton.MouseButton1Click:Connect(function()
                listeningForKey = true
                KeybindButton.Text = "..."
            end)
            
            -- Convert KeyCode to string
            local function keyCodeToString(keyCode)
                return tostring(keyCode):gsub("Enum.KeyCode.", "")
            end
            
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                
                if listeningForKey then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        updateKeybind(keyCodeToString(input.KeyCode))
                        listeningForKey = false
                        return
                    end
                elseif not listeningForKey and input.KeyCode and keyCodeToString(input.KeyCode) == currentKeybind then
                    if options.HoldToInteract then
                        keyPressed = true
                        options.Callback(true)
                    else
                        options.Callback()
                    end
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                
                if not listeningForKey and input.KeyCode and keyCodeToString(input.KeyCode) == currentKeybind and options.HoldToInteract then
                    keyPressed = false
                    options.Callback(false)
                end
            end)
            
            -- Methods for keybind
            local KeybindElement = {}
            
            function KeybindElement:Set(newKeybind)
                updateKeybind(newKeybind)
            end
            
            return KeybindElement
        end
        
        -- Create a text label
        function TabElements:CreateLabel(text)
            text = text or "Label"
            
            local Label = Instance.new("TextLabel")
            Label.Name = "Label"
            Label.Parent = TabFrame
            Label.BackgroundTransparency = 1
            Label.Size = UDim2.new(1, 0, 0, 30)
            Label.Font = Enum.Font.SourceSans
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            
            local LabelPadding = Instance.new("UIPadding")
            LabelPadding.Parent = Label
            LabelPadding.PaddingLeft = UDim.new(0, 10)
            
            -- Methods for label
            local LabelElement = {}
            
            function LabelElement:Set(newText)
                Label.Text = newText
            end
            
            return LabelElement
        end
        
        -- Create a paragraph
        function TabElements:CreateParagraph(options)
            options = options or {}
            options.Title = options.Title or "Title"
            options.Content = options.Content or "Content"
            
            local Paragraph = Instance.new("Frame")
            Paragraph.Name = "Paragraph"
            Paragraph.Parent = TabFrame
            Paragraph.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Paragraph.BorderSizePixel = 0
            Paragraph.Size = UDim2.new(1, 0, 0, 60)
            
            local ParagraphCorner = Instance.new("UICorner")
            ParagraphCorner.CornerRadius = UDim.new(0, 5)
            ParagraphCorner.Parent = Paragraph
            
            local Title = Instance.new("TextLabel")
            Title.Name = "Title"
            Title.Parent = Paragraph
            Title.BackgroundTransparency = 1
            Title.Position = UDim2.new(0, 0, 0, 0)
            Title.Size = UDim2.new(1, 0, 0, 30)
            Title.Font = Enum.Font.SourceSansBold
            Title.Text = options.Title
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.TextSize = 14
            Title.TextXAlignment = Enum.TextXAlignment.Left
            
            local TitlePadding = Instance.new("UIPadding")
            TitlePadding.Parent = Title
            TitlePadding.PaddingLeft = UDim.new(0, 10)
            
            local Content = Instance.new("TextLabel")
            Content.Name = "Content"
            Content.Parent = Paragraph
            Content.BackgroundTransparency = 1
            Content.Position = UDim2.new(0, 0, 0, 30)
            Content.Size = UDim2.new(1, 0, 0, 30)
            Content.Font = Enum.Font.SourceSans
            Content.Text = options.Content
            Content.TextColor3 = Color3.fromRGB(200, 200, 200)
            Content.TextSize = 14
            Content.TextWrapped = true
            Content.TextXAlignment = Enum.TextXAlignment.Left
            
            local ContentPadding = Instance.new("UIPadding")
            ContentPadding.Parent = Content
            ContentPadding.PaddingLeft = UDim.new(0, 10)
            ContentPadding.PaddingRight = UDim.new(0, 10)
            
            -- Auto-resize paragraph based on content
            local function updateSize()
                Content.Size = UDim2.new(1, 0, 0, math.max(30, Content.TextBounds.Y))
                Paragraph.Size = UDim2.new(1, 0, 0, 30 + Content.Size.Y.Offset)
            end
            
            updateSize()
            Content:GetPropertyChangedSignal("Text"):Connect(updateSize)
            
            -- Methods for paragraph
            local ParagraphElement = {}
            
            function ParagraphElement:SetTitle(newTitle)
                Title.Text = newTitle
            end
            
            function ParagraphElement:SetContent(newContent)
                Content.Text = newContent
                updateSize()
            end
            
            return ParagraphElement
        end
        
        return TabElements
    end
    
    -- Initial setup animation
    task.spawn(function()
        -- Create loading screen
        local LoadingScreen = Instance.new("Frame")
        LoadingScreen.Name = "LoadingScreen"
        LoadingScreen.Parent = ScreenGui
        LoadingScreen.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        LoadingScreen.BorderSizePixel = 0
        LoadingScreen.Size = UDim2.new(1, 0, 1, 0)
        LoadingScreen.ZIndex = 1000
        
        local LoadingTitle = Instance.new("TextLabel")
        LoadingTitle.Name = "LoadingTitle"
        LoadingTitle.Parent = LoadingScreen
        LoadingTitle.BackgroundTransparency = 1
        LoadingTitle.Position = UDim2.new(0, 0, 0.4, 0)
        LoadingTitle.Size = UDim2.new(1, 0, 0, 50)
        LoadingTitle.Font = Enum.Font.GothamBold
        LoadingTitle.Text = config.LoadingTitle
        LoadingTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        LoadingTitle.TextSize = 30
        LoadingTitle.ZIndex = 1001
        
        local LoadingSubtitle = Instance.new("TextLabel")
        LoadingSubtitle.Name = "LoadingSubtitle"
        LoadingSubtitle.Parent = LoadingScreen
        LoadingSubtitle.BackgroundTransparency = 1
        LoadingSubtitle.Position = UDim2.new(0, 0, 0.45, 0)
        LoadingSubtitle.Size = UDim2.new(1, 0, 0, 30)
        LoadingSubtitle.Font = Enum.Font.Gotham
        LoadingSubtitle.Text = config.LoadingSubtitle
        LoadingSubtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
        LoadingSubtitle.TextSize = 15
        LoadingSubtitle.ZIndex = 1001
        
        local LoadingBar = Instance.new("Frame")
        LoadingBar.Name = "LoadingBar"
        LoadingBar.Parent = LoadingScreen
        LoadingBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        LoadingBar.BorderSizePixel = 0
        LoadingBar.Position = UDim2.new(0.25, 0, 0.5, 0)
        LoadingBar.Size = UDim2.new(0.5, 0, 0, 5)
        LoadingBar.ZIndex = 1001
        
        local LoadingBarCorner = Instance.new("UICorner")
        LoadingBarCorner.CornerRadius = UDim.new(1, 0)
        LoadingBarCorner.Parent = LoadingBar
        
        local LoadingBarFill = Instance.new("Frame")
        LoadingBarFill.Name = "LoadingBarFill"
        LoadingBarFill.Parent = LoadingBar
        LoadingBarFill.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        LoadingBarFill.BorderSizePixel = 0
        LoadingBarFill.Size = UDim2.new(0, 0, 1, 0)
        LoadingBarFill.ZIndex = 1002
        
        local LoadingBarFillCorner = Instance.new("UICorner")
        LoadingBarFillCorner.CornerRadius = UDim.new(1, 0)
        LoadingBarFillCorner.Parent = LoadingBarFill
        
        -- Animate loading
        TweenService:Create(LoadingBarFill, TweenInfo.new(2, Enum.EasingStyle.Quint), {Size = UDim2.new(1, 0, 1, 0)}):Play()
        
        wait(2)
        
        -- Fade out loading screen
        TweenService:Create(LoadingScreen, TweenInfo.new(1.5, Enum.EasingStyle.Quint), {BackgroundTransparency = 1}):Play()
        TweenService:Create(LoadingTitle, TweenInfo.new(1.5, Enum.EasingStyle.Quint), {TextTransparency = 1}):Play()
        TweenService:Create(LoadingSubtitle, TweenInfo.new(1.5, Enum.EasingStyle.Quint), {TextTransparency = 1}):Play()
        TweenService:Create(LoadingBar, TweenInfo.new(1.5, Enum.EasingStyle.Quint), {BackgroundTransparency = 1}):Play()
        TweenService:Create(LoadingBarFill, TweenInfo.new(1.5, Enum.EasingStyle.Quint), {BackgroundTransparency = 1}):Play()
        
        wait(2)
        
        -- Remove loading screen and show window
        LoadingScreen:Destroy()
        Window.Visible = true
        
        -- Animate window entry
        Window.Size = UDim2.new(0, 0, 0, 0)
        Window.Position = UDim2.new(0.5, 0, 0.5, 0)
        
        TweenService:Create(Window, TweenInfo.new(1, Enum.EasingStyle.Bounce), {Size = UDim2.new(0, 700, 0, 500)}):Play()
    end)
    
    -- Return window functions
    return WindowFunctions
end

return Frosty
