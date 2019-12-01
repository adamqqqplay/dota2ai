----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy = 
{ 
	"item_tango",
	"item_stout_shield",
	"item_quelling_blade",			--补刀斧
	"item_flask",

	"item_boots",	
	"item_magic_stick",
	"item_recipe_magic_wand",		--大魔棒7.14
	"item_branches",
	"item_branches",
	
	"item_blades_of_attack",
	"item_chainmail",			--相位7.21

	"item_recipe_vanguard"
	"item_ring_of_health",	
	"item_vitality_booster",		--先锋7.23

	
	"item_blade_of_alacrity",
	"item_blade_of_alacrity",
	"item_robe",
	"item_recipe_diffusal_blade",	--散失刀
	
	"item_boots_of_elves",
	"item_blade_of_alacrity",
	"item_recipe_yasha",			
	"item_ultimate_orb",
	"item_recipe_manta",			--分身
	
	"item_mithril_hammer",
	"item_belt_of_strength",
	"item_recipe_basher",			--晕锤7.14
	
	"item_recipe_abyssal_blade",	--大晕锤
	
	"item_reaver",
	"item_vitality_booster",		
	"item_ring_of_tarrasque",
	"item_recipe_heart",					--龙心7.23
}

ItemPurchaseSystem.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(ItemsToBuy)
end