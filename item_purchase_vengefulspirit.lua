----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_clarity",
	-- "item_ring_of_basilius",
    "item_magic_stick",
	"item_power_treads", --假腿7.21
	"item_medallion_of_courage", --勋章
	"item_force_staff", --推推7.14
	"item_solar_crest", --大勋章7.20
	"item_dragon_lance", --魔龙枪
	"item_hurricane_pike", --大推推7.20
	"item_glimmer_cape",
	"item_black_king_bar",
	"item_ultimate_scepter",
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem.BuySupportItem()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
