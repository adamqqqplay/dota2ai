----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy = 
{ 
	
	"item_tango",
	
	"item_wraith_band",  --系带
	"item_flask",
	"item_wraith_band",  --系带
	
	"item_magic_wand",		--大魔棒7.14
	"item_boots",
	
	
	"item_hand_of_midas",	--点金

	--[["item_ring_of_protection",
	"item_sobi_mask",		]]		--天鹰
	
	"item_maelstrom",			--电锤7.14
	
	
	"item_invis_sword",				--隐刀
	
	"item_hyperstone",
	"item_recipe_mjollnir",			--大雷锤
	
	"item_recipe_travel_boots",		--飞鞋
	
	"item_ultimate_orb",
	"item_recipe_silver_edge",		--大隐刀
	
	
	"item_orchid",			--紫苑

	"item_black_king_bar",  --BKB
	
	"item_lesser_crit",--水晶剑
	"item_recipe_bloodthorn",		--血棘
	
	"item_butterfly",		--蝴蝶
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end