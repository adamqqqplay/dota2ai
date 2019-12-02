----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy = 
{ 
	"item_tango",
	"item_flask",
	"item_stout_shield",
	
	"item_gauntlets",
	"item_circlet",
	"item_recipe_bracer",
	"item_branches",
	"item_branches",
	"item_boots",
	"item_belt_of_strength",
	"item_gloves",			--假腿7.21
	"item_magic_stick",
	"item_recipe_magic_wand",		--大魔棒7.14
	"item_blink",					--跳刀
	"item_ring_of_regen",
	"item_staff_of_wizardry",
	"item_recipe_force_staff",		--推推7.14

	"item_vitality_booster",
	"item_energy_booster",
	"item_recipe_aeon_disk",		-- 永恒之盘

	"item_platemail",
	"item_ring_of_health",
	"item_void_stone",
	"item_energy_booster",			--清莲宝珠

	"item_ogre_axe", 
	"item_mithril_hammer",
	"item_recipe_black_king_bar",	--bkb

	"item_crown",
	"item_vitality_booster",		
	"item_ring_of_tarrasque",
	"item_recipe_heart",					--龙心7.20
}

ItemPurchaseSystem.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(ItemsToBuy)
	ItemPurchaseSystem.BuyCourier()
	ItemPurchaseSystem.BuySupportItem()
end