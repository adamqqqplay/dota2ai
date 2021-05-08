----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_tango",
	"item_enchanted_mango",
	"item_magic_wand", --大魔棒7.14
	"item_boots",
	"item_energy_booster",
	"item_blade_mail", --刃甲
	"item_mekansm", --梅肯
	"item_guardian_greaves", --卫士胫甲
	"item_force_staff",
	"item_pipe", --笛子
	"item_lotus_orb",
	"item_heart" --龙心7.20
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()

	ItemPurchaseSystem.BuySupportItem()
end
