----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_tango",
	"item_enchanted_mango",
    "item_magic_stick",
	"item_bracer",
	"item_arcane_boots", --秘法鞋
	"item_medallion_of_courage", --勋章
	"item_mekansm", --梅肯
	"item_guardian_greaves", --卫士胫甲
	"item_force_staff",
	"item_solar_crest", --大勋章7.20
	"item_lotus_orb", --清莲宝珠
	"item_ultimate_scepter", --蓝杖
	"item_efresher" --刷新球
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem.BuySupportItem()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
