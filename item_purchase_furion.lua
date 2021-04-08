----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
--  Contributor: zmcmcc Email:mengzhang@utexas.edu
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_flask",
	"item_orb_of_venom", -- 毒球
	"item_null_talisman",
	"item_null_talisman",
	"item_phase_boots", --相位7.21
	"item_invis_sword", --隐刀
	"item_desolator", --黯灭
	"item_orchid", --紫苑
	"item_black_king_bar",
	"item_hyperstone",
	"item_recipe_bloodthorn", --血棘
	"item_ultimate_scepter", --蓝杖
	"item_ultimate_orb",
	"item_recipe_silver_edge" --大隐刀
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end
