----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.3
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local utility = require( GetScriptDirectory().."/utility" ) 		--导入通用函数库

local ItemsToBuy = 
{ 
	"item_tango",
	"item_clarity",
	"item_wind_lace",
	"item_branches",
	"item_branches",
	"item_boots",	
	"item_ring_of_regen",			--绿鞋
	"item_magic_stick",
	"item_recipe_magic_wand",		--大魔棒7.14
	
	"item_circlet",
	"item_ring_of_protection",
	"item_recipe_urn_of_shadows",	
	"item_infused_raindrop",		--骨灰盒7.06
	
	"item_cloak",
	"item_shadow_amulet",			--微光
	
	"item_vitality_booster",
	"item_wind_lace",
	"item_recipe_spirit_vessel",	--大骨灰7.07
	
	"item_ring_of_regen",
	"item_staff_of_wizardry",
	"item_recipe_force_staff",		--推推7.14
	
	"item_point_booster",		
	"item_staff_of_wizardry",
	"item_ogre_axe",
	"item_blade_of_alacrity",		--蓝杖

	"item_mystic_staff",
	"item_ultimate_orb",
	"item_void_stone",				--羊刀
}

utility.checkItemBuild(ItemsToBuy)		--检查装备列表

function ItemPurchaseThink()
	utility.BuySupportItem()			--购买辅助物品	对于辅助英雄保留这一行
	utility.BuyCourier()				--购买信使		对于5号位保留这一行
	utility.ItemPurchase(ItemsToBuy)	--购买装备
end