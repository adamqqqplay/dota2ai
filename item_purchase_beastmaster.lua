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
	"item_gloves",
	"item_chainmail",			--相位7.20
	"item_magic_stick",
	"item_recipe_magic_wand",		--大魔棒7.14
	
	"item_chainmail",
	"item_sobi_mask",
	"item_blight_stone",			--勋章
	"item_ultimate_orb",
	"item_wind_lace",
	"item_recipe_solar_crest",		--大勋章7.20
	
	"item_sobi_mask",
	"item_sobi_mask",
	"item_belt_of_strength",
	"item_recipe_necronomicon",
	"item_recipe_necronomicon", 
	"item_recipe_necronomicon",		--死灵书
	
	"item_ring_of_regen",
	"item_recipe_headdress",
	"item_branches",				
	"item_ring_of_protection",
	"item_sobi_mask",
	"item_lifesteal",				--祭品
	
	"item_platemail",
	"item_ring_of_health",
	"item_void_stone",
	"item_energy_booster",			--清莲宝珠
	
	"item_crown",
	"item_vitality_booster",		
	"item_ring_of_tarrasque",
	"item_recipe_heart",					--龙心7.20
}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.ItemPurchase(ItemsToBuy)
end