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
	"item_branches",
	"item_branches",
	"item_boots",
	"item_belt_of_strength",
	"item_gloves",					--假腿
	"item_magic_stick",
	"item_enchanted_mango",			--大魔棒7.07
	
	"item_ring_of_regen",
	"item_recipe_headdress",
	"item_branches",				
	"item_ring_of_protection",
	"item_sobi_mask",
	"item_lifesteal",				--祭品

	"item_sobi_mask",
	"item_sobi_mask",
	"item_belt_of_strength",
	"item_recipe_necronomicon",
	"item_recipe_necronomicon", 
	"item_recipe_necronomicon",		--死灵书
	
	"item_ogre_axe", 
	"item_mithril_hammer",
	"item_recipe_black_king_bar",	--bkb
	
	"item_belt_of_strength", 
	"item_ogre_axe",
	"item_recipe_sange",
	"item_talisman_of_evasion",		--天堂
	
	"item_hyperstone",
	"item_platemail",
	"item_chainmail",
	"item_recipe_assault",			--强袭
}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.ItemPurchase(ItemsToBuy)
end