----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy = 
{ 
	"item_orb_of_venom", -- 毒球
	"item_tango",
	"item_branches",
	"item_branches",
	"item_stout_shield",
	
	"item_magic_stick",
	"item_recipe_magic_wand",		--大魔棒7.14

	"item_boots",
	"item_blades_of_attack",
	"item_chainmail",				--秘法鞋
	
	"item_circlet",
	"item_ring_of_protection",
	"item_recipe_urn_of_shadows",	
	"item_sobi_mask",		--骨灰盒7.23
	
	"item_vitality_booster",
	"item_wind_lace",
	"item_recipe_spirit_vessel",	--大骨灰7.07
	
	"item_ring_of_regen",
	"item_recipe_headdress",
	"item_branches",
	
	"item_chainmail",
    "item_recipe_mekansm",			--梅肯7.23
	
	"item_recipe_guardian_greaves",	--卫士胫甲
	
	"item_ring_of_regen",
	"item_staff_of_wizardry",
	"item_recipe_force_staff",		--推推7.14
	
	"item_ring_of_health",
	"item_void_stone",				
	"item_platemail",
	"item_energy_booster",			--清莲宝珠
	
	"item_chainmail",
	"item_sobi_mask",
	"item_blight_stone",			--勋章
	"item_ultimate_orb",
	"item_wind_lance",
	"item_recipe_solar_crest",		--大勋章7.20
}

ItemPurchaseSystem.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	ItemPurchaseSystem.BuyCourier()
	ItemPurchaseSystem.BuySupportItem()
	ItemPurchaseSystem.ItemPurchase(ItemsToBuy)
end