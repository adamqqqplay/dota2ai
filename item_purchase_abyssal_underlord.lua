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
	"item_buckler", --玄冥盾牌
	"item_boots",
	"item_magic_wand", --大魔棒7.14
	"item_bracer",
	"item_energy_booster", --秘法
	"item_mekansm", --梅肯
	"item_hood_of_defiance", --挑战
	"item_crimson_guard", --赤红甲
	"item_ring_of_regen",
	"item_recipe_headdress",
	"item_branches",
	"item_recipe_pipe", --笛子
	--"item_vladmir",			--祭品7.21
	"item_recipe_guardian_greaves", --卫士胫甲
	"item_lotus_orb", --清莲宝珠
	--"item_radiance",			--辉耀
	"item_shivas_guard" --希瓦
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end
