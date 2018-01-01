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
	"item_wind_lace",
	"item_ring_of_regen",			--绿鞋
	"item_magic_stick",
	"item_enchanted_mango",			--大魔棒7.07
	"item_blink",					--跳刀
	"item_ring_of_health",
	"item_staff_of_wizardry",
	"item_recipe_force_staff",		--推推7.06
	"item_ogre_axe", 
	"item_mithril_hammer",
	"item_recipe_black_king_bar",	--bkb
	"item_platemail",
	"item_ring_of_health",
	"item_void_stone",
	"item_energy_booster",			--清莲宝珠
	"item_vitality_booster",
	"item_vitality_booster",		
	"item_reaver",					--龙心7.06
}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.ItemPurchase(ItemsToBuy)
end