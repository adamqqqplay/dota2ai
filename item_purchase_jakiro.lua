----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_ring_of_basilius",
	"item_tango",
	"item_clarity",
	"item_magic_stick",
	"item_arcane_boots", --秘法鞋
	"item_force_staff", --推推7.14
	"item_rod_of_atos", --阿托斯7.20
	"item_cyclone", --风杖
	"item_ultimate_scepter_1", --蓝杖
	"item_dragon_lance",
	"item_recipe_hurricane_pike",
	"item_mekansm",
	"item_recipe_guardian_greaves"
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered) --检查装备列表

function ItemPurchaseThink()
	ItemPurchaseSystem.BuySupportItem() --购买辅助物品	对于辅助英雄保留这一行
	ItemPurchaseSystem.BuyCourier() --购买信使		对于5号位保留这一行
	ItemPurchaseSystem.ItemPurchase(Transfered) --购买装备
end
