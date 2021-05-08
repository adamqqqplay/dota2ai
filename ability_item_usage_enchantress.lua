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
		return Talents[3]
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
local CanCast={AbilityExtensions.PhysicalCanCastFunction,utility.NCanCast,utility.NCanCast,utility.UCanCast,utility.UCanCast}
local enemyDisabled=utility.enemyDisabled

function GetComboDamage()
	return ability_item_usage_generic.GetComboDamage(AbilitiesReal)
end

function GetComboMana()
	return ability_item_usage_generic.GetComboMana(AbilitiesReal)
end

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

	-- dispell
	local buffedEnemies = AbilityExtensions:Filter(enemys, function(t) return CanCast[2](t) end)
	buffedEnemies = AbilityExtensions:Map(enemys, function(t) return {t, AbilityExtensions:IndexOfBasicDispellablePositiveModifier(t)} end)
	buffedEnemies = AbilityExtensions:Filter(buffedEnemies, function(t) return t[2] ~= -1 end)
	buffedEnemies = AbilityExtensions:SortByMinFirst(buffedEnemies, function(t) return t[2] end)
	if AbilityExtensions:Any(buffedEnemies) then
		return BOT_ACTION_DESIRE_MODERATE, buffedEnemies[1][1]
	end

	-- Find neural creeps
	if(ManaPercentage>=0.4)
	then
		for k,creep in pairs(creepsNeutral) do
			if IsGoodNeutralCreeps(creep) and not creep:WasRecentlyDamagedByAnyHero(1.5)
			then
				return BOT_ACTION_DESIRE_MODERATE, creep;
			end
		end
	end

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

Consider[3]=function()
	local abilityNumber=3
	--------------------------------------
	-- Generic Variable Setting
	--------------------------------------
	local ability=AbilitiesReal[abilityNumber];
	
	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local Radius = ability:GetAOERadius();
	local Damage = 0
	
	local allys = AbilityExtensions:GetNearbyNonIllusionHeroes(npcBot, Radius+100, false)
	allys = AbilityExtensions:Filter(npcBot, function(t) return not t:HasModifier("modifier_ice_blast") end)
	local WeakestAlly,AllyHealth=utility.GetWeakestUnit(allys)
	local enemys = npcBot:GetNearbyHeroes(Radius+300,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(Radius+300,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	-- If we're seriously retreating
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH ) 
	then
		if HealthPercentage<=0.5 and npcBot:WasRecentlyDamagedByAnyHero(2.0) and not npcBot:HasModifier("modifier_ice_blast")
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end
	
	--teamfightUsing
	if(	npcBot:GetActiveMode() == BOT_MODE_ROAM or
		npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		npcBot:GetActiveMode() == BOT_MODE_ATTACK ) 
	then
		if (WeakestAlly~=nil)
		then
			if(AllyHealth/WeakestAlly:GetMaxHealth()<0.4+0.4*ManaPercentage)
			then
				return BOT_ACTION_DESIRE_MODERATE
			end
		end
	end
	
	local creeps2 = npcBot:GetNearbyCreeps(Radius+300,false)
	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_LANING or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT) 
	then
		if #creeps2<=1 then
			for _,npcTarget in pairs( allys )
			do
				if(npcTarget:GetHealth()/npcTarget:GetMaxHealth()<(0.4+0.4*ManaPercentage)) and not npcTarget:HasModifier("modifier_ice_blast")
				then
					return BOT_ACTION_DESIRE_MODERATE
				end
			end
		end
	end
	
	return BOT_ACTION_DESIRE_NONE
	
end

Consider[1] = function()
    local abilityNumber=1
    --------------------------------------
    -- Generic Variable Setting
    --------------------------------------
    local ability=AbilitiesReal[abilityNumber];

    if not ability:IsFullyCastable() then
        return 0
    end

    local CastRange = ability:GetCastRange()
    local enemys = npcBot:GetNearbyHeroes(CastRange+100,true,BOT_MODE_NONE)
    local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)

    local function UseAt(target)
        if not CanCast[abilityNumber](target) then
            return false
        end
        if npcBot:HasModifier("modifier_enchantress_bunny_hop") and target:IsHero() then
            return true
        end
        if target:IsHero() then
            if AbilityExtensions:MustBeIllusion(npcBot, target) then
                return (AbilityExtensions:GetManaPercent(npcBot) >= 0.6 or AbilityExtensions:GetHealthPercent(target) <= 0.4) and GetUnitToUnitDistance(npcBot, target) >= 400
            else
                return AbilityExtensions:GetManaPercent(npcBot) >= 0.4 or GetUnitToUnitDistance(npcBot, target) >= 250
            end
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
Consider[1] = AbilityExtensions:ToggleFunctionToAutoCast(npcBot, Consider[1], AbilitiesReal[1])

Consider[4] = function()
    local abilityNumber = 4
    local ability = AbilitiesReal[abilityNumber]
    if not ability:IsFullyCastable() then
        return BOT_ACTION_DESIRE_NONE
    end

    local function TrySproink(t)
        if t == nil or t:IsBuilding() then
            return false
        end
        if not t:IsHero() then
            return AbilityExtensions:GetManaPercent(npcBot) >= 0.8
        end
        local dis = GetUnitToUnitDistance(npcBot, t)
        if dis <= npcBot:GetAttackRange() + ability:GetSpecialValueInt("impetus_attacks_range_buffer") - ability:GetSpecialValueInt("leap_distance") + 100 and npcBot:IsFacingLocation(t:GetLocation(), 40) then
            return true
        else
            return false
        end
    end

    if TrySproink(npcBot:GetAttackTarget()) then
        if npcBot:WasRecentlyDamagedByHero(npcBot:GetAttackTarget(), 2) then
            return BOT_ACTION_DESIRE_HIGH
        else
            return BOT_ACTION_DESIRE_LOW
        end
    end
    local enemies = AbilityExtensions:GetNearbyNonIllusionHeroes(npcBot, npcBot:GetAttackRange()+150, true, BOT_MODE_NONE)
    if AbilityExtensions:Contains(enemies, npcBot:GetAttackTarget()) then

    end
    enemies = AbilityExtensions:SortByMinFirst(enemies, function(t) return GetUnitToUnitDistance(npcBot, t) end)
    enemies = AbilityExtensions:Filter(enemies, function(t) return TrySproink(t)  end)
    if AbilityExtensions:Any(enemies, function(t) return npcBot:WasRecentlyDamagedByHero(t, 2)  end) then
        return BOT_ACTION_DESIRE_HIGH
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