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
	"item_bottle",
	"item_phase_boots",
	"item_magic_wand", --大魔棒7.14
    "item_witch_blade",
	"item_cyclone", --风杖
	"item_ultimate_scepter", --蓝杖
    "item_black_king_bar",
	"item_shivas_guard",
    "item_sheepstick",
    "item_mystic_staff",
    "item_recipe_wind_waker",
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end
