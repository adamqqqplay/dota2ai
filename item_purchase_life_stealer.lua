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
	"item_orb_of_venom",
	"item_phase_boots", --相位7.21
	"item_blight_stoe",
	"item_flaffly_hat",
	"item_recipe_orb_of_corrosion",
	"item_magic_wand", --大魔棒7.14
	"item_armlet", --臂章
	"item_sange_and_yasha",
	"item_desolator",
	"item_abyssal_blade",
	"item_assault"
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end
