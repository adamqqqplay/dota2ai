----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_clarity",
	"item_clarity",
	"item_buckler",
	"item_boots",
	"item_magic_stick",
	"item_energy_booster", 
	-- heroes buy a lot of energy boosters because energy booster and boots create an arcane boots so they need to buy more energy booster
	"item_aether_lens", --以太之镜7.06
	"item_force_staff", --推推7.14
	"item_cyclone", --风杖
	"item_ultimate_scepter", --蓝杖
	"item_lotus_orb"
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	ItemPurchaseSystem.BuySupportItem()
	ItemPurchaseSystem.BuyCourier()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end
