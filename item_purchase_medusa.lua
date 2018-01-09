----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.3
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local utility = require( GetScriptDirectory().."/utility" )		--导入通用函数库

local ItemsToBuy = 
{ 
	"item_tango",
	"item_flask",
	"item_clarity",
	"item_branches",
	"item_branches",
	"item_boots",	
	"item_magic_stick",
	"item_enchanted_mango",			--大魔棒7.07
	"item_blades_of_attack",
	"item_blades_of_attack",		--相位
	
	"item_slippers",
	"item_circlet",
	"item_recipe_wraith_band",
	"item_ring_of_protection",
	"item_sobi_mask",				--天鹰
	
	"item_lifesteal",
	"item_quarterstaff",			--疯狂面具7.06
	
	"item_ring_of_health",
	"item_void_stone",
	"item_ultimate_orb",
	"item_recipe_sphere",			--林肯
	
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
	"item_ultimate_orb",
	"item_ultimate_orb",			--冰眼
	
	"item_hyperstone",
	"item_javelin",
	"item_javelin",					--金箍棒7.07
	
	"item_quarterstaff",
	"item_eagle",
	"item_talisman_of_evasion",		--蝴蝶
}

utility.checkItemBuild(ItemsToBuy)		--检查装备列表

function ItemPurchaseThink()
	utility.ItemPurchase(ItemsToBuy)	--购买装备
end