--local minion = dofile( GetScriptDirectory().."//util/util/MinionUtility" )
local npcBot = GetBot();
local castRTDesire = 0;
local castSRDesire = 0;
local RetreatDesire = 0;
local MoveDesire = 0;
local AttackDesire = 0;
local npcBotAR = 0;
local ProxRange = 1300;
local bearState = "";

local BearItem = {
	"item_boots",
	"item_orb_of_venom",
	"item_blight_stone"
}
function  MinionThink(  hMinionUnit ) 

if not hMinionUnit:IsNull() and hMinionUnit ~= nil then 
	if string.find(hMinionUnit:GetUnitName(), "npc_dota_lone_druid_bear") then
		
		if hMinionUnit:DistanceFromFountain() == 0 and hMinionUnit:GetHealth() / hMinionUnit:GetMaxHealth() == 1.0 then bearState = "" end
		
		if ( hMinionUnit:IsUsingAbility() or hMinionUnit:IsChanneling() or not hMinionUnit:IsAlive() ) then return end
			
		abilityFG = npcBot:GetAbilityByName( "lone_druid_spirit_bear" );	
		abilityES = npcBot:GetAbilityByName( "lone_druid_savage_roar" );
		abilityRT = hMinionUnit:GetAbilityByName( "lone_druid_spirit_bear_return" );
		abilitySR = hMinionUnit:GetAbilityByName( "lone_druid_savage_roar_bear" );
		
		BearPurchaseItem(hMinionUnit)
		
		castRTDesire = ConsiderReturn(hMinionUnit);
		castSRDesire = ConsiderSavageRoar(hMinionUnit);
		AttackDesire, AttackTarget = ConsiderAttacking(hMinionUnit); 
		MoveDesire, Location = ConsiderMove(hMinionUnit); 
		RetreatDesire, RetreatLocation = ConsiderRetreat(hMinionUnit); 
		
		if hMinionUnit:GetMaxHealth() - hMinionUnit:GetHealth() > 150 and not hMinionUnit:HasModifier('modifier_tango_heal') then
			local tango = hMinionUnit:FindItemSlot('item_tango_single');
			if tango >= 0 and tango <= 5 then
				local item = hMinionUnit:GetItemInSlot(tango);
				if item ~= nil and item:IsFullyCastable() then
					local tree = hMinionUnit:GetNearbyTrees(1200);
					if tree[1] ~= nil then
						--print("use tango"..tostring(tango).." "..item:GetName().." "..tostring(tree[1]))
						hMinionUnit:Action_UseAbilityOnTree(item, tree[1]);
						return
					end
				end
			end
		end
		
		if castRTDesire > 0 then
			hMinionUnit:Action_UseAbility(abilityRT);
			return
		end
		if castSRDesire > 0 then
			hMinionUnit:Action_UseAbility(abilitySR);
			return
		end
		if ( RetreatDesire > 0 ) 
		then
			hMinionUnit:Action_MoveToLocation( RetreatLocation );
			if bearState == "" and RetreatDesire == BOT_ACTION_DESIRE_HIGH then bearState = "retreat"; end
			return;
		end
		if (AttackDesire > 0)
		then
			--print("attack")
			hMinionUnit:Action_AttackUnit( AttackTarget, true );
			return
		end
		if (MoveDesire > 0)
		then
			--print("move")
			hMinionUnit:Action_MoveToLocation( Location );
			return
		end
	elseif hMinionUnit:IsIllusion() then
		if (AttackDesire > 0)
		then
			--print("attack")
			hMinionUnit:Action_AttackUnit( AttackTarget, true );
			return
		end
		if (MoveDesire > 0)
		then
			--print("move")
			hMinionUnit:Action_MoveToLocation( Location );
			return
		end
	end		
end		

end


function BearPurchaseItem(hMinionUnit)
	
	if ( BearItem == nil or #(BearItem) == 0 ) then
		hMinionUnit:SetNextItemPurchaseValue( 0 );
		return;
	end
	local sNextItem = BearItem[1];
	hMinionUnit:SetNextItemPurchaseValue( GetItemCost( sNextItem ) );
	if ( npcBot:GetGold() >= GetItemCost( sNextItem ) and hMinionUnit:DistanceFromFountain() < 100 ) then
		if ( hMinionUnit:ActionImmediate_PurchaseItem( sNextItem ) == PURCHASE_ITEM_SUCCESS ) then
			table.remove( BearItem, 1 );
		end
	end	
end

function CanCastSavageRoarOnTarget( npcTarget )
	return npcTarget:CanBeSeen() and not npcTarget:IsMagicImmune() and not npcTarget:IsInvulnerable();
end

function CanBeAttacked( npcTarget )
	return npcTarget:CanBeSeen() and not npcTarget:IsInvulnerable();
end

function ConsiderReturn(hMinionUnit)

	if bearState == "retreat" or RetreatDesire > 0 or abilityFG:GetLevel() < 2 or  not abilityRT:IsFullyCastable() or abilityRT:IsHidden() then
		return BOT_ACTION_DESIRE_NONE;
	end

	local bearDist = GetUnitToUnitDistance(hMinionUnit, npcBot);
	local pHP = hMinionUnit:GetHealth() / hMinionUnit:GetMaxHealth();
	
	if hMinionUnit:DistanceFromFountain() > 0 and bearDist > ProxRange then
		return BOT_ACTION_DESIRE_MODERATE
	end
	
	if hMinionUnit:DistanceFromFountain() == 0 and pHP == 1.0 and bearDist > ProxRange then
		return BOT_ACTION_DESIRE_MODERATE
	end
	
	return BOT_ACTION_DESIRE_NONE;
	
end

function ConsiderSavageRoar(hMinionUnit)

	if abilityES:GetLevel() < 1 or  not abilitySR:IsFullyCastable() or abilitySR:IsHidden()  then
		return BOT_ACTION_DESIRE_NONE;
	end
	
	-- Get some of its values
	local nRadius = abilitySR:GetSpecialValueInt( "radius" );

	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if ( ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH ) or RetreatDesire > 0 ) 
	then
		local tableNearbyEnemyHeroes = hMinionUnit:GetNearbyHeroes( nRadius, true, BOT_MODE_NONE );
		if ( tableNearbyEnemyHeroes ~= nil and #tableNearbyEnemyHeroes >= 1 ) 
		then
			return BOT_ACTION_DESIRE_MODERATE;
		end
	end

	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_ATTACK or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY 
		 ) 
	then
		local npcTarget = npcBot:GetTarget();
		if ( npcTarget ~= nil and npcTarget:IsHero() ) 
		then
			if ( CanCastSavageRoarOnTarget( npcTarget ) and GetUnitToUnitDistance( npcTarget, hMinionUnit ) < nRadius and 
				( npcTarget:IsChanneling() or npcTarget:IsUsingAbility() ) )
			then
				return BOT_ACTION_DESIRE_MODERATE;
			end
		end
	end
	
	if hMinionUnit:WasRecentlyDamagedByAnyHero( 2.0 ) and hMinionUnit:GetHealth() / hMinionUnit:GetMaxHealth() < 0.45 then
		local tableNearbyEnemyHeroes = hMinionUnit:GetNearbyHeroes( nRadius, true, BOT_MODE_NONE );
		if tableNearbyEnemyHeroes ~= nil and #tableNearbyEnemyHeroes >= 1 then
			return BOT_ACTION_DESIRE_MODERATE;
		end
	end
	
	return BOT_ACTION_DESIRE_NONE;

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

function ConsiderRetreat(hMinionUnit)
	
	if hMinionUnit:DistanceFromFountain() == 0 and hMinionUnit:GetHealth() / hMinionUnit:GetMaxHealth() < 1.0 then
		local loc = GetBase()
		return BOT_ACTION_DESIRE_HIGH, loc;
	end
	
	local mode = npcBot:GetActiveMode();
	
	if not ( mode == BOT_MODE_ATTACK or mode == BOT_MODE_DEFEND_ALLY ) and ( hMinionUnit:WasRecentlyDamagedByAnyHero(2.0) or
	hMinionUnit:WasRecentlyDamagedByTower(2.0)  ) then
		return BOT_ACTION_DESIRE_MODERATE, npcBot:GetXUnitsTowardsLocation(GetAncient(GetTeam()):GetLocation(), 200);
	end
	
	if hMinionUnit:GetHealth() / hMinionUnit:GetMaxHealth() < 0.20 then
		local loc = GetBase()
		return BOT_ACTION_DESIRE_HIGH, loc;
	end
	
	return BOT_ACTION_DESIRE_NONE, 0;
	
end	

function ConsiderAttacking(hMinionUnit)
	
	local target = npcBot:GetTarget();
	local AR = hMinionUnit:GetAttackRange();
	local OAR = npcBot:GetAttackRange();
	local AD = hMinionUnit:GetAttackDamage();
	
	if target == nil or target:IsTower() or target:IsBuilding() then
		target = npcBot:GetAttackTarget();
	end
	
	if target ~= nil and GetUnitToUnitDistance(hMinionUnit, npcBot) <= ProxRange then
		return BOT_ACTION_DESIRE_MODERATE, target;
	end
	
	return BOT_ACTION_DESIRE_NONE, nil;
end

function ConsiderMove(hMinionUnit)
	
	local target = npcBot:GetAttackTarget();
	
	if target == nil or ( target ~= nil and not CanBeAttacked(target) ) or (target ~= nil and GetUnitToUnitDistance(target, npcBot) > ProxRange) then
		return BOT_ACTION_DESIRE_MODERATE, npcBot:GetXUnitsTowardsLocation(GetAncient(GetOpposingTeam()):GetLocation(), 200);
	end
	
	return BOT_ACTION_DESIRE_NONE, 0;
	
end


	