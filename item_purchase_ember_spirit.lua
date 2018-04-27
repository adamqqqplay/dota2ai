----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local utility = require( GetScriptDirectory().."/utility" ) 

local ItemsToBuy = 
{ 
	"item_stout_shield",
	"item_tango",
	"item_branches",
	"item_branches",
	"item_bottle",
	"item_boots",
	"item_magic_stick",
	"item_recipe_magic_wand",		--大魔棒7.14
	"item_mantle",
	"item_circlet",
	"item_recipe_null_talisman",	--无用挂件
	"item_mantle",
	"item_circlet",
	"item_recipe_null_talisman",	--无用挂件
	"item_helm_of_iron_will",
	"item_recipe_veil_of_discord",	--纷争
	"item_blades_of_attack",
	"item_blades_of_attack",		--相位
	
	"item_javelin",
	"item_mithril_hammer",			--电锤7.14
	"item_hyperstone",
	"item_recipe_mjollnir",			--大雷锤
	
	"item_ring_of_health",
	"item_void_stone",
	"item_ultimate_orb",
	"item_recipe_sphere",			--林肯
	
	"item_point_booster",
	"item_vitality_booster",
	"item_energy_booster",
	"item_mystic_staff",			--玲珑心

}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.ItemPurchase(ItemsToBuy)
end