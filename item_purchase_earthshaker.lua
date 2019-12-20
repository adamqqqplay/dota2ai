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
	"item_clarity",
	
	"item_arcane_boots",			--秘法
	
	
	"item_=magic_wand",		--大魔棒7.14
	
	"item_blink",					--跳刀
	

	"item_force_staff",		--推推7.14
	
	"item_cyclone",			--风杖
	
	"item_ultimate_scepter_1",		--蓝杖
	
	"item_black_king_bar",		
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)	--检查装备列表

function ItemPurchaseThink()
	ItemPurchaseSystem.BuySupportItem()			--购买辅助物品	对于辅助英雄保留这一行
	ItemPurchaseSystem.BuyCourier()				--购买信使		对于5号位保留这一行
	ItemPurchaseSystem.ItemPurchase(Transfered)	--购买装备
end