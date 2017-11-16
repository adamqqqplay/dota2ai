----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.3 New Structure
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local role = require(GetScriptDirectory() ..  "/RoleUtility")

hero_pool={"npc_dota_hero_abaddon",
		"npc_dota_hero_abyssal_underlord",
		"npc_dota_hero_alchemist",
		"npc_dota_hero_antimage",
		"npc_dota_hero_ancient_apparition",
		"npc_dota_hero_arc_warden",
		"npc_dota_hero_axe",
		"npc_dota_hero_bane",
		"npc_dota_hero_batrider",
		"npc_dota_hero_beastmaster",
		"npc_dota_hero_bloodseeker",
		"npc_dota_hero_bounty_hunter",
		"npc_dota_hero_brewmaster",
		"npc_dota_hero_bristleback",
		"npc_dota_hero_broodmother",
		"npc_dota_hero_centaur",
		"npc_dota_hero_chaos_knight",
		"npc_dota_hero_chen",
		"npc_dota_hero_clinkz",
		"npc_dota_hero_rattletrap",
		"npc_dota_hero_crystal_maiden",
		"npc_dota_hero_dark_seer",
		"npc_dota_hero_dazzle",
		"npc_dota_hero_death_prophet",
		"npc_dota_hero_disruptor",
		"npc_dota_hero_doom_bringer",
		"npc_dota_hero_dragon_knight",
		"npc_dota_hero_drow_ranger",
		"npc_dota_hero_earth_spirit",
		"npc_dota_hero_earthshaker",
		"npc_dota_hero_elder_titan",
		"npc_dota_hero_ember_spirit",
		"npc_dota_hero_enchantress",
		"npc_dota_hero_enigma",
		"npc_dota_hero_faceless_void",
		"npc_dota_hero_gyrocopter",
		"npc_dota_hero_huskar",
		"npc_dota_hero_invoker",
		"npc_dota_hero_wisp",
		"npc_dota_hero_jakiro",
		"npc_dota_hero_juggernaut",
		"npc_dota_hero_keeper_of_the_light",
		"npc_dota_hero_kunkka",
		"npc_dota_hero_legion_commander",
		"npc_dota_hero_leshrac",
		"npc_dota_hero_lich",
		"npc_dota_hero_life_stealer",
		"npc_dota_hero_lina",
		"npc_dota_hero_lion",
		"npc_dota_hero_lone_druid",
		"npc_dota_hero_luna",
		"npc_dota_hero_lycan",
		"npc_dota_hero_magnataur",
		"npc_dota_hero_medusa",
		"npc_dota_hero_meepo",
		"npc_dota_hero_mirana",
		"npc_dota_hero_morphling",
		"npc_dota_hero_monkey_king",
		"npc_dota_hero_naga_siren",
		"npc_dota_hero_furion",
		"npc_dota_hero_necrolyte",
		"npc_dota_hero_night_stalker",
		"npc_dota_hero_nyx_assassin",
		"npc_dota_hero_ogre_magi",
		"npc_dota_hero_omniknight",
		"npc_dota_hero_oracle",
		"npc_dota_hero_obsidian_destroyer",
		"npc_dota_hero_phantom_assassin",
		"npc_dota_hero_phantom_lancer",
		"npc_dota_hero_phoenix",
		"npc_dota_hero_puck",
		"npc_dota_hero_pudge",
		"npc_dota_hero_pugna",
		"npc_dota_hero_queenofpain",
		"npc_dota_hero_razor",
		"npc_dota_hero_riki",
		"npc_dota_hero_rubick",
		"npc_dota_hero_sand_king",
		"npc_dota_hero_shadow_demon",
		"npc_dota_hero_nevermore",
		"npc_dota_hero_shadow_shaman",
		"npc_dota_hero_silencer",
		"npc_dota_hero_skywrath_mage",
		"npc_dota_hero_slardar",
		"npc_dota_hero_slark",
		"npc_dota_hero_sniper",
		"npc_dota_hero_spectre",
		"npc_dota_hero_spirit_breaker",
		"npc_dota_hero_storm_spirit",
		"npc_dota_hero_sven",
		"npc_dota_hero_techies",
		"npc_dota_hero_templar_assassin",
		"npc_dota_hero_terrorblade",
		"npc_dota_hero_tidehunter",
		"npc_dota_hero_shredder",
		"npc_dota_hero_tinker",
		"npc_dota_hero_tiny",
		"npc_dota_hero_treant",
		"npc_dota_hero_troll_warlord",
		"npc_dota_hero_tusk",
		"npc_dota_hero_undying",
		"npc_dota_hero_ursa",
		"npc_dota_hero_vengefulspirit",
		"npc_dota_hero_venomancer",
		"npc_dota_hero_viper",
		"npc_dota_hero_visage",
		"npc_dota_hero_warlock",
		"npc_dota_hero_weaver",
		"npc_dota_hero_windrunner",
		"npc_dota_hero_winter_wyvern",
		"npc_dota_hero_witch_doctor",
		"npc_dota_hero_skeleton_king",
		"npc_dota_hero_zuus"}                --记录英雄池
		
hero_pool_test={
        "npc_dota_hero_axe",
        "npc_dota_hero_bane",
        "npc_dota_hero_bloodseeker",
        "npc_dota_hero_bounty_hunter",
        "npc_dota_hero_bristleback",
        "npc_dota_hero_chaos_knight",
        "npc_dota_hero_crystal_maiden",
        "npc_dota_hero_dazzle",
        "npc_dota_hero_death_prophet",
        "npc_dota_hero_dragon_knight",
        "npc_dota_hero_drow_ranger",
        "npc_dota_hero_earthshaker",
        "npc_dota_hero_jakiro",
        "npc_dota_hero_juggernaut",
        "npc_dota_hero_kunkka",
        "npc_dota_hero_lich",
        "npc_dota_hero_lina",
        "npc_dota_hero_lion",
        "npc_dota_hero_luna",
        "npc_dota_hero_necrolyte",
        "npc_dota_hero_nevermore",
        "npc_dota_hero_omniknight",
        "npc_dota_hero_oracle",
        "npc_dota_hero_phantom_assassin",
        "npc_dota_hero_pudge",
        "npc_dota_hero_razor",
        "npc_dota_hero_sand_king",
        "npc_dota_hero_skeleton_king",
        "npc_dota_hero_skywrath_mage",
        "npc_dota_hero_sniper",
        "npc_dota_hero_sven",
        "npc_dota_hero_tidehunter",
        "npc_dota_hero_tiny",
        "npc_dota_hero_vengefulspirit",
        "npc_dota_hero_viper",
        "npc_dota_hero_warlock",
        "npc_dota_hero_windrunner",
        "npc_dota_hero_witch_doctor",
        "npc_dota_hero_zuus"
}
hero_pool_my={
		-- "npc_dota_hero_zuus",
		-- "npc_dota_hero_skywrath_mage",
		-- "npc_dota_hero_ogre_magi",
		-- "npc_dota_hero_chaos_knight",
		-- "npc_dota_hero_viper",
		
		-- "npc_dota_hero_lina",
		-- "npc_dota_hero_abaddon",
		-- "npc_dota_hero_huskar",
		-- "npc_dota_hero_phantom_assassin",
		-- "npc_dota_hero_crystal_maiden",
		
		-- "npc_dota_hero_ember_spirit",
		
		-- "npc_dota_hero_shadow_shaman",
		 "npc_dota_hero_centaur",
		-- "npc_dota_hero_venomancer",
		-- "npc_dota_hero_doom_bringer",
		-- "npc_dota_hero_slardar",
		
		-- "npc_dota_hero_silencer",
		-- "npc_dota_hero_skeleton_king",
		-- "npc_dota_hero_lion",
		-- "npc_dota_hero_legion_commander",
		-- "npc_dota_hero_ursa",
		
		-- "npc_dota_hero_luna",
		-- "npc_dota_hero_necrolyte",
		-- "npc_dota_hero_undying",
		-- "npc_dota_hero_treant",
		-- "npc_dota_hero_tidehunter",
		
		-- "npc_dota_hero_slark",
		-- "npc_dota_hero_riki",
		-- "npc_dota_hero_spirit_breaker",
		-- "npc_dota_hero_vengefulspirit",
		-- "npc_dota_hero_clinkz",

		-- "npc_dota_hero_jakiro",
		-- "npc_dota_hero_leshrac",
		-- "npc_dota_hero_queenofpain",
		-- "npc_dota_hero_dazzle",
		-- "npc_dota_hero_drow_ranger",
		
		-- "npc_dota_hero_dragon_knight",
		-- "npc_dota_hero_life_stealer",
		-- "npc_dota_hero_bane",
		-- "npc_dota_hero_lich",
		-- "npc_dota_hero_nevermore",
		
		-- "npc_dota_hero_night_stalker",
		-- "npc_dota_hero_juggernaut",
		-- "npc_dota_hero_axe",
		-- "npc_dota_hero_razor",
		-- "npc_dota_hero_sand_king",
		
		-- "npc_dota_hero_oracle",
		-- "npc_dota_hero_sniper",
		-- "npc_dota_hero_bloodseeker",
		-- "npc_dota_hero_bristleback",
		-- "npc_dota_hero_earthshaker",
			
		-- "npc_dota_hero_winter_wyvern",
		-- "npc_dota_hero_pugna",
		-- "npc_dota_hero_spectre",
		-- "npc_dota_hero_antimage",
		-- "npc_dota_hero_faceless_void",
		
		-- "npc_dota_hero_warlock",
		-- "npc_dota_hero_windrunner",
		-- "npc_dota_hero_omniknight",
		-- "npc_dota_hero_tiny",
		-- "npc_dota_hero_death_prophet",
		 
		 -- "npc_dota_hero_sven",
		 -- "npc_dota_hero_bounty_hunter",	--!
		 -- "npc_dota_hero_pudge",			--!
		 -- "npc_dota_hero_witch_doctor",	--!
		 -- "npc_dota_hero_kunkka",			--!
		 
		-- "npc_dota_hero_alchemist",
		-- "npc_dota_hero_abyssal_underlord",
		-- "npc_dota_hero_ancient_apparition",
		-- "npc_dota_hero_arc_warden",
		-- "npc_dota_hero_gyrocopter",
}
allBotHeroes={
		"npc_dota_hero_zuus",
		"npc_dota_hero_skywrath_mage",
		"npc_dota_hero_ogre_magi",
		"npc_dota_hero_chaos_knight",
		"npc_dota_hero_viper",
		
		"npc_dota_hero_lina",
		"npc_dota_hero_abaddon",
		"npc_dota_hero_huskar",
		"npc_dota_hero_phantom_assassin",
		"npc_dota_hero_crystal_maiden",
		"npc_dota_hero_shadow_shaman",
		
		"npc_dota_hero_ember_spirit",
		"npc_dota_hero_centaur",
		"npc_dota_hero_venomancer",
		"npc_dota_hero_doom_bringer",
		"npc_dota_hero_slardar",
		
		"npc_dota_hero_silencer",
		"npc_dota_hero_skeleton_king",
		"npc_dota_hero_lion",
		"npc_dota_hero_legion_commander",
		"npc_dota_hero_ursa",
		
		"npc_dota_hero_luna",
		"npc_dota_hero_necrolyte",
		"npc_dota_hero_undying",
		"npc_dota_hero_treant",
		"npc_dota_hero_tidehunter",
		
		"npc_dota_hero_slark",
		"npc_dota_hero_riki",
		"npc_dota_hero_spirit_breaker",
		"npc_dota_hero_vengefulspirit",
		"npc_dota_hero_clinkz",

		"npc_dota_hero_jakiro",
		"npc_dota_hero_leshrac",
		"npc_dota_hero_queenofpain",
		"npc_dota_hero_dazzle",
		"npc_dota_hero_drow_ranger",
		
		"npc_dota_hero_dragon_knight",
		"npc_dota_hero_life_stealer",
		"npc_dota_hero_bane",
		"npc_dota_hero_lich",
		"npc_dota_hero_nevermore",
		
		"npc_dota_hero_night_stalker",
		"npc_dota_hero_juggernaut",
		"npc_dota_hero_axe",
		"npc_dota_hero_razor",
		"npc_dota_hero_sand_king",
		
		"npc_dota_hero_oracle",
		"npc_dota_hero_sniper",
		"npc_dota_hero_bloodseeker",
		"npc_dota_hero_bristleback",
		"npc_dota_hero_earthshaker",
			
			"npc_dota_hero_winter_wyvern",
			"npc_dota_hero_pugna",
			"npc_dota_hero_spectre",
			"npc_dota_hero_antimage",
			"npc_dota_hero_faceless_void",
		
		"npc_dota_hero_warlock",
		"npc_dota_hero_windrunner",
		"npc_dota_hero_omniknight",
		"npc_dota_hero_tiny",
		"npc_dota_hero_death_prophet",
		 
		 "npc_dota_hero_sven",
		 "npc_dota_hero_bounty_hunter",	--!
		 "npc_dota_hero_pudge",			--!
		 "npc_dota_hero_witch_doctor",	--!
		 "npc_dota_hero_kunkka",			--!
		 
		"npc_dota_hero_alchemist",
		"npc_dota_hero_abyssal_underlord",
		"npc_dota_hero_ancient_apparition",
		"npc_dota_hero_arc_warden",
		"npc_dota_hero_gyrocopter",
}
hero_pool_1={
	"npc_dota_hero_chaos_knight",
	"npc_dota_hero_phantom_assassin",
	"npc_dota_hero_skeleton_king",
	"npc_dota_hero_slark",
	"npc_dota_hero_clinkz",
	"npc_dota_hero_drow_ranger",
	"npc_dota_hero_dragon_knight",
	"npc_dota_hero_life_stealer",
	"npc_dota_hero_luna",
	"npc_dota_hero_juggernaut",
	"npc_dota_hero_sniper",
	"npc_dota_hero_sven",
	"npc_dota_hero_spectre",
	--"npc_dota_hero_antimage",
	"npc_dota_hero_gyrocopter",
}
hero_pool_2={
	"npc_dota_hero_zuus",
	"npc_dota_hero_lina",
	--"npc_dota_hero_ember_spirit",
	"npc_dota_hero_viper",
	"npc_dota_hero_necrolyte",
	"npc_dota_hero_queenofpain",
	"npc_dota_hero_leshrac",
	"npc_dota_hero_nevermore",
	"npc_dota_hero_pugna",
	"npc_dota_hero_death_prophet",
	"npc_dota_hero_alchemist",
	"npc_dota_hero_arc_warden",
}
hero_pool_3={
	"npc_dota_hero_huskar",
	"npc_dota_hero_centaur",
	"npc_dota_hero_doom_bringer",
	"npc_dota_hero_slardar",
	"npc_dota_hero_ursa",
	"npc_dota_hero_legion_commander",
	"npc_dota_hero_undying",
	"npc_dota_hero_tidehunter",
	"npc_dota_hero_night_stalker",
	"npc_dota_hero_axe",
	"npc_dota_hero_razor",
	--"npc_dota_hero_sand_king",
	"npc_dota_hero_bloodseeker",
	"npc_dota_hero_bristleback",
	"npc_dota_hero_faceless_void",
	"npc_dota_hero_tiny",
	"npc_dota_hero_windrunner",
	"npc_dota_hero_abyssal_underlord",
}
hero_pool_4={
	"npc_dota_hero_skywrath_mage",
	"npc_dota_hero_shadow_shaman",
	"npc_dota_hero_venomancer",
	"npc_dota_hero_abaddon",
	"npc_dota_hero_silencer",
	"npc_dota_hero_spirit_breaker",
	"npc_dota_hero_riki",
	"npc_dota_hero_bane",
	"npc_dota_hero_earthshaker",
	"npc_dota_hero_omniknight",
}
hero_pool_5={
	"npc_dota_hero_ogre_magi",
	"npc_dota_hero_crystal_maiden",
	"npc_dota_hero_lion",
	"npc_dota_hero_treant",
	"npc_dota_hero_vengefulspirit",
	"npc_dota_hero_jakiro",
	"npc_dota_hero_dazzle",
	"npc_dota_hero_lich",
	"npc_dota_hero_oracle",
	"npc_dota_hero_winter_wyvern",
	"npc_dota_hero_warlock",
	"npc_dota_hero_ancient_apparition",
}
hero_pool_new={hero_pool_2,hero_pool_1,hero_pool_4,hero_pool_5,hero_pool_3}
----------------------------------------------------------------------------------------------------
local debug_mode=false

function Think()

	if GetGameMode() == GAMEMODE_AP then
		AllPickLogic();
	elseif GetGameMode() == GAMEMODE_CM then
		CaptainModeLogic();
		AddToList();
	else
		AllPickLogic();
		print("GAME MODE NOT SUPPORTED")
	end
end


function AllPickLogic()
	if(debug_mode==false)
	then
		if(GameTime()<50 and IsHumanPlayerReady()==false or GameTime()<20)
		then
			return
		end
		for i,id in pairs(GetTeamPlayers(GetTeam()))
		do
			if(IsPlayerInHeroSelectionControl(id) and IsPlayerBot(id) and (GetSelectedHeroName(id)=="" or GetSelectedHeroName(id)==nil))
			then
			
				local picks = GetPicks();
				local selectedHeroes = {};
				for slot, hero in pairs(picks) do
					selectedHeroes[hero] = true;
				end
				
				local number
				local temphero
				for j=1,#hero_pool_new[i],1
				do
					number=RandomInt(1,#hero_pool_new[i])
					temphero=hero_pool_new[i][number]
					if(selectedHeroes[temphero] == true)
					then
						table.remove(hero_pool_new[i],number)
					else
						break
					end
				end
				
				if(selectedHeroes[temphero] == true)
				then
					temphero=GetRandomHero()
				end
				
				SelectHero( id,temphero)
			end
		end
	else
		if(GameTime()<45 and IsHumanPlayerReady()==false)
		then
			return
		end
		for i,id in pairs(GetTeamPlayers(GetTeam()))
		do
			if(IsPlayerInHeroSelectionControl(id) and IsPlayerBot(id) and (GetSelectedHeroName(id)=="" or GetSelectedHeroName(id)==nil))
			then
				PickHero(id)
			end
		end
	end
end

----------------------------------------------------------------------------------------------------
function PickHero(iPlayerNumber)
	SelectHero( iPlayerNumber,GetRandomHero())
	return
end

function GetPicks()
    local selectedHeroes = {}
	for i=0,20,1
	do
		if(IsTeamPlayer(i)==true)
		then
			local hName = GetSelectedHeroName(i)
			if (hName ~= "") then
				table.insert(selectedHeroes,hName)
			end
		end
    end
    return selectedHeroes;
end

function GetRandomHero()
    local hero;
    local picks = GetPicks();
	local selectedHeroes = {};
	for slot, hero in pairs(picks) do
		selectedHeroes[hero] = true;
	end
	
	if(#hero_pool_my >0 )
	then
		hero = hero_pool_my[1]
		while(selectedHeroes[hero] == true) do
			table.remove(hero_pool_my,1)
			hero = hero_pool_my[1]
		end
	end
	
    if (hero == nil) then
        hero = hero_pool_test[RandomInt(1, #hero_pool_test)]
    end

    while ( selectedHeroes[hero] == true ) do
        --print("repicking because " .. hero .. " was taken.")
        hero = hero_pool_test[RandomInt(1, #hero_pool_test)]
    end

    return hero;
end

function IsHumanPlayerReady()
	local number,playernumber=0,0
	local IDs=GetTeamPlayers(GetTeam());
	for i,id in pairs(IDs)
	do
        if(IsPlayerBot(id)==false)
		then
			local hName = GetSelectedHeroName(id)
			playernumber=playernumber+1
			if (hName ~="")
			then
				number=number+1
			end
		end
    end
	
	if(number>=playernumber)
	then
		return true
	else
		return false
	end
	
end

----------------------------------------------------------------------------------------------------
-- BOT EXPERIMENT Author:Arizona Fauzie Link:http://steamcommunity.com/sharedfiles/filedetails/?id=837040016
----------------------------------------------------------------------------------------------------
function UpdateLaneAssignments()    
	if GetGameMode() == GAMEMODE_AP then
		--print("AP Lane Assignment")
		return APLaneAssignment()
	elseif GetGameMode() == GAMEMODE_CM then
		--print("CM Lane Assignment")
		return CMLaneAssignment()	
	end
   
end

function APLaneAssignment()

	 local lanecount = {
        [LANE_NONE] = 5,
        [LANE_MID] = 1,
        [LANE_TOP] = 2,
        [LANE_BOT] = 2,
    };
	local lanes={}
	if ( GetTeam() == TEAM_RADIANT )
    then 
		lanes={
			[1] = LANE_MID,
			[2] = LANE_BOT,
			[3] = LANE_TOP,
			[4] = LANE_BOT,
			[5] = LANE_TOP,
		}
	elseif ( GetTeam() == TEAM_DIRE )
	then
		lanes = {
			[1] = LANE_MID,
			[2] = LANE_TOP,
			[3] = LANE_BOT,
			[4] = LANE_TOP,
			[5] = LANE_BOT,
		}
	end
	
    local playercount = 0

	local ids = GetTeamPlayers(GetTeam())
	for i,v in pairs(ids) do
		if not IsPlayerBot(v) then
			playercount = playercount + 1
		end
	end
	if(playercount>0)
	then
		for i=1,playercount do
			local lane = GetLane( GetTeam(),GetTeamMember( i ) )
			lanecount[lane] = lanecount[lane] - 1
			lanes[i] = lane 
		end
	
		for i=(playercount + 1), 5 do
			if lanecount[LANE_MID] > 0 then
				lanes[i] = LANE_MID
				lanecount[LANE_MID] = lanecount[LANE_MID] - 1
			elseif lanecount[LANE_TOP] > 0 then
				lanes[i] = LANE_TOP
				lanecount[LANE_TOP] = lanecount[LANE_TOP] - 1
			else
				lanes[i] = LANE_BOT
			end
		end
	end
  
    return lanes
end

function GetLane( nTeam ,hHero )
        local vBot = GetLaneFrontLocation(nTeam, LANE_BOT, 0)
        local vTop = GetLaneFrontLocation(nTeam, LANE_TOP, 0)
        local vMid = GetLaneFrontLocation(nTeam, LANE_MID, 0)
        --print(GetUnitToLocationDistance(hHero, vMid))
        if GetUnitToLocationDistance(hHero, vBot) < 2500 then
            return LANE_BOT
        end
        if GetUnitToLocationDistance(hHero, vTop) < 2500 then
            return LANE_TOP
        end
        if GetUnitToLocationDistance(hHero, vMid) < 2500 then
            return LANE_MID
        end
        return LANE_NONE
end

------------------------------------------CAPTAIN'S MODE GAME MODE-------------------------------------------
local UnImplementedHeroes = {
	
};

local ListPickedHeroes = {};
local AllHeroesSelected = false;
local BanCycle = 1;
local PickCycle = 1;
local NeededTime = 29;
local Min = 5;
local Max = 15;
local CMTestMode = false;
local UnavailableHeroes = {
	"npc_dota_hero_techies"
}
local HeroLanes = {
	[1] = LANE_MID,
	[2] = LANE_TOP,
	[3] = LANE_TOP,
	[4] = LANE_BOT,
	[5] = LANE_BOT,
};

local PairsHeroNameNRole = {};
local humanPick = {};

--Picking logic for Captain's Mode Game Mode
function CaptainModeLogic()
	if (GetGameState() ~= GAME_STATE_HERO_SELECTION) then
        return
    end
	if not CMTestMode then
		if NeededTime == 29 then
			NeededTime = RandomInt( Min, Max );
		elseif NeededTime == 0 then
			NeededTime = RandomInt( Min, Max );
		end
	elseif CMTestMode then
		NeededTime = 29;
	end	
	if GetHeroPickState() == HEROPICK_STATE_CM_CAPTAINPICK then	
		PickCaptain();
	elseif GetHeroPickState() >= HEROPICK_STATE_CM_BAN1 and GetHeroPickState() <= 18 and GetCMPhaseTimeRemaining() <= NeededTime then
		BansHero();
		NeededTime = 0 
	elseif GetHeroPickState() >= HEROPICK_STATE_CM_SELECT1 and GetHeroPickState() <= HEROPICK_STATE_CM_SELECT10 and GetCMPhaseTimeRemaining() <= NeededTime then
		PicksHero();	
		NeededTime = 0
	elseif GetHeroPickState() == HEROPICK_STATE_CM_PICK then
		SelectsHero();	
	end	
end
--Pick the captain
function PickCaptain()
	if not IsHumanPlayerExist() or DotaTime() > -1 then
		if GetCMCaptain() == -1 then
			local CaptBot = GetFirstBot();
			if CaptBot ~= nil then
				print("CAPTAIN PID : "..CaptBot)
				SetCMCaptain(CaptBot)
			end
		end
	end
end
--Check if human player exist in team
function IsHumanPlayerExist()
	local Players = GetTeamPlayers(GetTeam())
    for _,id in pairs(Players) do
        if not IsPlayerBot(id) then
			return true;
        end
    end
	return false;
end
--Get the first bot to be the captain
function GetFirstBot()
	local BotId = nil;
	local Players = GetTeamPlayers(GetTeam())
    for _,id in pairs(Players) do
        if IsPlayerBot(id) then
			BotId = id;
			return BotId;
        end
    end
	return BotId;
end
--Ban hero function
function BansHero()
	if not IsPlayerBot(GetCMCaptain()) or not IsPlayerInHeroSelectionControl(GetCMCaptain()) then
		return
	end	
	local BannedHero = RandomHero();
	print(BannedHero.." is banned")
	CMBanHero(BannedHero);
	BanCycle = BanCycle + 1;
end
--Pick hero function
function PicksHero()
	if not IsPlayerBot(GetCMCaptain()) or not IsPlayerInHeroSelectionControl(GetCMCaptain()) then
		return
	end	
	local PickedHero = RandomHero();
	if PickCycle == 1 then
		while not role.CanBeOfflaner(PickedHero) do
			PickedHero = RandomHero();
		end
		PairsHeroNameNRole[PickedHero] = "offlaner";
	elseif	PickCycle == 2 then
		while not role.CanBeSupport(PickedHero) do
			PickedHero = RandomHero();
		end
		PairsHeroNameNRole[PickedHero] = "support";
	elseif	PickCycle == 3 then
		while not role.CanBeMidlaner(PickedHero) do
			PickedHero = RandomHero();
		end
		PairsHeroNameNRole[PickedHero] = "midlaner";
	elseif	PickCycle == 4 then
		while not role.CanBeSupport(PickedHero) do
			PickedHero = RandomHero();
		end
		PairsHeroNameNRole[PickedHero] = "support";
	elseif	PickCycle == 5 then
		while not role.CanBeSafeLaneCarry(PickedHero) do
			PickedHero = RandomHero();
		end	
		PairsHeroNameNRole[PickedHero] = "carry";
	end
	print(PickedHero.." is picked")
	CMPickHero(PickedHero);
	PickCycle = PickCycle + 1;
end
--Add to list human picked heroes
function AddToList()
	if not IsPlayerBot(GetCMCaptain()) then
		for _,h in pairs(allBotHeroes)
		do
			if IsCMPickedHero(GetTeam(), h) and not alreadyInTable(h) then
				table.insert(humanPick, h)
			end
		end
	end
end
--Check if selected hero already picked by human
function alreadyInTable(hero_name)
	for _,h in pairs(humanPick)
	do
		if hero_name == h then
			return true
		end
	end
	return false
end
--Check if the randomed hero doesn't available for captain's mode
function IsUnavailableHero(name)
	for _,uh in pairs(UnavailableHeroes)
	do
		if name == uh then
			return true;
		end	
	end
	return false;
end
--Check if a hero hasn't implemented yet
function IsUnImplementedHeroes()
	for _,unh in pairs(UnImplementedHeroes)
	do
		if name == unh then
			return true;
		end	
	end
	return false;
end
--Random hero which is non picked, non banned, or non human picked heroes if the human is the captain 
function RandomHero()
	local hero = allBotHeroes[RandomInt(1, #allBotHeroes)];
	while ( IsUnavailableHero(hero) or IsCMPickedHero(GetTeam(), hero) or IsCMPickedHero(GetOpposingTeam(), hero) or IsCMBannedHero(hero) ) 
	do
        hero = allBotHeroes[RandomInt(1, #allBotHeroes)];
    end
	return hero;
end
--Check if the human already pick the hero in captain's mode
function WasHumansDonePicking()
	local Players = GetTeamPlayers(GetTeam())
    for _,id in pairs(Players) 
	do
        if not IsPlayerBot(id) then
			if GetSelectedHeroName(id) == nil or GetSelectedHeroName(id) == "" then
				return false;
			end	
        end
    end
	return true;
end
--Select the rest of the heroes that the human players don't pick in captain's mode
function SelectsHero()
	if not AllHeroesSelected and ( WasHumansDonePicking() or GetCMPhaseTimeRemaining() < 1 ) then
		local Players = GetTeamPlayers(GetTeam())
		local RestBotPlayers = {};
		GetTeamSelectedHeroes();
		
		for _,id in pairs(Players) 
		do
			local hero_name =  GetSelectedHeroName(id);
			if hero_name ~= nil and hero_name ~= "" then
				UpdateSelectedHeroes(hero_name)
				print(hero_name.." Removed")
			else
				table.insert(RestBotPlayers, id)
			end	
		end
		
		for i = 1, #RestBotPlayers
		do
			SelectHero(RestBotPlayers[i], ListPickedHeroes[i])
		end
		
		AllHeroesSelected = true;
	end
end
--Get the team picked heroes
function GetTeamSelectedHeroes()
	for _,sName in pairs(allBotHeroes)
	do
		if IsCMPickedHero(GetTeam(), sName) then
			table.insert(ListPickedHeroes, sName);
		end
	end
	for _,sName in pairs(UnImplementedHeroes)
	do
		if IsCMPickedHero(GetTeam(), sName) then
			table.insert(ListPickedHeroes, sName);
		end	
	end
end
--Update team picked heroes after human players select their desired hero
function UpdateSelectedHeroes(selected)
	for i=1, #ListPickedHeroes
	do
		if ListPickedHeroes[i] == selected then
			table.remove(ListPickedHeroes, i);
		end
	end
end
-------------------------------------------------------------------------------------------------------

---------------------------------------------------------CAPTAIN'S MODE LANE ASSIGNMENT------------------------------------------------
function CMLaneAssignment()
	if IsPlayerBot(GetCMCaptain()) then
		FillLaneAssignmentTable();
	else
		FillLAHumanCaptain()
	end
	return HeroLanes;
end
--Lane Assignment if the captain is not human
function FillLaneAssignmentTable()
	local supportAlreadyAssigned = false;
	local TeamMember = GetTeamPlayers(GetTeam());
	for i = 1, #TeamMember
	do
		if GetTeamMember(i) ~= nil and GetTeamMember(i):IsHero() then
			local unit_name =  GetTeamMember(i):GetUnitName(); 
			if PairsHeroNameNRole[unit_name] == "support" and not supportAlreadyAssigned then
				HeroLanes[i] = LANE_TOP;
				supportAlreadyAssigned = true;
			elseif PairsHeroNameNRole[unit_name] == "support" and supportAlreadyAssigned then
				HeroLanes[i] = LANE_BOT;
			elseif PairsHeroNameNRole[unit_name] == "midlaner" then
				HeroLanes[i] = LANE_MID;
			elseif PairsHeroNameNRole[unit_name] == "offlaner" then
				if GetTeam() == TEAM_RADIANT then
					HeroLanes[i] = LANE_TOP;
				else
					HeroLanes[i] = LANE_BOT;
				end
			elseif PairsHeroNameNRole[unit_name] == "carry" then
				if GetTeam() == TEAM_RADIANT then
					HeroLanes[i] = LANE_BOT;
				else
					HeroLanes[i] = LANE_TOP;
				end	
			end
		end
	end	
end
--Fill the lane assignment if the captain is human
function FillLAHumanCaptain()
	local TeamMember = GetTeamPlayers(GetTeam());
	for i = 1, #TeamMember
	do
		if GetTeamMember(i) ~= nil and GetTeamMember(i):IsHero() then
			local unit_name =  GetTeamMember(i):GetUnitName(); 
			local key = GetFromHumanPick(unit_name);
			if key ~= nil then
				if key == 1 then
					if GetTeam() == TEAM_DIRE then
						HeroLanes[i] = LANE_BOT;
					else
						HeroLanes[i] = LANE_TOP;
					end
				elseif key == 2 then
					if GetTeam() == TEAM_DIRE then
						HeroLanes[i] = LANE_BOT;
					else
						HeroLanes[i] = LANE_TOP;
					end	
				elseif key == 3 then
					HeroLanes[i] = LANE_MID;
				elseif key == 4 then
					if GetTeam() == TEAM_DIRE then
						HeroLanes[i] = LANE_TOP;
					else
						HeroLanes[i] = LANE_BOT;
					end
				elseif key == 5 then
					if GetTeam() == TEAM_DIRE then
						HeroLanes[i] = LANE_TOP;
					else
						HeroLanes[i] = LANE_BOT;
					end	
				end
			end
		end
	end	
end
--Get human picked heroes if the captain is human player
function GetFromHumanPick(hero_name)
	local i = nil;
	for key,h in pairs(humanPick)
	do
		if hero_name == h then
			i = key;
		end	
	end
	return i;
end
---------------------------------------------------------------------------------------------------------------------------------------