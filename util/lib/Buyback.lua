--
-- Copyright (c) 2023. Ranked Matchmaking AI Developers. All rights reserved.
-- 
-- SPDX-License-Identifier: GPL-3.0-or-later
--

local X={}

local BattleSituation = require(GetScriptDirectory() .. "/util/lib/BattleSituation")

X['LastTeamBuybackTime'] = -90;

function X.CanBuybackUpperRespawnTime(respawnTime)
	local npcBot = GetBot()
    if npcBot == nil then
        return
    end

	if (not npcBot:IsAlive() and respawnTime ~= nil and npcBot:GetRespawnTime() >= respawnTime and
		npcBot:GetBuybackCooldown() <= 0 and
		npcBot:GetGold() > npcBot:GetBuybackCost())
	then
		return true
	end

	return false
end

function X.BuybackUsageComplement()

    local npcBot = GetBot()
    if npcBot == nil then
        return
    end

	if npcBot:GetLevel() <= 15
		or npcBot:HasModifier( 'modifier_arc_warden_tempest_double' )
		or DotaTime() < X['LastTeamBuybackTime'] + 2.0
	then
		return
	end

	if not npcBot:HasBuyback() or npcBot:GetRespawnTime() < 60 then
		return
	end

	if not X.CanBuybackUpperRespawnTime(60) then
		return
	end

	if npcBot:GetLevel() > 24 and npcBot:GetRespawnTime() >= 75
	then
		local nTeamFightLocation =BattleSituation.GetTeamFightLocation()
		if nTeamFightLocation ~= nil
		then
			X['LastTeamBuybackTime'] = DotaTime()
			npcBot:ActionImmediate_Buyback()
			return
		end
	end

	local ancient = GetAncient( GetTeam() )
	if ancient ~= nil
	then
		local nEnemyCount = BattleSituation.GetNumEnemyNearby( ancient )
		local nAllyCount = BattleSituation.GetNumOfAliveHeroes( false )
		if nEnemyCount > 0 and nEnemyCount >= nAllyCount
		then
			X['LastTeamBuybackTime'] = DotaTime()
			npcBot:ActionImmediate_Buyback()
			return
		end
	end

end

return X