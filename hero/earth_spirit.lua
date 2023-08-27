----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local X = {}
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
	"item_cyclone", --风杖
	"item_ultimate_scepter", --蓝杖
	"item_wind_waker",
	"item_ultimate_scepter_2",
	"item_sheepstick",
	"item_overwhelming_blink",
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)

function X.ItemPurchaseThink()
	ItemPurchaseSystem.BuySupportItem() --购买信使		对于5号位保留这一行
	ItemPurchaseSystem:ItemPurchaseExtend()
end

return X