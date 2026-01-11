-- Define initial customization options
local defaultHighlightColor = Color3.fromRGB(255, 255, 255) -- Default white color if no team color is found
local outlineColor = Color3.fromRGB(0, 0, 0) -- Black outline color
local fillTransparency = 0.5 -- Transparency of the fill
local outlineTransparency = 0 -- Transparency of the outline
local maxDistance = 500 -- Maximum distance to show highlights

-- Toggle variable
local highlightsEnabled = true

-- Table to keep track of players and their distances
local playerDistances = {}

-- Function to get the highlight color based on the player's team
local function getHighlightColor(player)
    local team = player.Team
    if team then
        return team.TeamColor.Color
    else
        return defaultHighlightColor
    end
end

-- Function to create highlight for a player
local function createHighlight(player)
    local character = player.Character or player.CharacterAdded:Wait()
    if character and not character:FindFirstChild("PlayerHighlight") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "PlayerHighlight"
        highlight.Adornee = character
        highlight.FillColor = getHighlightColor(player)
        highlight.OutlineColor = outlineColor
        highlight.FillTransparency = fillTransparency
        highlight.OutlineTransparency = outlineTransparency
        highlight.Parent = character
    end
end

-- Function to remove highlight from a player
local function removeHighlight(player)
    local character = player.Character
    if character then
        local highlight = character:FindFirstChild("PlayerHighlight")
        if highlight then
            highlight:Destroy()
        end
    end
end

-- Function to update highlights based on distance
local function updateHighlights()
    local localPlayer = game.Players.LocalPlayer
    local localCharacter = localPlayer.Character
    if localCharacter and localCharacter.PrimaryPart then
        local localPosition = localCharacter.PrimaryPart.Position
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= localPlayer then
                local character = player.Character
                if character and character.PrimaryPart then
                    local distance = (localPosition - character.PrimaryPart.Position).Magnitude
                    playerDistances[player] = distance
                    if distance <= maxDistance then
                        createHighlight(player)
                    else
                        removeHighlight(player)
                    end
                end
            end
        end
    end
end

-- Batch processing function
local function batchUpdateHighlights()
    for _, player in pairs(game.Players:GetPlayers()) do
        if highlightsEnabled and playerDistances[player] and playerDistances[player] <= maxDistance then
            createHighlight(player)
        else
            removeHighlight(player)
        end
    end
end

-- Connect events
game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if highlightsEnabled then
            createHighlight(player)
        end
    end)
    player.CharacterRemoving:Connect(function()
        removeHighlight(player)
    end)
end)

game.Players.PlayerRemoving:Connect(function(player)
    removeHighlight(player)
    playerDistances[player] = nil
end)

-- Update highlights periodically
spawn(function()
    while true do
        if highlightsEnabled then
            updateHighlights()
        end
        wait(0.5) -- Adjust the interval as needed
    end
end)

-- Batch processing periodically
spawn(function()
    while true do
        batchUpdateHighlights()
        wait(0.1) -- Adjust the interval as needed
    end
end)

-- Toggle button logic
local function createToggleButton()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ToggleHighlightGui"
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 200, 0, 50)
    toggleButton.Position = UDim2.new(0, 10, 0, 10)
    toggleButton.Text = "Disable Highlights"
    toggleButton.Parent = screenGui

    toggleButton.MouseButton1Click:Connect(function()
        highlightsEnabled = not highlightsEnabled
        if highlightsEnabled then
            toggleButton.Text = "Disable Highlights"
            updateHighlights()  -- Initial update when enabled
        else
            toggleButton.Text = "Enable Highlights"
            -- Remove existing highlights
            for _, player in pairs(game.Players:GetPlayers()) do
                removeHighlight(player)
            end
        end
    end)
end

-- Create toggle button
createToggleButton()
