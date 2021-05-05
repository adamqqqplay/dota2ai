----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6 New Structure
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
--------------------------------------
-- General Initialization
--------------------------------------
local utility = require( GetScriptDirectory().."/utility" )
local AbilityHelper = dofile(GetScriptDirectory().."/util/AbilityHelper")
require(GetScriptDirectory() .. "/ability_item_usage_generic")
local AbilityExtensions = require(GetScriptDirectory() .. "/util/AbilityAbstraction")

local enableDebug = true
local npcBot = GetBot()
local talents = {}
local abilities = {}
local abilityHandles = {}

ability_item_usage_generic.InitAbility(abilities, abilityHandles, talents)

local abilityTree = {
	abilities[2],
	abilities[1],
	abilities[2],
	abilities[3],
	abilities[2],
	abilities[5],
	abilities[2],
	abilities[1],
	abilities[1],
	"talent",
	abilities[1],
	abilities[5],
	abilities[3],
	abilities[3],
	"talent",
	abilities[3],
	"nil",
	abilities[5],
	"nil",
	"talent",
	"nil",
	"nil",
	"nil",
	"nil",
	"talent"
}

local talentTree = {
	function()
		return talents[2]
	end,
	function()
		return talents[3]
	end,
	function()
		return talents[5]
	end,
	function()
		return talents[7]
	end
}

-- check skill build vs current level
utility.CheckAbilityBuild(abilityTree)

function AbilityLevelUpThink()
	ability_item_usage_generic.AbilityLevelUpThink2(abilityTree, talentTree)
end

--utility.PrintAbilityName(abilities)
local abilityName =  { "lich_frost_nova","lich_frost_shield","lich_sinister_gaze","lich_ice_spire","lich_chain_frost"}
local abilityIndexes = utility.ReverseTable(abilityName)


--------------------------------------
-- Ability Usage Thinking
--------------------------------------
local const = AbilityHelper.const

local comboMana
local comboDamage
local attackRange
local manaPercent
local healthPercent
local activeMode
local activeModeDesire

local caster = {Desire = {}, Target = {}, Type = {}}
local consider = {}
local CanCast = {
	AbilityHelper.normalCanCast,
	AbilityHelper.normalCanCast,
	AbilityHelper.normalCanCast,
    AbilityHelper.normalCanCast,
	AbilityHelper.ultimateCanCast
}
local isDisabled = AbilityHelper.isDisabled
local getComboDamage = AbilityHelper.getComboDamage
local getComboMana = AbilityHelper.getComboMana

consider[1] = function()
	--Target Ability Example
	local abilityIndex = 1
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability = abilityHandles[abilityIndex]

	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local castRange = ability:GetCastRange()
	local castPoint = ability:GetCastPoint()
	local damage = ability:GetAbilityDamage()
	local damageType = ability:GetDamageType()

	local serachDistance = Min(castRange + const.EXTRA_SEARCH_DISTANCE, const.MAX_SEARCH_DISTANCE)
	local isManaEnough = manaPercent > 0.6 or npcBot:GetMana() > comboMana
	local allys = npcBot:GetNearbyHeroes(const.MAX_ALLY_SEARCH_DISTANCE, false, BOT_MODE_NONE)
	local enemys = npcBot:GetNearbyHeroes(serachDistance, true, BOT_MODE_NONE)
	local weakestEnemy, heroHealth = AbilityHelper.getWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(serachDistance, true)
	local weakestCreep, creepHealth = AbilityHelper.getWeakestUnit(creeps)
	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------
	-- Try to kill enemy hero
	if (activeMode ~= BOT_MODE_RETREAT) then
		if (weakestEnemy ~= nil and CanCast[abilityIndex](weakestEnemy) and healthPercent > 0.4) then
			local realDamage = weakestEnemy:GetActualIncomingDamage(damage, damageType)
			local realcomboDamage = weakestEnemy:GetActualIncomingDamage(comboDamage, damageType)
			if (heroHealth <= realDamage or (heroHealth <= realcomboDamage and npcBot:GetMana() > comboMana)) then
				return BOT_ACTION_DESIRE_HIGH, weakestEnemy
			end
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	-- Protect myself
	local nearyByEnemys = npcBot:GetNearbyHeroes(const.WARNING_DISTANCE, true, BOT_MODE_NONE)
	if ((activeMode == BOT_MODE_RETREAT and activeModeDesire >= BOT_MODE_DESIRE_HIGH) or #nearyByEnemys > 0) then
		for _, npcEnemy in pairs(enemys) do
			if (CanCast[abilityIndex](npcEnemy)) then
				if
					(npcBot:WasRecentlyDamagedByHero(npcEnemy, 2.0) or GetUnitToUnitDistance(npcBot, npcEnemy) < const.WARNING_DISTANCE)
				 then
					return BOT_ACTION_DESIRE_HIGH, npcEnemy
				end
			end
		end
	end

	-- Attack roshan
	if (npcBot:GetActiveMode() == BOT_MODE_ROSHAN) then
		local npcTarget = npcBot:GetAttackTarget()
		if (AbilityHelper.isRoshan(npcTarget) and AbilityHelper.roshanCanCast(npcTarget)) then
			if (isManaEnough and GetUnitToUnitDistance(npcBot, npcTarget) <= castRange + const.EXTRA_SEARCH_DISTANCE) then
				return BOT_ACTION_DESIRE_LOW, npcTarget
			end
		end
	end

	-- If my mana is enough, use it at enemy
	if (activeMode == BOT_MODE_LANING) then
		if (weakestEnemy ~= nil and CanCast[abilityIndex](weakestEnemy)) then
			if (isManaEnough and ability:GetLevel() >= 1) then
				return BOT_ACTION_DESIRE_LOW, weakestEnemy
			end
		end
	end

	-- Get last hit
	if (activeMode == BOT_MODE_LANING) then
		if (weakestCreep ~= nil and CanCast[abilityIndex](weakestCreep)) then
			if (isManaEnough and GetUnitToUnitDistance(npcBot, weakestCreep) >= attackRange + 100) then
				if (creepHealth <= weakestCreep:GetActualIncomingDamage(damage, damageType)) then
					return BOT_ACTION_DESIRE_LOW, weakestCreep
				end
			end
		end
	end

	-- If we're farming
	if (activeMode == BOT_MODE_FARM) then
		if (#creeps >= 2 and CanCast[abilityIndex](weakestCreep)) then
			if (isManaEnough and creepHealth <= weakestCreep:GetActualIncomingDamage(damage, damageType)) then
				return BOT_ACTION_DESIRE_LOW, weakestCreep
			end
		end
	end

	-- If we're pushing or defending a lane
	if
		(npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
			npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or
			npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
			npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
			npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT)
	 then
		if (isManaEnough and abilityHandles[abilityIndex]:GetLevel() >= 1) then
			if (#enemys >= 1) then
				if (CanCast[abilityIndex](weakestEnemy)) then
					if (GetUnitToUnitDistance(npcBot, weakestEnemy) < castRange + 75 * #allys) then
						return BOT_ACTION_DESIRE_LOW, weakestEnemy
					end
				end
			end

			for _, creep in pairs(creeps) do
				if (CanCast[abilityIndex](creep) and GetUnitToUnitDistance(npcBot, creep) < castRange + 75 * #allys) then
					return BOT_ACTION_DESIRE_LOW, creep
				end
			end
		end
	end

	-- If we're going after someone
	if
		(npcBot:GetActiveMode() == BOT_MODE_ROAM or npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
			npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
			npcBot:GetActiveMode() == BOT_MODE_ATTACK)
	 then
		local npcEnemy = npcBot:GetTarget()

		if (AbilityHelper.isValidTarget(npcEnemy) and CanCast[abilityIndex](npcEnemy)) then
			if (GetUnitToUnitDistance(npcBot, npcEnemy) < castRange + 75 * #allys) then
				return BOT_ACTION_DESIRE_MODERATE, npcEnemy
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

consider[2] = function()
	--Target Ability Example
	local abilityIndex = 2
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability = abilityHandles[abilityIndex]

	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local castRange = ability:GetCastRange()
	local castPoint = ability:GetCastPoint()
	local damage = ability:GetAbilityDamage()
	local damageType = ability:GetDamageType()
	local radius = ability:GetAOERadius()
	assert(radius ~= nil, "can not get the radius")

	local serachDistance = Min(castRange + const.EXTRA_SEARCH_DISTANCE, const.MAX_SEARCH_DISTANCE)
	local isManaEnough = manaPercent > 0.6 or npcBot:GetMana() > comboMana
	local allys = npcBot:GetNearbyHeroes(const.MAX_ALLY_SEARCH_DISTANCE, false, BOT_MODE_NONE)
	local enemys = npcBot:GetNearbyHeroes(serachDistance, true, BOT_MODE_NONE)
	local weakestEnemy, heroHealth = AbilityHelper.getWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(serachDistance, true)
	local weakestCreep, creepHealth = AbilityHelper.getWeakestUnit(creeps)
	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------
	-- Protect ally
	if (activeMode == BOT_MODE_DEFEND_ALLY or activeMode == BOT_MODE_ATTACK) then
		local weakestAlly, allyHealth = AbilityHelper.getWeakestUnit(allys)
		if (weakestAlly ~= nil) then
			local allyNeaybyEnemys = weakestAlly:GetNearbyHeroes(radius, true, BOT_MODE_NONE)
			if
				(allyHealth / weakestAlly:GetMaxHealth() < 0.4 + 0.4 * manaPercent + #allyNeaybyEnemys * 0.05 or
					#allyNeaybyEnemys >= 2)
			 then
				return BOT_ACTION_DESIRE_MODERATE, weakestAlly
			end
		end

		for _, npcTarget in pairs(allys) do
			local allyNeaybyEnemys = npcTarget:GetNearbyHeroes(radius, true, BOT_MODE_NONE)
			if
				(npcTarget:GetHealth() / npcTarget:GetMaxHealth() < (0.6 + #enemys * 0.05 + 0.2 * manaPercent) or
					npcTarget:WasRecentlyDamagedByAnyHero(5.0) or
					#allyNeaybyEnemys >= 2)
			 then
				if (CanCast[abilityIndex](npcTarget)) then
					return BOT_ACTION_DESIRE_MODERATE, npcTarget
				end
			end
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	-- Protect myself
	local nearyByEnemys = npcBot:GetNearbyHeroes(const.WARNING_DISTANCE, true, BOT_MODE_NONE)
	if ((activeMode == BOT_MODE_RETREAT and activeModeDesire >= BOT_MODE_DESIRE_HIGH) or #nearyByEnemys > 0) then
		if (npcBot:WasRecentlyDamagedByAnyHero(2.0)) then
			return BOT_ACTION_DESIRE_HIGH, npcBot
		end
	end

	-- Attack roshan
	--if (npcBot:GetActiveMode() == BOT_MODE_ROSHAN) then
	--	local npcTarget
	--	for _, creep in pairs(creeps) do
	--		if (AbilityHelper.isRoshan(creep)) then
	--			npcTarget = creep
	--			break
	--		end
	--	end
    --
	--	local roshanTarget = npcTarget:GetAttackTarget()
	--	if (isManaEnough and AbilityHelper.isValidTarget(roshanTarget)) then
	--		return BOT_ACTION_DESIRE_HIGH, roshanTarget
	--	end
	--end

	-- If we're farming
	if (activeMode == BOT_MODE_FARM) then
		if (#creeps >= 2 and CanCast[abilityIndex](weakestCreep)) then
			if (isManaEnough) then
				return BOT_ACTION_DESIRE_LOW, npcBot
			end
		end
	end

	-- If we're pushing or defending a lane
	if
		(npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
			npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or
			npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
			npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
			npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT)
	 then
		local allyCreeps = npcBot:GetNearbyCreeps(serachDistance, false)
		local strongestAllyCreep = AbilityHelper.getStrongestUnit(allyCreeps)
		if (isManaEnough and abilityHandles[abilityIndex]:GetLevel() >= 1) then
			if (#allyCreeps >= 1) then
				if (CanCast[abilityIndex](strongestAllyCreep)) then
					if (GetUnitToUnitDistance(npcBot, strongestAllyCreep) < castRange + 75 * #allys) then
						return BOT_ACTION_DESIRE_LOW, strongestAllyCreep
					end
				end
			end
		end
	end

	-- If we're going after someone
	if
		(npcBot:GetActiveMode() == BOT_MODE_ROAM or npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
			npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
			npcBot:GetActiveMode() == BOT_MODE_ATTACK)
	 then
		local npcEnemy = AbilityExtensions:GetTargetIfGood(npcBot)

		if (AbilityHelper.isValidTarget(npcEnemy)) then
			local npcEnemyNearbyAllys = npcEnemy:GetNearbyHeroes(serachDistance, false, BOT_MODE_NONE)
			if (npcEnemyNearbyAllys ~= nil and #npcEnemyNearbyAllys >= 1) then
				for _, npcTarget in pairs(npcEnemyNearbyAllys) do
					if (GetUnitToUnitDistance(npcBot, npcTarget) <= castRange) then
						return BOT_ACTION_DESIRE_MODERATE, npcBot
					end
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

consider[3] = function()
	--Target Ability Example
	local abilityIndex = 3
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability = abilityHandles[abilityIndex]

	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local castRange = ability:GetCastRange()
	local castPoint = ability:GetCastPoint()
	local damage = ability:GetAbilityDamage()
	local damageType = ability:GetDamageType()

	local serachDistance = Min(castRange + const.EXTRA_SEARCH_DISTANCE, const.MAX_SEARCH_DISTANCE)
	local isManaEnough = manaPercent > 0.6 or npcBot:GetMana() > comboMana
	local allys = npcBot:GetNearbyHeroes(const.MAX_ALLY_SEARCH_DISTANCE, false, BOT_MODE_NONE)
	local enemys = npcBot:GetNearbyHeroes(serachDistance, true, BOT_MODE_NONE)
	local weakestEnemy, heroHealth = AbilityHelper.getWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(serachDistance, true)
	local weakestCreep, creepHealth = AbilityHelper.getWeakestUnit(creeps)
	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------
	-- Check for a channeling enemy
	for _, npcEnemy in pairs(enemys) do
		if (npcEnemy:IsChanneling() and CanCast[abilityIndex](npcEnemy)) then
			return BOT_ACTION_DESIRE_HIGH, npcEnemy
		end
	end

	-- If we're in a teamfight, use it on the scariest enemy
	local tableNearbyAttackingAlliedHeroes = npcBot:GetNearbyHeroes(const.MAX_ALLY_SEARCH_DISTANCE, false, BOT_MODE_ATTACK)
	if (#tableNearbyAttackingAlliedHeroes >= 2) then
		local npcMostDangerousEnemy = nil
		local mostDangerousDamage = 0

		for _, npcEnemy in pairs(enemys) do
			if (CanCast[abilityIndex](npcEnemy) and not isDisabled(npcEnemy)) then
				local realDamage = npcEnemy:GetEstimatedDamageToTarget(false, npcBot, 3.0, DAMAGE_TYPE_ALL)
				if (realDamage > mostDangerousDamage) then
					mostDangerousDamage = realDamage
					npcMostDangerousEnemy = npcEnemy
				end
			end
		end

		if (npcMostDangerousEnemy ~= nil) then
			return BOT_ACTION_DESIRE_HIGH, npcMostDangerousEnemy
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	-- Protect myself
	local nearyByEnemys = npcBot:GetNearbyHeroes(const.WARNING_DISTANCE, true, BOT_MODE_NONE)
	if ((activeMode == BOT_MODE_RETREAT and activeModeDesire >= BOT_MODE_DESIRE_HIGH) or #nearyByEnemys > 0) then
		for _, npcEnemy in pairs(enemys) do
			if (CanCast[abilityIndex](npcEnemy) and not isDisabled(npcEnemy)) then
				if
					(npcBot:WasRecentlyDamagedByHero(npcEnemy, 2.0) or GetUnitToUnitDistance(npcBot, npcEnemy) < const.WARNING_DISTANCE)
				 then
					return BOT_ACTION_DESIRE_HIGH, npcEnemy
				end
			end
		end
	end

	-- Attack roshan
	if (npcBot:GetActiveMode() == BOT_MODE_ROSHAN) then
		local npcTarget = npcBot:GetAttackTarget()
		if (AbilityHelper.isRoshan(npcTarget) and AbilityHelper.roshanCanCast(npcTarget) and not isDisabled(npcTarget)) then
			if (isManaEnough and GetUnitToUnitDistance(npcBot, npcTarget) <= castRange + const.EXTRA_SEARCH_DISTANCE) then
				return BOT_ACTION_DESIRE_LOW, npcTarget
			end
		end
	end

	-- If we're going after someone
	if
		(npcBot:GetActiveMode() == BOT_MODE_ROAM or npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
			npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
			npcBot:GetActiveMode() == BOT_MODE_ATTACK)
	 then
		local npcEnemy = npcBot:GetTarget()

		if (AbilityHelper.isValidTarget(npcEnemy) and CanCast[abilityIndex](npcEnemy) and not isDisabled(npcEnemy)) then
			if (GetUnitToUnitDistance(npcBot, npcEnemy) < castRange + 75 * #allys) then
				return BOT_ACTION_DESIRE_MODERATE, npcEnemy
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

-- copied from terrorblade_reflection

consider[4]=function()

    local abilityNumber=4
    --------------------------------------
    -- Generic Variable Setting
    --------------------------------------
    local ability=abilityHandles[abilityNumber];

    if not ability:IsFullyCastable() then
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
                    return BOT_ACTION_DESIRE_LOW, npcEnemy:GetExtrapolatedLocation(CastPoint);
                end
            end
        end
    end

    -- If we're going after someone
    if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
            npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
            npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
            npcBot:GetActiveMode() == BOT_MODE_ATTACK)
    then
        local locationAoE = npcBot:FindAoELocation( true, true, npcBot:GetLocation(), CastRange, Radius, 0, 0 );
        if ( locationAoE.count >= 3 ) then
            return BOT_ACTION_DESIRE_LOW+0.05, locationAoE.targetloc;
        end

        local npcEnemy = npcBot:GetTarget()

        if ( npcEnemy ~= nil )
        then
            if ( CanCast[abilityNumber]( npcEnemy ) )
            then
                return BOT_ACTION_DESIRE_LOW, npcEnemy:GetExtrapolatedLocation(CastPoint);
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0

end

consider[5] = function()
	--Target Ability Example
	local abilityIndex = 5
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability = abilityHandles[abilityIndex]

	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local castRange = ability:GetCastRange()
	local castPoint = ability:GetCastPoint()
	local damage = ability:GetAbilityDamage()
	local damageType = ability:GetDamageType()

	local serachDistance = Min(castRange + const.EXTRA_SEARCH_DISTANCE, const.MAX_SEARCH_DISTANCE)
	local isManaEnough = manaPercent > 0.6 or npcBot:GetMana() > comboMana
	local allys = npcBot:GetNearbyHeroes(const.MAX_ALLY_SEARCH_DISTANCE, false, BOT_MODE_NONE)
	local enemys = npcBot:GetNearbyHeroes(serachDistance, true, BOT_MODE_NONE)
	local weakestEnemy, heroHealth = AbilityHelper.getWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(serachDistance, true)
	local weakestCreep, creepHealth = AbilityHelper.getWeakestUnit(creeps)
	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------
	-- If we're in a teamfight, use it on the scariest enemy
	local tableNearbyAttackingAlliedHeroes = npcBot:GetNearbyHeroes(const.MAX_ALLY_SEARCH_DISTANCE, false, BOT_MODE_ATTACK)
	if (#tableNearbyAttackingAlliedHeroes >= 2) then
		local npcMostDangerousEnemy = nil
		local mostDangerousDamage = 0

		for _, npcEnemy in pairs(enemys) do
			if (CanCast[abilityIndex](npcEnemy) and not isDisabled(npcEnemy)) then
				local realDamage = npcEnemy:GetEstimatedDamageToTarget(false, npcBot, 3.0, DAMAGE_TYPE_ALL)
				if (realDamage > mostDangerousDamage) then
					mostDangerousDamage = realDamage
					npcMostDangerousEnemy = npcEnemy
				end
			end
		end

		if (npcMostDangerousEnemy ~= nil) then
			return BOT_ACTION_DESIRE_HIGH, npcMostDangerousEnemy
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	-- Protect myself
	local nearyByEnemys = npcBot:GetNearbyHeroes(const.WARNING_DISTANCE, true, BOT_MODE_NONE)
	if ((activeMode == BOT_MODE_RETREAT and activeModeDesire >= BOT_MODE_DESIRE_HIGH) or #nearyByEnemys > 0) then
		for _, npcEnemy in pairs(enemys) do
			if (CanCast[abilityIndex](npcEnemy) and not isDisabled(npcEnemy)) then
				if
					(npcBot:WasRecentlyDamagedByHero(npcEnemy, 2.0) or GetUnitToUnitDistance(npcBot, npcEnemy) < const.WARNING_DISTANCE)
				 then
					return BOT_ACTION_DESIRE_HIGH, npcEnemy
				end
			end
		end
	end

	-- If we're going after someone
	if
		(npcBot:GetActiveMode() == BOT_MODE_ROAM or npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
			npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
			npcBot:GetActiveMode() == BOT_MODE_ATTACK)
	 then
		local npcEnemy = AbilityExtensions:GetTargetIfGood(npcBot)

		if (AbilityHelper.isValidTarget(npcEnemy) and CanCast[abilityIndex](npcEnemy) and not isDisabled(npcEnemy)) then
			if (GetUnitToUnitDistance(npcBot, npcEnemy) < castRange + 75 * #allys) then
				return BOT_ACTION_DESIRE_MODERATE, npcEnemy
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end


AbilityExtensions:AutoModifyConsiderFunction(npcBot, consider, abilityHandles)


function AbilityUsageThink()
	-- Check if we're already using an ability
	if (npcBot:IsUsingAbility() or npcBot:IsChanneling() or npcBot:IsSilenced()) then
		return
	end

	comboMana = getComboMana(abilityHandles)
	comboDamage = getComboDamage(abilityHandles)
	attackRange = npcBot:GetAttackRange()
	manaPercent = npcBot:GetMana() / npcBot:GetMaxMana()
	healthPercent = npcBot:GetHealth() / npcBot:GetMaxHealth()
	activeMode = npcBot:GetActiveMode()
	activeModeDesire = npcBot:GetActiveModeDesire()

	caster = ability_item_usage_generic.ConsiderAbility(abilityHandles, consider)
	---------------------------------debug--------------------------------------------
	if (enableDebug == true) then
		ability_item_usage_generic.PrintDebugInfo(abilityHandles, caster)
	end
	ability_item_usage_generic.UseAbility(abilityHandles, caster)
end

function CourierUsageThink()
	ability_item_usage_generic.CourierUsageThink()
end
