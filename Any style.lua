local players = game:GetService("Players")
local player = players.LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AnthuhubX/Main/refs/heads/main/UI%20premium"))()

MakeWindow({
    Hub = {
        Title = "Any style",
        Animation = "Made by sae"
    },
    Key = {
        KeySystem = false,
        Title = "XLZ Hub Premium made by Sae",
        Description = "Blue Lock Rivals (Updated)",
        Keys = {"Xlz"},
        Notifi = {
            Notifications = false,
        }
    },
    Theme = {
        Background = Color3.fromRGB(30, 30, 90),
        TopBar = Color3.fromRGB(50, 50, 200),
        TextColor = Color3.fromRGB(255, 255, 255),
        BorderColor = Color3.fromRGB(0, 0, 255),
    }
})

MinimizeButton({
    Size = {40, 40},
    Color = Color3.fromRGB(10, 10, 90),
    Corner = true,
    Stroke = true,
    StrokeColor = Color3.fromRGB(0, 0, 255)
})

local StyleFlowTab = MakeTab({Name = "Any style"})
AddParagraph(StyleFlowTab, {"• Set your style!"})

local function set_style(desired_style)
    if player:FindFirstChild("PlayerStats") then
        local playerStats = player.PlayerStats
        if playerStats:FindFirstChild("Style") then
            playerStats.Style.Value = desired_style
        end
    end
end

local function set_flow(desired_flow)
    if player:FindFirstChild("PlayerStats") then
        local playerStats = player.PlayerStats
        if playerStats:FindFirstChild("Flow") then
            playerStats.Flow.Value = desired_flow
        end
    end
end

local styleId
local StyleTextBox = AddTextBox(StyleFlowTab, {
    Name = "Style Name",
    Default = "",
    TextDisappear = false,
    PlaceholderText = "PUT STYLE NAME",
    ClearText = true,
    Callback = function(value)
        styleId = value
    end
})

AddButton(StyleFlowTab, {
    Name = "Get the Style (reo needed)",
    Callback = function()
        if styleId and styleId ~= "" then
            set_style(styleId)
            MakeNotifi({
                Title = "Success",
                Text = "You got the style!",
                Time = 5
            })
        else
            MakeNotifi({
                Title = "Error",
                Text = "Please enter a valid style name",
                Time = 5
            })
        end
    end
})
