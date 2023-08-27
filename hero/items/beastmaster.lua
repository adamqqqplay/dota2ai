----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local X = {}
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_quelling_blade",
	"item_flask",
	"item_enchanted_mango",
	-- "item_bracer",
	"item_phase_boots", --相位7.21
	"item_magic_wand",
	"item_helm_of_the_dominator",
	"item_vladmir", --祭品
	"item_black_king_bar", --BKB
	"item_helm_of_the_overlord", --level 2 helm dominator 7.30
	"item_assault",
	"item_ultimate_scepter",
	"item_ultimate_scepter_2",
	"item_heart",
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)

function X.ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()
end

return X