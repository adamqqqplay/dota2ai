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
	"item_enchanted_mango",			--大魔棒7.07
	"item_magic_stick",
	
	"item_boots",
	"item_belt_of_strength",
	"item_gloves",					--假腿

	"item_ring_of_health",
	"item_staff_of_wizardry",
	"item_recipe_force_staff",		--推推7.06
	
	"item_boots_of_elves",
	"item_boots_of_elves", 
	"item_ogre_axe",				--魔龙枪
	"item_slippers",
	"item_circlet",
	"item_recipe_wraith_band",		--大推推7.07
	
	"item_gauntlets",
	"item_circlet",
	"item_recipe_bracer",
	"item_gauntlets",
	"item_circlet",
	"item_recipe_bracer",
	"item_staff_of_wizardry",
	"item_recipe_rod_of_atos",		--阿托斯7.06
	
	"item_wind_lace",
	"item_staff_of_wizardry",
	"item_void_stone",
	"item_recipe_cyclone",				--风杖
	"item_point_booster",
	"item_staff_of_wizardry",
	"item_ogre_axe",
	"item_blade_of_alacrity",		--蓝杖
	"item_void_stone",
	"item_ultimate_orb",
	"item_mystic_staff",			--羊刀
}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.BuyCourier()				--购买信使
	utility.BuySupportItem()
	utility.ItemPurchase(ItemsToBuy)
end