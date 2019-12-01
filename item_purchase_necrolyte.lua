----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy = 
{ 
	
	"item_tango",
	"item_mantle",
	"item_circlet",
	"item_mantle",	--无用挂件
	"item_branches",
	"item_branches",
	"item_magic_stick",
	"item_recipe_magic_wand",		--大魔棒7.14
	"item_boots",
	

	"item_recipe_null_talisman",
	"item_circlet",
	"item_recipe_null_talisman",
	"item_belt_of_strength",
	"item_gloves",			--假腿7.21
	
	"item_ring_of_regen",
	"item_recipe_headdress",
	"item_branches",
	
	"item_chainmail",
    "item_recipe_mekansm",			--梅肯7.23

    "item_sobi_mask",
	"item_branches",
	"item_recipe_ring_of_basilius",
	"item_crown",
	"item_recipe_veil_of_discord",	--纷争7.23
	
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

ItemPurchaseSystem.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(ItemsToBuy)
end