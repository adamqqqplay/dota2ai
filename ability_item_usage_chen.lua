---------------------------------------------
-- Generated from Mirana Compiler version 1.6.2
-- Do not modify
-- https://github.com/AaronSong321/Mirana
---------------------------------------------
local utility = require(GetScriptDirectory() .. "/utility")
local ability_item_usage_generic = require(GetScriptDirectory() .. "/ability_item_usage_generic")
local fun1 = require(GetScriptDirectory() .. "/util/AbilityAbstraction")
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
    Abilities[1],
    Abilities[2],
    Abilities[2],
    Abilities[1],
    Abilities[2],
    Abilities[4],
    Abilities[2],
    Abilities[1],
    Abilities[1],
    "talent",
    Abilities[3],
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
        return Talents[2]
    end,
    function()
        return Talents[3]
    end,
    function()
        return Talents[6]
    end,
    function()
        return Talents[7]
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
local cast = {}
cast.Desire = {}
cast.Target = {}
cast.Type = {}
local Consider = {}
local CanCast = {
    function(t)
        return t:GetLevel() <= AbilitiesReal[2]:GetLevel() + 2
    end,
    utility.NCanCast,
    utility.NCanCast,
    utility.UCanCast,
}
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
    local CastRange = ability:GetCastRange()
    local Damage = 0
    local CastPoint = ability:GetCastPoint()
    local allys = fun1:GetNearbyHeroes(npcBot, 1200, false)
    local enemys = fun1:GetNearbyHeroes(npcBot, CastRange + 300, true)
    local WeakestEnemy, HeroHealth = utility.GetWeakestUnit(enemys)
    local creeps = fun1:GetNearbyCreeps(npcBot, CastRange + 300, true)
    local WeakestCreep, CreepHealth = utility.GetWeakestUnit(creeps)
    local enemys2 = fun1:GetNearbyCreeps(npcBot, 400, true)
    if (npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH) or
        #enemys2 > 0 then
        for _, npcEnemy in pairs(enemys) do
            if (npcBot:WasRecentlyDamagedByHero(npcEnemy, 2.0) and CanCast[abilityNumber](npcEnemy)) or
                GetUnitToUnitDistance(npcBot, npcEnemy) < 400 then
                return BOT_ACTION_DESIRE_HIGH, npcEnemy
            end
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_ROAM or npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
        npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or npcBot:GetActiveMode() == BOT_MODE_ATTACK then
        local npcEnemy = npcBot:GetTarget()
        if npcEnemy ~= nil then
            if CanCast[abilityNumber](npcEnemy) and GetUnitToUnitDistance(npcBot, npcEnemy) < CastRange + 75 * #allys then
                return BOT_ACTION_DESIRE_MODERATE, npcEnemy
            end
        end
    end
    return BOT_ACTION_DESIRE_NONE, 0
end
local goodNeutral = {
    "npc_dota_neutral_alpha_wolf",
    "npc_dota_neutral_centaur_khan",
    "npc_dota_neutral_dark_troll_warlord",
    "npc_dota_neutral_polar_furbolg_ursa_warrior",
    "npc_dota_neutral_satyr_hellcaller",
    "npc_dota_neutral_enraged_wildkin",
}
local function IsGoodNeutralCreeps(npcCreep)
    local name = npcCreep:GetUnitName()
    for k, creepName in pairs(goodNeutral) do
        if name == creepName then
            return true
        end
    end
    return false
end

Consider[2] = function()
    local abilityNumber = 2
    local ability = AbilitiesReal[abilityNumber]
    if not ability:IsFullyCastable() then
        return BOT_ACTION_DESIRE_NONE, 0
    end
    local CastRange = ability:GetCastRange()
    local Damage = 0
    local CastPoint = ability:GetCastPoint()
    local allys = fun1:GetNearbyHeroes(npcBot, 1200, false)
    local enemys = fun1:GetNearbyHeroes(npcBot, CastRange + 300, true)
    local WeakestEnemy, HeroHealth = utility.GetWeakestUnit(enemys)
    local creeps = fun1:GetNearbyCreeps(npcBot, CastRange + 300, true)
    local WeakestCreep, CreepHealth = utility.GetWeakestUnit(creeps)
    local creepsNeutral = npcBot:GetNearbyNeutralCreeps(1600)
    local StrongestCreep, CreepHealth2 = utility.GetStrongestUnit(creepsNeutral)
    local holyPersuasionLevelLimit = AbilitiesReal[2]:GetLevel() + 2
    local canEnchantAncientCreep = npcBot:GetLevel() <= 15
    if ManaPercentage >= 0.3 then
        for k, creep in pairs(creepsNeutral) do
            if (
                IsGoodNeutralCreeps(creep) and holyPersuasionLevelLimit >= creep:GetLevel() or
                    (creep:IsAncientCreep() and fun1:HasScepter(npcBot))) and CanCast[2](creep) and
                not creep:WasRecentlyDamagedByAnyHero(1.5) then
                return BOT_ACTION_DESIRE_HIGH, creep
            end
        end
    end
    local recallDesire, target = ConsiderRecall()
    if recallDesire > 0 then
        return recallDesire, target
    end
    return BOT_ACTION_DESIRE_NONE
end
function ConsiderRecall()
    local abilityNumber = 3
    local ability = AbilitiesReal[abilityNumber]
    if not ability:IsFullyCastable() then
        return BOT_ACTION_DESIRE_NONE, 0
    end
    local allys = fun1:GetNearbyHeroes(npcBot, 1200, false)
    local enemys = fun1:GetNearbyHeroes(npcBot, 1600, true)
    local WeakestEnemy, HeroHealth = utility.GetWeakestUnit(enemys)
    local creeps = fun1:GetNearbyCreeps(npcBot, 1600, true)
    local WeakestCreep, CreepHealth = utility.GetWeakestUnit(creeps)
    local numPlayer = GetTeamPlayers(GetTeam())
    return BOT_ACTION_DESIRE_NONE, 0
end

local GetAllAllyHeroes = fun1:EveryManySeconds(2, function()
    return fun1:GetAllHeores(npcBot, false)
end)
Consider[4] = function()
    local abilityNumber = 4
    local ability = AbilitiesReal[abilityNumber]
    if not ability:IsFullyCastable() then
        return BOT_ACTION_DESIRE_NONE, 0
    end
    local healAmount = ability:GetSpecialValueInt("heal_amount")
    local function IsSeverelyDamaged(npc)
        return (fun1:GetHealthPercent(npc) <= 0.3 or npc:GetHealth() <= 400) and fun1:IsSeverelyDisabled(npc) and
            npc:WasRecentlyDamagedByAnyHero(0.8)
    end

    local function IsDamaged(npc)
        return npc:GetHealth() <= 400 or
            fun1:GetHealthDeficit(npc) >= healAmount * 1.3 and npc:GetUnitName() ~= "npc_dota_hero_huskar" and
            npc:WasRecentlyDamagedByAnyHero(1.2)
    end

    local castRange = 1599
    local enemies = fun1:GetNearbyNonIllusionHeroes(npcBot)
    local allys = GetAllAllyHeroes()
    if not fun1:CalledOnThisFrame(allys) then
        allys = fun1:GetNearbyNonIllusionHeroes(npcBot, castRange, false)
    end
    allys = fun1:Filter(allys, function(t)
        return not t:IsInvulnerable() and not t:HasModifier("modifier_ice_blast")
    end)
    local damagedAllies = fun1:Filter(allys, function(t)
        return IsDamaged(t) and not IsSeverelyDamaged(t)
    end)
    local severelyDamagedAllies = fun1:Filter(allys, IsSeverelyDamaged)
    if npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH then
        if npcBot:WasRecentlyDamagedByAnyHero(1.0) and (not IsSeverelyDamaged(npcBot) or #damagedAllies >= 2) then
            return BOT_ACTION_DESIRE_HIGH
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_LANING then
        if #damagedAllies >= 2 and #severelyDamagedAllies >= 1 then
            return BOT_ACTION_DESIRE_MODERATE
        end
    end
    local tableNearbyAttackingAlliedHeroes = npcBot:GetNearbyHeroes(1000, false, BOT_MODE_ATTACK)
    if #tableNearbyAttackingAlliedHeroes >= 2 and #enemies > 0 then
        if fun1:Contains(severelyDamagedAllies, npcBot) and #damagedAllies >= 3 or
            #damagedAllies >= 2 and #severelyDamagedAllies >= 1 then
            return BOT_ACTION_DESIRE_HIGH
        end
    end
    return 0
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
    ability_item_usage_generic.UseAbility(AbilitiesReal, cast)
end

function CourierUsageThink()
    ability_item_usage_generic.CourierUsageThink()
end
