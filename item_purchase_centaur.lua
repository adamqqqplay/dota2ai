----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy = 
{ 
	"item_tango",
	"item_flask",
	"item_stout_shield",
	"item_enchanted_mango",
	"item_enchanted_mango",
	"item_branches",
	"item_branches",
	
	"item_magic_stick",
	"item_recipe_magic_wand",		--大魔棒7.14
	"item_gauntlets",
	"item_circlet",
	"item_recipe_bracer",


	"item_boots",

	"item_ring_of_health",
	
	"item_vitality_booster",--先锋
	
	"item_blink",					--跳刀
	"item_chainmail",
	"item_recipe_buckler" ,
	"item_branches",
	"item_recipe_crimson_guard",	--赤红甲
	"item_cloak",
	"item_ring_of_health",
	"item_ring_of_regen",			--挑战
	"item_ring_of_regen",
	"item_recipe_headdress",
	"item_branches",
	"item_recipe_pipe" ,			--笛子
	"item_point_booster",		
	"item_staff_of_wizardry",
	"item_ogre_axe",
	"item_blade_of_alacrity",		--蓝杖
	"item_crown",
	"item_vitality_booster",		
	"item_ring_of_tarrasque",
	"item_recipe_heart",					--龙心7.20
	
}

ItemPurchaseSystem.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(ItemsToBuy)
end