----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local utility = require( GetScriptDirectory().."/utility" ) 

local ItemsToBuy = 
{ 
	"item_tango",
	"item_branches",
	"item_branches",
	"item_clarity",
	"item_enchanted_mango",	
	"item_magic_stick",		--大魔棒7.07

	"item_boots",	
	"item_energy_booster",			--秘法鞋
	
	"item_chainmail",
	"item_sobi_mask",
	"item_blight_stone",			--勋章

	"item_ring_of_regen",
	"item_recipe_headdress",
	"item_branches",
	"item_chainmail",
	"item_recipe_buckler" ,
	"item_branches",
    "item_recipe_mekansm",			--梅肯

	"item_recipe_guardian_greaves",	--卫士胫甲
	"item_talisman_of_evasion",		--大勋章

	"item_ring_of_health",
	"item_void_stone",				
	"item_platemail",
	"item_energy_booster",			--清莲宝珠
	
	"item_point_booster",
	"item_staff_of_wizardry",
	"item_ogre_axe",
	"item_blade_of_alacrity",		--蓝杖

	"item_ring_of_health",
	"item_void_stone",		
	"item_ring_of_health",
	"item_void_stone",		
	"item_recipe_refresher", 		--刷新球
	

}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.BuyCourier()
	utility.BuySupportItem()
	utility.ItemPurchase(ItemsToBuy)
end