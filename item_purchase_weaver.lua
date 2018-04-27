----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.5c
--	Author: adamqqq		Email:adamqqq@163.com
--  Contributor: zmcmcc Email:mengzhang@utexas.edu
----------------------------------------------------------------------------
local utility = require( GetScriptDirectory().."/utility" ) 

local ItemsToBuy = 
{ 
	"item_slippers",
	"item_circlet",
	"item_recipe_wraith_band", --系带
	"item_tango",

	"item_branches",
	"item_branches",
	"item_magic_stick",
	"item_recipe_magic_wand",		--大魔棒7.14

	"item_ring_of_protection",
	"item_sobi_mask",				--天鹰

	"item_boots",
	"item_belt_of_strength",
	"item_gloves",					--假腿

	"item_ring_of_health",
	"item_void_stone",
	"item_ultimate_orb",
	"item_recipe_sphere",			--林肯
	
	"item_blight_stone",
    "item_mithril_hammer",
    "item_mithril_hammer",			--黯灭

	"item_ogre_axe", 
	"item_mithril_hammer",
	"item_recipe_black_king_bar",	--bkb
	
	"item_quarterstaff",
	"item_eagle",
	"item_talisman_of_evasion",		--蝴蝶
	
	"item_point_booster",
    "item_ultimate_orb",
    "item_ultimate_orb",			--冰眼
}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.ItemPurchase(ItemsToBuy)
end