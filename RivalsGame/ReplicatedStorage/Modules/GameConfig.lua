local GameConfig = {}

GameConfig.MAX_STOCKS = 3
GameConfig.ROUND_TIME = 180 -- 3 minutos
GameConfig.MAX_PLAYERS_PER_MATCH = 4
GameConfig.LOBBY_WAIT_TIME = 15
GameConfig.RESPAWN_TIME = 3
GameConfig.KNOCKBACK_MULTIPLIER = 1.5
GameConfig.BLAST_ZONE_Y = -100

-- Combo system
GameConfig.COMBO_WINDOW = 0.8 -- Segundos para encadenar ataques
GameConfig.COMBO_DAMAGE_MULTIPLIER = 0.15 -- +15% daño por hit en combo
GameConfig.COMBO_KNOCKBACK_MULTIPLIER = 0.1 -- +10% knockback por hit en combo
GameConfig.MAX_COMBO_HITS = 10

-- Ranked
GameConfig.RANKED_STARTING_ELO = 1000
GameConfig.RANKED_K_FACTOR = 32
GameConfig.RANKED_MIN_LEVEL = 3
GameConfig.RANKED_STOCKS = 4
GameConfig.RANKED_ROUND_TIME = 240

GameConfig.RankedTiers = {
	{ Name = "Bronce", MinElo = 0, Color = Color3.fromRGB(205, 127, 50) },
	{ Name = "Plata", MinElo = 800, Color = Color3.fromRGB(192, 192, 192) },
	{ Name = "Oro", MinElo = 1000, Color = Color3.fromRGB(255, 215, 0) },
	{ Name = "Platino", MinElo = 1200, Color = Color3.fromRGB(100, 200, 255) },
	{ Name = "Diamante", MinElo = 1400, Color = Color3.fromRGB(185, 120, 255) },
	{ Name = "Maestro", MinElo = 1600, Color = Color3.fromRGB(255, 50, 50) },
	{ Name = "Leyenda", MinElo = 1900, Color = Color3.fromRGB(255, 0, 200) },
}

function GameConfig.GetTier(elo)
	local tier = GameConfig.RankedTiers[1]
	for _, t in ipairs(GameConfig.RankedTiers) do
		if elo >= t.MinElo then tier = t end
	end
	return tier
end

GameConfig.Characters = {
	{
		Name = "Blaze",
		Description = "Guerrero de fuego. Rápido y agresivo.",
		Health = 0, -- En Rivals el daño es porcentaje
		Speed = 20,
		JumpPower = 60,
		Attacks = {
			LightAttack = { Damage = 8, Knockback = 5, Cooldown = 0.3, Range = 6 },
			HeavyAttack = { Damage = 18, Knockback = 15, Cooldown = 0.8, Range = 8 },
			SpecialUp = { Damage = 12, Knockback = 20, Cooldown = 1.2, Range = 10 },
			SpecialSide = { Damage = 15, Knockback = 18, Cooldown = 1.0, Range = 12 },
			SpecialDown = { Damage = 20, Knockback = 25, Cooldown = 1.5, Range = 7 },
			AerialAttack = { Damage = 10, Knockback = 12, Cooldown = 0.5, Range = 7 },
		},
	},
	{
		Name = "Frost",
		Description = "Mago de hielo. Control y defensa.",
		Health = 0,
		Speed = 16,
		JumpPower = 55,
		Attacks = {
			LightAttack = { Damage = 6, Knockback = 3, Cooldown = 0.25, Range = 5 },
			HeavyAttack = { Damage = 22, Knockback = 20, Cooldown = 1.0, Range = 9 },
			SpecialUp = { Damage = 10, Knockback = 18, Cooldown = 1.0, Range = 10 },
			SpecialSide = { Damage = 14, Knockback = 16, Cooldown = 0.9, Range = 14 },
			SpecialDown = { Damage = 16, Knockback = 22, Cooldown = 1.3, Range = 6 },
			AerialAttack = { Damage = 9, Knockback = 10, Cooldown = 0.4, Range = 6 },
		},
	},
	{
		Name = "Shadow",
		Description = "Asesino sigiloso. Combos rápidos.",
		Health = 0,
		Speed = 24,
		JumpPower = 65,
		Attacks = {
			LightAttack = { Damage = 5, Knockback = 2, Cooldown = 0.15, Range = 5 },
			HeavyAttack = { Damage = 14, Knockback = 12, Cooldown = 0.6, Range = 7 },
			SpecialUp = { Damage = 8, Knockback = 22, Cooldown = 0.8, Range = 12 },
			SpecialSide = { Damage = 12, Knockback = 14, Cooldown = 0.7, Range = 10 },
			SpecialDown = { Damage = 18, Knockback = 20, Cooldown = 1.2, Range = 5 },
			AerialAttack = { Damage = 7, Knockback = 8, Cooldown = 0.3, Range = 6 },
		},
	},
	{
		Name = "Titan",
		Description = "Tanque pesado. Daño masivo pero lento.",
		Health = 0,
		Speed = 12,
		JumpPower = 45,
		Attacks = {
			LightAttack = { Damage = 10, Knockback = 8, Cooldown = 0.4, Range = 7 },
			HeavyAttack = { Damage = 28, Knockback = 30, Cooldown = 1.2, Range = 10 },
			SpecialUp = { Damage = 15, Knockback = 25, Cooldown = 1.4, Range = 8 },
			SpecialSide = { Damage = 22, Knockback = 22, Cooldown = 1.1, Range = 12 },
			SpecialDown = { Damage = 25, Knockback = 35, Cooldown = 2.0, Range = 9 },
			AerialAttack = { Damage = 14, Knockback = 18, Cooldown = 0.7, Range = 8 },
		},
	},
	{
		Name = "Volt",
		Description = "Luchador eléctrico. Equilibrado.",
		Health = 0,
		Speed = 18,
		JumpPower = 58,
		Attacks = {
			LightAttack = { Damage = 7, Knockback = 4, Cooldown = 0.25, Range = 6 },
			HeavyAttack = { Damage = 16, Knockback = 16, Cooldown = 0.9, Range = 8 },
			SpecialUp = { Damage = 11, Knockback = 20, Cooldown = 1.0, Range = 11 },
			SpecialSide = { Damage = 13, Knockback = 15, Cooldown = 0.85, Range = 11 },
			SpecialDown = { Damage = 19, Knockback = 24, Cooldown = 1.4, Range = 7 },
			AerialAttack = { Damage = 9, Knockback = 11, Cooldown = 0.45, Range = 7 },
		},
	},
	{
		Name = "Aqua",
		Description = "Guerrera del agua. Fluida y escurridiza.",
		Health = 0,
		Speed = 19,
		JumpPower = 62,
		Attacks = {
			LightAttack = { Damage = 6, Knockback = 3, Cooldown = 0.2, Range = 6 },
			HeavyAttack = { Damage = 17, Knockback = 17, Cooldown = 0.85, Range = 9 },
			SpecialUp = { Damage = 10, Knockback = 22, Cooldown = 1.0, Range = 11 },
			SpecialSide = { Damage = 14, Knockback = 15, Cooldown = 0.8, Range = 13 },
			SpecialDown = { Damage = 18, Knockback = 20, Cooldown = 1.3, Range = 8 },
			AerialAttack = { Damage = 8, Knockback = 10, Cooldown = 0.35, Range = 7 },
		},
	},
	{
		Name = "Gaia",
		Description = "Espíritu de la tierra. Lenta pero devastadora.",
		Health = 0,
		Speed = 13,
		JumpPower = 48,
		Attacks = {
			LightAttack = { Damage = 9, Knockback = 7, Cooldown = 0.35, Range = 7 },
			HeavyAttack = { Damage = 26, Knockback = 28, Cooldown = 1.1, Range = 10 },
			SpecialUp = { Damage = 14, Knockback = 24, Cooldown = 1.3, Range = 9 },
			SpecialSide = { Damage = 20, Knockback = 20, Cooldown = 1.0, Range = 11 },
			SpecialDown = { Damage = 30, Knockback = 38, Cooldown = 2.2, Range = 8 },
			AerialAttack = { Damage = 12, Knockback = 16, Cooldown = 0.6, Range = 7 },
		},
	},
	{
		Name = "Nova",
		Description = "Luchadora cósmica. Ataques de área.",
		Health = 0,
		Speed = 17,
		JumpPower = 60,
		Attacks = {
			LightAttack = { Damage = 7, Knockback = 5, Cooldown = 0.28, Range = 7 },
			HeavyAttack = { Damage = 19, Knockback = 18, Cooldown = 0.95, Range = 11 },
			SpecialUp = { Damage = 13, Knockback = 22, Cooldown = 1.1, Range = 12 },
			SpecialSide = { Damage = 16, Knockback = 17, Cooldown = 0.9, Range = 14 },
			SpecialDown = { Damage = 22, Knockback = 26, Cooldown = 1.5, Range = 10 },
			AerialAttack = { Damage = 10, Knockback = 13, Cooldown = 0.5, Range = 8 },
		},
	},
	{
		Name = "Phantom",
		Description = "Espectro oscuro. Teletransporte y engaño.",
		Health = 0,
		Speed = 22,
		JumpPower = 63,
		Attacks = {
			LightAttack = { Damage = 6, Knockback = 3, Cooldown = 0.18, Range = 5 },
			HeavyAttack = { Damage = 15, Knockback = 13, Cooldown = 0.7, Range = 8 },
			SpecialUp = { Damage = 9, Knockback = 20, Cooldown = 0.9, Range = 13 },
			SpecialSide = { Damage = 13, Knockback = 16, Cooldown = 0.75, Range = 15 },
			SpecialDown = { Damage = 17, Knockback = 19, Cooldown = 1.1, Range = 6 },
			AerialAttack = { Damage = 8, Knockback = 9, Cooldown = 0.3, Range = 7 },
		},
	},
	{
		Name = "Rex",
		Description = "Bestia prehistórica. Puro poder bruto.",
		Health = 0,
		Speed = 14,
		JumpPower = 50,
		Attacks = {
			LightAttack = { Damage = 11, Knockback = 9, Cooldown = 0.45, Range = 8 },
			HeavyAttack = { Damage = 30, Knockback = 32, Cooldown = 1.3, Range = 11 },
			SpecialUp = { Damage = 16, Knockback = 26, Cooldown = 1.5, Range = 9 },
			SpecialSide = { Damage = 24, Knockback = 24, Cooldown = 1.2, Range = 12 },
			SpecialDown = { Damage = 28, Knockback = 40, Cooldown = 2.5, Range = 9 },
			AerialAttack = { Damage = 15, Knockback = 20, Cooldown = 0.8, Range = 8 },
		},
	},
}

GameConfig.Arenas = {
	{
		Name = "Battlefield",
		SpawnPoints = {
			Vector3.new(-20, 10, 0),
			Vector3.new(20, 10, 0),
			Vector3.new(-10, 10, 0),
			Vector3.new(10, 10, 0),
		},
	},
	{
		Name = "Final Destination",
		SpawnPoints = {
			Vector3.new(-25, 10, 0),
			Vector3.new(25, 10, 0),
			Vector3.new(-12, 10, 0),
			Vector3.new(12, 10, 0),
		},
	},
}

return GameConfig
