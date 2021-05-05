----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.3 New Structure
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
-- v1.7 template
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
local CanCast={function(t)
    return AbilityExtensions:NormalCanCast(t, false, DAMAGE_TYPE_PURE, true, false) 
end,utility.NCanCast,utility.NCanCast,utility.CanCastNoTarget,function(t)
    return AbilityExtensions:NormalCanCast(t, false, DAMAGE_TYPE_MAGICAL, true, true) and not AbilityExtensions:HasAbilityRetargetModifier(t)
end}
local enemyDisabled=utility.enemyDisabled

Consider[1] = function()
    local ability = AbilitiesReal[1]
    if not ability:IsFullyCastable() or npcBot:IsChanneling() then
        return 0
    end
    local castPoint = ability:GetCastPoint()
    local range = ability:GetSpecialValueInt("hook_distance")
    local searchRadius = ability:GetSpecialValueInt("hook_width")
    local hookSpeed = ability:GetSpecialValueFloat("hook_speed")
    local allNearbyUnits = AbilityExtensions:GetNearbyAllUnits(npcBot, range)

    local function NotBlockedByAnyUnit(line, target, distance)
        return AbilityExtensions:All(AbilityExtensions:Remove(allNearbyUnits, target), function(t)
            local f = AbilityExtensions:GetPointToLineDistance(t:GetLocation(), line) <= searchRadius + target:GetBoundingRadius() and distance <= GetUnitToUnitDistance(npcBot, t) or t:IsInvulnerable()
            return f
        end)
    end

    local function T(target)
        local point = target:GetExtrapolatedLocation(GetUnitToUnitDistance(npcBot, target) / hookSpeed + castPoint)
        local distance = GetUnitToLocationDistance(npcBot, point)
        local line = AbilityExtensions:GetLine(npcBot:GetLocation(), point)
        local result = GetUnitToLocationDistance(npcBot, point) <= range and NotBlockedByAnyUnit(line, target, distance)
        return result
    end

    local enemies = AbilityExtensions:GetNearbyNonIllusionHeroes(npcBot, range, true, BOT_MODE_NONE)
    enemies = AbilityExtensions:SortByMaxFirst(enemies, function(t) return GetUnitToUnitDistance(npcBot, t)  end)
    enemies = AbilityExtensions:Filter(enemies, T)
    if #enemies ~= 0 and CanCast[1](enemies[1]) then
        return BOT_MODE_DESIRE_HIGH, enemies[1]:GetExtrapolatedLocation(GetUnitToUnitDistance(npcBot, enemies[1]) / 1450)
    end

    local allies = AbilityExtensions:GetNearbyNonIllusionHeroes(npcBot, range, false, BOT_MODE_NONE)
    allies = AbilityExtensions:Filter(allies, function(t) return t:IsStunned() or t:IsRooted()  end)
    allies = AbilityExtensions:Filter(allies, T)
    if #allies ~= 0 and CanCast[1](allies[1]) then
        return BOT_MODE_DESIRE_HIGH, allies[1]:GetExtrapolatedLocation(GetUnitToUnitDistance(npcBot, enemies[1]) / 1450)
    end

    return 0
end

Consider[2] = function()
    local ability = AbilitiesReal[2]
    local radius = ability:GetAOERadius()
    if not ability:IsFullyCastable() then
        return false
    end
    if AbilityExtensions:IsAttackingEnemies(npcBot) or AbilityExtensions:IsRetreating(npcBot) then
        local nearbyEnemies = npcBot:GetNearbyHeroes(radius, true, BOT_MODE_NONE)
        if #nearbyEnemies ~= 0 then
            return AbilityExtensions:Any(nearbyEnemies, function(t) npcBot:WasRecentlyDamagedByHero(t, 1.5) end) or AbilityExtensions:GetHealthPercent(npcBot) >= 0.3
        end
        return false
    end
    do
        local target = npcBot:GetTarget()
        if target and GetUnitToUnitDistance(target, npcBot) <= radius and AbilityExtensions:NormalCanCast(target, false) then
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
    if not ability:IsFullyCastable() or npcBot:IsChanneling() then
        return nil
    end
    local range = ability:GetCastRange() + 100
    local hookedEnemy = AbilityExtensions:First(AbilityExtensions:GetNearbyNonIllusionHeroes(npcBot, range, true, BOT_MODE_NONE), function(t)
        return t:IsHero() and AbilityExtensions:MayNotBeIllusion(npcBot, t) and t:HasModifier("modifier_pudge_meat_hook")
    end)
    if hookedEnemy ~= nil then
        return BOT_MODE_DESIRE_VERYHIGH, hookedEnemy
    end

    do 
        local target = AbilityExtensions:GetTargetIfGood(npcBot)
        if target ~= nil and CanCast[5](target) and GetUnitToUnitDistance(npcBot, target) <= range then
            return BOT_MODE_DESIRE_HIGH, target
        end
    end
    local nearbyEnemies = AbilityExtensions:GetNearbyNonIllusionHeroes(npcBot, 900, true, BOT_MODE_NONE)
    if AbilityExtensions:IsAttackingEnemies(npcBot) then
        local u = utility.GetWeakestUnit(nearbyEnemies)
        if u ~= nil and CanCast[5](u) then
            return BOT_MODE_DESIRE_HIGH, u
        end
    end
    if AbilityExtensions:IsRetreating(npcBot) and #nearbyEnemies == 1 then
        local loneEnemy = nearbyEnemies[1]
        if not AbilityExtensions:HasAbilityRetargetModifier(loneEnemy) and CanCast[5](loneEnemy) then
            return BOT_MODE_DESIRE_MODERATE, loneEnemy
        end
    end

    -- if has shard
    -- local function CanCast5AtFriend(friend)
    --     return not AbilityExtensions:IsInvulnerable(friend) and not AbilityExtensions:CannotBeTargetted()
    -- end
    -- local nearbyAllies = AbilityExtensions:Filter(AbilityExtensions:GetNearbyNonIllusionHeroes(npcBot, range+200, false, BOT_MODE_NONE), function(t) return AbilityExtensions:CanHardlyMove(t)  end)
    -- nearbyAllies = AbilityExtensions:SortByMinFirst(nearbyAllies, function(t) return t:GetHealth() end)
    -- if #nearbyAllies ~= 0 and CanCast5AtFriend(nearbyAllies[1]) then
    --     return BOT_MODE_DESIRE_MODERATE, nearbyAllies[1]
    -- end
    return 0
end


function CourierUsageThink() 
	ability_item_usage_generic.CourierUsageThink()
end

function AbilityUsageThink()
    if npcBot:IsUsingAbility() or npcBot:IsSilenced() then
        return
    end

    cast=ability_item_usage_generic.ConsiderAbility(AbilitiesReal,Consider)
    ability_item_usage_generic.UseAbility(AbilitiesReal,cast)
end
