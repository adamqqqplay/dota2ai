---------------------------------------------
-- Generated from Mirana Compiler version 1.6.2
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
    Abilities[2],
    Abilities[3],
    Abilities[6],
    Abilities[3],
    Abilities[2],
    Abilities[2],
    "talent",
    Abilities[2],
    Abilities[6],
    Abilities[1],
    Abilities[1],
    "talent",
    Abilities[1],
    "nil",
    Abilities[6],
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
        return Talents[7]
    end,
}
utility.CheckAbilityBuild(AbilityToLevelUp)
function AbilityLevelUpThink()
    ability_item_usage_generic.AbilityLevelUpThink2(AbilityToLevelUp, TalentTree)
end
function CanCast1(npcEnemy)
    if npcEnemy == nil then
        return false
    end
    return npcEnemy:CanBeSeen() and not npcEnemy:IsInvulnerable()
end
local cast = {}
cast.Desire = {}
cast.Target = {}
cast.Type = {}
local Consider = {}
function GetComboDamage()
    return ability_item_usage_generic.GetComboDamage(AbilitiesReal)
end
local level
local attackRange
local health
local maxHealth
local healthPercent
local mana
local maxMana
local manaPercent
local netWorth
local allEnemies
local enemies
local enemyCount
local friends
local friendCount
local enemyCreeps
local friendCreeps
local neutralCreeps
local tower
local CanCast = {
    function(t)
        return not t:IsHero() and not fun1:IsRoshan(t) and t:GetLevel() <= AbilitiesReal[1]:GetLevel() + 3 and (not t:IsAncient() or level >= 28)
    end,
    AbilityExtensions.NormalCanCastFunction,
    AbilityExtensions.PhysicalCanCastFunction,
    AbilityExtensions.NormalCanCastFunction,
    AbilityExtensions.NormalCanCastFunction,
    utility.UCanCast,
}
local enemyDisabled = utility.enemyDisabled
local function GetComboMana()
    local mana = 0
    local dotaTime = DotaTime() / 60
    local estimatedFightTime = (function()
        if dotaTime <= 20 then
            return RemapVal(dotaTime, 10, 20, 10, 15)
        elseif dotaTime <= 30 then
            return RemapVal(dotaTime, 20, 30, 15, 30)
        elseif dotaTime <= 45 then
            return RemapVal(dotaTime, 30, 45, 30, 50)
        else
            return 50
        end
    end)()
    local function GetAbilityMana(ability)
        if ability:GetManaCost() == 0 then
            return
        end
        local scorchedEarthReady = ability:IsFullyCastable()
        if scorchedEarthReady then
            mana = mana + ability:GetManaCost()
        end
        mana = mana + estimatedFightTime / ability:GetCooldown() * ability:GetManaCost()
    end
    fun1:ForEach({
        AbilitiesReal[2],
        AbilitiesReal[3],
        AbilitiesReal[6],
    }, function(t)
        return GetAbilityMana(t)
    end)
    if dotaTime >= 30 and AbilitiesReal[1]:IsCooldownReady() then
        mana = mana + AbilitiesReal[1]:GetManaCost()
    end
    return mana
end
Consider[1] = function()
    local abilityNumber = 1
    local ability = AbilitiesReal[abilityNumber]
    if not ability:IsFullyCastable() then
        return BOT_ACTION_DESIRE_NONE
    end
    local creeps = A.Dota.GetNearbyCreeps(npcBot, 800, true):Concat(A.Dota.GetNearbyNeutralCreeps(npcBot, 800))
    local strongstCreep = A.Linq.Filter(utility.GetStrongestUnit(creeps), CanCast[1])
    if strongstCreep then
        return BOT_ACTION_DESIRE_MODERATE, strongstCreep
    end
    return BOT_ACTION_DESIRE_NONE
end
Consider[2] = function()
    local abilityNumber = 2
    local ability = AbilitiesReal[abilityNumber]
    if not ability:IsFullyCastable() then
        return BOT_ACTION_DESIRE_NONE, 0
    end
    local Damage = ability:GetDuration() * ability:GetSpecialValueInt("damage_per_second")
    local Radius = ability:GetAOERadius()
    local allys = fun1:GetNearbyNonIllusionHeroes(npcBot, 1200, false)
    local allyCount = fun1:GetEnemyHeroNumber(npcBot, allys)
    local enemys = npcBot:GetNearbyHeroes(Radius + 300, true, BOT_MODE_NONE)
    local WeakestEnemy, HeroHealth = utility.GetWeakestUnit(enemys)
    local creeps = npcBot:GetNearbyCreeps(Radius + 300, true)
    local WeakestCreep, CreepHealth = utility.GetWeakestUnit(creeps)
    local abilityLevel = ability:GetLevel()
    if npcBot:WasRecentlyDamagedByAnyHero(2) or (npcBot:GetActiveMode() == BOT_MODE_RETREAT and HealthPercentage <= 0.4 + #enemys * 0.05) then
        return BOT_ACTION_DESIRE_HIGH
    end
    if npcBot:GetActiveMode() == BOT_MODE_ROAM or npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or npcBot:GetActiveMode() == BOT_MODE_ATTACK then
        local npcEnemy = npcBot:GetTarget()
        if ManaPercentage > 0.4 or npcBot:GetMana() > ComboMana then
            if npcEnemy ~= nil then
                if (GetUnitToUnitDistance(npcBot, npcEnemy) > 350 or npcEnemy:GetHealth() / npcEnemy:GetMaxHealth() < 0.4) and GetUnitToUnitDistance(npcBot, npcEnemy) < 900 then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_FARM then
        if (#creeps >= 3 and (ManaPercentage > 0.4 or npcBot:GetMana() > ComboMana)) and allyCount < 3 and abilityLevel >= 3 then
            return BOT_ACTION_DESIRE_LOW
        end
    end
    return BOT_ACTION_DESIRE_NONE
end
Consider[3] = function()
    local abilityNumber = 3
    local ability = AbilitiesReal[abilityNumber]
    if not ability:IsFullyCastable() or fun1:IsPhysicalOutputDisabled(npcBot) then
        return BOT_ACTION_DESIRE_NONE, 0
    end
    local CastRange = ability:GetCastRange()
    local Damage = ability:GetAbilityDamage()
    local allys = npcBot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
    local enemys = npcBot:GetNearbyHeroes(CastRange + 150, true, BOT_MODE_NONE)
    local WeakestEnemy, HeroHealth = utility.GetWeakestUnit(enemys)
    local creeps = npcBot:GetNearbyCreeps(CastRange + 150, true)
    local WeakestCreep, CreepHealth = utility.GetWeakestUnit(creeps)
    for _, npcEnemy in pairs(enemys) do
        if npcEnemy:IsChanneling() and CanCast[abilityNumber](npcEnemy) then
            return BOT_ACTION_DESIRE_HIGH, npcEnemy
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_ROAM or npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or npcBot:GetActiveMode() == BOT_MODE_ATTACK then
        local npcEnemy = npcBot:GetTarget()
        if npcEnemy ~= nil then
            if CanCast[abilityNumber](npcEnemy) and GetUnitToUnitDistance(npcBot, npcEnemy) < CastRange + 75 * #allys then
                return BOT_ACTION_DESIRE_MODERATE, npcEnemy
            end
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_LANING then
        if (HealthPercentage > 0.7 and ManaPercentage > 0.4 or npcBot:GetMana() > ComboMana) then
            if WeakestEnemy ~= nil then
                if CanCast[abilityNumber](WeakestEnemy) then
                    return BOT_ACTION_DESIRE_LOW, WeakestEnemy
                end
            end
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_FARM then
        if #creeps >= 1 and ManaPercentage > 0.6 or npcBot:GetMana() > ComboMana then
            return BOT_ACTION_DESIRE_LOW, creeps[1]
        end
    end
    return BOT_ACTION_DESIRE_NONE, 0
end
local function DoomEmptyAbilityThink(ability)
    return 0
end
local function centaur_khan_war_stomp(ability)
    if not ability:IsFullyCastable() then
        return 0
    end
    local radius = ability:GetAOERadius()
    local enemies = fun1:GetNearbyNonIllusionHeroes(npcBot, radius + 90)
    local allys = fun1:GetNearbyNonIllusionHeroes(npcBot, 800)
    if fun1:GetEnemyHeroNumber(npcBot, enemies) >= 2 and (AbilitiesReal[6]:IsFullyCastable() or #ally >= 2) then
        return RemapValClamped(mana, 100, ComboMana, BOT_ACTION_DESIRE_MODERATE, BOT_ACTION_DESIRE_HIGH)
    end
    if fun1:NotRetreating(npcBot) then
        do
            local target = fun1:GetTargetIfGood()
            if target then
                if fun1:NormalCanCast(target) and GetUnitToUnitDistance(npcBot, target) <= radius then
                    return RemapValClamped(mana, 100, ComboMana, BOT_ACTION_DESIRE_MODERATE, BOT_ACTION_DESIRE_HIGH)
                end
            end
        end
    else
        if enemies:Any(fun1.NormalCanCastFunction) then
            return RemapValClamped(mana, 100, ComboMana, BOT_ACTION_DESIRE_MODERATE, BOT_ACTION_DESIRE_HIGH)
        end
    end
    return 0
end
local function mud_golem_hurl_boulder(ability)
    if not ability:IsFullyCastable() then
        return 0
    end
    local castRange = ability:GetCastRange()
    local enemies = fun1:GetNearbyNonIllusionHeroes(npcBot, castRange + 200)
    local allys = fun1:GetNearbyNonIllusionHeroes(npcBot, 1000)
    do
        local target = enemies:Min(function(t)
            return t:GetHealth() * (function()
                if fun1:IsSeverelyDisabled(t) then
                    return 0.5
                else
                    return 1
                end
            end)()
        end)
        if target then
            return BOT_ACTION_DESIRE_HIGH, target
        end
    end
    if fun1:NotRetreating(npcBot) then
        do
            local target = fun1:GetTargetIfGood()
            if target then
                if fun1:NormalCanCast(target) then
                    return BOT_ACTION_DESIRE_MODERATE, target
                end
            end
        end
        do
            local target = fun1:GetTargetIfBad()
            if target then
                if fun1:NormalCanCast(target) then
                    return BOT_ACTION_DESIRE_MODERATE, target
                end
            end
        end
    else
        do
            local target = enemies:Min(function(t)
                return GetUnitToUnitDistance(npcBot, t)
            end)
            if target then
                if fun1:NormalCanCast(target) then
                    return BOT_ACTION_DESIRE_HIGH, target
                end
            end
        end
    end
    return 0
end
local function satyr_soulstealer_mana_burn(ability)
    if not ability:IsFullyCastable() then
        return 0
    end
    local manaCost = ability:GetManaCost()
    local castRange = ability:GetCastRange()
    local enemies = fun1:GetNearbyNonIllusionHeroes(npcBot, castRange + 200)
    local allys = fun1:GetNearbyNonIllusionHeroes(npcBot, 1200)
    if fun1:IsAttackingEnemies(npcBot) then
        if mana >= ComboMana + manaCost then
            do
                local target = enemies:Filter(fun1.NormalCanCastFunction):Min(function(t)
                    return t:GetHealth() * (function()
                        if fun1:IsSeverelyDisabledOrSlowed(t) then
                            return 2
                        else
                            return 1
                        end
                    end)()
                end)
                if target then
                    return BOT_ACTION_DESIRE_MODERATE - 0.1, target
                end
            end
        end
    end
    if fun1:IsLaning(npcBot) then
        if mana >= 110 then
            do
                local target = enemies:Filter(function(t)
                    if not fun1.NormalCanCastFunction(t) then
                        return false
                    end
                    if netWorth >= 15000 and not fun1:PhysicalCanCast(t) then
                        return false
                    end
                    return true
                end):Max(function(t)
                    local m = t:GetMana()
                    local desire = (function()
                        if m <= 40 then
                            return BOT_ACTION_DESIRE_LOW
                        elseif m <= 150 then
                            return BOT_ACTION_DESIRE_HIGH
                        else
                            return BOT_ACTION_DESIRE_MODERATE - 0.1
                        end
                    end)()
                    if t:GetUnitName() == "npc_dota_hero_obsidian_destroyer" then
                        desire = desire * 0.1
                    end
                    return desire
                end)
                if target then
                    return BOT_ACTION_DESIRE_MODERATE, target
                end
            end
        end
    end
    return 0
end
local function enraged_wildkin_tornado(ability)
    return 0
end
local function DoomAcquiredAbilityThink(ability)
    local abilityName = ability:GetName()
    if abilityName == "doom_bringer_empty1" or abilityName == "doom_bringer_empty2" then
        return DoomEmptyAbilityThink(ability)
    elseif abilityName == "satyr_soulstealer_mana_burn" then
        return satyr_soulstealer_mana_burn(ability)
    elseif abilityName == "centaur_khan_war_stomp" then
        return centaur_khan_war_stomp(ability)
    elseif abilityName == "mud_golem_hurl_boulder" then
        return mud_golem_hurl_boulder(ability)
    elseif abilityName == "enraged_wildkin_tornado" then
        return enraged_wildkin_tornado(ability)
    else
        return 0
    end
end
Consider[4] = function()
    return DoomAcquiredAbilityThink(AbilitiesReal[4])
end
Consider[5] = function()
    return DoomAcquiredAbilityThink(AbilitiesReal[5])
end
Consider[6] = function()
    local abilityNumber = 6
    local ability = AbilitiesReal[abilityNumber]
    if not ability:IsFullyCastable() then
        return BOT_ACTION_DESIRE_NONE, 0
    end
    local Damage = ability:GetDuration() * ability:GetSpecialValueInt("damage_per_second")
    local CastRange = ability:GetCastRange()
    local allys = fun1:GetNearbyNonIllusionHeroes(npcBot, 1200, false)
    local enemys = fun1:GetNearbyNonIllusionHeroes(npcBot, CastRange + 300, true)
    local WeakestEnemy, HeroHealth = utility.GetWeakestUnit(enemys)
    local creeps = npcBot:GetNearbyCreeps(CastRange + 300, true)
    local WeakestCreep, CreepHealth = utility.GetWeakestUnit(creeps)
    local tableNearbyAttackingAlliedHeroes = npcBot:GetNearbyHeroes(1000, false, BOT_MODE_ATTACK)
    if #tableNearbyAttackingAlliedHeroes >= 2 or #allys >= 3 then
        local npcMostDangerousEnemy = nil
        local nMostDangerousDamage = 0
        for _, npcEnemy in pairs(enemys) do
            if CanCast[abilityNumber](npcEnemy) and not enemyDisabled(npcEnemy) then
                local Damage2 = npcEnemy:GetEstimatedDamageToTarget(false, npcBot, 3.0, DAMAGE_TYPE_ALL)
                if Damage2 > nMostDangerousDamage then
                    nMostDangerousDamage = Damage2
                    npcMostDangerousEnemy = npcEnemy
                end
            end
        end
        if npcMostDangerousEnemy ~= nil then
            return BOT_ACTION_DESIRE_HIGH, npcMostDangerousEnemy
        end
    end
    do
        local channeling = enemys:First(function(t)
            return fun1:IsChannelingBreakWorthAbility(t, "moderate") and CanCast[6](t)
        end)
        if channeling then
            return BOT_ACTION_DESIRE_MODERATE - 0.1, channeling
        end
    end
    if npcBot:GetActiveMode() ~= BOT_MODE_RETREAT then
        if WeakestEnemy ~= nil then
            if CanCast[abilityNumber](WeakestEnemy) then
                if HeroHealth <= WeakestEnemy:GetActualIncomingDamage(Damage, DAMAGE_TYPE_MAGICAL) or (HeroHealth <= WeakestEnemy:GetActualIncomingDamage(GetComboDamage(), DAMAGE_TYPE_MAGICAL) and npcBot:GetMana() > ComboMana) then
                    return BOT_ACTION_DESIRE_HIGH, WeakestEnemy
                end
            end
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_ROAM or npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or npcBot:GetActiveMode() == BOT_MODE_ATTACK then
        do
            local npcEnemy = fun1:GetTargetIfGood(npcBot)
            if npcEnemy then
                if CanCast[abilityNumber](npcEnemy) and not enemyDisabled(npcEnemy) and GetUnitToUnitDistance(npcBot, npcEnemy) < CastRange + 75 * #allys then
                    return BOT_ACTION_DESIRE_MODERATE, npcEnemy
                end
            end
        end
    end
    return BOT_ACTION_DESIRE_NONE, 0
end
local RefreshAbilities = fun1:EveryManySeconds(2, function()
    AbilitiesReal = fun1:Range(1, 10):Map(function(t)
        return npcBot:GetAbilityInSlot(t)
    end):Filter(function(t)
        return t and t:GetName() ~= "ability_hidden" and not t:IsTalent()
    end)
end)
fun1:AutoModifyConsiderFunction(npcBot, Consider, AbilitiesReal)
function AbilityUsageThink()
    RefreshAbilities()
    if npcBot:IsUsingAbility() or npcBot:IsChanneling() or npcBot:IsSilenced() then
        return
    end
    ComboMana = GetComboMana()
    AttackRange = npcBot:GetAttackRange()
    ManaPercentage = npcBot:GetMana() / npcBot:GetMaxMana()
    HealthPercentage = npcBot:GetHealth() / npcBot:GetMaxHealth()
    level = npcBot:GetLevel()
    attackRange = npcBot:GetAttackRange()
    health = npcBot:GetHealth()
    maxHealth = npcBot:GetMaxHealth()
    healthPercent = fun1:GetHealthPercent(npcBot)
    mana = npcBot:GetMana()
    maxMana = npcBot:GetMaxMana()
    manaPercent = fun1:GetManaPercent(npcBot)
    netWorth = npcBot:GetNetWorth()
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
    if debugmode == true then
        ability_item_usage_generic.PrintDebugInfo(AbilitiesReal, cast)
    end
    ability_item_usage_generic.UseAbility(AbilitiesReal, cast)
end
function CourierUsageThink()
    ability_item_usage_generic.CourierUsageThink()
end
