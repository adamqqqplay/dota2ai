local campUtils = require(GetScriptDirectory() .. "/util/CampUtility")
local A = require(GetScriptDirectory() .. "/util/MiraDota")
local bot = GetBot()
local sec = 0;
local preferedCamp = nil;
local AvailableCamp = {};
local LaneCreeps = {};
local numCamp = 1; -- will update when camps are loaded
local farmState = 0;
local teamPlayers = nil;
local lanes = { LANE_TOP, LANE_MID, LANE_BOT };
local cause = "";
local cogsTarget = nil;
local cLoc = nil;
local farmLane = false;


function GetDesire()

	sec = DotaTime() % 60

	-- If there are any missing camps,
	-- refresh at 0:30, and upon each minute
	if #AvailableCamp < numCamp and ((DotaTime() > 30 and DotaTime() < 31)
		or (DotaTime() > 30 and sec > 0 and sec < 1))
	then
		AvailableCamp, numCamp = campUtils.RefreshCamp(bot);
	end

	if teamPlayers == nil then teamPlayers = GetTeamPlayers(GetTeam()) end

	local EnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE);

	local heroDesire = HeroSpecificDesire()
	if heroDesire ~= nil then
		return heroDesire
	end

	-- Requirements to allow farming mode:
	-- * Be alive
	-- * Be a hero that farms
	-- * Between level 6 and 30
	-- * No humans on team
	-- * Game is not mid only
	-- * Have something to buy
	-- * No enemies nearby, and none have damaged us recently
	-- * No enemy heroes near our base
	-- * We aren't trying to retreat or go to secret shop

	if not (bot:IsAlive()
			and campUtils.IsStrongJungler(bot)
			and bot:GetLevel() >=6 and bot:GetLevel() < 30)
		or IsHumanPlayerInTeam()
		or GetGameMode() == GAMEMODE_MO
		or bot:GetNextItemPurchaseValue() == 0
		or A.Unit.WasRecentlyDamagedByEnemy(bot, 3.0) or #EnemyHeroes >= 1
		or IsUnitAroundLocation(GetAncient(GetTeam()):GetLocation(), 3000)
		or (bot:GetActiveMode() == BOT_MODE_RETREAT and bot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH)
		or bot.SecretShop
	then
		return BOT_MODE_DESIRE_NONE;
	end

	LaneCreeps = bot:GetNearbyLaneCreeps(1600, true);
	if LaneCreeps ~= nil and #LaneCreeps > 0 then
		return BOT_MODE_DESIRE_HIGH;
	else
		if preferedCamp == nil then preferedCamp = campUtils.GetClosestNeutralSpwan(bot, AvailableCamp) end
		if preferedCamp ~= nil then
			if bot:GetHealth() / bot:GetMaxHealth() <= 0.15 then
				return BOT_MODE_DESIRE_LOW;
			elseif farmState == 1 then
				return BOT_MODE_DESIRE_ABSOLUTE;
			elseif not campUtils.IsSuitableToFarm(bot) then
				return BOT_MODE_DESIRE_NONE;
			else
				return BOT_MODE_DESIRE_HIGH;
			end
		end

		-- No camps available to farm
		return BOT_MODE_DESIRE_NONE

	end

end

function HeroSpecificDesire()
	local EnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE);

	if bot:GetUnitName() == "npc_dota_hero_rattletrap" then
		local num_cogs = 0;

		if (bot:GetActiveMode() == BOT_MODE_RETREAT and bot:WasRecentlyDamagedByAnyHero(3.0)) or #EnemyHeroes == 0 or
			cause == "cogs" then
			local units = GetUnitList(UNIT_LIST_ALLIED_OTHER);
			local minDist = 10000;
			for _, u in pairs(units) do
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
				for _, u in pairs(units) do
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

	return nil
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
			local t = 2.0 * bot:GetAttackPoint() + ((GetUnitToUnitDistance(target, bot)) / bot:GetCurrentMovementSpeed());
			print(tostring(bot:GetEstimatedDamageToTarget(false, target, t, DAMAGE_TYPE_PHYSICAL) ..
				"><" .. tostring(target:GetHealth())))
			if bot:WasRecentlyDamagedByTower(1.0) or bot:WasRecentlyDamagedByCreep(1.0) then
				bot:Action_MoveToLocation(GetAncient(GetTeam()):GetLocation());
				return
			elseif bot:GetEstimatedDamageToTarget(false, target, t, DAMAGE_TYPE_PHYSICAL) >= target:GetHealth() then
				bot:Action_AttackUnit(target, true);
				return
			else
				bot:Action_MoveToLocation(target:GetLocation());
				return
			end
		else
			bot:Action_MoveToLocation(cLoc + RandomVector(200));
			return
		end
	end

	if cause == "cogs" then
		print("Attack Cogs")
		bot:Action_ClearActions(false);
		bot:Action_AttackUnit(cogsTarget, true);
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
		local stackMove = campUtils.GetCampMoveToStack(bot, preferedCamp)
		local stackTime = campUtils.GetCampStackTime(preferedCamp);
		if (cDist > 300 or IsLocationVisible(preferedCamp.cattr.location) == false) and farmState == 0 then
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
	for _, id in pairs(GetTeamPlayers(GetTeam())) do
		if not IsPlayerBot(id)
		then
			return true;
		end
	end
	return false;
end


function GetDistance(s, t)
	return math.sqrt((s[1] - t[1]) * (s[1] - t[1]) + (s[2] - t[2]) * (s[2] - t[2]));
end

function GetSaveLocToFarmLane()
	local minDist = 100000;
	local clashLoc = nil;
	for _, lane in pairs(lanes) do
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
	for i, id in pairs(GetTeamPlayers(GetOpposingTeam())) do
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
	for _, unit in pairs(units) do
		local hp = unit:GetHealth();
		if hp < lowestHP then
			lowestHP = hp;
			lowestUnit = unit;
		end
	end
	return lowestUnit;
end
