----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.3 New Structure
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
--------------------------------------
-- General Initialization
--------------------------------------
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
    Abilities[2],
    Abilities[3],
    Abilities[2],
    Abilities[6],
    Abilities[2],
    Abilities[3],
    Abilities[1],
    "talent",
    Abilities[1],
    Abilities[6],
    Abilities[1],
    Abilities[3],
    "talent",
    Abilities[3],
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
        return Talents[3]
    end,
    function()
        return Talents[6]
    end,
    function()
        return Talents[7]
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
local ComboMana
local AttackRange
local ManaPercentage
local HealthPercentage
local cast = {}
cast.Desire = {}
cast.Target = {}
cast.Type = {}
local Consider = {}
local CanCast = {
    utility.NCanCast,
    function(t)
        return AbilityExtensions.PhysicalCanCastFunction(t) or
            t:IsTower() and not t:HasModifier "modifier_fountain_glyph"
    end,
    utility.NCanCast,
    utility.UCanCast,
    function(t)
        return not t:IsAncientCreep() and not t:IsRoshan()
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
        return BOT_ACTION_DESIRE_NONE, 0
    end
    local CastRange = ability:GetCastRange()
    local Damage = ability:GetAbilityDamage()
    local Radius = ability:GetAOERadius()
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
                    return BOT_ACTION_DESIRE_HIGH, WeakestEnemy:GetLocation(), "Location"
                end
            end
        end
    end
	
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	-- If we're farming and can hit 2+ creeps
    if npcBot:GetActiveMode() == BOT_MODE_FARM then
        if ManaPercentage > 0.4 or npcBot:GetMana() > ComboMana then
            local locationAoE = npcBot:FindAoELocation(true, false, npcBot:GetLocation(), CastRange, Radius, 0, 0)
            if locationAoE.count >= 3 then
                return BOT_ACTION_DESIRE_MODERATE - 0.03, locationAoE.targetloc, "Location"
            end
        end
    end

	-- If we're pushing or defending a lane and can hit 4+ creeps, go for it
    if npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
        npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
        npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT then
        if ManaPercentage > 0.4 or npcBot:GetMana() > ComboMana then
            local locationAoE = npcBot:FindAoELocation(true, false, npcBot:GetLocation(), CastRange, Radius, 0, 0)
            if locationAoE.count >= 3 then
                return BOT_ACTION_DESIRE_MODERATE - 0.03, locationAoE.targetloc, "Location"
            end
        end
    end
		
	-- If my mana is enough, use it at enemy
    if npcBot:GetActiveMode() == BOT_MODE_LANING then
        if (ManaPercentage > 0.4 or npcBot:GetMana() > ComboMana) and ability:GetLevel() >= 2 then
            if WeakestEnemy ~= nil then
                if CanCast[abilityNumber](WeakestEnemy) then
                    return BOT_ACTION_DESIRE_LOW, WeakestEnemy:GetLocation(), "Location"
                end
            end
        end
    end
	
	-- If we're going after someone
    if npcBot:GetActiveMode() == BOT_MODE_ROAM or npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
        npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or npcBot:GetActiveMode() == BOT_MODE_ATTACK then
        local locationAoE = npcBot:FindAoELocation(true, true, npcBot:GetLocation(), CastRange, Radius, 0, 0)
        if locationAoE.count >= 2 then
            return BOT_ACTION_DESIRE_MODERATE, locationAoE.targetloc, "Location"
        end
        local npcEnemy = npcBot:GetTarget()
        if npcEnemy ~= nil then
            if not enemyDisabled(npcEnemy) and GetUnitToUnitDistance(npcBot, npcEnemy) < CastRange + 75 * #allys then
                return BOT_ACTION_DESIRE_MODERATE, npcEnemy:GetLocation(), "Location"
            end
        end
    end
    return BOT_ACTION_DESIRE_NONE
end
Consider[2] = AbilityExtensions:ToggleFunctionToAutoCast(npcBot, AbilitiesReal[2], function()
    local abilityNumber = 2
    --------------------------------------
    -- Generic Variable Setting
    --------------------------------------
    local ability = AbilitiesReal[abilityNumber]
    if not ability:IsFullyCastable() or AbilityExtensions:IsPhysicalOutputDisabled(npcBot) then
        return 0
    end
    local CastRange = ability:GetCastRange()
    local enemys = npcBot:GetNearbyHeroes(CastRange + 100, true, BOT_MODE_NONE)
    local WeakestEnemy, HeroHealth = utility.GetWeakestUnit(enemys)
    local function UseAt(target)
        if not CanCast[abilityNumber](target) then
            return false
        end
        if target:IsHero() then
            if AbilityExtensions:IsAttackingEnemies(npcBot) and npcBot:WasRecentlyDamagedByAnyHero(1) then
                return false
            end
            if GetUnitToUnitDistanceSqr(npcBot, target) <= 190000 then
                return false
            elseif AbilityExtensions:MustBeIllusion(npcBot, target) then
                return AbilityExtensions:GetManaPercent(npcBot) >= 0.8 or
                    AbilityExtensions:GetHealthPercent(target) <= 0.4
            else
                return true
            end
        elseif target:IsBuilding() then
            return true
        else
            return AbilityExtensions:GetManaPercent(npcBot) >= 0.8
        end
    end

    local attackRange = npcBot:GetAttackRange()
    if AbilityExtensions:NotRetreating(npcBot) then
        if npcBot:GetActiveMode() == BOT_MODE_LANING then
            local creeps = npcBot:GetNearbyLaneCreeps(attackRange + 120, true)
            local allyCreeps = npcBot:GetNearbyLaneCreeps(attackRange + 120, false)
            if creeps and #creeps > 0 or allyCreeps and #allyCreeps > 0 then
                return false
            end
        end
        local target = npcBot:GetAttackTarget() or npcBot:GetTarget()
        if target == nil then
            if WeakestEnemy ~= nil then
                local b = UseAt(WeakestEnemy)
                if b then
                    return BOT_ACTION_DESIRE_MODERATE, WeakestEnemy
                else
                    return false
                end
            end
        else
            return UseAt(target)
        end
    end
    return false
end)

Consider[6] = function()
    local abilityNumber = 6
    local ability = AbilitiesReal[abilityNumber]
    if not ability:IsFullyCastable() then
        return BOT_ACTION_DESIRE_NONE, 0
    end
    local CastRange = ability:GetCastRange()
    local Damage = ability:GetAbilityDamage()
    local Radius = ability:GetAOERadius()
    local allys = npcBot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
    local enemys = npcBot:GetNearbyHeroes(CastRange + 300, true, BOT_MODE_NONE)
    local WeakestEnemy, HeroHealth = utility.GetWeakestUnit(enemys)
    local creeps = npcBot:GetNearbyCreeps(CastRange + 300, true)
    local WeakestCreep, CreepHealth = utility.GetWeakestUnit(creeps)
    if npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH then
        return BOT_ACTION_DESIRE_MODERATE
    end
    if npcBot:GetActiveMode() == BOT_MODE_ROAM or npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM then
        local npcEnemy = npcBot:GetTarget()
        if npcEnemy ~= nil then
            if GetUnitToUnitDistance(npcBot, npcEnemy) >= 1800 then
                return BOT_ACTION_DESIRE_MODERATE
            end
        end
    end
    return BOT_ACTION_DESIRE_NONE, 0
end
local goodNeutral = {
    "npc_dota_neutral_alpha_wolf",              -- 头狼
    "npc_dota_neutral_centaur_khan",            -- 半人马征服者
    "npc_dota_neutral_dark_troll_warlord",      -- 黑暗巨魔召唤法师
    "npc_dota_neutral_polar_furbolg_ursa_warrior", -- 地狱熊怪粉碎者
    "npc_dota_neutral_satyr_hellcaller",        -- 萨特苦难使者
    "npc_dota_neutral_enraged_wildkin",         -- 枭兽撕裂者
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

Consider[4] = function()
    local abilityNumber = 4
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
    local ability = AbilitiesReal[abilityNumber]
    if not ability:IsFullyCastable() then
        return BOT_ACTION_DESIRE_NONE, 0
    end
    local CastRange = ability:GetCastRange()
    local Damage = ability:GetAbilityDamage()
    local Radius = ability:GetAOERadius()
    local allys = npcBot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
    local enemys = npcBot:GetNearbyHeroes(CastRange + 300, true, BOT_MODE_NONE)
    local WeakestEnemy, HeroHealth = utility.GetWeakestUnit(enemys)
    local creeps = npcBot:GetNearbyCreeps(CastRange + 300, true)
    local WeakestCreep, CreepHealth = utility.GetWeakestUnit(creeps)
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	-- If we're in a teamfight, use it on the scariest enemy
    local tableNearbyAttackingAlliedHeroes = npcBot:GetNearbyHeroes(1200, false, BOT_MODE_ATTACK)
    if #tableNearbyAttackingAlliedHeroes >= 2 then
        local locationAoE = npcBot:FindAoELocation(true, true, npcBot:GetLocation(), AttackRange, 400, 0, 0)
        if locationAoE.count >= 2 then
            return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc
        end
    end

	-- If we're going after someone
    if npcBot:GetActiveMode() == BOT_MODE_ROAM or npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
        npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or npcBot:GetActiveMode() == BOT_MODE_ATTACK then
        local npcEnemy = npcBot:GetTarget()
        if ManaPercentage > 0.4 or npcBot:GetMana() > ComboMana then
            if npcEnemy ~= nil then
                if CanCast[abilityNumber](npcEnemy) and GetUnitToUnitDistance(npcBot, npcEnemy) < CastRange + 300 then
                    return BOT_ACTION_DESIRE_MODERATE, npcEnemy:GetLocation()
                end
            end
        end
    end
    return BOT_ACTION_DESIRE_NONE, 0
end
local function RateCreep(creep)
    local rate = 0
    rate = rate + creep:GetMaxHealth() * AbilityExtensions:GetTargetHealAmplifyPercent(npcBot)
    rate = rate + creep:GetAttackDamage() * 6
    if creep:IsDominated() then
        rate = rate * 2
    end
    if creep:GetTeam() ~= TEAM_NEUTRAL then
        rate = rate * 0.4
    end
    if string.match(creep:GetUnitName(), "upgraded_mega") then
        rate = rate * 0.5
    elseif string.match(creep:GetUnitName(), "upgraded") then
        rate = rate * 0.8
    end
    return rate
end

local standardCreepRate = 0
local GetStandardCreepRate = AbilityExtensions:EveryManySeconds(2, function()
    standardCreepRate = AbilityExtensions:MaxV(GetUnitList(UNIT_LIST_ENEMY_CREEPS) or {}, RateCreep) or 0
end)
Consider[5] = function()
    local abilityNumber = 5
    --------------------------------------
    -- Generic Variable Setting
    --------------------------------------
    local ability = AbilitiesReal[abilityNumber]
    if not ability:IsFullyCastable() then
        return BOT_ACTION_DESIRE_NONE
    end
    local CastRange = ability:GetCastRange()
    local enemys = npcBot:GetNearbyHeroes(CastRange + 300, true, BOT_MODE_NONE)
    GetStandardCreepRate()
    local creeps = AbilityExtensions:Filter(AbilityExtensions:Concat(npcBot:GetNearbyCreeps(CastRange + 300, true),
        npcBot:GetNearbyNeutralCreeps(CastRange + 300)), CanCast[5])
    do
        local creep = creeps:Max(RateCreep)
        if creep then
            if RateCreep(creep) < standardCreepRate then
                return BOT_ACTION_DESIRE_VERYLOW
            else
                return BOT_ACTION_DESIRE_MODERATE
            end
        end
    end
    return BOT_ACTION_DESIRE_NONE
end
AbilityExtensions:AutoModifyConsiderFunction(npcBot, Consider, AbilitiesReal)
function AbilityUsageThink()

	-- Check if we're already using an ability
    if npcBot:IsUsingAbility() or npcBot:IsChanneling() or npcBot:IsSilenced() then
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
    ability_item_usage_generic.UseAbility(AbilitiesReal, cast)
end

function CourierUsageThink()
    ability_item_usage_generic.CourierUsageThink()
end
