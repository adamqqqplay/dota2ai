----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.1 NewStructure
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
	Abilities[3],
	Abilities[2],
	Abilities[2],
	Abilities[2],
	Abilities[4],
	Abilities[2],
	Abilities[1],
	Abilities[1],
	"talent",
	Abilities[1],
	Abilities[4],
	Abilities[3],
	Abilities[3],
	"talent",
	Abilities[3],
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
		return Talents[1]
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

local CanCast={utility.NCanCast,utility.NCanCast,function(t)
	if not AbilityExtensions:AllyCanCast(t) or AbilityExtensions:MustBeIllusion(npcBot, t) and not AbilityExtensions:IsTempestDouble(t) or not AbilityExtensions:IsHero(t) and not AbilityExtensions:IsLoneDruidBear(t) then
		return false
	end
	if AbilityExtensions:DontInterruptAlly(t) then
		if t:HasModifier("modifier_medusa_stone_gaze") and AbilityExtensions:IsRetreating(t) then
			return true
		end
		if t:HasModifier("modifier_monkey_king_fur_army_soldier_in_position") and AbilityExtensions:GetHealthPercent(t) <= 0.35 then
			return true
		end
		return false
	end
	if t:GetUnitName() == "npc_dota_hero_faceless_void" then
		local allUnits = AbilityExtensions:GetNearbyAllUnits(t, 1599)
		--  GetUnitList(UNIT_LIST_ALL)
		return AbilityExtensions:Any(allUnits, function(t)
			return t:HasModifier("modifier_faceless_void_chronosphere_freeze")
		end) or AbilityExtensions:Any(t:GetNearbyHeroes(300, true, BOT_MODE_NONE, function(t)
			return t:HasModifier("modifier_faceless_void_timelock_freeze")
		end))
	end
	return AbilityExtensions:AllyCanCast(t) and (not AbilityExtensions:DontInterruptAlly(t) or t:HasModifier("modifier_medusa_stone_gaze") and t:GetActiveMode() == BOT_MODE_RETREAT) and not t:IsChanneling()
end,function(t)
	return AbilityExtensions:SpellCanCast(t, true, true)
end}
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
	
	local enemys = npcBot:GetNearbyHeroes(AttackRange,true,BOT_MODE_NONE)
	
	-- If my mana is enough,use it at enemy TODO:Attack enemy when hero have buff
	if ( npcBot:GetActiveMode() ~= BOT_MODE_RETREAT) 
	then
		for i,npcEnemy in pairs(enemys)
		do
			if(npcBot:HasModifier("modifier_winter_wyvern_arctic_burn_flight") and npcEnemy:HasModifier("modifier_winter_wyvern_arctic_burn_slow"))
			then
				npcBot:Action_AttackUnit( npcEnemy, true )
			end
		end
	end

	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = ability:GetSpecialValueInt("attack_range_bonus")+AttackRange
	local Damage = 0
	local CastPoint = ability:GetCastPoint();
	
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
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
	
	if ( npcBot:GetActiveMode() == BOT_MODE_LANING ) 
	then
		if(ManaPercentage>0.75)
		then
			if (WeakestEnemy~=nil)
			then
				if ( CanCast[abilityNumber]( WeakestEnemy ) )
				then
					return BOT_ACTION_DESIRE_LOW
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
			if ( CanCast[abilityNumber]( npcEnemy ) and GetUnitToUnitDistance(npcBot,npcEnemy)< CastRange + 75*#allys)
			then
				return BOT_ACTION_DESIRE_MODERATE
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;
	
end

function GetAbilityTarget(npcTarget)
	local Radius=500
	local tableNearbyEnemyHeroes = npcTarget:GetNearbyHeroes( Radius, false, BOT_MODE_NONE );
	local tableNearbyEnemyCreeps = npcTarget:GetNearbyCreeps( Radius, false );
	if(tableNearbyEnemyCreeps~=nil)
	then
		for _,c in pairs(tableNearbyEnemyCreeps) 
		do
			if GetUnitToUnitDistance(c, npcTarget) < Radius  and CanCast[2]( c ) 
			then
				return BOT_ACTION_DESIRE_HIGH, c;
			end
		end
	end
	if(tableNearbyEnemyHeroes~=nil)
	then
		for _,h in pairs(tableNearbyEnemyHeroes) 
		do
			if h:GetUnitName() ~= npcTarget:GetUnitName() and  GetUnitToUnitDistance(h, npcTarget) < Radius and CanCast[2]( h ) 
			then
				return BOT_ACTION_DESIRE_HIGH, h;
			end
		end
	end
	return 0,0
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
	
	local CastRange = ability:GetCastRange();
	local Damage = ability:GetAbilityDamage();
	local CastPoint = ability:GetCastPoint();
	
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange+300,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
	local npcTarget
	--try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		if (WeakestEnemy~=nil)
		then
			if ( CanCast[abilityNumber]( WeakestEnemy ) )
			then
				if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL) or (HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana))
				then
					local desire,target=GetAbilityTarget(WeakestEnemy)
					if(desire>0)
					then
						return desire,target
					end
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
		local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( 800, true, BOT_MODE_NONE );
		for _,npcEnemy in pairs( tableNearbyEnemyHeroes )
		do
			if ( npcBot:WasRecentlyDamagedByHero( npcEnemy, 2.0 ) ) 
			then
				local desire,target=GetAbilityTarget(npcEnemy)
				if(desire>0)
				then
					return desire,target
				end
			end
		end
	end
	
	--Last hit
	if ( npcBot:GetActiveMode() == BOT_MODE_LANING ) 
	then
		if(WeakestCreep~=nil)
		then
			if((ManaPercentage>0.5 or npcBot:GetMana()>ComboMana) and GetUnitToUnitDistance(npcBot,WeakestCreep)>=AttackRange+100)
			then
				if(CreepHealth<=WeakestCreep:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL))
				then					
					local desire,target=GetAbilityTarget(WeakestCreep)
					if(desire>0)
					then
						return desire,target
					end
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
				if ( CanCast[abilityNumber]( WeakestCreep ) )
				then
					local desire,target=GetAbilityTarget(WeakestCreep)
					if(desire>0)
					then
						return desire,target
					end
				end
			end
		end
	end

	-- If we're pushing or defending a lane and can hit 3+ creeps, go for it
	if ( npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT ) 
	then
		if ( #enemys+#creeps >= 3 ) 
		then
			if (ManaPercentage>0.5 or npcBot:GetMana()>ComboMana)
			then
				if (WeakestCreep~=nil)
				then
					if ( CanCast[abilityNumber]( WeakestCreep ) )
					then
						local desire,target=GetAbilityTarget(WeakestCreep)
						if(desire>0)
						then
							return desire,target
						end
					end
				end
				if (WeakestEnemy~=nil)
				then
					if ( CanCast[abilityNumber]( WeakestEnemy ) )
					then
						local desire,target=GetAbilityTarget(WeakestEnemy)
						if(desire>0)
						then
							return desire,target
						end
					end
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
			if ( CanCast[abilityNumber]( npcEnemy )  and GetUnitToUnitDistance(npcBot,npcEnemy)< CastRange + 75*#allys)
			then
				local desire,target=GetAbilityTarget(npcEnemy)
				if(desire>0)
				then
					return desire,target
				end
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
	local allys = npcBot:GetNearbyHeroes( CastRange+300, false, BOT_MODE_NONE );
    allys = AbilityExtensions:Filter(allys, function(t)
        return AbilityExtensions:MayNotBeIllusion(npcBot, t) and not AbilityExtensions:CannotBeTargetted(t) and not AbilityExtensions:IsInvulnerable(t) and not AbilityExtensions:CannotBeKilledNormally(t)
    end)
	local WeakestAlly,AllyHealth=utility.GetWeakestUnit(allys)
	local allys2 = GetUnitList(UNIT_LIST_ALLIED_HEROES)
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	-- If we're seriously retreating
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH ) 
	then
		if ( npcBot:WasRecentlyDamagedByAnyHero( 2.0 ) ) 
		then
			return BOT_ACTION_DESIRE_HIGH,npcBot; 	
		end
	end
	
	--teamfightUsing
	if(	npcBot:GetActiveMode() == BOT_MODE_ROAM or
		npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		npcBot:GetActiveMode() == BOT_MODE_ATTACK ) 
	then
		if (WeakestAlly~=nil)
		then
			if(AllyHealth/WeakestAlly:GetMaxHealth()<0.3+0.2*ManaPercentage)
			then
				return BOT_ACTION_DESIRE_MODERATE,WeakestAlly
			end
		end
			
		for _,npcTarget in pairs( allys )
		do
			local enemys2 = npcTarget:GetNearbyHeroes(600,true,BOT_MODE_NONE)
			local healingFactor=0.2+#enemys2*0.05+0.2*ManaPercentage
			if(enemyDisabled(npcTarget))
			then
				healingFactor=healingFactor+0.1
			end
			
			if(npcTarget:GetHealth()/npcTarget:GetMaxHealth()<healingFactor and npcTarget:WasRecentlyDamagedByAnyHero(2.0) and npcTarget:GetActiveMode() ~= BOT_MODE_ATTACK)
			then
				if ( CanCast[abilityNumber]( npcTarget ) and not npcTarget:IsChanneling())
				then
					return BOT_ACTION_DESIRE_MODERATE, npcTarget
				end
			end
		end
	end
	
	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_LANING or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT) 
	then
		for _,npcTarget in pairs( allys )
		do
			if npcTarget:GetHealth()/npcTarget:GetMaxHealth()<(0.35+0.4*ManaPercentage) and npcTarget:WasRecentlyDamagedByAnyHero(3)
			then
				if ( CanCast[abilityNumber]( npcTarget ) and not npcTarget:IsChanneling() )
				then
					return BOT_ACTION_DESIRE_MODERATE, npcTarget
				end
			end
		end
	end
	
	return BOT_ACTION_DESIRE_NONE, 0;
	
end

local function CanBeAffectedByCurse(t)
	return AbilityExtensions:SpellCanCast(t, false, false)
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
	local Radius = ability:GetAOERadius();
	local Duration = ability:GetSpecialValueFloat("duration");
	
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
		if ( npcEnemy:IsChanneling() and CanCast[abilityNumber]( npcEnemy ) and #allys<#enemys) 
		then
			return BOT_ACTION_DESIRE_HIGH, npcEnemy
		end
	end
	
	if(enemys~=nil and #enemys==1)
	then
		return 0
	end
	
	--Try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		local BestTarget=nil
		local BestTargetScore=0
		for i,npcEnemy in pairs(enemys)
		do
			local sumdamage=0
			local enemys2 = npcEnemy:GetNearbyHeroes(Radius,true,BOT_MODE_NONE)
			local creeps2 = npcEnemy:GetNearbyCreeps(Radius,true)
			if(npcEnemy~=nil)
			then
				for j,npcEnemyAttacker in pairs(enemys2)
				do
					if(npcEnemy~=npcEnemyAttacker)
					then
						sumdamage=sumdamage+npcEnemyAttacker:GetEstimatedDamageToTarget(true,npcEnemy,Duration,DAMAGE_TYPE_PHYSICAL)
					end
				end
				for j,npcEnemyAttacker in pairs(creeps2)
				do
					sumdamage=sumdamage+npcEnemyAttacker:GetEstimatedDamageToTarget(true,npcEnemy,Duration,DAMAGE_TYPE_PHYSICAL)
				end
				if(sumdamage/npcEnemy:GetHealth()>BestTargetScore)
				then
					BestTargetScore=sumdamage/npcEnemy:GetHealth()
					BestTarget=npcEnemy
				end
			end
		end
		
		if(BestTargetScore>=1.05 and BestTarget~=nil)
		then
			return BOT_ACTION_DESIRE_HIGH, BestTarget
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
				if ( CanCast[abilityNumber]( npcEnemy ) and not enemyDisabled(npcEnemy) and #allys<=1) 
				then
					return BOT_ACTION_DESIRE_HIGH, npcEnemy;
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;

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