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
	"item_enchanted_mango",			--大魔棒7.07
	"item_energy_booster",			--秘法鞋
	"item_circlet",
	"item_ring_of_protection",
	"item_recipe_urn_of_shadows",	
	"item_infused_raindrop",		--骨灰盒7.06
	"item_gauntlets",
	"item_circlet",
	"item_recipe_bracer",
	"item_gauntlets",
	"item_circlet",
	"item_recipe_bracer",
	"item_staff_of_wizardry",
	"item_recipe_rod_of_atos",		--阿托斯7.06
	"item_staff_of_wizardry",
	"item_void_stone",
	"item_recipe_cyclone",
	"item_wind_lace",				--风杖
	"item_point_booster",
	"item_staff_of_wizardry",
	"item_ogre_axe",
	"item_blade_of_alacrity",		--蓝杖

	"item_platemail",
	"item_mystic_staff",
	"item_recipe_shivas_guard" ,	--希瓦
	"item_void_stone",
	"item_ultimate_orb",
	"item_mystic_staff",			--羊刀
}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.BuyCourier()
	utility.BuySupportItem()
	utility.ItemPurchase(ItemsToBuy)
end