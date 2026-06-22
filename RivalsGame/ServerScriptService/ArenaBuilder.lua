-- Genera arenas básicas con partes de Roblox
-- Podés reemplazar esto con mapas hechos en Studio

local Workspace = game:GetService("Workspace")

local ArenasFolder = Instance.new("Folder")
ArenasFolder.Name = "Arenas"
ArenasFolder.Parent = Workspace

local function createPlatform(parent, position, size, color, name)
	local part = Instance.new("Part")
	part.Name = name or "Platform"
	part.Size = size
	part.Position = position
	part.Anchored = true
	part.BrickColor = BrickColor.new(color)
	part.Material = Enum.Material.SmoothPlastic
	part.Parent = parent
	return part
end

-- Arena 1: Battlefield
local bf = Instance.new("Folder")
bf.Name = "Battlefield"
bf.Parent = ArenasFolder

createPlatform(bf, Vector3.new(0, 0, 0), Vector3.new(80, 3, 40), "Dark stone grey", "MainPlatform")
createPlatform(bf, Vector3.new(-20, 15, 0), Vector3.new(20, 2, 15), "Medium stone grey", "LeftPlatform")
createPlatform(bf, Vector3.new(20, 15, 0), Vector3.new(20, 2, 15), "Medium stone grey", "RightPlatform")
createPlatform(bf, Vector3.new(0, 25, 0), Vector3.new(15, 2, 12), "Medium stone grey", "TopPlatform")

-- Bordes / paredes invisibles para orientación
local wallL = Instance.new("Part")
wallL.Name = "WallLeft"
wallL.Size = Vector3.new(2, 50, 40)
wallL.Position = Vector3.new(-50, 25, 0)
wallL.Anchored = true
wallL.Transparency = 0.8
wallL.BrickColor = BrickColor.new("Really red")
wallL.CanCollide = false
wallL.Parent = bf

local wallR = wallL:Clone()
wallR.Name = "WallRight"
wallR.Position = Vector3.new(50, 25, 0)
wallR.Parent = bf

-- Arena 2: Final Destination
local fd = Instance.new("Folder")
fd.Name = "FinalDestination"
fd.Parent = ArenasFolder

createPlatform(fd, Vector3.new(0, 0, 0), Vector3.new(100, 3, 35), "Black", "MainPlatform")

-- Detalles visuales
for i = -4, 4 do
	local glow = Instance.new("Part")
	glow.Size = Vector3.new(2, 1, 35)
	glow.Position = Vector3.new(i * 10, 1.5, 0)
	glow.Anchored = true
	glow.Material = Enum.Material.Neon
	glow.BrickColor = BrickColor.new("Cyan")
	glow.Transparency = 0.5
	glow.CanCollide = false
	glow.Parent = fd
end

-- Kill zone (abajo)
local killZone = Instance.new("Part")
killZone.Name = "KillZone"
killZone.Size = Vector3.new(500, 5, 500)
killZone.Position = Vector3.new(0, -100, 0)
killZone.Anchored = true
killZone.Transparency = 1
killZone.CanCollide = false
killZone.Parent = Workspace

-- Desactivar arenas que no se usan
for _, arena in ipairs(ArenasFolder:GetChildren()) do
	for _, part in ipairs(arena:GetDescendants()) do
		if part:IsA("BasePart") then
			part.Transparency = 1
			part.CanCollide = false
		end
	end
end

-- Función para activar arena
local function ActivateArena(arenaName)
	for _, arena in ipairs(ArenasFolder:GetChildren()) do
		local isActive = arena.Name == arenaName
		for _, part in ipairs(arena:GetDescendants()) do
			if part:IsA("BasePart") then
				part.Transparency = isActive and (part.Name:find("Wall") and 0.8 or 0) or 1
				part.CanCollide = isActive and (not part.Name:find("Wall"))
			end
		end
	end
end

ActivateArena("Battlefield")

print("[ArenaBuilder] Arenas construidas")
