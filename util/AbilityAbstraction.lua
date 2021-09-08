---------------------------------------------
-- Generated from Mirana Compiler version 1.5.1
-- Do not modify
-- https://github.com/AaronSong321/Mirana
---------------------------------------------
local M = {}
local binlib = require(GetScriptDirectory().."/util/BinDecHex")
local magicTable = {}
local function GiveLinqFunctions(t)
    setmetatable(t, magicTable)
end
local function NewTable()
    local a = {}
    GiveLinqFunctions(a, magicTable)
    return a
end
magicTable.__index = magicTable
M.Range = function(self, min, max, step)
    if step == nil then
        step = 1
    end
    local g = NewTable()
    for i = min, max, step do
        table.insert(g, i)
    end
    return g
end
M.Contains = function(self, tb, value, equals)
    equals = equals or function(__mira_olpar_1, __mira_olpar_2) return __mira_olpar_1 == __mira_olpar_2 end
    for _, v in ipairs(tb) do
        if equals(v, value) then
            return true
        end
    end
    return false
end
M.ContainsKey = function(self, tb, key, equals)
    equals = equals or function(__mira_olpar_1, __mira_olpar_2) return __mira_olpar_1 == __mira_olpar_2 end
    for k, _ in pairs(tb) do
        if equals(key, k) then
            return true
        end
    end
    return false
end
function M:Keys(tb)
    local g = NewTable()
    for k, _ in pairs(tb) do
        table.insert(g, k)
    end
    return g
end
M.Filter = function(self, tb, filter)
    local g = NewTable()
    for k, v in ipairs(tb) do
        if filter(v, k) then
            table.insert(g, v)
        end
    end
    return g
end
M.FilterNot = function(self, tb, filter)
    local g = NewTable()
    for k, v in ipairs(tb) do
        if not filter(v, k) then
            table.insert(g, v)
        end
    end
    return g
end
M.Count = function(self, tb, filter)
    local g = 0
    for k, v in ipairs(tb) do
        if filter == nil or filter(v, k) then
            g = g + 1
        end
    end
    return g
end
function M:NonEmpty(self, tb)
    return self:Filter(tb, function(t)
        return t ~= nil and #t ~= 0
    end)
end
M.Map = function(self, tb, transform)
    local g = NewTable()
    for k, v in ipairs(tb) do
        g[k] = transform(v)
    end
    return g
end
function M:MapDic(tb, transform)
    local g = NewTable()
    for k, v in pairs(tb) do
        g[k] = transform(k, v)
    end
    return g
end
M.ForEach = function(self, tb, action)
    for k, v in ipairs(tb) do
        action(v, k)
    end
end
function M:ForEachDic(tb, action)
    for k, v in pairs(tb) do
        action(v, k)
    end
end
M.Any = function(self, tb, filter)
    for k, v in ipairs(tb) do
        if filter == nil or filter(v, k) then
            return true
        end
    end
    return false
end
M.All = function(self, tb, filter)
    for k, v in ipairs(tb) do
        if not filter(v, k) then
            return false
        end
    end
    return true
end
M.Aggregate = function(self, seed, tb, aggregate)
    for k, v in ipairs(tb) do
        seed = aggregate(seed, v, k)
    end
    return seed
end
M.ShallowCopy = function(self, tb)
    local g = NewTable()
    for k, v in pairs(tb) do
        g[k] = v
    end
    return g
end
M.First = function(self, tb, filter)
    if filter == nil then
        filter = function()
            return true
        end
    end
    for k, v in ipairs(tb) do
        if filter == nil or filter(v, k) then
            return v
        end
    end
end
M.Skip = function(self, tb, number)
    local g = NewTable()
    local i = 0
    for _, v in ipairs(tb) do
        i = i + 1
        if i > number then
            table.insert(g, v)
        end
    end
    return g
end
M.Take = function(self, tb, number)
    local g = NewTable()
    local i = 0
    for _, v in ipairs(tb) do
        i = i + 1
        if i <= number then
            table.insert(g, v)
        else
            break

        end
    end
    return g
end
local function deepCopy(self, tb)
    local copiedTables = NewTable()
    local g = NewTable()
    table.insert(copiedTables, tb)
    for k, v in pairs(tb) do
        if type(v) ~= "table" then
            g[k] = v
        else
            if self:Contains(copiedTables, v) then
                return {}
            end
            g[k] = deepCopy(self, v)
        end
    end
    return g
end
M.DeepCopy = deepCopy
M.Concat = function(self, a, ...)
    local g = NewTable()
    local rec
    rec = function(b, ...)
        if b == nil then
            return
        end
        for _, v in ipairs(b) do
            table.insert(g, v)
        end
        rec(...)
    end
    rec(a, ...)
    return g
end
M.Remove = function(self, a, b)
    local g = self:ShallowCopy(a)
    for k, v in pairs(a) do
        if v == b then
            g[k] = nil
        end
    end
    return g
end
M.RemoveAll = function(self, a, b)
    local g = NewTable()
    for _, v in pairs(a) do
        if not self:Contains(b, v) then
            table.insert(g, v)
        end
    end
    return g
end
M.Prepend = function(self, a, b)
    return self:Concat(b, a)
end
M.GroupBy = function(self, collection, keySelector, elementSelector, resultSelector, comparer)
    comparer = comparer or function(a, b)
        return a == b
    end
    resultSelector = resultSelector or function(key, value)
        return value
    end
    elementSelector = elementSelector or self.IdentityFunction
    local keys = NewTable()
    local values = NewTable()
    for _, k in ipairs(collection) do
        local keyFound = false
        for readKeyIndex, readKey in ipairs(keys) do
            if comparer(readKey, keySelector(k)) then
                keyFound = true
                table.insert(values[readKeyIndex], elementSelector(k))
                break

            end
        end
        if not keyFound then
            table.insert(keys, keySelector(k))
            table.insert(values, { elementSelector(k) })
        end
    end
    return self:Map2(keys, values, resultSelector)
end
M.Partition = function(self, tb, filter)
    local a = NewTable()
    local b = NewTable()
    for k, v in pairs(tb) do
        if filter(v, k) then
            table.insert(a, v)
        else
            table.insert(b, v)
        end
    end
    return a, b
end
M.Distinct = function(self, tb, equals)
    equals = equals or function(__mira_olpar_1, __mira_olpar_2) return __mira_olpar_1 == __mira_olpar_2 end
    local g = NewTable()
    for _, v in pairs(tb) do
        if not self:Contains(g, v, equals) then
            table.insert(g, v)
        end
    end
    return g
end
M.Reverse = function(self, tb)
    local g = NewTable()
    for i = #tb, 1, -1 do
        table.insert(g, tb[i])
    end
    return g
end
M.Last = function(self, tb, filter)
    return self:First(self:Reverse(tb), filter)
end
function M:Identity(t)
    return t
end
M.IdentityFunction = function(t)
    return t
end
function M:Max(tb, map)
    if #tb == 0 then
        return nil
    end
    map = map or self.IdentityFunction
    local maxv,maxm = tb[1], map(tb[1])
    for i = 2, #tb do
        local m = map(tb[i])
        if m > maxm then
            maxm = m
            maxv = tb[i]
        end
    end
    return maxv
end
function M:Min(tb, map)
    if #tb == 0 then
        return nil
    end
    map = map or self.IdentityFunction
    local maxv,maxm = tb[1], map(tb[1])
    for i = 2, #tb do
        local m = map(tb[i])
        if m < maxm then
            maxm = m
            maxv = tb[i]
        end
    end
    return maxv
end
M.Repeat = function(self, element, count)
    local g = NewTable()
    for i = 1, count do
        table.insert(g, element)
    end
    return g
end
M.Select = M.Map
M.SelectMany = function(self, tb, map, filter)
    local g = NewTable()
    for _, source in ipairs(tb) do
        local collection = map(source)
        for index, value in ipairs(collection) do
            if filter == nil or filter(value, index) then
                table.insert(g, value)
            end
        end
    end
    return g
end
M.Where = M.Filter
M.SkipLast = function(self, tb, number)
    return self:Skip(self:Reverse(tb), number)
end
M.Replace = function(self, tb, filter, map)
    local g = NewTable()
    for k, v in ipairs(tb) do
        if filter(v, k) then
            table.insert(g, map(v, k))
        else
            table.insert(g, v)
        end
    end
    return g
end
M.IndexOf = function(self, tb, filter)
    local g = NewTable()
    for k, v in ipairs(tb) do
        if type(filter) == "function" then
            if filter(v, k) then
                return k
            end
        elseif filter ~= nil then
            if v == filter then
                return k
            end
        end
    end
    return -1
end
M.Zip2 = function(self, tb1, tb2, map)
    if map == nil then
        map = function(a, b)
            return {
                a,
                b,
            }
        end
    end
    local g = NewTable()
    for i = 1, #tb1 do
        table.insert(g, map(tb1[i], tb2[i]))
    end
    return g
end
M.ForEach2 = function(self, tb1, tb2, func)
    for i = 1, #tb1 do
        func(tb1[i], tb2[i])
    end
end
M.Map2 = function(self, tb1, tb2, map)
    local g = NewTable()
    for i = 1, #tb1 do
        table.insert(g, map(tb1[i], tb2[i], i))
    end
    return g
end
M.Filter2 = function(self, tb1, tb2, filter, map)
    if map == nil then
        map = function(a, b, c)
            return {
                a,
                b,
                c,
            }
        end
    end
    local g = NewTable()
    for i = 1, #tb1 do
        if filter(tb1[i], tb2[i], i) then
            table.insert(map(tb1[i], tb2[i], i))
        end
    end
    return g
end
M.SlowSort = function(self, tb, sort)
    local g = self:ShallowCopy(tb)
    local len = #g
    if sort ~= nil then
        for i = 1, len - 1 do
            for j = i + 1, len do
                if sort(g[i], g[j]) > 0 then
                    g[i], g[j] = g[j], g[i]
                end
            end
        end
    else
        for i = 1, len - 1 do
            for j = i + 1, len do
                if g[i] > g[j] then
                    g[i], g[j] = g[j], g[i]
                end
            end
        end
    end
    return g
end
M.MergeSort = function(self, tb, sort)
    if sort == nil then
        sort = function(a, b)
            return a - b
        end
    end
    local function Merge(a, b)
        local g = NewTable()
        local aLen = #a
        local bLen = #b
        local i = 1
        local j = 1
        while i <= aLen and j <= bLen do
            if sort(a[i], b[j]) > 0 then
                table.insert(g, b[j])
                j = j + 1
            else
                table.insert(g, a[i])
                i = i + 1
            end
        end
        if i <= aLen then
            for _ = i, aLen do
                table.insert(g, a[i])
            end
        end
        if j <= bLen then
            for _ = j, bLen do
                table.insert(g, b[j])
            end
        end
        return g
    end
    local function SortRec(tab)
        local tableLength = #tab
        if tableLength == 1 then
            return tab
        end
        local left = SortRec(self:Take(tab, tableLength / 2))
        local right = SortRec(self:Skip(tab, tableLength / 2))
        local merge = Merge(left, right)
        return merge
    end
    return SortRec(tb)
end
M.Sort = M.SlowSort
M.SortByMaxFirst = function(self, tb, map)
    map = map or function(a, b)
        return b - a
    end
    return self:Sort(tb, function(a, b)
        return map(b) - map(a)
    end)
end
M.SortByMinFirst = function(self, tb, map)
    map = map or function(a, b)
        return a - b
    end
    return self:Sort(tb, function(a, b)
        return map(a) - map(b)
    end)
end
function M:Remove_Modify(tb, item)
    local filter = item
    if type(item) ~= "function" then
        filter = function(t)
            return t == item
        end
    end
    local i = 1
    local d = #tb
    while i <= d do
        if filter(tb[i]) then
            table.remove(tb, i)
            d = d - 1
        else
            i = i + 1
        end
    end
end
function M:InsertAfter_Modify(tb, item, after)
    if after == nil then
        table.insert(tb, item)
    else
        for index, value in ipairs(tb) do
            if after == value then
                table.insert(tb, index, item)
                return
            end
        end
        table.insert(tb, item)
    end
end
function M:Unpack(tb)
    local index = #tb
    local function rec(...)
        if index >= 1 then
            index = index - 1
            return rec(tb[index + 1], ...)
        else
            return ...
        end
    end
    return rec()
end
function M:UnpackIfTable(p)
    if type(p) == "table" then
        return self:Unpack(p)
    else
        return p
    end
end
function M:Also(tb, block)
    block(tb)
    return tb
end
function M:Let(tb, block)
    return block(tb)
end
local function AddLinqFunctionsToMetatable(mt)
    for k, v in pairs(M) do
        mt[k] = function(...)
            return v(M, ...)
        end
    end
    for functionName, func in pairs(table) do
        mt[functionName] = func
    end
end
AddLinqFunctionsToMetatable(magicTable)
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
    return Trim(cooldown / 120, 0, 1)
end
M.IsFarmingOrPushing = function(self, npcBot)
    local mode = npcBot:GetActiveMode()
    return mode == BOT_MODE_FARM or mode == BOT_MODE_PUSH_TOWER_BOT or mode == BOT_MODE_PUSH_TOWER_MID or mode == BOT_MODE_PUSH_TOWER_TOP or mode == BOT_MODE_DEFEND_TOWER_BOT or mode == BOT_MODE_DEFEND_TOWER_MID or mode == BOT_MODE_DEFEND_TOWER_TOP
end
M.IsLaning = function(self, npcBot)
    local mode = npcBot:GetActiveMode()
    return mode == BOT_MODE_LANING
end
M.IsAttackingEnemies = function(self, npcBot)
    local mode = npcBot:GetActiveMode()
    return mode == BOT_MODE_ROAM or mode == BOT_MODE_TEAM_ROAM or mode == BOT_MODE_ATTACK or mode == BOT_MODE_DEFEND_ALLY
end
function M:CanBeEngaged(npcBot)
    return self:IsAttackingEnemies(npcBot) or self:IsFarmingOrPushing(npcBot) or self:IsLaning(npcBot) or not npcBot:IsBot()
end
M.IsRetreating = function(self, npcBot)
    return npcBot:GetActiveMode() == BOT_MODE_RETREAT
end
M.NotRetreating = function(self, npcBot)
    return npcBot:GetActiveMode() ~= BOT_MODE_RETREAT
end
M.HasEnoughManaToUseAttackAttachedAbility = function(self, npcBot, ability)
    local percent = self:GetManaPercent(npcBot)
    if percent >= 0.8 and npcBot:GetMana() >= 650 then
        return true
    end
    return percent >= 0.4 and npcBot:GetMana() >= 300 and npcBot:GetManaRegen() >= npcBot:GetAttackSpeed() / 100 * ability:GetManaCost() * 0.75
end
M.ToggleFunctionToAction = function(self, npcBot, oldConsider, ability)
    return function()
        local value,target,castType = oldConsider()
        if type(value) == "number" then
            return value, target, castType
        end
        if value ~= ability:GetToggleState() and ability:IsFullyCastable() then
            return BOT_ACTION_DESIRE_HIGH
        else
            return 0
        end
    end
end
M.ToggleFunctionToAutoCast = function(self, npcBot, ability, oldToggle)
    return function()
        local value,target,castType = oldToggle()
        if type(value) == "number" then
            return value, target, castType
        end
        if ability:IsFullyCastable() and value ~= ability:GetAutoCastState() or not ability:IsHidden() then
            ability:ToggleAutoCast()
        end
        return 0
    end
end
M.PreventAbilityAtIllusion = function(self, npcBot, oldConsiderFunction, ability)
    return function()
        local desire,target,targetTypeString = oldConsiderFunction()
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
        local desire,target,targetTypeString = oldConsiderFunction()
        if desire == 0 or target == nil or target == 0 or self:IsVector(target) or targetTypeString == "Location" then
            return desire, target, targetTypeString
        end
        local oldDesire = desire
        if npcBot:GetTeam() ~= target:GetTeam() then
            local cooldown = ability:GetCooldown()
            local abilityImportance = self:GetAbilityImportance(cooldown)
            if target:HasModifier "modifier_antimage_counterspell" then
                return 0
            end
            if target:HasModifier "modifier_item_sphere" or target:HasModifier "modifier_roshan_spell_block" or target:HasModifier "modifier_special_bonus_spell_block" then
                if cooldown >= 30 then
                    desire = desire - abilityImportance
                elseif cooldown <= 20 then
                    desire = desire + abilityImportance
                end
            end
            if target:HasModifier "modifier_item_sphere_target" then
                if cooldown >= 60 then
                    desire = 0
                elseif cooldown >= 30 then
                    desire = desire - abilityImportance + 0.1
                elseif cooldown <= 20 then
                    desire = desire + abilityImportance
                    if abilityImportance > 0.1 then
                        desire = desire - 0.1
                    end
                end
            end
            if target:HasModifier "modifier_item_lotus_orb_active" then
                if npcBot:GetActiveMode() == BOT_MODE_RETREAT then
                    desire = 0
                else
                    desire = desire - abilityImportance / 2
                end
            end
            if target:HasModifier "modifier_mirror_shield_delay" then
                desire = desire - abilityImportance * 1.5
            end
            desire = self:TrimDesire(desire)
        end
        return desire, target, targetTypeString
    end
    return newConsider
end
M.GetUsedAbilityInfo = function(self, ability, abilityInfoTable, considerTarget)
    abilityInfoTable.lastUsedTime = DotaTime()
    abilityInfoTable.lastUsedCharge = ability:GetCurrentCharges()
    abilityInfoTable.lastUsedTarget = considerTarget
    abilityInfoTable.lastUsedRemainingCooldown = ability:GetCooldownTimeRemaining()
end
M.AddCooldownToChargeAbility = function(self, oldConsider, ability, abilityInfoTable, additionalCooldown)
    return function()
        if abilityInfoTable.lastUsedTime == nil then
            abilityInfoTable.lastUsedTime = DotaTime()
        end
        if not (ability:GetCurrentCharges() > 0 and ability:IsFullyCastable()) then
            return 0
        end
        if DotaTime() <= abilityInfoTable.lastUsedTime + additionalCooldown and abilityInfoTable.lastUsedCharge >= ability:GetCurrentCharges() and abilityInfoTable.lastUsedRemainingCooldown <= ability:GetCooldownTimeRemaining() then
            return 0
        end
        return oldConsider()
    end
end
local function CaptureOutpost()
    return 0
end
local function UnderlordFly()
    return 0
end
M.AutoModifyConsiderFunction = function(self, npcBot, considers, abilitiesReal)
    for index, ability in pairs(abilitiesReal) do
        if ability:GetName() == "ability_capture" then
            considers[index] = CaptureOutpost
        elseif ability:GetName() == "abyssal_underlord_portal_warp" then
            considers[index] = UnderlordFly
        elseif not binlib.Test(ability:GetBehavior(), ABILITY_BEHAVIOR_PASSIVE) and considers[index] == nil then
            print("Missing consider function "..ability:GetName())
        elseif binlib.Test(ability:GetTargetTeam(), ABILITY_TARGET_TEAM_ENEMY) and binlib.Test(ability:GetTargetType(), binlib.Or(ABILITY_TARGET_TYPE_HERO, ABILITY_TARGET_TYPE_CREEP, ABILITY_TARGET_TYPE_BUILDING)) and binlib.Test(ability:GetBehavior(), ABILITY_BEHAVIOR_UNIT_TARGET) then
            considers[index] = self.PreventAbilityAtIllusion(self, npcBot, considers[index], ability)
            if not self:IgnoreAbilityBlock(ability) then
                considers[index] = self.PreventEnemyTargetAbilityUsageAtAbilityBlock(self, npcBot, considers[index], ability)
            end
        end
    end
    npcBot.abilityRecords = {}
end
function M:InitAbility(npcBot)
    local abilities = NewTable()
    local abilityNames = NewTable()
    local talents = NewTable()
    for i = 0, 23 do
        local ability = npcBot:GetAbilityInSlot(i)
        if ability ~= nil then
            if ability:GetName() ~= "generic_hidden" then
                if ability:IsTalent() == true then
                    table.insert(talents, ability:GetName())
                else
                    table.insert(abilityNames, ability:GetName())
                    table.insert(abilities, ability)
                end
            end
        end
    end
    npcBot.abilityInited = true
    return abilityNames, abilities, talents
end
local keysBeforeAbilityInformation = M:Keys(M)
M.UndisjointableProjectiles = {
    "alchemist_berser_potion",
    "alchemist_unstable_concoction_throw",
    "arc_warden_spark_wraith",
    "grimstroke_phantoms_embrace",
    "earthshaker_echoslam",
    "gyrocopter_homing_missile",
    "beastmaster_hawk_dive",
    "huskar_life_break",
    "lich_chain_frost",
    "medusa_cold_blooded",
    "medusa_mystic_snake",
    "mirana_starstorm",
    "necrolyte_death_pulse",
    "necrolyte_death_seeker",
    "oracle_fortunes_end",
    "queenofpain_scream_of_pain",
    "skywrath_mage_arcane_bolt",
    "snapfire_firesnap_cookie",
    "spectre_spectral_dagger",
    "tiny_toss",
    "tusk_snowball",
    "witch_doctor_paralyzing_cask",
}
M.targetTrackingStunAbilities = {
    "alchemist_berser_potion",
    "alchemist_unstable_concoction_throw",
    "chaos_knight_chaos_bolt",
    "dragon_knight_dragon_tail",
    "gyrocopter_homing_missile",
    "morphling_adaptive_strike_str",
    "mud_golem_hurl_boulder",
    "skeleton_king_hellfire_blast",
    "sven_storm_hammer",
    "vengefulspirit_magic_missile",
    "windrunner_shackleshot",
}
M.targetNonTrackingStunAbilities = {
    "bane_fiends_grip",
    "beastmaster_primal_roar",
    "dark_willow_cursed_crown",
    "enigma_malefice",
    "invoker_cold_snap",
    "item_abyssal_blade",
    "lich_sinister_gaze",
    "luna_lucent_beam",
    "necrolyte_reapers_scythe",
    "ogre_magi_fireblast",
    "ogre_magi_unrefined_fireblast",
    "pudge_dismember",
    "rubick_telekinesis",
    "shadow_shaman_shackles",
    "storm_spirit_electric_vortex",
}
M.targetStunAbilities = M:Concat(M.targetTrackingStunAbilities, M.targetNonTrackingStunAbilities)
M.locationStunAbilities = {
    "axe_berserkers_call",
    "centaur_hoof_stomp",
    "dark_seer_vacuum",
    "dark_willow_cursed_crown",
    "dawnbreaker_fire_wreath",
    "dawnbreaker_solar_guardian",
    "earthshaker_fissure",
    "earthshaker_enchant_totem",
    "earthshaker_echoslam",
    "enigma_black_hole",
    "faceless_void_chronosphere",
    "jakiro_ice_path",
    "keeper_of_the_light_will_o_wisp",
    "kunkka_ghostship",
    "kunkka_torrent",
    "kunkka_torrent_storm",
    "lina_light_strike_array",
    "magnataur_skewer",
    "magnataur_horn_toss",
    "magnataur_reverse_polarity",
    "monkey_king_boundless_strike",
    "phoenix_supernova",
    "puck_dream_coil",
    "sand_king_burrowstrike",
    "slardar_slithereen_crush",
    "tidehunter_ravage",
}
M.targetTrackingDisableAbilities = {
    "gleipnir_eternal_chains",
    "naga_siren_ensnare",
    "riki_sleeping_dart",
    "viper_viper_strike",
}
M.targetNonTrackingDisableAbilities = {
    "bloodseeker_rupture",
    "doom_bringer_doom",
    "ember_spirit_searing_chains",
    "grimstroke_ink_creature",
    "grimstroke_soul_chain",
    "item_sheepstick",
    "lion_vex",
    "shadow_demon_purge",
    "shadow_shaman_voodoo",
}
M.targetDisableAbilities = M:Concat(M.targetNonTrackingStunAbilities, M.targetTrackingDisableAbilities)
M.locationDisableAbilities = {
    "dark_willow_bramble_maze",
    "death_prophet_silence",
    "disruptor_kinetic_field",
    "disruptor_static_storm",
    "drow_ranger_wave_of_silence",
    "elder_titan_echo_stomp",
    "invoker_deafening_wave",
    "treant_overgrowth",
}
M.targetTrackingHeavyDamageAbilities = {
    "item_ethereal_blade",
    "lich_chain_frost",
    "lion_finger_of_death",
    "morphling_adaptive_strike_agi",
    "sniper_assassinate",
}
M.targetNonTrackingHeavyDamageAbilities = {
    "antimage_mana_void",
    "item_dagon",
    "lina_laguna_blade",
    "pugna_life_drain",
    "tinker_laser",
    "zuus_lightning_bolt",
}
M.targetHeavyDamageAbilities = M:Concat(M.targetTrackingHeavyDamageAbilities, M.targetNonTrackingHeavyDamageAbilities)
M.locationHeavyDamageAbilities = {
    "ancient_apparition_ice_blast",
    "antimage_mana_void",
    "disruptor_static_storm",
    "invoker_chaos_meteor",
    "invoker_sun_strike",
    "jakiro_macropyre",
    "kunkka_ghostship",
    "nevermore_requiem_of_souls",
    "obsidian_destroyer_sanitys_eclipse",
    "phoenix_sun_ray",
    "puck_dream_coil",
    "pugna_nether_blast",
    "queenofpain_sonic_wave",
    "sand_king_epicenter",
    "skywrath_mage_mystic_flare",
    "venomancer_poison_nova",
}
M.heavyDamageAbilities = M:Concat(M.targetTrackingHeavyDamageAbilities, M.locationHeavyDamageAbilities)
M.dodgeWorthAbilities = M:Concat(M.targetStunAbilities, M.locationStunAbilities, M.heavyDamageAbilities)
M.invisibleModifiers = {
    "modifier_bounty_hunter_wind_walk",
    "modifier_clinkz_wind_walk",
    "modifier_dark_willow_shadow_realm_buff",
    "modifier_item_glimmer_cape_glimmer",
    "modifier_invoker_ghost_walk_self",
    "modifier_nyx_assassin_vendetta",
    "modifier_item_phase_boots_active",
    "modifier_item_shadow_amulet_fade",
    "modifier_item_invisibility_edge_windwalk",
    "modifier_shadow_fiend_requiem_thinker",
    "modifier_item_silver_edge_windwalk",
    "modifier_windrunner_wind_walk",
    "modifier_storm_wind_walk",
    "modifier_templar_assassin_meld",
    "modifier_visage_silent_as_the_grave",
    "modifier_weaver_shukuchi",
}
M.phaseModifiers = {
    "modifier_bounty_hunter_wind_walk",
    "modifier_clinkz_wind_walk",
    "modifier_dark_willow_shadow_realm_buff",
    "modifier_faceless_void_chronosphere_selfbuff",
    "modifier_item_glimmer_cape_glimmer",
    "modifier_invoker_ghost_walk_self",
    "modifier_nyx_assassin_vendetta",
    "modifier_item_phase_boots_active",
    "modifier_item_shadow_amulet_fade",
    "modifier_item_invisibility_edge_windwalk",
    "modifier_shadow_fiend_requiem_thinker",
    "modifier_item_silver_edge_windwalk",
    "modifier_slardar_sprint",
    "modifier_storm_wind_walk",
    "modifier_templar_assassin_meld",
    "modifier_weaver_shukuchi",
}
M.phaseUnits = {
    "npc_dota_brewmaster_fire_1",
    "npc_dota_brewmaster_fire_2",
    "npc_dota_brewmaster_fire_3",
    "npc_dota_broodmother_web",
    "npc_dota_courier",
    "npc_dota_phoenix_sun",
    "npc_dota_juggernaut_healing_ward",
    "npc_dota_techies_land_mine",
    "npc_dota_techies_stasis_trap",
    "npc_dota_techies_remote_mine",
    "npc_dota_weaver_swarm",
}
M.unobstructedMovementModifiers = {
    "modifier_batrider_firefly",
    "modifier_broodmother_spin_web",
    "modifier_centaur_stampede",
    "modifier_dragon_knight_dragon_form",
    "modifier_item_giants_ring_giants_foot",
    "modifier_lich_sinister_gaze",
    "modifier_legion_commander_duel",
    "modifier_nyx_assassin_vendetta",
    "modifier_spectre_spectral_dagger_path_phased",
    "modifier_item_spider_legs_active",
    "modifier_visage_silent_as_the_grave",
}
M.flyingModifiers = {
    "modifier_rattletrap_jetpack",
    "modifier_night_stalker_darkness",
    "modifier_winter_wyvern_arctic_burn_flight",
}
M.flyingUnits = {
    "npc_dota_visage_familiar1",
    "npc_dota_visage_familiar2",
    "npc_dota_visage_familiar3",
    "npc_dota_flying_courier",
    "npc_dota_beastmaster_hawk",
}
M.positiveForceMovementModifiers = {
    "modifier_faceless_void_time_walk",
    "modifier_huskar_life_break_charge",
    "modifier_magnataur_skewer_movement",
    "modifier_monkey_king_bounce",
    "modifier_monkey_king_bounce_leap",
    "modifier_monkey_king_tree_dance_activity",
    "modifier_monkey_king_bounce_perch",
    "modifier_monkey_king_right_click_jump_activity",
    "modifier_pangolier_swashbuckle",
    "modiifer_pangolier_shield_crash_jump",
    "modifier_pangolier_rollup",
    "modifier_snapfire_firesnap_cookie",
    "modifier_snapfire_gobble_up",
    "modifier_sand_king_burrowstrike",
    "modifier_techies_suicide_leap",
}
M.timeSensitivePositiveModifiers = {
    "modifier_item_black_king_bar",
    "modifier_faceless_void_chronosphere_selfbuff",
    "modifier_medusa_stone_gaze",
    "modifier_monkey_king_fur_army_soldier_in_position",
}
M.basicDispellablePositiveModifiers = {
    "modifier_omniknight_guardian_angle",
    "modifier_ember_spirit_flame_guard",
    "modifier_legion_commander_press_the_attack",
    "modifier_windrunner_windrun",
    "modifier_lich_frost_shield",
    "modifier_oracle_purifying_flames",
    "modifier_ogre_magi_bloodlust",
    "modifier_treant_living_armor",
    "modifier_mirana_leap_buff",
    "modifier_necrolyte_death_seeker",
    "modifier_necrolyte_sadist_active",
    "modifier_pugna_decrepify",
    "modifier_item_ethereal_blade_ethereal",
    "modifier_ghost_state",
    "modifier_abaddon_frostmourne_buff",
    "modifier_item_mjollnir_static",
    "modifier_visage_silent_as_the_grave",
    "modifier_spirit_breaker_bulldoze",
    "modifier_item_spider_legs_active",
    "modifier_item_bullwhip_buff",
}
M.basicDispellWorthPositiveModifiers = {
    "modifier_omniknight_guardian_angle",
    "modifier_ember_spirit_flame_guard",
    "modifier_legion_commander_press_the_attack",
    "modifier_windrunner_windrun",
    "modifier_lich_frost_shield",
    "modifier_oracle_purifying_flames",
    "modifier_ogre_magi_bloodlust",
    "modifier_treant_living_armor",
    "modifier_mirana_leap_buff",
    "modifier_necrolyte_death_seeker",
    "modifier_necrolyte_sadist_active",
    "modifier_pugna_decrepify",
    "modifier_item_ethereal_blade_ethereal",
    "modifier_ghost_state",
}
M.basicDispellWorthNegativeModifiers = { "modifier_abaddon_frostmourne_debuff_bonus" }
M.basicDispellableNegativeModifiers = {
    "modifier_abaddon_frostmourne_debuff",
    "modifier_abaddon_frostmourne_debuff_bonus",
}
M.unbreakableChannelAbilities = {
    "puck_phase_shift",
    "pangolier_gyroshell",
    "lone_druid_true_form",
    "phoenix_supernova",
    "lycan_shapeshift",
}
M.nonIllusionModifiers = {}
M.valubleNeutrals = {
    "npc_dota_neutral_alpha_wolf",
    "npc_dota_neutral_centaur_khan",
    "npc_dota_neutral_polar_furbolg_ursa_warrior",
    "npc_dota_neutral_dark_troll_warlord",
    "npc_dota_neutral_mud_golem",
    "npc_dota_neutral_satyr_hellcaller",
}
M.valubleAncientNeutrals = {
    "npc_dota_neutral_black_dragon",
    "npc_dota_neutral_rock_golem",
    "npc_dota_neutral_big_thunder_lizard",
}
M.hypnosisModifiers = {
    "modifier_lich_sinister_gaze",
    "modifier_void_spirit_aether_remnant_pull",
    "modifier_keeper_of_the_light_will_o_wisp",
}
M.fearModifiers = {
    "modifier_dark_willow_debuff_fear",
    "modifier_lone_druid_savage_roar",
    "modifier_shadow_fiend_requiem_fear",
    "modifier_terrorblade_fear",
}
M.hexModifiers = {
    "modifier_lion_voodoo",
    "modifier_shadow_shaman_voodoo",
    "modifier_sheepstick_debuff",
    "modifier_item_princes_knife_hex",
    "modifier_hexxed",
}
M.silenceModifiers = {
    "modifier_abaddon_frostmourne_debuff_bonus",
    "modifier_silence",
    "modifier_bloodthorn_debuff",
    "modifier_disruptor_static_storm",
    "modifier_doom_bringer_doom",
    "modifier_drow_ranger_wave_of_silence",
    "modifier_earth_spirit_geomagnetic_grip_debuff",
    "modifier_enigma_black_hole_pull",
    "modifier_grimstroke_ink_creature_debuff",
    "modifier_legion_commander_duel",
    "modifier_item_mask_of_madness_berserk",
    "modifier_night_stalker_crippling_fear",
    "modifier_orchid_malevolence_debuff",
    "modifier_riki_smoke_screen",
    "modifier_silencer_global_silence",
    "modifier_silencer_last_word",
    "modifier_skywrath_mage_ancient_seal",
}
M.timedSilenceModifiers = {
    "modifier_abaddon_frostmourne_debuff_bonus",
    "modifier_silence",
    "modifier_bloodthorn_debuff",
    "modifier_doom_bringer_doom",
    "modifier_drow_ranger_wave_of_silence",
    "modifier_earth_spirit_geomagnetic_grip_debuff",
    "modifier_grimstroke_ink_creature_debuff",
    "modifier_legion_commander_duel",
    "modifier_item_mask_of_madness_berserk",
    "modifier_orchid_malevolence_debuff",
    "modifier_silencer_global_silence",
    "modifier_silencer_last_word",
    "modifier_skywrath_mage_ancient_seal",
}
M.magicImmuneModifiers = {
    "modifier_item_black_king_bar",
    "modifier_life_stealer_rage",
    "modifier_juggernaut_blade_fury",
    "modifier_minotaur_horn_immune",
    "modifier_elder_titan_echo_stomp_magic_immune",
    "modifier_huskar_life_break_charge",
    "modifier_legion_commander_press_the_attack_immunity",
    "modifier_lion_mana_drain_immunity",
}
M.muteModifiers = {
    "modifier_tusk_snowball",
    "modifier_doom_bringer_doom",
    "modifier_disruptor_static_storm_mute",
}
M.breakModifiers = {
    "modifier_hoodwink_sharpshooter",
    "modifier_phantom_assassin_fan_of_knives",
    "modifier_silver_edge_debuff",
    "modifier_viper_nethertoxin",
}
M.noTrueSightRootAbilityAssociation = {
    dark_willow_branble_maze = "modifier_dark_willow_bramble_maze",
    item_diffusal_blade = "modifier_rooted",
}
M.conditionalTrueSightRootAbilityAssociation = {
    dark_troll_warlord_ensnare = "modifier_dark_troll_warlord_ensnare",
    ember_spirit_searing_chains = "modifier_ember_spirit_searing_chains",
    oracle_fortunes_end = "modifier_oracle_fortunes_end_purge",
    item_rod_of_atos = "modifier_rod_of_atos_debuff",
}
M.permanentTrueSightRootAbilityAssociation = {
    broodmother_silken_bola = "modifier_broodmother_silken_bola",
    crystal_maiden_frostbite = "modfifier_crystal_maiden_frostbite",
    meepo_earthbind = "modifier_meepo_earthbind",
    naga_siren_ensnare = "modifier_naga_siren_ensnare",
    spirit_bear_entangling_claws = "modifier_lone_druid_spirit_bear_entangle_effect",
    techies_stasis_trap = "modifier_techies_stasis_trap_stunned",
    treant_overgrowth = "modifier_treant_overgrowth",
    troll_warlord_berserkers_rage = "modifier_troll_warlord_berserkers_rage_ensnare",
    abyssal_underlord_pit_of_malice = "modifier_abyssal_underlord_pit_of_malice_ensare",
}
M.rootAbilityAssociation = M:Concat(M.noTrueSightRootAbilityAssociation, M.conditionalTrueSightRootAbilityAssociation, M.permanentTrueSightRootAbilityAssociation)
local keysAfterAbilityInformation = M:Keys(M)
local abilityInformationKeys = keysAfterAbilityInformation:RemoveAll(keysBeforeAbilityInformation)
abilityInformationKeys:ForEach(function(t)
    setmetatable(M[t], magicTable)
end)
abilityInformationKeys = abilityInformationKeys:Filter(function(t)
    return t:match "AbilityAssociation"
end)
local function ExtendAssociation(association)
    return association:MapDic(function(key, value)
        return key
    end), association:Map(function(key, value)
        return value
    end):Distinct()
end
abilityInformationKeys:ForEach(function(t)
    local a,b = ExtendAssociation(M[t])
    local k = t:sub(1, #t - #"AbilityAssociation")
    M[k.."Abilities"] = a
    M[k.."Modifiers"] = b
end)
function M:IsRoshan(npcTarget)
    return npcTarget ~= nil and npcTarget:IsAlive() and string.find(npcTarget:GetUnitName(), "roshan")
end
function M:IsHero(t)
    return t:IsHero()
end
function M:IsTempestDouble(npc)
    return npc:HasModifier "modifier_arc_warden_tempest_double"
end
function M:IsLoneDruidBear(npc)
    return string.match(npc:GetUnitName(), "npc_dota_lone_druid_bear")
end
function M:IsVisageFamiliar(npc)
    return string.match(npc:GetUnitName(), "npc_dota_visage_familiar")
end
function M:IsBrewmasterPrimalSplit(npc)
    local unitName = npc:GetUnitName()
    return string.match(unitName, "npc_dota_brewmaster_")
end
M.GetIncomingDodgeWorthProjectiles = function(self, npc)
    local health = npc:GetHealth()
    local projectiles = npc:GetIncomingTrackingProjectiles()
    projectiles = self:Filter(projectiles, function(t)
        if t.is_attack then
            return false
        end
        if t.caster then
            if npc:GetTeam() == t.caster:GetTeam() then
                return false
            end
        else
            if GetTeamForPlayer(t.playerid) == npc:GetTeam() then
                return false
            end
        end
        local ability = t.ability
        if ability then
            local abilityName = ability:GetName()
            if self:Contains(self.UndisjointableProjectiles, abilityName) then
                return false
            end
            if self:Contains(self.targetTrackingStunAbilities, abilityName) or self:Contains(self.targetTrackingDisableAbilities, abilityName) or self:Contains(self.targetTrackingHeavyDamageAbilities, abilityName) or npc:GetHealth() <= npc:GetActualIncomingDamage(ability:GetAbilityDamage(), ability:GetDamageType()) then
                return true
            end
            return false
        end
        return true
    end)
    return projectiles
end
M.GetTargetHealAmplifyPercent = function(self, npc)
    local modifiers = npc:FindAllModifiers()
    local amplify = 1
    for i = 1, npc:NumModifiers() do
        local modifierName = npc:GetModifierName(i)
        if modifierName == "modifier_ice_blast" then
            return 0
        end
        if modifierName == "modifier_item_spirit_vessel_damage" then
            amplify = amplify - 0.45
        end
        if modifierName == "modifier_holy_blessing" then
            amplify = amplify + 0.3
        end
        if modifierName == "modifier_necrolyte_sadist_active" then
            amplify = amplify + 0.75
        end
        if modifierName == "modifier_wisp_tether_haste" then
            amplify = amplify + 0.6
        end
        if modifierName == "modifier_oracle_false_promise" then
            amplify = amplify + 1
        end
    end
    return amplify
end
M.IsChannelingItem = function(self, npc)
    return npc:HasModifier "modifier_item_meteor_hammer" or npc:HasModifier "modifier_teleporting" or npc:HasModifier "modifier_boots_of_travel_incoming"
end
M.IsChannelingAbility = function(self, npc)
    return npc:IsChanneling() and not self:IsChannelingItem(npc)
end
function M:IsChannelingBreakWorthAbility(npc)
    if not npc:IsChanneling() then
        return false
    end
    local ability = npc:GetCurrentActiveAbility()
    if ability == nil then
        if npc:HasModifier "modifier_teleporting" then
            return true
        end
        local item = self:GetAvailableItem(npc, "item_fallen_sky")
        return item ~= nil
    end
    local name = ability:GetName()
    if self:Contains(self.unbreakableChannelAbilities, name) then
        return false
    end
    return true
end
M.RadiantPlayerId = M:Map(GetTeamPlayers(TEAM_RADIANT), function()
end)
M.DirePlayerId = GetTeamPlayers(TEAM_DIRE)
M.GetTeamPlayers = function(self, team)
    if team == TEAM_RADIANT then
        return self.RadiantPlayerId
    else
        return self.DirePlayerId
    end
end
M.GetEnemyTeamMemberNames = function(self, npcBot)
    local enemies = self:GetEnemyHeroUnique(npcBot, GetUnitList(UNIT_LIST_ENEMY_HEROES))
    return self:Map(enemies, function(t)
        return t:GetUnitName()
    end)
end
M.enemyVisibleIllusionModifiers = {
    "modifier_illusion",
    "modifier_terrorblade_conjureimage",
    "modifier_grimstroke_scepter_buff",
    "modifier_arc_warden_tempest_double",
    "modifier_skeleton_king_reincarnation_active",
    "modifier_vengefulspirit_hybrid_special",
}
M.MustBeIllusion = function(self, npcBot, target)
    if npcBot:GetTeam() == target:GetTeam() then
        return target:IsIllusion() or self:HasAnyModifier(target, self.enemyVisibleIllusionModifiers)
    end
    if self:Contains(self:GetTeamPlayers(npcBot:GetTeam()), target:GetPlayerID()) or target.markedAsIllusion then
        return true
    end
    if target.markedAsRealHero then
        return false
    end
    if not IsHeroAlive(target:GetPlayerID()) then
        return true
    end
    return false
end
M.MayNotBeIllusion = function(self, npcBot, target)
    return not self:MustBeIllusion(npcBot, target)
end
function M:IsOnSameTeam(a, b)
    return a:GetTeam() == b:GetTeam()
end
function M:IsNonIllusionHero(npcBot, target)
    return self:MayNotBeIllusion(npcBot, target) and self:IsHero(target)
end
function M:HasNonIllusionModifier(npc)
    return self:HasAnyModifier(npc, self.nonIllusionModifiers)
end
function M:CanIllusionUseAbility(npc)
    local name = npc:GetUnitName()
    local ability = npc:GetCurrentActiveAbility()
    if ability == nil then
        return false
    end
    if name == "npc_dota_hero_bane" and self:HasScepter(npc) and ability:GetName() == "bane_fiends_grip" then
        return true
    end
end
M.DetectIllusion = function(self, npcBot)
    local nearbyEnemies = self:GetNearbyNonIllusionHeroes(npcBot, 1599)
    nearbyEnemies = self:Filter(nearbyEnemies, function(t)
        return string.match(t:GetUnitName(), "npc_dota_hero")
    end)
    local nearbyEnemyGroups = self:GroupBy(nearbyEnemies, function(t)
        return t:GetUnitName()
    end)
    nearbyEnemyGroups = self:Filter(nearbyEnemyGroups, function(t)
        return #t > 1
    end)
    self:ForEach(nearbyEnemyGroups, function(nearbyEnemyGroup)
        local castingEnemies = self:Filter(nearbyEnemyGroup, function(t)
            return (t:IsUsingAbility() or t:IsChanneling() or self:HasNonIllusionModifier(t) or t.markedAsRealHero) and not t.markedAsIllusion
        end)
        local castingEnemy = castingEnemies[1]
        if castingEnemy and not self:CanIllusionUseAbility(castingEnemy) then
            castingEnemy.markedAsRealHero = true
            castingEnemies = self:Remove(nearbyEnemyGroup, castingEnemy)
            self:ForEach(castingEnemies, function(t)
                t.markedAsIllusion = true
            end)
        end
    end)
end
M.GetNearbyHeroes = function(self, npcBot, range, getEnemy, botModeMask)
    range = range or 1200
    if getEnemy == nil then
        getEnemy = true
    end
    botModeMask = botModeMask or BOT_MODE_NONE
    local heroes = npcBot:GetNearbyHeroes(range, getEnemy, botModeMask) or {}
    GiveLinqFunctions(heroes, magicTable)
    return heroes
end
function M:GetAllHeores(npcBot, getEnemy)
    if getEnemy == nil then
        getEnemy = true
    end
    if getEnemy then
        return self:GetEnemyHeroUnique(npcBot, GetUnitList(UNIT_LIST_ENEMY_HEROES)):Filter(function(it)
            self:MayNotBeIllusion(npcBot, it)
        end)
    else
        return self:Filter(GetUnitList(UNIT_LIST_ALLIED_HEROES), function(it)
            self:MayNotBeIllusion(npcBot, it)
        end)
    end
end
function M:GetNearbyCreeps(npcBot, range, getEnemy)
    if getEnemy == nil then
        getEnemy = true
    end
    local t = npcBot:GetNearbyCreeps(range, getEnemy) or {}
    GiveLinqFunctions(t, magicTable)
    return t
end
function M:GetNearbyLaneCreeps(npcBot, range, getEnemy)
    if getEnemy == nil then
        getEnemy = true
    end
    local t = npcBot:GetNearbyLaneCreeps(range, getEnemy) or {}
    GiveLinqFunctions(t, magicTable)
    return t
end
M.GetNearbyNonIllusionHeroes = function(self, npcBot, range, getEnemy, botModeMask)
    range = range or 1200
    if getEnemy == nil then
        getEnemy = true
    end
    botModeMask = botModeMask or BOT_MODE_NONE
    local heroes = npcBot:GetNearbyHeroes(range, getEnemy, botModeMask)
    return self:Filter(heroes, function(t)
        return self:MayNotBeIllusion(npcBot, t)
    end)
end
function M:AttackOnceDamage(npcBot, target)
    return target:GetActualIncomingDamage(npcBot:GetAttackDamage() - npcBot:GetBaseDamageVariance() / 2, DAMAGE_TYPE_PHYSICAL)
end
function M:GetNearbyAttackableCreeps(npcBot, range, getEnemy)
    if getEnemy == nil then
        getEnemy = true
    end
    local creeps = npcBot:GetNearbyCreeps(range, getEnemy)
    if getEnemy then
        creeps = self:Filter(creeps, function(t)
            return t:HasModifier "modifier_fountain_glyph"
        end)
    end
    GiveLinqFunctions(creeps, magicTable)
    return creeps
end
M.GetNearbyAllUnits = function(self, npcBot, range)
    local h1 = npcBot:GetNearbyHeroes(range, true, BOT_MODE_NONE)
    local h2 = self:Remove(npcBot:GetNearbyHeroes(range, false, BOT_MODE_NONE), npcBot)
    local h3 = npcBot:GetNearbyCreeps(range, true)
    local h4 = npcBot:GetNearbyCreeps(range, false)
    return self:Concat(h1, h2, h3, h4)
end
function M:GetNearbyEnemyUnits(npc, range)
    local h1 = npc:GetNearbyHeroes(range, true, BOT_MODE_NONE)
    local h3 = npc:GetNearbyCreeps(range, true)
    return self:Concat(h1, h3)
end
M.GetEnemyHeroUnique = function(self, npcBot, enemies)
    local p = self:Filter(enemies, function(t)
        self:MayNotBeIllusion(npcBot, t)
    end)
    local g = NewTable()
    local readNames = NewTable()
    for _, enemy in pairs(p) do
        local name = enemy:GetUnitName()
        if not self:Contains(readNames, name) then
            table.insert(readNames, name)
            table.insert(g, enemy)
        end
    end
    return g
end
M.GetMovementSpeedPercent = function(self, npc)
    return npc:GetCurrentMovementSpeed() / npc:GetBaseMovementSpeed()
end
M.CanHardlyMove = function(self, npc)
    return npc:IsStunned() or npc:IsRooted() or npc:GetCurrentMovementSpeed() <= 150
end
M.GetModifierRemainingDuration = function(self, npc, modifierName)
    local mod = npc:GetModifierByName(modifierName)
    if mod ~= -1 then
        return npc:GetModifierRemainingDuration(mod)
    end
    return 0
end
M.imprisonmentModifier = {
    "modifier_item_cyclone",
    "modifier_item_wind_waker",
    "modifier_shadow_demon_disruption",
    "modifier_obsidian_destroyer_astral_imprisonment_prison",
    "modifier_brewmaster_storm_cyclone",
    "modifier_invoker_tornado",
}
M.GetImprisonmentRemainingDuration = function(self, npc)
    return self:First(self:Map(self.imprisonmentModifier, function(t)
        return self:GetModifierRemainingDuration(npc, t)
    end), function(t)
        return t ~= 0
    end) or 0
end
function M:GetMagicImmuneRemainingDuration(npc)
    local remainingTime = self:Map(self.magicImmuneModifiers, function(t)
        return {
            t,
            self:GetModifierRemainingDuration(npc, t),
        }
    end)
    remainingTime = self:SortByMaxFirst(remainingTime, function(t)
        return t[2]
    end)
    remainingTime = remainingTime[1]
    return remainingTime and remainingTime[2] or 0
end
function M:GetSilenceRemainingDuration(npc)
    local silenceModifierRemainings = self:Map(self.timedSilenceModifiers, function(t)
        return self:GetModifierRemainingDuration(npc, t)
    end)
    if npc:HasModifier "modifier_disruptor_static_storm" then
        table.insert(silenceModifierRemainings, 1, 6)
    end
    if npc:HasModifier "modifier_enigma_black_hole_pull" or npc:HasModifier "modifier_riki_smoke_screen" then
        table.insert(silenceModifierRemainings, 1, 4)
    end
    silenceModifierRemainings = #silenceModifierRemainings ~= 0 and math.max(self:Unpack(silenceModifierRemainings)) or 0
    return silenceModifierRemainings
end
function M:GetStunRemainingDuration(npc)
    return self:DontControlAgain(npc) and 1 or 0
end
M.GetEnemyHeroNumber = function(self, npcBot, enemies)
    return #self:GetEnemyHeroUnique(npcBot, enemies)
end
function M:HasPhasedMovement(npc)
    return self:HasAnyModifier(npc, self.phaseModifiers) or self:Contains(self.phaseUnits, npc:GetUnitName())
end
function M:HasUnobstructedMovement(npc)
    if self:HasAnyModifier(npc, self.flyingModifiers) or self:Contains(self.flyingUnits, npc:GetUnitName()) then
        if string.match(npc:GetUnitName(), "npc_dota_visage_familiar") then
            return npc:HasModifier "modifier_rooted"
        end
        return true
    end
    local activeFlyingModifiers = self:Filter(self.unobstructedMovementModifiers, function(t)
        return npc:HasModifier(t)
    end)
    if #activeFlyingModifiers ~= 0 then
        local dragonKnightDragonForm = self:IndexOf(activeFlyingModifiers, "modifier_dragon_knight_dragon_form")
        if dragonKnightDragonForm ~= -1 then
            local ability = npc:GetAbilityByName "dragon_knight_elder_dragon_form"
            if ability == nil or not (ability:GetLevel() == 4) then
                table.remove(activeFlyingModifiers, dragonKnightDragonForm)
            end
        end
        local stampede = self:IndexOf(activeFlyingModifiers, "modifier_centaur_stampede")
        if stampede ~= -1 then
            local ability = npc:GetAbilityByName "modifier_centaur_stampede"
            if ability == nil or not self:hasScepter(npc) then
                table.remove(activeFlyingModifiers, stampede)
            end
        end
    end
    return #activeFlyingModifiers ~= 0
end
M.GetAvailableItem = function(self, npc, itemName)
    for i = 0, 5 do
        local item = npc:GetItemInSlot(i)
        if item and item:GetName() == itemName and item:IsFullyCastable() then
            return item
        end
    end
end
local radianceAncientLocation = Vector(-7200, -6666)
local direAncientLocation = Vector(7137, 6548)
M.GetAncientLocation = function(self, npc)
    if npc:GetTeam() == TEAM_RADIANT then
        return radianceAncientLocation
    else
        return direAncientLocation
    end
end
M.GetDistanceFromAncient = function(self, npc)
    local fountain = self:GetAncientLocation(npc)
    return GetUnitToLocationDistance(npc, fountain)
end
M.TryUseTp = function(self, npc)
    local item = npc:GetItemInSlot(15)
    if item ~= nil and item:IsFullyCastable() and self:CanMove(npc) then
        local distanceFromFountain
        if npc:GetTeam() == TEAM_RADIANT then
            distanceFromFountain = radianceAncientLocation + Vector(400, 400)
        else
            distanceFromFountain = direAncientLocation + Vector(-400, -400)
        end
        npc:Action_UseAbilityOnLocation(item, distanceFromFountain)
        return true
    end
end
M.GetAvailableBlink = function(self, npc)
    local blinks = {
        "item_blink",
        "item_overwhelming_blink",
        "item_swift_blink",
        "item_arcane_blink",
    }
    return self:Aggregate(nil, blinks, function(a, blinkName)
        return a or self:GetAvailableItem(npc, blinkName)
    end)
end
function M:GetAvailableTravelBoots(npc)
    local travelBoots = {
        "item_travel_boots",
        "item_travel_boots_2",
    }
    return self:Aggregate(nil, travelBoots, function(seed, t)
        return seed or self:GetAvailableItem(npc, t)
    end)
end
M.GetEmptyInventorySlots = function(self, npc)
    local g = 0
    for i = 0, 5 do
        if npc:GetItemInSlot(i) == nil then
            g = g + 1
        end
    end
    return g
end
M.GetEmptyItemSlots = function(self, npc)
    local g = 0
    for i = 0, 8 do
        if npc:GetItemInSlot(i) == nil then
            g = g + 1
        end
    end
    return g
end
M.GetEmptyBackpackSlots = function(self, npc)
    local g = 0
    for i = 6, 8 do
        if npc:GetItemInSlot(i) == nil then
            g = g + 1
        end
    end
    return g
end
M.SwapItemToBackpack = function(self, npc, itemIndex)
    for i = 6, 8 do
        if npc:GetItemInSlot(i) == nil then
            npc:ActionImmediate_SwapItems(itemIndex, i)
            return true
        end
    end
    return false
end
M.GetCarriedItems = function(self, npc)
    local g = NewTable()
    for i = 0, 8 do
        local item = npc:GetItemInSlot(i)
        if item ~= nil then
            item.slotIndex = i
            table.insert(g, item)
        end
    end
    return g
end
M.GetInventoryItems = function(self, npc)
    local g = NewTable()
    for i = 0, 5 do
        local item = npc:GetItemInSlot(i)
        if item ~= nil then
            item.slotIndex = i
            table.insert(g, item)
        end
    end
    return g
end
M.GetInventoryItemNames = function(self, npc)
    local g = NewTable()
    for i = 0, 5 do
        local item = npc:GetItemInSlot(i)
        if item ~= nil then
            item.slotIndex = i
            table.insert(g, item:GetName())
        end
    end
    return g
end
M.GetStashItems = function(self, npc)
    local g = NewTable()
    for i = 9, 14 do
        local item = npc:GetItemInSlot(i)
        if item ~= nil then
            item.slotIndex = i
            table.insert(g, item)
        end
    end
    return g
end
function M:GetCourierItems(courier)
    local g = NewTable()
    for i = 0, 8 do
        local item = courier:GetItemInSlot(i)
        if item then
            table.insert(g, item)
        end
    end
    return g
end
function M:GetMyCourier(npcBot)
    if npcBot.courierIDNew == nil then
        self:FindCourier(npcBot)
    end
    return GetCourier(npcBot.courierIDNew)
end
function M:FindCourier(npcBot)
    for i = 0, 4 do
        local courier = GetCourier(i)
        if courier ~= nil then
            if courier:GetPlayerID() == npcBot:GetPlayerID() then
                npcBot.courierIDNew = i
            end
        end
    end
end
M.GetAllBoughtItems = function(self, npcBot)
    local g = NewTable()
    for i = 0, 15 do
        local item = npcBot:GetItemInSlot(i)
        if item then
            table.insert(g, item)
        end
    end
    if DotaTime() >= -70 then
        g = self:Concat(g, self:GetCourierItems(self:GetMyCourier(npcBot)))
    end
    return g
end
M.IsBoots = function(self, item)
    if type(item) ~= "string" then
        item = item:GetName()
    end
    return string.match(item, "boots") or item == "item_guardian_greaves" or #item >= 17 and string.sub(item, 17) == "item_power_treads"
end
M.SwapCheapestItemToBackpack = function(self, npc)
    local cheapestItem = self:First(self:Sort(self:Filter(self:GetInventoryItems(npc), function(t)
        return not self:IsBoots(t) and not string.match(t:GetName(), "ward")
    end), function(a, b)
        return GetItemCost(a:GetName()) - GetItemCost(b:GetName())
    end))
    if cheapestItem == nil then
        return false
    end
    return self:SwapItemToBackpack(npc, cheapestItem.slotIndex)
end
M.SuitableForSilence = function(self, npc, target)
    return self:MayNotBeIllusion(npc, target) and not target:IsMagicImmune() and not self:IsInvulnerable(target)
end
M.GetHeroFullName = function(self, s)
    return "npc_dota_hero_"..s
end
M.GetHeroShortName = function(self, s)
    return string.sub(s, 15)
end
M.IsMeleeHero = function(self, npc)
    local range = npc:GetAttackRange()
    local name = npc:GetUnitName()
    return range <= 210 or name == self:GetHeroFullName "tiny" or name == self:GetHeroFullName "doom_bringer" or name == self:GetHeroFullName "pudge"
end
function M:HasAnyModifier(npc, modifierGroup)
    return self:First(modifierGroup, function(t)
        return npc:HasModifier(t)
    end)
end
M.AttackPassiveAbilities = {
    "doom_bringer_infernal_blade",
    "drow_ranger_frost_arrows",
    "clinkz_fire_arrows",
    "viper_poison_attack",
    "obsidian_destroyer_arcane_orb",
}
M.OtherIgnoreAbilityBlockAbilities = {
    "batrider_flaming_lasso",
    "gyrocopter_homing_missile",
    "axe_culling_blade",
}
M.IgnoreAbilityBlockAbilities = {
    "dark_seer_ion_shell",
    "grimstroke_soulbind",
    "rubick_spell_steal",
    "spectre_spectral_dagger",
    "morphling_morph",
    "urn_of_shadows_soul_release",
    "spirit_vessel_soul_release",
    "medallion_of_courage_valor",
    "solar_crest_armor_shine",
}
M.IgnoreAbilityBlock = function(self, ability)
    local abilityName = ability:GetName()
    return self:Contains(self.AttackPassiveAbilities, abilityName) or self:Contains(self.IgnoreAbilityBlockAbilities, abilityName) or self:Contains(self.OtherIgnoreAbilityBlockAbilities, abilityName)
end
M.AbilityRetargetModifiers = {
    "modifier_antimage_counterspell",
    "modifier_item_lotus_orb_active",
    "modifier_nyx_assassin_spiked_carapace",
}
M.HasAbilityRetargetModifier = function(self, npc)
    return self:HasAnyModifier(npc, self.AbilityRetargetModifiers)
end
function M:DarkPactRemainingTime(npc)
    if npc:HasModifier "modifier_slark_dark_pact" then
        return self:GetModifierRemainingDuration(npc, "modifier_slark_dark_pact") + 1
    else
        return self:GetModifierRemainingDuration(npc, "modifier_slark_dark_pact_pulses")
    end
end
M.CanMove = function(self, npc)
    return not npc:IsStunned() and not npc:IsRooted() and not self:IsNightmared(npc) and not self:IsTaunted(npc)
end
function M:CannotMove(npc)
    return npc:IsRooted() or self:IsTaunted(npc) or self:IsHypnosed(npc) or self:IsFeared(npc)
end
function M:CannotTeleport(npc)
    return npc:IsRooted() or self:IsTaunted(npc) or self:IsHypnosed(npc) or self:IsFeared(npc)
end
function M:IsNightmared(npc)
    return npc:HasModifier "modifier_bane_nightmare" or npc:HasModifier "modifier_riki_poison_dart_debuff"
end
function M:IsTaunted(npc)
    return npc:HasModifier "modifier_axe_berserkers_call" or npc:HasModifier "modifier_legion_commander_duel"
end
function M:DontControlAgain(npc)
    return npc:IsStunned() or self:IsNightmared(npc) or self:IsTaunted(npc) or self:IsHypnosed(npc)
end
function M:IsDuelCaster(npc)
    local function IsTaunting(_npc)
        local ability = _npc:GetAbilityByName "modifier_legion_commander_duel"
        return ability and ability:GetCooldownTimeRemaining() + self:GetModifierRemainingDuration(_npc, "modifier_legion_commander_duel") + 1 >= ability:GetCooldown()
    end
    local npcBot = GetBot()
    if npcBot:GetTeam() == npc:GetTeam() then
        return IsTaunting(npc)
    else
        local players = self:Map(self:Range(0, 4), GetTeamMember)
        local tauntingPlayer = self:First(players, function(t)
            return IsTaunting(t) and t:GetAttackTarget() == npc
        end)
        return IsTaunting and not IsTaunting(tauntingPlayer)
    end
end
function M:IsMuted(npc)
    return npc:IsHexed() or self:HasAnyModifier(npc, self.muteModifiers)
end
function M:IsHypnosed(npc)
    return self:HasAnyModifier(npc, self.hypnosisModifiers)
end
function M:IsFeared(npc)
    return self:HasAnyModifier(npc, self.fearModifiers)
end
M.IsSeverelyDisabled = function(self, npc)
    return npc:IsStunned() or npc:IsHexed() or npc:IsRooted() or self:IsFeared(npc) or self:IsHypnosed(npc) or self:IsNightmared(npc) or npc:HasModifier "modifier_legion_commander_duel" and not self:IsDuelCaster(npc) or npc:HasModifier "modifier_axe_berserkers_call" or npc:HasModifier "modifier_shadow_demon_purge_slow" or npc:HasModifier "modifier_doom_bringer_doom"
end
M.IsSeverelyDisabledOrSlowed = function(self, npc)
    return self:IsSeverelyDisabled(npc) or self:GetMovementSpeedPercent(npc) <= 0.35
end
M.HasSeverelyDisableProjectiles = function(self, npc)
    local projectiles = self:GetIncomingDodgeWorthProjectiles(npc)
    return self:Any(projectiles, function(t)
        return self:Contains(self.targetTrackingStunAbilities, t.ability:GetName())
    end)
end
M.IsOrGoingToBeSeverelyDisabled = function(self, npc)
    return self:IsSeverelyDisabled(npc) or self:HasSeverelyDisableProjectiles(npc)
end
M.EtherealModifiers = {
    "modifier_ghost_state",
    "modifier_item_ethereal_blade_ethereal",
    "modifier_necrolyte_death_seeker",
    "modifier_necrolyte_sadist_active",
    "modifier_pugna_decrepify",
}
M.IsEthereal = function(self, npc)
    return self:HasAnyModifier(npc, self.EtherealModifiers)
end
function M:NotBlasted(self, npc)
    return not npc:HasModifier "modifier_ice_blast"
end
M.CannotBeTargetted = function(self, npc)
    return self:HasAnyModifier(npc, self.CannotBeTargettedModifiers)
end
M.CanBeTargettedFunction = function(npc)
    return not M:CanBeTargetted(npc)
end
M.CannotBeAttacked = function(self, npc)
    return self:IsEthereal(npc) or self:IsInvulnerable(npc) or self:CannotBeTargetted(npc)
end
M.CanBeAttackedFunction = function(npc)
    return not M:CanBeAttacked(npc)
end
M.IsInvulnerable = function(self, npc)
    return npc:IsInvulnerable() or self:Any(self.IgnoreDamageModifiers, function(t)
        return npc:HasModifier(t)
    end)
end
M.MayNotBeSeen = function(self, npc)
    if not npc:IsInvisible() or npc:HasModifier "modifier_item_dust" or npc:HasModifier "modifier_bounty_hunter_track" or npc:HasModifier "modifier_slardar_amplify_damage" or npc:HasModifier "modifier_truesight" then
        return false
    end
    if self:HasAnyModifier(npc, self.permanentTrueSightRootModifiers) then
        return false
    end
    local enemies = self:GetNearbyHeroes(npc)
    return self:All(enemies, function(t)
        if self:GetAvailableItem(t, "item_gem") then
            return false
        end
        if t:GetAttackTarget() == npc then
            return false
        end
        if t:IsUsingAbility() then
            local ability = t:GetCurrentActiveAbility()
            if binlib.Test(ability:GetBehavior(), ABILITY_BEHAVIOR_UNIT_TARGET) and t:IsFacingLocation(npc:GetLocation(), 10) then
                return false
            end
        end
        return true
    end) and not self:Any(npc:GetNearbyCreeps(1000, true), function(t)
        return t:GetUnitName() == "npc_dota_necronomicon_warrior_3"
    end)
end
M.ShouldNotBeAttacked = function(self, npc)
    return self:CannotBeAttacked(npc) or self:Any(self.IgnoreDamageModifiers, function(t)
        return npc:HasModifier(t)
    end) or self:Any(self.IgnorePhysicalDamageModifiers, function(t)
        return npc:HasModifier(t)
    end)
end
M.PhysicalCanCastFunction = function(npc)
    return not M:IsInvulnerable(npc) and not M:ShouldNotBeAttacked(npc) and not npc:IsMagicImmune()
end
M.IsPhysicalOutputDisabled = function(self, npc)
    return npc:IsDisarmed() or npc:IsBlind() and not self:GetAvailableItem(npc, "item_monkey_king_bar") or self:IsEthereal(npc)
end
M.GetHealthPercent = function(self, npc)
    return npc:GetHealth() / npc:GetMaxHealth()
end
function M:GetPhysicalHealth(t)
    return t:GetHealth() * (1 + 0.06 * t:GetArmor()) / (1 - t:GetEvasion())
end
function M:GetBuildingPhysicalHealth(t)
    local h = self:GetPhysicalHealth(t)
    if t:HasModifier "modifier_fountain_glyph" then
        h = h + self:GetModifierRemainingDuration(t, "modifier_fountain_glyph") * 200
    end
    return h
end
M.GetManaPercent = function(self, npc)
    return npc:GetMana() / npc:GetMaxMana()
end
M.GetHealthDeficit = function(self, npc)
    return npc:GetMaxHealth() - npc:GetHealth()
end
function M:GetManaDeficit(npc)
    return npc:GetMaxMana() - npc:GetMana()
end
function M:GetTargetIfGood(npc)
    local target = npc:GetTarget()
    if target and target:IsHero() and self:MayNotBeIllusion(npc, target) then
        return target
    end
end
function M:GetTargetIfBad(npc)
    local target = npc:GetTarget()
    if target and (not target:IsHero() or self:MustBeIllusion(npc, target)) then
        return target
    end
end
function M:IndexOfBasicDispellablePositiveModifier(npc)
    return self:Aggregate(nil, self.basicDispellWorthPositiveModifiers, function(seed, modifier, index)
        if seed then
            return seed
        end
        local b = npc:HasModifier(modifier)
        if b then
            return index
        else
            return nil
        end
    end) or -1
end
function M:HasBasicDispellablePositiveModifier(npc)
    return self:Any(self.basicDispellWorthPositiveModifiers, function(t)
        return t:HasModifier(t)
    end)
end
function M:DontInterruptAlly(npc)
    return self:HasAnyModifier(npc, self.positiveForceMovementModifiers) or self:HasAnyModifier(npc, self.timeSensitivePositiveModifiers) or self:IsDuelCaster(npc)
end
M.MidLaneTowers = {
    TOWER_MID_1,
    TOWER_MID_2,
    TOWER_MID_3,
}
M.BotLaneTowers = {
    TOWER_BOT_1,
    TOWER_BOT_2,
    TOWER_BOT_3,
}
M.TopLaneTowers = {
    TOWER_TOP_1,
    TOWER_TOP_2,
    TOWER_TOP_3,
}
function M:GetLaningTower(npc)
    local team = npc:GetTeam()
    local lane = npc:GetAssignedLane()
    local function ToTower(t)
        return GetTower(team, t)
    end
    local function TowerExists(t)
        return t:GetHealth() > 0
    end
    if lane == LANE_BOT then
        local a = self:Map(self.BotLaneTowers, ToTower)
        return self:First(a, TowerExists)
    elseif lane == LANE_MID then
        return self:First(self:Map(self.MidLaneTowers, ToTower), TowerExists)
    elseif lane == LANE_TOP then
        return self:First(self:Map(self.TopLaneTowers, ToTower), TowerExists)
    end
end
M.DebugTable = function(self, tb)
    local msg = "{ "
    local DebugRec
    DebugRec = function(tc)
        for k, v in pairs(tc) do
            if type(v) == "number" or type(v) == "string" then
                msg = msg..k.." = "..v..", "
            elseif type(v) == "boolean" then
                msg = msg..k.." = "..tostring(v)..", "
            elseif type(v) == "table" then
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
M.DebugLongTable = function(self, tb)
    for k, v in pairs(tb) do
        if type(v) == "table" then
            print(tostring(k).." = ")
            self:DebugTable(v)
        else
            print(tostring(k).." = "..tostring(v))
        end
    end
end
M.DebugArray = function(self, tb)
    for k, v in ipairs(tb) do
        if type(v) == "table" then
            self:DebugTable(v)
        else
            print(v)
        end
    end
end
M.PrintAbilities = function(self, npcBot)
    local abilityNames = "{\n"
    for i = 0, 23 do
        local ability = npcBot:GetAbilityInSlot(i)
        if ability ~= nil and ability:GetName() ~= "generic_hidden" then
            abilityNames = abilityNames.."\t\""..ability:GetName().."\",\n"
        end
    end
    abilityNames = abilityNames.."}"
    print(npcBot:GetUnitName())
    print(abilityNames)
end
function M:PrintMode(npc)
    print("bot "..npc:GetUnitName().." in mode "..npc:GetActiveMode()..", desire = "..npc:GetActiveModeDesire())
end
function M:NormalCanCast(target, isPureDamageWithoutDisable, damageType, pierceMagicImmune, targetMustBeSeen, mustBeTargettable)
    damageType = damageType or DAMAGE_TYPE_MAGICAL
    if pierceMagicImmune == nil then
        if damageType == DAMAGE_TYPE_MAGICAL then
            pierceMagicImmune = false
        else
            pierceMagicImmune = true
        end
    end
    if isPureDamageWithoutDisable == nil then
        isPureDamageWithoutDisable = true
    end
    if self:IsInvulnerable(target) then
        return false
    end
    if mustBeTargettable == nil then
        mustBeTargettable = true
    end
    if mustBeTargettable and self:CannotBeTargetted(target) then
        return false
    end
    if not pierceMagicImmune and target:IsMagicImmune() then
        return false
    end
    if targetMustBeSeen and not target:CanBeSeen() then
        return false
    end
    if isPureDamageWithoutDisable and (damageType == DAMAGE_TYPE_PHYSICAL and self:ShouldNotBeAttacked(target) or damageType == DAMAGE_TYPE_MAGICAL and (target:IsMagicImmune() or self:Contains(self.IgnoreMagicalDamageModifiers, function(t)
        target:HasModifier(t)
    end))) then
        return false
    end
    return true
end
M.NormalCanCastFunction = function(target)
    return M:NormalCanCast(target)
end
function M:SpellCanCast(target, pierceMagicImmune, targetMustBeSeen, mustBeTargettable)
    if targetMustBeSeen == nil then
        targetMustBeSeen = true
    end
    if mustBeTargettable == nil then
        mustBeTargettable = true
    end
    if target:IsInvulnerable() then
        return false
    end
    if mustBeTargettable and self:CannotBeTargetted(target) then
        return false
    end
    if not pierceMagicImmune and target:IsMagicImmune() then
        return false
    end
    return true
end
M.SpellCanCastFunction = function(target)
    return M:SpellCanCast(target)
end
function M:StunCanCast(target, ability, pierceMagicImmune, targetCast, dispellable, considerDamage)
    if dispellable == nil then
        dispellable = true
    end
    if considerDamage == nil then
        considierDamage = true
    end
    if not pierceMagicImmune and target:IsMagicImmune() then
        return false
    end
    if targetCast and self:HasAbilityRetargetModifier(target) then
        return false
    end
    if target:IsInvulnerable() then
        return false
    end
    if dispellable and self:DarkPactRemainingTime(target) > ability:GetCastPoint() then
        return false
    end
    return true
end
function M:AllyCanCast(target, pierceMagicImmune)
    if pierceMagicImmune == nil then
        pierceMagicImmune = true
    end
    if not pierceMagicImmune and target:IsMagicImmune() then
        return false
    end
    return not target:IsInvulnerable() and not self:CannotBeTargetted(target)
end
M.AllyCanCastFunction = function(target)
    return M:AllyCanCast(target)
end
function M:NeutralCanCast(target)
end
function M:EnemyAllyCanCast(target, isPureDamageWithoutDisable, damageType, pierceMagicImmune, targetMustBeSeen)
    if self:IsOnSameTeam(target, GetBot()) then
        return self:NormalCanCast(target, isPureDamageWithoutDisable, damageType, pierceMagicImmune, targetMustBeSeen)
    else
        return self:AllyCanCast(target, pierceMagicImmune, targetMustBeSeen)
    end
end
M.SpecialBonusAttributes = "special_bonus_attributes"
M.TalentNamePrefix = "special_bonus_"
M.IncorrectAbilityName = "incorrect_name"
M.IsTalent = function(self, ability)
    if ability == nil then
        return false
    end
    if type(ability) ~= "string" then
        ability = ability:GetName()
    end
    return ability ~= "special_bonus_attributes" and #ability >= #self.TalentNamePrefix and string.sub(ability, 1, #self.TalentNamePrefix) == self.TalentNamePrefix
end
M.GetAbilities = function(self, npcBot)
    local g = NewTable()
    for i = 0, 25 do
        local ability = npcBot:GetAbilityInSlot(i)
        if ability ~= nil and ability:GetName() ~= "generic_hidden" then
            table.insert(g, ability)
        end
    end
    return g
end
M.GetAbilityNames = function(self, npcBot)
    return self:Map(self:GetAbilities(npcBot), function(t)
        return t:GetName()
    end)
end
M.GetTalents = function(self, npcBot)
    return self:Filter(self:GetAbilities(npcBot), function(t)
        return self:IsTalent(t)
    end)
end
M.GetAbilityLevelUpIndex = function(self, npcBot)
    return npcBot:GetLevel() - npcBot:GetAbilityPoints() + 1 + npcBot.abilityTable.incorrectAbilityLevelUpNumber
end
M.FillInAbilities = function(self, npcBot, abilityTable)
    local abilities = self:GetAbilityNames(npcBot)
    if #abilityTable == 19 then
        table.insert(abilityTable, 17, self.SpecialBonusAttributes)
        table.insert(abilityTable, 19, self.SpecialBonusAttributes)
        table.insert(abilityTable, 21, self.SpecialBonusAttributes)
        table.insert(abilityTable, 22, self.SpecialBonusAttributes)
        table.insert(abilityTable, 23, self.SpecialBonusAttributes)
        table.insert(abilityTable, 24, self.SpecialBonusAttributes)
    end
    if #abilityTable == 25 then
        table.insert(abilityTable, 26, self.SpecialBonusAttributes)
    end
    for i = 1, 26 do
        if abilityTable[i] == "nil" then
            abilityTable[i] = self.SpecialBonusAttributes
        end
        if not self:Contains(abilities, abilityTable[i]) and abilityTable[i] ~= "talent" then
            print("Bot script "..npcBot:GetUnitName().." contains incorrect ability name: "..abilityTable[i])
            abilityTable[i] = self.IncorrectAbilityName
        end
    end
    if #abilityTable == 30 then
        npcBot.abilityTable = abilityTable
        abilityTable.incorrectAbilityLevelUpNumber = self:Count(abilityTable, function(ability, index)
            return index < npcBot:GetLevel() - npcBot:GetAbilityPoints() + 1 and (ability == nil or not ability:CanAbilityBeUpgraded() or ability:GetName() == self.IncorrectAbilityName)
        end)
        return
    end
    local talents = self:Map(self:GetTalents(npcBot), function(t)
        return t:GetName()
    end)
    local levelUpTalents = self:Filter(abilityTable, function(t)
        return self:IsTalent(t)
    end)
    local g = self:Concat(abilityTable, self:RemoveAll(talents, levelUpTalents))
    g.incorrectAbilityLevelUpNumber = self:Count(g, function(ability, index)
        return index < npcBot:GetLevel() - npcBot:GetAbilityPoints() + 1 and (ability == nil or not ability:CanAbilityBeUpgraded() or ability:GetName() == self.IncorrectAbilityName)
    end)
    npcBot.abilityTable = g
end
M.ExecuteAbilityLevelUp = function(self, npcBot)
    local abilityTable = npcBot.abilityTable
    if abilityTable.justLevelUpAbility then
        if abilityTable.abilityPoints == npcBot:GetAbilityPoints() then
            abilityTable.incorrectAbilityLevelUpNumber = abilityTable.incorrectAbilityLevelUpNumber + 1
        end
        abilityTable.justLevelUpAbility = false
    end
    abilityTable.abilityPoints = npcBot:GetAbilityPoints()
    if npcBot:GetAbilityPoints() < 1 + abilityTable.incorrectAbilityLevelUpNumber or GetGameState() ~= GAME_STATE_PRE_GAME and GetGameState() ~= GAME_STATE_GAME_IN_PROGRESS then
        return
    end
    local abilityName = abilityTable[self:GetAbilityLevelUpIndex(npcBot)]
    if abilityName == self.IncorrectAbilityName or abilityName == self.SpecialBonusAttributes then
        abilityTable.incorrectAbilityLevelUpNumber = abilityTable.incorrectAbilityLevelUpNumber + 1
    end
    npcBot:ActionImmediate_LevelAbility(abilityName)
    abilityTable.justLevelUpAbility = true
end
M.IsVector = function(self, object)
    return type(object) == "userdata" and type(object.x) == "number" and type(object.y) == "number" and type(object.z) == "number"
end
M.ToStringVector = function(self, object)
    return string.format("(%d,%d,%d)", object.x, object.y, object.z)
end
M.GetLine = function(self, a, b)
    if a.x == b.x then
        return {
            a = 1,
            b = 0,
            c = -a.x,
        }
    end
    local k = (a.y - b.y) / (a.x - b.x)
    local bb = a.y - k * a.x
    return {
        a = k,
        b = -1,
        c = bb,
    }
end
M.GetPointToLineDistance = function(self, point, line)
    local up = math.abs(line.a * point.x + line.b * point.y + line.c)
    local down = math.sqrt(line.a * line.a + line.b * line.b)
    return up / down
end
M.GetPointToPointDistance = function(self, a, b)
    return ((a.x - b.x) ^ 2 + (a.y - b.y) ^ 2) ^ 0.5
end
M.GetPointFromLineByDistance = function(self, startPoint, endPoint, distance)
    local distanceTo = self:GetPointToPointDistance(startPoint, endPoint)
    local divide = (endPoint - startPoint) / distanceTo * distance
    return startPoint + divide
end
M.GetCos = function(self, b, c, a)
    return (b ^ 2 + c * 2 - a * 2) / 2 / b / c
end
M.GetLocationToLocationDistance = function(self, a, b)
    return ((a.x - b.x) ^ 2 + (a.y - b.y) ^ 2) ^ 0.5
end
function M:GetDegree(loc1, loc2)
    local y = loc2.y - loc1.y
    local x = loc2.x - loc1.x
    return math.atan2(y, x) * 180 / math.pi
end
function M:MultiplyBetween(down, up)
    local result = 1
    local g = down
    while g <= up do
        result = result * g
        g = g + 1
    end
    return result
end
function M:Combination(down, up)
    return self:MultiplyBetween(down - up + 1, down) / self:MultiplyBetween(1, up)
end
function M:Arrange(down, up)
    return self:MultiplyBetween(down - up + 1, down)
end
function M:FindAoELocation(npcBot, target, ability, hero, maxHealth)
    if hero == nil then
        hero = true
    end
    if maxHealth == nil then
        maxHealth = 10000
    end
    return npcBot:FindAoELocation(true, hero, npcBot:GetLocation(), ability:GetCastRange(), ability:GetAOERadius(), ability:GetCastPoint(), maxHealth)
end
function M:FindAOELocationAtSingleTarget(npcBot, target, radius, castRange, castPoint)
    local targetLoc = target:GetLocation()
    local npcLoc = npcBot:GetLocation()
    local targetMove = target:GetCurrentMovementSpeed() * castPoint
    local ntDis = self:GetLocationToLocationDistance(targetLoc, npcLoc) - target:GetBoundingRadius()
    if ntDis >= targetMove + radius then
        local centre = (function()
            if target:IsFacingLocation(npcLoc, 180) then
                return ntDis - targetMove
            else
                return ntDis + targetMove
            end
        end)()
        return self:GetPointFromLineByDistance(npcLoc, targetLoc, centre)
    end
    return self:GetPointFromLineByDistance(npcLoc, targetLoc, ntDis + targetMove + target:GetBoundingRadius())
end
M.MinValue = function(self, coefficients, min, max)
    max = max or 10000
    min = min or -10000
    local function Differential(coefficients)
        local g = {}
        for index, coefficient in pairs(coefficients) do
            g[index - 1] = coefficient * index
        end
        return g
    end
    local function Y(coefficients, x)
        local g = 0
        for index, coefficient in pairs(coefficients) do
            g = g + coefficient * x ^ index
        end
        return g
    end
    local differential = Differential(coefficients)
    if differential[1] ~= nil and differential[1] ~= 0 then
        local zeroPoint = -differential[0] / differential[1]
        if Y(coefficients, zeroPoint + 0.1) > 0 then
            if zeroPoint > max then
                return Y(coefficients, max)
            elseif zeroPoint < min then
                return Y(coefficients, min)
            else
                return Y(coefficients, zeroPoint)
            end
        else
            if zeroPoint > max then
                return Y(coefficients, min)
            elseif zeroPoint < min then
                return Y(coefficients, max)
            else
                local val1 = Y(coefficients, min)
                local val2 = Y(coefficients, min)
                return math.min(val1, val2)
            end
        end
    else
        return Y(coefficients, min)
    end
end
M.MaxValue = function(self, coefficients, min, max)
    local g = {}
    for index, coefficient in coefficients do
        g[index] = -coefficient
    end
    return self:MinValue(g, -max, -min)
end
M.GetCollapseInfo = function(self, obj1, obj2, timeLimit)
    local x1 = obj1.location.x - obj2.location.x
    local x2 = obj1.velocity.x - obj2.velocity.x
    local coefficient0 = x1 ^ 2
    local coefficient1 = 2 * x1 * x2
    local coefficient3 = x2 ^ 2
    x1 = obj1.location.y - obj2.location.y
    x2 = obj2.velocity.y - obj2.velocity.y
    coefficient0 = coefficient0
end
M.PreventHealAtHealSuppressTarget = function(self, npcBot, oldConsiderFunction, ability)
    return function()
        local desire,target,targetTypeString = oldConsiderFunction()
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
M.PURCHASE_ITEM_OUT_OF_STOCK = 82
M.PURCHASE_ITEM_INVALID_ITEM_NAME = 33
M.PURCHASE_ITEM_DISALLOWED_ITEM = 78
M.PURCHASE_ITEM_INSUFFICIENT_GOLD = 63
M.PURCHASE_ITEM_NOT_AT_SECRET_SHOP = 62
M.PURCHASE_ITEM_NOT_AT_HOME_SHOP = 67
M.PURCHASE_ITEM_SUCCESS = -1
M.IgnoreDamageModifiers = {
    "modifier_abaddon_borrowed_time",
    "modifier_item_aeon_disk_buff",
    "modifier_winter_wyvern_winters_curse",
    "modifier_winter_wyvern_winters_curse_aura",
    "modifier_skeleton_king_reincarnation_scepter_active",
}
M.CannotKillModifiers = {
    "modifier_dazzle_shadow_grave",
    "modifier_troll_warlord_battle_trance",
}
M.CannotBeTargettedModifiers = {
    "modifier_slark_shadow_dance",
    "modifier_item_book_of_shadows",
    "modifier_dark_willow_shadow_realm_buff",
}
M.IgnorePhysicalDamageModifiers = {
    "modifier_winter_wyvern_cold_embrace",
    "modifier_omniknight_guardian_angle",
}
M.IgnoreMagicalDamageModifiers = { "modifier_oracle_fates_edict" }
M.LastForAtLeastSeconds = function(self, predicate, time, infoTable)
    if infoTable.lastTrueTime == nil then
        infoTable.lastTrueTime = DotaTime()
    end
    if predicate() then
        if DotaTime() - infoTable.lastTrueTime >= time then
            return true
        else
            return false
        end
    else
        infoTable.lastTrueTime = nil
        return false
    end
end
M.GoodIllusionHero = {
    "antimage",
    "spectre",
    "terrorblade",
    "naga_siren",
}
M.ModerateIllusionHero = {
    "abaddon",
    "axe",
    "chaos_knight",
    "arc_warden",
    "juggernaut",
    "luna",
    "medusa",
    "morphling",
    "phantom_lancer",
    "sniper",
    "wraith_king",
    "phantom_assassin",
}
M.GetIllusionBattlePower = function(self, npc)
    local name = self:GetHeroShortName(npc:GetUnitName())
    if npc:HasModifier "modifier_arc_warden_tempest_double" or npc:HasModifier "modifier_skeleton_king_reincarnation_active" then
        return 0.8
    end
    if npc:HasModifier "modifier_vengefulspirit_hybrid_special" then
        return 1.05
    end
    local t = 0.1
    if self:Contains(self.GoodIllusionHero, name) then
        t = 0.25
    elseif self:Contains(self.ModerateIllusionHero, name) then
        t = 0.4
    elseif t:IsRanged() then
        t = t + t:GetAttackRange() / 600
    end
    local inventory = self:Map(self:GetInventoryItems(npc), function(t)
        return t:GetName()
    end)
    if self:Contains(inventory, "item_radiance") then
        t = t + 0.07
    end
    if self:Contains(inventory, "item_diffusal_blade") then
        t = t + 0.05
    end
    if self:Contains(inventory, "item_lesser_crit") then
        t = t + 0.04
    end
    if self:Contains(inventory, "item_greater_crit") then
        t = t + 0.08
    end
    if npc:HasModifier "modifier_special_bonus_mana_break" then
        t = t + 0.04
    end
    return t
end
M.GetNetWorth = function(self, npc, isEnemy)
    if isEnemy then
        local itemCost = self:Map(self:GetInventoryItems(npc), function(t)
            return GetItemCost(t:GetName())
        end)
        return self:Aggregate(0, itemCost, function(a, b)
            return a + b
        end)
    else
        return npc:GetNetWorth()
    end
end
function M:GetBattlePower(npc)
    local power = 0
    local name = npc:GetUnitName()
    if string.match(name, "npc_dota_hero") then
        power = npc:GetNetWorth() + npc:GetLevel() * 1000
        if npc:GetLevel() >= 25 then
            power = power + 1000
        end
        if npc:GetLevel() >= 30 then
            power = power + 1000
        end
    elseif string.match(name, "npc_dota_lone_druid_bear") then
        local heroLevel = GetHeroLevel(npc:GetPlayerID())
        power = name[#"npc_dota_lone_druid_bear" + 1] * 2000 - 1000
        power = power + heroLevel * 250
        power = power + npc:GetNetWorth()
    end
    if npc:HasModifier "modifier_item_assault_positive" and not npc:HasModifier "modifier_item_assault_positive_aura" then
        power = power + 1500
    end
    local items = self:GetInventoryItemsNames(npc)
    if npc:HasModifier "modifier_item_pipe_aura" and not self:Contains(items, "item_pipe") then
        power = power + 400
    end
    if npc:HasModifier "modifier_item_vladmir_aura" and not self:Contains(items, "item_vladmir") then
        power = power + 300
    end
    if npc:HasModifier "modifier_item_guardian_greaves_aura" and not self:Contains(items, "item_guardian_greaves") then
        power = power + 1000
    elseif npc:HasModifier "modifier_item_mekansm_aura" and not self:Contains(items, "item_mekansm") then
        power = power + 500
    end
    return power
end
M.GetHeroGroupBattlePower = function(self, npcBot, heroes, isEnemy)
    local function A(tb)
        local battlePowerMap = self:Map(tb, function(t)
            return {
                t:GetUnitName(),
                self:GetBattlePower(t),
            }
        end)
        battlePowerMap = self:SortByMaxFirst(battlePowerMap, function(t)
            return t[2]
        end)
        battlePowerMap = self:Map(battlePowerMap, function(t, index)
            return t[2] * (1.15 - 0.15 * index)
        end)
        local g = NewTable()
        for _, v in ipairs(battlePowerMap) do
            g[v[1]] = v[2]
        end
        return g
    end
    local enemyNetWorthMap = A(self:GetEnemyHeroUnique(npcBot, heroes))
    local netWorth = 0
    local readNames = NewTable()
    for _, enemy in pairs(heroes) do
        local name = enemy:GetUnitName()
        if not self:Contains(readNames, name) then
            table.insert(readNames, name)
            if enemyNetWorthMap[name] then
                netWorth = netWorth + enemyNetWorthMap[name]
            end
        else
            if enemyNetWorthMap[name] then
                netWorth = netWorth + enemyNetWorthMap[name] * self:GetIllusionBattlePower(enemy)
            end
        end
    end
    return netWorth
end
M.Outnumber = function(self, npcBot, friends, enemies)
    return self:GetHeroGroupBattlePower(npcBot, friends, false) >= self:GetHeroGroupBattlePower(npcBot, enemies, true) * 1.8
end
M.CannotBeKilledNormally = function(self, target)
    return target:IsInvulnerable() or self:Any(self.IgnoreDamageModifiers, function(t)
        target:HasModifier(t)
    end) or target:HasModifier "modifier_dazzle_shallow_grave"
end
M.HasScepter = function(self, npc)
    return npc:HasScepter() or npc:HasModifier "modifier_wisp_tether_scepter" or npc:HasModifier "modifier_item_ultimate_scepter" or npc:HasModifier "modifier_item_ultimate_scepter_consumed_alchemist"
end
local locationAOEAbilities = {
    cone = { "lina_dragon_slave" },
    circle = { "lina_light_strike_array" },
    isoscelesTrapezoid = { "kunkka_tidebringer" },
}
function M:RecordAbility(npc, index, target, castType, abilities)
    local abilityRecords = npc.abilityRecords
    if index ~= nil then
        abilityRecords[index] = {}
        if castType == "Location" then
            abilityRecords[index].location = target
        elseif castType == "Target" then
            abilityRecords[index].target = target
        elseif castType == "Tree" then
            abilityRecords[index].targetTree = target
        elseif self:IsVector(target) then
            abilityRecords[index].location = target
        elseif target ~= nil then
            abilityRecords[index].target = target
        end
        abilityRecords.usingAbilityIndex = index
        abilityRecords[index].beginCastTime = DotaTime()
        return
    end
    if not npc:IsUsingAbility() and not npc:IsChanneling() then
        if abilityRecords.usingAbilityIndex ~= nil and not abilities[abilityRecords.usingAbilityIndex]:IsCooldownReady() then
            abilityRecords.lastUsedAbilityIndex = abilityRecords.usingAbilityIndex
            abilityRecords.usingAbilityIndex = nil
            abilityRecords.lastUsedAbilityTime = DotaTime()
        end
    end
end
local frameNumber = 0
local dotaTimer
local function FloatEqual(a, b)
    return math.abs(a - b) < 0.000001
end
function M:GetFrameNumber()
    return frameNumber
end
function M:EveryManyFrames(count, times)
    times = times or 1
    return frameNumber % count < times
end
local defaultReturn = NewTable()
local everySecondsCallRegistry = NewTable()
function M:EveryManySeconds(second, oldFunction)
    local functionName = tostring(oldFunction)
    everySecondsCallRegistry[functionName.."lastCallTime"] = DotaTime() + RandomFloat(0, second)
    return function(...)
        if everySecondsCallRegistry[functionName.."lastCallTime"] <= DotaTime() - second then
            everySecondsCallRegistry[functionName.."lastCallTime"] = DotaTime()
            return oldFunction(...)
        else
            return defaultReturn
        end
    end
end
local singleForTeamRegistry = NewTable()
function M:SingleForTeam(oldFunction)
    local functionName = tostring(oldFunction)..GetTeam()
    return function(...)
        if singleForTeamRegistry[functionName] ~= frameNumber then
            singleForTeamRegistry[functionName] = frameNumber
            return oldFunction(...)
        else
            return defaultReturn
        end
    end
end
local singleForAllBots = NewTable()
function M:SingleForAllBots(oldFunction)
    local functionName = tostring(oldFunction)
    return function(...)
        if singleForAllBots[functionName] ~= frameNumber then
            singleForAllBots[functionName] = frameNumber
            return oldFunction(...)
        else
            return defaultReturn
        end
    end
end
local groupAnnounceTimes1 = 0
function M:AnnounceGroups1(npcBot)
    if groupAnnounceTimes1 == 0 then
        npcBot:ActionImmediate_Chat("Thanks for choosing RMM AI. Join our new discord group at https://discord.gg/Agd632pvhA to put suggestions or devloping issues!", true)
        groupAnnounceTimes1 = 1
    end
end
local groupAnnounceTimes2 = 0
function M:AnnounceGroups2(npcBot)
    if groupAnnounceTimes2 == 0 then
        npcBot:ActionImmediate_Chat("Or join QQ group at 946823144!", true)
        groupAnnounceTimes2 = 1
    end
end
function M:CalledOnThisFrame(functionInvocationResult)
    return functionInvocationResult ~= defaultReturn
end
local slowFunctionRegistries = NewTable()
local coroutineRegistry = NewTable()
local coroutineExempt = NewTable()
function M:TickFromDota()
    local time = DotaTime()
    local function ResumeCoroutine(thread)
        local coroutineResult = { coroutine.resume(thread, time - dotaTimer) }
        if not coroutineResult[1] then
            table.remove(coroutineResult, 1)
            print("error in coroutine "..tostring(coroutineResult))
        end
    end
    if dotaTimer == nil then
        dotaTimer = time
        return
    end
    if not FloatEqual(time, dotaTimer) then
        frameNumber = frameNumber + 1
        self:ForEach(slowFunctionRegistries, function(t)
            t(time - dotaTimer)
        end)
        local threadIndex = 1
        while threadIndex <= #coroutineRegistry do
            local t = coroutineRegistry[threadIndex]
            local exemptIndex
            local exempt
            self:ForEach(coroutineExempt, function(exemptPair, index)
                if exemptPair[1] == t then
                    if exemptPair[2] == frameNumber then
                        exempt = true
                    end
                    exemptIndex = index
                end
            end)
            if exemptIndex then
                table.remove(coroutineExempt, exemptIndex)
            end
            if not exempt then
                if coroutine.status(t) == "suspended" then
                    ResumeCoroutine(t)
                    threadIndex = threadIndex + 1
                elseif coroutine.status(t) == "dead" then
                    table.remove(coroutineRegistry, threadIndex)
                else
                    threadIndex = threadIndex + 1
                end
            end
        end
        dotaTimer = time
    end
end
function M:RegisterSlowFunction(oldFunction, calledWhenHowManyFrames, frameOffset, defaultReturn)
    return function(...)
        if frameNumber % calledWhenHowManyFrames == frameOffset then
            return oldFunction(...)
        else
            return self:UnpackIfTable(defaultReturn)
        end
    end
end
function M:ResumeUntilReturn(func)
    local g = NewTable()
    local thread = coroutine.create(func)
    while true do
        local values = { coroutine.resume(thread) }
        if values[1] then
            table.remove(values, 1)
            table.insert(g, values)
        else
            table.remove(values, 1)
            print("error in coroutine "..tostring(values))
            break

        end
    end
    return g
end
function M:StartCoroutine(func)
    local newCoroutine = coroutine.create(func)
    table.insert(coroutineRegistry, newCoroutine)
    table.insert(coroutineExempt, {
        newCoroutine,
        frameNumber,
    })
    return newCoroutine
end
function M:WaitForSeconds(seconds)
    local function WaitFor(firstFrameTime)
        local t = seconds - firstFrameTime
        while t > 0 do
            t = t - coroutine.yield()
        end
    end
    return self:StartCoroutine(WaitFor)
end
function M:StopCoroutine(thread)
    self:Remove_Modify(coroutineExempt, function(t)
        return t[1] == thread
    end)
    self:Remove_Modify(coroutineRegistry, thread)
end
local function GetDataFromAbility(ability, valueName)
    local a = ability:GetSpecialValueInt(valueName)
    return a == 0 and ability:GetSpecialValueFloat(valueName) or a
end
local function Append__Index(tb, __index)
    local m = getmetatable(tb)
    if m == nil then
        m = {}
        setmetatable(tb, m)
    end
    local oldIndex = m.__index
    if oldIndex == nil then
        m.__index = __index
    elseif type(oldIndex) == "function" then
        m.__index = function(ability, i)
            local oldResult = { oldIndex(ability, i) }
            if oldResult[1] == nil then
                return __index(ability, i)
            else
                return M.Unpack(oldResult)
            end
        end
    elseif type(oldIndex) == "table" then
        if oldIndex == m then
            m.__index = function(g, h)
                local newResult = { __index(g, h) }
                if newResult[1] == nil then
                    return oldIndex[h]
                else
                    return M.Unpack(newResult)
                end
            end
        else
            Append__Index(oldIndex, __index)
        end
    end
end
Append__Index(CDOTABaseAbility_BotScript, GetDataFromAbility)
function M:pcall(func, ...)
    local result = { func(...) }
    if result[1] then
        table.remove(result, 1)
        return self:Unpack(result)
    else
        self:DebugPause()
    end
end
function M:DebugPause()
    if self.debug then
        DebugPause()
    end
end
return M
