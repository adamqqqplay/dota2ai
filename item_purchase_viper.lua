----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_wraith_band", --系带
	"item_flask",
	"item_wraith_band", --系带
	"item_power_treads", --假腿7.21
	"item_maelstrom",
	"item_hurricane_pike", --大推推7.20
	"item_black_king_bar", --bkb
	"item_ultimate_scepter",
	"item_manta", --分身斧
	"item_heart", --龙心7.20
	"item_hyperstone",
	"item_recipe_mjollnir" --大雷锤
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
