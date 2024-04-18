----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.3 New Structure
--	Author: Archer Wayne		Email:archerwayne1216@gmail.com
----------------------------------------------------------------------------
--------------------------------------
-- General Initialization
--------------------------------------
local utility = require(GetScriptDirectory() .. "/utility")
local ability_item_usage_generic = require(GetScriptDirectory() .. "/ability_item_usage_generic")
local AbilityExtensions = require(GetScriptDirectory() .. "/util/AbilityAbstraction")
local ItemUsage = require(GetScriptDirectory() .. "/util/ItemUsage-New")

local debugmode = false
local npcBot = GetBot()
if npcBot == nil or npcBot:IsIllusion() then
	return
end

local Talents = {}
local Abilities = {}
local AbilitiesReal = {}

ability_item_usage_generic.InitAbility(Abilities, AbilitiesReal, Talents)

local AbilityToLevelUp =
{
	Abilities[1], --1
	Abilities[2], --2
	Abilities[1], --3
	Abilities[3], --4
	Abilities[1], --5
	Abilities[6], --6
	Abilities[1], --7
	Abilities[2], --8
	Abilities[2], --9
	Abilities[2], --10
	"talent", --11
	Abilities[6], --12
	Abilities[3], --13
	Abilities[3], --14
	"talent", --15
	Abilities[3], --16
	"nil", --17
	Abilities[6], --18
	"nil", --19
	"talent", --20
	"nil", --21
	"nil", --22
	"nil", --23
	"nil", --24
	"talent", --25
}

local TalentTree = {
	function()
		return Talents[2]
	end,
	function()
		return Talents[4]
	end,
	function()
		return Talents[6]
	end,
	function()
		return Talents[8]
	end
}

-- check skill build vs current level
utility.CheckAbilityBuild(AbilityToLevelUp)

function BuybackUsageThink()
	ability_item_usage_generic.BuybackUsageThink();
end

function CourierUsageThink()
	ability_item_usage_generic.CourierUsageThink();
end

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
local CanCast = { utility.NCanCast, utility.NCanCast, utility.NCanCast, utility.UCanCast, utility.UCanCast,
	utility.UCanCast }
local enemyDisabled = utility.enemyDisabled

function GetComboDamage()
	return ability_item_usage_generic.GetComboDamage(AbilitiesReal)
end

function GetComboMana()
	return ability_item_usage_generic.GetComboMana(AbilitiesReal)
end

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
	local Radius = ability:GetAOERadius();


	local allys = npcBot:GetNearbyHeroes(1200, false, BOT_MODE_NONE);
	local enemys = npcBot:GetNearbyHeroes(CastRange + 0, true, BOT_MODE_NONE);
	local WeakestEnemy, HeroHealth = utility.GetWeakestUnit(enemys);
	local creeps = npcBot:GetNearbyCreeps(CastRange + 0, true);
	local WeakestCreep, CreepHealth = utility.GetWeakestUnit(creeps);

	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------

	--try to kill enemy hero
	if (npcBot:GetActiveMode() ~= BOT_MODE_RETREAT)
	then
		if (WeakestEnemy ~= nil)
		then
			if (CanCast[abilityNumber](WeakestEnemy))
			then
				if (
					HeroHealth <= WeakestEnemy:GetActualIncomingDamage(Damage, DAMAGE_TYPE_MAGICAL) or
					(
						HeroHealth <= WeakestEnemy:GetActualIncomingDamage(GetComboDamage(), DAMAGE_TYPE_MAGICAL) and
						npcBot:GetMana() > ComboMana))
						then
					return BOT_ACTION_DESIRE_HIGH, WeakestEnemy, "Target";
				end
			end
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	--Last hit
	if (npcBot:GetActiveMode() == BOT_MODE_LANING)
	then
		if (WeakestCreep ~= nil)
		then
			if ((ManaPercentage > 0.5 or npcBot:GetMana() > ComboMana))
			then
				local locationAoE = npcBot:FindAoELocation(true, false, npcBot:GetLocation(), CastRange, Radius, 125, Damage);
				if (locationAoE.count >= 1) then
					return BOT_ACTION_DESIRE_HIGH, locationAoE.targetloc, "Location"
				end
			end
		end
	end

	if (npcBot:GetActiveMode() == BOT_MODE_LANING)
	then
		if ((ManaPercentage > 0.5 or npcBot:GetMana() > ComboMana) and ability:GetLevel() >= 4)
		then
			local locationAoE = npcBot:FindAoELocation(true, true, npcBot:GetLocation(), CastRange, Radius, 0, 0);
			if (locationAoE.count >= 2) then
				return BOT_ACTION_DESIRE_HIGH, locationAoE.targetloc, "Location"
			end
		end
	end

	-- If we're farming and can kill 2+ creeps with hd's first skill
	if (npcBot:GetActiveMode() == BOT_MODE_FARM) then
		local locationAoE = npcBot:FindAoELocation(true, false, npcBot:GetLocation(), CastRange, Radius, 0, Damage);

		if (locationAoE.count >= 2) then
			return BOT_ACTION_DESIRE_HIGH, locationAoE.targetloc, "Location"
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
		local locationAoE = npcBot:FindAoELocation(true, false, npcBot:GetLocation(), CastRange, Radius, 0, 0);

		if (locationAoE.count >= 4)
		then
			return BOT_ACTION_DESIRE_HIGH, locationAoE.targetloc, "Location"
		end
	end

	-- If we're going after someone
	if (npcBot:GetActiveMode() == BOT_MODE_ROAM or
		npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		npcBot:GetActiveMode() == BOT_MODE_ATTACK)
	then
		local npcTarget = npcBot:GetTarget();

		if (npcTarget ~= nil)
		then
			if (CanCast[abilityNumber](npcTarget))
			then
				return BOT_ACTION_DESIRE_HIGH, npcTarget:GetLocation(), "Location"
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;

end

Consider[2] = function()

	local abilityNumber = 2

	local ability = AbilitiesReal[abilityNumber];

	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end

	local CastRange = ability:GetCastRange();
	local Damage = ability:GetAbilityDamage();
	local Radius = ability:GetAOERadius();
	local CastPoint = ability:GetCastPoint()

	local allys = npcBot:GetNearbyHeroes(1200, false, BOT_MODE_NONE);
	local enemys = npcBot:GetNearbyHeroes(CastRange + 200, true, BOT_MODE_NONE)
	local WeakestEnemy, HeroHealth = utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange + 200, true)
	local WeakestCreep, CreepHealth = utility.GetWeakestUnit(creeps)

	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------

	-- Check for a channeling enemy
	for _, npcEnemy in pairs(enemys) do
		if (npcEnemy:IsChanneling())
		then
			return BOT_ACTION_DESIRE_HIGH, npcEnemy:GetLocation();
		end
	end

	--try to kill enemy hero
	if (npcBot:GetActiveMode() ~= BOT_MODE_RETREAT)
	then
		if (WeakestEnemy ~= nil)
		then
			if (CanCast[4](WeakestEnemy))
			then
				if (
					HeroHealth <= WeakestEnemy:GetActualIncomingDamage(Damage, DAMAGE_TYPE_MAGICAL) or
						(
						HeroHealth <= WeakestEnemy:GetActualIncomingDamage(GetComboDamage(), DAMAGE_TYPE_MAGICAL) and
							npcBot:GetMana() > ComboMana))
				then
					return BOT_ACTION_DESIRE_HIGH, WeakestEnemy:GetExtrapolatedLocation(0.8);
				end
			end
		end
	end

	local imprisonedEnemy = AbilityExtensions:Map(npcBot:GetNearbyHeroes(CastRange + 200, true, BOT_MODE_NONE),
		function(t) return { t, AbilityExtensions:GetImprisonmentRemainingDuration(t) } end)
	imprisonedEnemy = AbilityExtensions:First(imprisonedEnemy, function(t) return t[2] ~= nil end)
	if imprisonedEnemy ~= nil then
		local timer = imprisonedEnemy[2] - ability:GetSpecialValueFloat("effect_delay") - ability:GetCastPoint() - 0.1
		if timer >= 0 then
			return BOT_ACTION_DESIRE_VERYHIGH, imprisonedEnemy[1]:GetLocation()
		end
	end

	--------------------------------------
	-- Mode based usage
	--------------------------------------
	if ((ManaPercentage > 0.4 or npcBot:GetMana() > ComboMana) and ability:GetLevel() >= 1)
	then
		local locationAoE = npcBot:FindAoELocation(true, true, npcBot:GetLocation(), CastRange, Radius, CastPoint, 0);
		if (locationAoE.count >= 2) then
			return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc;
		end
	end

	-- If we're farming and can kill 3+ creeps with LSA
	if (npcBot:GetActiveMode() == BOT_MODE_FARM) then
		local locationAoE = npcBot:FindAoELocation(true, false, npcBot:GetLocation(), CastRange, Radius, CastPoint, Damage);

		if (locationAoE.count >= 3) then
			return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc;
		end
	end

	if (npcBot:GetActiveMode() == BOT_MODE_LANING)
	then
		if (WeakestEnemy ~= nil and CanCast[4](WeakestEnemy))
		then
			if (ManaPercentage > 0.66 or npcBot:GetMana() > ComboMana)
			then
				return BOT_ACTION_DESIRE_LOW, WeakestEnemy:GetExtrapolatedLocation(CastPoint)
			end
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
		local locationAoE = npcBot:FindAoELocation(true, false, npcBot:GetLocation(), CastRange, Radius, CastPoint, 0);

		if (locationAoE.count >= 4)
		then
			return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc;
		end
	end

	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if (npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH)
	then
		local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes(CastRange + Radius + 200, true, BOT_MODE_NONE);
		for _, npcEnemy in pairs(tableNearbyEnemyHeroes) do
			if (npcBot:WasRecentlyDamagedByHero(npcEnemy, 2.0))
			then
				if (CanCast[4](npcEnemy))
				then
					return BOT_ACTION_DESIRE_MODERATE, npcEnemy:GetExtrapolatedLocation(0.95);
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
		local npcTarget = npcBot:GetTarget();

		if (npcTarget ~= nil)
		then
			if (CanCast[4](npcTarget))
			then
				return BOT_ACTION_DESIRE_HIGH, npcTarget:GetExtrapolatedLocation(0.8);
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

	if not ability:IsFullyCastable() or npcBot:HasModifier("modifier_shadow_demon_purge_slow")
	then
		return BOT_ACTION_DESIRE_NONE, 0;
	end

	local CastRange = ability:GetCastRange();
	local CastPoint = ability:GetCastPoint();

	local allys = npcBot:GetNearbyHeroes(1200, false, BOT_MODE_NONE);
	local enemys = npcBot:GetNearbyHeroes(CastRange + 300, true, BOT_MODE_NONE)
	local WeakestEnemy, HeroHealth = utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange + 300, true)
	local WeakestCreep, CreepHealth = utility.GetWeakestUnit(creeps)
	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------
	--Try to kill enemy hero
	if (npcBot:GetActiveMode() ~= BOT_MODE_RETREAT)
	then
		if (WeakestEnemy ~= nil and CanCast[abilityNumber](WeakestEnemy))
		then
			if (WeakestEnemy:GetHealth() / WeakestEnemy:GetMaxHealth() < 0.3)
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	--------------------------------------
	-- Mode based usage
	--------------------------------------
	--protect myself
	local enemys2 = npcBot:GetNearbyHeroes(600, true, BOT_MODE_NONE);
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if (
		(npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH) or #enemys2 >
			0)
	then
		for _, npcEnemy in pairs(enemys) do
			if (
				(npcBot:WasRecentlyDamagedByHero(npcEnemy, 2.0) and HealthPercentage < 0.4) or
					GetUnitToUnitDistance(npcBot, npcEnemy) < 400)
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end


	-- If we're going after someone
	if (npcBot:GetActiveMode() == BOT_MODE_ROAM or
		npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		npcBot:GetActiveMode() == BOT_MODE_ATTACK)
	then
		local npcEnemy = npcBot:GetTarget();

		if (npcEnemy ~= nil)
		then
			if (npcEnemy:GetHealth() / npcEnemy:GetMaxHealth() < 0.4 or GetUnitToUnitDistance(npcBot, npcEnemy) >
				AttackRange + 200)
			then
				return BOT_ACTION_DESIRE_HIGH, npcEnemy
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;
end

Consider[6] = function()
	local abilityNumber = 6
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability = AbilitiesReal[abilityNumber];

	-- return BOT_ACTION_DESIRE_HIGH;

	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = ability:GetCastRange();
	local Damage = ability:GetAbilityDamage();
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange+200, true, BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	-- local creeps = npcBot:GetNearbyCreeps(CastRange+200, true)
	-- local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
	
	--try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		if (WeakestEnemy~=nil)
		then
			if ( CanCast[abilityNumber]( WeakestEnemy ) )
			then
				if(WeakestEnemy:GetHealth()/WeakestEnemy:GetMaxHealth() < 0.5 and #allys >=#enemys)
				then
					return BOT_ACTION_DESIRE_HIGH,WeakestEnemy;
				end
			end
		end
	end
	
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		 npcBot:GetActiveMode() == BOT_MODE_ATTACK ) 
	then
		local npcEnemy = npcBot:GetTarget();

		if ( npcEnemy ~= nil ) 
		then
			if ( CanCast[abilityNumber]( npcEnemy ) and npcEnemy:GetHealth()/npcEnemy:GetMaxHealth() < 0.5
			 and GetUnitToUnitDistance(npcBot,npcEnemy)< CastRange and #allys >=#enemys)
			then
				return BOT_ACTION_DESIRE_MODERATE, npcEnemy;
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;
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
