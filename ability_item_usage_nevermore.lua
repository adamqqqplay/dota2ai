----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.1 NewStructure
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
--------------------------------------
-- General Initialization
--------------------------------------
local utility = require( GetScriptDirectory().."/utility" ) 
require(GetScriptDirectory() ..  "/ability_item_usage_generic")

local debugmode=false
local npcBot = GetBot()
local Talents ={}
local Abilities ={}
local AbilitiesReal ={}

ability_item_usage_generic.InitAbility(Abilities,AbilitiesReal,Talents) 

-- utility.PrintAbilityName(Abilities)
local abilityName = { "nevermore_shadowraze1", "nevermore_shadowraze2", "nevermore_shadowraze3", "nevermore_necromastery", "nevermore_dark_lord", "nevermore_requiem" }
local abilityIndex = utility.ReverseTable(abilityName)


local AbilityToLevelUp=
{
	Abilities[4],
	Abilities[1],
	Abilities[4],
	Abilities[1],
	Abilities[4],
	Abilities[1],
	Abilities[4],
	Abilities[1],
	Abilities[6],
	"talent",
	Abilities[5],
	Abilities[6],
	Abilities[5],
	Abilities[5],
	"talent",
	Abilities[5],
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

local TalentTree={
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
		return Talents[7]
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

function GetComboDamage()
	return ability_item_usage_generic.GetComboDamage(AbilitiesReal)
end

function GetComboMana()
	return ability_item_usage_generic.GetComboMana(AbilitiesReal)
end

function CourierUsageThink() 
	ability_item_usage_generic.CourierUsageThink()
end