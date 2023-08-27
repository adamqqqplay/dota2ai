----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local X = {}
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	-- "item_tango",
	"item_quelling_blade",
	"item_hat",
	"item_phase_boots", --相位7.21
	"item_wraith_band",
	-- "item_wraith_band",
	"item_falcon_blade",
	"item_maelstrom",
	"item_aghanims_shard",
	"item_yasha",
	"item_manta", 
	"item_basher",
	"item_abyssal_blade", --大晕锤
	"item_butterfly", --蝴蝶
	"item_ultimate_scepter",
	"item_swift_blink",
	"item_ultimate_scepter_2",
	"item_skadi",
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)

function X.ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()
end

return X