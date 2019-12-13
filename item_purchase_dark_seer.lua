----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy = 
{ 
	"item_tango",
	"item_flask",
	"item_enchanted_mango",
	"item_enchanted_mango",

	
	"item_soul_ring",  		--魂戒

	"item_boots",

	
	"item_magic_wand",		--大魔棒7.14

	"item_energy_booster",			--秘法鞋	

	
	"item_pipe" ,			--笛子
	
	
    "item_mekansm",			--梅肯
	"item_recipe_guardian_greaves",	--卫士胫甲
	
	"item_blink",					--跳刀
	
	
	"item_lotus_orb",			--清莲宝珠
	
	"item_shivas_guard",	--希瓦
	

	"item_heart",					--龙心7.20
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end