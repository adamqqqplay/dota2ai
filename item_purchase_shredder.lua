----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
--  Contributor: zmcmcc Email:mengzhang@utexas.edu
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_flask",
	"item_quelling_blade", --补刀斧
	"item_soul_ring",
	"item_magic_wand", --大魔棒7.14
	"item_arcane_boots", --秘法鞋
	"item_bloodstone",
	"item_pipe", --笛子
	"item_cyclone",
	"item_ultimate_scepter", --蓝杖
	"item_shivas_guard", --希瓦
	"item_octarine_core",
	"item_black_king_bar",
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end
