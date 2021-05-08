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
	Abilities[2],
	Abilities[1],
	Abilities[2],
	Abilities[2],
	Abilities[6],
	Abilities[2],
	Abilities[1],
	Abilities[1],
	"talent",
	Abilities[3],
	Abilities[6],
	Abilities[3],
	Abilities[3],
	"talent",
	Abilities[3],
	"nil",
	Abilities[6],
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
		return Talents[6]
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
local CanCast={utility.NCanCast,utility.NCanCast,utility.NCanCast,utility.UCanCast,utility.UCanCast}
local enemyDisabled=utility.enemyDisabled

function GetComboDamage()
	return ability_item_usage_generic.GetComboDamage(AbilitiesReal)
end

function GetComboMana()
	return ability_item_usage_generic.GetComboMana(AbilitiesReal)
end

Consider[1]=function()

	local ability=AbilitiesReal[1];
	
	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = ability:GetCastRange();
	local Damage = ability:GetSpecialValueInt("arc_damage");
	

	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyLaneCreeps(CastRange+300,true)
	local Allcreeps = npcBot:GetNearbyCreeps(CastRange+300,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
	
	--try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		if (WeakestEnemy~=nil)
		then
			if ( CanCast[1]( WeakestEnemy ) )
			then
				if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL)*3 or (HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana))
				then
					return BOT_ACTION_DESIRE_HIGH,WeakestEnemy; 
				end
			end
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	
	--teamfightUsing
	if(npcBot:GetActiveMode() == BOT_MODE_ATTACK ) 
	then
		if(ManaPercentage>0.4 or npcBot:GetMana()>ComboMana)
		then
			if (#enemys+#creeps>2)
			then
				if(WeakestCreep~=nil)
				then
					return BOT_ACTION_DESIRE_HIGH,WeakestCreep; 
				end
				if(WeakestEnemy~=nil)
				then
					if ( CanCast[1]( WeakestEnemy ) )
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
			if((ManaPercentage>0.45 or npcBot:GetMana()>ComboMana) and GetUnitToUnitDistance(npcBot,WeakestCreep)>=AttackRange-ManaPercentage)
			then
				if(CreepHealth<=WeakestCreep:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL))
				then					
				
					return BOT_ACTION_DESIRE_MODERATE+0.05,WeakestCreep; 
				end
			end		
		end
	end
	
	-- If we're farming and can hit 2+ creeps and kill 1+ 
	if ( npcBot:GetActiveMode() == BOT_MODE_FARM )
	then
		if ( #Allcreeps >= 2 ) 
		then
			if(CreepHealth<=Allcreeps[1]:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL) and ManaPercentage>0.45 and npcBot:GetMana()>ComboMana)
			then
				return BOT_ACTION_DESIRE_LOW, Allcreeps[1];
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
		if ( #enemys+#creeps >= 3 and ManaPercentage>0.4 or npcBot:GetMana()>ComboMana) 
		then
			if (WeakestEnemy~=nil)
			then
				if ( CanCast[1]( WeakestEnemy )and GetUnitToUnitDistance(npcBot,WeakestEnemy)< CastRange + 75*#allys )
				then
					return BOT_ACTION_DESIRE_LOW, WeakestEnemy;
				end
			end
			if (WeakestCreep~=nil)
			then
				if ( CanCast[1]( WeakestCreep )and GetUnitToUnitDistance(npcBot,WeakestCreep)< CastRange + 75*#allys )
				then
					return BOT_ACTION_DESIRE_LOW, WeakestCreep;
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
				if ( CanCast[1]( npcTarget )  and GetUnitToUnitDistance(npcBot,npcTarget)< CastRange + 75*#allys)
				then
					return BOT_ACTION_DESIRE_MODERATE, npcTarget;
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;
	
end

Consider[2]=function()

	local ability=AbilitiesReal[2];
	
	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0 ,"nil";
	end
	
	local CastRange = ability:GetCastRange();
	local Damage = ability:GetAbilityDamage();
	

	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange+300,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
	
	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------
	-- Check for a channeling enemy
	for _,enemy in pairs( enemys )
	do
		if ( enemy:IsChanneling() and CanCast[2]( enemy ) and not enemy:HasModifier("modifier_antimage_counterspell")) 
		then
			return BOT_ACTION_DESIRE_HIGH, enemy,"Target";
		end
	end
	
	-- Kill enemy
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT )
	then
		if (WeakestEnemy~=nil)
		then
			if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL) or (HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana))
			then
				if ( CanCast[2]( WeakestEnemy ) )
				then
					return BOT_ACTION_DESIRE_HIGH,WeakestEnemy,"Target";
				end
			end
		end
	end
	
	--protect myself
	local enemys2 = npcBot:GetNearbyHeroes( CastRange, true, BOT_MODE_NONE );
	if(npcBot:WasRecentlyDamagedByAnyHero(5))
	then
		for _,enemy in pairs( enemys2 )
		do
			if ( CanCast[2]( enemy ) )and not enemy:HasModifier("modifier_antimage_counterspell") and not enemy:HasModifier("modifier_item_lotus_orb_active") and not enemy:HasModifier("modifier_item_blade_mail")
			then
				return BOT_ACTION_DESIRE_HIGH, enemy,"Target"
			end
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	--����
	--if ( npcBot:GetActiveMode() == BOT_MODE_LANING ) 
	--then
		if((ManaPercentage>0.4 or npcBot:GetMana()>ComboMana) and ability:GetLevel()>=2 )
		then
			if (WeakestEnemy~=nil)
			then
				if ( CanCast[2]( WeakestEnemy ) )
				then
					return BOT_ACTION_DESIRE_LOW,WeakestEnemy,"Target";
				end
			end
		end
	--end

	-- If we're pushing or defending a lane and can hit 4+ creeps, go for it
	if ( npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT ) 
	then
		if (WeakestEnemy~=nil)
		then
			if ( CanCast[2]( WeakestEnemy )and GetUnitToUnitDistance(npcBot,WeakestEnemy)< CastRange + 75*#allys )
			then
				return BOT_ACTION_DESIRE_LOW,WeakestEnemy,"Target";
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
			if ( CanCast[2]( npcTarget ) and GetUnitToUnitDistance(npcBot,npcTarget)< CastRange + 75*#allys)
			then
				return BOT_ACTION_DESIRE_MODERATE, npcTarget,"Target";
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0 ,"nil";
end

Consider[6]=function()
	
	local ability=AbilitiesReal[6]
	if not ability:IsFullyCastable() 
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local Damage = 125+100*ability:GetLevel()
	local WeakestEnemy=nil
	local LowestHP=10000.0
	
	for _,Enemy in pairs (GetUnitList(UNIT_LIST_ENEMY_HEROES)) 
	do
		if Enemy~=nil
		then
			if(GetUnitToUnitDistance(npcBot,Enemy)>AbilitiesReal[2]:GetCastRange() or not AbilitiesReal[2]:IsFullyCastable())
			then
				if Enemy:IsAlive() and Enemy:CanBeSeen() and CanCast[4](Enemy)
				then
					if (LowestHP>Enemy:GetHealth())
					then
						WeakestEnemy=Enemy;
						LowestHP=Enemy:GetHealth();
					end
				end
			end
		end
	end
	
	if (WeakestEnemy==nil or LowestHP<1)
	then
		return BOT_ACTION_DESIRE_NONE
	end

	if LowestHP<=WeakestEnemy:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL)
	then
		--return BOT_ACTION_DESIRE_VERYHIGH
		local time_byname=WeakestEnemy:GetUnitName()
		local allys=WeakestEnemy:GetNearbyHeroes( 600, false, BOT_MODE_ATTACK );
		if(#allys==0 or allys[1]==npcBot)
		then
			-- Don't rush to get the kill
			return BOT_ACTION_DESIRE_MODERATE
		else
			if(npcBot.ult==nil)
			then
				npcBot.ult={}
			end
			if(npcBot.ult.time_byname==nil)
			then
				npcBot.ult.time_byname={DotaTime(),WeakestEnemy,WeakestEnemy:GetPlayerID()}
			end	
		end
	end
	
	if(npcBot.ult~=nil)
	then
		for _,i in pairs(npcBot.ult)
		do
			if(DotaTime()-i[1]>=3)
			then
				if(i[2]==nil or i[2]:IsNull() or i[2]:GetHealth()<=i[2]:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL) and IsHeroAlive(i[3]))
				then
					npcBot.ult=nil
					return BOT_ACTION_DESIRE_VERYHIGH
				end
			end
		end	
	end

	
	return BOT_ACTION_DESIRE_NONE
end

Consider[4]=function()
	
	local ability=AbilitiesReal[4]
	if not ability:IsFullyCastable() 
	then
		return BOT_ACTION_DESIRE_NONE
	end
	
	local CastRange = ability:GetCastRange();
	
	local CreepHealth=10000;
	local enemys = npcBot:GetNearbyHeroes( 1600, true, BOT_MODE_NONE );
	local WeakestEnemy,CreepHealth=utility.GetWeakestUnit(enemys)
	
	local tower=nil
	
	if ( npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT )
	then
		local tower=npcBot:GetNearbyTowers(1500,false)
	end
	
	if (npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
		npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
		npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT ) 
	then
		local tower=npcBot:GetNearbyTowers(1000,true)
	end
	
	if(tower~=nil and GetUnitToUnitDistance(npcBot,tower[1])<CastRange+500)
	then
		return BOT_ACTION_DESIRE_LOW,tower[1]:GetLocation()
	end
	
	if (WeakestEnemy~=nil)
	then
		return BOT_ACTION_DESIRE_LOW,WeakestEnemy:GetLocation()
	end
	
	return BOT_ACTION_DESIRE_NONE,0
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