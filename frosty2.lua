
-- Frosty UI Library
-- Inspired by Rayfield Hub and Orion Lib

local Frosty = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local Mouse = LocalPlayer:GetMouse()

-- Utility functions
local function createInstance(className, properties)
    local instance = Instance.new(className)
    for property, value in pairs(properties) do
        instance[property] = value
    end
    return instance
end

local function createTween(instance, properties, duration, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(
        duration or 0.5,
        easingStyle or Enum.EasingStyle.Quad,
        easingDirection or Enum.EasingDirection.Out
    )
    
    local tween = TweenService:Create(instance, tweenInfo, properties)
    return tween
end

function Frosty:Create(options)
    options = options or {}
    options.Name = options.Name or "Frosty UI"
    options.Theme = options.Theme or "Dark"
    
    -- Main UI Framework
    local FrostyUI = {}
    
    -- Create UI Elements
    local ScreenGui = createInstance("ScreenGui", {
        Name = options.Name,
        Parent = gethui and gethui() or CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })
    
    local MainFrame = createInstance("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        BackgroundColor3 = Color3.fromRGB(25, 25, 35),
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -300, 0.5, -175),
        Size = UDim2.new(0, 600, 0, 350),
        ClipsDescendants = true,
        AnchorPoint = Vector2.new(0, 0)
    })
    
    local UICorner = createInstance("UICorner", {
        Parent = MainFrame,
        CornerRadius = UDim.new(0, 8)
    })
    
    local UIShadow = createInstance("ImageLabel", {
        Name = "Shadow",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, -15, 0, -15),
        Size = UDim2.new(1, 30, 1, 30),
        ZIndex = 0,
        Image = "rbxassetid://6014261993",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450)
    })
    
    local TitleBar = createInstance("Frame", {
        Name = "TitleBar",
        Parent = MainFrame,
        BackgroundColor3 = Color3.fromRGB(30, 30, 45),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 40)
    })
    
    local TitleCorner = createInstance("UICorner", {
        Parent = TitleBar,
        CornerRadius = UDim.new(0, 8)
    })
    
    local TitleCornerFix = createInstance("Frame", {
        Name = "CornerFix",
        Parent = TitleBar,
        BackgroundColor3 = Color3.fromRGB(30, 30, 45),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.new(1, 0, 0.5, 0)
    })
    
    local TitleText = createInstance("TextLabel", {
        Name = "Title",
        Parent = TitleBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(1, -40, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = options.Name,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local CloseButton = createInstance("TextButton", {
        Name = "CloseButton",
        Parent = TitleBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -35, 0, 5),
        Size = UDim2.new(0, 30, 0, 30),
        Font = Enum.Font.GothamBold,
        Text = "✕",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 20
    })
    
    -- Make UI Draggable
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    local function updateDrag(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            updateDrag(input)
        end
    end)
    
    -- Close Button Functionality
    CloseButton.MouseEnter:Connect(function()
        createTween(CloseButton, {TextColor3 = Color3.fromRGB(255, 100, 100)}, 0.3):Play()
    end)
    
    CloseButton.MouseLeave:Connect(function()
        createTween(CloseButton, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.3):Play()
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        createTween(MainFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In):Play()
        wait(0.5)
        ScreenGui:Destroy()
    end)
    
    -- Tab System
    local TabContainer = createInstance("Frame", {
        Name = "TabContainer",
        Parent = MainFrame,
        BackgroundColor3 = Color3.fromRGB(35, 35, 50),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 40),
        Size = UDim2.new(0, 150, 1, -40)
    })
    
    local TabContainerCorner = createInstance("UICorner", {
        Parent = TabContainer,
        CornerRadius = UDim.new(0, 8)
    })
    
    local TabContainerFix = createInstance("Frame", {
        Name = "CornerFix",
        Parent = TabContainer,
        BackgroundColor3 = Color3.fromRGB(35, 35, 50),
        BorderSizePixel = 0,
        Position = UDim2.new(1, -8, 0, 0),
        Size = UDim2.new(0, 8, 1, 0)
    })
    
    local TabScroll = createInstance("ScrollingFrame", {
        Name = "TabScroll",
        Parent = TabContainer,
        Active = true,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 10),
        Size = UDim2.new(1, 0, 1, -10),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Color3.fromRGB(100, 100, 255),
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    })
    
    local TabList = createInstance("UIListLayout", {
        Parent = TabScroll,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    })
    
    local TabPadding = createInstance("UIPadding", {
        Parent = TabScroll,
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10)
    })
    
    -- Content Container
    local ContentContainer = createInstance("Frame", {
        Name = "ContentContainer",
        Parent = MainFrame,
        BackgroundColor3 = Color3.fromRGB(25, 25, 35),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 150, 0, 40),
        Size = UDim2.new(1, -150, 1, -40)
    })
    
    local ContentScroll = createInstance("ScrollingFrame", {
        Name = "ContentScroll",
        Parent = ContentContainer,
        Active = true,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 10, 0, 10),
        Size = UDim2.new(1, -20, 1, -20),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Color3.fromRGB(100, 100, 255),
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    })
    
    local ContentList = createInstance("UIListLayout", {
        Parent = ContentScroll,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10)
    })
    
    local ContentPadding = createInstance("UIPadding", {
        Parent = ContentScroll,
        PaddingLeft = UDim.new(0, 5),
        PaddingRight = UDim.new(0, 5),
        PaddingTop = UDim.new(0, 5),
        PaddingBottom = UDim.new(0, 5)
    })
    
    local tabs = {}
    local currentTab
    
    -- Tab Creation
    function FrostyUI:CreateTab(tabOptions)
        tabOptions = tabOptions or {}
        tabOptions.Name = tabOptions.Name or "Tab"
        tabOptions.Icon = tabOptions.Icon or "rbxassetid://6031229361"
        
        local TabFrame = createInstance("Frame", {
            Name = tabOptions.Name .. "Tab",
            Parent = TabScroll,
            BackgroundColor3 = Color3.fromRGB(45, 45, 65),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 30)
        })
        
        local TabFrameCorner = createInstance("UICorner", {
            Parent = TabFrame,
            CornerRadius = UDim.new(0, 6)
        })
        
        local TabIcon = createInstance("ImageLabel", {
            Name = "Icon",
            Parent = TabFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 5, 0, 5),
            Size = UDim2.new(0, 20, 0, 20),
            Image = tabOptions.Icon,
            ImageColor3 = Color3.fromRGB(200, 200, 200)
        })
        
        local TabLabel = createInstance("TextLabel", {
            Name = "Label",
            Parent = TabFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 35, 0, 0),
            Size = UDim2.new(1, -40, 1, 0),
            Font = Enum.Font.Gotham,
            Text = tabOptions.Name,
            TextColor3 = Color3.fromRGB(200, 200, 200),
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        local TabButton = createInstance("TextButton", {
            Name = "Button",
            Parent = TabFrame,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Text = "",
            ZIndex = 2
        })
        
        local TabContentFrame = createInstance("Frame", {
            Name = tabOptions.Name .. "Content",
            Parent = ContentScroll,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Visible = false
        })
        
        local TabContentList = createInstance("UIListLayout", {
            Parent = TabContentFrame,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8)
        })
        
        local TabContentPadding = createInstance("UIPadding", {
            Parent = TabContentFrame,
            PaddingLeft = UDim.new(0, 5),
            PaddingRight = UDim.new(0, 5),
            PaddingTop = UDim.new(0, 5),
            PaddingBottom = UDim.new(0, 5)
        })
        
        local tab = {
            TabFrame = TabFrame,
            ContentFrame = TabContentFrame,
            Name = tabOptions.Name
        }
        
        table.insert(tabs, tab)
        
        TabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(tabs) do
                local isSelected = (t == tab)
                
                createTween(t.TabFrame, {
                    BackgroundTransparency = isSelected and 0 or 1
                }, 0.3):Play()
                
                if t.TabFrame:FindFirstChild("Icon") then
                    createTween(t.TabFrame:FindFirstChild("Icon"), {
                        ImageColor3 = isSelected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
                    }, 0.3):Play()
                end
                
                if t.TabFrame:FindFirstChild("Label") then
                    createTween(t.TabFrame:FindFirstChild("Label"), {
                        TextColor3 = isSelected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
                    }, 0.3):Play()
                end
                
                t.ContentFrame.Visible = isSelected
            end
            
            currentTab = tab
        end)
        
        -- If this is the first tab, select it automatically
        if #tabs == 1 then
            TabButton.MouseButton1Click:Fire()
        end
        
        -- Tab Element Creation Functions
        local TabElements = {}
        
        -- Section
        function TabElements:CreateSection(sectionOptions)
            sectionOptions = sectionOptions or {}
            sectionOptions.Name = sectionOptions.Name or "Section"
            
            local SectionFrame = createInstance("Frame", {
                Name = sectionOptions.Name .. "Section",
                Parent = TabContentFrame,
                BackgroundColor3 = Color3.fromRGB(35, 35, 50),
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 36),
                AutomaticSize = Enum.AutomaticSize.Y
            })
            
            local SectionCorner = createInstance("UICorner", {
                Parent = SectionFrame,
                CornerRadius = UDim.new(0, 6)
            })
            
            local SectionTitle = createInstance("TextLabel", {
                Name = "Title",
                Parent = SectionFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 8),
                Size = UDim2.new(1, -30, 0, 20),
                Font = Enum.Font.GothamSemibold,
                Text = sectionOptions.Name,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local SectionContainer = createInstance("Frame", {
                Name = "Container",
                Parent = SectionFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 36),
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y
            })
            
            local SectionContentList = createInstance("UIListLayout", {
                Parent = SectionContainer,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 8)
            })
            
            local SectionContentPadding = createInstance("UIPadding", {
                Parent = SectionContainer,
                PaddingLeft = UDim.new(0, 10),
                PaddingRight = UDim.new(0, 10),
                PaddingBottom = UDim.new(0, 10)
            })
            
            local SectionElements = {}
            
            -- Button Element
            function SectionElements:AddButton(buttonOptions)
                buttonOptions = buttonOptions or {}
                buttonOptions.Name = buttonOptions.Name or "Button"
                buttonOptions.Callback = buttonOptions.Callback or function() end
                
                local ButtonFrame = createInstance("Frame", {
                    Name = buttonOptions.Name .. "ButtonFrame",
                    Parent = SectionContainer,
                    BackgroundColor3 = Color3.fromRGB(45, 45, 65),
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 36)
                })
                
                local ButtonCorner = createInstance("UICorner", {
                    Parent = ButtonFrame,
                    CornerRadius = UDim.new(0, 4)
                })
                
                local ButtonTitle = createInstance("TextLabel", {
                    Name = "Title",
                    Parent = ButtonFrame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(1, -20, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = buttonOptions.Name,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local Button = createInstance("TextButton", {
                    Name = "Button",
                    Parent = ButtonFrame,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Font = Enum.Font.SourceSans,
                    Text = "",
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    TextSize = 14
                })
                
                Button.MouseEnter:Connect(function()
                    createTween(ButtonFrame, {BackgroundColor3 = Color3.fromRGB(55, 55, 80)}, 0.3):Play()
                end)
                
                Button.MouseLeave:Connect(function()
                    createTween(ButtonFrame, {BackgroundColor3 = Color3.fromRGB(45, 45, 65)}, 0.3):Play()
                end)
                
                Button.MouseButton1Down:Connect(function()
                    createTween(ButtonFrame, {BackgroundColor3 = Color3.fromRGB(65, 65, 95)}, 0.1):Play()
                end)
                
                Button.MouseButton1Up:Connect(function()
                    createTween(ButtonFrame, {BackgroundColor3 = Color3.fromRGB(55, 55, 80)}, 0.1):Play()
                end)
                
                Button.MouseButton1Click:Connect(function()
                    local success, err = pcall(buttonOptions.Callback)
                    if not success then
                        warn("Frosty UI | Button Callback Error: " .. err)
                    end
                end)
                
                return Button
            end
            
            -- Toggle Element
            function SectionElements:AddToggle(toggleOptions)
                toggleOptions = toggleOptions or {}
                toggleOptions.Name = toggleOptions.Name or "Toggle"
                toggleOptions.Default = toggleOptions.Default or false
                toggleOptions.Callback = toggleOptions.Callback or function() end
                
                local Toggle = {Value = toggleOptions.Default}
                
                local ToggleFrame = createInstance("Frame", {
                    Name = toggleOptions.Name .. "ToggleFrame",
                    Parent = SectionContainer,
                    BackgroundColor3 = Color3.fromRGB(45, 45, 65),
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 36)
                })
                
                local ToggleCorner = createInstance("UICorner", {
                    Parent = ToggleFrame,
                    CornerRadius = UDim.new(0, 4)
                })
                
                local ToggleTitle = createInstance("TextLabel", {
                    Name = "Title",
                    Parent = ToggleFrame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(1, -60, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = toggleOptions.Name,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local ToggleContainer = createInstance("Frame", {
                    Name = "Container",
                    Parent = ToggleFrame,
                    BackgroundColor3 = Color3.fromRGB(35, 35, 50),
                    BorderSizePixel = 0,
                    Position = UDim2.new(1, -46, 0.5, -10),
                    Size = UDim2.new(0, 36, 0, 20)
                })
                
                local ToggleContainerCorner = createInstance("UICorner", {
                    Parent = ToggleContainer,
                    CornerRadius = UDim.new(1, 0)
                })
                
                local ToggleIndicator = createInstance("Frame", {
                    Name = "Indicator",
                    Parent = ToggleContainer,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 2, 0.5, -8),
                    Size = UDim2.new(0, 16, 0, 16)
                })
                
                local ToggleIndicatorCorner = createInstance("UICorner", {
                    Parent = ToggleIndicator,
                    CornerRadius = UDim.new(1, 0)
                })
                
                local ToggleButton = createInstance("TextButton", {
                    Name = "Button",
                    Parent = ToggleFrame,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Font = Enum.Font.SourceSans,
                    Text = "",
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    TextSize = 14
                })
                
                ToggleButton.MouseEnter:Connect(function()
                    createTween(ToggleFrame, {BackgroundColor3 = Color3.fromRGB(55, 55, 80)}, 0.3):Play()
                end)
                
                ToggleButton.MouseLeave:Connect(function()
                    createTween(ToggleFrame, {BackgroundColor3 = Color3.fromRGB(45, 45, 65)}, 0.3):Play()
                end)
                
                local function updateToggle()
                    if Toggle.Value then
                        createTween(ToggleContainer, {BackgroundColor3 = Color3.fromRGB(100, 100, 255)}, 0.3):Play()
                        createTween(ToggleIndicator, {Position = UDim2.new(0, 18, 0.5, -8)}, 0.3):Play()
                    else
                        createTween(ToggleContainer, {BackgroundColor3 = Color3.fromRGB(35, 35, 50)}, 0.3):Play()
                        createTween(ToggleIndicator, {Position = UDim2.new(0, 2, 0.5, -8)}, 0.3):Play()
                    end
                    
                    local success, err = pcall(function()
                        toggleOptions.Callback(Toggle.Value)
                    end)
                    
                    if not success then
                        warn("Frosty UI | Toggle Callback Error: " .. err)
                    end
                end
                
                updateToggle() -- Initialize toggle state
                
                ToggleButton.MouseButton1Click:Connect(function()
                    Toggle.Value = not Toggle.Value
                    updateToggle()
                end)
                
                -- Set method to change toggle externally
                function Toggle:Set(value)
                    if value ~= Toggle.Value then
                        Toggle.Value = value
                        updateToggle()
                    end
                end
                
                return Toggle
            end
            
            -- Slider Element
            function SectionElements:AddSlider(sliderOptions)
                sliderOptions = sliderOptions or {}
                sliderOptions.Name = sliderOptions.Name or "Slider"
                sliderOptions.Min = sliderOptions.Min or 0
                sliderOptions.Max = sliderOptions.Max or 100
                sliderOptions.Default = sliderOptions.Default or 50
                sliderOptions.Increment = sliderOptions.Increment or 1
                sliderOptions.Callback = sliderOptions.Callback or function() end
                sliderOptions.ValueName = sliderOptions.ValueName or ""
                
                sliderOptions.Default = math.clamp(sliderOptions.Default, sliderOptions.Min, sliderOptions.Max)
                
                local Slider = {Value = sliderOptions.Default}
                
                local SliderFrame = createInstance("Frame", {
                    Name = sliderOptions.Name .. "SliderFrame",
                    Parent = SectionContainer,
                    BackgroundColor3 = Color3.fromRGB(45, 45, 65),
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 50)
                })
                
                local SliderCorner = createInstance("UICorner", {
                    Parent = SliderFrame,
                    CornerRadius = UDim.new(0, 4)
                })
                
                local SliderTitle = createInstance("TextLabel", {
                    Name = "Title",
                    Parent = SliderFrame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(1, -20, 0, 25),
                    Font = Enum.Font.Gotham,
                    Text = sliderOptions.Name,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local SliderValue = createInstance("TextLabel", {
                    Name = "Value",
                    Parent = SliderFrame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -50, 0, 0),
                    Size = UDim2.new(0, 40, 0, 25),
                    Font = Enum.Font.Gotham,
                    Text = tostring(sliderOptions.Default) .. sliderOptions.ValueName,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Right
                })
                
                local SliderBackground = createInstance("Frame", {
                    Name = "Background",
                    Parent = SliderFrame,
                    BackgroundColor3 = Color3.fromRGB(35, 35, 50),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 10, 0, 32),
                    Size = UDim2.new(1, -20, 0, 6)
                })
                
                local SliderBackgroundCorner = createInstance("UICorner", {
                    Parent = SliderBackground,
                    CornerRadius = UDim.new(1, 0)
                })
                
                local SliderFill = createInstance("Frame", {
                    Name = "Fill",
                    Parent = SliderBackground,
                    BackgroundColor3 = Color3.fromRGB(100, 100, 255),
                    BorderSizePixel = 0,
                    Size = UDim2.new((sliderOptions.Default - sliderOptions.Min) / (sliderOptions.Max - sliderOptions.Min), 0, 1, 0)
                })
                
                local SliderFillCorner = createInstance("UICorner", {
                    Parent = SliderFill,
                    CornerRadius = UDim.new(1, 0)
                })
                
                local SliderButton = createInstance("TextButton", {
                    Name = "Button",
                    Parent = SliderBackground,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Font = Enum.Font.SourceSans,
                    Text = "",
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    TextSize = 14
                })
                
                local function updateSlider(value)
                    value = math.clamp(value, sliderOptions.Min, sliderOptions.Max)
                    value = math.floor((value - sliderOptions.Min) / sliderOptions.Increment + 0.5) * sliderOptions.Increment + sliderOptions.Min
                    value = math.clamp(value, sliderOptions.Min, sliderOptions.Max)
                    
                    Slider.Value = value
                    SliderValue.Text = tostring(value) .. sliderOptions.ValueName
                    
                    createTween(SliderFill, {Size = UDim2.new((value - sliderOptions.Min) / (sliderOptions.Max - sliderOptions.Min), 0, 1, 0)}, 0.1):Play()
                    
                    local success, err = pcall(function()
                        sliderOptions.Callback(value)
                    end)
                    
                    if not success then
                        warn("Frosty UI | Slider Callback Error: " .. err)
                    end
                end
                
                -- Initialize slider
                updateSlider(sliderOptions.Default)
                
                local dragging = false
                
                SliderButton.MouseButton1Down:Connect(function()
                    dragging = true
                    
                    local function update()
                        if dragging then
                            local mousePosition = UserInputService:GetMouseLocation().X
                            local sliderPosition = SliderBackground.AbsolutePosition.X
                            local sliderWidth = SliderBackground.AbsoluteSize.X
                            
                            local relativePosition = math.clamp((mousePosition - sliderPosition) / sliderWidth, 0, 1)
                            local value = sliderOptions.Min + (relativePosition * (sliderOptions.Max - sliderOptions.Min))
                            
                            updateSlider(value)
                        end
                    end
                    
                    local connectionMove
                    local connectionRelease
                    
                    connectionMove = Mouse.Move:Connect(update)
                    update() -- Update immediately
                    
                    connectionRelease = UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragging = false
                            connectionMove:Disconnect()
                            connectionRelease:Disconnect()
                        end
                    end)
                end)
                
                -- Set method to change slider externally
                function Slider:Set(value)
                    updateSlider(value)
                end
                
                return Slider
            end
            
            -- Dropdown Element
            function SectionElements:AddDropdown(dropdownOptions)
                dropdownOptions = dropdownOptions or {}
                dropdownOptions.Name = dropdownOptions.Name or "Dropdown"
                dropdownOptions.Options = dropdownOptions.Options or {}
                dropdownOptions.Default = dropdownOptions.Default
                dropdownOptions.Callback = dropdownOptions.Callback or function() end
                
                local Dropdown = {Value = dropdownOptions.Default, Options = dropdownOptions.Options, Open = false}
                
                local DropdownFrame = createInstance("Frame", {
                    Name = dropdownOptions.Name .. "DropdownFrame",
                    Parent = SectionContainer,
                    BackgroundColor3 = Color3.fromRGB(45, 45, 65),
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 36),
                    ClipsDescendants = true
                })
                
                local DropdownCorner = createInstance("UICorner", {
                    Parent = DropdownFrame,
                    CornerRadius = UDim.new(0, 4)
                })
                
                local DropdownTitle = createInstance("TextLabel", {
                    Name = "Title",
                    Parent = DropdownFrame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(1, -20, 0, 36),
                    Font = Enum.Font.Gotham,
                    Text = dropdownOptions.Name,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local DropdownCurrent = createInstance("TextLabel", {
                    Name = "Current",
                    Parent = DropdownFrame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -150, 0, 0),
                    Size = UDim2.new(0, 120, 0, 36),
                    Font = Enum.Font.Gotham,
                    Text = dropdownOptions.Default or "Select...",
                    TextColor3 = Color3.fromRGB(200, 200, 200),
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Right
                })
                
                local DropdownArrow = createInstance("ImageLabel", {
                    Name = "Arrow",
                    Parent = DropdownFrame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -25, 0, 8),
                    Size = UDim2.new(0, 20, 0, 20),
                    Image = "rbxassetid://6031094670",
                    Rotation = 0
                })
                
                local DropdownButton = createInstance("TextButton", {
                    Name = "Button",
                    Parent = DropdownFrame,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 36),
                    Font = Enum.Font.SourceSans,
                    Text = "",
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    TextSize = 14
                })
                
                local DropdownOptionsContainer = createInstance("Frame", {
                    Name = "OptionsContainer",
                    Parent = DropdownFrame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 36),
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y
                })
                
                local DropdownOptionsList = createInstance("UIListLayout", {
                    Parent = DropdownOptionsContainer,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 2)
                })
                
                local DropdownOptionsPadding = createInstance("UIPadding", {
                    Parent = DropdownOptionsContainer,
                    PaddingLeft = UDim.new(0, 5),
                    PaddingRight = UDim.new(0, 5),
                    PaddingBottom = UDim.new(0, 5)
                })
                
                -- Create option buttons
                local function createOptions()
                    -- Clear existing options
                    for _, child in pairs(DropdownOptionsContainer:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                    
                    for i, option in ipairs(Dropdown.Options) do
                        local OptionButton = createInstance("TextButton", {
                            Name = "Option_" .. option,
                            Parent = DropdownOptionsContainer,
                            BackgroundColor3 = Color3.fromRGB(55, 55, 80),
                            BorderSizePixel = 0,
                            Size = UDim2.new(1, 0, 0, 30),
                            Font = Enum.Font.Gotham,
                            Text = option,
                            TextColor3 = Color3.fromRGB(255, 255, 255),
                            TextSize = 14,
                            AutoButtonColor = false
                        })
                        
                        local OptionButtonCorner = createInstance("UICorner", {
                            Parent = OptionButton,
                            CornerRadius = UDim.new(0, 4)
                        })
                        
                        OptionButton.MouseEnter:Connect(function()
                            createTween(OptionButton, {BackgroundColor3 = Color3.fromRGB(65, 65, 95)}, 0.3):Play()
                        end)
                        
                        OptionButton.MouseLeave:Connect(function()
                            createTween(OptionButton, {BackgroundColor3 = Color3.fromRGB(55, 55, 80)}, 0.3):Play()
                        end)
                        
                        OptionButton.MouseButton1Click:Connect(function()
                            DropdownCurrent.Text = option
                            Dropdown.Value = option
                            
                            toggleDropdown(false)
                            
                            local success, err = pcall(function()
                                dropdownOptions.Callback(option)
                            end)
                            
                            if not success then
                                warn("Frosty UI | Dropdown Callback Error: " .. err)
                            end
                        end)
                    end
                end
                
                -- Toggle dropdown function
                function toggleDropdown(open)
                    Dropdown.Open = open
                    
                    local totalHeight = 36
                    if open then
                        for _, option in ipairs(Dropdown.Options) do
                            totalHeight = totalHeight + 32
                        end
                        createTween(DropdownFrame, {Size = UDim2.new(1, 0, 0, totalHeight)}, 0.3):Play()
                        createTween(DropdownArrow, {Rotation = 180}, 0.3):Play()
                    else
                        createTween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 36)}, 0.3):Play()
                        createTween(DropdownArrow, {Rotation = 0}, 0.3):Play()
                    end
                end
                
                DropdownButton.MouseButton1Click:Connect(function()
                    toggleDropdown(not Dropdown.Open)
                end)
                
                -- Initialize options
                createOptions()
                
                -- Set method to change dropdown value externally
                function Dropdown:Set(value)
                    if table.find(self.Options, value) then
                        self.Value = value
                        DropdownCurrent.Text = value
                        
                        local success, err = pcall(function()
                            dropdownOptions.Callback(value)
                        end)
                        
                        if not success then
                            warn("Frosty UI | Dropdown Callback Error: " .. err)
                        end
                    end
                end
                
                -- Refresh method to update dropdown options
                function Dropdown:Refresh(options)
                    self.Options = options
                    createOptions()
                    
                    if not table.find(options, self.Value) then
                        self.Value = nil
                        DropdownCurrent.Text = "Select..."
                    end
                end
                
                return Dropdown
            end
            
            -- Label Element
            function SectionElements:AddLabel(labelOptions)
                labelOptions = labelOptions or {}
                labelOptions.Text = labelOptions.Text or "Label"
                
                local LabelFrame = createInstance("Frame", {
                    Name = "LabelFrame",
                    Parent = SectionContainer,
                    BackgroundColor3 = Color3.fromRGB(45, 45, 65),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 24)
                })
                
                local LabelText = createInstance("TextLabel", {
                    Name = "Text",
                    Parent = LabelFrame,
                    BackgroundTransparency = a,
                    Size = UDim2.new(1, 0, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = labelOptions.Text,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextSize = 14,
                    TextWrapped = true
                })
                
                local Label = {}
                
                function Label:Set(text)
                    LabelText.Text = text
                end
                
                return Label
            end
            
            -- Textbox Element
            function SectionElements:AddTextbox(textboxOptions)
                textboxOptions = textboxOptions or {}
                textboxOptions.Name = textboxOptions.Name or "Textbox"
                textboxOptions.Default = textboxOptions.Default or ""
                textboxOptions.PlaceholderText = textboxOptions.PlaceholderText or "Enter text..."
                textboxOptions.ClearOnFocus = textboxOptions.ClearOnFocus ~= nil and textboxOptions.ClearOnFocus or true
                textboxOptions.Callback = textboxOptions.Callback or function() end
                
                local Textbox = {Value = textboxOptions.Default}
                
                local TextboxFrame = createInstance("Frame", {
                    Name = textboxOptions.Name .. "TextboxFrame",
                    Parent = SectionContainer,
                    BackgroundColor3 = Color3.fromRGB(45, 45, 65),
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 36)
                })
                
                local TextboxCorner = createInstance("UICorner", {
                    Parent = TextboxFrame,
                    CornerRadius = UDim.new(0, 4)
                })
                
                local TextboxTitle = createInstance("TextLabel", {
                    Name = "Title",
                    Parent = TextboxFrame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(0.5, -15, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = textboxOptions.Name,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local TextboxContainer = createInstance("Frame", {
                    Name = "Container",
                    Parent = TextboxFrame,
                    BackgroundColor3 = Color3.fromRGB(35, 35, 50),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0.5, 5, 0.5, -12),
                    Size = UDim2.new(0.5, -15, 0, 24)
                })
                
                local TextboxContainerCorner = createInstance("UICorner", {
                    Parent = TextboxContainer,
                    CornerRadius = UDim.new(0, 4)
                })
                
                local TextboxInput = createInstance("TextBox", {
                    Name = "Input",
                    Parent = TextboxContainer,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 8, 0, 0),
                    Size = UDim2.new(1, -16, 1, 0),
                    Font = Enum.Font.Gotham,
                    PlaceholderText = textboxOptions.PlaceholderText,
                    Text = textboxOptions.Default,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextSize = 14,
                    ClearTextOnFocus = textboxOptions.ClearOnFocus
                })
                
                TextboxInput.FocusLost:Connect(function(enterPressed)
                    Textbox.Value = TextboxInput.Text
                    
                    local success, err = pcall(function()
                        textboxOptions.Callback(TextboxInput.Text)
                    end)
                    
                    if not success then
                        warn("Frosty UI | Textbox Callback Error: " .. err)
                    end
                end)
                
                -- Set method to change textbox value externally
                function Textbox:Set(value)
                    self.Value = value
                    TextboxInput.Text = value
                    
                    local success, err = pcall(function()
                        textboxOptions.Callback(value)
                    end)
                    
                    if not success then
                        warn("Frosty UI | Textbox Callback Error: " .. err)
                    end
                end
                
                return Textbox
            end
            
            -- Color Picker Element
            function SectionElements:AddColorPicker(colorOptions)
                colorOptions = colorOptions or {}
                colorOptions.Name = colorOptions.Name or "Color Picker"
                colorOptions.Default = colorOptions.Default or Color3.fromRGB(255, 255, 255)
                colorOptions.Callback = colorOptions.Callback or function() end
                
                local ColorPicker = {Value = colorOptions.Default, Open = false}
                
                local ColorPickerFrame = createInstance("Frame", {
                    Name = colorOptions.Name .. "ColorPickerFrame",
                    Parent = SectionContainer,
                    BackgroundColor3 = Color3.fromRGB(45, 45, 65),
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 36),
                    ClipsDescendants = true
                })
                
                local ColorPickerCorner = createInstance("UICorner", {
                    Parent = ColorPickerFrame,
                    CornerRadius = UDim.new(0, 4)
                })
                
                local ColorPickerTitle = createInstance("TextLabel", {
                    Name = "Title",
                    Parent = ColorPickerFrame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(1, -60, 0, 36),
                    Font = Enum.Font.Gotham,
                    Text = colorOptions.Name,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local ColorDisplay = createInstance("Frame", {
                    Name = "ColorDisplay",
                    Parent = ColorPickerFrame,
                    BackgroundColor3 = colorOptions.Default,
                    BorderSizePixel = 0,
                    Position = UDim2.new(1, -46, 0.5, -10),
                    Size = UDim2.new(0, 36, 0, 20)
                })
                
                local ColorDisplayCorner = createInstance("UICorner", {
                    Parent = ColorDisplay,
                    CornerRadius = UDim.new(0, 4)
                })
                
                local ColorPickerButton = createInstance("TextButton", {
                    Name = "Button",
                    Parent = ColorPickerFrame,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 36),
                    Font = Enum.Font.SourceSans,
                    Text = "",
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    TextSize = 14
                })
                
                local ColorPickerExpanded = createInstance("Frame", {
                    Name = "Expanded",
                    Parent = ColorPickerFrame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 36),
                    Size = UDim2.new(1, 0, 0, 120)
                })
                
                -- Simple RGB sliders for color picking
                local function createColorSlider(parent, color, defaultValue, position)
                    local ColorSlider = createInstance("Frame", {
                        Name = color .. "Slider",
                        Parent = parent,
                        BackgroundColor3 = Color3.fromRGB(35, 35, 50),
                        BorderSizePixel = 0,
                        Position = position,
                        Size = UDim2.new(1, -20, 0, 20)
                    })
                    
                    local ColorSliderCorner = createInstance("UICorner", {
                        Parent = ColorSlider,
                        CornerRadius = UDim.new(0, 4)
                    })
                    
                    local ColorSliderFill = createInstance("Frame", {
                        Name = "Fill",
                        Parent = ColorSlider,
                        BackgroundColor3 = (color == "R" and Color3.fromRGB(255, 0, 0)) or 
                                           (color == "G" and Color3.fromRGB(0, 255, 0)) or 
                                           (color == "B" and Color3.fromRGB(0, 0, 255)),
                        BorderSizePixel = 0,
                        Size = UDim2.new(defaultValue/255, 0, 1, 0)
                    })
                    
                    local ColorSliderFillCorner = createInstance("UICorner", {
                        Parent = ColorSliderFill,
                        CornerRadius = UDim.new(0, 4)
                    })
                    
                    local ColorLabel = createInstance("TextLabel", {
                        Name = "Label",
                        Parent = ColorSlider,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 5, 0, 0),
                        Size = UDim2.new(0, 20, 1, 0),
                        Font = Enum.Font.GothamBold,
                        Text = color,
                        TextColor3 = Color3.fromRGB(255, 255, 255),
                        TextSize = 14
                    })
                    
                    local ColorValue = createInstance("TextLabel", {
                        Name = "Value",
                        Parent = ColorSlider,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(1, -30, 0, 0),
                        Size = UDim2.new(0, 25, 1, 0),
                        Font = Enum.Font.Gotham,
                        Text = tostring(defaultValue),
                        TextColor3 = Color3.fromRGB(255, 255, 255),
                        TextSize = 14
                    })
                    
                    local ColorSliderButton = createInstance("TextButton", {
                        Name = "Button",
                        Parent = ColorSlider,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 1, 0),
                        Font = Enum.Font.SourceSans,
                        Text = "",
                        TextColor3 = Color3.fromRGB(0, 0, 0),
                        TextSize = 14
                    })
                    
                    return ColorSlider, ColorSliderFill, ColorValue, ColorSliderButton
                end
                
                local RSlider, RFill, RValue, RButton = createColorSlider(
                    ColorPickerExpanded, 
                    "R", 
                    math.floor(colorOptions.Default.R * 255), 
                    UDim2.new(0, 10, 0, 10)
                )
                
                local GSlider, GFill, GValue, GButton = createColorSlider(
                    ColorPickerExpanded, 
                    "G", 
                    math.floor(colorOptions.Default.G * 255), 
                    UDim2.new(0, 10, 0, 40)
                )
                
                local BSlider, BFill, BValue, BButton = createColorSlider(
                    ColorPickerExpanded, 
                    "B", 
                    math.floor(colorOptions.Default.B * 255), 
                    UDim2.new(0, 10, 0, 70)
                )
                
                local ApplyButton = createInstance("TextButton", {
                    Name = "ApplyButton",
                    Parent = ColorPickerExpanded,
                    BackgroundColor3 = Color3.fromRGB(100, 100, 255),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0.5, -50, 0, 100),
                    Size = UDim2.new(0, 100, 0, 24),
                    Font = Enum.Font.GothamSemibold,
                    Text = "Apply",
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextSize = 14
                })
                
                local ApplyButtonCorner = createInstance("UICorner", {
                    Parent = ApplyButton,
                    CornerRadius = UDim.new(0, 4)
                })
                
                local function updateSlider(slider, fill, value, color, newValue)
                    newValue = math.clamp(newValue, 0, 255)
                    createTween(fill, {Size = UDim2.new(newValue/255, 0, 1, 0)}, 0.1):Play()
                    value.Text = tostring(math.floor(newValue))
                    
                    local r = color == "R" and newValue or tonumber(RValue.Text)
                    local g = color == "G" and newValue or tonumber(GValue.Text)
                    local b = color == "B" and newValue or tonumber(BValue.Text)
                    
                    local newColor = Color3.fromRGB(r, g, b)
                    createTween(ColorDisplay, {BackgroundColor3 = newColor}, 0.1):Play()
                    
                    return newColor
                end
                
                local function setupSliderDrag(button, fill, value, color)
                    local dragging = false
                    
                    button.MouseButton1Down:Connect(function()
                        dragging = true
                        
                        local function update()
                            if dragging then
                                local mousePosition = UserInputService:GetMouseLocation().X
                                local sliderPosition = button.Parent.AbsolutePosition.X
                                local sliderWidth = button.Parent.AbsoluteSize.X
                                
                                local relativePosition = math.clamp((mousePosition - sliderPosition) / sliderWidth, 0, 1)
                                local newValue = math.floor(relativePosition * 255)
                                
                                updateSlider(button.Parent, fill, value, color, newValue)
                            end
                        end
                        
                        local connectionMove
                        local connectionRelease
                        
                        connectionMove = Mouse.Move:Connect(update)
                        update() -- Update immediately
                        
                        connectionRelease = UserInputService.InputEnded:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                dragging = false
                                connectionMove:Disconnect()
                                connectionRelease:Disconnect()
                            end
                        end)
                    end)
                end
                
                setupSliderDrag(RButton, RFill, RValue, "R")
                setupSliderDrag(GButton, GFill, GValue, "G")
                setupSliderDrag(BButton, BFill, BValue, "B")
                
                -- Toggle color picker expanded
                function toggleColorPicker(open)
                    ColorPicker.Open = open
                    
                    if open then
                        createTween(ColorPickerFrame, {Size = UDim2.new(1, 0, 0, 166)}, 0.3):Play()
                    else
                        createTween(ColorPickerFrame, {Size = UDim2.new(1, 0, 0, 36)}, 0.3):Play()
                    end
                end
                
                ColorPickerButton.MouseButton1Click:Connect(function()
                    toggleColorPicker(not ColorPicker.Open)
                end)
                
                ApplyButton.MouseButton1Click:Connect(function()
                    local r = tonumber(RValue.Text)
                    local g = tonumber(GValue.Text)
                    local b = tonumber(BValue.Text)
                    
                    local newColor = Color3.fromRGB(r, g, b)
                    ColorPicker.Value = newColor
                    
                    toggleColorPicker(false)
                    
                    local success, err = pcall(function()
                        colorOptions.Callback(newColor)
                    end)
                    
                    if not success then
                        warn("Frosty UI | ColorPicker Callback Error: " .. err)
                    end
                end)
                
                -- Set method to change color picker value externally
                function ColorPicker:Set(color)
                    if typeof(color) == "Color3" then
                        self.Value = color
                        ColorDisplay.BackgroundColor3 = color
                        
                        -- Update sliders
                        local r, g, b = math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255)
                        
                        updateSlider(RSlider, RFill, RValue, "R", r)
                        updateSlider(GSlider, GFill, GValue, "G", g)
                        updateSlider(BSlider, BFill, BValue, "B", b)
                        
                        local success, err = pcall(function()
                            colorOptions.Callback(color)
                        end)
                        
                        if not success then
                            warn("Frosty UI | ColorPicker Callback Error: " .. err)
                        end
                    end
                end
                
                return ColorPicker
            end
            
            return SectionElements
        end
        
        return TabElements
    end
    
    -- Initialize the UI
    FrostyUI.Initialized = true
    
    return FrostyUI
end

-- EXAMPLE USAGE
local function CreateExample()
    -- Create the UI
    local UI = Frosty:Create({
        Name = "Frosty UI Library"
    })
    
    -- Create tabs
    local HomeTab = UI:CreateTab({
        Name = "Home",
        Icon = "rbxassetid://6026568198"
    })
    
    local SettingsTab = UI:CreateTab({
        Name = "Settings",
        Icon = "rbxassetid://6031280882"
    })
    
    local CreditsTab = UI:CreateTab({
        Name = "Credits",
        Icon = "rbxassetid://6022668888"
    })
    
    -- Add sections to the Home tab
    local GeneralSection = HomeTab:CreateSection({
        Name = "General"
    })
    
    local TeleportsSection = HomeTab:CreateSection({
        Name = "Teleports"
    })
    
    -- Add elements to General section
    local WalkspeedToggle = GeneralSection:AddToggle({
        Name = "Walkspeed",
        Default = false,
        Callback = function(Value)
            print("Walkspeed toggled:", Value)
            if Value then
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid.WalkSpeed = 32
                end
            else
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid.WalkSpeed = 16
                end
            end
        end
    })
    
    local JumpPowerSlider = GeneralSection:AddSlider({
        Name = "Jump Power",
        Min = 50,
        Max = 200,
        Default = 50,
        Increment = 10,
        ValueName = "",
        Callback = function(Value)
            print("Jump Power set to:", Value)
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.JumpPower = Value
            end
        end
    })
    
    -- Add elements to Teleports section
    TeleportsSection:AddDropdown({
        Name = "Teleport To",
        Options = {"Spawn", "Boss Area", "Shop", "Secret Room"},
        Default = "Spawn",
        Callback = function(Value)
            print("Selected teleport:", Value)
        end
    })
    
    TeleportsSection:AddButton({
        Name = "Teleport",
        Callback = function()
            print("Teleport button pressed")
        end
    })
    
    -- Add sections to Settings tab
    local ConfigSection = SettingsTab:CreateSection({
        Name = "Configuration"
    })
    
    local VisualsSection = SettingsTab:CreateSection({
        Name = "Visuals"
    })
    
    -- Add elements to Config section
    ConfigSection:AddTextbox({
        Name = "Username",
        Default = "",
        PlaceholderText = "Enter username...",
        ClearOnFocus = false,
        Callback = function(Value)
            print("Username set to:", Value)
        end
    })
    
    -- Add visual settings
    VisualsSection:AddColorPicker({
        Name = "UI Color",
        Default = Color3.fromRGB(100, 100, 255),
        Callback = function(Value)
            print("UI Color set to:", Value)
        end
    })
    
    VisualsSection:AddToggle({
        Name = "Fullbright",
        Default = false,
        Callback = function(Value)
            print("Fullbright toggled:", Value)
        end
    })
    
    -- Add sections to Credits tab
    local CreditsSection = CreditsTab:CreateSection({
        Name = "Credits"
    })
    
    -- Add labels for credits
    CreditsSection:AddLabel({
        Text = "Frosty UI Library"
    })
    
    CreditsSection:AddLabel({
        Text = "Created for Replit Assistant"
    })
    
    CreditsSection:AddLabel({
        Text = "Inspired by Rayfield Hub and Orion Lib"
    })
    
    return UI
end

-- Execute the loadstring version would be done like this:
return Frosty
