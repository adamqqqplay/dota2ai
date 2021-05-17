----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_tango",
	"item_quelling_blade",
	"item_bracer",
	"item_magic_wand", --大魔棒7.14
	"item_power_treads", --假腿7.21
	--"item_armlet", --臂章
	"item_manta", --分身
	"item_black_king_bar",
	"item_heart", --龙心7.20
	"item_assault" --强袭
}
ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)

function ItemPurchaseThink()
    ItemPurchaseSystem:ItemPurchaseExtend()
end
