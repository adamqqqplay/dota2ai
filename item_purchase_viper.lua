----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy = 
{ 
	"item_slippers",
	"item_circlet",
	"item_slippers",
	"item_tango",
	"item_flask",
	"item_recipe_wraith_band", --系带
	"item_circlet",
	"item_recipe_wraith_band", --系带
	"item_boots",
	"item_belt_of_strength",
	"item_gloves",			--假腿7.21
	"item_boots_of_elves",
	"item_boots_of_elves", 
	"item_ogre_axe",				--魔龙枪
	"item_ring_of_regen",
	"item_staff_of_wizardry",
	"item_recipe_force_staff",		--推推7.14
	"item_crown",					--大推推7.20
	"item_point_booster",
	"item_staff_of_wizardry",
	"item_ogre_axe",
	"item_blade_of_alacrity",		--蓝杖
	"item_boots_of_elves",
	"item_blade_of_alacrity",
	"item_recipe_yasha",
	"item_ultimate_orb", 
	"item_recipe_manta",			--分身斧
	"item_platemail", 
	"item_chainmail", 
	"item_hyperstone",
	"item_recipe_assault",			--强袭
	"item_crown",
	"item_vitality_booster",		
	"item_ring_of_tarrasque",
	"item_recipe_heart",					--龙心7.20
}

ItemPurchaseSystem.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(ItemsToBuy)
end