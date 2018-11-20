require( GetScriptDirectory().."/item_purchase_generic_gxc" )

npcBot = GetBot();

local tableItemsToBuy = { 
	"item_circlet",
	"item_mantle",
	"item_recipe_null_talisman",
	
	"item_gloves",
	"item_recipe_hand_of_midas",
	
	"item_boots",

	"item_wind_lace",
	"item_void_stone",
	"item_staff_of_wizardry",
	"item_recipe_cyclone",

	"item_belt_of_strength",
	"item_sobi_mask",
	"item_sobi_mask",
	"item_recipe_necronomicon",
	"item_recipe_necronomicon",
	"item_recipe_necronomicon",
	
	"item_recipe_travel_boots",

	"item_point_booster",
	"item_staff_of_wizardry",
	"item_ogre_axe",
	"item_blade_of_alacrity",

	"item_ogre_axe",
	"item_mithril_hammer",
	"item_recipe_black_king_bar",

	"item_void_stone",
	"item_ring_of_health",
	"item_ultimate_orb",
	"item_recipe_sphere" ,

	"item_blink",
	};


----------------------------------------------------------------------------------------------------

function ItemPurchaseThink()

	-- if we have travel boots, no need item_tpscroll
	purchase.NoNeedTpscrollForTravelBoots();

	-- buy item_tpscroll
	purchase.WeNeedTpscroll();

	--------------------------------------------------------------------------

	npcBot.tableItemsToBuy = tableItemsToBuy;
	purchase.ItemPurchase();

end

----------------------------------------------------------------------------------------------------
