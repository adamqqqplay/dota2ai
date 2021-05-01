----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	-- "item_ring_of_basilius",
	"item_tango",
	"item_wind_lace",
	"item_boots",
	"item_magic_wand", --大魔棒7.14
	"item_arcane_boots",
	"item_mekansm", --梅肯
    "item_ghost",
    "item_spirit_vessel", --大骨灰
	"item_guardian_greaves", --卫士胫甲
	"item_solar_crest", --大勋章7.20
	"item_sheepstick" --羊刀
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)
 --检查装备列表

function ItemPurchaseThink()
	ItemPurchaseSystem.BuySupportItem() --购买辅助物品	对于辅助英雄保留这一行 --购买信使		对于5号位保留这一行
	ItemPurchaseSystem:ItemPurchaseExtend()
 --购买装备
end
