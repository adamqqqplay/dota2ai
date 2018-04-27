----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local utility = require( GetScriptDirectory().."/utility" ) 

local ItemsToBuy = 
{ 
	"item_tango",
	"item_flask",
	"item_stout_shield",
	"item_branches",
	"item_branches",
	"item_magic_stick",
	"item_recipe_magic_wand",		--大魔棒7.14

	"item_boots",
	"item_energy_booster",			--秘法鞋
	
	"item_blink",					--跳刀

	"item_shadow_amulet",
	"item_claymore",				--隐刀

	"item_ogre_axe", 
	"item_mithril_hammer",
	"item_recipe_black_king_bar",	--bkb
	
	"item_point_booster",
	"item_vitality_booster",
	"item_energy_booster",
	"item_mystic_staff",			--玲珑心

	"item_ring_of_health",
	"item_void_stone",		
	"item_ring_of_health",
	"item_void_stone",		
	"item_recipe_refresher", 		--刷新球
}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.ItemPurchase(ItemsToBuy)
end