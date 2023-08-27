----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local X = {}
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	-- "item_tango",
	-- "item_flask",
	"item_clarity",
	"item_boots",
	"item_magic_wand", --大魔棒7.14
	"item_arcane_boots", --秘法
	"item_blink", --跳刀
	"item_force_staff", --推推7.14
	"item_ultimate_scepter", --蓝杖
	"item_aeon_disk",
	"item_ultimate_scepter_2",
	"item_black_king_bar",
	"item_overwhelming_blink",
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)

function X.ItemPurchaseThink()
	ItemPurchaseSystem.BuySupportItem() --购买信使		对于5号位保留这一行
	ItemPurchaseSystem:ItemPurchaseExtend()
end

return X