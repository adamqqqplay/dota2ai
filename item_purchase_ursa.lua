----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy = 
{ 
	"item_tango",
	"item_stout_shield",
	"item_orb_of_venom",
	"item_branches",
	"item_branches",
	"item_boots",
	"item_magic_stick",
	"item_recipe_magic_wand",		--大魔棒7.14
	"item_blades_of_attack",
	"item_chainmail",				--相位7.21
	
	"item_ring_of_protection",
	"item_branches",
	"item_recipe_buckler",
	"item_sobi_mask",
	"item_branches",
	"item_recipe_ring_of_basilius",
	"item_recipe_vladmir",
	"item_lifesteal",	             --祭品7.23
	
	"item_blink"	,				--跳刀
	
	"item_mithril_hammer",
	"item_belt_of_strength",
	"item_recipe_basher",			--晕锤7.14
	
	"item_point_booster",		
	"item_staff_of_wizardry",
	"item_ogre_axe",
	"item_blade_of_alacrity",		--蓝杖
	
	"item_mithril_hammer",
	"item_ogre_axe",
	"item_recipe_black_king_bar",	--bkb
	
	"item_recipe_vanguard"
	"item_ring_of_health",	
	"item_vitality_booster",		--先锋7.23
	
	"item_recipe_abyssal_blade",	--大晕锤
}

ItemPurchaseSystem.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(ItemsToBuy)
end