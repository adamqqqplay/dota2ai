----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local utility = require( GetScriptDirectory().."/utility" ) 

local ItemsToBuy = 
{ 
	"item_tango",
	"item_quelling_blade",
	"item_gauntlets",
	"item_gauntlets",
	"item_ring_of_regen",
	"item_recipe_soul_ring",  		--魂戒
	
	"item_branches",
	"item_branches",
	"item_magic_stick",
	"item_enchanted_mango",			--大魔棒7.07

				"item_boots",
				"item_gloves",
				"item_belt_of_strength",		--假腿

				"item_gauntlets",
				"item_circlet",
				"item_recipe_bracer",
				
				"item_wind_lace",
				"item_sobi_mask",
				"item_recipe_ancient_janggo",	--战鼓

				"item_gloves",
				"item_mithril_hammer",
				"item_recipe_maelstrom",		--电锤

				"item_ogre_axe",
				"item_mithril_hammer",
				"item_recipe_black_king_bar",		--BKB

				"item_hyperstone",
				"item_recipe_mjollnir",			--大雷锤

				"item_hyperstone",
				"item_platemail",
				"item_chainmail",
				"item_recipe_assault",			--强袭
				
				"item_broadsword",
				"item_blades_of_attack",
				"item_recipe_lesser_crit" ,
				"item_demon_edge",
				"item_recipe_greater_crit",		--大炮

	

}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.ItemPurchase(ItemsToBuy)
end