----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local utility = require( GetScriptDirectory().."/utility" ) 

local ItemsToBuy = 
{ 
	"item_tango",
	"item_flask",
	"item_stout_shield",
	"item_branches",
	"item_branches",
	"item_boots",
	"item_energy_booster",			--秘法
	
	"item_magic_stick",
	"item_recipe_magic_wand",		--大魔棒7.14
	
	"item_blink",					--跳刀
	
	"item_ring_of_regen",
	"item_staff_of_wizardry",
	"item_recipe_force_staff",		--推推7.14
				
	"item_point_booster",
	"item_ogre_axe",
	"item_staff_of_wizardry",
	"item_blade_of_alacrity",		--蓝杖
	
	"item_platemail",
	"item_mystic_staff",
	"item_recipe_shivas_guard",		--希瓦
	
	"item_ring_of_health",
	"item_void_stone",				
	"item_platemail",
	"item_energy_booster",			--清莲宝珠
}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.BuyCourier()
	utility.BuySupportItem()
	utility.ItemPurchase(ItemsToBuy)
end