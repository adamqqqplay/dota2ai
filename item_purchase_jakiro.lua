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
	
	"item_mantle",
	"item_circlet",
	"item_recipe_null_talisman",	--无用挂件
	"item_mantle",
	"item_circlet",
	"item_recipe_null_talisman",	--无用挂件
	"item_helm_of_iron_will",
	"item_recipe_veil_of_discord",	--纷争
	
	"item_ring_of_health",
	"item_staff_of_wizardry",
	"item_recipe_force_staff",		--推推7.06

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
	
	"item_mystic_staff",
	"item_ultimate_orb",
	"item_void_stone",				--羊刀
}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.BuySupportItem()
	utility.BuyCourier()
	utility.ItemPurchase(ItemsToBuy)
end