----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_tango",
	"item_quelling_blade",
	"item_enchanted_mango",
	"item_enchanted_mango",
	"item_branches",
	"item_branches",
	"item_magic_stick",
	"item_recipe_magic_wand", --大魔棒7.14
	"item_bracer",
	"item_boots",
	"item_bracer",
	--"item_energy_booster",
	"item_arcane_boots", --秘法
	"item_mekansm", --梅肯
	"item_vladmir", --祭品7.21
	"item_recipe_guardian_greaves", --卫士胫甲
	"item_hood_of_defiance", --挑战
	"item_ring_of_regen",
	"item_recipe_headdress",
	"item_branches",
	"item_recipe_pipe", --笛子
	"item_ultimate_scepter", --蓝杖
	"item_lotus_orb" --清莲宝珠
}
local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	ItemPurchaseSystem.BuyCourier()
	ItemPurchaseSystem.BuySupportItem()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end
