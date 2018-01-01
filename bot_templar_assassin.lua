local npcBot = nil;

function  MinionThink(  hMinionUnit ) 
	
	if npcBot == nil then npcBot = GetBot(); end
	
if not hMinionUnit:IsNull() and hMinionUnit ~= nil then 	
	if hMinionUnit:GetUnitName() ==  "npc_dota_templar_assassin_psionic_trap" and hMinionUnit ~= nil and hMinionUnit:GetHealth() > 0 
	then
		local abilitySTP = hMinionUnit:GetAbilityByName( "templar_assassin_self_trap" );
		local abilityTP = npcBot:GetAbilityByName( "templar_assassin_trap" );
		local nRadius = abilitySTP:GetSpecialValueInt("trap_radius");
		local nRange = npcBot:GetAttackRange();
		local Enemies = hMinionUnit:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE);
		local Allies = hMinionUnit:GetNearbyHeroes(2*nRadius, false, BOT_MODE_NONE);
		local distance = GetUnitToUnitDistance(npcBot, hMinionUnit);
		if Enemies ~= nil and #Enemies >=1 and ( distance < 800 or Allies ~= nil ) and abilityTP:IsFullyCastable() then
			npcBot:Action_UseAbility( abilityTP );
			return;
		end
	end
end
end
