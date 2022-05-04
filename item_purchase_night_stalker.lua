----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_bracer",
	"item_flask",
	"item_phase_boots", --相位7.21
	"item_magic_wand",
	"item_blink",
	"item_black_king_bar", --bkb
	"item_ultimate_scepter",
	"item_assault", --强袭
	"item_ultimate_scepter_2",
	"item_heart",
	"item_overwhelming_blink",
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem.BuySupportItem()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
