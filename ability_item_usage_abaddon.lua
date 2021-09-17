---------------------------------------------
-- Generated from Mirana Compiler version 1.6.1
-- Do not modify
-- https://github.com/AaronSong321/Mirana
---------------------------------------------
local utility = require(GetScriptDirectory().."/utility")
require(GetScriptDirectory().."/ability_item_usage_generic")
local AbilityExtensions = require(GetScriptDirectory().."/util/AbilityAbstraction")
local fun1 = AbilityExtensions
local debugmode = false
local npcBot = GetBot()
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
        return Talents[6]
    end,
    function()
        return Talents[8]
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
local attackRange
local health
local healthPercent
local mana
local manaPercent
local enemyDisabled = utility.enemyDisabled
function GetComboDamage()
    return ability_item_usage_generic.GetComboDamage(AbilitiesReal)
end
function GetComboMana()
    return ability_item_usage_generic.GetComboMana(AbilitiesReal)
end
local function CanCast2(npcEnemy)
    return npcEnemy:CanBeSeen() and not npcEnemy:IsInvulnerable() and not npcEnemy:HasModifier "modifier_abaddon_aphotic_shield"
end
local CanCast = {
    function(t)
        if AbilityExtensions:IsOnSameTeam(npcBot, t) then
            return AbilityExtensions:AllyCanCast(t) and not t:HasModifier "modifier_ice_blast"
        else
            return AbilityExtensions:NormalCanCast(t)
        end
    end,
    CanCast2,
}
Consider[1] = function()
    local abilityNumber = 1
    local ability = AbilitiesReal[abilityNumber]
    if not ability:IsFullyCastable() then
        return BOT_ACTION_DESIRE_NONE, 0
    end
    local CastRange = ability:GetCastRange()
    local Damage = ability:GetAbilityDamage()
    local SelfDamage = ability:GetSpecialValueInt("self_damage")
    local allys = npcBot:GetNearbyHeroes(CastRange + 150, false, BOT_MODE_NONE)
    for _, hero in pairs(allys) do
        if hero == npcBot then
            table.remove(allys, _)
        end
    end
    local WeakestAlly,AllyHealth = utility.GetWeakestUnit(allys)
    local enemys = npcBot:GetNearbyHeroes(CastRange + 150, true, BOT_MODE_NONE)
    local WeakestEnemy,HeroHealth = utility.GetWeakestUnit(enemys)
    local creeps = npcBot:GetNearbyCreeps(CastRange + 300, true)
    local WeakestCreep,CreepHealth = utility.GetWeakestUnit(creeps)
    if npcBot:GetActiveMode() ~= BOT_MODE_RETREAT then
        if WeakestEnemy ~= nil then
            if CanCast[abilityNumber](WeakestEnemy) then
                if HeroHealth <= WeakestEnemy:GetActualIncomingDamage(Damage, DAMAGE_TYPE_MAGICAL) then
                    return BOT_ACTION_DESIRE_HIGH, WeakestEnemy
                end
            end
        end
    end
    if npcBot:GetHealth() / npcBot:GetMaxHealth() > (0.4 - #enemys * 0.05) or npcBot:HasModifier("modifier_abaddon_aphotic_shield") or npcBot:HasModifier("modifier_abaddon_borrowed_time") then
        if WeakestAlly ~= nil then
            if AllyHealth / WeakestAlly:GetMaxHealth() < 0.5 then
                return BOT_ACTION_DESIRE_MODERATE, WeakestAlly
            end
        end
        for _, npcTarget in pairs(allys) do
            if npcTarget:GetHealth() / npcTarget:GetMaxHealth() < (0.5 + #enemys * 0.05) then
                if CanCast[abilityNumber](npcTarget) then
                    return BOT_ACTION_DESIRE_MODERATE, npcTarget
                end
            end
        end
    end
    if npcBot:HasModifier("modifier_abaddon_borrowed_time") then
        if WeakestEnemy ~= nil then
            return BOT_ACTION_DESIRE_MODERATE, WeakestEnemy
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_ROAM or npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or npcBot:GetActiveMode() == BOT_MODE_ATTACK then
        if npcBot:GetHealth() / npcBot:GetMaxHealth() > (0.5 - #enemys * 0.05) or npcBot:HasModifier("modifier_abaddon_aphotic_shield") or npcBot:HasModifier("modifier_abaddon_borrowed_time") then
            local npcEnemy = npcBot:GetTarget()
            if npcEnemy ~= nil then
                if CanCast[abilityNumber](npcEnemy) and GetUnitToUnitDistance(npcBot, npcEnemy) < CastRange + 75 * #allys then
                    return BOT_ACTION_DESIRE_MODERATE, npcEnemy
                end
            end
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_FARM then
        if #creeps >= 2 and npcBot:HasModifier("modifier_abaddon_aphotic_shield") then
            if ManaPercentage > 0.5 then
                return BOT_ACTION_DESIRE_LOW, WeakestCreep
            end
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_LANING then
        if ManaPercentage > 0.4 and (npcBot:GetHealth() / npcBot:GetMaxHealth() > 0.75 or npcBot:HasModifier("modifier_abaddon_aphotic_shield")) and ability:GetLevel() >= 2 then
            if WeakestEnemy ~= nil then
                if CanCast[abilityNumber](WeakestEnemy) then
                    return BOT_ACTION_DESIRE_LOW, WeakestEnemy
                end
            end
        end
    end
    return BOT_ACTION_DESIRE_NONE, 0
end
Consider[2] = function()
    local abilityNumber = 2
    local ability = AbilitiesReal[abilityNumber]
    if not ability:IsFullyCastable() then
        return BOT_ACTION_DESIRE_NONE, 0
    end
    local CastRange = ability:GetCastRange()
    local Damage = ability:GetAbilityDamage()
    local allys = fun1:GetNearbyNonIllusionHeroes(npcBot, CastRange + 200, false):Filter(CanCast[2]):Filter(function(it)
        return it:WasRecentlyDamagedByAnyHero(4) or it:WasRecentlyDamagedByTower(2)
    end)
    local WeakestAlly,AllyHealth = utility.GetWeakestUnit(allys)
    local enemys = npcBot:GetNearbyHeroes(CastRange + 300, true, BOT_MODE_NONE)
    local WeakestEnemy,HeroHealth = utility.GetWeakestUnit(enemys)
    local creeps = npcBot:GetNearbyCreeps(CastRange + 300, true)
    local WeakestCreep,CreepHealth = utility.GetWeakestUnit(creeps)
    local function Rate(it)
        local rate = 0
        if it == npcBot then
            rate = rate + 15
        end
        if fun1:IsSeverelyDisabled(it) then
            rate = rate + 30
        end
        if fun1:GetMovementSpeedPercent(it) <= 0.3 then
            rate = rate + 15
        elseif fun1:GetMovementSpeedPercent(it) <= 0.7 then
            rate = rate + 8
        end
        if fun1:GetHealthPercent(it) <= 0.3 then
            rate = rate + 20
        elseif fun1:GetHealthPercent(it) <= 0.7 then
            rate = rate + 8
        end
        if fun1:DontInterruptAlly(it) then
            rate = rate + 10
        end
        return rate
    end
    do
        local target = allys:Map(function(it)
            return {
                it,
                Rate(it),
            }
        end):Filter(function(it)
            return it[2] >= 15
        end):SortByMaxFirst(function(it)
            return it[2]
        end):First()
        if target then
            local t = target[1]
            local rate = target[2]
            return RemapValClamped(rate, 15, 80, BOT_ACTION_DESIRE_MODERATE - 0.1, BOT_ACTION_DESIRE_VERYHIGH), t
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_ATTACK or npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY then
        if WeakestAlly ~= nil then
            if AllyHealth / WeakestAlly:GetMaxHealth() < 0.3 + 0.4 * ManaPercentage then
                if CanCast[abilityNumber](WeakestAlly) then
                    return BOT_ACTION_DESIRE_MODERATE, WeakestAlly
                end
            end
        end
        for _, npcTarget in pairs(allys) do
            if npcTarget:GetHealth() / npcTarget:GetMaxHealth() < (0.6 + #enemys * 0.05 + 0.2 * ManaPercentage) or npcTarget:WasRecentlyDamagedByAnyHero(5.0) then
                if CanCast[abilityNumber](npcTarget) then
                    return BOT_ACTION_DESIRE_MODERATE, npcTarget
                end
            end
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT then
        if #enemys + #creeps >= 3 then
            if ManaPercentage > 0.4 then
                for _, npcTarget in pairs(allys) do
                    if CanCast[abilityNumber](npcTarget) then
                        return BOT_ACTION_DESIRE_MODERATE, npcTarget
                    end
                end
            end
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_ROAM or npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or npcBot:GetActiveMode() == BOT_MODE_ATTACK then
        local npcEnemy = npcBot:GetTarget()
        if ManaPercentage > 0.4 and HealthPercentage <= 0.66 then
            if npcEnemy ~= nil then
                if CanCast[abilityNumber](npcBot) then
                    return BOT_ACTION_DESIRE_MODERATE, npcBot
                end
            end
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_LANING then
        if #enemys >= 1 and CanCast[abilityNumber](npcBot) then
            if ManaPercentage > 0.5 then
                npcBot:SetTarget(WeakestEnemy)
                return BOT_ACTION_DESIRE_LOW, npcBot
            end
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_FARM then
        if #creeps >= 2 and CanCast[abilityNumber](npcBot) then
            if ManaPercentage > 0.5 then
                return BOT_ACTION_DESIRE_LOW, npcBot
            end
        end
    end
    return BOT_ACTION_DESIRE_NONE, 0
end
Consider[4] = function()
    local abilityNumber = 4
    local ability = AbilitiesReal[abilityNumber]
    if not ability:IsFullyCastable() or npcBot:HasModifier("modifier_ice_blast") or not npcBot:WasRecentlyDamagedByAnyHero(1.5) then
        return BOT_ACTION_DESIRE_NONE
    end
    if HealthPercentage <= 0.3 or health <= 370 + npcBot:GetLevel() * 3 then
        return BOT_ACTION_DESIRE_HIGH
    end
    if HealthPercentage <= 0.5 and fun1:IsSeverelyDisabled(npcBot) and not AbilitiesReal[2]:IsFullyCastable() then
        return BOT_ACTION_DESIRE_HIGH
    end
    return BOT_ACTION_DESIRE_NONE
end
AbilityExtensions:AutoModifyConsiderFunction(npcBot, Consider, AbilitiesReal)
function AbilityUsageThink()
    if npcBot:IsUsingAbility() or npcBot:IsChanneling() or npcBot:IsSilenced() then
        return
    end
    ComboMana = GetComboMana()
    AttackRange = npcBot:GetAttackRange()
    ManaPercentage = npcBot:GetMana() / npcBot:GetMaxMana()
    HealthPercentage = npcBot:GetHealth() / npcBot:GetMaxHealth()
    attackRange = npcBot:GetAttackRange()
    health = npcBot:GetHealth()
    healthPercent = AbilityExtensions:GetHealthPercent(npcBot)
    mana = npcBot:GetMana()
    manaPercent = AbilityExtensions:GetManaPercent(npcBot)
    cast = ability_item_usage_generic.ConsiderAbility(AbilitiesReal, Consider)
    if debugmode == true then
        ability_item_usage_generic.PrintDebugInfo(AbilitiesReal, cast)
    end
    ability_item_usage_generic.UseAbility(AbilitiesReal, cast)
end
function CourierUsageThink()
    ability_item_usage_generic.CourierUsageThink()
end
