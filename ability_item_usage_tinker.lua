local utility = require( GetScriptDirectory().."/utility" ) 
require(GetScriptDirectory() ..  "/ability_item_usage_generic")
local AbilityExtensions = require(GetScriptDirectory().."/util/AbilityAbstraction")


local debugmode=false
local npcBot = GetBot()
local Talents ={}
local Abilities ={}
local AbilitiesReal ={}

ability_item_usage_generic.InitAbility(Abilities,AbilitiesReal,Talents)


local AbilityToLevelUp = {
    Abilities[1],
    Abilities[2],
    Abilities[1],
    Abilities[2],
    Abilities[1],
    Abilities[2],
    Abilities[1],
    Abilities[2],
    Abilities[5],
    "talent",
    Abilities[3],
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

local TalentTree = {
    function() return Talents[2]  end,
    function() return Talents[3]  end,
    function() return Talents[5]  end,
    function() return Talents[7]  end,
}

local Consider = {}

utility.CheckAbilityBuild(AbilityToLevelUp)

local function TryLastHitWithAttack(npc, target)
    local time = npc:GetAttackPoint() + GetUnitToUnitDistance(npc, target) / npc:GetAttackProjectileSpeed()
    return time
end
local function ReadyForLastHit(npc, target)
    local damage = npc:GetAttackDamage()
    if target:WasRecentlyDamagedByAnyHero(1.5) or target:WasRecentlyDamagedByCreep(1.7) then
        damage = damage * 1.05
    end
    return target:GetActualIncomingDamage(damage, DAMAGE_TYPE_PHYSICAL) >= target:GetHealth()
end

Consider[1] = function()
    local manaPercentage = AbilityExtensions:GetManaPercent(npcBot)
    local ability = AbilitiesReal[1]
    if not ability:IsFullyCastable() then
        return 0 
    end
    if npcBot:GetActiveMode() == BOT_MODE_LANING then
        local enemyCreeps = npcBot:GetNearbyCreeps(1200, true)
        local rangedCreep = AbilityExtensions:First(enemyCreeps, function(t) 
            return t:GetAttackRange() >= 500
        end)
        local enemy = AbilityExtensions:First(npcBot:GetNearbyHeroes(1200, true, BOT_MODE_NONE))
        if rangedCreep ~= nil and enemy ~= nil then
            if ReadyForLastHit(npcBot, rangedCreep) and manaPercentage >= 0.6 then
                if enemy:GetAttackTarget() == rangedCreep then
                    return BOT_MODE_DESIRE_MODERATE, rangedCreep
                end
                if TryLastHitWithAttack(enemy, rangedCreep) < TryLastHitWithAttack(npcBot, rangedCreep) then
                    return BOT_MODE_DESIRE_MODERATE, rangedCreep
                end
            end
        end

        if enemy ~= nil then
            local allCreeps = AbilityExtensions:Concat(npcBot:GetNearbyCreeps(900, true), npcBot:GetNearbyCreeps(900, false))
            allCreeps = AbilityExtensions:Filter(allCreeps, function(t) return t:GetHealth() <= enemy:GetAttackDamage() * 1.2 end)
            if #allCreeps >= 2 and manaPercentage >= 0.4 then
                return BOT_MODE_DESIRE_MODERATE, enemy
            end

            if manaPercentage >= 0.6 then
                return BOT_MODE_DESIRE_MODERATE, enemy
            end
        end
    end
    if AbilityExtensions:IsAttackingEnemy(npcBot) then
        local enemies = npcBot:GetNearbyHeroes(900, true, BOT_MODE_NONE)
    end
end

function AbilityLevelUpThink()
    ability_item_usage_generic.AbilityLevelUpThink2(AbilityToLevelUp,TalentTree)
end

AbilityExtensions:AutoModifyConsiderFunction(npcBot, Consider, AbilitiesReal)

function AbilityUsageThink()
	if ( npcBot:IsUsingAbility() or npcBot:IsChanneling() or npcBot:IsSilenced() )
	then 
		return
	end
	
	cast=ability_item_usage_generic.ConsiderAbility(AbilitiesReal,Consider)
	ability_item_usage_generic.UseAbility(AbilitiesReal,cast)
end

function CourierUsageThink() 
	ability_item_usage_generic.CourierUsageThink()
end