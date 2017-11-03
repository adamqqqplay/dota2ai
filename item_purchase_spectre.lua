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
	"item_magic_stick",
	"item_enchanted_mango",			--大魔棒7.07
	
	"item_ring_of_health",
	"item_vitality_booster",		--先锋
	
	"item_blades_of_attack",
	"item_blades_of_attack",		--相位
	

	
	"item_blade_of_alacrity",
	"item_blade_of_alacrity",
	"item_robe",
	"item_recipe_diffusal_blade",	--散失刀
	
	"item_boots_of_elves",
	"item_blade_of_alacrity",
	"item_recipe_yasha",			
	"item_ultimate_orb",
	"item_recipe_manta",			--分身
	
	"item_recipe_diffusal_blade",	--2级散失
	
	"item_relic",
	"item_recipe_radiance",			--辉耀
		
	"item_javelin",
	"item_belt_of_strength",
	"item_recipe_basher",
	"item_recipe_abyssal_blade",	--大晕锤
	
	"item_vitality_booster",
	"item_vitality_booster",		
	"item_reaver",					--龙心7.06
}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.ItemPurchase(ItemsToBuy)
end