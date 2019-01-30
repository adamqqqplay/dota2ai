----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
--  Contributor: zmcmcc Email:mengzhang@utexas.edu
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy = 
{ 
	"item_stout_shield",
	"item_branches",
	"item_branches",
	"item_tango",
	"item_boots",
	"item_magic_stick",
	"item_recipe_magic_wand",			--大魔棒7.14
	"item_belt_of_strength",
	"item_gloves",			--假腿7.21

	"item_slippers",
	"item_circlet",
	"item_recipe_wraith_band",
	
	"item_boots_of_elves",
	"item_boots_of_elves", 
	"item_ogre_axe",				--魔龙枪
	
	"item_boots_of_elves",
	"item_blade_of_alacrity",
	"item_recipe_yasha",			--夜叉
	"item_ogre_axe",
    "item_belt_of_strength",
    "item_recipe_sange",			--双刀
	
    "item_point_booster",
    "item_ultimate_orb",
    "item_ultimate_orb",			--冰眼

    "item_eagle",
    "item_talisman_of_evasion",
    "item_quarterstaff",			--蝴蝶
	
	"item_demon_edge",	
	"item_quarterstaff",	
	"item_javelin",					--金箍棒7.14
}

ItemPurchaseSystem.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(ItemsToBuy)
end