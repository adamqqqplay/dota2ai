----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_magic_wand", --大魔棒7.14
	"item_bracer",
	"item_phase_boots",
	"item_hand_of_midas",
	"item_black_king_bar", --bkb
	"item_greater_crit", --大炮
	"item_ultimate_scepter",
	"item_blink",
	"item_sange_and_yasha",
	"item_assault" --强袭
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
