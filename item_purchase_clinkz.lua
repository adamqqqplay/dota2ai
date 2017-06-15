----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
require( GetScriptDirectory().."/utility" ) 

local ItemsToBuy = 
{ 
	"item_tango",
	"item_flask",
	"item_branches",
	"item_branches",
	"item_circlet",
	"item_boots",
	"item_magic_stick",				--大魔棒
	"item_belt_of_strength",
	"item_gloves",					--假腿
	
	"item_boots_of_elves",
	"item_boots_of_elves", 
	"item_ogre_axe",				--魔龙枪

	"item_quarterstaff",
	"item_robe",
	"item_sobi_mask",
	"item_quarterstaff",
	"item_robe",
	"item_sobi_mask",
	"item_recipe_orchid",			--紫苑
	
	"item_ring_of_health",
	"item_staff_of_wizardry",
	"item_recipe_force_staff",
	"item_recipe_hurricane_pike",	--大推推7.06
	
	"item_broadsword",
	"item_blades_of_attack",
	"item_recipe_lesser_crit" ,
	"item_recipe_bloodthorn",		--血棘
	
	"item_ogre_axe", 
	"item_mithril_hammer",
	"item_recipe_black_king_bar",	--bkb
	
	"item_demon_edge",
	"item_javelin",
	"item_javelin",					--金箍棒
	
	"item_lifesteal",
	"item_reaver", 
	"item_mithril_hammer",			--撒旦
}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.ItemPurchase(ItemsToBuy)
end