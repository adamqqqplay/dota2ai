---------------------------------------------
-- Generated from Mirana Compiler version 1.6.2
-- Do not modify
-- https://github.com/AaronSong321/Mirana
---------------------------------------------
local utility = require(GetScriptDirectory() .. "/utility")
local ability_item_usage_generic = require(GetScriptDirectory() .. "/ability_item_usage_generic")
local AbilityExtensions = require(GetScriptDirectory() .. "/util/AbilityAbstraction")
local A = require(GetScriptDirectory() .. "/util/MiraDota")
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
local CanCast = {
    function(t)
        if AbilityExtensions:IsOnSameTeam(npcBot, t) then
            return AbilityExtensions:AllyCanCast(t) and not t:HasModifier "modifier_ice_blast"
        else
            return AbilityExtensions:NormalCanCast(t)
        end
    end,
    utility.NCanCast,
    utility.NCanCast,
    function(t)
        return (function()
            if AbilityExtensions:IsOnSameTeam(npcBot, t) then
                return AbilityExtensions:AllyCanCast(t)
            else
                return AbilityExtensions:NormalCanCast(t)
            end
        end)()
    end,
    function(t)
        return AbilityExtensions:NormalCanCast(t) and
            not AbilityExtensions:HasAnyModifier(t, AbilityExtensions.CannotKillModifiers)
    end,
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
        return BOT_ACTION_DESIRE_NONE
    end
    local CastRange = 0
    local Damage = ability:GetAbilityDamage()
    local Radius = ability:GetAOERadius()
    local CastPoint = ability:GetCastPoint()
    local allys = npcBot:GetNearbyHeroes(Radius, false, BOT_MODE_NONE)
    local WeakestAlly, AllyHealth = utility.GetWeakestUnit(allys)
    local enemys = npcBot:GetNearbyHeroes(Radius, true, BOT_MODE_NONE)
    local WeakestEnemy, HeroHealth = utility.GetWeakestUnit(enemys)
    local creeps = npcBot:GetNearbyCreeps(Radius, true)
    local WeakestCreep, CreepHealth = utility.GetWeakestUnit(creeps)
    if npcBot:GetActiveMode() ~= BOT_MODE_RETREAT then
        if WeakestEnemy ~= nil then
            if CanCast[abilityNumber](WeakestEnemy) then
                if HeroHealth <= WeakestEnemy:GetActualIncomingDamage(Damage, DAMAGE_TYPE_MAGICAL) or
                    (
                    HeroHealth <= WeakestEnemy:GetActualIncomingDamage(GetComboDamage(), DAMAGE_TYPE_MAGICAL) and
                        npcBot:GetMana() > ComboMana) then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end
    end
    if ManaPercentage > 0.5 or npcBot:GetMana() > ComboMana then
        for _, npcTarget in pairs(allys) do
            if npcTarget:GetHealth() / npcTarget:GetMaxHealth() < (0.6 + #enemys * 0.05) then
                if CanCast[abilityNumber](npcTarget) then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end
    end
    if ManaPercentage > 0.4 or npcBot:GetMana() > ComboMana or
        (npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH) then
        if (npcBot:WasRecentlyDamagedByAnyHero(2) and #enemys >= 1) or #enemys >= 2 or HealthPercentage <= 0.4 then
            for _, npcEnemy in pairs(enemys) do
                if CanCast[abilityNumber](npcEnemy) then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
        npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
        npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT then
        if #enemys + #creeps >= 5 then
            if ManaPercentage > 0.6 or npcBot:GetMana() > ComboMana * 1.5 then
                return BOT_ACTION_DESIRE_MODERATE, WeakestEnemy
            end
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_LANING then
        if ManaPercentage > 0.75 then
            if WeakestEnemy ~= nil and WeakestCreep ~= nil then
                if CanCast[abilityNumber](WeakestEnemy) then
                    return BOT_ACTION_DESIRE_LOW
                end
            end
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_FARM then
        if #creeps >= 4 then
            if ManaPercentage > 0.5 or npcBot:GetMana() > ComboMana then
                return BOT_ACTION_DESIRE_MODERATE
            end
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_ROAM or npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
        npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or npcBot:GetActiveMode() == BOT_MODE_ATTACK then
        local npcEnemy = npcBot:GetTarget()
        if npcEnemy ~= nil then
            if CanCast[abilityNumber](npcEnemy) and GetUnitToUnitDistance(npcBot, npcEnemy) <= Radius then
                return BOT_ACTION_DESIRE_MODERATE
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
    local CastRange = 0
    local Damage = 0
    local Radius = 750
    local allys = npcBot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
    local enemys = npcBot:GetNearbyHeroes(Radius, true, BOT_MODE_NONE)
    local WeakestEnemy, HeroHealth = utility.GetWeakestUnit(enemys)
    if npcBot:WasRecentlyDamagedByAnyHero(2.0) and #enemys >= 2 and HealthPercentage <= 0.35 + 0.05 * #enemys then
        return BOT_ACTION_DESIRE_HIGH
    end
    if npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH then
        if npcBot:WasRecentlyDamagedByAnyHero(2.0) then
            return BOT_ACTION_DESIRE_HIGH
        end
    end
    return BOT_ACTION_DESIRE_NONE
end
Consider[4] = function()
    local ability = AbilitiesReal[4]
    if not ability:IsFullyCastable() or ability:IsHidden() then
        return 0
    end
    local castRange = ability:GetRange()
    local enemies = AbilityExtensions:GetPureHeroes(npcBot, castRange + 200)
    local allys = AbilityExtensions:GetPureHeroes(npcBot, castRange + 200, false)
    local strongestEnemy = enemies:Filter(CanCast[4]):Max(function(t)
        return t:GetNetWorth()
    end)
    if AbilityExtensions:IsAttackingEnemies(npcBot) then
        local target = AbilityExtensions:GetTargetIfGood(npcBot)
        if target and AbilityExtensions:GetHealthPercent(target) <= 0.55 and
            AbilityExtensions:GetHealthPercent(target) >= 0.4 and target:GetHealth() > 600 and
            target:GetHealth() < (enemies:MaxV(function(t)
                return t:GetHealth()
            end) or npcBot:GetHealth()) / 4 and AbilityExtensions:NormalCanCast(target) then
            return BOT_ACTION_DESIRE_HIGH, target
        end
        local fEnemy = enemies:Filter(CanCast[4]):First(function(t)
            return AbilityExtensions:DontInterruptAlly(t)
        end)
        if fEnemy then
            return BOT_ACTION_DESIRE_HIGH, fEnemy
        end
        if #enemies > 1 and #allys > 1 then
            if AbilitiesReal[1]:IsFullyCastable() and #enemies > 1 + #allys then
                return BOT_ACTION_DESIRE_MODERATE, strongestEnemy
            else
                return BOT_ACTION_DESIRE_VERYLOW, strongestEnemy
            end
        elseif #enemies > 1 and #allys == 1 then
            if AbilitiesReal[1]:IsFullyCastable() then
                return BOT_ACTION_DESIRE_HIGH, strongestEnemy
            else
                return BOT_ACTION_DESIRE_LOW, strongestEnemy
            end
        end
        do
            local weakestAlly = allys:Filter(function(t)
                return CanCast[4](t) and not AbilityExtensions:DontInterruptAlly(t) and
                    (
                    AbilityExtensions:GetHealthPercent(t) < 0.3 and t:WasRecentlyDamagedByAnyHero(1.2) or
                        AbilityExtensions:IsSeverelyDisabled(t)) and AbilityExtensions:NotBlasted(t)
            end):SortByMinFirst(function(t)
                return AbilityExtensions:GetHealthPercent(t)
            end)
            if weakestAlly then
                return BOT_ACTION_DESIRE_MODERATE, weakestAlly
            end
        end
    end
    if AbilityExtensions:IsRetreating(npcBot) then
        if strongestEnemy then
            return BOT_ACTION_DESIRE_HIGH, true
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
    local DamagePercent = ability:GetSpecialValueFloat("damage_per_health")
    local allys = npcBot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
    local enemys = AbilityExtensions:GetPureHeroes(npcBot, CastRange + 300):Filter(A.Unit.IsNotCreepHero)
    local WeakestEnemy, HeroHealth = utility.GetWeakestUnit(enemys)
    local maxHealth = (AbilityExtensions:GetNearbyHeroes(npcBot):MaxV(function(t)
        return t:GetHealth()
    end) or npcBot:GetHealth()) / 3
    local allyNumber = AbilityExtensions:GetEnemyHeroNumber(npcBot, AbilityExtensions:Filter(allys, function(t)
        return AbilityExtensions:IsAttackingEnemies(t) or not t:IsBot()
    end))
    do
        local enemy = enemys:First(A.Hero.IsTeleporting)
        if enemy and CanCast[abilityNumber](enemy) then
            local k = (1 - enemy:GetMagicResist()) * d * (1 + 0.08 * allyNumber)
            local maxHealthPercentToKill = k / (1 + k)
            if AbilityExtensions:GetHealthPercent(enemy) <= maxHealthPercentToKill then
                return BOT_ACTION_DESIRE_HIGH, enemy
            end
        end
    end
    if npcBot:GetActiveMode() ~= BOT_MODE_RETREAT then
        for i, npcEnemy in pairs(enemys) do
            if (CanCast[abilityNumber](npcEnemy)) and not npcEnemy:IsMagicImmune() then
                local Damage = (npcEnemy:GetMaxHealth() - npcEnemy:GetHealth()) * DamagePercent *
                    (1 + allyNumber * 0.06
                    )
                local n1 = npcEnemy:GetHealth()
                local n2 = npcEnemy:GetActualIncomingDamage(Damage, DAMAGE_TYPE_MAGICAL)
                if npcEnemy:GetHealth() <= npcEnemy:GetActualIncomingDamage(Damage, DAMAGE_TYPE_MAGICAL) and
                    (
                    npcEnemy:GetHealth() >= (ability:GetLevel() * 100 + 300) and npcEnemy:GetHealth() > maxHealth and
                        AbilityExtensions:GetHealthPercent(npcEnemy) >= 0.25) then
                    return BOT_ACTION_DESIRE_HIGH, npcEnemy
                end
            end
        end
    end
    return BOT_ACTION_DESIRE_NONE, 0
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
