local ComboSystem = {}

local GameConfig = require(script.Parent.GameConfig)

local ActiveCombos = {} -- { [attackerUserId_victimUserId] = { Hits, LastHitTime, Attacks } }

function ComboSystem.RegisterHit(attackerUserId, victimUserId, attackType)
	local key = attackerUserId .. "_" .. victimUserId
	local now = tick()

	local combo = ActiveCombos[key]

	if combo and (now - combo.LastHitTime) <= GameConfig.COMBO_WINDOW then
		combo.Hits = math.min(combo.Hits + 1, GameConfig.MAX_COMBO_HITS)
		combo.LastHitTime = now
		table.insert(combo.Attacks, attackType)
	else
		ActiveCombos[key] = {
			Hits = 1,
			LastHitTime = now,
			Attacks = { attackType },
		}
		combo = ActiveCombos[key]
	end

	return combo
end

function ComboSystem.GetDamageMultiplier(combo)
	if not combo or combo.Hits <= 1 then return 1.0 end
	return 1.0 + (combo.Hits - 1) * GameConfig.COMBO_DAMAGE_MULTIPLIER
end

function ComboSystem.GetKnockbackMultiplier(combo)
	if not combo or combo.Hits <= 1 then return 1.0 end
	return 1.0 + (combo.Hits - 1) * GameConfig.COMBO_KNOCKBACK_MULTIPLIER
end

function ComboSystem.GetComboData(attackerUserId, victimUserId)
	local key = attackerUserId .. "_" .. victimUserId
	return ActiveCombos[key]
end

function ComboSystem.ResetCombo(attackerUserId, victimUserId)
	local key = attackerUserId .. "_" .. victimUserId
	ActiveCombos[key] = nil
end

function ComboSystem.ResetAllForPlayer(userId)
	local keysToRemove = {}
	for key in pairs(ActiveCombos) do
		if key:find(tostring(userId)) then
			table.insert(keysToRemove, key)
		end
	end
	for _, key in ipairs(keysToRemove) do
		ActiveCombos[key] = nil
	end
end

function ComboSystem.CleanupExpired()
	local now = tick()
	local keysToRemove = {}
	for key, combo in pairs(ActiveCombos) do
		if (now - combo.LastHitTime) > GameConfig.COMBO_WINDOW * 2 then
			table.insert(keysToRemove, key)
		end
	end
	for _, key in ipairs(keysToRemove) do
		ActiveCombos[key] = nil
	end
end

return ComboSystem
