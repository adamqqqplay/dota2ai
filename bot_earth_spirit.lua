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