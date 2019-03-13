----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy = 
{ 
	"item_slippers",
	"item_circlet",

	"item_stout_shield",
	"item_tango",
	"item_recipe_wraith_band",
	"item_branches",
	"item_branches",
	"item_bottle",
	"item_boots",
	"item_magic_stick",
	"item_recipe_magic_wand",		--大魔棒7.14
	
	"item_blades_of_attack",
	"item_chainmail",			--相位7.21
	
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

ItemPurchaseSystem.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(ItemsToBuy)
end