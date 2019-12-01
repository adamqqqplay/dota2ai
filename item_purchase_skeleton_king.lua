----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy = 
{ 
	"item_tango",
	"item_flask",
	"item_stout_shield",
	"item_branches",
	"item_branches",
	"item_boots",
	"item_magic_stick",
	"item_recipe_magic_wand",		--大魔棒7.14
	"item_belt_of_strength",
	"item_gloves",			--假腿7.21
	
	"item_quarterstaff",
	"item_robe",
	"item_sobi_mask",
	"item_ogre_axe",				--连击刀

	"item_broadsword",
	"item_robe",
	"item_chainmail",				--刃甲

	"item_ogre_axe",
	"item_mithril_hammer",
	"item_recipe_black_king_bar",	--bkb
	
	"item_ring_of_protection",
	"item_branches",
	"item_recipe_buckler",
	"item_platemail",
	"item_hyperstone",
	"item_recipe_assault",			--强袭7.23	
	
	"item_point_booster",
	"item_staff_of_wizardry",
	"item_ogre_axe",
	"item_blade_of_alacrity",		--蓝杖
	
}

ItemPurchaseSystem.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(ItemsToBuy)
end