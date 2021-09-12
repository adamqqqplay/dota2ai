---------------------------------------------
-- Generated from Mirana Compiler version 1.5.4
-- Do not modify
-- https://github.com/AaronSong321/Mirana
---------------------------------------------
local utility = require(GetScriptDirectory().."/utility")
local ability_item_usage_generic = require(GetScriptDirectory().."/ability_item_usage_generic")
local AbilityExtensions = require(GetScriptDirectory().."/util/AbilityAbstraction")
local npcBot = GetBot()
if npcBot:IsIllusion() then
    return
end
local AbilityNames,Abilities,Talents = AbilityExtensions:InitAbility()
local AbilityToLevelUp = {
    AbilityNames[1],
    AbilityNames[3],
    AbilityNames[1],
    AbilityNames[2],
    AbilityNames[1],
    AbilityNames[5],
    AbilityNames[1],
    AbilityNames[3],
    AbilityNames[2],
    "talent",
    AbilityNames[2],
    AbilityNames[5],
    AbilityNames[2],
    AbilityNames[3],
    "talent",
    AbilityNames[3],
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
        return Talents[2]
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
local CanCast = {}
CanCast[1] = function(t) return AbilityExtensions:NormalCanCast(t, false) end
CanCast[2] = CanCast[1]
CanCast[3] = function(t) return not AbilityExtensions:IsInvulnerable(t) or not AbilityExtensions:ShouldNotBeAttacked(t) end
CanCast[4] = function(t) return true end
CanCast[5] = CanCast[1]
local attackRange
local healthPercent
local mana
local manaPercent
local enemies
local realEnemies
local friends
local friendCount
local enemyCreeps
local friendCreeps
local neutralCreeps
local tower
local illusoryOrbCastLocation
local illusoryOrbMaxTravelDistance
local Consider = {}
local function GetIllusoryOrb()
    return AbilityExtensions:First(GetLinearProjectiles(), function(t) return t.ability and t.ability:GetName() == "puck_illusory_orb" and t.caster == npcBot end)
end
local illusoryOrb = GetIllusoryOrb()
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
    local damage = ability:GetDamage()
    local forbiddenCreeps = AbilityExtensions:Filter(enemyCreeps, function(t)
        return t:GetHealth() > t:GetActualIncomingDamage(damage, DAMAGE_TYPE_MAGICAL) and (t:GetHealth() <= t:GetActualIncomingDamage(damage, DAMAGE_TYPE_MAGICAL) + AbilityExtensions:AttackOnceDamage(npcBot, t) * (0.9 + #enemyCreeps * 0.1) or GetUnitToUnitDistance(tower, t) <= 700)
    end)
    if #friendCreeps == 0 then
        forbiddenCreeps = {}
    end
    if AbilityExtensions:NotRetreating(npcBot) then
        do
            local target = AbilityExtensions:GetTargetIfGood(npcBot)
            if target then
                coroutine.yield(BOT_ACTION_DESIRE_HIGH, target)
            end
        end
    end
    if AbilityExtensions:IsFarmingOrPushing(npcBot) then
        if #enemyCreeps > 3 and #forbiddenCreeps == 0 and manaPercent > 0.6 + manaCost then
            coroutine.yield(BOT_ACTION_DESIRE_MODERATE, enemyCreeps[2]:GetLocation())
        end
    elseif AbilityExtensions:IsRetreating(npcBot) then
    end
end
AbilityExtensions:AutoModifyConsiderFunction(npcBot, Consider, Abilities)
function AbilityUsageThink()
    if npcBot:IsUsingAbility() or npcBot:IsChanneling() or npcBot:IsSilenced() then
        return
    end
    attackRange = npcBot:GetAttackRange()
    healthPercent = AbilityExtensions:GetHealthPercent(npcBot)
    mana = npcBot:GetMana()
    manaPercent = AbilityExtensions:GetManaPercent(npcBot)
    enemies = AbilityExtensions:GetNearbyHeroes(npcBot, 1599)
    realEnemies = AbilityExtensions:Filter(enemies, function(t)
        return AbilityExtensions:MayNotBeIllusion(npcBot, t)
    end)
    friends = AbilityExtensions:GetNearbyHeroes(npcBot, 1599, true)
    friendCount = AbilityExtensions:GetEnemyHeroNumber(npcBot, friends)
    enemyCreeps = AbilityExtensions:GetNearbyAttackableCreeps(npcBot, 1599)
    friendCreeps = AbilityExtensions:GetNearbyAttackableCreeps(npcBot, npcBot:GetAttackRange() + 150, false)
    neutralCreeps = npcBot:GetNearbyNeutralCreeps(1599)
    tower = AbilityExtensions:GetLaningTower(npcBot)
    cast = ability_item_usage_generic.ConsiderAbility(Abilities, Consider)
    local abilityIndex,target,castType = ability_item_usage_generic.UseAbility(Abilities, cast)
    if abilityIndex == 1 then
        illusoryOrbCastLocation = npcBot:GetLocation()
        illusoryOrbMaxTravelDistance = Abilities[1]:GetSpecialValueInt("max_distance") - 50
    end
end
function CourierUsageThink()
    ability_item_usage_generic.CourierUsageThink()
end
