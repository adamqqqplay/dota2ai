----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_orb_of_venom", -- 毒球
	"item_tango",
	"item_phase_boots",
	"item_magic_wand", --大魔棒7.14
	"item_ancient_janggo", --战鼓
    "item_ghost",
    "item_ultimate_scepter",
	"item_spirit_vessel", --大骨灰7.07
	"item_force_staff", --推推7.14
	"item_black_king_bar", --BKB
	"item_lotus_orb", --清莲宝珠
	"item_sheepstick",
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem.BuySupportItem()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
