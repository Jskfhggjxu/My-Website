-- ============================================================
-- Anti-AFK v1.0.0
-- Simulates movement input at configurable intervals.
-- ============================================================
local AntiAFK = {}

AntiAFK.Interval = 60        -- seconds between inputs
AntiAFK.Radius = 3           -- max random movement radius

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local running = false

local function jiggle()
    if not character or not character:FindFirstChild("Humanoid") then
        character = player.Character or player.CharacterAdded:Wait()
        return
    end
    local humanoid = character:FindFirstChild("HumanoidRootPart")
    if not humanoid then return end

    -- tiny random nudge on the HumanoidRootPart
    local angle = math.random() * math.pi * 2
    humanoid.AssemblyLinearVelocity = Vector3.new(
        math.cos(angle) * AntiAFK.Radius,
        0,
        math.sin(angle) * AntiAFK.Radius
    )
    -- also wiggle the mouse so Roblox sees real input
    local mouse = player:GetMouse()
    if mouse then
        UserInputService:SetMouseDelta(Vector2.new(1, 0))
    end
end

function AntiAFK:Start()
    if running then return end
    running = true
    task.spawn(function()
        while running and task.wait(AntiAFK.Interval) do
            jiggle()
        end
    end)
end

function AntiAFK:Stop()
    running = false
end

return AntiAFK
