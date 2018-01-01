----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local utility = require( GetScriptDirectory().."/utility" ) 

local ItemsToBuy = 
{ 
	"item_tango",
	"item_clarity",
	"item_branches",
	"item_branches",
	"item_bottle",
	"item_boots",
	"item_energy_booster",			--秘法鞋
	"item_magic_stick",
	"item_enchanted_mango",			--大魔棒7.07
	
	"item_ring_of_regen",
	"item_recipe_headdress",
	"item_branches",
	"item_chainmail",
	"item_recipe_buckler" ,
	"item_branches",
    "item_recipe_mekansm",			--梅肯
	
	"item_point_booster",
	"item_recipe_guardian_greaves",	--卫士胫甲
	
	"item_staff_of_wizardry",
	"item_ogre_axe",
	"item_blade_of_alacrity",		--蓝杖
	
	"item_cloak",
	"item_ring_of_health",
	"item_ring_of_regen",			--挑战
	"item_ring_of_regen",
	"item_recipe_headdress",
	"item_branches",
	"item_recipe_pipe",			--笛子
	
	"item_platemail",
	"item_mystic_staff",
	"item_recipe_shivas_guard" ,	--希瓦
	
	"item_mystic_staff",
	"item_ultimate_orb",
	"item_void_stone",				--羊刀
	
}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.ItemPurchase(ItemsToBuy)
end