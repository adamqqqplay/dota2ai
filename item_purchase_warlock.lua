----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy = 
{ 
	"item_tango",
	"item_tango",
	"item_clarity",
	"item_flask",
	"item_ring_of_basilius",


	"item_arcane_boots",
	"item_magic_stick",

	"item_hand_of_midas",


	
	
	"item_glimmer_cape",			--微光
	"item_force_staff",
	"item_ultimate_scepter_1",		--蓝杖

	"item_refresher",
	"item_lotus_orb",			--清莲宝珠
	
	"item_sheepstick",				--羊刀
}


ItemPurchaseSystem.checkItemBuild(ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem.BuySupportItem()
	ItemPurchaseSystem.BuyCourier()

	ItemPurchaseSystem.ItemPurchase(ItemsToBuy)

end