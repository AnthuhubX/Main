local Frosty = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FrostyLibrary"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

-- UI Variables
local windowCount = 0
local library = {
    WindowCount = windowCount,
    Theme = {
        Primary = Color3.fromRGB(24, 25, 28),
        Secondary = Color3.fromRGB(32, 33, 36),
        Accent = Color3.fromRGB(75, 171, 255),
        Text = Color3.fromRGB(255, 255, 255),
        DarkText = Color3.fromRGB(175, 175, 175),
        DarkerText = Color3.fromRGB(125, 125, 125),
        TabBackground = Color3.fromRGB(50, 53, 59),
        ElementBackground = Color3.fromRGB(40, 43, 48),
    },
    Font = Enum.Font.SourceSansSemibold,
    ToggleKey = Enum.KeyCode.RightShift,
    Windows = {}
}

-- Utility Functions
local utility = {}

function utility:DarkenColor(color, percent)
    local r, g, b = color.R, color.G, color.B
    r = math.clamp(r - (r * percent), 0, 1)
    g = math.clamp(g - (g * percent), 0, 1)
    b = math.clamp(b - (b * percent), 0, 1)
    return Color3.new(r, g, b)
end

function utility:LightenColor(color, percent)
    local r, g, b = color.R, color.G, color.B
    r = math.clamp(r + ((1 - r) * percent), 0, 1)
    g = math.clamp(g + ((1 - g) * percent), 0, 1)
    b = math.clamp(b + ((1 - b) * percent), 0, 1)
    return Color3.new(r, g, b)
end

function utility:Tween(instance, properties, duration, style, direction)
    style = style or Enum.EasingStyle.Quart
    direction = direction or Enum.EasingDirection.Out
    
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(duration, style, direction),
        properties
    )
    tween:Play()
    return tween
end

function utility:CreateDropShadow(parent, size, transparency)
    size = size or 5
    transparency = transparency or 0.5
    
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0, -size, 0, -size)
    shadow.Size = UDim2.new(1, size*2, 1, size*2)
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = transparency
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Parent = parent
    
    return shadow
end

function utility:SmoothScroll(scrollingFrame, duration)
    duration = duration or 0.2
    local contentSize = scrollingFrame.UIListLayout.AbsoluteContentSize
    local speed = (contentSize.Y - scrollingFrame.AbsoluteWindowSize.Y) / (40 * duration)
    
    if speed ~= 0 then
        scrollingFrame.ScrollingEnabled = false
        
        local scrollConnection
        scrollConnection = scrollingFrame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseWheel then
                local direction = input.Position.Z > 0 and -1 or 1
                local targetPosition = scrollingFrame.CanvasPosition.Y + direction * speed
                targetPosition = math.clamp(targetPosition, 0, contentSize.Y - scrollingFrame.AbsoluteWindowSize.Y)
                
                utility:Tween(scrollingFrame, {CanvasPosition = Vector2.new(0, targetPosition)}, duration, Enum.EasingStyle.Quint)
            end
        end)
        
        scrollingFrame.Destroying:Connect(function()
            if scrollConnection then
                scrollConnection:Disconnect()
            end
        end)
    end
end

-- Main Library Functions
function Frosty:CreateWindow(options)
    options = options or {}
    options.Title = options.Title or "Frosty UI"
    options.Subtitle = options.Subtitle or "by Pahotfgo"
    options.Size = options.Size or UDim2.new(0, 500, 0, 350)
    options.Position = options.Position or UDim2.new(0.5, -250, 0.5, -175)
    options.Theme = options.Theme or library.Theme
    options.ToggleKey = options.ToggleKey or library.ToggleKey
    
    -- Window Creation
    windowCount = windowCount + 1
    
    local Window = {}
    local tabs = {}
    local selectedTab = nil
    
    -- Main Elements
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = options.Size
    MainFrame.Position = options.Position
    MainFrame.BackgroundColor3 = options.Theme.Primary
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = MainFrame
    
    utility:CreateDropShadow(MainFrame, 10, 0.3)
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = options.Theme.Secondary
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local TitleUICorner = Instance.new("UICorner")
    TitleUICorner.CornerRadius = UDim.new(0, 6)
    TitleUICorner.Parent = TitleBar
    
    local TitleBarBottom = Instance.new("Frame")
    TitleBarBottom.Name = "TitleBarBottom"
    TitleBarBottom.Position = UDim2.new(0, 0, 1, -6)
    TitleBarBottom.Size = UDim2.new(1, 0, 0, 6)
    TitleBarBottom.BackgroundColor3 = options.Theme.Secondary
    TitleBarBottom.BorderSizePixel = 0
    TitleBarBottom.ZIndex = 2
    TitleBarBottom.Parent = TitleBar
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.Size = UDim2.new(0.5, 0, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Font = library.Font
    Title.Text = options.Title
    Title.TextSize = 16
    Title.TextColor3 = options.Theme.Text
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar
    
    local Subtitle = Instance.new("TextLabel")
    Subtitle.Name = "Subtitle"
    Subtitle.Position = UDim2.new(0, 12, 0.5, 2)
    Subtitle.Size = UDim2.new(0.5, 0, 0.5, 0)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Font = library.Font
    Subtitle.Text = options.Subtitle
    Subtitle.TextSize = 13
    Subtitle.TextColor3 = options.Theme.DarkText
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left
    Subtitle.Parent = TitleBar
    
    -- Minimize Button
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Position = UDim2.new(1, -70, 0, 0)
    MinimizeButton.Size = UDim2.new(0, 30, 1, 0)
    MinimizeButton.BackgroundTransparency = 1
    MinimizeButton.Font = Enum.Font.SourceSansBold
    MinimizeButton.Text = "-"
    MinimizeButton.TextSize = 20
    MinimizeButton.TextColor3 = options.Theme.Text
    MinimizeButton.Parent = TitleBar
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Position = UDim2.new(1, -30, 0, 0)
    CloseButton.Size = UDim2.new(0, 30, 1, 0)
    CloseButton.BackgroundTransparency = 1
    CloseButton.Font = Enum.Font.SourceSansBold
    CloseButton.Text = "X"
    CloseButton.TextSize = 16
    CloseButton.TextColor3 = options.Theme.Text
    CloseButton.Parent = TitleBar
    
    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Position = UDim2.new(0, 0, 0, 40)
    TabContainer.Size = UDim2.new(0, 120, 1, -40)
    TabContainer.BackgroundColor3 = options.Theme.Secondary
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = MainFrame
    
    local TabContainerUICorner = Instance.new("UICorner")
    TabContainerUICorner.CornerRadius = UDim.new(0, 6)
    TabContainerUICorner.Parent = TabContainer
    
    local TabContainerRight = Instance.new("Frame")
    TabContainerRight.Name = "TabContainerRight"
    TabContainerRight.Position = UDim2.new(1, -6, 0, 0)
    TabContainerRight.Size = UDim2.new(0, 6, 1, 0)
    TabContainerRight.BackgroundColor3 = options.Theme.Secondary
    TabContainerRight.BorderSizePixel = 0
    TabContainerRight.ZIndex = 2
    TabContainerRight.Parent = TabContainer
    
    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.Name = "TabScroll"
    TabScroll.Position = UDim2.new(0, 0, 0, 10)
    TabScroll.Size = UDim2.new(1, 0, 1, -10)
    TabScroll.BackgroundTransparency = 1
    TabScroll.BorderSizePixel = 0
    TabScroll.ScrollBarThickness = 0
    TabScroll.ScrollingDirection = Enum.ScrollingDirection.Y
    TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabScroll.Parent = TabContainer
    
    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Name = "TabListLayout"
    TabListLayout.FillDirection = Enum.FillDirection.Vertical
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 5)
    TabListLayout.Parent = TabScroll
    
    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingLeft = UDim.new(0, 10)
    TabPadding.PaddingRight = UDim.new(0, 10)
    TabPadding.PaddingTop = UDim.new(0, 5)
    TabPadding.PaddingBottom = UDim.new(0, 5)
    TabPadding.Parent = TabScroll
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Position = UDim2.new(0, 120, 0, 40)
    ContentContainer.Size = UDim2.new(1, -120, 1, -40)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.BorderSizePixel = 0
    ContentContainer.Parent = MainFrame
    
    -- Draggable circle (initially hidden)
    local DraggableCircle = Instance.new("ImageButton")
    DraggableCircle.Name = "DraggableCircle"
    DraggableCircle.Size = UDim2.new(0, 40, 0, 40)
    DraggableCircle.Position = UDim2.new(0, 20, 0, 100)
    DraggableCircle.BackgroundColor3 = options.Theme.Accent
    DraggableCircle.BorderSizePixel = 0
    DraggableCircle.Visible = false
    DraggableCircle.Parent = ScreenGui
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = DraggableCircle
    
    -- Window Functionality
    local Minimized = false
    local ContentSize = ContentContainer.Size
    
    -- Make window draggable
    local Dragging = false
    local DragStart, StartPosition
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = MainFrame.Position
        end
    end)
    
    TitleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local Delta = input.Position - DragStart
            MainFrame.Position = UDim2.new(
                StartPosition.X.Scale,
                StartPosition.X.Offset + Delta.X,
                StartPosition.Y.Scale,
                StartPosition.Y.Offset + Delta.Y
            )
        end
    end)
    
    -- Make circle draggable
    local CircleDragging = false
    local CircleDragStart, CircleStartPosition
    
    DraggableCircle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            CircleDragging = true
            CircleDragStart = input.Position
            CircleStartPosition = DraggableCircle.Position
        end
    end)
    
    DraggableCircle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            CircleDragging = false
            
            -- Handle click (not drag)
            if (input.Position - CircleDragStart).Magnitude < 5 then
                MainFrame.Visible = true
                DraggableCircle.Visible = false
            end
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if CircleDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local Delta = input.Position - CircleDragStart
            DraggableCircle.Position = UDim2.new(
                CircleStartPosition.X.Scale,
                CircleStartPosition.X.Offset + Delta.X,
                CircleStartPosition.Y.Scale,
                CircleStartPosition.Y.Offset + Delta.Y
            )
        end
    end)
    
    -- Minimize and Close Functionality
    MinimizeButton.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        
        if Minimized then
            utility:Tween(ContentContainer, {Size = UDim2.new(1, -120, 0, 0)}, 0.3)
            utility:Tween(MainFrame, {Size = UDim2.new(options.Size.X.Scale, options.Size.X.Offset, 0, 40)}, 0.3)
        else
            utility:Tween(ContentContainer, {Size = ContentSize}, 0.3)
            utility:Tween(MainFrame, {Size = options.Size}, 0.3)
        end
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        DraggableCircle.Visible = true
    end)
    
    -- Toggle key functionality
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == options.ToggleKey then
            if MainFrame.Visible then
                MainFrame.Visible = false
                DraggableCircle.Visible = true
            else
                MainFrame.Visible = true
                DraggableCircle.Visible = false
            end
        end
    end)
    
    -- Tab Management Functions
    function Window:CreateTab(tabTitle)
        local TabInfo = {}
        
        -- Create Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabTitle .. "Tab"
        TabButton.Size = UDim2.new(1, 0, 0, 30)
        TabButton.BackgroundColor3 = selectedTab == nil and options.Theme.TabBackground or options.Theme.Secondary
        TabButton.BorderSizePixel = 0
        TabButton.Text = tabTitle
        TabButton.Font = library.Font
        TabButton.TextSize = 14
        TabButton.TextColor3 = selectedTab == nil and options.Theme.Text or options.Theme.DarkText
        TabButton.Parent = TabScroll
        
        local TabButtonUICorner = Instance.new("UICorner")
        TabButtonUICorner.CornerRadius = UDim.new(0, 6)
        TabButtonUICorner.Parent = TabButton
        
        -- Create Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = tabTitle .. "Content"
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 2
        TabContent.ScrollBarImageColor3 = options.Theme.DarkText
        TabContent.ScrollingDirection = Enum.ScrollingDirection.Y
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Visible = selectedTab == nil
        TabContent.Parent = ContentContainer
        
        local TabContentListLayout = Instance.new("UIListLayout")
        TabContentListLayout.Name = "ContentListLayout"
        TabContentListLayout.FillDirection = Enum.FillDirection.Vertical
        TabContentListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabContentListLayout.Padding = UDim.new(0, 8)
        TabContentListLayout.Parent = TabContent
        
        local TabContentPadding = Instance.new("UIPadding")
        TabContentPadding.PaddingLeft = UDim.new(0, 12)
        TabContentPadding.PaddingRight = UDim.new(0, 12)
        TabContentPadding.PaddingTop = UDim.new(0, 12)
        TabContentPadding.PaddingBottom = UDim.new(0, 12)
        TabContentPadding.Parent = TabContent
        
        -- Update tab selection
        if selectedTab == nil then
            selectedTab = TabButton
        end
        
        -- Handle tab content size updating
        TabContentListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContentListLayout.AbsoluteContentSize.Y + 24)
        end)
        
        -- Tab Selection Functionality
        TabButton.MouseButton1Click:Connect(function()
            -- Deselect previous tab
            if selectedTab ~= TabButton then
                utility:Tween(selectedTab, {BackgroundColor3 = options.Theme.Secondary}, 0.2)
                utility:Tween(selectedTab, {TextColor3 = options.Theme.DarkText}, 0.2)
                
                for _, tab in pairs(tabs) do
                    if tab.Button == selectedTab then
                        tab.Content.Visible = false
                    end
                end
                
                -- Select new tab
                selectedTab = TabButton
                utility:Tween(selectedTab, {BackgroundColor3 = options.Theme.TabBackground}, 0.2)
                utility:Tween(selectedTab, {TextColor3 = options.Theme.Text}, 0.2)
                TabContent.Visible = true
            end
        end)
        
        -- Add to tabs table
        table.insert(tabs, {Button = TabButton, Content = TabContent})
        
        -- Smooth scrolling for tab content
        utility:SmoothScroll(TabContent, 0.2)
        
        -- Element Creation Functions
        function TabInfo:CreateSection(sectionTitle)
            local SectionInfo = {}
            
            -- Create Section Frame
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = sectionTitle .. "Section"
            SectionFrame.Size = UDim2.new(1, 0, 0, 36)
            SectionFrame.BackgroundTransparency = 1
            SectionFrame.BorderSizePixel = 0
            SectionFrame.Parent = TabContent
            
            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Name = "SectionTitle"
            SectionTitle.Size = UDim2.new(1, 0, 0, 24)
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Font = library.Font
            SectionTitle.Text = sectionTitle
            SectionTitle.TextSize = 15
            SectionTitle.TextColor3 = options.Theme.Text
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Parent = SectionFrame
            
            local SectionDivider = Instance.new("Frame")
            SectionDivider.Name = "SectionDivider"
            SectionDivider.Position = UDim2.new(0, 0, 0, 28)
            SectionDivider.Size = UDim2.new(1, 0, 0, 1)
            SectionDivider.BackgroundColor3 = options.Theme.DarkerText
            SectionDivider.BorderSizePixel = 0
            SectionDivider.Transparency = 0.5
            SectionDivider.Parent = SectionFrame
            
            return SectionInfo
        end
        
        function TabInfo:CreateLabel(labelText)
            local LabelInfo = {}
            
            -- Create Label
            local LabelFrame = Instance.new("Frame")
            LabelFrame.Name = "LabelFrame"
            LabelFrame.Size = UDim2.new(1, 0, 0, 24)
            LabelFrame.BackgroundTransparency = 1
            LabelFrame.BorderSizePixel = 0
            LabelFrame.Parent = TabContent
            
            local LabelTextLabel = Instance.new("TextLabel")
            LabelTextLabel.Name = "LabelText"
            LabelTextLabel.Size = UDim2.new(1, 0, 1, 0)
            LabelTextLabel.BackgroundTransparency = 1
            LabelTextLabel.Font = library.Font
            LabelTextLabel.Text = labelText
            LabelTextLabel.TextSize = 14
            LabelTextLabel.TextColor3 = options.Theme.DarkText
            LabelTextLabel.TextXAlignment = Enum.TextXAlignment.Left
            LabelTextLabel.Parent = LabelFrame
            
            function LabelInfo:Update(newText)
                LabelTextLabel.Text = newText
            end
            
            return LabelInfo
        end
        
        function TabInfo:CreateButton(buttonText, callback)
            callback = callback or function() end
            
            -- Create Button
            local ButtonFrame = Instance.new("Frame")
            ButtonFrame.Name = "ButtonFrame"
            ButtonFrame.Size = UDim2.new(1, 0, 0, 34)
            ButtonFrame.BackgroundTransparency = 1
            ButtonFrame.BorderSizePixel = 0
            ButtonFrame.Parent = TabContent
            
            local Button = Instance.new("TextButton")
            Button.Name = "Button"
            Button.Size = UDim2.new(1, 0, 1, 0)
            Button.BackgroundColor3 = options.Theme.ElementBackground
            Button.BorderSizePixel = 0
            Button.Text = buttonText
            Button.Font = library.Font
            Button.TextSize = 14
            Button.TextColor3 = options.Theme.Text
            Button.ClipsDescendants = true
            Button.Parent = ButtonFrame
            
            local ButtonUICorner = Instance.new("UICorner")
            ButtonUICorner.CornerRadius = UDim.new(0, 4)
            ButtonUICorner.Parent = Button
            
            -- Button Functionality
            local Debounce = false
            
            Button.MouseButton1Click:Connect(function()
                if not Debounce then
                    Debounce = true
                    
                    -- Ripple effect
                    local Ripple = Instance.new("Frame")
                    Ripple.Name = "Ripple"
                    Ripple.Position = UDim2.new(0, Mouse.X - Button.AbsolutePosition.X, 0, Mouse.Y - Button.AbsolutePosition.Y)
                    Ripple.Size = UDim2.new(0, 0, 0, 0)
                    Ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Ripple.BackgroundTransparency = 0.7
                    Ripple.BorderSizePixel = 0
                    Ripple.ZIndex = 10
                    Ripple.Parent = Button
                    
                    local RippleUICorner = Instance.new("UICorner")
                    RippleUICorner.CornerRadius = UDim.new(1, 0)
                    RippleUICorner.Parent = Ripple
                    
                    utility:Tween(Ripple, {Size = UDim2.new(0, 500, 0, 500), Position = UDim2.new(0.5, -250, 0.5, -250)}, 0.5)
                    utility:Tween(Ripple, {BackgroundTransparency = 1}, 0.5)
                    
                    -- Button press effect
                    utility:Tween(Button, {BackgroundColor3 = utility:DarkenColor(options.Theme.ElementBackground, 0.1)}, 0.2)
                    task.wait(0.2)
                    utility:Tween(Button, {BackgroundColor3 = options.Theme.ElementBackground}, 0.2)
                    
                    task.spawn(function()
                        callback()
                    end)
                    
                    task.wait(0.5)
                    Ripple:Destroy()
                    Debounce = false
                end
            end)
            
            -- Button hover effect
            Button.MouseEnter:Connect(function()
                utility:Tween(Button, {BackgroundColor3 = utility:LightenColor(options.Theme.ElementBackground, 0.05)}, 0.2)
            end)
            
            Button.MouseLeave:Connect(function()
                utility:Tween(Button, {BackgroundColor3 = options.Theme.ElementBackground}, 0.2)
            end)
            
            local ButtonInfo = {}
            
            function ButtonInfo:Update(newText)
                Button.Text = newText
            end
            
            return ButtonInfo
        end
        
        function TabInfo:CreateToggle(toggleText, default, callback)
            default = default or false
            callback = callback or function() end
            
            -- Create Toggle
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = "ToggleFrame"
            ToggleFrame.Size = UDim2.new(1, 0, 0, 34)
            ToggleFrame.BackgroundTransparency = 1
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Parent = TabContent
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Name = "ToggleButton"
            ToggleButton.Size = UDim2.new(1, 0, 1, 0)
            ToggleButton.BackgroundColor3 = options.Theme.ElementBackground
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Text = ""
            ToggleButton.Font = library.Font
            ToggleButton.TextSize = 14
            ToggleButton.TextColor3 = options.Theme.Text
            ToggleButton.ClipsDescendants = true
            ToggleButton.Parent = ToggleFrame
            
            local ToggleUICorner = Instance.new("UICorner")
            ToggleUICorner.CornerRadius = UDim.new(0, 4)
            ToggleUICorner.Parent = ToggleButton
            
            local ToggleTitle = Instance.new("TextLabel")
            ToggleTitle.Name = "ToggleTitle"
            ToggleTitle.Position = UDim2.new(0, 10, 0, 0)
            ToggleTitle.Size = UDim2.new(1, -60, 1, 0)
            ToggleTitle.BackgroundTransparency = 1
            ToggleTitle.Font = library.Font
            ToggleTitle.Text = toggleText
            ToggleTitle.TextSize = 14
            ToggleTitle.TextColor3 = options.Theme.Text
            ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
            ToggleTitle.Parent = ToggleButton
            
            local ToggleIndicator = Instance.new("Frame")
            ToggleIndicator.Name = "ToggleIndicator"
            ToggleIndicator.Position = UDim2.new(1, -50, 0.5, -10)
            ToggleIndicator.Size = UDim2.new(0, 40, 0, 20)
            ToggleIndicator.BackgroundColor3 = default and options.Theme.Accent or options.Theme.DarkerText
            ToggleIndicator.BorderSizePixel = 0
            ToggleIndicator.Parent = ToggleButton
            
            local ToggleIndicatorUICorner = Instance.new("UICorner")
            ToggleIndicatorUICorner.CornerRadius = UDim.new(1, 0)
            ToggleIndicatorUICorner.Parent = ToggleIndicator
            
            local ToggleCircle = Instance.new("Frame")
            ToggleCircle.Name = "ToggleCircle"
            ToggleCircle.Position = UDim2.new(default and 1 or 0, default and -18 or 2, 0.5, -8)
            ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
            ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleCircle.BorderSizePixel = 0
            ToggleCircle.Parent = ToggleIndicator
            
            local ToggleCircleUICorner = Instance.new("UICorner")
            ToggleCircleUICorner.CornerRadius = UDim.new(1, 0)
            ToggleCircleUICorner.Parent = ToggleCircle
            
            -- Toggle Functionality
            local Toggled = default
            
            -- Initial callback
            task.spawn(function()
                callback(Toggled)
            end)
            
            ToggleButton.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                
                utility:Tween(ToggleIndicator, {BackgroundColor3 = Toggled and options.Theme.Accent or options.Theme.DarkerText}, 0.2)
                utility:Tween(ToggleCircle, {Position = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}, 0.2)
                
                -- Ripple effect
                local Ripple = Instance.new("Frame")
                Ripple.Name = "Ripple"
                Ripple.Position = UDim2.new(0, Mouse.X - ToggleButton.AbsolutePosition.X, 0, Mouse.Y - ToggleButton.AbsolutePosition.Y)
                Ripple.Size = UDim2.new(0, 0, 0, 0)
                Ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Ripple.BackgroundTransparency = 0.7
                Ripple.BorderSizePixel = 0
                Ripple.ZIndex = 10
                Ripple.Parent = ToggleButton
                
                local RippleUICorner = Instance.new("UICorner")
                RippleUICorner.CornerRadius = UDim.new(1, 0)
                RippleUICorner.Parent = Ripple
                
                utility:Tween(Ripple, {Size = UDim2.new(0, 500, 0, 500), Position = UDim2.new(0.5, -250, 0.5, -250)}, 0.5)
                utility:Tween(Ripple, {BackgroundTransparency = 1}, 0.5)
                
                task.spawn(function()
                    callback(Toggled)
                end)
                
                task.delay(0.5, function()
                    Ripple:Destroy()
                end)
            end)
            
            -- Toggle hover effect
            ToggleButton.MouseEnter:Connect(function()
                utility:Tween(ToggleButton, {BackgroundColor3 = utility:LightenColor(options.Theme.ElementBackground, 0.05)}, 0.2)
            end)
            
            ToggleButton.MouseLeave:Connect(function()
                utility:Tween(ToggleButton, {BackgroundColor3 = options.Theme.ElementBackground}, 0.2)
            end)
            
            local ToggleInfo = {}
            
            function ToggleInfo:Update(newValue)
                Toggled = newValue
                utility:Tween(ToggleIndicator, {BackgroundColor3 = Toggled and options.Theme.Accent or options.Theme.DarkerText}, 0.2)
                utility:Tween(ToggleCircle, {Position = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}, 0.2)
                
                task.spawn(function()
                    callback(Toggled)
                end)
            end
            
            function ToggleInfo:Get()
                return Toggled
            end
            
            return ToggleInfo
        end
        
        function TabInfo:CreateSlider(sliderText, options, callback)
            options = options or {}
            options.Min = options.Min or 0
            options.Max = options.Max or 100
            options.Default = options.Default or options.Min
            options.Increment = options.Increment or 1
            options.Suffix = options.Suffix or ""
            callback = callback or function() end
            
            -- Create Slider
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = "SliderFrame"
            SliderFrame.Size = UDim2.new(1, 0, 0, 50)
            SliderFrame.BackgroundTransparency = 1
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Parent = TabContent
            
            local SliderTitle = Instance.new("TextLabel")
            SliderTitle.Name = "SliderTitle"
            SliderTitle.Position = UDim2.new(0, 0, 0, 0)
            SliderTitle.Size = UDim2.new(1, 0, 0, 20)
            SliderTitle.BackgroundTransparency = 1
            SliderTitle.Font = library.Font
            SliderTitle.Text = sliderText
            SliderTitle.TextSize = 14
            SliderTitle.TextColor3 = options.Theme.Text
            SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
            SliderTitle.Parent = SliderFrame
            
            local SliderBackground = Instance.new("Frame")
            SliderBackground.Name = "SliderBackground"
            SliderBackground.Position = UDim2.new(0, 0, 0, 25)
            SliderBackground.Size = UDim2.new(1, 0, 0, 10)
            SliderBackground.BackgroundColor3 = options.Theme.ElementBackground
            SliderBackground.BorderSizePixel = 0
            SliderBackground.Parent = SliderFrame
            
            local SliderBackgroundUICorner = Instance.new("UICorner")
            SliderBackgroundUICorner.CornerRadius = UDim.new(0, 4)
            SliderBackgroundUICorner.Parent = SliderBackground
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Name = "SliderFill"
            SliderFill.Size = UDim2.new(0, 0, 1, 0)
            SliderFill.BackgroundColor3 = options.Theme.Accent
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderBackground
            
            local SliderFillUICorner = Instance.new("UICorner")
            SliderFillUICorner.CornerRadius = UDim.new(0, 4)
            SliderFillUICorner.Parent = SliderFill
            
            local SliderCircle = Instance.new("Frame")
            SliderCircle.Name = "SliderCircle"
            SliderCircle.Position = UDim2.new(0, -5, 0.5, -5)
            SliderCircle.Size = UDim2.new(0, 10, 0, 10)
            SliderCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SliderCircle.BorderSizePixel = 0
            SliderCircle.ZIndex = 2
            SliderCircle.Parent = SliderFill
            
            local SliderCircleUICorner = Instance.new("UICorner")
            SliderCircleUICorner.CornerRadius = UDim.new(1, 0)
            SliderCircleUICorner.Parent = SliderCircle
            
            local SliderValue = Instance.new("TextLabel")
            SliderValue.Name = "SliderValue"
            SliderValue.Position = UDim2.new(1, -50, 0, 0)
            SliderValue.Size = UDim2.new(0, 50, 0, 20)
            SliderValue.BackgroundTransparency = 1
            SliderValue.Font = library.Font
            SliderValue.Text = options.Default .. options.Suffix
            SliderValue.TextSize = 14
            SliderValue.TextColor3 = options.Theme.DarkText
            SliderValue.TextXAlignment = Enum.TextXAlignment.Right
            SliderValue.Parent = SliderFrame
            
            -- Slider Functionality
            local Value = options.Default
            local Dragging = false
            
            -- Update slider visuals
            local function updateSlider(value)
                Value = value
                local Percent = (Value - options.Min) / (options.Max - options.Min)
                SliderFill.Size = UDim2.new(Percent, 0, 1, 0)
                SliderValue.Text = Value .. options.Suffix
                
                task.spawn(function()
                    callback(Value)
                end)
            end
            
            -- Initial update
            updateSlider(options.Default)
            
            -- Handle slider input
            SliderBackground.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true
                    
                    -- Calculate value from mouse position
                    local Percent = math.clamp((input.Position.X - SliderBackground.AbsolutePosition.X) / SliderBackground.AbsoluteSize.X, 0, 1)
                    local NewValue = options.Min + (options.Max - options.Min) * Percent
                    
                    -- Apply increment
                    NewValue = math.floor(NewValue / options.Increment + 0.5) * options.Increment
                    NewValue = math.clamp(NewValue, options.Min, options.Max)
                    
                    updateSlider(NewValue)
                end
            end)
            
            SliderBackground.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    -- Calculate value from mouse position
                    local Percent = math.clamp((input.Position.X - SliderBackground.AbsolutePosition.X) / SliderBackground.AbsoluteSize.X, 0, 1)
                    local NewValue = options.Min + (options.Max - options.Min) * Percent
                    
                    -- Apply increment
                    NewValue = math.floor(NewValue / options.Increment + 0.5) * options.Increment
                    NewValue = math.clamp(NewValue, options.Min, options.Max)
                    
                    updateSlider(NewValue)
                end
            end)
            
            local SliderInfo = {}
            
            function SliderInfo:Update(newValue)
                newValue = math.clamp(newValue, options.Min, options.Max)
                updateSlider(newValue)
            end
            
            function SliderInfo:Get()
                return Value
            end
            
            return SliderInfo
        end
        
        function TabInfo:CreateDropdown(dropdownText, items, default, callback)
            items = items or {}
            default = default or ""
            callback = callback or function() end
            
            -- Create Dropdown
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Name = "DropdownFrame"
            DropdownFrame.Size = UDim2.new(1, 0, 0, 40)
            DropdownFrame.BackgroundTransparency = 1
            DropdownFrame.BorderSizePixel = 0
            DropdownFrame.ClipsDescendants = true
            DropdownFrame.Parent = TabContent
            
            local DropdownTitle = Instance.new("TextLabel")
            DropdownTitle.Name = "DropdownTitle"
            DropdownTitle.Position = UDim2.new(0, 0, 0, 0)
            DropdownTitle.Size = UDim2.new(1, 0, 0, 20)
            DropdownTitle.BackgroundTransparency = 1
            DropdownTitle.Font = library.Font
            DropdownTitle.Text = dropdownText
            DropdownTitle.TextSize = 14
            DropdownTitle.TextColor3 = options.Theme.Text
            DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
            DropdownTitle.Parent = DropdownFrame
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Name = "DropdownButton"
            DropdownButton.Position = UDim2.new(0, 0, 0, 20)
            DropdownButton.Size = UDim2.new(1, 0, 0, 30)
            DropdownButton.BackgroundColor3 = options.Theme.ElementBackground
            DropdownButton.BorderSizePixel = 0
            DropdownButton.Font = library.Font
            DropdownButton.Text = default ~= "" and default or "Select..."
            DropdownButton.TextSize = 14
            DropdownButton.TextColor3 = options.Theme.Text
            DropdownButton.Parent = DropdownFrame
            
            local DropdownButtonUICorner = Instance.new("UICorner")
            DropdownButtonUICorner.CornerRadius = UDim.new(0, 4)
            DropdownButtonUICorner.Parent = DropdownButton
            
            local DropdownIcon = Instance.new("ImageLabel")
            DropdownIcon.Name = "DropdownIcon"
            DropdownIcon.Position = UDim2.new(1, -25, 0.5, -8)
            DropdownIcon.Size = UDim2.new(0, 16, 0, 16)
            DropdownIcon.BackgroundTransparency = 1
            DropdownIcon.Image = "rbxassetid://8553913103"
            DropdownIcon.ImageColor3 = options.Theme.Text
            DropdownIcon.Parent = DropdownButton
            
            local DropdownContent = Instance.new("Frame")
            DropdownContent.Name = "DropdownContent"
            DropdownContent.Position = UDim2.new(0, 0, 0, 55)
            DropdownContent.Size = UDim2.new(1, 0, 0, 0) -- Will be adjusted based on items
            DropdownContent.BackgroundColor3 = options.Theme.ElementBackground
            DropdownContent.BorderSizePixel = 0
            DropdownContent.Visible = false
            DropdownContent.ZIndex = 5
            DropdownContent.Parent = DropdownFrame
            
            local DropdownContentUICorner = Instance.new("UICorner")
            DropdownContentUICorner.CornerRadius = UDim.new(0, 4)
            DropdownContentUICorner.Parent = DropdownContent
            
            local DropdownItemsList = Instance.new("UIListLayout")
            DropdownItemsList.Name = "DropdownItemsList"
            DropdownItemsList.SortOrder = Enum.SortOrder.LayoutOrder
            DropdownItemsList.Padding = UDim.new(0, 5)
            DropdownItemsList.Parent = DropdownContent
            
            local DropdownPadding = Instance.new("UIPadding")
            DropdownPadding.PaddingTop = UDim.new(0, 5)
            DropdownPadding.PaddingBottom = UDim.new(0, 5)
            DropdownPadding.PaddingLeft = UDim.new(0, 5)
            DropdownPadding.PaddingRight = UDim.new(0, 5)
            DropdownPadding.Parent = DropdownContent
            
            -- Add dropdown items
            for _, item in ipairs(items) do
                local ItemButton = Instance.new("TextButton")
                ItemButton.Name = item .. "Item"
                ItemButton.Size = UDim2.new(1, 0, 0, 25)
                ItemButton.BackgroundColor3 = options.Theme.Secondary
                ItemButton.BorderSizePixel = 0
                ItemButton.Text = item
                ItemButton.Font = library.Font
                ItemButton.TextSize = 14
                ItemButton.TextColor3 = options.Theme.Text
                ItemButton.ZIndex = 6
                ItemButton.Parent = DropdownContent
                
                local ItemButtonUICorner = Instance.new("UICorner")
                ItemButtonUICorner.CornerRadius = UDim.new(0, 4)
                ItemButtonUICorner.Parent = ItemButton
                
                -- Item selection
                ItemButton.MouseButton1Click:Connect(function()
                    DropdownButton.Text = item
                    task.spawn(function()
                        callback(item)
                    end)
                    
                    -- Close dropdown
                    utility:Tween(DropdownIcon, {Rotation = 0}, 0.2)
                    utility:Tween(DropdownContent, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                    DropdownContent.Visible = false
                    utility:Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 50)}, 0.2)
                end)
                
                -- Hover effect
                ItemButton.MouseEnter:Connect(function()
                    utility:Tween(ItemButton, {BackgroundColor3 = utility:LightenColor(options.Theme.Secondary, 0.05)}, 0.2)
                end)
                
                ItemButton.MouseLeave:Connect(function()
                    utility:Tween(ItemButton, {BackgroundColor3 = options.Theme.Secondary}, 0.2)
                end)
            end
            
            -- Calculate content size
            local ContentSize = (#items * 25) + ((#items + 1) * 5)
            
            -- Dropdown functionality
            local Opened = false
            
            DropdownButton.MouseButton1Click:Connect(function()
                Opened = not Opened
                
                if Opened then
                    utility:Tween(DropdownIcon, {Rotation = 180}, 0.2)
                    utility:Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 55 + ContentSize)}, 0.2)
                    DropdownContent.Visible = true
                    utility:Tween(DropdownContent, {Size = UDim2.new(1, 0, 0, ContentSize)}, 0.2)
                else
                    utility:Tween(DropdownIcon, {Rotation = 0}, 0.2)
                    utility:Tween(DropdownContent, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                    DropdownContent.Visible = false
                    utility:Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 50)}, 0.2)
                end
            end)
            
            -- Dropdown hover effect
            DropdownButton.MouseEnter:Connect(function()
                utility:Tween(DropdownButton, {BackgroundColor3 = utility:LightenColor(options.Theme.ElementBackground, 0.05)}, 0.2)
            end)
            
            DropdownButton.MouseLeave:Connect(function()
                utility:Tween(DropdownButton, {BackgroundColor3 = options.Theme.ElementBackground}, 0.2)
            end)
            
            -- Apply default value
            if default ~= "" then
                task.spawn(function()
                    callback(default)
                end)
            end
            
            local DropdownInfo = {}
            
            function DropdownInfo:Update(newItems)
                -- Clear existing items
                for _, child in pairs(DropdownContent:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end
                
                -- Add new items
                for _, item in ipairs(newItems) do
                    local ItemButton = Instance.new("TextButton")
                    ItemButton.Name = item .. "Item"
                    ItemButton.Size = UDim2.new(1, 0, 0, 25)
                    ItemButton.BackgroundColor3 = options.Theme.Secondary
                    ItemButton.BorderSizePixel = 0
                    ItemButton.Text = item
                    ItemButton.Font = library.Font
                    ItemButton.TextSize = 14
                    ItemButton.TextColor3 = options.Theme.Text
                    ItemButton.ZIndex = 6
                    ItemButton.Parent = DropdownContent
                    
                    local ItemButtonUICorner = Instance.new("UICorner")
                    ItemButtonUICorner.CornerRadius = UDim.new(0, 4)
                    ItemButtonUICorner.Parent = ItemButton
                    
                    -- Item selection
                    ItemButton.MouseButton1Click:Connect(function()
                        DropdownButton.Text = item
                        task.spawn(function()
                            callback(item)
                        end)
                        
                        -- Close dropdown
                        utility:Tween(DropdownIcon, {Rotation = 0}, 0.2)
                        utility:Tween(DropdownContent, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                        DropdownContent.Visible = false
                        utility:Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 50)}, 0.2)
                        Opened = false
                    end)
                    
                    -- Hover effect
                    ItemButton.MouseEnter:Connect(function()
                        utility:Tween(ItemButton, {BackgroundColor3 = utility:LightenColor(options.Theme.Secondary, 0.05)}, 0.2)
                    end)
                    
                    ItemButton.MouseLeave:Connect(function()
                        utility:Tween(ItemButton, {BackgroundColor3 = options.Theme.Secondary}, 0.2)
                    end)
                end
                
                -- Update content size
                ContentSize = (#newItems * 25) + ((#newItems + 1) * 5)
                
                -- Update dropdown size if open
                if Opened then
                    utility:Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 55 + ContentSize)}, 0.2)
                    utility:Tween(DropdownContent, {Size = UDim2.new(1, 0, 0, ContentSize)}, 0.2)
                end
            end
            
            function DropdownInfo:Set(item)
                DropdownButton.Text = item
                task.spawn(function()
                    callback(item)
                end)
            end
            
            function DropdownInfo:Get()
                return DropdownButton.Text
            end
            
            return DropdownInfo
        end
        
        function TabInfo:CreateTextbox(textboxText, placeholder, callback)
            placeholder = placeholder or ""
            callback = callback or function() end
            
            -- Create Textbox
            local TextboxFrame = Instance.new("Frame")
            TextboxFrame.Name = "TextboxFrame"
            TextboxFrame.Size = UDim2.new(1, 0, 0, 50)
            TextboxFrame.BackgroundTransparency = 1
            TextboxFrame.BorderSizePixel = 0
            TextboxFrame.Parent = TabContent
            
            local TextboxTitle = Instance.new("TextLabel")
            TextboxTitle.Name = "TextboxTitle"
            TextboxTitle.Position = UDim2.new(0, 0, 0, 0)
            TextboxTitle.Size = UDim2.new(1, 0, 0, 20)
            TextboxTitle.BackgroundTransparency = 1
            TextboxTitle.Font = library.Font
            TextboxTitle.Text = textboxText
            TextboxTitle.TextSize = 14
            TextboxTitle.TextColor3 = options.Theme.Text
            TextboxTitle.TextXAlignment = Enum.TextXAlignment.Left
            TextboxTitle.Parent = TextboxFrame
            
            local TextboxContainer = Instance.new("Frame")
            TextboxContainer.Name = "TextboxContainer"
            TextboxContainer.Position = UDim2.new(0, 0, 0, 20)
            TextboxContainer.Size = UDim2.new(1, 0, 0, 30)
            TextboxContainer.BackgroundColor3 = options.Theme.ElementBackground
            TextboxContainer.BorderSizePixel = 0
            TextboxContainer.Parent = TextboxFrame
            
            local TextboxContainerUICorner = Instance.new("UICorner")
            TextboxContainerUICorner.CornerRadius = UDim.new(0, 4)
            TextboxContainerUICorner.Parent = TextboxContainer
            
            local Textbox = Instance.new("TextBox")
            Textbox.Name = "Textbox"
            Textbox.Position = UDim2.new(0, 10, 0, 0)
            Textbox.Size = UDim2.new(1, -20, 1, 0)
            Textbox.BackgroundTransparency = 1
            Textbox.Font = library.Font
            Textbox.PlaceholderText = placeholder
            Textbox.Text = ""
            Textbox.TextSize = 14
            Textbox.TextColor3 = options.Theme.Text
            Textbox.PlaceholderColor3 = options.Theme.DarkText
            Textbox.TextXAlignment = Enum.TextXAlignment.Left
            Textbox.Parent = TextboxContainer
            
            -- Textbox Functionality
            Textbox.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    task.spawn(function()
                        callback(Textbox.Text)
                    end)
                end
            end)
            
            -- Textbox hover effect
            TextboxContainer.MouseEnter:Connect(function()
                utility:Tween(TextboxContainer, {BackgroundColor3 = utility:LightenColor(options.Theme.ElementBackground, 0.05)}, 0.2)
            end)
            
            TextboxContainer.MouseLeave:Connect(function()
                utility:Tween(TextboxContainer, {BackgroundColor3 = options.Theme.ElementBackground}, 0.2)
            end)
            
            local TextboxInfo = {}
            
            function TextboxInfo:Update(newText)
                Textbox.Text = newText
            end
            
            function TextboxInfo:Get()
                return Textbox.Text
            end
            
            return TextboxInfo
        end
        
        function TabInfo:CreateColorPicker(colorPickerText, default, callback)
            default = default or Color3.fromRGB(255, 255, 255)
            callback = callback or function() end
            
            -- Create ColorPicker
            local ColorPickerFrame = Instance.new("Frame")
            ColorPickerFrame.Name = "ColorPickerFrame"
            ColorPickerFrame.Size = UDim2.new(1, 0, 0, 50)
            ColorPickerFrame.BackgroundTransparency = 1
            ColorPickerFrame.BorderSizePixel = 0
            ColorPickerFrame.ClipsDescendants = true
            ColorPickerFrame.Parent = TabContent
            
            local ColorPickerTitle = Instance.new("TextLabel")
            ColorPickerTitle.Name = "ColorPickerTitle"
            ColorPickerTitle.Position = UDim2.new(0, 0, 0, 0)
            ColorPickerTitle.Size = UDim2.new(1, -30, 0, 20)
            ColorPickerTitle.BackgroundTransparency = 1
            ColorPickerTitle.Font = library.Font
            ColorPickerTitle.Text = colorPickerText
            ColorPickerTitle.TextSize = 14
            ColorPickerTitle.TextColor3 = options.Theme.Text
            ColorPickerTitle.TextXAlignment = Enum.TextXAlignment.Left
            ColorPickerTitle.Parent = ColorPickerFrame
            
            local ColorPickerButton = Instance.new("TextButton")
            ColorPickerButton.Name = "ColorPickerButton"
            ColorPickerButton.Position = UDim2.new(0, 0, 0, 20)
            ColorPickerButton.Size = UDim2.new(1, 0, 0, 30)
            ColorPickerButton.BackgroundColor3 = options.Theme.ElementBackground
            ColorPickerButton.BorderSizePixel = 0
            ColorPickerButton.Text = ""
            ColorPickerButton.Parent = ColorPickerFrame
            
            local ColorPickerButtonUICorner = Instance.new("UICorner")
            ColorPickerButtonUICorner.CornerRadius = UDim.new(0, 4)
            ColorPickerButtonUICorner.Parent = ColorPickerButton
            
            local ColorDisplay = Instance.new("Frame")
            ColorDisplay.Name = "ColorDisplay"
            ColorDisplay.Position = UDim2.new(1, -40, 0.5, -10)
            ColorDisplay.Size = UDim2.new(0, 30, 0, 20)
            ColorDisplay.BackgroundColor3 = default
            ColorDisplay.BorderSizePixel = 0
            ColorDisplay.Parent = ColorPickerButton
            
            local ColorDisplayUICorner = Instance.new("UICorner")
            ColorDisplayUICorner.CornerRadius = UDim.new(0, 4)
            ColorDisplayUICorner.Parent = ColorDisplay
            
            local ColorPickerPopup = Instance.new("Frame")
            ColorPickerPopup.Name = "ColorPickerPopup"
            ColorPickerPopup.Position = UDim2.new(0, 0, 0, 55)
            ColorPickerPopup.Size = UDim2.new(1, 0, 0, 0) -- Will be expanded when opened
            ColorPickerPopup.BackgroundColor3 = options.Theme.ElementBackground
            ColorPickerPopup.BorderSizePixel = 0
            ColorPickerPopup.Visible = false
            ColorPickerPopup.ZIndex = 10
            ColorPickerPopup.Parent = ColorPickerFrame
            
            local ColorPickerPopupUICorner = Instance.new("UICorner")
            ColorPickerPopupUICorner.CornerRadius = UDim.new(0, 4)
            ColorPickerPopupUICorner.Parent = ColorPickerPopup
            
            -- Color Picker Components
            local ColorPickerArea = Instance.new("ImageButton")
            ColorPickerArea.Name = "ColorPickerArea"
            ColorPickerArea.Position = UDim2.new(0, 10, 0, 10)
            ColorPickerArea.Size = UDim2.new(1, -20, 0, 150)
            ColorPickerArea.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            ColorPickerArea.BorderSizePixel = 0
            ColorPickerArea.ZIndex = 11
            ColorPickerArea.Image = "rbxassetid://4155801252"
            ColorPickerArea.Parent = ColorPickerPopup
            
            local ColorPickerAreaUICorner = Instance.new("UICorner")
            ColorPickerAreaUICorner.CornerRadius = UDim.new(0, 4)
            ColorPickerAreaUICorner.Parent = ColorPickerArea
            
            local ColorPickerSelector = Instance.new("Frame")
            ColorPickerSelector.Name = "ColorPickerSelector"
            ColorPickerSelector.Size = UDim2.new(0, 10, 0, 10)
            ColorPickerSelector.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ColorPickerSelector.BorderSizePixel = 0
            ColorPickerSelector.ZIndex = 12
            ColorPickerSelector.Parent = ColorPickerArea
            
            local ColorPickerSelectorUICorner = Instance.new("UICorner")
            ColorPickerSelectorUICorner.CornerRadius = UDim.new(1, 0)
            ColorPickerSelectorUICorner.Parent = ColorPickerSelector
            
            local HueSlider = Instance.new("Frame")
            HueSlider.Name = "HueSlider"
            HueSlider.Position = UDim2.new(0, 10, 0, 170)
            HueSlider.Size = UDim2.new(1, -20, 0, 20)
            HueSlider.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            HueSlider.BorderSizePixel = 0
            HueSlider.ZIndex = 11
            HueSlider.Parent = ColorPickerPopup
            
            local HueSliderUICorner = Instance.new("UICorner")
            HueSliderUICorner.CornerRadius = UDim.new(0, 4)
            HueSliderUICorner.Parent = HueSlider
            
            local HueSliderGradient = Instance.new("UIGradient")
            HueSliderGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
                ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
                ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
            })
            HueSliderGradient.Parent = HueSlider
            
            local HueSliderButton = Instance.new("TextButton")
            HueSliderButton.Name = "HueSliderButton"
            HueSliderButton.Size = UDim2.new(1, 0, 1, 0)
            HueSliderButton.BackgroundTransparency = 1
            HueSliderButton.Text = ""
            HueSliderButton.ZIndex = 12
            HueSliderButton.Parent = HueSlider
            
            local HueSliderSelector = Instance.new("Frame")
            HueSliderSelector.Name = "HueSliderSelector"
            HueSliderSelector.Position = UDim2.new(0, -2, 0, -2)
            HueSliderSelector.Size = UDim2.new(0, 4, 1, 4)
            HueSliderSelector.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            HueSliderSelector.BorderSizePixel = 0
            HueSliderSelector.ZIndex = 13
            HueSliderSelector.Parent = HueSliderButton
            
            local HueSliderSelectorUICorner = Instance.new("UICorner")
            HueSliderSelectorUICorner.CornerRadius = UDim.new(0, 2)
            HueSliderSelectorUICorner.Parent = HueSliderSelector
            
            local RGBInfo = Instance.new("Frame")
            RGBInfo.Name = "RGBInfo"
            RGBInfo.Position = UDim2.new(0, 10, 0, 200)
            RGBInfo.Size = UDim2.new(1, -20, 0, 25)
            RGBInfo.BackgroundTransparency = 1
            RGBInfo.BorderSizePixel = 0
            RGBInfo.ZIndex = 11
            RGBInfo.Parent = ColorPickerPopup
            
            local RLabel = Instance.new("TextLabel")
            RLabel.Name = "RLabel"
            RLabel.Position = UDim2.new(0, 0, 0, 0)
            RLabel.Size = UDim2.new(0, 30, 1, 0)
            RLabel.BackgroundTransparency = 1
            RLabel.Font = library.Font
            RLabel.Text = "R:"
            RLabel.TextSize = 14
            RLabel.TextColor3 = options.Theme.Text
            RLabel.ZIndex = 11
            RLabel.Parent = RGBInfo
            
            local RValue = Instance.new("TextBox")
            RValue.Name = "RValue"
            RValue.Position = UDim2.new(0, 30, 0, 0)
            RValue.Size = UDim2.new(0, 40, 1, 0)
            RValue.BackgroundColor3 = options.Theme.Secondary
            RValue.BorderSizePixel = 0
            RValue.Font = library.Font
            RValue.Text = tostring(math.floor(default.R * 255))
            RValue.TextSize = 14
            RValue.TextColor3 = options.Theme.Text
            RValue.ZIndex = 11
            RValue.Parent = RGBInfo
            
            local RValueUICorner = Instance.new("UICorner")
            RValueUICorner.CornerRadius = UDim.new(0, 4)
            RValueUICorner.Parent = RValue
            
            local GLabel = Instance.new("TextLabel")
            GLabel.Name = "GLabel"
            GLabel.Position = UDim2.new(0, 80, 0, 0)
            GLabel.Size = UDim2.new(0, 30, 1, 0)
            GLabel.BackgroundTransparency = 1
            GLabel.Font = library.Font
            GLabel.Text = "G:"
            GLabel.TextSize = 14
            GLabel.TextColor3 = options.Theme.Text
            GLabel.ZIndex = 11
            GLabel.Parent = RGBInfo
            
            local GValue = Instance.new("TextBox")
            GValue.Name = "GValue"
            GValue.Position = UDim2.new(0, 110, 0, 0)
            GValue.Size = UDim2.new(0, 40, 1, 0)
            GValue.BackgroundColor3 = options.Theme.Secondary
            GValue.BorderSizePixel = 0
            GValue.Font = library.Font
            GValue.Text = tostring(math.floor(default.G * 255))
            GValue.TextSize = 14
            GValue.TextColor3 = options.Theme.Text
            GValue.ZIndex = 11
            GValue.Parent = RGBInfo
            
            local GValueUICorner = Instance.new("UICorner")
            GValueUICorner.CornerRadius = UDim.new(0, 4)
            GValueUICorner.Parent = GValue
            
            local BLabel = Instance.new("TextLabel")
            BLabel.Name = "BLabel"
            BLabel.Position = UDim2.new(0, 160, 0, 0)
            BLabel.Size = UDim2.new(0, 30, 1, 0)
            BLabel.BackgroundTransparency = 1
            BLabel.Font = library.Font
            BLabel.Text = "B:"
            BLabel.TextSize = 14
            BLabel.TextColor3 = options.Theme.Text
            BLabel.ZIndex = 11
            BLabel.Parent = RGBInfo
            
            local BValue = Instance.new("TextBox")
            BValue.Name = "BValue"
            BValue.Position = UDim2.new(0, 190, 0, 0)
            BValue.Size = UDim2.new(0, 40, 1, 0)
            BValue.BackgroundColor3 = options.Theme.Secondary
            BValue.BorderSizePixel = 0
            BValue.Font = library.Font
            BValue.Text = tostring(math.floor(default.B * 255))
            BValue.TextSize = 14
            BValue.TextColor3 = options.Theme.Text
            BValue.ZIndex = 11
            BValue.Parent = RGBInfo
            
            local BValueUICorner = Instance.new("UICorner")
            BValueUICorner.CornerRadius = UDim.new(0, 4)
            BValueUICorner.Parent = BValue
            
            -- Color Picker Functionality
            local SelectedColor = default
            local H, S, V = Color3.toHSV(default)
            
            -- Update color display and invoke callback
            local function updateColor()
                SelectedColor = Color3.fromHSV(H, S, V)
                ColorDisplay.BackgroundColor3 = SelectedColor
                ColorPickerArea.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
                
                -- Update RGB values
                RValue.Text = tostring(math.floor(SelectedColor.R * 255))
                GValue.Text = tostring(math.floor(SelectedColor.G * 255))
                BValue.Text = tostring(math.floor(SelectedColor.B * 255))
                
                task.spawn(function()
                    callback(SelectedColor)
                end)
            end
            
            -- Initialize color picker
            updateColor()
            
            -- RGB input handling
            local function updateFromRGB()
                local r = tonumber(RValue.Text) or 0
                local g = tonumber(GValue.Text) or 0
                local b = tonumber(BValue.Text) or 0
                
                r = math.clamp(r, 0, 255) / 255
                g = math.clamp(g, 0, 255) / 255
                b = math.clamp(b, 0, 255) / 255
                
                SelectedColor = Color3.new(r, g, b)
                H, S, V = Color3.toHSV(SelectedColor)
                
                -- Update positions
                ColorPickerArea.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
                ColorPickerSelector.Position = UDim2.new(S, -5, 1 - V, -5)
                HueSliderSelector.Position = UDim2.new(H, -2, 0, -2)
                
                -- Update color display
                ColorDisplay.BackgroundColor3 = SelectedColor
                
                task.spawn(function()
                    callback(SelectedColor)
                end)
            end
            
            RValue.FocusLost:Connect(function()
                updateFromRGB()
            end)
            
            GValue.FocusLost:Connect(function()
                updateFromRGB()
            end)
            
            BValue.FocusLost:Connect(function()
                updateFromRGB()
            end)
            
            -- Color picker area dragging
            local draggingColorPicker = false
            
            ColorPickerArea.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingColorPicker = true
                    
                    -- Update color based on input position
                    local relativeX = math.clamp((input.Position.X - ColorPickerArea.AbsolutePosition.X) / ColorPickerArea.AbsoluteSize.X, 0, 1)
                    local relativeY = math.clamp((input.Position.Y - ColorPickerArea.AbsolutePosition.Y) / ColorPickerArea.AbsoluteSize.Y, 0, 1)
                    
                    S = relativeX
                    V = 1 - relativeY
                    
                    -- Update selector position
                    ColorPickerSelector.Position = UDim2.new(relativeX, -5, relativeY, -5)
                    
                    updateColor()
                end
            end)
            
            ColorPickerArea.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingColorPicker = false
                end
            end)
            
            -- Hue slider dragging
            local draggingHue = false
            
            HueSliderButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingHue = true
                    
                    -- Update hue based on input position
                    local relativeX = math.clamp((input.Position.X - HueSlider.AbsolutePosition.X) / HueSlider.AbsoluteSize.X, 0, 1)
                    
                    H = relativeX
                    
                    -- Update selector position
                    HueSliderSelector.Position = UDim2.new(relativeX, -2, 0, -2)
                    
                    updateColor()
                end
            end)
            
            HueSliderButton.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingHue = false
                end
            end)
            
            -- Input changed events for dragging
            UserInputService.InputChanged:Connect(function(input)
                if draggingColorPicker and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    -- Update color based on input position
                    local relativeX = math.clamp((input.Position.X - ColorPickerArea.AbsolutePosition.X) / ColorPickerArea.AbsoluteSize.X, 0, 1)
                    local relativeY = math.clamp((input.Position.Y - ColorPickerArea.AbsolutePosition.Y) / ColorPickerArea.AbsoluteSize.Y, 0, 1)
                    
                    S = relativeX
                    V = 1 - relativeY
                    
                    -- Update selector position
                    ColorPickerSelector.Position = UDim2.new(relativeX, -5, relativeY, -5)
                    
                    updateColor()
                elseif draggingHue and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    -- Update hue based on input position
                    local relativeX = math.clamp((input.Position.X - HueSlider.AbsolutePosition.X) / HueSlider.AbsoluteSize.X, 0, 1)
                    
                    H = relativeX
                    
                    -- Update selector position
                    HueSliderSelector.Position = UDim2.new(relativeX, -2, 0, -2)
                    
                    updateColor()
                end
            end)
            
            -- Toggle color picker popup
            local colorPickerOpen = false
            
            ColorPickerButton.MouseButton1Click:Connect(function()
                colorPickerOpen = not colorPickerOpen
                
                if colorPickerOpen then
                    -- Open color picker popup
                    ColorPickerPopup.Visible = true
                    utility:Tween(ColorPickerFrame, {Size = UDim2.new(1, 0, 0, 270)}, 0.3)
                    utility:Tween(ColorPickerPopup, {Size = UDim2.new(1, 0, 0, 240)}, 0.3)
                    
                    -- Position selector based on current color
                    local h, s, v = Color3.toHSV(SelectedColor)
                    H, S, V = h, s, v
                    
                    ColorPickerSelector.Position = UDim2.new(s, -5, 1 - v, -5)
                    HueSliderSelector.Position = UDim2.new(h, -2, 0, -2)
                    ColorPickerArea.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                else
                    -- Close color picker popup
                    utility:Tween(ColorPickerPopup, {Size = UDim2.new(1, 0, 0, 0)}, 0.3)
                    utility:Tween(ColorPickerFrame, {Size = UDim2.new(1, 0, 0, 50)}, 0.3)
                    task.wait(0.3)
                    ColorPickerPopup.Visible = false
                end
            end)
            
            -- Color picker button hover effect
            ColorPickerButton.MouseEnter:Connect(function()
                utility:Tween(ColorPickerButton, {BackgroundColor3 = utility:LightenColor(options.Theme.ElementBackground, 0.05)}, 0.2)
            end)
            
            ColorPickerButton.MouseLeave:Connect(function()
                utility:Tween(ColorPickerButton, {BackgroundColor3 = options.Theme.ElementBackground}, 0.2)
            end)
            
            local ColorPickerInfo = {}
            
            function ColorPickerInfo:Update(newColor)
                SelectedColor = newColor
                H, S, V = Color3.toHSV(newColor)
                
                -- Update positions
                ColorPickerArea.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
                ColorPickerSelector.Position = UDim2.new(S, -5, 1 - V, -5)
                HueSliderSelector.Position = UDim2.new(H, -2, 0, -2)
                
                -- Update color display
                ColorDisplay.BackgroundColor3 = newColor
                
                -- Update RGB values
                RValue.Text = tostring(math.floor(newColor.R * 255))
                GValue.Text = tostring(math.floor(newColor.G * 255))
                BValue.Text = tostring(math.floor(newColor.B * 255))
                
                task.spawn(function()
                    callback(newColor)
                end)
            end
            
            function ColorPickerInfo:Get()
                return SelectedColor
            end
            
            return ColorPickerInfo
        end
        
        -- Additional element functions can be added here
        
        return TabInfo
    end
    
    -- Initialize window
    if #Window == 0 then
        Window:CreateTab("Home") -- Create default tab if none exists
    end
    
    -- Add window to library windows table
    table.insert(library.Windows, Window)
    
    return Window
end

-- Helper functions for themes
function Frosty:SetTheme(theme)
    for _, property in pairs(theme) do
        library.Theme[property] = theme[property]
    end
    
    -- Update UI elements with new theme
    for _, window in ipairs(library.Windows) do
        -- Update window elements
    end
end

function Frosty:GetTheme()
    return library.Theme
end

return Frosty
