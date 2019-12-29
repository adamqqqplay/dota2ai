local X = {}

local team =  GetTeam();

local pIDs = GetTeamPlayers(team);

local npcBot = GetBot();

npcBot.courierID = 0;
local calibrateTime = DotaTime();
local checkCourier = false;
local define_courier = false;
local cr = nil;
X.pIDInc = 1;
X.calibrateTime = DotaTime();

return X
