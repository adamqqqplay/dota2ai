----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy = 
{ 
	"item_null_talisman",
	"item_tango",
	"item_enchanted_mango"
	"item_null_talisman",

	"item_boots",
	"item_magic_wand",		--大魔棒7.14

	"item_veil_of_discord",	--纷争7.20


	"item_belt_of_strength",
	"item_gloves",			--假腿7.21
	"item_orchid",			--紫苑

	"item_black_king_bar",	--bkb

	


	"item_ultimate_scepter_1",		--蓝杖
	"item_shivas_guard",	--希瓦
	"item_lesser_crit",
	"item_recipe_bloodthorn",		--血棘
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end