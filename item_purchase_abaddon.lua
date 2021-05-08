----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_tango",
	"item_quelling_blade",
	"item_enchanted_mango",
	"item_magic_wand",
	"item_boots",
	"item_bracer",
	"item_energy_booster",
	"item_mekansm", --梅肯
	"item_vladmir", --祭品7.21
	"item_guardian_greaves", --卫士胫甲
	"item_pipe", --笛子
	"item_ultimate_scepter", --蓝杖
	"item_lotus_orb" --清莲宝珠
}
ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem.BuySupportItem()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
