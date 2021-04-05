----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_null_talisman",
	"item_tango",
	"item_hand_of_midas",
	"item_boots",
	"item_cyclone",
	"item_black_king_bar",
	"item_ultimate_scepter",
	"item_recipe_travel_boots",
	"item_black_king_bar",
	"item_sphere",
	"item_sheepstick"
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end
