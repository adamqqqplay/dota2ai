----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_quelling_blade", --补刀斧
	"item_orb_of_venom",
	"item_wraith_band", --系带
	"item_phase_boots",
	"item_magic_wand", --大魔棒7.14
	"item_maelstrom",
	"item_echo_sabre", --连击刀
	"item_black_king_bar", --bkb
	"item_skadi", --冰眼
	"item_butterfly",
	"item_hyperstone",
	"item_recipe_mjollnir" --大雷锤
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
