----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_wraith_band", --系带
	"item_flask",
	"item_wraith_band", --系带
	"item_phase_boots", --相位7.21
	"item_magic_wand",
	"item_dragon_lance",
	"item_mjollnir",
	"item_manta",
	"item_skadi", --冰眼
	"item_butterfly",
	"item_hurricane_pike",
	-- "item_black_king_bar",
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)
 --检查装备列表

function ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()
 --购买装备
end
