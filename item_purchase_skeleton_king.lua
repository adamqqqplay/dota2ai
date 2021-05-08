----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")
local AbilityExtensions = require(GetScriptDirectory().."/util/AbilityAbstraction")

local enemyTeamMemberNames = AbilityExtensions:GetEnemyTeamMemberNames(GetBot())

local ItemsToBuy =
{
	"item_tango",
	"item_quelling_blade", --补刀斧
    "item_bracer",
	"item_magic_wand", --大魔棒7.14
    "item_gloves",
    "item_boots",
    "item_hand_of_midas",
    "item_power_treads",
    "item_radiance",
	"item_black_king_bar", --bkb
    "item_blink",
	"item_assault", --强袭
	"item_ultimate_scepter", --蓝杖
}

if AbilityExtensions:Contains(enemyTeamMemberNames, "antimage") then
    AbilityExtensions:InsertAfter_Modify(ItemsToBuy, "item_radiance", "item_aghanims_shard")
end

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
