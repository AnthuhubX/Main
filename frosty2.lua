
--[[
    Frosty UI Library
    A sleek and modern UI library for Roblox, inspired by Rayfield Hub and Orion UI Library
]]

local Frosty = {}
Frosty.__index = Frosty

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- Constants
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Variables
local Library = {
    Toggled = true,
    ToggleKey = Enum.KeyCode.RightShift,
    Theme = {
        MainBackground = Color3.fromRGB(25, 30, 40),
        TopbarBackground = Color3.fromRGB(30, 35, 45),
        TextColor = Color3.fromRGB(255, 255, 255),
        AccentColor = Color3.fromRGB(85, 170, 255),
        DarkAccentColor = Color3.fromRGB(60, 120, 190),
        OutlineColor = Color3.fromRGB(40, 45, 55),
        SectionBackground = Color3.fromRGB(35, 40, 50),
        TabBackground = Color3.fromRGB(28, 33, 43),
        ElementBackground = Color3.fromRGB(40, 45, 55),
        ElementBackgroundHover = Color3.fromRGB(45, 50, 60),
    },
    Flags = {},
    Objects = {},
    Connections = {},
    Window = nil
}

-- Utility Functions
local function MakeDraggable(topBarObject, object)
    local Dragging = nil
    local DragInput = nil
    local DragStart = nil
    local StartPosition = nil
    
    local function Update(input)
        local Delta = input.Position - DragStart
        local Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
        object.Position = Position
    end
    
    topBarObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
    
    topBarObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            DragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            Update(input)
        end
    end)
end

local function Tween(object, properties, duration, ...)
    local tween = TweenService:Create(object, TweenInfo.new(duration, ...), properties)
    tween:Play()
    return tween
end

local function CreateInstance(className, properties)
    local instance = Instance.new(className)
    for property, value in pairs(properties) do
        instance[property] = value
    end
    return instance
end

local function CreateRipple(Parent)
    local RippleContainer = CreateInstance("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Size = UDim2.fromScale(1, 1),
        Position = UDim2.fromScale(0.5, 0.5),
        ZIndex = 100,
        Parent = Parent
    })
    
    Parent.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            local RippleCircle = Instance.new("Frame")
            RippleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            RippleCircle.BackgroundTransparency = 0.7
            RippleCircle.BorderSizePixel = 0
            RippleCircle.AnchorPoint = Vector2.new(0.5, 0.5)
            RippleCircle.Position = UDim2.new(0, Input.Position.X - Parent.AbsolutePosition.X, 0, Input.Position.Y - Parent.AbsolutePosition.Y)
            RippleCircle.Size = UDim2.new(0, 0, 0, 0)
            RippleCircle.Parent = RippleContainer
            
            local MaxSize = math.max(Parent.AbsoluteSize.X, Parent.AbsoluteSize.Y) * 2
            
            Tween(RippleCircle, {
                Size = UDim2.new(0, MaxSize, 0, MaxSize),
                BackgroundTransparency = 1
            }, 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            
            task.delay(0.5, function()
                RippleCircle:Destroy()
            end)
        end
    end)
    
    return RippleContainer
end

-- Main Library Functions
function Frosty:CreateWindow(config)
    config = config or {}
    config.Name = config.Name or "Frosty UI"
    config.Size = config.Size or UDim2.new(0, 500, 0, 350)
    config.Position = config.Position or UDim2.new(0.5, -250, 0.5, -175)
    config.Theme = config.Theme or Library.Theme
    
    -- Apply theme if specified
    if config.Theme then
        for key, value in pairs(config.Theme) do
            Library.Theme[key] = value
        end
    end
    
    -- Create main GUI
    local FrostyGUI = CreateInstance("ScreenGui", {
        Name = "FrostyGUI",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        Parent = (RunService:IsStudio() and Player.PlayerGui) or CoreGui
    })
    
    -- Create window frame
    local MainFrame = CreateInstance("Frame", {
        Name = "MainFrame",
        Size = config.Size,
        Position = config.Position,
        BackgroundColor3 = Library.Theme.MainBackground,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = FrostyGUI
    })
    
    -- Add corner and stroke
    local MainCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = MainFrame
    })
    
    local MainStroke = CreateInstance("UIStroke", {
        Color = Library.Theme.OutlineColor,
        Thickness = 1,
        Parent = MainFrame
    })
    
    -- Create topbar
    local TopBar = CreateInstance("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Library.Theme.TopbarBackground,
        BorderSizePixel = 0,
        Parent = MainFrame
    })
    
    local TopBarCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = TopBar
    })
    
    -- Create title
    local Title = CreateInstance("TextLabel", {
        Name = "Title",
        Text = config.Name,
        Size = UDim2.new(0.5, 0, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        TextColor3 = Library.Theme.TextColor,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        Parent = TopBar
    })
    
    -- Create close button
    local CloseButton = CreateInstance("TextButton", {
        Name = "CloseButton",
        Text = "×",
        Size = UDim2.new(0, 25, 0, 25),
        Position = UDim2.new(1, -30, 0, 2),
        BackgroundTransparency = 1,
        TextColor3 = Library.Theme.TextColor,
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        Parent = TopBar
    })
    
    CloseButton.MouseEnter:Connect(function()
        Tween(CloseButton, {TextColor3 = Library.Theme.AccentColor}, 0.2)
    end)
    
    CloseButton.MouseLeave:Connect(function()
        Tween(CloseButton, {TextColor3 = Library.Theme.TextColor}, 0.2)
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        FrostyGUI:Destroy()
        for _, connection in ipairs(Library.Connections) do
            pcall(function() connection:Disconnect() end)
        end
        Library.Connections = {}
    end)
    
    -- Create minimize button
    local MinimizeButton = CreateInstance("TextButton", {
        Name = "MinimizeButton",
        Text = "-",
        Size = UDim2.new(0, 25, 0, 25),
        Position = UDim2.new(1, -60, 0, 2),
        BackgroundTransparency = 1,
        TextColor3 = Library.Theme.TextColor,
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        Parent = TopBar
    })
    
    MinimizeButton.MouseEnter:Connect(function()
        Tween(MinimizeButton, {TextColor3 = Library.Theme.AccentColor}, 0.2)
    end)
    
    MinimizeButton.MouseLeave:Connect(function()
        Tween(MinimizeButton, {TextColor3 = Library.Theme.TextColor}, 0.2)
    end)
    
    local Minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        if Minimized then
            Tween(MainFrame, {Size = UDim2.new(0, MainFrame.AbsoluteSize.X, 0, 30)}, 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        else
            Tween(MainFrame, {Size = config.Size}, 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        end
    end)
    
    -- Create content container
    local ContentContainer = CreateInstance("Frame", {
        Name = "ContentContainer",
        Size = UDim2.new(1, 0, 1, -30),
        Position = UDim2.new(0, 0, 0, 30),
        BackgroundTransparency = 1,
        Parent = MainFrame
    })
    
    -- Create tab container
    local TabContainer = CreateInstance("Frame", {
        Name = "TabContainer",
        Size = UDim2.new(0, 120, 1, 0),
        BackgroundColor3 = Library.Theme.TabBackground,
        BorderSizePixel = 0,
        Parent = ContentContainer
    })
    
    local TabList = CreateInstance("ScrollingFrame", {
        Name = "TabList",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = TabContainer
    })
    
    local TabListPadding = CreateInstance("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        Parent = TabList
    })
    
    local TabListLayout = CreateInstance("UIListLayout", {
        Padding = UDim.new(0, 5),
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = TabList
    })
    
    -- Create tab content
    local TabContent = CreateInstance("Frame", {
        Name = "TabContent",
        Size = UDim2.new(1, -120, 1, 0),
        Position = UDim2.new(0, 120, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = ContentContainer
    })
    
    -- Make the window draggable
    MakeDraggable(TopBar, MainFrame)
    
    -- Add keybind to toggle UI
    table.insert(Library.Connections, UserInputService.InputBegan:Connect(function(input, processed)
        if input.KeyCode == Library.ToggleKey and not processed then
            Library.Toggled = not Library.Toggled
            MainFrame.Visible = Library.Toggled
        end
    end))
    
    local Window = {}
    Window.__index = Window
    
    local ActiveTab = nil
    
    function Window:CreateTab(name, icon)
        name = name or "Tab"
        icon = icon or "rbxassetid://7733715400"  -- Default icon
        
        -- Create tab button
        local TabButton = CreateInstance("TextButton", {
            Name = name .. "Tab",
            Size = UDim2.new(0, 100, 0, 30),
            BackgroundColor3 = Library.Theme.ElementBackground,
            BackgroundTransparency = 0.5,
            Text = "",
            AutoButtonColor = false,
            Parent = TabList
        })
        
        local TabButtonCorner = CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = TabButton
        })
        
        local TabIcon = CreateInstance("ImageLabel", {
            Name = "Icon",
            Size = UDim2.new(0, 16, 0, 16),
            Position = UDim2.new(0, 10, 0.5, -8),
            BackgroundTransparency = 1,
            Image = icon,
            Parent = TabButton
        })
        
        local TabTitle = CreateInstance("TextLabel", {
            Name = "Title",
            Text = name,
            Size = UDim2.new(1, -35, 1, 0),
            Position = UDim2.new(0, 30, 0, 0),
            BackgroundTransparency = 1,
            TextColor3 = Library.Theme.TextColor,
            TextXAlignment = Enum.TextXAlignment.Left,
            Font = Enum.Font.GothamMedium,
            TextSize = 12,
            Parent = TabButton
        })
        
        -- Create tab page
        local TabPage = CreateInstance("ScrollingFrame", {
            Name = name .. "Page",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Library.Theme.AccentColor,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            Parent = TabContent
        })
        
        local TabPagePadding = CreateInstance("UIPadding", {
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10),
            PaddingTop = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10),
            Parent = TabPage
        })
        
        local TabPageLayout = CreateInstance("UIListLayout", {
            Padding = UDim.new(0, 8),
            FillDirection = Enum.FillDirection.Vertical,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = TabPage
        })
        
        -- Handle tab button click
        TabButton.MouseButton1Click:Connect(function()
            if ActiveTab == TabPage then return end
            
            -- Deactivate current tab if it exists
            if ActiveTab then
                ActiveTab.Visible = false
                local oldTabButton = TabList:FindFirstChild(ActiveTab.Name:gsub("Page", "Tab"))
                if oldTabButton then
                    Tween(oldTabButton, {BackgroundTransparency = 0.5}, 0.2)
                end
            end
            
            -- Activate new tab
            ActiveTab = TabPage
            TabPage.Visible = true
            Tween(TabButton, {BackgroundTransparency = 0}, 0.2)
        end)
        
        TabButton.MouseEnter:Connect(function()
            if ActiveTab ~= TabPage then
                Tween(TabButton, {BackgroundTransparency = 0.3}, 0.2)
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if ActiveTab ~= TabPage then
                Tween(TabButton, {BackgroundTransparency = 0.5}, 0.2)
            end
        end)
        
        -- Create ripple effect
        CreateRipple(TabButton)
        
        -- If this is the first tab, activate it
        if not ActiveTab then
            ActiveTab = TabPage
            TabPage.Visible = true
            TabButton.BackgroundTransparency = 0
        end
        
        local Tab = {}
        Tab.__index = Tab
        
        function Tab:CreateSection(name)
            name = name or "Section"
            
            -- Create section frame
            local SectionFrame = CreateInstance("Frame", {
                Name = name .. "Section",
                Size = UDim2.new(1, 0, 0, 30),  -- Initial size, will be adjusted
                BackgroundColor3 = Library.Theme.SectionBackground,
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = TabPage
            })
            
            local SectionCorner = CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = SectionFrame
            })
            
            local SectionStroke = CreateInstance("UIStroke", {
                Color = Library.Theme.OutlineColor,
                Thickness = 1,
                Parent = SectionFrame
            })
            
            -- Create section title
            local SectionTitle = CreateInstance("TextLabel", {
                Name = "Title",
                Text = name,
                Size = UDim2.new(1, -20, 0, 24),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                TextColor3 = Library.Theme.TextColor,
                TextXAlignment = Enum.TextXAlignment.Left,
                Font = Enum.Font.GothamBold,
                TextSize = 13,
                Parent = SectionFrame
            })
            
            -- Create section content
            local SectionContent = CreateInstance("Frame", {
                Name = "Content",
                Size = UDim2.new(1, -20, 0, 0),
                Position = UDim2.new(0, 10, 0, 24),
                BackgroundTransparency = 1,
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = SectionFrame
            })
            
            local SectionContentLayout = CreateInstance("UIListLayout", {
                Padding = UDim.new(0, 8),
                FillDirection = Enum.FillDirection.Vertical,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = SectionContent
            })
            
            local SectionContentPadding = CreateInstance("UIPadding", {
                PaddingBottom = UDim.new(0, 8),
                Parent = SectionContent
            })
            
            local Section = {}
            Section.__index = Section
            
            function Section:CreateButton(config)
                config = config or {}
                config.Name = config.Name or "Button"
                config.Callback = config.Callback or function() end
                
                -- Create button
                local ButtonFrame = CreateInstance("Frame", {
                    Name = config.Name .. "Button",
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundColor3 = Library.Theme.ElementBackground,
                    Parent = SectionContent
                })
                
                local ButtonCorner = CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = ButtonFrame
                })
                
                local ButtonButton = CreateInstance("TextButton", {
                    Name = "Button",
                    Text = config.Name,
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    TextColor3 = Library.Theme.TextColor,
                    Font = Enum.Font.GothamMedium,
                    TextSize = 12,
                    Parent = ButtonFrame
                })
                
                -- Create ripple effect
                CreateRipple(ButtonButton)
                
                ButtonButton.MouseEnter:Connect(function()
                    Tween(ButtonFrame, {BackgroundColor3 = Library.Theme.ElementBackgroundHover}, 0.2)
                end)
                
                ButtonButton.MouseLeave:Connect(function()
                    Tween(ButtonFrame, {BackgroundColor3 = Library.Theme.ElementBackground}, 0.2)
                end)
                
                ButtonButton.MouseButton1Click:Connect(function()
                    pcall(config.Callback)
                end)
                
                local Button = {}
                return Button
            end
            
            function Section:CreateToggle(config)
                config = config or {}
                config.Name = config.Name or "Toggle"
                config.Default = config.Default or false
                config.Flag = config.Flag or nil
                config.Callback = config.Callback or function() end
                
                local Toggled = config.Default
                
                -- Create toggle frame
                local ToggleFrame = CreateInstance("Frame", {
                    Name = config.Name .. "Toggle",
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundColor3 = Library.Theme.ElementBackground,
                    Parent = SectionContent
                })
                
                local ToggleCorner = CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = ToggleFrame
                })
                
                local ToggleLabel = CreateInstance("TextLabel", {
                    Name = "Label",
                    Text = config.Name,
                    Size = UDim2.new(1, -50, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    TextColor3 = Library.Theme.TextColor,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.GothamMedium,
                    TextSize = 12,
                    Parent = ToggleFrame
                })
                
                local ToggleIndicator = CreateInstance("Frame", {
                    Name = "Indicator",
                    Size = UDim2.new(0, 36, 0, 18),
                    Position = UDim2.new(1, -46, 0.5, -9),
                    BackgroundColor3 = Toggled and Library.Theme.AccentColor or Library.Theme.ElementBackgroundHover,
                    Parent = ToggleFrame
                })
                
                local ToggleIndicatorCorner = CreateInstance("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = ToggleIndicator
                })
                
                local ToggleKnob = CreateInstance("Frame", {
                    Name = "Knob",
                    Size = UDim2.new(0, 14, 0, 14),
                    Position = UDim2.new(Toggled and 1 or 0, Toggled and -16 or 2, 0.5, -7),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = ToggleIndicator
                })
                
                local ToggleKnobCorner = CreateInstance("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = ToggleKnob
                })
                
                local ToggleButton = CreateInstance("TextButton", {
                    Name = "Button",
                    Text = "",
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Parent = ToggleFrame
                })
                
                -- Save to flags if flag specified
                if config.Flag then
                    Library.Flags[config.Flag] = Toggled
                end
                
                local function Toggle()
                    Toggled = not Toggled
                    
                    Tween(ToggleIndicator, {
                        BackgroundColor3 = Toggled and Library.Theme.AccentColor or Library.Theme.ElementBackgroundHover
                    }, 0.2)
                    
                    Tween(ToggleKnob, {
                        Position = UDim2.new(Toggled and 1 or 0, Toggled and -16 or 2, 0.5, -7)
                    }, 0.2)
                    
                    if config.Flag then
                        Library.Flags[config.Flag] = Toggled
                    end
                    
                    pcall(config.Callback, Toggled)
                end
                
                ToggleButton.MouseButton1Click:Connect(Toggle)
                
                ToggleFrame.MouseEnter:Connect(function()
                    Tween(ToggleFrame, {BackgroundColor3 = Library.Theme.ElementBackgroundHover}, 0.2)
                end)
                
                ToggleFrame.MouseLeave:Connect(function()
                    Tween(ToggleFrame, {BackgroundColor3 = Library.Theme.ElementBackground}, 0.2)
                end)
                
                local Toggle = {}
                Toggle.__index = Toggle
                
                function Toggle:Set(value)
                    if value == Toggled then return end
                    Toggle()
                end
                
                function Toggle:Get()
                    return Toggled
                end
                
                return Toggle
            end
            
            function Section:CreateSlider(config)
                config = config or {}
                config.Name = config.Name or "Slider"
                config.Min = config.Min or 0
                config.Max = config.Max or 100
                config.Default = config.Default or config.Min
                config.Increment = config.Increment or 1
                config.Flag = config.Flag or nil
                config.Callback = config.Callback or function() end
                
                -- Make sure default value is within range and properly incremented
                local DefaultValue = math.clamp(config.Default, config.Min, config.Max)
                DefaultValue = config.Min + (math.round((DefaultValue - config.Min) / config.Increment) * config.Increment)
                local Value = DefaultValue
                
                -- Create slider frame
                local SliderFrame = CreateInstance("Frame", {
                    Name = config.Name .. "Slider",
                    Size = UDim2.new(1, 0, 0, 45),
                    BackgroundColor3 = Library.Theme.ElementBackground,
                    Parent = SectionContent
                })
                
                local SliderCorner = CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = SliderFrame
                })
                
                local SliderLabel = CreateInstance("TextLabel", {
                    Name = "Label",
                    Text = config.Name,
                    Size = UDim2.new(1, -65, 0, 25),
                    Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    TextColor3 = Library.Theme.TextColor,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.GothamMedium,
                    TextSize = 12,
                    Parent = SliderFrame
                })
                
                local SliderValue = CreateInstance("TextLabel", {
                    Name = "Value",
                    Text = tostring(Value),
                    Size = UDim2.new(0, 55, 0, 25),
                    Position = UDim2.new(1, -65, 0, 0),
                    BackgroundTransparency = 1,
                    TextColor3 = Library.Theme.TextColor,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Font = Enum.Font.GothamMedium,
                    TextSize = 12,
                    Parent = SliderFrame
                })
                
                local SliderBackground = CreateInstance("Frame", {
                    Name = "Background",
                    Size = UDim2.new(1, -20, 0, 5),
                    Position = UDim2.new(0, 10, 0, 30),
                    BackgroundColor3 = Library.Theme.ElementBackgroundHover,
                    BorderSizePixel = 0,
                    Parent = SliderFrame
                })
                
                local SliderBackgroundCorner = CreateInstance("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = SliderBackground
                })
                
                local SliderFill = CreateInstance("Frame", {
                    Name = "Fill",
                    Size = UDim2.new((Value - config.Min) / (config.Max - config.Min), 0, 1, 0),
                    BackgroundColor3 = Library.Theme.AccentColor,
                    BorderSizePixel = 0,
                    Parent = SliderBackground
                })
                
                local SliderFillCorner = CreateInstance("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = SliderFill
                })
                
                local SliderButton = CreateInstance("TextButton", {
                    Name = "Button",
                    Text = "",
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Parent = SliderFrame
                })
                
                -- Save to flags if flag specified
                if config.Flag then
                    Library.Flags[config.Flag] = Value
                end
                
                local function UpdateSlider(input)
                    local sizeX = math.clamp((input.Position.X - SliderBackground.AbsolutePosition.X) / SliderBackground.AbsoluteSize.X, 0, 1)
                    local newValue = config.Min + ((config.Max - config.Min) * sizeX)
                    
                    -- Apply increment
                    newValue = config.Min + (math.round((newValue - config.Min) / config.Increment) * config.Increment)
                    
                    -- Clamp the value
                    newValue = math.clamp(newValue, config.Min, config.Max)
                    
                    -- Update value display
                    Value = newValue
                    SliderValue.Text = tostring(Value)
                    
                    -- Update slider fill
                    Tween(SliderFill, {
                        Size = UDim2.new((Value - config.Min) / (config.Max - config.Min), 0, 1, 0)
                    }, 0.1)
                    
                    if config.Flag then
                        Library.Flags[config.Flag] = Value
                    end
                    
                    pcall(config.Callback, Value)
                end
                
                SliderButton.MouseButton1Down:Connect(function()
                    local connection
                    connection = RunService.Heartbeat:Connect(function()
                        UpdateSlider({Position = Vector2.new(Mouse.X, 0)})
                    end)
                    
                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            if connection then connection:Disconnect() end
                        end
                    end)
                end)
                
                SliderFrame.MouseEnter:Connect(function()
                    Tween(SliderFrame, {BackgroundColor3 = Library.Theme.ElementBackgroundHover}, 0.2)
                end)
                
                SliderFrame.MouseLeave:Connect(function()
                    Tween(SliderFrame, {BackgroundColor3 = Library.Theme.ElementBackground}, 0.2)
                end)
                
                local Slider = {}
                Slider.__index = Slider
                
                function Slider:Set(value)
                    value = math.clamp(value, config.Min, config.Max)
                    value = config.Min + (math.round((value - config.Min) / config.Increment) * config.Increment)
                    
                    Value = value
                    SliderValue.Text = tostring(Value)
                    
                    Tween(SliderFill, {
                        Size = UDim2.new((Value - config.Min) / (config.Max - config.Min), 0, 1, 0)
                    }, 0.1)
                    
                    if config.Flag then
                        Library.Flags[config.Flag] = Value
                    end
                    
                    pcall(config.Callback, Value)
                end
                
                function Slider:Get()
                    return Value
                end
                
                -- Initialize with default value
                Slider:Set(DefaultValue)
                
                return Slider
            end
            
            function Section:CreateDropdown(config)
                config = config or {}
                config.Name = config.Name or "Dropdown"
                config.Options = config.Options or {}
                config.Default = config.Default or nil
                config.Flag = config.Flag or nil
                config.Callback = config.Callback or function() end
                
                local SelectedOption = config.Default
                local Opened = false
                
                -- Create dropdown frame
                local DropdownFrame = CreateInstance("Frame", {
                    Name = config.Name .. "Dropdown",
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundColor3 = Library.Theme.ElementBackground,
                    ClipsDescendants = true,
                    Parent = SectionContent
                })
                
                local DropdownCorner = CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = DropdownFrame
                })
                
                local DropdownHeader = CreateInstance("TextButton", {
                    Name = "Header",
                    Text = "",
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundTransparency = 1,
                    Parent = DropdownFrame
                })
                
                local DropdownLabel = CreateInstance("TextLabel", {
                    Name = "Label",
                    Text = config.Name,
                    Size = UDim2.new(1, -30, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    TextColor3 = Library.Theme.TextColor,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.GothamMedium,
                    TextSize = 12,
                    Parent = DropdownHeader
                })
                
                local DropdownArrow = CreateInstance("ImageLabel", {
                    Name = "Arrow",
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = UDim2.new(1, -26, 0.5, -8),
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://7072706796",
                    ImageColor3 = Library.Theme.TextColor,
                    Parent = DropdownHeader
                })
                
                local DropdownValue = CreateInstance("TextLabel", {
                    Name = "Value",
                    Text = SelectedOption or "Select...",
                    Size = UDim2.new(1, -30, 0, 32),
                    Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    TextColor3 = SelectedOption and Library.Theme.TextColor or Color3.fromRGB(180, 180, 180),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.GothamMedium,
                    TextSize = 12,
                    Visible = false,
                    Parent = DropdownFrame
                })
                
                local DropdownContainer = CreateInstance("Frame", {
                    Name = "Container",
                    Size = UDim2.new(1, -20, 0, 0),
                    Position = UDim2.new(0, 10, 0, 32),
                    BackgroundTransparency = 1,
                    Parent = DropdownFrame
                })
                
                local DropdownContainerLayout = CreateInstance("UIListLayout", {
                    Padding = UDim.new(0, 4),
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Parent = DropdownContainer
                })
                
                -- Create options
                for _, option in ipairs(config.Options) do
                    local OptionButton = CreateInstance("TextButton", {
                        Name = option,
                        Text = option,
                        Size = UDim2.new(1, 0, 0, 24),
                        BackgroundColor3 = Library.Theme.ElementBackgroundHover,
                        TextColor3 = Library.Theme.TextColor,
                        Font = Enum.Font.GothamMedium,
                        TextSize = 12,
                        AutoButtonColor = false,
                        Parent = DropdownContainer
                    })
                    
                    local OptionCorner = CreateInstance("UICorner", {
                        CornerRadius = UDim.new(0, 4),
                        Parent = OptionButton
                    })
                    
                    OptionButton.MouseEnter:Connect(function()
                        Tween(OptionButton, {BackgroundColor3 = Library.Theme.AccentColor}, 0.2)
                    end)
                    
                    OptionButton.MouseLeave:Connect(function()
                        Tween(OptionButton, {BackgroundColor3 = Library.Theme.ElementBackgroundHover}, 0.2)
                    end)
                    
                    OptionButton.MouseButton1Click:Connect(function()
                        SelectedOption = option
                        DropdownValue.Text = option
                        DropdownValue.TextColor3 = Library.Theme.TextColor
                        
                        -- Close dropdown
                        Opened = false
                        Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 32)}, 0.2)
                        Tween(DropdownArrow, {Rotation = 0}, 0.2)
                        
                        if config.Flag then
                            Library.Flags[config.Flag] = SelectedOption
                        end
                        
                        pcall(config.Callback, SelectedOption)
                    end)
                end
                
                -- Calculate dropdown height when opened
                local OptionsHeight = #config.Options * 28  -- 24 + 4 padding per option
                
                DropdownHeader.MouseButton1Click:Connect(function()
                    Opened = not Opened
                    
                    if Opened then
                        Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 32 + OptionsHeight)}, 0.2)
                        Tween(DropdownArrow, {Rotation = 180}, 0.2)
                    else
                        Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 32)}, 0.2)
                        Tween(DropdownArrow, {Rotation = 0}, 0.2)
                    end
                end)
                
                DropdownFrame.MouseEnter:Connect(function()
                    Tween(DropdownFrame, {BackgroundColor3 = Library.Theme.ElementBackgroundHover}, 0.2)
                end)
                
                DropdownFrame.MouseLeave:Connect(function()
                    Tween(DropdownFrame, {BackgroundColor3 = Library.Theme.ElementBackground}, 0.2)
                end)
                
                -- Save to flags if flag specified and default provided
                if config.Flag and config.Default then
                    Library.Flags[config.Flag] = config.Default
                end
                
                local Dropdown = {}
                Dropdown.__index = Dropdown
                
                function Dropdown:Set(option)
                    if not table.find(config.Options, option) then return end
                    
                    SelectedOption = option
                    DropdownValue.Text = option
                    DropdownValue.TextColor3 = Library.Theme.TextColor
                    
                    if config.Flag then
                        Library.Flags[config.Flag] = SelectedOption
                    end
                    
                    pcall(config.Callback, SelectedOption)
                end
                
                function Dropdown:Get()
                    return SelectedOption
                end
                
                function Dropdown:Refresh(options, keepSelected)
                    -- Clear existing options
                    for _, child in ipairs(DropdownContainer:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                    
                    -- Update options
                    config.Options = options
                    
                    -- Reset selected option if not keeping it or if it no longer exists
                    if not keepSelected or not table.find(options, SelectedOption) then
                        SelectedOption = nil
                        DropdownValue.Text = "Select..."
                        DropdownValue.TextColor3 = Color3.fromRGB(180, 180, 180)
                        
                        if config.Flag then
                            Library.Flags[config.Flag] = nil
                        end
                    end
                    
                    -- Create new options
                    for _, option in ipairs(options) do
                        local OptionButton = CreateInstance("TextButton", {
                            Name = option,
                            Text = option,
                            Size = UDim2.new(1, 0, 0, 24),
                            BackgroundColor3 = Library.Theme.ElementBackgroundHover,
                            TextColor3 = Library.Theme.TextColor,
                            Font = Enum.Font.GothamMedium,
                            TextSize = 12,
                            AutoButtonColor = false,
                            Parent = DropdownContainer
                        })
                        
                        local OptionCorner = CreateInstance("UICorner", {
                            CornerRadius = UDim.new(0, 4),
                            Parent = OptionButton
                        })
                        
                        OptionButton.MouseEnter:Connect(function()
                            Tween(OptionButton, {BackgroundColor3 = Library.Theme.AccentColor}, 0.2)
                        end)
                        
                        OptionButton.MouseLeave:Connect(function()
                            Tween(OptionButton, {BackgroundColor3 = Library.Theme.ElementBackgroundHover}, 0.2)
                        end)
                        
                        OptionButton.MouseButton1Click:Connect(function()
                            SelectedOption = option
                            DropdownValue.Text = option
                            DropdownValue.TextColor3 = Library.Theme.TextColor
                            
                            -- Close dropdown
                            Opened = false
                            Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 32)}, 0.2)
                            Tween(DropdownArrow, {Rotation = 0}, 0.2)
                            
                            if config.Flag then
                                Library.Flags[config.Flag] = SelectedOption
                            end
                            
                            pcall(config.Callback, SelectedOption)
                        end)
                    end
                    
                    -- Recalculate dropdown height
                    OptionsHeight = #options * 28  -- 24 + 4 padding per option
                    
                    -- Update size if dropdown is open
                    if Opened then
                        DropdownFrame.Size = UDim2.new(1, 0, 0, 32 + OptionsHeight)
                    end
                end
                
                -- Initialize with default value if provided
                if config.Default then
                    Dropdown:Set(config.Default)
                end
                
                return Dropdown
            end
            
            function Section:CreateColorPicker(config)
                config = config or {}
                config.Name = config.Name or "Color Picker"
                config.Default = config.Default or Color3.fromRGB(255, 255, 255)
                config.Flag = config.Flag or nil
                config.Callback = config.Callback or function() end
                
                local SelectedColor = config.Default
                local Opened = false
                
                -- Create color picker frame
                local ColorPickerFrame = CreateInstance("Frame", {
                    Name = config.Name .. "ColorPicker",
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundColor3 = Library.Theme.ElementBackground,
                    ClipsDescendants = true,
                    Parent = SectionContent
                })
                
                local ColorPickerCorner = CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = ColorPickerFrame
                })
                
                local ColorPickerLabel = CreateInstance("TextLabel", {
                    Name = "Label",
                    Text = config.Name,
                    Size = UDim2.new(1, -65, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    TextColor3 = Library.Theme.TextColor,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.GothamMedium,
                    TextSize = 12,
                    Parent = ColorPickerFrame
                })
                
                local ColorDisplay = CreateInstance("Frame", {
                    Name = "ColorDisplay",
                    Size = UDim2.new(0, 25, 0, 25),
                    Position = UDim2.new(1, -35, 0.5, -12.5),
                    BackgroundColor3 = SelectedColor,
                    Parent = ColorPickerFrame
                })
                
                local ColorDisplayCorner = CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = ColorDisplay
                })
                
                local ColorPickerButton = CreateInstance("TextButton", {
                    Name = "Button",
                    Text = "",
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundTransparency = 1,
                    Parent = ColorPickerFrame
                })
                
                local ColorPickerContent = CreateInstance("Frame", {
                    Name = "Content",
                    Size = UDim2.new(1, -20, 0, 140),
                    Position = UDim2.new(0, 10, 0, 40),
                    BackgroundTransparency = 1,
                    Visible = false,
                    Parent = ColorPickerFrame
                })
                
                local H, S, V = Color3.toHSV(SelectedColor)
                
                -- Create color saturation picker
                local SaturationBox = CreateInstance("ImageLabel", {
                    Name = "SaturationBox",
                    Size = UDim2.new(1, 0, 0, 100),
                    BackgroundColor3 = Color3.fromHSV(H, 1, 1),
                    Image = "rbxassetid://4155801252",
                    Parent = ColorPickerContent
                })
                
                local SaturationBoxCorner = CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = SaturationBox
                })
                
                local SaturationCursor = CreateInstance("Frame", {
                    Name = "Cursor",
                    Size = UDim2.new(0, 8, 0, 8),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(S, 0, 1 - V, 0),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = SaturationBox
                })
                
                local SaturationCursorCorner = CreateInstance("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = SaturationCursor
                })
                
                -- Create hue picker
                local HueBox = CreateInstance("ImageLabel", {
                    Name = "HueBox",
                    Size = UDim2.new(1, 0, 0, 20),
                    Position = UDim2.new(0, 0, 0, 105),
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://3283651682",
                    Parent = ColorPickerContent
                })
                
                local HueBoxCorner = CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = HueBox
                })
                
                local HueCursor = CreateInstance("Frame", {
                    Name = "Cursor",
                    Size = UDim2.new(0, 8, 1, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(H, 0, 0.5, 0),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = HueBox
                })
                
                local HueCursorCorner = CreateInstance("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = HueCursor
                })
                
                -- Save to flags if flag specified
                if config.Flag then
                    Library.Flags[config.Flag] = SelectedColor
                end
                
                local function UpdateColor()
                    SelectedColor = Color3.fromHSV(H, S, V)
                    ColorDisplay.BackgroundColor3 = SelectedColor
                    SaturationBox.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
                    
                    if config.Flag then
                        Library.Flags[config.Flag] = SelectedColor
                    end
                    
                    pcall(config.Callback, SelectedColor)
                end
                
                ColorPickerButton.MouseButton1Click:Connect(function()
                    Opened = not Opened
                    
                    if Opened then
                        ColorPickerContent.Visible = true
                        Tween(ColorPickerFrame, {Size = UDim2.new(1, 0, 0, 190)}, 0.2)
                    else
                        Tween(ColorPickerFrame, {Size = UDim2.new(1, 0, 0, 32)}, 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, function()
                            ColorPickerContent.Visible = false
                        end)
                    end
                end)
                
                local function UpdateHue(input)
                    local sizeX = math.clamp((input.Position.X - HueBox.AbsolutePosition.X) / HueBox.AbsoluteSize.X, 0, 1)
                    HueCursor.Position = UDim2.new(sizeX, 0, 0.5, 0)
                    H = sizeX
                    UpdateColor()
                end
                
                local function UpdateSatVal(input)
                    local sizeX = math.clamp((input.Position.X - SaturationBox.AbsolutePosition.X) / SaturationBox.AbsoluteSize.X, 0, 1)
                    local sizeY = math.clamp((input.Position.Y - SaturationBox.AbsolutePosition.Y) / SaturationBox.AbsoluteSize.Y, 0, 1)
                    SaturationCursor.Position = UDim2.new(sizeX, 0, sizeY, 0)
                    S = sizeX
                    V = 1 - sizeY
                    UpdateColor()
                end
                
                HueBox.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        UpdateHue(input)
                        local connection
                        connection = RunService.Heartbeat:Connect(function()
                            UpdateHue({Position = Vector2.new(Mouse.X, Mouse.Y)})
                        end)
                        
                        UserInputService.InputEnded:Connect(function(inp)
                            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                                if connection then connection:Disconnect() end
                            end
                        end)
                    end
                end)
                
                SaturationBox.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        UpdateSatVal(input)
                        local connection
                        connection = RunService.Heartbeat:Connect(function()
                            UpdateSatVal({Position = Vector2.new(Mouse.X, Mouse.Y)})
                        end)
                        
                        UserInputService.InputEnded:Connect(function(inp)
                            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                                if connection then connection:Disconnect() end
                            end
                        end)
                    end
                end)
                
                ColorPickerFrame.MouseEnter:Connect(function()
                    Tween(ColorPickerFrame, {BackgroundColor3 = Library.Theme.ElementBackgroundHover}, 0.2)
                end)
                
                ColorPickerFrame.MouseLeave:Connect(function()
                    Tween(ColorPickerFrame, {BackgroundColor3 = Library.Theme.ElementBackground}, 0.2)
                end)
                
                local ColorPicker = {}
                ColorPicker.__index = ColorPicker
                
                function ColorPicker:Set(color)
                    H, S, V = Color3.toHSV(color)
                    SaturationCursor.Position = UDim2.new(S, 0, 1 - V, 0)
                    HueCursor.Position = UDim2.new(H, 0, 0.5, 0)
                    UpdateColor()
                end
                
                function ColorPicker:Get()
                    return SelectedColor
                end
                
                -- Initialize with default value
                ColorPicker:Set(config.Default)
                
                return ColorPicker
            end
            
            function Section:CreateTextbox(config)
                config = config or {}
                config.Name = config.Name or "Textbox"
                config.Default = config.Default or ""
                config.PlaceholderText = config.PlaceholderText or "Enter text..."
                config.ClearOnFocus = config.ClearOnFocus ~= nil and config.ClearOnFocus or true
                config.Flag = config.Flag or nil
                config.Callback = config.Callback or function() end
                
                -- Create textbox frame
                local TextboxFrame = CreateInstance("Frame", {
                    Name = config.Name .. "Textbox",
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundColor3 = Library.Theme.ElementBackground,
                    Parent = SectionContent
                })
                
                local TextboxCorner = CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = TextboxFrame
                })
                
                local TextboxLabel = CreateInstance("TextLabel", {
                    Name = "Label",
                    Text = config.Name,
                    Size = UDim2.new(0.4, -10, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    TextColor3 = Library.Theme.TextColor,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.GothamMedium,
                    TextSize = 12,
                    Parent = TextboxFrame
                })
                
                local TextboxContainer = CreateInstance("Frame", {
                    Name = "Container",
                    Size = UDim2.new(0.6, -15, 0, 24),
                    Position = UDim2.new(0.4, 5, 0.5, -12),
                    BackgroundColor3 = Library.Theme.ElementBackgroundHover,
                    Parent = TextboxFrame
                })
                
                local TextboxContainerCorner = CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = TextboxContainer
                })
                
                local Textbox = CreateInstance("TextBox", {
                    Name = "Textbox",
                    Text = config.Default,
                    PlaceholderText = config.PlaceholderText,
                    Size = UDim2.new(1, -10, 1, 0),
                    Position = UDim2.new(0, 5, 0, 0),
                    BackgroundTransparency = 1,
                    TextColor3 = Library.Theme.TextColor,
                    Font = Enum.Font.GothamMedium,
                    TextSize = 12,
                    ClearTextOnFocus = config.ClearOnFocus,
                    Parent = TextboxContainer
                })
                
                -- Save to flags if flag specified
                if config.Flag then
                    Library.Flags[config.Flag] = config.Default
                end
                
                Textbox.FocusLost:Connect(function(enterPressed)
                    if config.Flag then
                        Library.Flags[config.Flag] = Textbox.Text
                    end
                    
                    pcall(config.Callback, Textbox.Text, enterPressed)
                end)
                
                TextboxFrame.MouseEnter:Connect(function()
                    Tween(TextboxFrame, {BackgroundColor3 = Library.Theme.ElementBackgroundHover}, 0.2)
                end)
                
                TextboxFrame.MouseLeave:Connect(function()
                    Tween(TextboxFrame, {BackgroundColor3 = Library.Theme.ElementBackground}, 0.2)
                end)
                
                local TextboxObject = {}
                TextboxObject.__index = TextboxObject
                
                function TextboxObject:Set(text)
                    Textbox.Text = text
                    
                    if config.Flag then
                        Library.Flags[config.Flag] = text
                    end
                    
                    pcall(config.Callback, text, false)
                end
                
                function TextboxObject:Get()
                    return Textbox.Text
                end
                
                return TextboxObject
            end
            
            function Section:CreateLabel(text)
                text = text or "Label"
                
                local LabelFrame = CreateInstance("Frame", {
                    Name = "Label",
                    Size = UDim2.new(1, 0, 0, 24),
                    BackgroundTransparency = 1,
                    Parent = SectionContent
                })
                
                local Label = CreateInstance("TextLabel", {
                    Name = "Text",
                    Text = text,
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    TextColor3 = Library.Theme.TextColor,
                    TextWrapped = true,
                    Font = Enum.Font.GothamMedium,
                    TextSize = 12,
                    Parent = LabelFrame
                })
                
                local LabelObject = {}
                LabelObject.__index = LabelObject
                
                function LabelObject:Set(newText)
                    Label.Text = newText
                end
                
                return LabelObject
            end
            
            function Section:CreateKeybind(config)
                config = config or {}
                config.Name = config.Name or "Keybind"
                config.Default = config.Default or Enum.KeyCode.Unknown
                config.Flag = config.Flag or nil
                config.Callback = config.Callback or function() end
                
                local SelectedKey = config.Default
                local Listening = false
                
                -- Create keybind frame
                local KeybindFrame = CreateInstance("Frame", {
                    Name = config.Name .. "Keybind",
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundColor3 = Library.Theme.ElementBackground,
                    Parent = SectionContent
                })
                
                local KeybindCorner = CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = KeybindFrame
                })
                
                local KeybindLabel = CreateInstance("TextLabel", {
                    Name = "Label",
                    Text = config.Name,
                    Size = UDim2.new(0.5, -5, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    TextColor3 = Library.Theme.TextColor,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.GothamMedium,
                    TextSize = 12,
                    Parent = KeybindFrame
                })
                
                local KeybindButton = CreateInstance("TextButton", {
                    Name = "Button",
                    Text = SelectedKey == Enum.KeyCode.Unknown and "..." or SelectedKey.Name,
                    Size = UDim2.new(0.5, -10, 0, 24),
                    Position = UDim2.new(0.5, 5, 0.5, -12),
                    BackgroundColor3 = Library.Theme.ElementBackgroundHover,
                    TextColor3 = Library.Theme.TextColor,
                    Font = Enum.Font.GothamMedium,
                    TextSize = 12,
                    AutoButtonColor = false,
                    Parent = KeybindFrame
                })
                
                local KeybindButtonCorner = CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = KeybindButton
                })
                
                -- Create ripple effect
                CreateRipple(KeybindButton)
                
                -- Save to flags if flag specified
                if config.Flag then
                    Library.Flags[config.Flag] = SelectedKey
                end
                
                KeybindButton.MouseButton1Click:Connect(function()
                    if Listening then return end
                    
                    Listening = true
                    KeybindButton.Text = "..."
                    
                    local InputConnection
                    InputConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                        if gameProcessed then return end
                        
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            SelectedKey = input.KeyCode
                            KeybindButton.Text = SelectedKey.Name
                            
                            if config.Flag then
                                Library.Flags[config.Flag] = SelectedKey
                            end
                            
                            Listening = false
                            InputConnection:Disconnect()
                            
                            pcall(config.Callback, SelectedKey)
                        end
                    end)
                end)
                
                KeybindFrame.MouseEnter:Connect(function()
                    Tween(KeybindFrame, {BackgroundColor3 = Library.Theme.ElementBackgroundHover}, 0.2)
                end)
                
                KeybindFrame.MouseLeave:Connect(function()
                    Tween(KeybindFrame, {BackgroundColor3 = Library.Theme.ElementBackground}, 0.2)
                end)
                
                -- Add input handler for when key is pressed
                table.insert(Library.Connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if gameProcessed then return end
                    
                    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == SelectedKey then
                        pcall(config.Callback, SelectedKey)
                    end
                end))
                
                local Keybind = {}
                Keybind.__index = Keybind
                
                function Keybind:Set(key)
                    SelectedKey = key
                    KeybindButton.Text = key.Name
                    
                    if config.Flag then
                        Library.Flags[config.Flag] = key
                    end
                end
                
                function Keybind:Get()
                    return SelectedKey
                end
                
                return Keybind
            end
            
            return Section
        end
        
        return Tab
    end
    
    -- Set Library window reference
    Library.Window = Window
    
    return Window
end

-- Create notification function
function Frosty:Notify(config)
    config = config or {}
    config.Title = config.Title or "Notification"
    config.Content = config.Content or "This is a notification."
    config.Duration = config.Duration or 5
    config.Image = config.Image or "rbxassetid://4483362458"
    config.Actions = config.Actions or {}
    
    -- Create notification GUI
    local NotificationGUI = game:GetService("CoreGui"):FindFirstChild("FrostyNotifications")
    
    if not NotificationGUI then
        NotificationGUI = CreateInstance("ScreenGui", {
            Name = "FrostyNotifications",
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            ResetOnSpawn = false,
            Parent = game:GetService("CoreGui")
        })
        
        local NotificationContainer = CreateInstance("Frame", {
            Name = "NotificationContainer",
            Size = UDim2.new(0, 300, 1, 0),
            Position = UDim2.new(1, -310, 0, 0),
            BackgroundTransparency = 1,
            Parent = NotificationGUI
        })
        
        local NotificationLayout = CreateInstance("UIListLayout", {
            Padding = UDim.new(0, 10),
            FillDirection = Enum.FillDirection.Vertical,
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            Parent = NotificationContainer
        })
        
        local NotificationPadding = CreateInstance("UIPadding", {
            PaddingBottom = UDim.new(0, 10),
            Parent = NotificationContainer
        })
    end
    
    -- Get notification container
    local NotificationContainer = NotificationGUI.NotificationContainer
    
    -- Create notification frame
    local Notification = CreateInstance("Frame", {
        Name = "Notification",
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = Library.Theme.MainBackground,
        AutomaticSize = Enum.AutomaticSize.Y,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Parent = NotificationContainer
    })
    
    local NotificationCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = Notification
    })
    
    local NotificationStroke = CreateInstance("UIStroke", {
        Color = Library.Theme.AccentColor,
        Thickness = 1,
        Parent = Notification
    })
    
    -- Create notification content
    local NotificationImage = CreateInstance("ImageLabel", {
        Name = "Image",
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0, 15, 0, 15),
        BackgroundTransparency = 1,
        Image = config.Image,
        Parent = Notification
    })
    
    local NotificationTitle = CreateInstance("TextLabel", {
        Name = "Title",
        Text = config.Title,
        Size = UDim2.new(1, -50, 0, 25),
        Position = UDim2.new(0, 45, 0, 10),
        BackgroundTransparency = 1,
        TextColor3 = Library.Theme.TextColor,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        Parent = Notification
    })
    
    local NotificationContent = CreateInstance("TextLabel", {
        Name = "Content",
        Text = config.Content,
        Size = UDim2.new(1, -30, 0, 0),
        Position = UDim2.new(0, 15, 0, 40),
        BackgroundTransparency = 1,
        TextColor3 = Library.Theme.TextColor,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = Notification
    })
    
    -- Create action buttons if provided
    local ActionsContainer
    
    if #config.Actions > 0 then
        ActionsContainer = CreateInstance("Frame", {
            Name = "ActionsContainer",
            Size = UDim2.new(1, -30, 0, 30),
            Position = UDim2.new(0, 15, 0, NotificationContent.Position.Y.Offset + 5),
            BackgroundTransparency = 1,
            AutomaticSize = Enum.AutomaticSize.Y,
            Parent = Notification
        })
        
        local ActionsLayout = CreateInstance("UIListLayout", {
            Padding = UDim.new(0, 8),
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = ActionsContainer
        })
        
        for _, action in ipairs(config.Actions) do
            local ActionButton = CreateInstance("TextButton", {
                Name = action.Name,
                Text = action.Name,
                Size = UDim2.new(0, 0, 0, 30),
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundColor3 = Library.Theme.AccentColor,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                Font = Enum.Font.GothamBold,
                TextSize = 12,
                AutoButtonColor = false,
                Parent = ActionsContainer
            })
            
            local ActionButtonPadding = CreateInstance("UIPadding", {
                PaddingLeft = UDim.new(0, 12),
                PaddingRight = UDim.new(0, 12),
                Parent = ActionButton
            })
            
            local ActionButtonCorner = CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 4),
                Parent = ActionButton
            })
            
            -- Create ripple effect
            CreateRipple(ActionButton)
            
            ActionButton.MouseButton1Click:Connect(function()
                if action.Callback then
                    pcall(action.Callback)
                end
                
                -- Close notification
                Tween(Notification, {Position = UDim2.new(1.5, 0, 0.5, 0)}, 0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, function()
                    Notification:Destroy()
                end)
            end)
        end
        
        -- Adjust notification content
        NotificationContent.Size = UDim2.new(1, -30, 0, 0)
        ActionsContainer.Position = UDim2.new(0, 15, 0, NotificationContent.Position.Y.Offset + NotificationContent.AbsoluteSize.Y + 10)
    end
    
    -- Create close button
    local CloseButton = CreateInstance("TextButton", {
        Name = "CloseButton",
        Text = "×",
        Size = UDim2.new(0, 25, 0, 25),
        Position = UDim2.new(1, -25, 0, 10),
        BackgroundTransparency = 1,
        TextColor3 = Library.Theme.TextColor,
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        Parent = Notification
    })
    
    CloseButton.MouseButton1Click:Connect(function()
        -- Close notification
        Tween(Notification, {Position = UDim2.new(1.5, 0, 0.5, 0)}, 0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, function()
            Notification:Destroy()
        end)
    end)
    
    -- Animate notification in
    Notification.Position = UDim2.new(1.5, 0, 0.5, 0)
    Tween(Notification, {Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    
    -- Auto close after duration
    task.spawn(function()
        task.wait(config.Duration)
        
        if Notification and Notification.Parent then
            Tween(Notification, {Position = UDim2.new(1.5, 0, 0.5, 0)}, 0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, function()
                Notification:Destroy()
            end)
        end
    end)
end

-- Get flags utility function
function Frosty:GetFlag(flag)
    return Library.Flags[flag]
end

-- Set theme function
function Frosty:SetTheme(theme)
    for key, value in pairs(theme) do
        Library.Theme[key] = value
    end
    
    -- Update UI elements with new theme
    -- This will be a complex process depending on your implementation
end

return Frosty
