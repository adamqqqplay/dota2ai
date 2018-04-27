----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local utility = require( GetScriptDirectory().."/utility" ) 

local ItemsToBuy = 
{ 
	"item_tango",
	--"item_flask",
	"item_stout_shield",
	"item_branches",
	"item_branches",
	"item_magic_stick",
	"item_recipe_magic_wand",		--大魔棒7.14

	"item_bottle",					-- 魔瓶

	"item_boots",
	"item_belt_of_strength",
	"item_gloves",					--假腿
	
	"item_blink",					--跳刀

	"item_sobi_mask",
	"item_quarterstaff",
	"item_robe",
	"item_ogre_axe",				--连击刀

	"item_ogre_axe", 
	"item_mithril_hammer",
	"item_recipe_black_king_bar",	--bkb
	
	"item_platemail", 
	"item_chainmail", 
	"item_hyperstone",
	"item_recipe_assault",			--强袭	
	
	"item_broadsword",
	"item_blades_of_attack",
	"item_recipe_lesser_crit",
	"item_demon_edge",
	"item_lesser_crit",
	"item_recipe_greater_crit",		--大炮
}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.ItemPurchase(ItemsToBuy)
end