-- Frosty Library - Inspired by Rayfield and Orion

local Frosty = {}

-- Configuration
Frosty.Config = {
    Theme = {
        MainColor = Color3.fromRGB(52, 152, 219), -- Blue - Frosty!
        SecondaryColor = Color3.fromRGB(44, 62, 80), -- Dark Gray
        TextColor = Color3.fromRGB(236, 240, 241), -- Light Gray
        BackgroundColor = Color3.fromRGB(34, 40, 49), -- Darker Gray
        ElementBackgroundColor = Color3.fromRGB(44, 62, 80), -- Dark Gray (lighter than background)
        AccentColor = Color3.fromRGB(255, 255, 255), -- White (for highlights)
    },
    Font = Enum.Font.SourceSansBold,
    AnimationSpeed = 0.2, -- Seconds for animation
    TitleFont = Enum.Font.SourceSansBold,
}

-- Utility Functions
local function Create(type, props)
    local object = Instance.new(type)
    for property, value in pairs(props) do
        object[property] = value
    end
    return object
end

local function Tween(object, props)
    local tweenInfo = TweenInfo.new(
        Frosty.Config.AnimationSpeed,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out,
        0,
        false,
        0
    )
    local tween = game:GetService("TweenService"):Create(object, tweenInfo, props)
    tween:Play()
    return tween
end

-- UI Elements

-- Window Creation
function Frosty.CreateUI(title, description)
    local screenGui = Create("ScreenGui", {
        Name = "FrostyUI",
        ResetOnSpawn = false
    })
    screenGui.Parent = game:GetService("CoreGui")

    local mainWindow = Create("Frame", {
        Name = "MainWindow",
        Size = UDim2.new(0, 400, 0, 300),
        Position = UDim2.new(0.5, -200, 0.5, -150),
        BackgroundColor3 = Frosty.Config.Theme.BackgroundColor,
        BorderSizePixel = 0,
        ClipsDescendants = true,
    })
    mainWindow.Parent = screenGui
    mainWindow.Active = true -- For dragging
    mainWindow.Draggable = true

    -- Title Bar
    local titleBar = Create("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Frosty.Config.Theme.MainColor,
        BorderSizePixel = 0,
    })
    titleBar.Parent = mainWindow

    local titleLabel = Create("TextLabel", {
        Name = "TitleLabel",
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1,
        TextColor3 = Frosty.Config.Theme.TextColor,
        Text = title,
        Font = Frosty.Config.TitleFont,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
    })
    titleLabel.Parent = titleBar

    local closeButton = Create("TextButton", {
        Name = "CloseButton",
        Size = UDim2.new(0, 30, 1, 0),
        Position = UDim2.new(1, -30, 0, 0),
        BackgroundColor3 = Frosty.Config.Theme.MainColor,
        TextColor3 = Frosty.Config.Theme.TextColor,
        Text = "X",
        Font = Frosty.Config.Font,
        TextSize = 16,
        BorderSizePixel = 0,
    })
    closeButton.Parent = titleBar
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)


   -- Description Label
    local descriptionLabel = Create("TextLabel", {
        Name = "DescriptionLabel",
        Size = UDim2.new(1, -20, 0, 40),
        Position = UDim2.new(0, 10, 0, 30),
        BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1,
        TextColor3 = Frosty.Config.Theme.TextColor,
        Text = description,
        Font = Frosty.Config.Font,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
    })
    descriptionLabel.Parent = mainWindow
    descriptionLabel.TextXAlignment = Enum.TextXAlignment.Center -- Center it

    -- Tab Container
    local tabContainer = Create("Frame", {
        Name = "TabContainer",
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, 70), -- Adjust position based on the description
        BackgroundColor3 = Frosty.Config.Theme.ElementBackgroundColor,
        BorderSizePixel = 0,
        ClipsDescendants = true,
    })
    tabContainer.Parent = mainWindow

    -- Content Container (Where the actual UI elements will go)
    local contentContainer = Create("Frame", {
        Name = "ContentContainer",
        Size = UDim2.new(1, 0, 1, -100), -- Takes up rest of the window
        Position = UDim2.new(0, 0, 0, 100), -- Below tabs.  Adjust based on tabs
        BackgroundColor3 = Frosty.Config.Theme.BackgroundColor,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        LayoutOrder = 1,
    })
    contentContainer.Parent = mainWindow

    local tabs = {} -- Store tab objects

    -- Function to create a tab
    local function CreateTab(tabName)
        local tabButton = Create("TextButton", {
            Name = tabName .. "TabButton",
            Size = UDim2.new(0, 100, 1, 0),
            Position = UDim2.new(0, 100 * #tabs, 0, 0),
            BackgroundColor3 = Frosty.Config.Theme.ElementBackgroundColor,
            TextColor3 = Frosty.Config.Theme.TextColor,
            Text = tabName,
            Font = Frosty.Config.Font,
            TextSize = 14,
            BorderSizePixel = 0,
            AutoButtonColor = false,
            LayoutOrder = #tabs + 1,
        })
        tabButton.Parent = tabContainer

        local tabContent = Create("Frame", {
            Name = tabName .. "TabContent",
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundColor3 = Frosty.Config.Theme.BackgroundColor,
            BorderSizePixel = 0,
            Visible = false,
            ClipsDescendants = true,
        })
        tabContent.Parent = contentContainer

        -- UIGridLayout for content inside each tab
        local gridLayout = Create("UIGridLayout", {
            Name = "GridLayout",
            CellSize = UDim2.new(0.33,0,0.25,0),
            CellPadding = UDim2.new(0.01,0,0.01,0)
        })
        gridLayout.Parent = tabContent
        gridLayout:ApplyLayout(Enum.FillDirection.Horizontal)

        -- Initial state: show first tab
        if #tabs == 0 then
            tabContent.Visible = true
            tabButton.BackgroundColor3 = Frosty.Config.Theme.MainColor
        end

        tabButton.MouseButton1Click:Connect(function()
            -- Hide all other tabs
            for i, tab in ipairs(tabs) do
                tab.Content.Visible = false
                tab.Button.BackgroundColor3 = Frosty.Config.Theme.ElementBackgroundColor
            end

            -- Show this tab
            tabContent.Visible = true
            tabButton.BackgroundColor3 = Frosty.Config.Theme.MainColor
        end)

        local tab = {
            Button = tabButton,
            Content = tabContent,
            GridLayout = gridLayout,
            Name = tabName,
        }
        table.insert(tabs, tab)

        return tab
    end


    return {
        ScreenGui = screenGui,
        MainWindow = mainWindow,
        ContentContainer = contentContainer,
        CreateTab = CreateTab,
        Tabs = tabs, -- Return the table of tabs
    }
end



-- Toggle Button
function Frosty.CreateToggle(tab, text, callback)
    if not tab or not tab.Content then
        warn("Invalid tab passed to CreateToggle.")
        return
    end

    local toggleButton = Create("TextButton", {
        Name = text .. "Toggle",
        Size = UDim2.new(1/3, -5, 0.20, 0), -- takes 1/3 width, with some margin
        BackgroundColor3 = Frosty.Config.Theme.ElementBackgroundColor,
        TextColor3 = Frosty.Config.Theme.TextColor,
        Text = text,
        Font = Frosty.Config.Font,
        TextSize = 14,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        LayoutOrder = #tab.Content:GetChildren() + 1,
    })

    toggleButton.Parent = tab.Content
    toggleButton.Parent = tab.Content

    local state = false -- Initial state

    local function updateVisuals()
        if state then
            toggleButton.BackgroundColor3 = Frosty.Config.Theme.MainColor
            toggleButton.Text = text .. " (On)"
        else
            toggleButton.BackgroundColor3 = Frosty.Config.Theme.ElementBackgroundColor
            toggleButton.Text = text .. " (Off)"
        end
    end

    updateVisuals()

    toggleButton.MouseButton1Click:Connect(function()
        state = not state
        updateVisuals()
        if callback then
            callback(state)
        end
    end)

    return toggleButton
end

-- Slider
function Frosty.CreateSlider(tab, text, min, max, defaultValue, callback)
    if not tab or not tab.Content then
        warn("Invalid tab passed to CreateSlider.")
        return
    end

    local sliderFrame = Create("Frame", {
        Name = text .. "SliderFrame",
        Size = UDim2.new(1/3, -5, 0.20, 0),
        BackgroundColor3 = Frosty.Config.Theme.BackgroundColor,
        BorderSizePixel = 0,
        LayoutOrder = #tab.Content:GetChildren() + 1,
    })
    sliderFrame.Parent = tab.Content

    local label = Create("TextLabel", {
        Name = text .. "Label",
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1,
        TextColor3 = Frosty.Config.Theme.TextColor,
        Text = text .. ": " .. defaultValue,
        Font = Frosty.Config.Font,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    label.Parent = sliderFrame

    local slider = Create("Slider", {
        Name = text .. "Slider",
        Size = UDim2.new(1, -10, 0, 20),
        Position = UDim2.new(0, 5, 0, 20),
        BackgroundColor3 = Frosty.Config.Theme.ElementBackgroundColor,
        BorderColor3 = Frosty.Config.Theme.AccentColor,
        Min = min,
        Max = max,
        Value = defaultValue,
    })
    slider.Parent = sliderFrame

    slider.Changed:Connect(function()
        label.Text = text .. ": " .. string.format("%.2f", slider.Value) -- Format to 2 decimal places
        if callback then
            callback(slider.Value)
        end
    end)

    return slider
end

-- Button
function Frosty.CreateButton(tab, text, callback)
    if not tab or not tab.Content then
        warn("Invalid tab passed to CreateButton.")
        return
    end

    local button = Create("TextButton", {
        Name = text .. "Button",
        Size = UDim2.new(1/3, -5, 0.20, 0),
        BackgroundColor3 = Frosty.Config.Theme.MainColor,
        TextColor3 = Frosty.Config.Theme.TextColor,
        Text = text,
        Font = Frosty.Config.Font,
        TextSize = 14,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        LayoutOrder = #tab.Content:GetChildren() + 1,
    })
    button.Parent = tab.Content

    button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)

    return button
end

-- Textbox
function Frosty.CreateTextbox(tab, text, placeholder, callback)
    if not tab or not tab.Content then
        warn("Invalid tab passed to CreateTextbox.")
        return
    end

    local textboxFrame = Create("Frame", {
        Name = text .. "TextboxFrame",
        Size = UDim2.new(1/3, -5, 0.20, 0),
        BackgroundColor3 = Frosty.Config.Theme.BackgroundColor,
        BorderSizePixel = 0,
        LayoutOrder = #tab.Content:GetChildren() + 1,
    })
    textboxFrame.Parent = tab.Content

    local label = Create("TextLabel", {
        Name = text .. "Label",
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1,
        TextColor3 = Frosty.Config.Theme.TextColor,
        Text = text,
        Font = Frosty.Config.Font,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    label.Parent = textboxFrame

    local textbox = Create("TextBox", {
        Name = text .. "Textbox",
        Size = UDim2.new(1, -10, 0, 20),
        Position = UDim2.new(0, 5, 0, 20),
        BackgroundColor3 = Frosty.Config.Theme.ElementBackgroundColor,
        TextColor3 = Frosty.Config.Theme.TextColor,
        PlaceholderText = placeholder,
        PlaceholderColor3 = Color3.new(0.5, 0.5, 0.5),
        Font = Frosty.Config.Font,
        TextSize = 14,
    })
    textbox.Parent = textboxFrame

    textbox.FocusLost:Connect(function(enterPressed)
        if callback then
            callback(textbox.Text, enterPressed)
        end
    end)

    return textbox
end

--Dropdown
function Frosty.CreateDropdown(tab, text, options, callback)
    if not tab or not tab.Content then
        warn("Invalid tab passed to CreateDropdown.")
        return
    end

    local dropdownFrame = Create("Frame", {
        Name = text .. "DropdownFrame",
        Size = UDim2.new(1/3, -5, 0.20, 0),
        BackgroundColor3 = Frosty.Config.Theme.BackgroundColor,
        BorderSizePixel = 0,
        LayoutOrder = #tab.Content:GetChildren() + 1,
        ClipsDescendants = true
    })
    dropdownFrame.Parent = tab.Content

    local label = Create("TextLabel", {
        Name = text .. "Label",
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1,
        TextColor3 = Frosty.Config.Theme.TextColor,
        Text = text,
        Font = Frosty.Config.Font,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    label.Parent = dropdownFrame

    local dropdownButton = Create("TextButton", {
        Name = text .. "DropdownButton",
        Size = UDim2.new(1, -10, 0, 20),
        Position = UDim2.new(0, 5, 0, 20),
        BackgroundColor3 = Frosty.Config.Theme.ElementBackgroundColor,
        TextColor3 = Frosty.Config.Theme.TextColor,
        Text = options[1],
        Font = Frosty.Config.Font,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        AutoButtonColor = false,
    })
    dropdownButton.Parent = dropdownFrame

    local optionsFrame = Create("Frame", {
        Name = "OptionsFrame",
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Frosty.Config.Theme.ElementBackgroundColor,
        BorderSizePixel = 0,
        Visible = false,
        ClipsDescendants = true,
        ZIndex = 2
    })
    optionsFrame.Parent = dropdownFrame
    optionsFrame:SetAttribute("Height", 0)

    local dropdownOpen = false

    local function toggleDropdown()
        dropdownOpen = not dropdownOpen
        if dropdownOpen then
            Tween(optionsFrame, {Size = UDim2.new(1,0, 0, 20*#options)})
            optionsFrame.Visible = true
        else
            Tween(optionsFrame, {Size = UDim2.new(1,0,0,0)})
            task.wait(Frosty.Config.AnimationSpeed)
            optionsFrame.Visible = false
        end
    end

    dropdownButton.MouseButton1Click:Connect(toggleDropdown)

    for i, option in ipairs(options) do
        local optionButton = Create("TextButton", {
            Name = option .. "Option",
            Size = UDim2.new(1, 0, 0, 20),
            Position = UDim2.new(0, 0, 0, 20 * (i - 1)),
            BackgroundColor3 = Frosty.Config.Theme.ElementBackgroundColor,
            TextColor3 = Frosty.Config.Theme.TextColor,
            Text = option,
            Font = Frosty.Config.Font,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center,
            AutoButtonColor = false,
        })
        optionButton.Parent = optionsFrame

        optionButton.MouseButton1Click:Connect(function()
            dropdownButton.Text = option
            toggleDropdown()

            if callback then
                callback(option)
            end
        end)
    end
    return dropdownButton
end
return Frosty
