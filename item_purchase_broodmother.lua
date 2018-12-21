----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local utility = require( GetScriptDirectory().."/utility" ) 

local ItemsToBuy = 
{ 
	"item_tango",
	"item_quelling_blade",			--补刀斧
	"item_branches",
	"item_branches",
	"item_recipe_magic_wand",		--大魔棒7.14
	"item_boots",

	"item_magic_stick",

	"item_ring_of_regen",

	"item_gauntlets",
	"item_gauntlets",
	"item_recipe_soul_ring",  		--魂戒

	"item_belt_of_strength",
	"item_blades_of_attack",		--假腿7.20
	
	"item_ring_of_regen",
	"item_recipe_headdress",
	"item_branches",				
	"item_ring_of_protection",
	"item_sobi_mask",
	"item_lifesteal",				--祭品
	
	"item_chainmail",
	"item_sobi_mask",
	"item_blight_stone",			--勋章
	
	"item_quarterstaff",
	"item_robe",
	"item_sobi_mask",
	"item_quarterstaff",
	"item_robe",
	"item_sobi_mask",
	"item_recipe_orchid",			--紫苑
	
	"item_ultimate_orb",
	"item_wind_lace",
	"item_recipe_solar_crest",		--大勋章7.20

	"item_ogre_axe", 
	"item_mithril_hammer",
	"item_recipe_black_king_bar",	--bkb

	"item_broadsword",
	"item_blades_of_attack",
	"item_recipe_lesser_crit",
	"item_recipe_bloodthorn",		--血棘
	
	"item_hyperstone",
				"item_platemail",
				"item_chainmail",
				"item_recipe_assault",			--强袭
	
}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.ItemPurchase(ItemsToBuy)
end