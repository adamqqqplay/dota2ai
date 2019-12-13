----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy = 
{ 
	"item_tango",
	"item_flask",
	"item_enchanted_mango",
	"item_enchanted_mango",
	"item_quelling_blade",
	
	"item_bracer",

	
	"item_phase_boots",			--相位

	"item_magic_wand",		--大魔棒7.14
	
	"item_vanguard",		--先锋

	
	"item_pipe",			--笛子
	
	"item_helm_of_iron_will",
	"item_recipe_crimson_guard",	--赤红甲

	"item_black_king_bar",  --BKB
	
	"item_point_booster",
	"item_vitality_booster",
	"item_energy_booster",
	"item_mystic_staff",			--玲珑心
	
	"item_lotus_orb",
	
	
	"item_heart",					--龙心7.20
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end