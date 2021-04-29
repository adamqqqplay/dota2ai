----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_quelling_blade",
	"item_gauntlets",
	"item_bottle", -- 魔瓶
	"item_power_treads",
	"item_magic_wand", --大魔棒7.14
	"item_bracer",
	"item_blink", --跳刀
	"item_echo_sabre", --连击刀
	"item_black_king_bar", --bkb
	"item_assault", --强袭
	"item_ultimate_scepter"
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
