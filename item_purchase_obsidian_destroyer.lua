----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
--  Contributor: zmcmcc Email:mengzhang@utexas.edu
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
	"item_belt_of_strength",
	"item_gloves",			--假腿7.21
	"item_ring_of_regen",
	"item_staff_of_wizardry",
	"item_recipe_force_staff",		--推推7.14
	
	"item_boots_of_elves",
	"item_boots_of_elves", 
	"item_ogre_axe",				--魔龙枪
	"item_crown",					--大推推7.20
	
	"item_crown",
	"item_crown",
	"item_staff_of_wizardry",
	"item_recipe_rod_of_atos",		--阿托斯7.20
	
	"item_ogre_axe", 
	"item_mithril_hammer",
	"item_recipe_black_king_bar",	--bkb

	"item_ring_of_health",
	"item_void_stone",
	"item_ultimate_orb",
	"item_recipe_sphere",			--林肯

	"item_void_stone",
	"item_ultimate_orb",
	"item_mystic_staff",			--羊刀
}

ItemPurchaseSystem.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(ItemsToBuy)
end