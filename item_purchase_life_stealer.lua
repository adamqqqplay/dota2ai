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
    "item_magic_wand", --大魔棒7.14
	--"item_armlet", --臂章
    --"item_scepter_shard",
	"item_sange_and_yasha",
	"item_desolator",
	"item_abyssal_blade",
	"item_assault"
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
