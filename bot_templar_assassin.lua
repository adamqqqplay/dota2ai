local AbilityExtensions = require(GetScriptDirectory().."/util/AbilityAbstraction")

local trapTable = GetBot().trapTable
local function GetCastTime(trap)
	if trapTable ~= nil then
		return trapTable[AbilityExtensions:ToStringVector(trap:GetLocation())]
	end
end

function MinionThink(  hMinionUnit )
	local npcBot = GetBot()
	if not hMinionUnit:IsNull() and hMinionUnit ~= nil then 	
		if hMinionUnit:GetUnitName() ==  "npc_dota_templar_assassin_psionic_trap" and hMinionUnit:GetHealth() > 0 
		then
			local abilitySTP = hMinionUnit:GetAbilityByName( "templar_assassin_self_trap" );
			local abilityTP = npcBot:GetAbilityByName( "templar_assassin_trap" );
			local nRadius = abilitySTP:GetSpecialValueInt("trap_radius");
			local nRange = npcBot:GetAttackRange();
			local Enemies = hMinionUnit:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE);
			local Allies = hMinionUnit:GetNearbyHeroes(2*nRadius, false, BOT_MODE_NONE);
			local distance = GetUnitToUnitDistance(npcBot, hMinionUnit);
			local attackedTargets = AbilityExtensions:Filter(Enemies, function(t) return t:GetAttackTarget() ~= nil end)
			attackedTargets = AbilityExtensions:Map(Enemies, function(t) return t:GetAttackTarget() end)
			if Enemies ~= nil and #Enemies >=1 and ( distance < 800 or Allies ~= nil ) and abilityTP:IsFullyCastable() then
				local castTime = GetCastTime(hMinionUnit) or DotaTime()
				if DotaTime() - castTime < 1 then
					if AbilityExtensions:IsRetreating(npcBot) or AbilityExtensions:Contains(attackedTargets, hMinionUnit) then
						npcBot:Action_UseAbility( abilityTP )
					end
				else
					npcBot:Action_UseAbility( abilityTP )
				end
			end
		end
	end
end
