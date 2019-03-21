----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy = 
{ 
	"item_tango",
	"item_flask",
	"item_branches",
	"item_branches",
	"item_magic_stick",
	"item_recipe_magic_wand",		--大魔棒7.14
	"item_boots",	
	"item_belt_of_strength",
	"item_gloves",			--假腿7.21

	"item_lifesteal",
	"item_quarterstaff",			--疯狂面具7.06
	
	"item_boots_of_elves",
	"item_blade_of_alacrity",
	"item_recipe_yasha",			--夜叉
	"item_ultimate_orb",
	"item_recipe_manta",			--分身
	
	"item_boots_of_elves",
	"item_boots_of_elves", 
	"item_ogre_axe",				--魔龙枪
	"item_ring_of_regen",
	"item_staff_of_wizardry",
	"item_recipe_force_staff",		--推推7.14
	"item_recipe_hurricane_pike",					--大推推7.20

	"item_point_booster",
	"item_staff_of_wizardry",
	"item_ogre_axe",
	"item_blade_of_alacrity",		--蓝杖
	
	"item_quarterstaff",
	"item_eagle",
	"item_talisman_of_evasion",		--蝴蝶

}

ItemPurchaseSystem.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(ItemsToBuy)
end