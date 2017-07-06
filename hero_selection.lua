----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
hero_pool={"npc_dota_hero_abaddon",
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
		"npc_dota_hero_abyssal_underlord",
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
		
		 "npc_dota_hero_lina",
		-- "npc_dota_hero_abaddon",
		-- "npc_dota_hero_huskar",
		-- "npc_dota_hero_phantom_assassin",
		-- "npc_dota_hero_crystal_maiden",
		-- "npc_dota_hero_shadow_shaman",
		
		-- "npc_dota_hero_ember_spirit",
		-- "npc_dota_hero_centaur",
		-- "npc_dota_hero_venomancer",
		 "npc_dota_hero_doom_bringer",
		-- "npc_dota_hero_slardar",
		
		-- "npc_dota_hero_silencer",
		-- "npc_dota_hero_skeleton_king",
		--"npc_dota_hero_lion",
		-- "npc_dota_hero_legion_commander",
		-- "npc_dota_hero_ursa",
		
		 "npc_dota_hero_luna",
		 "npc_dota_hero_necrolyte",
		-- "npc_dota_hero_undying",
		-- "npc_dota_hero_treant",
		-- "npc_dota_hero_tidehunter",
		
		-- "npc_dota_hero_slark",
		 "npc_dota_hero_riki",
		 "npc_dota_hero_spirit_breaker",
		 "npc_dota_hero_vengefulspirit",
		-- "npc_dota_hero_clinkz",
		

		 "npc_dota_hero_jakiro",
		-- "npc_dota_hero_leshrac",
		--	"npc_dota_hero_queenofpain",
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
		
		-- "npc_dota_hero_warlock",
        -- "npc_dota_hero_windrunner",
        -- "npc_dota_hero_witch_doctor",
		-- "npc_dota_hero_tiny",
		-- "npc_dota_hero_bounty_hunter",
		
		-- "npc_dota_hero_sven",
		-- "npc_dota_hero_pudge",
		-- "npc_dota_hero_omniknight",
		-- "npc_dota_hero_kunkka",
		-- "npc_dota_hero_death_prophet",
		
		--	"npc_dota_hero_sven",
			
		--	"npc_dota_hero_winter_wyvern",
		--	"npc_dota_hero_pugna",
		--	"npc_dota_hero_spectre",
		--	"npc_dota_hero_antimage",
		--	"npc_dota_hero_faceless_void",
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
	"npc_dota_hero_antimage",
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
	"npc_dota_hero_sand_king",
	"npc_dota_hero_bloodseeker",
	"npc_dota_hero_bristleback",
	"npc_dota_hero_faceless_void",
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
}
hero_pool_new={hero_pool_2,hero_pool_1,hero_pool_3,hero_pool_5,hero_pool_4}
----------------------------------------------------------------------------------------------------
local debug_mode=false

function Think()
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

