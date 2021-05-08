local castSCDesire = 0;
local ReturnDesire = 0;
local MoveDesire = 0;
local ReturnTime = 0;
local npcBot = GetBot();
local abilityW = "";
local abilitySC = "";
local radius = 350;
local RB = Vector(-7200,-6666)
local DB = Vector(7137,6548)
local castReturn = false;

print(GetBot():GetUnitName())

function  MinionThink(  hMinionUnit ) 
	
	if npcBot:HasModifier('modifier_elder_titan_ancestral_spirit_buff') or not npcBot:IsAlive() then
		castReturn = false;
	end
	
	if hMinionUnit:GetUnitName() == "npc_dota_elder_titan_ancestral_spirit" and npcBot:IsAlive() then
		
		if abilitySC == "" then abilitySC = npcBot:GetAbilityByName( "elder_titan_echo_stomp" ); end
		
		if abilityW == "" then abilityW = npcBot:GetAbilityByName('elder_titan_ancestral_spirit'); end
		
		if not abilityW:IsHidden() then return; end
		
		if abilitySC:IsInAbilityPhase() or npcBot:IsChanneling() then npcBot:Action_ClearActions(false) return end
		
		if ( npcBot:IsUsingAbility() or npcBot:IsCastingAbility() ) then return end
	
		abilityRT = npcBot:GetAbilityByName( "elder_titan_return_spirit" );
		MoveDesire, Location = ConsiderMove(hMinionUnit); 
		ReturnDesire = Return(hMinionUnit); 
		castSCDesire = ConsiderSlithereenCrush(hMinionUnit);
		
		if ( castSCDesire > 0 ) 
		then
			--print("Stomp")
			npcBot:Action_UseAbility( abilitySC );
			return;
		end
		
		if ( ReturnDesire > 0 and castReturn == false  ) 
		then
			--print("Return")
			castReturn = true;
			npcBot:Action_UseAbility( abilityRT );
			return;
		end
		
		if ( MoveDesire > 0  )
		then
			--print("Move")
			hMinionUnit:Action_MoveToLocation( Location );
			return
		end
		
	end
	
end

function CanCastSlithereenCrushOnTarget( npcTarget )
	return npcTarget:CanBeSeen() and not npcTarget:IsMagicImmune() and not npcTarget:IsInvulnerable();
end

function Return(hMinionUnit)

	if castSCDesire > 0
	then
		return BOT_ACTION_DESIRE_NONE;
	end
	
	if abilityRT:IsFullyCastable() and not abilityRT:IsHidden() and abilitySC:GetCooldownTimeRemaining() > 4 then
		return BOT_ACTION_DESIRE_MODERATE;
	end
	
	return BOT_ACTION_DESIRE_NONE;
	
end

function ConsiderSlithereenCrush(hMinionUnit)

	-- Make sure it's castable
	if ( not abilitySC:IsFullyCastable() ) then 
		return BOT_ACTION_DESIRE_NONE;
	end


	-- Get some of its values
	local nRadius = abilitySC:GetSpecialValueInt( "radius" );
	local nCastRange = 0;
	local nDamage = abilitySC:GetSpecialValueInt( "stomp_damage" );

	--------------------------------------
	-- Mode based usage
	--------------------------------------
	local tableNearbyEnemyHeroes = hMinionUnit:GetNearbyHeroes( nRadius, true, BOT_MODE_NONE );
	for _,npcEnemy in pairs( tableNearbyEnemyHeroes )
	do
		if ( npcEnemy:IsChanneling() ) 
		then
			return BOT_ACTION_DESIRE_LOW;
		end
	end
	
	
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH ) 
	then
		local tableNearbyEnemyHeroes = hMinionUnit:GetNearbyHeroes( nCastRange, true, BOT_MODE_NONE );
		for _,npcEnemy in pairs( tableNearbyEnemyHeroes )
		do
			if ( npcBot:WasRecentlyDamagedByHero( npcEnemy, 2.0 ) ) 
			then
				if ( CanCastSlithereenCrushOnTarget( npcEnemy ) ) 
				then
					return BOT_ACTION_DESIRE_MODERATE;
				end
			end
		end
	end

	if ( npcBot:GetActiveMode() == BOT_MODE_FARM or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT ) 
	then
		local locationAoE = hMinionUnit:FindAoELocation( true, false, hMinionUnit:GetLocation(), 0, nRadius, 0, 1500 );
		if ( locationAoE.count >= 3 and GetUnitToLocationDistance( hMinionUnit, locationAoE.targetloc ) < nRadius - 200 and npcBot:GetMana()/npcBot:GetMaxMana() > 0.6 ) then
			return BOT_ACTION_DESIRE_LOW;
		end
	end
	
	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_ATTACK or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY ) 
	then
		local npcTarget = npcBot:GetTarget();

		if ( npcTarget ~= nil and npcTarget:IsHero() ) 
		then
			if ( CanCastSlithereenCrushOnTarget( npcTarget ) and GetUnitToUnitDistance( hMinionUnit, npcTarget ) < nRadius - 200 )
			then
				return BOT_ACTION_DESIRE_MODERATE;
			end
		end
	end


	return BOT_ACTION_DESIRE_NONE;

end

function ConsiderMove(hMinionUnit)
	
	if ( castSCDesire > 0 or ReturnDesire > 0 or castReturn == true ) 
	then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local NearbyEnemyHeroes = hMinionUnit:GetNearbyHeroes( radius, true, BOT_MODE_NONE );
	
	if NearbyEnemyHeroes[1] == nil then
		local location = RB;
		if GetTeam( ) == TEAM_RADIANT then
			location = DB;
		end
		return BOT_ACTION_DESIRE_MODERATE, location;
	else
		return BOT_ACTION_DESIRE_MODERATE, NearbyEnemyHeroes[1]:GetLocation();
	end
	
	return BOT_ACTION_DESIRE_NONE, 0;
end