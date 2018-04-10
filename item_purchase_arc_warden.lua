----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local utility = require( GetScriptDirectory().."/utility" ) 

local ItemsToBuy = 
{ 
	"item_slippers",
	"item_circlet",
	"item_recipe_wraith_band", --系带
	"item_tango",
	"item_branches",
	"item_branches",
	"item_boots",	
	"item_magic_stick",
	"item_enchanted_mango",			--大魔棒7.07
	
	"item_gloves",
	"item_recipe_hand_of_midas",	--点金

	"item_ring_of_protection",
	"item_sobi_mask",				--天鹰
	
	"item_gloves",
	"item_mithril_hammer",
	"item_recipe_maelstrom",		--电锤
	
	"item_shadow_amulet",
	"item_claymore",				--隐刀
	
	"item_hyperstone",
	"item_recipe_mjollnir",			--大雷锤
	
	"item_recipe_travel_boots",		--飞鞋
	
	"item_ultimate_orb",
	"item_recipe_silver_edge",		--大隐刀
	
	"item_quarterstaff",
	"item_robe",
	"item_sobi_mask",
	"item_quarterstaff",
	"item_robe",
	"item_sobi_mask",
	"item_recipe_orchid",			--紫苑
	
	"item_broadsword",
	"item_blades_of_attack",
	"item_recipe_lesser_crit" ,
	"item_recipe_bloodthorn",		--血棘
	
	"item_quarterstaff",
	"item_eagle",
	"item_talisman_of_evasion",		--蝴蝶
}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.ItemPurchase(ItemsToBuy)
end