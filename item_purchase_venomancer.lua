----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy = 
{
	"item_wraith_band", --系带
	"item_tango",
	"item_tango",
	"item_flask",
	"item_wraith_band", --系带
	

	"item_boots",
	"item_magic_stick",

	"item_energy_booster",			--秘法鞋

	"item_veil_of_discord",	--纷争7.20

	
	"item_hurricane_pike",					--大推推7.20

	"item_mekansm",			--梅肯
	"item_recipe_guardian_greaves",	--卫士胫甲

	"item_ultimate_scepter_1",		--蓝杖

	"item_black_king_bar",

	"item_lotus_orb",			--清莲宝珠

	
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	ItemPurchaseSystem.BuyCourier()
	ItemPurchaseSystem.BuySupportItem()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end