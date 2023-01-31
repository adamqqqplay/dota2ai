----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_flask",
	"item_enchanted_mango",
	"item_magic_wand",
	-- "item_bracer",
	"item_vanguard", 
	"item_phase_boots",
	-- "item_bracer",
	"item_blink", --跳刀
	"item_crimson_guard", --赤红甲
	"item_aghanims_shard",
	"item_pipe", --笛子
	"item_heart", --龙心7.20
	"item_ultimate_scepter", --蓝杖
	"item_ultimate_scepter_2",
	"item_overwhelming_blink",
	"item_assault",
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
