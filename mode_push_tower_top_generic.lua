require( GetScriptDirectory().."/PushUtility");

npcBot = GetBot();
lane = LANE_TOP

function GetDesire()
	return PushUtility.GetUnitPushLaneDesire(npcBot,lane)
end

function Think()
	return PushUtility.UnitPushLaneThink(npcBot,lane)
end