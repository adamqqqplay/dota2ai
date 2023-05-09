----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.3 New Structure
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
--Special thanks to DblTap for his commit of "Updated hero selection to try to build a team with one hero in each position".
--DblTap: http://steamcommunity.com/profiles/76561197967823929/ Github Link：https://github.com/adamqqqplay/dota2ai/pull/3
local role = require(GetScriptDirectory() .. "/util/RoleUtility")
local bnUtil = require(GetScriptDirectory() .. "/util/BotNameUtility")

--recording all dota2 heroes
local hero_pool = {
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
	--"npc_dota_hero_hoodwink",
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
local hero_pool_default_bot = {
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
	--"npc_dota_hero_hoodwink",
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
local hero_pool_test = {
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


	-- "npc_dota_hero_troll_warlord",
	-- "npc_dota_hero_obsidian_destroyer",
	-- "npc_dota_hero_weaver",
	-- "npc_dota_hero_nyx_assassin",
	-- "npc_dota_hero_naga_siren",

	-- "npc_dota_hero_phantom_lancer",
	-- "npc_dota_hero_kunkka",
	-- "npc_dota_hero_shredder",
	-- "npc_dota_hero_tusk",
	-- "npc_dota_hero_shadow_demon",


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
--recording implemented bots, used in CM mode.
local allBotHeroes = {
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
	"npc_dota_hero_ember_spirit",

	"npc_dota_hero_faceless_void",
	"npc_dota_hero_furion",

	"npc_dota_hero_gyrocopter",
	--"npc_dota_hero_hoodwink",
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
local hero_pool_position_1 = {
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
	"npc_dota_hero_abaddon"
}
local hero_pool_position_2 = {
	"npc_dota_hero_leshrac",
	"npc_dota_hero_ember_spirit",
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
}

local hero_pool_position_3 = {
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
local hero_pool_position_4 = {
	--"npc_dota_hero_hoodwink",
	"npc_dota_hero_skywrath_mage",
	"npc_dota_hero_shadow_shaman",
	-- "npc_dota_hero_abaddon",
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
local hero_pool_position_5 = {
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
local hero_pool_position = {
	[1] = hero_pool_position_2,
	[2] = hero_pool_position_1,
	[3] = hero_pool_position_3,
	[4] = hero_pool_position_4,
	[5] = hero_pool_position_5
}
-- This is the pool of other heros in each position, which dont have bots yet. This is so we can tell which positions the players are in.
local hero_pool_position_unimplemented = {
	[1] = { "npc_dota_hero_morphling" },
	[2] = { "npc_dota_hero_invoker", "npc_dota_hero_meepo", "npc_dota_hero_puck", "npc_dota_hero_storm_spirit",
		"npc_dota_hero_tinker" },
	[3] = { "npc_dota_hero_rattletrap", "npc_dota_hero_lone_druid", "npc_dota_hero_pangolier" },
	[4] = { "npc_dota_hero_wisp", "npc_dota_hero_phoenix", "npc_dota_hero_techies" },
	[5] = { "npc_dota_hero_rubick", "npc_dota_hero_visage", "npc_dota_hero_dark_willow" }
}
----------------------------------------------------------------------------------------------------
local debugMode = false

-----------------------------------------------------SELECT HERO FOR BOT WITH CHAT FEATURE------------------------------
--function to get hero name that match the expression
function GetHumanChatHero(name)
	if name == nil then return ""; end
	for _, hero in pairs(allBotHeroes) do
		if string.find(hero, name) then
			return hero;
		end
	end
	return "";
end

--function to decide which team should get the hero
function SelectHeroChatCallback(PlayerID, ChatText, bTeamOnly)
	local text = string.lower(ChatText);
	local hero = GetHumanChatHero(text);
	if hero ~= "" then
		if bTeamOnly then
			for _, id in pairs(GetTeamPlayers(GetTeam())) do
				if IsPlayerBot(id) and IsPlayerInHeroSelectionControl(id) and GetSelectedHeroName(id) == "" then
					SelectHero(id, hero);
					break;
				end
			end
		elseif bTeamOnly == false and GetTeamForPlayer(PlayerID) ~= GetTeam() then
			for _, id in pairs(GetTeamPlayers(GetTeam())) do
				if IsPlayerBot(id) and IsPlayerInHeroSelectionControl(id) and GetSelectedHeroName(id) == "" then
					SelectHero(id, hero);
					break;
				end
			end
		end
	else
		print("Hero name not found! Please refer to hero_selection.lua of this script for list of heroes's name");
	end
end

------------------------------------------------------------------------------------------------------------------------

function GetBotNames()
	return bnUtil.GetDota2Team();
end

function Think()
	if GetGameMode() == GAMEMODE_AP then
		if GetGameState() == GAME_STATE_HERO_SELECTION then
			InstallChatCallback(function(attr) SelectHeroChatCallback(attr.player_id, attr.string, attr.team_only); end);
		end
		AllPickLogic();
	elseif GetGameMode() == GAMEMODE_CM then
		CaptainModeLogic();
		AddToList();
	elseif GetGameMode() == GAMEMODE_AR then
		AllRandomLogic();
	elseif GetGameMode() == GAMEMODE_MO then
		MidOnlyLogic();
	elseif GetGameMode() == GAMEMODE_1V1MID then
		OneVsOneLogic();
	elseif GetGameMode() == GAMEMODE_SD then
		if GetGameState() == GAME_STATE_HERO_SELECTION then
			InstallChatCallback(function(attr) SelectHeroChatCallback(attr.player_id, attr.string, attr.team_only); end);
		end
		SingleDraftLogic();
	-- elseif GetGameMode() == GAMEMODE_TM then
	elseif GetGameMode() == 23 then
		if GetGameState() == GAME_STATE_HERO_SELECTION then
			InstallChatCallback(function(attr) SelectHeroChatCallback(attr.player_id, attr.string, attr.team_only); end);
		end
		NewTurboModeLogic();
	else
		if GetGameState() == GAME_STATE_HERO_SELECTION then
			InstallChatCallback(function(attr) SelectHeroChatCallback(attr.player_id, attr.string, attr.team_only); end);
		end
		AllPickLogic();
		--print("GAME MODE NOT SUPPORTED")
	end
end

local lastpick = 10;
function NewTurboModeLogic()
	local hero;
	if GetHeroPickState() == 58 and GameTime() >= 45 and GameTime() >= lastpick + 1.5 then
		for i, id in pairs(GetTeamPlayers(GetTeam())) do
			if IsPlayerBot(id) and IsPlayerInHeroSelectionControl(id) and GetSelectedHeroName(id) == "" then
				if debugMode then
					hero = GetRandomHero2()
				else
					hero = PickRightHero(i - 1)
				end
				SelectHero(id, hero);
				lastpick = GameTime();
				return;
			end
		end
	end
end

local humanInRad1Slot = nil;

function TurboModeLogic()
	local hero;
	if #GetTeamPlayers(GetTeam()) < 5 or #GetTeamPlayers(GetOpposingTeam()) < 5 then return end

	if humanInRad1Slot == nil then humanInRad1Slot = IsHumanPlayerInRadiant1Slot() return end

	--print(tostring(GetGameMode()).."=>"..tostring(GetGameState())..":"..tostring(DotaTime( ))..":"..tostring(GetHeroPickState()))
	if GetHeroPickState() == 55 and
		((humanInRad1Slot == true and IsHumanDonePickingFirstSlot() and DotaTime() > -10 and DotaTime() < -5)
			or (humanInRad1Slot == false and GameTime() > 10 and DotaTime() > -10 and DotaTime() < -5))
	then
		for i, id in pairs(GetTeamPlayers(GetTeam())) do
			if IsPlayerBot(id) and IsPlayerInHeroSelectionControl(id) and GetSelectedHeroName(id) == ""
			then
				if debugMode then
					hero = GetRandomHero2()
				else
					hero = PickRightHero(i - 1)
				end
				SelectHero(id, hero);
				return;
			end
		end
	end
end

function SingleDraftLogic()
	local hero;
	--print(tostring(GetGameMode()).."=>"..tostring(GetGameState())..":"..tostring(DotaTime( ))..":"..tostring(GetHeroPickState()))
	if GetHeroPickState() == 2 and GameTime() >= 45 and GameTime() >= lastpick + 1.5 then
		for i, id in pairs(GetTeamPlayers(GetTeam())) do
			if IsPlayerBot(id) and IsPlayerInHeroSelectionControl(id) and GetSelectedHeroName(id) == "" then
				if debugMode then
					hero = GetRandomHero2()
				else
					hero = PickRightHero(i - 1)
				end
				SelectHero(id, hero);
				lastpick = GameTime();
				return;
			end
		end
	end
end

local oboselect = false;
------------------------------------------1 VS 1 GAME MODE-------------------------------------------
function OneVsOneLogic()
	local hero;
	if IsHumanPlayerExist() then
		oboselect = true;
	end

	for _, i in pairs(GetTeamPlayers(GetTeam())) do
		if not oboselect and IsPlayerBot(i) and IsPlayerInHeroSelectionControl(i) and GetSelectedHeroName(i) == ""
		then
			if IsHumanPresentInGame() then
				hero = GetSelectedHumanHero(GetOpposingTeam());
			else
				hero = GetRandomHero2();
			end
			if hero ~= nil then
				SelectHero(i, hero);
				oboselect = true;
			end
			return
		elseif oboselect and IsPlayerBot(i) and IsPlayerInHeroSelectionControl(i) and GetSelectedHeroName(i) == ""
		then
			SelectHero(i, 'npc_dota_hero_techies');
			return
		end
	end
end

-------------------------------------------------------------------------------------------------------


local pickTime = GameTime();
local randomTime = 0;
function AllPickLogic()
	local team = GetTeam();
	if (GameTime() < 45 and AreHumanPlayersReady(team) == false or GameTime() < 25)
	then
		return
	end

	local picks = GetPicks();
	local selectedHeroes = {};
	for slot, hero in pairs(picks) do
		selectedHeroes[hero] = true;
	end

	if (debugMode == false)
	then
		for i, id in pairs(GetTeamPlayers(team)) do
			if (
				IsPlayerInHeroSelectionControl(id) and IsPlayerBot(id) and
					(GetSelectedHeroName(id) == "" or GetSelectedHeroName(id) == nil))
			then
				if (randomTime == 0) then
					randomTime = RandomInt(1, 2);
				end
				while (GameTime() - pickTime) < randomTime do
					return;
				end
				pickTime = GameTime();
				randomTime = 0;

				local temphero = GetPositionedHero(team, selectedHeroes);
				SelectHero(id, temphero);
			end
		end
	else
		for i, id in pairs(GetTeamPlayers(team)) do
			if (
				IsPlayerInHeroSelectionControl(id) and IsPlayerBot(id) and
					(GetSelectedHeroName(id) == "" or GetSelectedHeroName(id) == nil))
			then
				SelectHero(id, GetHeroInTest(selectedHeroes))
			end
		end
	end
end

------------------------------------------ALL RANDOM GAME MODE-------------------------------------------
--Picking logic for All Random Game Mode
function AllRandomLogic()
	for i, id in pairs(GetTeamPlayers(GetTeam())) do
		if GetHeroPickState() == HEROPICK_STATE_AR_SELECT and IsPlayerInHeroSelectionControl(id) and
			GetSelectedHeroName(id) == ""
		then
			hero = GetRandomHero2();
			SelectHero(id, hero);
			return;
		end
	end
end

-------------------------------------------------------------------------------------------------------------


------------------------------------------MID ONLY SAME HERO GAME MODE-----------------------------------------------
--Picking logic for Mid Only Same Hero Game Mode
local RandomedHero = nil;
function MidOnlyLogic()
	if IsHumanPresentInGame() then
		if IsHumansDonePicking() then
			if IsHumanPlayerExist() then
				local selectedHero = GetSelectedHumanHero(GetTeam())
				if selectedHero ~= "" and selectedHero ~= nil then
					for i, id in pairs(GetTeamPlayers(GetTeam())) do
						if GetHeroPickState() == HEROPICK_STATE_AP_SELECT and IsPlayerBot(id) and IsPlayerInHeroSelectionControl(id) and
							GetSelectedHeroName(id) == ""
						then
							SelectHero(id, selectedHero);
							return;
						end
					end
				end
			else
				local selectedHero = GetSelectedHumanHero(GetOpposingTeam())
				if selectedHero ~= "" and selectedHero ~= nil then
					for i, id in pairs(GetTeamPlayers(GetTeam())) do
						if GetHeroPickState() == HEROPICK_STATE_AP_SELECT and IsPlayerBot(id) and IsPlayerInHeroSelectionControl(id) and
							GetSelectedHeroName(id) == ""
						then
							SelectHero(id, selectedHero);
							return;
						end
					end
				end
			end
		end
	else
		if GetTeam() == TEAM_DIRE then
			if not IsOpposingTeamDonePicking() then
				return
			else
				local selectedHero = GetOpposingTeamSelectedHero()
				for i, id in pairs(GetTeamPlayers(GetTeam())) do
					if GetHeroPickState() == HEROPICK_STATE_AP_SELECT and IsPlayerBot(id) and IsPlayerInHeroSelectionControl(id) and
						GetSelectedHeroName(id) == ""
					then
						SelectHero(id, selectedHero);
						return;
					end
				end
			end
		else
			local selectedHero = SetRandomHero();
			for i, id in pairs(GetTeamPlayers(GetTeam())) do
				if GetHeroPickState() == HEROPICK_STATE_AP_SELECT and IsPlayerBot(id) and IsPlayerInHeroSelectionControl(id) and
					GetSelectedHeroName(id) == ""
				then
					SelectHero(id, selectedHero);
					return;
				end
			end
		end
	end
end

----------------------------------------------------------------------------------------------------
--Check if human done picking
function IsHumansDonePicking()
	-- check radiant
	for _, i in pairs(GetTeamPlayers(GetTeam())) do
		if GetSelectedHeroName(i) == "" and not IsPlayerBot(i) then
			return false;
		end
	end
	-- check dire
	for _, i in pairs(GetTeamPlayers(GetOpposingTeam())) do
		if GetSelectedHeroName(i) == "" and not IsPlayerBot(i) then
			return false;
		end
	end
	-- else humans have picked
	return true;
end

--Get Human Selected Hero
function GetSelectedHumanHero(team)
	for i, id in pairs(GetTeamPlayers(team)) do
		if not IsPlayerBot(id) and GetSelectedHeroName(id) ~= ""
		then
			return GetSelectedHeroName(id);
		end
	end
end

--Check if human present in the game
function IsHumanPresentInGame()
	for i, id in pairs(GetTeamPlayers(GetTeam())) do
		if not IsPlayerBot(id)
		then
			return true;
		end
	end
	for i, id in pairs(GetTeamPlayers(GetOpposingTeam())) do
		if not IsPlayerBot(id)
		then
			return true;
		end
	end
	return false;
end

function IsHumanDonePickingFirstSlot()
	if GetTeam() == TEAM_RADIANT then
		for _, id in pairs(GetTeamPlayers(GetTeam())) do
			if IsPlayerBot(id) == false and GetSelectedHeroName(id) ~= "" then
				return true;
			end
		end
	else
		for _, id in pairs(GetTeamPlayers(GetOpposingTeam())) do
			if IsPlayerBot(id) == false and GetSelectedHeroName(id) ~= "" then
				return true;
			end
		end
	end
end

function IsHumanPlayerInRadiant1Slot()
	if GetTeam() == TEAM_RADIANT then
		for i, id in pairs(GetTeamPlayers(GetTeam())) do
			if i == 1 and IsPlayerBot(id) == false then
				return true;
			end
		end
	else
		for i, id in pairs(GetTeamPlayers(GetOpposingTeam())) do
			if i == 1 and IsPlayerBot(id) == false then
				return true;
			end
		end
	end
	return false;
end

--Pick hero based on role
function PickRightHero(slot)
	local initHero = GetRandomHero2();
	local Team = GetTeam();
	if slot == 0 then
		while not role.CanBeMidlaner(initHero) do
			initHero = GetRandomHero2();
		end
	elseif slot == 1 then
		while (Team == TEAM_RADIANT and not role.CanBeOfflaner(initHero)) or
			(Team == TEAM_DIRE and not role.CanBeSafeLaneCarry(initHero)) do
			initHero = GetRandomHero2();
		end
	elseif slot == 2 then
		while not role.CanBeSupport(initHero) do
			initHero = GetRandomHero2();
		end
	elseif slot == 3 then
		while not role.CanBeSupport(initHero) do
			initHero = GetRandomHero2();
		end
	elseif slot == 4 then
		while (Team == TEAM_RADIANT and not role.CanBeSafeLaneCarry(initHero)) or
			(Team == TEAM_DIRE and not role.CanBeOfflaner(initHero)) do
			initHero = GetRandomHero2();
		end
	end
	return initHero;
end

function GetPicks()
	local selectedHeroes = {}
	for i = 0, 20, 1 do
		if (IsTeamPlayer(i) == true)
		then
			local hName = GetSelectedHeroName(i)
			if (hName ~= "") then
				table.insert(selectedHeroes, hName)
			end
		end
	end
	return selectedHeroes;
end

-- Return hero's postion
function GetHeroPostion(heroName)
	if (heroName ~= "") then
		for p = 1, 5, 1 do
			if (ListContains(hero_pool_position[p], heroName) or ListContains(hero_pool_position_unimplemented[p], heroName)) then
				return p;
			end
		end
	end
	return -1;
end

-- Returns a Hero that fills a position that current team does not have filled.
function GetPositionedHero(team, selectedHeroes)
	--Fill positions in random order
	local positionCounts = GetPositionCounts(team);
	local position
	repeat
		position = RandomInt(1, 5);
	until (positionCounts[position] == 0)

	return GetRandomHero(hero_pool_position[position], selectedHeroes);

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
function GetPositionCounts(team)
	local counts = { [1] = 0, [2] = 0, [3] = 0, [4] = 0, [5] = 0 };
	local playerIds = GetTeamPlayers(team);

	for i, id in ipairs(playerIds) do
		local heroName = GetSelectedHeroName(id)
		if (heroName ~= "") then
			for position = 1, 5, 1 do
				if (
					ListContains(hero_pool_position[position], heroName) or
						ListContains(hero_pool_position_unimplemented[position], heroName)) then
					counts[position] = counts[position] + 1;
				end
			end
		end
	end

	return counts
end

-- A utilitiy function that returns true if the passed list contains the passed value.
function ListContains(list, value)
	if list == nil then return false end
	for i, v in ipairs(list) do
		if v == value then
			return true
		end
	end
	return false
end

-- Returns a hero from the hero_pool_test pool
function GetHeroInTest(selectedHeroes)
	-- Step through the "hero_pool_test" pool allocating them in order. This function will error if the pool is too small, but it's not for general use.
	local hero
	repeat
		hero = hero_pool_test[1]
		table.remove(hero_pool_test, 1)
	until (selectedHeroes[hero] ~= true)
	return hero;
end

-- Returns a random hero from the supplied heroPool that is not in the selectedHeroes list.
-- Note: this function will enter an infinite loop if all heros in the pool have been selected.
function GetRandomHero(heroPool, selectedHeroes)
	local hero;
	repeat
		hero = heroPool[RandomInt(1, #heroPool)]
	until (selectedHeroes[hero] ~= true)
	return hero;
end

-- first, check the list of required heroes and pick from those
-- then try the whole bot pool
function GetRandomHero2()
	local hero;
	local picks = GetPicks();
	local selectedHeroes = {};

	for slot, hero in pairs(picks) do
		selectedHeroes[hero] = true;
	end

	if testMode then
		hero = requiredHeroes[RandomInt(1, #requiredHeroes)];
	else
		hero = nil;
	end

	if (hero == nil) then
		hero = allBotHeroes[RandomInt(1, #allBotHeroes)];
	end

	while (selectedHeroes[hero] == true) do
		hero = allBotHeroes[RandomInt(1, #allBotHeroes)];
	end

	return hero;
end

-- Returns true if, for the specified team, all the Human players have picked a hero.
function AreHumanPlayersReady(team)
	local number, playernumber = 0, 0
	local IDs = GetTeamPlayers(team);
	for i, id in pairs(IDs) do
		if (IsPlayerBot(id) == false)
		then
			local hName = GetSelectedHeroName(id)
			playernumber = playernumber + 1
			if (hName ~= "")
			then
				number = number + 1
			end
		end
	end

	if (number >= playernumber)
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
	local safeLane = GetSafeLane();
	local offLane = GetOffLane();

	local laneTable = {
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
	local lanes = { 1, 1, 2, 3, 3 };

	for id = 1, 5 do
		local hero = GetTeamMember(id);
		if (hero == nil)
		then
			break;
		end
		local heroName = hero:GetUnitName();
		local postion = GetHeroPostion(heroName);
		lanes[id] = laneTable[postion];
	end
	return lanes;
end

function TranspositionTable(sourceTable)
	local newTable = {};
	for k, v in pairs(sourceTable) do
		newTable[v] = k;
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
local chatLanes = {};
---------------------------------------------------------LANE ASSIGMENT WITH CHAT FEATURE-----------------------------------------------
function SelectLaneChatCallback(PlayerID, ChatText, bTeamOnly)
	if GetTeamForPlayer(PlayerID) == GetTeam() then
		chatLanes = {};
		local count = 1;
		for str in string.gmatch(ChatText, "%S+") do
			if str == "top" then
				chatLanes[count] = LANE_TOP;
			elseif str == "mid" then
				chatLanes[count] = LANE_MID;
			elseif str == "bot" then
				chatLanes[count] = LANE_BOT;
			end
			count = count + 1;
		end
		if #chatLanes ~= 5 then
			print("Wrong Command! Lane count is less or more than 5. Typo? Please type 5 lane (top, mid, or bot) with space separating each other.")
		end
	else
		print("You're not my team...!")
	end
end

function UpdateLaneAssignments()
	-- if GetGameMode() == GAMEMODE_AP or GetGameMode() == GAMEMODE_TM or GetGameMode() == GAMEMODE_SD then
	if GetGameMode() == GAMEMODE_AP or GetGameMode() == 23 or GetGameMode() == GAMEMODE_SD then
		--print("AP Lane Assignment")
		if GetGameState() == GAME_STATE_STRATEGY_TIME or GetGameState() == GAME_STATE_PRE_GAME then
			InstallChatCallback(function(attr) SelectLaneChatCallback(attr.player_id, attr.string, attr.team_only); end);
		end
		if #chatLanes == 5 then
			return chatLanes;
		else
			return APLaneAssignment();
		end
	elseif GetGameMode() == GAMEMODE_CM then
		--print("CM Lane Assignment")
		return CMLaneAssignment()
	elseif GetGameMode() == GAMEMODE_AR then
		return APLaneAssignment()
	elseif GetGameMode() == GAMEMODE_MO then
		return MOLaneAssignment()
	elseif GetGameMode() == GAMEMODE_1V1MID then
		return OneVsOneLaneAssignment()
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

	local lanecount = {
		[LANE_NONE] = 5,
		[LANE_MID] = 1,
		[LANE_TOP] = 2,
		[LANE_BOT] = 2,
	};

	local lanes = {
		[1] = LANE_MID,
		[2] = LANE_TOP,
		[3] = LANE_TOP,
		[4] = LANE_BOT,
		[5] = LANE_BOT,
	};

	local playercount = 0

	if (GetTeam() == TEAM_RADIANT)
	then
		local ids = GetTeamPlayers(TEAM_RADIANT)
		for i, v in pairs(ids) do
			if not IsPlayerBot(v) then
				playercount = playercount + 1
			end
		end
		for i = 1, playercount do
			local lane = GetLane(TEAM_RADIANT, GetTeamMember(i))
			lanecount[lane] = lanecount[lane] - 1
			lanes[i] = lane
		end

		for i = (playercount + 1), 5 do
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
		--print("RAD")
		--utils.print_r(lanes)
		return lanes
	elseif (GetTeam() == TEAM_DIRE)
	then
		local ids = GetTeamPlayers(TEAM_DIRE)
		for i, v in pairs(ids) do
			--print(tostring(IsPlayerBot(v)))
			if not IsPlayerBot(v) then
				playercount = playercount + 1
			end
		end
		for i = 1, playercount do
			local lane = GetLane(TEAM_DIRE, GetTeamMember(i))
			lanecount[lane] = lanecount[lane] - 1
			lanes[i] = lane
		end

		for i = (playercount + 1), 5 do
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
		--print("DIRE")
		--utils.print_r(lanes)
		return lanes
	end
end

function GetLane(nTeam, hHero)
	if (hHero == nil)
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
local CMdebugMode = true;
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
	if not CMdebugMode then
		NeededTime = RandomInt(Min, Max);
		--end
	elseif CMdebugMode then
		NeededTime = 25;
	end
	if GetHeroPickState() == HEROPICK_STATE_CM_CAPTAINPICK then
		PickCaptain();
	elseif GetHeroPickState() >= HEROPICK_STATE_CM_BAN1 and GetHeroPickState() <= 18 and
		GetCMPhaseTimeRemaining() <= NeededTime then
		BansHero();
		NeededTime = 0
	elseif GetHeroPickState() >= HEROPICK_STATE_CM_SELECT1 and GetHeroPickState() <= HEROPICK_STATE_CM_SELECT10 and
		GetCMPhaseTimeRemaining() <= NeededTime then
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
				print("CAPTAIN PID : " .. CaptBot)
				SetCMCaptain(CaptBot)
			end
		end
	end
end

--Check if human player exist in team
function IsHumanPlayerExist()
	local Players = GetTeamPlayers(GetTeam())
	for _, id in pairs(Players) do
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
	for _, id in pairs(Players) do
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
	print(BannedHero .. " is banned")
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
	elseif PickCycle == 2 then
		while not role.CanBeSupport(PickedHero) do
			PickedHero = RandomHero();
		end
		PairsHeroNameNRole[PickedHero] = "support";
	elseif PickCycle == 3 then
		while not role.CanBeMidlaner(PickedHero) do
			PickedHero = RandomHero();
		end
		PairsHeroNameNRole[PickedHero] = "midlaner";
	elseif PickCycle == 4 then
		while not role.CanBeSupport(PickedHero) do
			PickedHero = RandomHero();
		end
		PairsHeroNameNRole[PickedHero] = "support";
	elseif PickCycle == 5 then
		while not role.CanBeSafeLaneCarry(PickedHero) do
			PickedHero = RandomHero();
		end
		PairsHeroNameNRole[PickedHero] = "carry";
	end
	print(PickedHero .. " is picked")
	CMPickHero(PickedHero);
	PickCycle = PickCycle + 1;
end

--Add to list human picked heroes
function AddToList()
	if not IsPlayerBot(GetCMCaptain()) then
		for _, h in pairs(allBotHeroes) do
			if IsCMPickedHero(GetTeam(), h) and not alreadyInTable(h) then
				table.insert(humanPick, h)
			end
		end
	end
end

--Check if selected hero already picked by human
function alreadyInTable(hero_name)
	for _, h in pairs(humanPick) do
		if hero_name == h then
			return true
		end
	end
	return false
end

--Check if the randomed hero doesn't available for captain's mode
function IsUnavailableHero(name)
	for _, uh in pairs(UnavailableHeroes) do
		if name == uh then
			return true;
		end
	end
	return false;
end

--Check if a hero hasn't implemented yet
function IsUnImplementedHeroes(name)
	for _, unh in pairs(UnImplementedHeroes) do
		if name == unh then
			return true;
		end
	end
	return false;
end

--Random hero which is non picked, non banned, or non human picked heroes if the human is the captain
function RandomHero()
	local hero = allBotHeroes[RandomInt(1, #allBotHeroes)];
	while (
		IsUnavailableHero(hero) or IsCMPickedHero(GetTeam(), hero) or IsCMPickedHero(GetOpposingTeam(), hero) or
			IsCMBannedHero(hero)) do
		hero = allBotHeroes[RandomInt(1, #allBotHeroes)];
	end
	return hero;
end

--Check if the human already pick the hero in captain's mode
function WasHumansDonePicking()
	local Players = GetTeamPlayers(GetTeam())
	for _, id in pairs(Players) do
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
	if not AllHeroesSelected and (WasHumansDonePicking() or GetCMPhaseTimeRemaining() < 1) then
		local Players = GetTeamPlayers(GetTeam())
		local RestBotPlayers = {};
		GetTeamSelectedHeroes();

		for _, id in pairs(Players) do
			local hero_name = GetSelectedHeroName(id);
			if hero_name ~= nil and hero_name ~= "" then
				UpdateSelectedHeroes(hero_name)
				print(hero_name .. " Removed")
			else
				table.insert(RestBotPlayers, id)
			end
		end

		for i = 1, #RestBotPlayers do
			SelectHero(RestBotPlayers[i], ListPickedHeroes[i])
		end

		AllHeroesSelected = true;
	end
end

--Get the team picked heroes
function GetTeamSelectedHeroes()
	for _, sName in pairs(allBotHeroes) do
		if IsCMPickedHero(GetTeam(), sName) then
			table.insert(ListPickedHeroes, sName);
		end
	end
	for _, sName in pairs(UnImplementedHeroes) do
		if IsCMPickedHero(GetTeam(), sName) then
			table.insert(ListPickedHeroes, sName);
		end
	end
end

--Update team picked heroes after human players select their desired hero
function UpdateSelectedHeroes(selected)
	for i = 1, #ListPickedHeroes do
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
	for i = 1, #TeamMember do
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
			local unit_name = GetTeamMember(i):GetUnitName();
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
	for i = 1, #TeamMember do
		if GetTeamMember(i) ~= nil and GetTeamMember(i):IsHero() then
			local unit_name = GetTeamMember(i):GetUnitName();
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
	for key, h in pairs(humanPick) do
		if hero_name == h then
			i = key;
		end
	end
	return i;
end

---------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------MID ONLY LANE ASSIGNMENT------------------------------------------------------
function MOLaneAssignment()
	local lanes = {
		[1] = LANE_MID,
		[2] = LANE_MID,
		[3] = LANE_MID,
		[4] = LANE_MID,
		[5] = LANE_MID,
	};
	return lanes;
end

---------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------1 VS 1 LANE ASSIGNMENT------------------------------------------------------
function OneVsOneLaneAssignment()
	local lanes = {
		[1] = LANE_MID,
		[2] = LANE_TOP,
		[3] = LANE_TOP,
		[4] = LANE_TOP,
		[5] = LANE_TOP,
	};
	return lanes;
end

---------------------------------------------------------------------------------------------------------------------------------------
