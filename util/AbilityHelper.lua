local BotsInit = require("game/botsinit")

local M = BotsInit.CreateGeneric()

M.const = {
	MAX_SEARCH_DISTANCE = 1600,
	MAX_ALLY_SEARCH_DISTANCE = 1200,
	EXTRA_SEARCH_DISTANCE = 300,
	WARNING_DISTANCE = 600
}

function M.checkAbilityBuild(abilityTree)
	local npcBot = GetBot()
	if #abilityTree > 26 - npcBot:GetLevel() then
		local level = npcBot:GetLevel()
		for _ = 1, level do
			table.remove(abilityTree, 1)
		end
	end
end

function M.isRoshan(npcTarget)
	return npcTarget ~= nil and npcTarget:IsAlive() and string.find(npcTarget:GetUnitName(), "roshan")
end

function M.isDisabled(npcTarget)
	if npcTarget:IsRooted() or npcTarget:IsStunned() or npcTarget:IsHexed() then
		return true
	else
		return false
	end
end

function M.isValidTarget(npcTarget)
	return npcTarget ~= nil and npcTarget:IsAlive() and npcTarget:IsHero()
end

function M.hasForbiddenModifier(npcTarget)
	local modifier = {
		"modifier_winter_wyvern_winters_curse",
		"modifier_winter_wyvern_winters_curse_aura",
		"modifier_abaddon_borrowed_time",
		"modifier_obsidian_destroyer_astral_imprisonment_prison"
		--"modifier_modifier_dazzle_shallow_grave",
		--"modifier_modifier_oracle_false_promise",
		--"modifier_oracle_fates_edict"
	}

	for _, mod in pairs(modifier) do
		if npcTarget:HasModifier(mod) then
			return true
		end
	end
	return false
end

function M.hasSphere(npcTarget)
	local modifier = {
		"modifier_item_sphere",
		"modifier_item_sphere_target"
	}

	for _, mod in pairs(modifier) do
		if npcTarget:HasModifier(mod) then
			return true
		end
	end
	return false
end

function M.isSuspiciousIllusion(npcTarget)
	--TO DO Need to detect enemy hero's illusions better
	local bot = GetBot()
	--Detect allies's illusions
	if
		npcTarget:IsIllusion() or npcTarget:HasModifier("modifier_illusion") or
			npcTarget:HasModifier("modifier_phantom_lancer_doppelwalk_illusion") or
			npcTarget:HasModifier("modifier_phantom_lancer_juxtapose_illusion") or
			npcTarget:HasModifier("modifier_darkseer_wallofreplica_illusion") or
			npcTarget:HasModifier("modifier_terrorblade_conjureimage")
	 then
		return true
	else
		--Detect replicate and wall of replica illusions
		if GetGameMode() ~= GAMEMODE_MO then
			if npcTarget:GetTeam() ~= bot:GetTeam() then
				local TeamMember = GetTeamPlayers(GetTeam())
				for i = 1, #TeamMember do
					local ally = GetTeamMember(i)
					if ally ~= nil and ally:GetUnitName() == npcTarget:GetUnitName() then
						return true
					end
				end
			end
		end
		return false
	end
end

function M.normalCanCast(npcTarget)
	return npcTarget:CanBeSeen() and not npcTarget:IsInvulnerable() and not M.isSuspiciousIllusion(npcTarget) and
		not M.hasForbiddenModifier(npcTarget) and
		not npcTarget:IsMagicImmune()
end

function M.roshanCanCast(npcTarget)
	return npcTarget:CanBeSeen() and not npcTarget:IsInvulnerable() and not M.isSuspiciousIllusion(npcTarget) and
		not M.hasForbiddenModifier(npcTarget)
end

function M.ultimateCanCast(npcTarget)
	return npcTarget:CanBeSeen() and not npcTarget:IsInvulnerable() and not M.isSuspiciousIllusion(npcTarget) and
		not M.hasForbiddenModifier(npcTarget) and
		not M.hasSphere(npcTarget)
end

function M.aoeCanCast(npcTarget)
	return npcTarget:CanBeSeen() and not npcTarget:IsMagicImmune() and not npcTarget:IsInvulnerable() and
		not M.hasForbiddenModifier(npcTarget)
end

function M.getComboMana(AbilitiesReal)
	local tempComboMana = 0
	for _, ability in pairs(AbilitiesReal) do
		if ability:IsPassive() == false then
			if ability:IsUltimate() == false or ability:GetCooldownTimeRemaining() <= 30 then
				tempComboMana = tempComboMana + ability:GetManaCost()
			end
		end
	end
	return math.max(tempComboMana, 300)
end

function M.getComboDamage(AbilitiesReal)
	local tempComboDamage = 0
	for _, ability in pairs(AbilitiesReal) do
		if ability:IsPassive() == false then
			tempComboDamage = tempComboDamage + ability:GetAbilityDamage()
		end
	end
	return math.max(tempComboDamage, GetBot():GetOffensivePower())
end

function M.getWeakestUnit(EnemyUnits)
	if EnemyUnits == nil or #EnemyUnits == 0 then
		return nil, 10000
	end

	local WeakestUnit = nil
	local LowestHealth = 10000
	for _, unit in pairs(EnemyUnits) do
		if unit ~= nil and unit:IsAlive() then
			if unit:GetHealth() < LowestHealth then
				LowestHealth = unit:GetHealth()
				WeakestUnit = unit
			end
		end
	end

	return WeakestUnit, LowestHealth
end

function M.getStrongestUnit(EnemyUnits)
	if EnemyUnits == nil or #EnemyUnits == 0 then
		return nil, 0
	end

	local StrongestUnit = nil
	local HighestHealth = 0
	for _, unit in pairs(EnemyUnits) do
		if unit ~= nil and unit:IsAlive() then
			if unit:GetHealth() > HighestHealth then
				HighestHealth = unit:GetHealth()
				StrongestUnit = unit
			end
		end
	end

	return StrongestUnit, HighestHealth
end

return M
