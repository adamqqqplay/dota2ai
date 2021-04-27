----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
--  Contributor: zmcmcc Email:mengzhang@utexas.edu
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_tango",
	"item_bracer",
	"item_phase_boots",
    "item_magic_stick",
	"item_invis_sword", --隐刀
	"item_solar_crest",
	"item_black_king_bar", --bkb
	"item_ultimate_scepter", --蓝杖
	"item_aghanims_shard",
	"item_silver_edge" --大隐刀
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()

	ItemPurchaseSystem.BuySupportItem()
end
