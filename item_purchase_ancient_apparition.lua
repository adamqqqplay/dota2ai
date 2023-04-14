----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_clarity",
	"item_branches",
	"item_branches",
	"item_boots",
	-- "item_flask",
	"item_magic_wand",
	"item_arcane_boots",
	"item_glimmer_cape", --微光
	"item_ghost",
	-- "item_cyclone", --风杖
	"item_ultimate_scepter", --蓝杖
    "item_hurricane_pike",
	"item_moon_shard",
	"item_sheepstick", --羊刀
	-- "item_lotus_orb", --清莲宝珠
	-- "item_wind_waker",
	"item_ultimate_scepter_2",
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem.BuySupportItem()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
