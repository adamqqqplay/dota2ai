----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_wraith_band", --系带
	"item_tango",
	"item_flask",
	"item_wraith_band", --系带
	"item_phase_boots", --相位7.21
	"item_maelstrom",
	"item_hurricane_pike",
	"item_sange_and_yasha",
	"item_black_king_bar", --bkb
	"item_hyperstone",
	"item_recipe_mjollnir", --大雷锤
	"item_skadi"
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end
