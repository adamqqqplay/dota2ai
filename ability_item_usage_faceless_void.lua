----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.1 NewStructure
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
--------------------------------------
-- General Initialization
--------------------------------------
require(GetScriptDirectory() ..  "/utility")
require(GetScriptDirectory() ..  "/ability_item_usage_generic")

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
		return Talents[5]
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
local CanCast={utility.NCanCast,utility.NCanCast,utility.NCanCast,utility.UCanCast}
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
	
	local CastRange = ability:GetSpecialValueInt( "range" );
	
	local HeroHealth=10000
	local CreepHealth=10000
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local trees= npcBot:GetNearbyTrees(300)
	
	if(npcBot.FacelessVoidSkill1==nil or DotaTime()-npcBot.FacelessVoidSkill1.Timer>=2)
	then
		npcBot.FacelessVoidSkill1={Hp=HealthPercentage,Timer=DotaTime()}
	end
	
	--try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		if (WeakestEnemy~=nil)
		then
			local enemys2= WeakestEnemy:GetNearbyHeroes(900,true,BOT_MODE_NONE)
			if ( CanCast[abilityNumber]( WeakestEnemy ) and #enemys2<=2)
			then
				if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana)
				then
					return BOT_ACTION_DESIRE_HIGH,GetUnitsTowardsLocation(npcBot,WeakestEnemyw,200); 
				end
			end
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	-- If we trapped by the trees
	if(trees~=nil and #trees>=10)
	then
		return BOT_ACTION_DESIRE_HIGH, GetUnitsTowardsLocation(npcBot,GetAncient(GetTeam()),CastRange)
	end
	
	-- If we're seriously retreating
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT or npcBot.FacelessVoidSkill1.Hp-HealthPercentage>=0.15+0.03*#enemys) 
	then
		return BOT_ACTION_DESIRE_HIGH, GetUnitsTowardsLocation(npcBot,GetAncient(GetTeam()),CastRange)
	end
	
	if(npcBot:GetActiveMode() == BOT_MODE_ATTACK and ManaPercentage>ComboMana and AbilitiesReal[4]:IsFullyCastable()) 
	then
		local locationAoE = npcBot:FindAoELocation( true, true, npcBot:GetLocation(), CastRange, 425, 0, 0 );
		if ( locationAoE.count >= 2) 
		then
			return BOT_ACTION_DESIRE_HIGH+0.05, locationAoE.targetloc;
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
				local enemys2= npcEnemy:GetNearbyHeroes(900,true,BOT_MODE_NONE)
				if (enemys2~=nil and #enemys2<=2)
				then
					if ( CanCast[abilityNumber]( npcEnemy ) and GetUnitToUnitDistance(npcBot,npcEnemy)>CastRange-200 and GetUnitToUnitDistance(npcBot,npcEnemy)<1200)
					then
						return BOT_ACTION_DESIRE_MODERATE, GetUnitsTowardsLocation(npcBot,npcEnemy,200);
					end
				end
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
		return BOT_ACTION_DESIRE_NONE
	end
	
	local CastRange = 0
	local Damage = ability:GetAbilityDamage()
	local Radius = ability:GetAOERadius()
	local CastPoint = ability:GetCastPoint()
	
	local HeroHealth=10000
	local CreepHealth=10000
	local allys = npcBot:GetNearbyHeroes(Radius, false, BOT_MODE_NONE );
	local WeakestAlly,AllyHealth=utility.GetWeakestUnit(allys)
	local enemys = npcBot:GetNearbyHeroes(Radius,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------
	--Try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		if (WeakestEnemy~=nil)
		then
			if ( CanCast[abilityNumber]( WeakestEnemy ))
			then
				if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL) or (HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana))
				then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	--protect myself
	if(npcBot:GetActiveMode() == BOT_MODE_ATTACK)
	then
		if(npcBot:WasRecentlyDamagedByAnyHero(2) or #enemys >=2)
		then
			for _,npcEnemy in pairs( enemys )
			do
				if ( CanCast[abilityNumber]( npcEnemy ) )
				then
					return BOT_ACTION_DESIRE_HIGH
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

		if ( npcEnemy ~= nil and #enemys==1) 
		then
			if ( CanCast[abilityNumber]( npcEnemy ) and GetUnitToUnitDistance(npcBot,npcEnemy)<=Radius)
			then
				return BOT_ACTION_DESIRE_MODERATE
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
	
	
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
	local Damage = 0
	local Radius = ability:GetAOERadius()
	local CastPoint = ability:GetCastPoint()
	
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
		if ( npcEnemy:IsChanneling() ) 
		then
			return BOT_ACTION_DESIRE_HIGH, npcEnemy:GetLocation();
		end
	end

	--try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		if (WeakestEnemy~=nil)
		then
			if ( CanCast[abilityNumber]( WeakestEnemy ) )
			then
				if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana)
				then
					return BOT_ACTION_DESIRE_HIGH,WeakestEnemy:GetExtrapolatedLocation(CastPoint); 
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
				if ( CanCast[abilityNumber]( npcEnemy ) ) 
				then
					return BOT_ACTION_DESIRE_MODERATE, npcEnemy:GetExtrapolatedLocation(CastPoint);
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
		local locationAoE = npcBot:FindAoELocation( true, true, npcBot:GetLocation(), CastRange, Radius, CastPoint, 0 );
		if ( locationAoE.count >= 2 ) then
			return BOT_ACTION_DESIRE_MODERATE, locationAoE.targetloc;
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;
end

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