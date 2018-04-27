----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local utility = require( GetScriptDirectory().."/utility" ) 

local ItemsToBuy = 
{ 
	"item_tango",
	"item_stout_shield",
	"item_magic_stick",
	"item_recipe_magic_wand",			--大魔棒7.14
	"item_branches",
	"item_branches",

	"item_boots",
	"item_belt_of_strength",
	"item_gloves",					--假腿
	
	"item_helm_of_iron_will", 
	"item_gloves", 
	"item_blades_of_attack",
	"item_recipe_armlet",			--臂章

	"item_quarterstaff",
	"item_robe",
	"item_sobi_mask",
	"item_ogre_axe",				--连击刀

	"item_boots_of_elves",
	"item_blade_of_alacrity",
	"item_recipe_yasha",			--夜叉
	"item_ultimate_orb",
	"item_recipe_manta",			--分身

	"item_vitality_booster",
	"item_vitality_booster",		
	"item_reaver",					--龙心7.06

	"item_hyperstone",
	"item_platemail",
	"item_chainmail",
	"item_recipe_assault",			--强袭
}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.ItemPurchase(ItemsToBuy)
end