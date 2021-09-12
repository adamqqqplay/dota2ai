---------------------------------------------
-- Generated from Mirana Compiler version 1.6.0
-- Do not modify
-- https://github.com/AaronSong321/Mirana
---------------------------------------------
local utility = require(GetScriptDirectory().."/utility")
require(GetScriptDirectory().."/ability_item_usage_generic")
local fun1 = require(GetScriptDirectory().."/util/AbilityAbstraction")
local npcBot = GetBot()
if npcBot:IsIllusion() then
    return
end
local AbilityNames,Abilities,Talents = fun1:InitAbility(npcBot)
local AbilityToLevelUp = {
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
    end,
}
utility.CheckAbilityBuild(AbilityToLevelUp)
function AbilityLevelUpThink()
    ability_item_usage_generic.AbilityLevelUpThink2(AbilityToLevelUp, TalentTree)
end
local cast = {
    Desire = {},
    Target = {},
    Type = {},
}
local Consider = {}
local CanCast = {
    function(t)
        return fun1:StunCanCast(t, Abilities[1], false, false, true, false)
    end,
    fun1.PhysicalCanCastFunction,
    fun1.NormalCanCastFunction,
    function(_)
        return true
    end,
    function(_)
        return true
    end,
}
local attackRange
local health
local maxHealth
local healthPercent
local mana
local maxMana
local manaPercent
local enemies
local realEnemies
local friends
local friendCount
local enemyCreeps
local friendCreeps
local neutralCreeps
local tower
local function IsUsingSleightOfFist()
    return npcBot:HasModifier "modifier_ember_spirit_sleight_of_fist_in_progress"
end
local function IsUsingRemnant()
    return npcBot:HasModifier "modifier_ember_spirit_fire_remnant"
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
    local unitCount = ability:GetSpecialValueInt "unit_count"
    local allEnemies = fun1:GetNearbyHeroes(npcBot, castRange)
    local enemies = allEnemies:Filter(function(it)
        return fun1:MayNotBeIllusion(npcBot, it) and CanCast[1](it)
    end)
    local enemyCreeps = fun1:GetNearbyAttackableCreeps(npcBot, castRange)
    local neutralCreeps = npcBot:GetNearbyNeutralCreeps(castRange)
    local damage = ability:GetSpecialValueInt "total_damage"
    local weakCreeps = fun1:Filter(enemyCreeps, function(t)
        return t:GetHealth() < t:GetActualIncomingDamage(damage, DAMAGE_TYPE_MAGICAL)
    end)
    local forbiddenCreeps = fun1:Filter(enemyCreeps, function(t)
        return t:GetHealth() > t:GetActualIncomingDamage(damage, DAMAGE_TYPE_MAGICAL) and t:GetHealth() <= t:GetActualIncomingDamage(damage, DAMAGE_TYPE_MAGICAL) + fun1:AttackOnceDamage(npcBot, t) * (0.9 + #enemyCreeps * 0.1)
    end)
    if #friendCreeps == 0 then
        forbiddenCreeps = forbiddenCreeps:Filter(function(it)
            return false
        end)
    end
    local allTargets = allEnemies:Concat(fun1:GetNearbyCreeps(npcBot, castRange, true)):Filter(CanCast[1])
    local targetNumber = #allTargets
    if targetNumber <= unitCount then
        targetNumber = unitCount
    end
    local function ChainExpectancy(targetNumber, unitCount, allUnits)
        local t = targetNumber
        if targetNumber > unitCount then
            t = unitCount
        end
        return fun1:Aggregate(0, fun1:Range(1, t), function(seed, target)
            return seed + fun1:Combination(t, target) * fun1:Combination(allUnits - t, t - target) * target
        end) / fun1:Combination(unitCount, allUnits)
    end
    if fun1:IsFarmingOrPushing(npcBot) then
        if mana >= maxMana * 0.6 + manaCost and #enemyCreeps >= 2 then
            return BOT_ACTION_DESIRE_LOW
        end
    end
    if fun1:IsAttackingEnemies(npcBot) then
        if #enemies > 0 then
            local p = ChainExpectancy(#enemies, unitCount, targetNumber)
            if p >= 0.5 and mana >= maxMana * 0.6 + manaCost then
                return RemapValClamped(p, 0.5, 1, BOT_ACTION_DESIRE_MODERATE, BOT_ACTION_DESIRE_VERYHIGH)
            end
            if mana >= maxMana * 0.4 + manaCost and p >= 0.8 then
                return RemapValClamped(p, 0.5, 1, BOT_ACTION_DESIRE_MODERATE, BOT_ACTION_DESIRE_VERYHIGH)
            end
        end
    end
    if fun1:IsRetreating(npcBot) then
        if #enemies > 0 then
            local p = ChainExpectancy(#enemies, unitCount, targetNumber)
            if p >= 0.5 then
                return RemapValClamped(p, 0.5, 1, BOT_ACTION_DESIRE_MODERATE, BOT_ACTION_DESIRE_VERYHIGH)
            end
        end
    else
        do
            local target = fun1:GetTargetIfGood(npcBot)
            local target = fun1:GetTargetIfBad(npcBot)
            if target then
                local p = ChainExpectancy(#enemies, unitCount, targetNumber)
                if p >= 0.5 then
                    return RemapValClamped(p, 0.5, 1, BOT_ACTION_DESIRE_MODERATE, BOT_ACTION_DESIRE_VERYHIGH)
                end
            elseif target then
                local p = ChainExpectancy(#enemies, unitCount, targetNumber)
                if p >= 1 then
                    return RemapValClamped(p, 0.5, 1, BOT_ACTION_DESIRE_MODERATE, BOT_ACTION_DESIRE_VERYHIGH)
                end
            end
        end
    end
    return 0
end
Consider[2] = function()
    local ability = Abilities[2]
    if not ability:IsFullyCastable() or IsUsingRemnant() or IsUsingSleightOfFist() or fun1:CannotMove(npcBot) or ability:GetCurrentCharges() == 0 then
        return 0
    end
    local abilityLevel = ability:GetLevel()
    local castRange = ability:GetCastRange() + 100
    local radius = ability:GetAOERadius()
    local castPoint = ability:GetCastPoint()
    local manaCost = ability:GetManaCost()
    local duration = ability:GetDuration()
    local enemies = fun1:GetNearbyHeroes(npcBot, castRange + radius)
    local realEnemies = fun1:Filter(enemies, function(t)
        return fun1:MayNotBeIllusion(npcBot, t)
    end)
    local targettableEnemies = fun1:Filter(enemies, function(t)
        return fun1:NormalCanCast(t, true, DAMAGE_TYPE_PHYSICAL, true) and not fun1:CannotBeAttacked(t)
    end)
    local friends = fun1:GetNearbyHeroes(npcBot, 1200, true)
    local friendCount = fun1:GetEnemyHeroNumber(npcBot, friends)
    local enemyCreeps = fun1:GetNearbyAttackableCreeps(npcBot, castRange + radius)
    local friendCreeps = fun1:GetNearbyAttackableCreeps(npcBot, npcBot:GetAttackRange() + 150, false)
    local neutralCreeps = npcBot:GetNearbyNeutralCreeps(castRange)
    local weakestEnemy,enemyHealth = utility.GetWeakestUnit(targettableEnemies)
    local creepDamage = npcBot:GetAttackDamage() * (1 + ability:GetSpecialValueInt "creep_damage_penalty" / 100)
    local weakCreeps = fun1:Filter(enemyCreeps, function(t)
        return t:GetHealth() < t:GetActualIncomingDamage(creepDamage, DAMAGE_TYPE_MAGICAL)
    end)
    local weakestCreep = utility.GetWeakestUnit(weakCreeps)
    local forbiddenCreeps = fun1:Filter(enemyCreeps, function(t)
        return t:GetHealth() > t:GetActualIncomingDamage(creepDamage, DAMAGE_TYPE_MAGICAL) and t:GetHealth() <= t:GetActualIncomingDamage(creepDamage, DAMAGE_TYPE_MAGICAL) + fun1:AttackOnceDamage(npcBot, t) * (0.9 + #enemyCreeps * 0.1)
    end)
    if #friendCreeps == 0 then
        forbiddenCreeps = {}
    end
    local damage = npcBot:GetAttackDamage() + ability:GetSpecialValueInt "bonus_hero_damage"
    if fun1:GetAvailableItem(npcBot, "item_lesser_crit") then
        damage = damage * 1.7
    elseif fun1:GetAvailableItem(npcBot, "item_greater_crit") then
        damage = damage * 2.3
    end
    local hasBattleFury = fun1:GetAvailableItem(npcBot, "item_bfury") ~= nil
    local projectiles = fun1:GetIncomingDodgeWorthProjectiles(npcBot) or {}
    projectiles = fun1:Any(projectiles, function(t)
        return GetUnitToLocationDistance(npcBot, t.location) <= 200
    end)
    if projectiles then
        local locationAoE = npcBot:FindAoELocation(true, false, npcBot:GetLocation(), castRange + 60, radius, 0, 0)
        if locationAoE.count >= 2 then
            return BOT_ACTION_DESIRE_HIGH, locationAoE.targetloc
        end
    end
    if fun1:IsFarmingOrPushing(npcBot) then
        local locationAoE = npcBot:FindAoELocation(true, false, npcBot:GetLocation(), castRange + 150, radius, 0, 0)
        if hasBattleFury and (locationAoE.count >= 4 and manaPercent >= 0.3 + manaCost or locationAoE.count >= 3 and manaPercent >= 0.6 + manaCost) then
            return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc
        end
    elseif fun1:IsLaning(npcBot) then
        if manaPercent >= 0.6 + manaCost and #enemies == 1 and enemies[1]:CanBeSeen() and healthPercent >= 0.8 and abilityLevel >= 3 then
            return BOT_ACTION_DESIRE_HIGH, fun1:FindAOELocationAtSingleTarget(npcBot, enemies[1], radius, castRange, castPoint)
        end
        if manaPercent >= 0.3 and #enemies == 1 and enemies[1]:CanBeSeen() and healthPercent >= 0.75 and abilityLevel >= 4 then
            return BOT_ACTION_DESIRE_HIGH, fun1:FindAOELocationAtSingleTarget(npcBot, enemies[1], radius, castRange, castPoint)
        end
    end
    if fun1:NotRetreating(npcBot) then
        local findPlace = npcBot:FindAoELocation(true, true, npcBot:GetLocation(), castRange + 100, radius, 0, 0)
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
                local targetLocation = fun1:FindAOELocationAtSingleTarget(npcBot, weakestEnemy, radius, castRange, castPoint)
                return BOT_ACTION_DESIRE_HIGH, targetLocation
            end
        end
        local target = npcBot:GetTarget()
        if target ~= nil and target:CanBeSeen() and fun1:NormalCanCast(target, true, DAMAGE_TYPE_PHYSICAL) and not fun1:CannotBeAttacked(target) and (mana >= 200 and target:GetHealth() < target:GetActualIncomingDamage(damage, DAMAGE_TYPE_PHYSICAL) * (0.9 + friendCount * 0.1)) then
            return BOT_ACTION_DESIRE_HIGH, fun1:FindAOELocationAtSingleTarget(npcBot, target, radius, castRange, castPoint)
        end
    end
    return 0
end
Consider[3] = function()
    local ability = Abilities[3]
    if not ability:IsFullyCastable() or npcBot:HasModifier "modifier_ember_spirit_flame_guard" or npcBot:HasModifier "modifier_shadow_demon_purge_slow" then
        return 0
    end
    local abilityLevel = ability:GetLevel()
    local castRange = ability:GetCastRange()
    local radius = ability:GetAOERadius()
    local castPoint = ability:GetCastPoint()
    local manaCost = ability:GetManaCost()
    local duration = ability:GetDuration()
    local enemies = fun1:GetNearbyHeroes(npcBot, radius)
    local realEnemies = fun1:Filter(enemies, function(t)
        return fun1:MayNotBeIllusion(npcBot, t)
    end)
    local targettableEnemies = fun1:Filter(realEnemies, function(t)
        return fun1:NormalCanCast(t)
    end)
    local friends = fun1:GetNearbyHeroes(npcBot, 1200, true)
    local friendCount = fun1:GetEnemyHeroNumber(npcBot, friends)
    local enemyCreeps = fun1:GetNearbyAttackableCreeps(npcBot, 900)
    local friendCreeps = fun1:GetNearbyAttackableCreeps(npcBot, npcBot:GetAttackRange() + 150, false)
    local neutralCreeps = npcBot:GetNearbyNeutralCreeps(castRange)
    local weakestEnemy,enemyHealth = utility.GetWeakestUnit(targettableEnemies)
    local weakCreeps = enemyCreeps
    local weakestCreep = utility.GetWeakestUnit(weakCreeps)
    local forbiddenCreeps = {}
    local manaMaintain = npcBot:GetMaxMana() * 0.6 + manaCost
    if fun1:IsFarmingOrPushing(npcBot) then
        if #enemyCreeps >= 4 and mana >= manaMaintain and abilityLevel >= 3 then
            return BOT_ACTION_DESIRE_MODERATE - 0.08
        end
    elseif fun1:IsLaning(npcBot) then
        if #enemyCreeps >= 3 and mana >= npcBot:GetMaxMana() * 0.3 + manaCost then
            local laneEnemyHero = enemies[1]
            if laneEnemyHero ~= nil and GetUnitToUnitDistance(npcBot, laneEnemyHero) <= radius and fun1:GetHealthPercent(laneEnemyHero) <= 0.4 then
                return BOT_ACTION_DESIRE_MODERATE
            end
            if #friendCreeps == 0 and abilityLevel >= 2 then
                return BOT_ACTION_DESIRE_MODERATE
            end
        end
    elseif fun1:IsAttackingEnemies(npcBot) then
        if abilityLevel <= 2 then
            return 0
        end
        if IsUsingSleightOfFist() then
            local sleightFistMarkedHeroes = fun1:Count(enemies, function(t)
                return t:HasModifier "modifier_ember_spirit_sleight_of_fist_mark"
            end)
            if sleightFistMarkedHeroes >= 3 then
                return BOT_ACTION_DESIRE_HIGH
            end
        else
            if not npcBot:IsMagicImmune() then
                local projectiles = fun1:GetIncomingDodgeWorthProjectiles(npcBot)
                projectiles = fun1:Any(projectiles, function(t)
                    return GetUnitToLocationDistance(npcBot, t.location) <= 400
                end)
                if projectiles then
                    return BOT_ACTION_DESIRE_MODERATE
                end
            end
            if #enemies >= 1 and DotaTime() < 10 * 60 or #realEnemies >= 2 and npcBot:GetNetWorth() / DotaTime() * 60 <= 350 or #realEnemies >= 3 then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    elseif fun1:IsRetreating(npcBot) then
        local projectiles = fun1:GetIncomingDodgeWorthProjectiles(npcBot)
        projectiles = fun1:Any(projectiles, function(t)
            return GetUnitToLocationDistance(npcBot, t.location) <= 400
        end)
        if projectiles and abilityLevel >= 3 then
            return BOT_ACTION_DESIRE_HIGH
        end
        return BOT_ACTION_DESIRE_MODERATE
    end
    do
        local target = fun1:GetTargetIfGood(npcBot)
        if target then
            if CanCast[3](target) and GetUnitToUnitDistance(npcBot, target) < radius + 50 and abilityLevel >= 3 then
                return BOT_ACTION_DESIRE_MODERATE
            end
        end
    end
end
local activeRemnants
local refreshRemnantToken
local function RefreshActiveRemnants()
    activeRemnants = fun1:Filter(GetUnitList(UNIT_LIST_ALL), function(t)
        return t:GetUnitName() == "npc_dota_ember_spirit_remnant"
    end)
end
local DetectRemnant = fun1:EveryManySeconds(2, RefreshActiveRemnants)
RefreshActiveRemnants()
Consider[4] = function()
    local ability = Abilities[4]
    if not ability:IsFullyCastable() or IsUsingSleightOfFist() or IsUsingRemnant() or fun1:CannotMove(npcBot) then
        return 0
    end
    DetectRemnant()
    if #activeRemnants == 0 then
        return 0
    end
    local abilityLevel = ability:GetLevel()
    local radius = ability:GetAOERadius() - 100
    local castPoint = ability:GetCastPoint()
    local manaCost = ability:GetManaCost()
    local duration = ability:GetDuration()
    local damage = ability:GetAbilityDamage()
    local enemyCreeps = fun1:GetNearbyAttackableCreeps(npcBot, 900)
    local friendCreeps = fun1:GetNearbyAttackableCreeps(npcBot, npcBot:GetAttackRange() + 150, false)
    local weakCreeps = fun1:Filter(enemyCreeps, function(t)
        return t:GetHealth() < t:GetActualIncomingDamage(damage, DAMAGE_TYPE_MAGICAL)
    end)
    local weakestCreep = utility.GetWeakestUnit(weakCreeps)
    local forbiddenCreeps = fun1:Filter(enemyCreeps, function(t)
        return t:GetHealth() > t:GetActualIncomingDamage(damage, DAMAGE_TYPE_MAGICAL) and t:GetHealth() <= t:GetActualIncomingDamage(damage, DAMAGE_TYPE_MAGICAL) + fun1:AttackOnceDamage(npcBot, t) * (0.9 + #enemyCreeps * 0.1)
    end)
    if #friendCreeps == 0 then
        forbiddenCreeps = {}
    end
    if fun1:IsFarmingOrPushing(npcBot) and fun1:GetManaPercent(npcBot) >= 0.9 then
        for _, activeRemnant in ipairs(activeRemnants) do
            if #weakCreeps >= 3 and #forbiddenCreeps == 0 then
                return BOT_ACTION_DESIRE_MODERATE, activeRemnant:GetLocation()
            end
        end
    end
    if healthPercent >= 0.75 and manaPercent >= 0.9 and fun1:GetDistanceFromAncient(npcBot) <= 1000 and DotaTime() <= 15 * 60 then
        if fun1:IsLaning(npcBot) then
            local laneFront = GetLaneFrontLocation(GetTeam(), npcBot:GetAssignedLane(), 0)
            local remnantUnderTower = fun1:Filter(activeRemnants, function(t)
                return GetUnitToLocationDistance(t, laneFront) <= 1000
            end)
            if remnantUnderTower[1] then
                return BOT_ACTION_DESIRE_MODERATE, remnantUnderTower[1]:GetLocation()
            end
        elseif fun1:IsFarmingOrPushing(npcBot) then
            local remnantUnderTower = fun1:Filter(activeRemnants, function(t)
                return GetUnitToUnitDistance(t, npcBot) >= 4000 and #fun1:GetNearbyNonIllusionHeroes(t) == 0
            end)
            if remnantUnderTower[1] then
                return BOT_ACTION_DESIRE_MODERATE, remnantUnderTower[1]:GetLocation()
            end
        elseif fun1:IsAttackingEnemies(npcBot) then
            for _, activeRemnant in ipairs(activeRemnants) do
                local enemies = fun1:GetNearbyHeroes(activeRemnant, 1599)
                local enemyCount = fun1:GetEnemyHeroNumber(npcBot, enemies)
                local friends = fun1:GetNearbyHeroes(activeRemnant, 1200, true)
                local friendCount = fun1:GetEnemyHeroNumber(npcBot, friends)
                local veryNearEnemies = fun1:GetEnemyHeroNumber(npcBot, fun1:GetNearbyHeroes(activeRemnant, 400))
                if friendCount >= enemyCount and #veryNearEnemies == 0 then
                    return BOT_ACTION_DESIRE_MODERATE, activeRemnant:GetLocation()
                end
            end
        end
    end
    if fun1:IsRetreating(npcBot) then
        local distanceToFountain = fun1:Filter(activeRemnants, function(t)
            local distance = GetUnitToUnitDistance(t, npcBot)
            return distance >= npcBot:GetCurrentMovementSpeed() * 2.5 and distance >= 700 and distance > fun1:GetDistanceFromAncient(t) + 600
        end)
        distanceToFountain = fun1:Map(distanceToFountain, function(t)
            return {
                t,
                fun1:GetDistanceFromAncient(t),
            }
        end)
        distanceToFountain = fun1:SortByMinFirst(distanceToFountain, function(t)
            return t[2]
        end)
        if fun1:Any(distanceToFountain) then
            return BOT_ACTION_DESIRE_HIGH, distanceToFountain[1][1]:GetLocation()
        end
    else
        for _, activeRemnant in ipairs(activeRemnants) do
            local target = fun1:GetTargetIfGood(npcBot)
            if target ~= nil and target:CanBeSeen() and fun1:NormalCanCast(target, false) and GetUnitToUnitDistance(activeRemnant, target) <= radius then
                if fun1:GetHealthPercent(target) <= 0.7 then
                    if fun1:Any(activeRemnants, function(t)
                        local d = GetUnitToUnitDistance(t, target)
                        return d >= 0.7 * radius and d <= 800 and t:IsFacingLocation(target, 30) and t:GetCurrentMovementSpeed() ~= 0
                    end) then
                        return 0.1, activeRemnant:GetLocation()
                    end
                    return RemapValClamped(fun1:GetHealthPercent(target), 0, 0.7, 0.9, 0.5), activeRemnant:GetLocation()
                end
            end
            local enemies = fun1:GetNearbyNonIllusionHeroes(activeRemnant)
            local realEnemies = fun1:Filter(enemies, function(t)
                return fun1:MayNotBeIllusion(npcBot, t) and fun1:NormalCanCast(t, false)
            end)
        end
    end
    return 0
end
local function ShouldGoToFountainFromLane()
    return healthPercent <= 0.25 and not fun1:HasAvailableItem "item_flask" or healthPercent <= 0.4 and manaPercent <= 0.1
end
Consider[5] = function()
    local ability = Abilities[5]
    if not ability:IsFullyCastable() or ability:GetCurrentCharges() == 0 then
        return 0
    end
    local abilityLevel = ability:GetLevel()
    local castRange = ability:GetCastRange()
    local radius = ability:GetAOERadius() - 100
    local castPoint = ability:GetCastPoint()
    local manaCost = ability:GetManaCost()
    local duration = ability:GetDuration()
    local damage = Abilities[4]:GetAbilityDamage()
    local friends = fun1:GetNearbyHeroes(npcBot, 1200, true)
    local friendCount = fun1:GetEnemyHeroNumber(npcBot, friends)
    local enemyCreeps = fun1:GetNearbyAttackableCreeps(npcBot, 900)
    local friendCreeps = fun1:GetNearbyAttackableCreeps(npcBot, npcBot:GetAttackRange() + 150, false)
    local neutralCreeps = npcBot:GetNearbyNeutralCreeps(castRange)
    local weakCreeps = fun1:Filter(enemyCreeps, function(t)
        return t:GetHealth() < t:GetActualIncomingDamage(damage, DAMAGE_TYPE_MAGICAL)
    end)
    local weakestCreep = utility.GetWeakestUnit(weakCreeps)
    local forbiddenCreeps = fun1:Filter(enemyCreeps, function(t)
        return t:GetHealth() > t:GetActualIncomingDamage(damage, DAMAGE_TYPE_MAGICAL) and t:GetHealth() <= t:GetActualIncomingDamage(damage, DAMAGE_TYPE_MAGICAL) + fun1:AttackOnceDamage(npcBot, t) * (0.9 + #enemyCreeps * 0.1)
    end)
    if #friendCreeps == 0 then
        forbiddenCreeps = {}
    end
    local charge = ability:GetCurrentCharges()
    if charge == 0 then
        return 0
    end
    local remnantSpeed = npcBot:GetCurrentMovementSpeed() * ability:GetSpecialValueInt "speed_multiplier" / 100
    if fun1:IsFarmingOrPushing(npcBot) and fun1:GetManaPercent(npcBot) >= 0.9 then
        local nearbyTowers = npcBot:GetNearbyTowers(1100, true)
        if #nearbyTowers == 1 and (nearbyTowers[1] == GetTower(GetTeam(), TOWER_MID_1) or nearbyTowers[1] == GetTower(GetTeam(), TOWER_MID_2)) then
            if ShouldGoToFountainFromLane() then
                if #activeRemnants == 0 then
                    return BOT_ACTION_DESIRE_HIGH, nearbyTowers[1]:GetLocation() + RandomVector(200)
                else
                    local enemies = fun1:GetNearbyHeroes(npcBot, 800)
                    local realEnemies = fun1:Filter(enemies, function(t)
                        return fun1:MayNotBeIllusion(npcBot, t)
                    end)
                    if #realEnemies == 0 then
                        fun1:TryUseTp(npcBot)
                    end
                end
            end
        end
    end
    if fun1:IsRetreating(npcBot) then
        if IsUsingRemnant() then
            return 0
        end
        local enemies = fun1:GetNearbyHeroes(npcBot)
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
                extraLocation = fun1:GetPointFromLineByDistance(npcBot:GetLocation(), fun1:GetAncient(npcBot), useRange)
            end
            if npcBot:GetCurrentMovementSpeed() >= 285 or npcBot:GetCurrentMovementSpeed() >= 240 and IsUsingSleightOfFist() then
                return BOT_ACTION_DESIRE_HIGH, extraLocation
            end
        end
    else
        local target = fun1:GetTargetIfGood(npcBot)
        if target ~= nil and target:CanBeSeen() and fun1:NormalCanCast(target, false) then
            if fun1:GetHealthPercent(target) <= 0.7 then
                local remnantNumber = fun1:Count(activeRemnants, function(t)
                    return GetUnitToUnitDistance(t, target) <= radius
                end)
                local damageOnce = target:GetActualIncomingDamage(damage, DAMAGE_TYPE_MAGICAL)
                if target:GetHealth() <= (0.9 + 0.18 * friendCount) * damageOnce * remnantNumber + charge then
                    return BOT_ACTION_DESIRE_HIGH, target:GetExtrapolatedLocation(GetUnitToUnitDistance(target, npcBot) / Clamp((remnantSpeed - target:GetCurrentMovementSpeed()), 100, 1000))
                end
            end
        end
    end
    return 0
end
fun1:AutoModifyConsiderFunction(npcBot, Consider, Abilities)
function AbilityUsageThink()
    if refreshRemnantToken then
        RefreshActiveRemnants()
        refreshRemnantToken = nil
    end
    if npcBot:IsChanneling() or npcBot:IsSilenced() then
        return
    end
    attackRange = npcBot:GetAttackRange()
    health = npcBot:GetHealth()
    maxHealth = npcBot:GetMaxHealth()
    healthPercent = fun1:GetHealthPercent(npcBot)
    mana = npcBot:GetMana()
    maxMana = npcBot:GetMaxMana()
    manaPercent = fun1:GetManaPercent(npcBot)
    enemies = fun1:GetNearbyHeroes(npcBot, 1599)
    realEnemies = fun1:Filter(enemies, function(t)
        return fun1:MayNotBeIllusion(npcBot, t)
    end)
    friends = fun1:GetNearbyHeroes(npcBot, 1599, true)
    friendCount = fun1:GetEnemyHeroNumber(npcBot, friends)
    enemyCreeps = fun1:GetNearbyAttackableCreeps(npcBot, 1599)
    friendCreeps = fun1:GetNearbyAttackableCreeps(npcBot, npcBot:GetAttackRange() + 150, false)
    neutralCreeps = npcBot:GetNearbyNeutralCreeps(1599)
    tower = fun1:GetLaningTower(npcBot)
    cast = ability_item_usage_generic.ConsiderAbility(Abilities, Consider)
    local abilityIndex,target,castType = ability_item_usage_generic.UseAbility(Abilities, cast)
    fun1:RecordAbility(npcBot, abilityIndex, target, castType, Abilities)
    if abilityIndex == 5 then
        refreshRemnantToken = true
    end
end
function CourierUsageThink()
    ability_item_usage_generic.CourierUsageThink()
end
