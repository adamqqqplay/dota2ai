---------------------------------------------
-- Generated from Mirana Compiler version 1.6.2
-- Do not modify
-- https://github.com/AaronSong321/Mirana
---------------------------------------------
local utility = require(GetScriptDirectory() .. "/utility")
local ability_item_usage_generic = require(GetScriptDirectory() .. "/ability_item_usage_generic")
local fun1 = require(GetScriptDirectory() .. "/util/AbilityAbstraction")
local A = require(GetScriptDirectory() .. "/util/MiraDota")
local debugmode = false
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
    Abilities[4],
    Abilities[2],
    Abilities[1],
    Abilities[1],
    "talent",
    Abilities[1],
    Abilities[4],
    Abilities[3],
    Abilities[3],
    "talent",
    Abilities[3],
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
local TalentTree = {
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
        return Talents[7]
    end,
}
utility.CheckAbilityBuild(AbilityToLevelUp)
function AbilityLevelUpThink()
    ability_item_usage_generic.AbilityLevelUpThink2(AbilityToLevelUp, TalentTree)
end

local cast = {}
cast.Desire = {}
cast.Target = {}
cast.Type = {}
local Consider = {}
local CanCast = {
    utility.NCanCast,
    utility.NCanCast,
    utility.NCanCast,
    utility.UCanCast,
}
local enemyDisabled = utility.enemyDisabled
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
        return BOT_ACTION_DESIRE_NONE, 0
    end
    local Radius = ability:GetSpecialValueInt("bounce_aoe")
    local CastRange = ability:GetCastRange()
    local Damage = ability:GetAbilityDamage()
    local CastPoint = ability:GetCastPoint()
    local allys = npcBot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
    local enemys = npcBot:GetNearbyHeroes(Radius, true, BOT_MODE_NONE)
    local WeakestEnemy, HeroHealth = utility.GetWeakestUnit(enemys)
    local creeps = npcBot:GetNearbyCreeps(CastRange + 300, true)
    local WeakestCreep, CreepHealth = utility.GetWeakestUnit(creeps)
    for _, npcEnemy in pairs(enemys) do
        if npcEnemy:IsChanneling() and CanCast[abilityNumber](npcEnemy) then
            if GetUnitToUnitDistance(npcBot, npcEnemy) < CastRange then
                return BOT_ACTION_DESIRE_HIGH, npcEnemy
            elseif creeps[1] ~= nil and npcEnemy:HasModifier("modifier_bounty_hunter_track") then
                return BOT_ACTION_DESIRE_HIGH, creeps[1]
            end
        end
    end
    if npcBot:GetActiveMode() ~= BOT_MODE_RETREAT then
        if WeakestEnemy ~= nil then
            if CanCast[abilityNumber](WeakestEnemy) then
                if HeroHealth <= WeakestEnemy:GetActualIncomingDamage(Damage, DAMAGE_TYPE_MAGICAL) or
                    (
                    HeroHealth <= WeakestEnemy:GetActualIncomingDamage(GetComboDamage(), DAMAGE_TYPE_MAGICAL) and
                        npcBot:GetMana() > ComboMana) then
                    if GetUnitToUnitDistance(npcBot, WeakestEnemy) < CastRange and
                        not npcBot:HasModifier("modifier_bounty_hunter_shadow_walk") then
                        return BOT_ACTION_DESIRE_HIGH, WeakestEnemy
                    elseif creeps[1] ~= nil and not npcBot:HasModifier("modifier_bounty_hunter_shadow_walk") and
                        WeakestEnemy:HasModifier("modifier_bounty_hunter_track") then
                        return BOT_ACTION_DESIRE_HIGH, creeps[1]
                    end
                end
            end
        end
    end
    local tableNearbyAttackingAlliedHeroes = npcBot:GetNearbyHeroes(1000, false, BOT_MODE_ATTACK)
    if #tableNearbyAttackingAlliedHeroes >= 2 then
        local trackedEnemy = 0
        for k, npcEnemy in pairs(enemys) do
            if npcEnemy:HasModifier("modifier_bounty_hunter_track") then
                trackedEnemy = trackedEnemy + 1
            end
        end
        if trackedEnemy >= 2 then
            if creeps[1] ~= nil then
                return BOT_ACTION_DESIRE_HIGH, creeps[1]
            elseif enemys[1] ~= nil then
                return BOT_ACTION_DESIRE_HIGH, enemys[1]
            end
        end
    end
    local enemys2 = npcBot:GetNearbyHeroes(400, true, BOT_MODE_NONE)
    if npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
        npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
        npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT then
        if #enemys >= 1 then
            if ManaPercentage > 0.5 or npcBot:GetMana() > ComboMana then
                if WeakestEnemy ~= nil then
                    if CanCast[abilityNumber](WeakestEnemy) then
                        if GetUnitToUnitDistance(npcBot, WeakestEnemy) < CastRange and
                            not npcBot:HasModifier("modifier_bounty_hunter_shadow_walk") then
                            return BOT_ACTION_DESIRE_HIGH, WeakestEnemy
                        elseif creeps[1] ~= nil and WeakestEnemy:HasModifier("modifier_bounty_hunter_track") and
                            not npcBot:HasModifier("modifier_bounty_hunter_shadow_walk") then
                            return BOT_ACTION_DESIRE_HIGH, creeps[1]
                        end
                    end
                end
            end
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_ROAM or npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
        npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or npcBot:GetActiveMode() == BOT_MODE_ATTACK then
        local npcEnemy = npcBot:GetTarget()
        if npcEnemy ~= nil then
            if CanCast[abilityNumber](npcEnemy) then
                if GetUnitToUnitDistance(npcBot, npcEnemy) < CastRange then
                    return BOT_ACTION_DESIRE_HIGH, npcEnemy
                elseif creeps[1] and GetUnitToUnitDistanceSqr(creeps[1], npcEnemy) <= 810000 and
                    npcEnemy:HasModifier("modifier_bounty_hunter_track") then
                    return BOT_ACTION_DESIRE_HIGH, creeps[1]
                end
            end
        end
    end
    return BOT_ACTION_DESIRE_NONE, 0
end
Consider[2] = fun1:ToggleFunctionToAutoCast(npcBot, AbilitiesReal[2], function(it)
    do
        local target = npcBot:GetAttackTarget()
        if target then
            if not target:IsHero() and fun1:GetNearbyLaneCreeps(npcBot, 700, false) then
                if target:GetActualIncomingDamage(npcBot:GetAttackDamage(), DAMAGE_TYPE_PHYSICAL) >= target:GetHealth() then
                    return false
                end
            end
        end
    end
    return true
end)
Consider[3] = function()
    local abilityNumber = 3
    local ability = AbilitiesReal[abilityNumber]
    if not ability:IsFullyCastable() then
        return BOT_ACTION_DESIRE_NONE, 0
    end
    local CastRange = 0
    local Damage = ability:GetAbilityDamage()
    local Radius = ability:GetAOERadius()
    local CastPoint = ability:GetCastPoint()
    local allys = npcBot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
    local enemys = npcBot:GetNearbyHeroes(CastRange + 300, true, BOT_MODE_NONE)
    local WeakestEnemy, HeroHealth = utility.GetWeakestUnit(enemys)
    local creeps = npcBot:GetNearbyCreeps(CastRange + 300, true)
    local WeakestCreep, CreepHealth = utility.GetWeakestUnit(creeps)
    if npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_MODERATE then
        if npcBot:WasRecentlyDamagedByAnyHero(2.0) then
            return BOT_ACTION_DESIRE_HIGH
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_ROAM or npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
        npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or npcBot:GetActiveMode() == BOT_MODE_ATTACK then
        local npcEnemy = fun1:GetTargetIfGood(npcBot)
        if npcEnemy ~= nil then
            if GetUnitToUnitDistance(npcBot, npcEnemy) <= 2000 then
                return BOT_ACTION_DESIRE_MODERATE
            end
        end
    end
    return BOT_ACTION_DESIRE_NONE
end
local function HasTrackModifierPenalty(t)
    return fun1:GetModifierRemainingDuration(t, "modifier_bounty_hunter_track") <= 5 and 1 or 0.5
end

Consider[4] = function()
    local abilityNumber = 4
    local ability = AbilitiesReal[abilityNumber]
    if not ability:IsFullyCastable() then
        return BOT_ACTION_DESIRE_NONE
    end
    local CastRange = Clamp(ability:GetCastRange(), 0, 1599)
    local realEnemies = fun1:GetNearbyNonIllusionHeroes(npcBot, CastRange):Filter(function(it)
        return fun1:SpellCanCast(it) and it:IsHero() and fun1:MayNotBeIllusion(npcBot, it) and A.Unit.IsNotCreepHero(it)
    end):Map(function(it)
        return {
            it,
            it:GetHealth() * HasTrackModifierPenalty(it),
        }
    end):SortByMinFirst(function(it)
        return it[2]
    end)
    do
        local t = realEnemies:First()
        if t then
            local target = t[1]
            if fun1:IsFarmingOrPushing(npcBot) or npcBot:GetActiveMode() == BOT_MODE_LANING then
                if ManaPercentage >= 0.7 then
                    return BOT_ACTION_DESIRE_MODERATE, target
                end
                if fun1:GetHealthPercent(target) <= 0.5 then
                    return BOT_ACTION_DESIRE_HIGH, target
                end
            else
                return BOT_ACTION_DESIRE_HIGH, target
            end
        end
    end
    do
        local target = fun1:GetTargetIfGood(npcBot)
        if target and target:GetTeam() ~= npcBot:GetTeam() and A.Unit.IsNotCreepHero(target) then
            return BOT_ACTION_DESIRE_HIGH, target
        end
    end
    return BOT_ACTION_DESIRE_NONE
end
fun1:AutoModifyConsiderFunction(npcBot, Consider, AbilitiesReal)
function AbilityUsageThink()
    if npcBot:IsUsingAbility() or npcBot:IsChanneling() or npcBot:IsSilenced() then
        return
    end
    ComboMana = GetComboMana()
    AttackRange = npcBot:GetAttackRange()
    ManaPercentage = npcBot:GetMana() / npcBot:GetMaxMana()
    HealthPercentage = npcBot:GetHealth() / npcBot:GetMaxHealth()
    cast = ability_item_usage_generic.ConsiderAbility(AbilitiesReal, Consider)
    if debugmode == true then
        ability_item_usage_generic.PrintDebugInfo(AbilitiesReal, cast)
    end
    ability_item_usage_generic.UseAbility(AbilitiesReal, cast)
end

function CourierUsageThink()
    ability_item_usage_generic.CourierUsageThink()
end
