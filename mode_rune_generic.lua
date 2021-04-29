if GetBot():IsInvulnerable() or not GetBot():IsHero() or not string.find(GetBot():GetUnitName(), "hero") or  GetBot():IsIllusion() then
	return;
end

local role = require(GetScriptDirectory() .. "/util/RoleUtility");
local hero_roles = role["hero_roles"];
local bot = GetBot();
local minute = 0;
local sec = 0;
local closestRune  = -1;
local runeStatus = -1;
local ProxDist = 1500;
local teamPlayers = nil;
local PingTimeGap = 10;
local bottle = nil;

local ListRune = {
	RUNE_BOUNTY_1,
	RUNE_BOUNTY_2,
	RUNE_BOUNTY_3,
	RUNE_BOUNTY_4,
	RUNE_POWERUP_1,
	RUNE_POWERUP_2
}


function GetDesire()

	return 0

	--[[if bot.lastPlayerChat ~= nil and string.find(bot.lastPlayerChat.text, "rune") then
		bot:ActionImmediate_Chat("Catch this in mode_rune_generic", false);
		bot.lastPlayerChat = nil;
	end]]--

	-- if GetGameMode() == GAMEMODE_1V1MID then
	-- 	return BOT_MODE_DESIRE_NONE;
	-- end
	
	-- if GetGameMode() == GAMEMODE_MO and DotaTime() <= 0 then
	-- 	return BOT_MODE_DESIRE_NONE;
	-- end
	
	-- if teamPlayers == nil then teamPlayers = GetTeamPlayers(GetTeam()) end
	
	-- if bot:IsIllusion() or bot:IsInvulnerable() or not bot:IsHero() or bot:HasModifier("modifier_arc_warden_tempest_double") or
    --    bot:IsUsingAbility() or bot:IsChanneling() or bot:GetCurrentActionType() == BOT_ACTION_TYPE_IDLE or 
	--    GetUnitToUnitDistance(bot, GetAncient(GetTeam())) < 2500 or  GetUnitToUnitDistance(bot, GetAncient(GetOpposingTeam())) < 2500 
	-- then
	-- 	return BOT_MODE_DESIRE_NONE;
	-- end

	-- minute = math.floor(DotaTime() / 60)
	-- sec = DotaTime() % 60
	
	-- if not IsSuitableToPick() then
	-- 	return BOT_MODE_DESIRE_NONE;
	-- end	
	
	-- if DotaTime() < 0 and not bot:WasRecentlyDamagedByAnyHero(5.0) then 
	-- 	return BOT_MODE_DESIRE_MODERATE;
	-- end	
	
	-- closestRune, closestDist = GetBotClosestRune();
	-- if closestRune ~= -1 then
	-- 	if closestRune == RUNE_BOUNTY_1 or closestRune == RUNE_BOUNTY_2 or closestRune == RUNE_BOUNTY_3 or closestRune == RUNE_BOUNTY_4 then
	-- 		runeStatus = GetRuneStatus( closestRune );
	-- 		if runeStatus == RUNE_STATUS_AVAILABLE then
	-- 			return CountDesire(BOT_MODE_DESIRE_MODERATE, closestDist, 3000);
	-- 		elseif runeStatus == RUNE_STATUS_UNKNOWN and closestDist <= ProxDist then
	-- 			return CountDesire(BOT_MODE_DESIRE_MODERATE, closestDist, ProxDist);
	-- 		elseif runeStatus == RUNE_STATUS_MISSING and DotaTime() > 60 and ( minute % 4 == 0 and sec > 52 ) and closestDist <= ProxDist then
	-- 			return CountDesire(BOT_MODE_DESIRE_MODERATE, closestDist, ProxDist);
	-- 		elseif IsTeamMustSaveRune(closestRune) and runeStatus == RUNE_STATUS_UNKNOWN then
	-- 			return CountDesire(BOT_MODE_DESIRE_MODERATE, closestDist, 5000);
	-- 		end
	-- 	else
	-- 		runeStatus = GetRuneStatus( closestRune );
	-- 		if runeStatus == RUNE_STATUS_AVAILABLE then
	-- 			return CountDesire(BOT_MODE_DESIRE_MODERATE, closestDist, 5000);
	-- 		elseif runeStatus == RUNE_STATUS_UNKNOWN and closestDist <= ProxDist then
	-- 			return CountDesire(BOT_MODE_DESIRE_MODERATE, closestDist, ProxDist);
	-- 		elseif runeStatus == RUNE_STATUS_MISSING and DotaTime() > 60 and ( minute % 2 == 1 and sec > 52 ) and closestDist <= ProxDist then
	-- 			return CountDesire(BOT_MODE_DESIRE_MODERATE, closestDist, ProxDist);
	-- 		elseif IsTeamMustSaveRune(closestRune) and runeStatus == RUNE_STATUS_UNKNOWN then
	-- 			return CountDesire(BOT_MODE_DESIRE_MODERATE, closestDist, 5000);
	-- 		end
	-- 	end	
	-- end
	
	-- return BOT_MODE_DESIRE_NONE;
end

function OnStart()
	local bottle_slot = bot:FindItemSlot('item_bottle');
	if bot:GetItemSlotType(bottle_slot) == ITEM_SLOT_TYPE_MAIN then
		bottle = bot:GetItemInSlot(bottle_slot);
	end	
end

function OnEnd()
	bottle = nil;
end

function Think()
	
	if DotaTime() < 0 then 
		if GetTeam() == TEAM_RADIANT then
			if bot:GetAssignedLane() == LANE_BOT then 
				bot:Action_MoveToLocation(GetRuneSpawnLocation(RUNE_BOUNTY_3));
				return
			else
				bot:Action_MoveToLocation(GetRuneSpawnLocation(RUNE_BOUNTY_1));
				return
			end
		elseif GetTeam() == TEAM_DIRE then
			if bot:GetAssignedLane() == LANE_TOP then 
				bot:Action_MoveToLocation(GetRuneSpawnLocation(RUNE_BOUNTY_4));
				return
			else
				bot:Action_MoveToLocation(GetRuneSpawnLocation(RUNE_BOUNTY_2));
				return
			end
		end
	end	
	
	-- if runeStatus == RUNE_STATUS_AVAILABLE then
	-- 	if bottle ~= nil and closestDist < 1200 then 
	-- 		local bottle_charge = bottle:GetCurrentCharges() 
	-- 		if bottle:IsFullyCastable() and bottle_charge > 0 and ( bot:GetHealth() < bot:GetMaxHealth() or bot:GetMana() < bot:GetMaxMana() ) then
	-- 			bot:Action_UseAbility( bottle );
	-- 			return;
	-- 		end
	-- 	end
		
	-- 	if closestDist > 200 then
	-- 		bot:Action_MoveToLocation(GetRuneSpawnLocation(closestRune));
	-- 		return
	-- 	else
	-- 		bot:Action_PickUpRune(closestRune);
	-- 		return
	-- 	end
	-- else 
	-- 	bot:Action_MoveToLocation(GetRuneSpawnLocation(closestRune));
	-- 	return
	-- end
	
end

function CountDesire(base_desire, dist, maxDist)
	 return base_desire + RemapValClamped( dist, maxDist, 0, 0, 1-base_desire );
end	


function GetBotClosestRune()
	local cDist = 100000;	
	local cRune = -1;	
	for _,r in pairs(ListRune)
	do
		local rLoc = GetRuneSpawnLocation(r);
		if not IsHumanPlayerNearby(rLoc) and not IsPingedByHumanPlayer(rLoc) and not IsThereMidlaner(rLoc) and not IsThereCarry(rLoc) and IsTheClosestOne(rLoc)
		then
			local dist = GetUnitToLocationDistance(bot, rLoc);
			if dist < cDist then
				cDist = dist;
				cRune = r;
			end	
		end
	end
	return cRune, cDist;
end

function GetDistance(s, t)
    return math.sqrt((s[1]-t[1])*(s[1]-t[1]) + (s[2]-t[2])*(s[2]-t[2]));
end

function IsTeamMustSaveRune(rune)
	if GetTeam() == TEAM_DIRE then
		return rune == RUNE_BOUNTY_2 or rune == RUNE_BOUNTY_4 or rune == RUNE_POWERUP_1 or rune == RUNE_POWERUP_2
	else
		return rune == RUNE_BOUNTY_1 or rune == RUNE_BOUNTY_3 or rune == RUNE_POWERUP_1 or rune == RUNE_POWERUP_2
	end
end

function IsHumanPlayerNearby(runeLoc)
	for k,v in pairs(teamPlayers)
	do
		local member = GetTeamMember(k);
		if member ~= nil and not member:IsIllusion() and not IsPlayerBot(v) and member:IsAlive() then
			local dist1 = GetUnitToLocationDistance(member, runeLoc);
			local dist2 = GetUnitToLocationDistance(bot, runeLoc);
			if dist2 < 1200 and dist1 < 1200 then
				return true;
			end
		end
	end
	return false;
end

function IsPingedByHumanPlayer(runeLoc)
	local listPings = {};
	local dist2 = GetUnitToLocationDistance(bot, runeLoc);
	for k,v in pairs(teamPlayers)
	do
		local member = GetTeamMember(k);
		if member ~= nil and not member:IsIllusion() and not IsPlayerBot(v) and member:IsAlive() then
			local ping = member:GetMostRecentPing();
			table.insert(listPings, ping);
		end
	end
	for _,p in pairs(listPings)
	do
		if p ~= nil and not p.normal_ping and GetDistance(p.location, runeLoc) < 1200 and dist2 < 1200 and GameTime() - p.time < PingTimeGap then
			return true;
		end
	end
	return false;
end

function IsTheClosestOne(r)
	local minDist = GetUnitToLocationDistance(bot, r);
	local closest = bot;
	for k,v in pairs(teamPlayers)
	do	
		local member = GetTeamMember(k);
		if  member ~= nil and not member:IsIllusion() and member:IsAlive() then
			local dist = GetUnitToLocationDistance(member, r);
			if dist < minDist then
				minDist = dist;
				closest = member;
			end
		end
	end
	return closest == bot;
end

function IsThereMidlaner(runeLoc)
	for k,v in pairs(teamPlayers)
	do
		local member = GetTeamMember(k);
		if member ~= nil and not member:IsIllusion() and member:IsAlive() and member:GetAssignedLane() == LANE_MID then
			local dist1 = GetUnitToLocationDistance(member, runeLoc);
			local dist2 = GetUnitToLocationDistance(bot, runeLoc);
			if dist2 < 1200 and dist1 < 1200 and bot:GetUnitName() ~= member:GetUnitName() then
				return true;
			end
		end
	end
	return false;
end

function IsThereCarry(runeLoc)
	for k,v in pairs(teamPlayers)
	do
		local member = GetTeamMember(k);
		if member ~= nil and not member:IsIllusion() and member:IsAlive() and role.CanBeSafeLaneCarry(member:GetUnitName()) 
		   and ( (GetTeam()==TEAM_DIRE and member:GetAssignedLane()==LANE_TOP) or (GetTeam()==TEAM_RADIANT and member:GetAssignedLane()==LANE_BOT)  )	
		then
			local dist1 = GetUnitToLocationDistance(member, runeLoc);
			local dist2 = GetUnitToLocationDistance(bot, runeLoc);
			if dist2 < 1200 and dist1 < 1200 and bot:GetUnitName() ~= member:GetUnitName() then
				return true;
			end
		end
	end
	return false;
end

function IsSuitableToPick()
	local mode = bot:GetActiveMode();
	local Enemies = bot:GetNearbyHeroes(1300, true, BOT_MODE_NONE);
	if ( mode == BOT_MODE_RETREAT and bot:GetActiveModeDesire() > BOT_MODE_DESIRE_MODERATE )
		or mode == BOT_MODE_ATTACK
		or mode == BOT_MODE_DEFEND_ALLY
		or mode == BOT_MODE_DEFEND_TOWER_TOP
		or mode == BOT_MODE_DEFEND_TOWER_MID
		or mode == BOT_MODE_DEFEND_TOWER_BOT
		or ( #Enemies >= 1 and IsIBecameTheTarget(Enemies) )
		or bot:WasRecentlyDamagedByAnyHero(5.0)
	then
		return false;
	end
	return true;
end

function IsIBecameTheTarget(units)
	for _,u in pairs(units) do
		if u:GetAttackTarget() == bot then
			return true;
		end
	end
	return false;
end

