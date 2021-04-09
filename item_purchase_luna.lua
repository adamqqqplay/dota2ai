----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_wraith_band",
	"item_wraith_band",
	"item_magic_wand", --大魔棒7.14
	"item_power_treads", --假腿7.21
	"item_mask_of_madness", --疯狂面具7.06
	"item_yasha", --单刀
	"item_ultimate_orb",
	"item_recipe_manta",
	"item_hurricane_pike", --大推推7.20
	"item_black_king_bar",
	"item_ultimate_scepter", --蓝杖
	"item_butterfly", --蝴蝶
	"item_satanic",
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end
