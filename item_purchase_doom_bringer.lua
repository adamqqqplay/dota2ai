----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local utility = require( GetScriptDirectory().."/utility" ) 

local ItemsToBuy = 
{ 
	"item_tango",
	"item_flask",
	"item_stout_shield",
	"item_branches",
	"item_branches",

	"item_boots",

	"item_magic_stick",
	"item_enchanted_mango",			--大魔棒7.07

	"item_blades_of_attack",
	"item_blades_of_attack",		--相位
	
	"item_gauntlets",
	"item_circlet",
	"item_recipe_bracer",
				
	"item_wind_lace",
	"item_sobi_mask",
	"item_recipe_ancient_janggo",	--战鼓
	
	"item_shadow_amulet",
	"item_claymore",				--隐刀
	
	"item_broadsword",
	"item_robe",
	"item_chainmail",				--刃甲
	
	"item_platemail",
	"item_mystic_staff",
	"item_recipe_shivas_guard" ,	--希瓦
	
	"item_ultimate_orb",
	"item_recipe_silver_edge",		--大隐刀
	
	"item_hyperstone",
	"item_platemail",
	"item_chainmail",
	"item_recipe_assault",			--强袭
}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.ItemPurchase(ItemsToBuy)
end