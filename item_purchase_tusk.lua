----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.5f
--	Author: adamqqq		Email:adamqqq@163.com
--  Contributor: zmcmcc Email:mengzhang@utexas.edu
----------------------------------------------------------------------------
local utility = require( GetScriptDirectory().."/utility" ) 

local ItemsToBuy = 
{ 
	"item_tango",
	"item_flask",
	"item_stout_shield",
	"item_branches",
	"item_branches",
	"item_boots",
	"item_magic_stick",
	"item_recipe_magic_wand",		--大魔棒7.14

	"item_blades_of_attack",
	"item_blades_of_attack",		--相位	

	"item_circlet",
	"item_ring_of_protection",
	"item_recipe_urn_of_shadows",	
	"item_infused_raindrop",		--骨灰盒7.06
	
	"item_shadow_amulet",
	"item_claymore",				--隐刀

	"item_vitality_booster",
	"item_recipe_spirit_vessel", --大骨灰


	
	"item_point_booster",		
	"item_staff_of_wizardry",
	"item_ogre_axe",
	"item_blade_of_alacrity",		--蓝杖

	
	"item_ultimate_orb",
	"item_recipe_silver_edge",		--大隐刀
	
	"item_broadsword",
	"item_blades_of_attack",
	"item_recipe_lesser_crit" ,
	"item_demon_edge",
	"item_recipe_greater_crit",		--大炮
}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.BuyCourier()
	utility.ItemPurchase(ItemsToBuy)
	utility.BuySupportItem()
end