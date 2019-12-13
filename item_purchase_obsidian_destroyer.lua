----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
--  Contributor: zmcmcc Email:mengzhang@utexas.edu
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy = 
{ 
	"item_tango",
	"item_null_talisman",	--无用挂件
	"item_null_talisman",
	"item_boots",
	

	"item_power_treads",			--假腿7.21
	"item_force_staff",		--推推7.14

	"item_yasha_and_kaya",
	
	"item_dragon_lance",				--魔龙枪
	"item_recipe_hurricane_pike",				--大推推7.20
	
	"item_black_king_bar",	--bkb

	"item_sphere",			--林肯

	"item_sheepstick",			--羊刀
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end