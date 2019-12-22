----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_flask",
	"item_enchanted_mango",
	"item_enchanted_mango",
	"item_quelling_blade",
	"item_bracer",
	"item_phase_boots", --相位7.21
	"item_magic_wand", --大魔棒7.14
	"item_vladmir", --祭品7.21
	"item_blink", --跳刀
	"item_black_king_bar", --BKB
	"item_ultimate_scepter_1", --蓝杖
	"item_lotus_orb", --清莲宝珠
	"item_assault" --强袭
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end
