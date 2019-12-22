----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_null_talisman",
	"item_enchanted_mango",
	"item_null_talisman",
	"item_bottle",
	"item_phase_boots",
	"item_magic_wand", --大魔棒7.14
	"item_cyclone", --风杖
	"item_invis_sword",
	"item_black_king_bar",
	"item_ultimate_scepter_1", --蓝杖
	"item_shivas_guard"
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end
