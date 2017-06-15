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
local AbilitiesRefer =
{
	"life_stealer_rage",
	"life_stealer_feast",
	"life_stealer_open_wounds",
	"life_stealer_assimilate",
	"life_stealer_assimilate_eject",
	"life_stealer_infest",
	"life_stealer_control",
	"life_stealer_consume"
}
local AbilityToLevelUp=
{
	Abilities[2],
	Abilities[3],
	Abilities[1],
	Abilities[3],
	Abilities[3],
	Abilities[6],
	Abilities[3],
	Abilities[1],
	Abilities[1],
	"talent",
	Abilities[1],
	Abilities[6],
	Abilities[2],
	Abilities[2],
	"talent",
	Abilities[2],
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
		return Talents[4]
	end,
	function()
		return Talents[6]
	end,
	function()
		return Talents[7]
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

local CanCast={utility.NCanCast,utility.NCanCast,utility.NCanCast,utility.NCanCast,utility.NCanCast,utility.NCanCast,utility.NCanCast,utility.NCanCast}
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
	if AbilitiesReal[3]:IsFullyCastable()
	then
		tempComboMana=tempComboMana+AbilitiesReal[3]:GetManaCost()
	end	
	if AbilitiesReal[4]:IsFullyCastable() or AbilitiesReal[4]:GetCooldownTimeRemaining()<=30
	then
		tempComboMana=tempComboMana+AbilitiesReal[4]:GetManaCost()
	end
	
	if AbilitiesReal[1]:GetLevel()<1 or AbilitiesReal[3]:GetLevel()<1 or AbilitiesReal[4]:GetLevel()<1
	then
		tempComboMana=300;
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
	castDesire[2]=0
	castDesire[3], castTarget[3], castType[3] = Consider3();
	castDesire[4]=0
	castDesire[5]=0
	castDesire[6], castTarget[6], castType[6] = Consider6();
	castDesire[7]=0
	castDesire[8], castTarget[8], castType[8] = Consider8();	
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
	
	local CastRange = 400
	local Damage = ability:GetAbilityDamage();
	local CastPoint = ability:GetCastPoint();
	
	local HeroHealth=10000
	local CreepHealth=10000
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

function Consider3()

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
	local CastPoint = ability:GetCastPoint();
	
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

function Consider6()

	local abilityNumber=6
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
	local Radius = ability:GetAOERadius()
	
	local HeroHealth=10000
	local CreepHealth=10000
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local StrongestAlly,AllyHealth=utility.GetStrongestUnit(allys)
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange+300,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
	local StrongestCreep,CreepHealthEnemy=utility.GetStrongestUnit(creeps)
	local creepsAlly = npcBot:GetNearbyCreeps(CastRange+300,false)
	local StrongestCreepAlly,CreepHealthAlly=utility.GetStrongestUnit(creepsAlly)
	for _,hero in pairs (allys)
	do
		if (hero==npcBot)
		then
			table.remove(allys,_)
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
				local allys2 = WeakestEnemy:GetNearbyHeroes( Radius-50, true, BOT_MODE_NONE );
				if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana)
				then
					return BOT_ACTION_DESIRE_HIGH,allys2[#allys2]; 
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

	return BOT_ACTION_DESIRE_NONE, 0;
	
end

function Consider8()

	local abilityNumber=8
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability=AbilitiesReal[abilityNumber];
	
	if (not ability:IsFullyCastable() or ability:IsHidden()) then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = ability:GetCastRange();
	local Damage = ability:GetAbilityDamage();
	local CastPoint = ability:GetCastPoint();
	local Radius = 600
	
	local HeroHealth=10000
	local CreepHealth=10000
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
		if ( #enemys == 0 or AbilitiesReal[1]:IsFullyCastable() ) 
		then
			return BOT_ACTION_DESIRE_HIGH;
		end
	end
	
	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_GANK or
		 npcBot:GetActiveMode() == BOT_MODE_ATTACK or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY ) 
	then
		local npcTarget = npcBot:GetTarget();
		if ( npcTarget~= nil and GetUnitToUnitDistance( npcTarget, npcBot ) < Radius )
		then
			return BOT_ACTION_DESIRE_ABSOLUTE;
		end
	end

	return BOT_ACTION_DESIRE_NONE;
	
end

function CourierUsageThink() 
	ability_item_usage_generic.CourierUsageThink()
end