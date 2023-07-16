----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.3 New Structure
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
--------------------------------------
-- General Initialization
--------------------------------------
local utility = require(GetScriptDirectory() .. "/utility")
local ability_item_usage_generic = require(GetScriptDirectory() .. "/ability_item_usage_generic")
local AbilityExtensions = require(GetScriptDirectory() .. "/util/AbilityAbstraction")
local A = require(GetScriptDirectory() .. "/util/MiraDota")

local debugmode = false
local npcBot = GetBot()
if npcBot == nil or npcBot:IsIllusion() then
	return
end

local Talents = {}
local Abilities = {}
local AbilitiesReal = {}
npcBot.ult = {}  -- Track possible ult targets across frames (see GetDelayedUltDesire())
local delayedUltDesire = 0

ability_item_usage_generic.InitAbility(Abilities, AbilitiesReal, Talents)

local damageBuffer = 0.95  -- buffer ult damage for regen during cast time, etc.
local patience = 1.6 -- number of seconds to try killing without ult

local AbilityToLevelUp =
{
	Abilities[1],
	Abilities[3],
	Abilities[1],
	Abilities[2],
	Abilities[2],
	Abilities[6],
	Abilities[1],
	Abilities[1],
	Abilities[2],
	"talent",
	Abilities[2],
	Abilities[6],
	Abilities[3],
	Abilities[3],
	"talent",
	Abilities[3],
	"nil",
	Abilities[6],
	"nil",
	"talent",
	"nil",
	"nil",
	"nil",
	"nil",
	"talent",
}
local TalentTree = {
	function()
		return Talents[1]
	end,
	function()
		return Talents[3]
	end,
	function()
		return Talents[6]
	end,
	function()
		return Talents[8]
	end
}

-- check skill build vs current level
utility.CheckAbilityBuild(AbilityToLevelUp)

function BuybackUsageThink()
	ability_item_usage_generic.BuybackUsageThink();
end

function CourierUsageThink()
	ability_item_usage_generic.CourierUsageThink();
end

function AbilityLevelUpThink()
	ability_item_usage_generic.AbilityLevelUpThink2(AbilityToLevelUp, TalentTree)
end

--------------------------------------
-- Ability Usage Thinking
--------------------------------------
local cast = {}
cast.Desire = {}
cast.Target = {}
cast.Type = {}
local Consider = {}
local CanCast = { utility.NCanCast, utility.NCanCast, utility.NCanCast, utility.UCanCast,
	AbilityExtensions.NormalCanCastFunction,
	function(t)
		return AbilityExtensions:NormalCanCast(t) and AbilityExtensions:MayNotBeIllusion(npcBot, t) and
			not AbilityExtensions:IsHeroLevelUnit(t) and A.Unit.IsNotCreepHero(t)
	end }
local enemyDisabled = utility.enemyDisabled

function GetComboDamage()
	return ability_item_usage_generic.GetComboDamage(AbilitiesReal)
end

function GetComboMana()
	return ability_item_usage_generic.GetComboMana(AbilitiesReal)
end

-- zuus_arc_lightning
Consider[1] = function()

	local ability = AbilitiesReal[1];

	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end

	local CastRange = ability:GetCastRange();
	local Damage = ability:GetSpecialValueInt("arc_damage");


	local allys = npcBot:GetNearbyHeroes(1200, false, BOT_MODE_NONE);
	local enemys = npcBot:GetNearbyHeroes(CastRange + 300, true, BOT_MODE_NONE)
	local WeakestEnemy, HeroHealth = utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyLaneCreeps(CastRange + 300, true)
	local Allcreeps = npcBot:GetNearbyCreeps(CastRange + 300, true)
	local WeakestCreep, CreepHealth = utility.GetWeakestUnit(creeps)

	--try to kill enemy hero
	if (npcBot:GetActiveMode() ~= BOT_MODE_RETREAT)
	then
		if (WeakestEnemy ~= nil)
		then
			if (CanCast[1](WeakestEnemy))
			then
				if (
					HeroHealth <= WeakestEnemy:GetActualIncomingDamage(Damage, DAMAGE_TYPE_MAGICAL) * 3 or
						(
						HeroHealth <= WeakestEnemy:GetActualIncomingDamage(GetComboDamage(), DAMAGE_TYPE_MAGICAL) and
							npcBot:GetMana() > ComboMana))
				then
					return BOT_ACTION_DESIRE_HIGH, WeakestEnemy;
				end
			end
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------

	--teamfightUsing
	if (npcBot:GetActiveMode() == BOT_MODE_ATTACK)
	then
		if (ManaPercentage > 0.4 or npcBot:GetMana() > ComboMana)
		then
			if (#enemys + #creeps > 2)
			then
				if (WeakestCreep ~= nil)
				then
					return BOT_ACTION_DESIRE_HIGH, WeakestCreep;
				end
				if (WeakestEnemy ~= nil)
				then
					if (CanCast[1](WeakestEnemy))
					then
						return BOT_ACTION_DESIRE_HIGH, WeakestEnemy;
					end
				end
			end
		end
	end

	--Last hit
	if (npcBot:GetActiveMode() == BOT_MODE_LANING)
	then
		if (WeakestCreep ~= nil)
		then
			if (
				(ManaPercentage > 0.45 or npcBot:GetMana() > ComboMana) and
					GetUnitToUnitDistance(npcBot, WeakestCreep) >= AttackRange - ManaPercentage)
			then
				if (CreepHealth <= WeakestCreep:GetActualIncomingDamage(Damage, DAMAGE_TYPE_MAGICAL))
				then

					return BOT_ACTION_DESIRE_MODERATE + 0.05, WeakestCreep;
				end
			end
		end
	end

	-- If we're farming and can hit 2+ creeps and kill 1+
	if (npcBot:GetActiveMode() == BOT_MODE_FARM)
	then
		if (#Allcreeps >= 2)
		then
			if (
				CreepHealth <= Allcreeps[1]:GetActualIncomingDamage(Damage, DAMAGE_TYPE_MAGICAL) and ManaPercentage > 0.45 and
					npcBot:GetMana() > ComboMana)
			then
				return BOT_ACTION_DESIRE_LOW, Allcreeps[1];
			end
		end
	end

	-- If we're pushing or defending a lane and can hit 3+ creeps, go for it
	if (npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
		npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
		npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or
		npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
		npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
		npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT)
	then
		if (#enemys + #creeps >= 3 and ManaPercentage > 0.4 or npcBot:GetMana() > ComboMana)
		then
			if (WeakestEnemy ~= nil)
			then
				if (CanCast[1](WeakestEnemy) and GetUnitToUnitDistance(npcBot, WeakestEnemy) < CastRange + 75 * #allys)
				then
					return BOT_ACTION_DESIRE_LOW, WeakestEnemy;
				end
			end
			if (WeakestCreep ~= nil)
			then
				if (CanCast[1](WeakestCreep) and GetUnitToUnitDistance(npcBot, WeakestCreep) < CastRange + 75 * #allys)
				then
					return BOT_ACTION_DESIRE_LOW, WeakestCreep;
				end
			end
		end
	end

	-- If we're going after someone
	if (npcBot:GetActiveMode() == BOT_MODE_ROAM or
		npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		npcBot:GetActiveMode() == BOT_MODE_ATTACK)
	then
		local npcTarget = npcBot:GetTarget();

		if (ManaPercentage > 0.4 or npcBot:GetMana() > ComboMana)
		then
			if (npcTarget ~= nil)
			then
				if (CanCast[1](npcTarget) and GetUnitToUnitDistance(npcBot, npcTarget) < CastRange + 75 * #allys)
				then
					return BOT_ACTION_DESIRE_MODERATE, npcTarget;
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;

end

-- zuus_lightning_bolt
Consider[2] = function()

	local ability = AbilitiesReal[2];

	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0, "nil";
	end

	local CastRange = ability:GetCastRange();
	local Damage = ability:GetAbilityDamage();


	local allys = npcBot:GetNearbyHeroes(1200, false, BOT_MODE_NONE);
	local enemys = npcBot:GetNearbyHeroes(CastRange + 300, true, BOT_MODE_NONE)
	local WeakestEnemy, HeroHealth = utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange + 300, true)
	local WeakestCreep, CreepHealth = utility.GetWeakestUnit(creeps)

	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------
	-- Check for a channeling enemy
	for _, enemy in pairs(enemys) do
		if (enemy:IsChanneling() and CanCast[2](enemy) and not enemy:HasModifier("modifier_antimage_counterspell"))
		then
			return BOT_ACTION_DESIRE_HIGH, enemy, "Target";
		end
	end

	-- Kill enemy
	if (npcBot:GetActiveMode() ~= BOT_MODE_RETREAT)
	then
		if (WeakestEnemy ~= nil)
		then
			if (
				HeroHealth <= WeakestEnemy:GetActualIncomingDamage(Damage, DAMAGE_TYPE_MAGICAL) or
					(
					HeroHealth <= WeakestEnemy:GetActualIncomingDamage(GetComboDamage(), DAMAGE_TYPE_MAGICAL) and
						npcBot:GetMana() > ComboMana))
			then
				if (CanCast[2](WeakestEnemy))
				then
					return BOT_ACTION_DESIRE_HIGH, WeakestEnemy, "Target";
				end
			end
		end
	end

	--protect myself
	local enemys2 = npcBot:GetNearbyHeroes(CastRange, true, BOT_MODE_NONE);
	if (npcBot:WasRecentlyDamagedByAnyHero(5))
	then
		for _, enemy in pairs(enemys2) do
			if (CanCast[2](enemy)) and not enemy:HasModifier("modifier_antimage_counterspell") and
				not enemy:HasModifier("modifier_item_lotus_orb_active") and not enemy:HasModifier("modifier_item_blade_mail")
			then
				return BOT_ACTION_DESIRE_HIGH, enemy, "Target"
			end
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	--����
	--if ( npcBot:GetActiveMode() == BOT_MODE_LANING )
	--then
	if ((ManaPercentage > 0.4 or npcBot:GetMana() > ComboMana) and ability:GetLevel() >= 2)
	then
		if (WeakestEnemy ~= nil)
		then
			if (CanCast[2](WeakestEnemy))
			then
				return BOT_ACTION_DESIRE_LOW, WeakestEnemy, "Target";
			end
		end
	end
	--end

	-- If we're pushing or defending a lane and can hit 4+ creeps, go for it
	if (npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
		npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
		npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or
		npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
		npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
		npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT)
	then
		if (WeakestEnemy ~= nil)
		then
			if (CanCast[2](WeakestEnemy) and GetUnitToUnitDistance(npcBot, WeakestEnemy) < CastRange + 75 * #allys)
			then
				return BOT_ACTION_DESIRE_LOW, WeakestEnemy, "Target";
			end
		end
	end

	-- If we're going after someone
	if (npcBot:GetActiveMode() == BOT_MODE_ROAM or
		npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		npcBot:GetActiveMode() == BOT_MODE_ATTACK)
	then
		local npcTarget = npcBot:GetTarget();

		if (npcTarget ~= nil)
		then
			if (CanCast[2](npcTarget) and GetUnitToUnitDistance(npcBot, npcTarget) < CastRange + 75 * #allys)
			then
				return BOT_ACTION_DESIRE_MODERATE, npcTarget, "Target";
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0, "nil";
end

-- zuus_heavenly_jump
Consider[3] = function()
	local abilityNumber = 3
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability = AbilitiesReal[abilityNumber];

	if not ability:IsFullyCastable() or AbilityExtensions:CannotMove(npcBot) then
		return BOT_ACTION_DESIRE_NONE, 0;
	end

	local CastRange = 0
	local Damage = ability:GetAbilityDamage()
	local Radius = ability:GetAOERadius() - 50
	local CastPoint = ability:GetCastPoint()

	local allys = npcBot:GetNearbyHeroes(1200, false, BOT_MODE_NONE);
	local enemys = npcBot:GetNearbyHeroes(Radius, true, BOT_MODE_NONE)
	local WeakestEnemy, HeroHealth = utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(Radius + 300, true)
	local WeakestCreep, CreepHealth = utility.GetWeakestUnit(creeps)
	--Try to kill enemy hero
	if (npcBot:GetActiveMode() ~= BOT_MODE_RETREAT)
	then
		if (WeakestEnemy ~= nil)
		then
			if (CanCast[abilityNumber](WeakestEnemy))
			then
				if (
					HeroHealth <= WeakestEnemy:GetActualIncomingDamage(Damage, DAMAGE_TYPE_MAGICAL) and
						GetUnitToUnitDistance(npcBot, WeakestEnemy) <= Radius - CastPoint * WeakestEnemy:GetCurrentMovementSpeed())
				then
					return BOT_ACTION_DESIRE_HIGH, WeakestEnemy
				end
			end
		end
	end

	-- protect myself
	if (npcBot:WasRecentlyDamagedByAnyHero(2) or #enemys >= 2)
	then
		for _, npcEnemy in pairs(enemys) do
			if (CanCast[abilityNumber](npcEnemy))
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	-- If my mana is enough,use it at enemy
	if (npcBot:GetActiveMode() == BOT_MODE_LANING)
	then
		if ((ManaPercentage > 0.75 or npcBot:GetMana() > ComboMana) and ability:GetLevel() >= 2)
		then
			if (WeakestEnemy ~= nil)
			then
				if (CanCast[abilityNumber](WeakestEnemy))
				then
					if (GetUnitToUnitDistance(npcBot, WeakestEnemy) < Radius - CastPoint * WeakestEnemy:GetCurrentMovementSpeed())
					then
						return BOT_ACTION_DESIRE_LOW
					end
				end
			end
		end
	end

	-- If we're going after someone
	if (npcBot:GetActiveMode() == BOT_MODE_ROAM or
		npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		npcBot:GetActiveMode() == BOT_MODE_ATTACK)
	then
		local npcEnemy = AbilityExtensions:GetTargetIfGood(npcBot)
		if npcEnemy then
			if CanCast[abilityNumber](npcEnemy) and GetUnitToUnitDistance(npcBot, npcEnemy) <= Radius then
				return BOT_ACTION_DESIRE_MODERATE
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function DebugDrawUltTable()
	if debugmode then

		local drawY = 720
		local drawStep = 18

		for enemyName, enemyStats in pairs(npcBot.ult) do
			local timeElapsed = DotaTime() - enemyStats[1]
			local enemyBot = enemyStats[2]
			local enemyHero = enemyStats[3]
			local wasKillable = enemyStats[4]
			local isNull = ""

			if enemyBot:IsNull() then
				isNull = "!null"
			end

			local sInfo = enemyName .. isNull .. " Hero " .. tostring(enemyHero)
			sInfo = sInfo .. " Killable=" .. tostring(wasKillable) .. " " .. timeElapsed

			DebugDrawText(100, drawY, sInfo, 255, 255, 255)
			drawY = drawY + drawStep
		end
	end
end

-- Don't kill enemies that allies have just damaged but we haven't
local function DontSteal(enemy)
	return not enemy:WasRecentlyDamagedByAnyHero(1.5) or
		enemy:WasRecentlyDamagedByHero(npcBot, 2.5)
end

-- Tracking enemies with low health that we are giving teammates a chance to kill
local function GetDelayedUltDesire()
	local ability = AbilitiesReal[6];

	if not ability:IsTrained() or ability:GetCooldownTimeRemaining() > 30 then
		-- Skill is on cooldown, no point in tracking
		if next(npcBot.ult) ~= nil then
			npcBot.ult = {}
		end

		return BOT_ACTION_DESIRE_NONE
	end

	local Damage = ability:GetSpecialValueInt("damage") * damageBuffer

	-- Find good enemies to kill, put them in a list and wait a 
	-- couple seconds to see if our team can kill them without the ult
	for _, Enemy in ipairs(GetUnitList(UNIT_LIST_ENEMY_HEROES)) do
		-- Include enemies if:
		--  * They are alive and visible
		--  * We won't kill steal
		--  * We can't just hit them with lightning bolt
		--  * Our ult would kill them
		--  * TODO: They are the real hero
		--  * TODO: When shield support added, add that to health (or do hard way with modifiers)
		local isKillable = Enemy:GetHealth() <= Enemy:GetActualIncomingDamage(Damage, DAMAGE_TYPE_MAGICAL)
		if Enemy:IsAlive() and Enemy:CanBeSeen() and DontSteal(Enemy) and
			(GetUnitToUnitDistance(npcBot, Enemy) > AbilitiesReal[2]:GetCastRange() or
				not AbilitiesReal[2]:IsFullyCastable()) and
			isKillable
		then
			local enemyName = Enemy:GetUnitName()
			if (npcBot.ult[enemyName] == nil) then
				npcBot.ult[enemyName] = { DotaTime(), Enemy, Enemy:GetPlayerID(), isKillable }
			end
		end
	end

	DebugDrawUltTable()

	for enemyName, enemyStats in pairs(npcBot.ult) do
		local timeElapsed = DotaTime() - enemyStats[1]
		local enemyBot = enemyStats[2]
		local enemyHero = enemyStats[3]
		local wasKillable = enemyStats[4]

		local isEnemyNull = (enemyBot == nil or enemyBot:IsNull())
		local isKillable = not isEnemyNull and (IsHeroAlive(enemyHero) and
			CanCast[6](enemyBot) and
			enemyBot:GetHealth() <= enemyBot:GetActualIncomingDamage(Damage, DAMAGE_TYPE_MAGICAL))

		-- update killable status in case they go out of vision
		enemyStats[4] = isKillable

		if timeElapsed >= 30 or not IsHeroAlive(enemyHero) or
			(isEnemyNull and not wasKillable)
		then
			-- Enemy either got away or got killed
			-- Forget about them; we can always add them again if they get low
			npcBot.ult[enemyName] = nil

		elseif isEnemyNull and IsHeroAlive(enemyHero) and wasKillable then
			-- enemyBot should never be nil, but will become null when
			-- we lose sight of them. Ult now!
			-- Note: this may cast because they went invis
			--       they won't take damage, but we will get true sight
			return BOT_ACTION_DESIRE_VERYHIGH

		elseif (timeElapsed >= patience and isKillable) then
			-- Okay, we've been patient enough.  Time for some wrath.
			return BOT_ACTION_DESIRE_VERYHIGH

		end
	end

	return BOT_ACTION_DESIRE_NONE
end

-- zuus_thundergods_wrath
Consider[6] = function()
	local ability = AbilitiesReal[6];

	local Damage = ability:GetSpecialValueInt("damage") * damageBuffer

	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE
	end

	-- Results from GetDelayedUltDesire
	return delayedUltDesire
end


-- zuus_cloud (Nimbus)
Consider[4] = function()

	local ability = AbilitiesReal[4]
	if not ability:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local CastRange = ability:GetCastRange();

	local CreepHealth = 10000;
	local enemys = npcBot:GetNearbyHeroes(1600, true, BOT_MODE_NONE);
	local WeakestEnemy, CreepHealth = utility.GetWeakestUnit(enemys)

	local tower = nil

	if (npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
		npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
		npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT)
	then
		local tower = npcBot:GetNearbyTowers(1500, false)
	end

	if (npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
		npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
		npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT)
	then
		local tower = npcBot:GetNearbyTowers(1000, true)
	end

	if (tower ~= nil and GetUnitToUnitDistance(npcBot, tower[1]) < CastRange + 500)
	then
		return BOT_ACTION_DESIRE_LOW, tower[1]:GetLocation()
	end

	if (WeakestEnemy ~= nil)
	then
		return BOT_ACTION_DESIRE_LOW, WeakestEnemy:GetLocation()
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

AbilityExtensions:AutoModifyConsiderFunction(npcBot, Consider, AbilitiesReal)
function AbilityUsageThink()

	-- Run even if we can't cast, to keep track of targets
	delayedUltDesire = GetDelayedUltDesire()

	-- Check if we're already using an ability
	if (npcBot:IsUsingAbility() or npcBot:IsChanneling() or npcBot:IsSilenced())
	then
		return
	end

	ComboMana = GetComboMana()
	AttackRange = npcBot:GetAttackRange()
	ManaPercentage = npcBot:GetMana() / npcBot:GetMaxMana()
	HealthPercentage = npcBot:GetHealth() / npcBot:GetMaxHealth()

	cast = ability_item_usage_generic.ConsiderAbility(AbilitiesReal, Consider)
	---------------------------------debug--------------------------------------------
	if (debugmode == true)
	then
		ability_item_usage_generic.PrintDebugInfo(AbilitiesReal, cast)
	end
	ability_item_usage_generic.UseAbility(AbilitiesReal, cast)
end

function CourierUsageThink()
	ability_item_usage_generic.CourierUsageThink()
end
