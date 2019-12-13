----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
--  Contributor: zmcmcc Email:mengzhang@utexas.edu
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy = 
{ 
	"item_tango",
	"item_buckler"
	"item_flask",
	
	"item_bracer",
	"item_boots",

	"item_bracer",
	"item_magic_wand",		--大魔棒7.14


	"item_blades_of_attack",
	"item_chainmail",			--相位7.21

	"item_urn_of_shadows",		--骨灰盒7.06

	"item_medallion_of_courage",
	
	"item_invis_sword",				--隐刀

	"item_ultimate_orb",

	"item_wind_lace",

	"item_recipe_solar_crest",

	"item_desolator"

	"item_black_king_bar",	--bkb

	"item_vitality_booster",
	"item_wind_lace",
	"item_recipe_spirit_vessel", --大骨灰



	
	"item_ultimate_orb",
	"item_recipe_silver_edge",		--大隐刀
	
	
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	ItemPurchaseSystem.BuyCourier()
	ItemPurchaseSystem.ItemPurchase(Transfered)
	ItemPurchaseSystem.BuySupportItem()
end