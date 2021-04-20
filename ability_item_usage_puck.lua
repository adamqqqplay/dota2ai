local utility = require( GetScriptDirectory().."/utility" ) 
require(GetScriptDirectory() ..  "/ability_item_usage_generic")
local AbilityExtensions = require(GetScriptDirectory().."/util/AbilityAbstraction")

local debugmode=false
local npcBot = GetBot()
local Talents ={}
local Abilities ={}
local AbilitiesReal ={}

ability_item_usage_generic.InitAbility(Abilities,AbilitiesReal,Talents)

local AbilityToLevelUp = {
    Abilities[1],
    Abilities[3],
    Abilities[3],
    Abilities[2],
    Abilities[3],
    Abilities[4],
    Abilities[3],
    Abilities[2],
    Abilities[2],
    "talent",
    Abilities[2],
    Abilities[4],
    Abilities[1],
    Abilities[1],
    "talent",
    Abilities[1],
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

local TalentTree = {
    function() return Talents[1]  end,
    function() return Talents[3]  end,
    function() return Talents[6]  end,
    function() return Talents[7]  end,
    function() return Talents[2]  end,
    function() return Talents[4]  end,
    function() return Talents[5]  end,
    function() return Talents[8]  end,
}

utility.CheckAbilityBuild(AbilityToLevelUp)

function AbilityLevelUpThink()
    ability_item_usage_generic.AbilityLevelUpThink2(AbilityToLevelUp,TalentTree)
end


--------------------------------------
-- Ability Usage Thinking
--------------------------------------
local cast={} cast.Desire={} cast.Target={} cast.Type={}
local Consider ={}
local CanCast={utility.UCanCast,utility.NCanCast,utility.NCanCast,utility.UCanCast}
local enemyDisabled=utility.enemyDisabled

Consider[1] = function()
    local ability = AbilitiesReal[1]
    local enemies = npcBot:GetNearbyHeroes(1599, true, BOT_MODE_NONE)
    local realEnemies = AbilityExtensions:Filter(enemies, function(t) return AbilityExtensions:MayNotBeIllusion(t) end)
    local friends = npcBot:GetNearbyHeroes(1599, true, BOT_MODE_NONE)
    local enemyCreeps = AbilityExtensions:GetNearbyAttackableCreeps(npcBot, 900, true)
    local damage = ability:GetAbilityDamage()
    local weakCreeps = AbilityExtensions:Filter(enemyCreeps, function(t) return t:GetHealth() < t:GetActualIncomingDamage(damage, DAMAGE_TYPE_MAGICAL) end)
    if not ability:IsFullyCastable() then
        return 0
    end

    local distance = 1500
    local orbSpeed = 1500
    local radius = 150

    local function TryUseAt(location)
        local botLocation = npcBot:GetLocation()
        -- local 
    end

    if npcBot:GetActiveMode() == BOT_MODE_LANING then
        if #realEnemies ~= 0 then
            if #weakCreeps > 1 and ManaPercentage >= 0.4+ability:GetManaCost() and (HealthPercentage>=0.7 or HealthPercentage<=0.3) then
                local rates = AbilityExtensions:Map(AbilityExtensions:Concat(weakCreeps, realEnemies), function(t)
                    -- local 
                end)
            end
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