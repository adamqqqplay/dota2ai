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
	Abilities[2],
	Abilities[3],
	"talent",
	Abilities[3],
	Abilities[4],
	Abilities[3],
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
local cast4Desire = 0;
----------------------------------------------------------------------------------------------------

function CanCast1( npcTarget )
	return npcTarget:CanBeSeen() and not npcTarget:IsMagicImmune() and not npcTarget:IsInvulnerable();
end

function CanCast2( npcTarget )
	return npcTarget:CanBeSeen() and not npcTarget:IsMagicImmune() and not npcTarget:IsInvulnerable();
end

function CanCast3( npcTarget )
	return npcTarget:CanBeSeen() and not npcTarget:IsMagicImmune() and not npcTarget:IsInvulnerable();
end

function CanCast4( npcTarget )
	return npcTarget:CanBeSeen() and not npcTarget:IsMagicImmune() and not npcTarget:IsInvulnerable();
end

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
		sum=sum+40+20*AbilitiesReal[1]:GetLevel()+6*npcBot:GetLevel()
	end
	if AbilitiesReal[2]:IsFullyCastable()
	then
		sum=sum+60*AbilitiesReal[2]:GetLevel()
	end
	if AbilitiesReal[4]:IsFullyCastable()
	then
		sum=sum+200+400*AbilitiesReal[4]:GetLevel()
	end
	if AbilitiesReal[3]:IsFullyCastable()
	then
		sum=sum*(1.25+0.05*AbilitiesReal[3]:GetLevel());
	end
	
	return sum
end
--[[
local function GetComboMana()
	
	if AbilitiesReal[1]:GetLevel()<1 or AbilitiesReal[2]:GetLevel()<1 or AbilitiesReal[3]:GetLevel()<1 or AbilitiesReal[4]:GetLevel()<1
	then
		return 300;
	end
	
	if(AbilitiesReal[4]:GetCooldownTimeRemaining()>=30) 
	then
		return AbilitiesReal[1]:GetManaCost()+AbilitiesReal[2]:GetManaCost()+AbilitiesReal[3]:GetManaCost();
	end
	
	return AbilitiesReal[1]:GetManaCost()+AbilitiesReal[2]:GetManaCost()+AbilitiesReal[3]:GetManaCost()+AbilitiesReal[4]:GetManaCost();
end]]--

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
	if AbilitiesReal[3]:IsFullyCastable()
	then
		tempComboMana=tempComboMana+AbilitiesReal[3]:GetManaCost()
	end
	if AbilitiesReal[4]:IsFullyCastable() or AbilitiesReal[4]:GetCooldownTimeRemaining()<=30
	then
		tempComboMana=tempComboMana+AbilitiesReal[4]:GetManaCost()
	end
	
	if AbilitiesReal[1]:GetLevel()<1 or AbilitiesReal[2]:GetLevel()<1 or AbilitiesReal[3]:GetLevel()<1 or AbilitiesReal[4]:GetLevel()<1
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
	
	local i=npcBot:FindItemSlot("item_rod_of_atos")
	if(i>=0 and i<=5)
	then
		atos=npcBot:GetItemInSlot(i)
		i=nil
	end
	-- Consider using each ability
	cast1Desire, cast1Target = Consider1();
	cast2Desire = Consider2();
	cast3Desire, cast3Target = Consider3();
	cast4Desire, cast4Location = Consider4();
	---------------------------------debug--------------------------------------------
	--[[if(npcBot.LastSpeaktime==nil)
	then
		npcBot.LastSpeaktime=0
	end
	if(GameTime()-npcBot.LastSpeaktime>1)
	then
		if ( cast4Desire > 0 ) 
		then
			npcBot:ActionImmediate_Chat("try to use skill 4 at Desire= "..cast4Desire,true)
			npcBot.LastSpeaktime=GameTime()
		end
		if ( cast3Desire > 0 ) 
		then
			npcBot:ActionImmediate_Chat("try to use skill 3 at "..cast3Target:GetUnitName().." Desire= "..cast3Desire,true)
			npcBot.LastSpeaktime=GameTime()
		end
		if ( cast2Desire > 0 ) 
		then
			npcBot:ActionImmediate_Chat("try to use skill 2 Desire= "..cast2Desire,true)
			npcBot.LastSpeaktime=GameTime()
		end
		if ( cast1Desire > 0 ) 
		then
			npcBot:ActionImmediate_Chat("try to use skill 1 at "..cast1Target:GetUnitName().." Desire= "..cast1Desire,true)
			npcBot.LastSpeaktime=GameTime()
		end
	end]]--
	---------------------------------debug--------------------------------------------
	if ( cast4Desire > 0 ) 
	then
		npcBot:Action_UseAbilityOnLocation( AbilitiesReal[4], cast4Location );
		return
	end
	
	if ( cast3Desire > 0 ) 
	then
		npcBot:Action_UseAbilityOnEntity( AbilitiesReal[3], cast3Target );
		return
	end
	
	if ( cast2Desire > 0 ) 
	then
		npcBot:Action_UseAbility( AbilitiesReal[2] );
		return
	end
	
	if ( cast1Desire > 0 ) 
	then
		if(atos~=nil and atos:IsFullyCastable())
		then
			npcBot:Action_UseAbilityOnEntity(atos,cast1Target)
		end
		npcBot:Action_UseAbilityOnEntity( AbilitiesReal[1], cast1Target );
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
	
	--try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		if (WeakestEnemy~=nil)
		then
			if ( CanCast1( WeakestEnemy ) )
			then
				if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL)*3 or (HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana))
				then
					npcBot:SetTarget( WeakestEnemy ) 
					return BOT_ACTION_DESIRE_HIGH,WeakestEnemy; 
				end
			end
		end
	end
	
	--protect myself
	local enemys2 = npcBot:GetNearbyHeroes( 500, true, BOT_MODE_NONE );
	if(npcBot:WasRecentlyDamagedByAnyHero(5))
	then
		for _,enemy in pairs( enemys2 )
		do
			if ( CanCast1( enemy ) )
			then
				return BOT_ACTION_DESIRE_HIGH, enemy
			end
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	--消耗
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
	--end

	-- If we're pushing or defending a lane 
	if ( npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT ) 
	then
		if (WeakestEnemy~=nil)
		then
			if ( CanCast1( WeakestEnemy )and GetUnitToUnitDistance(npcBot,WeakestEnemy)< CastRange + 75*#allys )
			then
				return BOT_ACTION_DESIRE_LOW,WeakestEnemy
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

		if ( npcTarget ~= nil ) 
		then
			if ( CanCast1( npcTarget ) and GetUnitToUnitDistance(npcBot,npcTarget)< CastRange + 75*#allys)
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
	local Damage = ability:GetAbilityDamage();
	
	local HeroHealth=10000
	local CreepHealth=10000
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange+0,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	
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
	
	-- If a mode has set a target, and we can kill them, do it
	local npcTarget = npcBot:GetTarget();
	if ( npcTarget ~= nil and CanCast2( npcTarget ) )
	then
		if (GetComboDamage() > npcTarget:GetHealth())
		then
			return BOT_ACTION_DESIRE_HIGH;
		end
	end
	
	--protect myself
	if(npcBot:WasRecentlyDamagedByAnyHero(5) and npcBot:GetActiveMode() == BOT_MODE_RETREAT)
	then
		for _,enemy in pairs( enemys )
		do
			if ( CanCast2( enemy ) )
			then
				return BOT_ACTION_DESIRE_HIGH
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

		if ( npcTarget ~= nil ) 
		then
			if ( CanCast2( npcTarget ) and GetUnitToUnitDistance(npcBot,npcTarget)< CastRange)
			then
				return BOT_ACTION_DESIRE_MODERATE
			end
		end
	end
	
	return BOT_ACTION_DESIRE_NONE
	
end

function Consider3()

	local ability=AbilitiesReal[3];
	
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
	
	-- Check for a channeling enemy
	for _,enemy in pairs( enemys )
	do
		if ( enemy:IsChanneling() and CanCast3( enemy ) and not enemy:IsSilenced()) 
		then
			return BOT_ACTION_DESIRE_HIGH, enemy
		end
	end
	
	--try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		if (WeakestEnemy~=nil)
		then
			if ( CanCast3( WeakestEnemy ) )
			then
				if((HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana))
				then
					return BOT_ACTION_DESIRE_HIGH,WeakestEnemy; 
				end
			end
		end
	end

	-- If a mode has set a target, and we can kill them, do it
	local npcTarget = npcBot:GetTarget();
	if ( npcTarget ~= nil )
	then
		if(CanCast3( npcTarget ))
		then
			if (GetComboDamage() > npcTarget:GetHealth() and GetUnitToUnitDistance( npcTarget, npcBot ) < ( CastRange + 200 ) )
			then
				return BOT_ACTION_DESIRE_HIGH, npcTarget;
			end
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
			if ( CanCast3( npcEnemy ) and not npcEnemy:IsSilenced())
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
	
	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		 npcBot:GetActiveMode() == BOT_MODE_ATTACK ) 
	then
		local npcTarget = npcBot:GetTarget();

		if ( npcTarget ~= nil ) 
		then
			if ( CanCast3( npcTarget ) and not npcTarget:IsSilenced() and GetUnitToUnitDistance(npcBot,npcTarget)< CastRange)
			then
				return BOT_ACTION_DESIRE_MODERATE, npcTarget;
			end
		end
	end
	
	return BOT_ACTION_DESIRE_NONE, 0
end

function Consider4()

	local ability=AbilitiesReal[4];
	
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
	
	
	-- If a mode has set a target, and we can kill them, do it
	local npcTarget = npcBot:GetTarget();
	if ( npcTarget ~= nil and CanCast4( npcTarget ) )
	then
		if (GetComboDamage() > npcTarget:GetHealth() and GetUnitToUnitDistance ( npcTarget, npcBot ) < ( CastRange + 200 ) and 
		(enemyDisabled(npcTarget) or (npcTarget:IsSilenced() and npcTarget:HasModifier("modifier_skywrath_mage_concussive_shot_slow"))))
		then
			return BOT_ACTION_DESIRE_HIGH, npcTarget:GetExtrapolatedLocation(0.5)
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
			if ( CanCast4( npcEnemy ) and (enemyDisabled(npcEnemy) or (npcEnemy:IsSilenced() and npcEnemy:HasModifier("modifier_skywrath_mage_concussive_shot_slow"))))
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
			return BOT_ACTION_DESIRE_HIGH, npcMostDangerousEnemy:GetExtrapolatedLocation(0.5)
		end
	end
	
	return BOT_ACTION_DESIRE_NONE, 0
	
end

function CourierUsageThink() 
	ability_item_usage_generic.CourierUsageThink()
end