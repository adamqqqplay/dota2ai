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
	Abilities[3],
	Abilities[3],
	Abilities[2],
	Abilities[3],
	Abilities[4],
	Abilities[3],
	Abilities[1],
	Abilities[1],
	"talent",
	Abilities[1],
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
local castDesire = {}
local castTarget = {}
local castLocation = {}
local castType = {}

--Target Judement
local CanCast={utility.NCanCast,utility.NCanCast,utility.NCanCast,utility.UCanCast}

function enemyDisabled(npcEnemy)
	if npcEnemy:IsRooted( ) or npcEnemy:IsStunned( ) or npcEnemy:IsHexed( ) then
		return true;
	end
	return false;
end
--Combo Variable Getting
local function GetComboDamage()
	return npcBot:GetOffensivePower()
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
	HealthPercentage=npcBot:GetHealth()/npcBot:GetMaxHealth()
	
	-- Consider using each ability
	castDesire[1], castLocation[1] = Consider1();
	castDesire[2], castTarget[2] = Consider2();
	castDesire[3], castLocation[3] = Consider3();
	castDesire[4] = Consider4();
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
	if ( castDesire[4] > 0 ) 
	then
		npcBot:Action_UseAbility( AbilitiesReal[4] );
		return
	end

	if ( castDesire[3] > 0 ) 
	then
		npcBot:Action_UseAbilityOnLocation( AbilitiesReal[3], castLocation[3] );
		return
	end
	
	if ( castDesire[2] > 0 ) 
	then
		npcBot:Action_UseAbilityOnEntity( AbilitiesReal[2], castTarget[2] );
		return
	end

	if ( castDesire[1] > 0 ) 
	then
		npcBot:Action_UseAbilityOnLocation( AbilitiesReal[1], castLocation[1] );
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
	local Damage = ability:GetLevel()*75
	local Radius = ability:GetAOERadius()
	
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
	--try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		if (WeakestEnemy~=nil)
		then
			if ( CanCast[abilityNumber]( WeakestEnemy ) )
			then
				if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL) or (HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana))
				then
					return BOT_ACTION_DESIRE_HIGH,utility.GetUnitsTowardsLocation(WeakestEnemy,npcBot,Radius/2);
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
		for _,npcEnemy in pairs(enemys)
		do
			if ( npcBot:WasRecentlyDamagedByHero( npcEnemy, 2.0 ) ) 
			then
				if ( CanCast[abilityNumber]( npcEnemy ) ) 
				then
					return BOT_ACTION_DESIRE_MODERATE-0.05,utility.GetUnitsTowardsLocation(npcEnemy,npcBot,Radius/2);
				end
			end
		end
	end
	
	if(npcBot:GetActiveMode() == BOT_MODE_ATTACK)
	then
		if(ManaPercentage>0.4 or npcBot:GetMana()>ComboMana )
		then
			local locationAoE = npcBot:FindAoELocation( true, true, npcBot:GetLocation(), CastRange, Radius, 0, 0 );
			if ( locationAoE.count >= 2 and GetUnitToLocationDistance(npcBot,locationAoE.targetloc)<=CastRange) 
			then
				return BOT_ACTION_DESIRE_MODERATE-0.04, locationAoE.targetloc;
			end
		end
	end
	
	-- If we're pushing or defending a lane and can hit 4+ creeps, go for it
	if ( npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT ) 
	then
		if(ManaPercentage>0.4 or npcBot:GetMana()>ComboMana )
		then
			local locationAoE = npcBot:FindAoELocation( true, true, npcBot:GetLocation(), CastRange, Radius, 0, 0 );
			if ( locationAoE.count >=2 and GetUnitToLocationDistance(npcBot,locationAoE.targetloc)<=CastRange) 
			then
				return BOT_ACTION_DESIRE_MODERATE-0.03, locationAoE.targetloc;
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
			if ( CanCast[abilityNumber]( npcEnemy ) and GetUnitToUnitDistance(npcBot,npcEnemy))
			then
				return BOT_ACTION_DESIRE_MODERATE-0.02, utility.GetUnitsTowardsLocation(npcEnemy,npcBot,Radius/2);
			end
		end
	end
	
	--laning
	if ( npcBot:GetActiveMode() == BOT_MODE_LANING ) 
	then
		if((ManaPercentage>0.4 or npcBot:GetMana()>ComboMana))
		then
			local locationAoE = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), CastRange, Radius, 0, Damage );

			if ( locationAoE.count >= 1 and GetUnitToLocationDistance(npcBot,locationAoE.targetloc)>=300 and GetUnitToLocationDistance(npcBot,locationAoE.targetloc)<=CastRange)
			then
				return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc;
			end
		end
		
		if((ManaPercentage>0.4 or npcBot:GetMana()>ComboMana))
		then
			local locationAoE = npcBot:FindAoELocation( true, true, npcBot:GetLocation(), CastRange, Radius, 0, 0 );
			if ( locationAoE.count >= 2 and GetUnitToLocationDistance(npcBot,locationAoE.targetloc)<=CastRange)
			then
				return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc;
			end
		end
	end
	
	-- If we're farming and can kill 3+ creeps
	if ( npcBot:GetActiveMode() == BOT_MODE_FARM ) then
		if(ManaPercentage>0.4 or npcBot:GetMana()>ComboMana )
		then
			local locationAoE = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), CastRange, Radius, 0, 0 );
			if ( locationAoE.count >= 3 and GetUnitToLocationDistance(npcBot,locationAoE.targetloc)<=CastRange) then
				return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc;
			end
		end
	end
	
	return BOT_ACTION_DESIRE_NONE, 0;
	
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
	local Radius = ability:GetAOERadius()
	local searchcreeps = npcBot:GetNearbyCreeps(Radius,true)
	local Damage = math.min(#searchcreeps,ability:GetSpecialValueInt("max_units"))*ability:GetSpecialValueInt("damage_per_unit")
	
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
	
	--Protect myself
	if ( (npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:WasRecentlyDamagedByAnyHero(2)) or HealthPercentage<=0.4+#enemys*0.05+0.2*ManaPercentage) 
	then
		if(#enemys>=1)
		then
			return BOT_ACTION_DESIRE_HIGH,npcBot; 	
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	--teamfightUsing
	do
		if (WeakestAlly~=nil)
		then
			if(AllyHealth/WeakestAlly:GetMaxHealth()<0.3+0.4*ManaPercentage)
			then
				return BOT_ACTION_DESIRE_MODERATE,WeakestAlly
			end
		end
			
		for _,npcTarget in pairs( allys )
		do
			if(npcTarget:GetHealth()/npcTarget:GetMaxHealth()<(0.6+#enemys*0.05+0.2*ManaPercentage) and npcTarget:WasRecentlyDamagedByAnyHero(2.0))
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
		if(ManaPercentage>0.4)
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
	
	return BOT_ACTION_DESIRE_NONE, 0;
end

function table.merge( tDest, tSrc )
	for k, v in pairs( tSrc ) do
		tDest[k] = v
	end
end
	
function Consider3()
	
	local abilityNumber=3
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability=AbilitiesReal[abilityNumber];
	
	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = ability:GetCastRange();
	local Radius = ability:GetAOERadius()
	
	local HeroHealth=10000
	local CreepHealth=10000
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange+150,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange+150,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
	local towers = npcBot:GetNearbyTowers(CastRange+300,true)
	local towers2 =npcBot:GetNearbyTowers(CastRange+300,false)
	table.merge(towers,towers2)
	local trees=npcBot:GetNearbyTrees( CastRange-200 )
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	--Try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		if (WeakestEnemy~=nil)
		then
			if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana)
			then
				local trees2=WeakestEnemy:GetNearbyTrees( CastRange-200 )
				if ( #enemys+#allys>=4 and #enemys>=1 and GetUnitToUnitDistance(npcBot,WeakestEnemy)<=CastRange)
				then
					if(#trees2>=1)
					then
						return BOT_ACTION_DESIRE_MODERATE-0.02,GetTreeLocation(trees2[#trees2])
					else
						return BOT_ACTION_DESIRE_MODERATE-0.02, utility.GetUnitsTowardsLocation(WeakestEnemy,npcBot,Radius/2);
					end
				end
			end
		end
	end
	
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH ) 
	then
		if ( npcBot:WasRecentlyDamagedByAnyHero(2) ) 
		then
			if(#trees>=1 and #enemys>=1)
			then
				return BOT_ACTION_DESIRE_MODERATE-0.05,GetTreeLocation(trees[#trees])
			else
				return BOT_ACTION_DESIRE_MODERATE-0.05,npcBot:GetLocation()
			end
		end
	end
	
	-- If we're pushing or defending a lane and can hit 4+ creeps, go for it
	if ( npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT ) 
	then
		if(#enemys+#allys>=4 and #enemys>=1 and #towers>=1)
		then
			local locationAoE = npcBot:FindAoELocation( true, true, npcBot:GetLocation(), CastRange, Radius, 0, 0 );
			if ( locationAoE.count >=2) 
			then
				return BOT_ACTION_DESIRE_MODERATE-0.03, locationAoE.targetloc;
			end
			if(#trees>=1)
			then
				return BOT_ACTION_DESIRE_MODERATE-0.03,GetTreeLocation(trees[#trees])
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
			local trees2=npcEnemy:GetNearbyTrees( CastRange-200 )
			if ( #enemys+#allys>=4 and #enemys>=1 and GetUnitToUnitDistance(npcBot,npcEnemy)<=CastRange)
			then
				if(#trees2>=1)
				then
					return BOT_ACTION_DESIRE_MODERATE-0.02,GetTreeLocation(trees2[#trees2])
				else
					return BOT_ACTION_DESIRE_MODERATE-0.02, utility.GetUnitsTowardsLocation(npcEnemy,npcBot,Radius/2);
				end
			end
		end
	end
	
	-- If we're farming and can kill 3+ creeps
	if ( npcBot:GetActiveMode() == BOT_MODE_FARM ) then
		if(ManaPercentage>0.4 or npcBot:GetMana()>ComboMana and #creeps>=8)
		then
			local locationAoE = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), CastRange, Radius, 0, 0 );
			if ( locationAoE.count >= 5 ) then
				return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc;
			end
		end
	end
	
	return BOT_ACTION_DESIRE_NONE, 0;
	
end

function Consider4()

	local abilityNumber=4
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability=AbilitiesReal[abilityNumber];
	
	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = ability:GetCastRange();
	local Radius = ability:GetAOERadius()
	
	local HeroHealth=10000
	local CreepHealth=10000
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(Radius,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH ) 
	then
		if ( npcBot:WasRecentlyDamagedByAnyHero(2) ) 
		then
			return BOT_ACTION_DESIRE_MODERATE-0.05
		end
	end
	
	local disabledheronum=0
	for _,temphero in pairs(enemys)
	do
		if (enemyDisabled(temphero) or temphero:GetCurrentMovementSpeed()<=200)
		then
			disabledheronum=disabledheronum+1
		end
	end
			
	if ( npcBot:GetActiveMode() == BOT_MODE_ATTACK ) 
	then
		if ( #enemys+#allys+disabledheronum >= 5) 
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
			if ( npcEnemy:GetHealth()<=npcEnemy:GetActualIncomingDamage(npcBot:GetOffensivePower(),DAMAGE_TYPE_MAGICAL) and GetUnitToUnitDistance(npcEnemy,npcBot)<=Radius)
			then
				return BOT_ACTION_DESIRE_MODERATE
			end
		end
	end
	
	return BOT_ACTION_DESIRE_NONE;
	
end

function CourierUsageThink() 
	ability_item_usage_generic.CourierUsageThink()
end