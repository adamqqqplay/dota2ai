----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_null_talisman",
	"item_tango",
	"item_magic_wand",
	"item_boots",
	"item_javelin",
	"item_phase_boots",
	"item_maelstrom",
	"item_blink",
	"item_black_king_bar",
	"item_monkey_king_bar",
	"item_ultimate_scepter",
	"item_sphere", --林肯
	"item_mjollnir" --大雷锤
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
