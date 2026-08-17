-- ============================================================
-- Speed Farm Hub v0.9.5  (sample skeleton — replace me!)
-- Farming hub: waypoints, auto-click toggle, per-game presets.
-- Built on top of the Universal UI Library.
-- ============================================================
local Library = require(script.Parent:WaitForChild("universal-ui-library"))

local FarmHub = {}
FarmHub.Waypoints = {}      -- { [name] = Vector3 }
FarmHub.AutoClick = false
FarmHub.Presets = {}        -- { [gameName] = { waypoints = {}, interval = 0.1 } }

local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- teleport to a saved waypoint
function FarmHub:TeleportTo(name)
    local point = self.Waypoints[name]
    if not point then return false end
    local char = player.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    hrp.CFrame = CFrame.new(point)
    return true
end

-- auto-click loop (toggled via hub GUI)
function FarmHub:SetAutoClick(enabled, interval)
    self.AutoClick = enabled
    if enabled then
        task.spawn(function()
            while self.AutoClick and task.wait(interval or 0.1) do
                VirtualInputManager:SendMouseButtonEvent(
                    game:GetService("GuiService"):GetScreenResolution().X / 2,
                    game:GetService("GuiService"):GetScreenResolution().Y / 2,
                    0, true, game, 1
                )
                VirtualInputManager:SendMouseButtonEvent(
                    game:GetService("GuiService"):GetScreenResolution().X / 2,
                    game:GetService("GuiService"):GetScreenResolution().Y / 2,
                    0, false, game, 1
                )
            end
        end)
    end
end

-- build the hub window
function FarmHub:Init()
    local win = Library:CreateWindow({ Size = Vector2.new(420, 260) })
    print("[SpeedFarmHub] window created — add your buttons here")
    return win
end

return FarmHub
