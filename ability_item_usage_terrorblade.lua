----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.5b
--	Author: adamqqq		Email:adamqqq@163.com
--  Contributor: zmcmcc Email:mengzhang@utexas.edu
----------------------------------------------------------------------------
--------------------------------------
-- General Initialization
--------------------------------------
local utility = require(GetScriptDirectory() .. "/utility")
local ability_item_usage_generic = require(GetScriptDirectory() .. "/ability_item_usage_generic")
local AbilityExtensions = require(GetScriptDirectory() .. "/util/AbilityAbstraction")
local A = require(GetScriptDirectory() .. "/util/MiraDota")
-- ItemUsageThink = A.Dota.EmptyDesireFun

local debugmode = false
local npcBot = GetBot()
if npcBot:IsIllusion() then return end
local Talents = {}
local Abilities = {}
local AbilitiesReal = {}

ability_item_usage_generic.InitAbility(Abilities, AbilitiesReal, Talents)

local AbilityToLevelUp =
{
	Abilities[3],
	Abilities[1],
	Abilities[3],
	Abilities[1],
	Abilities[3],
	Abilities[6],
	Abilities[3],
	Abilities[2],
	Abilities[2],
	"talent",
	Abilities[2],
	Abilities[6],
	Abilities[2],
	Abilities[1],
	"talent",
	Abilities[1],
	"nil",
	Abilities[6],
	"nil",
	"talent",
	"nil",
	"nil",
	"nil",
	"nil",
	"talent",
}
local TalentTree = {
	function()
		return Talents[1]
	end,
	function()
		return Talents[3]
	end,
	function()
		return Talents[5]
	end,
	function()
		return Talents[8]
	end
}

-- check skill build vs current level
utility.CheckAbilityBuild(AbilityToLevelUp)

function AbilityLevelUpThink()
	ability_item_usage_generic.AbilityLevelUpThink2(AbilityToLevelUp, TalentTree)
end

--------------------------------------
-- Ability Usage Thinking
--------------------------------------
local cast = {}
cast.Desire = {}
cast.Target = {}
cast.Type = {}
local Consider = {}
local CanCast = { function(t)
	return AbilityExtensions:StunCanCast(t, AbilitiesReal[1], false, false, true, false)
		and A.Unit.IsNotCreepHero(t)
end, utility.CanCastNoTarget, utility.CanCastNoTarget, utility.NCanCast, utility.NCanCast, function(t)
	return AbilityExtensions:NormalCanCast(t, _, DAMAGE_TYPE_PURE, true) and A.Unit.IsNotCreepHero(t)
end }
local enemyDisabled = utility.enemyDisabled

function GetComboDamage()
	return ability_item_usage_generic.GetComboDamage(AbilitiesReal)
end

function GetComboMana()
	return ability_item_usage_generic.GetComboMana(AbilitiesReal)
end

Consider[5] = function()
	local abilityNumber = 5
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability = AbilitiesReal[abilityNumber];

	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE
	end

	local CastRange = 0
	local Damage = ability:GetAbilityDamage()
	local Radius = ability:GetAOERadius() - 100
	local CastPoint = ability:GetCastPoint()


	local allys = npcBot:GetNearbyHeroes(Radius, false, BOT_MODE_NONE);
	local WeakestAlly, AllyHealth = utility.GetWeakestUnit(allys)
	local enemys = npcBot:GetNearbyHeroes(Radius, true, BOT_MODE_NONE)
	local WeakestEnemy, HeroHealth = utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(Radius, true)
	local WeakestCreep, CreepHealth = utility.GetWeakestUnit(creeps)
	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------
	--Try to kill enemy hero
	if (npcBot:GetActiveMode() ~= BOT_MODE_RETREAT)
	then
		if (WeakestEnemy ~= nil)
		then
			if (CanCast[abilityNumber](WeakestEnemy))
			then
				if (
					HeroHealth <= WeakestEnemy:GetActualIncomingDamage(GetComboDamage(), DAMAGE_TYPE_MAGICAL) and
						npcBot:GetMana() > ComboMana
						and GetUnitToUnitDistance(npcBot, WeakestEnemy) < Radius - 120)
				then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	--protect myself
	if (ManaPercentage > 0.4 or npcBot:GetMana() > ComboMana)
	then
		if (npcBot:WasRecentlyDamagedByAnyHero(2) and #enemys >= 2)
		then
			for _, npcEnemy in pairs(enemys) do
				if (CanCast[abilityNumber](npcEnemy))
				then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end
	end



	-- If we're going after someone
	if (npcBot:GetActiveMode() == BOT_MODE_ROAM or
		npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		npcBot:GetActiveMode() == BOT_MODE_ATTACK)
	then
		local npcEnemy = AbilityExtensions:GetTargetIfGood(npcBot)

		if (npcEnemy ~= nil)
		then
			if (CanCast[abilityNumber](npcEnemy) and GetUnitToUnitDistance(npcBot, npcEnemy) < Radius - 120)
			then
				return BOT_ACTION_DESIRE_MODERATE
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

-- copied and modified from dark seer ability 1

Consider[1] = function()

	local abilityNumber = 1
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability = AbilitiesReal[abilityNumber];

	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end

	local CastRange = ability:GetCastRange();
	local Damage = ability:GetAbilityDamage();
	local Radius = ability:GetAOERadius()
	local CastPoint = ability:GetCastPoint();

	local allys = npcBot:GetNearbyHeroes(1200, false, BOT_MODE_NONE);
	local enemys = npcBot:GetNearbyHeroes(CastRange + 300, true, BOT_MODE_NONE)
	local WeakestEnemy, HeroHealth = utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange + 300, true)
	local WeakestCreep, CreepHealth = utility.GetWeakestUnit(creeps)

	--------------------------------------
	-- Mode based usage
	--------------------------------------

	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if (npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH)
	then
		for _, npcEnemy in pairs(enemys) do
			if (npcBot:WasRecentlyDamagedByHero(npcEnemy, 2.0))
			then
				if (CanCast[abilityNumber](npcEnemy))
				then
					return BOT_ACTION_DESIRE_LOW, npcEnemy:GetExtrapolatedLocation(CastPoint);
				end
			end
		end
	end

	-- If we're going after someone
	if (npcBot:GetActiveMode() == BOT_MODE_ROAM or
		npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		npcBot:GetActiveMode() == BOT_MODE_ATTACK)
	then
		local locationAoE = npcBot:FindAoELocation(true, true, npcBot:GetLocation(), CastRange, Radius, 0, 0);
		if (locationAoE.count >= 3) then
			return BOT_ACTION_DESIRE_LOW + 0.05, locationAoE.targetloc;
		end

		local npcEnemy = npcBot:GetTarget()

		if (npcEnemy ~= nil)
		then
			if (CanCast[abilityNumber](npcEnemy))
			then
				return BOT_ACTION_DESIRE_LOW, npcEnemy:GetExtrapolatedLocation(CastPoint);
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0

end

Consider[2] = function()
	local abilityNumber = 2
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability = AbilitiesReal[abilityNumber];

	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end

	local CastRange = 0
	local Damage = 0
	local CastPoint = ability:GetCastPoint();

	local allys = npcBot:GetNearbyHeroes(1200, false, BOT_MODE_NONE);
	local enemys = npcBot:GetNearbyHeroes(CastRange + 300, true, BOT_MODE_NONE)
	local WeakestEnemy, HeroHealth = utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange + 300, true)
	local WeakestCreep, CreepHealth = utility.GetWeakestUnit(creeps)
	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------
	-- If we're in a teamfight, use it on the scariest enemy
	local tableNearbyAttackingAlliedHeroes = npcBot:GetNearbyHeroes(1000, false, BOT_MODE_ATTACK);
	if (#tableNearbyAttackingAlliedHeroes >= 2)
	then
		return BOT_ACTION_DESIRE_HIGH
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	local enemys2 = npcBot:GetNearbyHeroes(400, true, BOT_MODE_NONE);

	-- If we're going after someone
	if (npcBot:GetActiveMode() == BOT_MODE_ROAM or
		npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		npcBot:GetActiveMode() == BOT_MODE_ATTACK)
	then
		local npcEnemy = npcBot:GetTarget();

		if (npcEnemy ~= nil)
		then
			if (CanCast[abilityNumber](npcEnemy) and GetUnitToUnitDistance(npcBot, npcEnemy) < CastRange + 75 * #allys)
			then
				return BOT_ACTION_DESIRE_MODERATE
			end
		end
	end

	-- If we're farming and can kill 3+ creeps
	if (npcBot:GetActiveMode() == BOT_MODE_FARM or
		npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
		npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or
		npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
		npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
		npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
		npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT)
	then
		if ((ManaPercentage > 0.5 or npcBot:GetMana() > ComboMana))
		then
			if (#creeps >= 3) then
				return BOT_ACTION_DESIRE_LOW
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;

end

Consider[3] = function()

	local abilityNumber = 3
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability = AbilitiesReal[abilityNumber];

	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end

	local CastRange = 600
	local Damage = ability:GetAbilityDamage();


	local allys = npcBot:GetNearbyHeroes(1200, false, BOT_MODE_NONE);
	local enemys = npcBot:GetNearbyHeroes(CastRange + 300, true, BOT_MODE_NONE)
	local WeakestEnemy, HeroHealth = utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange + 300, true)
	local WeakestCreep, CreepHealth = utility.GetWeakestUnit(creeps)
	local towers = npcBot:GetNearbyTowers(CastRange + 300, true)
	local towers2 = npcBot:GetNearbyTowers(CastRange + 300, false)

	--try to kill enemy hero
	if (npcBot:GetActiveMode() ~= BOT_MODE_RETREAT)
	then
		if (WeakestEnemy ~= nil)
		then
			if (
				HeroHealth <= WeakestEnemy:GetActualIncomingDamage(Damage, DAMAGE_TYPE_MAGICAL) or
					(
					HeroHealth <= WeakestEnemy:GetActualIncomingDamage(GetComboDamage(), DAMAGE_TYPE_MAGICAL) and
						npcBot:GetMana() > ComboMana))
			then
				return BOT_ACTION_DESIRE_HIGH - 0.03
			end
		end
	end

	--------------------------------------
	-- Mode based usage
	--------------------------------------
	-- If we're in a teamfight, use it on the scariest enemy
	local tableNearbyAttackingAlliedHeroes = npcBot:GetNearbyHeroes(1000, false, BOT_MODE_ATTACK);
	if (#tableNearbyAttackingAlliedHeroes >= 2)
	then

		local npcMostDangerousEnemy = nil;
		local nMostDangerousDamage = 0;

		for _, npcEnemy in pairs(enemys) do
			if (CanCast[abilityNumber](npcEnemy) and not enemyDisabled(npcEnemy))
			then
				local Damage2 = npcEnemy:GetEstimatedDamageToTarget(false, npcBot, 3.0, DAMAGE_TYPE_ALL);
				if (Damage2 > nMostDangerousDamage)
				then
					nMostDangerousDamage = Damage2;
					npcMostDangerousEnemy = npcEnemy;
				end
			end
		end

		if (npcMostDangerousEnemy ~= nil)
		then
			return BOT_ACTION_DESIRE_HIGH - 0.03
		end
	end

	-- If we're pushing or defending a lane and can hit 4+ creeps, go for it
	if (npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
		npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
		npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or
		npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
		npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
		npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT)
	then
		if (#towers + #towers2 >= 1 and #enemys >= 2)
		then
			return BOT_ACTION_DESIRE_LOW - 0.01
		end
	end
	return BOT_ACTION_DESIRE_NONE, 0
end

-- terror wave
Consider[4] = function()
	local ability = AbilitiesReal[4]
	if not ability:IsFullyCastable() or ability:IsHidden() then
		return 0
	end

	if AbilityExtensions:IsAttackingEnemies(npcBot) then
		local target = AbilityExtensions:GetTargetIfGood(npcBot)
		if target and GetUnitToUnitDistanceSqr(target, npcBot) <= 360000 then
			if not npcBot:HasModifier "modifier_terrorblade_metamorphosis" then
				return BOT_ACTION_DESIRE_HIGH
			else
				return BOT_ACTION_DESIRE_LOW
			end
		end
	end
	local nearbyTargets = AbilityExtensions:GetNearbyNonIllusionHeroes(npcBot, 300):Filter(function(t)
		return npcBot:WasRecentlyDamagedByHero(t, 1.2)
	end)
	if AbilityExtensions:GetEnemyHeroNumber(npcBot, nearbyTargets) >= 2 or #nearbyTargets >= 4 then
		if AbilityExtensions:IsAttackingEnemies(npcBot) or AbilityExtensions:IsRetreating(npcBot) then
			if npcBot:HasModifier "modifier_terrorblade_metamorphosis" then
				return BOT_ACTION_DESIRE_HIGH
			else
				return BOT_ACTION_DESIRE_LOW
			end
		end
	end
	return 0
end

-- demon zeal
Consider[5] = function()
	local ability = AbilitiesReal[4]
	if not ability:IsFullyCastable() or ability:IsHidden() then
		return 0
	end

	if AbilityExtensions:IsFarmingOrPushing(npcBot) then
		if npcBot:GetMana() >= 300 then
			if #AbilityExtensions:GetNearbyCreeps(npcBot, 1000, true) >= 7 or #npcBot:GetNearbyTowers(1000, true) >= 1 then
				return BOT_ACTION_DESIRE_MODERATE
			end
		end
	end
	if AbilityExtensions:IsAttackingEnemies(npcBot) then
		if #AbilityExtensions:GetNearbyNonIllusionHeroes(npcBot) > 0 and npcBot:GetAttackTarget() then
			return BOT_ACTION_DESIRE_HIGH
		end
	end
	if AbilityExtensions:NotRetreating(npcBot) then
		local target = AbilityExtensions:GetTargetIfGood(npcBot)
		if target and npcBot:GetMana() >= 180 and GetUnitToUnitDistanceSqr(npcBot, target) <= 640000 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end
	return 0
end

Consider[6] = function()
	local abilityNumber = 6
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability = AbilitiesReal[abilityNumber];

	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end

	local CastRange = ability:GetCastRange();
	local Damage = ability:GetAbilityDamage();


	local allys = npcBot:GetNearbyHeroes(1200, false, BOT_MODE_NONE);
	local enemys = npcBot:GetNearbyHeroes(CastRange + 300, true, BOT_MODE_NONE)
	local WeakestEnemy, HeroHealth = utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange + 300, true)
	local WeakestCreep, CreepHealth = utility.GetWeakestUnit(creeps)


	-- If we're in a teamfight, use it on the scariest enemy
	local tableNearbyAttackingAlliedHeroes = npcBot:GetNearbyHeroes(1000, false, BOT_MODE_ATTACK)
	if (#tableNearbyAttackingAlliedHeroes >= 2)
	then

		local npcMostDangerousEnemy = nil;
		local nMostHealth = 0;

		for _, npcEnemy in pairs(enemys) do
			if (CanCast[abilityNumber](npcEnemy))
			then
				local nEnemyHP = npcEnemy:GetHealth();
				if nEnemyHP > nMostHealth and nEnemyHP / npcEnemy:GetMaxHealth() > 0.6
				then
					nMostHealth = nEnemyHP;
					npcMostDangerousEnemy = npcEnemy;
				end
			end
		end

		if npcMostDangerousEnemy ~= nil and HealthPercentage < 0.3 and
			GetUnitToUnitDistance(npcMostDangerousEnemy, npcBot) < CastRange - 100
			and nMostHealth >= npcBot:GetHealth() * 2 then
			return BOT_ACTION_DESIRE_HIGH, npcMostDangerousEnemy
		end
	end

	--------------------------------------
	-- Mode based usage
	--------------------------------------
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if (npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH)
	then
		local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes(CastRange, true, BOT_MODE_NONE);
		for _, npcEnemy in pairs(tableNearbyEnemyHeroes) do
			if (npcBot:WasRecentlyDamagedByHero(npcEnemy, 2.0))
			then
				if CanCast[abilityNumber](npcEnemy) and HealthPercentage < 0.3
					and npcEnemy:GetHealth() / npcEnemy:GetMaxHealth() > 0.6
					and npcEnemy:GetHealth() >= npcBot:GetHealth() * 2 then
					return BOT_ACTION_DESIRE_HIGH, npcEnemy;
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end


AbilityExtensions:AutoModifyConsiderFunction(npcBot, Consider, AbilitiesReal)
function AbilityUsageThink()

	-- Check if we're already using an ability
	if (npcBot:IsUsingAbility() or npcBot:IsChanneling() or npcBot:IsSilenced())
	then
		return
	end

	ComboMana = GetComboMana()
	AttackRange = npcBot:GetAttackRange()
	ManaPercentage = npcBot:GetMana() / npcBot:GetMaxMana()
	HealthPercentage = npcBot:GetHealth() / npcBot:GetMaxHealth()

	cast = ability_item_usage_generic.ConsiderAbility(AbilitiesReal, Consider)
	---------------------------------debug--------------------------------------------
	if (debugmode == true)
	then
		ability_item_usage_generic.PrintDebugInfo(AbilitiesReal, cast)
	end
	ability_item_usage_generic.UseAbility(AbilitiesReal, cast)
end

function CourierUsageThink()
	ability_item_usage_generic.CourierUsageThink()
end
