----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.5c
--	Author: adamqqq		Email:adamqqq@163.com
--  Contributor: zmcmcc Email:mengzhang@utexas.edu
----------------------------------------------------------------------------
--------------------------------------
-- General Initialization
--------------------------------------
local utility = require( GetScriptDirectory().."/utility" ) 
require(GetScriptDirectory() ..  "/ability_item_usage_generic")
local AbilityExtensions = require(GetScriptDirectory().."/util/AbilityAbstraction")
local AbilityHelper = dofile(GetScriptDirectory() .. "/util/AbilityHelper")

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
	Abilities[3],
	Abilities[2],
	Abilities[3],
	Abilities[5],
	Abilities[3],
	Abilities[1],
	Abilities[1],
	"talent",
	Abilities[1],
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
		return Talents[1]
	end,
	function()
		return Talents[3]
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
local const = AbilityHelper.const

local cast={} cast.Desire={} cast.Target={} cast.Type={}
local Consider ={}
local enemyDisabled=utility.enemyDisabled

function GetComboDamage()
	return ability_item_usage_generic.GetComboDamage(AbilitiesReal)
end

function GetComboMana()
	return ability_item_usage_generic.GetComboMana(AbilitiesReal)
end

local CanCast = {}
CanCast[1] = function(t)
	if target:HasModifier("modifier_shadow_demon_disruption") then
		return false
	end
	if npcBot:GetTeam() == t:GetTeam() then
		return AbilityExtensions:SpellCanCast(t, true, true, true) and not AbilityExtensions:DontInterruptAlly(t) and not t:IsMagicImmune()
	else
		return AbilityExtensions:NormalCanCast(t, false, DAMAGE_TYPE_MAGICAL) and not target:HasModifier("modifier_antimage_counterspell")
	end
end
CanCast[2] = function(target)
	return target:HasModifier("modifier_shadow_demon_disruption") or AbilityExtensions:NormalCanCast(target, false, DAMAGE_TYPE_PURE, false, false)
end
CanCast[3] = function(target)
	return target:HasModifier("modifier_shadow_demon_disruption") or AbilityExtensions:NormalCanCast(target, false, DAMAGE_TYPE_MAGICAL, false, true) -- cannot calculate the position if the target is not seen
end
CanCast[4] = function(target)
	return target:HasModifier("modifier_shadow_demon_disruption") or AbilityExtensions:NormalCanCast(target, false, DAMAGE_TYPE_MAGICAL, false, true)
end
CanCast[5] = function(target)
    return not target:HasModifier("modifier_antimage_counterspell") and not target:HasModifier("modifier_shadow_demon_purge_slow") and (target:HasModifier("modifier_shadow_demon_disruption") or AbilityExtensions:NormalCanCast(target, false, DAMAGE_TYPE_MAGICAL, false, true))
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

    local allys = AbilityExtensions:GetNearbyNonIllusionHeroes(npcBot, CastRange+300, false)
	local WeakestAlly,AllyHealth=utility.GetWeakestUnit(allys)
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	
	-- Check for a channeling enemy
	for _,enemy in pairs( enemys )
	do
		if ( enemy:IsChanneling() and CanCast[abilityNumber]( enemy ) and not AbilityExtensions:IsOrGoingToBeSeverelyDisabled(enemy)) 
		then
			return BOT_ACTION_DESIRE_HIGH, enemy
		end
	end
	
	-- If we're in a teamfight, use it on the scariest enemy
	local tableNearbyAttackingAlliedHeroes = npcBot:GetNearbyHeroes( 1000, false, BOT_MODE_ATTACK );
	if ( #tableNearbyAttackingAlliedHeroes >= 2 ) 
	then

		local npcMostDangerousEnemy = nil;
		local nMostDangerousDamage = 0;

		local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( CastRange, true, BOT_MODE_NONE );
		for _,npcEnemy in pairs( tableNearbyEnemyHeroes )
		do
			if ( CanCast[abilityNumber]( npcEnemy ) and not AbilityExtensions:IsOrGoingToBeSeverelyDisabled(npcEnemy))
			then
				local Damage2 = npcEnemy:GetEstimatedDamageToTarget( false, npcBot, 3.0, DAMAGE_TYPE_ALL );
				if ( Damage2 > nMostDangerousDamage )
				then
					nMostDangerousDamage = Damage2;
					npcMostDangerousEnemy = npcEnemy;
				end
			end
		end

		if ( npcMostDangerousEnemy ~= nil and not AbilityExtensions:IsOrGoingToBeSeverelyDisabled(npcMostDangerousEnemy))
		then
			return BOT_ACTION_DESIRE_LOW, npcMostDangerousEnemy;
		end
	end
	
	--try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		if (WeakestEnemy~=nil)
		then
			if ( CanCast[abilityNumber]( WeakestEnemy ) )
			then
				if ( CanCast[abilityNumber]( WeakestEnemy ) and not AbilityExtensions:IsOrGoingToBeSeverelyDisabled(WeakestEnemy))
				then
					return BOT_ACTION_DESIRE_MODERATE,WeakestEnemy; 
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
		local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( CastRange, true, BOT_MODE_NONE );
		for _,npcEnemy in pairs( tableNearbyEnemyHeroes )
		do
			if ( npcBot:WasRecentlyDamagedByHero( npcEnemy, 2.0 ) ) 
			then
				if ( CanCast[abilityNumber]( npcEnemy ) and not AbilityExtensions:IsOrGoingToBeSeverelyDisabled(npcEnemy))
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
		local npcTarget = npcBot:GetTarget();

		if ( npcTarget ~= nil ) 
		then
			if ( CanCast[abilityNumber]( npcTarget ) and not AbilityExtensions:IsOrGoingToBeSeverelyDisabled(npcTarget) and GetUnitToUnitDistance(npcBot,npcTarget) > 400
				and GetUnitToUnitDistance(npcBot,npcTarget) < CastRange + 100)
			then
				return BOT_ACTION_DESIRE_MODERATE, npcTarget
			end
		end

		if (WeakestAlly~=nil and #enemys >= 2)
		then
			if(AllyHealth/WeakestAlly:GetMaxHealth()<0.2)
			then
				return BOT_ACTION_DESIRE_MODERATE,WeakestAlly
			end
		end

		if(HealthPercentage < 0.3 and #allys < #enemys) then
			return BOT_ACTION_DESIRE_HIGH,npcBot
		end
	end


	local enemys2 = AbilityExtensions:GetNearbyNonIllusionHeroes(npcBot, 1000)
	local enemyCount = AbilityExtensions:GetEnemyHeroNumber(npcBot, enemys2)

    for _,npcTarget in pairs( allys )
    do
        if (npcTarget:GetHealth()/npcTarget:GetMaxHealth()<=0.2+0.05*enemyCount) and AbilityExtensions:IsOrGoingToBeSeverelyDisabled(npcTarget) and CanCast[2](npcTarget)
        then
			return RemapValClamped(AbilityExtensions:GetIllusionBattlePower(npcTarget), 0.1, 0.4, BOT_ACTION_DESIRE_MODERATE, BOT_ACTION_DESIRE_VERYHIGH), npcTarget
        end
    end

	return BOT_ACTION_DESIRE_NONE, 0 
end

Consider[2] = function()
	local ability = AbilitiesReal[2]
    if not ability:IsFullyCastable() or AbilityExtensions:CannotMove(npcBot) or ability:GetCurrentCharges() == 0 then
        return 0
    end
    local abilityLevel = ability:GetLevel()
    local castRange = ability:GetCastRange() + 200
    local radius = ability:GetAOERadius()
    local castPoint = ability:GetCastPoint()
    local manaCost = ability:GetManaCost()
    local duration = ability:GetDuration()
    local enemies = AbilityExtensions:GetNearbyHeroes(npcBot, castRange + radius)
    local realEnemies = AbilityExtensions:Filter(enemies, function(t) return AbilityExtensions:MayNotBeIllusion(npcBot, t) end)
    local targettableEnemies = AbilityExtensions:Filter(enemies, function(t) return AbilityExtensions:NormalCanCast(t, true, DAMAGE_TYPE_PHYSICAL, true) and not AbilityExtensions:CannotBeAttacked(t) end)
    local friends = AbilityExtensions:GetNearbyHeroes(npcBot, 1200, true)
    local friendCount = AbilityExtensions:GetEnemyHeroNumber(npcBot, friends)
    local enemyCreeps = AbilityExtensions:GetNearbyAttackableCreeps(npcBot, castRange + radius)
    local friendCreeps = AbilityExtensions:GetNearbyAttackableCreeps(npcBot, npcBot:GetAttackRange()+150, false)
    local neutralCreeps = npcBot:GetNearbyNeutralCreeps(castRange)
    local weakestEnemy, enemyHealth = utility.GetWeakestUnit(targettableEnemies)
	local target = npcBot:GetTarget()

	do 
		if target and CanCast[2](target) then
			return BOT_ACTION_DESIRE_MODERATE, AbilityExtensions:FindAOELocationAtSingleTarget(npcBot, target, radius, castRange, castPoint)
		end
	end
    if AbilityExtensions:NotRetreating(npcBot) then
        local findPlace = npcBot:FindAoELocation(true, true, npcBot:GetLocation(), castRange+100, radius, 0, 0)
        if findPlace.count >= 3 then
            if GetUnitToLocationDistance(npcBot, findPlace) <= castRange then
                return BOT_ACTION_DESIRE_VERYHIGH, findPlace.targetloc
            else
                return BOT_ACTION_DESIRE_MODERATE, findPlace.targetloc
            end
        elseif findPlace.count >= 2 then
            return BOT_ACTION_DESIRE_MODERATE, findPlace.targetloc
		elseif #realEnemies == 1 and findPlace.count == 1 then
			return BOT_ACTION_DESIRE_MODERATE-0.1, findPlace.targetloc
        end
    end
    return 0
end

local function GetPoisonCount(npcTarget)
	local modifier=npcTarget:GetModifierByName("modifier_shadow_demon_shadow_poison")
	if(modifier~=nil)
	then
		return npcTarget:GetModifierStackCount(modifier)
	else
		return 0
	end
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
	
	local CastRange = ability:GetCastRange()-300;
	local Damage = ability:GetAbilityDamage();
	local Radius = ability:GetAOERadius()-300
	local CastPoint = ability:GetCastPoint();
	
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange+300,true)
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
				if (ManaPercentage>0.5 and HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana and GetPoisonCount(WeakestEnemy) < 5)

				then
					return BOT_ACTION_DESIRE_HIGH,WeakestEnemy:GetExtrapolatedLocation(CastPoint); 
				end
			end
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------

	-- If we're pushing or defending a lane and can hit 4+ creeps, go for it
	if ( npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT ) 
	then
		local locationAoE = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), CastRange, Radius, 0, 0 );

		if ( ManaPercentage> 0.4 and  locationAoE.count >= 4) 
		then
			return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc;
		end
	end

	-- If my mana is enough,use it at enemy
	if ( npcBot:GetActiveMode() == BOT_MODE_LANING ) 
	then
		if (WeakestEnemy~=nil)
		then
			if ( ManaPercentage>0.5 and CanCast[abilityNumber]( WeakestEnemy ) and GetPoisonCount(WeakestEnemy) < 5)
			then
				return BOT_ACTION_DESIRE_LOW,WeakestEnemy:GetLocation();
			end
		end
	end

	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		 npcBot:GetActiveMode() == BOT_MODE_ATTACK) 
	then
		local npcEnemy = npcBot:GetTarget();

		if ( npcEnemy ~= nil ) 
		then
			if ( CanCast[abilityNumber]( npcEnemy ) and GetPoisonCount(npcEnemy) < 5)
			then
				return BOT_ACTION_DESIRE_HIGH, npcEnemy:GetExtrapolatedLocation(CastPoint);
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;
	
end

--[[Consider[4]=function()
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
	local enemys = npcBot:GetNearbyHeroes(1000,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange+300,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------
	--Try to kill enemy hero
	if (WeakestEnemy~=nil)
	then
		if (GetPoisonCount(WeakestEnemy)>=5)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;
	
end]]


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

	--try to kill enemy hero
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
	
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	-- If we're in a teamfight, use it on the scariest enemy
	local tableNearbyAttackingAlliedHeroes = npcBot:GetNearbyHeroes( 1000, false, BOT_MODE_ATTACK );
	if ( #tableNearbyAttackingAlliedHeroes >= 2 ) 
	then

		local npcMostDangerousEnemy = nil;
		local nMostDangerousDamage = 0;

		for _,npcEnemy in pairs( enemys )
		do
			if ( CanCast[abilityNumber]( npcEnemy ) and not AbilityExtensions:IsSeverelyDisabledOrSlowed(npcEnemy))
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
	
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH ) 
	then
		for _,npcEnemy in pairs( enemys )
		do
			if ( npcBot:WasRecentlyDamagedByHero( npcEnemy, 2.0 ) ) 
			then
				if ( CanCast[abilityNumber]( npcEnemy ) ) 
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
		local npcEnemy = AbilityExtensions:GetTargetIfGood(npcBot)

		if ( npcEnemy ~= nil ) 
		then
			if ( CanCast[abilityNumber]( npcEnemy ) and GetUnitToUnitDistance(npcBot,npcEnemy)< CastRange + 75*#allys)
			then
				return BOT_ACTION_DESIRE_HIGH, npcEnemy
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