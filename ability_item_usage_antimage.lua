----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.1 NewStructure
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
--------------------------------------
-- General Initialization
--------------------------------------
local utility = require( GetScriptDirectory().."/utility" ) 
require(GetScriptDirectory() ..  "/ability_item_usage_generic")

local debugmode=false
local npcBot = GetBot()
local Talents ={}
local Abilities ={}
local AbilitiesReal ={}

ability_item_usage_generic.InitAbility(Abilities,AbilitiesReal,Talents) 

local AbilityToLevelUp=
{
	Abilities[2],
	Abilities[1],
	Abilities[1],
	Abilities[3],
	Abilities[1],
	Abilities[4],
	Abilities[1],
	Abilities[2],
	Abilities[2],
	"talent",
	Abilities[2],
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
		return Talents[5]
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

Consider[2]=function()
		local abilityNumber=2
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability=AbilitiesReal[abilityNumber];
	
	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = ability:GetSpecialValueInt( "blink_range" );
	
	local HeroHealth=10000
	local CreepHealth=10000
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local trees= npcBot:GetNearbyTrees(300)
	
	if(npcBot.Blink==nil or DotaTime()-npcBot.Blink.Timer>=10)
	then
		npcBot.Blink={Point=npcBot:GetLocation(),Timer=DotaTime()}
	end
	
	--try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		if (WeakestEnemy~=nil)
		then
			local enemys2= WeakestEnemy:GetNearbyHeroes(900,true,BOT_MODE_NONE)
			if ( CanCast[abilityNumber]( WeakestEnemy ) and #enemys2<=2)
			then
				if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana and GetUnitToUnitDistance(npcBot,WeakestEnemy) > 500)
				then
					return BOT_ACTION_DESIRE_HIGH,GetUnitsTowardsLocation(npcBot,WeakestEnemy,CastRange+200); 
				end
			end
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	-- If we trapped by the trees
	if(trees~=nil and #trees>=10 or (utility.PointToPointDistance(npcBot:GetLocation(),npcBot.Blink.Point)<=100 and DotaTime()-npcBot.Blink.Timer<10 and DotaTime()-npcBot.Blink.Timer>8))
	then
		return BOT_ACTION_DESIRE_HIGH, GetUnitsTowardsLocation(npcBot,GetAncient(GetTeam()),CastRange)
	end
	
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:DistanceFromFountain()>=2000 and (ManaPercentage>=0.6 or npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH or HealthPercentage<=0.6)) 
	then
		return BOT_ACTION_DESIRE_HIGH, GetUnitsTowardsLocation(npcBot,GetAncient(GetTeam()),CastRange)
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
				local enemys2= npcEnemy:GetNearbyHeroes(900,false,BOT_MODE_NONE)
				if (enemys2~=nil and #enemys2<=2)
				then
					if ( CanCast[abilityNumber]( npcEnemy ) and GetUnitToUnitDistance(npcBot,npcEnemy)< CastRange + 75*#allys and GetUnitToUnitDistance(npcBot,npcEnemy) > 500)
					then
						return BOT_ACTION_DESIRE_MODERATE, GetUnitsTowardsLocation(npcBot,npcEnemy,CastRange+200);
					end
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
	
	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = ability:GetCastRange();
	local DamagePercent = ability:GetSpecialValueFloat("mana_void_damage_per_mana")
	local Radius = ability:GetAOERadius();
	
	local HeroHealth=10000
	local CreepHealth=10000
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------
	--Try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		for i,npcEnemy in pairs(enemys)
		do
			if ( CanCast[abilityNumber]( npcEnemy ) )
			then
				local enemys = npcEnemy:GetNearbyHeroes(Radius,false,BOT_MODE_NONE)
				local Damage=(npcEnemy:GetMaxMana()-npcEnemy:GetMana())*DamagePercent
				local ManaPercentageEnemy=npcEnemy:GetMana()/npcEnemy:GetMaxMana()
				if(enemys~=nil)
				then
					Damage=Damage*(1+0.2*#enemys)
				end
				
				if(npcEnemy:GetHealth()<=npcEnemy:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL))
				then
					return BOT_ACTION_DESIRE_HIGH,npcEnemy; 
				end
			end
		end
	end
	
	-- Check for a channeling enemy
	for _,npcEnemy in pairs( enemys )
	do
		if ( npcEnemy:IsChanneling() and CanCast[abilityNumber]( npcEnemy )) 
		then
			return BOT_ACTION_DESIRE_HIGH, npcEnemy
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