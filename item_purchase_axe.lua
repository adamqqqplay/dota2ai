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
	"item_wind_lace",
	"item_ring_of_regen",			--绿鞋
	"item_circlet",
	"item_magic_stick",				--大魔棒
	"item_vitality_booster",
	"item_ring_of_health",			--先锋
	"item_blink",					--跳刀
	"item_robe",
	"item_chainmail",
	"item_broadsword",				--刃甲
	"item_chainmail",
	"item_recipe_buckler" ,
	"item_branches",
	"item_recipe_crimson_guard",	--赤红甲
	"item_mithril_hammer",
	"item_ogre_axe",
	"item_recipe_black_king_bar",	--bkb
	"item_vitality_booster",
	"item_vitality_booster",		
	"item_reaver",					--龙心7.06

}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.ItemPurchase(ItemsToBuy)
end