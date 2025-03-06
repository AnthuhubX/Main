local Frosty = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- UI Variables
Frosty.Windows = {}
Frosty.Theme = {
    BackgroundColor = Color3.fromRGB(25, 25, 30),
    TopbarColor = Color3.fromRGB(30, 30, 35),
    TextColor = Color3.fromRGB(255, 255, 255),
    AccentColor = Color3.fromRGB(90, 160, 255),
    DarkAccentColor = Color3.fromRGB(70, 125, 200),
    OutlineColor = Color3.fromRGB(40, 40, 45),
    SectionColor = Color3.fromRGB(30, 30, 35),
    ToggleBackgroundColor = Color3.fromRGB(35, 35, 40),
    DropdownBackgroundColor = Color3.fromRGB(35, 35, 40)
}

-- Utility Functions
local function CreateInstance(instanceType, properties)
    local instance = Instance.new(instanceType)
    for property, value in pairs(properties or {}) do
        instance[property] = value
    end
    return instance
end

local function MakeDraggable(topbarFrame, mainFrame)
    local dragging = false
    local dragInput
    local dragStart
    local startPos

    topbarFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    topbarFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local function CreateTween(instance, properties, duration, easingStyle, easingDirection)
    duration = duration or 0.3
    easingStyle = easingStyle or Enum.EasingStyle.Quad
    easingDirection = easingDirection or Enum.EasingDirection.Out
    
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(duration, easingStyle, easingDirection),
        properties
    )
    
    return tween
end

local function RippleEffect(button)
    local ripple = CreateInstance("Frame", {
        Name = "Ripple",
        Parent = button,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.8,
        BorderSizePixel = 0,
        Position = UDim2.new(0, Mouse.X - button.AbsolutePosition.X, 0, Mouse.Y - button.AbsolutePosition.Y),
        Size = UDim2.new(0, 0, 0, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = button.ZIndex + 1
    })
    
    local corner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = ripple
    })
    
    local targetSize = UDim2.new(0, button.AbsoluteSize.X * 2, 0, button.AbsoluteSize.X * 2)
    local growTween = CreateTween(ripple, {Size = targetSize, BackgroundTransparency = 1}, 0.5)
    growTween:Play()
    
    growTween.Completed:Connect(function()
        ripple:Destroy()
    end)
end

-- Core UI Functions
function Frosty:CreateWindow(config)
    config = config or {}
    local windowTitle = config.Title or "Frosty UI"
    local windowSize = config.Size or UDim2.new(0, 550, 0, 350)
    
    -- Create main GUI container
    local FrostyGUI = CreateInstance("ScreenGui", {
        Name = "Frosty_" .. HttpService:GenerateGUID(false),
        Parent = (RunService:IsStudio() and Player.PlayerGui) or CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    -- Create main window frame
    local MainFrame = CreateInstance("Frame", {
        Name = "MainFrame",
        Parent = FrostyGUI,
        BackgroundColor3 = Frosty.Theme.BackgroundColor,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -windowSize.X.Offset / 2, 0.5, -windowSize.Y.Offset / 2),
        Size = windowSize,
        ClipsDescendants = true
    })
    
    -- Add corner rounding
    local MainCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = MainFrame
    })
    
    -- Add shadow
    local Shadow = CreateInstance("ImageLabel", {
        Name = "Shadow",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, -15, 0, -15),
        Size = UDim2.new(1, 30, 1, 30),
        ZIndex = -1,
        Image = "rbxassetid://5554236805",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277)
    })
    
    -- Create top bar
    local TopBar = CreateInstance("Frame", {
        Name = "TopBar",
        Parent = MainFrame,
        BackgroundColor3 = Frosty.Theme.TopbarColor,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 30)
    })
    
    local TopBarCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = TopBar
    })
    
    -- Create top bar shadow
    local TopBarShadow = CreateInstance("Frame", {
        Name = "TopBarShadow",
        Parent = TopBar,
        BackgroundColor3 = Frosty.Theme.TopbarColor,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 1, -9),
        Size = UDim2.new(1, 0, 0, 9)
    })
    
    -- Create title
    local TitleLabel = CreateInstance("TextLabel", {
        Name = "TitleLabel",
        Parent = TopBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(0.5, 0, 1, 0),
        Font = Enum.Font.GothamSemibold,
        Text = windowTitle,
        TextColor3 = Frosty.Theme.TextColor,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Create logo
    local LogoLabel = CreateInstance("TextLabel", {
        Name = "LogoLabel",
        Parent = TopBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -55, 0, 0),
        Size = UDim2.new(0, 45, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = "Frosty",
        TextColor3 = Frosty.Theme.AccentColor,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Right
    })
    
    -- Create close button
    local CloseButton = CreateInstance("TextButton", {
        Name = "CloseButton",
        Parent = TopBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -25, 0, 0),
        Size = UDim2.new(0, 25, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = "×",
        TextColor3 = Frosty.Theme.TextColor,
        TextSize = 20
    })
    
    CloseButton.MouseButton1Click:Connect(function()
        FrostyGUI:Destroy()
    end)
    
    -- Make the window draggable
    MakeDraggable(TopBar, MainFrame)
    
    -- Create tab container
    local TabContainer = CreateInstance("Frame", {
        Name = "TabContainer",
        Parent = MainFrame,
        BackgroundColor3 = Frosty.Theme.SectionColor,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 10, 0, 40),
        Size = UDim2.new(0, 130, 1, -50)
    })
    
    local TabContainerCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = TabContainer
    })
    
    local TabScrollFrame = CreateInstance("ScrollingFrame", {
        Name = "TabScrollFrame",
        Parent = TabContainer,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 5),
        Size = UDim2.new(1, 0, 1, -10),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Frosty.Theme.AccentColor,
        VerticalScrollBarInset = Enum.ScrollBarInset.Always
    })
    
    local TabList = CreateInstance("UIListLayout", {
        Parent = TabScrollFrame,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    })
    
    local TabPadding = CreateInstance("UIPadding", {
        Parent = TabScrollFrame,
        PaddingLeft = UDim.new(0, 5),
        PaddingRight = UDim.new(0, 5),
        PaddingTop = UDim.new(0, 5),
        PaddingBottom = UDim.new(0, 5)
    })
    
    -- Create content container
    local ContentContainer = CreateInstance("Frame", {
        Name = "ContentContainer",
        Parent = MainFrame,
        BackgroundColor3 = Frosty.Theme.SectionColor,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 150, 0, 40),
        Size = UDim2.new(1, -160, 1, -50)
    })
    
    local ContentContainerCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = ContentContainer
    })
    
    -- Window functionality
    local Window = {}
    Window.Tabs = {}
    Window.ActiveTab = nil
    
    -- Update tab canvas size
    local function UpdateTabCanvas()
        TabScrollFrame.CanvasSize = UDim2.new(0, 0, 0, TabList.AbsoluteContentSize.Y + 10)
    end
    
    -- Tab functionality
    function Window:CreateTab(tabName, tabIcon)
        tabIcon = tabIcon or "rbxassetid://7733960981"  -- Default icon
        
        -- Create tab button
        local TabButton = CreateInstance("TextButton", {
            Name = tabName .. "Tab",
            Parent = TabScrollFrame,
            BackgroundColor3 = Frosty.Theme.SectionColor,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 30),
            Font = Enum.Font.Gotham,
            Text = "",
            TextColor3 = Frosty.Theme.TextColor,
            TextSize = 14,
            AutoButtonColor = false
        })
        
        local TabButtonCorner = CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = TabButton
        })
        
        -- Add icon
        local TabIcon = CreateInstance("ImageLabel", {
            Name = "Icon",
            Parent = TabButton,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 5, 0, 5),
            Size = UDim2.new(0, 20, 0, 20),
            Image = tabIcon,
            ImageColor3 = Frosty.Theme.TextColor
        })
        
        -- Add title
        local TabTitle = CreateInstance("TextLabel", {
            Name = "Title",
            Parent = TabButton,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 30, 0, 0),
            Size = UDim2.new(1, -35, 1, 0),
            Font = Enum.Font.Gotham,
            Text = tabName,
            TextColor3 = Frosty.Theme.TextColor,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        -- Create content page
        local ContentPage = CreateInstance("ScrollingFrame", {
            Name = tabName .. "Page",
            Parent = ContentContainer,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 5, 0, 5),
            Size = UDim2.new(1, -10, 1, -10),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Frosty.Theme.AccentColor,
            VerticalScrollBarInset = Enum.ScrollBarInset.Always,
            Visible = false
        })
        
        local ContentList = CreateInstance("UIListLayout", {
            Parent = ContentPage,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10)
        })
        
        local ContentPadding = CreateInstance("UIPadding", {
            Parent = ContentPage,
            PaddingLeft = UDim.new(0, 5),
            PaddingRight = UDim.new(0, 5),
            PaddingTop = UDim.new(0, 5),
            PaddingBottom = UDim.new(0, 5)
        })
        
        -- Update canvas size when content is added
        ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            ContentPage.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 10)
        end)
        
        local Tab = {}
        Tab.Button = TabButton
        Tab.Page = ContentPage
        
        -- Activate tab function
        local function ActivateTab()
            if Window.ActiveTab ~= nil then
                -- Deactivate current tab
                local previousTab = Window.ActiveTab
                previousTab.Button.BackgroundColor3 = Frosty.Theme.SectionColor
                previousTab.Page.Visible = false
            end
            
            -- Activate new tab
            TabButton.BackgroundColor3 = Frosty.Theme.AccentColor
            ContentPage.Visible = true
            Window.ActiveTab = Tab
        end
        
        -- Tab button click handler
        TabButton.MouseButton1Click:Connect(function()
            ActivateTab()
            RippleEffect(TabButton)
        end)
        
        -- Section functionality
        function Tab:CreateSection(sectionName)
            local SectionFrame = CreateInstance("Frame", {
                Name = sectionName .. "Section",
                Parent = ContentPage,
                BackgroundColor3 = Frosty.Theme.BackgroundColor,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 35),
                AutomaticSize = Enum.AutomaticSize.Y
            })
            
            local SectionCorner = CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = SectionFrame
            })
            
            local SectionTitle = CreateInstance("TextLabel", {
                Name = "Title",
                Parent = SectionFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 5),
                Size = UDim2.new(1, -20, 0, 25),
                Font = Enum.Font.GothamSemibold,
                Text = sectionName,
                TextColor3 = Frosty.Theme.TextColor,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local SectionDivider = CreateInstance("Frame", {
                Name = "Divider",
                Parent = SectionFrame,
                BackgroundColor3 = Frosty.Theme.OutlineColor,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 5, 0, 32),
                Size = UDim2.new(1, -10, 0, 1)
            })
            
            local SectionContent = CreateInstance("Frame", {
                Name = "Content",
                Parent = SectionFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 40),
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y
            })
            
            local SectionList = CreateInstance("UIListLayout", {
                Parent = SectionContent,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 10)
            })
            
            local SectionPadding = CreateInstance("UIPadding", {
                Parent = SectionContent,
                PaddingLeft = UDim.new(0, 10),
                PaddingRight = UDim.new(0, 10),
                PaddingBottom = UDim.new(0, 10)
            })
            
            -- Update section size
            SectionList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                SectionContent.Size = UDim2.new(1, 0, 0, SectionList.AbsoluteContentSize.Y)
            end)
            
            local Section = {}
            
            -- Button component
            function Section:CreateButton(buttonConfig)
                local buttonText = buttonConfig.Title or "Button"
                local buttonCallback = buttonConfig.Callback or function() end
                
                local ButtonFrame = CreateInstance("Frame", {
                    Name = buttonText .. "Button",
                    Parent = SectionContent,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 35)
                })
                
                local ButtonElement = CreateInstance("TextButton", {
                    Name = "ButtonElement",
                    Parent = ButtonFrame,
                    BackgroundColor3 = Frosty.Theme.AccentColor,
                    Size = UDim2.new(1, 0, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = buttonText,
                    TextColor3 = Frosty.Theme.TextColor,
                    TextSize = 14,
                    AutoButtonColor = false
                })
                
                local ButtonCorner = CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = ButtonElement
                })
                
                -- Button click handler
                ButtonElement.MouseButton1Click:Connect(function()
                    RippleEffect(ButtonElement)
                    
                    -- Create pressed effect
                    local originalColor = ButtonElement.BackgroundColor3
                    ButtonElement.BackgroundColor3 = Frosty.Theme.DarkAccentColor
                    
                    task.spawn(function()
                        buttonCallback()
                    end)
                    
                    task.delay(0.2, function()
                        ButtonElement.BackgroundColor3 = originalColor
                    end)
                end)
                
                -- Hover effects
                ButtonElement.MouseEnter:Connect(function()
                    CreateTween(ButtonElement, {BackgroundColor3 = Frosty.Theme.DarkAccentColor}, 0.2):Play()
                end)
                
                ButtonElement.MouseLeave:Connect(function()
                    CreateTween(ButtonElement, {BackgroundColor3 = Frosty.Theme.AccentColor}, 0.2):Play()
                end)
                
                local ButtonObj = {}
                return ButtonObj
            end
            
            -- Toggle component
            function Section:CreateToggle(toggleConfig)
                local toggleText = toggleConfig.Title or "Toggle"
                local toggleDefault = toggleConfig.Default or false
                local toggleCallback = toggleConfig.Callback or function() end
                
                local ToggleFrame = CreateInstance("Frame", {
                    Name = toggleText .. "Toggle",
                    Parent = SectionContent,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 30)
                })
                
                local ToggleLabel = CreateInstance("TextLabel", {
                    Name = "Label",
                    Parent = ToggleFrame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 0),
                    Size = UDim2.new(1, -50, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = toggleText,
                    TextColor3 = Frosty.Theme.TextColor,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local ToggleContainer = CreateInstance("Frame", {
                    Name = "Container",
                    Parent = ToggleFrame,
                    BackgroundColor3 = Frosty.Theme.ToggleBackgroundColor,
                    Position = UDim2.new(1, -40, 0.5, -10),
                    Size = UDim2.new(0, 40, 0, 20),
                    AnchorPoint = Vector2.new(0, 0.5)
                })
                
                local ToggleCorner = CreateInstance("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = ToggleContainer
                })
                
                local ToggleButton = CreateInstance("Frame", {
                    Name = "Button",
                    Parent = ToggleContainer,
                    BackgroundColor3 = Frosty.Theme.TextColor,
                    Position = UDim2.new(0, 2, 0.5, 0),
                    Size = UDim2.new(0, 16, 0, 16),
                    AnchorPoint = Vector2.new(0, 0.5)
                })
                
                local ToggleButtonCorner = CreateInstance("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = ToggleButton
                })
                
                local ToggleButtonClick = CreateInstance("TextButton", {
                    Name = "ButtonClick",
                    Parent = ToggleFrame,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Font = Enum.Font.SourceSans,
                    Text = "",
                    TextColor3 = Frosty.Theme.TextColor,
                    TextSize = 14
                })
                
                -- Toggle functionality
                local toggled = toggleDefault
                
                local function UpdateToggle()
                    if toggled then
                        CreateTween(ToggleContainer, {BackgroundColor3 = Frosty.Theme.AccentColor}, 0.2):Play()
                        CreateTween(ToggleButton, {Position = UDim2.new(1, -18, 0.5, 0)}, 0.2):Play()
                    else
                        CreateTween(ToggleContainer, {BackgroundColor3 = Frosty.Theme.ToggleBackgroundColor}, 0.2):Play()
                        CreateTween(ToggleButton, {Position = UDim2.new(0, 2, 0.5, 0)}, 0.2):Play()
                    end
                    
                    task.spawn(function()
                        toggleCallback(toggled)
                    end)
                end
                
                -- Set initial state
                if toggled then
                    ToggleContainer.BackgroundColor3 = Frosty.Theme.AccentColor
                    ToggleButton.Position = UDim2.new(1, -18, 0.5, 0)
                end
                
                -- Toggle click handler
                ToggleButtonClick.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    UpdateToggle()
                end)
                
                local ToggleObj = {}
                
                function ToggleObj:Set(value)
                    toggled = value
                    UpdateToggle()
                end
                
                function ToggleObj:Get()
                    return toggled
                end
                
                return ToggleObj
            end
            
            -- Slider component
            function Section:CreateSlider(sliderConfig)
                local sliderText = sliderConfig.Title or "Slider"
                local sliderMin = sliderConfig.Min or 0
                local sliderMax = sliderConfig.Max or 100
                local sliderDefault = sliderConfig.Default or sliderMin
                local sliderCallback = sliderConfig.Callback or function() end
                
                -- Clamp default value
                sliderDefault = math.clamp(sliderDefault, sliderMin, sliderMax)
                
                local SliderFrame = CreateInstance("Frame", {
                    Name = sliderText .. "Slider",
                    Parent = SectionContent,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 50)
                })
                
                local SliderLabel = CreateInstance("TextLabel", {
                    Name = "Label",
                    Parent = SliderFrame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 0),
                    Size = UDim2.new(1, 0, 0, 20),
                    Font = Enum.Font.Gotham,
                    Text = sliderText,
                    TextColor3 = Frosty.Theme.TextColor,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local SliderValue = CreateInstance("TextLabel", {
                    Name = "Value",
                    Parent = SliderFrame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -40, 0, 0),
                    Size = UDim2.new(0, 40, 0, 20),
                    Font = Enum.Font.Gotham,
                    Text = tostring(sliderDefault),
                    TextColor3 = Frosty.Theme.TextColor,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Right
                })
                
                local SliderContainer = CreateInstance("Frame", {
                    Name = "Container",
                    Parent = SliderFrame,
                    BackgroundColor3 = Frosty.Theme.ToggleBackgroundColor,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 0, 25),
                    Size = UDim2.new(1, 0, 0, 10)
                })
                
                local SliderCorner = CreateInstance("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = SliderContainer
                })
                
                local SliderFill = CreateInstance("Frame", {
                    Name = "Fill",
                    Parent = SliderContainer,
                    BackgroundColor3 = Frosty.Theme.AccentColor,
                    BorderSizePixel = 0,
                    Size = UDim2.new(0, 0, 1, 0)
                })
                
                local SliderFillCorner = CreateInstance("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = SliderFill
                })
                
                local SliderButton = CreateInstance("TextButton", {
                    Name = "Button",
                    Parent = SliderContainer,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Text = "",
                    TextTransparency = 1
                })
                
                -- Slider functionality
                local function UpdateSlider(value)
                    -- Clamp the value
                    value = math.clamp(value, sliderMin, sliderMax)
                    
                    -- Calculate percentage
                    local percent = (value - sliderMin) / (sliderMax - sliderMin)
                    
                    -- Update the fill
                    SliderFill.Size = UDim2.new(percent, 0, 1, 0)
                    
                    -- Update the value text
                    SliderValue.Text = tostring(math.floor(value))
                    
                    -- Fire the callback
                    sliderCallback(value)
                end
                
                -- Set initial value
                UpdateSlider(sliderDefault)
                
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
                        -- Calculate value from mouse position
                        local mousePos = UserInputService:GetMouseLocation()
                        local sliderPos = SliderContainer.AbsolutePosition
                        local sliderSize = SliderContainer.AbsoluteSize
                        
                        local relativeX = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
                        local value = sliderMin + (relativeX * (sliderMax - sliderMin))
                        
                        UpdateSlider(value)
                    end
                end)
                
                local SliderObj = {}
                
                function SliderObj:Set(value)
                    UpdateSlider(value)
                end
                
                function SliderObj:Get()
                    return tonumber(SliderValue.Text)
                end
                
                return SliderObj
            end
            
            -- Dropdown component
            function Section:CreateDropdown(dropdownConfig)
                local dropdownText = dropdownConfig.Title or "Dropdown"
                local dropdownItems = dropdownConfig.Items or {}
                local dropdownDefault = dropdownConfig.Default or nil
                local dropdownCallback = dropdownConfig.Callback or function() end
                
                local DropdownFrame = CreateInstance("Frame", {
                    Name = dropdownText .. "Dropdown",
                    Parent = SectionContent,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 50),
                    ClipsDescendants = true
                })
                
                local DropdownLabel = CreateInstance("TextLabel", {
                    Name = "Label",
                    Parent = DropdownFrame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 0),
                    Size = UDim2.new(1, 0, 0, 20),
                    Font = Enum.Font.Gotham,
                    Text = dropdownText,
                    TextColor3 = Frosty.Theme.TextColor,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local DropdownButton = CreateInstance("TextButton", {
                    Name = "Button",
                    Parent = DropdownFrame,
                    BackgroundColor3 = Frosty.Theme.DropdownBackgroundColor,
                    Position = UDim2.new(0, 0, 0, 25),
                    Size = UDim2.new(1, 0, 0, 30),
                    Font = Enum.Font.Gotham,
                    Text = "",
                    TextColor3 = Frosty.Theme.TextColor,
                    TextSize = 14,
                    AutoButtonColor = false
                })
                
                local DropdownCorner = CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = DropdownButton
                })
                
                local DropdownSelected = CreateInstance("TextLabel", {
                    Name = "Selected",
                    Parent = DropdownButton,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(1, -20, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = dropdownDefault or "Select...",
                    TextColor3 = Frosty.Theme.TextColor,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local DropdownIcon = CreateInstance("ImageLabel", {
                    Name = "Icon",
                    Parent = DropdownButton,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -25, 0.5, -8),
                    Size = UDim2.new(0, 16, 0, 16),
                    Image = "rbxassetid://7072706663",
                    ImageColor3 = Frosty.Theme.TextColor,
                    Rotation = 0
                })
                
                local DropdownItemsFrame = CreateInstance("Frame", {
                    Name = "Items",
                    Parent = DropdownFrame,
                    BackgroundColor3 = Frosty.Theme.DropdownBackgroundColor,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 0, 60),
                    Size = UDim2.new(1, 0, 0, 0),
                    Visible = false,
                    ZIndex = 2
                })
                
                local ItemsCorner = CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = DropdownItemsFrame
                })
                
                local ItemsList = CreateInstance("UIListLayout", {
                    Parent = DropdownItemsFrame,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 2)
                })
                
                local ItemsPadding = CreateInstance("UIPadding", {
                    Parent = DropdownItemsFrame,
                    PaddingLeft = UDim.new(0, 5),
                    PaddingRight = UDim.new(0, 5),
                    PaddingTop = UDim.new(0, 5),
                    PaddingBottom = UDim.new(0, 5)
                })
                
                -- Dropdown functionality
                local isOpen = false
                local selectedItem = dropdownDefault
                
                -- Create dropdown items
                for i, item in ipairs(dropdownItems) do
                    local ItemButton = CreateInstance("TextButton", {
                        Name = "Item_" .. i,
                        Parent = DropdownItemsFrame,
                        BackgroundColor3 = Frosty.Theme.SectionColor,
                        Size = UDim2.new(1, 0, 0, 25),
                        Font = Enum.Font.Gotham,
                        Text = item,
                        TextColor3 = Frosty.Theme.TextColor,
                        TextSize = 14,
                        ZIndex = 2,
                        AutoButtonColor = false
                    })
                    
                    local ItemCorner = CreateInstance("UICorner", {
                        CornerRadius = UDim.new(0, 4),
                        Parent = ItemButton
                    })
                    
                    -- Item button click
                    ItemButton.MouseButton1Click:Connect(function()
                        selectedItem = item
                        DropdownSelected.Text = item
                        
                        -- Close dropdown
                        isOpen = false
                        CreateTween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 50)}, 0.2):Play()
                        CreateTween(DropdownIcon, {Rotation = 0}, 0.2):Play()
                        
                        -- Fire callback
                        task.spawn(function()
                            dropdownCallback(item)
                        end)
                        
                        -- Hide items after tween
                        task.delay(0.2, function()
                            DropdownItemsFrame.Visible = false
                        end)
                    end)
                    
                    -- Hover effects
                    ItemButton.MouseEnter:Connect(function()
                        CreateTween(ItemButton, {BackgroundColor3 = Frosty.Theme.AccentColor}, 0.2):Play()
                    end)
                    
                    ItemButton.MouseLeave:Connect(function()
                        CreateTween(ItemButton, {BackgroundColor3 = Frosty.Theme.SectionColor}, 0.2):Play()
                    end)
                end
                
                -- Update items frame size
                ItemsList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    DropdownItemsFrame.Size = UDim2.new(1, 0, 0, ItemsList.AbsoluteContentSize.Y + 10)
                end)
                
                -- Dropdown button click
                DropdownButton.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    
                    if isOpen then
                        -- Calculate new frame size
                        local itemsHeight = ItemsList.AbsoluteContentSize.Y + 10
                        local newHeight = 55 + itemsHeight
                        
                        -- Show items
                        DropdownItemsFrame.Visible = true
                        
                        -- Animate dropdown
                        CreateTween(DropdownFrame, {Size = UDim2.new(1, 0, 0, newHeight)}, 0.2):Play()
                        CreateTween(DropdownIcon, {Rotation = 180}, 0.2):Play()
                    else
                        -- Animate dropdown
                        CreateTween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 50)}, 0.2):Play()
                        CreateTween(DropdownIcon, {Rotation = 0}, 0.2):Play()
                        
                        -- Hide items after tween
                        task.delay(0.2, function()
                            DropdownItemsFrame.Visible = false
                        end)
                    end
                end)
                
                -- Hover effects
                DropdownButton.MouseEnter:Connect(function()
                    if not isOpen then
                        CreateTween(DropdownButton, {BackgroundColor3 = Color3.fromRGB(45, 45, 50)}, 0.2):Play()
                    end
                end)
                
                DropdownButton.MouseLeave:Connect(function()
                    if not isOpen then
                        CreateTween(DropdownButton, {BackgroundColor3 = Frosty.Theme.DropdownBackgroundColor}, 0.2):Play()
                    end
                end)
                
                local DropdownObj = {}
                
                function DropdownObj:Set(item)
                    if table.find(dropdownItems, item) then
                        selectedItem = item
                        DropdownSelected.Text = item
                        
                        task.spawn(function()
                            dropdownCallback(item)
                        end)
                    end
                end
                
                function DropdownObj:Get()
                    return selectedItem
                end
                
                function DropdownObj:Refresh(newItems, keepSelection)
                    -- Clear existing items
                    for _, child in pairs(DropdownItemsFrame:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                    
                    -- Update items list
                    dropdownItems = newItems
                    
                    -- Reset selection if needed
                    if not keepSelection or not table.find(newItems, selectedItem) then
                        selectedItem = nil
                        DropdownSelected.Text = "Select..."
                    end
                    
                    -- Create new items
                    for i, item in ipairs(newItems) do
                        local ItemButton = CreateInstance("TextButton", {
                            Name = "Item_" .. i,
                            Parent = DropdownItemsFrame,
                            BackgroundColor3 = Frosty.Theme.SectionColor,
                            Size = UDim2.new(1, 0, 0, 25),
                            Font = Enum.Font.Gotham,
                            Text = item,
                            TextColor3 = Frosty.Theme.TextColor,
                            TextSize = 14,
                            ZIndex = 2,
                            AutoButtonColor = false
                        })
                        
                        local ItemCorner = CreateInstance("UICorner", {
                            CornerRadius = UDim.new(0, 4),
                            Parent = ItemButton
                        })
                        
                        -- Item button click
                        ItemButton.MouseButton1Click:Connect(function()
                            selectedItem = item
                            DropdownSelected.Text = item
                            
                            -- Close dropdown
                            isOpen = false
                            CreateTween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 50)}, 0.2):Play()
                            CreateTween(DropdownIcon, {Rotation = 0}, 0.2):Play()
                            
                            -- Fire callback
                            task.spawn(function()
                                dropdownCallback(item)
                            end)
                            
                            -- Hide items after tween
                            task.delay(0.2, function()
                                DropdownItemsFrame.Visible = false
                            end)
                        end)
                        
                        -- Hover effects
                        ItemButton.MouseEnter:Connect(function()
                            CreateTween(ItemButton, {BackgroundColor3 = Frosty.Theme.AccentColor}, 0.2):Play()
                        end)
                        
                        ItemButton.MouseLeave:Connect(function()
                            CreateTween(ItemButton, {BackgroundColor3 = Frosty.Theme.SectionColor}, 0.2):Play()
                        end)
                    end
                end
                
                return DropdownObj
            end
            
            -- TextBox component
            function Section:CreateTextBox(textboxConfig)
                local textboxText = textboxConfig.Title or "Input"
                local textboxPlaceholder = textboxConfig.Placeholder or "Enter text..."
                local textboxDefault = textboxConfig.Default or ""
                local textboxCallback = textboxConfig.Callback or function() end
                
                local TextBoxFrame = CreateInstance("Frame", {
                    Name = textboxText .. "TextBox",
                    Parent = SectionContent,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 50)
                })
                
                local TextBoxLabel = CreateInstance("TextLabel", {
                    Name = "Label",
                    Parent = TextBoxFrame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 0),
                    Size = UDim2.new(1, 0, 0, 20),
                    Font = Enum.Font.Gotham,
                    Text = textboxText,
                    TextColor3 = Frosty.Theme.TextColor,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local TextBoxContainer = CreateInstance("Frame", {
                    Name = "Container",
                    Parent = TextBoxFrame,
                    BackgroundColor3 = Frosty.Theme.DropdownBackgroundColor,
                    Position = UDim2.new(0, 0, 0, 25),
                    Size = UDim2.new(1, 0, 0, 30)
                })
                
                local TextBoxCorner = CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = TextBoxContainer
                })
                
                local TextBoxInput = CreateInstance("TextBox", {
                    Name = "Input",
                    Parent = TextBoxContainer,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(1, -20, 1, 0),
                    Font = Enum.Font.Gotham,
                    PlaceholderText = textboxPlaceholder,
                    Text = textboxDefault,
                    TextColor3 = Frosty.Theme.TextColor,
                    PlaceholderColor3 = Color3.fromRGB(120, 120, 130),
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ClearTextOnFocus = false
                })
                
                -- TextBox functionality
                TextBoxInput.FocusLost:Connect(function(enterPressed)
                    if enterPressed then
                        task.spawn(function()
                            textboxCallback(TextBoxInput.Text)
                        end)
                    end
                end)
                
                -- Hover effects
                TextBoxContainer.MouseEnter:Connect(function()
                    CreateTween(TextBoxContainer, {BackgroundColor3 = Color3.fromRGB(45, 45, 50)}, 0.2):Play()
                end)
                
                TextBoxContainer.MouseLeave:Connect(function()
                    CreateTween(TextBoxContainer, {BackgroundColor3 = Frosty.Theme.DropdownBackgroundColor}, 0.2):Play()
                end)
                
                local TextBoxObj = {}
                
                function TextBoxObj:Set(text)
                    TextBoxInput.Text = text
                    task.spawn(function()
                        textboxCallback(text)
                    end)
                end
                
                function TextBoxObj:Get()
                    return TextBoxInput.Text
                end
                
                return TextBoxObj
            end
            
            -- Label component
            function Section:CreateLabel(labelConfig)
                local labelText = labelConfig.Text or "Label"
                
                local LabelFrame = CreateInstance("Frame", {
                    Name = "Label",
                    Parent = SectionContent,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 20)
                })
                
                local LabelText = CreateInstance("TextLabel", {
                    Name = "Text",
                    Parent = LabelFrame,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = labelText,
                    TextColor3 = Frosty.Theme.TextColor,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextWrapped = true
                })
                
                -- Adjust frame size based on text wrap
                LabelText:GetPropertyChangedSignal("TextBounds"):Connect(function()
                    LabelFrame.Size = UDim2.new(1, 0, 0, LabelText.TextBounds.Y)
                end)
                
                local LabelObj = {}
                
                function LabelObj:Set(text)
                    LabelText.Text = text
                end
                
                return LabelObj
            end
            
            return Section
        end
        
        -- Activate this tab if it's the first one
        if #Window.Tabs == 0 then
            ActivateTab()
        end
        
        -- Add tab to tabs table
        table.insert(Window.Tabs, Tab)
        
        -- Update tab canvas size
        UpdateTabCanvas()
        
        return Tab
    end
    
    -- Notification system
    function Window:CreateNotification(notificationConfig)
        local notifTitle = notificationConfig.Title or "Notification"
        local notifContent = notificationConfig.Content or "This is a notification."
        local notifDuration = notificationConfig.Duration or 5
        
        -- Create notification container if it doesn't exist
        if not FrostyGUI:FindFirstChild("NotificationContainer") then
            local NotificationContainer = CreateInstance("Frame", {
                Name = "NotificationContainer",
                Parent = FrostyGUI,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -20, 0, 20),
                Size = UDim2.new(0, 300, 1, -40),
                AnchorPoint = Vector2.new(1, 0),
                ClipsDescendants = false
            })
            
            local NotificationList = CreateInstance("UIListLayout", {
                Parent = NotificationContainer,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Top,
                Padding = UDim.new(0, 10)
            })
        end
        
        local NotificationContainer = FrostyGUI.NotificationContainer
        
        -- Create notification
        local Notification = CreateInstance("Frame", {
            Name = "Notification",
            Parent = NotificationContainer,
            BackgroundColor3 = Frosty.Theme.BackgroundColor,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 0),
            ClipsDescendants = true,
            Position = UDim2.new(1, 0, 0, 0)
        })
        
        local NotificationCorner = CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = Notification
        })
        
        -- Add accent bar
        local AccentBar = CreateInstance("Frame", {
            Name = "AccentBar",
            Parent = Notification,
            BackgroundColor3 = Frosty.Theme.AccentColor,
            BorderSizePixel = 0,
            Size = UDim2.new(0, 4, 1, 0)
        })
        
        -- Add title
        local NotificationTitle = CreateInstance("TextLabel", {
            Name = "Title",
            Parent = Notification,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15, 0, 5),
            Size = UDim2.new(1, -25, 0, 25),
            Font = Enum.Font.GothamBold,
            Text = notifTitle,
            TextColor3 = Frosty.Theme.TextColor,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        -- Add content
        local NotificationContent = CreateInstance("TextLabel", {
            Name = "Content",
            Parent = Notification,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15, 0, 30),
            Size = UDim2.new(1, -25, 0, 0),
            Font = Enum.Font.Gotham,
            Text = notifContent,
            TextColor3 = Frosty.Theme.TextColor,
            TextSize = 14,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top
        })
        
        -- Update content text bounds
        NotificationContent.Size = UDim2.new(1, -25, 0, math.max(NotificationContent.TextBounds.Y, 30))
        
        -- Update notification size
        Notification.Size = UDim2.new(1, 0, 0, NotificationContent.Position.Y.Offset + NotificationContent.Size.Y.Offset + 10)
        
        -- Create shadow
        local NotificationShadow = CreateInstance("ImageLabel", {
            Name = "Shadow",
            Parent = Notification,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, -15, 0, -15),
            Size = UDim2.new(1, 30, 1, 30),
            ZIndex = -1,
            Image = "rbxassetid://5554236805",
            ImageColor3 = Color3.fromRGB(0, 0, 0),
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(23, 23, 277, 277)
        })
        
        -- Animate notification in
        Notification.Position = UDim2.new(1, 0, 0, 0)
        CreateTween(Notification, {Position = UDim2.new(0, 0, 0, 0)}, 0.5, Enum.EasingStyle.Quint):Play()
        
        -- Close after duration
        task.delay(notifDuration, function()
            -- Animate out
            CreateTween(Notification, {Position = UDim2.new(1, 0, 0, 0)}, 0.5, Enum.EasingStyle.Quint):Play()
            
            -- Remove after animation
            task.delay(0.5, function()
                Notification:Destroy()
            end)
        end)
    end
    
    Frosty.Windows[windowTitle] = Window
    return Window
end

-- Set theme
function Frosty:SetTheme(theme)
    for key, value in pairs(theme) do
        if Frosty.Theme[key] then
            Frosty.Theme[key] = value
        end
    end
end

return Frosty
