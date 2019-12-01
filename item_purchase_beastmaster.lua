----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy = 
{ 
	"item_tango",
	"item_flask",
	"item_enchanted_mango",
	"item_enchanted_mango",
	"item_stout_shield",
	"item_gauntlets",
	"item_circlet",
	"item_recipe_bracer",
	
	"item_boots",
	"item_blades_of_attack",
	"item_chainmail",				--相位7.21
	"item_magic_stick",
	"item_branches",
	"item_branches",
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
	
	"item_ring_of_protection",
	"item_branches",
	"item_recipe_buckler",
	"item_sobi_mask",
	"item_branches",
	"item_recipe_ring_of_basilius",
	"item_recipe_vladmir",
	"item_lifesteal",	             --祭品7.23
	
	"item_platemail",
	"item_ring_of_health",
	"item_void_stone",
	"item_energy_booster",			--清莲宝珠
	
	"item_reaver",
	"item_vitality_booster",		
	"item_ring_of_tarrasque",
	"item_recipe_heart",					--龙心7.23
}

ItemPurchaseSystem.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(ItemsToBuy)
end