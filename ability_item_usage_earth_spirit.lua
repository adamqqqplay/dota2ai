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
	Abilities[2],
	Abilities[1],
	Abilities[1],
	Abilities[3],
	Abilities[1],
	Abilities[6],
	Abilities[1],
	Abilities[3],
	Abilities[3],
	"talent",
	Abilities[3],
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
		return Talents[1]
	end,
	function()
		return Talents[4]
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
local CanCast={utility.NCanCast,utility.NCanCast,utility.NCanCast,utility.NCanCast,utility.NCanCast,utility.NCanCast}
local enemyDisabled=utility.enemyDisabled

function GetComboDamage()
	return ability_item_usage_generic.GetComboDamage(AbilitiesReal)
end

function GetComboMana()
	return ability_item_usage_generic.GetComboMana(AbilitiesReal)
end


local nStone = 0;

local remnantLoc = {};
local remnantCastTime = -100;
local remnantCastGap  = 0.1;
local stoneCast = -100;
local stoneCastGap = 1.0;

function IsStoneNearby(location, radius)
	local units = GetUnitList(UNIT_LIST_ALLIED_OTHER);
	for _,u in pairs(units) do
		if u ~= nil and u:GetUnitName() == "npc_dota_earth_spirit_stone" and GetUnitToLocationDistance(u, location) < radius then
			return true;
		end
	end
	return false;
end 

function IsStoneInPath(location, dist)
	if npcBot:IsFacingLocation(location, 5) then
		local units = GetUnitList(UNIT_LIST_ALLIED_OTHER);
		for _,u in pairs(units) do
			if u ~= nil and u:GetUnitName() == "npc_dota_earth_spirit_stone" 
			   and npcBot:IsFacingLocation(u:GetLocation(), 5) and GetUnitToUnitDistance(u, npcBot) < dist 
			then
				return true;
			end
		end
	end
	return false;
end

function CanChainMag(target, radius)
	local enemies = target:GetNearbyHeroes(radius, false, BOT_MODE_NONE);
	for _,enemy in pairs(enemies)
	do
		if not enemy:HasModifier('modifier_earth_spirit_magnetize') then
			return true
		end	
	end
	return false;
end

function GetCorrectLoc(target, delay)
	if target:GetMovementDirectionStability() < 0.9 then
		return target:GetLocation();
	else
		return target:GetExtrapolatedLocation(delay);	
	end
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
	local CastPoint = ability:GetCastPoint();

	local nRadius     = ability:GetSpecialValueInt('radius');
	local nSearchRad  = ability:GetSpecialValueInt('rock_search_aoe');
	local nUnitCR     = 150;
	local nStoneCR    = ability:GetSpecialValueInt('rock_distance');
	local nCastPoint  = ability:GetCastPoint( );
	local nManaCost   = ability:GetManaCost( );
	local nSpeed      = ability:GetSpecialValueInt('speed');
	local nDamage     = ability:GetSpecialValueInt('rock_damage');
	local stoneNearby = IsStoneNearby(npcBot:GetLocation(), nSearchRad);

	if nStoneCR > 1600 then nStoneCR = 1600 end

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
		if ( npcEnemy:IsChanneling() and CanCast[abilityNumber]( npcEnemy )) 
		then
			local target=npcEnemy;
			local loc = GetCorrectLoc(target, GetUnitToUnitDistance(npcBot, target)/nSpeed)
			if stoneNearby then
				return BOT_ACTION_DESIRE_HIGH, loc, false, true; 
			elseif nStone >= 1 then
				return BOT_ACTION_DESIRE_HIGH, loc, true, false; 
			elseif nStone < 1 then
				--do nothing
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
					local target=WeakestEnemy;
					local loc = GetCorrectLoc(target, GetUnitToUnitDistance(npcBot, target)/nSpeed)
					if stoneNearby then
						return BOT_ACTION_DESIRE_HIGH, loc, false, true; 
					elseif nStone >= 1 then
						return BOT_ACTION_DESIRE_HIGH, loc, true, false; 
					elseif nStone < 1 and GetUnitToUnitDistance(npcBot,target)<=nUnitCR+200 then
						return BOT_ACTION_DESIRE_HIGH, target, false, false; 
					end
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
					local target=npcEnemy;
					local loc = GetCorrectLoc(target, GetUnitToUnitDistance(npcBot, target)/nSpeed)
					if stoneNearby then
						return BOT_ACTION_DESIRE_HIGH, loc, false, true; 
					elseif nStone >= 1 then
						return BOT_ACTION_DESIRE_HIGH, loc, true, false; 
					elseif nStone < 1 and GetUnitToUnitDistance(npcBot,target)<=nUnitCR+200 then
						return BOT_ACTION_DESIRE_HIGH, target, false, false; 
					end
				end
			end
		end
	end
	
	-- -- If my mana is enough,use it at enemy
	-- if ( npcBot:GetActiveMode() == BOT_MODE_LANING ) 
	-- then
	-- 	if((ManaPercentage>0.4 or npcBot:GetMana()>ComboMana) and ability:GetLevel()>=2 )
	-- 	then
	-- 		if (WeakestEnemy~=nil)
	-- 		then
	-- 			if ( CanCast[abilityNumber]( WeakestEnemy ) )
	-- 			then
	-- 				return BOT_ACTION_DESIRE_LOW,WeakestEnemy;
	-- 			end
	-- 		end
	-- 	end
	-- end
	
	-- -- If we're farming and can hit 2+ creeps and kill 1+ 
	-- if ( npcBot:GetActiveMode() == BOT_MODE_FARM )
	-- then
	-- 	if ( #creeps >= 2 ) 
	-- 	then
	-- 		if(CreepHealth<=WeakestCreep:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana)
	-- 		then
	-- 			return BOT_ACTION_DESIRE_LOW, WeakestCreep;
	-- 		end
	-- 	end
	-- end

	-- -- If we're pushing or defending a lane
	-- if ( npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
	-- 	 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
	-- 	 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or
	-- 	 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
	-- 	 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
	-- 	 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT ) 
	-- then
	-- 	if ( #enemys>=1) 
	-- 	then
	-- 		if (ManaPercentage>0.5 or npcBot:GetMana()>ComboMana and AbilitiesReal[abilityNumber]:GetLevel()>=1)
	-- 		then
	-- 			if (WeakestEnemy~=nil)
	-- 			then
	-- 				if ( CanCast[abilityNumber]( WeakestEnemy )and GetUnitToUnitDistance(npcBot,WeakestEnemy)< CastRange + 75*#allys )
	-- 				then
	-- 					return BOT_ACTION_DESIRE_LOW, WeakestEnemy;
	-- 				end
	-- 			end
	-- 		end
	-- 	end
		
	-- 	if (#creeps >= 3 ) 
	-- 	then
	-- 		if (ManaPercentage>0.5 or npcBot:GetMana()>ComboMana and AbilitiesReal[abilityNumber]:GetLevel()>=1)
	-- 		then
	-- 				if ( CanCast[abilityNumber]( creeps[1] )and GetUnitToUnitDistance(npcBot,creeps[1])< CastRange + 75*#allys )
	-- 				then
	-- 					return BOT_ACTION_DESIRE_LOW, creeps[1];
	-- 				end
	-- 		end
	-- 	end
	-- end
	
	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		 npcBot:GetActiveMode() == BOT_MODE_ATTACK ) 
	then
		local locationAoE = npcBot:FindAoELocation( true, true, npcBot:GetLocation(), nStoneCR, nRadius, nCastPoint, 0 );
		if ( locationAoE.count >= 2 ) 
		then
			if stoneNearby then
				return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc, false, true;
			elseif nStone >= 1 then
				return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc, true, false;
			end
		end

		local npcEnemy = npcBot:GetTarget();

		if ( npcEnemy ~= nil ) 
		then
			if ( CanCast[abilityNumber]( npcEnemy ) and not enemyDisabled(npcEnemy) and GetUnitToUnitDistance(npcBot,npcEnemy)< CastRange + 75*#allys)
			then
				local target=npcEnemy;
				local loc = GetCorrectLoc(target, GetUnitToUnitDistance(npcBot, target)/nSpeed)
				if stoneNearby then
					return BOT_ACTION_DESIRE_HIGH, loc, false, true;
				elseif nStone >= 1 then
					return BOT_ACTION_DESIRE_HIGH, loc, true, false;
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0, false, false;
	
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
	
	local nRadius     = ability:GetSpecialValueInt('radius');
	local nUnitCR     = ability:GetSpecialValueInt('distance');
	local nStoneCR    = ability:GetSpecialValueInt('rock_distance');
	local nCastPoint  = ability:GetCastPoint( );
	local nDelay      = ability:GetSpecialValueFloat('delay');
	local nManaCost   = ability:GetManaCost( );
	local nSpeed      = ability:GetSpecialValueInt('speed');
	local nRSpeed     = ability:GetSpecialValueInt('rock_speed');
	local nDamage     = ability:GetSpecialValueInt('damage');

	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(1600,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(1600,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------
	--Check if stuck on cliff.
	if(npcBot.Blink==nil or DotaTime()-npcBot.Blink.Timer>=20)
	then
		npcBot.Blink={Point=npcBot:GetLocation(),Timer=DotaTime()}
	end

	local trees= npcBot:GetNearbyTrees(300)
	if(trees~=nil and #trees>=10 or (utility.PointToPointDistance(npcBot:GetLocation(),npcBot.Blink.Point)<=150 and DotaTime()-npcBot.Blink.Timer<20 and DotaTime()-npcBot.Blink.Timer>18))
	then
		return BOT_ACTION_DESIRE_HIGH, utility.GetUnitsTowardsLocation(npcBot,GetAncient(GetTeam()),CastRange)
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
					local target=WeakestEnemy;
					local loc = GetCorrectLoc(target, (GetUnitToUnitDistance(npcBot, target)/nRSpeed)+nDelay)
					if IsStoneInPath(loc, (nUnitCR/2)+200) then
						return BOT_ACTION_DESIRE_HIGH, loc, false; 
					elseif nStone >= 1 then
						return BOT_ACTION_DESIRE_HIGH, loc, true; 
					elseif nStone < 1 and GetUnitToUnitDistance(npcBot,target)<=nUnitCR+200 then
						return BOT_ACTION_DESIRE_HIGH, target:GetLocation(), false; 
					end
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
		local location = utility.Fountain(GetTeam());
		local loc = npcBot:GetXUnitsTowardsLocation( location, nUnitCR );
		if IsStoneInPath(loc, (nUnitCR/2)+200) then
			return BOT_ACTION_DESIRE_MODERATE, loc, false;
		elseif nStone >= 1 then
			return BOT_ACTION_DESIRE_MODERATE, loc, true;
		elseif nStone < 1 then
			return BOT_ACTION_DESIRE_MODERATE, loc, false;
		end
	end
	
	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		 npcBot:GetActiveMode() == BOT_MODE_ATTACK ) 
	then
		local npcTarget = npcBot:GetTarget();

		if ( npcTarget ~= nil ) 
		then
			if(CanCast[abilityNumber]( npcTarget ))
			then
				if nStone >= 1 and (GetUnitToUnitDistance(npcTarget, npcBot) <= nStoneCR + 200)
				then
					local targetAlly  = npcTarget:GetNearbyHeroes(1000, false, BOT_MODE_NONE);
					local targetEnemy = npcTarget:GetNearbyHeroes(1000, true, BOT_MODE_NONE);
					if targetEnemy ~= nil and targetAlly ~= nil and #targetEnemy >= #targetAlly then
						local loc = GetCorrectLoc(npcTarget, GetUnitToUnitDistance(npcBot, target)/nRSpeed)
						if IsStoneInPath(loc, (nUnitCR/2)+200) then
							return BOT_ACTION_DESIRE_HIGH, loc, false;
						else
							return BOT_ACTION_DESIRE_HIGH, loc, true;
						end
					end	
				elseif nStone < 1  and (GetUnitToUnitDistance(npcTarget, npcBot) <= nUnitCR / 2)  then
					local loc = GetCorrectLoc(npcTarget, GetUnitToUnitDistance(npcBot, target)/nSpeed)
					return BOT_ACTION_DESIRE_HIGH, loc, false;
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0, false;
	
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
	
	local nRadius     = ability:GetSpecialValueInt('radius');
	local nSearchRad  = 175;
	local nCastRange  = ability:GetCastRange();
	local nCastPoint  = ability:GetCastPoint( );
	local nManaCost   = ability:GetManaCost( );
	local nDamage     = ability:GetSpecialValueInt('rock_damage');

	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange+300,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------
	if gripAllies ~= nil and gripAllies:IsTrained() then
		for _,ally in pairs(allys) 
		do
			if ally:GetActiveMode() == BOT_MODE_RETREAT and ally:WasRecentlyDamagedByAnyHero(2.0) then
				return BOT_ACTION_DESIRE_HIGH, ally:GetLocation(), false, true; 
			end
		end
	end	

	-- Check for a channeling enemy
	for _,npcEnemy in pairs( enemys )
	do
		if ( npcEnemy:IsChanneling() and CanCast[abilityNumber]( npcEnemy )) 
		then
			local target=npcEnemy
			local loc = GetCorrectLoc(target, 2*nCastPoint)
			local stoneNearby = IsStoneNearby(loc, nSearchRad);
			if stoneNearby then
				return BOT_ACTION_DESIRE_HIGH, loc, false, true; 
			elseif nStone >= 1 then
				return BOT_ACTION_DESIRE_HIGH, loc, true, false; 
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
					if stoneNearby then
						return BOT_ACTION_DESIRE_HIGH, npcEnemy:GetLocation(), false, true; 
					elseif nStone >= 1 then
						return BOT_ACTION_DESIRE_HIGH, npcEnemy:GetLocation(), true, false;
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
		local locationAoE = npcBot:FindAoELocation( true, true, npcBot:GetLocation(), nCastRange, nRadius, nCastPoint, 0 );
		if ( locationAoE.count >= 2 ) 
		then
			local stoneNearby = IsStoneNearby(locationAoE.targetloc, nSearchRad);
			if stoneNearby and ( nStone >= 1 or  nStone < 1 ) then
				return BOT_ACTION_DESIRE_HIGH, locationAoE.targetloc, false, true; 
			elseif nStone >= 1 then
				return BOT_ACTION_DESIRE_HIGH, locationAoE.targetloc, true, false; 
			end
		end

		local npcTarget = npcBot:GetTarget();

		if ( npcTarget ~= nil ) 
		then
			if ( CanCast[abilityNumber]( npcTarget ) and not enemyDisabled(npcTarget) and GetUnitToUnitDistance(npcBot,npcTarget)< CastRange + 75*#allys)
			then
				local targetAlly  = npcTarget:GetNearbyHeroes(1000, false, BOT_MODE_NONE);
				local targetEnemy = npcTarget:GetNearbyHeroes(1000, true, BOT_MODE_NONE);
				if targetEnemy ~= nil and targetAlly ~= nil and #targetEnemy >= #targetAlly then
					local loc = GetCorrectLoc(npcTarget, 2*nCastPoint)
					local stoneNearby = IsStoneNearby(loc, nSearchRad);
					if stoneNearby and ( nStone >= 1 or  nStone < 1 ) then
						return BOT_ACTION_DESIRE_HIGH, loc, false, true; 
					elseif nStone >= 1 then
						return BOT_ACTION_DESIRE_HIGH, loc, true, false; 
					end
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

	if DotaTime() < stoneCast + stoneCastGap then
		return BOT_ACTION_DESIRE_NONE, 0;
	end

	local nCastRange  = ability:GetCastRange( );
	local nRadius     = AbilitiesReal[6]:GetSpecialValueInt('rock_search_radius');

	local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( nCastRange - 200, true, BOT_MODE_NONE );
	for _,npcEnemy in pairs( tableNearbyEnemyHeroes )
	do
		if npcEnemy:HasModifier('modifier_earth_spirit_magnetize') 
		then
			local duration = npcEnemy:GetModifierRemainingDuration(npcEnemy:GetModifierByName('modifier_earth_spirit_magnetize'));
			if duration < 1.0 or CanChainMag(npcEnemy, nRadius) then
				return BOT_ACTION_DESIRE_MODERATE, npcEnemy:GetLocation();
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0, false, false;
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

	return BOT_ACTION_DESIRE_NONE, 0;
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
	local Damage = ability:GetAbilityDamage();
	local CastPoint = ability:GetCastPoint();

	local nRadius    = ability:GetSpecialValueInt( "cast_radius" );
	local nCastPoint = ability:GetCastPoint( );
	local nManaCost  = ability:GetManaCost( );

	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
		
	local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( nRadius, true, BOT_MODE_NONE );

	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH )
	then
		for _,npcEnemy in pairs( tableNearbyEnemyHeroes )
		do
			if ( npcBot:WasRecentlyDamagedByHero( npcEnemy, 1.0 ) and CanCast[abilityNumber](npcEnemy)  ) 
			then
				return BOT_ACTION_DESIRE_MODERATE;
			end
		end
	end
	
	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
		npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		npcBot:GetActiveMode() == BOT_MODE_ATTACK ) 
	then
		if ( tableNearbyEnemyHeroes ~= nil and #tableNearbyEnemyHeroes >= 2 ) 
		then
			return BOT_ACTION_DESIRE_HIGH;
		end

		local npcTarget = npcBot:GetTarget();
		if ( npcTarget ~= nil ) 
		then
			if ( CanCast[abilityNumber]( npcTarget ) and not enemyDisabled(npcTarget) and GetUnitToUnitDistance(npcBot,npcTarget)< CastRange + 75*#allys) and GetUnitToUnitDistance(npcBot,npcTarget)< nRadius-100
			then
				return BOT_ACTION_DESIRE_MODERATE;
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE;
end

function AbilityUsageThink()

	-- Check if we're already using an ability
	if ( npcBot:IsUsingAbility() or npcBot:IsChanneling() or npcBot:IsSilenced() or npcBot:NumQueuedActions() > 0)
	then 
		return
	end
	
	nStone = npcBot:GetModifierStackCount(npcBot:GetModifierByName('modifier_earth_spirit_stone_caller_charge_counter'));
	gripAllies = npcBot:GetAbilityByName( "special_bonus_unique_earth_spirit_2" )

	ComboMana=GetComboMana()
	AttackRange=npcBot:GetAttackRange()
	ManaPercentage=npcBot:GetMana()/npcBot:GetMaxMana()
	HealthPercentage=npcBot:GetHealth()/npcBot:GetMaxHealth()
	
	cast.Desire[1], castQLoc, castQStone, QStoneNear = Consider[1]();
	cast.Desire[2], castWLoc, castWStone, WStoneNear = Consider[2]();
    cast.Desire[3], castELoc, castEStone, EStoneNear = Consider[3]();
	cast.Desire[4], castDLoc             = Consider[4]();
	cast.Desire[5], castFTarget          = Consider[5]();
	cast.Desire[6]                       = Consider[6]();

	if(debugmode==true)
	then
		ability_item_usage_generic.PrintDebugInfo(AbilitiesReal,cast)
	end
	
	if ( cast.Desire[6] > 0 ) 
	then
		npcBot:Action_UseAbility( AbilitiesReal[6] );
		return;
	end
	
	if ( cast.Desire[5] > 0 ) 
	then
		--npcBot:Action_UseAbilityOnEntity( abilityF, castFTarget );
		npcBot:ActionQueue_UseAbilityOnEntity(AbilitiesReal[5], castFTarget);
		npcBot:ActionQueue_UseAbilityOnLocation(AbilitiesReal[1], npcBot:GetLocation()+RandomVector(800));
		return;
	end

	if ( cast.Desire[1] > 0 ) 
	then
		if castQStone then
			npcBot:Action_ClearActions(false);
			npcBot:ActionQueue_UseAbilityOnLocation(AbilitiesReal[4], npcBot:GetLocation());
			npcBot:ActionQueue_UseAbilityOnLocation(AbilitiesReal[1], castQLoc);
			return;
		else
			if QStoneNear then
				npcBot:Action_UseAbilityOnLocation( AbilitiesReal[1], castQLoc );
				return;
			else
				npcBot:Action_UseAbilityOnEntity( AbilitiesReal[1], castQLoc );
				return;
			end
		end
	end
	
	if ( cast.Desire[2] > 0 ) 
	then
		if castWStone then
			npcBot:Action_ClearActions(false);
			npcBot:ActionQueue_UseAbilityOnLocation(AbilitiesReal[2], castWLoc);
			npcBot:ActionQueue_UseAbilityOnLocation(AbilitiesReal[4], npcBot:GetXUnitsTowardsLocation(castWLoc, 300));
			return;
		else
			npcBot:Action_UseAbilityOnLocation( AbilitiesReal[2], castWLoc );
			return;
		end
	end
	
	if ( cast.Desire[3] > 0 ) 
	then
		if castEStone then
			npcBot:Action_ClearActions(false);
			npcBot:ActionQueue_UseAbilityOnLocation(AbilitiesReal[4], castELoc);
			npcBot:ActionQueue_UseAbilityOnLocation(AbilitiesReal[3], castELoc);
			return;
		else
			npcBot:Action_UseAbilityOnLocation( AbilitiesReal[3], castELoc );
			return;
		end
	end
	
	if ( cast.Desire[4] > 0 ) 
	then
		npcBot:Action_UseAbilityOnLocation( AbilitiesReal[4], castDLoc );
		npcBot:ActionImmediate_Chat( "RESET BOYS", true );
		stoneCast = DotaTime();
		return;
	end
	
end

function CourierUsageThink() 
	ability_item_usage_generic.CourierUsageThink()
end