----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_null_talisman",
	"item_tango",
	"item_enchanted_mango",
	"item_enchanted_mango",
	"item_null_talisman",
	"item_null_talisman",
	"item_aether_lens",
	"item_rod_of_atos", --阿托斯7.20
	"item_force_staff",
	"item_ultimate_scepter", --蓝杖
	"item_yasha_and_kaya",
	"item_sheepsrick" --羊刀
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	ItemPurchaseSystem.BuyCourier()
	ItemPurchaseSystem.BuySupportItem()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end
