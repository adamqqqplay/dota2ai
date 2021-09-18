---------------------------------------------
-- Generated from Mirana Compiler version 1.6.1
-- Do not modify
-- https://github.com/AaronSong321/Mirana
---------------------------------------------
local utility = require(GetScriptDirectory().."/utility")
require(GetScriptDirectory().."/ability_item_usage_generic")
local fun1 = require(GetScriptDirectory().."/util/AbilityAbstraction")
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
    Abilities[3],
    Abilities[1],
    Abilities[3],
    Abilities[1],
    Abilities[1],
    Abilities[5],
    Abilities[1],
    Abilities[3],
    Abilities[3],
    "talent",
    Abilities[2],
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
local TalentTree = {
    function()
        return Talents[2]
    end,
    function()
        return Talents[4]
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
local CanCast = {
    utility.NCanCast,
    utility.NCanCast,
    utility.NCanCast,
    function(t)
        return fun1:AllyCanCast(t) and not t:HasModifier "modifier_lycan_wolf_bite_lifesteal"
    end,
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
    local CastRange = 500
    local CastPoint = ability:GetCastPoint()
    local allys = npcBot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
    local enemys = npcBot:GetNearbyHeroes(CastRange + 300, true, BOT_MODE_NONE)
    local WeakestEnemy,HeroHealth = utility.GetWeakestUnit(enemys)
    local creeps = npcBot:GetNearbyCreeps(CastRange + 300, true)
    local WeakestCreep,CreepHealth = utility.GetWeakestUnit(creeps)
    local wolves = 0
    local units = GetUnitList(UNIT_LIST_ALLIES)
    for _, unit in pairs(units) do
        if string.find(unit:GetUnitName(), "npc_dota_lycan_wolf") then
            wolves = wolves + 1
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_LANING then
        if ManaPercentage > 0.6 or npcBot:GetMana() > ComboMana and wolves < 1 then
            return BOT_ACTION_DESIRE_LOW
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT then
        local locationAoE = npcBot:FindAoELocation(true, false, npcBot:GetLocation(), 600, 300, 0, 0)
        if locationAoE.count >= 3 and npcBot:GetMana() / npcBot:GetMaxMana() > 0.65 and wolves < 1 then
            return BOT_ACTION_DESIRE_LOW
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH then
        if npcBot:WasRecentlyDamagedByAnyHero(2.0) and wolves < 1 then
            return BOT_ACTION_DESIRE_HIGH
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_FARM then
        local npcTarget = npcBot:GetAttackTarget()
        if npcTarget ~= nil then
            return BOT_ACTION_DESIRE_LOW
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_ROSHAN then
        local npcTarget = npcBot:GetAttackTarget()
        if npcTarget ~= nil then
            if string.find(npcTarget:GetUnitName(), "roshan") and GetUnitToUnitDistance(npcBot, npcTarget) < 600 and wolves < 1 then
                return BOT_ACTION_DESIRE_LOW
            end
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_ROAM or npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or npcBot:GetActiveMode() == BOT_MODE_ATTACK then
        local npcEnemy = npcBot:GetTarget()
        if npcEnemy ~= nil then
            if GetUnitToUnitDistance(npcBot, npcEnemy) < CastRange + 75 * #allys and wolves < 1 then
                return BOT_ACTION_DESIRE_MODERATE, npcEnemy
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
    local CastRange = ability:GetCastRange()
    local CastPoint = ability:GetCastPoint()
    local allys = fun1:GetNearbyNonIllusionHeroes(npcBot, 1600, false)
    local enemies = fun1:GetNearbyNonIllusionHeroes(npcBot, 1600, true)
    local radius = 2000
    if allys:Any(function(t)
        return fun1:GetHealthPercent(t) <= 0.5 and t:WasRecentlyDamagedByAnyHero(1.5)
    end) then
        return BOT_ACTION_DESIRE_MODERATE
    end
    if npcBot:GetActiveMode() == BOT_MODE_RETREAT and #enemies > 0 then
        if npcBot:WasRecentlyDamagedByAnyHero(2.0) then
            return BOT_ACTION_DESIRE_HIGH
        end
    end
end
Consider[4] = function()
    local abilityNumber = 4
    local ability = AbilitiesReal[abilityNumber]
    if not ability:IsFullyCastable() or ability:IsHidden() then
        return BOT_ACTION_DESIRE_NONE
    end
    local CastRange = ability:GetCastRange()
    local mana = npcBot:GetMana()
    local allys = fun1:GetNearbyNonIllusionHeroes(npcBot, CastRange + 200, false):Filter(CanCast[4])
    local enemies = fun1:GetNearbyNonIllusionHeroes(npcBot, 1500)
    local enemyCount = fun1:GetEnemyHeroNumber(npcBot, enemies)
    if enemyCount > 0 then
        local function BiteAllyDesire(ally)
            local desire = 0
            local perc = fun1:GetHealthPercent(ally)
            desire = desire + RemapValClamped(perc, 0.3, 0.8, 2, 1)
            if fun1:IsSeverelyDisabled(ally) then
                desire = desire - 1
            end
            local speed = fun1:GetMovementSpeedPercent(ally)
            desire = desire + RemapValClamped(speed, 0.2, 0.7, 0.8, 0)
            if ally:HasModifier "modifier_ice_blast" or fun1:IsRetreating(ally) then
                desire = desire - 0.5
            end
            desire = desire * Clamp(ally:GetNetWorth() / npcBot:GetNetWorth(), 0.5, 2)
            if mana <= 300 and AbilitiesReal[5]:IsFullyCastable() or mana <= 160 then
                desire = desire / 2
            end
            return desire
        end
        do
            local target = allys:Map(function(t)
                return {
                    t,
                    BiteAllyDesire(t),
                }
            end):SortByMaxFirst(function(t)
                return t[2]
            end):First(function(t)
                return t[2] >= 0.9
            end)
            if target then
                return RemapValClamped(target[2], 0.9, 2, BOT_ACTION_DESIRE_MODERATE, BOT_ACTION_DESIRE_VERYHIGH), target[1]
            end
        end
    else
        if mana >= 350 then
            do
                local target = allys:Filter(function(t)
                    return CanCast[4](t) and not t:HasModifier "modifier_ice_blast" and fun1:NotRetreating(t)
                end):Map(function(t)
                    return {
                        t,
                        (1 - fun1:GetHealthPercent(ally)) * fun1:GetTargetHealAmplifyPercent(ally),
                    }
                end):SortByMaxFirst(function(t)
                    return t[2]
                end):First(function(t)
                    return t[2] >= 0.6
                end)
                if target then
                    return BOT_ACTION_DESIRE_MODERATE, target[1]
                end
            end
        end
    end
    return BOT_ACTION_DESIRE_NONE
end
Consider[5] = function()
    local abilityNumber = 5
    local ability = AbilitiesReal[abilityNumber]
    if not ability:IsFullyCastable() then
        return BOT_ACTION_DESIRE_NONE, 0
    end
    local CastRange = ability:GetCastRange()
    local CastPoint = ability:GetCastPoint()
    local allys = npcBot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
    local enemys = npcBot:GetNearbyHeroes(CastRange + 300, true, BOT_MODE_NONE)
    local WeakestEnemy,HeroHealth = utility.GetWeakestUnit(enemys)
    local creeps = npcBot:GetNearbyCreeps(CastRange + 300, true)
    local WeakestCreep,CreepHealth = utility.GetWeakestUnit(creeps)
    if npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH then
        if npcBot:WasRecentlyDamagedByAnyHero(2.0) then
            return BOT_ACTION_DESIRE_HIGH
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_ROAM or npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or npcBot:GetActiveMode() == BOT_MODE_ATTACK then
        local npcEnemy = fun1:GetTargetIfGood(npcBot)
        if npcEnemy ~= nil then
            if CanCast[abilityNumber](npcEnemy) and GetUnitToUnitDistance(npcBot, npcEnemy) < 600 + 75 * #allys then
                return BOT_ACTION_DESIRE_MODERATE
            end
        end
    end
    local tableNearbyAttackingAlliedHeroes = npcBot:GetNearbyHeroes(700, false, BOT_MODE_ATTACK)
    if #tableNearbyAttackingAlliedHeroes >= 2 then
        local npcEnemy = fun1:GetTargetIfGood(npcBot)
        if GetUnitToUnitDistance(npcBot, npcEnemy) <= 600 then
            return BOT_ACTION_DESIRE_HIGH - 0.1
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
