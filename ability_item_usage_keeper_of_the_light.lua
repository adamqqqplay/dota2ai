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

-- utility.PrintAbilityName(Abilities)
local abilityName = {
	"keeper_of_the_light_illuminate",
	"keeper_of_the_light_radiant_blind",
	"keeper_of_the_light_chakra_magic",
	"keeper_of_the_light_blind_light",
	"keeper_of_the_light_will_o_wisp",
	"keeper_of_the_light_spirit_form",
	"keeper_of_the_light_illuminate_end",
	"keeper_of_the_light_spirit_form_illuminate",
	"keeper_of_the_light_spirit_form_illiminate_end",
	"keeper_of_the_light_recall",
}
local abilityIndex = utility.ReverseTable(abilityName)


local AbilityToLevelUp =
{
	Abilities[1],
	Abilities[3],
	Abilities[2],
	Abilities[1],
	Abilities[3],
	Abilities[5],
	Abilities[3],
	Abilities[1],
	Abilities[1],
	"talent",
	Abilities[3],
	Abilities[5],
	Abilities[2],
	Abilities[2],
	"talent",
	Abilities[2],
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

function AbilityLevelUpThink()
	ability_item_usage_generic.AbilityLevelUpThink2(AbilityToLevelUp,TalentTree)
end

--------------------------------------
-- Ability Usage Thinking
--------------------------------------
local cast={} cast.Desire={} cast.Target={} cast.Type={}
local Consider = {}
local CanCast= {
        utility.NCanCast,
        utility.NCanCast,
        utility.UCanCast,
        utility.NCanCast,
        utility.NCanCast,
        utility.UCanCast,
        utility.NCanCast,
        utility.NCanCast,
        utility.UCanCast,
        utility.UCanCast,
}
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
	
	if ( not ability:IsFullyCastable() ) then 
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = ability:GetCastRange();
	local ChannelTime = ability:GetChannelTime();
	local Damage = ability:GetSpecialValueFloat("damage_per_second")*ChannelTime;
	local Radius = ability:GetAOERadius()
	local CastPoint = ability:GetCastPoint();
	
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(1600,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(1600,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)

	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------
	--try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		if (WeakestEnemy~=nil)
		then
			if ( CanCast[abilityNumber]( WeakestEnemy ) )
			then
				if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL) or (HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana))
				then
					return BOT_ACTION_DESIRE_HIGH,npcBot:GetXUnitsTowardsLocation(WeakestEnemy:GetExtrapolatedLocation(CastPoint),300); 
				end
			end
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	-- If we're farming and can kill 3+ creeps with LSA
	if ( npcBot:GetActiveMode() == BOT_MODE_FARM ) then
		local locationAoE = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), CastRange, Radius, ChannelTime/2, 0 );

		if ( locationAoE.count >= 3 ) then
			return BOT_ACTION_DESIRE_LOW, npcBot:GetXUnitsTowardsLocation(locationAoE.targetloc,300);
		end
	end

	--[[Last hit
	if ( npcBot:GetActiveMode() == BOT_MODE_LANING ) 
	then
		if(WeakestCreep~=nil)
		then
			if((ManaPercentage>0.5 or npcBot:GetMana()>ComboMana) and GetUnitToUnitDistance(npcBot,WeakestCreep)>=300)
			then
				local locationAoE = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), CastRange, Radius, ChannelTime/2, Damage );
				if ( locationAoE.count >= 1 ) then
					return BOT_ACTION_DESIRE_LOW-0.02, npcBot:GetXUnitsTowardsLocation(locationAoE.targetloc,300);
				end
			end		
		end
	end]]
	
	if ( npcBot:GetActiveMode() == BOT_MODE_LANING ) 
	then
		if((ManaPercentage>0.5 or npcBot:GetMana()>ComboMana) and ability:GetLevel()>=2 )
		then
			local locationAoE = npcBot:FindAoELocation( true, true, npcBot:GetLocation(), CastRange, Radius, ChannelTime/2, 0 );
			if ( locationAoE.count >= 4 ) then
				return BOT_ACTION_DESIRE_LOW-0.01, npcBot:GetXUnitsTowardsLocation(locationAoE.targetloc,300);
			end
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
		local locationAoE = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), CastRange, Radius, ChannelTime/2, 0 );

		if ( locationAoE.count >= 4 ) 
		then
			return BOT_ACTION_DESIRE_MODERATE+0.05, npcBot:GetXUnitsTowardsLocation(locationAoE.targetloc,300);
		end
	end

	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		 npcBot:GetActiveMode() == BOT_MODE_ATTACK) 
	then
		local locationAoE = npcBot:FindAoELocation( true, true, npcBot:GetLocation(), CastRange, Radius, ChannelTime/2, 0 );
		if ( locationAoE.count >= 2 ) then
			return BOT_ACTION_DESIRE_LOW, npcBot:GetXUnitsTowardsLocation(locationAoE.targetloc,300);
		end
	
		local npcEnemy = npcBot:GetTarget();

		if ( npcEnemy ~= nil ) 
		then
			if ( CanCast[abilityNumber]( npcEnemy ) )
			then
				return BOT_ACTION_DESIRE_HIGH, npcBot:GetXUnitsTowardsLocation(npcEnemy:GetExtrapolatedLocation(CastPoint),300);
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;
	
end

-- Consider[2]=function()
	
-- 	local abilityNumber=2
-- 	--------------------------------------
-- 	-- Generic Variable Setting
-- 	--------------------------------------
-- 	local ability=AbilitiesReal[abilityNumber];
	
-- 	if ( not ability:IsFullyCastable() ) 
-- 	then 
-- 		return BOT_ACTION_DESIRE_NONE, 0;
-- 	end
	
-- 	local CastRange = ability:GetCastRange();
-- 	local Damage = ability:GetAbilityDamage();
-- 	local Radius = ability:GetAOERadius()
-- 	local CastPoint = ability:GetCastPoint();
	
-- 	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
-- 	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
-- 	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
-- 	local creeps = npcBot:GetNearbyCreeps(CastRange+300,true)
-- 	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
-- 	--------------------------------------
-- 	-- Mode based usage
-- 	--------------------------------------
-- 	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
-- 	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH ) 
-- 	then
-- 		if ( npcBot:WasRecentlyDamagedByAnyHero( 2.0 ) ) 
-- 		then
-- 			local locationAoE = npcBot:FindAoELocation( true, true, npcBot:GetLocation(), CastRange, Radius, 0, 0 );
-- 			if ( locationAoE.count >= 2 ) then
-- 				return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc;
-- 			end

-- 			return BOT_ACTION_DESIRE_HIGH, npcBot
-- 		end
-- 	end

-- 	-- If we're going after someone
-- 	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
-- 		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
-- 		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
-- 		 npcBot:GetActiveMode() == BOT_MODE_ATTACK) 
-- 	then
-- 		local locationAoE = npcBot:FindAoELocation( true, true, npcBot:GetLocation(), CastRange, Radius, 0, 0 );
-- 		if ( locationAoE.count >= 2 ) then
-- 			return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc;
-- 		end
	
-- 		local npcEnemy = npcBot:GetTarget();

-- 		if ( npcEnemy ~= nil )
-- 		then
-- 			if ( CanCast[abilityNumber]( npcEnemy ) )
-- 			then
-- 				return BOT_ACTION_DESIRE_LOW, npcEnemy:GetExtrapolatedLocation(CastPoint);
-- 			end
-- 		end
-- 	end

-- 	return BOT_ACTION_DESIRE_NONE, 0;
	
-- end

-- copied from sven_storm_hammer

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
		if ( npcEnemy:IsChanneling() and CanCast[abilityNumber]( npcEnemy )) 
		then
			return BOT_ACTION_DESIRE_HIGH, npcEnemy
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
					return BOT_ACTION_DESIRE_HIGH,WeakestEnemy; 
				end
			end
		end
	end
	
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
			return BOT_ACTION_DESIRE_HIGH, npcMostDangerousEnemy;
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
					return BOT_ACTION_DESIRE_HIGH, npcEnemy;
				end
			end
		end
	end
	
	-- If my mana is enough,use it at enemy
	if ( npcBot:GetActiveMode() == BOT_MODE_LANING ) 
	then
		if((ManaPercentage>0.7 or npcBot:GetMana()>ComboMana) and ability:GetLevel()>=2 )
		then
			if (WeakestEnemy~=nil)
			then
				if ( CanCast[abilityNumber]( WeakestEnemy ) )
				then
					return BOT_ACTION_DESIRE_LOW,WeakestEnemy;
				end
			end
		end
	end
	-- If we're farming and can hit 2+ creeps and kill 1+ 
	if ( npcBot:GetActiveMode() == BOT_MODE_FARM )
	then
		if ( #creeps >= 2 ) 
		then
			if(CreepHealth<=WeakestCreep:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana)
			then
				return BOT_ACTION_DESIRE_LOW, WeakestCreep;
			end
		end
	end

	-- If we're pushing or defending a lane
	if ( npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT ) 
	then
		if ( #enemys>=1) 
		then
			if (ManaPercentage>0.7 or npcBot:GetMana()>ComboMana )
			then
				if (WeakestEnemy~=nil)
				then
					if ( CanCast[abilityNumber]( WeakestEnemy )and GetUnitToUnitDistance(npcBot,WeakestEnemy)< CastRange + 75*#allys )
					then
						return BOT_ACTION_DESIRE_LOW, WeakestEnemy;
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
			if ( CanCast[abilityNumber]( npcEnemy ) and not enemyDisabled(npcEnemy) and GetUnitToUnitDistance(npcBot,npcEnemy)< CastRange + 75*#allys)
			then
				return BOT_ACTION_DESIRE_MODERATE, npcEnemy
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
	
	local CastRange = ability:GetCastRange();
	local Damage = ability:GetAbilityDamage();
	local CastPoint = ability:GetCastPoint();
	
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local bestTarget = npcBot;
	local minMana = ManaPercentage;
	
	for _,myFriend in pairs(allys) do
		tempMana=myFriend:GetMana() / myFriend:GetMaxMana()
		if ( CanCast[abilityNumber](myFriend) and tempMana < ManaPercentage  ) 
		then
			bestTarget=myFriend
			minMana=tempMana;
		end
	end	

	if(bestTarget~=nil and minMana<=0.8)
	then
		return BOT_ACTION_DESIRE_MODERATE, bestTarget; 
	end

	return BOT_ACTION_DESIRE_NONE, 0;
end

Consider[abilityIndex.keeper_of_the_light_blind_light] = function()
	--Location AOE Example

	local abilityNumber = abilityIndex.keeper_of_the_light_blind_light
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability = AbilitiesReal[abilityNumber]

	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local CastRange = ability:GetCastRange()
	local Damage = ability:GetAbilityDamage()
	local Radius = ability:GetAOERadius()
	local CastPoint = ability:GetCastPoint()

	local allys = npcBot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
	local enemys = npcBot:GetNearbyHeroes(Min(CastRange + 300, 1600), true, BOT_MODE_NONE)
	local WeakestEnemy, HeroHealth = utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(Min(CastRange + 300, 1600), true)
	local WeakestCreep, CreepHealth = utility.GetWeakestUnit(creeps)

	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------
	-- If we're in a teamfight, use it on the scariest enemy
	local tableNearbyAttackingAlliedHeroes = npcBot:GetNearbyHeroes( 1000, false, BOT_MODE_ATTACK );
	if ( #tableNearbyAttackingAlliedHeroes >= 2 )
	then
		for _,npcEnemy in pairs( enemys )
		do
			if ( npcEnemy:IsChanneling() )
			then
				return BOT_ACTION_DESIRE_MODERATE-0.15, npcEnemy:GetLocation()
			end
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH ) 
	then
		local locationAoE = npcBot:FindAoELocation( true, true, npcBot:GetLocation(), CastRange, Radius, CastPoint, 0 );
		if ( locationAoE.count >= 2 ) 
		then
			return BOT_ACTION_DESIRE_LOW-0.15, locationAoE.targetloc
		end
	end

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
			return BOT_ACTION_DESIRE_HIGH, npcMostDangerousEnemy:GetLocation();
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

	-- If we're in a teamfight, use it 
	local tableNearbyAttackingAlliedHeroes = npcBot:GetNearbyHeroes( 1000, false, BOT_MODE_ATTACK );
	if ( #tableNearbyAttackingAlliedHeroes >= 2 ) 
	then
		local npcEnemy = npcBot:GetTarget();

		if ( npcEnemy ~= nil and enemys~=nil and #enemys >= 2) 
		then
			return BOT_ACTION_DESIRE_HIGH, npcEnemy:GetLocation()
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;

end

Consider[5] = function()
	local abilityNumber = 5
	local ability = AbilitiesReal[abilityNumber]

	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local CastRange = ability:GetCastRange()
	local Damage = ability:GetAbilityDamage()
	local Radius = ability:GetAOERadius()
	local CastPoint = ability:GetCastPoint()

	local allys = npcBot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
	local enemys = npcBot:GetNearbyHeroes(Min(CastRange + 300, 1600), true, BOT_MODE_NONE)
	local WeakestEnemy, HeroHealth = utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(Min(CastRange + 300, 1600), true)
	local WeakestCreep, CreepHealth = utility.GetWeakestUnit(creeps)

	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------
	-- Check for a channeling enemy
	for _,npcEnemy in pairs( enemys )
	do
		if ( npcEnemy:IsChanneling() and CanCast[abilityNumber]( npcEnemy )) 
		then
			return BOT_ACTION_DESIRE_HIGH, npcEnemy:GetLocation()
		end
	end
	-- If we're in a teamfight, use it on the scariest enemy
	local tableNearbyAttackingAlliedHeroes = npcBot:GetNearbyHeroes( 1000, false, BOT_MODE_ATTACK );
	if ( #tableNearbyAttackingAlliedHeroes >= 2 )
	then
		for _,npcEnemy in pairs( enemys )
		do
			if ( npcEnemy:IsChanneling() )
			then
				return BOT_ACTION_DESIRE_MODERATE-0.15, npcEnemy:GetLocation()
			end
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH ) 
	then
		local locationAoE = npcBot:FindAoELocation( true, true, npcBot:GetLocation(), CastRange, Radius, CastPoint, 0 );
		if ( locationAoE.count >= 2 ) 
		then
			return BOT_ACTION_DESIRE_LOW-0.15, locationAoE.targetloc
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

	-- If we're in a teamfight, use it 
	local tableNearbyAttackingAlliedHeroes = npcBot:GetNearbyHeroes( 1000, false, BOT_MODE_ATTACK );
	if ( #tableNearbyAttackingAlliedHeroes >= 2 ) 
	then
		local npcEnemy = npcBot:GetTarget();

		if ( npcEnemy ~= nil and enemys~=nil and #enemys >= 2) 
		then
			return BOT_ACTION_DESIRE_HIGH, npcEnemy:GetLocation()
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;

end

-- copied from sven_strength_of_god
Consider[6]=function()
	local abilityNumber=6
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability=AbilitiesReal[abilityNumber]
	
	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = 0;
	local Damage = ability:GetAbilityDamage()
	local Radius = ability:GetAOERadius()
	local CastPoint = ability:GetCastPoint()
	
	local allys = npcBot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
	local enemys = npcBot:GetNearbyHeroes(Radius,true,BOT_MODE_NONE)
	local enemys2 = npcBot:GetNearbyHeroes(Radius,false,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps2 = npcBot:GetNearbyCreeps(Radius,false)
	
	--try to kill enemy hero
	if npcBot:GetActiveMode() ~= BOT_MODE_RETREAT then
		if WeakestEnemy~=nil then
			if HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_PHYSICAL) then
				return BOT_ACTION_DESIRE_HIGH,WeakestEnemy
			end
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	-- If we're in a teamfight, use it 
	local tableNearbyAttackingAlliedHeroes = npcBot:GetNearbyHeroes( 1000, false, BOT_MODE_ATTACK )
	if #tableNearbyAttackingAlliedHeroes >= 2 then
		local npcEnemy = AbilityExtensions:GetTargetIfGood(npcBot)
		if ( npcEnemy ~= nil ) 
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

Consider[8] = Consider[1]

AbilityExtensions:AutoModifyConsiderFunction(npcBot, Consider, AbilitiesReal)
function AbilityUsageThink()

	-- Check if we're already using an ability
	if npcBot:IsCastingAbility() or npcBot:IsUsingAbility() or npcBot:IsInvulnerable() or npcBot:IsChanneling() or npcBot:IsSilenced() or npcBot:HasModifier("modifier_doom_bringer_doom")  or npcBot:NumQueuedActions() > 0  then return end
	
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