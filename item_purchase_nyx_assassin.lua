----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6be
--	Author: adamqqq		Email:adamqqq@163.com
--  Contributor: zmcmcc Email:mengzhang@utexas.edu
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy = 
{ 
	"item_tango",
	"item_flask",	
	"item_stout_shield",
	"item_branches",
	"item_branches",

	"item_magic_stick",	
	"item_recipe_magic_wand",	--大魔棒7.14

	"item_boots",	

	"item_gloves",
	"item_recipe_hand_of_midas",	--点金

	"item_energy_booster",			--秘法鞋

	"item_blink",
	
	"item_point_booster",
	"item_staff_of_wizardry",
	"item_ogre_axe",
	"item_blade_of_alacrity",		--蓝杖

	"item_ring_of_health",
	"item_staff_of_wizardry",
	"item_recipe_force_staff",     --推推

	"item_crown",
	"item_staff_of_wizardry",
	"item_recipe_dagon",
	"item_recipe_dagon",
	"item_recipe_dagon",
	"item_recipe_dagon",
	"item_recipe_dagon",			--红杖

}

ItemPurchaseSystem.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	ItemPurchaseSystem.BuyCourier()
	ItemPurchaseSystem.BuySupportItem()
	ItemPurchaseSystem.ItemPurchase(ItemsToBuy)
end