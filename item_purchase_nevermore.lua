----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_wraith_band", --系带
	"item_bottle",
	"item_flask",
	"item_magic_wand", --大魔棒7.14
	"item_power_treads", --假腿7.21
	"item_desolator",
	"item_invis_sword", --隐刀
	"item_black_king_bar", --bkb
	"item_sange_and_yasha",
	"item_ultimate_orb",
	"item_recipe_silver_edge", --大隐刀
	"item_butterfly", --蝴蝶
	"item_satanic" --撒旦7.07
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
