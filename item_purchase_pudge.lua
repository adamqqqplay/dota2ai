----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy = 
{ 
	"item_tango",
	"item_flask",
	"item_wind_lace",
	"item_branches",
	"item_branches",
	"item_magic_stick",
	"item_ring_of_regen",			--绿鞋
	"item_boots",

	"item_recipe_magic_wand",		--大魔棒7.14

	"item_circlet",
	"item_ring_of_protection",
	"item_recipe_urn_of_shadows",	
	"item_sobi_mask",		--骨灰盒7.23

	"item_crown",
	"item_crown",
	"item_staff_of_wizardry",
	"item_recipe_rod_of_atos",		--阿托斯7.20

	"item_vitality_booster",
	"item_wind_lace",
	"item_recipe_spirit_vessel",	--大骨灰7.07

	"item_cloak",
	"item_ring_of_health",
	"item_ring_of_regen",			--挑战
	"item_ring_of_regen",
	"item_recipe_headdress",
	"item_branches",
	"item_recipe_pipe" ,			--笛子

	"item_ring_of_health",
	"item_void_stone",				
	"item_platemail",
	"item_energy_booster",			--清莲宝珠

	"item_reaver",
	"item_vitality_booster",		
	"item_ring_of_tarrasque",
	"item_recipe_heart",					--龙心7.23
}

ItemPurchaseSystem.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	ItemPurchaseSystem.BuyCourier()
	ItemPurchaseSystem.BuySupportItem()
	ItemPurchaseSystem.ItemPurchase(ItemsToBuy)
end