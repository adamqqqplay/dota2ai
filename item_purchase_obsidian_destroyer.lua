----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
--  Contributor: zmcmcc Email:mengzhang@utexas.edu
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_null_talisman", --无用挂件
	"item_power_treads", --假腿7.21
    "item_dragon_lance", --魔龙枪
    "item_witch_blade",
	"item_orchid",
    "item_black_king_bar", --bkb
    "item_sheepstick", --羊刀
    "item_hurricane_pike", --大推推7.20
	"item_sphere", --林肯
    "item_ultimate_scepter",
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
