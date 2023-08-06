----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local X = {}
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_flask",
	"item_enchanted_mango",
	"item_bracer",
	"item_phase_boots", --相位7.21
	"item_magic_wand",
	"item_blink", --跳刀
	"item_black_king_bar", --BKB
	"item_ultimate_scepter", --蓝杖
	"item_lotus_orb", --清莲宝珠
	"item_overwhelming_blink",
	"item_ultimate_scepter_2",
	"item_assault",
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)

function X.ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()
end

return X