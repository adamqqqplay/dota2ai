----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local X = {}
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem") --导入通用函数库

local ItemsToBuy =
{
	"item_tango",
	"item_tango",
	"item_clarity",
	"item_wind_lace",
	"item_magic_stick",
	"item_null_talisman",
	"item_tranquil_boots",
	"item_glimmer_cape",
	"item_ultimate_scepter", --蓝杖
	"item_force_staff", --推推7.14
	"item_ultimate_scepter_2",
	"item_sheepstick", --羊刀
	"item_boots_of_bearing"
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)

function X.ItemPurchaseThink()
	ItemPurchaseSystem.BuySupportItem() --购买信使		对于5号位保留这一行
	ItemPurchaseSystem:ItemPurchaseExtend()
end

return X