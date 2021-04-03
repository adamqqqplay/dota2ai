----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_tango",
	"item_null_talisman",
	"item_magic_stick",
	"item_power_treads", --假腿7.21
	"item_hurricane_pike", --大推推7.20
	"item_rod_of_atos", --阿托斯7.20
	"item_orchid",
	"item_bloodthorn",
	"item_ultimate_scepter", --蓝杖
	"item_sheepstick" --羊刀
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	-- ItemPurchaseSystem.BuyCourier() --购买信使
	ItemPurchaseSystem.BuySupportItem()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end
