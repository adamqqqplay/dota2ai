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
local Talents = {}
local Abilities = {}
local AbilitiesReal = {}
ability_item_usage_generic.InitAbility(Abilities, AbilitiesReal, Talents)
local AbilityToLevelUp = {
    Abilities[1],
    Abilities[3],
    Abilities[1],
    Abilities[2],
    Abilities[1],
    Abilities[5],
    Abilities[1],
    Abilities[3],
    Abilities[3],
    "talent",
    Abilities[3],
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
        return Talents[1]
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
    utility.CanCastNoTarget,
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
    if not ability:IsFullyCastable() or fun1:CannotMove(npcBot) then
        return BOT_ACTION_DESIRE_NONE, 0
    end
    if fun1:GameNotReallyStarting() then
        return 0
    end
    local CastRange = ability:GetSpecialValueInt("range")
    local allys = npcBot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
    local enemys = npcBot:GetNearbyHeroes(CastRange + 300, true, BOT_MODE_NONE)
    local WeakestEnemy,HeroHealth = utility.GetWeakestUnit(enemys)
    local trees = npcBot:GetNearbyTrees(300)
    if npcBot.FacelessVoidSkill1 == nil or DotaTime() - npcBot.FacelessVoidSkill1.Timer >= 2 then
        npcBot.FacelessVoidSkill1 = {
            Hp = HealthPercentage,
            Timer = DotaTime(),
        }
    end
    if npcBot:GetActiveMode() ~= BOT_MODE_RETREAT then
        if WeakestEnemy ~= nil then
            local enemys2 = WeakestEnemy:GetNearbyHeroes(900, true, BOT_MODE_NONE)
            if CanCast[abilityNumber](WeakestEnemy) and #enemys2 <= 2 then
                if HeroHealth <= WeakestEnemy:GetActualIncomingDamage(GetComboDamage(), DAMAGE_TYPE_MAGICAL) and npcBot:GetMana() > ComboMana then
                    return BOT_ACTION_DESIRE_MODERATE, utility.GetUnitsTowardsLocation(npcBot, WeakestEnemy, CastRange + 200)
                end
            end
        end
    end
    if trees ~= nil and #trees >= 6 then
        return BOT_ACTION_DESIRE_HIGH, utility.GetUnitsTowardsLocation(npcBot, GetAncient(GetTeam()), CastRange - 200) + RandomVector(200)
    end
    local projectiles = npcBot:GetIncomingTrackingProjectiles()
    for _, p in pairs(projectiles) do
        if GetUnitToLocationDistance(npcBot, p.location) <= 400 and p.is_attack == false and not fun1:IgnoreAbilityBlock(p.ability) then
            return BOT_ACTION_DESIRE_HIGH, fun1:GetPointFromLineByDistance(npcBot:GetLocation(), p.location, 450)
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_RETREAT or npcBot.FacelessVoidSkill1.Hp - HealthPercentage >= 0.25 + 0.05 * #enemys then
        return BOT_ACTION_DESIRE_HIGH, utility.GetUnitsTowardsLocation(npcBot, GetAncient(GetTeam()), CastRange)
    end
    if npcBot:GetActiveMode() ~= BOT_MODE_RETREAT and ManaPercentage > ComboMana and AbilitiesReal[4]:IsFullyCastable() then
        local locationAoE = npcBot:FindAoELocation(true, true, npcBot:GetLocation(), CastRange + 400, 425, 0, 0)
        if locationAoE.count >= 2 then
            return BOT_ACTION_DESIRE_HIGH + 0.05, locationAoE.targetloc
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_ROAM or npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or npcBot:GetActiveMode() == BOT_MODE_ATTACK then
        local npcEnemy = npcBot:GetTarget()
        if ManaPercentage > 0.4 or npcBot:GetMana() > ComboMana then
            if npcEnemy ~= nil then
                local enemys2 = npcEnemy:GetNearbyHeroes(900, true, BOT_MODE_NONE)
                if enemys2 ~= nil and #enemys2 <= 2 then
                    if CanCast[abilityNumber](npcEnemy) and GetUnitToUnitDistance(npcBot, npcEnemy) > CastRange - 200 and GetUnitToUnitDistance(npcBot, npcEnemy) < 1000 then
                        return BOT_ACTION_DESIRE_MODERATE, utility.GetUnitsTowardsLocation(npcBot, npcEnemy, CastRange + 200)
                    end
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
        return BOT_ACTION_DESIRE_NONE
    end
    local CastRange = 0
    local Damage = ability:GetAbilityDamage()
    local Radius = ability:GetAOERadius()
    local CastPoint = ability:GetCastPoint()
    local allys = npcBot:GetNearbyHeroes(Radius, false, BOT_MODE_NONE)
    local WeakestAlly,AllyHealth = utility.GetWeakestUnit(allys)
    local enemys = npcBot:GetNearbyHeroes(Radius, true, BOT_MODE_NONE)
    local WeakestEnemy,HeroHealth = utility.GetWeakestUnit(enemys)
    if npcBot:GetActiveMode() ~= BOT_MODE_RETREAT then
        if WeakestEnemy ~= nil then
            if CanCast[abilityNumber](WeakestEnemy) then
                if HeroHealth <= WeakestEnemy:GetActualIncomingDamage(Damage, DAMAGE_TYPE_MAGICAL) or (HeroHealth <= WeakestEnemy:GetActualIncomingDamage(GetComboDamage(), DAMAGE_TYPE_MAGICAL) and npcBot:GetMana() > ComboMana) then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_ATTACK then
        if npcBot:WasRecentlyDamagedByAnyHero(2) or #enemys >= 2 then
            for _, npcEnemy in pairs(enemys) do
                if CanCast[abilityNumber](npcEnemy) then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_ROAM or npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or npcBot:GetActiveMode() == BOT_MODE_ATTACK then
        local npcEnemy = fun1:GetTargetIfGood(npcBot)
        if npcEnemy ~= nil and #enemys == 1 then
            if CanCast[abilityNumber](npcEnemy) and GetUnitToUnitDistance(npcBot, npcEnemy) <= Radius then
                return BOT_ACTION_DESIRE_MODERATE
            end
        end
    end
    return BOT_ACTION_DESIRE_NONE
end
local timeWalkLocation
local timeWalkTime
Consider[4] = function()
    local abilityNumber = 4
    local ability = AbilitiesReal[abilityNumber]
    if not ability:IsFullyCastable() or ability:IsHidden() then
        return BOT_ACTION_DESIRE_NONE
    end
    if not timeWalkLocation or not timeWalkTime then
        return 0
    end
    if fun1:IsAttackingEnemies(npcBot) then
        do
            local target = fun1:GetTargetIfGood(npcBot)
            if target then
                local disHere = GetUnitToUnitDistanceSqr(target, npcBot)
                local dis = GetUnitToLocationDistanceSqr(target, timeWalkLocation)
                if dis - disHere >= 300000 then
                    return BOT_ACTION_DESIRE_MODERATE
                end
            end
        end
    end
    if fun1:IsRetreating() then
        local timeWalkLocationEnemies = fun1:GetEnemyHeroNumber(npcBot, fun1:GetNearbyNonIllusionHeroes(npcBot, 1400):Filter(function(t)
            return GetUnitToLocationDistance(t, timeWalkLocation) <= 350
        end))
        local enemies = fun1:GetEnemyHeroNumber(npcBot, fun1:GetNearbyNonIllusionHeroes(npcBot, 350))
        local timeDiff = DotaTime() - timeWalkTime
        if timeWalkLocationEnemies < enemies then
            if fun1:GetHealthPercent(npcBot) <= 0.15 and timeDiff >= 1 then
                return BOT_ACTION_DESIRE_MODERATE
            end
            if GetUnitToLocationDistanceSqr(npcBot, timeWalkLocation) >= 640000 then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end
    return 0
end
Consider[5] = function()
    local abilityNumber = 5
    local ability = AbilitiesReal[abilityNumber]
    if not ability:IsFullyCastable() then
        return BOT_ACTION_DESIRE_NONE, 0
    end
    local CastRange = ability:GetCastRange()
    local Damage = 0
    local Radius = ability:GetAOERadius() - 50
    local CastPoint = ability:GetCastPoint()
    local allys = npcBot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
    local enemys = npcBot:GetNearbyHeroes(CastRange + 300, true, BOT_MODE_NONE)
    local WeakestEnemy,HeroHealth = utility.GetWeakestUnit(enemys)
    for _, npcEnemy in pairs(enemys) do
        if npcEnemy:IsChanneling() then
            local TargetLocation = npcEnemy:GetLocation()
            local Allies = utility.GetAlliesNearLocation(TargetLocation, Radius)
            if #Allies == 0 then
                return BOT_ACTION_DESIRE_MODERATE, TargetLocation
            end
        end
    end
    if npcBot:GetActiveMode() ~= BOT_MODE_RETREAT then
        if WeakestEnemy ~= nil then
            if CanCast[abilityNumber](WeakestEnemy) then
                if HeroHealth <= WeakestEnemy:GetActualIncomingDamage(GetComboDamage(), DAMAGE_TYPE_MAGICAL) and npcBot:GetMana() > ComboMana then
                    local TargetLocation = WeakestEnemy:GetExtrapolatedLocation(CastPoint)
                    local Allies = utility.GetAlliesNearLocation(TargetLocation, Radius)
                    if #Allies == 0 then
                        return BOT_ACTION_DESIRE_MODERATE - 0.1, TargetLocation
                    end
                end
            end
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH then
        local locationAoE = npcBot:FindAoELocation(true, true, npcBot:GetLocation(), CastRange, Radius, CastPoint, 0)
        if locationAoE.count >= 3 then
            local TargetLocation = locationAoE.targetloc
            local Allies = utility.GetAlliesNearLocation(TargetLocation, Radius)
            if #Allies == 0 then
                return BOT_ACTION_DESIRE_LOW - 0.1, TargetLocation
            end
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_ROAM or npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or npcBot:GetActiveMode() == BOT_MODE_ATTACK then
        local locationAoE = npcBot:FindAoELocation(true, true, npcBot:GetLocation(), CastRange, Radius, CastPoint, 0)
        if locationAoE.count >= 3 then
            local TargetLocation = locationAoE.targetloc
            local Allies = utility.GetAlliesNearLocation(TargetLocation, Radius)
            if #Allies <= 1 then
                return BOT_ACTION_DESIRE_HIGH, TargetLocation
            end
        end
    end
    return BOT_ACTION_DESIRE_NONE, 0
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
    local index,target = ability_item_usage_generic.UseAbility(AbilitiesReal, cast)
    if index == 1 then
        timeWalkLocation = npcBot:GetLocation()
        timeWalkTime = DotaTime()
    end
end
function CourierUsageThink()
    ability_item_usage_generic.CourierUsageThink()
end
