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
	"item_blades_of_attack",
	"item_blades_of_attack",		--相位
	"item_magic_stick",
	"item_enchanted_mango",			--大魔棒7.07
	
		
	"item_boots_of_elves",
	"item_boots_of_elves", 
	"item_ogre_axe",				--魔龙枪
	
	"item_boots_of_elves",
	"item_blade_of_alacrity",
	"item_recipe_yasha",			--夜叉
	"item_ogre_axe",
	"item_belt_of_strength",
	"item_recipe_sange",			--双刀

	"item_ring_of_health",
	"item_staff_of_wizardry",
	"item_recipe_force_staff",
	"item_slippers",
	"item_circlet",
	"item_recipe_wraith_band",		--大推推7.07
	
	"item_platemail",
	"item_mystic_staff",
	"item_recipe_shivas_guard" ,	--希瓦
	
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