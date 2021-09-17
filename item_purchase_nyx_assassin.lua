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
	"item_flask",
	"item_magic_stick", --大魔棒7.14
	"item_boots",
	"item_hand_of_midas", --点金
	"item_arcane_boots",
	"item_blink",
    "item_dagon",
	"item_ultimate_scepter", --蓝杖
	"item_force_staff", --推推
	"item_guardian_greaves",
	"item_dagon_3",
	"item_recipe_dagon",
	"item_overwhelming_blink",
	"item_ultimate_scepter_2",
	"item_sheepstick",
	"item_dagon_5",
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem.BuySupportItem()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
