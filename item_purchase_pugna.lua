----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_mantle",
	"item_circlet",
	"item_mantle", --无用挂件
	"item_branches",
	"item_branches",
	"item_magic_stick",
	"item_recipe_magic_wand", --大魔棒7.14
	"item_boots",
	"item_recipe_null_talisman",
	"item_circlet",
	"item_recipe_null_talisman",
	"item_energy_booster",
	"item_robe",
	"item_staff_of_wizardry", --慧光
	"item_void_stone",
	"item_energy_booster",
	"item_recipe_aether_lens", --以太之镜7.06
	"item_point_booster",
	"item_staff_of_wizardry",
	"item_ogre_axe",
	"item_blade_of_alacrity", --蓝杖
	"item_ogre_axe",
	"item_mithril_hammer",
	"item_recipe_black_king_bar", --bkb
	"item_mystic_staff",
	"item_ultimate_orb",
	"item_void_stone" --羊刀
}

--[[for k,v in pairs(ItemsToBuy)
do
	local item =  GetItemComponents(ItemsToBuy[k])
	if item ~= nil and #item > 0
	then
		for k,v in pairs(item)
		do
			table.insert(ItemsToBuy,k,item[k])
		end
	end
end]]
local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end
