----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_buckler",
	"item_tango",
	"item_enchanted_mango",
	"item_magic_stick",
	"item_bracer",
	"item_arcane_boots", --秘法鞋
	"item_medallion_of_courage", --勋章
	"item_mekansm", --梅肯
	"item_recipe_guardian_greaves", --卫士胫甲
	"item_vladmir",
	"item_force_staff",
	"item_ultimate_orb",
	"item_wind_lace",
	"item_recipe_solar_crest", --大勋章7.20
	"item_lotus_orb", --清莲宝珠
	"item_ultimate_scepter", --蓝杖
	"item_ring_of_health",
	"item_void_stone",
	"item_ring_of_health",
	"item_void_stone",
	"item_recipe_refresher" --刷新球
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	-- ItemPurchaseSystem.BuyCourier()
	ItemPurchaseSystem.BuySupportItem()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end
