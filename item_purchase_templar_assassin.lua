----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
--  Contributor: zmcmcc Email:mengzhang@utexas.edu
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_wraith_band", --系带
	"item_flask",
	"item_power_treads", --假腿7.21
	"item_magic_wand",
	"item_desolator", --黯灭
	"item_black_king_bar", --bkb
    "item_blink",
	"item_butterfly", --蝴蝶
	"item_bloodthorn",
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
