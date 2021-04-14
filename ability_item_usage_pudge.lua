----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.3 New Structure
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
--------------------------------------
-- General Initialization
--------------------------------------
local utility = require( GetScriptDirectory().."/utility" ) 
require(GetScriptDirectory() ..  "/ability_item_usage_generic")
local AbilityExtensions = require(GetScriptDirectory().."/util/AbilityAbstraction")

local debugmode=false
local npcBot = GetBot()
local Talents ={}
local Abilities ={}
local AbilitiesReal ={}

ability_item_usage_generic.InitAbility(Abilities,AbilitiesReal,Talents) 

local AbilityToLevelUp=
{
	Abilities[1],
	Abilities[2],
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

local TalentTree={
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
	end
}

-- check skill build vs current level
utility.CheckAbilityBuild(AbilityToLevelUp)

function AbilityLevelUpThink()
	ability_item_usage_generic.AbilityLevelUpThink2(AbilityToLevelUp,TalentTree)
end

--------------------------------------
-- Ability Usage Thinking
--------------------------------------
local cast={} cast.Desire={} cast.Target={} cast.Type={}
local Consider ={}
local CanCast={utility.NCanCast,utility.NCanCast,utility.NCanCast,utility.UCanCast}
local enemyDisabled=utility.enemyDisabled

Consider[1] = function()
    local ability = AbilitiesReal[1]
    if not ability:IsFullyCastable() then
        return 0
    end
    local range = 1300
    local searchRadius = ability:GetSpecialValueInt("hook_search_radius") or 100
    local allNearbyUnits = AbilityExtensions:GetNearbyAllUnits(npcBot, range)

    local function NotBlockedByAnyUnit(line, target, distance)
        return AbilityExtensions:All(AbilityExtensions:Remove(allNearbyUnits, target), function(t)
            local f = AbilityExtensions:GetPointToLineDistance(t:GetLocation(), line) <= searchRadius and distance <= GetUnitToUnitDistance(npcBot, t)
            if not f then
                print("blocked by "..t:GetUnitName())
            end
            return f
        end)
    end

    local function T(target)
        local point = target:GetExtrapolatedLocation(GetUnitToUnitDistance(npcBot, target) / 1450)
        local distance = GetUnitToLocationDistance(npcBot, point)
        local line = AbilityExtensions:GetLine(npcBot:GetLocation(), point)
        if line == nil then
            print("pudge: line == nil")
            npcBot:ActionImmediate_Chat("pudge: line == nil", true)
        end
        print("pudge: if I hook "..target:GetUnitName())
        local result = GetUnitToLocationDistance(npcBot, point) <= range and NotBlockedByAnyUnit(line, target, distance)
        if result then
            print("pudge: I can hook "..target:GetUnitName())
        end
        return result
    end

    local enemies = AbilityExtensions:GetNearbyNonIllusionHeroes(npcBot, range, true, BOT_MODE_NONE)
    enemies = AbilityExtensions:SortByMaxFirst(enemies, function(t) return GetUnitToUnitDistance(npcBot, t)  end)
    enemies = AbilityExtensions:Filter(enemies, T)
    if #enemies ~= 0 then
        return BOT_MODE_DESIRE_HIGH, enemies[1]:GetExtrapolatedLocation(GetUnitToUnitDistance(npcBot, enemies[1]) / 1450)
    end

    local allies = AbilityExtensions:GetNearbyNonIllusionHeroes(npcBot, range, false, BOT_MODE_NONE)
    allies = AbilityExtensions:Filter(allies, function(t) return t:IsStunned() or t:IsRooted()  end)
    allies = AbilityExtensions:Filter(allies, T)
    if #allies ~= 0 then
        return BOT_MODE_DESIRE_HIGH, allies[1]:GetExtrapolatedLocation(GetUnitToUnitDistance(npcBot, enemies[1]) / 1450)
    end

    return 0
end

Consider[2] = function()
    local ability = AbilitiesReal[2]
    local radius = 250
    if npcBot:HasScepter() then
        radius = 475
    end
    if not ability:IsFullyCastable() then
        return false
    end
    if AbilityExtensions:IsAttackingEnemies(npcBot) or AbilityExtensions:IsRetreating(npcBot) then
        local nearbyEnemies = npcBot:GetNearbyHeroes(radius, true, BOT_MODE_NONE)
        if #nearbyEnemies ~= 0 then
            AbilityExtensions:DebugTable(nearbyEnemies, function(t) return t:GetUnitName()  end)
            local p = AbilityExtensions:Filter(nearbyEnemies, function(t) npcBot:WasRecentlyDamagedByHero(t, 1.5) end) or AbilityExtensions:GetHealthPercent(npcBot) >= 0.3
            AbilityExtensions:DebugTable(p, function(t) return t:GetUnitName()  end)
            return #p > 0
        end
        return false
    end
    return false
end
Consider[2] = AbilityExtensions:ToggleFunctionToAction(npcBot, Consider[2], AbilitiesReal[2])

local swallowingSomething
local swallowTimer
Consider[4] = function()
    local ability = AbilitiesReal[4]
    if not ability:IsFullyCastable() then
        return 0
    end
    swallowingSomething =  npcBot:HasModifier("modifier_pudge_swallow") or npcBot:HasModifier("modifier_pudge_swallow_effect") or npcBot:HasModifier("modifier_pudge_swallow_hide")
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
    if not ability:IsFullyCastable() then
        return nil
    end
    local range = ability:GetCastRange() + 100
    local hookedEnemy = AbilityExtensions:First(AbilityExtensions:GetNearbyNonIllusionHeroes(npcBot, range, true, BOT_MODE_NONE), function(t)
        return t:IsHero() and AbilityExtensions:MayNotBeIllusion(npcBot, t) and t:HasModifier("modifier_pudge_meat_hook")
    end)
    if hookedEnemy ~= nil then
        return BOT_MODE_DESIRE_VERYHIGH, hookedEnemy
    end
    local nearbyEnemies = AbilityExtensions:GetNearbyNonIllusionHeroes(npcBot, range+200, true, BOT_MODE_NONE)
    if AbilityExtensions:IsAttackingEnemies(npcBot) then
        local u = utility.GetWeakestUnit(nearbyEnemies)
        if u ~= nil then
            return BOT_MODE_DESIRE_HIGH, u
        end
    end
    if AbilityExtensions:IsRetreating(npcBot) and #nearbyEnemies == 1 then
        return BOT_MODE_DESIRE_MODERATE, nearbyEnemies[1]
    end

    local nearbyAllies = AbilityExtensions:Filter(AbilityExtensions:GetNearbyNonIllusionHeroes(npcBot, range+200, false, BOT_MODE_NONE), function(t) return AbilityExtensions:CanHardlyMove(t)  end)
    nearbyAllies = AbilityExtensions:SortByMinFirst(nearbyAllies, function(t) return t:GetHealth()  end)
    if #nearbyAllies ~= 0 then
        return BOT_MODE_DESIRE_MODERATE, nearbyAllies[1]
    end
end

function GetComboDamage()
	return ability_item_usage_generic.GetComboDamage(AbilitiesReal)
end

function GetComboMana()
	return ability_item_usage_generic.GetComboMana(AbilitiesReal)
end

function CourierUsageThink() 
	ability_item_usage_generic.CourierUsageThink()
end

function AbilityUsageThink()
    if ( npcBot:IsUsingAbility() or npcBot:IsChanneling() or npcBot:IsSilenced() )
    then
        return
    end


    cast=ability_item_usage_generic.ConsiderAbility(AbilitiesReal,Consider)
    ---------------------------------debug--------------------------------------------
    if true then
        --ability_item_usage_generic.PrintDebugInfo(AbilitiesReal,cast)
    end
    ability_item_usage_generic.UseAbility(AbilitiesReal,cast)
end
