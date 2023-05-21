---------------------------------------------
-- Generated from Mirana Compiler version 1.6.2
-- Do not modify
-- https://github.com/AaronSong321/Mirana
---------------------------------------------
local utility = require(GetScriptDirectory() .. "/utility")
local ability_item_usage_generic = require(GetScriptDirectory() .. "/ability_item_usage_generic")
local AbilityExtensions = require(GetScriptDirectory() .. "/util/AbilityAbstraction")
local debugmode = false
local npcBot = GetBot()
if npcBot == nil or npcBot:IsIllusion() then
	return
end

local Talents = {}
local Abilities = {}
local AbilitiesReal = {}
ability_item_usage_generic.InitAbility(Abilities, AbilitiesReal, Talents)
local AbilityToLevelUp = {
    Abilities[2],
    Abilities[1],
    Abilities[1],
    Abilities[2],
    Abilities[1],
    Abilities[5],
    Abilities[1],
    Abilities[3],
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
        return Talents[8]
    end,
}
utility.CheckAbilityBuild(AbilityToLevelUp)
function BuybackUsageThink()
	ability_item_usage_generic.BuybackUsageThink();
end

function CourierUsageThink()
	ability_item_usage_generic.CourierUsageThink();
end

function AbilityLevelUpThink()
    ability_item_usage_generic.AbilityLevelUpThink2(AbilityToLevelUp, TalentTree)
end

local cast = {}
cast.Desire = {}
cast.Target = {}
cast.Type = {}
local Consider = {}
local CanCast = {
    function(t)
        return AbilityExtensions:NormalCanCast(t, false, DAMAGE_TYPE_PURE, true, false)
    end,
    AbilityExtensions.NormalCanCastFunction,
    utility.NCanCast,
    utility.CanCastNoTarget,
    function(t)
        return AbilityExtensions:NormalCanCast(t, false, DAMAGE_TYPE_MAGICAL, true, true) and
            not AbilityExtensions:HasAbilityRetargetModifier(t)
    end,
}
Consider[1] = function()
    local ability = AbilitiesReal[1]
    if not ability:IsFullyCastable() or npcBot:IsChanneling() then
        return 0
    end
    local castPoint = ability:GetCastPoint()
    local range = ability:GetSpecialValueInt("hook_distance")
    local searchRadius = ability:GetSpecialValueInt("hook_width")
    local hookSpeed = ability:GetSpecialValueFloat("hook_speed")
    local allNearbyUnits = AbilityExtensions:GetNearbyAllUnits(npcBot, range):Remove(npcBot)
    local function NotBlockedByAnyUnit(line, target, distance)
        return AbilityExtensions:Remove(allNearbyUnits, target):All(function(t)
            local closeEnough = AbilityExtensions:GetPointToLineDistance(t:GetLocation(), line) <=
                searchRadius + target:GetBoundingRadius()
            local mayHook = closeEnough and distance > GetUnitToUnitDistance(npcBot, t)
            return not mayHook or t:IsInvulnerable()
        end)
    end

    local function T(target)
        if not CanCast[1](target) then
            return false
        end
        local point = target:GetExtrapolatedLocation(GetUnitToUnitDistance(npcBot, target) / hookSpeed + castPoint)
        local distance = GetUnitToLocationDistance(npcBot, point)
        local line = AbilityExtensions:GetLine(npcBot:GetLocation(), point)
        local result = GetUnitToLocationDistance(npcBot, point) <= range and NotBlockedByAnyUnit(line, target, distance)
        return result
    end

    if AbilityExtensions:IsAttackingEnemies(npcBot) then
        local enemies = AbilityExtensions:GetNearbyNonIllusionHeroes(npcBot, range, true, BOT_MODE_NONE)
        enemies = AbilityExtensions:SortByMaxFirst(enemies, function(t)
            return GetUnitToUnitDistance(npcBot, t)
        end)
        enemies = AbilityExtensions:Filter(enemies, T)
        if #enemies ~= 0 then
            return BOT_MODE_DESIRE_HIGH,
                enemies[1]:GetExtrapolatedLocation(GetUnitToUnitDistance(npcBot, enemies[1]) / hookSpeed)
        end
        do
            local ally = AbilityExtensions:GetNearbyNonIllusionHeroes(npcBot, range, false, BOT_MODE_NONE):Filter(allies
                , function(t)
                return t:IsStunned() or t:IsRooted()
            end):First(allies, T)
            if ally then
                return BOT_MODE_DESIRE_HIGH,
                    ally:GetExtrapolatedLocation(GetUnitToUnitDistance(npcBot, enemies[1]) / hookSpeed)
            end
        end
    end
    if AbilityExtensions:IsAttackingEnemies(npcBot) then
        do
            local atos = AbilityExtensions:GetAvailableItem(npcBot, "item_rod_of_atos") or
                AbilityExtensions:GetAvailableItem(npcBot, "item_gungir")
            if atos then
                do
                    local t = AbilityExtensions:GetNearbyNonIllusionHeroes(npcBot, range):First(function(t)
                        return not AbilityExtensions:CannotMove(t) and T(t) and AbilityExtensions:NormalCanCast(t)
                    end)
                    if t then
                        if atos:GetName() == "item_rod_of_atos" then
                            ItemUsage.UseItemOnEntity(npcBot, atos, t)
                        else
                            ItemUsage.UseItemOnLocation(npcBot, atos, t:GetLocation())
                        end
                        return 0
                    end
                end
            end
        end
        do
            local target = AbilityExtensions:GetTargetIfGood(npcBot)
            if target then
                if T(target) then
                    return BOT_ACTION_DESIRE_HIGH,
                        target:GetExtrapolatedLocation(GetUnitToUnitDistance(npcBot, target) / hookSpeed + castPoint)
                end
            end
        end
        do
            local enemy = AbilityExtensions:GetNearbyNonIllusionHeroes(npcBot, range):First(function(t)
                return (AbilityExtensions:CannotMove(t) or AbilityExtensions:GetMovementSpeedPercent(t) <= 0.3) and T(t)
            end)
            if enemy then
                return BOT_ACTION_DESIRE_HIGH,
                    enemy:GetExtrapolatedLocation(GetUnitToUnitDistance(npcBot, enemy) / hookSpeed + castPoint)
            end
        end
    end
    return 0
end
Consider[2] = function()
    local ability = AbilitiesReal[2]
    local radius = ability:GetAOERadius()
    if not ability:IsFullyCastable() then
        return 0
    end
    if AbilityExtensions:IsAttackingEnemies(npcBot) or AbilityExtensions:IsRetreating(npcBot) then
        do
            local nearbyEnemies = AbilityExtensions:GetNearbyHeroes(npcBot, radius, true)
            if nearbyEnemies:Any(CanCast[2]) then
                return true
            end
        end
    end
    do
        local target = npcBot:GetTarget()
        if target and GetUnitToUnitDistance(target, npcBot) <= radius and CanCast[2](target) then
            if not AbilityExtensions:IsHero(target) or AbilityExtensions:MustBeIllusion(npcBot, target) then
                if npcBot:GetHealth() <= 270 or
                    AbilityExtensions:GetHealthPercent(npcBot) <= 0.3 and npcBot:WasRecentlyDamagedByHero(target, 1.5) then
                    return false
                end
            end
            return true
        end
    end
    return false
end
Consider[2] = AbilityExtensions:ToggleFunctionToAction(npcBot, Consider[2], AbilitiesReal[2])
local swallowingSomething
local swallowTimer
Consider[4] = function()
    local ability = AbilitiesReal[4]
    if not ability:IsFullyCastable() or npcBot:IsChanneling() then
        return 0
    end
    swallowingSomething = npcBot:HasModifier("modifier_pudge_swallow") or
        npcBot:HasModifier("modifier_pudge_swallow_effect") or npcBot:HasModifier("modifier_pudge_swallow_hide")
    if swallowingSomething then
        if swallowTimer ~= nil then
            if DotaTime() >= swallowTimer + 3 then
                return BOT_MODE_DESIRE_VERYHIGH
            end
        else
            swallowTimer = DotaTime()
        end
    end
    return 0
end
Consider[5] = function()
    local ability = AbilitiesReal[5]
    if not ability:IsFullyCastable() or npcBot:IsChanneling() then
        return nil
    end
    local range = ability:GetCastRange() + 100
    local hookedEnemy = AbilityExtensions:First(AbilityExtensions:GetNearbyNonIllusionHeroes(npcBot, range, true,
        BOT_MODE_NONE), function(t)
        return t:IsHero() and AbilityExtensions:MayNotBeIllusion(npcBot, t) and t:HasModifier("modifier_pudge_meat_hook")
    end)
    if hookedEnemy then
        return BOT_MODE_DESIRE_VERYHIGH, hookedEnemy
    end
    do
        local target = AbilityExtensions:GetTargetIfGood(npcBot)
        if target and CanCast[5](target) and GetUnitToUnitDistance(npcBot, target) <= range then
            return BOT_MODE_DESIRE_HIGH, target
        end
    end
    local nearbyEnemies = AbilityExtensions:GetNearbyNonIllusionHeroes(npcBot, 900, true, BOT_MODE_NONE)
    if AbilityExtensions:IsAttackingEnemies(npcBot) then
        do
            local u = utility.GetWeakestUnit(nearbyEnemies)
            if u and CanCast[5](u) then
                return BOT_MODE_DESIRE_HIGH, u
            end
        end
    end
    if AbilityExtensions:IsRetreating(npcBot) and #nearbyEnemies == 1 then
        do
            local loneEnemy = nearbyEnemies[1]
            if loneEnemy and not AbilityExtensions:HasAbilityRetargetModifier(loneEnemy) and CanCast[5](loneEnemy) then
                return BOT_MODE_DESIRE_MODERATE, loneEnemy
            end
        end
    end
    return 0
end
function CourierUsageThink()
    ability_item_usage_generic.CourierUsageThink()
end

function AbilityUsageThink()
    if npcBot:IsUsingAbility() or npcBot:IsSilenced() then
        return
    end
    cast = ability_item_usage_generic.ConsiderAbility(AbilitiesReal, Consider)
    ability_item_usage_generic.UseAbility(AbilitiesReal, cast)
end
