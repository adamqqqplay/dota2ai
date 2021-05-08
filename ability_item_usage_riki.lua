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
local abilityName =  { "riki_smoke_screen", "riki_blink_strike", "riki_tricks_of_the_trade", "riki_poison_dart", "riki_backstab" }
local abilityIndex = utility.ReverseTable(abilityName)


local AbilityToLevelUp=
{
	Abilities[3],
	Abilities[2],
	Abilities[3],
	Abilities[1],
	Abilities[3],
	Abilities[5],
	Abilities[3],
	Abilities[2],
	Abilities[2],
	"talent",
	Abilities[2],
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

Consider[1]=function()	--Target Ability Example
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
	local CastPoint = ability:GetCastPoint()
	local Radius=ability:GetAOERadius()
	

	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
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
	
	--Try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		if (WeakestEnemy~=nil)
		then
			if ( CanCast[abilityNumber]( WeakestEnemy ) )
			then
				if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL) or (HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana))
				then
					return BOT_ACTION_DESIRE_HIGH,WeakestEnemy:GetExtrapolatedLocation(CastPoint+0.5); 
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
			if ( CanCast[abilityNumber]( npcEnemy ) )
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
			return BOT_ACTION_DESIRE_HIGH, npcMostDangerousEnemy:GetExtrapolatedLocation(CastPoint+0.5);
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
			if ( npcBot:WasRecentlyDamagedByHero( npcEnemy, 2.0 ) and GetUnitToUnitDistance(npcBot,npcEnemy)< CastRange) 
			then
				if ( CanCast[abilityNumber]( npcEnemy )) 
				then
					return BOT_ACTION_DESIRE_HIGH, npcEnemy:GetExtrapolatedLocation(CastPoint+0.5);
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
		local locationAoE = npcBot:FindAoELocation( true, true, npcBot:GetLocation(), CastRange, Radius, CastPoint, 0 );
		if ( locationAoE.count >= 2 ) 
		then
			return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc
		end
		
		local npcEnemy = npcBot:GetTarget();

		if ( npcEnemy ~= nil ) 
		then
			if ( enemyDisabled(npcEnemy) and GetUnitToUnitDistance(npcBot,npcEnemy)< CastRange + 75*#allys)
			then
				return BOT_ACTION_DESIRE_MODERATE, npcEnemy:GetExtrapolatedLocation(CastPoint+0.5);
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
	
	if not ability:IsFullyCastable() or AbilityExtensions:CannotTeleport(npcBot) then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = math.min(ability:GetCastRange(),1600)
	local Damage = ability:GetAbilityDamage();
	

	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local towers = npcBot:GetNearbyTowers(1000,true)
	
	-- Check for a channeling enemy
	for _,npcEnemy in pairs( enemys )
	do
		if ( npcEnemy:IsChanneling() and CanCast[abilityNumber]( npcEnemy ) and AbilitiesReal[1]:IsFullyCastable()) 
		then
			return BOT_ACTION_DESIRE_HIGH, npcEnemy
		end
	end
	
	
	--try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		if (WeakestEnemy~=nil)
		then
			if ( CanCast[abilityNumber]( WeakestEnemy ) )
			then
				if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_PHYSICAL) or (HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana) and npcBot:GetMana()>ComboMana and #allys+1 >=#enemys)
				then
					return BOT_ACTION_DESIRE_HIGH,WeakestEnemy; 
				end
			end
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	--[[]If my mana is enough,use it at enemy
	if ( npcBot:GetActiveMode() == BOT_MODE_LANING and (towers==nil or #towers==0)) 
	then
		if(ManaPercentage>0.4 or npcBot:GetMana()>ComboMana)
		then
			if (WeakestEnemy~=nil)
			then
				if ( CanCast[abilityNumber]( WeakestEnemy ) )
				then
					return BOT_ACTION_DESIRE_LOW,WeakestEnemy;
				end
			end
		end
	end]]
	
	--protect myself
	if((npcBot:WasRecentlyDamagedByAnyHero(5) and npcBot:GetActiveMode() == BOT_MODE_RETREAT))
	then
		local allydistance=npcBot:DistanceFromFountain()
		local npcEnemy
		for _,tempEnemy in pairs( allys )
		do
			tempdistance=tempEnemy:DistanceFromFountain()
			if (tempdistance<allydistance)
			then
				npcEnemy=tempEnemy
				allydistance=tempdistance
			end
		end
		if (npcEnemy~=nil)
		then
			if ( CanCast[abilityNumber]( npcEnemy ))
			then
				return BOT_ACTION_DESIRE_HIGH, npcEnemy
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
		
		if(ManaPercentage>0.4 or npcBot:GetMana()>ComboMana and #allys >=#enemys)
		then
			if ( npcEnemy ~= nil ) 
			then
				if ( CanCast[abilityNumber]( npcEnemy )  and GetUnitToUnitDistance(npcBot,npcEnemy)< CastRange + 75*#allys )
				then
					return BOT_ACTION_DESIRE_MODERATE, npcEnemy;
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;
	
end

Consider[3]=function()	--Target Ability Example
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
    local CastPoint = ability:GetCastPoint()
    local Radius=ability:GetAOERadius()

    local HeroHealth=10000
    local CreepHealth=10000
    local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
    local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
    local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
    --------------------------------------
    -- Global high-priorty usage
    --------------------------------------

    --Try to kill enemy hero
    if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT )
    then
        if (WeakestEnemy~=nil)
        then
            if ( CanCast[abilityNumber]( WeakestEnemy ) )
            then
                if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL) or (HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana))
                then
                    return BOT_ACTION_DESIRE_HIGH,WeakestEnemy:GetExtrapolatedLocation(CastPoint+0.5);
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
            if ( CanCast[abilityNumber]( npcEnemy ) )
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
            return BOT_ACTION_DESIRE_HIGH, npcMostDangerousEnemy:GetExtrapolatedLocation(CastPoint+0.5);
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
        local locationAoE = npcBot:FindAoELocation( true, true, npcBot:GetLocation(), CastRange, Radius, CastPoint, 0 );
        if ( locationAoE.count >= 2 )
        then
            return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc
        end

        local npcEnemy = npcBot:GetTarget();

        if ( npcEnemy ~= nil )
        then
            if ( enemyDisabled(npcEnemy) and GetUnitToUnitDistance(npcBot,npcEnemy)< CastRange + 75*#allys)
            then
                return BOT_ACTION_DESIRE_MODERATE, npcEnemy:GetExtrapolatedLocation(CastPoint+0.5);
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0;

end

Consider[4] = function()
    -- copied from bane_nightmare
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
        if ( npcEnemy:IsChanneling() and CanCast[abilityNumber]( npcEnemy ))
        then
            return BOT_ACTION_DESIRE_HIGH, npcEnemy
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
            local allys2=npcEnemy:GetNearbyHeroes( 600, true,BOT_MODE_NONE );
            if ( CanCast[abilityNumber]( npcEnemy ) and not enemyDisabled(npcEnemy) and allys2~=nil and #allys2==0)
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
            local allys2=npcEnemy:GetNearbyHeroes( 600, true ,BOT_MODE_NONE );
            if ( npcBot:WasRecentlyDamagedByHero( npcEnemy, 2.0 ) and allys2~=nil and #allys2==0)
            then
                if ( CanCast[abilityNumber]( npcEnemy ) and not enemyDisabled(npcEnemy))
                then
                    return BOT_ACTION_DESIRE_HIGH, npcEnemy;
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
        local allys2
        local allys3
        if ( npcEnemy ~= nil)
        then
            allys2=npcEnemy:GetNearbyHeroes( 600, true,BOT_MODE_NONE );
            allys3=npcEnemy:GetNearbyHeroes( 1600, true,BOT_MODE_NONE );
            if allys2 ==nil then allys2={} end
            if allys3 ==nil then allys3={} end
        end

        if ( npcEnemy ~= nil and #allys2<#allys3)
        then
            if ( CanCast[abilityNumber]( npcEnemy ) and not enemyDisabled(npcEnemy) and GetUnitToUnitDistance(npcBot,npcEnemy)< CastRange + 75*#allys)
            then
                return BOT_ACTION_DESIRE_MODERATE, npcEnemy
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

--Consider[5]=function()
--
--	local abilityNumber=5
--	--------------------------------------
--	-- Generic Variable Setting
--	--------------------------------------
--	local ability=AbilitiesReal[abilityNumber];
--
--	if not ability:IsFullyCastable() then
--		return BOT_ACTION_DESIRE_NONE, 0;
--	end
--
--	local CastRange = ability:GetCastRange();
--	local Radius = ability:GetAOERadius()
--
--	local HeroHealth=10000
--	local CreepHealth=10000
--	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
--	local enemys = npcBot:GetNearbyHeroes(Radius,true,BOT_MODE_NONE)
--	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
--	local linears=GetLinearProjectiles()
--	if(npcBot:GetActiveMode() == BOT_MODE_RETREAT and #enemys>=1)
--	then
--		for _,linear in pairs(linears)
--		do
--			if(GetTeamForPlayer(linear.playerid)~=GetTeam() and GetUnitToLocationDistance(npcBot,linear.location)<=600)
--			then
--				return BOT_ACTION_DESIRE_HIGH+0.05
--			end
--		end
--	end
--	--------------------------------------
--	-- Global high-priorty usage
--	--------------------------------------
--	-- If we're in a teamfight, use it on the scariest enemy
--	local tableNearbyAttackingAlliedHeroes = npcBot:GetNearbyHeroes( 1000, false, BOT_MODE_ATTACK );
--	if ( #tableNearbyAttackingAlliedHeroes >= 2 )
--	then
--		if ( #enemys+#allys >= 6-2*HealthPercentage and #enemys>=2)
--		then
--			return BOT_ACTION_DESIRE_HIGH
--		end
--	end
--
--	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
--	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH )
--	then
--		if ( npcBot:WasRecentlyDamagedByAnyHero(2) )
--		then
--			return BOT_ACTION_DESIRE_MODERATE-0.05
--		end
--	end
--
--	-- If we're going after someone
--	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
--		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
--		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
--		 npcBot:GetActiveMode() == BOT_MODE_ATTACK )
--	then
--		local npcEnemy = npcBot:GetTarget();
--
--		if ( npcEnemy ~= nil )
--		then
--			if ( npcEnemy:GetHealth()<=npcEnemy:GetActualIncomingDamage(npcBot:GetOffensivePower(),DAMAGE_TYPE_MAGICAL) and GetUnitToUnitDistance(npcEnemy,npcBot)<=Radius-200)
--			then
--				return BOT_ACTION_DESIRE_MODERATE
--			end
--		end
--	end
--
--	return BOT_ACTION_DESIRE_NONE;
--
--end

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