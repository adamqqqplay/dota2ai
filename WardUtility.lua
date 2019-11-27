----------------------------------------------------------------------------------------------------
-- Author:Arizona Fauzie  BOT EXPERIMENT Link:http://steamcommunity.com/sharedfiles/filedetails/?id=837040016
----------------------------------------------------------------------------------------------------
local X = {}

local visionRad = 1600;

---RADIANT WARDING SPOT
local RADIANT_T3TOPFALL = Vector(-6600.000000, -3072.000000, 0.000000);
local RADIANT_T3MIDFALL = Vector(-4314.000000, -3887.000000, 0.000000);
local RADIANT_T3BOTFALL = Vector(-3586.000000, -6131.000000, 0.000000);

local RADIANT_T2TOPFALL = Vector(-4340.000000, -1015.000000, 0.000000);
local RADIANT_T2MIDFALL = Vector(-1785.000000, -4868.000000, 0.000000);
local RADIANT_T2BOTFALL = Vector(1018.000000, -4101.000000, 0.000000);

local RADIANT_T1TOPFALL = Vector(-5364.000000, 2281.000000, 0.00000);
local RADIANT_T1MIDFALL = Vector(766.000000, -2296.000000, 0.000000);
local RADIANT_T1BOTFALL = Vector(5780.000000, -3276.000000, 0.000000);

local RADIANT_MANDATE1 = Vector(-1600.000000, 295.000000, 0.000000);
local RADIANT_MANDATE2 = Vector(2392.000000, -2981.000000, 0.000000);

local RADIANT_AGGRESSIVETOP  = Vector(-767.000000, 4082.000000, 0.000000);
local RADIANT_AGGRESSIVEMID1 = Vector(-55.000000, 2685.000000, 0.000000);
local RADIANT_AGGRESSIVEMID2 = Vector(2078.000000, -777.000000, 0.000000);
local RADIANT_AGGRESSIVEBOT  = Vector(4873.000000, -2277.000000, 0.000000);

---DIRE WARDING SPOT
local DIRE_T3TOPFALL = Vector(3087.000000, 5690.000000, 0.000000);
local DIRE_T3MIDFALL = Vector(4024.000000, 3445.000000, 0.000000);
local DIRE_T3BOTFALL = Vector(6354.000000, 2606.000000, 0.000000);

local DIRE_T2TOPFALL = Vector(1028.000000, 4859.000000, 0.000000);
local DIRE_T2MIDFALL = Vector(549.000000, 2365.000000, 0.000000);
local DIRE_T2BOTFALL = Vector(5111.000000, 776.000000, 0.000000);

local DIRE_T1TOPFALL = Vector(-5693.000000, 3520.000000, 0.000000);
local DIRE_T1MIDFALL = Vector(-209.000000, -49.000000, 0.000000);
local DIRE_T1BOTFALL = Vector(4859.000000, -2295.000000, 0.000000);

local DIRE_MANDATE1 = Vector(-1632.000000, 1426.000000, 0.000000);
local DIRE_MANDATE2 = Vector(2044.000000, -766.000000, 0.000000);

local DIRE_AGGRESSIVETOP  = Vector(-4656.000000, 400.000000, 0.000000);
local DIRE_AGGRESSIVEMID1 = Vector(-4362.000000, -1031.000000, 0.000000);
local DIRE_AGGRESSIVEMID2 = Vector(-1787.000000, -4869.000000, 0.000000);
local DIRE_AGGRESSIVEBOT  = Vector(1027.000000, -4095.000000, 0.000000);


local Towers = {
	TOWER_TOP_1,
	TOWER_MID_1,
	TOWER_BOT_1,
	TOWER_TOP_2,
	TOWER_MID_2,
	TOWER_BOT_2,
	TOWER_TOP_3,
	TOWER_MID_3,
	TOWER_BOT_3
}



local WardSpotTowerFallRadiant = {
	RADIANT_T1TOPFALL,
	RADIANT_T1MIDFALL,
	RADIANT_T1BOTFALL,
	RADIANT_T2TOPFALL,
	RADIANT_T2MIDFALL,
	RADIANT_T2BOTFALL,
	RADIANT_T3TOPFALL,
	RADIANT_T3MIDFALL,
	RADIANT_T3BOTFALL
}	

local WardSpotTowerFallDire = {
	DIRE_T1TOPFALL,
	DIRE_T1MIDFALL,
	DIRE_T1BOTFALL,
	DIRE_T2TOPFALL,
	DIRE_T2MIDFALL,
	DIRE_T2BOTFALL,
	DIRE_T3TOPFALL,
	DIRE_T3MIDFALL,
	DIRE_T3BOTFALL
}

function X.GetDistance(s, t)
    --print("S1: "..s[1]..", S2: "..s[2].." :: T1: "..t[1]..", T2: "..t[2]);
    return math.sqrt((s[1]-t[1])*(s[1]-t[1]) + (s[2]-t[2])*(s[2]-t[2]));
end

function X.GetMandatorySpot()
	local MandatorySpotRadiant = {
		RADIANT_MANDATE1,
		RADIANT_MANDATE2
	}

	local MandatorySpotDire = {
		DIRE_MANDATE1,
		DIRE_MANDATE2
	}
	if GetTeam() == TEAM_RADIANT then
		return MandatorySpotRadiant;
	else
		return MandatorySpotDire
	end	
end

function X.GetWardSpotWhenTowerFall()
	local wardSpot = {};
	for i = 1, #Towers
	do
		local t = GetTower(GetTeam(),  Towers[i]);
		if t == nil then
			if GetTeam() == TEAM_RADIANT then
				table.insert(wardSpot, WardSpotTowerFallRadiant[i]);
			else
				table.insert(wardSpot, WardSpotTowerFallDire[i]);
			end
		end
	end
	return wardSpot;
end

function X.GetAggressiveSpot()
	local AggressiveDire = {
		DIRE_AGGRESSIVETOP,
		DIRE_AGGRESSIVEMID1,
		DIRE_AGGRESSIVEMID2,
		DIRE_AGGRESSIVEBOT
	}

	local AggressiveRadiant = {
		RADIANT_AGGRESSIVETOP,
		RADIANT_AGGRESSIVEMID1,
		RADIANT_AGGRESSIVEMID2,
		RADIANT_AGGRESSIVEBOT
	}
	if GetTeam() == TEAM_RADIANT then
		return AggressiveRadiant;
	else
		return AggressiveDire
	end	
end

function X.GetItemWard(bot)
	for i = 0,8 do
		local item = bot:GetItemInSlot(i);
		if item ~= nil and item:GetName() == 'item_ward_observer' then
			return item;
		end
	end
	return nil;
end

function X.IsPingedByHumanPlayer(bot)
	local TeamPlayers = GetTeamPlayers(GetTeam());
	for i,id in pairs(TeamPlayers)
	do
		if not IsPlayerBot(id) then
			local member = GetTeamMember(i);
			if member ~= nil and member:IsAlive() and GetUnitToUnitDistance(bot, member) <= 1000 then
				local ping = member:GetMostRecentPing();
				local Wslot = member:FindItemSlot('item_ward_observer');
				if GetUnitToLocationDistance(bot, ping.location) <= 600 and 
				   GameTime() - ping.time < 5 and 
				   Wslot == -1
				then
					return true, member;
				end	
			end
		end
	end
	return false, nil;
end

function X.GetAvailableSpot(bot)
	local temp = {};
	for _,s in pairs(X.GetMandatorySpot()) do
		if not X.CloseToAvailableWard(s) then
			table.insert(temp, s);
		end
	end
	for _,s in pairs(X.GetWardSpotWhenTowerFall()) do
		if not X.CloseToAvailableWard(s) then
			table.insert(temp, s);
		end
	end
	if DotaTime() > 5*60 then
		for _,s in pairs(X.GetAggressiveSpot()) do
			if GetUnitToLocationDistance(bot, s) <= 1200 and not X.CloseToAvailableWard(s) then
				table.insert(temp, s);
			end
		end
	end
	return temp;
end

function X.CloseToAvailableWard(wardLoc)
	local WardList = GetUnitList(UNIT_LIST_ALLIED_WARDS);
	for _,ward in pairs(WardList) do
		if X.IsObserver(ward) and GetUnitToLocationDistance(ward, wardLoc) <= visionRad then
			return true;
		end
	end
	return false;
end

function X.GetClosestSpot(bot, spots)
	local cDist = 100000;
	local cTarget = nil;
	for _, spot in pairs(spots) do
		local dist = GetUnitToLocationDistance(bot, spot);
		if dist < cDist then
			cDist = dist;
			cTarget = spot;
		end
	end
	return cTarget, cDist;
end

function X.IsObserver(wardUnit)
	return wardUnit:GetUnitName() == "npc_dota_observer_wards";
end

function X.GetHumanPing()
	local teamIDs = GetTeamPlayers(GetTeam());
	for i,id in pairs(teamIDs)
	do
		local hUnit = GetTeamMember(i);
		if hUnit ~= nil and not hUnit:IsBot() then
			return hUnit:GetMostRecentPing();
		end
	end
	return nil;
end


return X