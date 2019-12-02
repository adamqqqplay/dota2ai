----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy = 
{ 
	"item_tango",
	"item_flask",
	"item_recipe_magic_wand",		--大魔棒7.14
	"item_branches",
	"item_branches",
	"item_magic_stick",

	"item_boots",
	"item_energy_booster",			--秘法
			
	"item_ring_of_regen",
	"item_branches",
	"item_recipe_headdress",
	"item_chainmail",
	"item_branches",
	"item_recipe_buckler" ,
    "item_recipe_mekansm",			--梅肯
	
	"item_blink",					--跳刀
	
	"item_recipe_guardian_greaves",	--卫士胫甲
	
	"item_point_booster",		
	"item_staff_of_wizardry",
	"item_ogre_axe",
	"item_blade_of_alacrity",		--蓝杖
	
	"item_platemail",
	"item_mystic_staff",
	"item_recipe_shivas_guard" ,	--希瓦
	
	"item_ring_of_health",
	"item_void_stone",		
	"item_ring_of_health",
	"item_void_stone",		
	"item_recipe_refresher", 		--刷新球
	
	"item_ring_of_health",
	"item_void_stone",				
	"item_platemail",
	"item_energy_booster",			--清莲宝珠
	
}

ItemPurchaseSystem.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(ItemsToBuy)
end