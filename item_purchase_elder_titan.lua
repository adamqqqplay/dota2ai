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
	"item_magic_wand", --大魔棒7.14
	"item_bracer",
	"item_tranquil_boots",
	"item_circlet",
	"item_ring_of_protection",
	"item_recipe_urn_of_shadows",
	"item_infused_raindrop", --骨灰盒7.06
	"item_pipe", --笛子
	"item_rod_of_atos", --阿托斯7.20
	"item_ultimate_scepter", --蓝杖
	"item_lotus_orb",
	"item_black_king_bar" --bkb
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered) --检查装备列表

function ItemPurchaseThink()
	ItemPurchaseSystem.BuySupportItem() --购买辅助物品	对于辅助英雄保留这一行
	-- ItemPurchaseSystem.BuyCourier() --购买信使		对于5号位保留这一行
	ItemPurchaseSystem.ItemPurchase(Transfered) --购买装备
end
