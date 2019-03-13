----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy = 
{ 
	"item_tango",
	"item_quelling_blade",			--补刀斧
	"item_branches",
	"item_branches",
	"item_magic_stick",
	"item_recipe_magic_wand",		--大魔棒7.14
	
	"item_gauntlets",
	"item_circlet",
	"item_recipe_bracer",

	"item_gauntlets",
	"item_circlet",
	"item_recipe_bracer",

	"item_boots",	
	"item_blades_of_attack",
	"item_chainmail",			--相位7.21
	
	"item_shadow_amulet",
	"item_claymore",				--隐刀

	
	"item_broadsword",
	"item_blades_of_attack",
	"item_recipe_lesser_crit" ,
	"item_demon_edge",
	"item_recipe_greater_crit",		--大炮

	"item_ultimate_orb",
	"item_recipe_silver_edge",		--大隐刀

	"item_ogre_axe", 
	"item_mithril_hammer",
	"item_recipe_black_king_bar",	--bkb
	
	"item_broadsword",
	"item_blades_of_attack",
	"item_recipe_lesser_crit" ,
	"item_demon_edge",
	"item_recipe_greater_crit",		--大炮

	
}

ItemPurchaseSystem.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(ItemsToBuy)
end