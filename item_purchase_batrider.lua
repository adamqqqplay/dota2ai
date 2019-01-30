----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")		--导入通用函数库

local ItemsToBuy = 
{ 
	"item_tango",
	"item_flask",
	"item_wind_lace",
	"item_branches",
	"item_branches",
	"item_magic_stick",
	"item_recipe_magic_wand",		--大魔棒7.14

	"item_boots",
	"item_ring_of_regen",			--绿鞋

	"item_crown",
	"item_sobi_mask",
	"item_wind_lace",
	"item_recipe_ancient_janggo",   --战鼓7.20
	"item_blink",					--跳刀
	"item_ring_of_regen",
	"item_staff_of_wizardry",
	"item_recipe_force_staff",		--推推7.14
	"item_wind_lace",
	"item_void_stone",
	"item_staff_of_wizardry",
	"item_recipe_cyclone",			--风杖
	"item_ogre_axe", 
	"item_mithril_hammer",
	"item_recipe_black_king_bar",	--bkb
	"item_point_booster",		
	"item_staff_of_wizardry",
	"item_ogre_axe",
	"item_blade_of_alacrity",		--蓝杖
}

ItemPurchaseSystem.checkItemBuild(ItemsToBuy)		--检查装备列表

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(ItemsToBuy)	--购买装备
end