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
	"item_magic_stick",
	"item_recipe_magic_wand",		--大魔棒7.14

	"item_boots",	
	"item_energy_booster",			--秘法鞋
	
	"item_cloak",
	"item_shadow_amulet",			--微光
	
	"item_ring_of_regen",
	"item_staff_of_wizardry",
	"item_recipe_force_staff",		--推推7.14
	
	"item_void_stone",
	"item_energy_booster",
	"item_recipe_aether_lens",		--以太之镜7.06
	
	"item_point_booster",
	"item_staff_of_wizardry",
	"item_ogre_axe",
	"item_blade_of_alacrity",		--蓝杖
	
	"item_ogre_axe", 
	"item_mithril_hammer",
	"item_recipe_black_king_bar",	--bkb
	
	"item_mystic_staff",
	"item_ultimate_orb",
	"item_void_stone",				--羊刀

}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.BuySupportItem()
	utility.BuyCourier()
	utility.ItemPurchase(ItemsToBuy)
end