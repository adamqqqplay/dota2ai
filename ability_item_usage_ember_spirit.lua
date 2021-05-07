----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.3 New Structure
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
-- v1.7 template by AaronSong321
local utility = require(GetScriptDirectory().."/utility")
require(GetScriptDirectory() ..  "/ability_item_usage_generic")
local AbilityExtensions = require(GetScriptDirectory().."/util/AbilityAbstraction")

local npcBot = GetBot()
if npcBot:IsIllusion() then
    return
end
local AbilityNames, Abilities, Talents = AbilityExtensions:InitAbility(npcBot)
--local CanCast = {utility.NCanCast,utility.UCanCast,utility.NCanCast,utility.UCanCast,utility.UCanCast}

local AbilityToLevelUp =
{
    AbilityNames[2],
    AbilityNames[3],
	AbilityNames[3],
	AbilityNames[1],
	AbilityNames[3],
	AbilityNames[5],
	AbilityNames[3],
	AbilityNames[2],
	AbilityNames[2],
	"talent",
	AbilityNames[2],
	AbilityNames[1],
	AbilityNames[1],
	AbilityNames[1],
	"talent",
	AbilityNames[5],
	"nil",
	AbilityNames[5],
	"nil",
	"talent",
	"nil",
	"nil",
	"nil",
	"nil",
	"talent",
}
local TalentTree = {
	function()
		return Talents[1]
	end,
	function()
		return Talents[4]
	end,
	function()
		return Talents[5]
	end,
	function()
		return Talents[8]
	end
}
utility.CheckAbilityBuild(AbilityToLevelUp)

function AbilityLevelUpThink()
    ability_item_usage_generic.AbilityLevelUpThink2(AbilityToLevelUp, TalentTree)
end

local cast= {} cast.Desire= {} cast.Target= {} cast.Type= {}
local Consider = {}


local attackRange
local healthPercent
local mana
local manaPercent

local function IsUsingSleightOfFist()
    return npcBot:HasModifier("modifier_ember_spirit_sleight_of_fist_in_progress")
end
local function IsUsingRemnant()
    return npcBot:HasModifier("modifier_ember_spirit_fire_remnant")
end
local fistCastLocation

Consider[1] = function()
    local ability = Abilities[1]
    if not ability:IsFullyCastable() then
        return 0
    end
    local abilityLevel = ability:GetLevel()
    local castRange = ability:GetCastRange()
    local castPoint = ability:GetCastPoint()
    local manaCost = ability:GetManaCost()
    local duration = ability:GetDuration()
    local enemies = AbilityExtensions:GetNearbyHeroes(npcBot, castRange)
    local realEnemies = AbilityExtensions:Filter(enemies, function(t) return AbilityExtensions:MayNotBeIllusion(npcBot, t) end)
    local targettableEnemies = AbilityExtensions:Filter(realEnemies, function(t) return AbilityExtensions:NormalCanCast(t, true) end)
    local friends = AbilityExtensions:GetNearbyHeroes(npcBot, 1200, true)
    local friendCount = AbilityExtensions:GetEnemyHeroNumber(npcBot, friends)
    local enemyCreeps = AbilityExtensions:GetNearbyAttackableCreeps(npcBot, castRange)
    local friendCreeps = AbilityExtensions:GetNearbyAttackableCreeps(npcBot, npcBot:GetAttackRange()+150, false)
    local neutralCreeps = npcBot:GetNearbyNeutralCreeps(castRange)
    local damage = ability:GetSpecialValueInt("total_damage")
    local weakestEnemy, enemyHealth = utility.GetWeakestUnit(targettableEnemies)
    local weakCreeps = AbilityExtensions:Filter(enemyCreeps, function(t) return t:GetHealth() < t:GetActualIncomingDamage(damage, DAMAGE_TYPE_MAGICAL) end)
    local weakestCreep = utility.GetWeakestUnit(weakCreeps)
    local forbiddenCreeps = AbilityExtensions:Filter(enemyCreeps, function(t)
        return t:GetHealth() > t:GetActualIncomingDamage(damage, DAMAGE_TYPE_MAGICAL) and t:GetHealth() <= t:GetActualIncomingDamage(damage, DAMAGE_TYPE_MAGICAL) + AbilityExtensions:AttackOnceDamage(npcBot, t) * (0.9+#enemyCreeps*0.1)
    end)
    if #friendCreeps == 0 then
        forbiddenCreeps = {}
    end

    local unitCount = ability:GetSpecialValueInt("unit_count")
    local allNearbyTargettableEnemies = AbilityExtensions:Concat(targettableEnemies, enemyCreeps, neutralCreeps)
    allNearbyTargettableEnemies = AbilityExtensions:Count(enemies, function(t) return not t:IsInvulnerable() and not t:IsMagicImmune()  end)
    local fistBonus = 1
    if IsUsingSleightOfFist() and fistCastLocation ~= nil and GetUnitToLocationDistance(npcBot, fistCastLocation) >= Abilities[2]:GetCastRange()-200 then
        fistBonus = 2
    end
    local goodTargets = AbilityExtensions:Count(targettableEnemies, function(t) return t:IsChanneling() end) * fistBonus
    goodTargets = goodTargets + AbilityExtensions:GetEnemyHeroNumber(npcBot, targettableEnemies) * 0.3 * fistBonus
    goodTargets = goodTargets + AbilityExtensions:Count(targettableEnemies, function(t) return AbilityExtensions:GetHealthPercent(t) <= duration/5+0.1*friendCount end)
    if allNearbyTargettableEnemies ~= 1 then
        goodTargets = goodTargets * unitCount / allNearbyTargettableEnemies
    end

    if AbilityExtensions:IsLaning(npcBot) then
        if manaPercent >= 0.5 + manaCost and goodTargets >= manaPercent or goodTargets >= 0.8 then
            return BOT_ACTION_DESIRE_HIGH
        end
    elseif AbilityExtensions:IsAttackingEnemies(npcBot) then
        if friendCount >= 2 and #enemies <= 2 then
            return BOT_ACTION_DESIRE_HIGH
        end
        if manaPercent >= 0.2 + manaCost and goodTargets >= 1 then
            return BOT_ACTION_DESIRE_MODERATE
        end
    elseif AbilityExtensions:IsFarmingOrPushing(npcBot) then
        if manaPercent >= 0.8 + manaCost and allNearbyTargettableEnemies >= 2 then
            return BOT_ACTION_DESIRE_MODERATE
        end
    elseif AbilityExtensions:IsRetreating(npcBot) then
        if allNearbyTargettableEnemies <= 3 and #targettableEnemies >= 1 then
            return BOT_ACTION_DESIRE_HIGH
        end
    end
    return 0
end

Consider[2] = function()
    local ability = Abilities[2]
    if not ability:IsFullyCastable() or IsUsingRemnant() or IsUsingSleightOfFist() or AbilityExtensions:CannotMove(npcBot) or ability:GetCurrentCharges() == 0 then
        return 0
    end
    local abilityLevel = ability:GetLevel()
    local castRange = ability:GetCastRange() + 100
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
    local creepDamage = npcBot:GetAttackDamage() * (1 + ability:GetSpecialValueInt("creep_damage_penalty") / 100)
    local weakCreeps = AbilityExtensions:Filter(enemyCreeps, function(t) return t:GetHealth() < t:GetActualIncomingDamage(creepDamage, DAMAGE_TYPE_MAGICAL) end)
    local weakestCreep = utility.GetWeakestUnit(weakCreeps)
    local forbiddenCreeps = AbilityExtensions:Filter(enemyCreeps, function(t)
        return t:GetHealth() > t:GetActualIncomingDamage(creepDamage, DAMAGE_TYPE_MAGICAL) and t:GetHealth() <= t:GetActualIncomingDamage(creepDamage, DAMAGE_TYPE_MAGICAL) + AbilityExtensions:AttackOnceDamage(npcBot, t) * (0.9+#enemyCreeps*0.1)
    end)
    if #friendCreeps == 0 then
        forbiddenCreeps = {}
    end
    local damage = npcBot:GetAttackDamage() + ability:GetSpecialValueInt("bonus_hero_damage")
    if AbilityExtensions:GetAvailableItem(npcBot, "item_lesser_crit") then
        damage = damage * 1.7
    elseif AbilityExtensions:GetAvailableItem(npcBot, "item_greater_crit") then
        damage = damage * 2.3
    end
    local hasBattleFury = AbilityExtensions:GetAvailableItem(npcBot, "item_bfury") ~= nil

    local projectiles = AbilityExtensions:GetIncomingDodgeWorthProjectiles(npcBot) or {}
    projectiles = AbilityExtensions:Any(projectiles, function(t) return GetUnitToLocationDistance(npcBot, t.location) <= 200  end)
    if projectiles then
        local locationAoE = npcBot:FindAoELocation(true, false, npcBot:GetLocation(), castRange+60, radius, 0, 0)
        if locationAoE.count >= 2 then
            return BOT_ACTION_DESIRE_HIGH, locationAoE.targetloc
        end
    end
    if AbilityExtensions:IsFarmingOrPushing(npcBot) then
        local locationAoE = npcBot:FindAoELocation(true, false, npcBot:GetLocation(), castRange+150, radius, 0, 0)
        if hasBattleFury and (locationAoE.count >= 4 and manaPercent >= 0.3 + manaCost or locationAoE.count >= 3 and manaPercent >= 0.6 + manaCost) then
            return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc
        end
    elseif AbilityExtensions:IsLaning(npcBot) then
        if manaPercent >= 0.6 + manaCost and #enemies == 1 and enemies[1]:CanBeSeen() and healthPercent >= 0.8 and abilityLevel >= 3 then
            return BOT_ACTION_DESIRE_HIGH, AbilityExtensions:FindAOELocationAtSingleTarget(npcBot, enemies[1], radius, castRange, castPoint)
        end
        if manaPercent >= 0.3 and #enemies == 1 and enemies[1]:CanBeSeen() and healthPercent >= 0.75 and abilityLevel >= 4 then
            return BOT_ACTION_DESIRE_HIGH, AbilityExtensions:FindAOELocationAtSingleTarget(npcBot, enemies[1], radius, castRange, castPoint)
        end
    end
    if AbilityExtensions:NotRetreating(npcBot) then
        local findPlace = npcBot:FindAoELocation(true, true, npcBot:GetLocation(), castRange+100, radius, 0, 0)
        if findPlace.count >= 3 then
            if GetUnitToLocationDistance(npcBot, findPlace.targetloc) <= castRange then
                return BOT_ACTION_DESIRE_VERYHIGH, findPlace.targetloc
            else
                return BOT_ACTION_DESIRE_MODERATE + 0.05, findPlace.targetloc
            end
        elseif findPlace.count >= 2 then
            return BOT_ACTION_DESIRE_MODERATE, findPlace.targetloc
        end

        if weakestEnemy ~= nil and enemyHealth ~= -1 then
            local damageTaken = weakestEnemy:GetActualIncomingDamage(damage, DAMAGE_TYPE_PHYSICAL)
            if enemyHealth <= damageTaken or enemyHealth <= damageTaken * 1.5 and mana > 200 + manaCost then
                local targetLocation = AbilityExtensions:FindAOELocationAtSingleTarget(npcBot, weakestEnemy, radius, castRange, castPoint)
                return BOT_ACTION_DESIRE_HIGH, targetLocation
            end
        end

        local target = npcBot:GetTarget()
        if target ~= nil and target:CanBeSeen() and AbilityExtensions:NormalCanCast(target, true, DAMAGE_TYPE_PHYSICAL) and not AbilityExtensions:CannotBeAttacked(target)
                and (mana >= 200 and target:GetHealth() < target:GetActualIncomingDamage(damage, DAMAGE_TYPE_PHYSICAL) * (0.9 + friendCount*0.1)) then
            return BOT_ACTION_DESIRE_HIGH, AbilityExtensions:FindAOELocationAtSingleTarget(npcBot, target, radius, castRange, castPoint)
        end
    end
    return 0
end

Consider[3] = function()
    local ability = Abilities[3]
    if not ability:IsFullyCastable() or npcBot:HasModifier("modifier_ember_spirit_flame_guard") or npcBot:HasModifier("modifier_shadow_demon_purge_slow") then
        return 0
    end
    local abilityLevel = ability:GetLevel()
    local castRange = ability:GetCastRange()
    local radius = ability:GetAOERadius()
    local castPoint = ability:GetCastPoint()
    local manaCost = ability:GetManaCost()
    local duration = ability:GetDuration()
    local enemies = AbilityExtensions:GetNearbyHeroes(npcBot, radius)
    local realEnemies = AbilityExtensions:Filter(enemies, function(t) return AbilityExtensions:MayNotBeIllusion(npcBot, t) end)
    local targettableEnemies = AbilityExtensions:Filter(realEnemies, function(t) return AbilityExtensions:NormalCanCast(t) end)
    local friends = AbilityExtensions:GetNearbyHeroes(npcBot, 1200, true)
    local friendCount = AbilityExtensions:GetEnemyHeroNumber(npcBot, friends)
    local enemyCreeps = AbilityExtensions:GetNearbyAttackableCreeps(npcBot, 900)
    local friendCreeps = AbilityExtensions:GetNearbyAttackableCreeps(npcBot, npcBot:GetAttackRange()+150, false)
    local neutralCreeps = npcBot:GetNearbyNeutralCreeps(castRange)
    local weakestEnemy, enemyHealth = utility.GetWeakestUnit(targettableEnemies)
    local weakCreeps = enemyCreeps
    local weakestCreep = utility.GetWeakestUnit(weakCreeps)
    local forbiddenCreeps = {}
    local manaMaintain = npcBot:GetMaxMana() * 0.6 + manaCost
    if AbilityExtensions:IsFarmingOrPushing(npcBot) then
        if #enemies == 0 and #enemyCreeps >= 5 and mana >= manaMaintain and abilityLevel >= 3 then
            return BOT_ACTION_DESIRE_MODERATE - 0.08
        end
    elseif AbilityExtensions:IsLaning(npcBot) then
        if #enemyCreeps >= 3 and mana >= npcBot:GetMaxMana() * 0.3 + manaCost then
            local laneEnemyHero = enemies[1]
            if laneEnemyHero ~= nil and GetUnitToUnitDistance(npcBot, laneEnemyHero) <= radius and AbilityExtensions:GetHealthPercent(laneEnemyHero) <= 0.4 then
                return BOT_ACTION_DESIRE_MODERATE
            end
			if #friendCreeps == 0 and abilityLevel >= 2 then
				return BOT_ACTION_DESIRE_MODERATE
			end
        end
    elseif AbilityExtensions:IsAttackingEnemies(npcBot) then
        if abilityLevel <= 2 then
            return 0
        end
        if IsUsingSleightOfFist() then
            local sleightFistMarkedHeroes = AbilityExtensions:Count(enemies, function(t) return t:HasModifier("modifier_ember_spirit_sleight_of_fist_mark")  end)
            if sleightFistMarkedHeroes >= 3 then
                return BOT_ACTION_DESIRE_HIGH
            end
        else
            if not npcBot:IsMagicImmune() then
                local projectiles = AbilityExtensions:GetIncomingDodgeWorthProjectiles(npcBot)
                projectiles = AbilityExtensions:Any(projectiles, function(t) return GetUnitToLocationDistance(npcBot, t.location) <= 400  end)
                if projectiles then
                    return BOT_ACTION_DESIRE_MODERATE
                end
            end
            if #enemies >= 1 and DotaTime() < 10 * 60 or #realEnemies >= 2 and npcBot:GetNetWorth() / DotaTime() * 60 <= 350 or #realEnemies >= 3 then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    elseif AbilityExtensions:IsRetreating(npcBot) then
        local projectiles = AbilityExtensions:GetIncomingDodgeWorthProjectiles(npcBot)
        projectiles = AbilityExtensions:Any(projectiles, function(t) return GetUnitToLocationDistance(npcBot, t.location) <= 400  end)
        if projectiles and abilityLevel >= 3 then
            return BOT_ACTION_DESIRE_MODERATE
        end
    end
    do
        local target = npcBot:GetTarget()
        if target ~= nil and target:CanBeSeen() and not AbilityExtensions:NormalCanCast(target) and GetUnitToUnitDistance(npcBot, target) < radius - 50 and abilityLevel >= 3 then
            return BOT_ACTION_DESIRE_MODERATE
        end
    end
end

local activeRemnants
local refreshRemnantToken
local function RefreshActiveRemnants()
    activeRemnants = AbilityExtensions:Filter(GetUnitList(UNIT_LIST_ALL), function(t) return t:GetUnitName() == "npc_dota_ember_spirit_remnant" end)
end
local DetectRemnant = AbilityExtensions:EveryManySeconds(2, RefreshActiveRemnants)
RefreshActiveRemnants()

Consider[4] = function()
	local ability = Abilities[4]
    if not ability:IsFullyCastable() or IsUsingSleightOfFist() or IsUsingRemnant() or AbilityExtensions:CannotMove(npcBot) then
        return 0
    end
    DetectRemnant()
    if #activeRemnants == 0 then
        return 0
    end
    local abilityLevel = ability:GetLevel()
    local radius = ability:GetAOERadius()-100
    local castPoint = ability:GetCastPoint()
    local manaCost = ability:GetManaCost()
    local duration = ability:GetDuration()
    local damage = ability:GetAbilityDamage()
    local enemyCreeps = AbilityExtensions:GetNearbyAttackableCreeps(npcBot, 900)
    local friendCreeps = AbilityExtensions:GetNearbyAttackableCreeps(npcBot, npcBot:GetAttackRange()+150, false)
    local weakCreeps = AbilityExtensions:Filter(enemyCreeps, function(t) return t:GetHealth() < t:GetActualIncomingDamage(damage, DAMAGE_TYPE_MAGICAL) end)
    local weakestCreep = utility.GetWeakestUnit(weakCreeps)
    local forbiddenCreeps = AbilityExtensions:Filter(enemyCreeps, function(t)
        return t:GetHealth() > t:GetActualIncomingDamage(damage, DAMAGE_TYPE_MAGICAL) and t:GetHealth() <= t:GetActualIncomingDamage(damage, DAMAGE_TYPE_MAGICAL) + AbilityExtensions:AttackOnceDamage(npcBot, t) * (0.9+#enemyCreeps*0.1)
    end)
    if #friendCreeps == 0 then
        forbiddenCreeps = {}
	end

	if AbilityExtensions:IsFarmingOrPushing(npcBot) and AbilityExtensions:GetManaPercent(npcBot) >= 0.9 then
		for _, activeRemnant in ipairs(activeRemnants) do
			if #weakCreeps >= 3 and #forbiddenCreeps == 0 then
				return BOT_ACTION_DESIRE_MODERATE, activeRemnant:GetLocation()
			end
		end
	end

	if healthPercent >= 0.75 and manaPercent >= 0.9 and AbilityExtensions:GetDistanceFromAncient(npcBot) <= 1000 and DotaTime() <= 15 * 60 then
		if AbilityExtensions:IsLaning(npcBot) then
			local laneFront = GetLaneFrontLocation(GetTeam(), npcBot:GetAssignedLane(), 0)
			local remnantUnderTower = AbilityExtensions:Filter(activeRemnants, function(t) return GetUnitToUnitDistance(t, laneFront) <= 1000 end)
			if remnantUnderTower[1] then
				return BOT_ACTION_DESIRE_MODERATE, remnantUnderTower[1]:GetLocation()
			end
		elseif AbilityExtensions:IsFarmingOrPushing(npcBot) then
			local remnantUnderTower = AbilityExtensions:Filter(activeRemnants, function(t)
				return GetUnitToUnitDistance(t, npcBot) >= 4000 and #AbilityExtensions:GetNearbyNonIllusionHeroes(t) == 0
			end)
			if remnantUnderTower[1] then
				return BOT_ACTION_DESIRE_MODERATE, remnantUnderTower[1]:GetLocation()
			end
		elseif AbilityExtensions:IsAttackingEnemies(npcBot) then
			for _, activeRemnant in ipairs(activeRemnants) do
				local enemies = AbilityExtensions:GetNearbyHeroes(activeRemnant, 1599)
				local enemyCount = AbilityExtensions:GetEnemyHeroNumber(npcBot, enemies)
				local friends = AbilityExtensions:GetNearbyHeroes(activeRemnant, 1200, true)
				local friendCount = AbilityExtensions:GetEnemyHeroNumber(npcBot, friends)
				local veryNearEnemies = AbilityExtensions:GetEnemyHeroNumber(npcBot, AbilityExtensions:GetNearbyHeroes(activeRemnant, 400))
				if friendCount >= enemyCount and #veryNearEnemies == 0 then
					return BOT_ACTION_DESIRE_MODERATE, activeRemnant:GetLocation()
				end
			end
		end
	end

    if AbilityExtensions:IsRetreating(npcBot) then
        local distanceToFountain = AbilityExtensions:Filter(activeRemnants, function(t) 
            local distance = GetUnitToUnitDistance(t, npcBot)
            return distance >= npcBot:GetCurrentMovementSpeed() * 2 and distance > AbilityExtensions:GetDistanceFromAncient(t) + 600
        end)
        distanceToFountain = AbilityExtensions:Map(distanceToFountain, function(t) return { t, AbilityExtensions:GetDistanceFromAncient(t) } end)
        distanceToFountain = AbilityExtensions:SortByMinFirst(distanceToFountain, function(t) return t[2] end)
        if AbilityExtensions:Any(distanceToFountain) then
            return BOT_ACTION_DESIRE_HIGH, distanceToFountain[1][1]:GetLocation()
        end

    else
        for _, activeRemnant in ipairs(activeRemnants) do
            local target = AbilityExtensions:GetTargetIfGood(npcBot)
            if target ~= nil and target:CanBeSeen() and AbilityExtensions:NormalCanCast(target, false) and GetUnitToUnitDistance(activeRemnant, target) <= radius then
                if AbilityExtensions:GetHealthPercent(target) <= 0.7 then
                    if AbilityExtensions:Any(activeRemnants, function(t)
                        local d = GetUnitToUnitDistance(t, target)
                        return d >= 0.7*radius and d <= 800 and t:IsFacingLocation(target, 30) and t:GetCurrentMovementSpeed() ~= 0
                    end) then
                        return 0.1, activeRemnant:GetLocation()
                    end
                    return RemapValClamped(AbilityExtensions:GetHealthPercent(target), 0, 0.7, 0.9, 0.5), activeRemnant:GetLocation()
                end
            end
            local enemies = AbilityExtensions:GetNearbyNonIllusionHeroes(activeRemnant)
            local realEnemies = AbilityExtensions:Filter(enemies, function(t) return
                AbilityExtensions:MayNotBeIllusion(npcBot, t) and AbilityExtensions:NormalCanCast(t, false)
            end)
        end
    end
	return 0  
end

local function ShouldGoToFountainFromLane()
    return healthPercent <= 0.25 and not AbilityExtensions:HasAvailableItem("item_flask") or healthPercent <= 0.4 and manaPercent <= 0.1
end

Consider[5] = function()
    local ability = Abilities[5]
    if not ability:IsFullyCastable() or ability:GetCurrentCharges() == 0 then
        return 0
    end
    local abilityLevel = ability:GetLevel()
    local castRange = ability:GetCastRange()
    local radius = ability:GetAOERadius()-100
    local castPoint = ability:GetCastPoint()
    local manaCost = ability:GetManaCost()
    local duration = ability:GetDuration()
    local damage = Abilities[4]:GetAbilityDamage()
    local friends = AbilityExtensions:GetNearbyHeroes(npcBot, 1200, true)
    local friendCount = AbilityExtensions:GetEnemyHeroNumber(npcBot, friends)
    local enemyCreeps = AbilityExtensions:GetNearbyAttackableCreeps(npcBot, 900)
    local friendCreeps = AbilityExtensions:GetNearbyAttackableCreeps(npcBot, npcBot:GetAttackRange()+150, false)
    local neutralCreeps = npcBot:GetNearbyNeutralCreeps(castRange)
    local weakCreeps = AbilityExtensions:Filter(enemyCreeps, function(t) return t:GetHealth() < t:GetActualIncomingDamage(damage, DAMAGE_TYPE_MAGICAL) end)
    local weakestCreep = utility.GetWeakestUnit(weakCreeps)
    local forbiddenCreeps = AbilityExtensions:Filter(enemyCreeps, function(t)
        return t:GetHealth() > t:GetActualIncomingDamage(damage, DAMAGE_TYPE_MAGICAL) and t:GetHealth() <= t:GetActualIncomingDamage(damage, DAMAGE_TYPE_MAGICAL) + AbilityExtensions:AttackOnceDamage(npcBot, t) * (0.9+#enemyCreeps*0.1)
    end)
    if #friendCreeps == 0 then
        forbiddenCreeps = {}
    end
    local charge = ability:GetCurrentCharges()
    if charge == 0 then
        return 0
    end
    local remnantSpeed = npcBot:GetCurrentMovementSpeed() * ability:GetSpecialValueInt("speed_multiplier") / 100

    if AbilityExtensions:IsFarmingOrPushing(npcBot) and AbilityExtensions:GetManaPercent(npcBot) >= 0.9 then
        local nearbyTowers = npcBot:GetNearbyTowers(1100, true)
        if #nearbyTowers == 1 and (nearbyTowers[1] == GetTower(GetTeam(), TOWER_MID_1) or nearbyTowers[1] == GetTower(GetTeam(), TOWER_MID_2)) then
            if ShouldGoToFountainFromLane() then
                if #activeRemnants == 0 then
                    return BOT_ACTION_DESIRE_HIGH, nearbyTowers[1]:GetLocation() + RandomVector(200)
                else
                    local enemies = AbilityExtensions:GetNearbyHeroes(npcBot, 800)
                    local realEnemies = AbilityExtensions:Filter(enemies, function(t) return AbilityExtensions:MayNotBeIllusion(npcBot, t) end)
                    if #realEnemies == 0 then
                        AbilityExtensions:TryUseTp(npcBot)
                    end
                end
            end
        end
    end

    if AbilityExtensions:IsRetreating(npcBot) then
        if IsUsingRemnant() then
            return 0
        end
        local enemies = AbilityExtensions:GetNearbyHeroes(npcBot)
        if npcBot:WasRecentlyDamagedByAnyHero(1.5) and #enemies ~= 0 then
            if #activeRemnants ~= 0 then
                return 0
            end
            local useRange = castRange - 80
            local nearestEnemy = enemies[1]
            local strangeFacing = npcBot:GetFacing()
            if nearestEnemy:IsFacingLocation(npcBot:GetLocation(), 20) then
                strangeFacing = nearestEnemy:GetFacing() + 75
            end
            local extraLocation = npcBot:GetLocation() + Vector(useRange * math.cos(strangeFacing), useRange * math.sin(strangeFacing))
            if npcBot:HasScepter() then
                extraLocation = AbilityExtensions:GetPointFromLineByDistance(npcBot:GetLocation(), AbilityExtensions:GetAncient(npcBot), useRange)
            end
            if npcBot:GetCurrentMovementSpeed() >= 285 or npcBot:GetCurrentMovementSpeed() >= 240 and IsUsingSleightOfFist() then
                return BOT_ACTION_DESIRE_HIGH, extraLocation
            end
        end
    else
        local target = AbilityExtensions:GetTargetIfGood(npcBot)
        if target ~= nil and target:CanBeSeen() and AbilityExtensions:NormalCanCast(target, false) then
            if AbilityExtensions:GetHealthPercent(target) <= 0.7 then
                local remnantNumber = AbilityExtensions:Count(activeRemnants, function(t)
                    return GetUnitToUnitDistance(t, target) <= radius
                end)
                local damageOnce = target:GetActualIncomingDamage(damage, DAMAGE_TYPE_MAGICAL)
                if target:GetHealth() <= (0.9+0.18*friendCount) * damageOnce * remnantNumber + charge then
                    return BOT_ACTION_DESIRE_HIGH, target:GetExtrapolatedLocation(GetUnitToUnitDistance(target, npcBot) / Clamp((remnantSpeed - target:GetCurrentMovementSpeed()), 100, 1000))
                end
            end
        end
    end
    return 0
end

AbilityExtensions:AutoModifyConsiderFunction(npcBot, Consider, Abilities)

function AbilityUsageThink()
    if refreshRemnantToken then
        RefreshActiveRemnants()
        refreshRemnantToken = nil
    end
    if npcBot:IsChanneling() or npcBot:IsSilenced() then
        return
    end
    attackRange = npcBot:GetAttackRange()
    healthPercent = AbilityExtensions:GetHealthPercent(npcBot)
    mana = npcBot:GetMana()
    manaPercent = AbilityExtensions:GetManaPercent(npcBot)

    cast=ability_item_usage_generic.ConsiderAbility(Abilities,Consider)
    local abilityIndex, target, castType = ability_item_usage_generic.UseAbility(Abilities,cast)
    AbilityExtensions:RecordAbility(npcBot, abilityIndex, target, castType, Abilities)
    if abilityIndex == 5 then
        refreshRemnantToken = true
    end
end

function CourierUsageThink() 
	ability_item_usage_generic.CourierUsageThink()
end