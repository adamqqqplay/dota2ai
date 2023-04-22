----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.7
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
if GetBot():IsInvulnerable() or not GetBot():IsHero() or not string.find(GetBot():GetUnitName(), "hero") or
	GetBot():IsIllusion() then
	return
end

local npcBot = GetBot()
if npcBot == nil then
	return
end

function GetDesire()
	if npcBot.pushWhenNoEnemies then
		return 0
	end

	local currentTime = DotaTime()
	local botLV = npcBot:GetLevel()

	if currentTime <= 5
	then
		return 0.268
	end

	if currentTime <= 9 * 60
		and botLV <= 7
	then
		return 0.446
	end

	if currentTime <= 12 * 60
		and botLV <= 11
	then
		return 0.369
	end

	if botLV <= 17
	then
		return 0.228
	end

	return 0
end

----------------------------------------------------------------------------------------------------
