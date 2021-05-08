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
	Abilities[1],
	Abilities[3],
	Abilities[1],
	Abilities[2],
	Abilities[1],
	Abilities[5],
	Abilities[1],
	Abilities[3],
	Abilities[3],
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
		return Talents[3]
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
local Consider ={}
local CanCast={function(t)
	return AbilityExtensions:NormalCanCast(t, false, DAMAGE_TYPE_PHYSICAL, true, true, true) and not AbilityExtensions:HasAbilityRetargetModifier(npcBot)
end,function(t)
	return AbilityExtensions:SpellCanCast(t, true, true, true) and not AbilityExtensions:HasAbilityRetargetModifier(npcBot)
end,utility.NCanCast,function(t)
	return AbilityExtensions:NormalCanCast(t, false, DAMAGE_TYPE_PHYSICAL, true, false, false)
end,utility.CanCastPassive}
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
	local Damage = 65+npcBot:GetAttackDamage()*(0.1+0.15*ability:GetLevel())

	local HeroHealth=10000
	local CreepHealth=10000
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange+300,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
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
				if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(Damage,DAMAGE_TYPE_PHYSICAL)or (HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_PHYSICAL) and npcBot:GetMana()>ComboMana))
				then
					return BOT_ACTION_DESIRE_HIGH-0.04,WeakestEnemy;
				end
			end
		end
	end

	--------------------------------------
	-- Mode based usage
	--------------------------------------
	--protect myself
	if((npcBot:WasRecentlyDamagedByAnyHero(5) and npcBot:GetActiveMode() == BOT_MODE_RETREAT))
	then
		for _,npcEnemy in pairs( enemys )
		do
			if ( CanCast[abilityNumber]( npcEnemy ) and GetUnitToUnitDistance(npcBot,npcEnemy)<=CastRange)
			then
				return BOT_ACTION_DESIRE_HIGH-0.03, npcEnemy
			end
		end
	end

	--Last hit
	if (npcBot:GetActiveMode() == BOT_MODE_LANING or
		npcBot:GetActiveMode() == BOT_MODE_FARM		)
	then
		if(WeakestCreep~=nil)
		then
			if((ManaPercentage>0.4 or npcBot:GetMana()>ComboMana) and GetUnitToUnitDistance(npcBot,WeakestCreep)>=AttackRange+300)
			then
				if(CreepHealth<=WeakestCreep:GetActualIncomingDamage(Damage,DAMAGE_TYPE_PHYSICAL))
				then
					return BOT_ACTION_DESIRE_MODERATE+0.05,WeakestCreep;
				end
			end
		end
	end

	-- If my mana is enough,use it at enemy
	if ( npcBot:GetActiveMode() == BOT_MODE_LANING )
	then
		if((ManaPercentage>0.4 or npcBot:GetMana()>ComboMana) and ability:GetLevel()>=2 and CreepHealth>=150)
		then
			if (WeakestEnemy~=nil)
			then
				if ( CanCast[abilityNumber]( WeakestEnemy ) )
				then
					return BOT_ACTION_DESIRE_MODERATE-0.01,WeakestEnemy;
				end
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
		if ( #enemys>=1)
		then
			if (ManaPercentage>0.5 or npcBot:GetMana()>ComboMana and AbilitiesReal[abilityNumber]:GetLevel()>=1)
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

		if (#creeps >= 3 )
		then
			if (ManaPercentage>0.5 or npcBot:GetMana()>ComboMana and AbilitiesReal[abilityNumber]:GetLevel()>=1)
			then
					if ( CanCast[abilityNumber]( creeps[1] )and GetUnitToUnitDistance(npcBot,creeps[1])< CastRange + 75*#allys )
					then
						return BOT_ACTION_DESIRE_LOW, creeps[1];
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

Consider[2]=function()
	local abilityNumber=2
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability=AbilitiesReal[abilityNumber];

	if not ability:IsFullyCastable() or AbilityExtensions:CannotTeleport(npcBot) then
		return BOT_ACTION_DESIRE_NONE, 0;
	end

	local CastRange = ability:GetCastRange();
	local Damage = 0

	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange+300,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)

	--try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT )
	then
		if (WeakestEnemy~=nil)
		then
			if ( CanCast[abilityNumber]( WeakestEnemy ) )
			then
				if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_PHYSICAL) and npcBot:GetMana()>ComboMana and #allys >=#enemys)
				then
					return BOT_ACTION_DESIRE_HIGH,WeakestEnemy;
				end
			end
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	--protect myself
	if((npcBot:WasRecentlyDamagedByAnyHero(5) and npcBot:GetActiveMode() == BOT_MODE_RETREAT))
	then
		local allydistance=npcBot:DistanceFromFountain()
		local npcEnemy
		for _,tempEnemy in pairs( allys )
		do
			local tempDistance=tempEnemy:DistanceFromFountain()
			if (tempDistance<allydistance)
			then
				npcEnemy=tempEnemy
				allydistance=tempDistance
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
				if ( CanCast[abilityNumber]( npcEnemy )  and GetUnitToUnitDistance(npcBot,npcEnemy)< CastRange + 75*#allys and #allys >=#enemys)
				then
					return BOT_ACTION_DESIRE_MODERATE, npcEnemy;
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

	local CastRange = ability:GetAOERadius();

	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)

	local dispellRadius = ability:GetCastRange()
	local realEnemiesNearby = AbilityExtensions:GetNearbyNonIllusionHeroes(dispellRadius)

	--------------------------------------
	-- Mode based usage
	--------------------------------------
	--protect myself
	if npcBot:GetActiveMode() == BOT_MODE_LANING then 
		if HealthPercentage >= 0.6 or HealthPercentage >= 0.3 and ManaPercentage <= 0.3 then
			return 0
		end
	end
	if(npcBot:WasRecentlyDamagedByAnyHero(1) or
		(npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_MODERATE))
	then
		if (#realEnemiesNearby==0)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if AbilityExtensions:HasScepter(npcBot) then
		if AbilityExtensions:GetALlyDispellWorthModifiers(npcBot) then
			return BOT_ACTION_DESIRE_HIGH
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
			if ( GetUnitToUnitDistance(npcBot,npcEnemy)> CastRange + 75*#allys)
			then
				return BOT_ACTION_DESIRE_MODERATE
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;

end

Consider[4] = function()
	local abilityNumber=4
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability=AbilitiesReal[abilityNumber];

	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE
	end

	local CastRange = ability:GetAOERadius();

	local allys = AbilityExtensions:GetNearbyNonIllusionHeroes(npcBot, 1200, true)
	local enemys = AbilityExtensions:GetNearbyNonIllusionHeroes(npcBot, CastRange-100, false)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)

	if AbilityExtensions:IsAttackingEnemies(npcBot) then
		if #enemys >= 2 or #enemys == 1 and #allys == 0 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end
	return 0
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
