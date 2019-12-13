----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy = 
{ 
	
	
	
	"item_tango",
	"item_tango",
	"item_flask",
	"item_null_talisman",	--无用挂件
	
	"item_null_talisman",	--无用挂件
	"item_boots",
	
	"item_magic_wand",		--大魔棒7.14
	
	
	
	"item_blades_of_attack",
	"item_chainmail",			--相位7.21
	
	
	"item_cyclone",			--风杖

	"item_black_king_bar",	--bkb
	
	"item_ultimate_scepter_1",

	
	
	
	"item_octarine_core",			--玲珑心
	
	
	"item_shivas_guard" ,	--希瓦
	
	
	"item_heart",					--龙心7.20
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end