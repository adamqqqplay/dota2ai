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
	"item_wind_lace",
	"item_boots",
	"item_tranquil_boots",
	"item_glimmer_cape", --微光
    "item_ghost", --绿杖
	"item_force_staff", --推推7.14
	"item_sheepstick", --羊刀
	"item_refresher"
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)
 --检查装备列表

function ItemPurchaseThink()
	ItemPurchaseSystem.BuySupportItem() --购买辅助物品	对于辅助英雄保留这一行 --购买信使		对于5号位保留这一行
	ItemPurchaseSystem:ItemPurchaseExtend()
 --购买装备
end
