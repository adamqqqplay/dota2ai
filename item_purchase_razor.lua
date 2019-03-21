----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy = 
{ 
		"item_slippers",
	"item_circlet",
	"item_slippers",
	"item_tango",
	"item_flask",
	"item_recipe_wraith_band", --系带
	"item_circlet",
	"item_recipe_wraith_band", --系带
	
	"item_boots",

	"item_magic_stick",
	"item_recipe_magic_wand",		--大魔棒7.14
	"item_branches",
	"item_branches",

	"item_blades_of_attack",
	"item_chainmail",			--相位7.21

	
		
	"item_boots_of_elves",
	"item_boots_of_elves", 
	"item_ogre_axe",				--魔龙枪
	
	"item_boots_of_elves",
	"item_blade_of_alacrity",
	"item_recipe_yasha",			--夜叉
	"item_ogre_axe",
	"item_belt_of_strength",
	"item_recipe_sange",			--双刀

	"item_ring_of_regen",
	"item_staff_of_wizardry",
	"item_recipe_force_staff",		--推推7.14
	"item_recipe_hurricane_pike",					--大推推7.20
	
	"item_ogre_axe", 
	"item_mithril_hammer",
	"item_recipe_black_king_bar",	--bkb
	
	"item_point_booster",		
	"item_staff_of_wizardry",
	"item_ogre_axe",
	"item_blade_of_alacrity",		--蓝杖
	
	"item_platemail",
	"item_mystic_staff",
	"item_recipe_shivas_guard" ,	--希瓦
	
	
	
}

ItemPurchaseSystem.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(ItemsToBuy)
end