----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local p = {
    "item_tango",
    "item_tango",
    "item_flask",
    "item_quelling_blade",
    "item_wraith_band",
    "item_power_treads",
    "item_orb_of_corrosion",
    "item_bfury",
    "item_manta",
    "item_abyssal_blade",
    "item_black_king_bar",
    "item_butterfly",
    "item_ultimate_scepter",
    "item_recipe_ultimate_scepter",
    "item_moon_shard",
}
ItemPurchaseSystem:CreateItemInformationTable(GetBot(), p)

function ItemPurchaseThink()
    ItemPurchaseSystem:ItemPurchaseExtend()
end
