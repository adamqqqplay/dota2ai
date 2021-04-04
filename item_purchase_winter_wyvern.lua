----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_tango",
	"item_clarity",
	"item_magic_stick",
	"item_buckler",
	"item_wind_lace",
	"item_boots",
	"item_magic_stick",
	"item_ring_of_regen", --绿鞋
	"item_soul_ring",
	"item_urn_of_shadows",
	"item_glimmer_cape", --微光
	"item_force_staff",
	"item_ultimate_scepter", --蓝杖
	"item_lotus_orb", --清莲宝珠
	"item_sheepstick" --羊刀
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	ItemPurchaseSystem.BuySupportItem()
	-- ItemPurchaseSystem.BuyCourier()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end
