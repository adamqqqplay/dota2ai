----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_tango",
	"item_flask",
	"item_null_talisman", --无用挂件
	"item_boots",
	"item_magic_wand",
    "item_phase_boots",
	"item_cyclone", --风杖
	"item_ultimate_scepter",
	"item_shivas_guard", --希瓦
	"item_black_king_bar", --bkb
	"item_octarine_core", --玲珑心
	"item_heart" --龙心7.20
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
