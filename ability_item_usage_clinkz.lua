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
	Abilities[2],
	Abilities[3],
	Abilities[2],
	Abilities[1],
	Abilities[2],
	Abilities[5],
	Abilities[2],
	Abilities[1],
	Abilities[1],
	"talent",
	Abilities[1],
	Abilities[5],
	Abilities[3],
	Abilities[3],
	"talent",
	Abilities[3],
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
local ComboMana;
local AttackRange;
local ManaPercentage;
local HealthPercentage;
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
				if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL) or (HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana) and GetUnitToUnitDistance( WeakestEnemy,npcBot ) <= AttackRange+100)
				then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end
	end

	--------------------------------------
	-- Mode based usage
	--------------------------------------
	-- If we're pushing or defending a lane
	if ( npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT )
	then
		local t=npcBot:GetAttackTarget()
		if(t~=nil)
		then
			if (ManaPercentage>0.4 and t:IsTower() and GetUnitToUnitDistance(  t, npcBot  ) <= AttackRange+100)
			then
				return BOT_ACTION_DESIRE_MODERATE
			end
		end
	end

	if ( npcBot:GetActiveMode() == BOT_MODE_ROSHAN )
	then
		local npcTarget = npcBot:GetTarget();
		if ( npcTarget ~= nil and GetUnitToUnitDistance(  npcTarget, npcBot  ) <= AttackRange+100  )
		then
			return BOT_ACTION_DESIRE_MODERATE;
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
			if ( CanCast[abilityNumber]( npcEnemy ) and GetUnitToUnitDistance(npcBot,npcEnemy)<= AttackRange+100)
			then
				return BOT_ACTION_DESIRE_MODERATE
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
	local Damage = ability:GetSpecialValueInt("damage_bonus")+npcBot:GetAttackDamage()
	--print(ability:GetName().." :Damage is "..Damage)


	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange+100,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange+100,true)
	local creeps2 = npcBot:GetNearbyCreeps(300,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)

	if(ability:GetToggleState()==false)
	then
		local t=npcBot:GetAttackTarget()
		if(t~=nil)
		then
			if (t:IsHero() or t:IsTower())
			then
				ability:ToggleAutoCast()
				return BOT_ACTION_DESIRE_NONE, 0;
			end
		end
	end
	--[[else
		local t=npcBot:GetAttackTarget()
		if(t~=nil)
		then
			if (not(t:IsHero() or t:IsTower()))
			then
				ability:ToggleAutoCast()
				return BOT_ACTION_DESIRE_NONE, 0;
			end
		end
	end]]

	--try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT)
	then
		if (WeakestEnemy~=nil)
		then
			if ( CanCast[abilityNumber]( WeakestEnemy ) )
			then
				if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_ALL))
				then
					return BOT_ACTION_DESIRE_HIGH,WeakestEnemy;
				end
			end
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	if ( npcBot:GetActiveMode() == BOT_MODE_LANING )
	then
		if(CreepHealth>=250 and ManaPercentage>=0.5 and HealthPercentage>=0.6 and #creeps2<=1)
		then
			if (WeakestEnemy~=nil)
			then
				if ( CanCast[abilityNumber]( WeakestEnemy ) )
				then
					return BOT_ACTION_DESIRE_LOW-0.01,WeakestEnemy
				end
			end
		end

		if(WeakestCreep~=nil)
		then
			if(CreepHealth<=WeakestCreep:GetActualIncomingDamage(Damage,DAMAGE_TYPE_PHYSICAL)+20)
			then
				return BOT_ACTION_DESIRE_LOW-0.02,WeakestCreep
			end
		end

	end

	-- If we're farming
	if ( npcBot:GetActiveMode() == BOT_MODE_FARM )
	then
		return BOT_ACTION_DESIRE_LOW, WeakestCreep;
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
			if ( CanCast[abilityNumber]( npcEnemy )  and GetUnitToUnitDistance(npcBot,npcEnemy)< CastRange+100)
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

	local CastRange = ability:GetCastRange();
	local Damage = ability:GetAbilityDamage();
	local Radius = ability:GetAOERadius()


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
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH )
	then
		return BOT_ACTION_DESIRE_MODERATE
	end

	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM  )
	then
		local npcEnemy = npcBot:GetTarget();

		if ( npcEnemy ~= nil )
		then
			if(GetUnitToUnitDistance(npcBot,npcEnemy)>=1800)
			then
				return BOT_ACTION_DESIRE_MODERATE
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;

end

local goodNeutral=
{
	"npc_dota_neutral_alpha_wolf",			-- 头狼
	"npc_dota_neutral_centaur_khan",			-- 半人马征服者
	"npc_dota_neutral_dark_troll_warlord",			-- 黑暗巨魔召唤法师
	"npc_dota_neutral_polar_furbolg_ursa_warrior",			-- 地狱熊怪粉碎者
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
	local Damage = ability:GetAbilityDamage();
	local Radius = ability:GetAOERadius()


	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange+300,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	-- If we're in a teamfight, use it on the scariest enemy
	local tableNearbyAttackingAlliedHeroes = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_ATTACK );
	if ( #tableNearbyAttackingAlliedHeroes >= 2 )
	then
		local locationAoE = npcBot:FindAoELocation( true, true, npcBot:GetLocation(), AttackRange, 400, 0, 0 );
		if ( locationAoE.count >= 2 ) then
			return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc;
		end
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
			   if ( CanCast[abilityNumber]( npcEnemy )  and GetUnitToUnitDistance(npcBot,npcEnemy)< CastRange + 300)
			   then
				   return BOT_ACTION_DESIRE_MODERATE, npcEnemy:GetLocation();
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
    if(ManaPercentage>=0.4)
    then
        for k,creep in pairs(creepsNeutral) do
            if(IsGoodNeutralCreeps(creep) and not creep:WasRecentlyDamagedByAnyHero(1.5))
            then
                return BOT_ACTION_DESIRE_MODERATE, creep
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
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