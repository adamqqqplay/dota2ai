----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local utility = require( GetScriptDirectory().."/utility" ) 

local ItemsToBuy = 
{ 
	"item_tango",
	"item_flask",
	"item_clarity",
	"item_branches",
	"item_branches",

	"item_magic_stick",
	"item_recipe_magic_wand",		--大魔棒7.14

	"item_boots",	
	
	"item_belt_of_strength",
	"item_gloves",					--假腿
	
	"item_chainmail",
	"item_sobi_mask",
	"item_blight_stone",			--勋章
	
	"item_ring_of_regen",
	"item_staff_of_wizardry",
	"item_recipe_force_staff",		--推推7.14
	"item_boots_of_elves",
	"item_boots_of_elves", 
	"item_ogre_axe",				--魔龙枪
	"item_slippers",
	"item_circlet",
	"item_recipe_wraith_band",		--大推推7.07
	
	"item_talisman_of_evasion",		--大勋章
	
	"item_point_booster",
	"item_staff_of_wizardry",
	"item_ogre_axe",
	"item_blade_of_alacrity",		--蓝杖
	
	"item_boots_of_elves",
	"item_blade_of_alacrity",
	"item_recipe_yasha",			--夜叉
	"item_ultimate_orb",
	"item_recipe_manta",			--分身
	
	"item_broadsword",
	"item_blades_of_attack",
	"item_recipe_lesser_crit" ,
	"item_demon_edge",
	"item_recipe_greater_crit",		--大炮
}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.BuySupportItem()
	utility.BuyCourier()
	utility.ItemPurchase(ItemsToBuy)
end