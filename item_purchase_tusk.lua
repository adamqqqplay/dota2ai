----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
--  Contributor: zmcmcc Email:mengzhang@utexas.edu
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_buckler",
	"item_tango",
	"item_enchanted_mango",
	"item_enchanted_mango",
	"item_bracer",
	"item_phase_boots",
	"item_magic_stick",
	"item_urn_of_shadows",
	"item_invis_sword", --隐刀
	"item_solar_crest",
	"item_vitality_booster",
	"item_recipe_spirit_vessel", --大骨灰
	"item_black_king_bar", --bkb
	"item_ultimate_scepter_1", --蓝杖
	"item_ultimate_orb",
	"item_recipe_silver_edge" --大隐刀
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	ItemPurchaseSystem.BuyCourier()
	ItemPurchaseSystem.ItemPurchase(Transfered)
	ItemPurchaseSystem.BuySupportItem()
end
