-- ============================================================
-- Network Ownership Lab v1.3.2  (sample skeleton — replace me!)
-- Educational research tool: inspect & visualize network
-- ownership of parts in the workspace. No disruptive payloads.
-- ============================================================
local Lab = {}
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

-- Log the current network owner of every part (research only)
function Lab:Scan()
    local report = {}
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") then
            local owner = part:GetNetworkOwner()
            table.insert(report, {
                name = part:GetFullName(),
                owner = owner and owner.Name or "SERVER",
            })
        end
    end
    return report
end

-- Visualize ownership: highlight parts owned by the local player
function Lab:Visualize()
    local highlight = Instance.new("Highlight")
    highlight.FillTransparency = 0.6
    highlight.FillColor = Color3.fromRGB(76, 201, 255)
    highlight.Parent = nil

    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and part:GetNetworkOwner() == localPlayer then
            local h = highlight:Clone()
            h.Parent = part
        end
    end
end

-- Run one scan every 5 seconds (toggle with Lab:Toggle())
Lab._running = false
function Lab:Toggle()
    self._running = not self._running
    if self._running then
        task.spawn(function()
            while self._running and task.wait(5) do
                print("[NetworkOwnershipLab] scanned", #self:Scan(), "parts")
            end
        end)
    end
end

return Lab
