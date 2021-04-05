----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_flask",
	"item_quelling_blade", --补刀斧
	"item_magic_wand", --大魔棒7.14
	"item_power_treads", --假腿7.21
	"item_echo_sabre", --连击刀
	"item_blink",
	"item_blade_mail", --刃甲
	"item_black_king_bar", --bkb
	"item_assault", --强袭
	"item_ultimate_scepter" --蓝杖
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end
