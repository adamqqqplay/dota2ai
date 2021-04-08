local M = {}

local binlib = require(GetScriptDirectory().."/util/BinDecHex")

M.Contains = function(self, tb, value)
    for _, v in pairs(tb) do
        if v == value then
            return true
        end
    end
    return false
end

M.Filter = function(self, tb, filter)
    local g = {}
    for k, v in pairs(tb) do
        if filter(v) then
            g[k] = v
        end
    end
    return g
end
M.FilterNot = function(self, tb, filter)
    local g = {}
    for k, v in pairs(tb) do
        if not filter(v) then
            g[k] = v
        end
    end
    return g
end

M.Map = function(self, tb, transform)
    local g = {}
    for k,v in pairs(tb) do
        g[k] = transform(v)
    end
    return g
end

M.ForEach = function(self, tb, action)
    for _, v in pairs(tb) do
        action(v)
    end
end

M.ShallowCopy = function(self, tb)
    local g = {}
    for k, v in pairs(tb) do
        g[k] = v
    end
    return g
end

local function deepCopy(self, tb)
    local copiedTables = {}
    local g = {}
    table.insert(copiedTables, tb)
    for k, v in pairs(tb) do
        if type(v) ~= "table" then
            g[k] = v
        else
            if self:Contains(copiedTables, v) then
                print("Copy loop!")
                return {}
            end
            g[k] = deepCopy(self, v)
        end
    end
    return g
end
M.DeepCopy = deepCopy

M.Concat = function(self, a, b)
    if type(a) ~= "table" or type(b) ~= "table" then
        return a..b
    end
    local g = self:ShallowCopy(a)
    local f = #a
    for k, v in ipairs(b) do
        g[k+f] = v
    end
    return g
end

M.Prepend = function(self, a, b)
    return self:Concat(b, a)
end



M.SeriouslyRetreatingStunSomeone = function(self, npcBot, abilityIndex, ability, targetType)
    if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0
	end
	
	local CastRange = ability:GetCastRange()
	local Damage = ability:GetAbilityDamage()
	local Radius = ability:GetAOERadius()
	local CastPoint = ability:GetCastPoint()
	
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE )
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange+300,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)

	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH ) then
		for _,npcEnemy in pairs( enemys )
		do
			if ( npcBot:WasRecentlyDamagedByHero( npcEnemy, 2.0 ) ) 
			then
				if ( CanCast[abilityNumber]( npcEnemy ) ) 
				then
					return BOT_ACTION_DESIRE_LOW, npcEnemy:GetExtrapolatedLocation(CastPoint)
				end
			end
		end
	end
end

local Trim = function(v, left, right)
    if right >= left then
        if v > right then
            return right
        elseif v < left then
            return left
        else
            return v
        end
    else
        if v > left then
            return left
        elseif v < right then
            return right
        else
            return v
        end
    end
end

M.TrimDesire = function(self, desire)
    return Trim(desire, 0, 1)
end

M.GetAbilityImportance = function(self, cooldown)
    return Trim(cooldown/120, 0, 1)
end

M.IsFarmingOrPushing = function(self, npcBot)
    local mode = npcBot:GetActiveMode()
    return mode==BOT_MODE_FARM or mode==BOT_MODE_PUSH_TOWER_BOT or mode==BOT_MODE_PUSH_TOWER_MID or mode==BOT_MODE_PUSH_TOWER_TOP
end

M.IsAttackingEnemies = function(self, npcBot)
    local mode = npcBot:GetActiveMode()
    return mode == BOT_MODE_ROAM or mode == BOT_MODE_TEAM_ROAM or mode == BOT_MODE_ATTACK or mode ==  BOT_MODE_DEFEND_ALLY
end

M.HasEnoughManaToUseAttackAttachedAbility = function(self, npcBot, ability)
    local percent = self:GetManaPercent(npcBot)
    if percent >= 0.8 and npcBot:GetMana() >= 650 then
        return true
    end
    return percent >= 0.4 and npcBot:GetMana() >= 300 and npcBot:GetManaRegen() >= npcBot:GetAttacksPerSecond() * ability:GetManaCost() * 0.75
end

-- turn a function that returns true, false, nil to a function that decides whether to toggle the ability or not
M.ToggleFunctionToAction = function(self, npcBot, oldConsider, ability)
    return function()
        local value = oldConsider()
        if value == nil or value == ability:GetToggleState() then
            return 0
        else
            return BOT_ACTION_DESIRE_HIGH
        end
    end
end

local GetOtherTeam = function(team)
    if team == TEAM_RADIANT then
        return TEAM_DIRE
    end
    if team == TEAM_DIRE then
        return TEAM_RADIANT
    end
end

M.RadiantPlayerId = GetTeamPlayers(TEAM_RADIANT)
M.DirePlayerId = GetTeamPlayers(TEAM_DIRE)

M.GetTeamPlayers = function(self, team)
    if team == TEAM_RADIANT then
        return self.RadiantPlayerId
    else
        return self.DirePlayerId
    end
end

M.MustBeIllusion = function(self, npcBot, target)
    if npcBot:GetTeam() == target:GetTeam() then
        return target:IsIllusion()
    end
    if self:Contains(self:GetTeamPlayers(npcBot:GetTeam()), target:GetPlayerID()) then
        return true
    end
    return false
end
M.MayNotBeIllusion = function(self, npcBot, target) return not self:MustBeIllusion(npcBot, target) end

M.IgnoreAbilityBlockAbilities = {
    "dark_seer_ion_shell",
    "grimstroke_soulbind",
    "rubick_spell_steal",
    "spectre_spectral_dagger",
    "morphling_morph",
    "batrider_flaming_lasso",
    "urn_of_shadows_soul_release",
    "spirit_vessel_soul_release",
    "medallion_of_courage_valor",
    "solar_crest_armor_shine",
}

M.DebugTable = function(self, tb)
    local msg = "{ "
    local DebugRec
    DebugRec = function(tb)
        for k,v in pairs(tb) do
            if type(v) == "number" or type(v) == "string" then
                msg = msg..k.." = "..v
                msg = msg..", "
            end
            if type(v) == "table" then
                msg = msg..k.." = ".."{ "
                DebugRec(v)
                msg = msg.."}, "
            end
        end
    end
    DebugRec(tb)
    msg = msg.." }"
    print(msg)
end

M.IsVector = function(self, object)
    return type(object)=="userdata" and type(object.x)=="number" and type(object.y)=="number" and type(object.z)=="number" and type(object.Length) == "function"
end
M.ToStringVector = function(self, object)
    return string.format("(%d,%d,%d)",object.x,object.y,object.z)
end

M.PreventAbilityAtIllusion = function(self, npcBot, oldConsiderFunction, ability)
    return function()
        local desire, target, targetTypeString = oldConsiderFunction()
        if desire == 0 or target == nil or target == 0 or self:IsVector(target) or targetTypeString == "Location" then
            return desire, target, targetTypeString
        end
        if self:MustBeIllusion(npcBot, target) then
            return 0
        end
        return desire, target, targetTypeString
    end
end

M.PreventEnemyTargetAbilityUsageAtAbilityBlock = function(self, npcBot, oldConsiderFunction, ability)
    local newConsider = function()
        -- TODO: do we consider the base cooldown or the modified cooldown (arcane rune, octarine orb)? Will you crack a sphere's spell block with an ultimate ability when you're on arcane rune?
        local desire, target, targetTypeString = oldConsiderFunction()
        if desire == 0 or target == nil or target == 0 or self:IsVector(target) or targetTypeString == "Location" then
            if self:IsVector(target) then
                print("npcBot "..npcBot:GetUnitName().." lands target ability "..ability:GetName().." at location "..self:ToStringVector(target))
            end
            return desire, target, targetTypeString
        end
        local oldDesire = desire
        if npcBot:GetTeam() ~= target:GetTeam() then -- some ability can cast to both allies and enemies (abbadon_mist_coil, etc)
            local cooldown = ability:GetCooldown()
            local abilityImportance = self:GetAbilityImportance(cooldown)

            if target:HasModifier("modifier_antimage_counterspell") then
                return 0
            end
            if target:HasModifier "modifier_item_sphere" or target:HasModifier("modifier_roshan_spell_block") or target:HasModifier("modifier_special_bonus_spell_block") then -- qop lv 25
                if cooldown >= 30 then
                    desire = desire - abilityImportance
                elseif cooldown <= 20 then
                    desire = desire + abilityImportance
                end
            end
            if target:HasModifier("modifier_item_sphere_target") then
                if cooldown >= 30  then
                    desire = desire - abilityImportance + 0.1
                elseif cooldown <= 20 then
                    desire = desire + abilityImportance
                    if abilityImportance > 0.1 then
                        desire = desire - 0.1
                    end
                end
            end
            if target:HasModifier("modifier_item_lotus_orb_active") then
                desire = desire - abilityImportance/2
            end
            if target:HasModifier("modifier_mirror_shield_delay") then
                desire = desire - abilityImportance*1.5
            end

            desire = self:TrimDesire(desire)
        end
        if desire ~= oldDesire then
            print("desire modified from "..oldDesire.." to "..desire)
        end
        return desire, target, targetTypeString
    end
    return newConsider
end

M.AutoModifyConsiderFunction = function(self, npcBot, considers, abilitiesReal)
    for index, ability in pairs(abilitiesReal) do
        if not binlib.Test(ability:GetBehavior(), ABILITY_BEHAVIOR_PASSIVE) and considers[index] == nil then
            print("Missing consider function "..ability:GetName())
        elseif binlib.Test(ability:GetTargetTeam(), ABILITY_TARGET_TEAM_ENEMY) and binlib.Test(ability:GetTargetType(), binlib.Or(ABILITY_TARGET_TYPE_HERO, ABILITY_TARGET_TYPE_CREEP, ABILITY_TARGET_TYPE_BUILDING)) and binlib.Test(ability:GetBehavior(), ABILITY_BEHAVIOR_UNIT_TARGET) then
            print("Modify ability to prevent ability usage at illusion "..ability:GetName())
            considers[index] = self.PreventAbilityAtIllusion(self, npcBot, considers[index], ability)
            if not self:Contains(self.IgnoreAbilityBlockAbilities, ability:GetName()) then
                print("Modify ability to avoid spell block: "..ability:GetName())
                considers[index] = self.PreventEnemyTargetAbilityUsageAtAbilityBlock(self, npcBot, considers[index], ability)
            end
        end
    end
end

M.GetHealthPercent = function(self, npc)
    return npc:GetHealth() / npc:GetMaxHealth()
end

M.GetManaPercent = function(self, npc)
    return npc:GetMana() / npc:GetMaxMana()
end

M.GetTargetHealAmplifyPercent = function(self, npc)
    local modifiers = npc:FindAllModifiers()
    local amplify = 1
    for i, modifier in pairs(modifiers) do
        local a = (modifier:GetModifierHealAmplify_PercentageSource())
        if a ~= 0 then
            print("modifier: "..modifier:GetName()..", heal amplify source:"..a..", target:"..modifier:GetModifierHealAmplify_PercentageTarget())
        end
        local modifierName = modifier:GetName()
        if modifierName == "modifier_ice_blast" then
            return 0
        end
        if modifierName == "modifier_item_spirit_vessel_damage" then
            amplify = amplify - 0.45
        end
        if modifierName == "modifier_holy_blessing" then
            amplify = amplify + 0.3
        end
        if modifierName == "modifier_necrolyte_sadist_active" then -- ghost shroud
            amplify = amplify + 0.75
        end
        if modifierName == "modifier_wisp_tether_haste" then
            amplify = amplify + 0.6 -- 0.8/1/1.2
        end
        if modifierName == "modifier_oracle_false_promise" then
            amplify = amplify + 1
        end
    end
    return amplify
end

M.PreventHealAtHealSuppressTarget = function(self, npcBot, oldConsiderFunction, ability)
    return function()
        local desire, target, targetTypeString = oldConsiderFunction()
        if desire == 0 or target == nil or target == 0 or targetTypeString == "Location" then
            return desire, target, targetTypeString
        end
        if npcBot:GetTeam() == target:GetTeam() then
            desire = desire * self:GetTargetHealAmplifyPercent(target)
        end
        desire = self:TrimDesire(desire)
        return desire, target, targetTypeString
    end
end

M.PURCHASE_ITEM_OUT_OF_STOCK=82
M.PURCHASE_ITEM_INVALID_ITEM_NAME=33
M.PURCHASE_ITEM_DISALLOWED_ITEM=78
M.PURCHASE_ITEM_INSUFFICIENT_GOLD=63
M.PURCHASE_ITEM_NOT_AT_SECRET_SHOP=62
M.PURCHASE_ITEM_NOT_AT_HOME_SHOP=67
M.PURCHASE_ITEM_SUCCESS=-1
-- invalid order(3) unrecognised order name
-- invalid order(40) order not allowed for illusions
-- attempt to purchase "item_energy_booster" failed code 68

M.CannotBeKilledNormally = function(self, target)
    return target:IsInvulnerable() or target:HasModifier("modifier_abaddon_borrowed_time") or target:HasModifier("modifier_dazzle_shallow_grave") or target:HasModifier("modifier_aeon_disk")
end

M.HasScepter = function(self, npc)
    return npc:HasScepter() or npc:HasModifier("modifier_wisp_tether_scepter")
end


return M
