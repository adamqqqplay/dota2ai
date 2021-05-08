----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_flask",
	"item_quelling_blade",
	"item_wraith_band",
	"item_magic_wand",
	"item_phase_boots", --相位
	"item_recipe_magic_wand", --大魔棒7.14
	"item_blade_mail", --刃甲
    "item_orb_of_corrosion",
	"item_sange_and_yasha",
	"item_black_king_bar", --bkb
	"item_basher", --晕锤7.14
	"item_mjollnir", --大电锤
	"item_vanguard", --先锋盾
	"item_recipe_abyssal_blade", --大晕锤
	"item_butterfly" --蝴蝶
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
