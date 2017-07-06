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
local debugmode=false

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
	Abilities[2],
	Abilities[1],
	Abilities[2],
	Abilities[2],
	Abilities[4],
	Abilities[2],
	Abilities[3],
	Abilities[3],
	"talent",
	Abilities[3],
	Abilities[4],
	Abilities[1],
	Abilities[1],
	"talent",
	Abilities[1],
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
	if AbilitiesReal[2]:IsFullyCastable()
	then
		tempComboMana=tempComboMana+AbilitiesReal[2]:GetManaCost()
	end
	if AbilitiesReal[4]:IsFullyCastable() or AbilitiesReal[4]:GetCooldownTimeRemaining()<=30
	then
		tempComboMana=tempComboMana+AbilitiesReal[4]:GetManaCost()
	end
	
	if AbilitiesReal[1]:GetLevel()<1 or AbilitiesReal[2]:GetLevel()<1 or AbilitiesReal[4]:GetLevel()<1
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
	
	local i=npcBot:FindItemSlot("item_blink")
	if(i>=0 and i<=5)
	then
		blink=npcBot:GetItemInSlot(i)
		i=nil
	end
	
	-- Consider using each ability
	castDesire[1], castTarget[1],castType[1] = Consider1();
	castDesire[2] = Consider2();
	castDesire[3]=0;
	castDesire[4] = Consider4();
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
	if ( castDesire[2] > 0 ) 
	then
		npcBot:Action_UseAbility( AbilitiesReal[2] );
		return
	end

	if ( castDesire[1] > 0 ) 
	then		
		if(castTarget[1]=="immediately")
		then
			npcBot:Action_UseAbility( AbilitiesReal[1] );
			return
		end
		
		if(castType[1]=="blink")
		then
			npcBot:Action_UseAbilityOnLocation( blink, castTarget[1] );
			--[[if(GetUnitToLocationDistance(npcBot,castTarget[1])<= AbilitiesReal[1]:GetAOERadius())
			then
				npcBot:Action_UseAbility( AbilitiesReal[1] );
			end]]--
			return
		else
			if(castTarget[1]~=nil and GetUnitToUnitDistance(npcBot,castTarget[1])>=300 and GetUnitToUnitDistance(npcBot,castTarget[1])<=1200 and blink~=nil and blink:IsFullyCastable())
			then
				npcBot:Action_UseAbilityOnLocation( blink, castTarget[1]:GetLocation() );
			end
			if(GetUnitToUnitDistance(npcBot,castTarget[1])< AbilitiesReal[1]:GetAOERadius()-AbilitiesReal[1]:GetCastPoint()*castTarget[1]:GetCurrentMovementSpeed())
			then
				npcBot:Action_UseAbility( AbilitiesReal[1] );
				return
			end
		end
	end
	
	if ( castDesire[4] > 0 ) 
	then
		npcBot:Action_UseAbility( AbilitiesReal[4] );
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
	
	local CastRange = 0
	local Damage = ability:GetAbilityDamage()
	local Radius = ability:GetAOERadius()
	local CastPoint = ability:GetCastPoint()
	
	if(blink~=nil and blink:IsFullyCastable())
	then
		CastRange=CastRange+1200
		if(npcBot:GetActiveMode() == BOT_MODE_ATTACK ) 
		then
			local locationAoE = npcBot:FindAoELocation( false, true, npcBot:GetLocation(), CastRange, Radius, 0, 0 );
			if ( locationAoE.count >= 2 ) 
			then
				return BOT_ACTION_DESIRE_HIGH+0.05, locationAoE.targetloc,"blink";
			end
		end
	end
	
	local HeroHealth=10000
	local CreepHealth=10000
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(Radius,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(Radius+300,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------
	-- Check for a channeling enemy
	for _,npcEnemy in pairs( enemys )
	do
		if ( npcEnemy:IsChanneling() and CanCast[abilityNumber]( npcEnemy )) 
		then
			return BOT_ACTION_DESIRE_HIGH,npcEnemy
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
					return BOT_ACTION_DESIRE_HIGH,WeakestEnemy
				end
			end
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	--protect myself
	if(npcBot:WasRecentlyDamagedByAnyHero(2) or #enemys >=2)
	then
		for _,npcEnemy in pairs( enemys )
		do
			if ( CanCast[abilityNumber]( npcEnemy ) )
			then
				return BOT_ACTION_DESIRE_HIGH,"immediately"
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
					if(GetUnitToUnitDistance(npcBot,WeakestEnemy)<Radius-CastPoint*WeakestEnemy:GetCurrentMovementSpeed())
					then
						return BOT_ACTION_DESIRE_LOW,WeakestEnemy
					end
				end
			end
		end
	end
	
	-- If we're farming and can hit 2+ creeps
	if ( npcBot:GetActiveMode() == BOT_MODE_FARM )
	then
		if ( #creeps >= 2 ) 
		then
			if(CreepHealth<=WeakestCreep:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana)
			then
				return BOT_ACTION_DESIRE_LOW,WeakestCreep
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
			if ( CanCast[abilityNumber]( npcEnemy ) and not enemyDisabled(npcEnemy) and GetUnitToUnitDistance(npcBot,npcEnemy)<=Radius)
			then
				return BOT_ACTION_DESIRE_MODERATE,npcEnemy
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
	
	if not ability:IsFullyCastable() or npcBot:HasModifier("modifier_ursa_overpower") then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = 300
	
	local HeroHealth=10000
	local CreepHealth=10000
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange+300,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
	
	--Try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		if (WeakestEnemy~=nil)
		then
			if ( CanCast[abilityNumber]( WeakestEnemy ) )
			then
				if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana)
				then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	-- If we're roshaning
	if ( npcBot:GetActiveMode() == BOT_MODE_ROSHAN ) 
	then
		local npcTarget = npcBot:GetTarget();
		local t=npcBot:GetAttackTarget()
		if ( npcTarget ~= nil and t~=nil )
		then
			return BOT_ACTION_DESIRE_MODERATE;
		end
	end
	
	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		 npcBot:GetActiveMode() == BOT_MODE_ATTACK ) 
	then
		local npcEnemy = npcBot:GetTarget();

		if ( npcEnemy ~= nil and GetUnitToUnitDistance(npcBot,npcEnemy)<=1600) 
		then
			return BOT_ACTION_DESIRE_MODERATE
		end
	end
	
	-- If we're pushing or defending a lane
	if ( npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT ) 
	then
		local t=npcBot:GetAttackTarget()
		if(t~=nil)
		then
			if (ManaPercentage>0.4 and t:IsTower())
				then
			return BOT_ACTION_DESIRE_MODERATE, npcBot
			end
		end
	end
	
	-- If we're farming
	if ( npcBot:GetActiveMode() == BOT_MODE_FARM ) 
	then
		if (ManaPercentage>0.4 or npcBot:GetMana()>ComboMana)
		then
			return BOT_ACTION_DESIRE_LOW;
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
	local Radius = ability:GetAOERadius()
	
	local HeroHealth=10000
	local CreepHealth=10000
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange+300,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
	
	--Try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		if (WeakestEnemy~=nil and HealthPercentage<=0.4+0.05*#enemys)
		then
			if ( CanCast[abilityNumber]( WeakestEnemy ) )
			then
				if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana)
				then
					return BOT_ACTION_DESIRE_HIGH
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
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end
	
	-- If we're roshaning
	if ( npcBot:GetActiveMode() == BOT_MODE_ROSHAN ) 
	then
		local npcTarget = npcBot:GetTarget();
		local t=npcBot:GetAttackTarget()
		if ( npcTarget ~= nil and t~=nil )
		then
			return BOT_ACTION_DESIRE_MODERATE;
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
			if(GetUnitToUnitDistance(npcBot,npcEnemy)<=400)
			then
				return BOT_ACTION_DESIRE_MODERATE
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;
	
end

function CourierUsageThink() 
	ability_item_usage_generic.CourierUsageThink()
end