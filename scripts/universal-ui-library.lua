-- ============================================================
-- Universal UI Library v2.1.0  (sample skeleton — replace me!)
-- A lightweight, modern UI library skeleton for Roblox scripts.
-- ============================================================
local Library = {}

Library.Themes = {
    Dark = {
        Background = Color3.fromRGB(18, 22, 34),
        Accent     = Color3.fromRGB(255, 68, 56),
        Text       = Color3.fromRGB(230, 238, 252),
    },
}

Library.__instances = {}

-- Create a draggable window
function Library:CreateWindow(config)
    config = config or {}
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ToryLibWindow"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromOffset(config.Size or 480, config.Size and config.Size.Y or 320)
    frame.Position = UDim2.fromScale(0.5, 0.5)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BackgroundColor3 = Library.Themes.Dark.Background
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    -- drag logic
    local dragging, dragOffset
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragOffset = input.Position - frame.AbsolutePosition
        end
    end)
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            frame.Position = UDim2.fromOffset(input.Position.X - dragOffset.X, input.Position.Y - dragOffset.Y)
        end
    end)

    table.insert(Library.__instances, screenGui)
    return frame
end

return Library
