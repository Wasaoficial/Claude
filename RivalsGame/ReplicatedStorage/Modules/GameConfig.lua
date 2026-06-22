local GameConfig = {}

GameConfig.MAX_STOCKS = 3
GameConfig.ROUND_TIME = 180 -- 3 minutos
GameConfig.MAX_PLAYERS_PER_MATCH = 4
GameConfig.LOBBY_WAIT_TIME = 15
GameConfig.RESPAWN_TIME = 3
GameConfig.KNOCKBACK_MULTIPLIER = 1.5
GameConfig.BLAST_ZONE_Y = -100

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
