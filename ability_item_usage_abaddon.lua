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

local AbilityToLevelUp=
{
	Abilities[2],
	Abilities[3],
	Abilities[2],
	Abilities[1],
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
local cast={} cast.Desire={} cast.Target={} cast.Type={}
local Consider ={}

local enemyDisabled=utility.enemyDisabled

function GetComboDamage()
	return ability_item_usage_generic.GetComboDamage(AbilitiesReal)
end

function GetComboMana()
	return ability_item_usage_generic.GetComboMana(AbilitiesReal)
end

--Target Judement
function CanCast1( npcEnemy )
	if utility.IsEnemy(npcEnemy)== true
	then
		return npcEnemy:CanBeSeen() and not npcEnemy:IsMagicImmune() and not npcEnemy:IsInvulnerable() and not utility.HasImmuneDebuff(npcEnemy)
	else
		return npcEnemy:CanBeSeen() and not npcEnemy:IsInvulnerable();
	end
end

function CanCast2( npcEnemy )
	return npcEnemy:CanBeSeen() and not npcEnemy:IsInvulnerable() and not npcEnemy:HasModifier("modifier_abaddon_aphotic_shield");
end

local CanCast={CanCast1,CanCast2}

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
	local SelfDamage = ability:GetSpecialValueInt("self_damage");
	
	local HeroHealth=10000
	local CreepHealth=10000
	local allys = npcBot:GetNearbyHeroes( CastRange+300, false, BOT_MODE_NONE );
	for _,hero in pairs (allys)
	do
		if (hero==npcBot)
		then
			table.remove(allys,_)
		end
	end
	local WeakestAlly,AllyHealth=utility.GetWeakestUnit(allys)
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
				if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL))
				then
					return BOT_ACTION_DESIRE_HIGH,WeakestEnemy; 
				end
			end
		end
	end
	
	-- If we're seriously retreating, try to suicide
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH ) 
	then
		if ( #enemys>=1 and npcBot:WasRecentlyDamagedByAnyHero(2.0) and npcBot:GetHealth() <= SelfDamage) 
		then
			if ( CanCast[abilityNumber]( enemys[1] )) 
			then
				return BOT_ACTION_DESIRE_HIGH, enemys[1];
			end
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	--protect teammate
	if(npcBot:GetHealth()/npcBot:GetMaxHealth()>(0.4-#enemys*0.05) or npcBot:HasModifier("modifier_abaddon_aphotic_shield") or npcBot:HasModifier("modifier_abaddon_borrowed_time"))
	then
		if (WeakestAlly~=nil)
		then
			if(AllyHealth/WeakestAlly:GetMaxHealth()<0.5)
			then
				return BOT_ACTION_DESIRE_MODERATE,WeakestAlly
			end
		end
		
		for _,npcTarget in pairs( allys )
		do
			if(npcTarget:GetHealth()/npcTarget:GetMaxHealth()<(0.5+#enemys*0.05))
			then
				if ( CanCast[abilityNumber]( npcTarget ) )
				then
					return BOT_ACTION_DESIRE_MODERATE, npcTarget
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
		if(npcBot:GetHealth()/npcBot:GetMaxHealth()>(0.5-#enemys*0.05) or npcBot:HasModifier("modifier_abaddon_aphotic_shield" )or npcBot:HasModifier("modifier_abaddon_borrowed_time"))
		then
			local npcEnemy = npcBot:GetTarget();
			if ( npcEnemy ~= nil ) 
			then
				if ( CanCast[abilityNumber]( npcEnemy ) and GetUnitToUnitDistance(npcBot,npcEnemy)< CastRange + 75*#allys)
				then
					return BOT_ACTION_DESIRE_MODERATE, npcEnemy
				end
			end
		end
	end
	
	-- If we're farming
	if ( npcBot:GetActiveMode() == BOT_MODE_FARM )
	then
		if ( #creeps >= 2 and npcBot:HasModifier("modifier_abaddon_aphotic_shield")) 
		then
			if(ManaPercentage>0.5)
			then
				return BOT_ACTION_DESIRE_LOW,WeakestCreep; 
			end	
		end
	end
	
	-- If our mana is enough,use it at enemy
	if ( npcBot:GetActiveMode() == BOT_MODE_LANING ) 
	then
		if(ManaPercentage>0.4 and (npcBot:GetHealth()/npcBot:GetMaxHealth()>0.75 or npcBot:HasModifier("modifier_abaddon_aphotic_shield")) and ability:GetLevel()>=2 )
		then
			if (WeakestEnemy~=nil)
			then
				if ( CanCast[abilityNumber]( WeakestEnemy ) )
				then
					return BOT_ACTION_DESIRE_LOW,WeakestEnemy;
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
	
	local HeroHealth=10000
	local CreepHealth=10000
	local allys = npcBot:GetNearbyHeroes( CastRange+300, false, BOT_MODE_NONE );
	local WeakestAlly,AllyHealth=utility.GetWeakestUnit(allys)
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange+300,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------
	--protect teammate,save allys from control
	for _,npcTarget in pairs( allys )
	do
		if(enemyDisabled(npcTarget))
		then
			if ( CanCast[abilityNumber]( npcTarget ) )
			then
				return BOT_ACTION_DESIRE_HIGH, npcTarget
			end
		end
	end
	if(	npcBot:GetActiveMode() == BOT_MODE_ATTACK or
		npcBot:GetActiveMode() == BOT_DEFEND_ALLY or
		ManaPercentage>0.4)
	then
		for _,npcTarget in pairs( allys )
		do
			if(	npcTarget:GetCurrentMovementSpeed()<250 or npcTarget:IsSilenced() or npcTarget:IsMuted() or 
				npcTarget:IsNightmared() or npcTarget:IsDisarmed() or npcTarget:IsBlind() or npcTarget:IsBlockDisabled())
			then
				if ( CanCast[abilityNumber]( npcTarget ) )
				then
					return BOT_ACTION_DESIRE_HIGH, npcTarget
				end
			end
		end
	end
	
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT) 
	then
		if(#enemys>=1 and CanCast[abilityNumber]( npcBot ))
		then
			return BOT_ACTION_DESIRE_HIGH,npcBot; 	
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	
	--teamfightUsing
	if(npcBot:GetActiveMode() == BOT_MODE_ATTACK or 
		npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY) 
	then
		if (WeakestAlly~=nil)
		then
			if(AllyHealth/WeakestAlly:GetMaxHealth()<0.3+0.4*ManaPercentage)
			then
				if(CanCast[abilityNumber]( WeakestAlly ))
				then
					return BOT_ACTION_DESIRE_MODERATE,WeakestAlly
				end
			end
		end
			
		for _,npcTarget in pairs( allys )
		do
			if(npcTarget:GetHealth()/npcTarget:GetMaxHealth()<(0.6+#enemys*0.05+0.2*ManaPercentage) or npcTarget:WasRecentlyDamagedByAnyHero(5.0))
			then
				if ( CanCast[abilityNumber]( npcTarget ) )
				then
					return BOT_ACTION_DESIRE_MODERATE, npcTarget
				end
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
			if (ManaPercentage>0.4)
			then
				for _,npcTarget in pairs( allys )
				do
					if ( CanCast[abilityNumber]( npcTarget ) )
					then
						return BOT_ACTION_DESIRE_MODERATE, npcTarget
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
		
		if(ManaPercentage>0.4 and HealthPercentage<=0.66)
		then
			if ( npcEnemy ~= nil ) 
			then
				if ( CanCast[abilityNumber]( npcBot ))
				then
					return BOT_ACTION_DESIRE_MODERATE, npcBot;
				end
			end
		end
	end

	-- If my mana is enough,use it
	if ( npcBot:GetActiveMode() == BOT_MODE_LANING) 
	then
		if(#enemys>=1 and CanCast[abilityNumber]( npcBot ))
		then
			if(ManaPercentage>0.5)
			then
				npcBot:SetTarget(WeakestEnemy)
				return BOT_ACTION_DESIRE_LOW,npcBot; 
			end		
		end
	end
	
	-- If we're farming
	if ( npcBot:GetActiveMode() == BOT_MODE_FARM )
	then
		if ( #creeps >= 2 and CanCast[abilityNumber]( npcBot )) 
		then
			if(ManaPercentage>0.5)
			then
				return BOT_ACTION_DESIRE_LOW,npcBot; 
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

	-- In case of silence
	if(npcBot:GetHealth()<=400)
	then
		return BOT_ACTION_DESIRE_HIGH;
	end

	return BOT_ACTION_DESIRE_NONE
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