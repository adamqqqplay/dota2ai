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
	Abilities[3],
	Abilities[1],
	Abilities[1],
	Abilities[3],
	Abilities[1],
	Abilities[5],
	Abilities[1],
	Abilities[3],
	Abilities[3],
	"talent",
	Abilities[2],
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
local CanCast={utility.NCanCast,utility.NCanCast,utility.NCanCast,utility.UCanCast,utility.CanCastNoTarget,utility.NCanCast}
local enemyDisabled=utility.enemyDisabled

function GetComboDamage()
	return ability_item_usage_generic.GetComboDamage(AbilitiesReal)
end

function GetComboMana()
	return ability_item_usage_generic.GetComboMana(AbilitiesReal)
end

function ConsiderSoulRing()
	local soulring=IsItemAvailable("item_soul_ring");
	if(soulring~=nil and soulring:IsFullyCastable() and HealthPercentage>0.6)
	then
		npcBot:Action_UseAbility(soulring);
	end
end

-- Consider[1]=function()
	-- local Desire,Location=Consider1()
	-- if(Desire>0)
	-- then
		-- ConsiderSoulRing()
		-- return Desire,Location
	-- end
-- end

Consider[1]=function()
		
	local abilityNumber=1
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	
	local ability=AbilitiesReal[abilityNumber];
	if not ability:IsFullyCastable() then
		return 0
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
	
	if(ability:IsCooldownReady() and (#creeps>0 or #enemys>0))
	then
		ConsiderSoulRing()	
	end
	
	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
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
	-- If we're farming and can kill 3+ creeps with LSA
	if ( npcBot:GetActiveMode() == BOT_MODE_FARM ) then
		local locationAoE = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), CastRange, Radius, 0, Damage );

		if ( locationAoE.count >= 3 ) then
			return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc;
		end
	end

	-- If my mana is enough,use it at enemy
	if ( npcBot:GetActiveMode() == BOT_MODE_LANING ) 
	then
		if(ManaPercentage>0.4 or npcBot:GetMana()>ComboMana)
		then
			local locationAoE = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), CastRange, Radius, 0, Damage );
			if ( locationAoE.count >= 4 ) then
				return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc;
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
		local locationAoE = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), CastRange, Radius, 0, 0 );

		if ( locationAoE.count >= 4 ) 
		then
			return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc;
		end
	end

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
	
		local npcEnemy = npcBot:GetTarget();

		if ( npcEnemy ~= nil ) 
		then
			if ( CanCast[abilityNumber]( npcEnemy ) and enemyDisabled(npcEnemy))
			then
				return BOT_ACTION_DESIRE_HIGH, npcEnemy:GetExtrapolatedLocation(CastPoint);
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;
	
end

Consider[2]=function()
	
	local desire=Consider2()
	if(desire>0)
	then
		npcBot.AlchemistAbilityTimer=DotaTime()
		return desire
	end

end

function Consider2()
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
			return BOT_ACTION_DESIRE_HIGH
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
					return BOT_ACTION_DESIRE_HIGH
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
					return BOT_ACTION_DESIRE_HIGH
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

		if ( npcEnemy ~= nil ) and npcEnemy:IsHero()
		then
			if ( CanCast[abilityNumber]( npcEnemy ) and not enemyDisabled(npcEnemy) and GetUnitToUnitDistance(npcBot,npcEnemy)< CastRange + 75*#allys)
			then
				return BOT_ACTION_DESIRE_MODERATE
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;
	
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
    if HealthPercentage <= 0.2 then
        return BOT_ACTION_DESIRE_HIGH
    end
 	if ( HealthPercentage<=0.4)
 	then
 		return BOT_ACTION_DESIRE_LOW
 	end
	
 	-- If we're in a teamfight, use it on the scariest enemy
 	local tableNearbyAttackingAlliedHeroes = npcBot:GetNearbyHeroes( 1000, false, BOT_MODE_ATTACK );
 	if ( #tableNearbyAttackingAlliedHeroes >= 2)
 	then
 		return BOT_ACTION_DESIRE_HIGH
 	end
 	--------------------------------------
 	-- Mode based usage
 	--------------------------------------
 	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
 	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH )
 	then
 		if ( npcBot:WasRecentlyDamagedByAnyHero( 2.0 ) and HealthPercentage<=0.70+#enemys*0.05)
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
 		if ( HealthPercentage<=0.70+#enemys*0.05 )
 		then
 			return BOT_ACTION_DESIRE_HIGH
 		end
 	end

 	return BOT_ACTION_DESIRE_NONE
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
    local CastPoint = ability:GetCastPoint();

    local allys = npcBot:GetNearbyHeroes( CastRange+200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
    -- use at myself when chemical rage is not available
    local useTable = {}
    if not npcBot:HasModifier("modifier_alchemist_chemical_rage") and not npcBot:HasModifier("modifier_alchemist_berserk_potion") then
        local useChemicalRageDesire = Consider[5]()
        if useChemicalRageDesire ~= 0 then
            table.insert(useTable, {useChemicalRageDesire, npcBot})
        end
    end

    local checkAlly = function(ally)
        if HealthPercentage <= 0.2 then
            return BOT_ACTION_DESIRE_HIGH
        end
        if ( HealthPercentage<=0.4)
        then
            return BOT_ACTION_DESIRE_LOW
        end

        -- If we're in a teamfight, use it on the scariest enemy
        local tableNearbyAttackingAlliedHeroes = npcBot:GetNearbyHeroes( 1000, false, BOT_MODE_ATTACK );
        if ( #tableNearbyAttackingAlliedHeroes >= 2)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
        --------------------------------------
        -- Mode based usage
        --------------------------------------
        -- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
        if ( ally:GetActiveMode() == BOT_MODE_RETREAT and ally:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH )
        then
            if ( ally:WasRecentlyDamagedByAnyHero( 2.0 ) and HealthPercentage<=0.70+#enemys*0.05)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end

        -- If we're going after someone
        if ( ally:GetActiveMode() == BOT_MODE_ROAM or
                ally:GetActiveMode() == BOT_MODE_TEAM_ROAM or
                ally:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
                ally:GetActiveMode() == BOT_MODE_ATTACK )
        then
            if ( HealthPercentage<=0.70+#enemys*0.05 )
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end

        return BOT_ACTION_DESIRE_NONE
    end
    for _, ally in ipairs(allys) do
        local useAtAllyDesire = checkAlly(ally) - 0.2
        if useAtAllyDesire > 0 then
            table.insert(useTable, {useAtAllyDesire, ally})
        end
    end
    local highestDesire = {-1, -1}
    for _, target in ipairs(useTable) do
        if highestDesire[1] < target[1] then
            highestDesire = target
        end
    end
    if highestDesire[1] == -1 then
        return 0
    else
        return highestDesire[1], highestDesire[2]
    end
end

Consider[6]=function()
	local abilityNumber=6
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability=AbilitiesReal[abilityNumber];
	
	if not ability:IsFullyCastable() or ability:IsHidden() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = ability:GetCastRange();
	local Damage = ability:GetAbilityDamage();
	local CastPoint = ability:GetCastPoint();
	local TimeSinceCast = DotaTime()-npcBot.AlchemistAbilityTimer
	
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
			return BOT_ACTION_DESIRE_HIGH,npcEnemy
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
					if((GetUnitToUnitDistance(npcBot,WeakestEnemy)>CastRange-100 and GetUnitToUnitDistance(npcBot,WeakestEnemy)<CastRange) or (TimeSinceCast>3 and TimeSinceCast<5) or WeakestEnemy:GetHealth()/WeakestEnemy:GetMaxHealth()<=0.2)
					then
						return BOT_ACTION_DESIRE_HIGH,WeakestEnemy
					end
				end
			end
		end
	end

	--------------------------------------
	-- Mode based usage
	--------------------------------------
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH then
		for _,npcEnemy in pairs( enemys )do
			if ( npcBot:WasRecentlyDamagedByHero( npcEnemy, 2.0 ) ) then
				if ( CanCast[abilityNumber]( npcEnemy ) and not enemyDisabled(npcEnemy)) then
					if (GetUnitToUnitDistance(npcBot,npcEnemy)>CastRange-100 and GetUnitToUnitDistance(npcBot,npcEnemy)<CastRange) or (TimeSinceCast>2 and TimeSinceCast<5)
                            or npcEnemy:GetHealth()/npcEnemy:GetMaxHealth() <= 0.2 then
						return BOT_ACTION_DESIRE_HIGH,npcEnemy
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
		local npcEnemy = AbilityExtensions:GetTargetIfGood(npcBot)

		if ( npcEnemy ~= nil ) 
		then
			if CanCast[abilityNumber]( npcEnemy ) and not enemyDisabled(npcEnemy) then
				if GetUnitToUnitDistance(npcBot,npcEnemy)>CastRange-100 and GetUnitToUnitDistance(npcBot,npcEnemy)<CastRange
                        or (TimeSinceCast>3 and TimeSinceCast<5) or npcEnemy:GetHealth()/npcEnemy:GetMaxHealth() <= 0.2
				then
					return BOT_ACTION_DESIRE_HIGH,npcEnemy
				end
			end
		end
	end

	if TimeSinceCast >= 4 or TimeSinceCast >= 3 and enemys[1]:GetStunDuration(true) >= 2 then
		return BOT_ACTION_DESIRE_VERYHIGH,enemys[1]
	end
	if TimeSinceCast >= 2.5 then
		local silencer = AbilityExtensions:Count(enemys, function(t)
			return AbilityExtensions:MayNotBeIllusion(t) and t:HasSilence()
		end)
		if silencer > 0 then
			return BOT_ACTION_DESIRE_HIGH, enemys[1]
		end
	end
	
	-- throw when I'm hurt
	if (npcBot:GetHealth()/npcBot:GetMaxHealth() <= 0.25 and TimeSinceCast >= 1) then
		local es = npcBot:GetNearbyHeroes(CastRange,true,BOT_MODE_NONE)
		if #es > 0 then
			return BOT_ACTION_DESIRE_HIGH, es[1]
		end
	end
	return BOT_ACTION_DESIRE_NONE, 0
end
AbilityExtensions:AutoModifyConsiderFunction(npcBot, Consider, AbilitiesReal)

local function HasRealScepter(t)
	return t:HasScepter() or t:HasModifier("modifier_item_ultimate_scepter") or t:HasModifier("modifier_item_ultimate_scepter_consumed_alchemist") 
end

local function GetNonScepterFriends()
	local friends = GetTeamPlayers(GetTeam())
	return AbilityExtensions:FilterNot(friends, function(t) return HasRealScepter(t) end)
end

local function GetFeedScepterDesire(t)
	if npcBot == t then
		return 0.1
	end
	if HasRealScepter(t) then
		return 0
	end
	local tb = t.itemInformationTable
	local scepterIndex = AbilityExtensions:IndexOf(tb, function(tp) return tp.name == "item_ultimate_scepter" or tp.name == "item_recipe_ultimate_scepter" end)
	if scepterIndex == -1 then
		return 0.02
	elseif scepterIndex == 1 then
		return 0
	end
	local desire = RemapValClamped(scepterIndex, 2, 4, 0.8, 0.2)
	return desire
end

local function CheckFeedScepter()
	local friends = GetNonScepterFriends()
	friends = AbilityExtensions:Filter(friends, function(t) return t:IsAlive() and AbilityExtensions:AllyCanCast(t) and GetUnitToUnitDistance(t, npcBot) <= 1400 end)
	AbilityExtensions:ForEach(friends, function(t) coroutine.yield(GetFeedScepterDesire(t), t) end)
end
CheckFeedScepter = AbilityExtensions:EveryManySeconds(1, CheckFeedScepter)

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
	local index, target, castType = ability_item_usage_generic.UseAbility(AbilitiesReal,cast)
	if index == nil then
		local scepter = AbilityExtensions:GetAvailableItem(npcBot, "item_ultimate_scepter")
		if scepter and not AbilityExtensions:IsMuted(npcBot) then
			local desirePairs = AbilityExtensions:ResumeUntilReturn(CheckFeedScepter)
			if AbilityExtensions:CalledOnThisFrame(desirePairs) then
				local bestDesire = AbilityExtensions:Max(desirePairs, function(t) return t[1] end)
				if bestDesire[1] ~= 0 then
					npcBot:Action_UseAbilityOnEntity(scepter, bestDesire[2])
				end
			end
		end
	end
end

function CourierUsageThink() 
	ability_item_usage_generic.CourierUsageThink()
end