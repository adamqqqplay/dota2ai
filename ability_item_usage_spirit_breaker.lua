----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0
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
local debugmode=utility.debug_mode

local Talents ={}
local Abilities ={}

for i=0,23,1 do
	local ability=npcBot:GetAbilityInSlot(i)
	if(ability~=nil)
	then
		if(ability:IsTalent()==true)
		then
			table.insert(Talents,ability:GetName())
		else
			table.insert(Abilities,ability:GetName())
		end
	end
end

local AbilitiesReal =
{
	npcBot:GetAbilityByName(Abilities[1]),
	npcBot:GetAbilityByName(Abilities[2]),
	npcBot:GetAbilityByName(Abilities[3]),
	npcBot:GetAbilityByName(Abilities[4])
}

local AbilityToLevelUp=
{
	Abilities[3],
	Abilities[1],
	Abilities[2],
	Abilities[3],
	Abilities[3],
	Abilities[4],
	Abilities[3],
	Abilities[1],
	Abilities[1],
	"talent",
	Abilities[1],
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
		return Talents[5]
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
local castLocation = {}
local castType = {}

--Target Judement
local CanCast={utility.NCanCast,utility.NCanCast,utility.NCanCast,utility.UCanCast}

function enemyDisabled(npcEnemy)
	if npcEnemy:IsRooted( ) or npcEnemy:IsStunned( ) or npcEnemy:IsHexed( ) then
		return true;
	end
	return false;
end
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
	if AbilitiesReal[4]:IsFullyCastable() or AbilitiesReal[4]:GetCooldownTimeRemaining()<=30
	then
		tempComboMana=tempComboMana+AbilitiesReal[4]:GetManaCost()
	end
	
	if AbilitiesReal[1]:GetLevel()<1 or AbilitiesReal[4]:GetLevel()<1
	then
		tempComboMana=200;
	end
	
	ComboMana=tempComboMana
	return
end

function AbilityUsageThink()

	-- Check if we're already using an ability
	if ( npcBot:IsUsingAbility() or npcBot:IsChanneling() or npcBot:IsSilenced() or npcBot:HasModifier("modifier_spirit_breaker_charge_of_darkness") )
	then 
		return
	end
	
	GetComboMana()
	AttackRange=npcBot:GetAttackRange()
	ManaPercentage=npcBot:GetMana()/npcBot:GetMaxMana()
	HealthPercentage=npcBot:GetHealth()/npcBot:GetMaxHealth()
	
	-- Consider using each ability
	castDesire[1], castTarget[1] = Consider1();
	castDesire[2]= Consider2();
	castDesire[3]=0
	castDesire[4], castTarget[4] = Consider4();
	---------------------------------debug--------------------------------------------
	if(debugmode==true) then
		if(npcBot.LastSpeaktime==nil)
		then
			npcBot.LastSpeaktime=0
		end
		if(GameTime()-npcBot.LastSpeaktime>1)
		then
			for i=1,4,1
			do					
				if ( castDesire[i] > 0 ) 
				then
					if (castType[i]==nil or castType[i]=="target") and castTarget[i]~=nil
					then
						npcBot:ActionImmediate_Chat("try to use skill "..i.." at "..castTarget[i]:GetUnitName().." Desire= "..castDesire[i],true)
					else
						npcBot:ActionImmediate_Chat("try to use skill "..i.." Desire= "..castDesire[i],true)
					end
					npcBot.LastSpeaktime=GameTime()
				end
			end
		end
	end
	---------------------------------debug--------------------------------------------
	if ( castDesire[4] > 0 ) 
	then
		npcBot:Action_UseAbilityOnEntity( AbilitiesReal[4],castTarget[4]);
		return
	end
	
	if ( castDesire[2] > 0 ) 
	then
		npcBot:Action_UseAbility( AbilitiesReal[2] );
		return
	end

	if ( castDesire[1] > 0 ) 
	then
		npcBot:Action_ClearActions(true)
		npcBot:Action_UseAbilityOnEntity( AbilitiesReal[1], castTarget[1] );
		npcBot.SBTarget=castTarget[1]
		return
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
	
	local CastRange = 1300
	local Damage = 0
	--print(ability:GetName().." :Damage is "..Damage)
	
	local HeroHealth=10000
	local CreepHealth=10000
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local allys2= GetUnitList(UNIT_LIST_ALLIED_HEROES)
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local enemys2= GetUnitList(UNIT_LIST_ENEMY_HEROES)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local enemysAll=GetUnitList(UNIT_LIST_ENEMY_HEROES)
	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------
	-- Check for a channeling enemy
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		for _,npcEnemy in pairs( enemys )
		do
			if ( npcEnemy:IsChanneling() and CanCast[abilityNumber]( npcEnemy )) 
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
			local enemys3=npcAlly:GetNearbyHeroes(1600,true,BOT_MODE_NONE)
			local allys3=npcAlly:GetNearbyHeroes(1600,false,BOT_MODE_NONE)
				
			if(npcAlly:GetActiveMode() == BOT_MODE_RETREAT )
			then
				if(#enemys3==1)
				then
					local npcEnemy=enemys3[1]
					if(npcBot:GetHealth()<npcEnemy:GetEstimatedDamageToTarget(true,npcBot,5.0,DAMAGE_TYPE_ALL))
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

					if(npcEnemy:GetHealth()<sumdamage*1.25 or npcEnemy:GetHealth()/npcEnemy:GetMaxHealth()<=0.6)
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
				if(npcEnemy:GetHealth()*1.1<=sumdamage)
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
		local npcEnemy = npcBot:GetTarget();
	
		
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

function Consider2()		--Target AOE Ability Example
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
	
	local HeroHealth=10000
	local CreepHealth=10000
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	-- If we're seriously retreating
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH ) 
	then
		if ( npcBot:WasRecentlyDamagedByAnyHero( 2.0 ) ) 
		then
			return BOT_ACTION_DESIRE_HIGH, npcEnemy;
		end
	end

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

function Consider4()
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
	
	local HeroHealth=10000
	local CreepHealth=10000
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

function CourierUsageThink() 
	ability_item_usage_generic.CourierUsageThink()
end