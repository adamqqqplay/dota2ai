----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_bracer",
	"item_enchanted_mango",
	"item_enchanted_mango",
	"item_magic_wand", --大魔棒7.14
    "item_soul_ring",
	"item_arcane_boots", --秘法鞋
	"item_mekansm", --梅肯
    "item_guardian_greaves",
	"item_ultimate_scepter", --蓝杖
    "item_force_staff",
	"item_lotus_orb", --清莲宝珠
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem.BuySupportItem()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
