----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.3 New Structure
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
--------------------------------------
-- General Initialization
--------------------------------------
local utility = require( GetScriptDirectory().."/utility" ) 
require(GetScriptDirectory() .. "/ability_item_usage_generic")

local debugmode = false
local npcBot = GetBot()
local Talents = {}
local Abilities = {}
local AbilitiesReal = {}

ability_item_usage_generic.InitAbility(Abilities, AbilitiesReal, Talents)

local AbilityToLevelUp =
{
	Abilities[2],
	Abilities[1],
	Abilities[1],
	Abilities[2],
	Abilities[1],
	Abilities[4],
	Abilities[1],
	Abilities[2],
	Abilities[2],
	"talent",
	Abilities[3],
	Abilities[4],
	Abilities[3],
	Abilities[3],
	"talent",
	Abilities[3],
	"nil",
	Abilities[4],
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
		return Talents[2]
	end,
	function()
		return Talents[3]
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

function AbilityLevelUpThink()
	ability_item_usage_generic.AbilityLevelUpThink2(AbilityToLevelUp, TalentTree)
end

--------------------------------------
-- Ability Usage Thinking
--------------------------------------
local cast = {}cast.Desire = {}cast.Target = {}cast.Type = {}
local Consider = {}
local CanCast = {utility.NCanCast, utility.NCanCast, utility.NCanCast, utility.UCanCast}
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
	
	if not ability:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = ability:GetCastRange();
	local Damage = ability:GetAbilityDamage();
	local CastPoint = ability:GetCastPoint();
	
	local allys = npcBot:GetNearbyHeroes(1200, false, BOT_MODE_NONE);
	local enemys = npcBot:GetNearbyHeroes(math.min(1600,CastRange + 300), true, BOT_MODE_NONE)
	local WeakestEnemy, HeroHealth = utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(math.min(1600,CastRange + 300), true)
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
				if (HeroHealth <= WeakestEnemy:GetActualIncomingDamage(Damage, DAMAGE_TYPE_MAGICAL) or (HeroHealth <= WeakestEnemy:GetActualIncomingDamage(GetComboDamage(), DAMAGE_TYPE_MAGICAL) and npcBot:GetMana() > ComboMana))
				then
					return BOT_ACTION_DESIRE_HIGH, WeakestEnemy;
				end
			end
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if (npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH)
	then
		for _, npcEnemy in pairs(enemys)
		do
			if (npcBot:WasRecentlyDamagedByHero(npcEnemy, 2.0))
			then
				if (CanCast[abilityNumber](npcEnemy))
				then
					return BOT_ACTION_DESIRE_HIGH, npcEnemy;
				end
			end
		end
	end
	
	-- If my mana is enough,use it at enemy
	if (npcBot:GetActiveMode() == BOT_MODE_LANING)
	then
		if ((ManaPercentage > 0.6 or npcBot:GetMana() > ComboMana) and ability:GetLevel() >= 2)
		then
			if (WeakestEnemy ~= nil)
			then
				if (CanCast[abilityNumber](WeakestEnemy))
				then
					return BOT_ACTION_DESIRE_LOW, WeakestEnemy;
				end
			end
		end
	end
	
	--Last hit
	if (npcBot:GetActiveMode() == BOT_MODE_LANING)
	then
		if (WeakestCreep ~= nil)
		then
			if ((ManaPercentage > 0.6 or npcBot:GetMana() > ComboMana) and GetUnitToUnitDistance(npcBot, WeakestCreep) >= AttackRange + 100 and ability:GetLevel() >= 2)
			then
				if (CreepHealth <= WeakestCreep:GetActualIncomingDamage(Damage, DAMAGE_TYPE_MAGICAL))
				then
					return BOT_ACTION_DESIRE_LOW+0.05, WeakestCreep;
				end
			end
		end
	end
	
	-- If we're farming and can hit 2+ creeps and kill 1+
	if (npcBot:GetActiveMode() == BOT_MODE_FARM)
	then
		if (#creeps >= 2)
		then
			if (CreepHealth <= WeakestCreep:GetActualIncomingDamage(Damage, DAMAGE_TYPE_MAGICAL) and npcBot:GetMana() > ComboMana)
			then
				return BOT_ACTION_DESIRE_LOW, WeakestCreep;
			end
		end
	end
	
	-- If we're pushing or defending a lane
	if (npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
		npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
		npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or
		npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
		npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
		npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT)
	then
		if (#creeps >= 3)
		then
			if (ManaPercentage > 0.6 or npcBot:GetMana() > ComboMana)
			then
				if (CanCast[abilityNumber](creeps[1]) and GetUnitToUnitDistance(npcBot, creeps[1]) < CastRange + 75 * #allys)
				then
					return BOT_ACTION_DESIRE_MODERATE, creeps[1];
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
		local npcEnemy = npcBot:GetTarget();
		
		if (npcEnemy ~= nil)
		then
			if (CanCast[abilityNumber](npcEnemy) and not enemyDisabled(npcEnemy) and GetUnitToUnitDistance(npcBot, npcEnemy) < CastRange + 75 * #allys)
			then
				return BOT_ACTION_DESIRE_MODERATE, npcEnemy
			end
		end
	end
	
	return BOT_ACTION_DESIRE_NONE, 0;

end

function IsLocationOverlapWeb(location, Radius)
	local unit = GetUnitList(UNIT_LIST_ALLIES);
	for _, u in pairs(unit)
	do
		if u:GetUnitName() == "npc_dota_broodmother_web"
		then
			local flag = (2 * Radius) - 100;
			if GetUnitToLocationDistance(u, location) <= flag then
				return true
			end
		end
	end
	return false;
end

function GetTowardsFountainLocation(unitLoc, distance)
	local destination = {};
	if (GetTeam() == TEAM_RADIANT) then
		destination[1] = unitLoc[1] - distance / math.sqrt(2);
		destination[2] = unitLoc[2] - distance / math.sqrt(2);
	end
	
	if (GetTeam() == TEAM_DIRE) then
		destination[1] = unitLoc[1] + distance / math.sqrt(2);
		destination[2] = unitLoc[2] + distance / math.sqrt(2);
	end
	return Vector(destination[1], destination[2]);
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
	
	local Radius = ability:GetAOERadius()
	local CastRange = ability:GetCastRange();
	local CastPoint = ability:GetCastPoint();
	
	local allys = npcBot:GetNearbyHeroes(1200, false, BOT_MODE_NONE);
	local enemys = npcBot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
	local WeakestEnemy, HeroHealth = utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(1600, true)
	local WeakestCreep, CreepHealth = utility.GetWeakestUnit(creeps)
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	--[[if (npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH)
	then
		if (npcBot:WasRecentlyDamagedByAnyHero(2.0))
		then
			if (not IsLocationOverlapWeb(GetTowardsFountainLocation(npcBot:GetLocation(), CastRange), Radius))
			then
				return BOT_ACTION_DESIRE_MODERATE, GetTowardsFountainLocation(npcBot:GetLocation(), CastRange);
			end
		end
	end]]

	-- Check if stuck on cliff.
	--[[if not IsLocationPassable(npcBot:GetLocation()) then
		return BOT_MODE_DESIRE_HIGH, npcBot:GetLocation();
	end]]

	if(npcBot.Blink==nil or DotaTime()-npcBot.Blink.Timer>=25)
	then
		npcBot.Blink={Point=npcBot:GetLocation(),Timer=DotaTime()}
	end

	local trees= npcBot:GetNearbyTrees(300)
	if(trees~=nil and #trees>=10 or (utility.PointToPointDistance(npcBot:GetLocation(),npcBot.Blink.Point)<=150 and DotaTime()-npcBot.Blink.Timer<25 and DotaTime()-npcBot.Blink.Timer>23))
	then
		return BOT_ACTION_DESIRE_HIGH, npcBot:GetLocation();
	end
	
	-- If my mana is enough,use it at enemy
	if (npcBot:GetActiveMode() == BOT_MODE_LANING)
	then
		if creeps ~= nil and #creeps >= 4 and not IsLocationOverlapWeb(npcBot:GetLocation(), Radius) then
			return BOT_MODE_DESIRE_MODERATE, npcBot:GetLocation();
		end
	end
	
	-- If we're pushing or defending a lane
	if (npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
		npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
		npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT)
	then
		local lanecreeps = npcBot:GetNearbyLaneCreeps(1600, true);
		local NearbyTower = npcBot:GetNearbyTowers(Radius, true);
		local locationAoE = npcBot:FindAoELocation(true, false, npcBot:GetLocation(), CastRange, Radius / 3, 0, 0);
		if locationAoE.count >= 3 and #lanecreeps >= 3 and not IsLocationOverlapWeb(locationAoE.targetloc, Radius) then
			return BOT_ACTION_DESIRE_MODERATE, locationAoE.targetloc;
		end
		if NearbyTower[1] ~= nil and not NearbyTower[1]:IsInvulnerable() and
			not IsLocationOverlapWeb(NearbyTower[1]:GetLocation(), Radius)
		then
			return BOT_ACTION_DESIRE_MODERATE, NearbyTower[1]:GetLocation();
		end
	end
	
	if (npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
		npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
		npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT)
	then
		local NearbyTower = npcBot:GetNearbyTowers(Radius, false);
		if NearbyTower[1] ~= nil and not NearbyTower[1]:IsInvulnerable() and
			not IsLocationOverlapWeb(NearbyTower[1]:GetLocation(), Radius)
		then
			return BOT_ACTION_DESIRE_MODERATE, NearbyTower[1]:GetLocation();
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
			if (not IsLocationOverlapWeb(npcEnemy:GetExtrapolatedLocation(CastPoint), Radius) and GetUnitToUnitDistance(npcBot, npcEnemy) < CastRange + 75 * #allys)
			then
				return BOT_ACTION_DESIRE_MODERATE, npcEnemy:GetExtrapolatedLocation(CastPoint);
			end
		end
	end
	
	return BOT_ACTION_DESIRE_NONE, 0;

end

Consider[4] = function()
	local abilityNumber = 4
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability = AbilitiesReal[abilityNumber];
	
	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = ability:GetCastRange();
	local CastPoint = ability:GetCastPoint();
	
	local allys = npcBot:GetNearbyHeroes(1200, false, BOT_MODE_NONE);
	local enemys = npcBot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
	local WeakestEnemy, HeroHealth = utility.GetWeakestUnit(enemys)
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
				if (HeroHealth <= WeakestEnemy:GetActualIncomingDamage(GetComboDamage(), DAMAGE_TYPE_MAGICAL) and npcBot:GetMana() > ComboMana)
				then
					return BOT_ACTION_DESIRE_LOW
				end
			end
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	-- If we're going after someone
	if (npcBot:GetActiveMode() == BOT_MODE_ROAM or
		npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		npcBot:GetActiveMode() == BOT_MODE_ATTACK)
	then
		local npcEnemy = npcBot:GetTarget();
		
		if (npcEnemy ~= nil)
		then
			if (CanCast[abilityNumber](npcEnemy) and GetUnitToUnitDistance(npcBot, npcEnemy) <= 400)
			then
				return BOT_ACTION_DESIRE_LOW
			end
		end
	end
	
	return BOT_ACTION_DESIRE_NONE, 0;

end

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
