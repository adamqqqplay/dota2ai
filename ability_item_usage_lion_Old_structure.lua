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
function CanCast1( npcEnemy )
	return npcEnemy:CanBeSeen() and not npcEnemy:IsMagicImmune() and not npcEnemy:IsInvulnerable();
end

function CanCast2( npcEnemy )
	return npcEnemy:CanBeSeen() and not npcEnemy:IsMagicImmune() and not npcEnemy:IsInvulnerable();
end

function CanCast3( npcEnemy )
	return npcEnemy:CanBeSeen() and not npcEnemy:IsMagicImmune() and not npcEnemy:IsInvulnerable();
end

function CanCast4( npcEnemy )
	return npcEnemy:CanBeSeen() and not npcEnemy:IsMagicImmune() and not npcEnemy:IsInvulnerable() and npcEnemy:IsHero()
end

local CanCast={CanCast1,CanCast2,CanCast3,CanCast4}

function enemyDisabled(npcEnemy)
	if npcEnemy:IsRooted( ) or npcEnemy:IsStunned( ) or npcEnemy:IsHexed( ) then
		return true;
	end
	return false;
end
--Combo Variable Getting
local function GetComboDamage()

	local sum=0
	
	if AbilitiesReal[1]:IsFullyCastable()
	then
		sum=sum+AbilitiesReal[1]:GetAbilityDamage();
	end
	if AbilitiesReal[4]:IsFullyCastable()
	then
		sum=sum+AbilitiesReal[4]:GetAbilityDamage();
	end
	
	return sum
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
	
	-- Consider using each ability
	castDesire[1], castTarget[1],castType[1]= Consider1();
	castDesire[2], castTarget[2] = Consider2();
	castDesire[3], castTarget[3] = Consider3();
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
	if ( castDesire[2] > 0 ) 
	then
		npcBot:Action_UseAbilityOnEntity( AbilitiesReal[2], castTarget[2] );
		return
	end
	
	if ( castDesire[1] > 0 ) 
	then
		if(castType[1]=="Location")
		then
			npcBot:Action_UseAbilityOnLocation( AbilitiesReal[1], castTarget[1] );
		else
			npcBot:Action_UseAbilityOnEntity( AbilitiesReal[1], castTarget[1] );		
		end

		return
	end
	
	if ( castDesire[4] > 0 ) 
	then
		npcBot:Action_UseAbilityOnEntity( AbilitiesReal[4], castTarget[4] );
		return
	end

	if ( castDesire[3] > 0 ) 
	then
		npcBot:Action_UseAbilityOnEntity( AbilitiesReal[3], castTarget[3] );
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
	
	local CastRange = ability:GetCastRange();
	local Damage = ability:GetAbilityDamage();
	local Radius = ability:GetAOERadius()
	local CastPoint=ability:GetCastPoint()
	
	local HeroHealth=10000
	local CreepHealth=10000
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange + 75*#allys,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange + 75*#allys,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------
	-- Check for a channeling enemy
	for _,npcEnemy in pairs( enemys )
	do
		if ( npcEnemy:IsChanneling() ) 
		then
			return BOT_ACTION_DESIRE_HIGH+0.05, npcEnemy,"Target";
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
					local d=GetUnitToUnitDistance(npcBot,WeakestEnemy)
					if(d<=CastRange+Radius)
					then
						return BOT_ACTION_DESIRE_HIGH,WeakestEnemy,"Target"
					else
						return BOT_ACTION_DESIRE_HIGH,utility.GetUnitsTowardsLocation(npcBot,WeakestEnemy,GetUnitToUnitDistance(npcBot,WeakestEnemy)+100),"Location"
					end
				end
			end
		end
	end
	
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	--protect myself
	do
		local enemys2 = npcBot:GetNearbyHeroes( 300, true, BOT_MODE_NONE );
		for _,npcEnemy in pairs( enemys2 )
		do
			if ( CanCast[abilityNumber]( npcEnemy ) )
			then
				return BOT_ACTION_DESIRE_HIGH, npcEnemy,"Target"
			end
		end
	end
	
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH ) 
	then
		for _,npcEnemy in pairs( enemys )
		do
			if ( npcBot:WasRecentlyDamagedByHero( npcEnemy, 2.0 ) ) 
			then
				return BOT_ACTION_DESIRE_HIGH, npcEnemy,"Target"
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
			return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc,"Location"
		end
		
		local npcEnemy = npcBot:GetTarget();

		if ( npcEnemy ~= nil ) 
		then
			if (CanCast[abilityNumber]( npcEnemy ) and not enemyDisabled(npcEnemy) and GetUnitToUnitDistance(npcBot,npcEnemy)< CastRange + 75*#allys)
			then
				return BOT_ACTION_DESIRE_MODERATE, npcEnemy,"Target"
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
					return BOT_ACTION_DESIRE_LOW,WeakestEnemy,"Target"
				end
			end
		end
	end
		
	-- If we're farming and can kill 3+ creeps with it
	if ( npcBot:GetActiveMode() == BOT_MODE_FARM ) then
		local locationAoE = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), CastRange, Radius, CastPoint, Damage );

		if ( locationAoE.count >= 3 ) then
			return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc,"Location"
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
		local locationAoE = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), CastRange, Radius, CastPoint, 0 );

		if ( locationAoE.count >= 3 ) 
		then
			return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc,"Location"
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
	
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
	-- Check for a channeling enemy
	for _,npcEnemy in pairs( enemys )
	do
		if ( npcEnemy:IsChanneling() ) 
		then
			return BOT_ACTION_DESIRE_HIGH, npcEnemy;
		end
	end
	
	--------------------------------------
	-- Mode based usage
	--------------------------------------
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
	
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH ) 
	then
		for _,npcEnemy in pairs( enemys )
		do
			if ( npcBot:WasRecentlyDamagedByHero( npcEnemy, 2.0 ) ) 
			then
				if ( CanCast2( npcEnemy ) and not enemyDisabled(npcEnemy)) 
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

function Consider3()
	local abilityNumber=3
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability=AbilitiesReal[abilityNumber];
	
	if not ability:IsFullyCastable() or AbilitiesReal[1]:IsFullyCastable() or AbilitiesReal[2]:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = ability:GetCastRange();
	local Damage = ability:GetAbilityDamage();
	local DrainMana=ability:GetSpecialValueFloat("duration")*ability:GetSpecialValueInt("mana_per_second")
	
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

	--------------------------------------
	-- Mode based usage
	--------------------------------------	
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		local BestTarget
		if(npcBot:GetMaxMana()-npcBot:GetMana()<=DrainMana and #enemys<=#allys)
		then
			for _,npcEnemy in pairs(enemys)
			do
				if ( CanCast[abilityNumber]( npcEnemy ) and npcEnemy:GetMana() > 0.5*DrainMana)
				then
					BestTarget=npcEnemy
					if(enemyDisabled(npcEnemy))
					then
						break
					end
				end
			end
			
			if ( BestTarget~=nil)
			then
				return BOT_ACTION_DESIRE_MODERATE,BestTarget;
			end
			--Creep Target--
			for _,npcEnemy in pairs(creeps)
			do
				if ( CanCast[abilityNumber]( npcEnemy ) and npcEnemy:GetMana()>0.5*DrainMana)
				then
					return BOT_ACTION_DESIRE_MODERATE+0.01,npcEnemy;
				end
			end
		end
		
	end
	
	if AbilitiesReal[1]:IsFullyCastable() or AbilitiesReal[2]:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
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
				return BOT_ACTION_DESIRE_MODERATE+0.04, npcEnemy
			end
		end
	end
	
	return BOT_ACTION_DESIRE_NONE, 0;
	
end

function Consider4()

	local ability=AbilitiesReal[4];
	
	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = ability:GetCastRange();
	local Damage = ability:GetSpecialValueInt( "damage" );
	local Radius = ability:GetSpecialValueInt( "light_strike_array_aoe" );
	
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
			if ( CanCast4( WeakestEnemy ))
			then
				if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL) or HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_MAGICAL))
				then
					return BOT_ACTION_DESIRE_HIGH,WeakestEnemy; 
				end
			end
		end
	end
	
	-- If a mode has set a target, and we can kill them, do it
	local npcTarget = npcBot:GetTarget();
	if ( npcTarget ~= nil and CanCast4( npcTarget ) )
	then
		if ( npcTarget:GetActualIncomingDamage( Damage, DAMAGE_TYPE_MAGICAL ) > npcTarget:GetHealth() and GetUnitToUnitDistance( npcTarget, npcBot ) < ( CastRange + 200 ) )
		then
			return BOT_ACTION_DESIRE_HIGH, npcTarget;
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
			if ( CanCast4( npcEnemy ) )
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
			return BOT_ACTION_DESIRE_HIGH, npcMostDangerousEnemy;
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;
	
end

function CourierUsageThink() 
	ability_item_usage_generic.CourierUsageThink()
end