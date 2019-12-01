----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy = 
{ 
	"item_tango",
	"item_clarity",
	"item_branches",
	"item_branches",
	"item_boots",	
	"item_magic_stick",
	"item_recipe_magic_wand",		--大魔棒7.14
	"item_energy_booster",			--秘法鞋
		
	

	"item_blink",					--跳刀

	"item_ring_of_regen",
	"item_recipe_headdress",
	"item_branches",
	
	"item_chainmail",
    "item_recipe_mekansm",			--梅肯7.23
	
	"item_recipe_guardian_greaves",	--卫士胫甲


	
	"item_ogre_axe", 
	"item_mithril_hammer",
	"item_recipe_black_king_bar",	--bkb

	"item_vitality_booster",
	"item_energy_booster",
	"item_recipe_aeon_disk",		-- 永恒之盘
	
	"item_point_booster",		
	"item_staff_of_wizardry",
	"item_ogre_axe",
	"item_blade_of_alacrity",		--蓝杖
	
	"item_point_booster",
	"item_vitality_booster",
	"item_energy_booster",
	"item_mystic_staff",			--玲珑心
	
	"item_ring_of_health",
	"item_void_stone",		
	"item_ring_of_health",
	"item_void_stone",		
	"item_recipe_refresher", 		--刷新球
}

ItemPurchaseSystem.checkItemBuild(ItemsToBuy)		--检查装备列表

function ItemPurchaseThink()
	ItemPurchaseSystem.BuySupportItem()			--购买辅助物品	对于辅助英雄保留这一行
	ItemPurchaseSystem.ItemPurchase(ItemsToBuy)	--购买装备
end