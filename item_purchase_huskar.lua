----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_tango",
	"item_bracer",
	"item_bracer",
	"item_magic_wand", --大魔棒7.14
	"item_power_treads", --假腿7.21
	--"item_armlet", --臂章
	"item_heavens_halberd", --天堂
	"item_hurricane_pike", --大推推7.20
	"item_ultimate_scepter", --蓝杖
	"item_satanic" --撒旦7.07
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
