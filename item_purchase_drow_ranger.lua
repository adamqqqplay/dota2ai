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
	"item_power_treads",
	"item_wraith_band", --系带
	"item_dragon_lance", --魔龙枪
	"item_yasha", --夜叉
	"item_hurricane_pike", --大推推7.20
	"item_ultimate_orb",
	"item_recipe_manta", --分身
	"item_greater_crit", --大炮
	"item_ultimate_scepter", --蓝杖
	"item_monkey_king_bar" --金箍棒7.14
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end
