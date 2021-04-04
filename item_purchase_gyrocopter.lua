----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_tango",
	"item_magic_stick",
	"item_wraith_band", --系带
	"item_wraith_band", --系带
	"item_boots",
	"item_branch",
	"item_branch",
	"item_recipe_magic_wand",
	"item_blades_of_attack",
	"item_chainmail", --相位7.21
	"item_ancient_janggo", --战鼓7.20
	"item_monkey_king_bar", --金箍棒7.14
	"item_black_king_bar", --bkb
	"item_sange_and_yasha", --双刀
	-- "item_hurricane_pike", --大推推7.20
	"item_butterfly", --蝴蝶
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end
