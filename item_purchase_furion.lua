----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
--  Contributor: zmcmcc Email:mengzhang@utexas.edu
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")
local AbilityExtensions = require(GetScriptDirectory().."/util/AbilityAbstraction")


local p = {
    "item_tango",
    "item_flask",
    "item_blight_stone",
    "item_null_talisman",
    "item_power_treads",
    "item_invis_sword",
    "item_desolator",
    "item_orchid",
    "item_black_king_bar",
    "item_bloodthorn",
    "item_ultimate_scepter",
    "item_silver_edge",
}
ItemPurchaseSystem:CreateItemInformationTable(GetBot(), p)

function ItemPurchaseThink()
    ItemPurchaseSystem:ItemPurchaseExtend()
end
