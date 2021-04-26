----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.3 New Structure
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
-- v1.7 template by AaronSong321
local utility = require(GetScriptDirectory().."/utility")
require(GetScriptDirectory() ..  "/ability_item_usage_generic")
local AbilityExtensions = require(GetScriptDirectory().."/util/AbilityAbstraction")

local npcBot = GetBot()
if npcBot:IsIllusion() then
    return
end
local AbilityNames, Abilities, Talents = AbilityExtensions:InitAbility(npcBot)
local CanCast = {utility.NCanCast,utility.UCanCast,utility.CanCastNoTarget,utility.UCanCast,utility.UCanCast}

local AbilityToLevelUp=
{
    AbilityNames[3],
    AbilityNames[1],
	AbilityNames[3],
	AbilityNames[2],
	AbilityNames[3],
	AbilityNames[5],
	AbilityNames[3],
	AbilityNames[2],
	AbilityNames[2],
	"talent",
	AbilityNames[2],
	AbilityNames[5],
	AbilityNames[1],
	AbilityNames[1],
	"talent",
	AbilityNames[1],
	"nil",
	AbilityNames[5],
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
		return Talents[1]
	end,
	function()
		return Talents[4]
	end,
	function()
		return Talents[5]
	end,
	function()
		return Talents[8]
	end
}
utility.CheckAbilityBuild(AbilityToLevelUp)

function AbilityLevelUpThink()
    ability_item_usage_generic.AbilityLevelUpThink2(AbilityToLevelUp, TalentTree)
end

--------------------------------------
-- Ability Usage Thinking
--------------------------------------
local cast= {} cast.Desire= {} cast.Target= {} cast.Type= {}
local Consider = {}

local attackRange = npcBot:GetAttackRange()
local healthPercent = AbilityExtensions:GetHealthPercent(npcBot)
local mana = npcBot:GetMana()
local manaPercent = AbilityExtensions:GetManaPercent(npcBot)


Consider[1]=function()	--Target Ability Example
	local abilityNumber=1
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability=AbilitiesReal[abilityNumber];
	
	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = ability:GetCastRange();
	local Damage = ability:GetAbilityDamage();
	local Radius = ability:GetAOERadius()
	
	local HeroHealth=10000
	local CreepHealth=10000
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------
	-- Check for a channeling enemy
	for _,npcEnemy in pairs( enemys )
	do
		if ( npcEnemy:IsChanneling() and CanCast[abilityNumber]( npcEnemy )) 
		then
			return BOT_ACTION_DESIRE_HIGH, npcEnemy
		end
	end
	
	--Try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		if (WeakestEnemy~=nil)
		then
			if ( CanCast[abilityNumber]( WeakestEnemy ) )
			then
				if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL) or (HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana))
				then
					return BOT_ACTION_DESIRE_HIGH,WeakestEnemy; 
				end
			end
		end
	end

	--------------------------------------
	-- Mode based usage
	--------------------------------------
	if ( #enemys>=1 and #creeps<=1 ) 
	then
		if ( CanCast[abilityNumber]( enemys[1] ) )
			then
				return BOT_ACTION_DESIRE_MODERATE,WeakestEnemy;
			end
	end
	
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH ) 
	then
		for _,npcEnemy in pairs( enemys )
		do
			if ( npcBot:WasRecentlyDamagedByHero( npcEnemy, 2.0 ) ) 
			then
				if ( CanCast[abilityNumber]( npcEnemy ) and not enemyDisabled(npcEnemy) and GetUnitToUnitDistance(npcBot,npcEnemy)< CastRange) 
				then
					return BOT_ACTION_DESIRE_HIGH, npcEnemy;
				end
			end
		end
	end
	
	-- If my mana is enough,use it at enemy
	if ( npcBot:GetActiveMode() == BOT_MODE_LANING ) 
	then
		if(ManaPercentage>0.4 or npcBot:GetMana()>ComboMana)
		then
			if (WeakestEnemy~=nil)
			then
				if ( CanCast[abilityNumber]( WeakestEnemy ) )
				then
					return BOT_ACTION_DESIRE_LOW,WeakestEnemy;
				end
			end
		end
	end
	
	-- If we're farming and can hit 2+ creeps and kill 1+ 
	if ( npcBot:GetActiveMode() == BOT_MODE_FARM )
	then
		if ( #creeps >= 2 ) 
		then
			if(CreepHealth<=WeakestCreep:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana)
			then
				return BOT_ACTION_DESIRE_LOW, WeakestCreep;
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
			if ( CanCast[abilityNumber]( npcEnemy ) and not enemyDisabled(npcEnemy) and GetUnitToUnitDistance(npcBot,npcEnemy)< CastRange)
			then
				return BOT_ACTION_DESIRE_MODERATE,npcEnemy
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;
	
end

Consider[2]=function()		--Target AOE Ability Example
	local abilityNumber=2
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability=AbilitiesReal[abilityNumber];
	
	if not ability:IsFullyCastable() or not AbilityExtensions:CanMove(npcBot) then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = ability:GetCastRange();
	local Damage =  npcBot:GetAttackDamage()+ability:GetSpecialValueInt("bonus_hero_damage")
	local Radius = ability:GetAOERadius()
	
	local HeroHealth=10000
	local CreepHealth=10000
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(1200,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(1200,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
	
	--try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		if (WeakestEnemy~=nil)
		then
			if ( CanCast[abilityNumber]( WeakestEnemy ) )
			then
				if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL) or (HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana))
				then
					return BOT_ACTION_DESIRE_HIGH,WeakestEnemy:GetLocation()+GetSafeVector(npcBot,Radius); 
				end
			end
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	-- if we can hit 3+ hero
	if ( npcBot:GetActiveMode() == BOT_MODE_ATTACK ) 
	then
		local locationAoE = npcBot:FindAoELocation( true, true, npcBot:GetLocation(), CastRange+500, Radius, 0, 0 );
		if ( locationAoE.count >= 2) then
			return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc;
		end
	end
	
	-- LANING
	if ( npcBot:GetActiveMode() == BOT_MODE_LANING ) 
	then
		if((ManaPercentage>0.4 or npcBot:GetMana()>ComboMana))
		then
			local locationAoE = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), CastRange+500, Radius, 0, 0 );
			if ( locationAoE.count >= 2) then
				return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc;
			end
		end
	end
	
	-- If we're farming and can kill 3+ creeps with LSA
	if ( npcBot:GetActiveMode() == BOT_MODE_FARM ) then
		local locationAoE = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), CastRange+500, Radius, 0, 0 );

		if ( locationAoE.count >= 2) then
			return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc;
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
		local locationAoE = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), CastRange+500, Radius, 0, 0 );

		if ( locationAoE.count >= 3) 
		then
			return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc;
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
			if ( CanCast[abilityNumber]( npcEnemy ) )
			then
				return BOT_ACTION_DESIRE_HIGH, npcEnemy:GetLocation()+GetSafeVector(npcBot,Radius);
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;
	
end

Consider[3]=function()
	
	local abilityNumber=3
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability=AbilitiesReal[abilityNumber];
	
	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = ability:GetCastRange();
	local Damage = ability:GetAbilityDamage();
	
	local HeroHealth=10000
	local CreepHealth=10000
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange+300,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)

	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------
	--try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		if (WeakestEnemy~=nil)
		then
			if ( CanCast[abilityNumber]( WeakestEnemy ) )
			then
				if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL) or (HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana))
				then
					return BOT_ACTION_DESIRE_HIGH; 
				end
			end
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH ) 
	then
		if ( npcBot:WasRecentlyDamagedByHero( npcEnemy, 2.0 ) ) 
		then
			return BOT_ACTION_DESIRE_MODERATE;
		end
	end

	--Laning
	if ( npcBot:GetActiveMode() == BOT_MODE_LANING ) 
	then
		if((ManaPercentage>0.4 or npcBot:GetMana()>ComboMana) and #enemys >=2)
		then				
			return BOT_ACTION_DESIRE_LOW; 
		end		
	end
	
	-- If we're pushing or defending a lane and can hit 4+ creeps, go for it
	if ( npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT or
		 npcBot:GetActiveMode() == BOT_MODE_FARM ) 
	then
		if ( #enemys==0 and #creeps>=2 and (ManaPercentage>0.4 or npcBot:GetMana()>ComboMana)) 
		then
			return BOT_ACTION_DESIRE_LOW;
		end
	end

	-- If we're going after someone
	if (  npcBot:GetActiveMode() == BOT_MODE_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		 npcBot:GetActiveMode() == BOT_MODE_ATTACK ) 
	then
		local npcEnemy = npcBot:GetTarget();

		if ( npcEnemy ~= nil ) 
		then
			if ( CanCast[abilityNumber]( npcEnemy ) )
			then
				return BOT_ACTION_DESIRE_MODERATE;
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE;
	
end

Consider[4]=function()
	local abilityNumber=4
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability=Abilities[abilityNumber];
	
	if not ability:IsFullyCastable() or not AbilityExtensions:CanMove(npcBot) then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = ability:GetCastRange();
	local Damage = ability:GetAbilityDamage();
	
	local HeroHealth=10000
	local CreepHealth=10000
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(1600,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(1600,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
	
	if(npcBot.ult==nil)
	then
		npcBot.ult={}
	end
	for _,i in pairs(npcBot.ult)
	do
		if(DotaTime()>=i[1]+45)
		then
			table.remove(npcBot.ult,_)
		end
	end
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
				if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL) or (HeroHealth<=WeakestEnemy:GetActualIncomingDamage(500,DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana))
				then
					local d=GetUnitToUnitDistance(npcBot,WeakestEnemy)
					return BOT_ACTION_DESIRE_HIGH,utility.GetUnitsTowardsLocation(npcBot,WeakestEnemy,d+300) 
				end
			end
		end
	end
	
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	-- If we're seriously retreating
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= 0.75 and #npcBot.ult==0) 
	then
		if ( npcBot:WasRecentlyDamagedByAnyHero(2) or #enemys >=1) 
		then
			return BOT_ACTION_DESIRE_HIGH, utility.GetUnitsTowardsLocation(enemys[1],npcBot,CastRange);
		end
	end

	-- If we're pushing or defending a lane
	if ( npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT or
		 npcBot:GetActiveMode() == BOT_MODE_LANING	or
		 npcBot:GetActiveMode() == BOT_MODE_FARM) 
	then
		if(#npcBot.ult<1 and (npcBot.ult_time==nil or DotaTime()-npcBot.ult_time>=2))
		then
			npcBot.ult_time=DotaTime()
			return BOT_ACTION_DESIRE_HIGH, npcBot:GetLocation()+utility.GetSafeVector(npcBot,1500)
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
			local d=GetUnitToUnitDistance(npcBot,npcEnemy)
			if ( CanCast[abilityNumber]( npcEnemy ) and not utility.enemyDisabled(npcEnemy) and d< CastRange + 75*#allys)
			then
				return BOT_ACTION_DESIRE_MODERATE, utility.GetUnitsTowardsLocation(npcBot,npcEnemy,d+300)
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;
	
end

function Consider5_r()

	local abilityNumber=5
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability=AbilitiesReal[abilityNumber];
	
	if (not ability:IsFullyCastable()) then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = ability:GetCastRange();
	local Damage = ability:GetAbilityDamage();

	local HeroHealth=10000
	local CreepHealth=10000
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(1600,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(1600,true)
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
				if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL) or (HeroHealth<=WeakestEnemy:GetActualIncomingDamage(550,DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana))
				then
					return BOT_ACTION_DESIRE_HIGH,WeakestEnemy:GetLocation()
				end
			end
		end
	end
	
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	-- If we're seriously retreating
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= 0.5) 
	then
		if ( npcBot:WasRecentlyDamagedByAnyHero(2) or #enemys >=1) 
		then
			return BOT_ACTION_DESIRE_HIGH, utility.Fountain(GetTeam())
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
			local d=GetUnitToUnitDistance(npcBot,npcEnemy)
			if ( CanCast[abilityNumber]( npcEnemy ) and not utility.enemyDisabled(npcEnemy) and d< CastRange + 75*#allys)
			then
				return BOT_ACTION_DESIRE_MODERATE, utility.GetUnitsTowardsLocation(npcBot,npcEnemy,d+300)
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;
	
end

Consider[5]=function()
	if(npcBot:HasModifier("modifier_ember_spirit_fire_remnant_timer")==false and npcBot.ult~=nil)
	then
		--print("remove"..DotaTime().." "..#npcBot.ult)
		npcBot.ult={}
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	if(npcBot.ult==nil or #npcBot.ult==0)
	then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local desire,location=Consider5_r()
	if(desire==0) 
	then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local min_distance =10000
	local q=-1
	for _,i in pairs(npcBot.ult)
	do
		if(DotaTime()>i[1]+i[3])
		then
			d=utility.PointToPointDistance(i[2],location)
			if(d<min_distance)
			then
				min_distance=d
				q=_
			end
		end
	end
	
	if(q~=-1)
	then
		return desire,location
	else
		return BOT_ACTION_DESIRE_NONE, 0;
	end
end

local function IsUsingSleightOfFist()
    return npcBot:HasModifier("modifier_ember_spirit_sleight_of_fist_in_progress")
end
local function IsUsingRemnant()
    return npcBot:HasModifier("modifier_ember_spirit_fire_remnant")
end
local fistCastLocation

Consider[1] = function()
    local ability = Abilities[1]
    if not ability:IsFullyCastable() then
        return 0
    end
    local abilityLevel = ability:GetLevel()
    local castRange = ability:GetCastRange()
    local castPoint = ability:GetCastPoint()
    local manaCost = ability:GetManaCost()
    local duration = ability:GetDuration()
    local enemies = AbilityExtensions:GetNearbyHeroes(npcBot, castRange)
    local realEnemies = AbilityExtensions:Filter(enemies, function(t) return AbilityExtensions:MayNotBeIllusion(npcBot, t) end)
    local targettableEnemies = AbilityExtensions:Filter(realEnemies, function(t) return AbilityExtensions:NormalCanCast(t, true) end)
    local friends = AbilityExtensions:GetNearbyHeroes(npcBot, 1200, true)
    local friendCount = AbilityExtensions:GetEnemyHeroNumber(npcBot, friends)
    local enemyCreeps = AbilityExtensions:GetNearbyAttackableCreeps(npcBot, castRange)
    local friendCreeps = AbilityExtensions:GetNearbyAttackableCreeps(npcBot, npcBot:GetAttackRange()+150, false)
    local neutralCreeps = npcBot:GetNearbyNeutralCreeps(castRange)
    local damage = ability:GetSpecialValueInt("total_damage")
    local weakestEnemy, enemyHealth = utility.GetWeakestUnit(targettableEnemies)
    local weakCreeps = AbilityExtensions:Filter(enemyCreeps, function(t) return t:GetHealth() < t:GetActualIncomingDamage(damage, DAMAGE_TYPE_MAGICAL) end)
    local weakestCreep = utility.GetWeakestUnit(weakCreeps)
    local forbiddenCreeps = AbilityExtensions:Filter(enemyCreeps, function(t)
        return t:GetHealth() > t:GetActualIncomingDamage(damage, DAMAGE_TYPE_MAGICAL) and t:GetHealth() <= t:GetActualIncomingDamage(damage, DAMAGE_TYPE_MAGICAL) + AbilityExtensions:AttackOnceDamage(npcBot, t) * (0.9+#enemyCreeps*0.1)
    end)
    if #friendCreeps == 0 then
        forbiddenCreeps = {}
    end

    local unitCount = ability:GetSpecialValueInt("unit_count")
    local allNearbyTargettableEnemies = AbilityExtensions:Concat(targettableEnemies, enemyCreeps, neutralCreeps)
    allNearbyTargettableEnemies = AbilityExtensions:Count(enemies, function(t) return not t:IsInvulnerable() and not t:IsMagicImmune()  end)
    local fistBonus = 1
    if IsUsingSleightOfFist() and fistCastLocation ~= nil and GetUnitToLocationDistance(npcBot, fistCastLocation) >= Abilities[2]:GetCastRange()-200 then
        fistBonus = 2
    end
    local goodTargets = AbilityExtensions:Count(targettableEnemies, function(t) return t:IsChanneling() end) * fistBonus
    goodTargets = goodTargets + AbilityExtensions:GetEnemyHeroNumber(npcBot, targettableEnemies) * 0.3 * fistBonus
    goodTargets = goodTargets + AbilityExtensions:Count(targettableEnemies, function(t) return AbilityExtensions:GetHealthPercent(t) <= duration/5+0.1*friendCount end)
    if allNearbyTargettableEnemies ~= 1 then
        goodTargets = goodTargets * unitCount / allNearbyTargettableEnemies
    end

    if AbilityExtensions:IsLaning(npcBot) then
        if manaPercent >= 0.5 + manaCost and goodTargets >= manaPercent or goodTargets >= 0.8 then
            return BOT_ACTION_DESIRE_HIGH
        end
    elseif AbilityExtensions:IsAttackingEnemies(npcBot) then
        if friendCount >= 2 and #enemies <= 2 then
            return BOT_ACTION_DESIRE_HIGH
        end
        if manaPercent >= 0.2 + manaCost and goodTargets >= 1 then
            return BOT_ACTION_DESIRE_MODERATE
        end
    elseif AbilityExtensions:IsFarmingOrPushing(npcBot) then
        if manaPercent >= 0.8 + manaCost and allNearbyTargettableEnemies >= 2 then
            return BOT_ACTION_DESIRE_MODERATE
        end
    elseif AbilityExtensions:IsRetreating(npcBot) then
        if allNearbyTargettableEnemies <= 3 and #targettableEnemies >= 1 then
            return BOT_ACTION_DESIRE_HIGH
        end
    end
    return 0
end

local ConsiderFist = function()
    local ability = Abilities[1]
    if not ability:IsFullyCastable() or IsUsingRemnant() or IsUsingSleightOfFist() or not AbilityExtensions:CanMove(npcBot) or ability:GetCurrentCharges() == 0 then
        return 0
    end
    local abilityLevel = ability:GetLevel()
    local castRange = ability:GetCastRange() + 200
    local radius = ability:GetAOERadius()
    local castPoint = ability:GetCastPoint()
    local manaCost = ability:GetManaCost()
    local duration = ability:GetDuration()
    local enemies = AbilityExtensions:GetNearbyHeroes(npcBot, castRange)
    local realEnemies = AbilityExtensions:Filter(enemies, function(t) return AbilityExtensions:MayNotBeIllusion(npcBot, t) end)
    local targettableEnemies = AbilityExtensions:Filter(realEnemies, function(t) return AbilityExtensions:NormalCanCast(t, true, DAMAGE_TYPE_PHYSICAL, true) and not AbilityExtensions:CannotBeAttacked(t) end)
    local friends = AbilityExtensions:GetNearbyHeroes(npcBot, 1200, true)
    local friendCount = AbilityExtensions:GetEnemyHeroNumber(npcBot, friends)
    local enemyCreeps = AbilityExtensions:GetNearbyAttackableCreeps(npcBot, castRange)
    local friendCreeps = AbilityExtensions:GetNearbyAttackableCreeps(npcBot, npcBot:GetAttackRange()+150, false)
    local neutralCreeps = npcBot:GetNearbyNeutralCreeps(castRange)
    local weakestEnemy, enemyHealth = utility.GetWeakestUnit(targettableEnemies)
    local creepDamage = npcBot:GetAttackDamage() * (1 + ability:GetSpecialValueInt("creep_damage_penalty") / 100)
    local weakCreeps = AbilityExtensions:Filter(enemyCreeps, function(t) return t:GetHealth() < t:GetActualIncomingDamage(creepDamage, DAMAGE_TYPE_MAGICAL) end)
    local weakestCreep = utility.GetWeakestUnit(weakCreeps)
    local forbiddenCreeps = AbilityExtensions:Filter(enemyCreeps, function(t)
        return t:GetHealth() > t:GetActualIncomingDamage(damage, DAMAGE_TYPE_MAGICAL) and t:GetHealth() <= t:GetActualIncomingDamage(creepDamage, DAMAGE_TYPE_MAGICAL) + AbilityExtensions:AttackOnceDamage(npcBot, t) * (0.9+#enemyCreeps*0.1)
    end)
    if #friendCreeps == 0 then
        forbiddenCreeps = {}
    end
    local damage = npcBot:GetAttackDamage() + ability:GetSpecialValueInt("bonus_hero_damage")
    if AbilityExtensions:GetAvailableItem(npcBot, "item_lesser_crit") then
        damage = damage * 1.7
    elseif AbilityExtensions:GetAvailableItem(npcBot, "item_greater_crit") then
        damage = damage * 2.3
    end
    local hasBattleFury = AbilityExtensions:GetAvailableItem(npcBot, "item_bfury") ~= nil

    local projectiles = AbilityExtensions:GetIncomingDodgeableProjectiles(npcBot) or {}
    projectiles = AbilityExtensions:Any(projectiles, function(t) return GetUnitToLocationDistance(npcBot, t.location) <= 200  end)
    if projectiles then
        local locationAoE = npcBot:FindAoELocation(true, not hasBattleFury, npcBot:GetLocation(), castRange+60, radius, 0, 5000)
        if locationAoE.count >= 2 then
            return BOT_ACTION_DESIRE_HIGH, locationAoE.targetloc
        end
    end
    if AbilityExtensions:NotRetreating(npcBot) then
        local findPlace = npcBot:FindAoELocation(true, true, npcBot:GetLocation(), castRange+100, radius, 0, 5000)
        if findPlace.count >= 3 then
            if GetUnitToLocationDistance(npcBot, findPlace) <= castRange then
                return BOT_ACTION_DESIRE_VERYHIGH, findPlace.targetloc
            else
                return BOT_ACTION_DESIRE_MODERATE, findPlace.targetloc
            end
        elseif findPlace.count >= 2 then
            return BOT_ACTION_DESIRE_MODERATE, findPlace.targetloc
        end

        if weakestEnemy ~= nil then
            local damageTaken = weakestEnemy:GetActualIncomingDamage(damage, DAMAGE_TYPE_PHYSICAL)
            if enemyHealth <= damageTaken or enemyHealth <= damageTaken * 1.5 and mana > ComboMana + manaCost then
                local targetLocation =  AbilityExtensions:FindAOELocationAtSingleTarget(npcBot, weakestEnemy, radius, castRange, castPoint)
                return BOT_ACTION_DESIRE_HIGH, targetLocation
            end
        end

        local target = npcBot:GetTarget()
        if target ~= nil and AbilityExtensions:NormalCanCast(target, true, DAMAGE_TYPE_PHYSICAL, true) and not AbilityExtensions:CannotBeAttacked(target)
                and (mana >= ComboMana or mana >= 200 and target:GetHealth() < target:GetActualIncomingDamage(damage, DAMAGE_TYPE_PHYSICAL) * (0.9 + friendCount*0.1)) then
            return BOT_ACTION_DESIRE_HIGH, AbilityExtensions:FindAOELocationAtSingleTarget(npcBot, target, radius, castRange, castPoint)
        end
    end
    if AbilityExtensions:IsFarmingOrPushing(npcBot) then
        local locationAoE = npcBot:FindAoELocation(true, false, npcBot:GetLocation(), castRange+150, radius, 0, 5000)
        if locationAoE.count >= 4 and manaPercent >= 0.4 + manaCost or locationAoE.count >= 3 and manaPercent >= 0.6 + manaCost then
            return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc
        end
    elseif AbilityExtensions:IsLaning(npcBot) then
        if manaPercent >= 0.6 + manaCost and #enemies == 1 and healthPercent >= 0.8 and abilityLevel >= 3 then
            return BOT_ACTION_DESIRE_HIGH, AbilityExtensions:FindAOELocationAtSingleTarget(npcBot, enemies[1], radius, castRange, castPoint)
        end
        if manaPercent >= 0.3 and #enemies == 1 and healthPercent >= 0.75 and abilityLevel >= 4 then
            return BOT_ACTION_DESIRE_HIGH, AbilityExtensions:FindAOELocationAtSingleTarget(npcBot, enemies[1], radius, castRange, castPoint)
        end
    end
    return 0
end
Consider[2] = function()
    local t1, t2 = ConsiderFist()
    if t1 == 0 then
        return 0
    else
        return t1, t2, "Location"
    end
end

Consider[3] = function()
    local ability = Abilities[1]
    if not ability:IsFullyCastable() or npcBot:HasModifier("modifier_ember_spirit_flame_guard") or npcBot:HasModifier("modifier_shadow_demon_purge_slow") then
        return 0
    end
    local abilityLevel = ability:GetLevel()
    local castRange = ability:GetCastRange()
    local radius = ability:GetAOERadius()
    local castPoint = ability:GetCastPoint()
    local manaCost = ability:GetManaCost()
    local duration = ability:GetDuration()
    local enemies = AbilityExtensions:GetNearbyHeroes(npcBot, radius)
    local realEnemies = AbilityExtensions:Filter(enemies, function(t) return AbilityExtensions:MayNotBeIllusion(npcBot, t) end)
    local targettableEnemies = AbilityExtensions:Filter(realEnemies, function(t) return AbilityExtensions:NormalCanCast(t) end)
    local friends = AbilityExtensions:GetNearbyHeroes(npcBot, 1200, true)
    local friendCount = AbilityExtensions:GetEnemyHeroNumber(npcBot, friends)
    local enemyCreeps = AbilityExtensions:GetNearbyAttackableCreeps(npcBot, 900)
    local friendCreeps = AbilityExtensions:GetNearbyAttackableCreeps(npcBot, npcBot:GetAttackRange()+150, false)
    local neutralCreeps = npcBot:GetNearbyNeutralCreeps(castRange)
    local weakestEnemy, enemyHealth = utility.GetWeakestUnit(targettableEnemies)
    local weakCreeps = AbilityExtensions:Filter(enemyCreeps, function(t) return t:GetHealth() < t:GetActualIncomingDamage(damage, DAMAGE_TYPE_MAGICAL) end)
    local weakestCreep = utility.GetWeakestUnit(weakCreeps)
    local forbiddenCreeps = AbilityExtensions:Filter(enemyCreeps, function(t)
        return t:GetHealth() > t:GetActualIncomingDamage(damage, DAMAGE_TYPE_MAGICAL) and t:GetHealth() <= t:GetActualIncomingDamage(damage, DAMAGE_TYPE_MAGICAL) + AbilityExtensions:AttackOnceDamage(npcBot, t) * (0.9+#enemyCreeps*0.1)
    end)
    if #friendCreeps == 0 then
        forbiddenCreeps = {}
    end
    local manaMaintain = math.min(ComboMana, npcBot:GetMaxMana() * 0.6) + manaCost
    if AbilityExtensions:IsFarmingOrPushing(npcBot) then
        if #enemies == 0 and #enemyCreeps >= 5 and mana >= manaMaintain then
            return BOT_ACTION_DESIRE_LOW
        end
    elseif AbilityExtensions:IsLaning(npcBot) then
        if #enemyCreeps >= 3 and mana >= npcBot:GetMaxMana() * 0.3 + manaCost and #enemies ~= 0 then
            local laneEnemyHero = enemies[1]
            if GetUnitToUnitDistance(npcBot, laneEnemyHero) <= radius and AbilityExtensions:GetHealthPercent(laneEnemyHero) <= 0.4 then
                return BOT_ACTION_DESIRE_MODERATE
            end
        end
    elseif AbilityExtensions:IsAttackingEnemies(npcBot) then
        if IsUsingSleightOfFist() then
            local sleightFistMarkedHeroes = AbilityExtensions:Count(enemies, function(t) return t:HasModifier("modifier_ember_spirit_sleight_of_fist_mark")  end)
            if sleightFistMarkedHeroes >= 3 then
                return BOT_ACTION_DESIRE_HIGH
            end
        else
            if not npcBot:IsMagicImmune() then
                local projectiles = AbilityExtensions:GetIncomingDodgeableProjectiles(npcBot)
                projectiles = AbilityExtensions:Any(projectiles, function(t) return GetUnitToLocationDistance(npcBot, t.location) <= 400  end)
                if projectiles then
                    return BOT_ACTION_DESIRE_MODERATE
                end
            end
            if #enemies >= 1 and DotaTime() < 10 * 60 or #realEnemies >= 2 and npcBot:GetNetWorth() / DotaTime() * 60 <= 350 or #realEnemies >= 3 then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    elseif AbilityExtensions:IsRetreating(npcBot) then
        local projectiles = AbilityExtensions:GetIncomingDodgeableProjectiles(npcBot)
        projectiles = AbilityExtensions:Any(projectiles, function(t) return GetUnitToLocationDistance(npcBot, t.location) <= 400  end)
        if projectiles then
            return BOT_ACTION_DESIRE_MODERATE
        end
    end
    do
        local target = npcBot:GetTarget()
        if target ~= nil and not AbilityExtensions:NormalCanCast(target) and GetUnitToUnitDistance(npcBot, target) < radius - 50 then
            return BOT_ACTION_DESIRE_MODERATE
        end
    end
end
--Consider[4] = function() return 0  end
--Consider[5] = function() return 0  end

AbilityExtensions:AutoModifyConsiderFunction(npcBot, Consider, Abilities)

function AbilityUsageThink()
    if npcBot:IsChanneling() or npcBot:IsSilenced() then
        return
    end
    ComboMana=450
    cast=ability_item_usage_generic.ConsiderAbility(Abilities,Consider)
    --AbilityExtensions:DebugTable(cast)
    local abilityIndex, target, castType = ability_item_usage_generic.UseAbility(Abilities,cast)
    AbilityExtensions:RecordAbility(npcBot, abilityIndex, target, castType, Abilities)
    --local records = npcBot.abilityRecords
end

function CourierUsageThink() 
	ability_item_usage_generic.CourierUsageThink()
end