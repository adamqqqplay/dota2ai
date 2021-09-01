---------------------------------------------
-- Generated from Mirana Compiler version 1.0.0
-- Do not modify
-- https://github.com/AaronSong321/Mirana
---------------------------------------------
local utility = require(GetScriptDirectory().."/utility")
require(GetScriptDirectory().."/ability_item_usage_generic")
local AbilityExtensions = require(GetScriptDirectory().."/util/AbilityAbstraction")
local debugmode = false
local npcBot = GetBot()
local Talents = {}
local Abilities = {}
local AbilitiesReal = {}
ability_item_usage_generic.InitAbility(Abilities, AbilitiesReal, Talents)
local AbilityToLevelUp = {
    Abilities[3],
    Abilities[2],
    Abilities[1],
    Abilities[1],
    Abilities[1],
    Abilities[4],
    Abilities[1],
    Abilities[3],
    Abilities[3],
    "talent",
    Abilities[2],
    Abilities[4],
    Abilities[2],
    Abilities[2],
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
    local WeakestEnemy,HeroHealth = utility.GetWeakestUnit(enemys)
    local creeps = npcBot:GetNearbyCreeps(CastRange + 300, true)
    local WeakestCreep,CreepHealth = utility.GetWeakestUnit(creeps)
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
                if HeroHealth <= WeakestEnemy:GetActualIncomingDamage(Damage, DAMAGE_TYPE_MAGICAL) or (HeroHealth <= WeakestEnemy:GetActualIncomingDamage(GetComboDamage(), DAMAGE_TYPE_MAGICAL) and npcBot:GetMana() > ComboMana) then
                    if GetUnitToUnitDistance(npcBot, WeakestEnemy) < CastRange and not npcBot:HasModifier("modifier_bounty_hunter_shadow_walk") then
                        return BOT_ACTION_DESIRE_HIGH, WeakestEnemy
                    elseif creeps[1] ~= nil and not npcBot:HasModifier("modifier_bounty_hunter_shadow_walk") and WeakestEnemy:HasModifier("modifier_bounty_hunter_track") then
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
    if npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT then
        if #enemys >= 1 then
            if ManaPercentage > 0.5 or npcBot:GetMana() > ComboMana then
                if WeakestEnemy ~= nil then
                    if CanCast[abilityNumber](WeakestEnemy) then
                        if GetUnitToUnitDistance(npcBot, WeakestEnemy) < CastRange and not npcBot:HasModifier("modifier_bounty_hunter_shadow_walk") then
                            return BOT_ACTION_DESIRE_HIGH, WeakestEnemy
                        elseif creeps[1] ~= nil and WeakestEnemy:HasModifier("modifier_bounty_hunter_track") and not npcBot:HasModifier("modifier_bounty_hunter_shadow_walk") then
                            return BOT_ACTION_DESIRE_HIGH, creeps[1]
                        end
                    end
                end
            end
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_ROAM or npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or npcBot:GetActiveMode() == BOT_MODE_ATTACK then
        local npcEnemy = npcBot:GetTarget()
        if npcEnemy ~= nil then
            if CanCast[abilityNumber](npcEnemy) then
                if GetUnitToUnitDistance(npcBot, npcEnemy) < CastRange then
                    return BOT_ACTION_DESIRE_HIGH, npcEnemy
                elseif creeps[1] ~= nil and npcEnemy:HasModifier("modifier_bounty_hunter_track") then
                    return BOT_ACTION_DESIRE_HIGH, creeps[1]
                end
            end
        end
    end
    return BOT_ACTION_DESIRE_NONE, 0
end
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
    local WeakestEnemy,HeroHealth = utility.GetWeakestUnit(enemys)
    local creeps = npcBot:GetNearbyCreeps(CastRange + 300, true)
    local WeakestCreep,CreepHealth = utility.GetWeakestUnit(creeps)
    if npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_MODERATE then
        if npcBot:WasRecentlyDamagedByAnyHero(2.0) then
            return BOT_ACTION_DESIRE_HIGH
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_ROAM or npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or npcBot:GetActiveMode() == BOT_MODE_ATTACK then
        local npcEnemy = AbilityExtensions:GetTargetIfGood(npcBot)
        if npcEnemy ~= nil then
            if GetUnitToUnitDistance(npcBot, npcEnemy) <= 2000 then
                return BOT_ACTION_DESIRE_MODERATE
            end
        end
    end
    return BOT_ACTION_DESIRE_NONE
end
Consider[4] = function()
    local abilityNumber = 4
    local ability = AbilitiesReal[abilityNumber]
    local function HasTrackModifierPenalty(t)
        return AbilityExtensions:GetModifierRemainingDuration("modifier_bounty_hunter_track") <= 5 and 0.5 or 1
    end
    if not ability:IsFullyCastable() then
        return BOT_ACTION_DESIRE_NONE
    end
    local CastRange = Clamp(ability:GetCastRange(), 0, 1599)
    local realEnemies = AbilityExtensions:GetNearbyNonIllusionHeroes(npcBot, CastRange):Filter(function(__mira_lpar_it)
        return AbilityExtensions:SpellCanCast(__mira_lpar_it) and __mira_lpar_it:IsHero() and AbilityExtensions:MayNotBeIllusion(npcBot, __mira_lpar_it)
    end):Map(function(__mira_lpar_it)
        return {
            __mira_lpar_it,
            __mira_lpar_it:GetHealth() * HasTrackModifierPenalty(__mira_lpar_it),
        }
    end):SortByMinFirst(function(__mira_lpar_it)
        return __mira_lpar_it[2]
    end)
    if AbilityExtensions:Any(realEnemies) then
        local desire = RemapValClamped(realEnemies[2], 300 + ability:GetLevel() * 100, 1000, 0.8, 0.4)
        if desire >= 0.5 and ManaPercentage >= 0.4 or desire >= 0.7 then
            return desire, realEnemies[1]
        else
            return desire - 0.2, realEnemies[1]
        end
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
    cast = ability_item_usage_generic.ConsiderAbility(AbilitiesReal, Consider)
    if debugmode == true then
        ability_item_usage_generic.PrintDebugInfo(AbilitiesReal, cast)
    end
    ability_item_usage_generic.UseAbility(AbilitiesReal, cast)
end
function CourierUsageThink()
    ability_item_usage_generic.CourierUsageThink()
end
