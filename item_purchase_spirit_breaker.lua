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
	"item_magic_stick",
	"item_recipe_magic_wand",		--大魔棒7.14

	"item_orb_of_venom",

	"item_boots",	
	"item_gauntlets",
	"item_circlet",
	"item_recipe_bracer",
	"item_gauntlets",
	"item_circlet",
	"item_recipe_bracer",

	"item_belt_of_strength",
	"item_gloves",			--假腿7.21

	"item_circlet",
	"item_ring_of_protection",
	"item_recipe_urn_of_shadows",	
	"item_infused_raindrop",		--骨灰盒7.06

	"item_quarterstaff",
	"item_robe",
	"item_sobi_mask",
	"item_ogre_axe",				--连击刀

	"item_ogre_axe", 
	"item_mithril_hammer",
	"item_recipe_black_king_bar",	--bkb

	"item_point_booster",
	"item_staff_of_wizardry",
	"item_ogre_axe",
	"item_blade_of_alacrity",		--蓝杖

	"item_crown",
	"item_vitality_booster",		
	"item_ring_of_tarrasque",
	"item_recipe_heart",					--龙心7.20
	
}

ItemPurchaseSystem.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	ItemPurchaseSystem.BuyCourier()
	ItemPurchaseSystem.BuySupportItem()
	ItemPurchaseSystem.ItemPurchase(ItemsToBuy)
end