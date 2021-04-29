----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_quelling_blade",
	"item_soul_ring", --魂戒
	"item_magic_wand", --大魔棒7.14
	"item_power_treads", --假腿7.21
	"item_ancient_janggo", --战鼓7.20
	"item_maelstrom", --电锤7.14
	"item_black_king_bar", --BKB
	"item_blink",
	"item_mjollnir", --大雷锤
	"item_assault", --强袭
	"item_greater_crit" --大炮
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
