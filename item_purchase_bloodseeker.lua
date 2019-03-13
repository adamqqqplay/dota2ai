----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy = 
{ 
	"item_tango",
	"item_stout_shield",
	"item_quelling_blade",	
	"item_slippers",
	"item_circlet",
	"item_recipe_wraith_band",
	"item_flask",
	
	"item_slippers",
	"item_circlet",
	"item_recipe_wraith_band",
	
	"item_branches",
	"item_branches",
	"item_magic_stick",
	"item_recipe_magic_wand",		--大魔棒7.14
	"item_boots",	
	"item_belt_of_strength",
	"item_gloves",			--假腿7.21

	--[["item_slippers",
	"item_circlet",
	"item_recipe_wraith_band", --系带
	"item_ring_of_protection",
	"item_sobi_mask",		]]		--天鹰
	
	"item_broadsword",
	"item_robe",
	"item_chainmail",				--刃甲
	
	"item_blade_of_alacrity",
	"item_boots_of_elves",
	"item_recipe_yasha",
	"item_ogre_axe",
	"item_belt_of_strength",
	"item_recipe_sange",			--双刀
	
	"item_ogre_axe",
	"item_mithril_hammer",
	"item_recipe_black_king_bar",	--bkb
	
	"item_mithril_hammer",
	"item_belt_of_strength",
	"item_recipe_basher",			--晕锤7.14
	
	"item_vitality_booster",
	"item_ring_of_health",
	"item_stout_shield",
	"item_recipe_abyssal_blade",	--大晕锤
	
	"item_eagle",
	"item_talisman_of_evasion",
	"item_quarterstaff",			--蝴蝶
	
}

ItemPurchaseSystem.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(ItemsToBuy)
end