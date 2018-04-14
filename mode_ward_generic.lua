-- ----------------------------------------------------------------------------------------------------
-- -- Author:Arizona Fauzie  BOT EXPERIMENT Link:http://steamcommunity.com/sharedfiles/filedetails/?id=837040016
-- ----------------------------------------------------------------------------------------------------


if GetBot():IsInvulnerable() or not GetBot():IsHero() or not string.find(GetBot():GetUnitName(), "hero") or  GetBot():IsIllusion() then
	return;
end

local wardUtils = require(GetScriptDirectory() ..  "/WardUtility")
local role = require(GetScriptDirectory() .. "/RoleUtility");
local bot = GetBot();
local AvailableSpots = {};
local nWardCastRange = 500;
local wt = nil;
local itemWard = nil;
local targetLoc = nil;
local smoke = nil;
local wardCastTime = -90;
local swapTime = -90;

bot.ward = false;
bot.steal = false;

local route = {
	Vector(-108.000000, 2271.000000, 0.000000),
	Vector(-1276.000000, 3644.000000, 0.000000),
	Vector(-3148.000000, 3720.000000, 0.000000)
}

local route2 = {
	Vector(3597.000000, 351.000000, 0.000000),
	Vector(2186.000000, -3656.000000, 0.000000),
	Vector(3689.000000, -3625.000000, 0.000000)
}

local vNonStuck = Vector(-2610.000000, 538.000000, 0.000000);

local chat = false;

function GetDesire()

	--[[local pg = wardUtils.GetHumanPing();
	if pg ~= nil and pg.time > 0 and GameTime() - pg.time < 0.25 then
		print(tostring(pg.location)..":Vis:"..tostring(IsLocationVisible(pg.location))..":Pas:"..tostring(IsLocationPassable(pg.location)));
	end]]--

	--[[if bot.lastPlayerChat ~= nil and string.find(bot.lastPlayerChat.text, "ward") then
		bot:ActionImmediate_Chat("Catch this in mode_ward_generic", false);
		bot.lastPlayerChat = nil;
	end]]--
	

	if bot:IsChanneling() or bot:IsIllusion() or bot:IsInvulnerable() or not bot:IsHero() or not IsSuitableToWard() 
	   or bot:GetCurrentActionType() == BOT_ACTION_TYPE_IDLE 
	then
		return BOT_MODE_DESIRE_NONE;
	end
	
	--[[if DotaTime() < 0 then
		local enemies = bot:GetNearbyHeroes(500, true, BOT_MODE_NONE)
		if not IsSafelaneCarry() and bot:GetAssignedLane() ~= LANE_MID 
		   and ( (GetTeam() == TEAM_RADIANT and bot:GetAssignedLane() == LANE_TOP) 
		      or (GetTeam() == TEAM_DIRE and bot:GetAssignedLane() == LANE_BOT) 
			  or  role.CanBeSupport(bot:GetUnitName()) 
			  --or ( bot:GetUnitName() == "npc_dota_hero_elder_titan" and DotaTime() > -59 ) 
			  --or ( bot:GetUnitName() == 'npc_dota_hero_wisp' and DotaTime() > -59 )
			  ) 
		  and #enemies == 0 
		then
			--bot.steal = true;
			return BOT_MODE_DESIRE_ABSOLUTE;
		end
	else	
		bot.steal = false;
	end]]
	
	itemWard = wardUtils.GetItemWard(bot);
	
	if itemWard ~= nil  then
		
		pinged, wt = wardUtils.IsPingedByHumanPlayer(bot);
		--wt = GetUnitHandleByID(bot.lastPlayerChat.text);
		if pinged then	
			return RemapValClamped(GetUnitToUnitDistance(bot, wt), 1000, 0, BOT_MODE_DESIRE_HIGH, BOT_MODE_DESIRE_VERYHIGH);
		end
		--[[if bot.lastPlayerChat ~= nil and string.find(bot.lastPlayerChat.text, "ward") then
			if GetTeamForPlayer(bot.lastPlayerChat.pid) == bot:GetTeam() then
				pinged = false;
				bot:ActionImmediate_Chat("OK I'll give you ward", false);
				bot.lastPlayerChat = nil;
			elseif GetTeamForPlayer(bot.lastPlayerChat.pid) ~= bot:GetTeam() then
				bot:ActionImmediate_Chat("You're using All Chat dude!", true);
				bot.lastPlayerChat = nil;
			end
		else
			bot.lastPlayerChat = nil;	
		end]]--
		
		AvailableSpots = wardUtils.GetAvailableSpot(bot);
		targetLoc, targetDist = wardUtils.GetClosestSpot(bot, AvailableSpots);
		if targetLoc ~= nil and DotaTime() > wardCastTime + 1.0 then
			bot.ward = true;
			return RemapValClamped(targetDist, 6000, 0, BOT_MODE_DESIRE_MODERATE, BOT_MODE_DESIRE_VERYHIGH);
		end
	else
		bot.lastPlayerChat = nil;
	end
	return BOT_MODE_DESIRE_NONE;
end

function OnStart()
	if itemWard ~= nil then
		local wardSlot = bot:FindItemSlot(itemWard:GetName());
		if bot:GetItemSlotType(wardSlot) == ITEM_SLOT_TYPE_BACKPACK then
			local leastCostItem = FindLeastItemSlot();
			if leastCostItem ~= -1 then
				swapTime = DotaTime();
				bot:ActionImmediate_SwapItems( wardSlot, leastCostItem );
				return
			end
		end
	end
end

function OnEnd()
	AvailableSpots = {};
	bot.steal = false;
	itemWard = nil;
	wt = nil;
	local wardSlot = bot:FindItemSlot('item_ward_observer');
	if wardSlot >=0 and wardSlot <= 5 then
		local mostCostItem = FindMostItemSlot();
		if mostCostItem ~= -1 then
			bot:ActionImmediate_SwapItems( wardSlot, mostCostItem );
			return
		end
	end
end

function Think()

	if  GetGameState()~=GAME_STATE_PRE_GAME and GetGameState()~= GAME_STATE_GAME_IN_PROGRESS then
		return;
	end
	
	if wt ~= nil then
		bot:Action_UseAbilityOnEntity(itemWard, wt);
		return
	end
	
	if bot.ward then
		if targetDist <= nWardCastRange then
			if  DotaTime() > swapTime + 7.0 then
				bot:Action_UseAbilityOnLocation(itemWard, targetLoc);
				wardCastTime = DotaTime();	
				return
			else
				if targetLoc.x == Vector(-2948.000000, 769.000000, 0.000000) then
					bot:Action_MoveToLocation(vNonStuck+RandomVector(300));
					return
				else	
					bot:Action_MoveToLocation(targetLoc+RandomVector(300));
					return
				end
			end
		else
			if targetLoc == Vector(-2948.000000, 769.000000, 0.000000) then
				bot:Action_MoveToLocation(vNonStuck);
				return
			else	
				bot:Action_MoveToLocation(targetLoc);
				return
			end
		end
	end
	
	--[[if bot.steal == true then
		local stealCount = CountStealingUnit();
		smoke = HasItem('item_smoke_of_deceit');
		local loc = nil;
		
		if smoke ~= nil and chat == false then
			chat = true;
			bot:ActionImmediate_Chat("Let's steal the bounty rune!",false);
			return
		end
		
		if smoke ~= nil and smoke:IsFullyCastable() and not bot:HasModifier('modifier_smoke_of_deceit') then
			bot:Action_UseAbility(smoke);
			return
		end
		
		if GetTeam() == TEAM_RADIANT then
			for _,r in pairs(route) do
				if r ~= nil then
					loc = r;
					break;
				end
			end
		else
			for _,r in pairs(route2) do
				if r ~= nil then
					loc = r;
					break;
				end
			end
		end
		
		local allies = CountStealUnitNearLoc(loc, 300);
		
		if ( GetTeam() == TEAM_RADIANT and #route == 1 ) or ( GetTeam() == TEAM_DIRE and #route2 == 1 )  then
			bot:Action_MoveToLocation(loc);
			return
		elseif GetUnitToLocationDistance(bot, loc) <= 300 and allies < stealCount then
			bot:Action_MoveToLocation(loc);
			return	
		elseif GetUnitToLocationDistance(bot, loc) > 300 then
			bot:Action_MoveToLocation(loc);
			return
		else
			if GetTeam() == TEAM_RADIANT then
				table.remove(route,1);
			else
				table.remove(route2,1);
			end
		end
		
	end]]

end

function CountStealingUnit()
	local count = 0;
	for i,id in pairs(GetTeamPlayers(GetTeam())) do
		local unit = GetTeamMember(i);
		if IsPlayerBot(id) and unit ~= nil and unit.steal == true then
			count = count + 1;
		end
	end
	return count;
end

function  CountStealUnitNearLoc(loc, nRadius)
	local count = 0;
	for i,id in pairs(GetTeamPlayers(GetTeam())) do
		local unit = GetTeamMember(i);
		if unit ~= nil and unit.steal == true and GetUnitToLocationDistance(unit, loc) <= nRadius then
			count = count + 1;
		end
	end
	return count;
end

function FindLeastItemSlot()
	local minCost = 100000;
	local idx = -1;
	for i=0,5 do
		if  bot:GetItemInSlot(i) ~= nil and bot:GetItemInSlot(i):GetName() ~= "item_aegis"  then
			local _item = bot:GetItemInSlot(i):GetName()
			if( GetItemCost(_item) < minCost ) then
				minCost = GetItemCost(_item);
				idx = i;
			end
		end
	end
	return idx;
end

function FindMostItemSlot()
	local maxCost = 0;
	local idx = -1;
	for i=6,8 do
		if  bot:GetItemInSlot(i) ~= nil  then
			local _item = bot:GetItemInSlot(i):GetName()
			if( GetItemCost(_item) > maxCost ) then
				maxCost = GetItemCost(_item);
				idx = i;
			end
		end
	end
	return idx;
end

function HasItem(item_name)
	for i=0,5  do
		local item = bot:GetItemInSlot(i); 
		if item ~= nil and item:GetName() == item_name then
			return item;
		end
	end
	return nil;
end

--check if the condition is suitable for warding
function IsSuitableToWard()
	local Enemies = bot:GetNearbyHeroes(1300, true, BOT_MODE_NONE);
	local mode = bot:GetActiveMode();
	if ( ( mode == BOT_MODE_RETREAT and bot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH )
		or mode == BOT_MODE_ATTACK
		or mode == BOT_MODE_RUNE 
		or mode == BOT_MODE_DEFEND_ALLY
		or mode == BOT_MODE_DEFEND_TOWER_TOP
		or mode == BOT_MODE_DEFEND_TOWER_MID
		or mode == BOT_MODE_DEFEND_TOWER_BOT
		or ( #Enemies >= 1 and IsIBecameTheTarget(Enemies) )
		or bot:WasRecentlyDamagedByAnyHero(5.0)
		) 
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

function IsSafelaneCarry()
	return role.CanBeSafeLaneCarry(bot:GetUnitName()) and ( (GetTeam()==TEAM_DIRE and bot:GetAssignedLane()==LANE_TOP) or (GetTeam()==TEAM_RADIANT and bot:GetAssignedLane()==LANE_BOT)  )	
end