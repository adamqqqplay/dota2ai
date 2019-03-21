----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy = 
{ 
	"item_tango",
	"item_clarity",
	"item_branches",
	"item_branches",
	"item_recipe_magic_wand",		--大魔棒7.14
	"item_magic_stick",
	
	"item_boots",	
	"item_belt_of_strength",
	"item_gloves",			--假腿7.21

	"item_ring_of_regen",
	"item_staff_of_wizardry",
	"item_recipe_force_staff",		--推推7.14
	
	"item_boots_of_elves",
	"item_boots_of_elves", 
	"item_ogre_axe",				--魔龙枪
	"item_recipe_hurricane_pike",					--大推推7.20
	
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
	"item_void_stone",
	"item_ultimate_orb",
	"item_mystic_staff",			--羊刀
}

ItemPurchaseSystem.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	ItemPurchaseSystem.BuyCourier()				--购买信使
	ItemPurchaseSystem.BuySupportItem()
	ItemPurchaseSystem.ItemPurchase(ItemsToBuy)
end