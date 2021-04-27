----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_quelling_blade", --补刀斧
	"item_boots",
	"item_magic_wand", --大魔棒7.14
    "item_power_treads",
	"item_soul_ring",
	"item_solar_crest", --大勋章7.20
	"item_orchid", --紫苑
	"item_black_king_bar", --bkb
	"item_hyperstone",
	"item_recipe_bloodthorn", --血棘
	"item_assault", --强袭
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
