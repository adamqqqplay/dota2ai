----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.3 New Structure
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

-- utility.PrintAbilityName(Abilities)
local abilityName = { "medusa_split_shot", "medusa_mystic_snake", "medusa_mana_shield", "medusa_cold_blooded", "medusa_stone_gaze" }
local abilityIndex = utility.ReverseTable(abilityName)


local AbilityToLevelUp=
{
	Abilities[2],
	Abilities[3],
	Abilities[2],
	Abilities[3],
	Abilities[2],
	Abilities[abilityIndex.medusa_stone_gaze],
	Abilities[2],
	Abilities[1],
	Abilities[1],
	"talent",
	Abilities[1],
	Abilities[abilityIndex.medusa_stone_gaze],
	Abilities[1],
	Abilities[3],
	"talent",
	Abilities[3],
	"nil",
	Abilities[abilityIndex.medusa_stone_gaze],
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

Consider[2]=function()
	local abilityNumber=2
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability=AbilitiesReal[abilityNumber];
	
	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = ability:GetCastRange();
	local Damage = ability:GetSpecialValueInt("snake_damage")
	local CastPoint = ability:GetCastPoint();
	
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
					return BOT_ACTION_DESIRE_HIGH,WeakestEnemy; 
				end
			end
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	-- If we're in a teamfight
	local tableNearbyAttackingAlliedHeroes = npcBot:GetNearbyHeroes( 1000, false, BOT_MODE_ATTACK );
	if ( #tableNearbyAttackingAlliedHeroes >= 2 ) 
	then
		if(ManaPercentage>0.65 or npcBot:GetMana()>ComboMana and ability:GetLevel()> 1)
		then
			if (#enemys>=1 and #creeps < 4) or #enemys > 2
			then
				if(WeakestCreep~=nil)
				then
					return BOT_ACTION_DESIRE_HIGH,WeakestCreep; 
				end
				if(WeakestEnemy~=nil)
				then
					if ( CanCast[abilityNumber]( WeakestEnemy ) )
					then
						return BOT_ACTION_DESIRE_HIGH,WeakestEnemy; 
					end
				end
			end
		end
	end
	
	--Last hit
	if ( npcBot:GetActiveMode() == BOT_MODE_LANING ) 
	then
		if(WeakestCreep~=nil)
		then
			if((ManaPercentage>0.7 or npcBot:GetMana()>ComboMana) and GetUnitToUnitDistance(npcBot,WeakestCreep)>=AttackRange+200)
			then
				if(CreepHealth<=WeakestCreep:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL))
				then					
					return BOT_ACTION_DESIRE_LOW,creeps[1];
				end
			end		
		end
	end
	
	-- If we're farming and can hit 2+ creeps and kill 1+ 
	if ( npcBot:GetActiveMode() == BOT_MODE_FARM )
	then
		if ( #creeps >= 2 ) 
		then
			if(ManaPercentage>0.5 or npcBot:GetMana()>ComboMana)
			then
				return BOT_ACTION_DESIRE_LOW, creeps[1];
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
		if ( #enemys+#creeps >= 3 ) 
		then
			if (ManaPercentage>0.5 or npcBot:GetMana()>ComboMana)
			then
				if (creeps[1]~=nil)
				then
					if ( CanCast[abilityNumber]( WeakestCreep )and GetUnitToUnitDistance(npcBot,WeakestCreep)< CastRange + 75*#allys )
					then
						return BOT_ACTION_DESIRE_LOW, creeps[1];
					end
				end
				if (WeakestEnemy~=nil)
				then
					if ( CanCast[abilityNumber]( WeakestEnemy )and GetUnitToUnitDistance(npcBot,WeakestEnemy)< CastRange + 75*#allys )
					then
						return BOT_ACTION_DESIRE_LOW, WeakestEnemy;
					end
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
			if ( CanCast[abilityNumber]( npcEnemy )  and GetUnitToUnitDistance(npcBot,npcEnemy)< CastRange + 75*#allys)
			then
				return BOT_ACTION_DESIRE_MODERATE, npcEnemy;
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;
	
end

Consider[3]=function()
	
	local abilityNumber=3
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability=AbilitiesReal[abilityNumber];
	
	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end

	if(ability:GetToggleState()==false)
	then
		return BOT_ACTION_DESIRE_HIGH
	end

	return BOT_ACTION_DESIRE_NONE, 0;
	
end

Consider[abilityIndex.medusa_stone_gaze]=function()

	local abilityNumber=abilityIndex.medusa_stone_gaze
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability=AbilitiesReal[abilityNumber];
	
	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = ability:GetCastRange();
	local CastPoint = ability:GetCastPoint();

	local enemys = npcBot:GetNearbyHeroes(CastRange-300,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	local enemys2 = npcBot:GetNearbyHeroes( 400, true, BOT_MODE_NONE );
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH or #enemys2>=2) 
	then
		if ( npcBot:WasRecentlyDamagedByAnyHero( 2.0 )) 
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
			if ( CanCast[abilityNumber]( npcEnemy ) and GetUnitToUnitDistance(npcBot,npcEnemy)< 300 + 75*#allys and #enemys>=2 )
			then
				return BOT_ACTION_DESIRE_MODERATE
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE;

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