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
	"item_circlet",
	"item_magic_stick",				--大魔棒
	"item_blight_stone",
	"item_blades_of_attack",
	"item_blades_of_attack",		--相位
	"item_ring_of_health",
	"item_vitality_booster",		--先锋
	"item_mithril_hammer",
	"item_mithril_hammer",			--暗灭
	"item_ogre_axe", 
	"item_mithril_hammer",
	"item_recipe_black_king_bar",	--bkb
	"item_javelin",
	"item_belt_of_strength",
	"item_recipe_basher" ,
	"item_recipe_abyssal_blade",	--大晕锤
	"item_lifesteal",
	"item_reaver", 
	"item_mithril_hammer",			--撒旦
	"item_demon_edge",
	"item_javelin",
	"item_javelin",					--金箍棒
}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.ItemPurchase(ItemsToBuy)
end