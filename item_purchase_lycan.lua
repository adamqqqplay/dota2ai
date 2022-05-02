----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_flask",
	"item_power_treads", --假腿7.21
	"item_orb_of_corrosion",
	"item_helm_of_the_dominator",
	"item_vladmir", --祭品7.21
	"item_helm_of_the_overlord", --level 2 helm dominator 7.30
	"item_black_king_bar", --bkb
	"item_assault", --强袭
	"item_heart",
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
