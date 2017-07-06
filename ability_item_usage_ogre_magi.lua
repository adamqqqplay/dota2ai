----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
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
		end
	end
end

local Abilities =
{
	"ogre_magi_fireblast",
	"ogre_magi_ignite",
	"ogre_magi_bloodlust",
	"ogre_magi_multicast",
	"ogre_magi_unrefined_fireblast",
}

local AbilitiesReal =
{
	npcBot:GetAbilityByName(Abilities[1]),
	npcBot:GetAbilityByName(Abilities[2]),
	npcBot:GetAbilityByName(Abilities[3]),
	npcBot:GetAbilityByName(Abilities[4]),
	npcBot:GetAbilityByName(Abilities[5])
}

local AbilityToLevelUp=
{
	Abilities[2],
	Abilities[1],
	Abilities[2],
	Abilities[3],
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
		return Talents[2]
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

utility.CheckAbilityBuild(AbilityToLevelUp)

function AbilityLevelUpThink()
	ability_item_usage_generic.AbilityLevelUpThink2(AbilityToLevelUp,TalentTree)
end

local cast1Desire = 0;
local cast2Desire = 0;
local cast3Desire = 0;
local cast5Desire = 0;
----------------------------------------------------------------------------------------------------

function CanCast3( npcTarget )
	return not npcTarget:IsInvulnerable();
end

local CanCast1=utility.NCanCast
local CanCast2=utility.NCanCast
local CanCast4=utility.NCanCast
local CanCast5=utility.NCanCast

function enemyDisabled(npcTarget)
	if npcTarget:IsRooted( ) or npcTarget:IsStunned( ) or npcTarget:IsHexed( ) then
		return true;
	end
	return false;
end
----------------------------------------------------------------------------------------------------
local function GetComboDamage()

	local sum=0
	
	if AbilitiesReal[1]:IsFullyCastable()
	then
		sum=sum+AbilitiesReal[1]:GetAbilityDamage();
	end
	if AbilitiesReal[2]:IsFullyCastable()
	then
		sum=sum+(18+8*AbilitiesReal[2]:GetLevel())*(4+AbilitiesReal[2]:GetLevel());
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
	
	if AbilitiesReal[1]:GetLevel()<1 or AbilitiesReal[2]:GetLevel()<1
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
	
	-- Consider using each ability
	cast1Desire, cast1Target = Consider1();
	cast2Desire, cast2Target = Consider2();
	cast3Desire, cast3Target = Consider3();
	cast5Desire, cast5Target = Consider5();
	--[[---------------------------------debug--------------------------------------------
	if(npcBot.LastSpeaktime==nil)
	then
		npcBot.LastSpeaktime=0
	end
	if(GameTime()-npcBot.LastSpeaktime>1)
	then
		if ( cast5Desire > 0 ) 
		then
			npcBot:ActionImmediate_Chat("try to use skill 5 at "..cast5Target:GetUnitName().." Desire= "..cast5Desire,true)
			npcBot.LastSpeaktime=GameTime()
		end
		if ( cast3Desire > 0 ) 
		then
			npcBot:ActionImmediate_Chat("try to use skill 3 at "..cast3Target:GetUnitName().." Desire= "..cast3Desire,true)
			npcBot.LastSpeaktime=GameTime()
		end
		if ( cast2Desire > 0 ) 
		then
			npcBot:ActionImmediate_Chat("try to use skill 2 at "..cast2Target:GetUnitName().." Desire= "..cast2Desire,true)
			npcBot.LastSpeaktime=GameTime()
		end
		if ( cast1Desire > 0 ) 
		then
			npcBot:ActionImmediate_Chat("try to use skill 1 at "..cast1Target:GetUnitName().." Desire= "..cast1Desire,true)
			npcBot.LastSpeaktime=GameTime()
		end
	end
	---------------------------------debug--------------------------------------------]]--
	if ( cast1Desire > 0 ) 
	then
		npcBot:Action_UseAbilityOnEntity( AbilitiesReal[1], cast1Target );
		return
	end
	
	if ( cast2Desire > 0 ) 
	then
		npcBot:Action_UseAbilityOnEntity( AbilitiesReal[2], cast2Target );
		return
	end
	
	if ( cast3Desire > 0 ) 
	then
		npcBot:Action_UseAbilityOnEntity( AbilitiesReal[3], cast3Target );
		return
	end
	
	if ( cast5Desire > 0 ) 
	then
		npcBot:Action_UseAbilityOnEntity( AbilitiesReal[5], cast5Target );
		return
	end
	
end

function Consider1()

	local ability=AbilitiesReal[1];
	
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
	
	-- Check for a channeling enemy
	for _,enemy in pairs( enemys )
	do
		if ( enemy:IsChanneling() and CanCast1( enemy )) 
		then
			return BOT_ACTION_DESIRE_HIGH, enemy
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
			if ( CanCast1( npcEnemy ) and not enemyDisabled(npcEnemy))
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
	
	--try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		if (WeakestEnemy~=nil)
		then
			if ( CanCast1( WeakestEnemy ) )
			then
				if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL) or (HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana))
				then
					return BOT_ACTION_DESIRE_HIGH,WeakestEnemy; 
				end
			end
		end
	end
	
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH ) 
	then
		local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( CastRange, true, BOT_MODE_NONE );
		for _,npcEnemy in pairs( tableNearbyEnemyHeroes )
		do
			if ( npcBot:WasRecentlyDamagedByHero( npcEnemy, 2.0 ) ) 
			then
				if ( CanCast1( npcEnemy ) and not enemyDisabled(npcEnemy)) 
				then
					return BOT_ACTION_DESIRE_HIGH, npcEnemy;
				end
			end
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	--[[--ÏûºÄ
	--if ( npcBot:GetActiveMode() == BOT_MODE_LANING ) 
	--then
		if((ManaPercentage>0.4 or npcBot:GetMana()>ComboMana) and ability:GetLevel()>=1 )
		then
			if (WeakestEnemy~=nil)
			then
				if ( CanCast1( WeakestEnemy ) )
				then
					return BOT_ACTION_DESIRE_LOW,WeakestEnemy
				end
			end
		end
	--end]]--

	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		 npcBot:GetActiveMode() == BOT_MODE_ATTACK ) 
	then
		local npcTarget = npcBot:GetTarget();

		if ( npcTarget ~= nil ) 
		then
			if ( CanCast1( npcTarget ) and not enemyDisabled(npcTarget) and GetUnitToUnitDistance(npcBot,npcTarget)< CastRange + 75*#allys)
			then
				return BOT_ACTION_DESIRE_MODERATE, npcTarget
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0 
end

function Consider2()

	local ability=AbilitiesReal[2];
	
	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = ability:GetCastRange();
	local Damage = (18+8*ability:GetLevel())*(4+ability:GetLevel());
	
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
			if ( CanCast2( WeakestEnemy ) )
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
	
	--if ( npcBot:GetActiveMode() == BOT_MODE_LANING ) 
	--then
		if((ManaPercentage>0.4 or npcBot:GetMana()>ComboMana) and ability:GetLevel()>=2 )
		then
			if (WeakestEnemy~=nil)
			then
				if ( CanCast2( WeakestEnemy ) )
				then
					return BOT_ACTION_DESIRE_LOW,WeakestEnemy;
				end
			end
		end
	--end
	
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

	-- If we're pushing or defending a lane and can hit 3+ creeps, go for it
	if ( npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT ) 
	then
		if ( #enemys>=1) 
		then
			if (ManaPercentage>0.5 or npcBot:GetMana()>ComboMana and AbilitiesReal[4]:GetLevel()>=1)
			then
				if (WeakestEnemy~=nil)
				then
					if ( CanCast2( WeakestEnemy )and GetUnitToUnitDistance(npcBot,WeakestEnemy)< CastRange + 75*#allys )
					then
						return BOT_ACTION_DESIRE_LOW, WeakestEnemy;
					end
				end
			end
		end
		
		if (#creeps >= 3 ) 
		then
			if (ManaPercentage>0.5 or npcBot:GetMana()>ComboMana and AbilitiesReal[4]:GetLevel()>=1)
			then
					if ( CanCast2( creeps[1] )and GetUnitToUnitDistance(npcBot,creeps[1])< CastRange + 75*#allys )
					then
						return BOT_ACTION_DESIRE_LOW, creeps[1];
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
		
		if(ManaPercentage>0.4 or npcBot:GetMana()>ComboMana)
		then
			if ( npcTarget ~= nil ) 
			then
				if ( CanCast2( npcTarget )  and GetUnitToUnitDistance(npcBot,npcTarget)< CastRange + 75*#allys)
				then
					return BOT_ACTION_DESIRE_MODERATE, npcTarget;
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;
	
end

function Consider3()

	local ability=AbilitiesReal[3];
	
	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = ability:GetCastRange();
	local Damage = 0
	
	local HeroHealth=10000
	local CreepHealth=10000
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange+300,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
	
	-- If we're pushing or defending a lane
	if ( npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOTTOM or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOTTOM) 
	then
		    local tableNearbyFriendlyTowers = npcBot:GetNearbyTowers( CastRange+300, false );
			for _,myTower in pairs(tableNearbyFriendlyTowers) do
				if ( GetUnitToUnitDistance( myTower, npcBot  ) < CastRange and not myTower:HasModifier("modifier_ogre_magi_bloodlust") ) 
				then
					return BOT_ACTION_DESIRE_MODERATE, myTower;
				end
			end

			for _,myFriend in pairs(allys) do
				if ( GetUnitToUnitDistance( myFriend, npcBot  ) < CastRange and not myFriend:HasModifier("modifier_ogre_magi_bloodlust") ) 
				then
					return BOT_ACTION_DESIRE_MODERATE, myFriend;
				end
			end	
			if not npcBot:HasModifier("modifier_ogre_magi_bloodlust") then
				return BOT_ACTION_DESIRE_MODERATE, npcBot;
			end
	end
	
	-- If my mana is enough,buff myfriend.
	if(ManaPercentage>0.5 and npcBot:GetMana()>ComboMana)
	then
		for _,ally in pairs(allys)
		do
			if ( not ally:HasModifier("modifier_ogre_magi_bloodlust") ) 
			then
				return BOT_ACTION_DESIRE_MODERATE,ally;
			end
		end
		
		if not npcBot:HasModifier("modifier_ogre_magi_bloodlust") then
			return BOT_ACTION_DESIRE_MODERATE, npcBot;
		end
		
	end
	
	return BOT_ACTION_DESIRE_NONE, 0 
end

function Consider5()

	local ability=AbilitiesReal[5];
	
	if not ability:IsFullyCastable() or AbilitiesReal[1]:IsFullyCastable() or ability:GetManaCost()/npcBot:GetMaxMana() > 0.3 then
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
	
	-- Check for a channeling enemy
	for _,enemy in pairs( enemys )
	do
		if ( enemy:IsChanneling() and CanCast1( enemy )) 
		then
			return BOT_ACTION_DESIRE_HIGH, enemy
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
			if ( CanCast5( npcEnemy ) and not enemyDisabled(npcEnemy))
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
	
	--try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		if (WeakestEnemy~=nil)
		then
			if ( CanCast5( WeakestEnemy ) )
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
	
	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		 npcBot:GetActiveMode() == BOT_MODE_ATTACK ) 
	then
		local npcTarget = npcBot:GetTarget();

		if ( npcTarget ~= nil ) 
		then
			if ( CanCast5( npcTarget ) and not enemyDisabled(npcTarget) and GetUnitToUnitDistance(npcBot,npcTarget)< CastRange + 75*#allys)
			then
				return BOT_ACTION_DESIRE_MODERATE, npcTarget
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0 
end

function CourierUsageThink() 
	ability_item_usage_generic.CourierUsageThink()
end