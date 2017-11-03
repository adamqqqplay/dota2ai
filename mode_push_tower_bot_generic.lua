require( GetScriptDirectory().."/PushUtility");

npcBot = GetBot();
lane = LANE_BOT

function GetDesire()
	return PushUtility.GetUnitPushLaneDesire(npcBot,lane)
end

function Think()
	return PushUtility.UnitPushLaneThink(npcBot,lane)
end