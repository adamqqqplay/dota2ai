----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
--  Contributor: zmcmcc Email:mengzhang@utexas.edu
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy = 
{ 
	"item_tango",
	
	"item_magic_stick",
	
	

	"item_tranquil_boots",

	"item_urn_of_shadows",

	"item_solar_crest",		--大勋章7.20

	"item_ultimate_scepter_1",

	"item_guardian_greaves",

	"item_pipe",

	"item_lotus_orb",			--清莲宝珠

	"item_diffusal_blade",	--散失刀
	

}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	ItemPurchaseSystem.BuyCourier()
	ItemPurchaseSystem.BuySupportItem()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end