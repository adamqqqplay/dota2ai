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
	Abilities[1],
	Abilities[2],
	Abilities[1],
	Abilities[3],
	Abilities[1],
	Abilities[4],
	Abilities[1],
	Abilities[3],
	Abilities[3],
	"talent",
	Abilities[3],
	Abilities[4],
	Abilities[2],
	Abilities[2],
	"talent",
	Abilities[2],
	"nil",
	Abilities[4],
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

function AbilityLevelUpThink()
	ability_item_usage_generic.AbilityLevelUpThink2(AbilityToLevelUp,TalentTree)
end

--------------------------------------
-- Ability Usage Thinking
--------------------------------------
local cast={} cast.Desire={} cast.Target={} cast.Type={}
local Consider ={}

local enemyDisabled=utility.enemyDisabled

function GetComboDamage()
	return ability_item_usage_generic.GetComboDamage(AbilitiesReal)
end

function GetComboMana()
	return ability_item_usage_generic.GetComboMana(AbilitiesReal)
end

local function GetLagunaBladeDamageType()
	return AbilityExtensions:HasScepter(npcBot) and DAMAGE_TYPE_PURE or DAMAGE_TYPE_MAGICAL
end
function CanCast4(t)
	local hasShard = AbilityExtensions:HasShard(t)
	return AbilityExtensions:NormalCanCast(t, false, GetLagunaBladeDamageType(), nil, not hasShard, not hasShard)
end
local CanCast={utility.NCanCast,utility.NCanCast,utility.NCanCast,CanCast4}

----------------------------------------------------------------------------------------------------

Consider[1]=function()

	local ability=AbilitiesReal[1];
	
	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = ability:GetCastRange();
	local Damage = ability:GetAbilityDamage();
	local Radius = ability:GetSpecialValueInt( "dragon_slave_width_end" );
	

	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange+0,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange+0,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)

	--try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		if (WeakestEnemy~=nil)
		then
			if ( CanCast[1]( WeakestEnemy ) )
			then
				if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL) or (HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana))
				then
					return BOT_ACTION_DESIRE_HIGH,WeakestEnemy:GetLocation(); 
				end
			end
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	--Last hit
	--if ( npcBot:GetActiveMode() == BOT_MODE_LANING ) 
	--then
		if(WeakestCreep~=nil)
		then
			if((ManaPercentage>0.5 and npcBot:GetMana()>ComboMana) and GetUnitToUnitDistance(npcBot,WeakestCreep)>=300)
			then
				local locationAoE = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), CastRange, Radius, 0, Damage );
				if ( locationAoE.count >= 1 ) then
					return BOT_ACTION_DESIRE_MODERATE+0.02, locationAoE.targetloc;
				end
			end		
		end
	--end
	
	--if ( npcBot:GetActiveMode() == BOT_MODE_LANING ) 
	--then
		if((ManaPercentage>0.5 or npcBot:GetMana()>ComboMana) and ability:GetLevel()>=2 )
		then
			local locationAoE = npcBot:FindAoELocation( true, true, npcBot:GetLocation(), CastRange, Radius, 0, 0 );
			if ( locationAoE.count >= 3 ) then
				return BOT_ACTION_DESIRE_MODERATE-0.05, locationAoE.targetloc;
			end
		end
	--end
	
	-- If we're farming and can kill 3+ creeps with LSA
	if ( npcBot:GetActiveMode() == BOT_MODE_FARM ) then
		local locationAoE = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), CastRange, Radius, 0, Damage );

		if ( ManaPercentage>0.4 and locationAoE.count >= 3 ) then
			return BOT_ACTION_DESIRE_MODERATE+0.02, locationAoE.targetloc;
		end
	end

	-- If we're pushing or defending a lane and can hit 4+ creeps, go for it
	if ( npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT ) 
	then
		local locationAoE = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), CastRange, Radius, 0, 0 );

		if ( locationAoE.count >= 4 ) 
		then
			return BOT_ACTION_DESIRE_MODERATE+0.05, locationAoE.targetloc;
		end
	end

	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		 npcBot:GetActiveMode() == BOT_MODE_ATTACK ) 
	then
		local npcTarget = npcBot:GetTarget();

		if ( npcTarget ~= nil ) 
		then
			if ( CanCast[1]( npcTarget ) )
			then
				return BOT_ACTION_DESIRE_MODERATE, npcTarget:GetLocation();
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;

end

----------------------------------------------------------------------------------------------------

Consider[2]=function()

	local ability=AbilitiesReal[2];
	
	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = ability:GetCastRange();
	local Damage = ability:GetAbilityDamage();
	local Radius = ability:GetSpecialValueInt( "light_strike_array_aoe" );
	local CastPoint = ability:GetCastPoint()
	

	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange+300,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)

	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------

	-- Check for a channeling enemy
	for _,npcEnemy in pairs( enemys )
	do
		if ( npcEnemy:IsChanneling() ) 
		then
			return BOT_ACTION_DESIRE_HIGH, npcEnemy:GetLocation();
		end
	end

	--try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		if (WeakestEnemy~=nil)
		then
			if ( CanCast[4]( WeakestEnemy ) )
			then
				if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL) or (HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana))
				then
					return BOT_ACTION_DESIRE_HIGH,WeakestEnemy:GetExtrapolatedLocation(0.95); 
				end
			end
		end
	end

    local imprisonedEnemy = AbilityExtensions:Map(npcBot:GetNearbyHeroes(CastRange+100,true,BOT_MODE_NONE), function(t) return { t, AbilityExtensions:GetImprisonmentRemainingDuration(t) } end)
    imprisonedEnemy = AbilityExtensions:First(imprisonedEnemy, function(t) return t[2] ~= nil  end)
    if imprisonedEnemy ~= nil then
        local timer = imprisonedEnemy[2] - ability:GetSpecialValueFloat("effect_delay") - ability:GetCastPoint() - 0.1
        if timer >= 0 then
            return BOT_ACTION_DESIRE_VERYHIGH, imprisonedEnemy[1]:GetLocation()
        end
    end

	--------------------------------------
	-- Mode based usage
	--------------------------------------
	if((ManaPercentage>0.4 or npcBot:GetMana()>ComboMana) and ability:GetLevel()>=1 )
	then
		local locationAoE = npcBot:FindAoELocation( true, true, npcBot:GetLocation(), CastRange, Radius, CastPoint, 0 );
		if ( locationAoE.count >= 2 ) then
			return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc;
		end
	end
		
	-- If we're farming and can kill 3+ creeps with LSA
	if ( npcBot:GetActiveMode() == BOT_MODE_FARM ) then
		local locationAoE = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), CastRange, Radius, CastPoint, Damage );

		if ( locationAoE.count >= 3 ) then
			return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc;
		end
	end
	
	if ( npcBot:GetActiveMode() == BOT_MODE_LANING ) 
	then
		if(WeakestEnemy~=nil and CanCast[4]( WeakestEnemy ))
		then
			if(ManaPercentage>0.66 or npcBot:GetMana()>ComboMana)
			then				
				return BOT_ACTION_DESIRE_LOW,WeakestEnemy:GetExtrapolatedLocation(CastPoint)
			end		
		end
	end

	-- If we're pushing or defending a lane and can hit 4+ creeps, go for it
	if ( npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT ) 
	then
		local locationAoE = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), CastRange, Radius, CastPoint, 0 );

		if ( locationAoE.count >= 4 ) 
		then
			return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc;
		end
	end

	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH ) 
	then
		local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( CastRange + Radius + 200, true, BOT_MODE_NONE );
		for _,npcEnemy in pairs( tableNearbyEnemyHeroes )
		do
			if ( npcBot:WasRecentlyDamagedByHero( npcEnemy, 2.0 ) ) 
			then
				if ( CanCast[4]( npcEnemy ) ) 
				then
					return BOT_ACTION_DESIRE_MODERATE, npcEnemy:GetExtrapolatedLocation(0.95);
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
		local npcTarget = npcBot:GetTarget();

		if ( npcTarget ~= nil ) 
		then
			if ( CanCast[4]( npcTarget ) )
			then
				return BOT_ACTION_DESIRE_HIGH, npcTarget:GetExtrapolatedLocation(0.95);
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;
end

----------------------------------------------------------------------------------------------------


local function NormalLagnuaBladeConsider()
	local ability=AbilitiesReal[4];
	
	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = ability:GetCastRange();
	local Damage = ability:GetAbilityDamage()
	local DamageType = GetLagunaBladeDamageType()

	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)

	--try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		if (WeakestEnemy~=nil)
		then
			if ( CanCast[4]( WeakestEnemy ))
			then
				if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(Damage,DamageType) or HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DamageType))
				then
					return BOT_ACTION_DESIRE_HIGH, WeakestEnemy, "Target"
				end
			end
		end
	end
	
	-- If a mode has set a target, and we can kill them, do it
	local npcTarget = AbilityExtensions:GetTargetIfGood(npcBot)
	if ( npcTarget ~= nil and CanCast[4]( npcTarget ) )
	then
		if ( npcTarget:GetActualIncomingDamage( Damage, DamageType ) > npcTarget:GetHealth() and GetUnitToUnitDistance( npcTarget, npcBot ) < ( CastRange + 200 ) )
		then
			return BOT_ACTION_DESIRE_HIGH, npcTarget, "Target"
		end
	end

	-- If we're in a teamfight, use it on the scariest enemy
	local tableNearbyAttackingAlliedHeroes = npcBot:GetNearbyHeroes( 1000, false, BOT_MODE_ATTACK );
	if ( #tableNearbyAttackingAlliedHeroes >= 2 ) 
	then

		local npcMostDangerousEnemy = nil;
		local nMostDangerousDamage = 0;

		local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( CastRange, true, BOT_MODE_NONE );
		for _,npcEnemy in pairs( tableNearbyEnemyHeroes )
		do
			if ( CanCast[4]( npcEnemy ) )
			then
				local Damage = npcEnemy:GetEstimatedDamageToTarget( false, npcBot, 3.0, DAMAGE_TYPE_ALL );
				if ( Damage > nMostDangerousDamage )
				then
					nMostDangerousDamage = Damage;
					npcMostDangerousEnemy = npcEnemy;
				end
			end
		end

		if ( npcMostDangerousEnemy ~= nil )
		then
			return BOT_ACTION_DESIRE_HIGH, npcMostDangerousEnemy, "Target"
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

local function TryUseShardLagunaAt(location, possibleEnemies)
	local scepter_width = AbilitiesReal[4]:GetSpecialValueInt("scepter_width")
	local line = AbilityExtensions:GetLine(npcBot:GetLocation(), location)
	return AbilityExtensions:Count(possibleEnemies, function(t)
		return CanCast[4](t) and AbilityExtensions:GetPointToLineDistance(t:GetLocation(), line) <= (AbilityExtensions:CannotMove() and scepter_width + t:GetBoundingRadius() or scepter_width * 0.75 + t:GetBoundingRadius())
	end)
end

local ShardLagunaBlade = function()
    local ability = AbilitiesReal[4]
    if not ability:IsFullyCastable() then
        return 0
    end
    local castRange = ability:GetCastRange()
	local enemies = AbilityExtensions:GetNearbyNonIllusionHeroes(npcBot, castRange)
	local oDesire, oTarget = NormalLagnuaBladeConsider()
	local myLocation = npcBot:GetLocation()
	local scepter_width = ability:GetSpecialValueInt("scepter_width") / 2
	local deltaDegree = scepter_width / castRange * 180 / math.pi -- at a low degree, tan(x) ~= x
	if oDesire > 0 then
		local enemyLocation = oTarget:GetLocation()
		local distance = GetUnitToUnitDistance(npcBot, oTarget)
		local degree1 = AbilityExtensions:GetDegree(enemyLocation, myLocation)
		local degree2 = degree1 + deltaDegree
		local degree3 = degree1 - deltaDegree
		local degree = { degree1, degree2, degree3 }
		local guess = AbilityExtensions:Map(degree, function(t) return { t, myLocation + Vector(distance*math.cos(t), distance*math.sin(t)) } end)
		local count = AbilityExtensions:Map(guess, function(t) return { t[1], t[2], TryUseShardLagunaAt(t[3], enemies) } end)
		count = AbilityExtensions:Max(count, function(t) return t[3] end)
		if count[3] > 1 or AbilityExtensions:HasAbilityRetargetModifier(oTarget) or AbilityExtensions:CannotBeTargetted(oTarget) then
			return oDesire, count[2], "Location"
		else
			return oDesire, oTarget, "Target" -- Why still use at target sometimes? Because laguna used at location can be dodged with forced movement!
		end
	end
	return 0
end

Consider[4] = function()
	if AbilityExtensions:HasShard(npcBot) then
		return NormalLagnuaBladeConsider()
	else
		return ShardLagunaBlade()
	end
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
	local a,b,c = ability_item_usage_generic.UseAbility(AbilitiesReal,cast)
	AbilityExtensions:RecordAbility(npcBot, a, b, c, AbilitiesReal)

end

function CourierUsageThink() 
	ability_item_usage_generic.CourierUsageThink()
end