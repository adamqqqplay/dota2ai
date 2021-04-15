----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_quelling_blade", --补刀斧
    "item_bracer",
	"item_magic_wand", --大魔棒7.14
    "item_gloves",
    "item_boots",
    "item_recipe_hand_of_midas",
    "item_belt_of_strength",
    "item_gloves",
    "item_radiance",
	"item_black_king_bar", --bkb
    "item_blink",
	"item_assault", --强袭
	"item_ultimate_scepter", --蓝杖
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
