----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
require( GetScriptDirectory().."/utility" ) 

local ItemsToBuy = 
{ 
	"item_tango",
	"item_flask",
	"item_stout_shield",
	"item_branches",
	"item_branches",
	"item_boots",	
	"item_circlet",
	"item_magic_stick",				--大魔棒
	"item_belt_of_strength",
	"item_gloves",					--假腿
	
	"item_lifesteal",
	"item_quarterstaff",			--疯狂面具7.06
	
	"item_ogre_axe",
	"item_belt_of_strength",
	"item_recipe_sange",			--散华
	"item_boots_of_elves",
	"item_blade_of_alacrity",
	"item_recipe_yasha",			--夜叉

	"item_blink",					--跳刀
	
	"item_ogre_axe",
	"item_mithril_hammer",
	"item_recipe_black_king_bar",	--bkb
	
	"item_hyperstone",
	"item_platemail",
	"item_chainmail",
	"item_recipe_assault",			--强袭
	
	"item_quarterstaff",
	"item_robe",
	"item_sobi_mask",
	"item_quarterstaff",
	"item_robe",
	"item_sobi_mask",
	"item_recipe_orchid",			--紫苑
	
	"item_broadsword",
	"item_blades_of_attack",
	"item_recipe_lesser_crit" ,
	"item_recipe_bloodthorn",		--血棘
}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.ItemPurchase(ItemsToBuy)
end