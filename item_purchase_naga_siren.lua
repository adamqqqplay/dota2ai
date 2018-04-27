----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.5
--	Author: adamqqq		Email:adamqqq@163.com
--  Contributor: zmcmcc Email:mengzhang@utexas.edu
----------------------------------------------------------------------------
local utility = require( GetScriptDirectory().."/utility" ) 

local ItemsToBuy = 
{ 
	"item_tango",
	"item_stout_shield",
	"item_branches",
	"item_branches",
	"item_magic_stick",
	"item_recipe_magic_wand",			--大魔棒7.14

	"item_boots",	
	"item_ring_of_regen",			--绿鞋
	"item_wind_lace",

	"item_slippers",
	"item_circlet",
	"item_recipe_wraith_band", --系带
	"item_ring_of_protection",
	"item_sobi_mask",				--天鹰

	"item_blade_of_alacrity",
	"item_blade_of_alacrity",
	"item_robe",
	"item_recipe_diffusal_blade",	--散失刀
	
	"item_ring_of_regen",
	"item_staff_of_wizardry",
	"item_recipe_force_staff",		--推推7.14
	
	"item_point_booster",
	"item_staff_of_wizardry",
	"item_ogre_axe",
	"item_blade_of_alacrity",		--蓝杖

	"item_chainmail",
	"item_sobi_mask",
	"item_blight_stone",			--勋章
	"item_talisman_of_evasion",		--大勋章

	"item_ring_of_health",
	"item_void_stone",				
	"item_platemail",
	"item_energy_booster",			--清莲宝珠
	

}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.BuyCourier()
	utility.BuySupportItem()
	utility.ItemPurchase(ItemsToBuy)
end