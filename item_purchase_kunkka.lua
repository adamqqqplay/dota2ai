----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")


local p = {
    "item_tango",
    "item_quelling_blade", --补刀斧
    "item_magic_wand", --大魔棒7.14
    "item_bracer",
    "item_phase_boots", --相位7.21
    "item_invis_sword", --隐刀
    "item_black_king_bar", --bkb
    "item_greater_crit", --大炮
    "item_ultimate_scepter",
    "item_silver_edge",
    "item_assault",
}
ItemPurchaseSystem:CreateItemInformationTable(GetBot(), p)

function ItemPurchaseThink()
    ItemPurchaseSystem:ItemPurchaseExtend()
end
