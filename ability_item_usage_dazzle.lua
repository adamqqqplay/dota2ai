----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.3 New Structure
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
--------------------------------------
-- General Initialization
--------------------------------------
local utility = require( GetScriptDirectory().."/utility" ) 
require(GetScriptDirectory() ..  "/ability_item_usage_generic")
local AbilityExtensions = require(GetScriptDirectory().."/util/AbilityAbstraction")

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
	Abilities[2],
	Abilities[4],
	Abilities[3],
	Abilities[2],
	"talent",
	Abilities[3],
	Abilities[1],
	Abilities[2],
	Abilities[4],
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
local CanCast={function(t)
	return AbilityExtensions:NormalCanCast(t, true, DAMAGE_TYPE_PHYSICAL, false, true)
end,utility.NCanCast,utility.NCanCast,utility.UCanCast}
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
	
	local CastRange = ability:GetCastRange();
	local Damage = ability:GetAbilityDamage();
	

	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange+300,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)

	local endDistance = ability:GetSpecialValueInt("end_distance")
	local startRadius = ability:GetSpecialValueInt("start_radius")
	local endRadius = ability:GetSpecialValueInt("end_radius")
	
	local function FindPoisonTouchAlternativeNear(target)
		local radius = RemapVal(GetUnitToUnitDistance(npcBot, target), 0, endDistance, startRadius, endRadius)
		local enemies = AbilityExtensions:GetNearbyEnemyUnits(target, radius)
		enemies = AbilityExtensions:First(enemies, function (t) return CanCast[1](t) and t:HasModifier("modifier_antimage_counterspell") end)
		return enemies
	end

	local function UseAt(target)
		if AbilityExtensions:HasAbilityRetargetModifier(target) then
			local alternativeEnemy = FindPoisonTouchAlternativeNear(target)
			if alternativeEnemy then
				return alternativeEnemy
			end
		else
			return target
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
				if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL) or (HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana))
				then
					local target = UseAt(WeakestEnemy)
					if target ~= nil then
						return BOT_ACTION_DESIRE_HIGH, target
					end
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
			if ( CanCast[abilityNumber]( npcEnemy ))
			then
				local Damage2 = npcEnemy:GetEstimatedDamageToTarget( false, npcBot, 3.0, DAMAGE_TYPE_ALL );
				if ( Damage2 > nMostDangerousDamage )
				then
					nMostDangerousDamage = Damage2;
					npcMostDangerousEnemy = npcEnemy;
				end
			end
		end

		if ( npcMostDangerousEnemy ~= nil ) then
			local target = UseAt(npcMostDangerousEnemy)
			if target ~= nil then
				return BOT_ACTION_DESIRE_HIGH, target
			end
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	--protect myself
	local enemys2 = npcBot:GetNearbyHeroes( 400, true, BOT_MODE_NONE );
	if(npcBot:WasRecentlyDamagedByAnyHero(5))
	then
		for _,npcEnemy in pairs( enemys2 )
		do
			if ( CanCast[abilityNumber]( npcEnemy ) )
			then
				local target = UseAt(npcEnemy)
				if target ~= nil then
					return BOT_ACTION_DESIRE_HIGH, target
				end
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
				local target = UseAt(npcEnemy)
				if target ~= nil then
					return BOT_ACTION_DESIRE_HIGH, target
				end
			end
		end
	end
	
	-- If my mana is enough,use it at enemy
	if ( npcBot:GetActiveMode() == BOT_MODE_LANING ) 
	then
		if(ManaPercentage>0.8 or npcBot:GetMana()>ComboMana)
		then
			if (WeakestEnemy~=nil)
			then
				if ( CanCast[abilityNumber]( WeakestEnemy ) )
				then
					local target = UseAt(WeakestEnemy)
					if target ~= nil then
						return BOT_ACTION_DESIRE_HIGH, target
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
			if ( CanCast[abilityNumber]( npcEnemy ) and not enemyDisabled(npcEnemy) and GetUnitToUnitDistance(npcBot,npcEnemy)< CastRange + 75*#allys)
			then
				local target = UseAt(npcEnemy)
				if target ~= nil then
					return BOT_ACTION_DESIRE_MODERATE, target
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
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = ability:GetCastRange();
	local Damage = ability:GetAbilityDamage();
	
	local allys = AbilityExtensions:GetNearbyNonIllusionHeroes(npcBot, CastRange+300, false)
	local WeakestAlly,AllyHealth=utility.GetWeakestUnit(allys)
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local enemyAxe = AbilityExtensions:First(enemys, function(t)
		return AbilityExtensions:MayNotBeIllusion(t) and t:GetUnitName() == "npc_dota_hero_axe"
	end)
	local canEnemyAxeUseCullingBlade = false
	if enemyAxe then
		canEnemyAxeUseCullingBlade = AbilityExtensions:GetSilenceRemainingDuration(enemyAxe) <= 3 and enemyAxe:GetMana() >= Clamp(enemyAxe:GetLevel()/6, 0, 3) * 60
	end

	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange+300,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------
	-- If we're seriously retreating
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH ) 
	then
		if(HealthPercentage<=0.3) and not (enemyAxe and canEnemyAxeUseCullingBlade and GetUnitToUnitDistance(npcBot, enemyAxe) <= 350)
		then
			return BOT_ACTION_DESIRE_HIGH+0.15, npcBot
		end
	end
	
	--protect teammate,save allys from control
	for _,npcTarget in pairs( allys )
	do
		local enemys2 = npcTarget:GetNearbyHeroes(600,true,BOT_MODE_NONE)
		if not npcTarget:IsIllusion() and (npcTarget:GetHealth()/npcTarget:GetMaxHealth()<=0.2+0.05*#enemys2) and npcTarget:WasRecentlyDamagedByAnyHero(3)
		then
			local Damage2=0
			for _,npcEnemy in pairs( enemys2 )
			do
				Damage2 =Damage2 + npcEnemy:GetEstimatedDamageToTarget( true, npcBot, 2.0, DAMAGE_TYPE_ALL );
			end
			if not npcTarget:IsIllusion() and (npcTarget:GetHealth()<Damage2*1.25 or npcTarget:GetHealth()/npcTarget:GetMaxHealth()<=0.3) and not (enemyAxe and canEnemyAxeUseCullingBlade and GetUnitToUnitDistance(npcBot, enemyAxe) <= 350)
			then
				return BOT_ACTION_DESIRE_HIGH+0.15, npcTarget
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
	
	local CastRange = ability:GetCastRange();
	--local Damage = ability:GetAbilityDamage();
	local Damage = ability:GetSpecialValueInt("damage")
	local Radius = ability:GetSpecialValueInt("damage_radius")
	local RadiusAlly = ability:GetSpecialValueInt("bounce_radius")
	local MaxTarget=ability:GetSpecialValueInt("max_targets")
	local DamageType=DAMAGE_TYPE_PHYSICAL
	

	local allys = npcBot:GetNearbyHeroes( CastRange+300, false, BOT_MODE_NONE );
	local WeakestAlly,AllyHealth=utility.GetWeakestUnit(allys)
	local enemys = npcBot:GetNearbyHeroes(CastRange+200,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange+300,false)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)

	for _,npcEnemy in pairs(enemys)
	do
		if(npcEnemy:CanBeSeen())
		then
			local allyCreeps = npcEnemy:GetNearbyCreeps(Radius,true)
			local allyHeroes = npcEnemy:GetNearbyHeroes(Radius,true,BOT_MODE_NONE)
			local RadiusCount = math.min(MaxTarget,#allyCreeps+#allyHeroes)
			local RealDamage = RadiusCount*Damage
			local Target
			if(allyCreeps~=nil)
			then
				Target=allyCreeps[1]
			else
				Target=allyHeroes[1]
			end
			
			if(Target~=nil)
			then
				--------------------------------------
				-- Global high-priorty usage
				--------------------------------------
				--Try to kill enemy hero
				if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
				then
					if ( CanCast[abilityNumber]( npcEnemy ) )
					then
						if(npcEnemy:GetHealth()<=npcEnemy:GetActualIncomingDamage(RealDamage,DamageType))
						then
							return BOT_ACTION_DESIRE_HIGH,Target;
						end
					end
				end
				
				-- If we're going after someone
				if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
					npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
					npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
					npcBot:GetActiveMode() == BOT_MODE_ATTACK ) 
				then
					local npcEnemy2=npcBot:GetTarget()
					if(npcEnemy ~= nil)
					then
						if ( npcEnemy==npcEnemy2 ) 
						then
							if ( CanCast[abilityNumber]( npcEnemy ) )
							then
								return BOT_ACTION_DESIRE_HIGH,Target
							end
						end
					end
				end
				
				-- If our mana is enough,use it at enemy
				if ( npcBot:GetActiveMode() == BOT_MODE_LANING ) 
				then
					if(ManaPercentage>0.4 and RadiusCount>=3 )
					then
						if ( CanCast[abilityNumber]( npcEnemy ) )
						then
							return BOT_ACTION_DESIRE_LOW-0.01,Target
						end
					end
				end
			end
		end
	end
		
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH and not npcBot:HasModifier("modifier_ice_blast") ) 
	then
		if ( npcBot:WasRecentlyDamagedByAnyHero(2) ) 
		then
			return BOT_ACTION_DESIRE_HIGH, npcBot;
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	--protect teammate
	allys = AbilityExtensions:Filter(allys, function(t) return not t:HasModifier("modifier_ice_blast") end)
	for _,npcTarget in pairs (allys)
	do
		local enemys2=npcTarget:GetNearbyHeroes(600,true,BOT_MODE_NONE)
		local allyHeroes = npcTarget:GetNearbyHeroes(RadiusAlly,false,BOT_MODE_NONE)
		local RadiusCount = #allyHeroes
		local HpFactor=math.min(0.9,0.3+0.05*#enemys2+0.3*ManaPercentage+0.1*RadiusCount)
		
		if(npcBot:GetActiveMode() == BOT_MODE_ATTACK)
		then
			HpFactor=math.min(0.9,HpFactor+0.2)
		end

		if(npcTarget:GetHealth()/npcTarget:GetMaxHealth()< HpFactor )
		then
			if ( CanCast[abilityNumber]( npcTarget ) )
			then
				return BOT_ACTION_DESIRE_HIGH, npcTarget
			end
		end
		
	end
	
	-- If we're farming
	if ( npcBot:GetActiveMode() == BOT_MODE_FARM or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT )
	then
		if(ManaPercentage>0.5)
		then
			for _,npcTarget in pairs (creeps)
			do
				local enemyCreeps = npcTarget:GetNearbyCreeps(Radius,true)
				if(enemyCreeps~=nil and #enemyCreeps>=3)
				then
					return BOT_ACTION_DESIRE_LOW,npcTarget; 
				end
			end
		end
	end

	
	return BOT_ACTION_DESIRE_NONE, 0;	
	
end

Consider[4]=function()
	-- local abilityNumber=4
	-- --------------------------------------
	-- -- Generic Variable Setting
	-- --------------------------------------
	-- local ability=AbilitiesReal[abilityNumber];
	
	-- if not ability:IsFullyCastable() then
	-- 	return BOT_ACTION_DESIRE_NONE, 0;
	-- end
	
	-- local CastRange = ability:GetCastRange();
	-- local Damage = 0
	-- local Radius = ability:GetAOERadius()
	
	-- local HeroHealth=10000
	-- local CreepHealth=10000
	-- local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	-- local enemys = npcBot:GetNearbyHeroes(1600,true,BOT_MODE_NONE)
	-- local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	-- local creeps = npcBot:GetNearbyCreeps(1600,true)
	-- local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
	-- --------------------------------------
	-- -- Mode based usage
	-- --------------------------------------
	
	-- if(npcBot:GetActiveMode() == BOT_MODE_ATTACK)
	-- then
	-- 	local locationAoE = npcBot:FindAoELocation( false, true, npcBot:GetLocation(), CastRange, Radius, 0, 0 );
	-- 	if ( locationAoE.count >= 3 ) 
	-- 	then
	-- 		return BOT_ACTION_DESIRE_MODERATE-0.04, locationAoE.targetloc;
	-- 	end
			
	-- 	local locationAoE = npcBot:FindAoELocation( true, true, npcBot:GetLocation(), CastRange, Radius, 0, 0 );
	-- 	if ( locationAoE.count >= 2 ) 
	-- 	then
	-- 		return BOT_ACTION_DESIRE_MODERATE-0.04, locationAoE.targetloc;
	-- 	end
	-- end
	
	return BOT_ACTION_DESIRE_NONE, 0;
	
end

AbilityExtensions:AutoModifyConsiderFunction(npcBot, Consider, AbilitiesReal)


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