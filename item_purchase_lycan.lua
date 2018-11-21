----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local utility = require( GetScriptDirectory().."/utility" ) 

local ItemsToBuy = 
{ 
	"item_tango",
	"item_flask",
	"item_stout_shield",
	"item_quelling_blade",			--补刀斧
	

	"item_boots",	
	"item_belt_of_strength",
	"item_blades_of_attack",		--假腿7.20

	
	"item_lifesteal",				--祭品
	"item_ring_of_regen",
	"item_branches",
	"item_recipe_headdress",				
	"item_ring_of_protection",
	"item_sobi_mask",

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
	
	"item_hyperstone",
	"item_platemail",
	"item_chainmail",
	"item_recipe_assault",			--强袭
}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.ItemPurchase(ItemsToBuy)
end