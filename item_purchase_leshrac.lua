----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_null_talisman",
	"item_branches",
	"item_bottle",
	"item_magic_wand", --大魔棒7.14
	"item_boots",
	"item_null_talisman",
	"item_arcane_boots",
	-- "item_veil_of_discord", --纷争7.20
	"item_bloodstone",
	"item_cyclone", --风杖
	"item_aghanims_shard",
	"item_octarine_core",
	"item_ultimate_scepter",
	"item_ultimate_scepter_2",
	"item_shivas_guard", --希瓦
	"item_wind_waker",
	"item_sheepstick"
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
