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
	"item_faerie_fire",
	"item_bottle",
	"item_boots",
	"item_energy_booster",			--秘法鞋
	
	"item_gauntlets",
	"item_circlet",
	"item_recipe_bracer",
	"item_wind_lace",
	"item_sobi_mask",
	"item_recipe_ancient_janggo",	--战鼓

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
	
	"item_mystic_staff",
	"item_ultimate_orb",
	"item_void_stone",				--羊刀
}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.ItemPurchase(ItemsToBuy)
end