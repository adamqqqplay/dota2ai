----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.1 NewStructure
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
--------------------------------------
-- General Initialization
--------------------------------------
local utility = require(GetScriptDirectory() .. "/utility")
local ability_item_usage_generic = require(GetScriptDirectory() .. "/ability_item_usage_generic")
local fun1 = require(GetScriptDirectory() .. "/util/AbilityAbstraction")
local ItemUsage = require(GetScriptDirectory() .. "/util/ItemUsage-New")
local debugmode = true
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
    Abilities[3],
    Abilities[3],
    Abilities[1],
    Abilities[3],
    Abilities[4],
    Abilities[3],
    Abilities[1],
    Abilities[1],
    "talent",
    Abilities[1],
    Abilities[4],
    Abilities[2],
    Abilities[2],
    "talent",
    Abilities[2],
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

-- check skill build vs current level
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

--------------------------------------
-- Ability Usage Thinking
--------------------------------------
local cast = {}
cast.Desire = {}
cast.Target = {}
cast.Type = {}
local Consider = {}
local CanCast = {
    function(t)
        return fun1:StunCanCast(t, AbilitiesReal[1], true, false, false, false)
    end,
    fun1.NormalCanCastFunction,
    utility.NCanCast,
    function(t)
        return fun1:NormalCanCast(t, true, DAMAGE_TYPE_PURE, true, true, true)
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
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
    local ability = AbilitiesReal[abilityNumber]
    if not ability:IsFullyCastable() then
        return BOT_ACTION_DESIRE_NONE
    end
    local CastRange = 0
    local Damage = ability:GetAbilityDamage()
    local Radius = ability:GetAOERadius() - 50
    local CastPoint = ability:GetCastPoint()
    local blink = fun1:GetAvailableBlink(npcBot)
    if blink ~= nil and blink:IsFullyCastable() then
        CastRange = CastRange + 1200
        if npcBot:GetActiveMode() == BOT_MODE_ATTACK then
            local locationAoE = npcBot:FindAoELocation(true, true, npcBot:GetLocation(), CastRange, Radius, 0, 10000)
            if locationAoE.count >= 2 then
                ItemUsage.UseItemOnLocation(npcBot, blink, locationAoE.targetloc)
                return 0
            end
        end
    end
    local allys = npcBot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
    local enemys = npcBot:GetNearbyHeroes(Radius, true, BOT_MODE_NONE)
    local WeakestEnemy, HeroHealth = utility.GetWeakestUnit(enemys)
    local creeps = npcBot:GetNearbyCreeps(Radius, true)
    local WeakestCreep, CreepHealth = utility.GetWeakestUnit(creeps)
	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------
	-- Check for a channeling enemy
    for _, npcEnemy in pairs(enemys) do
        if npcEnemy:IsChanneling() then
            return BOT_ACTION_DESIRE_HIGH
        end
    end
	--Try to kill enemy hero
    if npcBot:GetActiveMode() ~= BOT_MODE_RETREAT then
        if WeakestEnemy ~= nil then
            if HeroHealth <= WeakestEnemy:GetActualIncomingDamage(Damage, DAMAGE_TYPE_MAGICAL) or
                GetUnitToUnitDistance(npcBot, WeakestEnemy) <=
                Radius - CastPoint * WeakestEnemy:GetCurrentMovementSpeed() then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	--protect myself
    if (npcBot:WasRecentlyDamagedByAnyHero(2) and #enemys >= 1) or #enemys >= 2 then
        for _, npcEnemy in pairs(enemys) do
            return BOT_ACTION_DESIRE_HIGH
        end
    end
	
	-- If my mana is enough,use it at enemy
    if npcBot:GetActiveMode() == BOT_MODE_LANING then
        if npcBot:GetMana() >= npcBot:GetMaxMana() * 0.4 + ability:GetManaCost() then
            if WeakestEnemy ~= nil then
                if GetUnitToUnitDistance(npcBot, WeakestEnemy) <
                    Radius - CastPoint * WeakestEnemy:GetCurrentMovementSpeed() then
                    return BOT_ACTION_DESIRE_LOW
                end
            end
        end
    end
	
	-- If we're going after someone
    if npcBot:GetActiveMode() == BOT_MODE_ROAM or npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
        npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or npcBot:GetActiveMode() == BOT_MODE_ATTACK then
        local npcEnemy = fun1:GetTargetIfGood(npcBot)
        if npcEnemy ~= nil then
            if GetUnitToUnitDistance(npcBot, npcEnemy) >= 300 then
                if GetUnitToUnitDistance(npcBot, npcEnemy) <= 1200 + Radius and blink ~= nil then
                    ItemUsage.UseItemOnLocation(npcBot, blink, npcEnemy:GetExtrapolatedLocation(CastPoint))
                    return 0
                end
            else
                return BOT_ACTION_DESIRE_MODERATE
            end
        end
    end
    return BOT_ACTION_DESIRE_NONE
end
Consider[2] = function()
    local abilityNumber = 2
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
    local ability = AbilitiesReal[abilityNumber]
    if not ability:IsFullyCastable() then
        return BOT_ACTION_DESIRE_NONE
    end
    local CastRange = ability:GetCastRange()
    local Damage = ability:GetAbilityDamage()
    local CastPoint = ability:GetCastPoint()
    local allys = npcBot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
    local enemys = npcBot:GetNearbyHeroes(CastRange + 300, true, BOT_MODE_NONE)
    local WeakestEnemy, HeroHealth = utility.GetWeakestUnit(enemys)
    local creeps = npcBot:GetNearbyCreeps(CastRange + 300, true)
    local WeakestCreep, CreepHealth = utility.GetWeakestUnit(creeps)
	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------
	--Try to kill enemy hero
    if npcBot:GetActiveMode() ~= BOT_MODE_RETREAT then
        if WeakestEnemy ~= nil then
            if CanCast[abilityNumber](WeakestEnemy) then
                if HeroHealth <= WeakestEnemy:GetActualIncomingDamage(Damage, DAMAGE_TYPE_MAGICAL) or
                    (
                    HeroHealth <= WeakestEnemy:GetActualIncomingDamage(GetComboDamage(), DAMAGE_TYPE_MAGICAL) and
                        npcBot:GetMana() > ComboMana) then
                    npcBot:SetTarget(WeakestEnemy)
                    return BOT_ACTION_DESIRE_MODERATE, WeakestEnemy
                end
            end
        end
    end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
    if npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH then
        for _, npcEnemy in pairs(enemys) do
            if npcBot:WasRecentlyDamagedByHero(npcEnemy, 2.0) then
                if CanCast[abilityNumber](npcEnemy) and not enemyDisabled(npcEnemy) then
                    return BOT_ACTION_DESIRE_MODERATE, npcEnemy
                end
            end
        end
    end
	
	-- If my mana is enough,use it at enemy
    if npcBot:GetActiveMode() == BOT_MODE_LANING then
        if (ManaPercentage > 0.5 or npcBot:GetMana() > ComboMana) then
            if WeakestEnemy ~= nil then
                if CanCast[abilityNumber](WeakestEnemy) then
                    return BOT_ACTION_DESIRE_LOW, WeakestEnemy
                end
            end
        end
    end
	
	-- If we're farming and can hit 2+ creeps and kill 1+ 
    if npcBot:GetActiveMode() == BOT_MODE_FARM then
        if #creeps >= 2 then
            if CreepHealth <= WeakestCreep:GetActualIncomingDamage(Damage, DAMAGE_TYPE_MAGICAL) and
                npcBot:GetMana() > ComboMana then
                return BOT_ACTION_DESIRE_LOW, WeakestCreep
            end
        end
    end
	-- If we're pushing or defending a lane
    if npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
        npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
        npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT then
        if #enemys >= 1 then
            if ManaPercentage > 0.5 or npcBot:GetMana() > ComboMana then
                if WeakestEnemy ~= nil then
                    if CanCast[abilityNumber](WeakestEnemy) and
                        GetUnitToUnitDistance(npcBot, WeakestEnemy) < CastRange + 75 * #allys then
                        return BOT_ACTION_DESIRE_LOW, WeakestEnemy
                    end
                end
            end
        end
    end
	
	-- If we're going after someone
    if npcBot:GetActiveMode() == BOT_MODE_ROAM or npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
        npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or npcBot:GetActiveMode() == BOT_MODE_ATTACK then
        local npcEnemy = fun1:GetTargetIfGood(npcBot)
        if npcEnemy ~= nil then
            if CanCast[abilityNumber](npcEnemy) and GetUnitToUnitDistance(npcBot, npcEnemy) < CastRange + 75 * #allys then
                return BOT_ACTION_DESIRE_MODERATE, npcEnemy
            end
        end
    end
    return BOT_ACTION_DESIRE_NONE
end
Consider[4] = function()
    local abilityNumber = 4
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
    local ability = AbilitiesReal[abilityNumber]
    if not ability:IsFullyCastable() then
        return BOT_ACTION_DESIRE_NONE
    end
    local CastRange = ability:GetCastRange()
    local Damage = ability:GetSpecialValueInt("damage")
    local function IsWeak(t)
        return CanCast[4](t) and t:GetHealth() <= Damage
    end

    local CastPoint = ability:GetCastPoint()
    local enemies, enemyIllusions = fun1:GetNearbyHeroes(npcBot, CastRange + 300):Filter(IsWeak):Partition(function(it)
        return fun1:MayNotBeIllusion(npcBot, it)
    end)
	
    -- kill real enemies
    if fun1:NotRetreating(npcBot) and #enemies == 0 then
        do
            local blink = fun1:GetAvailableBlink(npcBot)
            if blink then
                do
                    local target = fun1:GetNearbyNonIllusionHeroes(npcBot, CastRange + 1200):First(IsWeak)
                    if target then
                        ItemUsage.UseItemOnLocation(npcBot, blink, target:GetLocation())
                        return 0
                    end
                end
            end
        end
    end
    do
        local target = fun1:GetNearbyNonIllusionHeroes(npcBot, CastRange + 300):Filter(IsWeak):Min(function(it)
            return GetUnitToUnitDistance(npcBot, it)
        end)
        if target then
            local dis = GetUnitToUnitDistance(npcBot, target)
            if fun1:NotRetreating(npcBot) then
                do
                    local blink = fun1:GetAvailableBlink(npcBot)
                    if blink and dis > CastRange + 150 then
                        ItemUsage.UseItemOnLocation(npcBot, blink, target:GetLocation())
                        return 0
                    end
                end
                return BOT_ACTION_DESIRE_HIGH, target
            else
                if dis <= CastRange then
                    return BOT_ACTION_DESIRE_HIGH, target
                end
            end
        end
    end
    -- kill illusions
    if #enemies == 0 and fun1:NotRetreating(npcBot) then
        do
            local target = enemyIllusions:First()
            if target then
                if fun1:GetHealthPercent(npcBot) <= 0.5 and not npcBot:HasModifier "modifier_axe_culling_blade_boost" and
                    target and npcBot:GetMana() > npcBot:GetMaxMana() * 0.4 + ability:GetManaCost() then
                    return BOT_ACTION_DESIRE_MODERATE, target
                end
            end
        end
    end
    return BOT_ACTION_DESIRE_NONE
end
fun1:AutoModifyConsiderFunction(npcBot, Consider, AbilitiesReal)
local callLosingTarget
local cullingBladeTarget
function AbilityUsageThink()
	-- Check if we're already using an ability
    if npcBot:IsUsingAbility() or npcBot:IsChanneling() or npcBot:IsSilenced() then
        if npcBot:IsCastingAbility() then
            if npcBot:GetCurrentActiveAbility() == AbilitiesReal[1] then
                if not fun1:IsFarmingOrPushing(npcBot) then
                    local nearbyEnemies = fun1:GetNearbyHeroes(npcBot, AbilitiesReal[1]:GetAOERadius() + 90):Filter(CanCast
                        [1])
                    if #nearbyEnemies == 0 then
                        if callLosingTarget == nil then
                            callLosingTarget = DotaTime()
                        elseif DotaTime() - callLosingTarget > 0.15 then
                            npcBot:Action_ClearActions(true)
                        end
                        return
                    end
                end
            else
            end
        end
        callLosingTarget = nil
        return
    end
    ComboMana = GetComboMana()
    AttackRange = npcBot:GetAttackRange()
    ManaPercentage = npcBot:GetMana() / npcBot:GetMaxMana()
    HealthPercentage = npcBot:GetHealth() / npcBot:GetMaxHealth()
    cast = ability_item_usage_generic.ConsiderAbility(AbilitiesReal, Consider)
	---------------------------------debug--------------------------------------------
    if debugmode == true then
        ability_item_usage_generic.PrintDebugInfo(AbilitiesReal, cast)
    end
    local index, target = ability_item_usage_generic.UseAbility(AbilitiesReal, cast)
    if index == 4 then
        cullingBladeTarget = target
    end
end

function CourierUsageThink()
    ability_item_usage_generic.CourierUsageThink()
end
