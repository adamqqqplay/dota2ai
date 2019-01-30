----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.3 New Structure
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
-------
_G._savedEnv = getfenv()
module("ability_item_usage_generic", package.seeall)
local utility = require(GetScriptDirectory() .. "/utility")
local Courier = dofile(GetScriptDirectory() .. "/util/CourierSystem")
local ItemUsageSystem = dofile(GetScriptDirectory() .. "/util/ItemUsageSystem")

local function ConsiderGlyph()
	local Towers = {
		TOWER_TOP_1,
		TOWER_TOP_2,
		TOWER_TOP_3,
		TOWER_MID_1,
		TOWER_MID_2,
		TOWER_MID_3,
		TOWER_BOT_1,
		TOWER_BOT_2,
		TOWER_BOT_3,
		TOWER_BASE_1,
		TOWER_BASE_2
	}

	if GetGlyphCooldown() > 0 then
		return false
	end

	for i, BuildingID in pairs(Towers) do
		local tower = GetTower(GetTeam(), BuildingID)
		if tower ~= nil then
			local tableNearbyEnemyHeroes = utility.GetEnemiesNearLocation(tower:GetLocation(), 700)
			if tower:GetHealth() >= 200 and tower:GetHealth() <= 1000 and #tableNearbyEnemyHeroes >= 2 then
				GetBot():ActionImmediate_Glyph()
				break
			end
		end
	end
end

local function RecordStuckState()
	local npcBot = GetBot()
	local botLoc = npcBot:GetLocation();
	if npcBot:IsAlive() and npcBot:GetCurrentActionType() == BOT_ACTION_TYPE_MOVE_TO and not IsLocationPassable(botLoc) then
		if npcBot.stuckLoc == nil then
			npcBot.stuckLoc = botLoc
			npcBot.stuckTime = DotaTime();
		elseif npcBot.stuckLoc ~= botLoc then
			npcBot.stuckLoc = botLoc
			npcBot.stuckTime = DotaTime();
		end
	else	
		npcBot.stuckTime = nil;
		npcBot.stuckLoc = nil;
	end
end

local announceFlag=false
local function SendAnnouncement()
	if announceFlag == false then
		announceFlag = true;
		for id=1,36,1
		do
			if(IsPlayerBot(id)==true)
			then
				if(GetTeamForPlayer(id)==GetTeam())
				then
					local npcBot=GetBot();
					if(npcBot:GetPlayerID()==id)
					then
						npcBot:ActionImmediate_Chat(
							"Welcome to Ranked Matchmaking AI, the current version is 1.6b, updated on January 31, 2019. If you have any questions or feedback, please leave message on steam workshop https://steamcommunity.com/sharedfiles/filedetails/?id=855965029 or contact adamqqq@163.com",
							true
						)
						npcBot:ActionImmediate_Chat(
							"Please use hard or unfair mode and do not play Monkey king. 请使用困难或疯狂难度，不要使用齐天大圣。",
							true
						)
					end
				end
				return;
			end
		end
	end
end

function CourierUsageThink()
	ConsiderGlyph()
	ItemUsageSystem.UnImplementedItemUsage()
	Courier.CourierUsageThink()
	RecordStuckState()

	if(DotaTime()>=-60 and DotaTime()<=-59)
	then
		SendAnnouncement()
	end
end

function AbilityLevelUpThink2(AbilityToLevelUp, TalentTree)
	local npcBot = GetBot()
	if
		(npcBot:GetAbilityPoints() < 1 or #AbilityToLevelUp == 0 or
			(GetGameState() ~= GAME_STATE_PRE_GAME and GetGameState() ~= GAME_STATE_GAME_IN_PROGRESS))
	 then
		return
	end

	local abilityname = AbilityToLevelUp[1]
	if abilityname == "nil" then
		table.remove(AbilityToLevelUp, 1)
		return
	end
	if abilityname == "talent" then
		local level = npcBot:GetLevel()
		for i, temp in pairs(AbilityToLevelUp) do
			if temp == "talent" then
				table.remove(AbilityToLevelUp, i)
				table.insert(AbilityToLevelUp, i, TalentTree[1]())
				table.remove(TalentTree, 1)
				break
			end
		end
	end

	local ability = npcBot:GetAbilityByName(abilityname)

	if ability ~= nil and ability:CanAbilityBeUpgraded() then
		npcBot:ActionImmediate_LevelAbility(abilityname)
		table.remove(AbilityToLevelUp, 1)
	end
end

local function CanBuybackUpperRespawnTime(respawnTime)
	local npcBot = GetBot()
	if
		(not npcBot:IsAlive() and respawnTime ~= nil and npcBot:GetRespawnTime() >= respawnTime and
			npcBot:GetBuybackCooldown() == 0 and
			npcBot:GetGold() > npcBot:GetBuybackCost())
	 then
		return true
	end

	return false
end

--GXC BUYBACK LOGIC
function BuybackUsageThink()
	local npcBot = GetBot()
	if
		npcBot:IsInvulnerable() or not npcBot:IsHero() or not string.find(npcBot:GetUnitName(), "hero") or npcBot:IsIllusion()
	 then
		return
	end

	-- no buyback, no need to use GetUnitList() for performance considerations
	if (not CanBuybackUpperRespawnTime(20)) then
		return
	end

	local tower_top_3 = GetTower(GetTeam(), TOWER_TOP_3)
	local tower_mid_3 = GetTower(GetTeam(), TOWER_MID_3)
	local tower_bot_3 = GetTower(GetTeam(), TOWER_BOT_3)
	local tower_base_1 = GetTower(GetTeam(), TOWER_BASE_1)
	local tower_base_2 = GetTower(GetTeam(), TOWER_BASE_2)

	local barracks_top_melee = GetBarracks(GetTeam(), BARRACKS_TOP_MELEE)
	local barracks_mid_melee = GetBarracks(GetTeam(), BARRACKS_MID_MELEE)
	local barracks_bot_melee = GetBarracks(GetTeam(), BARRACKS_BOT_MELEE)

	local ancient = GetAncient(GetTeam())

	local buildList = {
		tower_top_3,
		tower_mid_3,
		tower_bot_3,
		tower_base_1,
		tower_base_2,
		barracks_top_melee,
		barracks_mid_melee,
		barracks_bot_melee,
		ancient
	}

	for _, build in pairs(buildList) do
		local tableNearbyEnemyHeroes = build:GetNearbyHeroes(1000, true, BOT_MODE_NONE)
		if DotaTime() > 25 * 60 and CanBuybackUpperRespawnTime(20) then
			if (tableNearbyEnemyHeroes ~= nil and #tableNearbyEnemyHeroes > 1) then
				if (build:WasRecentlyDamagedByAnyHero(2.0) and CanBuybackUpperRespawnTime(20)) then
					npcBot:ActionImmediate_Buyback()
					return
				end
			end
		end
	end

	if (DotaTime() > 35 * 60 and CanBuybackUpperRespawnTime(30)) then
		npcBot:ActionImmediate_Buyback()
	end
end

function InitAbility(Abilities, AbilitiesReal, Talents)
	local npcBot = GetBot()
	for i = 0, 25, 1 do
		local ability = npcBot:GetAbilityInSlot(i)
		if (ability ~= nil) then
			if (ability:GetName() ~= "generic_hidden") then
				if (ability:IsTalent() == true) then
					table.insert(Talents, ability:GetName())
				else
					table.insert(Abilities, ability:GetName())
					table.insert(AbilitiesReal, ability)
				end
			end
		end
	end
end

function GetComboMana(AbilitiesReal)
	local npcBot = GetBot()
	local tempComboMana = 0
	for i, ability in pairs(AbilitiesReal) do
		if ability:IsPassive() == false then
			if ability:IsUltimate() == false or ability:GetCooldownTimeRemaining() <= 30 then
				tempComboMana = tempComboMana + ability:GetManaCost()
			end
		end
	end
	return math.max(tempComboMana, 300)
end

function GetComboDamage(AbilitiesReal)
	local npcBot = GetBot()
	local tempComboDamage = 0
	for i, ability in pairs(AbilitiesReal) do
		if ability:IsPassive() == false then
			tempComboDamage = tempComboDamage + ability:GetAbilityDamage()
		end
	end
	return math.max(tempComboDamage, GetBot():GetOffensivePower())
end

function PrintDebugInfo(AbilitiesReal, cast)
	local npcBot = GetBot()
	for i = 1, #AbilitiesReal do
		if (cast.Desire[i] ~= nil and cast.Desire[i] > 0) then
			local ability = AbilitiesReal[i]
			if
				((cast.Type[i] == nil or cast.Type[i] == "Target") and cast.Target[i] ~= nil and
					utility.CheckFlag(ability:GetBehavior(), ABILITY_BEHAVIOR_UNIT_TARGET))
			 then
				if (cast.Target[i] ~= nil) then
					utility.DebugTalk(
						"try to use skill " .. i .. " at " .. cast.Target[i]:GetUnitName() .. " Desire= " .. cast.Desire[i]
					)
				else
					utility.DebugTalk("try to use skill " .. i .. " Desire= " .. cast.Desire[i])
				end
			else
				utility.DebugTalk("try to use skill " .. i .. " Desire= " .. cast.Desire[i])
			end
		end
	end
end

function ConsiderAbility(AbilitiesReal, Consider)
	local npcBot = GetBot()
	local cast = {}
	cast.Desire = {}
	cast.Target = {}
	cast.Type = {}
	for i, ability in pairs(AbilitiesReal) do
		if ability:IsPassive() == false and Consider[i] ~= nil then
			cast.Desire[i], cast.Target[i], cast.Type[i] = Consider[i]()
		end
	end
	return cast
end

function UseAbility(AbilitiesReal, cast)
	local npcBot = GetBot()

	local HighestDesire = 0
	local HighestDesireAbility = 0
	local HighestDesireAbilityBumber = 0
	for i, ability in pairs(AbilitiesReal) do
		if (cast.Desire[i] ~= nil and cast.Desire[i] > HighestDesire) then
			HighestDesire = cast.Desire[i]
			HighestDesireAbilityBumber = i
		end
	end
	if (HighestDesire > 0) then
		local j = HighestDesireAbilityBumber
		local ability = AbilitiesReal[j]
		if (cast.Type[j] == nil) then
			if (utility.CheckFlag(ability:GetBehavior(), ABILITY_BEHAVIOR_NO_TARGET)) then
				npcBot:Action_UseAbility(ability)
				return
			elseif (utility.CheckFlag(ability:GetBehavior(), ABILITY_BEHAVIOR_POINT)) then
				npcBot:Action_UseAbilityOnLocation(ability, cast.Target[j])
				return
			elseif (utility.CheckFlag(ability:GetTargetType(), ABILITY_TARGET_TYPE_TREE)) then
				npcBot:Action_UseAbilityOnTree(ability, cast.Target[j])
				return
			else
				npcBot:Action_UseAbilityOnEntity(ability, cast.Target[j])
				return
			end
		else
			if (cast.Type[j] == "Target") then
				npcBot:Action_UseAbilityOnEntity(ability, cast.Target[j])
				return
			elseif (cast.Type[j] == "Location") then
				npcBot:Action_UseAbilityOnLocation(ability, cast.Target[j])
				return
			else
				npcBot:Action_UseAbility(ability)
				return
			end
		end
	end
end

for k, v in pairs(ability_item_usage_generic) do
	_G._savedEnv[k] = v
end
