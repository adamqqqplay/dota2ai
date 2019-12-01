----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy = 
{ 
	"item_tango",
	"item_stout_shield",
	"item_blight_stone",
	"item_branches",
	"item_branches",
	"item_magic_stick",
	"item_recipe_magic_wand",		--大魔棒7.14
	"item_boots",
	"item_blades_of_attack",
	"item_chainmail",			--相位7.21
	
	"item_slippers",
	"item_circlet",
	"item_recipe_wraith_band",

	"item_recipe_vanguard"
	"item_ring_of_health",	
	"item_vitality_booster",		--先锋7.23

	"item_ogre_axe", 
	"item_mithril_hammer",
	"item_recipe_black_king_bar",	--bkb

	"item_mithril_hammer",
	"item_mithril_hammer",			--暗灭

	"item_mithril_hammer",
	"item_belt_of_strength",
	"item_recipe_basher",			--晕锤7.14
	"item_recipe_abyssal_blade",	--大晕锤
	
	"item_lifesteal",
	"item_reaver", 
	"item_claymore",				--撒旦7.07
	
	"item_demon_edge",	
	"item_quarterstaff",	
	"item_javelin",					--金箍棒7.14
}

ItemPurchaseSystem.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(ItemsToBuy)
end