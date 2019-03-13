----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy = 
{ 
	"item_tango",
	"item_flask",
	"item_clarity",
	"item_branches",
	"item_branches",
	"item_wind_lace",
	"item_magic_stick",
	"item_recipe_magic_wand",		--大魔棒7.14
	"item_boots",	

	"item_ring_of_regen",			--绿鞋
	"item_gauntlets",
	"item_circlet",
	"item_recipe_bracer",
	"item_gauntlets",
	"item_circlet",
	"item_recipe_bracer",
	
	"item_cloak",
	"item_shadow_amulet",			--微光

	"item_ring_of_regen",
	"item_staff_of_wizardry",
	"item_recipe_force_staff",		--推推7.14

	--"item_staff_of_wizardry",
	--"item_void_stone",
	--"item_recipe_cyclone",			--风杖

	"item_point_booster",
	"item_staff_of_wizardry",
	"item_ogre_axe",
	"item_blade_of_alacrity",		--蓝杖
	"item_mithril_hammer",
	"item_ogre_axe",
	"item_recipe_black_king_bar",	--bkb
	"item_mystic_staff",
	"item_ultimate_orb",
	"item_void_stone",				--羊刀
}

ItemPurchaseSystem.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	ItemPurchaseSystem.BuySupportItem()
	ItemPurchaseSystem.BuyCourier()
	ItemPurchaseSystem.ItemPurchase(ItemsToBuy)
end