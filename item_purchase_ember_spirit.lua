----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_quelling_blade",
	"item_circlet",
	"item_bottle",
	"item_wraith_band",
	"item_phase_boots",
    "item_bfury",
	"item_magic_wand", --大魔棒7.14
    "item_lesser_crit",
	"item_black_king_bar",
	"item_greater_crit",
    "item_ultimate_scepter",
    "item_aghanims_shard",
    "item_octarine_core", --玲珑心
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
