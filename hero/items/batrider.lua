----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local X = {}
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem") --导入通用函数库

local ItemsToBuy =
{
	"item_tango",
	"item_enchanted_mango",
	"item_wind_lace",
	"item_magic_wand",
	"item_tranquil_boots",
	"item_blink", --跳刀
	"item_force_staff", --推推7.14
	"item_ultimate_scepter", --蓝杖
	"item_black_king_bar", --bkb
	"item_cyclone", --风杖
	"item_ultimate_scepter_2",
	"item_lotus_orb",
	"item_arcane_blink",
	"item_wind_waker",
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)

function X.ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()
end

return X