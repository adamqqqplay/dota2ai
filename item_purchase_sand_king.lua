----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_quelling_blade", --补刀斧
	"item_enchanted_mango",
	"item_bracer",
	"item_arcane_boots", --秘法
	"item_magic_wand", --大魔棒7.14
	"item_veil_of_discord", --纷争7.20
	"item_blink", --跳刀
	"item_ultimate_scepter", --蓝杖
	"item_black_king_bar", --bkb
	"item_lotus_orb" --清莲宝珠
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem.BuySupportItem()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
