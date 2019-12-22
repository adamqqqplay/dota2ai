----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_null_talisman",
	"item_tango",
	"item_flask",
	"item_magic_stick",
	"item_boots",
	"item_javelin",
	"item_blades_of_attack",
	"item_chainmail", --相位7.21
	"item_mithril_hammer", --电锤7.14
	"item_blink",
	"item_black_king_bar",
	"item_monkey_king_bar",
	"item_ultimate_scepter_1",
	"item_sphere", --林肯
	"item_hyperstone",
	"item_recipe_mjollnir" --大雷锤
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end
