----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_tango",
	"item_quelling_blade", --补刀斧
	"item_wraith_band", --系带
	"item_flask",
	"item_phase_boots",
	"item_radiance",
	"item_manta", --分身
	"item_diffusal_blade", --散失刀
	"item_heart", --龙心7.20
	"item_black_king_bar",
	"item_butterfly",
    "item_ultimate_scepter",
    -- "item_recipe_ultimate_scepter",
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
