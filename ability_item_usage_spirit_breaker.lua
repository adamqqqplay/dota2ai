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
	Abilities[3],
	Abilities[2],
	Abilities[1],
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
function CanCast1( npcEnemy )
	return utility.NCanCast(npcEnemy) and (npcEnemy:DistanceFromFountain()>=4000 or DotaTime()>=30*60)
end

local cast={} cast.Desire={} cast.Target={} cast.Type={}
local Consider ={}
local CanCast={CanCast1,utility.NCanCast,utility.NCanCast,utility.UCanCast}
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
	
	local CastRange = 800
	local Damage = 0
	--print(ability:GetName().." :Damage is "..Damage)
	

	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local allys2= GetUnitList(UNIT_LIST_ALLIED_HEROES)
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local enemys2= GetUnitList(UNIT_LIST_ENEMY_HEROES)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local enemysAll=GetUnitList(UNIT_LIST_ENEMY_HEROES)

	if npcBot:HasModifier("modifier_spirit_breaker_charge_of_darkness")
	then
		npcBot:Action_ClearActions(false)
	end

	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------
	-- Check for a channeling enemy
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		for _,npcEnemy in pairs( enemys )
		do
			if ( npcEnemy:IsChanneling() and CanCast[abilityNumber]( npcEnemy ) ) 
			then
				return BOT_ACTION_DESIRE_HIGH, npcEnemy
			end
		end
	end
	
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
	
	--gank
	if(npcBot:GetActiveMode() == BOT_MODE_LANING or npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY and HealthPercentage>=0.7 and ManaPercentage>=0.5)
	then
		--protect teammate
		for _,npcAlly in pairs(allys2)
		do
			local enemys3=npcAlly:GetNearbyHeroes(800,true,BOT_MODE_NONE)
			local allys3=npcAlly:GetNearbyHeroes(800,false,BOT_MODE_NONE)
				
			if(npcAlly:GetActiveMode() == BOT_MODE_RETREAT )
			then
				if(#enemys3==1)
				then
					local npcEnemy=enemys3[1]
					if(npcBot:GetHealth()<npcEnemy:GetEstimatedDamageToTarget(true,npcBot,5.0,DAMAGE_TYPE_ALL) and CanCast[abilityNumber]( npcEnemy ))
					then
						return BOT_ACTION_DESIRE_HIGH+0.1,npcEnemy;
					end
				end
			end
			
			if(npcAlly:GetAssignedLane()==LANE_MID)
			then
				if(#enemys3==1)
				then
					local npcEnemy=enemys3[1]
					local sumdamage=npcBot:GetEstimatedDamageToTarget(true,npcEnemy,5.0,DAMAGE_TYPE_ALL)+100
					for _,npcAlly in pairs(allys3)
					do
						if(npcAlly:GetHealth()/npcAlly:GetMaxHealth()>=0.7 and npcAlly:GetActiveMode() ~= BOT_MODE_RETREAT)
						then
							sumdamage=sumdamage+npcAlly:GetEstimatedDamageToTarget(true,npcEnemy,5.0,DAMAGE_TYPE_ALL)
						end
					end

					if(npcEnemy:GetHealth()<sumdamage*1.25 or npcEnemy:GetHealth()/npcEnemy:GetMaxHealth()<=0.6) and CanCast[abilityNumber]( npcEnemy )
					then
						return BOT_ACTION_DESIRE_HIGH+0.1,npcEnemy;
					end
				end
			end
		end
		
		--search target
		for _,npcEnemy in pairs(enemys2)
		do
			local allys3=npcEnemy:GetNearbyHeroes(1600,true,BOT_MODE_NONE)
			local enemys3=npcEnemy:GetNearbyHeroes(1600,false,BOT_MODE_NONE)
			local sumdamage=npcBot:GetEstimatedDamageToTarget(true,npcEnemy,4.0,DAMAGE_TYPE_ALL)
			
			if(#enemys3<=2)
			then
				for _,npcAlly in pairs(allys3)
				do
					if(npcAlly:GetHealth()/npcAlly:GetMaxHealth()>=0.7 and npcAlly:GetActiveMode() ~= BOT_MODE_RETREAT)
					then
						sumdamage=sumdamage+npcAlly:GetEstimatedDamageToTarget(true,npcEnemy,4.0,DAMAGE_TYPE_ALL)
					end
				end
				if(npcEnemy:GetHealth()*1.5<=sumdamage and CanCast[abilityNumber]( npcEnemy ))
				then
					return BOT_ACTION_DESIRE_HIGH+0.12,npcEnemy;
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
		local npcEnemy = AbilityExtensions:GetTargetIfGood(npcBot)
	
		
		if ( npcEnemy ~= nil and HealthPercentage>=0.7) 
		then
			local allys3=npcEnemy:GetNearbyHeroes(1200,true,BOT_MODE_NONE)
			local enemys3=npcEnemy:GetNearbyHeroes(1600,false,BOT_MODE_NONE)
			if ( CanCast[abilityNumber]( npcEnemy ) and not enemyDisabled(npcEnemy) and #enemys3<=#allys3)
			then
				return BOT_ACTION_DESIRE_MODERATE, npcEnemy
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
	
	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = ability:GetCastRange();
	local Damage = ability:GetAbilityDamage();
	

	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	-- If we're seriously retreating
	-- if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH ) 
	-- then
	-- 	if ( npcBot:WasRecentlyDamagedByAnyHero( 2.0 ) ) 
	-- 	then
	-- 		return BOT_ACTION_DESIRE_HIGH, npcEnemy;
	-- 	end
	-- end

	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		 npcBot:GetActiveMode() == BOT_MODE_ATTACK ) 
	then
		local npcEnemy = npcBot:GetTarget();
		
		if(ManaPercentage>0.4 or npcBot:GetMana()>ComboMana)
		then
			if ( npcEnemy ~= nil ) 
			then
				if ( GetUnitToUnitDistance(npcBot,npcEnemy)< CastRange + 75*#allys)
				then
					return BOT_ACTION_DESIRE_MODERATE
				end
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
	
	if not ability:IsFullyCastable() or AbilityExtensions:CannotTeleport(npcBot) then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = ability:GetCastRange();
	local Damage = ability:GetAbilityDamage();
	

	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
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