----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_clarity",
	"item_branches",
	"item_boots",
	"item_magic_wand", --大魔棒7.14
	"item_ring_of_basilius",
	"item_null_talisman",
	"item_energy_booster",
	"item_glimmer_cape", --微光
	"item_cyclone", --风杖
	"item_ultimate_scepter", --蓝杖
	"item_sheepstick", --羊刀
	"item_lotus_orb" --清莲宝珠
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	ItemPurchaseSystem.BuySupportItem()
	ItemPurchaseSystem.BuyCourier()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end
