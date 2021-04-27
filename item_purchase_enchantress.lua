----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_tango",
	"item_clarity",
	"item_orb_of_venom",
	"item_null_talisman",
	"item_null_talisman",
	"item_boots",
	"item_magic_wand", --大魔棒7.14
	"item_power_treads",
	"item_dragon_lance", --魔龙枪
    "item_black_king_bar",
    "item_ultimate_scepter", --蓝杖
	"item_force_staff", --推推7.14
	"item_recipe_hurricane_pike", --大推推7.28
	"item_sheepstick", --羊刀
	"item_monkey_king_bar" --金箍棒7.14
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
