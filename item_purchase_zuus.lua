----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_null_talisman",
	"item_clarity",
	"item_bottle",
	"item_boots",
	"item_magic_stick",
	"item_branches",
	"item_branches",
	"item_recipe_magic_wand", --大魔棒7.14
	"item_null_talisman",
	"item_energy_booster",
	"item_veil_of_discord", --纷争
	"item_aether_lens", --以太之镜7.06
	"item_cyclone", --风杖
	"item_ultimate_scepter", --蓝杖
	"item_octarine_core" --玲珑心
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end
