----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy = 
{ 
	"item_tango",
	"item_tango",
	"item_flask",
	--"item_stout_shield",

	"item_quelling_blade",			--补刀斧
	
	"item_wraith_band",
	"item_wraith_band",
	"item_power_treads",			--假腿7.21

	"item_bfury",			--狂战7.14
	
	
	"item_manta",			--分身
	
	"item_basher",			--晕锤7.14

	"item_heart",
	
	"item_vanguard",
	"item_recipe_abyssal_blade",	--大晕锤
	
	"item_butterfly",			--蝴蝶


	--[["item_point_booster",
	"item_staff_of_wizardry",
	"item_ogre_axe",
	"item_blade_of_alacrity",]]		--蓝杖


	--"item_vitality_booster",
	--"item_vitality_booster",		
	--"item_reaver",					--龙心7.06
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end