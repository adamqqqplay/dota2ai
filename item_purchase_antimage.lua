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
	"item_quelling_blade", --补刀斧
	"item_wraith_band",
	"item_power_treads", --假腿7.21
	"item_orb_of_corrosion",
	"item_broadsword",
	"item_ring_of_health",
	"item_claymore",
	"item_void_stone",
	"item_manta", --分身
	"item_basher", --晕锤7.14
	"item_vanguard",
	"item_recipe_abyssal_blade", --大晕锤
	"item_black_king_bar",
	"item_butterfly", --蝴蝶
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end
