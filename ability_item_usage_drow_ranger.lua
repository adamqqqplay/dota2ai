----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.3 New Structure
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
--------------------------------------
-- General Initialization
--------------------------------------
local utility = require( GetScriptDirectory().."/utility" ) 
require(GetScriptDirectory() ..  "/ability_item_usage_generic")

local debugmode=false
local npcBot = GetBot()
local Talents ={}
local Abilities ={}
local AbilitiesReal ={}

ability_item_usage_generic.InitAbility(Abilities,AbilitiesReal,Talents) 

local AbilityToLevelUp=
{
	Abilities[3],
	Abilities[1],
	Abilities[3],
	Abilities[2],
	Abilities[3],
	Abilities[4],
	Abilities[3],
	Abilities[1],
	Abilities[1],
	"talent",
	Abilities[1],
	Abilities[4],
	Abilities[2],
	Abilities[2],
	"talent",
	Abilities[2],
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
		return Talents[2]
	end,
	function()
		return Talents[3]
	end,
	function()
		return Talents[5]
	end,
	function()
		return Talents[7]
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

Consider[1]=function()
	local abilityNumber=1
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability=AbilitiesReal[abilityNumber];
	
	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = ability:GetCastRange();
	local Damage = 0
	
	local HeroHealth=10000
	local CreepHealth=10000
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange+100,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange+100,true)
	local creeps2 = npcBot:GetNearbyCreeps(300,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
	
	if(ability:GetToggleState()==false)
	then
		local t=npcBot:GetAttackTarget()
		if(t~=nil)
		then
			if (t:IsHero())
			then
				ability:ToggleAutoCast()
				return BOT_ACTION_DESIRE_NONE, 0;
			end
		end
	end
	--[[else
		local t=npcBot:GetAttackTarget()
		if(t~=nil)
		then
			if (not t:IsHero())
			then
				ability:ToggleAutoCast()
				return BOT_ACTION_DESIRE_NONE, 0;
			end
		end
	end]]
	
	--try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT) 
	then
		if (WeakestEnemy~=nil)
		then
			if ( CanCast[abilityNumber]( WeakestEnemy ) )
			then
				if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_ALL))
				then
					return BOT_ACTION_DESIRE_HIGH,WeakestEnemy; 
				end
			end
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	if ( npcBot:GetActiveMode() == BOT_MODE_LANING ) 
	then
		if(CreepHealth>=300 and ManaPercentage>=0.5 and HealthPercentage>=0.6 and #creeps2<=1)
		then
			if (WeakestEnemy~=nil)
			then
				if ( CanCast[abilityNumber]( WeakestEnemy ) )
				then
					return BOT_ACTION_DESIRE_LOW-0.01,WeakestEnemy
				end
			end
		end
	end
	
	-- If we're farming
	if ( npcBot:GetActiveMode() == BOT_MODE_FARM )
	then
		if(WeakestCreep~=nil)
		then
			if(WeakestCreep:HasModifier("modifier_drow_ranger_frost_arrows_slow")==false)
			then
				return BOT_ACTION_DESIRE_LOW, WeakestCreep;
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
			if ( CanCast[abilityNumber]( npcEnemy )  and GetUnitToUnitDistance(npcBot,npcEnemy)< CastRange+100)
			then
				return BOT_ACTION_DESIRE_MODERATE, npcEnemy;
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;
	
end

Consider[2]=function()
	local abilityNumber=2
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability=AbilitiesReal[abilityNumber];
	
	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = ability:GetCastRange();
	local Damage = ability:GetAbilityDamage();
	local Radius = ability:GetAOERadius()
	local CastPoint=ability:GetCastPoint()
	
	local HeroHealth=10000
	local CreepHealth=10000
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange+300,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
	
	--try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		if (WeakestEnemy~=nil)
		then
			if ( CanCast[abilityNumber]( WeakestEnemy ) )
			then
				if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL) or (HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana))
				then
					return BOT_ACTION_DESIRE_HIGH,utility.GetUnitsTowardsLocation(npcBot,WeakestEnemy,GetUnitToUnitDistance(npcBot,WeakestEnemy)+100),"Location"
				end
			end
		end
	end
	
	-- Check for a channeling enemy
	for _,npcEnemy in pairs( enemys )
	do
		if ( npcEnemy:IsChanneling() and CanCast[abilityNumber]( npcEnemy ) and not npcEnemy:HasModifier("modifier_teleporting") and not npcEnemy:HasModifier("modifier_boots_of_travel_incoming")) 
		then
			return BOT_ACTION_DESIRE_HIGH, npcEnemy,"Location"
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if ( (npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH ) or (npcBot:WasRecentlyDamagedByAnyHero(2.0) and #enemys>=1) ) 
	then
		local locationAoE = npcBot:FindAoELocation( true, true, npcBot:GetLocation(), CastRange, Radius, CastPoint, 0 );
		if ( locationAoE.count >= 2 ) 
		then
			return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc,"Location"
		end
		
		for _,npcEnemy in pairs( enemys )
		do
			if ( npcBot:WasRecentlyDamagedByHero( npcEnemy, 3.0 ) and GetUnitToUnitDistance(npcBot,npcEnemy)<= 400) 
			then
				return BOT_ACTION_DESIRE_HIGH, npcEnemy:GetExtrapolatedLocation( CastPoint ),"Location"
			end
		end
	end
	
	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		 npcBot:GetActiveMode() == BOT_MODE_ATTACK ) 
	then
		local locationAoE = npcBot:FindAoELocation( true, true, npcBot:GetLocation(), CastRange, Radius, CastPoint, 0 );
		if ( locationAoE.count >= 2 ) 
		then
			return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc,"Location"
		end
		
		local npcEnemy = npcBot:GetTarget();

		if ( npcEnemy ~= nil ) 
		then
			if (CanCast[abilityNumber]( npcEnemy ) and not enemyDisabled(npcEnemy) and GetUnitToUnitDistance(npcBot,npcEnemy)<= CastRange)
			then
				return BOT_ACTION_DESIRE_MODERATE, utility.GetUnitsTowardsLocation(npcBot,npcEnemy,GetUnitToUnitDistance(npcBot,npcEnemy)+100),"Location"
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
	
	-- If we're pushing or defending a lane and can hit 3+ creeps, go for it
	if ( npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT ) 
	then
		return BOT_ACTION_DESIRE_LOW
	end

	return BOT_ACTION_DESIRE_NONE, 0;
	
end

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