----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.3 New Structure
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
--------------------------------------
-- General Initialization
--------------------------------------
local utility = require( GetScriptDirectory().."/utility" ) 
require(GetScriptDirectory() ..  "/ability_item_usage_generic")
local AbilityExtensions = require(GetScriptDirectory().."/util/AbilityAbstraction")

local debugmode=false
local npcBot = GetBot()
local Talents ={}
local Abilities ={}
local AbilitiesReal ={}

ability_item_usage_generic.InitAbility(Abilities,AbilitiesReal,Talents) 

local AbilityToLevelUp=
{
	Abilities[3],
	Abilities[2],
	Abilities[1],
	Abilities[1],
	Abilities[1],
	Abilities[4],
	Abilities[1],
	Abilities[3],
	Abilities[3],
	"talent",
	Abilities[2],
	Abilities[4],
	Abilities[2],
	Abilities[2],
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

local TalentTree={
	function()
		return Talents[1]
	end,
	function()
		return Talents[4]
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
	ability_item_usage_generic.AbilityLevelUpThink2(AbilityToLevelUp,TalentTree)
end

--------------------------------------
-- Ability Usage Thinking
--------------------------------------
local cast={} cast.Desire={} cast.Target={} cast.Type={}
local Consider ={}
local CanCast={utility.NCanCast,utility.NCanCast,utility.NCanCast,utility.UCanCast}
local enemyDisabled=utility.enemyDisabled

function GetComboDamage()
	return ability_item_usage_generic.GetComboDamage(AbilitiesReal)
end

function GetComboMana()
	return ability_item_usage_generic.GetComboMana(AbilitiesReal)
end

Consider[1]=function()	--Target Ability Example
	local abilityNumber=1
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability=AbilitiesReal[abilityNumber];
	
	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local Radius = ability:GetSpecialValueInt( "bounce_aoe" );
	local CastRange = ability:GetCastRange();
	local Damage = ability:GetAbilityDamage();
	local CastPoint = ability:GetCastPoint();
	
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(Radius,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange+300,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------
	-- Check for a channeling enemy
	for _,npcEnemy in pairs( enemys )
	do
		if ( npcEnemy:IsChanneling() and CanCast[abilityNumber]( npcEnemy )) 
		then
			if(GetUnitToUnitDistance(npcBot,npcEnemy)<CastRange)
			then
				return BOT_ACTION_DESIRE_HIGH, npcEnemy;
			elseif(creeps[1]~=nil and npcEnemy:HasModifier("modifier_bounty_hunter_track"))
			then
				return BOT_ACTION_DESIRE_HIGH, creeps[1];
			end
		end
	end
	
	--Try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		if (WeakestEnemy~=nil)
		then
			if ( CanCast[abilityNumber]( WeakestEnemy ) )
			then
				if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL) or (HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana))
				then
					if(GetUnitToUnitDistance(npcBot,WeakestEnemy)<CastRange and not npcBot:HasModifier("modifier_bounty_hunter_shadow_walk"))
					then
						return BOT_ACTION_DESIRE_HIGH, WeakestEnemy;
					elseif(creeps[1]~=nil and not npcBot:HasModifier("modifier_bounty_hunter_shadow_walk") and WeakestEnemy:HasModifier("modifier_bounty_hunter_track"))
					then
						return BOT_ACTION_DESIRE_HIGH, creeps[1];
					end
				end
			end
		end
	end

	-- If we're in a teamfight, use it on the scariest enemy
	local tableNearbyAttackingAlliedHeroes = npcBot:GetNearbyHeroes( 1000, false, BOT_MODE_ATTACK );
	if ( #tableNearbyAttackingAlliedHeroes >= 2 ) 
	then
		local trackedEnemy=0;
		for k,npcEnemy in pairs(enemys) do
			if npcEnemy:HasModifier("modifier_bounty_hunter_track") then
				trackedEnemy=trackedEnemy+1;
			end
		end

		if(trackedEnemy>=2)
		then
			if(creeps[1]~=nil)
			then
				return BOT_ACTION_DESIRE_HIGH, creeps[1];
			elseif(enemys[1]~=nil)
			then
				return BOT_ACTION_DESIRE_HIGH, enemys[1];
			end
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------	
	--protect myself
	local enemys2 = npcBot:GetNearbyHeroes( 400, true, BOT_MODE_NONE );
	--[[If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if ( (npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH) or #enemys2>0) 
	then
		for _,npcEnemy in pairs( enemys )
		do
			if ( (npcBot:WasRecentlyDamagedByHero( npcEnemy, 2.0 ) and CanCast[abilityNumber]( npcEnemy )) or GetUnitToUnitDistance(npcBot,npcEnemy)<400) 
			then
				if(GetUnitToUnitDistance(npcBot,npcEnemy)<CastRange)
				then
					return BOT_ACTION_DESIRE_HIGH, npcEnemy;
				elseif(creeps[1]~=nil and npcEnemy:HasModifier("modifier_bounty_hunter_track"))
				then
					return BOT_ACTION_DESIRE_HIGH, creeps[1];
				end
			end
		end
	end]]
	

	-- If we're pushing or defending a lane
	if ( npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT ) 
	then
		if ( #enemys>=1) 
		then
			if (ManaPercentage>0.5 or npcBot:GetMana()>ComboMana)
			then
				if (WeakestEnemy~=nil)
				then
					if ( CanCast[abilityNumber]( WeakestEnemy ) )
					then
						if(GetUnitToUnitDistance(npcBot,WeakestEnemy)<CastRange and not npcBot:HasModifier("modifier_bounty_hunter_shadow_walk"))
						then
							return BOT_ACTION_DESIRE_HIGH, WeakestEnemy;
						elseif(creeps[1]~=nil and WeakestEnemy:HasModifier("modifier_bounty_hunter_track") and not npcBot:HasModifier("modifier_bounty_hunter_shadow_walk"))
						then
							return BOT_ACTION_DESIRE_HIGH, creeps[1];
						end
					end
				end
			end
		end
	end
	
	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		 npcBot:GetActiveMode() == BOT_MODE_ATTACK ) 
	then
		local npcEnemy = npcBot:GetTarget();

		if ( npcEnemy ~= nil ) 
		then
			if ( CanCast[abilityNumber]( npcEnemy ))
			then
				if(GetUnitToUnitDistance(npcBot,npcEnemy)<CastRange and not npcBot:HasModifier("modifier_bounty_hunter_shadow_walk"))
				then
					return BOT_ACTION_DESIRE_HIGH, npcEnemy;
				elseif(creeps[1]~=nil and npcEnemy:HasModifier("modifier_bounty_hunter_track") and not npcBot:HasModifier("modifier_bounty_hunter_shadow_walk"))
				then
					return BOT_ACTION_DESIRE_HIGH, creeps[1];
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;
	
end

Consider[3]=function()
	local abilityNumber=3
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability=AbilitiesReal[abilityNumber];
	
	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = 0
	local Damage = ability:GetAbilityDamage()
	local Radius = ability:GetAOERadius()
	local CastPoint = ability:GetCastPoint()
	
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange+300,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------

	--------------------------------------
	-- Mode based usage
	--------------------------------------
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_MODERATE ) 
	then
		if ( npcBot:WasRecentlyDamagedByAnyHero( 2.0 ) ) 
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end
	
	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		 npcBot:GetActiveMode() == BOT_MODE_ATTACK ) 
	then
		local npcEnemy = AbilityExtensions:GetTargetIfGood(npcBot)
		if ( npcEnemy ~= nil ) 
		then
			if (GetUnitToUnitDistance(npcBot,npcEnemy)<=2000)
			then
				return BOT_ACTION_DESIRE_MODERATE
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
	
end

local EnlargeCastRange = AbilityExtensions:EveryManySeconds(0.5, function() CastRange = AbilitiesReal[4]:GetCastRange() end)

CanCast[4] = function(t)
	return AbilityExtensions:NormalCanCast(t, false, DAMAGE_TYPE_PHYSICAL, true, true) and t:IsHero() 
	-- and AbilityExtensions:MayNotBeIllusion(t)
end

Consider[4]=function()
	local abilityNumber=4
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability=AbilitiesReal[abilityNumber];
	
	local function HasTrackModifierPenalty(t)
		return AbilityExtensions:GetModifierRemainingDuration("modifier_bounty_hunter_track") <= 5 and 2 or 1
	end

	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE
	end
	
	local CastRange = Clamp(ability:GetCastRange(), 0, 1599)
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local realEnemies = AbilityExtensions:GetNearbyNonIllusionHeroes(npcBot, CastRange)
	realEnemies = AbilityExtensions:Filter(realEnemies, CanCast[4])
	realEnemies = AbilityExtensions:Map(realEnemies, function(t)
		return { t, t:GetHealth()*HasTrackModifierPenalty(t) }
	end)
	realEnemies = AbilityExtensions:SortByMinFirst(realEnemies, function(t) return t[2] end)
	if AbilityExtensions:Any(realEnemies) then
		local desire = RemapValClamped(realEnemies[2], 300+ability:GetLevel()*100, 1000, 0.8, 0.4)
		if desire >= 0.5 and ManaPercentage >= 0.4 or desire >= 0.7 then
			return desire, realEnemies[1]
		else
			return desire-0.2, realEnemies[1]
		end
	end
	
	return BOT_ACTION_DESIRE_NONE
end

AbilityExtensions:AutoModifyConsiderFunction(npcBot, Consider, AbilitiesReal)

function AbilityUsageThink()

	-- Check if we're already using an ability
	if ( npcBot:IsUsingAbility() or npcBot:IsChanneling() or npcBot:IsSilenced() )
	then 
		return
	end
	
	ComboMana=GetComboMana()
	AttackRange=npcBot:GetAttackRange()
	ManaPercentage=npcBot:GetMana()/npcBot:GetMaxMana()
	HealthPercentage=npcBot:GetHealth()/npcBot:GetMaxHealth()
	
	cast=ability_item_usage_generic.ConsiderAbility(AbilitiesReal,Consider)
	---------------------------------debug--------------------------------------------
	if(debugmode==true)
	then
		ability_item_usage_generic.PrintDebugInfo(AbilitiesReal,cast)
	end
	ability_item_usage_generic.UseAbility(AbilitiesReal,cast)
end

function CourierUsageThink() 
	ability_item_usage_generic.CourierUsageThink()
end