----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local X = {}
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_flask",
	"item_clarity",
	"item_tranquil_boots",
	"item_bracer",
	"item_glimmer_cape", --微光
	"item_force_staff", --推推7.14
	"item_aghanims_shard", 
	"item_black_king_bar", --bkb
	"item_ultimate_scepter", --蓝杖
	"item_ultimate_scepter_2",
	"item_sheepstick", --羊刀
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)

function X.ItemPurchaseThink()
	ItemPurchaseSystem.BuySupportItem() --购买信使		对于5号位保留这一行
	ItemPurchaseSystem:ItemPurchaseExtend()
end

return X