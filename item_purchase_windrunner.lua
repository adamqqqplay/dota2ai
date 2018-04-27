----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local utility = require( GetScriptDirectory().."/utility" ) 

local ItemsToBuy = 
{ 
	"item_tango",
	"item_flask",
	"item_branches",
	"item_branches",
	"item_magic_stick",
	"item_recipe_magic_wand",		--大魔棒7.14
		
	"item_boots",
	"item_blades_of_attack",
	"item_blades_of_attack",		--相位
	
	"item_ring_of_regen",
	"item_staff_of_wizardry",
	"item_recipe_force_staff",		--推推7.14
	
	"item_ring_of_health",
	"item_void_stone",
	"item_ultimate_orb",
	"item_recipe_sphere",			--林肯
	
	"item_javelin",
	"item_mithril_hammer",			--电锤7.14
	
	"item_point_booster",
	"item_staff_of_wizardry",
	"item_ogre_axe",
	"item_blade_of_alacrity",		--蓝杖
	
	"item_hyperstone",
	"item_recipe_mjollnir",			--大雷锤
	
	"item_demon_edge",	
	"item_quarterstaff",	
	"item_javelin",					--金箍棒7.14
	
}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.ItemPurchase(ItemsToBuy)
end