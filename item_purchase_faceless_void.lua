----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_wraith_band",
	"item_quelling_blade", --补刀斧
	"item_power_treads", --假腿7.21
	"item_magic_wand", --大魔棒7.14
	"item_orb_of_corrosion",
	"item_mjollnir",
	"item_manta", --分身
	"item_black_king_bar", --bkb
	-- "item_monkey_king_bar", --金箍棒7.14
	"item_greater_crit",
	"item_butterfly" --蝴蝶
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
