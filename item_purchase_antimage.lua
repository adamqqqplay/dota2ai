----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy = 
{ 
	"item_tango",
	"item_tango",
	"item_flask",
	"item_stout_shield",

	"item_quelling_blade",			--补刀斧
	"item_slippers",
	"item_circlet",
	"item_recipe_wraith_band",
	"item_boots",	
	"item_belt_of_strength",
	"item_gloves",			--假腿7.21

	"item_ring_of_health",
	"item_void_stone",
	"item_demon_edge",
	"item_recipe_bfury",			--狂战7.14
	
	"item_boots_of_elves",
	"item_blade_of_alacrity",
	"item_recipe_yasha",			--夜叉
	"item_ultimate_orb",
	"item_recipe_manta",			--分身
	
	"item_mithril_hammer",
	"item_belt_of_strength",
	"item_recipe_basher",			--晕锤7.14
	
	"item_ring_of_health",
	"item_vitality_booster",
	"item_stout_shield",
	"item_recipe_abyssal_blade",	--大晕锤
	
	"item_eagle",
	"item_talisman_of_evasion",
	"item_quarterstaff",			--蝴蝶


	--[["item_point_booster",
	"item_staff_of_wizardry",
	"item_ogre_axe",
	"item_blade_of_alacrity",]]		--蓝杖

	"item_crown",
	"item_vitality_booster",		
	"item_ring_of_tarrasque",
	"item_recipe_heart",					--龙心7.20
	
	--"item_vitality_booster",
	--"item_vitality_booster",		
	--"item_reaver",					--龙心7.06
}

ItemPurchaseSystem.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(ItemsToBuy)
end