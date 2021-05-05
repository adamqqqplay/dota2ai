----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.3 New Structure
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
--------------------------------------
-- General Initialization
--------------------------------------
local utility = require( GetScriptDirectory().."/utility" ) 
require(GetScriptDirectory() ..  "/ability_item_usage_generic")
local AbilityExtensions = require(GetScriptDirectory().."/util/AbilityAbstraction")

local debugmode=false
local npcBot = GetBot()
local Talents ={}
local Abilities ={}
local AbilitiesReal ={}

ability_item_usage_generic.InitAbility(Abilities,AbilitiesReal,Talents) 


local AbilityToLevelUp=
{
	Abilities[2],
	Abilities[1],
	Abilities[3],
	Abilities[1],
	Abilities[1],
	Abilities[5],
	Abilities[1],
	Abilities[3],
	Abilities[3],
	"talent",
	Abilities[2],
	Abilities[5],
	Abilities[2],
	Abilities[2],
	"talent",
	Abilities[3],
	"nil",
	Abilities[5],
	"nil",
	"talent",
	"nil",
	"nil",
	"nil",
	"nil",
	"talent",
}

local TalentTree={
	function()
		return Talents[2]
	end,
	function()
		return Talents[4]
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

function AbilityLevelUpThink()
	ability_item_usage_generic.AbilityLevelUpThink2(AbilityToLevelUp,TalentTree)
end

--------------------------------------
-- Ability Usage Thinking
--------------------------------------
local cast={} cast.Desire={} cast.Target={} cast.Type={}
local Consider ={}
local CanCast={utility.NCanCast,utility.NCanCast,utility.NCanCast,
utility.NCanCast,function(t)
	if npcBot:GetTeam() == t:GetTeam() then
		return AbilityExtensions:SpellCanCast(t, true)
	else
		return AbilityExtensions:HasScepter(t) and AbilityExtensions:SpellCanCast(t)
	end
end,utility.NCanCast,
utility.NCanCast,utility.NCanCast,utility.NCanCast}
local enemyDisabled=utility.enemyDisabled

function GetComboDamage()
	return ability_item_usage_generic.GetComboDamage(AbilitiesReal)
end

function GetComboMana()
	return ability_item_usage_generic.GetComboMana(AbilitiesReal)
end

Consider[1]=function()
	local abilityNumber=1
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability=AbilitiesReal[abilityNumber];
	
	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = 400
	local Damage = ability:GetAbilityDamage();
	local CastPoint = ability:GetCastPoint();
	

	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange+150,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange+150,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------
	--Try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		if (WeakestEnemy~=nil)
		then
			if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana)
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	--------------------------------------
	-- Mode based usage
	--------------------------------------
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH ) 
	then
		if ( npcBot:WasRecentlyDamagedByAnyHero( 2.0 ) ) 
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end
	
	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		 npcBot:GetActiveMode() == BOT_MODE_ATTACK ) 
	then
		local npcEnemy = npcBot:GetTarget();

		if ( npcEnemy ~= nil ) 
		then
			if ( GetUnitToUnitDistance(npcBot,npcEnemy)<= CastRange )
			then
				return BOT_ACTION_DESIRE_MODERATE
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;
	
end

Consider[4]=function()

	local abilityNumber=4
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability=AbilitiesReal[abilityNumber];
	
	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = ability:GetCastRange();
	local Damage = ability:GetAbilityDamage();
	local CastPoint = ability:GetCastPoint();
	

	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange+300,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------
	--Try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		if (WeakestEnemy~=nil)
		then
			if ( CanCast[abilityNumber]( WeakestEnemy ) )
			then
				if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana)
				then
					return BOT_ACTION_DESIRE_HIGH,WeakestEnemy; 
				end
			end
		end
	end
	
	-- If we're in a teamfight, use it on the scariest enemy
	local tableNearbyAttackingAlliedHeroes = npcBot:GetNearbyHeroes( 1000, false, BOT_MODE_ATTACK );
	if ( #tableNearbyAttackingAlliedHeroes >= 2 ) 
	then

		local npcMostDangerousEnemy = nil;
		local nMostDangerousDamage = 0;

		for _,npcEnemy in pairs( enemys )
		do
			if ( CanCast[abilityNumber]( npcEnemy ) and not enemyDisabled(npcEnemy))
			then
				local Damage2 = npcEnemy:GetEstimatedDamageToTarget( false, npcBot, 3.0, DAMAGE_TYPE_ALL );
				if ( Damage2 > nMostDangerousDamage )
				then
					nMostDangerousDamage = Damage2;
					npcMostDangerousEnemy = npcEnemy;
				end
			end
		end

		if ( npcMostDangerousEnemy ~= nil )
		then
			return BOT_ACTION_DESIRE_HIGH, npcMostDangerousEnemy;
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH ) 
	then
		for _,npcEnemy in pairs( enemys )
		do
			if ( npcBot:WasRecentlyDamagedByHero( npcEnemy, 2.0 ) ) 
			then
				if ( CanCast[abilityNumber]( npcEnemy ) and not enemyDisabled(npcEnemy)) 
				then
					return BOT_ACTION_DESIRE_HIGH, npcEnemy;
				end
			end
		end
	end
	
	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		 npcBot:GetActiveMode() == BOT_MODE_ATTACK ) 
	then
		local npcEnemy = npcBot:GetTarget();

		if ( npcEnemy ~= nil ) 
		then
			if ( CanCast[abilityNumber]( npcEnemy ) and not enemyDisabled(npcEnemy) and GetUnitToUnitDistance(npcBot,npcEnemy)< CastRange + 75*#allys)
			then
				return BOT_ACTION_DESIRE_MODERATE, npcEnemy
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;
	
end

Consider[5]=function()

	local abilityNumber=5
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability=AbilitiesReal[abilityNumber];
	
	if not ability:IsFullyCastable() or AbilityExtensions:CannotMove(npcBot) then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = ability:GetCastRange();
	local Damage = ability:GetAbilityDamage();
	local CastPoint = ability:GetCastPoint();
	local Radius = ability:GetAOERadius()
	

	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	allys = AbilityExtensions:Remove(allys, npcBot)
	local StrongestAlly,AllyHealth=utility.GetStrongestUnit(allys)
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange+300,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
	local StrongestCreep,CreepHealthEnemy=utility.GetStrongestUnit(creeps)
	local creepsAlly = npcBot:GetNearbyCreeps(CastRange+300,false)
	local StrongestCreepAlly,CreepHealthAlly=utility.GetStrongestUnit(creepsAlly)
	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------
	--Try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		if (WeakestEnemy~=nil)
		then
			if ( CanCast[abilityNumber]( WeakestEnemy ) )
			then
				local allys2 = WeakestEnemy:GetNearbyHeroes( Radius-50, true, BOT_MODE_NONE );
				allys2 = AbilityExtensions:Remove(allys2, npcBot)
				if(allys2~=nil and HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana)
				then
					return BOT_ACTION_DESIRE_HIGH,allys2[#allys2]; 
				end
			end
		end
	end

	if AbilityExtensions:HasScepter(npcBot) and (AbilityExtensions:IsSeverelyDisabled(npcBot) or AbilityExtensions:GetHealthPercent(npcBot) <= 0.3) then
		local enemies = npcBot:GetNearbyHeroes(CastRange,true,BOT_MODE_NONE)
		enemies = AbilityExtensions:Filter(enemies, CanCast[5])
		local realEnemies = AbilityExtensions:Filter(npcBot, function(t) return AbilityExtensions:MayNotBeIllusion(npcBot, t) end)
		if #realEnemies ~= 0 then
			return BOT_ACTION_DESIRE_HIGH, AbilityExtensions:Max(realEnemies, function(t) return t:GetMaxHealth() * RemapValClamped(AbilityExtensions:GetHealthPercent(t), 0, 0.4, 2, 1) end)
		end
		if #enemies ~= 0 then
			return BOT_ACTION_DESIRE_HIGH, AbilityExtensions:Max(enemies, function(t) return t:GetMaxHealth() * RemapValClamped(AbilityExtensions:GetHealthPercent(t), 0, 0.4, 2, 1) end)
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH ) 
	then
		if(StrongestAlly~=nil)
		then
			return BOT_ACTION_DESIRE_MODERATE,StrongestAlly
		end
		if(StrongestCreep~=nil and StrongestCreep:GetHealth()/StrongestCreep:GetMaxHealth()>0.5)
		then
			return BOT_ACTION_DESIRE_MODERATE,StrongestCreep
		end
		if(StrongestCreepAlly~=nil)
		then
			return BOT_ACTION_DESIRE_MODERATE,StrongestCreepAlly
		end
	end
	
	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY ) 
	then
		local npcEnemy = npcBot:GetTarget();

		if ( npcEnemy ~= nil and #allys>=1 ) 
		then
			if ( GetUnitToUnitDistance(npcBot,npcEnemy)>3000 )
			then
				local HighestSpeed=0
				local npcTarget=allys[1]
				for _,npcAlly in pairs(allys)
				do
					local speed=npcAlly:GetCurrentMovementSpeed()
					if(speed>HighestSpeed)
					then
						npcTarget=npcAlly
						HighestSpeed=speed
					end
				end
				
				return BOT_ACTION_DESIRE_MODERATE, npcTarget
			end
		end
	end
	return BOT_ACTION_DESIRE_NONE
end

Consider[7]=function()

	local abilityNumber=7
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability=AbilitiesReal[abilityNumber];
	
	if not ability:IsFullyCastable() or ability:IsHidden() then
		return BOT_ACTION_DESIRE_NONE
	end
	
	local CastRange = ability:GetCastRange();
	local Damage = ability:GetAbilityDamage();
	local CastPoint = ability:GetCastPoint();
	local Radius = 600
	

	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange+300,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
	
	--------------------------------------
	-- Mode based usage
	--------------------------------------

	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT ) 
	then
		if ( #enemys == 0 or AbilitiesReal[1]:IsFullyCastable() and npcBot:DistanceFromFountain()>=1000) 
		then
			return BOT_ACTION_DESIRE_HIGH;
		end
	end
	
	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_ATTACK or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY ) 
	then
		local npcTarget = npcBot:GetTarget();
		if ( npcTarget~= nil and GetUnitToUnitDistance( npcTarget, npcBot ) < Radius )
		then
			return BOT_ACTION_DESIRE_VERYHIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

local lastInfestTime
local lastInfestTarget

Consider[6] = function()
	local ability = AbilitiesReal[6]
	if not ability:IsFullyCastable() or ability:IsHidden() or lastInfestTarget == nil then
		return 0
	end
	if lastInfestTarget ~= nil or not lastInfestTarget:IsAlive() or not npcBot:IsInvulnerable() then
		lastInfestTarget = nil
		lastInfestTime = nil
	end
	local infestTime = DotaTime() - lastInfestTime
	local infest3 = infestTime > 3
	local infest10 = infestTime > 10
	
	local enemies = AbilityExtensions:GetNearbyNonIllusionHeroes(npcBot, 1000, true)
	local friends = AbilityExtensions:GetNearbyNonIllusionHeroes(npcBot, 1200, false)

	if AbilityExtensions:IsAttackingEnemies(npcBot) then
		local nearbyEnemies = AbilityExtensions:GetNearbyNonIllusionHeroes(npcBot, ability:GetAOERadius(), true)
		if #nearbyEnemies >= 3 or npcBot:GetTeam() == lastInfestTarget:GetTeam() and AbilityExtensions:IsSeverelyDisabled(lastInfestTarget) and #nearbyEnemies <= 2 or #nearbyEnemies == 1 then
			return BOT_ACTION_DESIRE_MODERATE + 0.1
		end
	end
	if infest3 and (#enemies == 0 or AbilityExtensions:Outnumber(npcBot, friends, enemies)) then
		return BOT_ACTION_DESIRE_HIGH
	end
	if infest10 then
		return BOT_ACTION_DESIRE_VERYHIGH
	end
	return 0
end


AbilityExtensions:AutoModifyConsiderFunction(npcBot, Consider, AbilitiesReal)


function AbilityUsageThink()

	-- Check if we're already using an ability
	if ( npcBot:IsUsingAbility() or npcBot:IsChanneling() or npcBot:IsSilenced() )
	then 
		return
	end
	
	ComboMana=GetComboMana()
	AttackRange=npcBot:GetAttackRange()
	ManaPercentage=npcBot:GetMana()/npcBot:GetMaxMana()
	HealthPercentage=npcBot:GetHealth()/npcBot:GetMaxHealth()
	
	cast=ability_item_usage_generic.ConsiderAbility(AbilitiesReal,Consider)
	---------------------------------debug--------------------------------------------
	if(debugmode==true)
	then
		ability_item_usage_generic.PrintDebugInfo(AbilitiesReal,cast)
	end
	local index, target = ability_item_usage_generic.UseAbility(AbilitiesReal,cast)
	if index == 5 then
		lastInfestTime = DotaTime()
		lastInfestTarget = target
	end
end

function CourierUsageThink() 
	ability_item_usage_generic.CourierUsageThink()
end