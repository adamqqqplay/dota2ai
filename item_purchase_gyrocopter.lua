----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local utility = require( GetScriptDirectory().."/utility" ) 

local ItemsToBuy = 
{ 
"item_tango",
	"item_flask",
	"item_branches",
	"item_branches",
	"item_boots",
	"item_magic_stick",
	"item_enchanted_mango",			--大魔棒7.07
	"item_energy_booster",			--秘法鞋
	
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
	
	"item_point_booster",		
	"item_staff_of_wizardry",
	"item_ogre_axe",
	"item_blade_of_alacrity",		--蓝杖
	
	"item_quarterstaff",
	"item_eagle",
	"item_talisman_of_evasion",		--蝴蝶
	
	"item_hyperstone",
	"item_javelin",
	"item_javelin",					--金箍棒7.07

}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.ItemPurchase(ItemsToBuy)
end