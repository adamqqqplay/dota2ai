----------------------------------------------------------------------------------------------------
-- Author:Arizona Fauzie  BOT EXPERIMENT Link:http://steamcommunity.com/sharedfiles/filedetails/?id=837040016
----------------------------------------------------------------------------------------------------
local X = {}

local visionRad = 2000;

---RADIANT WARDING SPOT
local RADIANT_RUNE_WARD = Vector( 2606, -1547, 0 )

local RADIANT_T3TOPFALL = Vector( -6600.000000, -3072.000000, 0.000000 ) --高地防御眼
local RADIANT_T3MIDFALL = Vector( -4314.000000, -3887.000000, 0.000000 )
local RADIANT_T3BOTFALL = Vector( -3586.000000, -6131.000000, 0.000000 )

local RADIANT_T2TOPFALL = Vector( -4345, -1018, 663 )  --二塔野区高台
local RADIANT_T2MIDFALL = Vector( 1283, -5109, 655 ) --天辉下路野区高台
local RADIANT_T2BOTFALL = Vector( -514, -3321, 655 )  --下路野区内高台

local RADIANT_T1TOPFALL = Vector( -4089, 1544, 535 )  --天辉上路野区高台
local RADIANT_T1MIDFALL = Vector( 2818, -3047, 655 )  --下方河道野区高台
local RADIANT_T1BOTFALL = Vector( 5253, -4844, 0 ) --下路野区十字路口

local RADIANT_MANDATE1 = Vector( -1243, -200, 0 )   ---天辉中路河道眼       
local RADIANT_MANDATE2 = RADIANT_RUNE_WARD  ---天辉看符眼

---DIRE WARDING SPOT
local DIRE_RUNE_WARD = Vector( 2606, -1547, 0 )

local DIRE_T3TOPFALL = Vector( 3087.000000, 5690.000000, 0.000000 )
local DIRE_T3MIDFALL = Vector( 4024.000000, 3445.000000, 0.000000 )
local DIRE_T3BOTFALL = Vector( 6354.000000, 2606.000000, 0.000000 )

local DIRE_T2TOPFALL = Vector( 514, 4107, 655 )  --夜魇上路野区高台
local DIRE_T2MIDFALL = Vector( 2047, -769, 655 )  --夜魇中路河道野区入口
local DIRE_T2BOTFALL = Vector( 4620, 788, 655 ) --夜魇下路高台

local DIRE_T1TOPFALL = Vector( -2815, 3565, 256 )   --夜魇上路野区河道路口
local DIRE_T1MIDFALL = Vector( -760, 2053, 655 )    --夜魇中路一塔野区入口高台
local DIRE_T1BOTFALL = Vector( 5122, -1930, 527 )   --夜魇下路一塔高台

local DIRE_MANDATE1 =  DIRE_RUNE_WARD       --夜魇看符眼      
local DIRE_MANDATE2 =  Vector( -463, 447, 0 )   --夜魇中路河道眼   

local RADIANT_AGGRESSIVETOP  = DIRE_T2TOPFALL --夜魇上路野区高台
local RADIANT_AGGRESSIVEMID1 = DIRE_T1MIDFALL --夜魇中路一塔野区入口高台
local RADIANT_AGGRESSIVEMID2 = DIRE_T2MIDFALL --夜魇中路河道野区入口
local RADIANT_AGGRESSIVEBOT  = DIRE_T2BOTFALL --夜魇下路高台

local DIRE_AGGRESSIVETOP  = RADIANT_T1TOPFALL --天辉上路野区高台
local DIRE_AGGRESSIVEMID1 = RADIANT_T2TOPFALL --天辉二塔野区高台
local DIRE_AGGRESSIVEMID2 = RADIANT_T2MIDFALL --天辉下路野区高台
local DIRE_AGGRESSIVEBOT  = RADIANT_T2BOTFALL --天辉下路野区内高台


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