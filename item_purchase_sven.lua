----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_flask",
	"item_magic_wand", --大魔棒7.14
	"item_bracer",
	"item_phase_boots",
	"item_hand_of_midas",
	"item_ultimate_scepter_1",
	"item_black_king_bar", --bkb
	"item_sange_and_yasha",
	"item_greater_crit", --大炮
	"item_assault" --强袭
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end
