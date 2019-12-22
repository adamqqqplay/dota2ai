----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_wraith_band", --系带
	"item_flask",
	"item_wraith_band", --系带
	"item_magic_wand", --大魔棒7.14
	"item_phase_boots", --相位7.21
	"item_magic_wand", --大魔棒7.14
	"item_maelstrom",
	"item_hurricane_pike", --大推推7.20
	"item_manta",
	"item_black_king_bar",
	"item_butterfly",
	"item_hyperstone",
	"item_recipe_mjollnir" --大雷锤
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered) --检查装备列表

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(Transfered) --购买装备
end
