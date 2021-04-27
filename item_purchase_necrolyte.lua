----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_null_talisman",
	"item_tango",
	"item_enchanted_mango",
	"item_null_talisman",
	"item_boots",
	"item_magic_wand", --大魔棒7.14
	"item_veil_of_discord", --纷争7.20
	"item_arcane_boots",
	"item_holy_locket",
	"item_mekansm", --梅肯
    "item_shivas_guard", --希瓦
    "item_bloodthorn",
	"item_ultimate_scepter", --蓝杖
	"item_guardian_greaves", --卫士胫甲
	"item_black_king_bar", --bkb
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
