----------------------------------------------------------------------------------------------------
--- The Creation Come From: BOT EXPERIMENT Credit:FURIOUSPUPPY
--- BOT EXPERIMENT Author: Arizona Fauzie 2018.11.21
--- Link:http://steamcommunity.com/sharedfiles/filedetails/?id=837040016
----------------------------------------------------------------------------------------------------

if GetBot():IsInvulnerable() or not GetBot():IsHero() or not string.find(GetBot():GetUnitName(), "hero") or
	GetBot():IsIllusion() then
	return
end


local ItemUsage   = require(GetScriptDirectory() .. "/util/ItemUsage-New")
local X           = {}
local Role        = require(GetScriptDirectory() .. "/util/RoleUtility");
local bot         = GetBot()
local minute      = 0
local sec         = 0
local closestRune = -1
local runeStatus  = -1
local ProxDist    = 1600
local teamPlayers = nil
local pingTimeGap = 20
local bottle      = nil

local vRadiantDropLocation = Vector(-6843, -6618, 384)
local vDireDropLocation = Vector(7062, 6200, 384)

X['nStopWaitTime'] = RandomInt(3, 8)
function X.GetRuneActionTime()
	return X['nStopWaitTime']
end

X['lastPowerRuneTime'] = 90
function X.IsPowerRuneKnown()
	return math.floor(X['lastPowerRuneTime'] / 120) == math.floor(DotaTime() / 120)
end

local runeLocation = nil
local nStopWaitTime = X.GetRuneActionTime()

local bMidHumanHere = false

local nRuneList = {
	RUNE_BOUNTY_1, --天辉野区
	RUNE_BOUNTY_2, --夜魇野区
	--	RUNE_BOUNTY_3,
	--	RUNE_BOUNTY_4,
	RUNE_POWERUP_1, --上路
	RUNE_POWERUP_2, --下路
}

local vWaitRuneLocList = {

	[1] = Vector(-4450, 1952, 0), --天辉中
	[2] = Vector(-6285, 4911, 0), --夜魇上
	[3] = Vector(4606, -1803, 0), --夜魇中
	[4] = Vector(6503, -4506, 0), --天辉下

}


function GetDesire()

	--	if 7.29 then return 0 end

	if GetGameMode() == GAMEMODE_1V1MID
		or (GetGameMode() == GAMEMODE_MO and DotaTime() <= 0)
		or (bot:HasModifier("modifier_arc_warden_tempest_double"))
		or (DotaTime() > -10 and bot:GetCurrentActionType() == BOT_ACTION_TYPE_IDLE)
	then
		return BOT_MODE_DESIRE_NONE
	end

	if teamPlayers == nil then teamPlayers = GetTeamPlayers(GetTeam()) end

	minute = math.floor(DotaTime() / 60)
	sec = DotaTime() % 60


	if not X.IsSuitableToPickRune() then
		return BOT_MODE_DESIRE_NONE
	end


	if DotaTime() < 0
		and not bot:WasRecentlyDamagedByAnyHero(12.0)
	then
		local enemyHeroList = bot:GetNearbyHeroes(1400, true, BOT_MODE_NONE)
		if #enemyHeroList <= 1
		then
			return BOT_MODE_DESIRE_MODERATE
		end
	end


	if DotaTime() < 5 * 60 and DotaTime() > 30
		and not bMidHumanHere
		and bot:GetAssignedLane() == LANE_MID
	then
		local enemyHeroList = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
		for i = 1, #enemyHeroList do
			if enemyHeroList[i] ~= nil
				and not enemyHeroList[i]:IsBot()
			then
				bMidHumanHere = true
			end
		end
	end


	if DotaTime() > 26 * 60
		and X.IsUnitAroundLocation(GetAncient(GetTeam()):GetLocation(), 2800)
	then
		ProxDist = 900
	else
		ProxDist = 1600
	end

	closestRune, closestDist = X.GetBotClosestRune()
	if closestRune ~= -1 and closestDist < 6000
	then
		if closestRune == RUNE_BOUNTY_1
			or closestRune == RUNE_BOUNTY_2
		then

			runeStatus = GetRuneStatus(closestRune)

			if runeStatus == RUNE_STATUS_AVAILABLE
				and (X.IsTeamMustSaveRune(closestRune) or DotaTime() > 585)
			then
				if X.IsEnemyPickRune(bot, closestRune) then return BOT_MODE_DESIRE_NONE end
				return X.CountDesire(BOT_MODE_DESIRE_HIGH, closestDist, 3500)
			elseif runeStatus == RUNE_STATUS_UNKNOWN
				and closestDist <= ProxDist * 1.5
				and DotaTime() > 2 * 60 + 50
				and ((minute % 3 == 0) or (minute % 3 == 2 and sec > 45))
			then
				return X.CountDesire(BOT_MODE_DESIRE_MODERATE, closestDist, ProxDist)
			elseif runeStatus == RUNE_STATUS_MISSING
				and DotaTime() > 2 * 60
				and (minute % 3 == 2 and sec > 52)
				and closestDist <= ProxDist * 2
			then
				return X.CountDesire(BOT_MODE_DESIRE_MODERATE, closestDist, ProxDist * 2)
			elseif X.IsTeamMustSaveRune(closestRune)
				and runeStatus == RUNE_STATUS_UNKNOWN
				and DotaTime() > 173
				and ((minute % 3 == 0) or (minute % 3 == 2 and sec > 45))
			then
				return X.CountDesire(BOT_MODE_DESIRE_MODERATE, closestDist, 5000)
			end
		else

			if bMidHumanHere
				and bot:GetAssignedLane() == LANE_MID
				and DotaTime() < 7 * 60
			then
				return BOT_MODE_DESIRE_NONE
			end


			runeStatus = GetRuneStatus(closestRune)

			if runeStatus == RUNE_STATUS_AVAILABLE then
				if X.IsEnemyPickRune(bot, closestRune) then return BOT_MODE_DESIRE_NONE end
				return X.CountDesire(BOT_MODE_DESIRE_MODERATE, closestDist, ProxDist * 2.5)
			elseif runeStatus == RUNE_STATUS_UNKNOWN and closestDist <= ProxDist and DotaTime() > 113 then
				return X.CountDesire(BOT_MODE_DESIRE_MODERATE, closestDist, ProxDist)
			elseif runeStatus == RUNE_STATUS_MISSING and DotaTime() > 60 and (minute % 2 == 1 and sec > 53) and
				closestDist <= ProxDist then
				return X.CountDesire(BOT_MODE_DESIRE_MODERATE, closestDist, ProxDist)
			elseif X.IsTeamMustSaveRune(closestRune) and runeStatus == RUNE_STATUS_UNKNOWN and DotaTime() > 113 and
				closestDist <= ProxDist * 2 then
				return X.CountDesire(BOT_MODE_DESIRE_MODERATE, closestDist, ProxDist * 2)
			end

		end
	end

	return BOT_MODE_DESIRE_NONE
end

function OnStart()
	local bottle_slot = bot:FindItemSlot('item_bottle')
	if bot:GetItemSlotType(bottle_slot) == ITEM_SLOT_TYPE_MAIN then
		bottle = bot:GetItemInSlot(bottle_slot)
	end
end

function OnEnd()
	bottle = nil
end

function Think()

	if bot:IsChanneling()
		or bot:NumQueuedActions() > 0
		or bot:IsCastingAbility()
		or bot:IsUsingAbility()
		or bot:GetCurrentActionType() == BOT_ACTION_TYPE_PICK_UP_RUNE
		or (GetGameState() ~= GAME_STATE_PRE_GAME and GetGameState() ~= GAME_STATE_GAME_IN_PROGRESS)
	then
		return
	end


	if DotaTime() < 0
	then

		if DotaTime() < -35
		then
			local vGoOutLocation = X.GetGoOutLocation()

			if GetUnitToLocationDistance(bot, vGoOutLocation) > 500
			then
				bot:Action_MoveToLocation(vGoOutLocation)
				return
			end

			bot:Action_ClearActions(false)
			return
		end

		if GetTeam() == TEAM_RADIANT
		then
			if bot:GetAssignedLane() == LANE_BOT
			then
				-- bot:Action_MoveToLocation( GetTower( TEAM_RADIANT, TOWER_BOT_2 ):GetLocation() + RandomVector( 20 ) )
				bot:Action_MoveToLocation(GetRuneSpawnLocation(RUNE_BOUNTY_2) + RandomVector(50)) --B2
				return
			else
				bot:Action_MoveToLocation(GetRuneSpawnLocation(RUNE_POWERUP_1) + RandomVector(50)) --P1
				return
			end
		else
			if bot:GetAssignedLane() == LANE_TOP
			then
				-- bot:Action_MoveToLocation( GetTower( TEAM_DIRE, TOWER_TOP_2 ):GetLocation() + RandomVector( 20 ))
				bot:Action_MoveToLocation(GetRuneSpawnLocation(RUNE_BOUNTY_1) + RandomVector(50)) --B1
				return
			else
				bot:Action_MoveToLocation(GetRuneSpawnLocation(RUNE_POWERUP_2) + RandomVector(50)) --P2
				return
			end
		end
	end



	if runeStatus == RUNE_STATUS_AVAILABLE
	then

		if bottle ~= nil and closestDist < 1200
		then
			local bottle_charge = bottle:GetCurrentCharges()
			if bottle:IsFullyCastable()
				and bottle_charge > 0
				and (bot:GetHealth() < bot:GetMaxHealth() or bot:GetMana() < bot:GetMaxMana())
			then
				bot:Action_UseAbility(bottle)
				return
			end
		end

		if closestDist > 118 then -- 128 to pick rune

			local nAttactRange = bot:GetAttackRange() + 90
			if nAttactRange > 1400 then nAttactRange = 1400 end
			local nEnemys = bot:GetNearbyHeroes(nAttactRange, true, BOT_MODE_NONE)
			if nEnemys[1] ~= nil and nEnemys[1]:IsAlive() and nEnemys[1]:CanBeSeen()
				and
				1.5 * bot:GetEstimatedDamageToTarget(true, bot, 4.0, DAMAGE_TYPE_ALL) >
				nEnemys[1]:GetEstimatedDamageToTarget(true, bot, 4.0, DAMAGE_TYPE_ALL)
				and bot:GetHealth() > 500
			then
				bot:Action_AttackUnit(nEnemys[1], true)
				return
			end

			if bot:GetLevel() >= 10
				and bot:GetUnitName() ~= "npc_dota_hero_antimage"
				and bot:GetPrimaryAttribute() == ATTRIBUTE_AGILITY
			then
				local nCreeps = bot:GetNearbyCreeps(nAttactRange + 90, true)
				if nCreeps[1] ~= nil
					and nCreeps[1]:IsAlive()
					and nCreeps[1]:GetHealth() < 1400
				then
					bot:Action_AttackUnit(nCreeps[1], true)
					return
				end
			end

			if X.CouldBlink(bot, GetRuneSpawnLocation(closestRune)) then return end

			bot:Action_MoveToLocation(GetRuneSpawnLocation(closestRune) + RandomVector(20))
			return
		else
			bot:Action_PickUpRune(closestRune)
			return
		end
	else

		local nAttactRange = bot:GetAttackRange() + 80
		if nAttactRange > 1400 then nAttactRange = 1400 end
		local nEnemys = bot:GetNearbyHeroes(nAttactRange, true, BOT_MODE_NONE)
		if nEnemys[1] ~= nil
			and nEnemys[1]:IsAlive()
			and nEnemys[1]:CanBeSeen()
			and
			1.6 * bot:GetEstimatedDamageToTarget(true, bot, 4.0, DAMAGE_TYPE_ALL) >
			nEnemys[1]:GetEstimatedDamageToTarget(true, bot, 4.0, DAMAGE_TYPE_ALL)
			and bot:GetHealth() > 500
		then
			bot:Action_AttackUnit(nEnemys[1], true)
			return
		end

		if bot:GetLevel() >= 10
			and bot:GetUnitName() ~= "npc_dota_hero_antimage"
			and bot:GetPrimaryAttribute() ~= ATTRIBUTE_INTELLECT
		then
			local nCreeps = bot:GetNearbyCreeps(nAttactRange + 90, true)
			if nCreeps[1] ~= nil and nCreeps[1]:IsAlive()
			then
				bot:Action_AttackUnit(nCreeps[1], true)
				return
			end
		end

		bot:Action_MoveToLocation(GetRuneSpawnLocation(closestRune))
		return
	end

end

function X.GetDistance(s, t)
	return math.sqrt((s[1] - t[1]) * (s[1] - t[1]) + (s[2] - t[2]) * (s[2] - t[2]))
end

function X.GetXUnitsTowardsLocation(hUnit, vLocation, nDistance)
	local direction = (vLocation - hUnit:GetLocation()):Normalized()
	return hUnit:GetLocation() + direction * nDistance
end

function X.CountDesire(base_desire, dist, maxDist)
	return base_desire + math.floor((RemapValClamped(dist, maxDist, 0, 0, 1 - base_desire)) * 40) / 40
end

function X.GetBotClosestRune()

	local cDist = 100000
	local cRune = -1
	for _, r in pairs(nRuneList) do
		local rLoc = GetRuneSpawnLocation(r)
		if not X.IsHumanPlayerNearby(rLoc)
			and not X.IsPingedByHumanPlayer(rLoc)
			and not X.IsThereMidlaner(rLoc)
			and not X.IsThereCarry(rLoc)
			and not X.IsMissing(r)
			--and not X.IsKnown(r)
			and X.IsTheClosestOne(rLoc)
		then
			local dist = GetUnitToLocationDistance(bot, rLoc)
			if dist < cDist
			then
				cDist = dist
				cRune = r
			end
		end
	end
	return cRune, cDist
end

function X.IsMissing(r)

	local sec = DotaTime() % 60
	local runeStatus = GetRuneStatus(r)

	if sec < 52 -- here has a bug
		and runeStatus == RUNE_STATUS_MISSING
	then
		return true
	end

	return false
end

function X.IsKnown(r) --存在问题

	if DotaTime() < 6 * 60
		or DotaTime() > 39 * 60 + 50 then return false end

	if r == RUNE_POWERUP_1
		or r == RUNE_POWERUP_2
	then
		local runeStatus = GetRuneStatus(r)

		if (minute % 2 == 0 or sec < 52)
			and runeStatus == RUNE_STATUS_UNKNOWN
		--			and X.IsPowerRuneKnown()
		then
			return true
		end

	end

	return false
end

function X.IsTeamMustSaveRune(rune)
	if GetTeam() == TEAM_DIRE
	then
		return rune == RUNE_BOUNTY_1
			or rune == RUNE_POWERUP_2
			or (DotaTime() > 1 * 60 + 45 and rune == RUNE_POWERUP_1)
			or (DotaTime() > 10 * 60 + 45 and rune == RUNE_BOUNTY_2)
	else
		return rune == RUNE_BOUNTY_2
			or rune == RUNE_POWERUP_1
			or (DotaTime() > 1 * 60 + 45 and rune == RUNE_POWERUP_2)
			or (DotaTime() > 10 * 60 + 45 and rune == RUNE_BOUNTY_1)
	end
end

function X.IsHumanPlayerNearby(runeLoc)

	if IsPlayerBot(teamPlayers[1]) then return false end

	for k, v in pairs(teamPlayers) do
		local member = GetTeamMember(k)
		if member ~= nil and not IsPlayerBot(v) and member:IsAlive()
		then
			local humanDist = GetUnitToLocationDistance(member, runeLoc)
			local selfDist = GetUnitToLocationDistance(bot, runeLoc)
			if (selfDist > 800 and humanDist < 2800)
				or humanDist < 2000
			then
				return true
			end
		end
	end

	return false
end

function X.IsPingedByHumanPlayer(runeLoc)

	if IsPlayerBot(teamPlayers[1]) then return false end

	local listPings = {}
	local dist2 = GetUnitToLocationDistance(bot, runeLoc)
	for k, v in pairs(teamPlayers) do
		local member = GetTeamMember(k)
		if member ~= nil and not member:IsIllusion() and not IsPlayerBot(v) and member:IsAlive() then
			local ping = member:GetMostRecentPing()
			table.insert(listPings, ping)
		end
	end
	for _, p in pairs(listPings) do
		if p ~= nil and not p.normal_ping and X.GetDistance(p.location, runeLoc) < 1200 and dist2 < 1200 and
			GameTime() - p.time < pingTimeGap then
			return true
		end
	end
	return false
end

function X.IsTheClosestOne(r)
	local minDist = GetUnitToLocationDistance(bot, r)
	local closest = bot
	for k, v in pairs(teamPlayers) do
		local member = GetTeamMember(k)
		if member ~= nil and not member:IsIllusion() and member:IsAlive() then
			local dist = GetUnitToLocationDistance(member, r)
			if dist < minDist then
				minDist = dist
				closest = member
			end
		end
	end
	return closest == bot
end

function X.IsThereMidlaner(runeLoc)

	if X.IsNotPowerRune(runeLoc) then return false end

	for k, v in pairs(teamPlayers) do
		local member = GetTeamMember(k)
		if member ~= nil and not member:IsIllusion() and member:IsAlive() and member:GetAssignedLane() == LANE_MID then
			local dist1 = GetUnitToLocationDistance(member, runeLoc)
			local dist2 = GetUnitToLocationDistance(bot, runeLoc)
			if dist2 < 1200 and dist1 < 1200 and bot:GetUnitName() ~= member:GetUnitName() then
				return true
			end
		end
	end

	return false
end

function X.IsThereCarry(runeLoc)

	if X.IsNotPowerRune(runeLoc) then return false end

	for k, v in pairs(teamPlayers) do
		local member = GetTeamMember(k)
		if member ~= nil
			and member:IsAlive() and Role.CanBeSafeLaneCarry(member:GetUnitName())
			and
			(
			(GetTeam() == TEAM_DIRE and member:GetAssignedLane() == LANE_TOP) or
				(GetTeam() == TEAM_RADIANT and member:GetAssignedLane() == LANE_BOT))
		then
			local dist1 = GetUnitToLocationDistance(member, runeLoc)
			local dist2 = GetUnitToLocationDistance(bot, runeLoc)
			if dist2 < 1200 and dist1 < 1200 and bot:GetUnitName() ~= member:GetUnitName() then
				return true
			end
		end
	end

	return false
end

function X.IsSuitableToPickRune()

	if X.IsNearRune(bot) then return true end

	local mode = bot:GetActiveMode()
	local nEnemies = bot:GetNearbyHeroes(1300, true, BOT_MODE_NONE)

	if (mode == BOT_MODE_RETREAT and bot:GetActiveModeDesire() > BOT_MODE_DESIRE_HIGH)
		or (#nEnemies >= 1 and X.IsIBecameTheTarget(nEnemies))
		or (bot:WasRecentlyDamagedByAnyHero(5.0) and mode == BOT_MODE_RETREAT)
		or (GetUnitToUnitDistance(bot, GetAncient(GetTeam())) < 2500 and DotaTime() > 0)
		or GetUnitToUnitDistance(bot, GetAncient(GetOpposingTeam())) < 4000
		or bot:HasModifier('modifier_item_shadow_amulet_fade')
	then
		return false
	end

	return true

end

function X.IsIBecameTheTarget(units)
	for _, u in pairs(units) do
		if u:GetAttackTarget() == bot then
			return true
		end
	end
	return false
end

function X.IsNearRune(bot)

	for _, r in pairs(nRuneList) do
		local rLoc = GetRuneSpawnLocation(r)
		if GetUnitToLocationDistance(bot, rLoc) <= 400
		then
			return true
		end
	end

	return false

end

function X.IsNotPowerRune(runeLoc)

	local rLocOne = GetRuneSpawnLocation(RUNE_POWERUP_1)
	local rLocTwo = GetRuneSpawnLocation(RUNE_POWERUP_2)

	if X.GetDistance(rLocOne, runeLoc) >= 600 and X.GetDistance(rLocTwo, runeLoc) >= 600
	then
		return true
	end

	return false
end

function X.CouldBlink(bot, nLocation)

	local blinkSlot = bot:FindItemSlot("item_blink")

	if bot:GetItemSlotType(blinkSlot) == ITEM_SLOT_TYPE_MAIN
		or bot:GetUnitName() == "npc_dota_hero_antimage"
	then
		local blink = bot:GetItemInSlot(blinkSlot)
		if bot:GetUnitName() == "npc_dota_hero_antimage"
		then
			blink = bot:GetAbilityByName("antimage_blink")
		end

		if blink ~= nil
			and blink:IsFullyCastable()
		then
			local bDist = GetUnitToLocationDistance(bot, nLocation)
			local maxBlinkLoc = X.GetXUnitsTowardsLocation(bot, nLocation, 1199)
			if bDist <= 500
			then
				return false
			elseif bDist < 1200
			then
				ItemUsage.UseItemOnLocation(bot, blink, nLocation)
				return true
			elseif IsLocationPassable(maxBlinkLoc)
			then
				ItemUsage.UseItemOnLocation(bot, blink, maxBlinkLoc)
				return true
			end
		end
	end

	return false
end

function X.IsUnitAroundLocation(vLoc, nRadius)
	for i, id in pairs(GetTeamPlayers(GetOpposingTeam())) do
		if IsHeroAlive(id) then
			local info = GetHeroLastSeenInfo(id)
			if info ~= nil then
				local dInfo = info[1]
				if dInfo ~= nil and X.GetDistance(vLoc, dInfo.location) <= nRadius and dInfo.time_since_seen < 1.0 then
					return true
				end
			end
		end
	end
	return false
end

function X.IsEnemyPickRune(bot, nRune)

	local nEnemys = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
	local runeLocation = GetRuneSpawnLocation(nRune)
	if GetUnitToLocationDistance(bot, runeLocation) < 500 then return false end

	for _, enemy in pairs(nEnemys) do
		if enemy ~= nil and enemy:IsAlive()
			and
			(
			enemy:IsFacingLocation(runeLocation, 30) or enemy:IsFacingLocation(bot:GetLocation(), 30) or
				GetUnitToLocationDistance(enemy, runeLocation) < 500)
			and GetUnitToLocationDistance(enemy, runeLocation) < GetUnitToLocationDistance(bot, runeLocation) + 300
		then
			return true
		end
	end

	return false
end

function X.GetWaitRuneLocation(nRune)

	local vLocation = GetRuneSpawnLocation(nRune)

	if DotaTime() > -nStopWaitTime or true then return vLocation end

	local vNearestLoc = nil
	local nDist = 99999
	for _, loc in pairs(vWaitRuneLocList) do
		local nLocDist = X.GetDistance(loc, vLocation)
		if nLocDist < nDist
		then
			vNearestLoc = loc
			nDist = nLocDist
		end
	end

	return vNearestLoc

end

function X.GetGoOutLocation()

	local nLane = bot:GetAssignedLane()
	local vLocation = X.GetXUnitsTowardsLocation(GetTower(GetTeam(), TOWER_MID_2),
		GetTower(GetTeam(), TOWER_MID_1):GetLocation(), 300)

	if nLane == LANE_BOT
	then
		vLocation = X.GetXUnitsTowardsLocation(GetTower(GetTeam(), TOWER_BOT_2), GetTower(GetTeam(), TOWER_BOT_1):GetLocation()
			, 300)
	elseif nLane == LANE_TOP
	then
		vLocation = X.GetXUnitsTowardsLocation(GetTower(GetTeam(), TOWER_TOP_2), GetTower(GetTeam(), TOWER_TOP_1):GetLocation()
			, 300)
	end

	return vLocation

end

-- dota2jmz@163.com QQ:2462331592..
