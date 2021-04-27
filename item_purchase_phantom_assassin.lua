----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_quelling_blade", --补刀斧
	"item_wraith_band", --系带
	"item_tango",
	"item_phase_boots", --相位7.21
	"item_magic_wand", --大魔棒7.14
	"item_bfury",
	"item_desolator",
	"item_black_king_bar", --bkb
	"item_abyssal_blade", --大晕锤
	"item_satanic", --撒旦7.07
	"item_assault"
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
