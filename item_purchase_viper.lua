----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local utility = require( GetScriptDirectory().."/utility" ) 

local ItemsToBuy = 
{ 
	"item_tango",
	"item_slippers",
	"item_circlet",
	"item_recipe_wraith_band",
	"item_boots",
	"item_ring_of_protection",
	"item_sobi_mask",				--天鹰
	"item_blades_of_attack",
	"item_blades_of_attack",		--相位
	"item_boots_of_elves",
	"item_boots_of_elves", 
	"item_ogre_axe",				--魔龙枪
	"item_ring_of_health",
	"item_staff_of_wizardry",
	"item_recipe_force_staff",		--推推7.06
	"item_slippers",
	"item_circlet",
	"item_recipe_wraith_band",		--大推推7.07
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
	"item_vitality_booster",
	"item_vitality_booster",		
	"item_reaver",					--龙心7.06
}

utility.checkItemBuild(ItemsToBuy)

function ItemPurchaseThink()
	utility.ItemPurchase(ItemsToBuy)
end