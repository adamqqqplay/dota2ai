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
	"item_energy_booster",
	"item_veil_of_discord", --纷争7.20
	"item_cyclone", --风杖
	"item_octarine_core", --玲珑心
	-- "item_mekansm",
	-- "item_uardian_greaves",
	"item_ultimate_scepter",
	"item_shivas_guard" --希瓦
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
