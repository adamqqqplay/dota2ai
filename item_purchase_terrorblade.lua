----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
--  Contributor: zmcmcc Email:mengzhang@utexas.edu
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_quelling_blade",
	"item_tango",
	"item_tango",
	"item_wraith_band",
	"item_wraith_band",
	"item_power_treads",
	"item_magic_wand", --大魔棒7.14
	"item_manta",
	"item_skadi", --冰眼
	"item_black_king_bar", --bkb
	"item_butterfly", --蝴蝶
	"item_satanic" --撒旦7.07
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
