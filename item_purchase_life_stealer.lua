----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_tango",
    "item_magic_stick",
	"item_quelling_blade", --补刀斧
	"item_orb_of_venom",
	"item_phase_boots", --相位7.21
	"item_orb_of_corrosion",
	"item_desolator",
	"item_basher",
	"item_abyssal_blade",
	"item_sange_and_yasha",
	"item_assault"
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
