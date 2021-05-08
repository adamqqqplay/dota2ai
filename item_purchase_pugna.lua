----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_mantle",
	"item_circlet",
	"item_mantle",
	"item_null_talisman",
    "item_magic_wand",
	"item_boots",
	"item_null_talisman",
	"item_arcane_boots",
	"item_kaya",
	"item_aether_lens", --以太之镜7.06
	"item_ultimate_scepter",
	"item_black_king_bar", --bkb
	"item_aghanims_shard",
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
