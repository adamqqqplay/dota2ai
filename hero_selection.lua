----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.3 New Structure
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
--Special thanks to DblTap for his commit of "Updated hero selection to try to build a team with one hero in each position".
--DblTap: http://steamcommunity.com/profiles/76561197967823929/ Github Link：https://github.com/adamqqqplay/dota2ai/pull/3
local role = require(GetScriptDirectory() .. "/RoleUtility")
local bnUtil = require(GetScriptDirectory() .. "/BotNameUtility")

--recording all dota2 heroes
hero_pool = {
	"npc_dota_hero_abaddon",
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
	"npc_dota_hero_rattletrap", -- Clockwerk
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
	"npc_dota_hero_furion", -- Natures prophet
	"npc_dota_hero_necrolyte",
	"npc_dota_hero_night_stalker",
	"npc_dota_hero_nyx_assassin",
	"npc_dota_hero_ogre_magi",
	"npc_dota_hero_omniknight",
	"npc_dota_hero_oracle",
	"npc_dota_hero_obsidian_destroyer", -- Outworld Devourer
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
	--"npc_dota_hero_spirit_breaker",
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
	"npc_dota_hero_zuus",
}
--recording default bot heroes
hero_pool_default_bot = {
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
--recoding implemented bots, using in test.
hero_pool_test = {
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
	-- "npc_dota_hero_centaur",
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

	-- "npc_dota_hero_batrider",
	-- "npc_dota_hero_beastmaster",
	-- "npc_dota_hero_bounty_hunter",
	-- "npc_dota_hero_brewmaster",
	-- "npc_dota_hero_broodmother",

	-- "npc_dota_hero_chen",
	-- "npc_dota_hero_dark_seer",
	-- "npc_dota_hero_disruptor",
	-- "npc_dota_hero_earth_spirit",
	-- "npc_dota_hero_elder_titan",

	-- "npc_dota_hero_enchantress",
	-- "npc_dota_hero_enigma",
	-- "npc_dota_hero_keeper_of_the_light",
	-- "npc_dota_hero_lycan",
	-- "npc_dota_hero_magnataur",

	-- "npc_dota_hero_medusa",
	-- "npc_dota_hero_mirana",
	-- "npc_dota_hero_monkey_king",
	-- "npc_dota_hero_pudge",
	-- "npc_dota_hero_sand_king",


	"npc_dota_hero_troll_warlord",
	"npc_dota_hero_obsidian_destroyer", 
	"npc_dota_hero_weaver",
	"npc_dota_hero_nyx_assassin",
	"npc_dota_hero_naga_siren",

	"npc_dota_hero_phantom_lancer",
	"npc_dota_hero_kunkka",
	"npc_dota_hero_shredder",
	"npc_dota_hero_tusk",
	"npc_dota_hero_shadow_demon",


	-- "npc_dota_hero_terrorblade",
	-- "npc_dota_hero_phantom_lancer",
	-- "npc_dota_hero_troll_warlord",

	-- "npc_dota_hero_obsidian_destroyer", 
	-- "npc_dota_hero_templar_assassin",
	-- "npc_dota_hero_kunkka",

	-- "npc_dota_hero_weaver",
	-- "npc_dota_hero_furion",
	-- "npc_dota_hero_shredder",

	-- "npc_dota_hero_nyx_assassin",
	-- "npc_dota_hero_tusk",

	-- "npc_dota_hero_naga_siren",
	-- "npc_dota_hero_shadow_demon",
}
--recording implemented bots, using in CM mode.
allBotHeroes = {
	"npc_dota_hero_abaddon",
	"npc_dota_hero_alchemist",
	"npc_dota_hero_abyssal_underlord",
	"npc_dota_hero_ancient_apparition",
	"npc_dota_hero_arc_warden",
	"npc_dota_hero_axe",
	"npc_dota_hero_antimage",

	"npc_dota_hero_batrider",
	"npc_dota_hero_beastmaster",
	"npc_dota_hero_bounty_hunter",
	"npc_dota_hero_brewmaster",
	"npc_dota_hero_broodmother",
	"npc_dota_hero_bloodseeker",
	"npc_dota_hero_bristleback",
	"npc_dota_hero_bane",

	"npc_dota_hero_chaos_knight",
	"npc_dota_hero_centaur",
	"npc_dota_hero_crystal_maiden",
	"npc_dota_hero_clinkz",
	"npc_dota_hero_chen",

	"npc_dota_hero_dark_seer",
	"npc_dota_hero_disruptor",
	"npc_dota_hero_doom_bringer",
	"npc_dota_hero_dazzle",
	"npc_dota_hero_drow_ranger",
	"npc_dota_hero_dragon_knight",
	"npc_dota_hero_death_prophet",

	"npc_dota_hero_earth_spirit",
	--"npc_dota_hero_elder_titan",
	"npc_dota_hero_enchantress",
	"npc_dota_hero_enigma",
	"npc_dota_hero_earthshaker",
	--"npc_dota_hero_ember_spirit",

	"npc_dota_hero_faceless_void",
	"npc_dota_hero_furion",

	"npc_dota_hero_gyrocopter",

	"npc_dota_hero_huskar",

	"npc_dota_hero_jakiro",
	"npc_dota_hero_juggernaut",

	"npc_dota_hero_keeper_of_the_light",
	"npc_dota_hero_kunkka", 
	
	"npc_dota_hero_lina",
	"npc_dota_hero_lion",
	"npc_dota_hero_luna",
	"npc_dota_hero_legion_commander",
	"npc_dota_hero_leshrac",
	"npc_dota_hero_life_stealer",
	"npc_dota_hero_lich",
	"npc_dota_hero_lycan",

	"npc_dota_hero_magnataur",
	"npc_dota_hero_medusa",
	"npc_dota_hero_mirana",
	"npc_dota_hero_monkey_king",

	"npc_dota_hero_nevermore",
	"npc_dota_hero_night_stalker",
	"npc_dota_hero_necrolyte",
	"npc_dota_hero_naga_siren",
	"npc_dota_hero_nyx_assassin",

	"npc_dota_hero_oracle",
	"npc_dota_hero_obsidian_destroyer",
	"npc_dota_hero_ogre_magi",
	"npc_dota_hero_omniknight",

	"npc_dota_hero_phantom_assassin",
	"npc_dota_hero_pugna",
	"npc_dota_hero_pudge", 
	"npc_dota_hero_phantom_lancer",

	"npc_dota_hero_queenofpain",

	"npc_dota_hero_razor",
	"npc_dota_hero_riki",

	"npc_dota_hero_skywrath_mage",
	"npc_dota_hero_shadow_shaman",
	"npc_dota_hero_slardar",
	"npc_dota_hero_silencer",
	"npc_dota_hero_skeleton_king",
	"npc_dota_hero_slark",
	"npc_dota_hero_sand_king",
	"npc_dota_hero_sven",
	"npc_dota_hero_sniper",
	"npc_dota_hero_spectre",
	"npc_dota_hero_shadow_demon",
	--"npc_dota_hero_spirit_breaker",

	"npc_dota_hero_treant",
	"npc_dota_hero_tidehunter",
	--"npc_dota_hero_tiny",
	"npc_dota_hero_terrorblade",
	"npc_dota_hero_templar_assassin",
	"npc_dota_hero_troll_warlord",
	"npc_dota_hero_tusk",

	"npc_dota_hero_ursa",
	"npc_dota_hero_undying",

	"npc_dota_hero_viper",
	"npc_dota_hero_venomancer",
	"npc_dota_hero_vengefulspirit",

	"npc_dota_hero_winter_wyvern",
	"npc_dota_hero_weaver",
	"npc_dota_hero_warlock",
	"npc_dota_hero_windrunner",
	"npc_dota_hero_witch_doctor", 

	"npc_dota_hero_zuus",
}
hero_pool_position_1 = {
	"npc_dota_hero_chaos_knight",
	"npc_dota_hero_skeleton_king",
	"npc_dota_hero_slark",
	"npc_dota_hero_clinkz",
	"npc_dota_hero_drow_ranger",
	"npc_dota_hero_faceless_void",
	"npc_dota_hero_life_stealer",
	"npc_dota_hero_luna",
	"npc_dota_hero_juggernaut",
	"npc_dota_hero_ursa",
	"npc_dota_hero_sven",
	"npc_dota_hero_spectre",
	"npc_dota_hero_antimage",
	"npc_dota_hero_gyrocopter",
	"npc_dota_hero_lycan",
	"npc_dota_hero_monkey_king",
	"npc_dota_hero_terrorblade",
	"npc_dota_hero_phantom_lancer",
	"npc_dota_hero_troll_warlord",
}
hero_pool_position_2 = {
	"npc_dota_hero_leshrac",
	"npc_dota_hero_dragon_knight",
	"npc_dota_hero_huskar",
	"npc_dota_hero_zuus",
	"npc_dota_hero_lina",
	"npc_dota_hero_medusa",
	"npc_dota_hero_phantom_assassin",
	"npc_dota_hero_viper",
	"npc_dota_hero_necrolyte",
	"npc_dota_hero_queenofpain",
	"npc_dota_hero_razor",
	"npc_dota_hero_nevermore",
	"npc_dota_hero_bloodseeker",
	"npc_dota_hero_pugna",
	"npc_dota_hero_death_prophet",
	"npc_dota_hero_arc_warden",
	"npc_dota_hero_sniper",
	"npc_dota_hero_alchemist",
	"npc_dota_hero_obsidian_destroyer", 
	"npc_dota_hero_templar_assassin",
	"npc_dota_hero_kunkka",

	--"npc_dota_hero_tiny",
}
hero_pool_position_3 = {
	"npc_dota_hero_centaur",
	"npc_dota_hero_doom_bringer",
	"npc_dota_hero_legion_commander",
	"npc_dota_hero_tidehunter",
	"npc_dota_hero_axe",
	"npc_dota_hero_bristleback",
	"npc_dota_hero_windrunner",
	"npc_dota_hero_abyssal_underlord",
	"npc_dota_hero_batrider",
	"npc_dota_hero_beastmaster",
	"npc_dota_hero_brewmaster",
	"npc_dota_hero_enigma",
	"npc_dota_hero_broodmother",
	"npc_dota_hero_dark_seer",
	"npc_dota_hero_enchantress",
	"npc_dota_hero_magnataur",
	"npc_dota_hero_mirana",
	"npc_dota_hero_weaver",
	"npc_dota_hero_furion",
	"npc_dota_hero_shredder",
}
hero_pool_position_4 = {
	"npc_dota_hero_skywrath_mage",
	"npc_dota_hero_shadow_shaman",
	"npc_dota_hero_abaddon",
	"npc_dota_hero_venomancer",
	"npc_dota_hero_slardar",
	"npc_dota_hero_undying",
	"npc_dota_hero_night_stalker",
	"npc_dota_hero_silencer",
	"npc_dota_hero_riki",
	"npc_dota_hero_earthshaker",
	"npc_dota_hero_omniknight",
	"npc_dota_hero_bounty_hunter",
	"npc_dota_hero_keeper_of_the_light",
	"npc_dota_hero_naga_siren",
	"npc_dota_hero_chen",
	"npc_dota_hero_pudge",
	"npc_dota_hero_sand_king",
	"npc_dota_hero_nyx_assassin",
	"npc_dota_hero_tusk",

	--"npc_dota_hero_elder_titan",
	--"npc_dota_hero_spirit_breaker",
}
hero_pool_position_5 = {
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
	"npc_dota_hero_bane",
	"npc_dota_hero_ancient_apparition",
	"npc_dota_hero_disruptor",
	"npc_dota_hero_earth_spirit",
	"npc_dota_hero_witch_doctor",
	"npc_dota_hero_shadow_demon",
}
-- This is the pool of heros from which to choose bots for each position
hero_pool_position={
    [1] = hero_pool_position_1,
    [2] = hero_pool_position_2,
    [3] = hero_pool_position_3,
    [4] = hero_pool_position_4,
    [5] = hero_pool_position_5
}
-- This is the pool of other heros in each position, which dont have bots yet. This is so we can tell which positions the players are in.
hero_pool_position_unimplemented={
    [1] = {"npc_dota_hero_morphling"},
    [2] = {"npc_dota_hero_invoker","npc_dota_hero_meepo","npc_dota_hero_puck","npc_dota_hero_storm_spirit","npc_dota_hero_tinker"},
    [3] = {"npc_dota_hero_rattletrap","npc_dota_hero_lone_druid","npc_dota_hero_pangolier"},
    [4] = {"npc_dota_hero_wisp","npc_dota_hero_phoenix","npc_dota_hero_techies"},
    [5] = {"npc_dota_hero_rubick","npc_dota_hero_visage","npc_dota_hero_dark_willow"}
}
----------------------------------------------------------------------------------------------------
local debug_mode=false

function GetBotNames()
	return bnUtil.GetDota2Team();
end

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

local pickTime=GameTime();
local randomTime=0;
function AllPickLogic()
	local team = GetTeam();
	if(GameTime()<45 and AreHumanPlayersReady(team)==false or GameTime()<25)
	then
		return
	end
	
    local picks = GetPicks();
    local selectedHeroes = {};
    for slot, hero in pairs(picks) do
        selectedHeroes[hero] = true;
    end
	
    if(debug_mode==false)
	then
		for i,id in pairs(GetTeamPlayers(team))
		do
			if(IsPlayerInHeroSelectionControl(id) and IsPlayerBot(id) and (GetSelectedHeroName(id)=="" or GetSelectedHeroName(id)==nil))
			then
				if(randomTime==0) then
					randomTime=RandomInt(10,12);
				end
				while (GameTime()-pickTime)<randomTime do
					return;
				end
				pickTime=GameTime();
				randomTime=0;
				
				local temphero = GetPositionedHero(team, selectedHeroes);
                SelectHero(id, temphero);
			end
		end
	else
		for i,id in pairs(GetTeamPlayers(team))
		do
			if(IsPlayerInHeroSelectionControl(id) and IsPlayerBot(id) and (GetSelectedHeroName(id)=="" or GetSelectedHeroName(id)==nil))
			then
				SelectHero(id,GetHeroInTest(selectedHeroes))
			end
		end
	end
end

----------------------------------------------------------------------------------------------------
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

-- Return hero's postion
function GetHeroPostion( heroName )
	if (heroName ~="") then
		for p=1,5,1 do
			if( ListContains( hero_pool_position[p], heroName ) or ListContains( hero_pool_position_unimplemented[p], heroName ) ) then
				return p;
			end
		end
	end
	return -1;
end

-- Returns a Hero that fills a position that current team does not have filled.
function GetPositionedHero(team, selectedHeroes)
	--Fill positions in random order
    local positionCounts = GetPositionCounts( team );
	local postion
	repeat
		position=RandomInt(1,5);
	until(positionCounts[position] == 0)

	return GetRandomHero( hero_pool_position[position], selectedHeroes );

	-- The object is to fill positions in this order: 3, 4, 2, 5, 1
	-- local order = {3, 4, 2, 5, 1};
	-- local positionCounts = GetPositionCounts( team );
    -- for i,position in ipairs( order ) do 
	-- 	if( positionCounts[position] == 0 ) then
    --         return GetRandomHero( hero_pool_position[position], selectedHeroes );
    --     end
    -- end
end

-- For the given team, returns a table that gives the counts of heros in each position.
function GetPositionCounts( team )
    local counts = { [1]=0, [2]=0, [3]=0, [4]=0, [5]=0 };
    local playerIds=GetTeamPlayers(team);

    for i,id in ipairs(playerIds) do
        local heroName = GetSelectedHeroName(id)
        if (heroName ~="") then
            for position=1,5,1 do
                if( ListContains( hero_pool_position[position], heroName ) or ListContains( hero_pool_position_unimplemented[position], heroName ) ) then
                    counts[position] = counts[position] + 1;
                end
            end
        end
    end

    return counts
end

-- A utilitiy function that returns true if the passed list contains the passed value.
function ListContains( list, value )
    if list == nil then return false end
    for i,v in ipairs(list) do
        if v == value then
            return true
        end
    end
    return false
end

-- Returns a hero from the hero_pool_test pool
function GetHeroInTest(selectedHeroes)
    -- Step through the "hero_pool_test" pool allocating them in order. This function will error if the pool is too small, but it's not for general use.
	
	repeat
		hero = hero_pool_test[1]
		table.remove(hero_pool_test,1)
	until(selectedHeroes[hero] ~= true)
    return hero;
end

-- Returns a random hero from the supplied heroPool that is not in the selectedHeroes list.
-- Note: this function will enter an infinite loop if all heros in the pool have been selected.
function GetRandomHero(heroPool, selectedHeroes)
	local hero;
	repeat
		hero = heroPool[RandomInt(1, #heroPool)]
	until( selectedHeroes[hero] ~= true )
    return hero;
end

-- Returns true if, for the specified team, all the Human players have picked a hero.
function AreHumanPlayersReady(team)
	local number,playernumber=0,0
	local IDs=GetTeamPlayers(team);
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

function GetSafeLane()
	if GetTeam() == TEAM_RADIANT
	then
		return LANE_BOT;
	else
		return LANE_TOP;
	end
end

function GetOffLane()
	if GetTeam() == TEAM_RADIANT
	then
		return LANE_TOP;
	else
		return LANE_BOT;
	end
end
--index:position,value:lane.
function GetLanesTable()
	local safeLane=GetSafeLane();
	local offLane=GetOffLane();

	local laneTable ={
		[1] = safeLane,
		[2] = LANE_MID,
		[3] = offLane,
		[4] = offLane,
		[5] = safeLane
	};

	return laneTable;
end
--index:id,value:lane Get normal lane assaignment.
function GetAssaignedLanes()

	local laneTable = GetLanesTable();
	local lanes = {1,1,2,3,3};

	for id=1,5 do
		local hero = GetTeamMember(id);
		if(hero == nil)
		then
			break;
		end
		local heroName = hero:GetUnitName();
		local postion = GetHeroPostion(heroName);
		lanes[id] = laneTable[postion];
	end
	return lanes;
end

function TranspositionTable( sourceTable )
	local newTable={};
	for k,v in pairs(sourceTable) do
		newTable[v]=k;
	end
	return newTable;
end
--index:lane,value:position.
function GetPositionAssaignedLanes()
	return TranspositionTable(GetLanesTable());
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

-- function printTable(table)
-- 	if(GetTeam()==TEAM_RADIANT)
-- 	then
-- 		print(tostring(table).."TEAM_RADIANT");
-- 	else
-- 		print(tostring(table).."TEAM_DIRE");
-- 	end
	
-- 	for k,v in pairs(table) do
-- 		print(k.." "..v)
-- 	end
-- end

function APLaneAssignment()
	local gamestate=GetGameState();
	if(gamestate==GAME_STATE_HERO_SELECTION or gamestate==GAME_STATE_STRATEGY_TIME or gamestate==GAME_STATE_TEAM_SHOWCASE or gamestate==GAME_STATE_WAIT_FOR_MAP_TO_LOAD or gamestate==GAME_STATE_WAIT_FOR_PLAYERS_TO_LOAD)
	then
		return;
	end

	local lanes = GetAssaignedLanes();
	
	if(DotaTime()<-15)
	then
		return lanes
	end

	local lanecount = {
        [LANE_NONE] = 5,
        [LANE_MID] = 1,
        [LANE_TOP] = 2,
        [LANE_BOT] = 2,
	};

	--adjust the lane assignement when player occupied the other lane.
	--TODO: Assign lane at Team level not hero level.
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
			local hero = GetTeamMember(i);
			local heroName = hero:GetUnitName();
			local position = GetHeroPostion(heroName);
			local laneTable = GetLanesTable();
			local bestLane = laneTable[position];
			local positionAssaignedLanes = GetPositionAssaignedLanes();
			local safeLane=GetSafeLane();
			local offLane=GetOffLane();
			--try to assign the most suitable lane, if can't try other lane.
			if lanecount[bestLane] > 0 then
				lanes[i] = bestLane
				lanecount[bestLane] = lanecount[bestLane] - 1
			elseif lanecount[offLane] > 0 then
				lanes[i] = offLane
				lanecount[offLane] = lanecount[offLane] - 1
			elseif lanecount[safeLane] > 0 then
				lanes[i] = safeLane
				lanecount[safeLane] = lanecount[safeLane] - 1
			elseif lanecount[LANE_MID] > 0 then
				lanes[i] = LANE_MID
				lanecount[LANE_MID] = lanecount[LANE_MID] - 1
			end
		end
	end
    return lanes
end

function GetLane( nTeam ,hHero )
		if(hHero==nil)
		then
			return LANE_NONE;
		end

        local vBot = GetLaneFrontLocation(nTeam, LANE_BOT, 0)
        local vTop = GetLaneFrontLocation(nTeam, LANE_TOP, 0)
        local vMid = GetLaneFrontLocation(nTeam, LANE_MID, 0)
		--print(GetUnitToLocationDistance(hHero, vMid))
		if hHero:DistanceFromFountain() < 2500 then
			return LANE_NONE
		end
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
local NeededTime = 28;
local Min = 15;
local Max = 20;
local CMTestMode = true;
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
		NeededTime = RandomInt( Min, Max );
	--end
	elseif CMTestMode then
		NeededTime = 25;
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
		--[[if GetTeamMember(i) ~= nil and GetTeamMember(i):IsHero() then
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
		end]]
		if GetTeamMember(i) ~= nil and GetTeamMember(i):IsHero() then
			local unit_name =  GetTeamMember(i):GetUnitName(); 
			if PairsHeroNameNRole[unit_name] == "support" then
				if GetTeam() == TEAM_RADIANT then
					HeroLanes[i] = LANE_BOT;
				else
					HeroLanes[i] = LANE_TOP;
				end
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