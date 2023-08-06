----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local X = {}
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_gauntlets",
	"item_circlet",
	"item_magic_wand", --大魔棒7.14
	"item_bracer",
	"item_phase_boots",
	"item_hand_of_midas",
	"item_black_king_bar", --bkb
	"item_greater_crit", --大炮
	"item_ultimate_scepter",
	"item_blink",
	"item_assault",
	"item_overwhelming_blink",
	"item_ultimate_scepter_2",
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)

function X.ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()
end

return X