-- Frosty UI Library - Inspired by Rayfield and Orion UI

local Frosty = {}

-- Configuration
Frosty.Config = {
    Theme = {
        Background = Color3.fromRGB(30, 30, 30),
        Accent = Color3.fromRGB(50, 150, 250),  -- Blue accent, can be changed
        Text = Color3.fromRGB(255, 255, 255),
        SecondaryText = Color3.fromRGB(180, 180, 180),
        Outline = Color3.fromRGB(45, 45, 45),
        ButtonBackground = Color3.fromRGB(40, 40, 40),
        ButtonHover = Color3.fromRGB(60, 60, 60),
        ButtonActive = Color3.fromRGB(75, 75, 75),
        SliderBackground = Color3.fromRGB(35, 35, 35),
        SliderFill = Color3.fromRGB(50, 150, 250),
        SliderThumb = Color3.fromRGB(255, 255, 255),
        InputBackground = Color3.fromRGB(40, 40, 40),
        InputBorder = Color3.fromRGB(60, 60, 60),
        DropdownBackground = Color3.fromRGB(40, 40, 40),
        DropdownHover = Color3.fromRGB(60, 60, 60),
        CheckboxBackground = Color3.fromRGB(40, 40, 40),
        CheckboxCheckmark = Color3.fromRGB(50, 150, 250),
    },
    Font = "rbxasset://fonts/families/SourceSansPro/SourceSansPro-Regular.json",
    TitleFont = "rbxasset://fonts/families/SourceSansPro/SourceSansPro-Bold.json",
    AnimationSpeed = 0.1, -- Adjust for smoother/faster animations
}

-- Helper Functions

local function LerpColor(color1, color2, alpha)
    return color1:Lerp(color2, alpha)
end

local function FadeIn(object, duration)
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = game:GetService("TweenService"):Create(object, tweenInfo, {Transparency = 0})
    tween:Play()
end

local function FadeOut(object, duration)
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = game:GetService("TweenService"):Create(object, tweenInfo, {Transparency = 1})
    tween:Play()
end

local function SlideIn(object, startPosition, endPosition, duration)
	local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tween = game:GetService("TweenService"):Create(object, tweenInfo, {Position = endPosition})
	tween:Play()
end

local function SlideOut(object, startPosition, endPosition, duration)
	local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tween = game:GetService("TweenService"):Create(object, tweenInfo, {Position = endPosition})
	tween:Play()
end

local function CreateButton(parent, text, callback)
    local button = Instance.new("TextButton")
    button.Parent = parent
    button.BackgroundTransparency = 0
    button.BackgroundColor3 = Frosty.Config.Theme.ButtonBackground
    button.TextColor3 = Frosty.Config.Theme.Text
    button.Font = Frosty.Config.Font
    button.TextSize = 14
    button.Text = text
    button.BorderSizePixel = 0

    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Frosty.Config.Theme.ButtonHover
    end)

    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Frosty.Config.Theme.ButtonBackground
    end)

    button.MouseButton1Click:Connect(function()
        button.BackgroundColor3 = Frosty.Config.Theme.ButtonActive
        task.wait(0.1)
        button.BackgroundColor3 = Frosty.Config.Theme.ButtonHover
        callback()
    end)

    return button
end


-- Window Creation

function Frosty.Create(title)
    local window = Instance.new("ScreenGui")
    window.Name = "FrostyWindow"
    window.ResetOnSpawn = false

    local mainFrame = Instance.new("Frame")
    mainFrame.Parent = window
    mainFrame.Size = UDim2.new(0, 400, 0, 300)  -- Initial size, adjust as needed
    mainFrame.Position = UDim2.new(0.3, 0, 0.3, 0) -- Centered-ish
    mainFrame.BackgroundTransparency = 0
    mainFrame.BackgroundColor3 = Frosty.Config.Theme.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.Draggable = true -- Inspired by Rayfield

	--Drop Shadow
	local dropShadow = Instance.new("ImageLabel")
	dropShadow.Parent = mainFrame
	dropShadow.Size = UDim2.new(1,0,1,0)
	dropShadow.Position = UDim2.new(0,0,0,0)
	dropShadow.ZIndex = 0
	dropShadow.Image = "rbxassetid://6342256976"
	dropShadow.ScaleType = Enum.ScaleType.Slice
	dropShadow.SliceCenter = Rect.new(12,12,12,12)
	dropShadow.Visible = true
	dropShadow.BackgroundTransparency = 1

    local titleBar = Instance.new("Frame")
    titleBar.Parent = mainFrame
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundTransparency = 0
    titleBar.BackgroundColor3 = Frosty.Config.Theme.Outline
    titleBar.BorderSizePixel = 0

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = titleBar
    titleLabel.Size = UDim2.new(0.8, 0, 1, 0)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = Frosty.Config.Theme.Text
    titleLabel.Font = Frosty.Config.TitleFont
    titleLabel.TextSize = 16
    titleLabel.Text = title
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextYAlignment = Enum.TextYAlignment.Center
	titleLabel.TextWrapped = true
	titleLabel.TextTruncate = Enum.TextTruncate.AtEnd

    local closeButton = Instance.new("TextButton")
    closeButton.Parent = titleBar
    closeButton.Size = UDim2.new(0, 30, 1, 0)
    closeButton.Position = UDim2.new(1, -30, 0, 0)
    closeButton.BackgroundTransparency = 0
    closeButton.BackgroundColor3 = Frosty.Config.Theme.ButtonBackground
    closeButton.TextColor3 = Frosty.Config.Theme.Text
    closeButton.Font = Frosty.Config.Font
    closeButton.TextSize = 20
    closeButton.Text = "X"
    closeButton.BorderSizePixel = 0

    closeButton.MouseEnter:Connect(function()
        closeButton.BackgroundColor3 = Frosty.Config.Theme.ButtonHover
    end)

    closeButton.MouseLeave:Connect(function()
        closeButton.BackgroundColor3 = Frosty.Config.Theme.ButtonBackground
    end)

    closeButton.MouseButton1Click:Connect(function()
        window:Destroy()
    end)

    local contentFrame = Instance.new("Frame")
    contentFrame.Parent = mainFrame
    contentFrame.Size = UDim2.new(1, 0, 1, -30)
    contentFrame.Position = UDim2.new(0, 0, 0, 30)
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0

    window.Enabled = true -- Make visible upon creation.

	-- Initialize tab list
	local tabs = {}
	local currentTab = nil

    -- Functions to be used within the window.
	local self = {
		Window = window,
		MainFrame = mainFrame,
		ContentFrame = contentFrame,
		Tabs = tabs,
		CurrentTab = currentTab
	}


    -- Define the window's functions and return it

    function self:AddTab(tabName)
		local tabButton = CreateButton(titleBar, tabName, function()
			if self.CurrentTab then
				self.CurrentTab.Frame.Visible = false
				self.CurrentTab.Button.BackgroundColor3 = Frosty.Config.Theme.ButtonBackground
			end
			-- Ensure the Frame exists before trying to set Visible
			if self.Tabs[tabName] and self.Tabs[tabName].Frame then
				self.Tabs[tabName].Frame.Visible = true
				self.Tabs[tabName].Button.BackgroundColor3 = Frosty.Config.Theme.ButtonActive
				self.CurrentTab = self.Tabs[tabName]
			else
				warn("Tab frame not created for tab: " .. tabName)
			end
		end)

		tabButton.Size = UDim2.new(0, 80, 1, 0)
		tabButton.Position = UDim2.new(0, 30 + (#self.Tabs * 80), 0, 0) -- Adjust positioning

		local tabFrame = Instance.new("Frame")
		tabFrame.Parent = self.ContentFrame
		tabFrame.Size = UDim2.new(1,0,1,0)
		tabFrame.Position = UDim2.new(0,0,0,0)
		tabFrame.BackgroundTransparency = 1
		tabFrame.BorderSizePixel = 0
		tabFrame.Visible = false  -- Start hidden

		self.Tabs[tabName] = {
			Button = tabButton,
			Frame = tabFrame
		}
		self.Tabs[tabName].Button.Name = tabName

		-- Set the first tab to be visible by default
		if #self.Tabs == 1 then
			self.CurrentTab = self.Tabs[tabName]
			self.CurrentTab.Frame.Visible = true
			self.CurrentTab.Button.BackgroundColor3 = Frosty.Config.Theme.ButtonActive
		end
        return tabFrame

	end



    -- Helper functions to add elements inside a tab

	--Create a section inside a tab
	function self:AddSection(tabFrame, sectionName)
		local section = Instance.new("Frame")
		section.Parent = tabFrame
		section.Size = UDim2.new(0.95, 0, 0, 30)  -- Adjust height as needed
		section.Position = UDim2.new(0.025, 0, 0, (section.Parent:GetChildrenCount() - 1) * 35) --Dynamic Y pos
		section.BackgroundTransparency = 0
		section.BackgroundColor3 = Frosty.Config.Theme.Outline
		section.BorderSizePixel = 0

		local sectionLabel = Instance.new("TextLabel")
		sectionLabel.Parent = section
		sectionLabel.Size = UDim2.new(1, 0, 1, 0)
		sectionLabel.Position = UDim2.new(0, 0, 0, 0)
		sectionLabel.BackgroundTransparency = 1
		sectionLabel.TextColor3 = Frosty.Config.Theme.Text
		sectionLabel.Font = Frosty.Config.Font
		sectionLabel.TextSize = 14
		sectionLabel.Text = sectionName
		sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
		sectionLabel.TextYAlignment = Enum.TextYAlignment.Center
		sectionLabel.TextWrapped = true
		sectionLabel.TextTruncate = Enum.TextTruncate.AtEnd
		return section
	end

    function self:AddButton(tabFrame, text, callback)
		local buttonPosition = UDim2.new(0.025, 0, 0, ((tabFrame:GetChildrenCount() - 1) * 40) + 35 )
        local button = CreateButton(tabFrame, text, callback)
		button.Size = UDim2.new(0.95, 0, 0, 30)
		button.Position = buttonPosition
        return button
    end

    function self:AddToggle(tabFrame, text, defaultValue, callback)
		local togglePosition = UDim2.new(0.025, 0, 0, ((tabFrame:GetChildrenCount() - 1) * 40) + 35)

        local toggleFrame = Instance.new("Frame")
        toggleFrame.Parent = tabFrame
        toggleFrame.Size = UDim2.new(0.95, 0, 0, 30)
        toggleFrame.Position = togglePosition
        toggleFrame.BackgroundTransparency = 1
        toggleFrame.BorderSizePixel = 0

        local label = Instance.new("TextLabel")
        label.Parent = toggleFrame
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.Position = UDim2.new(0, 0, 0, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Frosty.Config.Theme.Text
        label.Font = Frosty.Config.Font
        label.TextSize = 14
        label.Text = text
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextYAlignment = Enum.TextYAlignment.Center
        label.TextWrapped = true
        label.TextTruncate = Enum.TextTruncate.AtEnd

        local checkbox = Instance.new("TextButton")
        checkbox.Parent = toggleFrame
        checkbox.Size = UDim2.new(0, 30, 1, 0)
        checkbox.Position = UDim2.new(1, -30, 0, 0)
        checkbox.BackgroundTransparency = 0
        checkbox.BackgroundColor3 = Frosty.Config.Theme.CheckboxBackground
        checkbox.TextColor3 = Frosty.Config.Theme.Text
        checkbox.Font = Frosty.Config.Font
        checkbox.TextSize = 20
        checkbox.Text = defaultValue and "✓" or "" -- Checkmark
        checkbox.BorderSizePixel = 0

        local isToggled = defaultValue

        checkbox.MouseButton1Click:Connect(function()
            isToggled = not isToggled
            checkbox.Text = isToggled and "✓" or ""
            if callback then
                callback(isToggled)
            end
        end)

        return toggleFrame -- Allows further customization if needed
    end

    function self:AddSlider(tabFrame, text, minValue, maxValue, defaultValue, callback)
		local sliderPosition = UDim2.new(0.025, 0, 0, ((tabFrame:GetChildrenCount() - 1) * 40) + 35)

        local sliderFrame = Instance.new("Frame")
        sliderFrame.Parent = tabFrame
        sliderFrame.Size = UDim2.new(0.95, 0, 0, 30)
        sliderFrame.Position = sliderPosition
        sliderFrame.BackgroundTransparency = 1
        sliderFrame.BorderSizePixel = 0

        local label = Instance.new("TextLabel")
        label.Parent = sliderFrame
        label.Size = UDim2.new(0.4, 0, 1, 0)
        label.Position = UDim2.new(0, 0, 0, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Frosty.Config.Theme.Text
        label.Font = Frosty.Config.Font
        label.TextSize = 14
        label.Text = text .. ": " .. defaultValue
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextYAlignment = Enum.TextYAlignment.Center
        label.TextWrapped = true
        label.TextTruncate = Enum.TextTruncate.AtEnd

        local sliderBackground = Instance.new("Frame")
        sliderBackground.Parent = sliderFrame
        sliderBackground.Size = UDim2.new(0.5, 0, 0.5, 0)
        sliderBackground.Position = UDim2.new(0.5, 0, 0.25, 0)
        sliderBackground.BackgroundTransparency = 0
        sliderBackground.BackgroundColor3 = Frosty.Config.Theme.SliderBackground
        sliderBackground.BorderSizePixel = 0

        local sliderFill = Instance.new("Frame")
        sliderFill.Parent = sliderBackground
        sliderFill.Size = UDim2.new((defaultValue - minValue) / (maxValue - minValue), 1, 1, 1)
        sliderFill.Position = UDim2.new(0, 0, 0, 0)
        sliderFill.BackgroundTransparency = 0
        sliderFill.BackgroundColor3 = Frosty.Config.Theme.SliderFill
        sliderFill.BorderSizePixel = 0

        local sliderThumb = Instance.new("Frame")
        sliderThumb.Parent = sliderFill
        sliderThumb.Size = UDim2.new(0, 10, 1, 1)
        sliderThumb.Position = UDim2.new(1, -5, 0, 0)
        sliderThumb.BackgroundTransparency = 0
        sliderThumb.BackgroundColor3 = Frosty.Config.Theme.SliderThumb
        sliderThumb.BorderSizePixel = 0

        local dragging = false

        sliderBackground.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)

        sliderBackground.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)

        sliderBackground.MouseMoved:Connect(function(x, y)
            if dragging then
                local xPos = x - sliderBackground.AbsolutePosition.X
                local width = sliderBackground.AbsoluteSize.X
                local ratio = math.clamp(xPos / width, 0, 1)
                local value = minValue + (maxValue - minValue) * ratio
                defaultValue = value
                sliderFill.Size = UDim2.new(ratio, 1, 1, 1)
                label.Text = text .. ": " .. string.format("%.2f", value)
                if callback then
                    callback(value)
                end
            end
        end)

        return sliderFrame
    end

    function self:AddLabel(tabFrame, text)
		local labelPosition = UDim2.new(0.025, 0, 0, ((tabFrame:GetChildrenCount() - 1) * 40) + 35)

        local label = Instance.new("TextLabel")
        label.Parent = tabFrame
        label.Size = UDim2.new(0.95, 0, 0, 30)
        label.Position = labelPosition
        label.BackgroundTransparency = 1
        label.TextColor3 = Frosty.Config.Theme.Text
        label.Font = Frosty.Config.Font
        label.TextSize = 14
        label.Text = text
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextYAlignment = Enum.TextYAlignment.Center
        label.TextWrapped = true
        label.TextTruncate = Enum.TextTruncate.AtEnd

        return label
    end

	function self:AddTextbox(tabFrame, text, placeholder, callback)
		local textboxPosition = UDim2.new(0.025, 0, 0, ((tabFrame:GetChildrenCount() - 1) * 40) + 35)
		local textBoxFrame = Instance.new("Frame")
		textBoxFrame.Parent = tabFrame
		textBoxFrame.Size = UDim2.new(0.95, 0, 0, 30)
		textBoxFrame.Position = textboxPosition
		textBoxFrame.BackgroundTransparency = 1
		textBoxFrame.BorderSizePixel = 0

		local label = Instance.new("TextLabel")
		label.Parent = textBoxFrame
		label.Size = UDim2.new(0.3, 0, 1, 0)
		label.Position = UDim2.new(0, 0, 0, 0)
		label.BackgroundTransparency = 1
		label.TextColor3 = Frosty.Config.Theme.Text
		label.Font = Frosty.Config.Font
		label.TextSize = 14
		label.Text = text
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.TextYAlignment = Enum.TextYAlignment.Center
		label.TextWrapped = true
		label.TextTruncate = Enum.TextTruncate.AtEnd


		local textBox = Instance.new("TextBox")
		textBox.Parent = textBoxFrame
		textBox.Size = UDim2.new(0.65, 0, 1, 0)
		textBox.Position = UDim2.new(0.35, 0, 0, 0)
		textBox.BackgroundTransparency = 0
		textBox.BackgroundColor3 = Frosty.Config.Theme.InputBackground
		textBox.BorderColor3 = Frosty.Config.Theme.InputBorder
		textBox.TextColor3 = Frosty.Config.Theme.Text
		textBox.Font = Frosty.Config.Font
		textBox.TextSize = 14
		textBox.PlaceholderText = placeholder
		textBox.PlaceholderColor3 = Frosty.Config.Theme.SecondaryText
		textBox.ClearTextOnFocus = false

		textBox.Focused:Connect(function()
			textBox.BorderColor3 = Frosty.Config.Theme.Accent
		end)

		textBox.FocusLost:Connect(function()
			textBox.BorderColor3 = Frosty.Config.Theme.InputBorder
		end)

		textBox.Changed:Connect(function()
			if callback then
				callback(textBox.Text)
			end
		end)

		return textBoxFrame
	end

    return self
end


-- Example Usage:

local frostyWindow = Frosty.Create("Frosty UI Example")

local tab1Frame = frostyWindow:AddTab("Tab 1")
local section1 = frostyWindow:AddSection(tab1Frame, "Section 1")
local button1 = frostyWindow:AddButton(tab1Frame, "Click Me", function()
    print("Button 1 Clicked!")
end)

local tab2Frame = frostyWindow:AddTab("Tab 2")
local toggle1 = frostyWindow:AddToggle(tab2Frame, "Enable Feature", false, function(state)
    print("Toggle state:", state)
end)
local slider1 = frostyWindow:AddSlider(tab2Frame, "Volume", 0, 100, 50, function(value)
    print("Volume:", value)
end)
local label1 = frostyWindow:AddLabel(tab2Frame, "This is a label.")

local tab3Frame = frostyWindow:AddTab("Tab 3")
local textbox1 = frostyWindow:AddTextbox(tab3Frame, "Input:", "Enter text here", function(text)
    print("Text entered:", text)
end)

return Frosty
