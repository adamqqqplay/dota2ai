----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.1 NewStructure
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
	Abilities[2],
	Abilities[1],
	Abilities[5],
	Abilities[1],
	Abilities[3],
	Abilities[3],
	"talent",
	Abilities[3],
	Abilities[5],
	Abilities[2],
	Abilities[2],
	"talent",
	Abilities[2],
	"nil",
	Abilities[5],
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

function GetAbilityTarget(npcTarget)

	-- if(npcTarget:GetTeam()~=npcBot:GetTeam())
	-- then
		local Radius=AbilitiesReal[1]:GetAOERadius()
		local tableNearbyEnemyHeroes = npcTarget:GetNearbyHeroes( Radius, true, BOT_MODE_NONE );
		local tableNearbyEnemyCreeps = npcTarget:GetNearbyCreeps( Radius, true );
		if(tableNearbyEnemyCreeps~=nil)
		then
			for _,c in pairs(tableNearbyEnemyCreeps) 
			do
				if GetUnitToUnitDistance(c, npcTarget) < Radius  and CanCast[1]( c ) 
				then
					return BOT_ACTION_DESIRE_HIGH, c;
				end
			end
		end
		if(tableNearbyEnemyHeroes~=nil)
		then
			for _,h in pairs(tableNearbyEnemyHeroes) 
			do
				if GetUnitToUnitDistance(h, npcTarget) < Radius and CanCast[1]( h ) 
				then
					return BOT_ACTION_DESIRE_HIGH, h;
				end
			end
		end
		return 0,0
	--end
	--return 0,0
end

function ComputeFactor(UnitGroup)
	local HighestFactor=0
	local TempTarget
	local Radius=AbilitiesReal[1]:GetAOERadius()
	for _,npcTarget in pairs( UnitGroup )
	do
		if ( CanCast[1]( npcTarget ) )
		then
			local enemys2 = npcTarget:GetNearbyHeroes(Radius,true,BOT_MODE_NONE)
			if(enemys2==nil) then enemys2={} end
			local healingFactor=0.3+#enemys2*0.1+0.2*ManaPercentage-npcTarget:GetHealth()/npcTarget:GetMaxHealth()
			if(enemyDisabled(npcTarget))
			then
				healingFactor=healingFactor+0.1
			end
			if(healingFactor>HighestFactor)
			then
				HighestFactor=healingFactor
				TempTarget=npcTarget
			end			
		end
	end
	if(TempTarget~=nil)
	then
		--npcBot:ActionImmediate_Chat("omniknight.purify.Factor="..HighestFactor.." Target:"..TempTarget:GetUnitName(),true)
	end
	return HighestFactor,TempTarget
	
end

function GetTargetFactor()
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	return ComputeFactor(allys)
end

function GetTargetFactor2()
	local Radius=AbilitiesReal[1]:GetAOERadius()
	local allycreeps = npcBot:GetNearbyCreeps(Radius+300,false)
	for i,creep in pairs(allycreeps)
	do
		local allycreeps2 = npcBot:GetNearbyCreeps(Radius,true)
		if(#allycreeps2<3)
		then
			table.remove(allycreeps,i)
		end
	end
	
	local HighestFactor,TempTarget=GetTargetFactor()
	local HighestFactor2,TempTarget2=ComputeFactor(allycreeps)
	if(HighestFactor2>HighestFactor)
	then
		return HighestFactor2,TempTarget2
	else
		return HighestFactor,TempTarget
	end
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
	local CastPoint = ability:GetCastPoint();
	local Radius = ability:GetAOERadius();
	
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	allys = AbilityExtensions:Filter(npcBot, function(t) return not t:HasModifier("modifier_ice_blast") end)
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
				if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL) or (HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana))
				then
					local desire,target=GetAbilityTarget(WeakestEnemy)
					if(desire>0)
					then
						return desire,target
					end
				end
			end
		end
	end
	
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	--heal
	local enemys3 = npcBot:GetNearbyHeroes( Radius, true, BOT_MODE_NONE );
	-- If we're seriously retreating
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH ) 
	then
		if ( npcBot:WasRecentlyDamagedByAnyHero( 2.0 ) and (#enemys3>=1 or #enemys==0) or HealthPercentage<=0.2) and not npcBot:HasModifier("modifier_ice_blast")
		then
			return BOT_ACTION_DESIRE_HIGH+0.08,npcBot; 	
		end
	end
	
	--heal hero
	if(	true ) 
	then
		local HighestFactor,TempTarget=GetTargetFactor()
		if(HighestFactor>0 and TempTarget~=nil and not TempTarget:HasModifier("modifier_ice_blast"))
		then
			return BOT_ACTION_DESIRE_MODERATE-0.01, TempTarget
		end	
	end
	
	-----------------------------
	
	--damage
	--Last hit
	if 	( 	(npcBot:GetActiveMode() == BOT_MODE_LANING and WeakestCreep~=nil and CreepHealth<=WeakestCreep:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL)) or
			(	
				(
				 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
				 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
				 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or
				 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
				 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
				 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT or
				 npcBot:GetActiveMode() == BOT_MODE_FARM					
				) and #creeps>=3
			)
		)
	then
		if(WeakestCreep~=nil and (ManaPercentage>0.5 or npcBot:GetMana()>ComboMana))
		then
			local HighestFactor,TempTarget=GetTargetFactor2()
			if(HighestFactor>-0.5 and TempTarget~=nil)
			then
				return BOT_ACTION_DESIRE_MODERATE+0.01, TempTarget
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
			if ( CanCast[abilityNumber]( npcEnemy ) and GetUnitToUnitDistance(npcBot,npcEnemy)< CastRange + 75*#allys)
			then
				local desire,target=GetAbilityTarget(npcEnemy)
				if(desire>0)
				then
					return desire-0.02,target
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
	local CastPoint = ability:GetCastPoint();
	
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local allys = AbilityExtensions:GetNearbyNonIllusionHeroes(npcBot, CastRange+300, false, BOT_MODE_ATTACK );
	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------
	-- Protect ally
	if (npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or npcBot:GetActiveMode() == BOT_MODE_ATTACK) then
		local weakestAlly, allyHealth = utility.GetWeakestUnit(allys)
		if (weakestAlly ~= nil) then
			local allyNeaybyEnemys = weakestAlly:GetNearbyHeroes(CastRange, true, BOT_MODE_NONE)
			if
				(allyHealth / weakestAlly:GetMaxHealth() < 0.4 + 0.4 * ManaPercentage + #allyNeaybyEnemys * 0.05 or
					#allyNeaybyEnemys >= 2)
				then
				return BOT_ACTION_DESIRE_MODERATE, weakestAlly
			end
		end

		for _, npcTarget in pairs(allys) do
			local allyNeaybyEnemys = npcTarget:GetNearbyHeroes(CastRange, true, BOT_MODE_NONE)
			if
				(npcTarget:GetHealth() / npcTarget:GetMaxHealth() < (0.6 + #enemys * 0.05 + 0.2 * ManaPercentage) or
					npcTarget:WasRecentlyDamagedByAnyHero(5.0) or
					#allyNeaybyEnemys >= 2)
				then
				if (CanCast[abilityNumber](npcTarget)) then
					return BOT_ACTION_DESIRE_MODERATE, npcTarget
				end
			end
		end
	end

	-- If we're in a teamfight, use it on the scariest enemy
	if ( #allys >= 2 )
	then

		local npcMostDangerousEnemy = nil;
		local nMostDangerousDamage = 0;

		for _,npcEnemy in pairs( allys )
		do
			if ( CanCast[abilityNumber]( npcEnemy ) and not enemyDisabled(npcEnemy))
			then
				local Damage2 = npcEnemy:GetOffensivePower()
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
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH or (#enemys>=2 and #allys<=1) ) 
	then
		return BOT_ACTION_DESIRE_HIGH, npcBot;
	end

	return BOT_ACTION_DESIRE_NONE, 0;
	
end

Consider[4] = function()
	local abilityNumber = 4
	local ability = AbilitiesReal[abilityNumber]
    if not ability:IsFullyCastable() or AbilityExtensions:IsPhysicalOutputDisabled(npcBot) then
        return 0
    end

    local CastRange = ability:GetCastRange()
    local enemys = npcBot:GetNearbyHeroes(CastRange+100,true,BOT_MODE_NONE)
    local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)

    local function UseAt(target)
        if not CanCast[abilityNumber](target) then
            return false
        end
        if target:IsHero() then
            if AbilityExtensions:MustBeIllusion(npcBot, target) then
                return AbilityExtensions:GetManaPercent(npcBot) >= 0.8 or AbilityExtensions:GetHealthPercent(target) <= 0.4
            else
                return AbilityExtensions:GetManaPercent(npcBot) >= 0.4 or AbilityExtensions:GetManaPercent(npcBot) >= 0.2
            end
        elseif target:IsBuilding() then
            return false
        else
            return AbilityExtensions:GetManaPercent(npcBot) >= 0.8
        end

    end

    if AbilityExtensions:NotRetreating(npcBot) then
        local target = npcBot:GetAttackTarget()
        if target == nil then
            if WeakestEnemy ~= nil then
                local b = UseAt(WeakestEnemy)
                if b then
                    return BOT_ACTION_DESIRE_HIGH, WeakestEnemy
                else
                    return false
                end
            end
        else
            return UseAt(target)
        end
    end
    return false
end
Consider[4] = AbilityExtensions:ToggleFunctionToAutoCast(npcBot, Consider[4], AbilitiesReal[4])

Consider[5]=function()

	local abilityNumber=5
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
	

	local allys = npcBot:GetNearbyHeroes( math.max(Radius,1600), false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(Radius,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	
	-- If we're in a teamfight, use it on the scariest enemy
	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		 npcBot:GetActiveMode() == BOT_MODE_ATTACK ) 
	then
		if ( #allys+#enemys >= 5 ) 
		then
			for i,npcTarget in pairs(allys)
			do
				if(npcTarget:GetActiveMode()== BOT_MODE_RETREAT or npcTarget:GetHealth()/npcTarget:GetMaxHealth()<=0.7 )
				then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end
	end
	
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