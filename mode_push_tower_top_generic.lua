require(GetScriptDirectory() .. "/util/PushUtility");

local npcBot = GetBot()
if npcBot:IsIllusion() then return end
local lane = LANE_TOP

function GetDesire()
	return PushUtility.GetUnitPushLaneDesire(npcBot, lane)
end

function Think()
	return PushUtility.UnitPushLaneThink(npcBot, lane)
end
