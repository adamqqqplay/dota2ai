----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local utility = require( GetScriptDirectory().."/utility" ) 

local ItemsToBuy = 
{ 
	"item_tango",
	"item_clarity",
	"item_branches",
	"item_branches",
	"item_magic_stick",
	"item_recipe_magic_wand",		--大魔棒7.14

	"item_boots",	
	"item_energy_booster",			--秘法鞋

	"item_circlet",
	"item_ring_of_protection",
	"item_recipe_urn_of_shadows",	
	"item_infused_raindrop",		--骨灰盒7.06
	
	"item_cloak",
	"item_shadow_amulet",			--微光
	
	"item_ring_of_regen",
	"item_staff_of_wizardry",
	"item_recipe_force_staff",		--推推7.14

	"item_vitality_booster",
	"item_wind_lace",
	"item_recipe_spirit_vessel",	--大骨灰7.07
	
	"item_ring_of_regen",
	"item_branches",
	"item_recipe_headdress",
	"item_chainmail",
	"item_branches",
	"item_recipe_buckler" ,
    "item_recipe_mekansm",			--梅肯
    "item_recipe_guardian_greaves",	--卫士胫甲
	
	"item_mystic_staff",
	"item_ultimate_orb",
	"item_void_stone",				--羊刀
}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.BuySupportItem()
	utility.BuyCourier()
	utility.ItemPurchase(ItemsToBuy)
end