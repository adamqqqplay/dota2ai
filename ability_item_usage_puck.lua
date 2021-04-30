-- v1.7 template by AaronSong321
local utility = require(GetScriptDirectory().."/utility") 
local ability_item_usage_generic = require(GetScriptDirectory() ..  "/ability_item_usage_generic")
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
local CanCast = {}
CanCast[1] = function(t) return AbilityExtensions:NormalCanCast(t, false) end
CanCast[2] = CanCast[1]
CanCast[3] = function(t) return not AbilityExtensions:IsInvulnerable(t) or not AbilityExtensions:ShouldNotBeAttacked(t) end
CanCast[4] = function() return true end
CanCast[5] = CanCast[1]

local Consider = {}

local function GetIllusoryOrb()
    return AbilityExtensions:First(GetLinearProjectiles(), function(t)
        return t.ability and t.ability:GetName() == "puck_illusory_orb" and t.caster == npcBot
    end)
end
local illusoryOrb

Consider[2]=function()
    local ability = Abilities[2]
    if not ability:IsFullyCastable() or AbilityExtensions:CannotMove(npcBot) then
        return BOT_ACTION_DESIRE_NONE
    end

end

AbilityExtensions:AutoModifyConsiderFunction(npcBot, Consider, Abilities)

function AbilityUsageThink()
    if refreshIllusoryOrbToken then
        
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