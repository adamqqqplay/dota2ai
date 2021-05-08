----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_clarity",
	"item_boots",
	"item_flask",
    "item_hand_of_midas",
	"item_arcane_boots",
	"item_aether_lens", --以太之镜7.06
	"item_ultimate_scepter", --蓝杖
    "item_aghanims_shard",
	"item_force_staff", --推推7.14
	"item_cyclone", --风杖
	"item_lotus_orb",
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem.BuySupportItem()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
