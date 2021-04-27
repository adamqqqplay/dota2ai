----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_tango",
	"item_orb_of_venom",
	"item_magic_wand", --大魔棒7.14
	"item_power_treads",
	"item_diffusal_blade", --散失刀
	"item_sange_and_yasha", --双刀
    --"item_mage_slayer",
	"item_black_king_bar", --bkb
	"item_abyssal_blade" --大晕锤
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem.BuySupportItem()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
