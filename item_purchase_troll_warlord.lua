----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.5d
--	Author: adamqqq		Email:adamqqq@163.com
--  Contributor: zmcmcc Email:mengzhang@utexas.edu
----------------------------------------------------------------------------
local utility = require( GetScriptDirectory().."/utility" ) 

local ItemsToBuy = 
{ 
	"item_tango",
	"item_flask",
	"item_stout_shield",
	"item_branches",
	"item_branches",

	"item_magic_stick",			
	
	"item_recipe_magic_wand",		--大魔棒7.14

	"item_boots",

	"item_blades_of_attack",
	"item_blades_of_attack",		--相位

	"item_slippers",
	"item_circlet",
	"item_recipe_wraith_band", --系带
	"item_ring_of_protection",
	"item_sobi_mask",				--天鹰

	"item_boots_of_elves",
	"item_blade_of_alacrity",
	"item_recipe_yasha",			--夜叉
	"item_ogre_axe",
    "item_belt_of_strength",
    "item_recipe_sange",			--双刀

	"item_ogre_axe", 
	"item_mithril_hammer",
	"item_recipe_black_king_bar",	--bkb

	"item_eagle",
	"item_talisman_of_evasion",
	"item_quarterstaff",			--蝴蝶
	
	"item_demon_edge",	
	"item_quarterstaff",	
	"item_javelin",					--金箍棒7.14
}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.ItemPurchase(ItemsToBuy)
end