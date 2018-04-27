----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local utility = require( GetScriptDirectory().."/utility" ) 

local ItemsToBuy = 
{ 
	"item_tango",
	"item_slippers",
	"item_circlet",
	"item_recipe_wraith_band", --系带

	"item_magic_stick",
	"item_boots",
	"item_branches",
	"item_branches",
	"item_recipe_magic_wand",		--大魔棒7.14

	"item_blades_of_attack",
	"item_blades_of_attack",		--相位
	
	"item_ring_of_protection",
	"item_sobi_mask",				--tianying

	"item_gauntlets",
	"item_circlet",
	"item_recipe_bracer",
	"item_wind_lace",
	"item_sobi_mask",
	"item_recipe_ancient_janggo",	--战鼓
	
	"item_boots_of_elves",
	"item_blade_of_alacrity",
	"item_recipe_yasha",			--夜叉
	"item_ogre_axe",
	"item_belt_of_strength",
	"item_recipe_sange",			--双刀
	
	"item_mithril_hammer",
	"item_ogre_axe",
	"item_recipe_black_king_bar",	--bkb

	"item_boots_of_elves",
	"item_boots_of_elves", 
	"item_ogre_axe",				--魔龙枪
	"item_ring_of_regen",
	"item_staff_of_wizardry",
	"item_recipe_force_staff",		--推推7.14
	"item_slippers",
	"item_circlet",
	"item_recipe_wraith_band",		--大推推7.07
	
	"item_quarterstaff",
	"item_eagle",
	"item_talisman_of_evasion",		--蝴蝶
	
	"item_demon_edge",	
	"item_quarterstaff",	
	"item_javelin",					--金箍棒7.14

}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.ItemPurchase(ItemsToBuy)
end