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
	Abilities[3],
	Abilities[3],
	Abilities[3],
	Abilities[6],
	Abilities[3],
	Abilities[2],
	Abilities[2],
	"talent",
	Abilities[2],
	Abilities[6],
	Abilities[1],
	Abilities[1],
	"talent",
	Abilities[1],
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
local TalentTree={
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
		return Talents[7]
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
local CanCast={utility.NCanCast,utility.NCanCast,utility.NCanCast,utility.UCanCast,utility.UCanCast}
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
	
	local CastRange = ability:GetCastRange();
	local Damage = ability:GetAbilityDamage();
	local Radius = ability:GetAOERadius()
	

	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(1599,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(1599,true)
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
				if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL) or (HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana))
				then
					return BOT_ACTION_DESIRE_HIGH,WeakestEnemy:GetLocation()
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
		for _,npcEnemy in pairs( enemys )
		do
			if ( npcBot:WasRecentlyDamagedByHero( npcEnemy, 2.0 ) ) 
			then
				if ( CanCast[abilityNumber]( npcEnemy ) and not enemyDisabled(npcEnemy)) 
				then
					return BOT_ACTION_DESIRE_MODERATE, npcEnemy:GetLocation()
				end
			end
		end
	end

	-- If we're farming and can hit 2+ creeps
	if ( npcBot:GetActiveMode() == BOT_MODE_FARM )
	then
		if(ManaPercentage>0.4 or npcBot:GetMana()>ComboMana )
		then
			local locationAoE = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), CastRange, Radius, 0, 0 );
			if ( locationAoE.count >= 3 ) 
			then
				return BOT_ACTION_DESIRE_MODERATE-0.03, locationAoE.targetloc
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
		if(ManaPercentage>0.4 or npcBot:GetMana()>ComboMana )
		then
			local locationAoE = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), CastRange, Radius, 0, 0 );
			if ( locationAoE.count >= 3 ) 
			then
				return BOT_ACTION_DESIRE_MODERATE-0.03, locationAoE.targetloc
			end
		end
	end
	
		
	-- If my mana is enough,use it at enemy
	if ( npcBot:GetActiveMode() == BOT_MODE_LANING ) 
	then
		if((ManaPercentage>0.4 or npcBot:GetMana()>ComboMana) and ability:GetLevel()>=2 )
		then
			if (WeakestEnemy~=nil)
			then
				if ( CanCast[abilityNumber]( WeakestEnemy ) )
				then
					return BOT_ACTION_DESIRE_LOW,WeakestEnemy:GetLocation()
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
		local locationAoE = npcBot:FindAoELocation( true, true, npcBot:GetLocation(), CastRange, Radius, 0, 0 );
		if ( locationAoE.count >= 2 ) 
		then
			return BOT_ACTION_DESIRE_MODERATE, locationAoE.targetloc
		end
		
		local npcEnemy = npcBot:GetTarget();

		if ( npcEnemy ~= nil ) 
		then
			if ( not enemyDisabled(npcEnemy) and GetUnitToUnitDistance(npcBot,npcEnemy)< CastRange + 75*#allys)
			then
				return BOT_ACTION_DESIRE_MODERATE, npcEnemy:GetLocation()
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;
	
end

Consider[2]=function()
	local abilityNumber=2
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability=AbilitiesReal[abilityNumber];
	
	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = 0
	local Damage = ability:GetAbilityDamage()
	local Radius = ability:GetAOERadius()-50
	local CastPoint = ability:GetCastPoint()
	
	
	

	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(Radius,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(Radius,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------
	-- Check for a channeling enemy
	--[[for _,npcEnemy in pairs( enemys )
	do
		if ( npcEnemy:IsChanneling() ) 
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end]]
	
	--Try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		if (WeakestEnemy~=nil)
		then
			if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL) or GetUnitToUnitDistance(npcBot,WeakestEnemy) <= Radius-CastPoint* WeakestEnemy:GetCurrentMovementSpeed())
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	--protect myself
	if((npcBot:WasRecentlyDamagedByAnyHero(2) and #enemys>=1) or #enemys >=2)
	then
		for _,npcEnemy in pairs( enemys )
		do
			return BOT_ACTION_DESIRE_HIGH
		end
	end
	
	-- If my mana is enough,use it at enemy
	if ( npcBot:GetActiveMode() == BOT_MODE_LANING ) 
	then
		if((ManaPercentage>0.4 or npcBot:GetMana()>ComboMana))
		then
			if (WeakestEnemy~=nil)
			then
				if(GetUnitToUnitDistance(npcBot,WeakestEnemy)<Radius-CastPoint*WeakestEnemy:GetCurrentMovementSpeed())
				then
					return BOT_ACTION_DESIRE_LOW
				end
			end
		end
	end
	
	-- If we're farming and can hit 2+ creeps
	if ( npcBot:GetActiveMode() == BOT_MODE_FARM )
	then
		if ( #creeps >= 3 ) 
		then
			if(CreepHealth<=WeakestCreep:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana)
			then
				return BOT_ACTION_DESIRE_LOW
			end
		end
	end

	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT )
	then
		if ( #creeps >= 2 or #enemys >= 1 ) 
		then
			if( npcBot:GetHealth() / npcBot:GetMaxHealth() < 0.4)
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if ( npcBot:GetActiveMode() ~= BOT_MODE_NONE )
	then
		if ( #creeps >= 2 or #enemys >= 1 ) 
		then
			if( npcBot:GetHealth() / npcBot:GetMaxHealth() < 0.65 and ManaPercentage > 0.5)
			then
				return BOT_ACTION_DESIRE_MODERATE
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
	local allys = npcBot:GetNearbyHeroes( 1599, false, BOT_MODE_NONE );
	local WeakestAlly,AllyHealth=utility.GetWeakestUnit(allys)
	local allys2 = GetUnitList(UNIT_LIST_ALLIED_HEROES)
    allys2 = AbilityExtensions:Filter(allys2, function(b) return not b:IsIllusion()  end)
	local enemys = npcBot:GetNearbyHeroes(1599,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT) 
	then
		if(#enemys>=1)
		then
			if ( npcBot:GetHealth() / npcBot:GetMaxHealth() < 0.4 )
			then
				return BOT_ACTION_DESIRE_HIGH,npcBot:GetLocation()
			end
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	--teamfightUsing
	if(	npcBot:GetActiveMode() == BOT_MODE_ROAM or
		npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		npcBot:GetActiveMode() == BOT_MODE_ATTACK ) 
	then
		if (WeakestAlly~=nil)
		then
			if(AllyHealth/WeakestAlly:GetMaxHealth()<0.3+0.4*ManaPercentage) and not WeakestAlly:IsIllusion()
			then
				return BOT_ACTION_DESIRE_MODERATE,WeakestAlly:GetLocation()
			end
		end
			
		for _,npcTarget in pairs( allys )
		do
			if not npcTarget:IsIllusion() and (npcTarget:GetHealth()/npcTarget:GetMaxHealth()<(0.6+#enemys*0.05+0.2*ManaPercentage) or npcTarget:WasRecentlyDamagedByAnyHero(5.0))
			then
				if ( CanCast[abilityNumber]( npcTarget ) )
				then
					return BOT_ACTION_DESIRE_MODERATE, npcTarget:GetLocation()
				end
			end
		end
	end
	
	local WeakestAlly2=nil;
	local HighestFactor=0
	for i,npcTarget in pairs(allys2)
	do
		if(npcTarget:IsAlive() and npcTarget:DistanceFromFountain()>=1000)
		then
			local Threats=npcTarget:GetNearbyHeroes(900,true,BOT_MODE_NONE);
			local Towers=npcTarget:GetNearbyTowers(900,true);
			local TempFactor=(1-npcTarget:GetHealth()/npcTarget:GetMaxHealth())+(#Threats+#Towers)*0.05+0.05*(5-math.min(5,npcTarget:TimeSinceDamagedByAnyHero()))
			
			if TempFactor>HighestFactor
			then
				WeakestAlly2=npcTarget;
				HighestFactor=TempFactor
			end
		
			if(HighestFactor>=0.4)
			then
				if not WeakestAlly2:IsIllusion() and CanCast[abilityNumber]( npcTarget )
				then
					return BOT_ACTION_DESIRE_MODERATE, WeakestAlly2:GetLocation()
				end
			end
		end
	end
	
	if (ManaPercentage>0.4 or npcBot:GetMana()>ComboMana)
	then
		local WeakestTower=nil
		local LowestHP=1;
		for i=0,11,1 
		do
			local tower=GetTower(GetTeam(),i);
			if (tower~=nil)
			then
				local creeps_t=tower:GetNearbyCreeps(800,true)
				if(creeps_t==nil)
				then
					creeps_t={}
				end
				if (tower:IsAlive() and tower:GetHealth()/tower:GetMaxHealth()<LowestHP and #creeps_t<=2) 
				then
					LowestHP=tower:GetHealth()/tower:GetMaxHealth();
					WeakestTower=tower;
				end
			end
		end
		
		if LowestHP<0.80 then
			return BOT_ACTION_DESIRE_LOW, WeakestTower:GetLocation()
		end
	end
	
	return BOT_ACTION_DESIRE_NONE
end

Consider[6]=function()

	local abilityNumber=6
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability=AbilitiesReal[abilityNumber];
	
	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = ability:GetCastRange();
	local Radius = ability:GetAOERadius()
	

	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(Radius,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH ) 
	then
		if ( npcBot:WasRecentlyDamagedByAnyHero(2) ) 
		then
			return BOT_ACTION_DESIRE_MODERATE-0.05
		end
	end
	
	if ( npcBot:GetActiveMode() == BOT_MODE_ATTACK ) 
	then
		if ( #enemys+#allys >= 4 and #enemys >=2) 
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
			if ( npcEnemy:GetHealth()<=npcEnemy:GetActualIncomingDamage(npcBot:GetOffensivePower(),DAMAGE_TYPE_MAGICAL) and GetUnitToUnitDistance(npcEnemy,npcBot)<=Radius-200)
			then
				return BOT_ACTION_DESIRE_MODERATE
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
	local ability=AbilitiesReal[abilityNumber];
	
	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = ability:GetCastRange();
	local Damage = ability:GetAbilityDamage();
	
	local trees=npcBot:GetNearbyTrees( CastRange )
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	if ( npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		if ( #trees>=1 ) 
		then
			npcBot:Action_UseAbilityOnTree( ability, trees[1] )
			return 0;
		end
	end
	
	return BOT_ACTION_DESIRE_NONE;
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
	ability_item_usage_generic.UseAbility(AbilitiesReal,cast)
end

function CourierUsageThink() 
	ability_item_usage_generic.CourierUsageThink()
end