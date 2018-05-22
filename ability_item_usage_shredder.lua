----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.5f
--	Author: adamqqq		Email:adamqqq@163.com
--  Contributor: zmcmcc Email:mengzhang@utexas.edu
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
local ultTime = nil;

ability_item_usage_generic.InitAbility(Abilities,AbilitiesReal,Talents) 

local AbilityToLevelUp=
{
	Abilities[3],
	Abilities[1],
	Abilities[3],
	Abilities[2],
	Abilities[3],
	Abilities[5],
	Abilities[3],
	Abilities[2],
	Abilities[2],
	"talent",
	Abilities[2],
	Abilities[5],
	Abilities[1],
	Abilities[1],
	"talent",
	Abilities[1],
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
		return Talents[3]
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


Consider[1]=function()
	local abilityNumber=1
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability=AbilitiesReal[abilityNumber];
	
	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local Damage = ability:GetAbilityDamage()
	local Radius = ability:GetAOERadius()
	local CastPoint = ability:GetCastPoint()
	
	local HeroHealth=10000
	local CreepHealth=10000
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(Radius,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(Radius,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
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
				if( HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana 
					and GetUnitToUnitDistance(npcBot,WeakestEnemy) < Radius)
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
	if(ManaPercentage>0.4 or npcBot:GetMana()>ComboMana)
	then
		if(npcBot:WasRecentlyDamagedByAnyHero(2) and #enemys >=2)
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

	--Last hit
	if ( npcBot:GetActiveMode() == BOT_MODE_LANING ) 
	then
		if(WeakestCreep~=nil)
		then
			if((ManaPercentage>0.65 or npcBot:GetMana()>ComboMana) and GetUnitToUnitDistance(npcBot,WeakestCreep) < Radius)
			then
				if(CreepHealth<=WeakestCreep:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL))
				then					
					return BOT_ACTION_DESIRE_LOW
				end
			end		
		end
	end
	
	-- If we're pushing or defending a lane
	if ( npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT ) 
	then
		if ( #enemys+#creeps>=3) 
		then
			if (ManaPercentage>0.5 or npcBot:GetMana()>ComboMana)
			then
				return BOT_ACTION_DESIRE_LOW
			end
		end
	end
	
	
	-- If we're farming and can hit 2+ creeps
	if ( npcBot:GetActiveMode() == BOT_MODE_FARM )
	then
		if ( #creeps >= 3 ) 
		then
			if(ManaPercentage>0.4 or npcBot:GetMana()>ComboMana)
			then
				return BOT_ACTION_DESIRE_LOW
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
			if ( CanCast[abilityNumber]( npcEnemy ) and GetUnitToUnitDistance(npcBot,npcEnemy)<Radius)
			then
				return BOT_ACTION_DESIRE_MODERATE
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end


function GetBestTree(npcBot, enemy, CastRange, hitRadios)
   
	--find a tree behind enemy
	local bestTree=nil;
	local mindis=10000;

	local trees=npcBot:GetNearbyTrees(CastRange);
	
	for _,tree in pairs(trees) do
		local x=GetTreeLocation(tree);
		local y=npcBot:GetLocation();
		local z=enemy:GetLocation();
		
		if x~=y then
			local a=1;
			local b=1;
			local c=0;
		
			if x.x-y.x ==0 then
				b=0;
				c=-x.x;
			else
				a=-(x.y-y.y)/(x.x-y.x);
				c=-(x.y + x.x*a);
			end
		
			local d = math.abs((a*z.x+b*z.y+c)/math.sqrt(a*a+b*b));
			if d<=hitRadios and mindis>GetUnitToLocationDistance(enemy,x) and (GetUnitToLocationDistance(enemy,x)<=GetUnitToLocationDistance(npcBot,x)) then
				bestTree=x;
				mindis=GetUnitToLocationDistance(enemy,x);
			end
		end
	end
	
	return bestTree;

end

function GetBestRetreatTree(npcBot, CastRange)
	local trees=npcBot:GetNearbyTrees(CastRange);
	
	local dest=utility.VectorTowards(npcBot:GetLocation(),utility.Fountain(GetTeam()),1000);
	
	local BestTree=nil;
	local maxdis=0;
	
	for _,tree in pairs(trees) do
		local loc=GetTreeLocation(tree);
		
		if (not utility.AreTreesBetween(loc,100)) and 
			GetUnitToLocationDistance(npcBot,loc)>maxdis and 
			GetUnitToLocationDistance(npcBot,loc)<CastRange and 
			utility.GetDistance(loc,dest)<880 
		then
			maxdis=GetUnitToLocationDistance(npcBot,loc);
			BestTree=loc;
		end
	end
	
	if BestTree~=nil and maxdis>250 then
		return BestTree;
	end
	
	return nil;
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

	local Damage = ability:GetSpecialValueInt("damage");
	local Radius = ability:GetSpecialValueInt( "chain_radius" );
	local Speed = ability:GetSpecialValueInt( "speed" );
	local CastPoint = ability:GetCastPoint();
	local CastRange = ability:GetCastRange();
	
	local HeroHealth=10000
	local CreepHealth=10000
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(Radius,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(Radius,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
	
	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------
	
	
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH ) 
	then
		local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( 1200, true, BOT_MODE_NONE );
		if tableNearbyEnemyHeroes ~= nil and #tableNearbyEnemyHeroes >= 1 then
			local BRTree = GetBestRetreatTree(npcBot, CastRange);
			if BRTree ~= nil then
				return BOT_ACTION_DESIRE_MODERATE, BRTree
		end
	end
	
	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		 npcBot:GetActiveMode() == BOT_MODE_ATTACK ) 
	then
		local npcTarget = npcBot:GetTarget();
		if (npcTarget ~= nil) then
			if ( GetUnitToUnitDistance(npcBot,npcTarget) < CastRange and not utility.AreTreesBetween( npcTarget:GetLocation(),Radius ) ) 
			then
			
				local BTree = GetBestTree(npcBot, npcTarget, CastRange, Radius);
				if BTree ~= nil then
					return BOT_ACTION_DESIRE_MODERATE, BTree;
				end
			end
		end
	end

	--try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		if (WeakestEnemy~=nil)
		then
			if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL) 
				or (HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana)
				or HeroHealth/WeakestEnemy:GetMaxHealth() < 0.65)
			then
				if ( GetUnitToUnitDistance(npcBot,npcTarget) < CastRange and not utility.AreTreesBetween( npcTarget:GetLocation(),Radius ) ) 
				then
				local BTree = GetBestTree(npcBot, npcTarget, CastRange, Radius);
					if BTree ~= nil then
						return BOT_ACTION_DESIRE_MODERATE, BTree;
					end
				end
			end
		end
	end
	
	return BOT_ACTION_DESIRE_NONE, 0;
end



Consider[5]=function()
	local abilityNumber=5
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability=AbilitiesReal[abilityNumber];
	
	if not ability:IsFullyCastable() or ability:IsHidden() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = ability:GetCastRange();
	local Damage = ability:GetAbilityDamage();
	local Radius = 200;
	local CastPoint = ability:GetCastPoint();
	local Speed = 900;
	
	local HeroHealth=10000
	local CreepHealth=10000
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(1600,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(1600,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)


	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------
	--try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		if (WeakestEnemy~=nil)
		then
			if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL) 
				or (HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana)
				or HeroHealth/WeakestEnemy:GetMaxHealth() < 0.65)
			then
				local dist =  GetUnitToUnitDistance(npcBot, WeakestEnemy);
				ultTime = DotaTime();
				return BOT_ACTION_DESIRE_HIGH, npcBot:GetXUnitsTowardsLocation( WeakestEnemy:GetLocation(), dist + (dist/Speed+CastPoint)*350); 
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
			ultTime = DotaTime();
				return BOT_ACTION_DESIRE_HIGH, npcEnemy:GetExtrapolatedLocation( GetUnitToUnitDistance(npcEnemy, npcBot)/Speed + CastPoint );
			end
		end
	end

	-- If we're pushing or defending a lane and can hit 4+ creeps
	if ( npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT ) 
	then
		if((ManaPercentage>0.4 or npcBot:GetMana()>ComboMana))
		then
			local locationAoE = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), CastRange, Radius, CastPoint, 0 );
			if ( locationAoE.count >= 5 ) 
			then
			ultTime = DotaTime();
				return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc;
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
				local dist =  GetUnitToUnitDistance(npcBot, npcTarget);
				if dist < CastRange or npcTarget:GetHealth()/npcTarget:GetMaxHealth() < 0.65
				then
				ultTime = DotaTime();
					return BOT_ACTION_DESIRE_HIGH-0.1, npcBot:GetXUnitsTowardsLocation( npcTarget:GetLocation(), dist + (dist/Speed+CastPoint)*350);
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;
end

Consider[6]=function()
	local abilityNumber=6
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability=AbilitiesReal[abilityNumber];
	
	if not ability:IsFullyCastable() or ability:IsHidden() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end

	local Radius = ability:GetSpecialValueFloat( "radius" );
	local Damage = ability:GetSpecialValueInt("pass_damage");
	local ManaCost = ability:GetManaCost();

	if npcBot:GetMana() < 150 then
		return BOT_ACTION_DESIRE_HIGH;
	end

	if ultTime ~= nil then
		if DotaTime() - ultTime > 2 then
			ultTime = nil;
			return BOT_ACTION_DESIRE_HIGH;
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;
end

Consider[4]=function()		--A杖大
	local abilityNumber=4
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability=AbilitiesReal[abilityNumber];
	
	if not ability:IsFullyCastable() or ability:IsHidden() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = ability:GetCastRange();
	local Damage = ability:GetAbilityDamage();
	local Radius = 200;
	local CastPoint = ability:GetCastPoint();
	local Speed = 900;
	
	local HeroHealth=10000
	local CreepHealth=10000
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(1600,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(1600,true)
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
				if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL) 
					or (HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana)
					or HeroHealth/WeakestEnemy:GetMaxHealth() < 0.65)
				then
					local dist =  GetUnitToUnitDistance(npcBot, WeakestEnemy);
					return BOT_ACTION_DESIRE_HIGH, npcBot:GetXUnitsTowardsLocation( WeakestEnemy:GetLocation(), dist + (dist/Speed+CastPoint)*350); 
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
					return BOT_ACTION_DESIRE_HIGH, npcEnemy:GetExtrapolatedLocation( GetUnitToUnitDistance(npcEnemy, npcBot)/Speed + CastPoint );
				end
			end
		end
	end

	-- If we're pushing or defending a lane and can hit 4+ creeps
	if ( npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT ) 
	then
		if((ManaPercentage>0.4 or npcBot:GetMana()>ComboMana))
		then
			local locationAoE = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), CastRange, Radius, CastPoint, 0 );
			if ( locationAoE.count >= 5 ) 
			then
				return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc;
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
			if ( CanCast[abilityNumber]( npcTarget ) )
			then
				local dist =  GetUnitToUnitDistance(npcBot, npcTarget);
				if dist < CastRange or npcTarget:GetHealth()/npcTarget:GetMaxHealth() < 0.65
				then
					return BOT_ACTION_DESIRE_HIGH-0.1, npcBot:GetXUnitsTowardsLocation( npcTarget:GetLocation(), dist + (dist/Speed+CastPoint)*350);
				end
			end
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
