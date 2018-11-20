----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local utility = require( GetScriptDirectory().."/utility" ) 

local ItemsToBuy = 
{ 
	"item_circlet",
	"item_mantle",
	"item_recipe_null_talisman",	--无用挂件
	"item_tango",
	"item_magic_stick",
	"item_boots",
	"item_recipe_magic_wand",		--大魔棒7.14
	"item_branches",
	"item_branches",
	"item_belt_of_strength",
	"item_blades_of_attack",		--假腿7.20
	
	"item_ring_of_regen",
	"item_recipe_headdress",
	"item_branches",
	"item_chainmail",
	"item_recipe_buckler" ,
	"item_branches",
    "item_recipe_mekansm",			--梅肯

    "item_helm_of_iron_will",
	"item_crown",
	"item_recipe_veil_of_discord",	--纷争7.20
	
	"item_point_booster",
	"item_recipe_guardian_greaves",	--卫士胫甲
	
	"item_staff_of_wizardry",
	"item_ogre_axe",
	"item_blade_of_alacrity",		--蓝杖
	
	"item_cloak",
	"item_ring_of_health",
	"item_ring_of_regen",			--挑战
	"item_ring_of_regen",
	"item_recipe_headdress",
	"item_branches",
	"item_recipe_pipe",			--笛子

	"item_point_booster",
	"item_vitality_booster",
	"item_energy_booster",
	"item_mystic_staff",			--玲珑心
	
	"item_platemail",
	"item_mystic_staff",
	"item_recipe_shivas_guard" ,	--希瓦
	
}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.ItemPurchase(ItemsToBuy)
end