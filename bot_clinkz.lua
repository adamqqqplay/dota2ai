local bot = GetBot();
local AttackDesire = 0;
local MoveDesire = 0;


function  MinionThink(  hMinionUnit ) 

	if hMinionUnit:IsIllusion() then
		local target = bot:GetAttackTarget()
		AttackDesire, Target = ConsiderAttack(hMinionUnit, target)
		MoveDesire, Location = ConsiderMove(hMinionUnit, target)
		
		if AttackDesire > 0 then
			hMinionUnit:Action_AttackUnit(Target, true)
			return
		end
		
		if MoveDesire > 0 then
			hMinionUnit:Action_MoveToLocation(Location)
			return
		end
	elseif hMinionUnit:GetUnitName() == "npc_dota_clinkz_skeleton_archer" then
		-- local attackRange = hMinionUnit:GetAttackRange();
		-- local enemies = hMinionUnit:GetNearbyHeroes(attackRange, true, BOT_MODE_NONE);
		-- local minHP = 100000;
		-- local target = nil;
		-- for i = 1, #enemies do
			-- if enemies[i] ~= nil and enemies[i]:GetHealth() < minHP then
				-- minHP = enemies[i]:GetHealth();
				-- target = enemies[i]
			-- end
		-- end
		-- if target ~= nil then
			-- hMinionUnit:Action_AttackUnit(target, true);
			-- return
		-- end
		return;
	end
		
end

function ConsiderAttack(hMinionUnit, target)

	if target ~= nil and target:IsAlive() and not target:IsInvulnerable() then
		return BOT_ACTION_DESIRE_HIGH, target;
	end
	
	return BOT_ACTION_DESIRE_NONE, nil;
	
end

function ConsiderMove(hMinionUnit, target)
	
	if AttackDesire > 0 then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	if target == nil then
		return BOT_ACTION_DESIRE_HIGH, bot:GetLocation();
	end
	
	return BOT_ACTION_DESIRE_NONE, 0;
	
end