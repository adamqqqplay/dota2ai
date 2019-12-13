----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
--  Contributor: zmcmcc Email:mengzhang@utexas.edu
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy = 
{ 
	"item_tango",
	"item_tango",
	"item_quelling_blade",			--补刀斧
	"item_flask",
	"item_wraith_band",

	"item_magic_wand",		--大魔棒7.14

	
	"item_wraith_band",
	
	"item_power_treads",			--假腿7.21

	
	"item_diffusal_blade",	--散失刀
	
	"item_manta",			
	
	"item_heart",					--龙心7.20

	"item_skadi",			--冰眼

	"item_butterfly",
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end