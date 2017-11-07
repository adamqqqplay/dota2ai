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
	"item_quelling_blade",			--补刀斧
	"item_boots",	
	"item_magic_stick",
	"item_enchanted_mango",			--大魔棒7.07
	"item_belt_of_strength",
	"item_gloves",					--假腿

	"item_ring_of_health",
	"item_void_stone",
	"item_demon_edge",				--狂战7.07
	
	"item_boots_of_elves",
	"item_blade_of_alacrity",
	"item_recipe_yasha",			--夜叉
	"item_ultimate_orb",
	"item_recipe_manta",			--分身
	
	"item_javelin",
	"item_belt_of_strength",
	"item_recipe_basher",
	
	"item_ring_of_health",
	"item_vitality_booster",
	"item_stout_shield",
	"item_recipe_abyssal_blade",	--大晕锤
	
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