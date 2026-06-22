local CombatSystem = {}

local GameConfig = require(script.Parent.GameConfig)

function CombatSystem.CalculateKnockback(damagePercent, baseKnockback)
	local multiplier = 1 + (damagePercent / 100) * GameConfig.KNOCKBACK_MULTIPLIER
	return baseKnockback * multiplier
end

function CombatSystem.GetKnockbackDirection(attacker, victim, attackType)
	local dir = (victim.HumanoidRootPart.Position - attacker.HumanoidRootPart.Position).Unit

	if attackType == "SpecialUp" then
		dir = Vector3.new(dir.X * 0.3, 1, dir.Z * 0.3).Unit
	elseif attackType == "SpecialDown" then
		dir = Vector3.new(dir.X * 0.5, -0.8, dir.Z * 0.5).Unit
	elseif attackType == "AerialAttack" then
		dir = Vector3.new(dir.X * 0.6, -0.6, dir.Z * 0.6).Unit
	else
		dir = Vector3.new(dir.X, 0.3, dir.Z).Unit
	end

	return dir
end

function CombatSystem.ApplyKnockback(victimCharacter, direction, force)
	local rootPart = victimCharacter:FindFirstChild("HumanoidRootPart")
	if not rootPart then return end

	local bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.Velocity = direction * force
	bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	bodyVelocity.P = 10000
	bodyVelocity.Parent = rootPart

	task.delay(0.2, function()
		if bodyVelocity and bodyVelocity.Parent then
			bodyVelocity:Destroy()
		end
	end)
end

function CombatSystem.IsInRange(attacker, victim, range)
	local attackerPos = attacker.HumanoidRootPart.Position
	local victimPos = victim.HumanoidRootPart.Position
	return (attackerPos - victimPos).Magnitude <= range
end

function CombatSystem.CheckBlastZone(character)
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then return true end
	return rootPart.Position.Y < GameConfig.BLAST_ZONE_Y
		or math.abs(rootPart.Position.X) > 200
		or math.abs(rootPart.Position.Z) > 200
end

return CombatSystem
