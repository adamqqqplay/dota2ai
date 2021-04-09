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
    "item_magic_wand",
	"item_boots",
	"item_energy_booster",
    "item_witch_blade",
    "item_kaya",
	"item_aether_lens",
	"item_rod_of_atos", --阿托斯7.20
	"item_force_staff",
	"item_ultimate_scepter", --蓝杖
	"item_sheepstick", --羊刀
    "item_yasha",
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	-- ItemPurchaseSystem.BuyCourier()
	ItemPurchaseSystem.BuySupportItem()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end
