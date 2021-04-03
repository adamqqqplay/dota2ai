----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_flask",
	"item_quelling_blade", --补刀斧
	"item_bracer",
	"item_phase_boots", --相位7.21
	"item_magic_wand", --大魔棒7.14
	"item_ultimate_scepter",
	"item_blink",
	"item_black_king_bar", --bkb
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
