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
	"item_clarity",
	"item_magic_stick",
	"item_arcane_boots", --秘法鞋
	"item_force_staff", --推推7.14
	"item_ghost",
	"item_rod_of_atos", --阿托斯7.20
	"item_cyclone", --风杖
	"item_ultimate_scepter", --蓝杖
	"item_mekansm",
	"item_guardian_greaves",
	"item_dragon_lance",
	"item_hurricane_pike",
	"item_wind_waker",
	"item_ultimate_scepter_2",
	"item_sheepstick",
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)

function X.ItemPurchaseThink()
	ItemPurchaseSystem.BuySupportItem() --购买信使		对于5号位保留这一行
	ItemPurchaseSystem:ItemPurchaseExtend()
end

return X