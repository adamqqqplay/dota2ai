----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6be
--	Author: adamqqq		Email:adamqqq@163.com
--  Contributor: zmcmcc Email:mengzhang@utexas.edu
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_enchanted_mango",
	"item_enchanted_mango",
	"item_enchanted_mango",
	"item_flask",
	"item_buckler",
	"item_magic_wand", --大魔棒7.14
	"item_boots",
	"item_hand_of_midas", --点金
	"item_energy_booster", --秘法鞋
	"item_urn_of_shadows",
	"item_blink",
	"item_ultimate_scepter_1", --蓝杖
	"item_force_staff", --推推
	"item_mekansm", --梅肯
	"item_recipe_guardian_greaves", --卫士胫甲
	"item_crown",
	"item_staff_of_wizardry",
	"item_recipe_dagon",
	"item_recipe_dagon",
	"item_recipe_dagon",
	"item_sheepstick",
	"item_recipe_dagon",
	"item_recipe_dagon" --红杖
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	ItemPurchaseSystem.BuyCourier()
	ItemPurchaseSystem.BuySupportItem()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end
