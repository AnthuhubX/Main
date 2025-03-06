-- Combined Frosty UI Script (For easy copy-pasting into a script object)
-- This combines all the modules into a single script.
-- This is less organized but easier for initial testing.
-- Remember to place this script inside a ScreenGui object.

local FrostyUI = {}

-- Default Theme (Can be overridden)
FrostyUI.Theme = {
    BackgroundColor = Color3.fromRGB(40, 40, 40),
    ForegroundColor = Color3.fromRGB(220, 220, 220),
    AccentColor = Color3.fromRGB(50, 150, 255),
    Font = Enum.Font.SourceSansBold,
    FontSize = Enum.FontSize.Size14
}

-- Function to apply a theme to a UI element (Recursive)
function FrostyUI.ApplyTheme(guiObject, theme)
  if guiObject:IsA("Frame") or guiObject:IsA("TextLabel") or guiObject:IsA("TextBox") or guiObject:IsA("TextButton") then
    if theme.BackgroundColor then
      guiObject.BackgroundColor3 = theme.BackgroundColor
    end
    if theme.ForegroundColor and (guiObject:IsA("TextLabel") or guiObject:IsA("TextBox") or guiObject:IsA("TextButton")) then
      guiObject.TextColor3 = theme.ForegroundColor
    end
    if theme.Font and (guiObject:IsA("TextLabel") or guiObject:IsA("TextBox") or guiObject:IsA("TextButton")) then
      guiObject.Font = theme.Font
    end
    if theme.FontSize and (guiObject:IsA("TextLabel") or guiObject:IsA("TextBox") or guiObject:IsA("TextButton")) then
      guiObject.TextSize = theme.FontSize
    end
  end

  for _, child in ipairs(guiObject:GetChildren()) do
    FrostyUI.ApplyTheme(child, theme)
  end
end

-- Function to create a frame
function FrostyUI.CreateFrame(parent, properties)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    for property, value in pairs(properties or {}) do
        frame[property] = value
    end
    FrostyUI.ApplyTheme(frame, FrostyUI.Theme)
    return frame
end

-- Function to create a text label
function FrostyUI.CreateTextLabel(parent, properties)
    local label = Instance.new("TextLabel")
    label.Parent = parent
    label.BackgroundTransparency = 1
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    for property, value in pairs(properties or {}) do
        label[property] = value
    end
    FrostyUI.ApplyTheme(label, FrostyUI.Theme)
    return label
end

-- Function to create a button
function FrostyUI.CreateButton(parent, properties)
    local button = Instance.new("TextButton")
    button.Parent = parent
    button.TextScaled = true
    for property, value in pairs(properties or {}) do
        button[property] = value
    end
    FrostyUI.ApplyTheme(button, FrostyUI.Theme)
    return button
end

-- Function to enable draggability
function FrostyUI.MakeDraggable(frame)
  local UserInputService = game:GetService("UserInputService")
  local dragging = false
  local dragInput = nil
  local dragStart = nil
  local dragPos = nil

  frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
      dragging = true
      dragStart = input.Position
      dragPos = frame.Position
      dragInput = input
    end
  end)

  frame.InputEnded:Connect(function(input)
    if input == dragInput then
      dragging = false
      dragInput = nil
    end
  end)

  UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
      local delta = input.Position - dragStart
      frame.Position = UDim2.new(
        dragPos.X.Scale,
        dragPos.X.Offset + delta.X,
        dragPos.Y.Scale,
        dragPos.Y.Offset + delta.Y
      )
    end
  end)
end

------------------------------------
-- UI Element Modules (Combined) --
------------------------------------

-- FrostyButton Module
local FrostyButton = {}
FrostyButton.__index = FrostyButton

function FrostyButton.new(parent, properties)
    local self = setmetatable({}, FrostyButton)
    self.Button = FrostyUI.CreateButton(parent, properties)
    self.Button.Name = "FrostyButton"
    return self
end

function FrostyButton:SetText(text)
  self.Button.Text = text
end

function FrostyButton:GetButton()
  return self.Button
end

-- FrostySlider Module (Enhanced)
local FrostySlider = {}
FrostySlider.__index = FrostySlider

function FrostySlider.new(parent, properties)
    local self = setmetatable({}, FrostySlider)

    self.Track = FrostyUI.CreateFrame(parent, {
        Size = UDim2.new(1, 0, 0, 10),
        BackgroundColor3 = Color3.fromRGB(100, 100, 100),
        BorderSizePixel = 0,
        Name = "SliderTrack"
    })

    self.Thumb = FrostyUI.CreateFrame(self.Track, {
        Size = UDim2.new(0, 20, 1, 0),
        BackgroundColor3 = FrostyUI.Theme.AccentColor,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 0),
        Name = "SliderThumb"
    })

    -- Enable draggability, but constrain to the track.
    FrostyUI.MakeDraggable(self.Thumb)

    self.MinValue = properties.MinValue or 0
    self.MaxValue = properties.MaxValue or 1
    self.Value = properties.DefaultValue or self.MinValue
    self.Step = properties.Step or 0.01  -- Smaller steps

    self:SetValue(self.Value) --Initial value

    self.Changed = Instance.new("BindableEvent")
    self.Changed.Name = "Changed"
    self.Event = self.Changed.Event

    self.Track.SizeChanged:Connect(function()
      self:UpdateThumbPosition()
    end)

    self.Thumb.Changed:Connect(function(property)
      if property == "Position" then
        local trackWidth = self.Track.AbsoluteSize.X
        local thumbX = self.Thumb.Position.X.Scale * trackWidth + self.Thumb.Position.X.Offset
        local value = (thumbX / trackWidth) * (self.MaxValue - self.MinValue) + self.MinValue

        -- Snap value to the nearest step
        value = self.MinValue + math.round((value - self.MinValue) / self.Step) * self.Step

        value = math.clamp(value, self.MinValue, self.MaxValue)

        if value ~= self.Value then
            self:SetValue(value)
            self.Changed:Fire(value)
        end
      end
    end)

    return self
end

function FrostySlider:SetValue(value)
  self.Value = math.clamp(value, self.MinValue, self.MaxValue)
  self:UpdateThumbPosition()
end

function FrostySlider:UpdateThumbPosition()
  local trackWidth = self.Track.AbsoluteSize.X
  local percentage = (self.Value - self.MinValue) / (self.MaxValue - self.MinValue)
  local thumbPositionX = percentage * trackWidth
  self.Thumb.Position = UDim2.new(0, thumbPositionX, 0, 0)
end

function FrostySlider:GetValue()
  return self.Value
end

-- FrostyToggle Module
local FrostyToggle = {}
FrostyToggle.__index = FrostyToggle

function FrostyToggle.new(parent, properties)
    local self = setmetatable({}, FrostyToggle)

    self.Background = FrostyUI.CreateFrame(parent, {
        Size = UDim2.new(0, 40, 0, 20),
        BackgroundColor3 = Color3.fromRGB(80, 80, 80),
        BorderSizePixel = 0,
        Name = "ToggleBackground"
    })

    self.Thumb = FrostyUI.CreateFrame(self.Background, {
        Size = UDim2.new(0, 18, 1, 0),
        BackgroundColor3 = FrostyUI.Theme.ForegroundColor,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 1, 0, 0),
        Name = "ToggleThumb"
    })

    self.IsToggled = properties.DefaultValue or false
    self:UpdateVisualState()

    self.Background.MouseButton1Click:Connect(function()
        self:Toggle()
    end)

    self.Changed = Instance.new("BindableEvent")
    self.Changed.Name = "Changed"
    self.Event = self.Changed.Event

    return self
end

function FrostyToggle:Toggle()
    self.IsToggled = not self.IsToggled
    self:UpdateVisualState()
    self.Changed:Fire(self.IsToggled)
end

function FrostyToggle:UpdateVisualState()
    if self.IsToggled then
        self.Thumb.Position = UDim2.new(1, -19, 0, 0) -- Move to the right
        self.Background.BackgroundColor3 = FrostyUI.Theme.AccentColor
    else
        self.Thumb.Position = UDim2.new(0, 1, 0, 0) -- Move to the left
        self.Background.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    end
end

function FrostyToggle:GetValue()
    return self.IsToggled
end

-- FrostyTextBox Module
local FrostyTextBox = {}
FrostyTextBox.__index = FrostyTextBox

function FrostyTextBox.new(parent, properties)
    local self = setmetatable({}, FrostyTextBox)

    self.TextBox = Instance.new("TextBox")
    self.TextBox.Parent = parent
    self.TextBox.Size = properties.Size or UDim2.new(0, 100, 0, 20)
    self.TextBox.PlaceholderText = properties.PlaceholderText or ""
    self.TextBox.Text = properties.DefaultText or ""
    self.TextBox.Name = "FrostyTextBox"

    FrostyUI.ApplyTheme(self.TextBox, FrostyUI.Theme)

    self.Changed = Instance.new("BindableEvent")
    self.Changed.Name = "Changed"
    self.Event = self.Changed.Event

    self.TextBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            self.Changed:Fire(self.TextBox.Text)
        end
    end)

    self.TextBox.Changed:Connect(function()
      self.Changed:Fire(self.TextBox.Text)
    end)


    return self
end

function FrostyTextBox:GetText()
    return self.TextBox.Text
end

function FrostyTextBox:SetText(text)
    self.TextBox.Text = text
end

------------------------------------
-- Example Usage (Inside the same script) --
------------------------------------

local screenGui = script.Parent

-- Create a main window
local mainWindow = FrostyUI.CreateFrame(screenGui, {
    Size = UDim2.new(0, 300, 0, 400), -- Increased height
    Position = UDim2.new(0.5, -150, 0.5, -200),
    BackgroundColor3 = Color3.fromRGB(50, 50, 50),
    BorderSizePixel = 0,
    Name = "MainWindow"
})
FrostyUI.MakeDraggable(mainWindow)

-- Create a title bar
local titleBar = FrostyUI.CreateFrame(mainWindow, {
    Size = UDim2.new(1, 0, 0, 30),
    BackgroundColor3 = Color3.fromRGB(30, 30, 30),
    BorderSizePixel = 0,
    Name = "TitleBar"
})

local titleLabel = FrostyUI.CreateTextLabel(titleBar, {
    Text = "Frosty UI Example",
    Size = UDim2.new(1, 0, 1, 0),
    TextColor3 = Color3.fromRGB(200, 200, 200),
    Font = Enum.Font.SourceSans,
    TextSize = 18,
    TextXAlignment = Enum.TextXAlignment.Center,
    Name = "TitleLabel"
})

-- Create a button using the FrostyButton module
local myButton = FrostyButton.new(mainWindow, {
  Size = UDim2.new(0.5, 0, 0.1, 0),
  Position = UDim2.new(0.25, 0, 0.1, 0), -- Adjusted position
  Text = "Click Me!"
})

myButton:GetButton().MouseButton1Click:Connect(function()
    print("Button Clicked!")
end)

-- Discord Invite Link Input
local discordLabel = FrostyUI.CreateTextLabel(mainWindow, {
  Size = UDim2.new(0.9,0,0.1,0),
  Position = UDim2.new(0.05,0,0.2,0),
  Text = "Discord Invite Link:",
  TextXAlignment = Enum.TextXAlignment.Left
})
local discordLinkInput = FrostyTextBox.new(mainWindow, {
    Size = UDim2.new(0.9, 0, 0.1, 0),
    Position = UDim2.new(0.05, 0, 0.3, 0),
    PlaceholderText = "discord.gg/invitecode"
})

local joinDiscordButton = FrostyButton.new(mainWindow, {
    Size = UDim2.new(0.5, 0, 0.1, 0),
    Position = UDim2.new(0.25, 0, 0.4, 0),
    Text = "Join Discord"
})

joinDiscordButton:GetButton().MouseButton1Click:Connect(function()
    local inviteLink = discordLinkInput:GetText()
    if string.sub(inviteLink, 1, 12) == "discord.gg/" or string.sub(inviteLink,1,26) == "https://discord.com/invite/" then
      game:GetService("ContextActionService"):BindAction("OpenDiscordInvite", function()
        game:GetService("Players").LocalPlayer:Kick("You have been redirected to the discord server.")
      end, true, Enum.KeyCode.LeftShift)
      game:GetService("TeleportService"):Teleport(0, game:GetService("Players").LocalPlayer, {discordLink = inviteLink})
      --game:OpenURL("https://" .. inviteLink) --Use teleport service to teleport the user.
    else
        print("Invalid Discord invite link.")
    end
end)

-- Example Slider
local slider = FrostySlider.new(mainWindow, {
    Size = UDim2.new(0.8, 0, 0.1, 0),
    Position = UDim2.new(0.1, 0, 0.55, 0), --Adjust position
    MinValue = 0,
    MaxValue = 100,
    DefaultValue = 50,
    Step = 1
})

local sliderValueLabel = FrostyUI.CreateTextLabel(mainWindow, {
    Size = UDim2.new(0.8, 0, 0.1, 0),
    Position = UDim2.new(0.1, 0, 0.65, 0), --Adjust position
    Text = "Slider Value: " .. slider:GetValue()
})

slider.Changed:Connect(function(value)
    sliderValueLabel.Text = "Slider Value: " .. value
end)

-- Example Toggle
local toggle = FrostyToggle.new(mainWindow, {
    Size = UDim2.new(0.3, 0, 0.1, 0),
    Position = UDim2.new(0.35, 0, 0.75, 0), --Adjust position
    DefaultValue = false
})

local toggleStateLabel = FrostyUI.CreateTextLabel(mainWindow, {
    Size = UDim2.new(0.8, 0, 0.1, 0),
    Position = UDim2.new(0.1, 0, 0.85, 0), --Adjust position
    Text = "Toggle State: " .. tostring(toggle:GetValue())
})

toggle.Changed:Connect(function(value)
    toggleStateLabel.Text = "Toggle State: " .. tostring(value)
end)

--Example of changing theme
local newThemeButton = FrostyUI.CreateButton(mainWindow, {
  Size = UDim2.new(0.3, 0, 0.1, 0),
  Position = UDim2.new(0.65,0,0.95,0),
  Text = "Change Theme",
  BackgroundColor3 = FrostyUI.Theme.AccentColor,
  TextColor3 = FrostyUI.Theme.BackgroundColor
})
newThemeButton.MouseButton1Click:Connect(function()
  FrostyUI.Theme.BackgroundColor = Color3.fromRGB(255,255,255)
  FrostyUI.Theme.ForegroundColor = Color3.fromRGB(0,0,0)
  FrostyUI.ApplyTheme(screenGui,FrostyUI.Theme)
end)
