----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.1 NewStructure
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
	Abilities[1],
	Abilities[3],
	Abilities[1],
	Abilities[2],
	Abilities[1],
	Abilities[4],
	Abilities[1],
	Abilities[3],
	Abilities[3],
	"talent",
	Abilities[3],
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
		if ( npcEnemy:IsChanneling() and CanCast[1](npcEnemy) )
		then
			return BOT_ACTION_DESIRE_HIGH, npcEnemy:GetLocation();
		end
	end

	--try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		if (WeakestEnemy~=nil)
		then
			if ( CanCast[abilityNumber]( WeakestEnemy ) and not enemyDisabled(WeakestEnemy))
			then
				if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL) or (HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana))
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
		if((ManaPercentage>0.4 or npcBot:GetMana()>ComboMana))
		then
			local locationAoE = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), CastRange, Radius, CastPoint, 0 );
			if ( locationAoE.count >= 3 ) then
				return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc;
			end
		end
	end
	
	if ( npcBot:GetActiveMode() == BOT_MODE_LANING ) 
	then
		if(ManaPercentage>0.75 or npcBot:GetMana()>ComboMana)
		then	
			local locationAoE = npcBot:FindAoELocation( true, true, npcBot:GetLocation(), CastRange, Radius, CastPoint, 0 );
			if ( locationAoE.count >= 2 ) then
				return BOT_ACTION_DESIRE_MODERATE, locationAoE.targetloc;
			end
			
			if(WeakestEnemy~=nil and CanCast[abilityNumber]( WeakestEnemy )and not enemyDisabled(WeakestEnemy))
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
		if((ManaPercentage>0.4 or npcBot:GetMana()>ComboMana))
		then
			local locationAoE = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), CastRange, Radius, CastPoint, 0 );
			if ( locationAoE.count >= 3 ) 
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
		if ( locationAoE.count >= 2 ) then
			return BOT_ACTION_DESIRE_MODERATE, locationAoE.targetloc;
		end
		
		local npcTarget = npcBot:GetTarget();
		if ( npcTarget ~= nil ) 
		then
			if ( CanCast[abilityNumber]( npcTarget ) and not enemyDisabled(npcTarget) and GetUnitToUnitDistance(npcBot,npcTarget)<=CastRange)
				then
				return BOT_ACTION_DESIRE_MODERATE, npcTarget:GetExtrapolatedLocation(CastPoint);
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
	local Damage = 0
	local Radius = AbilitiesReal[3]:GetAOERadius()-80
	local CastPoint = ability:GetCastPoint()
	

	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(Radius+300,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(Radius+300,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	if AbilityExtensions:HasScepter(npcBot)
	then
		-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
		if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH ) 
		then
			if ( npcBot:WasRecentlyDamagedByAnyHero( 2.0 ) ) 
			then
				return BOT_ACTION_DESIRE_HIGH, npcBot:GetXUnitsInFront(CastRange);
			end
		end
	
		--protect myself
		if((npcBot:WasRecentlyDamagedByAnyHero(2) and #enemys>=1) or #enemys >=2)
		then
			for _,npcEnemy in pairs( enemys )
			do
				if ( CanCast[abilityNumber]( npcEnemy ) )
				then
					return BOT_ACTION_DESIRE_HIGH,npcBot:GetLocation();
				end
			end
		end
		
		-- If we're farming and can hit 2+ creeps
		if ( npcBot:GetActiveMode() == BOT_MODE_FARM )
		then
			if ( #creeps >= 2 and ManaPercentage>0.4 or npcBot:GetMana()>ComboMana) 
			then
				return BOT_ACTION_DESIRE_LOW,npcBot:GetXUnitsTowardsLocation(WeakestCreep,CastRange)
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
				if ( CanCast[abilityNumber]( npcEnemy ) and GetUnitToUnitDistance(npcBot,npcEnemy)<=Radius)
				then
					return BOT_ACTION_DESIRE_MODERATE,npcBot:GetXUnitsTowardsLocation(npcEnemy,CastRange)
				end
			end
		end
	else
		--protect myself
		if((npcBot:WasRecentlyDamagedByAnyHero(2) and #enemys>=1) or #enemys >=2)
		then
			for _,npcEnemy in pairs( enemys )
			do
				if ( CanCast[abilityNumber]( npcEnemy ) )
				then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end
		
		-- If my mana is enough
		if ( npcBot:GetActiveMode() == BOT_MODE_LANING ) 
		then
			if(WeakestCreep~=nil and ManaPercentage>0.4 or npcBot:GetMana()>ComboMana)
			then
				if(CreepHealth<=3*npcBot:GetAttackDamage() and GetUnitToUnitDistance(npcBot,WeakestCreep)<=300)
				then
					return BOT_ACTION_DESIRE_LOW,WeakestEnemy
				end
			end
		end
		
		-- If we're farming and can hit 2+ creeps
		if ( npcBot:GetActiveMode() == BOT_MODE_FARM )
		then
			if ( #creeps >= 2 and ManaPercentage>0.4 or npcBot:GetMana()>ComboMana) 
			then
				return BOT_ACTION_DESIRE_LOW,WeakestCreep
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
				if ( CanCast[abilityNumber]( npcEnemy ) and GetUnitToUnitDistance(npcBot,npcEnemy)<=Radius)
				then
					return BOT_ACTION_DESIRE_MODERATE,npcEnemy
				end
			end
		end
	end
	
	return BOT_ACTION_DESIRE_NONE, 0;
	
end

function GetUltDamage(npcTarget)

	local ability=AbilitiesReal[4]
	local Radius = ability:GetSpecialValueInt("echo_slam_echo_range")
	
	local enemys = npcTarget:GetNearbyHeroes(Radius,false,BOT_MODE_NONE)
	local creeps = npcTarget:GetNearbyCreeps(Radius,false)
	if(enemys==nil) then enemys={} end
	if(creeps==nil) then creeps={} end
	local count=#enemys+#creeps
	local Damage = ability:GetSpecialValueInt("AbilityDamage")+count*ability:GetSpecialValueInt("echo_slam_echo_damage")
	return Damage
	
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
	
	local CastRange = 0
	local Radius = ability:GetSpecialValueInt("echo_slam_echo_range")-150
	local CastPoint = ability:GetCastPoint()
	

	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(Radius,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(Radius,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
	if(enemys==nil) then enemys={} end
	if(creeps==nil) then creeps={} end
	local count=#enemys+#creeps
	local Damage = ability:GetSpecialValueInt("AbilityDamage")+count*ability:GetSpecialValueInt("echo_slam_echo_damage")
	
	local checkIfThereAreManyEnemies = AbilityExtensions:Filter(enemys, function(t) return AbilityExtensions:MayNotBeIllusion(npcBot, t) end)
	if #checkIfThereAreManyEnemies >= 3 then
		return #checkIfThereAreManyEnemies*0.2
	end
	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		 npcBot:GetActiveMode() == BOT_MODE_ATTACK ) 
	then
		local blink = AbilityExtensions:GetAvailableBlink(npcBot)
		if(blink~=nil and blink:IsFullyCastable())
		then
			local CastRange=1200
			local locationAoE = npcBot:FindAoELocation( true, true, npcBot:GetLocation(), CastRange, Radius, 0, 0 );
			local locationAoE2 = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), CastRange, Radius, 0, 0 );
			if ( locationAoE.count+locationAoE2.count >= 6 ) 
			then
				npcBot:Action_UseAbilityOnLocation( blink,locationAoE.targetloc );
				return 0
			end
			
			if (WeakestEnemy~=nil)
			then
				if ( CanCast[abilityNumber]( WeakestEnemy ))
				then
					if (#enemys > 1 or not WeakestEnemy:WasRecentlyDamagedByAnyHero(1.5)) and (HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetUltDamage(WeakestEnemy),DAMAGE_TYPE_MAGICAL) or (HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana))
					then
						npcBot:Action_UseAbilityOnLocation( blink,WeakestEnemy:GetLocation() );
						return 0
					end
				end
			end
		end
	end
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
				if (#enemys > 1 or not WeakestEnemy:WasRecentlyDamagedByAnyHero(1.5)) and (HeroHealth<=WeakestEnemy:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL))
				then
					return BOT_ACTION_DESIRE_MODERATE
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
		local npcEnemy = AbilityExtensions:GetTargetIfGood(npcBot)

		if ( npcEnemy ~= nil and #enemys>=2) 
		then
			if ( CanCast[abilityNumber]( npcEnemy ) and GetUnitToUnitDistance(npcBot,npcEnemy)<=Radius)
			then
				return BOT_ACTION_DESIRE_HIGH
			end
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