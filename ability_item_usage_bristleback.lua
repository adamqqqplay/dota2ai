---------------------------------------------
-- Generated from Mirana Compiler version 1.6.2
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
local Talents = {}
local Abilities = {}
local AbilitiesReal = {}
ability_item_usage_generic.InitAbility(Abilities, AbilitiesReal, Talents)
local AbilityToLevelUp = {
    Abilities[2],
    Abilities[3],
    Abilities[2],
    Abilities[1],
    Abilities[2],
    Abilities[5],
    Abilities[2],
    Abilities[3],
    Abilities[3],
    "talent",
    Abilities[3],
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
local TalentTree = {
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
    fun1.NormalCanCastFunction,
    fun1.PhysicalCanCastFunction,
    function(_)
        return true
    end,
    fun1.NormalCanCastFunction,
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
local allEnemies
local enemies
local enemyCount
local friends
local friendCount
local enemyCreeps
local friendCreeps
local neutralCreeps
local tower
function GetComboDamage()
    return ability_item_usage_generic.GetComboDamage(AbilitiesReal)
end
function GetComboMana()
    return ability_item_usage_generic.GetComboMana(AbilitiesReal)
end
Consider[1] = function()
    local abilityNumber = 1
    local ability = AbilitiesReal[abilityNumber]
    if not ability:IsFullyCastable() then
        return BOT_ACTION_DESIRE_NONE
    end
    local castRange = ability:GetCastRange()
    if fun1:HasScepter(npcBot) then
        local enemies = npcBot:GetNearbyHeroes(CastRange, true, BOT_MODE_NONE)
        enemies = fun1:Filter(enemies, function(t)
            local m = t:GetModifierByName("modifier_bristleback_viscous_nasal_goo")
            if m ~= -1 and t:GetModifierStackCount(m) >= 6 and t:GetModifierRemainingDuration(m) >= 2.5 then
                return false
            end
            return true
        end)
        if (fun1:IsAttackingEnemies(npcBot) or fun1:IsRetreating(npcBot)) and npcBot:GetMana() >= 120 then
            if #enemies == 0 then
                return 0
            end
            return #enemies >= 2 and fun1:GetManaPercent(npcBot) >= 0.3 or #enemies == 1 and fun1:GetManaPercent(npcBot) >= 0.6 or npcBot:WasRecentlyDamagedByAnyHero(1.5)
        end
        return 0
    end
    if friends:Count(function(t)
        return fun1:CanBeEngaged(t)
    end) >= 2 then
        do
            local target = enemies:Filter(CanCast[1]):Max(function(t)
                return t:GetEstimatedDamageToTarget(false, npcBot, 3, DAMAGE_TYPE_ALL)
            end)
            if target then
                return BOT_ACTION_DESIRE_HIGH, target
            end
        end
    end
    if fun1:NotRetreating(npcBot) and not fun1:IsLaning(npcBot) then
        do
            local target = enemies:Max(function(t)
                return t:GetHealth() * (function()
                    if fun1:IsSeverelyDisabledOrSlowed(t) then
                        return 1.5
                    else
                        return 1
                    end
                end)()
            end)
            if target then
                return BOT_ACTION_DESIRE_HIGH, target
            end
        end
    end
    if fun1:IsAttackingEnemies(npcBot) then
        do
            local target = fun1:GetTargetIfGood(npcBot)
            if target then
                if CanCast[1](target) and GetUnitToUnitDistance(npcBot, target) < castRange then
                    return BOT_ACTION_DESIRE_MODERATE, target
                end
            end
        end
    end
    return BOT_ACTION_DESIRE_NONE
end
Consider[2] = function()
    local abilityNumber = 2
    local ability = AbilitiesReal[abilityNumber]
    if not ability:IsFullyCastable() then
        return BOT_ACTION_DESIRE_NONE, 0
    end
    local CastRange = 0
    local Damage = ability:GetAbilityDamage()
    local Radius = ability:GetAOERadius() - 50
    local CastPoint = ability:GetCastPoint()
    local allys = npcBot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
    local enemys = npcBot:GetNearbyHeroes(Radius, true, BOT_MODE_NONE)
    local WeakestEnemy, HeroHealth = utility.GetWeakestUnit(enemys)
    local creeps = npcBot:GetNearbyCreeps(Radius, true)
    local WeakestCreep, CreepHealth = utility.GetWeakestUnit(creeps)
    if npcBot:GetActiveMode() ~= BOT_MODE_RETREAT then
        if WeakestEnemy ~= nil then
            if CanCast[abilityNumber](WeakestEnemy) then
                if HeroHealth <= WeakestEnemy:GetActualIncomingDamage(Damage, DAMAGE_TYPE_PHYSICAL) or WeakestEnemy:HasModifier("modifier_bristleback_viscous_nasal_goo") then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end
    end
    if (npcBot:WasRecentlyDamagedByAnyHero(2) and #enemys >= 1) or #enemys >= 2 then
        for _, npcEnemy in pairs(enemys) do
            if CanCast[abilityNumber](npcEnemy) then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_LANING then
        if (manaPercent > 0.65 or npcBot:GetMana() > ComboMana) then
            if WeakestEnemy ~= nil then
                if CanCast[abilityNumber](WeakestEnemy) then
                    if GetUnitToUnitDistance(npcBot, WeakestEnemy) < Radius - CastPoint * WeakestEnemy:GetCurrentMovementSpeed() then
                        return BOT_ACTION_DESIRE_LOW
                    end
                end
            end
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_FARM or npcBot:GetActiveMode() == BOT_MODE_LANING then
        if #creeps >= 2 then
            if WeakestCreep ~= nil then
                if CreepHealth <= WeakestCreep:GetActualIncomingDamage(Damage, DAMAGE_TYPE_PHYSICAL) and (manaPercent > 0.4 or npcBot:GetMana() > ComboMana) then
                    return BOT_ACTION_DESIRE_LOW
                end
            end
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_LANING then
        if WeakestCreep ~= nil then
            if (manaPercent > 0.5 or npcBot:GetMana() > ComboMana) and GetUnitToUnitDistance(npcBot, WeakestCreep) < Radius then
                if CreepHealth <= WeakestCreep:GetActualIncomingDamage(Damage, DAMAGE_TYPE_PHYSICAL) - 20 then
                    return BOT_ACTION_DESIRE_LOW
                end
            end
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_ROAM or npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or npcBot:GetActiveMode() == BOT_MODE_ATTACK then
        local npcEnemy = npcBot:GetTarget()
        if npcEnemy ~= nil then
            if CanCast[abilityNumber](npcEnemy) and GetUnitToUnitDistance(npcBot, npcEnemy) <= Radius then
                return BOT_ACTION_DESIRE_MODERATE, npcEnemy
            end
        end
    end
    return BOT_ACTION_DESIRE_NONE, 0
end
Consider[4] = function()
    local ability = AbilitiesReal[4]
    if not ability:IsFullyCastable() or ability:IsHidden() then
        return BOT_ACTION_DESIRE_NONE
    end
    local castRange = ability:GetCastRange()
    local radius = ability:GetAOERadius() - 50
    local castPoint = ability:GetCastPoint()
    local enemies = fun1:GetNearbyNonIllusionHeroes(npcBot, 1599)
    local enemyCount = fun1:GetEnemyHeroNumber(npcBot, enemies)
    if enemyCount >= 2 then
        local info = npcBot:FindAoELocation(true, true, npcBot:GetLocation(), castRange, radius, castPoint, 10000)
        if info.count >= enemyCount or info.count >= 3 then
            return BOT_ACTION_DESIRE_HIGH, info.targetloc
        end
    end
    if enemyCount == 1 then
        return BOT_ACTION_DESIRE_MODERATE, fun1:FindAOELocationAtSingleTarget(npcBot, enemeis[1], castRange, radius, castPoint)
    end
    if enemyCount == 0 then
        if fun1:IsFarmingOrPushing(npcBot) then
            local info = npcBot:FindAoELocation(true, false, npcBot:GetLocation(), castRange, radius, castPoint, 10000)
            if info.count >= 4 and mana >= 300 then
                return BOT_ACTION_DESIRE_HIGH, info.targetloc
            end
        end
    end
    return 0
end
fun1:AutoModifyConsiderFunction(npcBot, Consider, AbilitiesReal)
function AbilityUsageThink()
    if npcBot:IsChanneling() or npcBot:IsSilenced() then
        return
    end
    ComboMana = GetComboMana()
    attackRange = npcBot:GetAttackRange()
    health = npcBot:GetHealth()
    maxHealth = npcBot:GetMaxHealth()
    healthPercent = fun1:GetHealthPercent(npcBot)
    mana = npcBot:GetMana()
    maxMana = npcBot:GetMaxMana()
    manaPercent = fun1:GetManaPercent(npcBot)
    allEnemies = fun1:GetNearbyHeroes(npcBot, 1200)
    enemies = allEnemies:Filter(function(t)
        return fun1:MayNotBeIllusion(npcBot, t)
    end)
    enemyCount = fun1:GetEnemyHeroNumber(npcBot, enemies)
    friends = fun1:GetNearbyNonIllusionHeroes(npcBot, 1500, true)
    friendCount = fun1:GetEnemyHeroNumber(npcBot, friends)
    enemyCreeps = fun1:GetNearbyAttackableCreeps(npcBot, 900)
    friendCreeps = fun1:GetNearbyAttackableCreeps(npcBot, npcBot:GetAttackRange() + 150, false)
    neutralCreeps = npcBot:GetNearbyNeutralCreeps(900)
    tower = fun1:GetLaningTower(npcBot)
    cast = ability_item_usage_generic.ConsiderAbility(AbilitiesReal, Consider)
    ability_item_usage_generic.UseAbility(AbilitiesReal, cast)
end
function CourierUsageThink()
    ability_item_usage_generic.CourierUsageThink()
end
