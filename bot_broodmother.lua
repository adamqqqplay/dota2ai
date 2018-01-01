local npcBot = GetBot();
local MoveDesire = 0;
local AttackDesire = 0;
local npcBotAR = 200;
local ProxRange = 1300;

function  MinionThink(  hMinionUnit ) 	
	if not hMinionUnit:IsNull() and hMinionUnit ~= nil and ( hMinionUnit:GetUnitName() == 'npc_dota_broodmother_spiderling' or hMinionUnit:IsIllusion() ) then 
		AttackDesire, AttackTarget = ConsiderAttacking(hMinionUnit); 
		MoveDesire, Location = ConsiderMove(hMinionUnit); 
		
		if (AttackDesire > 0)
		then
			hMinionUnit:Action_AttackUnit( AttackTarget, true );
			return
		end
		if (MoveDesire > 0)
		then
			hMinionUnit:Action_MoveToLocation( Location );
			return
		end
	end
end

function CanBeAttacked( npcTarget )
	return npcTarget:CanBeSeen() and not npcTarget:IsInvulnerable();
end

function GetBase()
	local RB = Vector(-7200,-6666)
	local DB = Vector(7137,6548)
	if GetTeam( ) == TEAM_DIRE then
		return DB;
	elseif GetTeam( ) == TEAM_RADIANT then
		return RB;
	end
end

function ConsiderAttacking(hMinionUnit)
	
	local target = npcBot:GetTarget();
	local AR = hMinionUnit:GetAttackRange();
	local AD = hMinionUnit:GetAttackDamage();
	
	if target == nil or target:IsTower() or target:IsBuilding() then
		target = npcBot:GetAttackTarget();
	end
	
	if target ~= nil and GetUnitToUnitDistance(hMinionUnit, npcBot) <= ProxRange then
		return BOT_ACTION_DESIRE_MODERATE, target;
	end
	
	return BOT_ACTION_DESIRE_NONE, 0;
end

function ConsiderMove(hMinionUnit)
	if not npcBot:IsAlive() then
		local loc = GetBase()
		return BOT_ACTION_DESIRE_HIGH, loc;
	end

	local target = npcBot:GetAttackTarget()

	if target == nil or ( target ~= nil and not CanBeAttacked(target) ) or GetUnitToUnitDistance(hMinionUnit, npcBot) > ProxRange then
		return BOT_ACTION_DESIRE_MODERATE, npcBot:GetXUnitsTowardsLocation(GetAncient(GetOpposingTeam()):GetLocation(), 200);
	end
	
	return BOT_ACTION_DESIRE_NONE, 0;
	
end
