----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")		--导入通用函数库

local ItemsToBuy = 
{ 
	"item_tango",
	"item_enchanted_mango",
	"item_enchanted_mango",
	"item_flask",
	"item_wind_lace",

	"item_null_talisman",
	"item_buckler",
	"item_null_talisman",
	
	"item_magic_wand",		--大魔棒7.14

	"item_boots",
	"item_ring_of_regen",			--绿鞋

	
	--"item_ancient_janggo",   --战鼓7.20
	"item_blink",					--跳刀

	"item_force_staff",		--推推7.14
	"item_black_king_bar",	--bkb
	
	"item_cyclone",			--风杖
	
	"item_ultimate_scepter_1",		--蓝杖

	"item_lotus_orb",

	"item_shivas_guard",
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)	--检查装备列表

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(Transfered)	--购买装备
end