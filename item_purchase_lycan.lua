----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy = 
{ 
	"item_tango",
	"item_flask",

	"item_quelling_blade",			--补刀斧

	"item_headdress",
	

	"item_power_treads",			--假腿7.21

	"item_broadsword",
	"item_crown",
	"item_recipe_helm_of_the_dominator",

	"item_vladmir",			--祭品7.21

	"item_necronomicon_3",		--死灵书
	
	"item_black_king_bar",	--bkb
	
	
	"item_assault",			--强袭
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end