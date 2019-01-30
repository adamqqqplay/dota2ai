----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

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
	"item_recipe_magic_wand",		--大魔棒7.14

	"item_boots",	
	"item_belt_of_strength",
	"item_gloves",			--假腿7.21

	"item_crown",
	"item_sobi_mask",
	"item_wind_lance",
	"item_recipe_ancient_janggo",   --战鼓7.20

	"item_javelin",
	"item_mithril_hammer",			--电锤7.14

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

ItemPurchaseSystem.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(ItemsToBuy)
end