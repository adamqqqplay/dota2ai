----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_clarity",
	"item_branches",
	"item_branches",
	"item_boots",
    "item_magic_wand", --大魔棒7.14
	"item_arcane_boots",
	"item_glimmer_cape",
	"item_force_staff",
    "item_ghost",
    "item_ultimate_scepter",
    "item_refresher",
    "item_sheepstick",
}

ItemPurchaseSystem.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	ItemPurchaseSystem.BuySupportItem()
	ItemPurchaseSystem.ItemPurchase(ItemsToBuy)
end
