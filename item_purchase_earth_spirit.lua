----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem") --导入通用函数库

local ItemsToBuy =
{
	"item_tango",
	"item_clarity",
	"item_orb_of_venom", --毒球
	"item_boots",
	"item_bracer",
	"item_magic_wand", --大魔棒7.14
	"item_spirit_vessel", --大骨灰7.07
	"item_glimmer_cape",
	"item_blink", --跳刀
	"item_cyclone",	--风杖
	"item_ultimate_scepter" --蓝杖
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)
 --检查装备列表

function ItemPurchaseThink()
	ItemPurchaseSystem.BuySupportItem() --购买辅助物品	对于辅助英雄保留这一行 --购买信使		对于5号位保留这一行
	ItemPurchaseSystem:ItemPurchaseExtend()
 --购买装备
end
