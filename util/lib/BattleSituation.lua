--
-- Copyright (c) 2023. Ranked Matchmaking AI Developers. All rights reserved.
-- 
-- SPDX-License-Identifier: GPL-3.0-or-later
--

local X={}

function X.GetNumOfAliveHeroes( bEnemy )

	local count = 0
	local nTeam = GetTeam()
	if bEnemy then nTeam = GetOpposingTeam() end

	for i, id in pairs( GetTeamPlayers( nTeam ) )
	do
		if IsHeroAlive( id )
		then
			count = count + 1
		end
	end

	return count

end

function X.GetSpecialModeAllies( bot, nDistance, nMode )

	local allyList = {}
	local numPlayer = GetTeamPlayers( GetTeam() )
	for i = 1, #numPlayer
	do
		local member = GetTeamMember( i )
		if member ~= nil and member:IsAlive()
		then
			if member:GetActiveMode() == nMode
				and GetUnitToUnitDistance( member, bot ) <= nDistance
			then
				table.insert( allyList, member )
			end
		end
	end

	return allyList

end

function X.GetSpecialModeAlliesCount( nMode )

	local allyList = X.GetSpecialModeAllies( GetBot(), 99999, nMode )

	return #allyList

end

function X.GetCenterOfUnits( nUnits )

	if #nUnits == 0
	then
		return Vector( 0.0, 0.0 )
	end

	local sum = Vector( 0.0, 0.0 )
	local num = 0

	for _, unit in pairs( nUnits )
	do
		if unit ~= nil
			and unit:IsAlive()
		then
			sum = sum + unit:GetLocation()
			num = num + 1
		end
	end

	if num == 0 then return Vector( 0.0, 0.0 ) end

	return sum / num

end

function X.IsInTeamFight( bot, nRadius )

	if nRadius == nil or nRadius > 1600 then nRadius = 1600 end

	local attackModeAllyList = bot:GetNearbyHeroes( nRadius, false, BOT_MODE_ATTACK )

	return #attackModeAllyList >= 2 and bot:GetActiveMode() ~= BOT_MODE_RETREAT

end

function X.IsSuspiciousIllusion( npcTarget )

	if not npcTarget:IsHero()
		or npcTarget:IsCastingAbility()
		or npcTarget:IsUsingAbility()
		or npcTarget:IsChanneling()
	then
		return false
	end

	local bot = GetBot()

	if npcTarget:GetTeam() == bot:GetTeam()
	then
		return npcTarget:IsIllusion() or npcTarget:HasModifier( "modifier_arc_warden_tempest_double" )
	elseif npcTarget:GetTeam() == GetOpposingTeam()
	then

		if npcTarget:HasModifier( 'modifier_illusion' )
			or npcTarget:HasModifier( 'modifier_phantom_lancer_doppelwalk_illusion' )
			or npcTarget:HasModifier( 'modifier_phantom_lancer_juxtapose_illusion' )
			or npcTarget:HasModifier( 'modifier_darkseer_wallofreplica_illusion' )
			or npcTarget:HasModifier( 'modifier_terrorblade_conjureimage' )
		then
			return true
		end

		local tID = npcTarget:GetPlayerID()

		if not IsHeroAlive( tID )
		then
			return true
		end

		if GetHeroLevel( tID ) > npcTarget:GetLevel()
		then
			return true
		end
		--[[
		if GetSelectedHeroName( tID ) ~= "npc_dota_hero_morphling"
			and GetSelectedHeroName( tID ) ~= npcTarget:GetUnitName()
		then
			return true
		end
		--]]
	end

	return false

end

function X.GetEnemyList( bot, nRadius )

	if nRadius > 1600 then nRadius = 1600 end
	local nRealEnemyList = {}
	local nCandidate = bot:GetNearbyHeroes( nRadius, true, BOT_MODE_NONE )
	if nCandidate[1] == nil then return nCandidate end

	for _, enemy in pairs( nCandidate )
	do
		if enemy ~= nil and enemy:IsAlive()
			and not X.IsSuspiciousIllusion( enemy )
		then
			table.insert( nRealEnemyList, enemy )
		end
	end

	return nRealEnemyList

end


function X.GetEnemyCount( bot, nRadius )

	local nRealEnemyList = X.GetEnemyList( bot, nRadius )

	return #nRealEnemyList

end

function X.GetTeamFightLocation( bot )

	local targetLocation = nil
	local numPlayer = GetTeamPlayers( GetTeam() )

	for i = 1, #numPlayer
	do
		local member = GetTeamMember( i )
		if member ~= nil and member:IsAlive()
			and X.IsInTeamFight( member, 1500 )
			and X.GetEnemyCount( member, 1400 ) >= 2
		then
			local allyList = X.GetSpecialModeAllies( member, 1400, BOT_MODE_ATTACK )
			targetLocation = X.GetCenterOfUnits( allyList )
			break
		end
	end

	return targetLocation

end

function X.GetNumEnemyNearby( building )

	local nearbynum = 0
	for i, id in pairs( GetTeamPlayers( GetOpposingTeam() ) )
	do
		if IsHeroAlive( id )
		then
			local info = GetHeroLastSeenInfo( id )
			if info ~= nil
			then
				local dInfo = info[1]
				if dInfo ~= nil
					and GetUnitToLocationDistance( building, dInfo.location ) <= 3000
					and dInfo.time_since_seen < 1.0
				then
					nearbynum = nearbynum + 1
				end
			end
		end
	end

	return nearbynum

end

return X