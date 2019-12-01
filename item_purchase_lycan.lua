----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy = 
{ 
	"item_tango",
	"item_flask",
	"item_stout_shield",
	"item_quelling_blade",			--补刀斧
	

	"item_boots",	
	"item_belt_of_strength",
	"item_gloves",			--假腿7.21

	"item_ring_of_protection",
	"item_branches",
	"item_recipe_buckler",
	"item_sobi_mask",
	"item_branches",
	"item_recipe_ring_of_basilius",
	"item_recipe_vladmir",
	"item_lifesteal",	             --祭品7.23

	"item_sobi_mask",
	"item_sobi_mask",
	"item_belt_of_strength",
	"item_recipe_necronomicon",
	"item_recipe_necronomicon", 
	"item_recipe_necronomicon",		--死灵书
	
	"item_ogre_axe", 
	"item_mithril_hammer",
	"item_recipe_black_king_bar",	--bkb
	
	"item_blight_stone",
	"item_mithril_hammer",
	"item_mithril_hammer",			--黯灭
	
	"item_ring_of_protection",
	"item_branches",
	"item_recipe_buckler",
	"item_platemail",
	"item_hyperstone",
	"item_recipe_assault",			--强袭7.23
}

ItemPurchaseSystem.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(ItemsToBuy)
end