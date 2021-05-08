----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_tango",
	"item_flask",
	"item_quelling_blade", --补刀斧
	"item_bracer",
	"item_magic_wand",
	"item_phase_boots", --相位7.21
	"item_invis_sword", --隐刀
	"item_blade_mail", --刃甲
	"item_ultimate_orb",
	"item_recipe_silver_edge", --大隐刀
	"item_black_king_bar", --bkb
	"item_assault", --强袭
	"item_heart" --龙心7.20
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
