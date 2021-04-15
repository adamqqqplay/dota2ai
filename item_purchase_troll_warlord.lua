----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
--  Contributor: zmcmcc Email:mengzhang@utexas.edu
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_tango",
	"item_quelling_blade",
	"item_wraith_band",
	"item_wraith_band",
	"item_magic_wand",
	"item_phase_boots", --相位7.21
    "item_broadsword",
    "item_ring_of_health",
    "item_claymore",
    "item_void_stone",
	"item_sange_and_yasha", --双刀
    "item_diffusal_blade", --散失刀
	"item_black_king_bar", --bkb
	"item_butterfly",
	"item_demon_edge",
	"item_quarterstaff",
	"item_javelin" --金箍棒7.14
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
