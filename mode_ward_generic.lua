----------------------------------------------------------------------------------------------------
-- Author:Arizona Fauzie  BOT EXPERIMENT Link:http://steamcommunity.com/sharedfiles/filedetails/?id=837040016
----------------------------------------------------------------------------------------------------
if GetBot():IsInvulnerable() or not GetBot():IsHero() or not string.find(GetBot():GetUnitName(), "hero") or  GetBot():IsIllusion() then
	return;
end

local wardUtils = require(GetScriptDirectory() ..  "/WardUtility")
local bot = GetBot();
local AvailableSpots = {};
local nWardCastRange = 500;
local wt = nil;
local itemWard = nil;
local targetLoc = nil;
local wardCastTime = -90;
local swapTime = -90;
local targetLoc, targetDist;
local chat = false;


function GetDesire()

	--[[local pg = wardUtils.GetHumanPing();
	if pg ~= nil and pg.time > 0 and GameTime() - pg.time < 0.5 then
		print(tostring(pg.location));
	end]]--

	if bot:IsChanneling() or bot:IsIllusion() or bot:IsInvulnerable() or not bot:IsHero() or not IsSuitableToWard() 
	   or bot:GetCurrentActionType() == BOT_ACTION_TYPE_IDLE 
	then
		return BOT_MODE_DESIRE_NONE;
	end
	
	itemWard = wardUtils.GetItemWard(bot);
	
	if itemWard ~= nil and DotaTime() > wardCastTime + 1.0 then
		pinged, wt = wardUtils.IsPingedByHumanPlayer(bot);
		if pinged then	
			return RemapValClamped(GetUnitToUnitDistance(bot, wt), 1000, 0, BOT_MODE_DESIRE_HIGH, BOT_MODE_DESIRE_VERYHIGH);
		end
		AvailableSpots = wardUtils.GetAvailableSpot(bot);
		targetLoc, targetDist = wardUtils.GetClosestSpot(bot, AvailableSpots);
		if targetLoc ~= nil then
			return RemapValClamped(targetDist, 6000, 0, BOT_MODE_DESIRE_MODERATE-0.1, BOT_MODE_DESIRE_HIGH-0.1);
		end
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
	
	if targetDist <= nWardCastRange then
		if  DotaTime() - swapTime > 6.75 then
			bot:Action_UseAbilityOnLocation(itemWard, targetLoc);
			wardCastTime = DotaTime();	
			return
		else
			bot:Action_MoveToLocation(targetLoc+RandomVector(400));
			return
		end
	else
		bot:Action_MoveToLocation(targetLoc);
		return
	end
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