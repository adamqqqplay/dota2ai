---------------------------------------------
-- Generated from Mirana Compiler version 1.5.1
-- Do not modify
-- https://github.com/AaronSong321/Mirana
---------------------------------------------
local utility = require(GetScriptDirectory().."/utility")
require(GetScriptDirectory().."/ability_item_usage_generic")
local AbilityExtensions = require(GetScriptDirectory().."/util/AbilityAbstraction")
local role = require(GetScriptDirectory().."/util/RoleUtility")
local fun1 = require(GetScriptDirectory().."/util/AbilityAbstraction")
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
    Abilities[3],
    Abilities[3],
    "talent",
    Abilities[3],
    Abilities[4],
    Abilities[1],
    Abilities[1],
    "talent",
    Abilities[1],
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
        return Talents[4]
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
local CanCast = {}
CanCast[1] = function(t)
    return AbilityExtensions:NormalCanCast(t, false, DAMAGE_TYPE_MAGICAL, false, true)
end
CanCast[2] = function(t)
    return AbilityExtensions:NormalCanCast(t, true, DAMAGE_TYPE_PURE, false, true) and not AbilityExtensions:HasAbilityRetargetModifier(t) and not (t:HasModifier("modifier_item_blade_mail") and AbilityExtensions:IsRetreating(npcBot))
end
CanCast[3] = function(t) return fun1:StunCanCast(t, AbilitiesReal[3], false, true, true, false) and not fun1:DontControlAgain(t) end
CanCast[4] = function(t) return fun1:StunCanCast(t, AbilitiesReal[4], true, true, true, false) and not fun1:DontControlAgain(t) end
local enemyDisabled = utility.enemyDisabled
function GetComboDamage()
    return ability_item_usage_generic.GetComboDamage(AbilitiesReal)
end
function GetComboMana()
    return ability_item_usage_generic.GetComboMana(AbilitiesReal)
end
local health
local maxHealth
local healthPercentage
local mana
local maxMana
local manaPercentage
Consider[1] = function()
    local abilityNumber = 1
    local ability = AbilitiesReal[abilityNumber]
    if not ability:IsFullyCastable() then
        return BOT_ACTION_DESIRE_NONE, 0
    end
    local CastRange = ability:GetCastRange()
    local Damage = ability:GetAbilityDamage()
    local CastPoint = ability:GetCastPoint()
    local allys = npcBot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
    local enemys = npcBot:GetNearbyHeroes(CastRange + 300, true, BOT_MODE_NONE)
    local WeakestEnemy,HeroHealth = utility.GetWeakestUnit(enemys)
    local creeps = npcBot:GetNearbyCreeps(CastRange + 300, true)
    local WeakestCreep,CreepHealth = utility.GetWeakestUnit(creeps)
    local tableNearbyAttackingAlliedHeroes = npcBot:GetNearbyHeroes(1000, false, BOT_MODE_ATTACK)
    if #tableNearbyAttackingAlliedHeroes >= 2 then
        local npcMostDangerousEnemy = nil
        local nMostDangerousDamage = 0
        for _, npcEnemy in pairs(enemys) do
            if CanCast[abilityNumber](npcEnemy) then
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
    local enemys2 = npcBot:GetNearbyHeroes(500, true, BOT_MODE_NONE)
    if npcBot:WasRecentlyDamagedByAnyHero(5) then
        for _, npcEnemy in pairs(enemys2) do
            if CanCast[abilityNumber](npcEnemy) then
                return BOT_ACTION_DESIRE_HIGH, npcEnemy
            end
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT then
        if #enemys >= 1 then
            if ManaPercentage > 0.5 or npcBot:GetMana() > ComboMana then
                if WeakestEnemy ~= nil then
                    if CanCast[abilityNumber](WeakestEnemy) and GetUnitToUnitDistance(npcBot, WeakestEnemy) < CastRange + 75 * #allys then
                        return BOT_ACTION_DESIRE_LOW, WeakestEnemy
                    end
                end
            end
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
    return BOT_ACTION_DESIRE_NONE, 0
end
Consider[2] = function()
    local abilityNumber = 2
    local ability = AbilitiesReal[abilityNumber]
    if not ability:IsFullyCastable() then
        return BOT_ACTION_DESIRE_NONE, 0
    end
    local abilityLevel = ability:GetLevel()
    local radius = ability:GetAOERadius() - 100
    local castPoint = ability:GetCastPoint()
    local manaCost = ability:GetManaCost()
    local duration = ability:GetDuration()
    local damage = ability:GetAbilityDamage()
    local castRange = ability:GetCastRange()
    local enemyHeroes = fun1:GetNearbyHeroes(npcBot, castRange + 200, true)
    local enemies,enemyIllusions = enemyHeroes:Partition(function(it)
        fun1:MayNotBeIllusion(npcBot, it)
    end)
    local allies = fun1:GetNearbyNonIllusionHeroes(npcBot, 900, false)
    local nearbyCreeps = fun1:GetNearbyAttackableCreeps(npcBot, castRange + 150, true)
    if fun1:NotRetreating(npcBot) then
        do
            local target = enemies:Filter(CanCast[2]):Filter(function(it)
                return it:GetHealth() <= it:GetActualIncomingDamage(damage, DAMAGE_TYPE_PURE) or it:GetHealth() <= it:GetActualIncomingDamage(GetComboDamage(), DAMAGE_TYPE_PURE) and mana > ComboMana
            end):SortByMaxFirst(function(it)
                it:GetHealth()
            end):First()
            if target then
                return BOT_ACTION_DESIRE_HIGH, target
            end
        end
    end
    if healthPercentage <= 0.3 then
        do
            local target = enemyIllusions:First()
            if target then
                return BOT_ACTION_DESIRE_HIGH, target
            end
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH then
        if npcBot:WasRecentlyDamagedByAnyHero(2) then
            do
                local target = enemyIllusions:First()
                if target then
                    return BOT_ACTION_DESIRE_MODERATE, target
                end
            end
        end
        do
            local target = enemies:First(function(it)
                return CanCast[2](it) and npcBot:WasRecentlyDamagedByHero(it, 2) and GetUnitToUnitDistance(npcBot, it) <= castRange + it:GetBoundingRadius()
            end)
            if target then
                return BOT_ACTION_DESIRE_HIGH, target
            end
        end
        if npcBot:WasRecentlyDamagedByAnyHero(2) then
            do
                local target = nearbyCreeps:First()
                if target then
                    return BOT_ACTION_DESIRE_MODERATE, target
                end
            end
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_LANING then
        if (manaPercentage > healthPercentage or mana > ComboMana) and abilityLevel >= 2 then
            do
                local target = enemies:SortByMinFirst(function(it)
                    it:GetHealth()
                end):First()
                if target then
                    return BOT_ACTION_DESIRE_MODERATE, target
                end
            end
        end
    end
    if fun1:IsFarmingOrPushing(npcBot) and #enemies == 0 then
        if mana > maxMana * 0.7 + manaCost or manaPercentage > healthPercentage + 0.2 then
            do
                local target = nearbyCreeps:SortByMinFirst(function(it)
                    it:GetHealth()
                end):First()
                if target then
                    return BOT_ACTION_DESIRE_MODERATE - 0.1, target
                end
            end
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_ROAM or npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or npcBot:GetActiveMode() == BOT_MODE_ATTACK then
        do
            local target = fun1:GetTargetIfGood(npcBot)
            if target then
                if CanCast[2](target) and GetUnitToUnitDistance(npcBot, target) < castRange + target:GetBoundingRadius() + 50 * #allies then
                    return BOT_ACTION_DESIRE_MODERATE, target
                end
            end
        end
    end
    return BOT_ACTION_DESIRE_NONE
end
Consider[3] = function()
    local abilityNumber = 3
    local ability = AbilitiesReal[abilityNumber]
    if not ability:IsFullyCastable() then
        return BOT_ACTION_DESIRE_NONE
    end
    local abilityLevel = ability:GetLevel()
    local radius = ability:GetAOERadius() - 100
    local castPoint = ability:GetCastPoint()
    local manaCost = ability:GetManaCost()
    local duration = ability:GetDuration()
    local damage = ability:GetAbilityDamage()
    local castRange = ability:GetCastRange()
    local enemies = fun1:GetNearbyNonIllusionHeroes(npcBot, castRange + 240)
    local allies = fun1:GetNearbyNonIllusionHeroes(npcBot, castRange + 240, false)
    do
        local target = enemies:First(function(it)
            return fun1:IsChannelingBreakWorthAbility(it) and CanCast[abilityNumber](it)
        end)
        if target then
            return BOT_ACTION_DESIRE_HIGH, target
        end
    end
    do
        local target = enemies:Filter(function(it)
            return CanCast[abilityNumber](it) and not fun1:IsOrGoingToBeSeverelyDisabled(it) and #allies <= 1
        end):SortByMaxFirst(function(it)
            it:GetEstimatedDamageToTarget(false, npcBot, 3.0, DAMAGE_TYPE_ALL)
        end):First()
        if target then
            return BOT_ACTION_DESIRE_HIGH, target
        end
    end
    if fun1:IsRetreating(npcBot) and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH then
        do
            local target = fun1:GetNearbyNonIllusionHeroes(npcBot, castRange + 120):First(function(it)
                return CanCast[3](it) and not fun1:IsOrGoingToBeSeverelyDisabled(it)
            end)
            if target then
                return BOT_ACTION_DESIRE_HIGH, target
            end
        end
    end
    if fun1:IsAttackingEnemies(npcBot) then
        local npcEnemy = fun1:GetTargetIfGood(npcBot)
        local allys2 = fun1:GetNearbyNonIllusionHeroes(npcBot, 600)
        local allys3 = fun1:GetNearbyNonIllusionHeroes(npcBot, 1000)
        if npcEnemy and #allys2 < #allys3 then
            if CanCast[abilityNumber](npcEnemy) and not fun1:IsOrGoingToBeSeverelyDisabled(npcEnemy) and GetUnitToUnitDistance(npcBot, npcEnemy) < castRange + npcEnemy:GetBoundingRadius() then
                return BOT_ACTION_DESIRE_MODERATE, npcEnemy
            end
        end
    end
    do
        local target = allies:First(function(it)
            return AbilityExtensions:IsOrGoingToBeSeverelyDisabled(it) and not it:IsChanneling() and not fun1:DontInterruptAlly(it)
        end)
        if target then
            return BOT_ACTION_DESIRE_MODERATE, target
        end
    end
    do
        local target = allies:First(function(it)
            fun1:Any(fun1:GetIncomingDodgeWorthProjectiles(it), function(t) return GetUnitToLocationDistance(it, t.location) <= 400 and not t.is_attack end)
        end)
        if target then
            return BOT_ACTION_DESIRE_MODERATE, target
        end
    end
    return BOT_ACTION_DESIRE_NONE
end
Consider[4] = function()
    local abilityNumber = 4
    local ability = AbilitiesReal[abilityNumber]
    if not ability:IsFullyCastable() then
        return BOT_ACTION_DESIRE_NONE, 0
    end
    local CastRange = ability:GetCastRange()
    local Damage = ability:GetAbilityDamage()
    local CastPoint = ability:GetCastPoint()
    local allys = npcBot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
    local enemys = npcBot:GetNearbyHeroes(CastRange + 300, true, BOT_MODE_NONE)
    local enemys2 = npcBot:GetNearbyHeroes(CastRange - 300, true, BOT_MODE_NONE)
    local WeakestEnemy,HeroHealth = utility.GetWeakestUnit(enemys)
    local creeps = npcBot:GetNearbyCreeps(CastRange + 300, true)
    local WeakestCreep,CreepHealth = utility.GetWeakestUnit(creeps)
    local abilityLevel = ability:GetLevel()
    local radius = ability:GetAOERadius() - 100
    local castPoint = ability:GetCastPoint()
    local manaCost = ability:GetManaCost()
    local duration = ability:GetDuration()
    local damage = ability:GetAbilityDamage()
    local castRange = ability:GetCastRange()
    for _, npcEnemy in pairs(enemys) do
        if npcEnemy:IsChanneling() and CanCast[abilityNumber](npcEnemy) and not AbilityExtensions:HasAbilityRetargetModifier(npcEnemy) then
            return BOT_ACTION_DESIRE_HIGH, npcEnemy
        end
    end
    if #enemys2 > 0 then
        return 0
    end
    if npcBot:GetActiveMode() ~= BOT_MODE_RETREAT then
        if WeakestEnemy ~= nil then
            if CanCast[abilityNumber](WeakestEnemy) and not enemyDisabled(WeakestEnemy) and #enemys <= 2 then
                if HeroHealth <= WeakestEnemy:GetActualIncomingDamage(Damage, DAMAGE_TYPE_MAGICAL) or (HeroHealth <= WeakestEnemy:GetActualIncomingDamage(GetComboDamage(), DAMAGE_TYPE_MAGICAL) and npcBot:GetMana() > ComboMana) then
                    return BOT_ACTION_DESIRE_HIGH, WeakestEnemy
                end
            end
        end
    end
    local tableNearbyAttackingAlliedHeroes = npcBot:GetNearbyHeroes(1000, false, BOT_MODE_ATTACK)
    if #tableNearbyAttackingAlliedHeroes >= 2 then
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
    if AbilityExtensions:IsRetreating(npcBot) and #enemys == 1 and not AbilityExtensions:HasAbilityRetargetModifier(enemys[1]) then
        return BOT_ACTION_DESIRE_HIGH, enemys[1]
    end
    if fun1:IsAttackingEnemies(npcBot) then
        do
            local target = npcBot:GetTargetIfGood()
            if target then
                if CanCast[abilityNumber](target) and GetUnitToUnitDistance(npcBot, npcEnemy) < CastRange + 75 * #allys then
                    return BOT_ACTION_DESIRE_MODERATE, target
                end
            end
        end
    end
    return BOT_ACTION_DESIRE_NONE, 0
end
Consider[5] = function()
    local ability = AbilitiesReal[5]
    if not ability:IsFullyCastable() or ability:IsHidden() then
        return 0
    end
    local enemies = AbilityExtensions:GetNearbyNonIllusionHeroes(npcBot, 1200, true, BOT_MODE_NONE)
    local nightmaredEnemies = AbilityExtensions:Filter(enemies, function(t)
        return t:HasModifier("modifier_bane_nightmare")
    end)
    local friends = AbilityExtensions:GetNearbyNonIllusionHeroes(npcBot, 1200, false, BOT_MODE_NONE)
    local nightmaredFriends = AbilityExtensions:Filter(friends, function(t)
        return t:HasModifier("modifier_bane_nightmare")
    end)
    if #nightmaredEnemies ~= 0 then
        if #enemies == 1 and #friends >= 2 and AbilityExtensions:GetModifierRemainingDuration(nightmaredEnemies[1], "modifier_bane_nightmare") <= 4 or nightmaredEnemies:All(function(it)
            return fun1:GetHealthPercent(it) <= 0.3 and fun1:GetModifierRemainingDuration(it, "modifier_bane_nightmare") <= 4
        end) and friends:All(function(it)
            return fun1:GetHealthPercent(it) >= 0.5
        end) then
            return BOT_ACTION_DESIRE_HIGH
        end
    end
    if #nightmaredFriends ~= 0 then
        if AbilityExtensions:All(nightmaredFriends, function(t)
            return AbilityExtensions:GetHealthPercent(t) >= 0.3
        end) or AbilityExtensions:All(nightmaredFriends, function(t) return #fun1:GetIncomingDodgeWorthProjectiles(t) == 0 end) and #enemies == 0 then
            return BOT_ACTION_DESIRE_HIGH
        end
    end
    return BOT_ACTION_DESIRE_NONE
end
AbilityExtensions:AutoModifyConsiderFunction(npcBot, Consider, AbilitiesReal)
local drainSnapTarget
local fiendsGripTarget
function AbilityUsageThink()
    if npcBot:IsUsingAbility() or npcBot:IsChanneling() or npcBot:IsSilenced() then
        if npcBot:IsCastingAbility() then
            if npcBot:GetCurrentActiveAbility() == AbilitiesReal[2] then
                if drainSnapTarget and AbilityExtensions:HasAbilityRetargetModifier(drainSnapTarget) then
                    npcBot:Action_ClearActions(true)
                end
            end
            if npcBot:GetCurrentActiveAbility() == AbilitiesReal[4] and not npcBot:IsChanneling() then
                if fiendsGripTarget and AbilityExtensions:HasAbilityRetargetModifier(fiendsGripTarget) then
                    npcBot:Action_ClearActions(true)
                end
            end
        end
        return
    end
    health = npcBot:GetHealth()
    maxHealth = npcBot:GetMaxHealth()
    healthPercentage = health / maxHealth
    mana = npcBot:GetMana()
    maxMana = npcBot:GetMaxMana()
    manaPercentage = mana / maxMana
    ComboMana = GetComboMana()
    AttackRange = npcBot:GetAttackRange()
    ManaPercentage = npcBot:GetMana() / npcBot:GetMaxMana()
    HealthPercentage = npcBot:GetHealth() / npcBot:GetMaxHealth()
    cast = ability_item_usage_generic.ConsiderAbility(AbilitiesReal, Consider)
    if debugmode == true then
        ability_item_usage_generic.PrintDebugInfo(AbilitiesReal, cast)
    end
    local index,target = ability_item_usage_generic.UseAbility(AbilitiesReal, cast)
    if index == 2 then
        drainSnapTarget = target
    elseif index == 4 then
        fiendsGripTarget = target
    end
end
function CourierUsageThink()
    ability_item_usage_generic.CourierUsageThink()
end
