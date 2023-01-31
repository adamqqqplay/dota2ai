----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")
local AbilityExtensions = require(GetScriptDirectory() .. "/util/AbilityAbstraction")

local enemyTeamMemberNames = AbilityExtensions:GetEnemyTeamMemberNames(GetBot())
AbilityExtensions:ForEach(enemyTeamMemberNames, function(t)
	print("enemy team has " .. t:GetUnitName())
end)

local ItemsToBuy =
{
	"item_tango",
	"item_bracer",
	"item_magic_wand", --大魔棒7.14
	"item_power_treads",
	"item_desolator",
	"item_aghanims_shard",
	"item_black_king_bar", --bkb
	"item_blink",
	"item_assault", --强袭
	"item_ultimate_scepter", --蓝杖
	"item_overwhelming_blink",
	"item_ultimate_scepter_2",
	"item_monkey_king_bar",
}

--[[
if AbilityExtensions:Contains(enemyTeamMemberNames, "antimage") then
	AbilityExtensions:InsertAfter_Modify(ItemsToBuy, "item_radiance", "item_aghanims_shard")
end
--]]

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
