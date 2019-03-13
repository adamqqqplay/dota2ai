----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy = 
{ 
	"item_circlet",
	"item_mantle",
	"item_circlet",
	"item_tango",
	"item_flask",
	"item_recipe_null_talisman",	--无用挂件
	"item_mantle",
	"item_recipe_null_talisman",	--无用挂件
	"item_boots",
	
	"item_magic_stick",
	"item_recipe_magic_wand",		--大魔棒7.14
	"item_branches",
	"item_branches",
	
	"item_blades_of_attack",
	"item_chainmail",			--相位7.21
	
	"item_staff_of_wizardry",
	"item_void_stone",
	"item_recipe_cyclone",
	"item_wind_lace",				--风杖

	"item_ogre_axe", 
	"item_mithril_hammer",
	"item_recipe_black_king_bar",	--bkb
	
	"item_crown",
	"item_crown",
	"item_staff_of_wizardry",
	"item_recipe_rod_of_atos",		--阿托斯7.20

	"item_vitality_booster",
	"item_energy_booster",
	"item_recipe_aeon_disk",		-- 永恒之盘
	
	"item_point_booster",
	"item_vitality_booster",
	"item_energy_booster",
	"item_mystic_staff",			--玲珑心
	
	"item_platemail",
	"item_mystic_staff",
	"item_recipe_shivas_guard" ,	--希瓦
	
	"item_crown",
	"item_vitality_booster",		
	"item_ring_of_tarrasque",
	"item_recipe_heart",					--龙心7.20
}

ItemPurchaseSystem.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(ItemsToBuy)
end