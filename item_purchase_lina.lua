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
	"item_wind_lace",
	"item_bottle",
	"item_boots",
	"item_magic_stick",
	"item_enchanted_mango",			--大魔棒7.07
	"item_energy_booster",			--秘法鞋
	"item_void_stone",
	"item_energy_booster",
	"item_recipe_aether_lens",		--以太之镜7.06
	"item_staff_of_wizardry",
	"item_void_stone",
	"item_recipe_cyclone",				--风杖
	"item_point_booster",
	"item_staff_of_wizardry",
	"item_ogre_axe",
	"item_blade_of_alacrity",		--蓝杖
	"item_platemail",
	"item_mystic_staff",
	"item_recipe_shivas_guard",		--希瓦
	"item_point_booster",
	"item_vitality_booster",
	"item_energy_booster",
	"item_mystic_staff",			--玲珑心
}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.ItemPurchase(ItemsToBuy)
end