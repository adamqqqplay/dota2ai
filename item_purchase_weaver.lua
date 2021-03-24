----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
--  Contributor: zmcmcc Email:mengzhang@utexas.edu
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_wraith_band", --系带
	"item_tango",
	"item_tango",
	"item_flask",
	"item_wraith_band", --系带
	"item_magic_wand", --大魔棒7.14
	"item_power_treads", --假腿7.21
	"item_desolator",
	"item_greater_crit",
	"item_black_king_bar", --bkb
	"item_butterfly",
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end
