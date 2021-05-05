----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.5e
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
	Abilities[2],
	Abilities[1],
	Abilities[2],
	Abilities[3],
	Abilities[2],
	Abilities[6],
	Abilities[2],
	Abilities[3],
	Abilities[3],
	"talent",
	Abilities[3],
	Abilities[6],
	Abilities[1],
	Abilities[1],
	"talent",
	Abilities[1],
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
local CanCast = {
    utility.NCanCast,
    utility.NCanCast,
    utility.NCanCast,
    utility.NCanCast,
    utility.NCanCast,
    utility.NCanCast,
}
local enemyDisabled=utility.enemyDisabled

function GetComboDamage()
	return ability_item_usage_generic.GetComboDamage(AbilitiesReal)
end

function GetComboMana()
	return ability_item_usage_generic.GetComboMana(AbilitiesReal)
end

local xMarkTarget
local xMarkTime
local xMarkLocation
local xMarkDuration
local useTorrentAtXMark
local useTorrentAtXMarkTime
local function XMarksEnemy()
	if xMarkTarget ~= nil then
		-- print(xMarkTarget:GetUnitName())
		-- print(AbilityExtensions:ToStringVector(xMarkLocation))
	end
    return xMarkTarget ~= nil and xMarkTarget:GetTeam() ~= npcBot:GetTeam()
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
	local CastPoint = 2;
	

	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)


	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------

	-- Check for a channeling enemy
	for _,npcEnemy in pairs( enemys )
	do
		if ( npcEnemy:IsChanneling() ) 
		then
			return BOT_ACTION_DESIRE_HIGH-0.1, npcEnemy:GetLocation();
		end
	end

    if XMarksEnemy() and CanCast[1](xMarkTarget) and DotaTime()-xMarkTime <= 0.8 then
		print("Torrent on x marked target: "..xMarkTarget:GetUnitName().." at location "..AbilityExtensions:ToStringVector(xMarkLocation).." at "..DotaTime())
        return BOT_ACTION_DESIRE_VERYHIGH, xMarkLocation
    end

	--try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		if (WeakestEnemy~=nil)
		then
			if ( CanCast[abilityNumber]( WeakestEnemy ) and WeakestEnemy:HasModifier("modifier_kunkka_x_marks_the_spot"))
			then
				if WeakestEnemy:GetModifierRemainingDuration( WeakestEnemy:GetModifierByName('modifier_kunkka_x_marks_the_spot') )< 1.6
				then
					return BOT_ACTION_DESIRE_HIGH+0.15, WeakestEnemy:GetExtrapolatedLocation(-2.5);
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
				if ( CanCast[abilityNumber]( npcEnemy ) ) 
				then
					return BOT_ACTION_DESIRE_MODERATE, npcEnemy:GetExtrapolatedLocation(CastPoint+0.5);
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
			if ( locationAoE.count >= 4 ) 
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
			if ( CanCast[abilityNumber]( npcTarget ) and npcTarget:HasModifier("modifier_kunkka_x_marks_the_spot"))
			then
				if npcTarget:GetModifierRemainingDuration( npcTarget:GetModifierByName('modifier_kunkka_x_marks_the_spot') )< 1.6
				then
					return BOT_ACTION_DESIRE_HIGH+0.15, npcTarget:GetExtrapolatedLocation(-2.5);
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;
end

-- Consider[2] = function()
-- 	local ability=AbilitiesReal[3];
	
-- 	if not ability:IsFullyCastable() then
-- 		return 0
-- 	end
	
-- 	local CastRange = ability:GetCastRange();
-- 	local Damage = ability:GetAbilityDamage();
	
-- 	local HeroHealth=10000
-- 	local CreepHealth=10000
-- 	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
-- 	local enemys = npcBot:GetNearbyHeroes(CastRange,true,BOT_MODE_NONE)
-- 	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	
-- 	if npcBot:GetActiveMode() == BOT_MODE_LANING then
-- 		if ability:GetAutoCastState() then
-- 			ability:ToggleAutoCast()
-- 		end
		
-- end
-- Consider[2] = AbilityExtensions:ToggleFunctionToAutoCast(npcBot, Consider[2], AbilitiesReal[2])

-- Consider[4] = function()
-- 	return 0
-- end
-- Consider[5] = function()
-- 	return 0
-- end

Consider[3]=function()

	local ability=AbilitiesReal[3];
	
	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = ability:GetCastRange();
	local Damage = ability:GetAbilityDamage();
	

	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	
	-- Check for a channeling enemy
	for _,enemy in pairs( enemys )
	do
		if ( enemy:IsChanneling() and CanCast[3]( enemy ) and not enemy:IsSilenced()) 
		then
			return BOT_ACTION_DESIRE_HIGH, enemy
		end
	end
	
	--try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		if (WeakestEnemy~=nil)
		then
			if ( CanCast[3]( WeakestEnemy ) and ManaPercentage > 0.5)
			then
				if((HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_MAGICAL) or npcBot:GetMana()>ComboMana))
				then
					return BOT_ACTION_DESIRE_HIGH,WeakestEnemy; 
				end
			end
		end
	end

	-- If a mode has set a target, and we can kill them, do it
	local npcTarget = npcBot:GetTarget();
	if ( npcTarget ~= nil )
	then
		if(CanCast[3]( npcTarget ))
		then
			if (GetComboDamage()*(0.85+0.15*#allys) > npcTarget:GetHealth() and GetUnitToUnitDistance( npcTarget, npcBot ) < ( CastRange + 200 ) )
			then
				return BOT_ACTION_DESIRE_HIGH, npcTarget;
			end
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
			if ( CanCast[3]( npcEnemy ) and not npcEnemy:IsSilenced())
			then
				local Damage = npcEnemy:GetEstimatedDamageToTarget( false, npcBot, 3.0, DAMAGE_TYPE_ALL );
				if ( Damage > nMostDangerousDamage )
				then
					nMostDangerousDamage = Damage;
					npcMostDangerousEnemy = npcEnemy;
				end
			end
		end

		if ( npcMostDangerousEnemy ~= nil )
		then
			return BOT_ACTION_DESIRE_HIGH, npcMostDangerousEnemy;
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
			if ( CanCast[3]( npcTarget ) and not npcTarget:IsSilenced() and GetUnitToUnitDistance(npcBot,npcTarget)< CastRange)
			then
				return BOT_ACTION_DESIRE_HIGH, npcTarget;
			end
		end
	end
	
	return BOT_ACTION_DESIRE_NONE, 0
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
	
	local CastRange = 1600;
	local Damage = ability:GetAbilityDamage();
	local Radius = ability:GetAOERadius()-300;
	local CastPoint = ability:GetCastPoint();
	
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange,true)
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
				if (HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana)
				then
					if not AbilitiesReal[1]:IsFullyCastable() or WeakestEnemy:GetModifierRemainingDuration( WeakestEnemy:GetModifierByName('modifier_kunkka_x_marks_the_spot') )< 1.2
					then
						return BOT_ACTION_DESIRE_HIGH,WeakestEnemy:GetExtrapolatedLocation(-2.9); 
					end
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

		local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( CastRange, true, BOT_MODE_NONE );
		for _,npcEnemy in pairs( tableNearbyEnemyHeroes )
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
			return BOT_ACTION_DESIRE_LOW, npcMostDangerousEnemy:GetLocation();
		end
	end

	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		 npcBot:GetActiveMode() == BOT_MODE_ATTACK) 
	then
		local npcEnemy = AbilityExtensions:GetTargetIfGood(npcBot)

		if ( npcEnemy ~= nil ) 
		then
			if ( CanCast[abilityNumber]( npcEnemy ))
			then
				if not AbilitiesReal[1]:IsFullyCastable() or npcEnemy:GetModifierRemainingDuration( npcEnemy:GetModifierByName('modifier_kunkka_x_marks_the_spot') )< 1.2
				then
					return BOT_ACTION_DESIRE_HIGH, npcEnemy:GetExtrapolatedLocation(-2.9);
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;
end

Consider[4] = function()
    local ability = AbilitiesReal[4]
    if not ability:IsFullyCastable() or ability:GetCurrentCharges() == 0 then
        return 0
    end
    local abilityLevel = ability:GetLevel()
    local castRange = ability:GetCastRange() + 200
    local radius = ability:GetAOERadius()
    local enemies = AbilityExtensions:GetNearbyHeroes(npcBot, castRange + radius)
    local realEnemies = AbilityExtensions:Filter(enemies, function(t) return AbilityExtensions:MayNotBeIllusion(npcBot, t) end)
    local targettableEnemies = AbilityExtensions:Filter(enemies, function(t) return AbilityExtensions:NormalCanCast(t, false) and not AbilityExtensions:CannotBeAttacked(t) end)
    local target = npcBot:GetTarget()

    if AbilityExtensions:GetEnemyHeroNumber(npcBot, enemies) >= 2 then
        return RemapValClamped(AbilityExtensions:GetEnemyHeroNumber(npcBot, enemies), 2, 4, 0.3, 0.9)
    end
    if AbilityExtensions:Contains(targettableEnemies, target) then
        return BOT_ACTION_DESIRE_MODERATE, true
    end
    return 0
end



--  this initialisation doesn't work, because ability values cannot be queried before they are learned
--local torrentDelay = AbilitiesReal[1]:GetSpecialValueFloat("delay")
--local xMarksReturnCastPoint = AbilitiesReal[1]:GetCastPoint()

Consider[7] = function()
    local abilityNumber=7
    local ability=AbilitiesReal[abilityNumber]
    if not ability:IsFullyCastable() or ability:IsHidden() or xMarkTarget == nil or not xMarkTarget:HasModifier("modifier_kunkka_x_marks_the_spot") then
        return 0
    end
    if xMarkTarget:IsChanneling() then
        return BOT_ACTION_DESIRE_VERYHIGH
    end
    if XMarksEnemy() and npcBot:GetActiveMode() ~= BOT_MODE_RETREAT and GetUnitToUnitDistance(npcBot, xMarkTarget) >= 1800 then
        return BOT_ACTION_DESIRE_HIGH
    end
    if XMarksEnemy() and npcBot:GetActiveMode() == BOT_MODE_RETREAT and (GetUnitToUnitDistance(npcBot, xMarkTarget) <= 300 or npcBot:WasRecentlyDamagedByHero(xMarkTarget, 1)) and DotaTime() > 1 + xMarkTime and GetUnitToLocationDistance(xMarkTarget, xMarkLocation) then
        return BOT_ACTION_DESIRE_HIGH
    end
	if XMarksEnemy() and useTorrentAtXMark then
		local timing = useTorrentAtXMarkTime + AbilitiesReal[1]:GetSpecialValueFloat("delay") - ability:GetCastPoint()
		print("Kunkka return: "..DotaTime().." "..timing)
		if DotaTime() >= timing-0.1 and DotaTime() <= timing+AbilitiesReal[1]:GetAOERadius()/xMarkTarget:GetVelocity() then
			return BOT_ACTION_DESIRE_VERYHIGH
		end
    end
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

    if xMarkTarget ~= nil and (DotaTime() > xMarkTime + xMarkDuration or not npcBot:IsAlive() or not xMarkTarget:IsAlive() or not xMarkTarget:HasModifier("modifier_kunkka_x_marks_the_target")) then
        xMarkTarget = nil
        xMarkTime = nil
        xMarkLocation = nil
        useTorrentAtXMark = false
        useTorrentAtXMarkTime = nil
    end

	local index, target = ability_item_usage_generic.UseAbility(AbilitiesReal,cast)
    if index == 3 and target ~= nil then
        xMarkTarget = target
        xMarkTime = DotaTime()+AbilitiesReal[3]:GetCastPoint()
        xMarkLocation = target:GetLocation()
		if target:GetTeam() == npcBot:GetTeam() then
			xMarkDuration = AbilitiesReal[3]:GetSpecialValueFloat("allied_duration") or 8
		else
			xMarkDuration = AbilitiesReal[3]:GetSpecialValueFloat("duration") or 4
		end

    elseif index == 1 and xMarkTarget and GetUnitToLocationDistance(xMarkTarget, target) <= 180 then
        useTorrentAtXMark = true
        useTorrentAtXMarkTime = DotaTime()+AbilitiesReal[1]:GetCastPoint()
    end
end

function CourierUsageThink() 
	ability_item_usage_generic.CourierUsageThink()
end