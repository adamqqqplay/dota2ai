----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local utility = require( GetScriptDirectory().."/utility" ) 

local ItemsToBuy = 
{ 
	"item_circlet",
	"item_mantle",
	"item_recipe_null_talisman",	--无用挂件
	"item_tango",
	
	"item_magic_stick",
	"item_enchanted_mango",			--大魔棒7.07
	"item_branches",
	"item_branches",
	
	
	"item_bottle",
	"item_boots",
	"item_energy_booster",			--秘法鞋

	"item_robe",
	"item_staff_of_wizardry",		--慧光

	"item_void_stone",
	"item_energy_booster",
	"item_recipe_aether_lens",		--以太之镜7.06
	
	"item_point_booster",
	"item_staff_of_wizardry",
	"item_ogre_axe",
	"item_blade_of_alacrity",		--蓝杖
	
	"item_ogre_axe", 
	"item_mithril_hammer",
	"item_recipe_black_king_bar",	--bkb

	"item_mystic_staff",
	"item_ultimate_orb",
	"item_void_stone",				--羊刀
}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.ItemPurchase(ItemsToBuy)
end