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
	"item_wind_lace",
	"item_boots",
    "item_magic_stick",
	"item_ring_of_regen", --绿鞋
	"item_blink",
    "item_ghost",
    "item_aether_lens",
	"item_glimmer_cape", --微光
	"item_force_staff",
	"item_ultimate_scepter", --蓝杖
	"item_lotus_orb", --清莲宝珠
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem.BuySupportItem()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
