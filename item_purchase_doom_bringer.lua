----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_flask",
	-- "item_bracer",
	"item_boots",
	"item_magic_wand",
	"item_phase_boots",
	"item_hand_of_midas",
	"item_ancient_janggo", --战鼓7.20
	"item_invis_sword", --隐刀
	"item_shivas_guard", --希瓦
	"item_ultimate_scepter",
	"item_ultimate_scepter_2",
	"item_aghanims_shard",
	"item_silver_edge", --大隐刀
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
