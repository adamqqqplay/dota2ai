----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.3
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local utility = require( GetScriptDirectory().."/utility" )	--导入通用函数库

local ItemsToBuy = 
{ 
	"item_tango",
	"item_flask",
	"item_clarity",
	"item_branches",
	"item_branches",
	"item_magic_stick",
	"item_enchanted_mango",			--大魔棒7.07
	"item_boots",	
	"item_slippers",
	"item_circlet",
	"item_recipe_wraith_band",
	"item_ring_of_protection",
	"item_sobi_mask",				--天鹰
	"item_energy_booster",			--秘法鞋
	
	
	"item_point_booster",
	"item_staff_of_wizardry",
	"item_ogre_axe",
	"item_blade_of_alacrity",		--蓝杖

	"item_blink",		-- 跳刀
	
	"item_boots_of_elves",
	"item_blade_of_alacrity",
	"item_recipe_yasha",			--夜叉
	"item_ultimate_orb",
	"item_recipe_manta",			--分身
	
	"item_ogre_axe", 
	"item_mithril_hammer",
	"item_recipe_black_king_bar",	--bkb
	
	"item_quarterstaff",
	"item_eagle",
	"item_talisman_of_evasion",		--蝴蝶
}

utility.checkItemBuild(ItemsToBuy)		--检查装备列表

function ItemPurchaseThink()
	utility.ItemPurchase(ItemsToBuy)	--购买装备
end