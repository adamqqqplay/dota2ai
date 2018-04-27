----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local utility = require( GetScriptDirectory().."/utility" ) 

local ItemsToBuy = 
{ 
	"item_tango",
	"item_stout_shield",
	"item_orb_of_venom",
	"item_branches",
	"item_branches",
	"item_boots",
	"item_magic_stick",
	"item_recipe_magic_wand",		--大魔棒7.14
	"item_blades_of_attack",
	"item_blades_of_attack",		--相位
	
	
	"item_ring_of_protection",
	"item_sobi_mask",
	"item_lifesteal",
	"item_ring_of_regen",
	"item_recipe_headdress",
	"item_branches",				--祭品
	
	"item_blink"	,				--跳刀
	
	"item_mithril_hammer",
	"item_belt_of_strength",
	"item_recipe_basher",			--晕锤7.14
	
	"item_point_booster",		
	"item_staff_of_wizardry",
	"item_ogre_axe",
	"item_blade_of_alacrity",		--蓝杖
	
	"item_mithril_hammer",
	"item_ogre_axe",
	"item_recipe_black_king_bar",	--bkb
	
	"item_ring_of_health",
	"item_vitality_booster",		
	"item_stout_shield",			--先锋
	"item_recipe_abyssal_blade",	--大晕锤
}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.ItemPurchase(ItemsToBuy)
end