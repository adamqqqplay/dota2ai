----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy = 
{ 
	"item_tango",
	"item_tango",
	"item_enchanted_mango",
	"item_enchanted_mango",
	"item_stout_shield",
	"item_branches",
	"item_branches",
	"item_boots",
	
	"item_magic_stick",
	"item_recipe_magic_wand",		--大魔棒7.14
	
	"item_recipe_vanguard"
	"item_ring_of_health",	
	"item_vitality_booster",		--先锋7.23
	
	"item_blink",					--跳刀
	
	"item_robe",
	"item_chainmail",
	"item_broadsword",				--刃甲
	
	"item_helm_of_iron_will",
	"item_recipe_crimson_guard",	--赤红甲

	"item_vitality_booster",
	"item_energy_booster",
	"item_recipe_aeon_disk",		-- 永恒之盘

	"item_reaver",
	"item_vitality_booster",		
	"item_ring_of_tarrasque",
	"item_recipe_heart",					--龙心7.23
	
	"item_ring_of_health",
	"item_void_stone",				
	"item_platemail",
	"item_energy_booster",			--清莲宝珠

}

ItemPurchaseSystem.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(ItemsToBuy)
end