----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_tango",
	"item_wraith_band",
	"item_power_treads", --假腿7.21
	-- "item_wraith_band",
	-- "item_magic_wand", --大魔棒7.14
	"item_diffusal_blade", 
	"item_gungir", 
	"item_desolator", --黯灭
	"item_orchid", --紫苑
	"item_black_king_bar", --bkb
	"item_monkey_king_bar", --金箍棒7.14
	-- "item_sheepstick",
	"item_bloodthorn", --血棘
	"item_greater_crit",
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
