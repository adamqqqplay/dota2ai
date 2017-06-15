----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
require( GetScriptDirectory().."/utility" ) 

local ItemsToBuy = 
{ 
                "item_tango",
				"item_stout_shield",
				"item_branches",
				"item_branches",
				"item_magic_stick",
				"item_circlet",
				"item_gauntlets",
				"item_circlet",
				"item_recipe_bracer",
				
				"item_boots",
				"item_gloves",
				"item_belt_of_strength",
				
				"item_wind_lace",
				"item_sobi_mask",
				"item_recipe_ancient_janggo",
				
				"item_blade_of_alacrity",
				"item_boots_of_elves",
				"item_recipe_yasha",
				"item_ogre_axe",
				"item_belt_of_strength",
				"item_recipe_sange",
				
				"item_ogre_axe",
				"item_mithril_hammer",
				"item_recipe_black_king_bar",
				
				"item_hyperstone",
				"item_platemail",
				"item_chainmail",
				"item_recipe_assault",
				
				"item_lifesteal",
				"item_mithril_hammer",
				"item_reaver",
}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.ItemPurchase(ItemsToBuy)
end