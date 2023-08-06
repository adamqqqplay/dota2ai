----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local X = {}
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	-- "item_flask",
	"item_enchanted_mango",
	"item_enchanted_mango",
	"item_quelling_blade",
	-- "item_bracer",
	"item_falcon_blade", 
	"item_phase_boots", --相位
	-- "item_magic_wand",
	"item_vanguard", --先锋
	"item_crimson_guard",
	"item_heart", --龙心7.20
	"item_black_king_bar", --BKB
	"item_shivas_guard",
	"item_ultimate_scepter",
	"item_ultimate_scepter_2",
	"item_lotus_orb",
}
ItemPurchaseSystem:CreateItemInformationTable(GetBot(), p)

function X.ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()
end

return X