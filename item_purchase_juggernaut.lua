----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_tango",
	"item_quelling_blade",
	"item_wraith_band",
	"item_magic_wand", --大魔棒7.14
	"item_wraith_band",
	"item_phase_boots", --相位7.21
	"item_maelstrom",
	"item_yasha",
	"item_manta", 
	"item_aghanims_shard",
    "item_basher",
	"item_abyssal_blade", --大晕锤
	"item_butterfly", --蝴蝶
    "item_ultimate_scepter",
    "item_swift_blink",
    "item_ultimate_scepter_2",
	"item_skadi",
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
