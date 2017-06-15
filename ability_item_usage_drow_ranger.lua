----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.1
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
--------------------------------------
-- Load Utility Function Library
--------------------------------------
require(GetScriptDirectory() ..  "/utility")
require(GetScriptDirectory() ..  "/ability_item_usage_generic")
--------------------------------------
-- Hero Area Local Variable Setting
--------------------------------------
local npcBot = GetBot()
local ComboMana = 0
local debugmode=false

local Talents ={}
local Abilities ={}
local AbilitiesReal ={}

for i=0,23,1 do
	local ability=npcBot:GetAbilityInSlot(i)
	if(ability~=nil)
	then
		if(ability:IsTalent()==true)
		then
			table.insert(Talents,ability:GetName())
		else
			table.insert(Abilities,ability:GetName())
			table.insert(AbilitiesReal,ability)
		end
	end
end

local AbilityToLevelUp=
{
	Abilities[1],
	Abilities[3],
	Abilities[1],
	Abilities[2],
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
		return Talents[4]
	end,
	function()
		return Talents[5]
	end,
	function()
		return Talents[8]
	end
}
--------------------------------------
-- Level Ability and Talent
--------------------------------------

-- check skill build vs current level
utility.CheckAbilityBuild(AbilityToLevelUp)

function AbilityLevelUpThink()
	ability_item_usage_generic.AbilityLevelUpThink2(AbilityToLevelUp,TalentTree)
end

--------------------------------------
-- Ability Usage Thinking
--------------------------------------
local castDesire = {}
local castTarget = {}
local castType = {}

--Target Judement
local CanCast={utility.NCanCast,utility.NCanCast,utility.NCanCast,utility.NCanCast}
local enemyDisabled=utility.enemyDisabled

--Combo Variable Getting
local function GetComboDamage()
	return npcBot:GetOffensivePower()
end

local function GetComboMana()
	
	local tempComboMana=0
	if AbilitiesReal[1]:IsFullyCastable()
	then
		tempComboMana=tempComboMana+AbilitiesReal[1]:GetManaCost()
	end
	if AbilitiesReal[2]:IsFullyCastable()
	then
		tempComboMana=tempComboMana+AbilitiesReal[2]:GetManaCost()
	end
	
	if AbilitiesReal[1]:GetLevel()<1 or AbilitiesReal[2]:GetLevel()<1
	then
		tempComboMana=200;
	end
	
	ComboMana=tempComboMana
	return
end

function AbilityUsageThink()

	-- Check if we're already using an ability
	if ( npcBot:IsUsingAbility() or npcBot:IsChanneling() or npcBot:IsSilenced() )
	then 
		return
	end
	
	GetComboMana()
	AttackRange=npcBot:GetAttackRange()
	ManaPercentage=npcBot:GetMana()/npcBot:GetMaxMana()
	HealthPercentage=npcBot:GetHealth()/npcBot:GetMaxHealth()
	
	-- Consider using each ability
	castDesire[1], castTarget[1], castType[1] = Consider1();
	castDesire[2], castTarget[2], castType[2] = Consider2();
	castDesire[3], castTarget[3], castType[3] = Consider3();
	castDesire[4], castTarget[4], castType[4] = 0
	---------------------------------debug--------------------------------------------
	if(debugmode==true) then
			for i=1,#AbilitiesReal
			do					
				if ( castDesire[i] > 0 ) 
				then
					if (castType[i]==nil or castType[i]=="target") and castTarget[i]~=nil
					then
						utility.DebugTalk("try to use skill "..i.." at "..castTarget[i]:GetUnitName().." Desire= "..castDesire[i])
					else
						utility.DebugTalk("try to use skill "..i.." Desire= "..castDesire[i])
					end
				end
			end
	end
	---------------------------------debug--------------------------------------------
	local HighestDesire=0
	local HighestDesireAbility=0
	local HighestDesireAbilityBumber=0
	for i,ability in pairs(AbilitiesReal)
	do
		if (castDesire[i]>HighestDesire)
		then
			HighestDesire=castDesire[i]
			HighestDesireAbilityBumber=i
		end
	end
	if( HighestDesire>0)
	then
		local j=HighestDesireAbilityBumber
		local ability=AbilitiesReal[j]
		
				if(castType[j]==nil)
				then
					if(utility.CheckFlag(ability:GetBehavior(),ABILITY_BEHAVIOR_NO_TARGET))
					then
						npcBot:Action_UseAbility( ability )
						return
					elseif(utility.CheckFlag(ability:GetBehavior(),ABILITY_BEHAVIOR_POINT))
					then
						npcBot:Action_UseAbilityOnLocation( ability , castTarget[j])
						return
					else
						npcBot:Action_UseAbilityOnEntity( ability , castTarget[j])
						return
					end
				else
					if(castType[j]=="Target")
					then
						npcBot:Action_UseAbilityOnEntity( ability , castTarget[j])
						return
					elseif(castType[j]=="Location")
					then
						npcBot:Action_UseAbilityOnLocation( ability , castTarget[j])
						return
					else
						npcBot:Action_UseAbility( ability )
						return
					end
				end
	end
end


function Consider1()
	local abilityNumber=1
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability=AbilitiesReal[abilityNumber];
	
	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = ability:GetCastRange();
	local Damage = 0
	
	local HeroHealth=10000
	local CreepHealth=10000
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange+100,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyLaneCreeps(CastRange+100,true)
	local creeps2 = npcBot:GetNearbyLaneCreeps(300,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
	
	if(ability:GetToggleState()==false)
	then
		local t=npcBot:GetAttackTarget()
		if(t~=nil)
		then
			if (t:IsHero())
			then
				ability:ToggleAutoCast()
				return BOT_ACTION_DESIRE_NONE, 0;
			end
		end
	else
		local t=npcBot:GetAttackTarget()
		if(t~=nil)
		then
			if (not t:IsHero())
			then
				ability:ToggleAutoCast()
				return BOT_ACTION_DESIRE_NONE, 0;
			end
		end
	end
	
	--try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT) 
	then
		if (WeakestEnemy~=nil)
		then
			if ( CanCast[abilityNumber]( WeakestEnemy ) )
			then
				if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_ALL))
				then
					return BOT_ACTION_DESIRE_HIGH,WeakestEnemy; 
				end
			end
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	if ( npcBot:GetActiveMode() == BOT_MODE_LANING ) 
	then
		if(CreepHealth>=300 and ManaPercentage>=0.5 and HealthPercentage>=0.6 and #creeps2<=1)
		then
			if (WeakestEnemy~=nil)
			then
				if ( CanCast[abilityNumber]( WeakestEnemy ) )
				then
					return BOT_ACTION_DESIRE_LOW-0.01,WeakestEnemy
				end
			end
		end
	end
	
	-- If we're farming
	if ( npcBot:GetActiveMode() == BOT_MODE_FARM )
	then
		if(WeakestCreep~=nil)
		then
			if(WeakestCreep:HasModifier("modifier_drow_ranger_frost_arrows_slow")==false)
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
			if ( CanCast[abilityNumber]( npcEnemy )  and GetUnitToUnitDistance(npcBot,npcEnemy)< CastRange+100)
			then
				return BOT_ACTION_DESIRE_MODERATE, npcEnemy;
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;
	
end

function Consider2()
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
	local Radius = ability:GetAOERadius()
	local CastPoint=ability:GetCastPoint()
	
	local HeroHealth=10000
	local CreepHealth=10000
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange+300,true)
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
					return BOT_ACTION_DESIRE_HIGH,utility.GetUnitsTowardsLocation(npcBot,WeakestEnemy,GetUnitToUnitDistance(npcBot,WeakestEnemy)+100); 
				end
			end
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if ( (npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH ) or (npcBot:WasRecentlyDamagedByAnyHero(2.0) and #enemys>=1) ) 
	then
		local locationAoE = npcBot:FindAoELocation( false, true, npcBot:GetLocation(), CastRange, Radius, CastPoint, 0 );
		if ( locationAoE.count >= 2 ) 
		then
			return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc
		end
		
		for _,npcEnemy in pairs( enemys )
		do
			if ( npcBot:WasRecentlyDamagedByHero( npcEnemy, 3.0 ) and GetUnitToUnitDistance(npcBot,npcEnemy)<= 400) 
			then
				return BOT_ACTION_DESIRE_HIGH, npcEnemy:GetExtrapolatedLocation( CastPoint ) 
			end
		end
	end
	
	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		 npcBot:GetActiveMode() == BOT_MODE_ATTACK ) 
	then
		local locationAoE = npcBot:FindAoELocation( false, true, npcBot:GetLocation(), CastRange, Radius, CastPoint, 0 );
		if ( locationAoE.count >= 2 ) 
		then
			return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc
		end
		
		local npcEnemy = npcBot:GetTarget();

		if ( npcEnemy ~= nil ) 
		then
			if (CanCast[abilityNumber]( npcEnemy ) and not enemyDisabled(npcEnemy) and GetUnitToUnitDistance(npcBot,npcEnemy)<= CastRange)
			then
				return BOT_ACTION_DESIRE_MODERATE, utility.GetUnitsTowardsLocation(npcBot,npcEnemy,GetUnitToUnitDistance(npcBot,npcEnemy)+100)
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;
	
end

function Consider3()
	local abilityNumber=3
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability=AbilitiesReal[abilityNumber];
	
	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	-- If we're pushing or defending a lane and can hit 3+ creeps, go for it
	if ( npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT ) 
	then
		return BOT_ACTION_DESIRE_LOW
	end

	return BOT_ACTION_DESIRE_NONE, 0;
	
end

function CourierUsageThink() 
	ability_item_usage_generic.CourierUsageThink()
end