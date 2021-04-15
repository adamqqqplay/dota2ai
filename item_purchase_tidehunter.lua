----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_quelling_blade",
	"item_flask",
	"item_enchanted_mango",
	"item_enchanted_mango",
	"item_soul_ring",
	"item_phase_boots",
	"item_magic_wand",
	"item_vladmir",
	"item_medallion_of_courage",
	"item_pipe",
	"item_blink", --跳刀
	"item_ultimate_orb",
	"item_wind_lace",
	"item_recipe_solar_crest",
	"item_shivas_guard" --希瓦
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
