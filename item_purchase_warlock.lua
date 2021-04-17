----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_clarity",
	"item_branches",
	"item_branches",
	"item_boots",
    "item_magic_stick",
	"item_recipe_magic_wand", --大魔棒7.14
	"item_energy_booster",
	"item_cloak",
	"item_shadow_amulet", --微光
	"item_ring_of_regen",
	"item_staff_of_wizardry",
	"item_recipe_force_staff", --推推7.14
    "item_ghost",
    "item_ultimate_scepter",
    "item_refresher",
    "item_sheepstick",
	--"item_point_booster",
	--"item_staff_of_wizardry",
	--"item_ogre_axe",
	--"item_blade_of_alacrity", --蓝杖
	--"item_ring_of_health",
	--"item_void_stone",
	--"item_ring_of_health",
	--"item_void_stone",
	--"item_recipe_refresher", --刷新球
	--"item_mystic_staff",
	--"item_ultimate_orb",
	--"item_void_stone" --羊刀
}

ItemPurchaseSystem.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	ItemPurchaseSystem.BuySupportItem()
	ItemPurchaseSystem.ItemPurchase(ItemsToBuy)
end
