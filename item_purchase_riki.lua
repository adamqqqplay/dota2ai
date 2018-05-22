----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local utility = require( GetScriptDirectory().."/utility" ) 

local ItemsToBuy = 
{ 
	"item_tango",
	"item_orb_of_venom",
	"item_branches",
	"item_branches",
	"item_magic_stick",
	"item_recipe_magic_wand",		--大魔棒7.14
	"item_boots",	
	
	"item_slippers",
	"item_circlet",
	"item_recipe_wraith_band",
	"item_ring_of_protection",
	"item_sobi_mask",				--天鹰

	"item_belt_of_strength",
	"item_gloves",					--假腿

	"item_blade_of_alacrity",
	"item_blade_of_alacrity",
	"item_robe",
	"item_recipe_diffusal_blade",	--散失刀

	"item_quarterstaff",
	"item_robe",
	"item_sobi_mask",
	"item_ogre_axe",				--连击刀

	"item_mithril_hammer",
	"item_belt_of_strength",
	"item_recipe_basher",			--晕锤7.14
	
	"item_ring_of_health",
	"item_vitality_booster",
	"item_stout_shield",
	"item_recipe_abyssal_blade",	--大晕锤
	
	"item_broadsword",
	"item_blades_of_attack",
	"item_recipe_lesser_crit" ,
	"item_demon_edge",
	"item_recipe_greater_crit",		--大炮
	
	"item_quarterstaff",
	"item_eagle",
	"item_talisman_of_evasion",		--蝴蝶
}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.BuyCourier()
	utility.BuySupportItem()
	utility.ItemPurchase(ItemsToBuy)
end