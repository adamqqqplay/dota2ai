----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local X = {}
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem") --导入通用函数库

local ItemsToBuy =
{
	"item_tango",
	"item_clarity",
	"item_branches",
	"item_branches",
	"item_boots",
	"item_flask",
	"item_magic_wand", --大魔棒7.14
	"item_arcane_boots",
	"item_mekansm", --梅肯
	"item_ghost",
	"item_guardian_greaves", --卫士胫甲
	"item_ultimate_scepter",
	"item_force_staff",
	"item_ultimate_scepter_2",
	"item_lotus_orb",
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)

function X.ItemPurchaseThink()
	ItemPurchaseSystem.BuySupportItem() --购买信使		对于5号位保留这一行
	ItemPurchaseSystem:ItemPurchaseExtend()
end

return X