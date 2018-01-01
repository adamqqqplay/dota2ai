----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
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
	"item_energy_booster",			--秘法鞋
	"item_magic_stick",
	"item_enchanted_mango",			--大魔棒7.07
	
	"item_circlet",
	"item_ring_of_protection",
	"item_recipe_urn_of_shadows",	
	"item_infused_raindrop",		--骨灰盒7.06
	"item_vitality_booster",
	"item_wind_lace",
	"item_recipe_spirit_vessel",	--大骨灰7.07
	
	"item_ring_of_regen",
	"item_recipe_headdress",
	"item_branches",
	"item_chainmail",
	"item_recipe_buckler" ,
	"item_branches",
    "item_recipe_mekansm",			--梅肯
	
	"item_recipe_guardian_greaves",	--卫士胫甲
	
	"item_ring_of_regen",
	"item_staff_of_wizardry",
	"item_recipe_force_staff",		--推推
	
	"item_ring_of_health",
	"item_void_stone",				
	"item_platemail",
	"item_energy_booster",			--清莲宝珠
	
	"item_platemail", 
	"item_chainmail", 
	"item_hyperstone",
	"item_recipe_assault",			--强袭	
}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.ItemPurchase(ItemsToBuy)
end