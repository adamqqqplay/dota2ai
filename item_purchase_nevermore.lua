----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
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
	"item_enchanted_mango",			--大魔棒7.07

	"item_boots",

	"item_ring_of_protection",
	"item_sobi_mask",				--天鹰

	"item_belt_of_strength",
	"item_gloves",					--假腿
	
	"item_shadow_amulet",
	"item_claymore",				--隐刀

	"item_ogre_axe", 
	"item_mithril_hammer",
	"item_recipe_black_king_bar",	--bkb

	"item_point_booster",		
	"item_staff_of_wizardry",
	"item_ogre_axe",
	"item_blade_of_alacrity",		--蓝杖


	"item_ultimate_orb",
	"item_recipe_silver_edge",		--大隐刀
	
	
	"item_quarterstaff",
	"item_eagle",
	"item_talisman_of_evasion",		--蝴蝶
	
	"item_lifesteal",
	"item_reaver", 
	"item_claymore",				--撒旦7.07
}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.ItemPurchase(ItemsToBuy)
end