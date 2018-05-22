----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.5f
--	Author: adamqqq		Email:adamqqq@163.com
--  Contributor: zmcmcc Email:mengzhang@utexas.edu
----------------------------------------------------------------------------
local utility = require( GetScriptDirectory().."/utility" ) 

local ItemsToBuy = 
{ 
	"item_tango",
	"item_flask",
	"item_orb_of_venom", -- 毒球
	"item_branches",
	"item_branches",
	"item_boots",
	"item_magic_stick",
	"item_recipe_magic_wand",		--大魔棒7.14

	"item_blades_of_attack",
	"item_blades_of_attack",		--相位	
	
	"item_shadow_amulet",
	"item_claymore",				--隐刀

	"item_blight_stone",
    "item_mithril_hammer",
    "item_mithril_hammer",			--黯灭

    "item_quarterstaff",
	"item_robe",
	"item_sobi_mask",
	"item_quarterstaff",
	"item_robe",
	"item_sobi_mask",
	"item_recipe_orchid",			--紫苑

	"item_broadsword",
	"item_blades_of_attack",
	"item_recipe_lesser_crit",
	"item_recipe_bloodthorn",		--血棘

	
	"item_point_booster",		
	"item_staff_of_wizardry",
	"item_ogre_axe",
	"item_blade_of_alacrity",		--蓝杖

	
	"item_ultimate_orb",
	"item_recipe_silver_edge",		--大隐刀

	"item_platemail",
	"item_mystic_staff",
	"item_recipe_shivas_guard" ,	--希瓦
	
}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.ItemPurchase(ItemsToBuy)
end