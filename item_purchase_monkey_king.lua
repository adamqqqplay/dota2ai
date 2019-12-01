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
		"item_slippers",
	"item_circlet",
	"item_recipe_wraith_band",
		"item_slippers",
	"item_circlet",
	"item_recipe_wraith_band",
	"item_branches",
	"item_branches",
	"item_boots",
	"item_blades_of_attack",
	"item_chainmail",			--相位7.21

	"item_magic_stick",
	"item_recipe_magic_wand",		--大魔棒7.14
	
	"item_quarterstaff",
	"item_robe",
	"item_sobi_mask",
	"item_ogre_axe",				--连击刀
	
	
	"item_shadow_amulet",
	"item_claymore",				--隐刀
	"item_ultimate_orb",
	"item_recipe_silver_edge",		--大隐刀
	
	"item_ogre_axe", 
	"item_mithril_hammer",
	"item_recipe_black_king_bar",	--bkb

	"item_point_booster",
	"item_ultimate_orb",
	"item_ultimate_orb",			--冰眼
	
	"item_reaver",
	"item_vitality_booster",		
	"item_ring_of_tarrasque",
	"item_recipe_heart",					--龙心7.23
}

ItemPurchaseSystem.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(ItemsToBuy)
end