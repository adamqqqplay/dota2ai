----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy = 
{ 
	"item_tango",
	"item_clarity",
	"item_bottle",
	"item_boots",
	"item_magic_stick",
	"item_branches",
	"item_branches",
	"item_recipe_magic_wand",		--大魔棒7.14
	
	"item_mantle",
	"item_circlet",
	"item_recipe_null_talisman",
	
	"item_mantle",
	"item_circlet",
	"item_recipe_null_talisman",
	"item_energy_booster",			--秘法鞋
	"item_crown",
	"item_helm_of_iron_will",
	"item_recipe_veil_of_discord",	--纷争
	"item_void_stone",
	"item_energy_booster",
	"item_recipe_aether_lens",		--以太之镜7.06
	"item_staff_of_wizardry",
	"item_void_stone",
	"item_recipe_cyclone",
	"item_wind_lace",				--风杖
	"item_point_booster",
	"item_staff_of_wizardry",
	"item_ogre_axe",
	"item_blade_of_alacrity",		--蓝杖
	"item_point_booster",
	"item_vitality_booster",
	"item_energy_booster",
	"item_mystic_staff",			--玲珑心
}

ItemPurchaseSystem.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(ItemsToBuy)
end