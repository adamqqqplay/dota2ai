----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_quelling_blade",
	"item_bracer",
	"item_soul_ring", --灵魂之戒7.07
	"item_power_treads", --假腿7.21
	"item_armlet", --臂章
	"item_blink",
	"item_black_king_bar", --BKB
	"item_mithril_hammer",
	"item_belt_of_strength",
	"item_recipe_basher", --晕锤7.14
	"item_platemail",
	"item_hyperstone",
	"item_chainmail",
	"item_recipe_assault", --强袭
	"item_javelin",
	"item_mithril_hammer", --电锤7.14
	"item_hyperstone",
	"item_recipe_mjollnir", --大电锤
	"item_vanguard",
	"item_recipe_abyssal_blade", --大晕
	"item_hyperstone",
	"item_hyperstone" --银月
}

local Transfered = ItemPurchaseSystem.Transfer(ItemsToBuy)
ItemPurchaseSystem.checkItemBuild(Transfered)

function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchase(Transfered)
end
