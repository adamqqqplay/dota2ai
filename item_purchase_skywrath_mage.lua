----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy = 
{ 
	"item_tango",
	"item_mantle",
	"item_circlet",
	"item_mantle",	--无用挂件
	"item_branches",
	"item_branches",
	"item_magic_stick",
	"item_recipe_magic_wand",		--大魔棒7.14
	"item_boots",
	

	"item_recipe_null_talisman",
	"item_circlet",
	"item_recipe_null_talisman",
	
	"item_energy_booster",			--秘法鞋

	"item_crown",
	"item_crown",
	"item_staff_of_wizardry",
	"item_recipe_rod_of_atos",		--阿托斯7.20

	"item_wind_lace",
	"item_staff_of_wizardry",
	"item_void_stone",
	"item_recipe_cyclone",				--风杖

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

ItemPurchaseSystem.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	ItemPurchaseSystem.BuyCourier()
	ItemPurchaseSystem.BuySupportItem()
	ItemPurchaseSystem.ItemPurchase(ItemsToBuy)
end