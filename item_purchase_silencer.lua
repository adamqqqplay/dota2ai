----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_tango",
	"item_null_talisman",
    "item_magic_stick",
	"item_power_treads", --假腿7.21
    "item_witch_blade",
	"item_hurricane_pike", --大推推7.20
	"item_orchid",
    "item_bloodthorn",
    "item_sheepstick", --羊刀
    "item_gleipnir",
	"item_ultimate_scepter", --蓝杖
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink() --购买信使
	ItemPurchaseSystem.BuySupportItem()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
