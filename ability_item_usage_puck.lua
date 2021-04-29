-- v1.7 template by AaronSong321
local utility = require(GetScriptDirectory().."/utility") 
require(GetScriptDirectory() ..  "/ability_item_usage_generic")
local AbilityExtensions = require(GetScriptDirectory().."/util/AbilityAbstraction")

local npcBot = GetBot()
if npcBot:IsIllusion() then
    return
end
local AbilityNames, Abilities, Talents = AbilityExtensions:InitAbility()

local AbilityToLevelUp = {
    AbilityNames[1],
    AbilityNames[3],
    AbilityNames[1],
    AbilityNames[2],
    AbilityNames[1],
    AbilityNames[5],
    AbilityNames[1],
    AbilityNames[3],
    AbilityNames[2],
    "talent",
    AbilityNames[2],
    AbilityNames[5],
    AbilityNames[2],
    AbilityNames[3],
    "talent",
    AbilityNames[3],
    "nil",
    AbilityNames[5],
    "nil",
    "talent",
    "nil",
    "nil",
    "nil",
    "nil",
    "talent",
}

local TalentTree = {
    function() return Talents[2] end,
    function() return Talents[3] end,
    function() return Talents[6] end,
    function() return Talents[8] end,
}

utility.CheckAbilityBuild(AbilityToLevelUp)

function AbilityLevelUpThink()
    ability_item_usage_generic.AbilityLevelUpThink2(AbilityToLevelUp, TalentTree)
end

--------------------------------------
-- Ability Usage Thinking
--------------------------------------
local cast= {} cast.Desire= {} cast.Target= {} cast.Type= {}
local Consider = {}

local attackRange
local healthPercent
local manaPercent
local illusoryOrb
local refreshIllusoryOrbToken

local EnlargeIllusoryOrbCastRange
Consider[1] = function()
    local ability = Abilities[1]
    if not ability:IsFullyCastable() then
        return 0
    end
    local castRange = math.min(ability:GetCastRange(), 1599)
    if EnlargeIllusoryOrbCastRange == nil then
        EnlargeIllusoryOrbCastRange = AbilityExtensions:EveryManySeconds(2, function()
            castRange = ability:GetCastRange()
        end)
    end
    EnlargeIllusoryOrbCastRange()
    local castPoint = ability:GetCastPoint()
    local manaCost = ability:GetManaCost()
    local enemies = npcBot:GetNearbyHeroes(castRange, true, BOT_MODE_NONE)
    local realEnemies = AbilityExtensions:Filter(enemies, function(t) return AbilityExtensions:MayNotBeIllusion(t) end)
    local targettableEnemies = AbilityExtensions:Filter(realEnemies, function(t) return AbilityExtensions:NormalCanCast(t) end)
    local friends = npcBot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
    local enemyCreeps = AbilityExtensions:GetNearbyAttackableCreeps(npcBot, 900)
    local friendCreeps = AbilityExtensions:GetNearbyAttackableCreeps(npcBot, npcBot:GetAttackRange()+150, false)
    local damage = ability:GetAbilityDamage()
    local weakestEnemy, enemyHealth = utility.GetWeakestUnit(targettableEnemies)
    local weakCreeps = AbilityExtensions:Filter(enemyCreeps, function(t) return t:GetHealth() < t:GetActualIncomingDamage(damage, DAMAGE_TYPE_MAGICAL) end)
    local weakestCreep = utility.GetWeakestUnit(weakCreeps)
    local forbiddenCreeps = AbilityExtensions:Filter(enemyCreeps, function(t)
        return t:GetHealth() > t:GetActualIncomingDamage(damage, DAMAGE_TYPE_MAGICAL) and t:GetHealth() <= t:GetActualIncomingDamage(damage, DAMAGE_TYPE_MAGICAL) + AbilityExtensions:AttackOnceDamage(npcBot, t) * (0.9+#enemyCreeps*0.1)
    end)
    if #friendCreeps == 0 then
        forbiddenCreeps = {}
    end

    local distance = 1500
    local orbSpeed = 1500
    local radius = 150

    --try to kill enemy hero
    if npcBot:GetActiveMode() ~= BOT_MODE_RETREAT then
        if weakestEnemy~=nil and AbilityExtensions:NormalCanCast(weakestEnemy) then
            if enemyHealth<=weakestEnemy:GetActualIncomingDamage(damage, DAMAGE_TYPE_MAGICAL) or (enemyHealth<=weakestEnemy:GetActualIncomingDamage(GetComboDamage(), DAMAGE_TYPE_MAGICAL) and npcBot:GetMana() > ComboMana) then
                return BOT_ACTION_DESIRE_HIGH, weakestEnemy.GetExtrapolatedLocation
            end
        end
    end
    --------------------------------------
    -- Mode based usage
    --------------------------------------
    --Last hit
    if weakestCreep~=nil and #forbiddenCreeps == 0 then
        if (manaPercent>0.6 and npcBot:GetMana()>ComboMana) and GetUnitToUnitDistance(npcBot,weakestCreep) >= 550 then
            local locationAoE = npcBot:FindAoELocation(true, false, npcBot:GetLocation(), castRange, radius, GetUnitToUnitDistance(npcBot,weakestCreep)/orbSpeed, damage)
            if locationAoE.count >= 1 then
                return BOT_ACTION_DESIRE_MODERATE+0.02, locationAoE.targetloc
            end
        end
    end

    if (manaPercent>0.6 or npcBot:GetMana()>ComboMana) and ability:GetLevel()>=3 then
        local locationAoE = npcBot:FindAoELocation(true, true, npcBot:GetLocation(), castRange, radius, attackRange/GetUnitToUnitDistance(npcBot,weakestCreep)/orbSpeed, 0)
        if locationAoE.count >= 3 then
            return BOT_ACTION_DESIRE_MODERATE-0.05, locationAoE.targetloc
        end
    end

    -- If we're pushing or defending a lane and can hit 4+ creeps, go for it
    if AbilityExtensions:IsFarmingOrPushing(npcBot) then
        local locationAoE = npcBot:FindAoELocation(true, false, npcBot:GetLocation(), castRange, radius, attackRange/GetUnitToUnitDistance(npcBot,weakestCreep)/orbSpeed, 0)
        if locationAoE.count >= 4
        then
            return BOT_ACTION_DESIRE_MODERATE-0.05, locationAoE.targetloc
        end
    end

    -- If we're going after someone
    if AbilityExtensions:IsAttackingEnemies(npcBot) then
        local npcTarget = npcBot:GetTarget()
        if npcTarget ~= nil then
            if AbilityExtensions:NormalCanCast(npcTarget) then
                return BOT_ACTION_DESIRE_MODERATE, npcTarget:GetLocation()
            end
        end
    end
    return 0
end

Consider[2]=function()
    local ability = Abilities[2]
    if not ability:IsFullyCastable() or not AbilityExtensions:CanMove(npcBot) then
        return BOT_ACTION_DESIRE_NONE
    end

end

AbilityExtensions:AutoModifyConsiderFunction(npcBot, Consider, Abilities)

function AbilityUsageThink()
    if refreshIllusoryOrbToken then
        illusoryOrb = AbilityExtensions:First(GetUnitList(UNIT_LIST_ALL), function(t)
            return t:GetTeam() == npcBot:GetTeam() and t:GetUnitName() == ""
        end)
    end
	if npcBot:IsUsingAbility() or npcBot:IsChanneling() or npcBot:IsSilenced() then 
		return
	end
	ComboMana=GetComboMana(Abilities)
    attackRange = npcBot:GetAttackRange()
    healthPercent = AbilityExtensions:GetHealthPercent(npcBot)
    manaPercent = AbilityExtensions:GetManaPercent(npcBot)
	cast=ability_item_usage_generic.ConsiderAbility(Abilities,Consider)
	local abilityIndex, target, castType = ability_item_usage_generic.UseAbility(Abilities,cast)
    if abilityIndex == 1 then
        refreshIllusoryOrbToken = true
    end
end

function CourierUsageThink() 
	ability_item_usage_generic.CourierUsageThink()
end