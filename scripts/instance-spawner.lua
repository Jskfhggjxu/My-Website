-- ============================================================
-- Instance Spawner v2.0.1  (sample skeleton — replace me!)
-- GUI tool for spawning, cloning & inspecting Instances at runtime.
-- ============================================================
local Spawner = {}

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- spawn a part with options
function Spawner:SpawnPart(opts)
    opts = opts or {}
    local part = Instance.new("Part")
    part.Size = opts.Size or Vector3.new(4, 1, 4)
    part.Position = opts.Position or (player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 0)) or Vector3.zero
    part.Color = opts.Color or Color3.fromRGB(255, 68, 56)
    part.Material = opts.Material or Enum.Material.SmoothPlastic
    part.Anchored = opts.Anchored or false
    part.CanCollide = opts.CanCollide or true
    part.Parent = workspace
    return part
end

-- clone an existing instance
function Spawner:CloneInstance(instance, parent)
    local clone = instance:Clone()
    clone.Parent = parent or workspace
    return clone
end

-- inspect: dump properties of an instance
function Spawner:Inspect(instance)
    local props = {}
    for _, prop in ipairs(instance:GetProperties()) do
        local ok, val = pcall(function()
            return instance[prop.Name]
        end)
        props[prop.Name] = ok and tostring(val) or "<error>"
    end
    return props
end

-- simple property editor via CommandBar output
function Spawner:SetProperty(instance, prop, value)
    local ok, err = pcall(function()
        instance[prop] = value
    end)
    if not ok then warn("[InstanceSpawner]", err) end
    return ok
end

return Spawner
