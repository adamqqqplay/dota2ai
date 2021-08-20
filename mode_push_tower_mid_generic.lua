require( GetScriptDirectory().."/util/PushUtility");

local npcBot = GetBot()
local lane = LANE_MID

function GetDesire()
	return PushUtility.GetUnitPushLaneDesire(npcBot,lane)
end

function Think()
	return PushUtility.UnitPushLaneThink(npcBot,lane)
end