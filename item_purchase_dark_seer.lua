----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local utility = require( GetScriptDirectory().."/utility" ) 

local ItemsToBuy = 
{ 
	"item_tango",
	"item_flask",
	"item_ring_of_regen",
	"item_clarity",

	"item_gauntlets",
	"item_gauntlets",
	"item_recipe_soul_ring",  		--魂戒

	"item_boots",

	
	"item_magic_stick",
	"item_branches",
	"item_branches",
	"item_enchanted_mango",			--大魔棒7.07

	"item_energy_booster",			--秘法鞋	

	"item_stout_shield",
	"item_cloak",
	"item_ring_of_health",
	"item_ring_of_regen",			--挑战
	"item_ring_of_regen",
	"item_recipe_headdress",
	"item_branches",
	"item_recipe_pipe" ,			--笛子
	
	"item_ring_of_regen",
	"item_recipe_headdress",
	"item_branches",
	"item_chainmail",
	"item_recipe_buckler" ,
	"item_branches",
    "item_recipe_mekansm",			--梅肯
	"item_recipe_guardian_greaves",	--卫士胫甲
	
	"item_blink",					--跳刀
	
	"item_platemail",
	"item_ring_of_health",
	"item_void_stone",
	"item_energy_booster",			--清莲宝珠
	
	"item_platemail",
	"item_mystic_staff",
	"item_recipe_shivas_guard" ,	--希瓦
	
	"item_vitality_booster",
	"item_vitality_booster",		
	"item_reaver",					--龙心7.06
}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.ItemPurchase(ItemsToBuy)
end