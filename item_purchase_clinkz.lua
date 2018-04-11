----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local utility = require( GetScriptDirectory().."/utility" ) 

local ItemsToBuy = 
{ 
	"item_tango",
	"item_branches",
	"item_branches",
	"item_enchanted_mango",			--大魔棒7.07
	"item_circlet",

	"item_magic_stick",

	"item_boots",

	"item_slippers",
	"item_recipe_wraith_band", --系带

	"item_ring_of_protection",
	"item_sobi_mask",				--天鹰
	
	"item_belt_of_strength",
	"item_gloves",					--假腿
	
	"item_blight_stone",
    "item_mithril_hammer",
    "item_mithril_hammer",			--黯灭

	"item_quarterstaff",
	"item_robe",
	"item_sobi_mask",
	"item_quarterstaff",
	"item_robe",
	"item_sobi_mask",
	"item_recipe_orchid",			--紫苑
	
	"item_ogre_axe", 
	"item_mithril_hammer",
	"item_recipe_black_king_bar",	--bkb
	
	"item_broadsword",
	"item_blades_of_attack",
	"item_recipe_lesser_crit" ,
	"item_recipe_bloodthorn",		--血棘
	
	
	"item_hyperstone",
	"item_javelin",
	"item_javelin",					--金箍棒7.07
	
	"item_lifesteal",
	"item_reaver", 
	"item_claymore",				--撒旦7.07
}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.ItemPurchase(ItemsToBuy)
end