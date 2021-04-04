----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_magic_stick",
	"item_quelling_blade", --补刀斧
	"item_enchanted_mango",
	"item_bracer",
	"item_phase_boots",
	"item_branch",
	"item_branch",
	"item_recipe_magic_wand",
	"item_bracer",
	"item_blink", --跳刀
	"item_crimson_guard", --赤红甲
	"item_pipe", --笛子
	"item_ultimate_scepter", --蓝杖
	"item_heart" --龙心7.20
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end
