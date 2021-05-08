-- v1.7 template by AaronSong321
local utility = require(GetScriptDirectory().."/utility")
require(GetScriptDirectory() ..  "/ability_item_usage_generic")
local AbilityExtensions = require(GetScriptDirectory().."/util/AbilityAbstraction")

local npcBot = GetBot()
if npcBot:IsIllusion() then
    return
end
local AbilityNames, Abilities, Talents = AbilityExtensions:InitAbility(npcBot)
--local CanCast = {utility.NCanCast,utility.UCanCast,utility.NCanCast,utility.UCanCast,utility.UCanCast}

local AbilityToLevelUp =
{
    AbilityNames[2],
    AbilityNames[3],
	AbilityNames[3],
	AbilityNames[1],
	AbilityNames[3],
	AbilityNames[5],
	AbilityNames[3],
	AbilityNames[2],
	AbilityNames[2],
	"talent",
	AbilityNames[2],
	AbilityNames[1],
	AbilityNames[1],
	AbilityNames[1],
	"talent",
	AbilityNames[5],
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
		return Talents[8]
	end
}
utility.CheckAbilityBuild(AbilityToLevelUp)

function AbilityLevelUpThink()
    ability_item_usage_generic.AbilityLevelUpThink2(AbilityToLevelUp, TalentTree)
end

local cast= {} cast.Desire= {} cast.Target= {} cast.Type= {}

local CanCast = {}
CanCast[1] = function(t) return AbilityExtensions:NormalCanCast(t, false, DAMAGE_TYPE_MAGICAL, false) end
CanCast[2] = CanCast[1]
CanCast[3] = function(t) 
	local ability = npcBot:GetAbilityByName("special_bonus_unique_clockwerk_6")
	local breakInvisible = ability:GetLevel() == 1 and not ability:CanAbilityBeUpgraded()
	if breakInvisible then
		return AbilityExtensions:NormalCanCast(t, true, DAMAGE_TYPE_MAGICAL, false, false)
	else
		return AbilityExtensions:NormalCanCast(t, true, DAMAGE_TYPE_MAGICAL, false, t:IsInvisible())
	end
end
CanCast[4] = function() return true end
CanCast[5] = CanCast[4]
CanCast[6] = function(t)
	return AbilityExtensions:NormalCanCast(t, false, DAMAGE_TYPE_MAGICAL, true)
end

local Consider = {}


local attackRange
local healthPercent
local mana
local manaPercent

Consider[1] = function()
	local ability = Abilities[1]
    if not ability:IsFullyCastable() then
        return 0
    end
    local abilityLevel = ability:GetLevel()
    local castRange = ability:GetCastRange()
    local castPoint = ability:GetCastPoint()
    local manaCost = ability:GetManaCost()
    local duration = ability:GetDuration()
    local enemies = AbilityExtensions:GetNearbyHeroes(npcBot, castRange)
    local realEnemies = AbilityExtensions:Filter(enemies, function(t) return AbilityExtensions:MayNotBeIllusion(npcBot, t) end)
    local targettableEnemies = AbilityExtensions:Filter(realEnemies, function(t) return AbilityExtensions:NormalCanCast(t, true) end)
    local friends = AbilityExtensions:GetNearbyHeroes(npcBot, 1200, true)
    local friendCount = AbilityExtensions:GetEnemyHeroNumber(npcBot, friends)
    local enemyCreeps = AbilityExtensions:GetNearbyAttackableCreeps(npcBot, castRange)
    local friendCreeps = AbilityExtensions:GetNearbyAttackableCreeps(npcBot, npcBot:GetAttackRange()+150, false)
    local neutralCreeps = npcBot:GetNearbyNeutralCreeps(castRange)
    local damage = ability:GetSpecialValueInt("total_damage")
    local weakestEnemy, enemyHealth = utility.GetWeakestUnit(targettableEnemies)
    local weakCreeps = AbilityExtensions:Filter(enemyCreeps, function(t) return t:GetHealth() < t:GetActualIncomingDamage(damage, DAMAGE_TYPE_MAGICAL) end)
    local weakestCreep = utility.GetWeakestUnit(weakCreeps)
    local forbiddenCreeps = AbilityExtensions:Filter(enemyCreeps, function(t)
        return t:GetHealth() > t:GetActualIncomingDamage(damage, DAMAGE_TYPE_MAGICAL) and t:GetHealth() <= t:GetActualIncomingDamage(damage, DAMAGE_TYPE_MAGICAL) + AbilityExtensions:AttackOnceDamage(npcBot, t) * (0.9+#enemyCreeps*0.1)
    end)
    if #friendCreeps == 0 then
        forbiddenCreeps = {}
    end

	return 0
end

AbilityExtensions:AutoModifyConsiderFunction(npcBot, Consider, Abilities)

function AbilityUsageThink()
    if npcBot:IsChanneling() or npcBot:IsSilenced() then
        return
    end
    attackRange = npcBot:GetAttackRange()
    healthPercent = AbilityExtensions:GetHealthPercent(npcBot)
    mana = npcBot:GetMana()
    manaPercent = AbilityExtensions:GetManaPercent(npcBot)

    cast=ability_item_usage_generic.ConsiderAbility(Abilities,Consider)
    local abilityIndex, target, castType = ability_item_usage_generic.UseAbility(Abilities,cast)
end

function CourierUsageThink() 
	ability_item_usage_generic.CourierUsageThink()
end