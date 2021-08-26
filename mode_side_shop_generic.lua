----------------------------------------------------------------------------------------------------
--- The Creation Come From: BOT EXPERIMENT Credit:FURIOUSPUPPY
--- BOT EXPERIMENT Author: Arizona Fauzie 2018.11.21
--- Link:http://steamcommunity.com/sharedfiles/filedetails/?id=837040016
----------------------------------------------------------------------------------------------------
if GetBot():IsInvulnerable() or not GetBot():IsHero() or not string.find(GetBot():GetUnitName(), "hero") or GetBot():IsIllusion() then
	return;
end

local bot = GetBot()
local X = {}
local targetWatchTower = nil
local activeWatchTowerCD = 30.0
local lastActiveWatchTowerTime = 0
local nWatchTower_1 = nil
local nWatchTower_2 = nil
local ignoreDistance = 0
local bEnemyTower2Destroyed = false

function GetDesire()

	local currentTime = DotaTime()
	
	if bot:HasModifier("modifier_arc_warden_tempest_double") 
		or bot:GetCurrentActionType() == BOT_ACTION_TYPE_IDLE 
		or not X.HasEnemyTower2Destroyed()
		or X.GetAliveEnemyHeroCount() >= 4
	then
		return BOT_MODE_DESIRE_NONE
	end

	if targetWatchTower ~= nil
		and GetUnitToUnitDistance(bot,targetWatchTower) <= 3800 - ignoreDistance
		and targetWatchTower:GetTeam() ~= bot:GetTeam()
		and X.IsSuitableToActiveWatchTower()
		and lastActiveWatchTowerTime + activeWatchTowerCD < currentTime	
	then
		local nBonusDesire = -0.05
				
		if GetUnitToUnitDistance(bot,targetWatchTower) <= 600 
		then nBonusDesire = nBonusDesire + 0.02 end
		
		if bot:IsChanneling() and bot:GetActiveMode() == BOT_MODE_SIDE_SHOP 
		then 
			nBonusDesire = nBonusDesire + 0.1 
			local nEnemies = bot:GetNearbyHeroes(1600,true,BOT_MODE_NONE)
			if #nEnemies == 0 then nBonusDesire = nBonusDesire + 0.1 end
		end
	
		return BOT_MODE_DESIRE_HIGH + nBonusDesire
	end
	
	if currentTime % 60 > 0 and currentTime % 60 < 45 
	then 
		ignoreDistance = 1000
	else
		ignoreDistance = 0
	end
	
	targetWatchTower = X.GetNearestWatchTower(bot)	
	if	targetWatchTower ~= nil
		and targetWatchTower:GetTeam() == bot:GetTeam()
	then
		lastActiveWatchTowerTime = DotaTime()
	end
			
	return BOT_MODE_DESIRE_NONE

end

function Think()

	if  bot:IsChanneling() 
		or bot:NumQueuedActions() > 0
		or bot:IsCastingAbility()
		or bot:IsUsingAbility()
	then 
		return
	end
	
	if GetUnitToUnitDistance(bot,targetWatchTower) > 300
	then
		bot:Action_MoveToLocation(targetWatchTower:GetLocation() + RandomVector(30))
	else
		bot:Action_AttackUnit(targetWatchTower,false)
	end
		
end

function OnStart()

end


function OnEnd()

	targetWatchTower = nil

end

function X.GetNearestWatchTower(bot)	
	
	if nWatchTower_1 == nil 
	then
		local allUnitList = GetUnitList(UNIT_LIST_ALL)
		for _,v in pairs(allUnitList)
		do
			if v:GetUnitName() == '#DOTA_OutpostName_North' 
				or v:GetUnitName() == '#DOTA_OutpostName_South' 
			then
				if nWatchTower_1 == nil
				then
					nWatchTower_1 = v
				else
					nWatchTower_2 = v
				end
			end
		end	
	end

	if  nWatchTower_1 ~= nil and nWatchTower_2 ~= nil
		and GetUnitToUnitDistance(bot,nWatchTower_1) < GetUnitToUnitDistance(bot,nWatchTower_2)
	then
		return nWatchTower_1
	else
		return nWatchTower_2		
	end
	
end

function X.IsSuitableToActiveWatchTower()

	local mode = bot:GetActiveMode()
	local nEnemies = bot:GetNearbyHeroes(1400, true, BOT_MODE_NONE)
	local nAttackAllies = bot:GetNearbyHeroes(1200,false,BOT_MODE_ATTACK)
	local nRetreatAllies = bot:GetNearbyHeroes(1200,false,BOT_MODE_RETREAT)
	local nWatchtTowerAllies = bot:GetNearbyHeroes(1600,false,BOT_MODE_SIDE_SHOP)
	
	if ( mode == BOT_MODE_RETREAT and bot:GetActiveModeDesire() > BOT_MODE_DESIRE_HIGH )
		or ( mode == BOT_MODE_RETREAT and bot:WasRecentlyDamagedByAnyHero(2.0) )
		or ( #nAttackAllies >= 1 )
		or ( #nEnemies >= 1 and ( X.IsEnemyTargetBot(nEnemies) or #nEnemies >= 2 ) )	
		or ( #nRetreatAllies >= 2 and nRetreatAllies[2]:GetActiveModeDesire() > BOT_MODE_DESIRE_HIGH )
		or ( #nWatchtTowerAllies >= 2 and mode ~= BOT_MODE_SIDE_SHOP )
	then
		return false
	end

	return true
	
end

function X.IsEnemyTargetBot(nEnemies)
	for _,u in pairs(nEnemies) 
	do
		if u:GetAttackTarget() == bot 
		   or u:IsFacingLocation(bot:GetLocation(),10)
		   or ( targetWatchTower ~= nil and GetUnitToUnitDistance(u,targetWatchTower) < 500 )
		then
			return true
		end
	end
	return false
end

function X.HasEnemyTower2Destroyed()

	if bEnemyTower2Destroyed then return true end

	for i = 1, 7, 3
	do
		local tower = GetTower( GetOpposingTeam(), i )
		if tower == nil
		then
			bEnemyTower2Destroyed = true
			return true
		end
	end
	
	return false

end

function X.GetAliveEnemyHeroCount()

	local aliveEnemyHeroCount = 0
	
	for _, id in pairs( GetTeamPlayers( GetOpposingTeam() ) )
	do 
		if IsHeroAlive( id )
		then
			aliveEnemyHeroCount = aliveEnemyHeroCount + 1
		end
	end

	return aliveEnemyHeroCount

end