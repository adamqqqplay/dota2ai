----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_magic_stick",
	"item_enchanted_mango",
	"item_bracer",
	"item_boots",
	"item_magic_wand", --大魔棒7.14
	"item_blades_of_attack",
	"item_chainmail", --相位7.21
	"item_ancient_janggo", --战鼓7.20
	"item_invis_sword", --隐刀
	"item_ultimate_scepter",
	"item_blade_mail", --刃甲
	"item_shivas_guard", --希瓦
	"item_ultimate_orb",
	"item_recipe_silver_edge", --大隐刀
	"item_assault" --强袭
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end
