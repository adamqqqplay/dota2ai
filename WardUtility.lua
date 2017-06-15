local X = {}

---RADIANT WARDING SPOT
local RADIANT_T3TOPFALL = Vector(-6633, -3010);
local RADIANT_T3MIDFALL = Vector(-4393, -3854);
local RADIANT_T3BOTFALL = Vector(-3600, -6096);

local RADIANT_T2TOPFALL = Vector(-4381, -1311);
local RADIANT_T2MIDFALL = Vector(-960, -4613);
local RADIANT_T2BOTFALL = Vector(1396, -4686);

local RADIANT_T1TOPFALL = Vector(-5118, 2043);
local RADIANT_T1MIDFALL = Vector(-56, -1085);
local RADIANT_T1BOTFALL = Vector(5142, -3794);

local RADIANT_MANDATE1 = Vector(-2930, 775);
local RADIANT_MANDATE2 = Vector(1798, -2826);

local RADIANT_AGGRESSIVETOP = Vector(-4705, 1125);
local RADIANT_AGGRESSIVEMID1 = Vector(-3310, -1420);
local RADIANT_AGGRESSIVEMID2 = Vector(-865, -4013);
local RADIANT_AGGRESSIVEBOT = Vector(2162, -3869);

---DIRE WARDING SPOT
local DIRE_T3TOPFALL = Vector(3111, 5832);
local DIRE_T3MIDFALL = Vector(4006, 3481);
local DIRE_T3BOTFALL = Vector(6300, 2627);

local DIRE_T2TOPFALL = Vector(1010, 4619);
local DIRE_T2MIDFALL = Vector(981, 2278);
local DIRE_T2BOTFALL = Vector(5069, -760);

local DIRE_T1TOPFALL = Vector(-2833, 3900);
local DIRE_T1MIDFALL = Vector(787, -465);
local DIRE_T1BOTFALL = Vector(5130, -799);

local DIRE_MANDATE1 = Vector(3333, -1506);
local DIRE_MANDATE2 = Vector(-970, 1329);
--local DIRE_MANDATE2 = Vector(-1282, 2880);

local DIRE_AGGRESSIVETOP = Vector(-1999, 4853);
local DIRE_AGGRESSIVEMID1 = Vector(-60, 2310);
local DIRE_AGGRESSIVEMID2 = Vector(3320, -10);
local DIRE_AGGRESSIVEBOT = Vector(5130, -799);


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
	local AggressiveRadiant = {
		DIRE_AGGRESSIVETOP,
		DIRE_AGGRESSIVEMID1,
		DIRE_AGGRESSIVEMID2,
		DIRE_AGGRESSIVEBOT
	}

	local AggressiveDire = {
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

function X.UpdateWardSpot(WardSpot)
	for i = 1, #WardSpot
	do
		if X.IsWardInCertainPlace(WardSpot[i]) then
			print(i.."true")
			table.remove(WardSpot, i);
		end
	end
	return WardSpot;
end

function X.HasWardInInventory()
	local bot = GetBot();
	local slot = bot:FindItemSlot('item_ward_observer');
	if slot >= 0 and slot <= 8 then
		return slot;
	else
		return -1;
	end
end

function X.GetItemCharges(item)
	local npcBot = GetBot();
	local charges = item:GetCurrentCharges();
	return charges;
end

function X.IsWardInCertainPlace(vPlace)
	local WardList = GetUnitList(UNIT_LIST_ALLIED_WARDS);
	for _,ward in pairs(WardList)
	do
		local wardLoc = ward:GetLocation();
		if vPlace.x == wardLoc.x then
			return true;
		end
	end
	return false;
end

return X