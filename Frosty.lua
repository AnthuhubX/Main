
-- Frosty UI Library
-- Inspired by Rayfield Hub and Orion Library

local Frosty = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- UI Configuration
Frosty.Config = {
    WindowName = "Frosty",
    Color = Color3.fromRGB(70, 130, 180),
    LoadingDuration = 1.5,
    Font = Enum.Font.GothamSemibold,
    TextSize = 14,
    DragSpeed = 0.1
}

-- Local Functions
local function MakeDraggable(topBarObject, object)
    local Dragging = nil
    local DragInput = nil
    local DragStart = nil
    local StartPosition = nil
    
    local function Update(input)
        local Delta = input.Position - DragStart
        local Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
        
        local Tween = TweenService:Create(object, TweenInfo.new(Frosty.Config.DragSpeed), {Position = Position})
        Tween:Play()
    end
    
    topBarObject.InputBegan:Connect(function(input)
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
    
    topBarObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            Update(input)
        end
    end)
end

-- Create UI Functions
function Frosty:CreateWindow(windowName)
    self.Config.WindowName = windowName or self.Config.WindowName
    
    -- Check if existing UI exists
    if CoreGui:FindFirstChild("FrostyUI") then
        CoreGui:FindFirstChild("FrostyUI"):Destroy()
    end
    
    -- Main UI
    local FrostyUI = Instance.new("ScreenGui")
    FrostyUI.Name = "FrostyUI"
    FrostyUI.Parent = CoreGui
    FrostyUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Loading Frame
    local LoadingFrame = Instance.new("Frame")
    LoadingFrame.Name = "LoadingFrame"
    LoadingFrame.Parent = FrostyUI
    LoadingFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    LoadingFrame.Position = UDim2.new(0.5, -175, 0.5, -75)
    LoadingFrame.Size = UDim2.new(0, 350, 0, 150)
    LoadingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    
    -- Corner
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = LoadingFrame
    
    -- Loading Title
    local LoadingTitle = Instance.new("TextLabel")
    LoadingTitle.Name = "Title"
    LoadingTitle.Parent = LoadingFrame
    LoadingTitle.BackgroundTransparency = 1
    LoadingTitle.Position = UDim2.new(0, 0, 0.2, 0)
    LoadingTitle.Size = UDim2.new(1, 0, 0, 25)
    LoadingTitle.Font = Frosty.Config.Font
    LoadingTitle.Text = "Frosty Hub"
    LoadingTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    LoadingTitle.TextSize = 24
    
    -- Loading Subtitle
    local LoadingSubtitle = Instance.new("TextLabel")
    LoadingSubtitle.Name = "Subtitle"
    LoadingSubtitle.Parent = LoadingFrame
    LoadingSubtitle.BackgroundTransparency = 1
    LoadingSubtitle.Position = UDim2.new(0, 0, 0.5, 0)
    LoadingSubtitle.Size = UDim2.new(1, 0, 0, 20)
    LoadingSubtitle.Font = Frosty.Config.Font
    LoadingSubtitle.Text = "Loading..."
    LoadingSubtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
    LoadingSubtitle.TextSize = 16
    
    -- Loading Bar Background
    local LoadingBarBg = Instance.new("Frame")
    LoadingBarBg.Name = "LoadingBarBg"
    LoadingBarBg.Parent = LoadingFrame
    LoadingBarBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    LoadingBarBg.BorderSizePixel = 0
    LoadingBarBg.Position = UDim2.new(0.1, 0, 0.75, 0)
    LoadingBarBg.Size = UDim2.new(0.8, 0, 0, 10)
    
    local LoadingBarBgCorner = Instance.new("UICorner")
    LoadingBarBgCorner.CornerRadius = UDim.new(0, 4)
    LoadingBarBgCorner.Parent = LoadingBarBg
    
    -- Loading Bar Fill
    local LoadingBarFill = Instance.new("Frame")
    LoadingBarFill.Name = "LoadingBarFill"
    LoadingBarFill.Parent = LoadingBarBg
    LoadingBarFill.BackgroundColor3 = Frosty.Config.Color
    LoadingBarFill.BorderSizePixel = 0
    LoadingBarFill.Size = UDim2.new(0, 0, 1, 0)
    
    local LoadingBarFillCorner = Instance.new("UICorner")
    LoadingBarFillCorner.CornerRadius = UDim.new(0, 4)
    LoadingBarFillCorner.Parent = LoadingBarFill
    
    -- Loading Bar Animation
    local loadingTween = TweenService:Create(
        LoadingBarFill,
        TweenInfo.new(Frosty.Config.LoadingDuration, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut),
        {Size = UDim2.new(1, 0, 1, 0)}
    )
    loadingTween:Play()
    
    -- Main Window (Hidden initially)
    local MainWindow = Instance.new("Frame")
    MainWindow.Name = "MainWindow"
    MainWindow.Parent = FrostyUI
    MainWindow.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainWindow.Position = UDim2.new(0.5, -300, 0.5, -200)
    MainWindow.Size = UDim2.new(0, 600, 0, 400)
    MainWindow.Visible = false
    
    local MainWindowCorner = Instance.new("UICorner")
    MainWindowCorner.CornerRadius = UDim.new(0, 8)
    MainWindowCorner.Parent = MainWindow
    
    -- Window TopBar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Parent = MainWindow
    TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    
    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 8)
    TopBarCorner.Parent = TopBar
    
    -- Bottom TopBar Filler (Fixes corners)
    local TopBarFiller = Instance.new("Frame")
    TopBarFiller.Name = "Filler"
    TopBarFiller.Parent = TopBar
    TopBarFiller.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TopBarFiller.BorderSizePixel = 0
    TopBarFiller.Position = UDim2.new(0, 0, 0.9, 0)
    TopBarFiller.Size = UDim2.new(1, 0, 0.1, 0)
    
    -- Window Title
    local WindowTitle = Instance.new("TextLabel")
    WindowTitle.Name = "Title"
    WindowTitle.Parent = TopBar
    WindowTitle.BackgroundTransparency = 1
    WindowTitle.Position = UDim2.new(0.02, 0, 0, 0)
    WindowTitle.Size = UDim2.new(0.5, 0, 1, 0)
    WindowTitle.Font = Frosty.Config.Font
    WindowTitle.Text = self.Config.WindowName
    WindowTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    WindowTitle.TextSize = 18
    WindowTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = TopBar
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(0.95, 0, 0.25, 0)
    CloseButton.Size = UDim2.new(0, 20, 0, 20)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 16
    
    -- Close Button Action
    CloseButton.MouseButton1Click:Connect(function()
        FrostyUI:Destroy()
    end)
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Parent = MainWindow
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 0, 0, 40)
    ContentContainer.Size = UDim2.new(1, 0, 1, -40)
    
    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = ContentContainer
    TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TabContainer.Position = UDim2.new(0.02, 0, 0.02, 0)
    TabContainer.Size = UDim2.new(0.2, 0, 0.96, 0)
    
    local TabContainerCorner = Instance.new("UICorner")
    TabContainerCorner.CornerRadius = UDim.new(0, 6)
    TabContainerCorner.Parent = TabContainer
    
    -- Tab Buttons Container
    local TabButtonsContainer = Instance.new("ScrollingFrame")
    TabButtonsContainer.Name = "TabButtons"
    TabButtonsContainer.Parent = TabContainer
    TabButtonsContainer.Active = true
    TabButtonsContainer.BackgroundTransparency = 1
    TabButtonsContainer.Position = UDim2.new(0, 0, 0, 5)
    TabButtonsContainer.Size = UDim2.new(1, 0, 1, -5)
    TabButtonsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabButtonsContainer.ScrollBarThickness = 2
    TabButtonsContainer.ScrollBarImageColor3 = Frosty.Config.Color
    
    local TabButtonsList = Instance.new("UIListLayout")
    TabButtonsList.Parent = TabButtonsContainer
    TabButtonsList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabButtonsList.SortOrder = Enum.SortOrder.LayoutOrder
    TabButtonsList.Padding = UDim.new(0, 5)
    
    -- Tab Content Container
    local TabContentContainer = Instance.new("Frame")
    TabContentContainer.Name = "TabContent"
    TabContentContainer.Parent = ContentContainer
    TabContentContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TabContentContainer.Position = UDim2.new(0.24, 0, 0.02, 0)
    TabContentContainer.Size = UDim2.new(0.74, 0, 0.96, 0)
    
    local TabContentCorner = Instance.new("UICorner")
    TabContentCorner.CornerRadius = UDim.new(0, 6)
    TabContentCorner.Parent = TabContentContainer
    
    -- Make window draggable
    MakeDraggable(TopBar, MainWindow)
    
    -- After loading is complete, show the main UI
    loadingTween.Completed:Connect(function()
        wait(0.5)
        LoadingFrame:Destroy()
        MainWindow.Visible = true
    end)
    
    -- Library functions
    local FrostyLibrary = {}
    local TabCount = 0
    local SelectedTab = nil
    
    function FrostyLibrary:CreateTab(tabName)
        TabCount = TabCount + 1
        
        -- Create Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = "Tab_" .. tabName
        TabButton.Parent = TabButtonsContainer
        TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        TabButton.Size = UDim2.new(0.9, 0, 0, 35)
        TabButton.Font = Frosty.Config.Font
        TabButton.Text = tabName
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabButton.TextSize = Frosty.Config.TextSize
        
        local TabButtonCorner = Instance.new("UICorner")
        TabButtonCorner.CornerRadius = UDim.new(0, 4)
        TabButtonCorner.Parent = TabButton
        
        -- Create Tab Content Frame
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = "Content_" .. tabName
        TabContent.Parent = TabContentContainer
        TabContent.Active = true
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.Position = UDim2.new(0, 0, 0, 0)
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.ScrollBarThickness = 3
        TabContent.ScrollBarImageColor3 = Frosty.Config.Color
        TabContent.Visible = false
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        
        local TabContentList = Instance.new("UIListLayout")
        TabContentList.Parent = TabContent
        TabContentList.HorizontalAlignment = Enum.HorizontalAlignment.Center
        TabContentList.SortOrder = Enum.SortOrder.LayoutOrder
        TabContentList.Padding = UDim.new(0, 10)
        
        local TabContentPadding = Instance.new("UIPadding")
        TabContentPadding.Parent = TabContent
        TabContentPadding.PaddingTop = UDim.new(0, 10)
        TabContentPadding.PaddingBottom = UDim.new(0, 10)
        
        -- Update Canvas Size function
        local function UpdateCanvasSize()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContentList.AbsoluteContentSize.Y + 20)
        end
        
        -- Handle tab selection
        TabButton.MouseButton1Click:Connect(function()
            if SelectedTab ~= nil then
                -- Deselect previous tab
                TabButtonsContainer:FindFirstChild("Tab_" .. SelectedTab).BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                TabButtonsContainer:FindFirstChild("Tab_" .. SelectedTab).TextColor3 = Color3.fromRGB(200, 200, 200)
                TabContentContainer:FindFirstChild("Content_" .. SelectedTab).Visible = false
            end
            
            -- Select new tab
            SelectedTab = tabName
            TabButton.BackgroundColor3 = Frosty.Config.Color
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabContent.Visible = true
        end)
        
        -- If this is the first tab, select it by default
        if TabCount == 1 then
            SelectedTab = tabName
            TabButton.BackgroundColor3 = Frosty.Config.Color
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabContent.Visible = true
        end
        
        -- Tab functions
        local Tab = {}
        
        function Tab:CreateSection(sectionName)
            local Section = Instance.new("Frame")
            Section.Name = "Section_" .. sectionName
            Section.Parent = TabContent
            Section.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Section.Size = UDim2.new(0.95, 0, 0, 40) -- Initial size, will be resized
            
            local SectionCorner = Instance.new("UICorner")
            SectionCorner.CornerRadius = UDim.new(0, 4)
            SectionCorner.Parent = Section
            
            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Name = "Title"
            SectionTitle.Parent = Section
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Position = UDim2.new(0.02, 0, 0, 5)
            SectionTitle.Size = UDim2.new(0.96, 0, 0, 25)
            SectionTitle.Font = Frosty.Config.Font
            SectionTitle.Text = sectionName
            SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            SectionTitle.TextSize = Frosty.Config.TextSize
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            -- Container for section elements
            local SectionContainer = Instance.new("Frame")
            SectionContainer.Name = "Container"
            SectionContainer.Parent = Section
            SectionContainer.BackgroundTransparency = 1
            SectionContainer.Position = UDim2.new(0, 0, 0, 35)
            SectionContainer.Size = UDim2.new(1, 0, 1, -35)
            
            local SectionList = Instance.new("UIListLayout")
            SectionList.Parent = SectionContainer
            SectionList.HorizontalAlignment = Enum.HorizontalAlignment.Center
            SectionList.SortOrder = Enum.SortOrder.LayoutOrder
            SectionList.Padding = UDim.new(0, 8)
            
            local SectionPadding = Instance.new("UIPadding")
            SectionPadding.Parent = SectionContainer
            SectionPadding.PaddingTop = UDim.new(0, 5)
            SectionPadding.PaddingBottom = UDim.new(0, 5)
            
            local function UpdateSectionSize()
                Section.Size = UDim2.new(0.95, 0, 0, 35 + SectionList.AbsoluteContentSize.Y + 10)
                UpdateCanvasSize()
            end
            
            SectionList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateSectionSize)
            
            -- Section elements
            local Elements = {}
            
            function Elements:AddButton(buttonInfo)
                local buttonName = buttonInfo.Name or "Button"
                local callback = buttonInfo.Callback or function() end
                
                local Button = Instance.new("Frame")
                Button.Name = "Button_" .. buttonName
                Button.Parent = SectionContainer
                Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                Button.Size = UDim2.new(0.95, 0, 0, 35)
                
                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(0, 4)
                ButtonCorner.Parent = Button
                
                local ButtonLabel = Instance.new("TextLabel")
                ButtonLabel.Name = "Label"
                ButtonLabel.Parent = Button
                ButtonLabel.BackgroundTransparency = 1
                ButtonLabel.Position = UDim2.new(0.02, 0, 0, 0)
                ButtonLabel.Size = UDim2.new(0.96, 0, 1, 0)
                ButtonLabel.Font = Frosty.Config.Font
                ButtonLabel.Text = buttonName
                ButtonLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
                ButtonLabel.TextSize = Frosty.Config.TextSize
                ButtonLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                local ButtonClickArea = Instance.new("TextButton")
                ButtonClickArea.Name = "ClickArea"
                ButtonClickArea.Parent = Button
                ButtonClickArea.BackgroundTransparency = 1
                ButtonClickArea.Size = UDim2.new(1, 0, 1, 0)
                ButtonClickArea.Text = ""
                
                ButtonClickArea.MouseButton1Click:Connect(function()
                    callback()
                    
                    -- Button press effect
                    local originalColor = Button.BackgroundColor3
                    Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                    wait(0.1)
                    Button.BackgroundColor3 = originalColor
                end)
                
                UpdateSectionSize()
                return Button
            end
            
            function Elements:AddToggle(toggleInfo)
                local toggleName = toggleInfo.Name or "Toggle"
                local default = toggleInfo.Default or false
                local callback = toggleInfo.Callback or function() end
                
                local Toggle = Instance.new("Frame")
                Toggle.Name = "Toggle_" .. toggleName
                Toggle.Parent = SectionContainer
                Toggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                Toggle.Size = UDim2.new(0.95, 0, 0, 35)
                
                local ToggleCorner = Instance.new("UICorner")
                ToggleCorner.CornerRadius = UDim.new(0, 4)
                ToggleCorner.Parent = Toggle
                
                local ToggleLabel = Instance.new("TextLabel")
                ToggleLabel.Name = "Label"
                ToggleLabel.Parent = Toggle
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Position = UDim2.new(0.02, 0, 0, 0)
                ToggleLabel.Size = UDim2.new(0.75, 0, 1, 0)
                ToggleLabel.Font = Frosty.Config.Font
                ToggleLabel.Text = toggleName
                ToggleLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
                ToggleLabel.TextSize = Frosty.Config.TextSize
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                local ToggleIndicator = Instance.new("Frame")
                ToggleIndicator.Name = "Indicator"
                ToggleIndicator.Parent = Toggle
                ToggleIndicator.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                ToggleIndicator.Position = UDim2.new(0.85, 0, 0.5, 0)
                ToggleIndicator.Size = UDim2.new(0, 36, 0, 18)
                ToggleIndicator.AnchorPoint = Vector2.new(0, 0.5)
                
                local ToggleIndicatorCorner = Instance.new("UICorner")
                ToggleIndicatorCorner.CornerRadius = UDim.new(0, 10)
                ToggleIndicatorCorner.Parent = ToggleIndicator
                
                local ToggleButton = Instance.new("Frame")
                ToggleButton.Name = "Button"
                ToggleButton.Parent = ToggleIndicator
                ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
                ToggleButton.Position = UDim2.new(0, 2, 0.5, 0)
                ToggleButton.Size = UDim2.new(0, 14, 0, 14)
                ToggleButton.AnchorPoint = Vector2.new(0, 0.5)
                
                local ToggleButtonCorner = Instance.new("UICorner")
                ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
                ToggleButtonCorner.Parent = ToggleButton
                
                local ToggleClickArea = Instance.new("TextButton")
                ToggleClickArea.Name = "ClickArea"
                ToggleClickArea.Parent = Toggle
                ToggleClickArea.BackgroundTransparency = 1
                ToggleClickArea.Size = UDim2.new(1, 0, 1, 0)
                ToggleClickArea.Text = ""
                
                -- Toggle state
                local ToggleEnabled = default
                
                local function UpdateToggle()
                    if ToggleEnabled then
                        ToggleIndicator.BackgroundColor3 = Frosty.Config.Color
                        ToggleButton.Position = UDim2.new(1, -16, 0.5, 0)
                        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    else
                        ToggleIndicator.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                        ToggleButton.Position = UDim2.new(0, 2, 0.5, 0)
                        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
                    end
                    
                    callback(ToggleEnabled)
                end
                
                -- Initialize toggle state
                UpdateToggle()
                
                ToggleClickArea.MouseButton1Click:Connect(function()
                    ToggleEnabled = not ToggleEnabled
                    UpdateToggle()
                end)
                
                UpdateSectionSize()
                
                local ToggleObject = {}
                
                function ToggleObject:Set(value)
                    ToggleEnabled = value
                    UpdateToggle()
                end
                
                function ToggleObject:Get()
                    return ToggleEnabled
                end
                
                return ToggleObject
            end
            
            function Elements:AddSlider(sliderInfo)
                local sliderName = sliderInfo.Name or "Slider"
                local min = sliderInfo.Min or 0
                local max = sliderInfo.Max or 100
                local default = sliderInfo.Default or min
                local increment = sliderInfo.Increment or 1
                local callback = sliderInfo.Callback or function() end
                
                -- Validate and adjust default value
                default = math.clamp(default, min, max)
                default = min + (math.floor((default - min) / increment) * increment)
                
                local Slider = Instance.new("Frame")
                Slider.Name = "Slider_" .. sliderName
                Slider.Parent = SectionContainer
                Slider.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                Slider.Size = UDim2.new(0.95, 0, 0, 55)
                
                local SliderCorner = Instance.new("UICorner")
                SliderCorner.CornerRadius = UDim.new(0, 4)
                SliderCorner.Parent = Slider
                
                local SliderLabel = Instance.new("TextLabel")
                SliderLabel.Name = "Label"
                SliderLabel.Parent = Slider
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.Position = UDim2.new(0.02, 0, 0, 5)
                SliderLabel.Size = UDim2.new(0.6, 0, 0, 20)
                SliderLabel.Font = Frosty.Config.Font
                SliderLabel.Text = sliderName
                SliderLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
                SliderLabel.TextSize = Frosty.Config.TextSize
                SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                local SliderValue = Instance.new("TextLabel")
                SliderValue.Name = "Value"
                SliderValue.Parent = Slider
                SliderValue.BackgroundTransparency = 1
                SliderValue.Position = UDim2.new(0.65, 0, 0, 5)
                SliderValue.Size = UDim2.new(0.33, 0, 0, 20)
                SliderValue.Font = Frosty.Config.Font
                SliderValue.Text = tostring(default)
                SliderValue.TextColor3 = Color3.fromRGB(230, 230, 230)
                SliderValue.TextSize = Frosty.Config.TextSize
                SliderValue.TextXAlignment = Enum.TextXAlignment.Right
                
                local SliderBackground = Instance.new("Frame")
                SliderBackground.Name = "Background"
                SliderBackground.Parent = Slider
                SliderBackground.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                SliderBackground.Position = UDim2.new(0.02, 0, 0, 30)
                SliderBackground.Size = UDim2.new(0.96, 0, 0, 10)
                
                local SliderBackgroundCorner = Instance.new("UICorner")
                SliderBackgroundCorner.CornerRadius = UDim.new(0, 4)
                SliderBackgroundCorner.Parent = SliderBackground
                
                local SliderFill = Instance.new("Frame")
                SliderFill.Name = "Fill"
                SliderFill.Parent = SliderBackground
                SliderFill.BackgroundColor3 = Frosty.Config.Color
                SliderFill.Size = UDim2.new(0, 0, 1, 0)
                
                local SliderFillCorner = Instance.new("UICorner")
                SliderFillCorner.CornerRadius = UDim.new(0, 4)
                SliderFillCorner.Parent = SliderFill
                
                local SliderButton = Instance.new("TextButton")
                SliderButton.Name = "Button"
                SliderButton.Parent = SliderBackground
                SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SliderButton.Position = UDim2.new(0, 0, 0.5, 0)
                SliderButton.Size = UDim2.new(0, 12, 0, 12)
                SliderButton.Text = ""
                SliderButton.AnchorPoint = Vector2.new(0.5, 0.5)
                
                local SliderButtonCorner = Instance.new("UICorner")
                SliderButtonCorner.CornerRadius = UDim.new(1, 0)
                SliderButtonCorner.Parent = SliderButton
                
                local CurrentValue = default
                
                local function UpdateSlider(value)
                    local percentage = (value - min) / (max - min)
                    SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
                    SliderButton.Position = UDim2.new(percentage, 0, 0.5, 0)
                    SliderValue.Text = tostring(value)
                    CurrentValue = value
                    callback(value)
                end
                
                UpdateSlider(default)
                
                local isDragging = false
                SliderButton.MouseButton1Down:Connect(function()
                    isDragging = true
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        isDragging = false
                    end
                end)
                
                SliderBackground.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        isDragging = true
                        local percentage = math.clamp((input.Position.X - SliderBackground.AbsolutePosition.X) / SliderBackground.AbsoluteSize.X, 0, 1)
                        local value = min + ((max - min) * percentage)
                        value = min + (math.floor((value - min) / increment) * increment)
                        UpdateSlider(value)
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local percentage = math.clamp((input.Position.X - SliderBackground.AbsolutePosition.X) / SliderBackground.AbsoluteSize.X, 0, 1)
                        local value = min + ((max - min) * percentage)
                        value = min + (math.floor((value - min) / increment) * increment)
                        UpdateSlider(value)
                    end
                end)
                
                UpdateSectionSize()
                
                local SliderObject = {}
                
                function SliderObject:Set(value)
                    value = math.clamp(value, min, max)
                    value = min + (math.floor((value - min) / increment) * increment)
                    UpdateSlider(value)
                end
                
                function SliderObject:Get()
                    return CurrentValue
                end
                
                return SliderObject
            end
            
            function Elements:AddDropdown(dropdownInfo)
                local dropdownName = dropdownInfo.Name or "Dropdown"
                local options = dropdownInfo.Options or {}
                local default = dropdownInfo.Default or (options[1] or "")
                local callback = dropdownInfo.Callback or function() end
                
                local Dropdown = Instance.new("Frame")
                Dropdown.Name = "Dropdown_" .. dropdownName
                Dropdown.Parent = SectionContainer
                Dropdown.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                Dropdown.Size = UDim2.new(0.95, 0, 0, 35)
                Dropdown.ClipsDescendants = true
                
                local DropdownCorner = Instance.new("UICorner")
                DropdownCorner.CornerRadius = UDim.new(0, 4)
                DropdownCorner.Parent = Dropdown
                
                local DropdownLabel = Instance.new("TextLabel")
                DropdownLabel.Name = "Label"
                DropdownLabel.Parent = Dropdown
                DropdownLabel.BackgroundTransparency = 1
                DropdownLabel.Position = UDim2.new(0.02, 0, 0, 5)
                DropdownLabel.Size = UDim2.new(0.74, 0, 0, 25)
                DropdownLabel.Font = Frosty.Config.Font
                DropdownLabel.Text = dropdownName
                DropdownLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
                DropdownLabel.TextSize = Frosty.Config.TextSize
                DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                local DropdownButton = Instance.new("TextButton")
                DropdownButton.Name = "Button"
                DropdownButton.Parent = Dropdown
                DropdownButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                DropdownButton.Position = UDim2.new(0.78, 0, 0.5, 0)
                DropdownButton.Size = UDim2.new(0.2, 0, 0, 25)
                DropdownButton.AnchorPoint = Vector2.new(0, 0.5)
                DropdownButton.Font = Frosty.Config.Font
                DropdownButton.Text = default
                DropdownButton.TextColor3 = Color3.fromRGB(230, 230, 230)
                DropdownButton.TextSize = Frosty.Config.TextSize
                
                local DropdownButtonCorner = Instance.new("UICorner")
                DropdownButtonCorner.CornerRadius = UDim.new(0, 4)
                DropdownButtonCorner.Parent = DropdownButton
                
                local DropdownContainer = Instance.new("Frame")
                DropdownContainer.Name = "Container"
                DropdownContainer.Parent = Dropdown
                DropdownContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                DropdownContainer.Position = UDim2.new(0.02, 0, 0, 35)
                DropdownContainer.Size = UDim2.new(0.96, 0, 0, 0) -- Hidden initially
                DropdownContainer.ZIndex = 2
                
                local DropdownContainerCorner = Instance.new("UICorner")
                DropdownContainerCorner.CornerRadius = UDim.new(0, 4)
                DropdownContainerCorner.Parent = DropdownContainer
                
                local DropdownList = Instance.new("ScrollingFrame")
                DropdownList.Name = "List"
                DropdownList.Parent = DropdownContainer
                DropdownList.Active = true
                DropdownList.BackgroundTransparency = 1
                DropdownList.BorderSizePixel = 0
                DropdownList.Size = UDim2.new(1, 0, 1, 0)
                DropdownList.ScrollBarThickness = 3
                DropdownList.ScrollBarImageColor3 = Frosty.Config.Color
                
                local DropdownListLayout = Instance.new("UIListLayout")
                DropdownListLayout.Parent = DropdownList
                DropdownListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                DropdownListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                DropdownListLayout.Padding = UDim.new(0, 5)
                
                local DropdownListPadding = Instance.new("UIPadding")
                DropdownListPadding.Parent = DropdownList
                DropdownListPadding.PaddingTop = UDim.new(0, 5)
                DropdownListPadding.PaddingBottom = UDim.new(0, 5)
                
                -- Current selection
                local SelectedOption = default
                local IsOpen = false
                
                -- Populate dropdown with options
                for _, option in ipairs(options) do
                    local OptionButton = Instance.new("TextButton")
                    OptionButton.Name = "Option_" .. option
                    OptionButton.Parent = DropdownList
                    OptionButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                    OptionButton.Size = UDim2.new(0.95, 0, 0, 25)
                    OptionButton.Font = Frosty.Config.Font
                    OptionButton.Text = option
                    OptionButton.TextColor3 = Color3.fromRGB(230, 230, 230)
                    OptionButton.TextSize = Frosty.Config.TextSize
                    
                    local OptionButtonCorner = Instance.new("UICorner")
                    OptionButtonCorner.CornerRadius = UDim.new(0, 4)
                    OptionButtonCorner.Parent = OptionButton
                    
                    -- Highlight current selection
                    if option == default then
                        OptionButton.BackgroundColor3 = Frosty.Config.Color
                    end
                    
                    OptionButton.MouseButton1Click:Connect(function()
                        SelectedOption = option
                        DropdownButton.Text = option
                        
                        -- Update visuals for all options
                        for _, child in ipairs(DropdownList:GetChildren()) do
                            if child:IsA("TextButton") then
                                if child.Text == option then
                                    child.BackgroundColor3 = Frosty.Config.Color
                                else
                                    child.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                                end
                            end
                        end
                        
                        -- Close dropdown
                        TweenService:Create(Dropdown, TweenInfo.new(0.2), {Size = UDim2.new(0.95, 0, 0, 35)}):Play()
                        TweenService:Create(DropdownContainer, TweenInfo.new(0.2), {Size = UDim2.new(0.96, 0, 0, 0)}):Play()
                        IsOpen = false
                        
                        callback(option)
                    end)
                end
                
                -- Update size of dropdown list based on options
                DropdownList.CanvasSize = UDim2.new(0, 0, 0, DropdownListLayout.AbsoluteContentSize.Y + 10)
                
                -- Toggle dropdown
                DropdownButton.MouseButton1Click:Connect(function()
                    if IsOpen then
                        -- Close dropdown
                        TweenService:Create(Dropdown, TweenInfo.new(0.2), {Size = UDim2.new(0.95, 0, 0, 35)}):Play()
                        TweenService:Create(DropdownContainer, TweenInfo.new(0.2), {Size = UDim2.new(0.96, 0, 0, 0)}):Play()
                        IsOpen = false
                    else
                        -- Open dropdown
                        local listHeight = math.min(150, DropdownListLayout.AbsoluteContentSize.Y + 10)
                        TweenService:Create(Dropdown, TweenInfo.new(0.2), {Size = UDim2.new(0.95, 0, 0, 35 + listHeight)}):Play()
                        TweenService:Create(DropdownContainer, TweenInfo.new(0.2), {Size = UDim2.new(0.96, 0, 0, listHeight)}):Play()
                        IsOpen = true
                    end
                    
                    UpdateSectionSize()
                end)
                
                UpdateSectionSize()
                
                local DropdownObject = {}
                
                function DropdownObject:Set(option)
                    if table.find(options, option) then
                        SelectedOption = option
                        DropdownButton.Text = option
                        
                        -- Update visuals for all options
                        for _, child in ipairs(DropdownList:GetChildren()) do
                            if child:IsA("TextButton") then
                                if child.Text == option then
                                    child.BackgroundColor3 = Frosty.Config.Color
                                else
                                    child.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                                end
                            end
                        end
                        
                        callback(option)
                    end
                end
                
                function DropdownObject:Get()
                    return SelectedOption
                end
                
                function DropdownObject:Refresh(newOptions, keepSelection)
                    -- Clear existing options
                    for _, child in ipairs(DropdownList:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                    
                    options = newOptions
                    local newSelection = keepSelection and SelectedOption or newOptions[1] or ""
                    
                    -- If current selection isn't in new options, use first option
                    if not table.find(newOptions, newSelection) then
                        newSelection = newOptions[1] or ""
                    end
                    
                    SelectedOption = newSelection
                    DropdownButton.Text = newSelection
                    
                    -- Rebuild options
                    for _, option in ipairs(newOptions) do
                        local OptionButton = Instance.new("TextButton")
                        OptionButton.Name = "Option_" .. option
                        OptionButton.Parent = DropdownList
                        OptionButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                        OptionButton.Size = UDim2.new(0.95, 0, 0, 25)
                        OptionButton.Font = Frosty.Config.Font
                        OptionButton.Text = option
                        OptionButton.TextColor3 = Color3.fromRGB(230, 230, 230)
                        OptionButton.TextSize = Frosty.Config.TextSize
                        
                        local OptionButtonCorner = Instance.new("UICorner")
                        OptionButtonCorner.CornerRadius = UDim.new(0, 4)
                        OptionButtonCorner.Parent = OptionButton
                        
                        -- Highlight current selection
                        if option == newSelection then
                            OptionButton.BackgroundColor3 = Frosty.Config.Color
                        end
                        
                        OptionButton.MouseButton1Click:Connect(function()
                            SelectedOption = option
                            DropdownButton.Text = option
                            
                            -- Update visuals for all options
                            for _, child in ipairs(DropdownList:GetChildren()) do
                                if child:IsA("TextButton") then
                                    if child.Text == option then
                                        child.BackgroundColor3 = Frosty.Config.Color
                                    else
                                        child.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                                    end
                                end
                            end
                            
                            -- Close dropdown
                            TweenService:Create(Dropdown, TweenInfo.new(0.2), {Size = UDim2.new(0.95, 0, 0, 35)}):Play()
                            TweenService:Create(DropdownContainer, TweenInfo.new(0.2), {Size = UDim2.new(0.96, 0, 0, 0)}):Play()
                            IsOpen = false
                            
                            callback(option)
                        end)
                    end
                    
                    -- Update size of dropdown list based on options
                    DropdownList.CanvasSize = UDim2.new(0, 0, 0, DropdownListLayout.AbsoluteContentSize.Y + 10)
                    
                    callback(newSelection)
                end
                
                return DropdownObject
            end
            
            function Elements:AddColorPicker(colorInfo)
                local colorName = colorInfo.Name or "Color Picker"
                local default = colorInfo.Default or Color3.fromRGB(255, 255, 255)
                local callback = colorInfo.Callback or function() end
                
                local ColorPicker = Instance.new("Frame")
                ColorPicker.Name = "ColorPicker_" .. colorName
                ColorPicker.Parent = SectionContainer
                ColorPicker.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                ColorPicker.Size = UDim2.new(0.95, 0, 0, 35)
                
                local ColorPickerCorner = Instance.new("UICorner")
                ColorPickerCorner.CornerRadius = UDim.new(0, 4)
                ColorPickerCorner.Parent = ColorPicker
                
                local ColorLabel = Instance.new("TextLabel")
                ColorLabel.Name = "Label"
                ColorLabel.Parent = ColorPicker
                ColorLabel.BackgroundTransparency = 1
                ColorLabel.Position = UDim2.new(0.02, 0, 0, 0)
                ColorLabel.Size = UDim2.new(0.75, 0, 1, 0)
                ColorLabel.Font = Frosty.Config.Font
                ColorLabel.Text = colorName
                ColorLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
                ColorLabel.TextSize = Frosty.Config.TextSize
                ColorLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                local ColorDisplay = Instance.new("Frame")
                ColorDisplay.Name = "Display"
                ColorDisplay.Parent = ColorPicker
                ColorDisplay.BackgroundColor3 = default
                ColorDisplay.Position = UDim2.new(0.85, 0, 0.5, 0)
                ColorDisplay.Size = UDim2.new(0, 25, 0, 25)
                ColorDisplay.AnchorPoint = Vector2.new(0, 0.5)
                
                local ColorDisplayCorner = Instance.new("UICorner")
                ColorDisplayCorner.CornerRadius = UDim.new(0, 4)
                ColorDisplayCorner.Parent = ColorDisplay
                
                local ColorPickerButton = Instance.new("TextButton")
                ColorPickerButton.Name = "Button"
                ColorPickerButton.Parent = ColorDisplay
                ColorPickerButton.BackgroundTransparency = 1
                ColorPickerButton.Size = UDim2.new(1, 0, 1, 0)
                ColorPickerButton.Text = ""
                
                local ColorPickerFrame = Instance.new("Frame")
                ColorPickerFrame.Name = "PickerFrame"
                ColorPickerFrame.Parent = CoreGui:FindFirstChild("FrostyUI")
                ColorPickerFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                ColorPickerFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
                ColorPickerFrame.Size = UDim2.new(0, 250, 0, 250)
                ColorPickerFrame.AnchorPoint = Vector2.new(0.5, 0.5)
                ColorPickerFrame.Visible = false
                ColorPickerFrame.ZIndex = 10
                
                local ColorPickerFrameCorner = Instance.new("UICorner")
                ColorPickerFrameCorner.CornerRadius = UDim.new(0, 6)
                ColorPickerFrameCorner.Parent = ColorPickerFrame
                
                local ColorPickerTitle = Instance.new("TextLabel")
                ColorPickerTitle.Name = "Title"
                ColorPickerTitle.Parent = ColorPickerFrame
                ColorPickerTitle.BackgroundTransparency = 1
                ColorPickerTitle.Position = UDim2.new(0, 0, 0, 5)
                ColorPickerTitle.Size = UDim2.new(1, 0, 0, 25)
                ColorPickerTitle.Font = Frosty.Config.Font
                ColorPickerTitle.Text = "Color Picker"
                ColorPickerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
                ColorPickerTitle.TextSize = 18
                ColorPickerTitle.ZIndex = 10
                
                local ColorPickerCloseButton = Instance.new("TextButton")
                ColorPickerCloseButton.Name = "CloseButton"
                ColorPickerCloseButton.Parent = ColorPickerFrame
                ColorPickerCloseButton.BackgroundTransparency = 1
                ColorPickerCloseButton.Position = UDim2.new(0.9, 0, 0, 5)
                ColorPickerCloseButton.Size = UDim2.new(0, 20, 0, 20)
                ColorPickerCloseButton.Font = Enum.Font.GothamBold
                ColorPickerCloseButton.Text = "X"
                ColorPickerCloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                ColorPickerCloseButton.TextSize = 14
                ColorPickerCloseButton.ZIndex = 10
                
                local ColorPickerContent = Instance.new("Frame")
                ColorPickerContent.Name = "Content"
                ColorPickerContent.Parent = ColorPickerFrame
                ColorPickerContent.BackgroundTransparency = 1
                ColorPickerContent.Position = UDim2.new(0, 10, 0, 35)
                ColorPickerContent.Size = UDim2.new(1, -20, 1, -45)
                ColorPickerContent.ZIndex = 10
                
                -- Simplified color picker implementation
                -- In a real implementation, this would include a color wheel or grid
                -- and sliders for hue, saturation, value
                
                -- For demonstration, using RGB sliders
                local function CreateSlider(name, color, defaultValue, position)
                    local Slider = Instance.new("Frame")
                    Slider.Name = name .. "Slider"
                    Slider.Parent = ColorPickerContent
                    Slider.BackgroundTransparency = 1
                    Slider.Position = UDim2.new(0, 0, 0, position)
                    Slider.Size = UDim2.new(1, 0, 0, 30)
                    Slider.ZIndex = 10
                    
                    local SliderLabel = Instance.new("TextLabel")
                    SliderLabel.Name = "Label"
                    SliderLabel.Parent = Slider
                    SliderLabel.BackgroundTransparency = 1
                    SliderLabel.Position = UDim2.new(0, 0, 0, 0)
                    SliderLabel.Size = UDim2.new(0.15, 0, 1, 0)
                    SliderLabel.Font = Frosty.Config.Font
                    SliderLabel.Text = name
                    SliderLabel.TextColor3 = color
                    SliderLabel.TextSize = 14
                    SliderLabel.ZIndex = 10
                    
                    local SliderValue = Instance.new("TextLabel")
                    SliderValue.Name = "Value"
                    SliderValue.Parent = Slider
                    SliderValue.BackgroundTransparency = 1
                    SliderValue.Position = UDim2.new(0.85, 0, 0, 0)
                    SliderValue.Size = UDim2.new(0.15, 0, 1, 0)
                    SliderValue.Font = Frosty.Config.Font
                    SliderValue.Text = tostring(defaultValue)
                    SliderValue.TextColor3 = Color3.fromRGB(230, 230, 230)
                    SliderValue.TextSize = 14
                    SliderValue.ZIndex = 10
                    
                    local SliderBackground = Instance.new("Frame")
                    SliderBackground.Name = "Background"
                    SliderBackground.Parent = Slider
                    SliderBackground.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                    SliderBackground.Position = UDim2.new(0.17, 0, 0.5, 0)
                    SliderBackground.Size = UDim2.new(0.65, 0, 0, 6)
                    SliderBackground.AnchorPoint = Vector2.new(0, 0.5)
                    SliderBackground.ZIndex = 10
                    
                    local SliderBackgroundCorner = Instance.new("UICorner")
                    SliderBackgroundCorner.CornerRadius = UDim.new(0, 3)
                    SliderBackgroundCorner.Parent = SliderBackground
                    
                    local SliderFill = Instance.new("Frame")
                    SliderFill.Name = "Fill"
                    SliderFill.Parent = SliderBackground
                    SliderFill.BackgroundColor3 = color
                    SliderFill.Size = UDim2.new(defaultValue/255, 0, 1, 0)
                    SliderFill.ZIndex = 10
                    
                    local SliderFillCorner = Instance.new("UICorner")
                    SliderFillCorner.CornerRadius = UDim.new(0, 3)
                    SliderFillCorner.Parent = SliderFill
                    
                    local SliderButton = Instance.new("TextButton")
                    SliderButton.Name = "Button"
                    SliderButton.Parent = SliderBackground
                    SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    SliderButton.Position = UDim2.new(defaultValue/255, 0, 0.5, 0)
                    SliderButton.Size = UDim2.new(0, 12, 0, 12)
                    SliderButton.Text = ""
                    SliderButton.AnchorPoint = Vector2.new(0.5, 0.5)
                    SliderButton.ZIndex = 11
                    
                    local SliderButtonCorner = Instance.new("UICorner")
                    SliderButtonCorner.CornerRadius = UDim.new(1, 0)
                    SliderButtonCorner.Parent = SliderButton
                    
                    return Slider, SliderBackground, SliderFill, SliderButton, SliderValue
                end
                
                local RedSlider, RedBg, RedFill, RedBtn, RedVal = CreateSlider("R", Color3.fromRGB(255, 50, 50), default.R * 255, 20)
                local GreenSlider, GreenBg, GreenFill, GreenBtn, GreenVal = CreateSlider("G", Color3.fromRGB(50, 255, 50), default.G * 255, 70)
                local BlueSlider, BlueBg, BlueFill, BlueBtn, BlueVal = CreateSlider("B", Color3.fromRGB(50, 50, 255), default.B * 255, 120)
                
                local CurrentColor = default
                
                local function UpdateColorDisplay()
                    ColorDisplay.BackgroundColor3 = CurrentColor
                    callback(CurrentColor)
                end
                
                local function UpdateSlider(slider, fill, button, value, color, val)
                    local percentage = math.clamp(val / 255, 0, 1)
                    fill.Size = UDim2.new(percentage, 0, 1, 0)
                    button.Position = UDim2.new(percentage, 0, 0.5, 0)
                    value.Text = tostring(math.floor(val))
                    
                    local r, g, b = CurrentColor.R, CurrentColor.G, CurrentColor.B
                    if slider.Name == "RSlider" then
                        r = val / 255
                    elseif slider.Name == "GSlider" then
                        g = val / 255
                    elseif slider.Name == "BSlider" then
                        b = val / 255
                    end
                    
                    CurrentColor = Color3.new(r, g, b)
                    UpdateColorDisplay()
                end
                
                -- Handle slider dragging for each color component
                local function SetupSliderEvents(slider, background, fill, button, valueLabel)
                    local isDragging = false
                    
                    button.MouseButton1Down:Connect(function()
                        isDragging = true
                    end)
                    
                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            isDragging = false
                        end
                    end)
                    
                    background.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            isDragging = true
                            local percentage = math.clamp((input.Position.X - background.AbsolutePosition.X) / background.AbsoluteSize.X, 0, 1)
                            local value = percentage * 255
                            UpdateSlider(slider, fill, button, valueLabel, background.BackgroundColor3, value)
                        end
                    end)
                    
                    UserInputService.InputChanged:Connect(function(input)
                        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                            local percentage = math.clamp((input.Position.X - background.AbsolutePosition.X) / background.AbsoluteSize.X, 0, 1)
                            local value = percentage * 255
                            UpdateSlider(slider, fill, button, valueLabel, background.BackgroundColor3, value)
                        end
                    end)
                end
                
                SetupSliderEvents(RedSlider, RedBg, RedFill, RedBtn, RedVal)
                SetupSliderEvents(GreenSlider, GreenBg, GreenFill, GreenBtn, GreenVal)
                SetupSliderEvents(BlueSlider, BlueBg, BlueFill, BlueBtn, BlueVal)
                
                -- Apply Button
                local ApplyButton = Instance.new("TextButton")
                ApplyButton.Name = "ApplyButton"
                ApplyButton.Parent = ColorPickerContent
                ApplyButton.BackgroundColor3 = Frosty.Config.Color
                ApplyButton.Position = UDim2.new(0.25, 0, 0.8, 0)
                ApplyButton.Size = UDim2.new(0.5, 0, 0, 30)
                ApplyButton.Font = Frosty.Config.Font
                ApplyButton.Text = "Apply"
                ApplyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                ApplyButton.TextSize = 16
                ApplyButton.ZIndex = 10
                
                local ApplyButtonCorner = Instance.new("UICorner")
                ApplyButtonCorner.CornerRadius = UDim.new(0, 4)
                ApplyButtonCorner.Parent = ApplyButton
                
                ApplyButton.MouseButton1Click:Connect(function()
                    ColorPickerFrame.Visible = false
                    UpdateColorDisplay()
                end)
                
                -- Close Button action
                ColorPickerCloseButton.MouseButton1Click:Connect(function()
                    ColorPickerFrame.Visible = false
                end)
                
                -- Open color picker
                ColorPickerButton.MouseButton1Click:Connect(function()
                    ColorPickerFrame.Visible = true
                end)
                
                UpdateSectionSize()
                
                local ColorPickerObject = {}
                
                function ColorPickerObject:Set(color)
                    CurrentColor = color
                    ColorDisplay.BackgroundColor3 = color
                    
                    -- Update sliders
                    UpdateSlider(RedSlider, RedFill, RedBtn, RedVal, Color3.fromRGB(255, 50, 50), color.R * 255)
                    UpdateSlider(GreenSlider, GreenFill, GreenBtn, GreenVal, Color3.fromRGB(50, 255, 50), color.G * 255)
                    UpdateSlider(BlueSlider, BlueFill, BlueBtn, BlueVal, Color3.fromRGB(50, 50, 255), color.B * 255)
                    
                    callback(color)
                end
                
                function ColorPickerObject:Get()
                    return CurrentColor
                end
                
                return ColorPickerObject
            end
            
            function Elements:AddInput(inputInfo)
                local inputName = inputInfo.Name or "Input"
                local placeholder = inputInfo.Placeholder or "Enter text..."
                local default = inputInfo.Default or ""
                local callback = inputInfo.Callback or function() end
                
                local Input = Instance.new("Frame")
                Input.Name = "Input_" .. inputName
                Input.Parent = SectionContainer
                Input.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                Input.Size = UDim2.new(0.95, 0, 0, 35)
                
                local InputCorner = Instance.new("UICorner")
                InputCorner.CornerRadius = UDim.new(0, 4)
                InputCorner.Parent = Input
                
                local InputLabel = Instance.new("TextLabel")
                InputLabel.Name = "Label"
                InputLabel.Parent = Input
                InputLabel.BackgroundTransparency = 1
                InputLabel.Position = UDim2.new(0.02, 0, 0, 0)
                InputLabel.Size = UDim2.new(0.3, 0, 1, 0)
                InputLabel.Font = Frosty.Config.Font
                InputLabel.Text = inputName
                InputLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
                InputLabel.TextSize = Frosty.Config.TextSize
                InputLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                local InputField = Instance.new("TextBox")
                InputField.Name = "Field"
                InputField.Parent = Input
                InputField.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                InputField.Position = UDim2.new(0.35, 0, 0.5, 0)
                InputField.Size = UDim2.new(0.63, 0, 0.7, 0)
                InputField.AnchorPoint = Vector2.new(0, 0.5)
                InputField.Font = Frosty.Config.Font
                InputField.PlaceholderText = placeholder
                InputField.Text = default
                InputField.TextColor3 = Color3.fromRGB(230, 230, 230)
                InputField.TextSize = Frosty.Config.TextSize
                InputField.TextWrapped = true
                InputField.ClearTextOnFocus = false
                
                local InputFieldCorner = Instance.new("UICorner")
                InputFieldCorner.CornerRadius = UDim.new(0, 4)
                InputFieldCorner.Parent = InputField
                
                InputField.FocusLost:Connect(function(enterPressed)
                    callback(InputField.Text)
                end)
                
                UpdateSectionSize()
                
                local InputObject = {}
                
                function InputObject:Set(value)
                    InputField.Text = value
                    callback(value)
                end
                
                function InputObject:Get()
                    return InputField.Text
                end
                
                return InputObject
            end
            
            function Elements:AddLabel(labelInfo)
                local text = labelInfo.Text or "Label"
                
                local Label = Instance.new("Frame")
                Label.Name = "Label"
                Label.Parent = SectionContainer
                Label.BackgroundTransparency = 1
                Label.Size = UDim2.new(0.95, 0, 0, 25)
                
                local LabelText = Instance.new("TextLabel")
                LabelText.Name = "Text"
                LabelText.Parent = Label
                LabelText.BackgroundTransparency = 1
                LabelText.Size = UDim2.new(1, 0, 1, 0)
                LabelText.Font = Frosty.Config.Font
                LabelText.Text = text
                LabelText.TextColor3 = Color3.fromRGB(230, 230, 230)
                LabelText.TextSize = Frosty.Config.TextSize
                LabelText.TextWrapped = true
                
                UpdateSectionSize()
                
                local LabelObject = {}
                
                function LabelObject:Set(newText)
                    LabelText.Text = newText
                end
                
                function LabelObject:Get()
                    return LabelText.Text
                end
                
                return LabelObject
            end
            
            return Elements
        end
        
        return Tab
    end
    
    return FrostyLibrary
end

return Frosty
