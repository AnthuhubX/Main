--[[
    Frosty UI Library
    A modern and frosty themed UI library for Roblox
    Inspired by Wizard UI Library
]]

local Frosty = {}
Frosty.__index = Frosty

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TextService = game:GetService("TextService")

-- Variables
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Constants
local TWEEN_INFO = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local FROSTY_BLUE = Color3.fromRGB(120, 215, 255)
local FROSTY_DARK = Color3.fromRGB(30, 35, 45)
local FROSTY_DARKER = Color3.fromRGB(20, 25, 35)
local FROSTY_LIGHT = Color3.fromRGB(230, 240, 255)

-- Utility Functions
local function createInstance(className, properties)
    local instance = Instance.new(className)
    for property, value in pairs(properties) do
        instance[property] = value
    end
    return instance
end

local function createTween(instance, properties)
    return TweenService:Create(instance, TWEEN_INFO, properties)
end

local function addRippleEffect(button)
    button.ClipsDescendants = true
    
    button.MouseButton1Down:Connect(function(x, y)
        local ripple = createInstance("Frame", {
            Name = "Ripple",
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.7,
            Position = UDim2.new(0, x - button.AbsolutePosition.X, 0, y - button.AbsolutePosition.Y),
            Size = UDim2.new(0, 0, 0, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BorderSizePixel = 0,
            ZIndex = button.ZIndex + 1,
            Parent = button
        })
        
        local circle = createInstance("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = ripple
        })
        
        local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
        local growTween = createTween(ripple, {Size = UDim2.new(0, maxSize, 0, maxSize)})
        local fadeTween = createTween(ripple, {BackgroundTransparency = 1})
        
        growTween:Play()
        fadeTween:Play()
        
        fadeTween.Completed:Connect(function()
            ripple:Destroy()
        end)
    end)
end

-- Create the UI library
function Frosty.new(title)
    local self = setmetatable({}, Frosty)
    
    -- Main UI Frame
    self.ScreenGui = createInstance("ScreenGui", {
        Name = "FrostyUI",
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })
    
    -- Main Container
    self.MainFrame = createInstance("Frame", {
        Name = "MainFrame",
        BackgroundColor3 = FROSTY_DARK,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -200, 0.5, -150),
        Size = UDim2.new(0, 400, 0, 300),
        Parent = self.ScreenGui
    })
    
    -- Shadow effect
    local shadow = createInstance("ImageLabel", {
        Name = "Shadow",
        BackgroundTransparency = 1,
        Image = "rbxassetid://6014261993",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.5,
        Position = UDim2.new(0, -15, 0, -15),
        Size = UDim2.new(1, 30, 1, 30),
        ZIndex = 0,
        Parent = self.MainFrame
    })
    
    -- Rounded corners
    local corner = createInstance("UICorner", {
        CornerRadius = UDim.new(0, 10),
        Parent = self.MainFrame
    })
    
    -- Title Bar
    self.TitleBar = createInstance("Frame", {
        Name = "TitleBar",
        BackgroundColor3 = FROSTY_DARKER,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 40),
        Parent = self.MainFrame
    })
    
    local titleCorner = createInstance("UICorner", {
        CornerRadius = UDim.new(0, 10),
        Parent = self.TitleBar
    })
    
    -- Make sure the bottom corners of the title bar are not rounded
    local titleBottomCover = createInstance("Frame", {
        Name = "BottomCover",
        BackgroundColor3 = FROSTY_DARKER,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 1, -10),
        Size = UDim2.new(1, 0, 0, 10),
        Parent = self.TitleBar
    })
    
    -- Title Text
    self.TitleText = createInstance("TextLabel", {
        Name = "TitleText",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(1, -30, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = title or "Frosty UI",
        TextColor3 = FROSTY_BLUE,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.TitleBar
    })
    
    -- Close Button
    self.CloseButton = createInstance("TextButton", {
        Name = "CloseButton",
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -40, 0, 0),
        Size = UDim2.new(0, 40, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = "×",
        TextColor3 = FROSTY_LIGHT,
        TextSize = 24,
        Parent = self.TitleBar
    })
    
    -- Content Frame
    self.ContentFrame = createInstance("Frame", {
        Name = "ContentFrame",
        BackgroundColor3 = FROSTY_DARK,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 40),
        Size = UDim2.new(1, 0, 1, -40),
        ClipsDescendants = true,
        Parent = self.MainFrame
    })
    
    -- Tab Container
    self.TabButtons = createInstance("Frame", {
        Name = "TabButtons",
        BackgroundColor3 = FROSTY_DARKER,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 10, 0, 10),
        Size = UDim2.new(0, 120, 1, -20),
        Parent = self.ContentFrame
    })
    
    local tabCorner = createInstance("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = self.TabButtons
    })
    
    -- Tab Content Area
    self.TabContent = createInstance("Frame", {
        Name = "TabContent",
        BackgroundColor3 = FROSTY_DARKER,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 140, 0, 10),
        Size = UDim2.new(1, -150, 1, -20),
        Parent = self.ContentFrame
    })
    
    local contentCorner = createInstance("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = self.TabContent
    })
    
    -- List for tab buttons
    self.TabButtonList = createInstance("ScrollingFrame", {
        Name = "TabButtonList",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 10),
        Size = UDim2.new(1, 0, 1, -20),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = FROSTY_BLUE,
        Parent = self.TabButtons
    })
    
    local listLayout = createInstance("UIListLayout", {
        Padding = UDim.new(0, 5),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = self.TabButtonList
    })
    
    -- Make UI draggable
    local dragging, dragInput, dragStart, startPos
    
    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
        end
    end)
    
    self.TitleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            self.MainFrame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X, 
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Close button functionality
    self.CloseButton.MouseButton1Click:Connect(function()
        self.ScreenGui:Destroy()
    end)
    
    -- Initialize tabs system
    self.Tabs = {}
    self.ActiveTab = nil
    
    return self
end

-- Create a new tab
function Frosty:CreateTab(name)
    local tab = {}
    tab.Name = name
    tab.Elements = {}
    
    -- Tab Button
    tab.Button = createInstance("TextButton", {
        Name = name.."Tab",
        BackgroundColor3 = FROSTY_DARK,
        BorderSizePixel = 0,
        Size = UDim2.new(0.9, 0, 0, 30),
        Font = Enum.Font.Gotham,
        Text = name,
        TextColor3 = FROSTY_LIGHT,
        TextSize = 14,
        Parent = self.TabButtonList
    })
    
    local tabButtonCorner = createInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = tab.Button
    })
    
    -- Add ripple effect to button
    addRippleEffect(tab.Button)
    
    -- Tab Content Container
    tab.Container = createInstance("ScrollingFrame", {
        Name = name.."Container",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 10, 0, 10),
        Size = UDim2.new(1, -20, 1, -20),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = FROSTY_BLUE,
        Visible = false,
        Parent = self.TabContent
    })
    
    local containerLayout = createInstance("UIListLayout", {
        Padding = UDim.new(0, 8),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = tab.Container
    })
    
    containerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tab.Container.CanvasSize = UDim2.new(0, 0, 0, containerLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Handle tab selection
    tab.Button.MouseButton1Click:Connect(function()
        self:SelectTab(name)
    end)
    
    -- Add this tab to our tabs table
    self.Tabs[name] = tab
    
    -- Auto-select first tab
    if not self.ActiveTab then
        self:SelectTab(name)
    end
    
    -- Update TabButtonList canvas size
    self.TabButtonList.CanvasSize = UDim2.new(
        0, 0, 
        0, #self.TabButtonList:GetChildren() * 35
    )
    
    -- Return tab object with methods for adding elements
    local TabMethods = {}
    
    -- Add a button to the tab
    function TabMethods:AddButton(text, callback)
        callback = callback or function() end
        
        local button = createInstance("TextButton", {
            Name = text.."Button",
            BackgroundColor3 = FROSTY_DARKER,
            BorderSizePixel = 0,
            Size = UDim2.new(0.95, 0, 0, 35),
            Font = Enum.Font.Gotham,
            Text = text,
            TextColor3 = FROSTY_LIGHT,
            TextSize = 14,
            Parent = tab.Container
        })
        
        local buttonCorner = createInstance("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = button
        })
        
        -- Hover effect
        button.MouseEnter:Connect(function()
            createTween(button, {BackgroundColor3 = Color3.fromRGB(40, 45, 60)}):Play()
        end)
        
        button.MouseLeave:Connect(function()
            createTween(button, {BackgroundColor3 = FROSTY_DARKER}):Play()
        end)
        
        -- Click effect
        addRippleEffect(button)
        
        button.MouseButton1Click:Connect(function()
            callback()
        end)
        
        return button
    end
    
    -- Add a toggle switch to the tab
    function TabMethods:AddToggle(text, default, callback)
        default = default or false
        callback = callback or function() end
        
        local toggleContainer = createInstance("Frame", {
            Name = text.."Toggle",
            BackgroundColor3 = FROSTY_DARKER,
            BorderSizePixel = 0,
            Size = UDim2.new(0.95, 0, 0, 35),
            Parent = tab.Container
        })
        
        local containerCorner = createInstance("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = toggleContainer
        })
        
        local toggleLabel = createInstance("TextLabel", {
            Name = "Label",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 0),
            Size = UDim2.new(1, -60, 1, 0),
            Font = Enum.Font.Gotham,
            Text = text,
            TextColor3 = FROSTY_LIGHT,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = toggleContainer
        })
        
        local toggleButton = createInstance("Frame", {
            Name = "ToggleButton",
            BackgroundColor3 = default and FROSTY_BLUE or Color3.fromRGB(80, 85, 90),
            Position = UDim2.new(1, -50, 0.5, -10),
            Size = UDim2.new(0, 40, 0, 20),
            Parent = toggleContainer
        })
        
        local toggleCorner = createInstance("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = toggleButton
        })
        
        local toggleCircle = createInstance("Frame", {
            Name = "Circle",
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Position = UDim2.new(default and 0.5 or 0, default and 0 or 2, 0.5, -8),
            Size = UDim2.new(0, 16, 0, 16),
            Parent = toggleButton
        })
        
        local circleCorner = createInstance("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = toggleCircle
        })
        
        local toggle = {Value = default}
        
        local function updateToggle()
            toggle.Value = not toggle.Value
            local pos = toggle.Value and 0.5 or 0
            local offset = toggle.Value and 0 or 2
            local color = toggle.Value and FROSTY_BLUE or Color3.fromRGB(80, 85, 90)
            
            createTween(toggleCircle, {Position = UDim2.new(pos, offset, 0.5, -8)}):Play()
            createTween(toggleButton, {BackgroundColor3 = color}):Play()
            
            callback(toggle.Value)
        end
        
        toggleContainer.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                updateToggle()
            end
        end)
        
        function toggle:Set(value)
            if value ~= toggle.Value then
                updateToggle()
            end
        end
        
        return toggle
    end
    
    -- Add a slider to the tab
    function TabMethods:AddSlider(text, options, callback)
        options = options or {}
        options.min = options.min or 0
        options.max = options.max or 100
        options.default = options.default or options.min
        callback = callback or function() end
        
        local sliderContainer = createInstance("Frame", {
            Name = text.."Slider",
            BackgroundColor3 = FROSTY_DARKER,
            BorderSizePixel = 0,
            Size = UDim2.new(0.95, 0, 0, 50),
            Parent = tab.Container
        })
        
        local containerCorner = createInstance("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = sliderContainer
        })
        
        local sliderLabel = createInstance("TextLabel", {
            Name = "Label",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 0),
            Size = UDim2.new(1, -20, 0, 25),
            Font = Enum.Font.Gotham,
            Text = text,
            TextColor3 = FROSTY_LIGHT,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = sliderContainer
        })
        
        local valueLabel = createInstance("TextLabel", {
            Name = "Value",
            BackgroundTransparency = 1,
            Position = UDim2.new(0.8, 0, 0, 0),
            Size = UDim2.new(0.2, -10, 0, 25),
            Font = Enum.Font.Gotham,
            Text = tostring(options.default),
            TextColor3 = FROSTY_BLUE,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Right,
            Parent = sliderContainer
        })
        
        local sliderBg = createInstance("Frame", {
            Name = "Background",
            BackgroundColor3 = Color3.fromRGB(50, 55, 60),
            BorderSizePixel = 0,
            Position = UDim2.new(0, 10, 0, 30),
            Size = UDim2.new(1, -20, 0, 5),
            Parent = sliderContainer
        })
        
        local bgCorner = createInstance("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = sliderBg
        })
        
        local sliderFill = createInstance("Frame", {
            Name = "Fill",
            BackgroundColor3 = FROSTY_BLUE,
            BorderSizePixel = 0,
            Size = UDim2.new(0, 0, 1, 0),
            Parent = sliderBg
        })
        
        local fillCorner = createInstance("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = sliderFill
        })
        
        local sliderKnob = createInstance("Frame", {
            Name = "Knob",
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Position = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.new(0, 12, 0, 12),
            ZIndex = 2,
            Parent = sliderBg
        })
        
        local knobCorner = createInstance("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = sliderKnob
        })
        
        local slider = {Value = options.default}
        
        local function updateSlider(value)
            local percent
            
            if value then
                slider.Value = math.clamp(value, options.min, options.max)
                percent = (slider.Value - options.min) / (options.max - options.min)
            else
                percent = (slider.Value - options.min) / (options.max - options.min)
            end
            
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            sliderKnob.Position = UDim2.new(percent, 0, 0.5, 0)
            valueLabel.Text = tostring(math.floor(slider.Value * 100) / 100)
            
            callback(slider.Value)
        end
        
        updateSlider()
        
        local dragging = false
        
        sliderBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                
                local percent = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                local value = options.min + (options.max - options.min) * percent
                
                updateSlider(value)
            end
        end)
        
        sliderBg.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local percent = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                local value = options.min + (options.max - options.min) * percent
                
                updateSlider(value)
            end
        end)
        
        function slider:Set(value)
            updateSlider(value)
        end
        
        return slider
    end
    
    -- Add a dropdown to the tab
    function TabMethods:AddDropdown(text, options, callback)
        options = options or {}
        callback = callback or function() end
        
        local dropdownContainer = createInstance("Frame", {
            Name = text.."Dropdown",
            BackgroundColor3 = FROSTY_DARKER,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            Size = UDim2.new(0.95, 0, 0, 35),
            Parent = tab.Container
        })
        
        local containerCorner = createInstance("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = dropdownContainer
        })
        
        local dropdownHeader = createInstance("TextButton", {
            Name = "Header",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 35),
            Font = Enum.Font.Gotham,
            Text = text,
            TextColor3 = FROSTY_LIGHT,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = dropdownContainer
        })
        
        local headerPadding = createInstance("UIPadding", {
            PaddingLeft = UDim.new(0, 10),
            Parent = dropdownHeader
        })
        
        local selectedText = createInstance("TextLabel", {
            Name = "SelectedText",
            BackgroundTransparency = 1,
            Position = UDim2.new(0.6, 0, 0, 0),
            Size = UDim2.new(0.35, 0, 1, 0),
            Font = Enum.Font.Gotham,
            Text = options[1] or "Select",
            TextColor3 = FROSTY_BLUE,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Right,
            Parent = dropdownHeader
        })
        
        local arrowIcon = createInstance("TextLabel", {
            Name = "Arrow",
            BackgroundTransparency = 1,
            Position = UDim2.new(0.95, 0, 0, 0),
            Size = UDim2.new(0.05, 0, 1, 0),
            Font = Enum.Font.Gotham,
            Text = "▼",
            TextColor3 = FROSTY_LIGHT,
            TextSize = 12,
            Parent = dropdownHeader
        })
        
        local optionContainer = createInstance("Frame", {
            Name = "Options",
            BackgroundColor3 = Color3.fromRGB(40, 45, 55),
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0, 35),
            Size = UDim2.new(1, 0, 0, #options * 25),
            Visible = false,
            Parent = dropdownContainer
        })
        
        local optionLayout = createInstance("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = optionContainer
        })
        
        local dropdown = {Value = options[1] or ""}
        local open = false
        
        -- Create option buttons
        for i, option in ipairs(options) do
            local optionButton = createInstance("TextButton", {
                Name = option,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 25),
                Font = Enum.Font.Gotham,
                Text = option,
                TextColor3 = FROSTY_LIGHT,
                TextSize = 14,
                Parent = optionContainer
            })
            
            local optionPadding = createInstance("UIPadding", {
                PaddingLeft = UDim.new(0, 10),
                Parent = optionButton
            })
            
            optionButton.MouseEnter:Connect(function()
                createTween(optionButton, {BackgroundColor3 = Color3.fromRGB(50, 55, 65), BackgroundTransparency = 0}):Play()
            end)
            
            optionButton.MouseLeave:Connect(function()
                createTween(optionButton, {BackgroundTransparency = 1}):Play()
            end)
            
            optionButton.MouseButton1Click:Connect(function()
                dropdown.Value = option
                selectedText.Text = option
                createTween(dropdownContainer, {Size = UDim2.new(0.95, 0, 0, 35)}):Play()
                optionContainer.Visible = false
                open = false
                arrowIcon.Text = "▼"
                callback(option)
            end)
        end
        
        -- Toggle dropdown
        dropdownHeader.MouseButton1Click:Connect(function()
            if open then
                createTween(dropdownContainer, {Size = UDim2.new(0.95, 0, 0, 35)}):Play()
                optionContainer.Visible = false
                open = false
                arrowIcon.Text = "▼"
            else
                createTween(dropdownContainer, {Size = UDim2.new(0.95, 0, 0, 35 + optionContainer.AbsoluteSize.Y)}):Play()
                optionContainer.Visible = true
                open = true
                arrowIcon.Text = "▲"
            end
        end)
        
        function dropdown:Set(value)
            for _, option in ipairs(options) do
                if option == value then
                    dropdown.Value = value
                    selectedText.Text = value
                    callback(value)
                    break
                end
            end
        end
        
        function dropdown:Refresh(newOptions)
            -- Clear old options
            for _, child in ipairs(optionContainer:GetChildren()) do
                if child:IsA("TextButton") then
                    child:Destroy()
                end
            end
            
            -- Add new options
            for i, option in ipairs(newOptions) do
                local optionButton = createInstance("TextButton", {
                    Name = option,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 25),
                    Font = Enum.Font.Gotham,
                    Text = option,
                    TextColor3 = FROSTY_LIGHT,
                    TextSize = 14,
                    Parent = optionContainer
                })
                
                local optionPadding = createInstance("UIPadding", {
                    PaddingLeft = UDim.new(0, 10),
                    Parent = optionButton
                })
                
                optionButton.MouseEnter:Connect(function()
                    createTween(optionButton, {BackgroundColor3 = Color3.fromRGB(50, 55, 65), BackgroundTransparency = 0}):Play()
                end)
                
                optionButton.MouseLeave:Connect(function()
                    createTween(optionButton, {BackgroundTransparency = 1}):Play()
                end)
                
                optionButton.MouseButton1Click:Connect(function()
                    dropdown.Value = option
                    selectedText.Text = option
                    createTween(dropdownContainer, {Size = UDim2.new(0.95, 0, 0, 35)}):Play()
                    optionContainer.Visible = false
                    open = false
                    arrowIcon.Text = "▼"
                    callback(option)
                end)
            end
            
            -- Update size
            optionContainer.Size = UDim2.new(1, 0, 0, #newOptions * 25)
        end
        
        return dropdown
    end
    
    -- Add a text input to the tab
    function TabMethods:AddTextbox(text, default, callback)
        default = default or ""
        callback = callback or function() end
        
        local textboxContainer = createInstance("Frame", {
            Name = text.."Textbox",
            BackgroundColor3 = FROSTY_DARKER,
            BorderSizePixel = 0,
            Size = UDim2.new(0.95, 0, 0, 35),
            Parent = tab.Container
        })
        
        local containerCorner = createInstance("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = textboxContainer
        })
        
        local textboxLabel = createInstance("TextLabel", {
            Name = "Label",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 0),
            Size = UDim2.new(0.3, -10, 1, 0),
            Font = Enum.Font.Gotham,
            Text = text,
            TextColor3 = FROSTY_LIGHT,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = textboxContainer
        })
        
        local textboxInput = createInstance("TextBox", {
            Name = "Input",
            BackgroundColor3 = Color3.fromRGB(40, 45, 55),
            BorderSizePixel = 0,
            Position = UDim2.new(0.3, 0, 0.5, -15),
            Size = UDim2.new(0.65, -15, 0, 30),
            Font = Enum.Font.Gotham,
            PlaceholderText = "Type here...",
            Text = default,
            TextColor3 = FROSTY_LIGHT,
            PlaceholderColor3 = Color3.fromRGB(130, 140, 150),
            TextSize = 14,
            ClearTextOnFocus = false,
            Parent = textboxContainer
        })
        
        local inputCorner = createInstance("UICorner", {
            CornerRadius = UDim.new(0, 4),
            Parent = textboxInput
        })
        
        local padding = createInstance("UIPadding", {
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            Parent = textboxInput
        })
        
        local textbox = {Value = default}
        
        textboxInput.Focused:Connect(function()
            createTween(textboxInput, {BackgroundColor3 = Color3.fromRGB(50, 55, 65)}):Play()
        end)
        
        textboxInput.FocusLost:Connect(function(enterPressed)
            createTween(textboxInput, {BackgroundColor3 = Color3.fromRGB(40, 45, 55)}):Play()
            textbox.Value = textboxInput.Text
            callback(textboxInput.Text, enterPressed)
        end)
        
        function textbox:Set(value)
            textbox.Value = value
            textboxInput.Text = value
            callback(value)
        end
        
        return textbox
    end
    
    -- Add a label to the tab
    function TabMethods:AddLabel(text)
        local label = createInstance("TextLabel", {
            Name = "Label",
            BackgroundColor3 = FROSTY_DARKER,
            BorderSizePixel = 0,
            Size = UDim2.new(0.95, 0, 0, 30),
            Font = Enum.Font.GothamBold,
            Text = text,
            TextColor3 = FROSTY_BLUE,
            TextSize = 14,
            Parent = tab.Container
        })
        
        local labelCorner = createInstance("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = label
        })
        
        local labelObj = {
            Instance = label
        }
        
        function labelObj:Set(newText)
            label.Text = newText
        end
        
        return labelObj
    end
    
    -- Add a separator to the tab
    function TabMethods:AddSeparator()
        local separator = createInstance("Frame", {
            Name = "Separator",
            BackgroundColor3 = Color3.fromRGB(60, 65, 75),
            BorderSizePixel = 0,
            Size = UDim2.new(0.8, 0, 0, 1),
            Parent = tab.Container
        })
        
        return separator
    end
    
    -- Add a color picker to the tab
    function TabMethods:AddColorPicker(text, default, callback)
        default = default or Color3.fromRGB(255, 255, 255)
        callback = callback or function() end
        
        local pickerContainer = createInstance("Frame", {
            Name = text.."ColorPicker",
            BackgroundColor3 = FROSTY_DARKER,
            BorderSizePixel = 0,
            Size = UDim2.new(0.95, 0, 0, 35),
            ClipsDescendants = true,
            Parent = tab.Container
        })
        
        local containerCorner = createInstance("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = pickerContainer
        })
        
        local pickerLabel = createInstance("TextLabel", {
            Name = "Label",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 0),
            Size = UDim2.new(1, -60, 1, 0),
            Font = Enum.Font.Gotham,
            Text = text,
            TextColor3 = FROSTY_LIGHT,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = pickerContainer
        })
        
        local colorDisplay = createInstance("Frame", {
            Name = "ColorDisplay",
            BackgroundColor3 = default,
            BorderSizePixel = 0,
            Position = UDim2.new(1, -50, 0.5, -10),
            Size = UDim2.new(0, 40, 0, 20),
            Parent = pickerContainer
        })
        
        local displayCorner = createInstance("UICorner", {
            CornerRadius = UDim.new(0, 4),
            Parent = colorDisplay
        })
        
        local colorPickerMenu = createInstance("Frame", {
            Name = "PickerMenu",
            BackgroundColor3 = Color3.fromRGB(40, 45, 55),
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0, 35),
            Size = UDim2.new(1, 0, 0, 120),
            Visible = false,
            Parent = pickerContainer
        })
        
        local colorH = createInstance("ImageLabel", {
            Name = "ColorH",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 10),
            Size = UDim2.new(1, -20, 0, 20),
            Image = "rbxassetid://4155801252",
            Parent = colorPickerMenu
        })
        
        local hCorner = createInstance("UICorner", {
            CornerRadius = UDim.new(0, 4),
            Parent = colorH
        })
        
        local hSlider = createInstance("Frame", {
            Name = "Slider",
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0.5, -8),
            Size = UDim2.new(0, 5, 0, 16),
            Parent = colorH
        })
        
        local hSliderCorner = createInstance("UICorner", {
            CornerRadius = UDim.new(0, 2),
            Parent = hSlider
        })
        
        local colorSV = createInstance("ImageLabel", {
            Name = "ColorSV",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 40),
            Size = UDim2.new(1, -20, 0, 60),
            Image = "rbxassetid://4155801252",
            Parent = colorPickerMenu
        })
        
        local svCorner = createInstance("UICorner", {
            CornerRadius = UDim.new(0, 4),
            Parent = colorSV
        })
        
        local svSlider = createInstance("Frame", {
            Name = "Slider",
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderSizePixel = 0,
            Position = UDim2.new(0.5, -4, 0.5, -4),
            Size = UDim2.new(0, 8, 0, 8),
            ZIndex = 2,
            Parent = colorSV
        })
        
        local svSliderCorner = createInstance("UICorner", {
            CornerRadius = UDim.new(0, 4),
            Parent = svSlider
        })
        
        local colorGradientSV = createInstance("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1))
            }),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(1, 0)
            }),
            Rotation = 0,
            Parent = colorSV
        })
        
        local open = false
        local colorPicker = {Value = default}
        local hue, sat, val = Color3.toHSV(default)
        
        local function updateColor()
            colorGradientSV.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromHSV(hue, 0, 1)),
                ColorSequenceKeypoint.new(1, Color3.fromHSV(hue, 1, 1))
            })
            
            colorPicker.Value = Color3.fromHSV(hue, sat, val)
            colorDisplay.BackgroundColor3 = colorPicker.Value
            callback(colorPicker.Value)
        end
        
        colorDisplay.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                if open then
                    createTween(pickerContainer, {Size = UDim2.new(0.95, 0, 0, 35)}):Play()
                    colorPickerMenu.Visible = false
                    open = false
                else
                    createTween(pickerContainer, {Size = UDim2.new(0.95, 0, 0, 155)}):Play()
                    colorPickerMenu.Visible = true
                    open = true
                end
            end
        end)
        
        -- Hue slider
        local hDragging = false
        
        colorH.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                hDragging = true
                
                local percent = math.clamp((input.Position.X - colorH.AbsolutePosition.X) / colorH.AbsoluteSize.X, 0, 1)
                hue = percent
                hSlider.Position = UDim2.new(percent, -2, 0.5, -8)
                
                updateColor()
            end
        end)
        
        colorH.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                hDragging = false
            end
        end)
        
        -- SV picker
        local svDragging = false
        
        colorSV.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                svDragging = true
                
                local percentX = math.clamp((input.Position.X - colorSV.AbsolutePosition.X) / colorSV.AbsoluteSize.X, 0, 1)
                local percentY = math.clamp((input.Position.Y - colorSV.AbsolutePosition.Y) / colorSV.AbsoluteSize.Y, 0, 1)
                
                sat = percentX
                val = 1 - percentY
                
                svSlider.Position = UDim2.new(percentX, -4, percentY, -4)
                
                updateColor()
            end
        end)
        
        colorSV.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                svDragging = false
            end
        end)
        
        -- Update dragging
        UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                if hDragging then
                    local percent = math.clamp((input.Position.X - colorH.AbsolutePosition.X) / colorH.AbsoluteSize.X, 0, 1)
                    hue = percent
                    hSlider.Position = UDim2.new(percent, -2, 0.5, -8)
                    
                    updateColor()
                elseif svDragging then
                    local percentX = math.clamp((input.Position.X - colorSV.AbsolutePosition.X) / colorSV.AbsoluteSize.X, 0, 1)
                    local percentY = math.clamp((input.Position.Y - colorSV.AbsolutePosition.Y) / colorSV.AbsoluteSize.Y, 0, 1)
                    
                    sat = percentX
                    val = 1 - percentY
                    
                    svSlider.Position = UDim2.new(percentX, -4, percentY, -4)
                    
                    updateColor()
                end
            end
        end)
        
        -- Set initial positions
        hSlider.Position = UDim2.new(hue, -2, 0.5, -8)
        svSlider.Position = UDim2.new(sat, -4, 1 - val, -4)
        
        function colorPicker:Set(color)
            local newH, newS, newV = Color3.toHSV(color)
            hue, sat, val = newH, newS, newV
            
            hSlider.Position = UDim2.new(hue, -2, 0.5, -8)
            svSlider.Position = UDim2.new(sat, -4, 1 - val, -4)
            
            updateColor()
        end
        
        return colorPicker
    end
    
    -- Return the tab methods
    return TabMethods
end

-- Switch to a different tab
function Frosty:SelectTab(name)
    local tab = self.Tabs[name]
    if not tab then return end
    
    -- Hide all tabs
    for _, t in pairs(self.Tabs) do
        t.Container.Visible = false
        createTween(t.Button, {BackgroundColor3 = FROSTY_DARK}):Play()
        createTween(t.Button, {TextColor3 = FROSTY_LIGHT}):Play()
    end
    
    -- Show selected tab
    tab.Container.Visible = true
    createTween(tab.Button, {BackgroundColor3 = FROSTY_BLUE}):Play()
    createTween(tab.Button, {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    
    self.ActiveTab = name
end

-- Create animated notification
function Frosty:Notify(title, message, duration)
    duration = duration or 3
    
    local notification = createInstance("Frame", {
        Name = "Notification",
        BackgroundColor3 = FROSTY_DARKER,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -20, 1, -20),
        AnchorPoint = Vector2.new(1, 1),
        Size = UDim2.new(0, 250, 0, 80),
        Parent = self.ScreenGui
    })
    
    local notifCorner = createInstance("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = notification
    })
    
    local notifTitle = createInstance("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 10),
        Size = UDim2.new(1, -30, 0, 20),
        Font = Enum.Font.GothamBold,
        Text = title,
        TextColor3 = FROSTY_BLUE,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notification
    })
    
    local notifMessage = createInstance("TextLabel", {
        Name = "Message",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 35),
        Size = UDim2.new(1, -30, 0, 30),
        Font = Enum.Font.Gotham,
        Text = message,
        TextColor3 = FROSTY_LIGHT,
        TextSize = 14,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notification
    })
    
    -- Animation
    notification.Position = UDim2.new(1, 300, 1, -20)
    local showTween = createTween(notification, {Position = UDim2.new(1, -20, 1, -20)})
    local hideTween = createTween(notification, {Position = UDim2.new(1, 300, 1, -20)})
    
    showTween:Play()
    
    task.delay(duration, function()
        hideTween:Play()
        hideTween.Completed:Connect(function()
            notification:Destroy()
        end)
    end)
end

-- Return the library
return Frosty
