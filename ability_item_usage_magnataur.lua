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
	Abilities[3],
	Abilities[1],
	Abilities[1],
	Abilities[2],
	Abilities[1],
	Abilities[5],
	Abilities[1],
	Abilities[2],
	Abilities[2],
	"talent",
	Abilities[2],
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
local CanCast={utility.NCanCast,utility.NCanCast,utility.NCanCast,function(t)
    return not AbilityExtensions:IsInvulnerable(t)
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
	
	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = ability:GetCastRange();
	local Damage = ability:GetAbilityDamage();
	local Radius = ability:GetAOERadius();
	

	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange+0,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange+0,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)

	--try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		if (WeakestEnemy~=nil)
		then
			if ( CanCast[abilityNumber]( WeakestEnemy ) )
			then
				if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL) or (HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana))
				then
					return BOT_ACTION_DESIRE_HIGH,WeakestEnemy:GetLocation(); 
				end
			end
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	--Last hit
	if ( npcBot:GetActiveMode() == BOT_MODE_LANING ) 
	then
		if(WeakestCreep~=nil)
		then
			if((ManaPercentage>0.5 or npcBot:GetMana()>ComboMana) and GetUnitToUnitDistance(npcBot,WeakestCreep)>=300)
			then
				local locationAoE = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), CastRange, Radius, 0, Damage );
				if ( locationAoE.count >= 1 ) then
					return BOT_ACTION_DESIRE_LOW-0.02, locationAoE.targetloc;
				end
			end		
		end
	end
	
	if ( npcBot:GetActiveMode() == BOT_MODE_LANING ) 
	then
		if((ManaPercentage>0.5 or npcBot:GetMana()>ComboMana) and ability:GetLevel()>=2 )
		then
			local locationAoE = npcBot:FindAoELocation( true, true, npcBot:GetLocation(), CastRange, Radius, 0, 0 );
			if ( locationAoE.count >= 2 ) then
				return BOT_ACTION_DESIRE_LOW-0.01, locationAoE.targetloc;
			end
		end
	end
	
	-- If we're farming and can kill 3+ creeps with LSA
	if ( npcBot:GetActiveMode() == BOT_MODE_FARM ) then
		local locationAoE = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), CastRange, Radius, 0, Damage );

		if ( locationAoE.count >= 3 ) then
			return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc;
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
			return BOT_ACTION_DESIRE_LOW+0.01, locationAoE.targetloc;
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
			if ( CanCast[abilityNumber]( npcTarget ) )
			then
				return BOT_ACTION_DESIRE_MODERATE, npcTarget:GetLocation();
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;

end

CanCast[2] = function(t)
    return not t:IsInvulnerable() and not AbilityExtensions:CannotBeTargetted(t)
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
	
	local modifierName="modifier_magnataur_empower"
	local CastRange = ability:GetCastRange();
	local Damage = 0
	
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange+300,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
	
	-- If we're pushing or defending a lane
	if ( npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT) 
	then
		if(ManaPercentage>0.6)
		then
			for _,myFriend in pairs(allys) do
				if ( GetUnitToUnitDistance( myFriend, npcBot  ) < CastRange and not myFriend:HasModifier(modifierName) ) 
				then
					return BOT_ACTION_DESIRE_MODERATE, myFriend;
				end
			end	
			if not npcBot:HasModifier(modifierName) then
				return BOT_ACTION_DESIRE_MODERATE, npcBot;
			end
		end
	end
	
	-- If my mana is enough,buff myfriend.
	if(ManaPercentage>0.6 and npcBot:GetMana()>ComboMana)
	then
		for _,ally in pairs(allys)
		do
			if ( not ally:HasModifier(modifierName) ) 
			then
				return BOT_ACTION_DESIRE_MODERATE,ally;
			end
		end
		
		if not npcBot:HasModifier(modifierName) then
			return BOT_ACTION_DESIRE_MODERATE, npcBot;
		end
		
	end
	
	return BOT_ACTION_DESIRE_NONE, 0 
end

Consider[3]=function()
	
	local abilityNumber=3
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability=AbilitiesReal[abilityNumber];
	
	if not ability:IsFullyCastable() or AbilityExtensions:CannotMove(npcBot) then
		return BOT_ACTION_DESIRE_NONE, 0;
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

	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH ) 
	then
		if ( npcBot:WasRecentlyDamagedByAnyHero( 2.0 ) )
		then
			return BOT_ACTION_DESIRE_HIGH, utility.Fountain(GetTeam());
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
			if ( CanCast[abilityNumber]( npcEnemy ) )
			then
				return BOT_ACTION_DESIRE_MODERATE, npcEnemy:GetExtrapolatedLocation(CastPoint);
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
	local ability=AbilitiesReal[abilityNumber]
	
	if not ability:IsFullyCastable() or ability:IsHidden() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	local radius = ability:GetSpecialValueInt("radius")
	local pullAngle = ability:GetSpecialValueInt("pull_angle") / 2
	local CastPoint = ability:GetCastPoint()
	local function CanToss(target)
		local loc = target:GetExtrapolatedLocation(CastPoint)
		return GetUnitToLocationDistance(npcBot, loc) <= radius and npcBot:IsFacingLocation(loc, pullAngle)
	end
	local f = AbilityExtensions:Filter(AbilityExtensions:GetNearbyNonIllusionHeroes(npcBot, 500, true), CanToss)
    f = AbilityExtensions:Filter(f, function(t) AbilityExtensions:NormalCanCast(t) end)
	f = AbilityExtensions:GetEnemyHeroNumber(f)
	if AbilityExtensions:NotRetreating(npcBot) and f >= 2 or f == 1 and #AbilityExtensions:GetNearbyNonIllusionHeroes(npcBot, 1200, true) == 1 then
		return BOT_MODE_DESIRE_HIGH
	end

	local function CanTossAfterTurnBack(target)
		local loc = target:GetExtrapolatedLocation(CastPoint)
		return GetUnitToLocationDistance(npcBot, loc) <= radius and not npcBot:IsFacingLocation(loc, 180-pullAngle)
	end
	f = AbilityExtensions:Filter(AbilityExtensions:GetNearbyNonIllusionHeroes(npcBot, 500, true), CanTossAfterTurnBack)
    f = AbilityExtensions:Filter(f, function(t) AbilityExtensions:NormalCanCast(t) end)
	f = AbilityExtensions:GetEnemyHeroNumber(f)
	if AbilityExtensions:NotRetreating(npcBot) and f >= 1 then
		npcBot:Action_MoveDirectly(utility.GetUnitsTowardsLocation(npcBot, f[1]:GetLocation(), 10))
		npcBot:ActionQueue_UseAbility(ability)
		return 0
	end

	return 0
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
	
	local CastRange = 0
	local Damage = ability:GetAbilityDamage()
	local Radius = ability:GetAOERadius()-50
	local CastPoint = ability:GetCastPoint()
	
	local blink = AbilityExtensions:GetAvailableBlink(npcBot)
	if(blink~=nil and blink:IsFullyCastable())
	then
		CastRange=CastRange+1200
		if(npcBot:GetActiveMode() == BOT_MODE_ATTACK ) 
		then
			local locationAoE = npcBot:FindAoELocation( true, true, npcBot:GetLocation(), CastRange, Radius, 0, 0 );
			if ( locationAoE.count >= 2 ) 
			then
				npcBot:Action_UseAbilityOnLocation( blink, locationAoE.targetloc );
				return 0
			end
		end
	end

	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(Radius,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(Radius,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------
	--Try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		if (WeakestEnemy~=nil)
		then
			if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL) or (HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana))
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	--protect myself
	if((npcBot:WasRecentlyDamagedByAnyHero(2) and #enemys>=1) or #enemys>=2)
	then
		for _,npcEnemy in pairs( enemys )
		do
			return BOT_ACTION_DESIRE_HIGH
		end
	end
	
	-- If my mana is enough,use it at enemy
	if ( npcBot:GetActiveMode() == BOT_MODE_LANING ) 
	then
		if((ManaPercentage>0.4 or npcBot:GetMana()>ComboMana))
		then
			if (WeakestEnemy~=nil)
			then
				if(GetUnitToUnitDistance(npcBot,WeakestEnemy)<Radius-CastPoint*WeakestEnemy:GetCurrentMovementSpeed())
				then
					return BOT_ACTION_DESIRE_LOW
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
			if ( GetUnitToUnitDistance(npcBot,npcEnemy)>=300 ) 
			then
				if( GetUnitToUnitDistance(npcBot,npcEnemy)<=1200+Radius and blink~=nil)
				then
					npcBot:Action_UseAbilityOnLocation( blink, npcEnemy:GetExtrapolatedLocation(CastPoint) );
					return 0
				end
			else		
				return BOT_ACTION_DESIRE_MODERATE
			end

		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;
	
end

AbilityExtensions:AutoModifyConsiderFunction(npcBot, Consider, AbilitiesReal)

local abilityUsedInfo = {}

function AbilityUsageThink()

	-- Check if we're already using an ability
	if ( npcBot:IsUsingAbility() or npcBot:IsChanneling() or npcBot:IsSilenced() )then
        if npcBot:IsCastingAbility() then
			if npcBot:GetCurrentActiveAbility() == AbilitiesReal[5] then
				local radius = AbilitiesReal[5]:GetAOERadius()
				if AbilityExtensions:Count(AbilityExtensions:GetNearbyNonIllusionHeroes(npcBot, radius), CanCast[5]) == 0 then
					print("Magnataur: cancel ultimate")
					npcBot:Action_ClearActions(true)
				end
			end
        end
		return
	end
	abilityUsedInfo.index = nil
    
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
	local usedAbilityIndex, target, castType = ability_item_usage_generic.UseAbility(AbilitiesReal,cast)
    if usedAbilityIndex ~= nil then
        abilityUsedInfo.index = usedAbilityIndex
    end
end

function CourierUsageThink() 
	ability_item_usage_generic.CourierUsageThink()
end