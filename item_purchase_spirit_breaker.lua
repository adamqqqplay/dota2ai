----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_orb_of_venom",
	"item_tango",
	"item_magic_wand", --大魔棒7.14
	"item_bracer",
	"item_bracer",
	"item_power_treads", --假腿7.21
	"item_urn_of_shadows", --骨灰盒7.06
	"item_blade_mail",
	"item_echo_sabre", --连击刀
	"item_black_king_bar", --bkb
	"item_sange_and_yasha",
	"item_heart" --龙心7.20
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem.BuySupportItem()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
