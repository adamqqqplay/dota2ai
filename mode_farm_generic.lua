local campUtils = require(GetScriptDirectory() ..  "/util/CampUtility")
local bot = GetBot()
local minute = 0;
local sec = 0;
local preferedCamp = nil;
local AvailableCamp = {};
local LaneCreeps = {};
local numCamp = 18;
local farmState = 0;
local teamPlayers = nil;
local lanes = {LANE_TOP, LANE_MID, LANE_BOT};
local cause = "";
local cogsTarget = nil;
local t3Destroyed = false;
--local shrineTarget = nil;
local cLoc = nil;
local farmLane = false;

local tPing = 0;
local tChat = 0;

local testTime = 0;

function GetDesire()	
	
	--campUtils.PrintCamps()

	--[[if DotaTime() > testTime + 20.0 then
		campUtils.PingCamp(1, 3, TEAM_RADIANT, bot);
		testTime = DotaTime();
	end]]--

	if bot:GetUnitName() == "npc_dota_hero_faceless_voids" and bot:IsAlive() then
		cLoc = GetSaveLocToFarmLane();
		if cLoc ~= nil  then
			--bot:ActionImmediate_Ping(cLoc.x, cLoc.y, true);
			--tPing = DotaTime();
			farmLane = true;
			return BOT_MODE_DESIRE_ABSOLUTE;
		else
			farmLane = false;
		end
	end
	
	local num_cogs = 0;
	
	if IsUnitAroundLocation(GetAncient(GetTeam()):GetLocation(), 3000) then
		return BOT_MODE_DESIRE_NONE;
	end
	
	if teamPlayers == nil then teamPlayers = GetTeamPlayers(GetTeam()) end
	
	local EnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE);
	
	minute = math.floor(DotaTime() / 60)
	sec = DotaTime() % 60
	
	if #AvailableCamp < numCamp and ( ( DotaTime() > 30 and DotaTime() < 60 and sec > 30 and sec < 31 ) 
	   or ( DotaTime() > 30 and  sec > 0 and sec < 1 ) ) 
	then
		AvailableCamp, numCamp = campUtils.RefreshCamp(bot);
		--print(tostring(GetTeam())..tostring(#AvailableCamp))
	end
	
	if bot:GetUnitName() == "npc_dota_hero_rattletrap" then
		if ( bot:GetActiveMode() == BOT_MODE_RETREAT and bot:WasRecentlyDamagedByAnyHero(3.0) ) or #EnemyHeroes == 0 or cause == "cogs" then
			local units = GetUnitList(UNIT_LIST_ALLIED_OTHER);
			local minDist = 10000;
			for _,u in pairs(units)
			do
				if u:GetUnitName() == "npc_dota_rattletrap_cog" then
					num_cogs = num_cogs + 1;
					local cogDist = GetUnitToUnitDistance(u, GetAncient(GetTeam()));
					if cogDist < minDist then
						cogsTarget = u;
						minDist = cogDist;
					end
				end
			end
			if num_cogs == 8 then
				--print("attack cogs while retreat. Num cogs = "..tostring(num_cogs));
				cause = "cogs";
				return BOT_MODE_DESIRE_ABSOLUTE;
			end
		elseif bot:GetActiveMode() == BOT_MODE_ATTACK or cause == "cogs" then
			local npcTarget = bot:GetTarget();
			if npcTarget ~= nil and npcTarget:IsHero() and GetUnitToUnitDistance(bot, npcTarget) > 300 then
				local units = GetUnitList(UNIT_LIST_ALLIED_OTHER);
				local minDist = 10000;
				for _,u in pairs(units)
				do
					if u:GetUnitName() == "npc_dota_rattletrap_cog" then
						num_cogs = num_cogs + 1;
						local cogDist = GetUnitToUnitDistance(u, npcTarget);
						if cogDist < minDist then
							cogsTarget = u;
							minDist = cogDist;
						end
					end
				end
				if num_cogs == 8 then
					cause = "cogs";
					return BOT_MODE_DESIRE_ABSOLUTE;
				end
			end
		end	
		
	end
	
	if #EnemyHeroes > 0 then
		return BOT_MODE_DESIRE_NONE;
	end		
	
	if not bot:IsAlive() or bot:IsChanneling() or bot:GetCurrentActionType() == 1 or bot:GetNextItemPurchaseValue() == 0 
	   or bot:WasRecentlyDamagedByAnyHero(3.0) or #EnemyHeroes >= 1 
	   or ( bot:GetActiveMode() == BOT_MODE_RETREAT and bot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH )
	   or bot.SecretShop
	then
		return BOT_MODE_DESIRE_NONE;
	end
	
	if t3Destroyed == false then
		t3Destroyed = IsThereT3Detroyed();
	--else
	--	if bot:DistanceFromFountain() > 10000 then
	--		shrineTarget = GetTargetShrine();
	--		local barracks = bot:GetNearbyBarracks(700, true);
	--		if shrineTarget ~= nil and ( barracks == nil or #barracks == 0 ) and IsSuitableToDestroyShrine()  then
	--			cause = "shrine";
	--			return BOT_MODE_DESIRE_VERYHIGH;
	--		end
	--	end
	end
	
	if campUtils.IsStrongJungler(bot) and bot:GetLevel() >= 6 and bot:GetLevel() < 30 and not IsHumanPlayerInTeam() and GetGameMode() ~= GAMEMODE_MO 
	then
		LaneCreeps = bot:GetNearbyLaneCreeps(1600, true);
		if LaneCreeps ~= nil and #LaneCreeps > 0 then
			return BOT_MODE_DESIRE_HIGH;
		else
			if preferedCamp == nil then preferedCamp = campUtils.GetClosestNeutralSpwan(bot, AvailableCamp) end
			if preferedCamp ~= nil then
				if bot:GetHealth() / bot:GetMaxHealth() <= 0.15 then 
					preferedCamp = nil;
					return BOT_MODE_DESIRE_LOW;
				elseif farmState == 1 then 
					return BOT_MODE_DESIRE_ABSOLUTE;
				elseif not campUtils.IsSuitableToFarm(bot) then 
					preferedCamp = nil;
					return BOT_MODE_DESIRE_NONE;
				else
					return BOT_MODE_DESIRE_VERYHIGH;
				end
			end
		end
	end
	
	return 0.0
	
end

function OnEnd()
	preferedCamp = nil;
	farmState = 0;
	cogsTarget = nil;
	cogs = "";
	cause = "";
	--shrineTarget = nil;
end

function Think()
	if bot:IsUsingAbility() or bot:IsChanneling() then 
		return
	end
	
	if farmLane then
		local laneCreeps = bot:GetNearbyLaneCreeps(1600, true);
		local target = GetWeakestUnit(laneCreeps);
		if target ~= nil then
			local t = 2.0*bot:GetAttackPoint()+((GetUnitToUnitDistance(target, bot))/bot:GetCurrentMovementSpeed());
			print(tostring(bot:GetEstimatedDamageToTarget(false, target, t, DAMAGE_TYPE_PHYSICAL ).."><"..tostring(target:GetHealth())))
			if bot:WasRecentlyDamagedByTower(1.0) or bot:WasRecentlyDamagedByCreep(1.0) then
				bot:Action_MoveToLocation(GetAncient(GetTeam()):GetLocation());
				return
			elseif  bot:GetEstimatedDamageToTarget(false, target, t, DAMAGE_TYPE_PHYSICAL) >= target:GetHealth() then
				bot:Action_AttackUnit(target, true);
				return
			else
				bot:Action_MoveToLocation(target:GetLocation());
				return
			end
		else
			bot:Action_MoveToLocation(cLoc+RandomVector(200));
			return
		end
	end
	
	if cause == "cogs" then
		print("Attack Cogs")
		bot:Action_AttackUnit( cogsTarget, true );
		cause = "";
		return
	end	
	
	if LaneCreeps ~= nil and #LaneCreeps > 0 then
		local farmTarget = campUtils.FindFarmedTarget(LaneCreeps)
		if farmTarget ~= nil then
			--print("This")
			bot:Action_AttackUnit(farmTarget, true);
			return
		end
	end
		
	if preferedCamp ~= nil then
		local cDist = GetUnitToLocationDistance(bot, preferedCamp.cattr.location);
		local stackMove = campUtils.GetCampMoveToStack(preferedCamp.idx);
		local stackTime =  campUtils.GetCampStackTime(preferedCamp);
		if cDist > 300 and farmState == 0 then
			bot:Action_MoveToLocation(preferedCamp.cattr.location);
			return
		else
			local neutralCreeps = bot:GetNearbyNeutralCreeps(800);
			local farmTarget = campUtils.FindFarmedTarget(neutralCreeps)
			if farmTarget ~= nil then
				farmState = 1;
				if sec >= stackTime then
					bot:Action_MoveToLocation(stackMove);
					return
				else
					bot:Action_AttackUnit(farmTarget, true);
					return
				end
			else
				farmState = 0;
				AvailableCamp, preferedCamp = campUtils.UpdateAvailableCamp(bot, preferedCamp, AvailableCamp);
			end
		end	
	end
	
end

function IsHumanPlayerInTeam()
	for _,id in pairs(GetTeamPlayers(GetTeam())) 
	do 
		if not IsPlayerBot(id) 
		then 
			return true;
		end
	end 
	return false;
end

function IsThereT3Detroyed()
	
	local T3s = {
		TOWER_TOP_3,
		TOWER_MID_3,
		TOWER_BOT_3
	}
	
	for _,t in pairs(T3s) do
		local tower = GetTower(GetOpposingTeam(), t);
		if tower == nil or not tower:IsAlive() then
			return true;
		end
	end	
	return false;
end

--function GetTargetShrine()
--	local shrines = {
--		 SHRINE_JUNGLE_1,
--		 SHRINE_JUNGLE_2
--	}
--	for _,s in pairs(shrines) do
--		local shrine = GetShrine(GetOpposingTeam(), s);
--		if  shrine ~= nil and shrine:IsAlive() then
--			return shrine;
--		end
--	end
--	return nil;
--end
--
--function IsSuitableToDestroyShrine()
--	local mode = bot:GetActiveMode();
--	if bot:WasRecentlyDamagedByTower(2.0) or bot:WasRecentlyDamagedByAnyHero(3.0)
--	   or mode == BOT_MODE_DEFEND_TOWER_TOP
--	   or mode == BOT_MODE_DEFEND_TOWER_MID
--	   or mode == BOT_MODE_DEFEND_TOWER_BOT
--	   or mode == BOT_MODE_ATTACK
--	   or mode == BOT_MODE_RETREAT and bot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH
--	then
--		return false;
--	end
--	return true;
--end

function GetDistance(s, t)
    return math.sqrt((s[1]-t[1])*(s[1]-t[1]) + (s[2]-t[2])*(s[2]-t[2]));
end

function GetSaveLocToFarmLane()
	local minDist = 100000;
	local clashLoc = nil;
	for _,lane in pairs(lanes)
	do
		local tFLoc = GetLaneFrontLocation(GetTeam(), lane, 0);
		local eFLoc = GetLaneFrontLocation(GetOpposingTeam(), lane, 0);
		local fDist = GetDistance(tFLoc, eFLoc);
		local uDist = GetUnitToLocationDistance(bot, tFLoc);
		if fDist <= 1000 and uDist < minDist and not IsUnitAroundLocation(eFLoc, 2000) then
			minDist = uDist;
			clashLoc = tFLoc;
		end
	end
	return clashLoc;
end

function IsUnitAroundLocation(vLoc, nRadius)
	for i,id in pairs(GetTeamPlayers(GetOpposingTeam())) do
		if IsHeroAlive(id) then
			local info = GetHeroLastSeenInfo(id);
			if info ~= nil then
				local dInfo = info[1];
				if dInfo ~= nil and GetDistance(vLoc, dInfo.location) <= nRadius and dInfo.time_since_seen < 1.0 then
					return true;
				end
			end
		end
	end
	return false;
end

function GetWeakestUnit(units)
	local lowestHP = 10000;
	local lowestUnit = nil;
	for _,unit in pairs(units)
	do
		local hp = unit:GetHealth();
		if hp < lowestHP then
			lowestHP = hp;
			lowestUnit = unit;	
		end
	end
	return lowestUnit;
end