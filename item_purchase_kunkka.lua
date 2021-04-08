----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_quelling_blade", --补刀斧
	"item_magic_wand", --大魔棒7.14
	"item_bracer",
	"item_phase_boots", --相位7.21
	"item_invis_sword", --隐刀
	"item_black_king_bar", --bkb
	"item_greater_crit", --大炮
	"item_ultimate_scepter",
    -- "item_scepter_shard",
	"item_ultimate_orb",
	"item_recipe_silver_edge", --大隐刀
	"item_assault"
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end
