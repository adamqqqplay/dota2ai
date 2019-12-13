----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy = 
{ 
	"item_tango",
	"item_tango",
	"item_quelling_blade",			--补刀斧
	"item_flask",
	"item_wraith_band", --系带
	"item_wraith_band", --系带

	"item_magic_stick",

	"item_phase_boots",

	"item_vanguard",		--先锋

	
	"item_diffusal_blade",	--散失刀
	
	"item_manta",			--分身
	
	"item_basher",			--晕锤7.14
	
	"item_recipe_abyssal_blade",	--大晕锤
	
	"item_heart",					--龙心7.20

	"item_butterfly",
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end