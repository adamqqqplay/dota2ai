----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_magic_stick",
	"item_quelling_blade", --补刀斧
	"item_bracer",
	"item_phase_boots", --相位7.21
	"item_branch",
	"item_branch",
	"item_recipe_magic_wand",
	"item_blink",
	"item_black_king_bar", --bkb
	"item_ultimate_scepter",
	"item_assault", --强袭
	"item_heart"
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	-- ItemPurchaseSystem.BuyCourier()
	ItemPurchaseSystem.BuySupportItem()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end
