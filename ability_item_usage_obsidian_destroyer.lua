----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.5 
--	Author: adamqqq		Email:adamqqq@163.com
--  Contributor: zmcmcc Email:mengzhang@utexas.edu
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
	Abilities[3],
	Abilities[2],
	Abilities[3],
	Abilities[1],
	Abilities[3],
	Abilities[4],
	Abilities[1],
	"talent",
	Abilities[1],
	Abilities[2],
	Abilities[2],
	Abilities[2],
	"talent",
	Abilities[4],
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
local CanCast={AbilityExtensions.PhysicalCanCastFunction,function(t)
	if npcBot:GetTeam() == t:GetTeam() then
		return AbilityExtensions:SpellCanCast(t, true, true, true) and not AbilityExtensions:DontInterruptAlly(t) and not t:IsMagicImmune()
	else
		return AbilityExtensions:NormalCanCast(t, false, DAMAGE_TYPE_MAGICAL) and not t:HasModifier("modifier_antimage_counterspell")
	end
end,utility.NCanCast,
function(t)
    return t:HasModifier("modifier_obsidian_destroyer_astral_imprisonment_prison") or AbilityExtensions:NormalCanCast(t)
end}
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
	
	if npcBot:IsIllusion() or not ability:IsFullyCastable() or AbilityExtensions:IsPhysicalOutputDisabled(npcBot) then -- destroyer's illusions (from illusion rune or from shadow_demon_disruption) can use the first ability
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = ability:GetCastRange();
	local Damage = ability:GetSpecialValueInt("damage_bonus")+npcBot:GetAttackDamage()
	

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
			if npcBot:GetLevel()>=7
			then
				ability:ToggleAutoCast()
				return BOT_ACTION_DESIRE_NONE, 0;
			end
		end
	end
	
	
	--try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT) 
	then
		if (WeakestEnemy~=nil)
		then
			if ( CanCast[abilityNumber]( WeakestEnemy ) )
			then
				if(WeakestEnemy:GetHealth()<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_ALL))
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
		if(WeakestCreep~=nil and ManaPercentage > 0.45)
		then
			if(CreepHealth<=WeakestCreep:GetActualIncomingDamage(Damage,DAMAGE_TYPE_PHYSICAL))
			then
				return BOT_ACTION_DESIRE_LOW,WeakestCreep
			end
		end

	end
	
	-- If we're farming
	if ( npcBot:GetActiveMode() == BOT_MODE_FARM )
	then
		return BOT_ACTION_DESIRE_LOW, WeakestCreep;
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

local dazzle_shadow_grave = function()
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

    local allys = AbilityExtensions:GetNearbyNonIllusionHeroes(npcBot, CastRange+300, false)
	local enemys2 = AbilityExtensions:GetNearbyNonIllusionHeroes(npcBot, 1000)
	local enemyCount = AbilityExtensions:GetEnemyHeroNumber(npcBot, enemys2)

    for _,npcTarget in pairs( allys )
    do
        if (npcTarget:GetHealth()/npcTarget:GetMaxHealth()<=0.2+0.05*enemyCount) and AbilityExtensions:IsOrGoingToBeSeverelyDisabled(npcTarget) and CanCast[2](npcTarget)
        then
			return BOT_ACTION_DESIRE_MODERATE, npcTarget
        end
    end

    return BOT_ACTION_DESIRE_NONE

end

local oldConsider2 = function()
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
	
    local allys = AbilityExtensions:GetNearbyNonIllusionHeroes(npcBot, CastRange+300, false)
	local WeakestAlly,AllyHealth=utility.GetWeakestUnit(allys)
	local allys2 = GetUnitList(UNIT_LIST_ALLIED_HEROES)
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange+300,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
	local npcTarget
	
	-- Check for a channeling enemy
	for _,enemy in pairs( enemys )
	do
		if ( enemy:IsChanneling() and CanCast[abilityNumber]( enemy )) 
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

	local enemys2 = AbilityExtensions:GetNearbyNonIllusionHeroes(npcBot, 1000)
	local enemyCount = AbilityExtensions:GetEnemyHeroNumber(npcBot, enemys2)

    for _,npcTarget in pairs( allys )
    do
        if (npcTarget:GetHealth()/npcTarget:GetMaxHealth()<=0.2+0.05*enemyCount) and AbilityExtensions:IsOrGoingToBeSeverelyDisabled(npcTarget) and CanCast[2](npcTarget)
        then
			return BOT_ACTION_DESIRE_MODERATE, npcTarget
        end
    end

	--try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		if (WeakestEnemy~=nil)
		then
			if ( CanCast[abilityNumber]( WeakestEnemy ) )
			then
				if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL) and #allys <= 1 and not AbilityExtensions:IsOrGoingToBeSeverelyDisabled(WeakestEnemy))
				then
					return BOT_ACTION_DESIRE_HIGH,WeakestEnemy; 
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
	
	if ( npcBot:GetActiveMode() == BOT_MODE_LANING ) 
	then
		if(ManaPercentage>0.4 or npcBot:GetMana()>ComboMana)
		then
			if (WeakestEnemy~=nil)
			then
				if ( CanCast[abilityNumber]( WeakestEnemy ) and GetUnitToUnitDistance(npcBot,WeakestEnemy)< CastRange+200 and not AbilityExtensions:IsOrGoingToBeSeverelyDisabled(WeakestEnemy))
				then
					return BOT_ACTION_DESIRE_LOW,WeakestEnemy
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
			if ( CanCast[abilityNumber]( npcTarget ) and not AbilityExtensions:IsOrGoingToBeSeverelyDisabled(npcTarget) and GetUnitToUnitDistance(npcBot,npcTarget) > 75 * #allys 
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

		if(HealthPercentage < 0.2) then
			return BOT_ACTION_DESIRE_HIGH,npcBot
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0 
end

Consider[2] = function()
    local d1,t1 = oldConsider2()
    if d1 ~= 0 then
        return d1,t1
    else
        return dazzle_shadow_grave()
    end
end

--Consider[2]=function()
--
--	local abilityNumber=2
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
--	local Damage = ability:GetAbilityDamage();
--
--	local allys = npcBot:GetNearbyHeroes( CastRange+300, false, BOT_MODE_NONE )
--	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
--	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
--	local creeps = npcBot:GetNearbyCreeps(CastRange+300,true)
--	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
--
--
--	-- If we're going after someone
--	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
--		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
--		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
--		 npcBot:GetActiveMode() == BOT_MODE_ATTACK )
--	then
--		local npcEnemy = npcBot:GetTarget();
--		if ( npcEnemy ~= nil )
--		then
--			if ( CanCast[abilityNumber]( npcEnemy )  and GetUnitToUnitDistance(npcBot,npcEnemy)< CastRange + 75*#allys)
--			then
--				return BOT_ACTION_DESIRE_MODERATE, npcEnemy;
--			end
--		end
--	end
--
--
--
--	return BOT_ACTION_DESIRE_NONE, 0
--end

Consider[4]=function()

	local abilityNumber=4
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability=AbilitiesReal[abilityNumber];
	
	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = ability:GetCastRange()-100;
	local Damage = ability:GetAbilityDamage();
	local Radius = ability:GetAOERadius()-80
	local CastPoint = ability:GetCastPoint();
	
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = AbilityExtensions:GetNearbyNonIllusionHeroes(npcBot, CastRange+300,true,BOT_MODE_NONE)
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
			if ( CanCast[abilityNumber]( WeakestEnemy ) and #enemys>=2)
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

	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		 npcBot:GetActiveMode() == BOT_MODE_ATTACK) 
	then
		local locationAoE = npcBot:FindAoELocation( true, true, npcBot:GetLocation(), CastRange, Radius, CastPoint, 0 );
		if(#enemys >= 2)
		then
			if  npcBot:GetModifierStackCount(npcBot:GetModifierByName("modifier_obsidian_destroyer_astral_imprisonment_charge_counter")) > 30
				or (#enemys >= 3 and npcBot:GetModifierStackCount(npcBot:GetModifierByName("modifier_obsidian_destroyer_astral_imprisonment_charge_counter")) > 12)
			then
				return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc;
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
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