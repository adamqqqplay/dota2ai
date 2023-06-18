local bot = GetBot();

local RB = Vector(-7200, -6666)
local DB = Vector(7137, 6548)

local CastDMDesire = 0
local CastCYDesire = 0
local CastWWDesire = 0
local CastHBDesire = 0
local AttackDesire = 0
local MoveDesire = 0
local RetreatDesire = 0
local castAPDesire = 0
local castAPTarget
local castAPLocation
local abilityCY
local abilityDM
local abilityHB
local abilityWW
local abilityAP

function MinionThink(hMinionUnit)

	if not hMinionUnit:IsNull() and hMinionUnit ~= nil then

		if (hMinionUnit:IsUsingAbility()) then return end

		if string.find(hMinionUnit:GetUnitName(), "npc_dota_brewmaster_storm") then

			abilityDM = hMinionUnit:GetAbilityByName("brewmaster_storm_dispel_magic");
			abilityCY = hMinionUnit:GetAbilityByName("brewmaster_storm_cyclone");
			abilityWW = hMinionUnit:GetAbilityByName("brewmaster_storm_wind_walk");
			CastDMDesire, DMLocation = ConsiderDM(hMinionUnit);
			CastCYDesire, CYTarget = ConsiderCY(hMinionUnit);
			CastWWDesire = ConsiderWW(hMinionUnit);

			if (CastDMDesire > 0)
			then
				hMinionUnit:Action_UseAbilityOnLocation(abilityDM, DMLocation);
				return;
			end

			if (CastCYDesire > 0)
			then
				hMinionUnit:Action_UseAbilityOnEntity(abilityCY, CYTarget);
				return;
			end

			if (CastWWDesire > 0)
			then
				hMinionUnit:Action_UseAbility(abilityWW);
				return;
			end

		end

		if string.find(hMinionUnit:GetUnitName(), "npc_dota_brewmaster_earth") then

			abilityHB = hMinionUnit:GetAbilityByName("brewmaster_earth_hurl_boulder");
			CastHBDesire, HBTarget = ConsiderHB(hMinionUnit);
			RetreatDesire, RetreatLocation = ConsiderRetreat(hMinionUnit);

			-- Earth spirit will retreat alone
			if (RetreatDesire > 0)
			then
				hMinionUnit:Action_MoveToLocation(RetreatLocation);
				return;
			end
			if (CastHBDesire > 0)
			then
				hMinionUnit:Action_UseAbilityOnEntity(abilityHB, HBTarget);
				return;
			end

		end

		--if string.find(hMinionUnit:GetUnitName(), "npc_dota_brewmaster_fire") then
			-- Fire spirit has only passives
		--end

		if string.find(hMinionUnit:GetUnitName(), "npc_dota_brewmaster_void") then
			abilityAP = hMinionUnit:GetAbilityByName("brewmaster_void_astral_pull")
			castAPDesire, castAPTarget = ConsiderAstralPull(hMinionUnit)

			if (castAPDesire > 0) then
				-- No way to use an ability that takes an Entity and a Vector
				--hMinionUnit:Action_UseAbilityOnEntity(abilityAP, castAPTarget)
			end
		end

		-- Common behaviors (including illusions and other minions)
		AttackDesire, AttackTarget = ConsiderAttacking(hMinionUnit);
		MoveDesire, Location = ConsiderMove(hMinionUnit);

		if hMinionUnit:IsIllusion() then
			Location = Location + RandomVector(100)
		end

		if (AttackDesire > 0)
		then
			hMinionUnit:Action_AttackUnit(AttackTarget, true);
			return
		end
		if (MoveDesire > 0)
		then
			hMinionUnit:Action_MoveToLocation(Location);
			return
		end

	end

end

function ConsiderAstralPull(hMinionUnit)
	-- Currently only finds an enemy hero; will also need to return a direction to pull

	local tableNearbyEnemyHeroes = hMinionUnit:GetNearbyHeroes(600, true, BOT_MODE_NONE);
	if #tableNearbyEnemyHeroes > 0 then
		return BOT_ACTION_DESIRE_HIGH, tableNearbyEnemyHeroes[1]
	end

	return 0, nil
end


function CanCastCYOnTarget(npcTarget)
	return npcTarget:CanBeSeen() and not npcTarget:IsMagicImmune() and not npcTarget:IsInvulnerable();
end

function IsDisabled(npcTarget)
	if npcTarget:IsRooted() or npcTarget:IsStunned() or npcTarget:IsHexed() or npcTarget:IsNightmared() or
		npcTarget:IsSilenced() then
		return true;
	end
	return false;
end

function GetFountain(enemy)
	if enemy then
		if GetTeam() == TEAM_DIRE then
			return RB;
		else
			return DB;
		end
	else
		if GetTeam() == TEAM_DIRE then
			return DB;
		else
			return RB;
		end
	end
end

function ConsiderAttacking(hMinionUnit)
	local radius = 1600;
	local target = nil;

	if IsDisabled(hMinionUnit) then
		return BOT_ACTION_DESIRE_NONE, nil;
	end

	local units = hMinionUnit:GetNearbyHeroes(radius, true, BOT_MODE_NONE);

	if units == nil or #units == 0 then
		units = hMinionUnit:GetNearbyLaneCreeps(radius, true);
	end
	if units == nil or #units == 0 then
		units = hMinionUnit:GetNearbyTowers(radius, true);
	end
	if units == nil or #units == 0 then
		units = hMinionUnit:GetNearbyBarracks(radius, true);
	end

	if units ~= nil and #units > 0 then
		target = GetWeakestUnit(units);
		if target ~= nil then
			return BOT_ACTION_DESIRE_HIGH, target;
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil;
end

function GetWeakestUnit(tableNearbyEntity)
	local target = nil;
	local minHP = 100000;
	for _, unit in pairs(tableNearbyEntity) do
		local HP = unit:GetHealth();
		if not unit:IsInvulnerable() and HP < minHP then
			target = unit;
			minHP = HP;
		end
	end
	return target;
end

function ConsiderMove(hMinionUnit)
	local radius = 1000;
	local NearbyEnemyHeroes = hMinionUnit:GetNearbyHeroes(radius, true, BOT_MODE_NONE);
	local NearbyEnemyCreeps = hMinionUnit:GetNearbyLaneCreeps(radius, true);
	local NearbyEnemyTowers = hMinionUnit:GetNearbyTowers(radius, true);
	local NearbyEnemyBarracks = hMinionUnit:GetNearbyBarracks(radius, true);

	if #NearbyEnemyHeroes == 0 and #NearbyEnemyCreeps == 0 and #NearbyEnemyTowers == 0 and #NearbyEnemyBarracks == 0 then
		local ancient = GetAncient(GetOpposingTeam());
		if ancient ~= nil then
			return BOT_ACTION_DESIRE_HIGH, ancient:GetLocation();
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;
end

function ConsiderRetreat(hMinionUnit)
	local tableNearbyAllyHeroes = hMinionUnit:GetNearbyHeroes(1200, false, BOT_MODE_NONE);
	local tableNearbyEnemyHeroes = hMinionUnit:GetNearbyHeroes(1200, true, BOT_MODE_NONE);
	if #tableNearbyAllyHeroes == 0 and #tableNearbyEnemyHeroes >= 2 then
		local location = GetFountain(false)
		return BOT_ACTION_DESIRE_LOW, location;
	end
	return BOT_ACTION_DESIRE_NONE, 0;
end

function ConsiderDM(hMinionUnit)

	if abilityDM == nil or not abilityDM:IsFullyCastable() or abilityDM:IsHidden() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end

	local nCastRange = abilityDM:GetCastRange();
	local nRadius = abilityDM:GetSpecialValueInt("radius");

	local Allies = hMinionUnit:GetNearbyHeroes(nCastRange + nRadius, false, BOT_MODE_NONE);
	for _, Ally in pairs(Allies) do
		if (IsDisabled(Ally))
		then
			return BOT_ACTION_DESIRE_LOW, Ally:GetLocation();
		end
	end

	local tableNearbyEnemyHeroes = hMinionUnit:GetNearbyHeroes(1000, true, BOT_MODE_NONE);
	if #tableNearbyEnemyHeroes == 1 and tableNearbyEnemyHeroes[1]:HasModifier("modifier_brewmaster_storm_cyclone") then
		return BOT_ACTION_DESIRE_LOW, tableNearbyEnemyHeroes[1]:GetLocation()
	end

	return BOT_ACTION_DESIRE_NONE, 0;

end

function ConsiderCY(hMinionUnit)

	if abilityCY == nil or not abilityCY:IsFullyCastable() or abilityCY:IsHidden() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end

	local nCastRange = abilityCY:GetCastRange();

	-- If we're in a teamfight, use it on the scariest enemy
	local tableNearbyAttackingAlliedHeroes = hMinionUnit:GetNearbyHeroes(1000, false, BOT_MODE_ATTACK);
	if (#tableNearbyAttackingAlliedHeroes >= 1)
	then

		local npcMostDangerousEnemy = nil;
		local nMostDangerousDamage = 0;

		local EnemyHeroes = hMinionUnit:GetNearbyHeroes(1000, true, BOT_MODE_NONE);
		for _, npcEnemy in pairs(EnemyHeroes) do
			if (CanCastCYOnTarget(npcEnemy) and not IsDisabled(npcEnemy))
			then
				local nDamage = npcEnemy:GetEstimatedDamageToTarget(false, hMinionUnit, 3.0, DAMAGE_TYPE_ALL);
				if (nDamage > nMostDangerousDamage)
				then
					nMostDangerousDamage = nDamage;
					npcMostDangerousEnemy = npcEnemy;
				end
			end
		end

		if (npcMostDangerousEnemy ~= nil)
		then
			return BOT_ACTION_DESIRE_LOW, npcMostDangerousEnemy;
		end
	end

	local tableNearbyEnemyHeroes = hMinionUnit:GetNearbyHeroes(2 * nCastRange, true, BOT_MODE_NONE);

	for _, npcEnemy in pairs(tableNearbyEnemyHeroes) do
		if (npcEnemy:IsChanneling())
		then
			return BOT_ACTION_DESIRE_LOW, npcEnemy;
		end
	end

	for _, npcEnemy in pairs(tableNearbyEnemyHeroes) do
		if (CanCastCYOnTarget(npcEnemy) and not IsDisabled(npcEnemy) and npcEnemy:GetActiveMode() == BOT_MODE_RETREAT)
		then
			return BOT_ACTION_DESIRE_LOW, npcEnemy;
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;

end


function ConsiderWW(hMinionUnit)

	if abilityWW == nil or not abilityWW:IsFullyCastable() or abilityWW:IsHidden() then
		return BOT_ACTION_DESIRE_NONE;
	end

	local tableNearbyEnemyCreeps = hMinionUnit:GetNearbyLaneCreeps(1300, true);
	local tableNearbyEnemyHeroes = hMinionUnit:GetNearbyHeroes(700, true, BOT_MODE_NONE);

	if (#tableNearbyEnemyHeroes == 0 and #tableNearbyEnemyCreeps == 0) then
		return BOT_ACTION_DESIRE_HIGH;
	end

	return BOT_ACTION_DESIRE_NONE;

end

function ConsiderHB(hMinionUnit)

	if abilityHB == nil or not abilityHB:IsFullyCastable() or abilityHB:IsHidden() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end

	local nCastRange = abilityHB:GetCastRange();

	local tableNearbyEnemyHeroes = hMinionUnit:GetNearbyHeroes(1200, true, BOT_MODE_NONE);

	local target = GetWeakestUnit(tableNearbyEnemyHeroes);

	if target ~= nil then
		return BOT_ACTION_DESIRE_HIGH, target;
	end

	return BOT_ACTION_DESIRE_NONE, 0;

end

