local bot = GetBot();
local trueMK = nil;
for i, id in pairs(GetTeamPlayers(GetTeam())) do
	if IsPlayerBot(id) and GetSelectedHeroName(id) == 'npc_dota_hero_monkey_king' then
		local member = GetTeamMember(i);
		if member ~= nil then
			trueMK = member;
		end
	end
end
--print(tostring(trueMK))
--print(tostring(GetBot())..tostring(GetBot():GetLocation())..tostring(GetBot():IsInvulnerable())..tostring(trueMK==GetBot()))
if trueMK == nil or bot == trueMK then
	print("Bot MK "..tostring(bot).." is true MK")
	return;
end
print("Bot MK "..tostring(bot).." isn't true MK")

function  MinionThink(  hMinionUnit ) 

end

function Think()
	
end