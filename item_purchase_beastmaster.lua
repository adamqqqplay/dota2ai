----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_flask",
	"item_enchanted_mango",
	"item_quelling_blade",
	"item_bracer",
	"item_phase_boots", --相位7.21
    "item_magic_wand",
	"item_lifesteal", --祭品
	"item_solar_crest", --大勋章7.20
	"item_black_king_bar", --BKB
	"item_lotus_orb", --清莲宝珠
	"item_heart" --龙心7.20
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
