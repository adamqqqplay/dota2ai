----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy = 
{ 
	"item_slippers",
	"item_circlet",
	"item_slippers",
	"item_tango",
	"item_flask",
	"item_recipe_wraith_band", --系带
	"item_circlet",
	"item_recipe_wraith_band", --系带
	
	"item_branches",
	"item_branches",
	"item_boots",	
	"item_magic_stick",
	"item_recipe_magic_wand",		--大魔棒7.14
	"item_blades_of_attack",
	"item_chainmail",			--相位7.21
	
	"item_lifesteal",
	"item_quarterstaff",			--疯狂面具7.06

	"item_boots_of_elves",
	"item_boots_of_elves", 
	"item_ogre_axe",				--魔龙枪
	"item_ring_of_regen",
	"item_staff_of_wizardry",
	"item_recipe_force_staff",		--推推7.14
	"item_crown",					--大推推7.20



	--"item_ring_of_health",
	--"item_void_stone",
	--"item_ultimate_orb",
	--"item_recipe_sphere",			--林肯


	
	"item_point_booster",
	"item_ultimate_orb",
	"item_ultimate_orb",			--冰眼
	
	"item_demon_edge",	
	"item_quarterstaff",	
	"item_javelin",					--金箍棒7.14

	"item_javelin",
	"item_mithril_hammer",			--电锤7.14
	"item_hyperstone",
	"item_recipe_mjollnir",			--大雷锤
}

ItemPurchaseSystem.checkItemBuild(ItemsToBuy)		--检查装备列表

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(ItemsToBuy)	--购买装备
end