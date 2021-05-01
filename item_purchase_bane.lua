----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_tango",
	"item_clarity",
	"item_boots",
	-- "item_ring_of_basilius", --圣殿
	"item_magic_wand", --大魔棒7.14
	"item_energy_booster",
	"item_null_talisman",
	"item_aether_lens", --以太之镜7.06
	"item_glimmer_cape", --微光
	"item_cyclone", --风杖
	"item_ultimate_scepter", --蓝杖
	"item_sheepstick", --羊刀
	"item_mekansm", --梅肯
	"item_guardian_greaves" --卫士胫甲
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem.BuySupportItem()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
