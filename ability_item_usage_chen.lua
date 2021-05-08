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
	Abilities[3],
	Abilities[1],
	Abilities[3],
	Abilities[1],
	Abilities[3],
	Abilities[4],
	Abilities[3],
	Abilities[1],
	Abilities[1],
	"talent",
	Abilities[2],
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
		return Talents[2]
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
	
	local CastRange = ability:GetCastRange();
	local Damage = 0;
	local CastPoint = ability:GetCastPoint();
	
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange+300,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------

	--------------------------------------
	-- Mode based usage
	--------------------------------------
	--protect myself
	local enemys2 = npcBot:GetNearbyHeroes( 400, true, BOT_MODE_NONE );
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if ( (npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH) or #enemys2>0) 
	then
		for _,npcEnemy in pairs( enemys )
		do
			if ( (npcBot:WasRecentlyDamagedByHero( npcEnemy, 2.0 ) and CanCast[abilityNumber]( npcEnemy )) or GetUnitToUnitDistance(npcBot,npcEnemy)<400) 
			then
				return BOT_ACTION_DESIRE_HIGH, npcEnemy;
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
				return BOT_ACTION_DESIRE_MODERATE, npcEnemy
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;
	
end

-- Consider[2]=function()
-- 	local abilityNumber=2
-- 	--------------------------------------
-- 	-- Generic Variable Setting
-- 	--------------------------------------
-- 	local ability=AbilitiesReal[abilityNumber];
	
-- 	if not ability:IsFullyCastable() then
-- 		return BOT_ACTION_DESIRE_NONE, 0;
-- 	end
	
-- 	local CastRange = ability:GetCastRange();
-- 	--local Damage = (ability:GetSpecialValueInt("damage_max")+ability:GetSpecialValueInt("damage_min"))*0.5
-- 	local Heal = (ability:GetSpecialValueInt("heal_max")+ability:GetSpecialValueInt("heal_min"))*0.5
	
-- 	local HeroHealth=10000
-- 	local CreepHealth=10000
-- 	local allys = npcBot:GetNearbyHeroes( CastRange+300, false, BOT_MODE_NONE );
-- 	local WeakestAlly,AllyHealth=utility.GetWeakestUnit(allys)
-- 	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
-- 	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
-- 	local creeps = npcBot:GetNearbyCreeps(CastRange+300,true)
-- 	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
-- 	--------------------------------------
-- 	-- Global high-priorty usage
-- 	--------------------------------------
	
-- 	--------------------------------------
-- 	-- Mode based usage
-- 	--------------------------------------
-- 	-- If we're seriously retreating
-- 	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH ) 
-- 	then
-- 		if ( HealthPercentage<=0.5 and npcBot:WasRecentlyDamagedByAnyHero(2.0)) 
-- 		then
-- 			if ( CanCast[abilityNumber]( npcBot )) 
-- 			then
-- 				return BOT_ACTION_DESIRE_HIGH, npcBot
-- 			end
-- 		end
-- 	end
	
-- 	--teamfightUsing
-- 	if(	npcBot:GetActiveMode() == BOT_MODE_ROAM or
-- 		npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
-- 		npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
-- 		npcBot:GetActiveMode() == BOT_MODE_ATTACK ) 
-- 	then
-- 		if (WeakestAlly~=nil)
-- 		then
-- 			if(AllyHealth/WeakestAlly:GetMaxHealth()<0.3+0.2*ManaPercentage)
-- 			then
-- 				return BOT_ACTION_DESIRE_MODERATE,WeakestAlly
-- 			end
-- 		end
			
-- 		for _,npcTarget in pairs( allys )
-- 		do
-- 			local enemys2 = npcTarget:GetNearbyHeroes(600,true,BOT_MODE_NONE)
-- 			local healingFactor=0.2+#enemys2*0.05+0.2*ManaPercentage
-- 			if(enemyDisabled(npcTarget))
-- 			then
-- 				healingFactor=healingFactor+0.1
-- 			end
			
-- 			if(npcTarget:GetHealth()/npcTarget:GetMaxHealth()<healingFactor and npcTarget:WasRecentlyDamagedByAnyHero(2.0) )
-- 			then
-- 				if ( CanCast[abilityNumber]( npcTarget ) )
-- 				then
-- 					return BOT_ACTION_DESIRE_MODERATE, npcTarget
-- 				end
-- 			end
-- 		end
-- 	end
	
-- 	-- If we're going after someone
-- 	if ( npcBot:GetActiveMode() == BOT_MODE_LANING or
-- 		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
-- 		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
-- 		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or
-- 		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
-- 		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
-- 		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT) 
-- 	then
-- 		for _,npcTarget in pairs( allys )
-- 		do
-- 			if(npcTarget:GetHealth()/npcTarget:GetMaxHealth()<(0.35+0.4*ManaPercentage))
-- 			then
-- 				if ( CanCast[abilityNumber]( npcTarget ) )
-- 				then
-- 					return BOT_ACTION_DESIRE_MODERATE, npcTarget
-- 				end
-- 			end
-- 		end
-- 	end
	
-- 	return BOT_ACTION_DESIRE_NONE, 0;
	
-- end

local goodNeutral=
{
	"npc_dota_neutral_alpha_wolf",			-- 头狼
	"npc_dota_neutral_centaur_khan",			-- 半人马征服者
	"npc_dota_neutral_dark_troll_warlord",			-- 黑暗巨魔召唤法师
	"npc_dota_neutral_polar_furbolg_ursa_warrior",			-- 地狱熊怪粉碎者
	--"npc_dota_neutral_forest_troll_high_priest",			-- 丘陵巨魔牧师
	--"npc_dota_neutral_mud_golem",			-- 泥土傀儡
	--"npc_dota_neutral_ogre_magi",		-- 食人魔冰霜法师
	"npc_dota_neutral_satyr_hellcaller", -- 萨特苦难使者
	"npc_dota_neutral_enraged_wildkin",  -- 枭兽撕裂者
}

local function IsGoodNeutralCreeps(npcCreep)
	local name=npcCreep:GetUnitName();
	for k,creepName in pairs(goodNeutral) do
		if(name==creepName)
		then
			return true;
		end
	end
	return false;
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
	local Damage = 0;
	local CastPoint = ability:GetCastPoint();
	
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange+300,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
	local creepsNeutral = npcBot:GetNearbyNeutralCreeps(1600)
	local StrongestCreep,CreepHealth2=utility.GetStrongestUnit(creepsNeutral)
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	-- Find neural creeps
	if(ManaPercentage>=0.3)
	then
		for k,creep in pairs(creepsNeutral) do
			if(IsGoodNeutralCreeps(creep) or (creep:IsAncientCreep() and AbilityExtensions:HasScepter(npcBot)))
			then
				return BOT_ACTION_DESIRE_HIGH, creep;
			end
		end
	end

	-- If we're in a teamfight, use it on the scariest enemy
	-- local lowHpAlly = nil;
	-- local nLowestHealth = 10000;

	-- for _,npcAlly in pairs( allys )
	-- do
	-- 	if (  CanCast[abilityNumber]( npcAlly ) and npcAlly:GetUnitName() ~= npcBot:GetUnitName() )
	-- 	then
	-- 		local nAllyHP = npcAlly:GetHealth();
	-- 		if  nAllyHP < nLowestHealth and npcAlly:GetHealth() / npcAlly:GetMaxHealth() < 0.25 and npcAlly:WasRecentlyDamagedByAnyHero(3.0)  
	-- 		then
	-- 			nLowestHealth = nAllyHP;
	-- 			lowHpAlly = npcAlly;
	-- 		end
	-- 	end
	-- end
	-- if ( lowHpAlly ~= nil )
	-- then
	-- 	return BOT_ACTION_DESIRE_MODERATE, lowHpAlly;
	-- end
	
	if npcBot:HasScepter() then
		local desire,targetloc=ConsiderRecall()
		if(desire>0)
		then
			return desire,targetloc
		end
	end
	return BOT_ACTION_DESIRE_NONE, 0;
	
end

function ConsiderRecall()
	
	local abilityNumber=3
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability=AbilitiesReal[abilityNumber];
	
	if ( not ability:IsFullyCastable() ) 
	then 
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(1600,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(1600,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)

	local numPlayer =  GetTeamPlayers(GetTeam());
	-- for i = 1, #numPlayer
	-- do
	-- 	local player = GetTeamMember(i);
	-- 	if player ~= nil and not IsPlayerBot(player:GetPlayerID()) and player:IsAlive() and GetUnitToUnitDistance(npcBot, player) > 1000 then
	-- 			local p = player:GetMostRecentPing();
	-- 			if p ~= nil and GetUnitToLocationDistance(player, p.location) < 1000 and GameTime() - p.time < 10 then
	-- 				--print("Human pinged to get recalled")
	-- 				return BOT_ACTION_DESIRE_MODERATE, player;
	-- 			end
	-- 	end
	-- end
	
	-- If we're defending a lane
	if ( npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT ) 
	then
		local nearbyTower = npcBot:GetNearbyTowers(1000, false) 
		if nearbyTower[1] ~= nil then
			local maxDist = 0;
			local target = nil;
			for i = 1, #numPlayer
			do
				local player = GetTeamMember(i);
				if player ~= nil and player:IsAlive() and player:GetActiveMode() ~= BOT_MODE_RETREAT then
					local dist = GetUnitToUnitDistance(nearbyTower[1], player);
					local health = player:GetHealth()/player:GetMaxHealth();
					if IsPlayerBot(player:GetPlayerID()) and dist > maxDist and dist > 2500 and health >= 0.5 then
						maxDist = dist;
						target = GetTeamMember(i);
					end
				end
			end
			if target ~= nil then
				return BOT_ACTION_DESIRE_MODERATE, target;
			end
		end
	end
	
	if ( npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
	npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
	npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT  ) 
	then
		local nearbyTower = npcBot:GetNearbyTowers(1000, true) 
		if nearbyTower[1] ~= nil then
			local maxDist = 0;
			local target = nil;
			for i = 1, #numPlayer
			do
				local player = GetTeamMember(i);
				if player ~= nil and player:IsAlive() and player:GetActiveMode() ~= BOT_MODE_RETREAT then
					local dist = GetUnitToUnitDistance(nearbyTower[1], player);
					local health = player:GetHealth()/player:GetMaxHealth();
					if IsPlayerBot(player:GetPlayerID()) and dist > maxDist and dist > 2500 and health >= 0.5  then
						maxDist = dist;
						target = GetTeamMember(i);
					end
				end
			end
			if target ~= nil then
				return BOT_ACTION_DESIRE_MODERATE, target;
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
		if ( npcTarget ~= nil  and npcTarget:IsHero() and GetUnitToUnitDistance( npcTarget, npcBot ) < 1000  ) 
		then	
			local maxDist = 0;
			local target = nil;
			for i = 1, #numPlayer
			do
				local player = GetTeamMember(i);
				if player ~= nil and player:IsAlive() and player:GetActiveMode() ~= BOT_MODE_RETREAT then
					local dist = GetUnitToUnitDistance(player, npcBot);
					local health = player:GetHealth()/player:GetMaxHealth();
					if IsPlayerBot(player:GetPlayerID()) and dist > maxDist and dist > 2500 and health >= 0.5 then
						maxDist = dist;
						target = GetTeamMember(i);
					end
				end
			end
			if target ~= nil then
				return BOT_ACTION_DESIRE_MODERATE, target;
			end
		end
	end
	
	return BOT_ACTION_DESIRE_NONE, 0;
end

local GetAllAllyHeroes = AbilityExtensions:EveryManySeconds(2, function()
	return AbilityExtensions:GetNearbyNonIllusionHeroes(npcBot, 10000, false)
end)

Consider[4]=function()
    local abilityNumber=4
    --------------------------------------
    -- Generic Variable Setting
    --------------------------------------
    local ability=AbilitiesReal[abilityNumber];

    if not ability:IsFullyCastable() then
        return BOT_ACTION_DESIRE_NONE, 0;
    end
    local healAmount = ability:GetSpecialValueInt("heal_amount")
    local function IsSeverelyDamaged(npc)
        return (AbilityExtensions:GetHealthPercent(npc) <= 0.3 or npc:GetHealth() <= 400) and AbilityExtensions:IsSeverelyDisabled(npc) and npc:WasRecentlyDamagedByAnyHero(0.8)
    end
    local function IsDamaged(npc)
        return npc:GetHealth() <= 400 or AbilityExtensions:GetHealthDeficit(npc) >= healAmount * 1.3 and npc:GetUnitName() ~= "npc_dota_hero_huskar" and npc:WasRecentlyDamagedByAnyHero(1.2)
    end

    local CastRange = 1599
    local allys = GetAllAllyHeroes()
	if not AbilityExtensions:CalledOnThisFrame(allys) then
		AbilityExtensions:GetNearbyNonIllusionHeroes(npcBot, CastRange, false)
	end
	allys = AbilityExtensions:Filter(allys, function(t) return not t:IsInvulnerable() and not t:HasModifier("modifier_ice_blast") end)
    local damagedAllies = AbilityExtensions:Filter(allys, function(t) return IsDamaged(t) and not IsSeverelyDamaged(t) end)
    local severelyDamagedAllies = AbilityExtensions:Filter(allys, IsSeverelyDamaged)

	local enemys = npcBot:GetNearbyHeroes(CastRange,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
	
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH ) 
	then
		if npcBot:WasRecentlyDamagedByAnyHero(1.0) and (not IsSeverelyDamaged(npcBot) or #damagedAllies >= 2) then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if npcBot:GetActiveMode() == BOT_MODE_LANING then
        if #damagedAllies >= 2 and #severelyDamagedAllies >= 1 then
            return BOT_ACTION_DESIRE_MODERATE
        end
    end
	
	-- If we're in a teamfight, use it on the scariest enemy
	local tableNearbyAttackingAlliedHeroes = npcBot:GetNearbyHeroes( 1000, false, BOT_MODE_ATTACK );
	if  #tableNearbyAttackingAlliedHeroes >= 2 and #enemys > 0 then
        if AbilityExtensions:Contains(severelyDamagedAllies, npcBot) and #damagedAllies >= 3
            or #damagedAllies >= 2 and #severelyDamagedAllies >= 1 then
            return BOT_ACTION_DESIRE_HIGH
        end
	end
    return 0
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