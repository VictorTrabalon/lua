-- Define colors
local squadColor = Color3.new(0.2, 0.8, 0.2) -- Green for squad members
local enemyColor = Color3.new(0.8, 0.2, 0.2) -- Red for enemies
local lineColor = Color3.new(1, 1, 1) -- White for lines

-- Enable/disable ESP by default
local isEnabled = false

-- Function to draw a line from the center of the screen to the player's head
local function drawLine(player)
    local playerCharacter = player.Character
    if playerCharacter then
        local headPosition = playerCharacter:WaitForChild("Head").Position
        local screenPosition, isOnScreen = workspace.CurrentCamera:WorldToScreenPoint(headPosition)

        if isOnScreen then
            local center = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
            local line = Drawing.new("Line")
            line.Visible = true
            line.From = center
            line.To = screenPosition + Vector2.new(0, 50) -- Offset the line slightly below the head
            line.Color = lineColor
        end
    end
end

-- Function to update the ESP for all players
local function updateESP()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            local playerCharacter = player.Character
            if playerCharacter then
                local headPosition = playerCharacter:WaitForChild("Head").Position
                local screenPosition, isOnScreen = workspace.CurrentCamera:WorldToScreenPoint(headPosition)

                if isOnScreen then
                    local boxSize = Vector2.new(50, 50)
                    local boxPosition = screenPosition - boxSize / 2

                    -- Create and configure the ESP box
                    local box = Drawing.new("Rectangle")
                    box.Visible = true
                    box.Size = boxSize
                    box.Position = boxPosition
                    box.CornerRadius = 5
                    box.Color = Color3.new(0, 0, 0) -- Transparent background for glow effect

                    -- Add a glow effect to the box
                    local glow = box:WaitForChild("Outline")
                    if not glow then
                        glow = box:AddChild("Outline")
                        glow.StrokeColor = box.Color -- Match the box color
                        glow.StrokeThickness = 5 -- Adjust thickness for desired glow intensity
                        glow.StrokeTransparency = 0.5 -- Control glow visibility
                    end

                    if player.Team == game.Players.LocalPlayer.Team then
                        box.Color = squadColor
                    else
                        box.Color = enemyColor
                    end

                    -- Add player name above the box
                    local nameLabel = Drawing.new("Text")
                    nameLabel.Visible = true
                    nameLabel.Text = player.Name
                    nameLabel.Position = boxPosition + Vector2.new(boxSize.X / 2, boxSize.Y + 10) -- Position above the box
                    nameLabel.TextColor = box.Color
                    nameLabel.TextOutlined = true -- Add outline for better visibility
                    nameLabel.TextOutlineColor = Color3.new(0, 0, 0) -- Black outline

                    -- Calculate and display distance
                    local distance = (headPosition - game.Players.LocalPlayer.Character.Head.Position).Magnitude
                    local distanceLabel = Drawing.new("Text")
                    distanceLabel.Visible = true
                    distanceLabel.Text = string.format("%.1f studs", distance)
                    distanceLabel.Position = boxPosition + Vector2.new(boxSize.X / 2, boxSize.Y - 15) -- Position below the box
                    distanceLabel.TextColor = box.Color
                    distanceLabel.TextOutlined = true
                    distanceLabel.TextOutlineColor = Color3.new(0, 0, 0)

                    -- Add a map point for the player
                    local mapPoint = Drawing.new("Circle")
                    mapPoint.Visible = true
                    mapPoint.Radius = 3
                    mapPoint.Position = Vector2.new(headPosition.X, headPosition.Z) -- Ignore Y for 2D map representation
                    mapPoint.Color = box.Color
                end
            end
        end
    end
end

-- Update ESP every frame
game:GetService("RunService").
