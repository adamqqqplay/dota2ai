----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy = 
{ 
	"item_tango",
	"item_tango",
	"item_clarity",
	"item_orb_of_venom",

	"item_null_talisman",
	"item_null_talisman",
	

	"item_boots",	

	"item_magic_wand",		--大魔棒7.14

	"item_blades_of_attack",
	"item_chainmail",			--相位7.21
	
	"item_hood_of_defiance",			--挑战
	
	"item_dragon_lance",				--魔龙枪
	
	"item_force_staff",		--推推7.14
	"item_crown",					--大推推7.20
	
	
	
	"item_ultimate_scepter_1",		--蓝杖

	"item_sheepstick",				--羊刀
	
	"item_monkey_king_bar",					--金箍棒7.14
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end