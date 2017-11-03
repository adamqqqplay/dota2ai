----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
require( GetScriptDirectory().."/utility" ) 

local ItemsToBuy = 
{ 
	"item_tango",
	"item_flask",
	"item_stout_shield",
	"item_branches",
	"item_branches",
	"item_boots",
	"item_blades_of_attack",
	"item_blades_of_attack",		--相位
	"item_magic_stick",
	"item_enchanted_mango",			--大魔棒7.07
	"item_chainmail",
	"item_sobi_mask",
	"item_blight_stone",			--勇气勋章
	"item_talisman_of_evasion",		--大勋章
	"item_point_booster",		
	"item_staff_of_wizardry",
	"item_ogre_axe",
	"item_blade_of_alacrity",		--蓝杖
	"item_ogre_axe", 
	"item_mithril_hammer",
	"item_recipe_black_king_bar",	--bkb
	"item_hyperstone",
	"item_platemail",
	"item_chainmail",
	"item_recipe_assault",			--强袭
	"item_ring_of_health",
	"item_void_stone",				
	"item_platemail",
	"item_energy_booster"			--清莲宝珠
	
	
}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.ItemPurchase(ItemsToBuy)
end