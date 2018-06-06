----------------------------------------------------------------------------------------------------
-- BOT EXPERIMENT Author:Arizona Fauzie Link:http://steamcommunity.com/sharedfiles/filedetails/?id=837040016
----------------------------------------------------------------------------------------------------
-- generic database
----------------------------------------------------------------------------------------------------

local X = {}

----------------------------------------------------------------------------------------------------

-- ["carry"] will become more useful later in the game if they gain a significant gold advantage.
-- ["durable"] has the ability to last longer in teamfights.
-- ["support"] can focus less on amassing gold and items, and more on using their abilities to gain an advantage for the team.
-- ["escape"] has the ability to quickly avoid death.
-- ["nuker"] can quickly kill enemy heroes using high damage spells with low cooldowns.
-- ["pusher"] can quickly siege and destroy towers and barracks at all points of the game.
-- ["disabler"] has a guaranteed disable for one or more of their spells.
-- ["initiator"] good at starting a teamfight.
-- ["jungler"] can farm effectively from neutral creeps inside the jungle early in the game.

X["hero_roles"] = {
	["npc_dota_hero_abaddon"] = {
		['carry'] = 1,
		['disabler'] = 0,
		['durable'] = 2,
		['escape'] = 0,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 0,
		['support'] = 2,
		['pusher'] = 0
	},

	["npc_dota_hero_alchemist"] = {
		['carry'] = 2,
		['disabler'] = 1,
		['durable'] = 2,
		['escape'] = 0,
		['initiator'] = 1,
		['jungler'] = 0,
		['nuker'] = 1,
		['support'] = 1,
		['pusher'] = 0
	},

	["npc_dota_hero_axe"] = {
		['carry'] = 0,
		['disabler'] = 2,
		['durable'] = 3,
		['escape'] = 0,
		['initiator'] = 3,
		['jungler'] = 2,
		['nuker'] = 0,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_beastmaster"] = {
		['carry'] = 0,
		['disabler'] = 2,
		['durable'] = 2,
		['escape'] = 0,
		['initiator'] = 2,
		['jungler'] = 0,
		['nuker'] = 1,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_brewmaster"] = {
		['carry'] = 1,
		['disabler'] = 2,
		['durable'] = 2,
		['escape'] = 0,
		['initiator'] = 3,
		['jungler'] = 0,
		['nuker'] = 1,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_bristleback"] = {
		['carry'] = 2,
		['disabler'] = 0,
		['durable'] = 3,
		['escape'] = 0,
		['initiator'] = 1,
		['jungler'] = 0,
		['nuker'] = 1,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_centaur"] = {
		['carry'] = 0,
		['disabler'] = 1,
		['durable'] = 3,
		['escape'] = 0,
		['initiator'] = 3,
		['jungler'] = 0,
		['nuker'] = 1,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_chaos_knight"] = {
		['carry'] = 3,
		['disabler'] = 2,
		['durable'] = 2,
		['escape'] = 0,
		['initiator'] = 1,
		['jungler'] = 0,
		['nuker'] = 0,
		['support'] = 0,
		['pusher'] = 2
	},

	["npc_dota_hero_rattletrap"] = {
		['carry'] = 0,
		['disabler'] = 2,
		['durable'] = 1,
		['escape'] = 0,
		['initiator'] = 3,
		['jungler'] = 0,
		['nuker'] = 1,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_doom_bringer"] = {
		['carry'] = 1,
		['disabler'] = 2,
		['durable'] = 2,
		['escape'] = 0,
		['initiator'] = 2,
		['jungler'] = 0,
		['nuker'] = 0,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_dragon_knight"] = {
		['carry'] = 2,
		['disabler'] = 2,
		['durable'] = 2,
		['escape'] = 0,
		['initiator'] = 1,
		['jungler'] = 0,
		['nuker'] = 1,
		['support'] = 0,
		['pusher'] = 3
	},

	["npc_dota_hero_earth_spirit"] = {
		['carry'] = 0,
		['disabler'] = 1,
		['durable'] = 1,
		['escape'] = 2,
		['initiator'] = 1,
		['jungler'] = 0,
		['nuker'] = 2,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_earthshaker"] = {
		['carry'] = 0,
		['disabler'] = 2,
		['durable'] = 0,
		['escape'] = 0,
		['initiator'] = 3,
		['jungler'] = 0,
		['nuker'] = 1,
		['support'] = 1,
		['pusher'] = 0
	},

	["npc_dota_hero_elder_titan"] = {
		['carry'] = 0,
		['disabler'] = 1,
		['durable'] = 1,
		['escape'] = 0,
		['initiator'] = 2,
		['jungler'] = 0,
		['nuker'] = 1,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_huskar"] = {
		['carry'] = 2,
		['disabler'] = 0,
		['durable'] = 2,
		['escape'] = 0,
		['initiator'] = 1,
		['jungler'] = 0,
		['nuker'] = 0,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_wisp"] = {
		['carry'] = 0,
		['disabler'] = 0,
		['durable'] = 0,
		['escape'] = 2,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 1,
		['support'] = 3,
		['pusher'] = 0
	},

	["npc_dota_hero_kunkka"] = {
		['carry'] = 1,
		['disabler'] = 1,
		['durable'] = 1,
		['escape'] = 0,
		['initiator'] = 1,
		['jungler'] = 0,
		['nuker'] = 1,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_legion_commander"] = {
		['carry'] = 1,
		['disabler'] = 2,
		['durable'] = 1,
		['escape'] = 0,
		['initiator'] = 1,
		['jungler'] = 0,
		['nuker'] = 1,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_life_stealer"] = {
		['carry'] = 2,
		['disabler'] = 1,
		['durable'] = 2,
		['escape'] = 1,
		['initiator'] = 0,
		['jungler'] = 1,
		['nuker'] = 0,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_lycan"] = {
		['carry'] = 2,
		['disabler'] = 0,
		['durable'] = 1,
		['escape'] = 1,
		['initiator'] = 0,
		['jungler'] = 1,
		['nuker'] = 0,
		['support'] = 0,
		['pusher'] = 3
	},

	["npc_dota_hero_magnataur"] = {
		['carry'] = 0,
		['disabler'] = 2,
		['durable'] = 0,
		['escape'] = 1,
		['initiator'] = 3,
		['jungler'] = 0,
		['nuker'] = 1,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_night_stalker"] = {
		['carry'] = 1,
		['disabler'] = 2,
		['durable'] = 2,
		['escape'] = 0,
		['initiator'] = 2,
		['jungler'] = 0,
		['nuker'] = 1,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_omniknight"] = {
		['carry'] = 0,
		['disabler'] = 0,
		['durable'] = 1,
		['escape'] = 0,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 1,
		['support'] = 2,
		['pusher'] = 0
	},

	["npc_dota_hero_phoenix"] = {
		['carry'] = 0,
		['disabler'] = 1,
		['durable'] = 0,
		['escape'] = 2,
		['initiator'] = 2,
		['jungler'] = 0,
		['nuker'] = 3,
		['support'] = 1,
		['pusher'] = 0
	},

	["npc_dota_hero_pudge"] = {
		['carry'] = 0,
		['disabler'] = 2,
		['durable'] = 2,
		['escape'] = 0,
		['initiator'] = 2,
		['jungler'] = 0,
		['nuker'] = 1,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_sand_king"] = {
		['carry'] = 0,
		['disabler'] = 2,
		['durable'] = 0,
		['escape'] = 2,
		['initiator'] = 3,
		['jungler'] = 1,
		['nuker'] = 2,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_slardar"] = {
		['carry'] = 2,
		['disabler'] = 1,
		['durable'] = 2,
		['escape'] = 1,
		['initiator'] = 2,
		['jungler'] = 0,
		['nuker'] = 0,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_spirit_breaker"] = {
		['carry'] = 1,
		['disabler'] = 2,
		['durable'] = 2,
		['escape'] = 1,
		['initiator'] = 2,
		['jungler'] = 0,
		['nuker'] = 0,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_sven"] = {
		['carry'] = 2,
		['disabler'] = 2,
		['durable'] = 2,
		['escape'] = 0,
		['initiator'] = 2,
		['jungler'] = 0,
		['nuker'] = 1,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_tidehunter"] = {
		['carry'] = 0,
		['disabler'] = 2,
		['durable'] = 3,
		['escape'] = 0,
		['initiator'] = 3,
		['jungler'] = 0,
		['nuker'] = 1,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_shredder"] = {
		['carry'] = 0,
		['disabler'] = 0,
		['durable'] = 2,
		['escape'] = 2,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 3,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_tiny"] = {
		['carry'] = 3,
		['disabler'] = 1,
		['durable'] = 2,
		['escape'] = 0,
		['initiator'] = 2,
		['jungler'] = 0,
		['nuker'] = 2,
		['support'] = 0,
		['pusher'] = 2
	},

	["npc_dota_hero_treant"] = {
		['carry'] = 0,
		['disabler'] = 2,
		['durable'] = 1,
		['escape'] = 1,
		['initiator'] = 2,
		['jungler'] = 0,
		['nuker'] = 0,
		['support'] = 3,
		['pusher'] = 0
	},

	["npc_dota_hero_tusk"] = {
		['carry'] = 0,
		['disabler'] = 2,
		['durable'] = 0,
		['escape'] = 0,
		['initiator'] = 2,
		['jungler'] = 0,
		['nuker'] = 1,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_abyssal_underlord"] = {
		['carry'] = 0,
		['disabler'] = 1,
		['durable'] = 1,
		['escape'] = 2,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 1,
		['support'] = 1,
		['pusher'] = 0
	},

	["npc_dota_hero_undying"] = {
		['carry'] = 0,
		['disabler'] = 1,
		['durable'] = 2,
		['escape'] = 0,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 1,
		['support'] = 1,
		['pusher'] = 0
	},

	["npc_dota_hero_skeleton_king"] = {
		['carry'] = 2,
		['disabler'] = 2,
		['durable'] = 3,
		['escape'] = 0,
		['initiator'] = 1,
		['jungler'] = 0,
		['nuker'] = 0,
		['support'] = 1,
		['pusher'] = 0
	},

	["npc_dota_hero_antimage"] = {
		['carry'] = 3,
		['disabler'] = 0,
		['durable'] = 0,
		['escape'] = 3,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 1,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_arc_warden"] = {
		['carry'] = 3,
		['disabler'] = 0,
		['durable'] = 0,
		['escape'] = 3,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 1,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_bloodseeker"] = {
		['carry'] = 1,
		['disabler'] = 1,
		['durable'] = 0,
		['escape'] = 0,
		['initiator'] = 1,
		['jungler'] = 1,
		['nuker'] = 1,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_bounty_hunter"] = {
		['carry'] = 0,
		['disabler'] = 0,
		['durable'] = 0,
		['escape'] = 2,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 1,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_broodmother"] = {
		['carry'] = 1,
		['disabler'] = 1,
		['durable'] = 0,
		['escape'] = 3,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 1,
		['support'] = 0,
		['pusher'] = 3
	},

	["npc_dota_hero_clinkz"] = {
		['carry'] = 2,
		['disabler'] = 0,
		['durable'] = 0,
		['escape'] = 3,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 1,
		['support'] = 0,
		['pusher'] = 1
	},

	["npc_dota_hero_drow_ranger"] = {
		['carry'] = 2,
		['disabler'] = 1,
		['durable'] = 0,
		['escape'] = 0,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 0,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_ember_spirit"] = {
		['carry'] = 2,
		['disabler'] = 1,
		['durable'] = 0,
		['escape'] = 3,
		['initiator'] = 1,
		['jungler'] = 0,
		['nuker'] = 1,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_faceless_void"] = {
		['carry'] = 3,
		['disabler'] = 2,
		['durable'] = 0,
		['escape'] = 2,
		['initiator'] = 3,
		['jungler'] = 0,
		['nuker'] = 0,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_gyrocopter"] = {
		['carry'] = 3,
		['disabler'] = 1,
		['durable'] = 0,
		['escape'] = 0,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 1,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_juggernaut"] = {
		['carry'] = 2,
		['disabler'] = 0,
		['durable'] = 0,
		['escape'] = 1,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 0,
		['support'] = 0,
		['pusher'] = 1
	},

	["npc_dota_hero_lone_druid"] = {
		['carry'] = 2,
		['disabler'] = 0,
		['durable'] = 1,
		['escape'] = 0,
		['initiator'] = 0,
		['jungler'] = 1,
		['nuker'] = 0,
		['support'] = 0,
		['pusher'] = 3
	},

	["npc_dota_hero_luna"] = {
		['carry'] = 2,
		['disabler'] = 0,
		['durable'] = 0,
		['escape'] = 0,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 2,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_medusa"] = {
		['carry'] = 3,
		['disabler'] = 1,
		['durable'] = 1,
		['escape'] = 0,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 0,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_meepo"] = {
		['carry'] = 2,
		['disabler'] = 1,
		['durable'] = 0,
		['escape'] = 2,
		['initiator'] = 1,
		['jungler'] = 0,
		['nuker'] = 2,
		['support'] = 0,
		['pusher'] = 1
	},

	["npc_dota_hero_mirana"] = {
		['carry'] = 1,
		['disabler'] = 1,
		['durable'] = 0,
		['escape'] = 2,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 1,
		['support'] = 1,
		['pusher'] = 0
	},

	["npc_dota_hero_monkey_king"] = {
		['carry'] = 2,
		['disabler'] = 1,
		['durable'] = 0,
		['escape'] = 2,
		['initiator'] = 1,
		['jungler'] = 0,
		['nuker'] = 0,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_morphling"] = {
		['carry'] = 3,
		['disabler'] = 1,
		['durable'] = 2,
		['escape'] = 3,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 1,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_naga_siren"] = {
		['carry'] = 3,
		['disabler'] = 2,
		['durable'] = 0,
		['escape'] = 1,
		['initiator'] = 1,
		['jungler'] = 0,
		['nuker'] = 0,
		['support'] = 1,
		['pusher'] = 2
	},

	["npc_dota_hero_nyx_assassin"] = {
		['carry'] = 0,
		['disabler'] = 2,
		['durable'] = 0,
		['escape'] = 1,
		['initiator'] = 2,
		['jungler'] = 0,
		['nuker'] = 2,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_phantom_assassin"] = {
		['carry'] = 3,
		['disabler'] = 0,
		['durable'] = 0,
		['escape'] = 1,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 0,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_phantom_lancer"] = {
		['carry'] = 2,
		['disabler'] = 0,
		['durable'] = 0,
		['escape'] = 2,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 1,
		['support'] = 0,
		['pusher'] = 1
	},

	["npc_dota_hero_razor"] = {
		['carry'] = 2,
		['disabler'] = 0,
		['durable'] = 2,
		['escape'] = 0,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 1,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_riki"] = {
		['carry'] = 2,
		['disabler'] = 1,
		['durable'] = 0,
		['escape'] = 2,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 0,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_nevermore"] = {
		['carry'] = 2,
		['disabler'] = 0,
		['durable'] = 0,
		['escape'] = 0,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 3,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_slark"] = {
		['carry'] = 2,
		['disabler'] = 1,
		['durable'] = 0,
		['escape'] = 0,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 1,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_sniper"] = {
		['carry'] = 2,
		['disabler'] = 0,
		['durable'] = 0,
		['escape'] = 0,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 1,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_spectre"] = {
		['carry'] = 3,
		['disabler'] = 0,
		['durable'] = 1,
		['escape'] = 1,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 0,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_templar_assassin"] = {
		['carry'] = 2,
		['disabler'] = 0,
		['durable'] = 0,
		['escape'] = 1,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 0,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_terrorblade"] = {
		['carry'] = 3,
		['disabler'] = 0,
		['durable'] = 0,
		['escape'] = 0,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 1,
		['support'] = 0,
		['pusher'] = 2
	},

	["npc_dota_hero_troll_warlord"] = {
		['carry'] = 3,
		['disabler'] = 1,
		['durable'] = 1,
		['escape'] = 0,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 0,
		['support'] = 0,
		['pusher'] = 1
	},

	["npc_dota_hero_ursa"] = {
		['carry'] = 2,
		['disabler'] = 1,
		['durable'] = 1,
		['escape'] = 0,
		['initiator'] = 0,
		['jungler'] = 1,
		['nuker'] = 0,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_vengefulspirit"] = {
		['carry'] = 0,
		['disabler'] = 2,
		['durable'] = 0,
		['escape'] = 1,
		['initiator'] = 2,
		['jungler'] = 0,
		['nuker'] = 1,
		['support'] = 3,
		['pusher'] = 0
	},

	["npc_dota_hero_venomancer"] = {
		['carry'] = 0,
		['disabler'] = 1,
		['durable'] = 0,
		['escape'] = 0,
		['initiator'] = 1,
		['jungler'] = 0,
		['nuker'] = 1,
		['support'] = 2,
		['pusher'] = 1
	},

	["npc_dota_hero_viper"] = {
		['carry'] = 1,
		['disabler'] = 1,
		['durable'] = 2,
		['escape'] = 0,
		['initiator'] = 1,
		['jungler'] = 0,
		['nuker'] = 0,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_weaver"] = {
		['carry'] = 2,
		['disabler'] = 0,
		['durable'] = 0,
		['escape'] = 3,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 0,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_ancient_apparition"] = {
		['carry'] = 0,
		['disabler'] = 1,
		['durable'] = 0,
		['escape'] = 0,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 1,
		['support'] = 2,
		['pusher'] = 0
	},

	["npc_dota_hero_bane"] = {
		['carry'] = 0,
		['disabler'] = 3,
		['durable'] = 1,
		['escape'] = 0,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 1,
		['support'] = 2,
		['pusher'] = 0
	},

	["npc_dota_hero_batrider"] = {
		['carry'] = 0,
		['disabler'] = 2,
		['durable'] = 0,
		['escape'] = 1,
		['initiator'] = 3,
		['jungler'] = 2,
		['nuker'] = 0,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_chen"] = {
		['carry'] = 0,
		['disabler'] = 0,
		['durable'] = 0,
		['escape'] = 0,
		['initiator'] = 0,
		['jungler'] = 3,
		['nuker'] = 0,
		['support'] = 2,
		['pusher'] = 2
	},

	["npc_dota_hero_crystal_maiden"] = {
		['carry'] = 0,
		['disabler'] = 2,
		['durable'] = 0,
		['escape'] = 0,
		['initiator'] = 0,
		['jungler'] = 1,
		['nuker'] = 2,
		['support'] = 3,
		['pusher'] = 0
	},

	["npc_dota_hero_dark_seer"] = {
		['carry'] = 0,
		['disabler'] = 1,
		['durable'] = 0,
		['escape'] = 1,
		['initiator'] = 1,
		['jungler'] = 1,
		['nuker'] = 0,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_dazzle"] = {
		['carry'] = 0,
		['disabler'] = 1,
		['durable'] = 0,
		['escape'] = 0,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 1,
		['support'] = 3,
		['pusher'] = 0
	},

	["npc_dota_hero_death_prophet"] = {
		['carry'] = 1,
		['disabler'] = 1,
		['durable'] = 0,
		['escape'] = 0,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 1,
		['support'] = 0,
		['pusher'] = 3
	},

	["npc_dota_hero_disruptor"] = {
		['carry'] = 0,
		['disabler'] = 2,
		['durable'] = 0,
		['escape'] = 0,
		['initiator'] = 1,
		['jungler'] = 0,
		['nuker'] = 1,
		['support'] = 2,
		['pusher'] = 0
	},

	["npc_dota_hero_enchantress"] = {
		['carry'] = 0,
		['disabler'] = 0,
		['durable'] = 1,
		['escape'] = 0,
		['initiator'] = 0,
		['jungler'] = 3,
		['nuker'] = 1,
		['support'] = 0,
		['pusher'] = 2
	},

	["npc_dota_hero_enigma"] = {
		['carry'] = 0,
		['disabler'] = 2,
		['durable'] = 0,
		['escape'] = 0,
		['initiator'] = 2,
		['jungler'] = 3,
		['nuker'] = 0,
		['support'] = 0,
		['pusher'] = 2
	},

	["npc_dota_hero_invoker"] = {
		['carry'] = 1,
		['disabler'] = 2,
		['durable'] = 0,
		['escape'] = 1,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 3,
		['support'] = 0,
		['pusher'] = 1
	},

	["npc_dota_hero_jakiro"] = {
		['carry'] = 0,
		['disabler'] = 1,
		['durable'] = 0,
		['escape'] = 0,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 2,
		['support'] = 1,
		['pusher'] = 2
	},

	["npc_dota_hero_keeper_of_the_light"] = {
		['carry'] = 0,
		['disabler'] = 1,
		['durable'] = 0,
		['escape'] = 0,
		['initiator'] = 0,
		['jungler'] = 1,
		['nuker'] = 2,
		['support'] = 3,
		['pusher'] = 0
	},

	["npc_dota_hero_leshrac"] = {
		['carry'] = 1,
		['disabler'] = 1,
		['durable'] = 0,
		['escape'] = 0,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 3,
		['support'] = 1,
		['pusher'] = 3
	},

	["npc_dota_hero_lich"] = {
		['carry'] = 0,
		['disabler'] = 0,
		['durable'] = 0,
		['escape'] = 0,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 2,
		['support'] = 3,
		['pusher'] = 0
	},

	["npc_dota_hero_lina"] = {
		['carry'] = 1,
		['disabler'] = 1,
		['durable'] = 0,
		['escape'] = 0,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 3,
		['support'] = 1,
		['pusher'] = 0
	},

	["npc_dota_hero_lion"] = {
		['carry'] = 0,
		['disabler'] = 3,
		['durable'] = 0,
		['escape'] = 0,
		['initiator'] = 2,
		['jungler'] = 0,
		['nuker'] = 3,
		['support'] = 2,
		['pusher'] = 0
	},

	["npc_dota_hero_furion"] = {
		['carry'] = 1,
		['disabler'] = 0,
		['durable'] = 0,
		['escape'] = 1,
		['initiator'] = 0,
		['jungler'] = 3,
		['nuker'] = 1,
		['support'] = 0,
		['pusher'] = 3
	},

	["npc_dota_hero_necrolyte"] = {
		['carry'] = 1,
		['disabler'] = 1,
		['durable'] = 1,
		['escape'] = 0,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 2,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_ogre_magi"] = {
		['carry'] = 0,
		['disabler'] = 2,
		['durable'] = 1,
		['escape'] = 0,
		['initiator'] = 1,
		['jungler'] = 0,
		['nuker'] = 2,
		['support'] = 2,
		['pusher'] = 0
	},

	["npc_dota_hero_oracle"] = {
		['carry'] = 0,
		['disabler'] = 2,
		['durable'] = 0,
		['escape'] = 1,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 3,
		['support'] = 3,
		['pusher'] = 0
	},

	["npc_dota_hero_obsidian_destroyer"] = {
		['carry'] = 2,
		['disabler'] = 1,
		['durable'] = 0,
		['escape'] = 0,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 2,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_puck"] = {
		['carry'] = 0,
		['disabler'] = 3,
		['durable'] = 0,
		['escape'] = 3,
		['initiator'] = 3,
		['jungler'] = 0,
		['nuker'] = 2,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_pugna"] = {
		['carry'] = 0,
		['disabler'] = 0,
		['durable'] = 0,
		['escape'] = 0,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 2,
		['support'] = 0,
		['pusher'] = 2
	},

	["npc_dota_hero_queenofpain"] = {
		['carry'] = 1,
		['disabler'] = 0,
		['durable'] = 0,
		['escape'] = 3,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 3,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_rubick"] = {
		['carry'] = 0,
		['disabler'] = 1,
		['durable'] = 0,
		['escape'] = 0,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 1,
		['support'] = 2,
		['pusher'] = 0
	},

	["npc_dota_hero_shadow_demon"] = {
		['carry'] = 0,
		['disabler'] = 2,
		['durable'] = 0,
		['escape'] = 0,
		['initiator'] = 1,
		['jungler'] = 0,
		['nuker'] = 1,
		['support'] = 2,
		['pusher'] = 0
	},

	["npc_dota_hero_shadow_shaman"] = {
		['carry'] = 0,
		['disabler'] = 3,
		['durable'] = 0,
		['escape'] = 0,
		['initiator'] = 1,
		['jungler'] = 0,
		['nuker'] = 2,
		['support'] = 2,
		['pusher'] = 3
	},

	["npc_dota_hero_silencer"] = {
		['carry'] = 1,
		['disabler'] = 2,
		['durable'] = 0,
		['escape'] = 0,
		['initiator'] = 2,
		['jungler'] = 0,
		['nuker'] = 1,
		['support'] = 1,
		['pusher'] = 0
	},

	["npc_dota_hero_skywrath_mage"] = {
		['carry'] = 0,
		['disabler'] = 1,
		['durable'] = 0,
		['escape'] = 0,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 3,
		['support'] = 2,
		['pusher'] = 0
	},

	["npc_dota_hero_storm_spirit"] = {
		['carry'] = 2,
		['disabler'] = 1,
		['durable'] = 0,
		['escape'] = 3,
		['initiator'] = 1,
		['jungler'] = 0,
		['nuker'] = 2,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_techies"] = {
		['carry'] = 0,
		['disabler'] = 1,
		['durable'] = 0,
		['escape'] = 0,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 3,
		['support'] = 0,
		['pusher'] = 0
	},

	["npc_dota_hero_tinker"] = {
		['carry'] = 1,
		['disabler'] = 0,
		['durable'] = 0,
		['escape'] = 0,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 3,
		['support'] = 0,
		['pusher'] = 2
	},

	["npc_dota_hero_visage"] = {
		['carry'] = 0,
		['disabler'] = 1,
		['durable'] = 1,
		['escape'] = 0,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 2,
		['support'] = 1,
		['pusher'] = 1
	},

	["npc_dota_hero_warlock"] = {
		['carry'] = 0,
		['disabler'] = 1,
		['durable'] = 0,
		['escape'] = 0,
		['initiator'] = 2,
		['jungler'] = 0,
		['nuker'] = 0,
		['support'] = 1,
		['pusher'] = 0
	},

	["npc_dota_hero_windrunner"] = {
		['carry'] = 1,
		['disabler'] = 1,
		['durable'] = 0,
		['escape'] = 1,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 1,
		['support'] = 1,
		['pusher'] = 0
	},

	["npc_dota_hero_winter_wyvern"] = {
		['carry'] = 0,
		['disabler'] = 2,
		['durable'] = 0,
		['escape'] = 0,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 1,
		['support'] = 3,
		['pusher'] = 0
	},

	["npc_dota_hero_witch_doctor"] = {
		['carry'] = 0,
		['disabler'] = 1,
		['durable'] = 0,
		['escape'] = 0,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 2,
		['support'] = 3,
		['pusher'] = 0
	},

	["npc_dota_hero_zuus"] = {
		['carry'] = 0,
		['disabler'] = 0,
		['durable'] = 0,
		['escape'] = 0,
		['initiator'] = 0,
		['jungler'] = 0,
		['nuker'] = 3,
		['support'] = 0,
		['pusher'] = 0
	}
}

X["bottle"] = {
	["npc_dota_hero_tinker"] = 1;
	["npc_dota_hero_storm_spirit"] = 1;
	["npc_dota_hero_pudge"] = 1;
	["npc_dota_hero_nevermore"] = 1;
	["npc_dota_hero_ember_spirit"] = 1;
	["npc_dota_hero_lina"] = 1;
	["npc_dota_hero_zuus"] = 1;
	["npc_dota_hero_queenofpain"] = 1;
	["npc_dota_hero_templar_assassin"] = 1;
	["npc_dota_hero_mirana"] = 1;
	["npc_dota_hero_puck"] = 1;
	["npc_dota_hero_magnataur"] = 1;
	["npc_dota_hero_windrunner"] = 1;
	["npc_dota_hero_obsidian_destroyer"] = 1;
	["npc_dota_hero_death_prophet"] = 1;
	["npc_dota_hero_tiny"] = 1;
	["npc_dota_hero_dragon_knight"] = 1;
	["npc_dota_hero_pugna"] = 1;
	["npc_dota_hero_naga_siren"] = 1;
}

X["phase_boots"] = {
		["npc_dota_hero_abaddon"] = 1,
		["npc_dota_hero_alchemist"] = 1,
		["npc_dota_hero_gyrocopter"] = 1,
		["npc_dota_hero_medusa"] = 1,
		["npc_dota_hero_phantom_assassin"] = 1,
		["npc_dota_hero_sniper"] = 1,
		["npc_dota_hero_spectre"] = 1,
		["npc_dota_hero_tiny"] = 1,
		["npc_dota_hero_troll_warlord"] = 1,
		["npc_dota_hero_alchemist"] = 1,
		["npc_dota_hero_life_stealer"] = 1,
		["npc_dota_hero_monkey_king"] = 1,
		["npc_dota_hero_ember_spirit"] = 1,
		["npc_dota_hero_juggernaut"] = 1,
		["npc_dota_hero_lone_druid"] = 1,
		["npc_dota_hero_razor"] = 1,
		["npc_dota_hero_templar_assassin"] = 1,
		["npc_dota_hero_ursa"] = 1,
		["npc_dota_hero_doom_bringer"] = 1,
		["npc_dota_hero_kunkka"] = 1,
		["npc_dota_hero_legion_commander"] = 1,
		["npc_dota_hero_night_stalker"] = 1,
		["npc_dota_hero_bloodseeker"] = 1,
		["npc_dota_hero_broodmother"] = 1,
		["npc_dota_hero_mirana"] = 1,
		["npc_dota_hero_invoker"] = 1,
		["npc_dota_hero_lina"] = 1,
		["npc_dota_hero_furion"] = 1,
		["npc_dota_hero_windrunner"] = 1
	}

X['invisHeroes'] = {
	['npc_dota_hero_templar_assassin'] = 1,
	['npc_dota_hero_clinkz'] = 1,
	['npc_dota_hero_mirana'] = 1,
	['npc_dota_hero_riki'] = 1,
	['npc_dota_hero_nyx_assassin'] = 1,
	['npc_dota_hero_bounty_hunter'] = 1,
	['npc_dota_hero_invoker'] = 1,
	['npc_dota_hero_sand_king'] = 1,
	['npc_dota_hero_treant'] = 1,
	['npc_dota_hero_broodmother'] = 1,
	['npc_dota_hero_weaver'] = 1
} 

function X.IsCarry(hero)
	if X["hero_roles"][hero] == nil then return false end;
	return X["hero_roles"][hero]["carry"] > 0;
end
function X.IsDisabler(hero)
	if X["hero_roles"][hero] == nil then return false end;
	return X["hero_roles"][hero]["disabler"] > 0;
end
function X.IsDurable(hero)
	if X["hero_roles"][hero] == nil then return false end;
	return X["hero_roles"][hero]["durable"] > 0;
end
function X.HasEscape(hero)
	if X["hero_roles"][hero] == nil then return false end;
	return X["hero_roles"][hero]["escape"] > 0;
end
function X.IsInitiator(hero)
	if X["hero_roles"][hero] == nil then return false end;
	return X["hero_roles"][hero]["initiator"] > 0;
end
function X.IsJungler(hero)
	if X["hero_roles"][hero] == nil then return false end;
	return X["hero_roles"][hero]["jungler"] > 0;
end
function X.IsNuker(hero)
	if X["hero_roles"][hero] == nil then return false end;
	return X["hero_roles"][hero]["nuker"] > 0;
end
function X.IsSupport(hero)
	if X["hero_roles"][hero] == nil then return false end;
	return X["hero_roles"][hero]["support"] > 0;
end
function X.IsPusher(hero)
	if X["hero_roles"][hero] == nil then return false end;
	return X["hero_roles"][hero]["pusher"] > 0;
end

function X.IsMelee(attackRange)
	return attackRange <= 320;
end

function X.BetterBuyPhaseBoots(hero)
	return X["phase_boots"][hero] == 1;
end	

function X.GetRoleLevel(hero, role)
	return X["hero_roles"][hero][role];
end

function X.IsRemovedFromSupportPoll(hero)
	return hero == "npc_dota_hero_juggernaut" or hero == "npc_dota_hero_chaos_knight" or hero == "npc_dota_hero_spectre" or hero == "npc_dota_hero_skeleton_king"
	or hero == "npc_dota_hero_slark" or hero == "npc_dota_hero_clinkz" or hero == "npc_dota_hero_sven" or hero == "npc_dota_hero_drow_ranger" 
	or hero == "npc_dota_hero_faceless_void" or hero == "npc_dota_hero_life_stealer" or hero == "npc_dota_hero_luna" or hero == "npc_dota_hero_monkey_king"
	or hero == "npc_dota_hero_ursa" or hero == "npc_dota_hero_lycan" or hero == "npc_dota_hero_gyrocopter" or hero == "npc_dota_hero_zuus" or hero == "npc_dota_hero_lina" or hero == "npc_dota_hero_phantom_assassin" or hero == "npc_dota_hero_dragon_knight" 
	or hero == "npc_dota_hero_viper" or hero == "npc_dota_hero_necrolyte" or hero == "npc_dota_hero_queenofpain" or hero == "npc_dota_hero_razor"  
	or hero == "npc_dota_hero_leshrac" or hero == "npc_dota_hero_nevermore" or hero == "npc_dota_hero_huskar" or hero == "npc_dota_hero_tiny" 
	or hero == "npc_dota_hero_bloodseeker" or hero == "npc_dota_hero_pugna" or hero == "npc_dota_hero_death_prophet" or hero == "npc_dota_hero_alchemist"
	or hero == "npc_dota_hero_arc_warden" or hero == "npc_dota_hero_sniper" or hero == "npc_dota_hero_medusa"  or hero == "npc_dota_hero_kunkka" or hero == "npc_dota_hero_tidehunter" or hero == "npc_dota_hero_nyx_assassin" or hero == "npc_dota_hero_magnataur" or hero == "npc_dota_hero_legion_commander"
           or hero == "npc_dota_hero_dark_seer" or hero == "npc_dota_hero_axe" or hero == "npc_dota_hero_batrider" or hero == "npc_dota_hero_centaur"
           or hero == "npc_dota_hero_doom_bringer" or hero == "npc_dota_hero_slardar" or hero == "npc_dota_hero_bristleback" or hero == "npc_dota_hero_windrunner"
           or hero == "npc_dota_hero_abyssal_underlord" or hero == "npc_dota_hero_beastmaster" or hero == "npc_dota_hero_broodmother"
           or hero == "npc_dota_hero_brewmaster" or hero == "npc_dota_hero_abaddon" or hero == "npc_dota_hero_enchantress" or hero == "npc_dota_hero_mirana"
           or hero == "npc_dota_hero_obsidian_destroyer" or hero == "npc_dota_hero_terrorblade" or hero == "npc_dota_hero_templar_assassin" or hero == "npc_dota_hero_weaver"
           or hero == "npc_dota_hero_phantom_lancer" or hero == "npc_dota_hero_troll_warlord" or hero == "npc_dota_hero_furion" or hero == "npc_dota_hero_shredder"
end

function X.CanBeOfflaner(hero)
	if X["hero_roles"][hero] == nil then return false end;
	return hero == "npc_dota_hero_tidehunter"  or hero == "npc_dota_hero_magnataur" or hero == "npc_dota_hero_legion_commander"
           or hero == "npc_dota_hero_dark_seer" or hero == "npc_dota_hero_axe" or hero == "npc_dota_hero_batrider" or hero == "npc_dota_hero_centaur"
           or hero == "npc_dota_hero_doom_bringer" or hero == "npc_dota_hero_slardar" or hero == "npc_dota_hero_bristleback" or hero == "npc_dota_hero_windrunner"
           or hero == "npc_dota_hero_abyssal_underlord" or hero == "npc_dota_hero_beastmaster" or hero == "npc_dota_hero_broodmother"
           or hero == "npc_dota_hero_brewmaster"  or hero == "npc_dota_hero_enchantress" or hero == "npc_dota_hero_mirana" 
           or hero == "npc_dota_hero_weaver" or hero == "npc_dota_hero_furion" or hero == "npc_dota_hero_shredder"
		   --[[or (  X["hero_roles"][hero]["initiator"] > 0 and
		         X["hero_roles"][hero]["disabler"] > 0 and
		         X["hero_roles"][hero]["durable"] > 0 and
		         X["hero_roles"][hero]["support"] == 0 )]]
end

function X.CanBeMidlaner(hero)
	if X["hero_roles"][hero] == nil then return false end;
	return hero == "npc_dota_hero_zuus" or hero == "npc_dota_hero_lina" or hero == "npc_dota_hero_phantom_assassin" or hero == "npc_dota_hero_dragon_knight" 
	or hero == "npc_dota_hero_viper" or hero == "npc_dota_hero_necrolyte" or hero == "npc_dota_hero_queenofpain" or hero == "npc_dota_hero_razor"  
	or hero == "npc_dota_hero_leshrac" or hero == "npc_dota_hero_nevermore" or hero == "npc_dota_hero_huskar" or hero == "npc_dota_hero_tiny" 
	or hero == "npc_dota_hero_bloodseeker" or hero == "npc_dota_hero_pugna" or hero == "npc_dota_hero_death_prophet" or hero == "npc_dota_hero_alchemist"
	or hero == "npc_dota_hero_arc_warden" or hero == "npc_dota_hero_sniper" or hero == "npc_dota_hero_medusa"  or hero == "npc_dota_hero_kunkka"  
	or hero == "npc_dota_hero_obsidian_destroyer" or hero == "npc_dota_hero_templar_assassin" or hero == "npc_dota_hero_invoker"
		   --[[or ( X["hero_roles"][hero]["carry"] > 0 and
		      ( 
		        X["hero_roles"][hero]["nuker"] > 0 or
			    X["hero_roles"][hero]["pusher"] > 0 
			   ) 
			)]]
end

function X.CanBeSafeLaneCarry(hero)
	if X["hero_roles"][hero] == nil or hero == "npc_dota_hero_obsidian_destroyer" or hero == "npc_dota_hero_storm_spirit" then return false end;
	return hero == "npc_dota_hero_juggernaut" or hero == "npc_dota_hero_chaos_knight" or hero == "npc_dota_hero_spectre" or hero == "npc_dota_hero_skeleton_king"
	or hero == "npc_dota_hero_slark" or hero == "npc_dota_hero_clinkz" or hero == "npc_dota_hero_sven" or hero == "npc_dota_hero_drow_ranger" 
	or hero == "npc_dota_hero_faceless_void" or hero == "npc_dota_hero_life_stealer" or hero == "npc_dota_hero_luna" or hero == "npc_dota_hero_monkey_king"
	or hero == "npc_dota_hero_ursa" or hero == "npc_dota_hero_lycan" or hero == "npc_dota_hero_gyrocopter" or hero == "npc_dota_hero_terrorblade"
	or hero == "npc_dota_hero_phantom_lancer" or hero == "npc_dota_hero_troll_warlord"
	--[[or (X["hero_roles"][hero]["carry"] > 1 and
		   ( 
			 ( X["hero_roles"][hero]["nuker"] < 3 and X["hero_roles"][hero]["pusher"] < 3 ) or
			 ( X["hero_roles"][hero]["escape"] > 0 and X["hero_roles"][hero]["nuker"] < 2 ) or
			 X["hero_roles"][hero]["nuker"] < 2 or	
			 X["hero_roles"][hero]["jungler"] == 1 
			) 
		   )]]
end

function X.CanBeSupport(hero)
	if X["hero_roles"][hero] == nil then return false end;
	return hero == "npc_dota_hero_skywrath_mage" 
	or hero == "npc_dota_hero_shadow_shaman"
	or hero == "npc_dota_hero_venomancer"
	or hero == "npc_dota_hero_slardar"
	or hero == "npc_dota_hero_undying"
	or hero == "npc_dota_hero_night_stalker"
	or hero == "npc_dota_hero_silencer"
	or hero == "npc_dota_hero_abaddon"
	--or hero == "npc_dota_hero_spirit_breaker",
	or hero == "npc_dota_hero_riki"
	or hero == "npc_dota_hero_earthshaker"
	or hero == "npc_dota_hero_omniknight"
	or hero == "npc_dota_hero_bounty_hunter"
	--or hero == "npc_dota_hero_elder_titan"
	or hero == "npc_dota_hero_keeper_of_the_light"
	or hero == "npc_dota_hero_chen"
	or hero == "npc_dota_hero_pudge"
	or hero == "npc_dota_hero_sand_king"
	or hero == "npc_dota_hero_ogre_magi"
	or hero == "npc_dota_hero_crystal_maiden"
	or hero == "npc_dota_hero_lion"
	or hero == "npc_dota_hero_treant"
	or hero == "npc_dota_hero_vengefulspirit"
	or hero == "npc_dota_hero_jakiro"
	or hero == "npc_dota_hero_dazzle"
	or hero == "npc_dota_hero_lich"
	or hero == "npc_dota_hero_oracle"
	or hero == "npc_dota_hero_winter_wyvern"
	or hero == "npc_dota_hero_warlock"
	or hero == "npc_dota_hero_bane"
	or hero == "npc_dota_hero_ancient_apparition"
	or hero == "npc_dota_hero_disruptor"
	or hero == "npc_dota_hero_earth_spirit"
	or hero == "npc_dota_hero_naga_siren"
	or hero == "npc_dota_hero_witch_doctor"
	or hero == "npc_dota_hero_shadow_demon"
	or hero == "npc_dota_hero_nyx_assassin"
	or hero == "npc_dota_hero_tusk"
end

function X.GetCurrentSuitableRole(bot, hero)

	local lane = bot:GetAssignedLane();
	if X.CanBeSupport(hero) and lane ~= LANE_MID then
		return "support";
	elseif X.CanBeMidlaner(hero) and lane == LANE_MID then
		return "midlaner";
	elseif X.CanBeSafeLaneCarry(hero) and ((GetTeam() == TEAM_RADIANT and lane == LANE_BOT) or (GetTeam() == TEAM_DIRE and lane == LANE_TOP) ) then
		return "carry";
	elseif X.CanBeOfflaner(hero) and ((GetTeam() == TEAM_RADIANT and lane == LANE_TOP) or (GetTeam() == TEAM_DIRE and lane == LANE_BOT) ) then
		return "offlaner";
	--elseif hero == "npc_dota_hero_wisp" then
		--return "support";
	--elseif hero == "npc_dota_hero_elder_titan" then
		--return "offlaner";
	else
		return "unknown";
	end
end

function X.CountValue(hero, role)
	local highest = 0;
	local TeamMember = GetTeamPlayers(GetTeam())
	for i = 1, #TeamMember
	do
		
	end
	return highest;
end

return X