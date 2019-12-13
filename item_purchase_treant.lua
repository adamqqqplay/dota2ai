----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy = 
{ 
	"item_tango",
	"item_tango",
	"item_magic_wand",			--大魔棒7.14

	"item_buckler",

	"item_arcane_boots",			--秘法鞋
	
	"item_medallion_of_courage",			--勋章


	"item_mekansm",			--梅肯

	"item_recipe_guardian_greaves",	--卫士胫甲
	"item_ultimate_orb",
	"item_wind_lace",
	"item_recipe_solar_crest",		--大勋章7.20

	
	
	"item_ultimate_scepter_1",		--蓝杖

	"item_force_staff",

	"item_lotus_orb",			--清莲宝珠

	"item_refresher", 		--刷新球
	

}

ItemPurchaseSystem.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	ItemPurchaseSystem.BuyCourier()
	ItemPurchaseSystem.BuySupportItem()
	ItemPurchaseSystem.ItemPurchase(ItemsToBuy)
end