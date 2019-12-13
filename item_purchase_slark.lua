----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy = 
{ 
	"item_tango",
	"item_flask",
	"item_quelling_blade",
	
	"item_orb_of_venom",

	"item_wraith_band",
	
	
	"item_wraith_band",

	"item_power_treads",			--假腿7.21
	"item_magic_wand",		--大魔棒7.14

	"item_ancient_janggo",
	
	"item_diffusal_blade",				--散失
	
	
	"item_sange_and_yasha",	
	
	"item_black_king_bar",	--bkb
	
	"item_abyssal_blade",			--大晕锤

	
	"item_butterfly",		
	
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end