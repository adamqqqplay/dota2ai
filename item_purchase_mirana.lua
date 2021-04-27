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
	"item_magic_wand",
	"item_phase_boots", --相位7.21
    "item_branches",
    "item_branches",
	"item_maelstrom",
	"item_manta",
	"item_black_king_bar",
	"item_butterfly",
	"item_hyperstone",
	"item_recipe_mjollnir" --大雷锤
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)
 --检查装备列表

function ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()
 --购买装备
end
