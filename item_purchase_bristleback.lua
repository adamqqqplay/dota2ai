----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
require( GetScriptDirectory().."/utility" ) 

local ItemsToBuy = 
{ 
	"item_tango",
	"item_enchanted_mango";
	"item_stout_shield",
	"item_branches",
	"item_branches",
	
	"item_boots",
	"item_belt_of_strength",
	"item_gloves",					--假腿
	
	"item_circlet",
	"item_magic_stick",				--大魔棒
	
	"item_vitality_booster",
	"item_ring_of_health",			--先锋

	"item_cloak",
	"item_ring_of_health",
	"item_ring_of_regen",			--挑战
	"item_ring_of_regen",
	"item_recipe_headdress",
	"item_branches",
	"item_recipe_pipe" ,			--笛子
	
	"item_chainmail",
	"item_recipe_buckler" ,
	"item_branches",
	"item_recipe_crimson_guard",	--赤红甲
	
	"item_point_booster",
	"item_vitality_booster",
	"item_energy_booster",
	"item_mystic_staff",			--玲珑心
	
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