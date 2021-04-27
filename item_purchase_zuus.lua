----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_null_talisman",
	"item_clarity",
	"item_bottle",
	"item_boots",
	"item_magic_wand", --大魔棒7.14
	"item_arcane_boots",
	"item_veil_of_discord", --纷争
	"item_aether_lens", --以太之镜7.06
	"item_cyclone", --风杖
	"item_ultimate_scepter", --蓝杖
	"item_octarine_core" --玲珑心
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
