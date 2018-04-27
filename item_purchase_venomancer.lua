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
	"item_ring_of_protection",

	"item_boots",
	"item_magic_stick",
	"item_recipe_magic_wand",		--大魔棒7.14
	"item_energy_booster",			--秘法鞋

	"item_sobi_mask",				--天鹰

	"item_slippers",
	"item_circlet",
	"item_recipe_wraith_band", --系带

	"item_circlet",
	"item_mantle",
	"item_recipe_null_talisman",	--无用挂件
	"item_mantle",
	"item_circlet",
	"item_recipe_null_talisman",	--无用挂件
	"item_helm_of_iron_will",
	"item_recipe_veil_of_discord",	--纷争

	
	"item_ring_of_regen",
	"item_staff_of_wizardry",
	"item_recipe_force_staff",		--推推7.14

	"item_point_booster",
	"item_staff_of_wizardry",
	"item_ogre_axe",
	"item_blade_of_alacrity",		--蓝杖

	"item_ring_of_health",
	"item_void_stone",			
	"item_platemail",
	"item_energy_booster",			--清莲宝珠

	"item_ring_of_health",
	"item_void_stone",
	"item_ultimate_orb",
	"item_recipe_sphere",			--林肯
}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.BuyCourier()
	utility.BuySupportItem()
	utility.ItemPurchase(ItemsToBuy)
end