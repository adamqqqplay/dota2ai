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
	"item_orb_of_venom",
	"item_boots",
	"item_magic_wand", --大魔棒7.14
	"item_phase_boots",
	"item_orb_of_corrosion",
	"item_vladmir", --祭品7.21
	"item_blink", --跳刀
	"item_basher", --晕锤7.14
	"item_black_king_bar", --bkb
	"item_ultimate_scepter",
	"item_abyssal_blade" --大晕锤
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
