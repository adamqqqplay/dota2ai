----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local utility = require( GetScriptDirectory().."/utility" ) 

local ItemsToBuy = 
{ 
	"item_tango",
	"item_flask",
	"item_quelling_blade",			--补刀斧
	"item_branches",
	"item_branches",
	"item_magic_stick",
	"item_enchanted_mango",			--大魔棒7.07
	
	"item_boots",	

	"item_lifesteal",               --吸血面具

	"item_belt_of_strength",
	"item_gloves",					--假腿
	
	"item_recipe_mask_of_madness",  -- 疯脸

	"item_ring_of_health",
	"item_void_stone",
	"item_demon_edge",				--狂战7.07

	"item_boots_of_elves",
	"item_blade_of_alacrity",
	"item_recipe_yasha",			--夜叉
	"item_ultimate_orb",
	"item_recipe_manta",			--分身

	"item_ogre_axe", 
	"item_mithril_hammer",
	"item_recipe_black_king_bar",	--bkb

	"item_hyperstone",
	"item_javelin",
	"item_javelin",					--金箍棒7.07
		
	"item_quarterstaff",
	"item_eagle",
	"item_talisman_of_evasion",		--蝴蝶
}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.ItemPurchase(ItemsToBuy)
end