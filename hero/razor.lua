----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local X = {}
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	-- "item_tango",
	-- "item_wraith_band", --系带
	-- "item_flask",
	-- "item_magic_wand", --大魔棒7.14
	-- "item_phase_boots", --相位7.21
	-- "item_sange_and_yasha", --双刀
	-- "item_black_king_bar", --bkb
	-- "item_ultimate_scepter", --蓝杖
	-- "item_heart",
	-- "item_ultimate_scepter_2",
	-- "item_shivas_guard" --希瓦
	"item_tango",
	"item_wraith_band",
	"item_flask",
	"item_magic_wand",
	"item_arcane_boots",
	"item_eternal_shroud",
	"item_aghanims_shard",
	"item_bloodstone",
	"item_kaya_and_sange",
	"item_heart",
	"item_ultimate_scepter",
	"item_ultimate_scepter_2"
	
	
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)

function X.ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()
end

return X