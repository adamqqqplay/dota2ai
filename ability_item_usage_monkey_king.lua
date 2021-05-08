----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.3 New Structure
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
--------------------------------------
-- General Initialization
--------------------------------------
if GetBot():IsInvulnerable() or not GetBot():IsHero() or not string.find(GetBot():GetUnitName(), "hero") or  GetBot():IsIllusion() then
	return;
end

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
	Abilities[4],
	Abilities[1],
	Abilities[4],
	Abilities[1],
	Abilities[4],
	Abilities[2],
	Abilities[4],
	Abilities[1],
	Abilities[1],
	"talent",
	Abilities[6],
	Abilities[6],
	Abilities[2],
	Abilities[2],
	"talent",
	Abilities[2],
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

local TalentTree={
	function()
		return Talents[2]
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

function GetFurthestTree(trees)
	if Ancient == nil then return nil end; 
	local furthest = nil;
	local fDist = 10000;
	for _,tree in pairs(trees)
	do
		local dist = GetUnitToLocationDistance(Ancient, GetTreeLocation(tree));
		if dist < fDist then
			furthest = tree;
			fDist = dist;
		end
	end
	return furthest;
end

function IsTargetDebuffStackEnough( npcTarget, sModifierName ,count )
	if(npcTarget~=nil and count~=nil)
	then
		local nModifier=npcTarget:GetModifierByName(sModifierName) 
		if(nModifier~=nil)
		then
			if(npcTarget:GetModifierStackCount(nModifier)>=count)
			then
				return true
			end
		end
	end
	return false;
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
	local CastPoint = ability:GetCastPoint()
	
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(1600,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(1600,true)
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

	--try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		if (WeakestEnemy~=nil)
		then
			if ( CanCast[abilityNumber]( WeakestEnemy ) and not enemyDisabled(WeakestEnemy) )
			then
				if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL) or (npcBot:HasModifier('modifier_monkey_king_quadruple_tap_bonuses') or IsTargetDebuffStackEnough(WeakestEnemy,"modifier_monkey_king_quadruple_tap_counter",4)))
				then
					return BOT_ACTION_DESIRE_HIGH,WeakestEnemy:GetExtrapolatedLocation(CastPoint); 
				end
			end
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------		
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH ) 
	then
		for _,npcEnemy in pairs( enemys )
		do
			if ( npcBot:WasRecentlyDamagedByHero( npcEnemy, 2.0 ) ) 
			then
				if ( CanCast[abilityNumber]( npcEnemy ) and not enemyDisabled(npcEnemy)) 
				then
					return BOT_ACTION_DESIRE_MODERATE, npcEnemy:GetExtrapolatedLocation(CastPoint);
				end
			end
		end
	end
	
	-- If we're farming and can kill 3+ creeps
	if ( npcBot:GetActiveMode() == BOT_MODE_FARM ) 
	then
		if((ManaPercentage>0.5 or npcBot:GetMana()>ComboMana))
		then
			local locationAoE = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), CastRange, Radius, CastPoint, 0 );
			if ( locationAoE.count >= 3 ) then
				return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc;
			end
		end
	end
	
	if ( npcBot:GetActiveMode() == BOT_MODE_LANING ) 
	then
		if(ManaPercentage>0.7 or npcBot:GetMana()>ComboMana)
		then	
			if(WeakestEnemy~=nil and CanCast[abilityNumber]( WeakestEnemy ) and not enemyDisabled(WeakestEnemy) and (npcBot:HasModifier('modifier_monkey_king_quadruple_tap_bonuses') or IsTargetDebuffStackEnough(WeakestEnemy,"modifier_monkey_king_quadruple_tap_counter",4)))
			then
				return BOT_ACTION_DESIRE_LOW,WeakestEnemy:GetExtrapolatedLocation(CastPoint)
			end	
		end
	end

	-- If we're pushing or defending a lane and can hit 4+ creeps
	if ( npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT ) 
	then
		if((ManaPercentage>0.7 or npcBot:GetMana()>ComboMana))
		then
			local locationAoE = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), CastRange, Radius, CastPoint, 0 );
			if ( locationAoE.count >= 5 and #enemys >=2 and npcBot:HasModifier('modifier_monkey_king_quadruple_tap_bonuses') )
			then
				return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc;
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
		if ( locationAoE.count >= 2 and npcBot:HasModifier('modifier_monkey_king_quadruple_tap_bonuses')) then
			return BOT_ACTION_DESIRE_MODERATE, locationAoE.targetloc;
		end
		
		local npcTarget = npcBot:GetTarget();
		if ( npcTarget ~= nil ) 
		then
			if(npcBot:HasModifier('modifier_monkey_king_quadruple_tap_bonuses') or IsTargetDebuffStackEnough(npcTarget,"modifier_monkey_king_quadruple_tap_counter",4))
			then
				if ( CanCast[abilityNumber]( npcTarget ) and not enemyDisabled(npcTarget) and GetUnitToUnitDistance(npcBot,npcEnemy)<=CastRange)
					then
					return BOT_ACTION_DESIRE_MODERATE, npcTarget:GetExtrapolatedLocation(CastPoint);
				end
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
	
	if not ability:IsFullyCastable() or not AbilitiesReal[3]:IsFullyCastable() or npcBot:IsRooted() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = ability:GetCastRange();
	
	local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( CastRange, true, BOT_MODE_NONE );
	if tableNearbyEnemyHeroes == nil then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH  and npcBot:DistanceFromFountain() > 1000 and #tableNearbyEnemyHeroes >= 1
	then
		local tableNearbyTrees = npcBot:GetNearbyTrees( CastRange );
		local furthest = GetFurthestTree(tableNearbyTrees);
		if furthest ~= nil then
			return BOT_ACTION_DESIRE_MODERATE, furthest;
		end
	end
	
	-- If we're in a teamfight, use it on the scariest enemy
	local tableNearbyAttackingAlliedHeroes = npcBot:GetNearbyHeroes( 1000, false, BOT_MODE_ATTACK );
	if ( #tableNearbyAttackingAlliedHeroes >= 2 ) 
	then
		local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( CastRange, true, BOT_MODE_NONE );
		for _,npcEnemy in pairs( tableNearbyEnemyHeroes )
		do
			if ( GetUnitToUnitDistance(npcBot,npcEnemy)<=CastRange ) 
			then
				local tableNearbyTrees = npcEnemy:GetNearbyTrees( CastRange );
				if tableNearbyTrees ~= nil and #tableNearbyTrees >= 1  then
					return BOT_ACTION_DESIRE_MODERATE, tableNearbyTrees[1];
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
		local npcTarget = npcBot:GetTarget();
		if ( npcTarget~=nil and  CanCast[abilityNumber]( npcTarget ) and GetUnitToUnitDistance(npcBot,npcTarget)<=CastRange ) 
		then
			local tableNearbyTrees = npcTarget:GetNearbyTrees( CastRange );
			if tableNearbyTrees ~= nil and #tableNearbyTrees >= 1  then
				return BOT_ACTION_DESIRE_MODERATE, tableNearbyTrees[1];
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
	
	if not ability:IsFullyCastable() or ability:IsHidden() or ability:IsActivated() == false then
		return BOT_ACTION_DESIRE_NONE, 0;
	end

	-- Get some of its values
	local CastRange = ability:GetSpecialValueInt("max_distance");
	local Radius = ability:GetSpecialValueInt("impact_radius");
	local nCastPoint = ability:GetChannelTime( );
	
	local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( 1000, true, BOT_MODE_NONE );
	if tableNearbyEnemyHeroes == nil then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH and #tableNearbyEnemyHeroes >= 1
	then
		local location = npcBot:GetXUnitsTowardsLocation( GetAncient(GetTeam()):GetLocation(), CastRange );
		return BOT_ACTION_DESIRE_MODERATE, location;
	end
	
	-- If we're in a teamfight, use it on the scariest enemy
	local tableNearbyAttackingAlliedHeroes = npcBot:GetNearbyHeroes( 1000, false, BOT_MODE_ATTACK );
	if ( #tableNearbyAttackingAlliedHeroes >= 2 ) 
	then		
		local locationAoE = npcBot:FindAoELocation( true, true, npcBot:GetLocation(), CastRange, Radius, 0, 0 );
		if ( locationAoE.count >= 2 ) 
		then
			return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc;
		end
	end
	
	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		 npcBot:GetActiveMode() == BOT_MODE_ATTACK ) 
	then
		local npcTarget = npcBot:GetTarget();
		if npcTarget~=nil and  CanCast[abilityNumber]( npcTarget ) and GetUnitToUnitDistance(npcBot,npcTarget)<=CastRange
		then
			if enemyDisabled(npcTarget) or npcTarget:GetMovementDirectionStability() < 1.0 then
				return BOT_ACTION_DESIRE_HIGH, npcTarget:GetLocation( );
			else
				return BOT_ACTION_DESIRE_MODERATE, npcTarget:GetExtrapolatedLocation( nCastPoint );
			end
		end
	end
--
	return BOT_ACTION_DESIRE_NONE, 0;
end

Consider[7]=function()
	local abilityNumber=7
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability=AbilitiesReal[abilityNumber];
	
	if not ability:IsFullyCastable() or ability:IsHidden() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end

	local trees = npcBot:GetNearbyTrees(50);
	if trees == nil or #trees == 0 then
		return BOT_ACTION_DESIRE_NONE;
	end

	local Radius = 375;
	
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH ) 
	then
		return BOT_ACTION_DESIRE_MODERATE
	end
	
	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		 npcBot:GetActiveMode() == BOT_MODE_ATTACK ) 
	then
		local npcTarget = npcBot:GetTarget();
		if npcTarget~=nil and  CanCast[abilityNumber]( npcTarget ) and 
		  ( GetUnitToLocationDistance(npcTarget, PSLoc) >= ( 375 - 125 ) or npcTarget:GetHealth() <= 175 )
		then
			return BOT_ACTION_DESIRE_MODERATE;
		end
	end
	
	return BOT_ACTION_DESIRE_NONE;
	
end

Consider[5]=function()
	
	local abilityNumber=5
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability=AbilitiesReal[abilityNumber];
	
	if not ability:IsFullyCastable() or ability:IsHidden() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH ) 
	then
		local tableNearbyEnemy = npcBot:GetNearbyHeroes( 1200, true, BOT_MODE_NONE );
		if #tableNearbyEnemy >= 1 then
			return BOT_ACTION_DESIRE_MODERATE
		end
	end
	
	if ( npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT )
	then
		local tableNearbyAlly = npcBot:GetNearbyHeroes( 1000, false, BOT_MODE_NONE );
		local tower = npcBot:GetNearbyTowers(1000, false);
		if tower ~= nil and tableNearbyAlly ~= nil and #tower >= 1 and #tableNearbyAlly >= 2 then
			return BOT_ACTION_DESIRE_MODERATE
		end
	end
	
	return BOT_ACTION_DESIRE_NONE;
end

Consider[8]=function()

	local abilityNumber=8
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability=AbilitiesReal[abilityNumber];
	
	if not ability:IsFullyCastable() or ability:IsHidden() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end

	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		 npcBot:GetActiveMode() == BOT_MODE_ATTACK ) 
	then
		local npcTarget = npcBot:GetTarget();
		if npcTarget~=nil and GetUnitToUnitDistance(npcBot,npcTarget)>=1200
		then
			return BOT_ACTION_DESIRE_MODERATE
		end
	end

	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH ) and not npcBot:WasRecentlyDamagedByAnyHero(4.0) 
	then
		return BOT_ACTION_DESIRE_MODERATE
	end
	
	return BOT_ACTION_DESIRE_NONE;
end

Consider[6]=function()
	local abilityNumber=6
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability=AbilitiesReal[abilityNumber];
	
	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = ability:GetCastRange();
	local Damage = 0
	local Radius = ability:GetAOERadius()-50;
	local CastPoint = ability:GetCastPoint()
	

	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)

	--------------------------------------
	-- Mode based usage
	--------------------------------------		
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH ) 
	then
		local locationAoE = npcBot:FindAoELocation( true, true, npcBot:GetLocation(), CastRange, Radius, CastPoint, 0 );
		if ( locationAoE.count >= 2 ) 
		then
			return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc
		end
	end
	
	-- If we're pushing or defending a lane and can hit 4+ creeps, go for it
	if ( npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT ) 
	then
		local locationAoE = npcBot:FindAoELocation( true, true, npcBot:GetLocation(), CastRange, Radius, CastPoint, 0 );
		if ( locationAoE.count >= 3 ) 
		then
			return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc
		end
	end
	
	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		 npcBot:GetActiveMode() == BOT_MODE_ATTACK  ) 
	then
		local locationAoE = npcBot:FindAoELocation( true, true, npcBot:GetLocation(), CastRange, Radius, CastPoint, 0 );
		if ( locationAoE.count >= 2 ) then
			return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc
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