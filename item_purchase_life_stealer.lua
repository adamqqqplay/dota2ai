----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local utility = require( GetScriptDirectory().."/utility" ) 

local ItemsToBuy = 
{ 
	"item_tango",
    "item_stout_shield",
	"item_blight_stone",
	"item_branches",
	"item_branches",
	
	"item_boots",
	"item_gloves",
	"item_chainmail",			--相位7.20
	
	"item_magic_stick",
	"item_recipe_magic_wand",		--大魔棒7.14
	
	"item_helm_of_iron_will", 
	"item_gloves", 
	"item_blades_of_attack",
	"item_recipe_armlet",			--臂章
	
	"item_ogre_axe",
	"item_belt_of_strength",
	"item_recipe_sange",
	"item_blade_of_alacrity",
	"item_boots_of_elves",
	"item_recipe_yasha",
	
	"item_mithril_hammer",
	"item_mithril_hammer",
	
	"item_mithril_hammer",
	"item_belt_of_strength",
	"item_recipe_basher",			--晕锤7.14
	
	"item_ring_of_health",
	"item_vitality_booster",
	"item_stout_shield",
	"item_recipe_abyssal_blade",
	
	"item_hyperstone",
	"item_platemail",
	"item_chainmail",
	"item_recipe_assault",
}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.ItemPurchase(ItemsToBuy)
end