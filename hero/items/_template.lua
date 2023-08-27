----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
--导入通用函数库
local X = {}
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_clarity",
	"item_wind_lace",
	"item_branches",
	"item_branches",
	"item_boots",
	"item_circlet",
	"item_magic_stick", --大魔棒
	"item_arcane_boots",

	"item_mantle",
	"item_circlet",
	"item_recipe_null_talisman", --无用挂件
	"item_mantle",
	"item_circlet",
	"item_recipe_null_talisman", --无用挂件
	"item_helm_of_iron_will",
	"item_recipe_veil_of_discord", --纷争

	"item_ring_of_regen",
	"item_recipe_headdress",
	"item_branches",
	"item_chainmail",
	"item_recipe_buckler",
	"item_branches",
	"item_recipe_mekansm", --梅肯
	"item_ring_of_regen",
	"item_staff_of_wizardry",
	"item_recipe_force_staff", --推推

	"item_recipe_guardian_greaves", --卫士胫甲

	"item_wind_lace",
	"item_void_stone",
	"item_staff_of_wizardry",
	"item_recipe_cyclone", --风杖

}

--检查装备列表
ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)

function ItemPurchaseThink()
	--购买辅助物品	对于辅助英雄保留这一行
	ItemPurchaseSystem.BuySupportItem()
	--购买装备
	ItemPurchaseSystem.ItemPurchase(ItemsToBuy)
end

return X