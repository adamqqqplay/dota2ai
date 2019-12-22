----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_tango",
	"item_quelling_blade", --补刀斧
	"item_enchanted_mango",
	"item_enchanted_mango",
	"item_buckler",
	"item_magic_wand", --大魔棒7.14
	"item_bracer",
	"item_arcane_boots", --秘法鞋
	"item_ancient_janggo",
	"item_mekansm", --梅肯
	"item_recipe_guardian_greaves", --卫士胫甲
	"item_vladmir",
	"item_pipe",
	"item_ultimate_scepter_1", --蓝杖
	"item_lotus_orb", --清莲宝珠
	"item_sheepstick" --羊刀
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	ItemPurchaseSystem.BuyCourier()
	ItemPurchaseSystem.BuySupportItem()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end
