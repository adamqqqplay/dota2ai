----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_tango",
	"item_clarity",
	"item_boots",
	"item_bracer",
    "item_magic_wand",
	"item_tranquil_boots",
	"item_urn_of_shadows",
	"item_blade_mail",
	"item_ultimate_scepter",
	"item_blink",
	"item_glimmer_cape", --微光
	"item_force_staff",
	"item_lotus_orb", --清莲宝珠
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem.BuySupportItem()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
