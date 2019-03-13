----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy = 
{ 
	"item_tango",
	"item_flask",
	"item_enchanted_mango",
	"item_enchanted_mango",
	"item_stout_shield",
	"item_branches",
	"item_branches",
	"item_gauntlets",
	"item_circlet",
	"item_recipe_bracer",

	
	"item_boots",	
	"item_belt_of_strength",
	"item_gloves",			--假腿7.21
	
	"item_magic_stick",
	"item_recipe_magic_wand",		--大魔棒7.14
	
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

	"item_vitality_booster",
	"item_energy_booster",
	"item_recipe_aeon_disk",		-- 永恒之盘
	
	"item_point_booster",
	"item_vitality_booster",
	"item_energy_booster",
	"item_mystic_staff",			--玲珑心
	
	"item_platemail",
	"item_mystic_staff",
	"item_recipe_shivas_guard" ,	--希瓦
	
	"item_crown",
	"item_vitality_booster",		
	"item_ring_of_tarrasque",
	"item_recipe_heart",					--龙心7.20
}

ItemPurchaseSystem.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(ItemsToBuy)
end