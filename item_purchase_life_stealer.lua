----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
require( GetScriptDirectory().."/utility" ) 

local ItemsToBuy = 
{ 
	"item_tango",
    "item_stout_shield",
	"item_blight_stone",
	
	"item_boots",
	"item_blades_of_attack",
	"item_blades_of_attack",
	
	"item_blade_of_alacrity",
	"item_boots_of_elves",
	"item_recipe_yasha",
	"item_ogre_axe",
	"item_belt_of_strength",
	"item_recipe_sange",
	
	"item_ogre_axe",
	"item_quarterstaff",
	"item_robe",
	"item_sobi_mask",
	
	"item_mithril_hammer",
	"item_mithril_hammer",
	
	"item_javelin",
	"item_belt_of_strength",
	"item_recipe_basher",
	
	"item_ring_of_health",
	"item_vitality_booster",
	"item_stout_shield",
	"item_recipe_abyssal_blade",
	
	"item_hyperstone",
	"item_platemail",
	"item_chainmail",
	"item_recipe_assault",
}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.ItemPurchase(ItemsToBuy)
end