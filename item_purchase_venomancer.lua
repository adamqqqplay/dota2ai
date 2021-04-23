----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_wraith_band", --系带
	"item_tango",
	"item_tango",
    "item_magic_stick",
	"item_wraith_band", --系带
	"item_boots",
    "item_branches",
    "item_branches",
    "item_recipe_magic_wand",
	"item_energy_booster",
	"item_veil_of_discord", --纷争7.20
	"item_hurricane_pike", --大推推7.20
	"item_mekansm", --梅肯
	"item_buckler",
	"item_recipe_guardian_greaves", --卫士胫甲
	"item_ultimate_scepter", --蓝杖
	"item_black_king_bar",
	"item_lotus_orb" --清莲宝珠
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem.BuySupportItem()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
