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
	"item_boots",	
	"item_magic_stick",
	"item_recipe_magic_wand",		--大魔棒7.14
	"item_energy_booster",			--秘法
	"item_cloak",
	"item_shadow_amulet",			--微光

	"item_wind_lace",
	"item_staff_of_wizardry",
	"item_void_stone",
	"item_recipe_cyclone",			--风杖

	"item_point_booster",
	"item_staff_of_wizardry",
	"item_ogre_axe",
	"item_blade_of_alacrity",		--蓝杖

	"item_mystic_staff",
	"item_ultimate_orb",
	"item_void_stone",				--羊刀
	
	"item_ring_of_health",
	"item_void_stone",				
	"item_platemail",
	"item_energy_booster",			--清莲宝珠
}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.BuySupportItem()
	utility.BuyCourier()
	utility.ItemPurchase(ItemsToBuy)
end