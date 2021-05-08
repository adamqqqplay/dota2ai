----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
--  Contributor: zmcmcc Email:mengzhang@utexas.edu
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_flask",
    "item_magic_stick",
	"item_tranquil_boots",
	"item_urn_of_shadows",
	"item_solar_crest", --大勋章7.20
	"item_ultimate_scepter",
	"item_guardian_greaves",
	"item_pipe",
	"item_lotus_orb", --清莲宝珠
	"item_diffusal_blade" --散失刀
}

local ItemsToBuy1 = {
	"item_wraith_brand",
	"item_tango","item_tango",
	"item_power_treads",
	"item_manta",
	"item_diffusal_blade",
	"item_heart",
	"item_butterfly",
	"item_black_king_bar",
	"item_travel_boots_1",
	"item_travel_boots_2"
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem.BuySupportItem()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
