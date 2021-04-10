----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_tango",
	"item_quelling_blade",
	"item_wraith_band",
	"item_bottle",
	"item_phase_boots",
	"item_broadsword",
	"item_ring_of_health",
	"item_claymore",
	"item_void_stone",
	"item_magic_wand", --大魔棒7.14
	"item_black_king_bar",
	"item_greater_crit",
	"item_maelstrom", --电锤7.14
	"item_octarine_core", --玲珑心
	"item_hyperstone",
	"item_recipe_mjollnir", --大雷锤
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end
