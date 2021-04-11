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


local AbilityToLevelUp = {
    Abilities[1],
    Abilities[2],
    Abilities[1],
    Abilities[3],
    Abilities[2],
    Abilities[5],
    Abilities[2],
    Abilities[2],
    Abilities[1],
    "talent",
    Abilities[1],
    Abilities[5],
    Abilities[3],
    Abilities[3],
    "talent",
    Abilities[3],
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

local TalentTree = {
    function() return Talents[1]  end,
    function() return Talents[4]  end,
    function() return Talents[6]  end,
    function() return Talents[8]  end,
    function() return Talents[2]  end,
    function() return Talents[3]  end,
    function() return Talents[5]  end,
    function() return Talents[7]  end,
}

utility.CheckAbilityBuild(AbilityToLevelUp)

function AbilityLevelUpThink()
    ability_item_usage_generic.AbilityLevelUpThink2(AbilityToLevelUp,TalentTree)
end


--------------------------------------
-- Ability Usage Thinking
--------------------------------------
local cast={} cast.Desire={} cast.Target={} cast.Type={}
local Consider ={}
local CanCast={utility.NCanCast,utility.NCanCast,utility.NCanCast,utility.UCanCast,utility.NCanCast}
local enemyDisabled=utility.enemyDisabled

function GetComboDamage()
	return ability_item_usage_generic.GetComboDamage(AbilitiesReal)
end

function GetComboMana()
	return ability_item_usage_generic.GetComboMana(AbilitiesReal)
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
	
	local CastRange = ability:GetSpecialValueInt( "blink_range" )
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local trees= npcBot:GetNearbyTrees(300)

	--try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		if (WeakestEnemy~=nil)
		then
			local enemys2= WeakestEnemy:GetNearbyHeroes(900,true,BOT_MODE_NONE)
			if ( CanCast[abilityNumber]( WeakestEnemy ) and #enemys2<=2)
			then
				if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana and GetUnitToUnitDistance(npcBot,WeakestEnemy) > 200)
				then
					return BOT_ACTION_DESIRE_HIGH,utility.GetUnitsTowardsLocation(npcBot,WeakestEnemy,CastRange+200); 
				end
			end
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	-- If we get stuck
	if utility.IsStuck(npcBot)
	then
		local loc = utility.GetEscapeLoc();
		return BOT_ACTION_DESIRE_HIGH, utility.GetUnitsTowardsLocation(npcBot,loc,CastRange);
	end
	
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:DistanceFromFountain()>=2000 and (ManaPercentage>=0.6 or npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH or HealthPercentage<=0.6)) 
	then
		return BOT_ACTION_DESIRE_HIGH, utility.GetUnitsTowardsLocation(npcBot,GetAncient(GetTeam()),CastRange)
	end
	
	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		 npcBot:GetActiveMode() == BOT_MODE_ATTACK ) 
	then
		local npcEnemy = npcBot:GetTarget();

		if(ManaPercentage>0.4 or npcBot:GetMana()>ComboMana)
		then
			if ( npcEnemy ~= nil ) 
			then
				local enemys2= npcEnemy:GetNearbyHeroes(900,false,BOT_MODE_NONE)
				if (enemys2~=nil and #enemys2<=2)
				then
					if ( CanCast[abilityNumber]( npcEnemy ) and GetUnitToUnitDistance(npcBot,npcEnemy)< CastRange + 75*#allys and GetUnitToUnitDistance(npcBot,npcEnemy) > 200)
					then
						return BOT_ACTION_DESIRE_MODERATE, utility.GetUnitsTowardsLocation(npcBot,npcEnemy,CastRange+200);
					end
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

	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE )
	local enemys = npcBot:GetNearbyHeroes(900,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local trees= npcBot:GetNearbyTrees(300)
	
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if (npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH)
	then
		local incProj = npcBot:GetIncomingTrackingProjectiles()
		for _,p in pairs(incProj)
		do
			if GetUnitToLocationDistance(npcBot, p.location) <= 300 and p.is_attack == false then
				return BOT_ACTION_DESIRE_HIGH;
			end
		end
	end
	
	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
		npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		npcBot:GetActiveMode() == BOT_MODE_ATTACK or
		(npcBot:GetActiveMode() == BOT_MODE_LANING and ManaPercentage >=0.4 ) )
	then
		local npcTarget = npcBot:GetTarget()
		if(npcTarget~=nil)
		then
			if CanCast[abilityNumber]( npcTarget ) and GetUnitToUnitDistance(npcBot,npcTarget) < 600
			then
				local incProj = npcBot:GetIncomingTrackingProjectiles()
				for _,p in pairs(incProj)
				do
					if GetUnitToLocationDistance(npcBot, p.location) <= 300 and p.is_attack == false and p.is_dodgeable and AbilityExtensions:Contains(AbilityExtensions.IgnoreAbilityBlockAbilities, p.ability:GetName()) then -- ability (etc spectre_spectral_dagger) cannot be blocked
						return BOT_ACTION_DESIRE_HIGH
					end
				end
			end
		end
	end
	
	return BOT_ACTION_DESIRE_NONE, 0;

end

Consider[4] = function()
    local abilityNumber=4
    local ability=AbilitiesReal[abilityNumber]
    if not ability:IsFullyCastable() then
        return 0
    end
    local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE )
    local enemies = AbilityExtensions:Filter(npcBot:GetNearbyHeroes(1600,true,BOT_MODE_NONE), function(t) return GetUnitToUnitDistance(npcBot, t) >= 450 end)
    local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemies)
    if #enemies == 0 then
        return 0
    end
    if npcBot:GetActiveMode() ~= BOT_MODE_RETREAT and (#enemies >= 2 or enemies[1]:GetHealth() >= npcBot:GetHealth() * 1.5) then
        return BOT_ACTION_DESIRE_MODERATE, WeakestEnemy:GetLocation()
    end
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
	local DamagePercent = ability:GetSpecialValueFloat("mana_void_damage_per_mana")
	local Radius = ability:GetAOERadius();

	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------
	--Try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		for i,npcEnemy in pairs(enemys)
		do
			if ( CanCast[abilityNumber]( npcEnemy ) )
			then
				local enemys = npcEnemy:GetNearbyHeroes(Radius,false,BOT_MODE_NONE)
				local Damage=(npcEnemy:GetMaxMana()-npcEnemy:GetMana())*DamagePercent
				local ManaPercentageEnemy=npcEnemy:GetMana()/npcEnemy:GetMaxMana()
				if(enemys~=nil)
				then
					Damage=Damage*(1+0.2*#enemys)
				end
				
				if(npcEnemy:GetHealth()<=npcEnemy:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL))
				then
					return BOT_ACTION_DESIRE_HIGH,npcEnemy; 
				end
			end
		end
	end
	
	-- Check for a channeling enemy
	for _,npcEnemy in pairs( enemys )
	do
		if ( npcEnemy:IsChanneling() and CanCast[abilityNumber]( npcEnemy )) 
		then
			return BOT_ACTION_DESIRE_MODERATE, npcEnemy
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