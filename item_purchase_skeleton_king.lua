----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local utility = require( GetScriptDirectory().."/utility" ) 

local ItemsToBuy = 
{ 
	"item_tango",
	"item_stout_shield",
	"item_branches",
	"item_branches",
	"item_boots",
	"item_magic_stick",
	"item_enchanted_mango",			--大魔棒7.07
	"item_belt_of_strength",
	"item_gloves",					--假腿
	
	"item_broadsword",
	"item_robe",
	"item_chainmail",				--刃甲
	
	"item_belt_of_strength", 
	"item_ogre_axe",
	"item_recipe_sange",
	"item_talisman_of_evasion",		--天堂
	
	"item_platemail", 
	"item_chainmail", 
	"item_hyperstone",
	"item_recipe_assault",			--强袭	
	
	"item_point_booster",
	"item_staff_of_wizardry",
	"item_ogre_axe",
	"item_blade_of_alacrity",		--蓝杖
	
	"item_vitality_booster",
	"item_vitality_booster",		
	"item_reaver",					--龙心7.06
	
}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.ItemPurchase(ItemsToBuy)
end