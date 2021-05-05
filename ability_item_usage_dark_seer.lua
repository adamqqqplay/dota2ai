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
	Abilities[2],
	Abilities[3],
	Abilities[2],
	Abilities[3],
	Abilities[2],
	Abilities[3],
	Abilities[2],
	Abilities[1],
	Abilities[5],
	"talent",
	Abilities[3],
	Abilities[5],
	Abilities[1],
	Abilities[1],
	"talent",
	Abilities[1],
	"nil",
	Abilities[5],
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
		return Talents[6]
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
	local Damage = ability:GetAbilityDamage();
	local Radius = ability:GetAOERadius()
	local CastPoint = ability:GetCastPoint();
	
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange+300,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)

	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------
	-- Check for a channeling enemy
	for _,npcEnemy in pairs( enemys )
	do
		if ( npcEnemy:IsChanneling() ) 
		then
			return BOT_ACTION_DESIRE_HIGH, npcEnemy:GetLocation();
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	-- If we're farming and can kill 3+ creeps with LSA
	--[[if ( npcBot:GetActiveMode() == BOT_MODE_FARM ) then
		local locationAoE = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), CastRange, Radius, 0, Damage );

		if ( locationAoE.count >= 3 ) then
			return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc;
		end
	end]]

	-- If we're pushing or defending a lane and can hit 4+ creeps, go for it
	if ( npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT ) 
	then
		local locationAoE = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), CastRange, Radius, 0, 0 );

		if ( locationAoE.count >= 4 ) 
		then
			return BOT_ACTION_DESIRE_LOW-0.1, locationAoE.targetloc;
		end
	end

	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH ) 
	then
		for _,npcEnemy in pairs( enemys )
		do
			if ( npcBot:WasRecentlyDamagedByHero( npcEnemy, 2.0 ) ) 
			then
				if ( CanCast[abilityNumber]( npcEnemy ) ) 
				then
					return BOT_ACTION_DESIRE_LOW, npcEnemy:GetExtrapolatedLocation(CastPoint);
				end
			end
		end
	end

	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		 npcBot:GetActiveMode() == BOT_MODE_ATTACK) 
	then
		local locationAoE = npcBot:FindAoELocation( true, true, npcBot:GetLocation(), CastRange, Radius, 0, 0 );
		if ( locationAoE.count >= 3 ) then
			return BOT_ACTION_DESIRE_LOW+0.05, locationAoE.targetloc;
		end
	
		local npcEnemy = AbilityExtensions:GetTargetIfGood(npcBot)

		if ( npcEnemy ~= nil ) 
		then
			if ( CanCast[abilityNumber]( npcEnemy ) )
			then
				return BOT_ACTION_DESIRE_LOW, npcEnemy:GetExtrapolatedLocation(CastPoint);
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
	local CastPoint = ability:GetCastPoint();
	local Radius = ability:GetAOERadius();

	local allys = npcBot:GetNearbyHeroes( CastRange+300, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange+300,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
	local creeps2 = npcBot:GetNearbyCreeps(CastRange+300,false)
	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------
	-- If we're in a teamfight, use it on the scariest enemy
	local tableNearbyAttackingAlliedHeroes = npcBot:GetNearbyHeroes( 1000, false, BOT_MODE_ATTACK );
	if ( #tableNearbyAttackingAlliedHeroes >= 2 ) 
	then

		local npcMostDangerousEnemy = nil;
		local nMostDangerousDamage = 0;

		for _,npcEnemy in pairs( enemys )
		do
			if ( CanCast[abilityNumber]( npcEnemy ) and not enemyDisabled(npcEnemy))
			then
				local Damage2 = npcEnemy:GetEstimatedDamageToTarget( false, npcBot, 3.0, DAMAGE_TYPE_ALL );
				if ( Damage2 > nMostDangerousDamage )
				then
					nMostDangerousDamage = Damage2;
					npcMostDangerousEnemy = npcEnemy;
				end
			end
		end

		if ( npcMostDangerousEnemy ~= nil )
		then
			return BOT_ACTION_DESIRE_MODERATE-0.1, npcMostDangerousEnemy;
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	--protect myself
	local enemys2 = npcBot:GetNearbyHeroes( Radius, true, BOT_MODE_NONE );
	if(npcBot:WasRecentlyDamagedByAnyHero(5) and #enemys2~=nil and #enemys2>0)
	then
		if ( CanCast[abilityNumber]( npcBot ) and not npcBot:HasModifier("modifier_dark_seer_ion_shell") )
		then
			return BOT_ACTION_DESIRE_HIGH, npcBot
		end
	end
	
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH ) 
	then
		if ( CanCast[abilityNumber]( npcBot ) and not npcBot:HasModifier("modifier_dark_seer_ion_shell") )
		then
			return BOT_ACTION_DESIRE_LOW-0.05, npcBot
		end
	end
	
	-- If my mana is enough,use it at enemy
	if ( npcBot:GetActiveMode() == BOT_MODE_LANING ) 
	then
		if(ManaPercentage>0.55 and npcBot:GetMana()>ComboMana)
		then
			for k,creep in pairs(creeps2) do
				if(creep:GetAttackRange()<=300 and CanCast[abilityNumber]( creep ) 
					and not creep:HasModifier("modifier_dark_seer_ion_shell") and creep:GetHealth()/creep:GetMaxHealth()>0.8)
				then
					return BOT_ACTION_DESIRE_LOW,creep;
				end
			end
		end
	end
	
	-- If we're farming and can hit 2+ creeps and kill 1+ 
	if ( npcBot:GetActiveMode() == BOT_MODE_FARM )
	then
		if ( #creeps >= 4 ) 
		then
			if ( CanCast[abilityNumber]( npcBot ) and not npcBot:HasModifier("modifier_dark_seer_ion_shell") )
			then
				return BOT_ACTION_DESIRE_HIGH-0.05, npcBot
			end
		end
	end

	-- If we're pushing or defending a lane
	if ( npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT ) 
	then
		for k,creep in pairs(creeps2) do
			if(creep:GetAttackRange()<=300 and CanCast[abilityNumber]( creep ) 
				and not creep:HasModifier("modifier_dark_seer_ion_shell") and creep:GetHealth()/creep:GetMaxHealth()>0.8)
			then
				return BOT_ACTION_DESIRE_HIGH,creep;
			end
		end

		-- if ( GetUnitToUnitDistance(npcBot,npcEnemy)< CastRange + 75*#allys)
		-- then
		-- 	for _,myFriend in pairs(allys) do
		-- 		if ( not myFriend:HasModifier("modifier_dark_seer_ion_shell") and myFriend:GetAttackRange() < 300 )
		-- 		then
		-- 			return BOT_ACTION_DESIRE_MODERATE-0.05, myFriend;
		-- 		end
		-- 	end	
		-- 	if not npcBot:HasModifier("modifier_dark_seer_ion_shell") then
		-- 		return BOT_ACTION_DESIRE_MODERATE-0.05, npcBot;
		-- 	end
		-- end
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
			if ( GetUnitToUnitDistance(npcBot,npcEnemy)< CastRange + 75*#allys)
			then
				for _,myFriend in pairs(allys) do
					if ( not myFriend:HasModifier("modifier_dark_seer_ion_shell") and myFriend:GetAttackRange() < 300 )
					then
						return BOT_ACTION_DESIRE_MODERATE, myFriend;
					end
				end	
				if not npcBot:HasModifier("modifier_dark_seer_ion_shell") then
					return BOT_ACTION_DESIRE_MODERATE, npcBot;
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;
	
end

local function ShouldSurge(t)
	return (AbilityExtensions:IsRetreating(t) or AbilityExtensions:GetHealthPercent(t) <= 0.4 or t:IsHexed() or t:GetCurrentMovementSpeed() <= 150) and AbilityExtensions:CanMove(t) and t:WasRecentlyDamagedByAnyHero(3)
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

	local CastRange = ability:GetCastRange();
	local Damage = ability:GetAbilityDamage();
	local CastPoint = ability:GetCastPoint();
	
	local allys = AbilityExtensions:GetNearbyNonIllusionHeroes(npcBot, CastRange + 200)
	local enemys = AbilityExtensions:GetNearbyNonIllusionHeroes(npcBot, 1400)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange+300,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)

	local AOESurge=npcBot:GetAbilityByName( "special_bonus_unique_dark_seer_3" );
	local Radius=300;

	local locationAoE = npcBot:FindAoELocation( false, true, npcBot:GetLocation(), CastRange, Radius, 0, 0 );
	if ( locationAoE.count >= 2 and AOESurge:IsTrained()==true ) and #enemys ~= 0 then
		return RemapValClamped(locationAoE.count, 2, 4, BOT_ACTION_DESIRE_LOW, BOT_ACTION_DESIRE_HIGH), locationAoE.targetloc, "Location"
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH and ShouldSurge(npcBot) ) 
	then
		if ( npcBot:WasRecentlyDamagedByAnyHero( 2.0 ) ) 
		then
			if(AOESurge:IsTrained()==true) then
				return BOT_ACTION_DESIRE_HIGH, locationAoE.targetloc, "Location"
			else
				return BOT_ACTION_DESIRE_HIGH, npcBot, "Target"
			end
		end
	end

	-- Help our ally
	local allysRetreat = npcBot:GetNearbyHeroes( CastRange+300, false, BOT_MODE_RETREAT );
	for k,ally in pairs(allys) do
		if(CanCast[abilityNumber]( ally ) and ally:WasRecentlyDamagedByAnyHero(2.0)) and ShouldSurge(ally)
		then
			if(AOESurge:IsTrained()==true) then
				local locationAoE = npcBot:FindAoELocation( false, true, ally:GetLocation(), CastRange, Radius, 0, 0 );
				return BOT_ACTION_DESIRE_HIGH, locationAoE.targetloc, "Location"
			else
				return BOT_ACTION_DESIRE_HIGH, ally, "Target"
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
			if ( GetUnitToUnitDistance(npcBot,npcEnemy)< 1600)
			then
				local ClosestDist = GetUnitToUnitDistance(npcEnemy, npcBot);
				local ClosestBot = npcBot; 
				for _,myFriend in pairs(allys) do
					local dist = GetUnitToUnitDistance(npcEnemy, myFriend);
					if dist < ClosestDist and dist < CastRange then
						ClosestDist = dist;
						ClosestBot = myFriend;
					end
				end
				if(AOESurge:IsTrained()==true) then
					local locationAoE = npcBot:FindAoELocation( false, true, ClosestBot:GetLocation(), CastRange, Radius, 0, 0 );
					return BOT_ACTION_DESIRE_MODERATE, locationAoE.targetloc, "Location"
				else
					return BOT_ACTION_DESIRE_MODERATE, ClosestBot, "Target"
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;
	
end

Consider[4]=function()
	local abilityNumber=4
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
	local CastPoint = ability:GetCastPoint();
	
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange+300,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)

	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------
	-- Check for a channeling enemy
	for _,npcEnemy in pairs( enemys )
	do
		if ( npcEnemy:IsChanneling() ) 
		then
			return BOT_ACTION_DESIRE_HIGH, npcEnemy
		end
	end

	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH ) 
	then
		for _,npcEnemy in pairs( enemys )
		do
			if ( npcBot:WasRecentlyDamagedByHero( npcEnemy, 2.0 ) ) 
			then
				if ( CanCast[abilityNumber]( npcEnemy ) ) 
				then
					return BOT_ACTION_DESIRE_LOW, npcEnemy;
				end
			end
		end
	end

	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		 npcBot:GetActiveMode() == BOT_MODE_ATTACK) 
	then
		local npcEnemy = AbilityExtensions:GetTargetIfGood(npcBot)

		if ( npcEnemy ~= nil ) 
		then
			if ( CanCast[abilityNumber]( npcEnemy ) )
			then
				return BOT_ACTION_DESIRE_LOW, npcEnemy
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
	
end

Consider[5]=function()
	
	local abilityNumber=5
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability=AbilitiesReal[abilityNumber];
	
	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = ability:GetCastRange();
	local Radius = ability:GetAOERadius()
	local CastPoint = ability:GetCastPoint();

	--------------------------------------
	-- Mode based usage
	--------------------------------------
	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		 npcBot:GetActiveMode() == BOT_MODE_ATTACK) 
	then
		local locationAoE = npcBot:FindAoELocation( true, true, npcBot:GetLocation(), CastRange, Radius, 0, 0 );
		if ( locationAoE.count >= 2 ) then
			return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc;
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;
	
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