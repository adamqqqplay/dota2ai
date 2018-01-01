----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local utility = require( GetScriptDirectory().."/utility" ) 

local ItemsToBuy = 
{ 
	"item_tango",
	"item_flask",
	"item_branches",
	"item_branches",
	"item_boots",
	"item_blades_of_attack",
	"item_blades_of_attack",		--相位
	"item_magic_stick",
	"item_enchanted_mango",			--大魔棒7.07
	
	"item_boots_of_elves",
	"item_boots_of_elves", 
	"item_ogre_axe",				--魔龙枪
	
	"item_ring_of_health",
	"item_staff_of_wizardry",
	"item_recipe_force_staff",
	"item_slippers",
	"item_circlet",
	"item_recipe_wraith_band",		--大推推7.07
	
	"item_shadow_amulet",
	"item_claymore",				--隐刀
	"item_ultimate_orb",
	"item_recipe_silver_edge",		--大隐刀
	
	"item_gloves",
	"item_mithril_hammer",
	"item_recipe_maelstrom",		--电锤
	"item_hyperstone",
	"item_recipe_mjollnir",			--大雷锤
	
	"item_boots_of_elves",
	"item_blade_of_alacrity",
	"item_recipe_yasha",			--夜叉
	"item_ultimate_orb",
	"item_recipe_manta",			--分身
	
	"item_hyperstone",
	"item_javelin",
	"item_javelin",					--金箍棒7.07
	
}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.ItemPurchase(ItemsToBuy)
end