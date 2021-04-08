----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem") --导入通用函数库

local ItemsToBuy =
{
	"item_tango",
	"item_clarity",
	"item_branches",
	"item_branches",
	"item_boots",
	"item_flask",
    "item_magic_stick",
	"item_recipe_magic_wand", --大魔棒7.14
	"item_energy_booster",
	"item_ring_of_regen",
	"item_recipe_headdress",
	"item_branches",
	"item_chainmail",
	"item_recipe_buckler",
	"item_branches",
	"item_recipe_mekansm", --梅肯
	"item_recipe_guardian_greaves", --卫士胫甲
	"item_point_booster",
	"item_staff_of_wizardry",
	"item_ogre_axe",
	"item_blade_of_alacrity", --蓝杖
	"item_ring_of_regen",
	"item_staff_of_wizardry",
	"item_recipe_force_staff", --推推7.14
	"item_ring_of_health",
	"item_void_stone",
	"item_platemail",
	"item_energy_booster" --清莲宝珠
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered) --检查装备列表

function ItemPurchaseThink()
	ItemPurchaseSystem.BuySupportItem() --购买辅助物品	对于辅助英雄保留这一行
	-- ItemPurchaseSystem.BuyCourier() --购买信使		对于5号位保留这一行
	ItemPurchaseSystem.ItemPurchase(Transfered) --购买装备
end
