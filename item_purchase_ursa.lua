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
	"item_orb_of_venom",
	"item_boots",
	"item_magic_wand", --大魔棒7.14
	"item_phase_boots",
	"item_orb_of_corrosion",
	"item_lifesteal",
	"item_diffusal_blade",
	"item_blink", --跳刀
	"item_basher", --晕锤7.14
	"item_black_king_bar", --bkb
	"item_aghanims_shard",
	"item_basher",
	"item_ultimate_scepter",
	"item_abyssal_blade",
	"item_overwhelming_blink",
	"item_ultimate_scepter_2",
	"item_skadi",
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
