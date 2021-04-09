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
	"item_ring_of_basilius",
	"item_arcane_boots",
	"item_blink",
	"item_glimmer_cape", --微光
    "item_ghost",
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
