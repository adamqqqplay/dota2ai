----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.5b
--	Author: adamqqq		Email:adamqqq@163.com
--  Contributor: zmcmcc Email:mengzhang@utexas.edu
----------------------------------------------------------------------------
local utility = require( GetScriptDirectory().."/utility" ) 

local ItemsToBuy = 
{ 
	"item_stout_shield",
	"item_branches",
	"item_branches",
	"item_enchanted_mango",
	"item_tango",

	"item_boots",
	"item_magic_stick",
	"item_belt_of_strength",
	"item_gloves",					--假腿

	"item_slippers",
	"item_circlet",
	"item_recipe_wraith_band",
	
	"item_ring_of_protection",
	"item_sobi_mask",				--天鹰
	
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
	
	"item_hyperstone",
	"item_javelin",
	"item_javelin",					--金箍棒7.07
}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.ItemPurchase(ItemsToBuy)
end