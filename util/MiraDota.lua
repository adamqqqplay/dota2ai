---------------------------------------------
-- Generated from Mirana Compiler version 1.6.2
-- Do not modify
-- https://github.com/AaronSong321/Mirana
---------------------------------------------
local fun1 = require(GetScriptDirectory().."/util/AbilityAbstraction")
local M = {}
local Linq = {}
local Debug = {}
local DotaExt = {}
local AbilInfo = {}
local ItemUseDefaultImpl = {}
local Push = {}
local Abil = {}
local Math = {}
local Hero = {}
local UnitFun = {}
local Building = {}
local magicTable = {}
function Linq.Give(t)
    setmetatable(t, magicTable)
end
magicTable.__index = magicTable
function Linq.NewTable(...)
    local a = { ... }
    Linq.Give(a, magicTable)
    return a
end
function Linq.Aggregate(tb, seed, aggregate)
    for k, v in ipairs(tb) do
        seed = aggregate(seed, v, k)
    end
    return seed
end
function Linq.All(tb, filter)
    for k, v in ipairs(tb) do
        if not filter(v, k) then
            return false
        end
    end
    return true
end
function Linq.Any(tb, filter)
    for k, v in ipairs(tb) do
        if filter == nil or filter(v, k) then
            return true
        end
    end
    return false
end
function Linq.Append(tb, item)
    local g = Linq.ShallowCopy(tb)
    table.insert(g, item)
    return g
end
function Linq.Average(tb)
    local i = 0
    local sum = 0
    for _, v in ipairs(tb) do
        i = i + 1
        sum = sum + v
    end
    return sum / i
end
function Linq.Concat(a, b)
    local g = Linq.NewTable()
    for _, v in ipairs(a) do
        table.insert(g, v)
    end
    for _, v in ipairs(b) do
        table.insert(g, v)
    end
    return g
end
function Linq.Contains(tb, value, equals)
    equals = equals or function(opv_1, opv_2) return opv_1 == opv_2 end
    for _, v in ipairs(tb) do
        if equals(v, value) then
            return true
        end
    end
    return false
end
function Linq.ContainsKey(tb, key, equals)
    equals = equals or function(opv_1, opv_2) return opv_1 == opv_2 end
    for k, _ in pairs(tb) do
        if equals(key, k) then
            return true
        end
    end
    return false
end
function Linq.Count(tb, filter)
    local g = 0
    for k, v in ipairs(tb) do
        if filter == nil or filter(v, k) then
            g = g + 1
        end
    end
    return g
end
function Linq.DeepCopy(tb)
    local copiedTables = Linq.NewTable()
    local g = Linq.NewTable()
    table.insert(copiedTables, tb)
    for k, v in pairs(tb) do
        if type(v) ~= "table" then
            g[k] = v
        else
            if Linq.Contains(copiedTables, v) then
                return {}
            end
            g[k] = Linq.DeepCopy(v)
        end
    end
    return g
end
function Linq.Distinct(tb, equals)
    equals = equals or function(opv_1, opv_2) return opv_1 == opv_2 end
    local g = Linq.NewTable()
    for _, v in pairs(tb) do
        if not Linq.Contains(g, v, equals) then
            table.insert(g, v)
        end
    end
    return g
end
function Linq.Except(tb, tb2, equals)
    local g = Linq.NewTable()
    for _, v in ipairs(tb) do
        if not Linq.Contains(tb2, v, equals) then
            table.insert(g, v)
        end
    end
    return g
end
function Linq.Filter(tb, filter)
    local g = Linq.NewTable()
    for k, v in ipairs(tb) do
        if filter(v, k) then
            table.insert(g, v)
        end
    end
    return g
end
function Linq.Filter2(tb1, tb2, filter, map)
    map = map or function(a, b, c)
        return {
            a,
            b,
        }
    end
    local g = Linq.NewTable()
    for i = 1, #tb1 do
        if filter(tb1[i], tb2[i], i) then
            table.insert(map(tb1[i], tb2[i], i))
        end
    end
    return g
end
function Linq.FilterNot(tb, filter)
    local g = Linq.NewTable()
    for k, v in ipairs(tb) do
        if not filter(v, k) then
            table.insert(g, v)
        end
    end
    return g
end
function Linq.First(tb, filter)
    filter = filter or function()
        return true
    end
    for k, v in ipairs(tb) do
        if filter == nil or filter(v, k) then
            return v
        end
    end
end
function Linq.ForEach2(tb1, tb2, func)
    for i = 1, #tb1 do
        func(tb1[i], tb2[i])
    end
end
function Linq.ForEach(tb, action)
    for k, v in ipairs(tb) do
        action(v, k)
    end
end
function Linq.ForEachDic(tb, action)
    for k, v in pairs(tb) do
        action(v, k)
    end
end
function Linq.GroupBy(collection, keySelector, elementSelector, resultSelector, comparer)
    comparer = comparer or function(opv_1, opv_2) return opv_1 == opv_2 end
    resultSelector = resultSelector or function(key, value)
        return value
    end
    elementSelector = elementSelector or Linq.Identity
    local keys = Linq.NewTable()
    local values = Linq.NewTable()
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
            local v = Linq.NewTable()
            table.insert(v, elementSelector(k))
            table.insert(values, v)
        end
    end
    return Linq.Map2(keys, values, resultSelector)
end
function Linq.GroupJoin(outer, inner, outerKeySelector, innerKeySelector, resultSelector, comparer)
    comparer = comparer or function(opv_1, opv_2) return opv_1 == opv_2 end
    resultSelector = resultSelector or function(key, values)
        return {
            key,
            values,
        }
    end
    innerKeySelector = innerKeySelector or Linq.Identity
    outerKeySelector = outerKeySelector or Linq.Identity
    local t = NewTable()
    for k, v in ipairs(outer) do
        local key = outerKeySelector(v, k)
        local m = Linq.Filter(inner, function(v, k)
            return comparer(innerKeySelector(v, k), key)
        end)
        table.insert(t, resultSelector {
            key,
            m,
        })
    end
    return t
end
Linq.Identity = function(t)
    return t
end
function Linq.InsertAfter_Modify(tb, item, after)
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
function Linq.Intersect(tb, tb2, equals)
    local g = Linq.NewTable()
    for _, v in tb do
        if Linq.Contains(tb2, v, equals) then
            table.insert(g, v)
        end
    end
    return g
end
function Linq.Join(outer, inner, outerKeySelector, innerKeySelector, resultSelector, comparer)
    comparer = comparer or function(opv_1, opv_2) return opv_1 == opv_2 end
    resultSelector = resultSelector or function(o, i)
        return {
            o,
            i,
        }
    end
    innerKeySelector = innerKeySelector or Linq.Identity
    outerKeySelector = outerKeySelector or Linq.Identity
    local g = NewTable()
    for k, v in ipairs(outer) do
        local key = outerKeySelector(v, k)
        Linq.Filter(inner, function(v, k)
            return comparer(innerKeySelector(v, k), key)
        end):Map(function(v2)
            return resultSelector(v, v2)
        end):ForEach(function(t)
            return table.insert(g, t)
        end)
    end
    return g
end
function Linq.Keys(tb)
    local g = Linq.NewTable()
    for k, _ in pairs(tb) do
        table.insert(g, k)
    end
    return g
end
function Linq.Last(tb, filter)
    return Linq.First(Linq.Reverse(tb), filter)
end
function Linq.Map(tb, transform)
    local g = Linq.NewTable()
    for k, v in ipairs(tb) do
        g[k] = transform(v)
    end
    return g
end
function Linq.MapDic(tb, transform)
    local g = Linq.NewTable()
    for k, v in pairs(tb) do
        g[k] = transform(k, v)
    end
    return g
end
function Linq.Max(tb, map)
    if #tb == 0 then
        return nil
    end
    map = map or Linq.Identity
    local maxv, maxm = tb[1], map(tb[1])
    for i = 2, #tb do
        local m = map(tb[i])
        if m > maxm then
            maxm = m
            maxv = tb[i]
        end
    end
    return maxm
end
function Linq.MaxKey(tb, map)
    if #tb == 0 then
        return nil
    end
    map = map or Linq.Identity
    local maxv, maxm = tb[1], map(tb[1])
    for i = 2, #tb do
        local m = map(tb[i])
        if m > maxm then
            maxm = m
            maxv = tb[i]
        end
    end
    return maxv
end
function Linq.Min(tb, map)
    if #tb == 0 then
        return nil
    end
    map = map or Linq.Identity
    local maxv, maxm = tb[1], map(tb[1])
    for i = 2, #tb do
        local m = map(tb[i])
        if m < maxm then
            maxm = m
            maxv = tb[i]
        end
    end
    return maxm
end
function Linq.MinKey(tb, map)
    if #tb == 0 then
        return nil
    end
    map = map or Linq.Identity
    local maxv, maxm = tb[1], map(tb[1])
    for i = 2, #tb do
        local m = map(tb[i])
        if m < maxm then
            maxm = m
            maxv = tb[i]
        end
    end
    return maxv
end
function Linq.NonEmpty(tb)
    return Linq.Filter(tb, function(t)
        return t ~= nil and #t ~= 0
    end)
end
function Linq.IndexOf(tb, filter)
    local g = Linq.NewTable()
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
function Linq.Map2(tb1, tb2, map)
    local g = Linq.NewTable()
    for i = 1, #tb1 do
        table.insert(g, map(tb1[i], tb2[i], i))
    end
    return g
end
function Linq.MergeSort(tb, sort)
    sort = sort or function(opv_1, opv_2) return opv_1 - opv_2 end
    local function Merge(a, b)
        local g = Linq.NewTable()
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
        local left = SortRec(Linq.Take(tab, tableLength / 2))
        local right = SortRec(Linq.Skip(tab, tableLength / 2))
        local merge = Merge(left, right)
        return merge
    end
    return SortRec(tb)
end
function Linq.OrderBy(tb, map)
    map = map or Linq.Identity
    return Linq.Sort(tb, function(a, b)
        return map(a) - map(b)
    end)
end
function Linq.OrderByDescending(tb, map)
    map = map or Linq.Identity
    return Linq.Sort(tb, function(a, b)
        return map(b) - map(a)
    end)
end
function Linq.Partition(tb, filter)
    local a = Linq.NewTable()
    local b = Linq.NewTable()
    for k, v in pairs(tb) do
        if filter(v, k) then
            table.insert(a, v)
        else
            table.insert(b, v)
        end
    end
    return a, b
end
function Linq.Prepend(a, b)
    return Linq.Concat(b, a)
end
function Linq.Range(min, max, step)
    step = step or 1
    local g = Linq.NewTable()
    for i = min, max, step do
        table.insert(g, i)
    end
    return g
end
function Linq.Remove(a, b)
    local g = Linq.ShallowCopy(a)
    for k, v in pairs(a) do
        if v == b then
            g[k] = nil
        end
    end
    return g
end
function Linq.RemoveAll(a, b)
    local g = Linq.NewTable()
    for _, v in pairs(a) do
        if not Linq.Contains(b, v) then
            table.insert(g, v)
        end
    end
    return g
end
function Linq.Remove_Modify(tb, item)
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
function Linq.Repeat(element, count)
    local g = Linq.NewTable()
    for i = 1, count do
        table.insert(g, element)
    end
    return g
end
function Linq.Replace(tb, filter, map)
    local g = Linq.NewTable()
    for k, v in ipairs(tb) do
        if filter(v, k) then
            table.insert(g, map(v, k))
        else
            table.insert(g, v)
        end
    end
    return g
end
function Linq.Reverse(tb)
    local g = Linq.NewTable()
    for i = #tb, 1, -1 do
        table.insert(g, tb[i])
    end
    return g
end
function Linq.ShallowCopy(tb)
    local g = Linq.NewTable()
    for k, v in pairs(tb) do
        g[k] = v
    end
    return g
end
function Linq.SlowSort(tb, sort)
    local g = Linq.ShallowCopy(tb)
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
Linq.Sort = Linq.SlowSort
function Linq.SelectMany(tb, map, filter)
    local g = Linq.NewTable()
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
function Linq.Skip(tb, number)
    local g = Linq.NewTable()
    local i = 0
    for _, v in ipairs(tb) do
        i = i + 1
        if i > number then
            table.insert(g, v)
        end
    end
    return g
end
function Linq.SkipLast(tb, number)
    return Linq.Skip(Linq.Reverse(tb), number)
end
function Linq.SkipWhile(tb, filter)
    local g = Linq.NewTable()
    local failure
    for k, v in ipairs(tb) do
        if failure then
            table.insert(tb, v)
        else
            if not filter(v, k) then
                table.insert(tb, v)
                failure = true
            end
        end
    end
    return g
end
function Linq.Take(tb, number)
    local g = Linq.NewTable()
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
function Linq.TakeWhile(tb, filter)
    local g = Linq.NewTable()
    for k, v in ipairs(tb) do
        if filter(v, k) then
            table.insert(g, v)
        else
            break
        end
    end
    return g
end
function Linq.Zip2(tb1, tb2, map)
    map = map or function(a, b)
        return {
            a,
            b,
        }
    end
    local g = Linq.NewTable()
    for i = 1, #tb1 do
        table.insert(g, map(tb1[i], tb2[i]))
    end
    return g
end
local function AddLinqfunctionsToMetatable(mt)
    for functionName, func in pairs(table) do
        mt[functionName] = func
    end
    for k, v in pairs(Linq) do
        mt[k] = v
    end
end
AddLinqfunctionsToMetatable(magicTable)
function Debug.DebugTable(tb)
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
function Debug.DebugLongTable(tb)
    if type(tb) ~= "table" then
        print(tostring(tb))
        return
    end
    for k, v in pairs(tb) do
        if type(v) == "table" then
            print(tostring(k).." = ")
            Debug.DebugTable(v)
        else
            print(tostring(k).." = "..tostring(v))
        end
    end
end
local AttributeTypeEnum = {
    ATTRIBUTE_INVALID = ATTRIBUTE_INVALID,
    ATTRIBUTE_STRENGTH = ATTRIBUTE_STRENGTH,
    ATTRIBUTE_AGILITY = ATTRIBUTE_AGILITY,
    ATTRIBUTE_INTELLECT = ATTRIBUTE_INTELLECT,
}
function DotaExt.AttributeTypeToString(i)
    for k, v in pairs(AttributeTypeEnum) do
        if v == i then
            return k
        end
    end
    return "unknown attribute type"
end
function DotaExt.GetNearbyHeroes(bot, range, getEnemy, botMode)
    botMode = botMode or BOT_MODE_NONE
    getEnemy = getEnemy or true
    local range1 = (function()
        if range > 1600 then
            return 1600
        else
            return range
        end
    end)()
    local units = bot:GetNearbyHeroes(range1, getEnemy, botMode)
    Linq.Give(units)
    return units
end
function DotaExt.GetNearbyLaneCreeps(bot, range, getEnemy)
    getEnemy = getEnemy or true
    local range1 = (function()
        if range > 1600 then
            return 1600
        else
            return range
        end
    end)()
    local units = bot:GetNearbyLaneCreeps(range1, getEnemy)
    Linq.Give(units)
    return units
end
function DotaExt.GetNearbyNeutralCreeps(bot, range)
    local range1 = (function()
        if range > 1600 then
            return 1600
        else
            return range
        end
    end)()
    local units = bot:GetNearbyNeutralCreeps(range1)
    Linq.Give(units)
    return units
end
local botModeEnum = {
    BOT_MODE_NONE = BOT_MODE_NONE,
    BOT_MODE_LANING = BOT_MODE_LANING,
    BOT_MODE_ATTACK = BOT_MODE_ATTACK,
    BOT_MODE_ROAM = BOT_MODE_ROAM,
    BOT_MODE_RETREAT = BOT_MODE_RETREAT,
    BOT_MODE_SECRET_SHOP = BOT_MODE_SECRET_SHOP,
    BOT_MODE_SIDE_SHOP = BOT_MODE_SIDE_SHOP,
    BOT_MODE_PUSH_TOWER_TOP = BOT_MODE_PUSH_TOWER_TOP,
    BOT_MODE_PUSH_TOWER_MID = BOT_MODE_PUSH_TOWER_MID,
    BOT_MODE_PUSH_TOWER_BOT = BOT_MODE_PUSH_TOWER_BOT,
    BOT_MODE_DEFEND_TOWER_TOP = BOT_MODE_DEFEND_TOWER_TOP,
    BOT_MODE_DEFEND_TOWER_MID = BOT_MODE_DEFEND_TOWER_MID,
    BOT_MODE_DEFEND_TOWER_BOT = BOT_MODE_DEFEND_TOWER_BOT,
    BOT_MODE_ASSEMBLE = BOT_MODE_ASSEMBLE,
    BOT_MODE_TEAM_ROAM = BOT_MODE_TEAM_ROAM,
    BOT_MODE_FARM = BOT_MODE_FARM,
    BOT_MODE_DEFEND_ALLY = BOT_MODE_DEFEND_ALLY,
    BOT_MODE_EVASIVE_MANEUVERS = BOT_MODE_EVASIVE_MANEUVERS,
    BOT_MODE_ROSHAN = BOT_MODE_ROSHAN,
    BOT_MODE_ITEM = BOT_MODE_ITEM,
    BOT_MODE_WARD = BOT_MODE_WARD,
}
function DotaExt.BotModeToString(mode)
    for k, v in pairs(botModeEnum) do
        if mode == v then
            return k
        end
    end
    return "unknown bot mode "..mode
end
DotaExt.towerNames = Linq.NewTable(TOWER_TOP_1, TOWER_TOP_2, TOWER_TOP_3, TOWER_MID_1, TOWER_MID_2, TOWER_MID_3, TOWER_BOT_1, TOWER_BOT_2, TOWER_BOT_3, TOWER_BASE_1, TOWER_BASE_2)
DotaExt.barracksNames = Linq.NewTable(BARRACKS_TOP_MELEE, BARRACKS_TOP_RANGED, BARRACKS_MID_MELEE, BARRACKS_MID_RANGED, BARRACKS_BOT_MELEE, BARRACKS_BOT_RANGED)
DotaExt.shrineNames = Linq.NewTable(SHRINE_BASE_1, SHRINE_BASE_2, SHRINE_BASE_3, SHRINE_BASE_4, SHRINE_BASE_5)
function DotaExt.IsValidUnit(v)
    return v and not v:IsNull() and v:IsAlive()
end
function DotaExt.GetAllBuildings(team)
    return DotaExt.towerNames:Map(function(t)
        return GetTower(team, t)
    end):Concat(DotaExt.barracksNames:Map(function(t)
        return GetBarracks(team, t)
    end)):Concat(DotaExt.shrineNames:Map(function(t)
        return GetShrine(team, t)
    end)):Concat { GetAncient(team) }:Filter(function(t)
        return DotaExt.IsValidUnit(t) and not t:IsInvulnerable()
    end)
end
function DotaExt.GetPureHeroes(npcBot, range, getEnemy)
    range = range or 1600
    if getEnemy == nil then
        getEnemy = true
    end
    return Linq.Filter(DotaExt.GetNearbyHeroes(npcBot, range, getEnemy), function(t)
        return Hero.MayNotBeIllusion(npcBot, t) and not UnitFun.IsHeroLevelUnit(t)
    end)
end
function DotaExt.EmptyFun() end
function DotaExt.EmptyDesireFun()
    return BOT_ACTION_DESIRE_NONE
end
function DotaExt.GetNearbyCreeps(npc, range, getEnemy)
    local r = npc:GetNearbyCreeps(range, getEnemy)
    Linq.Give(r)
    return r
end
function DotaExt.GetNearbyNeutralCreeps(npc, range)
    local r = npc:GetNearbyNeutralCreeps(range)
    Linq.Give(r)
    return r
end
AbilInfo.invisibleModifiers = Linq.NewTable("modifier_bounty_hunter_wind_walk", "modifier_clinkz_wind_walk", "modifier_dark_willow_shadow_realm_buff", "modifier_item_glimmer_cape_glimmer", "modifier_invoker_ghost_walk_self", "modifier_nyx_assassin_vendetta", "modifier_item_phase_boots_active", "modifier_item_shadow_amulet_fade", "modifier_item_invisibility_edge_windwalk", "modifier_shadow_fiend_requiem_thinker", "modifier_item_silver_edge_windwalk", "modifier_windrunner_wind_walk", "modifier_storm_wind_walk", "modifier_templar_assassin_meld", "modifier_visage_silent_as_the_grave", "modifier_weaver_shukuchi", "modified_invisible", "modifier_rune_invis", "modifier_nyx_assassin_burrow", "modifier_oracle_false_promise_invis")
AbilInfo.truesightModifiers = Linq.NewTable("modifier_item_dustofappearance", "modifier_bounty_hunter_track", "modifier_slardar_amplify_damage", "modifier_truesight")
function AbilInfo.HasAnyModifier(bot, modifiers)
    return modifiers:Any(function(t)
        return bot:HasModifier(t)
    end)
end
local frameNumber = 0
local dotaTimer
local deltaTime = 0
local function FloatEqual(a, b)
    return math.abs(a - b) < 0.000001
end
local GameLoop = {}
function GameLoop.GetFrameNumber()
    return frameNumber
end
function GameLoop.GetDeltaTime()
    return deltaTime
end
function GameLoop.EveryManyFrames(count, times)
    times = times or 1
    return frameNumber % count < times
end
local defaultReturn = Linq.NewTable()
local everySecondsCallRegistry = Linq.NewTable()
function GameLoop.EveryManySeconds(second, registerName, oldFunction, ...)
    if everySecondsCallRegistry[registerName] == nil then
        local callTable = {}
        callTable.lastCallTime = DotaTime() + RandomFloat(0, second) - second
        callTable.interval = second
        everySecondsCallRegistry[registerName] = callTable
    end
    local callTable = everySecondsCallRegistry[registerName]
    if callTable.lastCallTime <= DotaTime() - callTable.interval then
        callTable.lastCallTime = DotaTime()
        return oldFunction(...)
    else
        return defaultReturn
    end
end
local singleForTeamRegistry = Linq.NewTable()
function GameLoop.SingleForTeam(oldFunction)
    local functionName = tostring(oldFunction)
    return function(...)
        if singleForTeamRegistry[functionName] ~= frameNumber then
            singleForTeamRegistry[functionName] = frameNumber
            return oldFunction(...)
        else
            return defaultReturn
        end
    end
end
function GameLoop.CalledOnThisFrame(functionInvocationResult)
    return functionInvocationResult ~= defaultReturn
end
function GameLoop.AiTicking()
    return DotaTime() >= -75
end
local coroutineRegistry = Linq.NewTable()
local coroutineExempt = Linq.NewTable()
function GameLoop.TickFromDota()
    if not GameLoop.AiTicking() then
        return
    end
    local time = DotaTime()
    local function ResumeCoroutine(thread)
        local coroutineResult = { coroutine.resume(thread, deltaTime) }
        if not coroutineResult[1] then
            print("error in coroutine:")
            table.remove(coroutineResult, 1)
            Debug.DebugLongTable(coroutineResult)
        end
    end
    if dotaTimer == nil then
        dotaTimer = time
        return
    end
    deltaTime = time - dotaTimer
    if not FloatEqual(time, dotaTimer) then
        frameNumber = frameNumber + 1
        local threadIndex = 1
        while threadIndex <= #coroutineRegistry do
            local t = coroutineRegistry[threadIndex]
            local exemptIndex
            local exempt
            coroutineExempt:ForEach(function(exemptPair, index)
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
function GameLoop.ResumeUntilReturn(func)
    local g = NewTable()
    local thread = coroutine.create(func)
    while true do
        local values = { coroutine.resume(thread) }
        if values[1] then
            table.remove(values, 1)
            table.insert(g, values)
        else
            print("error in coroutine:")
            table.remove(values, 1)
            Debug.DebugLongTable(values)
            break
        end
    end
    return g
end
function GameLoop.StartCoroutine(func)
    local newCoroutine = coroutine.create(func)
    table.insert(coroutineRegistry, newCoroutine)
    table.insert(coroutineExempt, {
        newCoroutine,
        frameNumber,
    })
    return newCoroutine
end
function GameLoop.WaitForSeconds(seconds)
    local t = seconds
    while t > 0 do
        t = t - coroutine.yield()
    end
end
function GameLoop.StopCoroutine(thread)
    GameLoop.Remove_Modify(coroutineExempt, function(t)
        return t[1] == thread
    end)
    GameLoop.Remove_Modify(coroutineRegistry, thread)
end
function Abil.UseAbilityOnEntity(bot, abil, entity, motive, queueType)
    if Abil.print then
        local printContent = bot:GetUnitName().." use "..abil:GetName().." on entity "..entity:GetUnitName()
        if motive then
            printContent = printContent..", motive = "..tostring(motive)
        end
        print(motive)
    end
    if queueType == "queue" then
        bot:ActionQueue_UseAbilityOnEntity(abil, entity)
    elseif queueType == "push" then
        bot:ActionPush_UseAbilityOnEntity(abil, entity)
    else
        bot:Action_UseAbilityOnEntity(abil, entity)
    end
end
function Abil.UseAbility(bot, abil, motive, queueType)
    if Abil.print then
        local printContent = bot:GetUnitName().." use "..abil:GetName()
        if motive then
            printContent = printContent..", motive = "..tostring(motive)
        end
        print(motive)
    end
    if queueType == "queue" then
        bot:ActionQueue_UseAbility(abil)
    elseif queueType == "push" then
        bot:ActionPush_UseAbility(abil)
    else
        bot:Action_UseAbility(abil)
    end
end
function Abil.UseAbilityOnLocation(bot, abil, location, motive, queueType)
    if Abil.print then
        local printContent = bot:GetUnitName().." use "..abil:GetName().." on location "..fun1:ToStringVector(location)
        if motive then
            printContent = printContent..", motive = "..tostring(motive)
        end
        print(motive)
    end
    if queueType == "queue" then
        bot:ActionQueue_UseAbilityOnLocation(abil, location)
    elseif queueType == "push" then
        bot:ActionPush_UseAbilityOnLocation(abil, location)
    else
        bot:Action_UseAbilityOnLocation(abil, location)
    end
end
function Abil.UseAbilityOnTree(bot, abil, tree, motive, queueType)
    if Abil.print then
        local printContent = bot:GetUnitName().." use "..abil:GetName().." on tree "..tree
        if motive then
            printContent = printContent..", motive = "..tostring(motive)
        end
        print(motive)
    end
    if queueType == "queue" then
        bot:ActionQueue_UseAbilityOnTree(abil, tree)
    elseif queueType == "push" then
        bot:ActionPush_UseAbilityOnTree(abil, tree)
    else
        bot:Action_UseAbilityOnTree(abil, tree)
    end
end
function UnitFun.IsFarmingOrPushing(npcBot)
    local mode = npcBot:GetActiveMode()
    return mode == BOT_MODE_FARM or mode == BOT_MODE_PUSH_TOWER_BOT or mode == BOT_MODE_PUSH_TOWER_MID or mode == BOT_MODE_PUSH_TOWER_TOP or mode == BOT_MODE_DEFEND_TOWER_BOT or mode == BOT_MODE_DEFEND_TOWER_MID or mode == BOT_MODE_DEFEND_TOWER_TOP
end
function UnitFun.IsLaning(npcBot)
    local mode = npcBot:GetActiveMode()
    return mode == BOT_MODE_LANING
end
function UnitFun.IsAttackingEnemies(npcBot)
    local mode = npcBot:GetActiveMode()
    return mode == BOT_MODE_ROAM or mode == BOT_MODE_TEAM_ROAM or mode == BOT_MODE_ATTACK or mode == BOT_MODE_DEFEND_ALLY
end
function UnitFun.IsRetreating(npcBot)
    return npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_MODERATE
end
function UnitFun.NotRetreating(npcBot)
    return not UnitFun.IsRetreating(npcBot)
end
local heroNamePrefixLen = #"npc_dota_hero_"
function UnitFun.GetHeroShortName(name)
    return string.sub(name, heroNamePrefixLen + 1)
end
function UnitFun.IsTempestDouble(npc)
    return npc:HasModifier "modifier_arc_warden_tempest_double"
end
function UnitFun.IsLoneDruidBear(npc)
    return string.match(npc:GetUnitName(), "npc_dota_lone_druid_bear")
end
function UnitFun.IsVisageFamiliar(npc)
    return string.match(npc:GetUnitName(), "npc_dota_visage_familiar")
end
function UnitFun.IsBrewmasterPrimalSplit(npc)
    local unitName = npc:GetUnitName()
    return string.match(unitName, "npc_dota_brewmaster_")
end
function UnitFun.IsHeroLevelUnit(npc)
    if UnitFun.IsBrewmasterPrimalSplit(npc) then
        return true
    end
    local name = npc:GetUnitName()
    if name == "npc_dota_phoenix_sun" then
        return true
    end
    if string.match(npc:GetUnitName(), "npc_dota_lone_druid_bear") then
        return true
    end
    return false
end
local canUseItemIllusionModifiers = Linq.NewTable("modifier_arc_warden_tempest_double", "modifier_skeleton_king_reincarnation_active", "modifier_vengefulspirit_hybrid_special")
function UnitFun.CanBuyItem(npc)
    if UnitFun.IsHeroLevelUnit(npc) or UnitFun.IsTempestDouble(npc) then
        return false
    end
    if npc:IsIllusion() then
        return false
    end
    return true
end
function UnitFun.CanUseItem(npc)
    if UnitFun.IsBrewmasterPrimalSplit(npc) then
        return false
    end
    if string.match(npc:GetUnitName(), "npc_dota_lone_druid_bear") then
        return true
    end
    if name == "npc_dota_phoenix_sun" then
        return false
    end
    if npc:IsIllusion() and not AbilInfo.HasAnyModifier(npc, canUseItemIllusionModifiers) then
        return false
    end
    return true
end
function UnitFun.IsGoodTarget(npc, target)
    return target:IsHero() and Hero.MayNotBeIllusion(npc, target) and not UnitFun.IsHeroLevelUnit(target)
end
function UnitFun.GetHeroTarget(npc)
    do
        local t = npc:GetTarget()
        if t and UnitFun.IsGoodTarget(npc, t) then
            return t
        end
    end
end
function UnitFun.IsHero(npc)
    return npc:IsHero() and not UnitFun.IsCreepHero(npc)
end
function UnitFun.IsCreepHero(npc)
    return UnitFun.IsLoneDruidBear(npc) or UnitFun.IsVisageFamiliar(npc)
end
function UnitFun.IsNotCreepHero(npc)
    return not UnitFun.IsCreepHero(npc)
end
function Building.CanBeAttacked(buillding, npc)
    if not building:IsAlive() or building:HasModifier "modifier_foutain_glyph" then
        return false
    end
    npc = npc or GetBot()
    if buidling:HasModifier "modifier_backdoor_protection_active" then
        do
            local target = building:GetAttackTarget()
            if target then
                if not target:IsHero() or target:IsIllusion() then
                    return true
                end
            end
        end
        return DotaExt.GetNearbyHeroes(npc, 1500, false):Filter(Hero.MayNotBeIllusion):Count(function(it)
            return it:GetAttackTarget() == building
        end) * 80 >= building:GetHealth()
    end
    return true
end
local ItemFun = {}
function ItemFun.GetAvailableItem(npc, itemName, isNeutral)
    if npc:IsMuted() then
        return nil
    end
    if (itemName) == "item_tpscroll" then
        local item = npc:GetItemInSlot(15)
        if item and item:IsFullyCastable() then
            return item
        end
    end
    if isNeutral then
        local item = npc:GetItemInSlot(16)
        if item and item:IsFullyCastable() then
            return item
        end
    end
    for _, i in ipairs(Linq.Range(0, 5):Concat { 16 }) do
        local item = npc:GetItemInSlot(i)
        if item and item:GetName() == itemName and item:IsFullyCastable() then
            return item
        end
    end
end
function ItemFun.GetAvailableTp(npc)
    do
        local teleportation = npc:GetAbilityByName("furion_teleportation")
        if teleportation then
            if not npc:IsSilenced() and teleportation:IsFullyCastable() and teleportation:GetLevel() >= 2 then
                return teleportation
            end
        end
    end
    do
        local keenConveyance = npc:GetAbilityByName("tinker_keen_conveyance")
        if keenConveyance then
            if keenConveyance:IsTrained() then
                return keenConveyance
            end
        end
    end
    return ItemFun.GetAvailableItem(npc, "item_tpscroll")
end
function ItemFun.CanUseAvailableTp(npc, tp)
    local rearm = npc:GetAbilityByName "tinker_rearm"
    if tp:GetName() == "tinker_keen_conveyance" then
        if tp:IsFullyCastable() then
            return true
        end
        if not tp:IsCooldownReady() and not npc:HasModifier "modifier_rejuvenation_aura_buff" and rearm and rearm:IsTrained() then
            return true
        end
    end
    if tp:GetName() == "furion_teleportation" then
        return not npc:IsSilenced() and tp:IsFullyCastable()
    end
    return not npc:IsMuted() and tp:IsFullyCastable()
end
function ItemFun.UseAvailableTp(npc, tp, location)
    if tp:GetName() == "tinker_keen_conveyance" then
        if tp:IsFullyCastable() then
            ItemFun.UseAbilityOnLocation(npc, tp, location)
        end
        local rearm = npc:GetAbilityByName "tinker_rearm"
        if not tp:IsCooldownReady() and not npc:HasModifier "modifier_rejuvenation_aura_buff" and rearm and rearm:IsTrained() then
            while npc:IsSilenced() or not rearm:IsFullyCastable() do
                coroutine.yield()
            end
            Abil.UseAbility(npc, rearm)
            coroutine.yield()
            while npc:IsChanneling() do
                coroutine.yield()
            end
            Abil.UseAbilityOnLocation(npc, tp, location)
            return true
        end
        return false
    end
    if tp:GetName() == "furion_teleportation" then
        Abil.UseAbilityOnLocation(npc, tp, location)
        return true
    end
    ItemFun.UseItemOnLocation(npc, tp, location)
end
function ItemFun.GetAvailableBlink(npc)
    local blinks = {
        "item_blink",
        "item_overwhelming_blink",
        "item_swift_blink",
        "item_arcane_blink",
    }
    return Linq.Aggregate(blinks, nil, function(a, blinkName)
        return a or ItemFun.GetAvailableItem(npc, blinkName)
    end)
end
function ItemFun.GetAvailableTravelBoots(npc)
    local travelBoots = {
        "item_travel_boots",
        "item_travel_boots_2",
    }
    return Linq.Aggregate(travelBoots, nil, function(seed, t)
        return seed or ItemFun.GetAvailableItem(npc, t)
    end)
end
function ItemFun.GetEmptyInventorySlots(npc)
    local g = 0
    for i = 0, 5 do
        if npc:GetItemInSlot(i) == nil then
            g = g + 1
        end
    end
    return g
end
function ItemFun.GetEmptyItemSlots(npc)
    local g = 0
    for i = 0, 8 do
        if npc:GetItemInSlot(i) == nil then
            g = g + 1
        end
    end
    return g
end
function ItemFun.GetEmptyBackpackSlots(npc)
    local g = 0
    for i = 6, 8 do
        if npc:GetItemInSlot(i) == nil then
            g = g + 1
        end
    end
    return g
end
function ItemFun.SwapItemToBackpack(npc, itemIndex)
    for i = 6, 8 do
        if npc:GetItemInSlot(i) == nil then
            npc:ActionImmediate_SwapItems(itemIndex, i)
            return true
        end
    end
    return false
end
function ItemFun.GetCarriedItems(npc)
    local g = Linq.NewTable()
    for i = 0, 8 do
        local item = npc:GetItemInSlot(i)
        if item then
            table.insert(g, item)
        end
    end
    return g
end
function ItemFun.GetCarriedItemsWithIndex(npc)
    local g = Linq.NewTable()
    for i = 0, 8 do
        local item = npc:GetItemInSlot(i)
        if item then
            table.insert(g, {
                i,
                item,
            })
        end
    end
    return g
end
function ItemFun.GetInventoryItems(npc)
    local g = Linq.NewTable()
    for i = 0, 5 do
        local item = npc:GetItemInSlot(i)
        if item then
            table.insert(g, item)
        end
    end
    return g
end
function ItemFun.GetInventoryItemNames(npc)
    local g = Linq.NewTable()
    for i = 0, 5 do
        local item = npc:GetItemInSlot(i)
        if item then
            table.insert(g, item:GetName())
        end
    end
    return g
end
function ItemFun.GetStashItems(npc)
    local g = Linq.NewTable()
    for i = 9, 14 do
        local item = npc:GetItemInSlot(i)
        if item then
            item.slotIndex = i
            table.insert(g, item)
        end
    end
    return g
end
function ItemFun.GetAllBoughtItems(npcBot)
    local g = Linq.NewTable()
    for i = 0, 16 do
        local item = npcBot:GetItemInSlot(i)
        if item then
            table.insert(g, item)
        end
    end
    return g
end
function ItemFun.IsBoots(item)
    if type(item) ~= "string" then
        item = item:GetName()
    end
    return string.match(item, "boots") or item == "item_guardian_greaves" or item == "item_power_treads"
end
ItemFun.InventoryOnlyItems = Linq.NewTable("item_gem", "item_rapier", "item_bloodstone", "item_aegis")
ItemFun.PurchasedConsumables = Linq.NewTable('item_clarity', 'item_tango', 'item_flask', 'item_faerie_fire', 'item_enchanted_mango', 'item_infused_raindrop')
ItemFun.NeutralItems = Linq.NewTable()
ItemFun.NeutralItems.T1 = Linq.NewTable("item_arcane_ring", "item_broom_handle", "item_chipped_vest", "item_fairys_trinket", "item_keen_optic", "item_ocean_heart", "item_pig_hole", "item_possessed_mask", "item_trusty_shovel", "item_tumblers_toy")
ItemFun.NeutralItems.T2 = Linq.NewTable("item_brigands_blade", "item_bullwhip", "item_dragon_scale", "item_essence_ring", "item_fae_grenade", "item_grove_bow", "item_nether_shawl", "item_philosophers_stome", "item_pupils_gift", "item_quicksilver_amulet", "item_ring_of_aquila", "item_vambrace")
ItemFun.NeutralItems.T3 = Linq.NewTable("item_blast_rig", "item_ceremonial_robe", "item_cloak_of_flames", "item_elven_tunic", "item_enchanted_quiver", "item_mind_breaker", "item_paladin_sword", "item_psychic_headband", "item_quickening_charm", "item_spider_legs", "item_titan_silver")
ItemFun.NeutralItems.T4 = Linq.NewTable("item_ascetics_cap", "item_flicker", "item_ninja_gear", "item_penta_edged_sword", "item_spell_prism", "item_stormcrafter", "item_telescope", "item_the_leveller", "item_timeless_relic", "item_trickster_cloak", "item_witchblade")
ItemFun.NeutralItems.T5 = Linq.NewTable("item_apex", "item_arcanists_armor", "item_book_of_shadows", "item_book_of_the_dead", "item_ex_machina", "item_fallen_sky", "item_force_boots", "item_giants_ring", "item_mirror_shield", "item_pirate_hat", "item_seer_stone", "item_stygian_desolator")
function ItemFun.IsNeutralItem(name)
    return Linq.Range(1, 5):Map(function(t)
        return ItemFun.NeutralItems["T"..t]
    end):Any(function(t)
        return t:Contains(name)
    end)
end
function ItemFun.CannotBePutIntoBackpack(item)
    if type(item) ~= "string" then
        item = item:GetName()
    end
    return ItemFun.InventoryOnlyItems:Contains(item)
end
local function RateItem(item)
    local name = item:GetName()
    local rate = (function()
        if name == "item_gem" then
            return 4000
        elseif name == "item_dust" then
            return 1800 + 200 * item:GetCurrentCharges()
        elseif ItemFun.PurchasedConsumables:Contains(name) then
            local rate1 = GetItemCost(name) * item:GetCurrentCharges()
            if name == "item_tango" then
                rate1 = rate1 / 3
            elseif name == "item_infused_raindrop" then
                rate1 = rate1 / 6
            end
            return rate1
        elseif name == "item_rapier" then
            return 14000
        elseif string.match(name, "recipe_") then
            return 0
        else
            return GetItemCost(name)
        end
    end)()
    return rate
end
function ItemFun.SwapUsefulOnes(bot)
    local items = ItemFun.GetCarriedItemsWithIndex(bot):Map(function(t)
        return {
            inventIndex = t[1],
            item = t[2],
            rate = RateItem(t[2]),
        }
    end):OrderByDescending(function(t)
        if bot:GetActiveMode() == BOT_MODE_WARD and (t.item:GetName() == "item_ward_observer" or t.item:GetName() == "item_ward_dispenser") then
            return 10000
        end
        return (function()
            if ItemFun.InventoryOnlyItems:Contains(t.item:GetName()) then
                return 20000
            elseif ItemFun.IsNeutralItem(t) then
                return 0
            else
                return t.rate
            end
        end)()
    end)
    items:ForEach(function(t, index)
        t.correctIndex = index - 1
    end)
    local backpackItemsInInventory = items:Filter(function(t)
        return bot:GetItemSlotType(t.inventIndex) == ITEM_SLOT_TYPE_MAIN and bot:GetItemSlotType(t.correctIndex) == ITEM_SLOT_TYPE_BACKPACK
    end)
    local inventoryItemsInBackpack = items:Filter(function(t)
        return bot:GetItemSlotType(t.inventIndex) == ITEM_SLOT_TYPE_BACKPACK and bot:GetItemSlotType(t.correctIndex) == ITEM_SLOT_TYPE_MAIN
    end)
    Linq.ForEach2(backpackItemsInInventory, inventoryItemsInBackpack, function(a, b)
    end)
end
ItemFun.defaultAbilityFunctions = Linq.NewTable("CanAbilityBeUpgraded", "GetAbilityDamage", "GetAOERadius", "GetAutoCastState", "GetBehavior", "GetCaster", "GetCastPoint", "GetCastRange", "GetChannelledManaCostPerSecond", "GetChannelTime", "GetDuration", "GetCooldown", "GetCooldownTimeRemaining", "GetCurrentCharges", "GetDamageType", "GetEstimatedDamageToTarget", "GetHeroLevelRequiredToUpgrade", "GetInitialCharges", "GetLevel", "GetManaCost", "GetMaxLevel", "GetName", "GetSecondaryCharges", "GetSpecialValueFloat", "GetSpecialValueInt", "GetTargetFlags", "GetTargetTeam", "GetTargetType", "GetToggleState", "IsActivated", "IsAttributeBonus", "IsChanneling", "IsCooldownReady", "IsFullyCastable", "IsHidden", "IsInAbilityPhase", "IsItem", "IsNull", "IsOwnersManaEnough", "IsPassive", "IsStealable", "IsStolen", "IsTalent", "IsToggle", "IsTrained", "IsUltimate", "ProcsMagicStick", "ToggleAutoCast")
ItemFun.defaultItemExtraFunctions = Linq.NewTable("CanBeDisassembled", "IsCombineLocked", "GetPowerTreadsStat")
ItemFun.defaultItemFunctions = ItemFun.defaultAbilityFunctions:Concat(ItemFun.defaultItemExtraFunctions)
function ItemFun.UseItemNoTarget(npc, item, cause)
    if ItemFun.print then
        local s = npc:GetUnitName()..": use "..item:GetName()
        if cause then
            s = s.." because of "..cause
        end
        print(s)
    end
    npc:Action_UseAbility(item)
end
function ItemFun.UseItemOnEntity(npc, item, entity, cause)
    if ItemFun.print then
        local s = npc:GetUnitName()..": use "..item:GetName().." on entity "..entity:GetUnitName()
        if cause then
            s = s.." because of "..cause
        end
        print(s)
    end
    npc:Action_UseAbilityOnEntity(item, entity)
end
function ItemFun.UseItemOnLocation(npc, item, loc, cause)
    if ItemFun.print then
        local s = npc:GetUnitName()..": use "..item:GetName().." on location "..fun1:ToStringVector(loc)
        if cause then
            s = s.." because of "..cause
        end
        print(s)
    end
    npc:Action_UseAbilityOnLocation(item, loc)
end
function ItemFun.UseItemOnTree(npc, item, tree, cause)
    if ItemFun.print then
        local s = npc:GetUnitName()..": use "..item:GetName().." on tree "..tostring(tree)
        if cause then
            s = s.." because of "..cause
        end
        print(s)
    end
    npc:Action_UseAbilityOnTree(item, tree)
end
function ItemFun.FadeWouldMakeNoSense(t)
    if t:HasModifier "modifier_item_dustofappearance" or t:HasModifier "modifier_truesight" or t:HasModifier "modifier_bounty_hunter_track" or t:HasModifier "modifier_slardar_amplify_damage" then
        return true
    end
    return false
end
local itemNamePrefix = "item_"
function ItemFun.GetItemShortName(t)
    return string.sub(t, #itemNamePrefix + 1)
end
function Hero.MustBeIllusion(target)
    if target:IsIllusion() then
        return true
    end
    if GetTeam() == target:GetTeam() then
        return target:IsIllusion()
    end
    if target.markedAsIllusion then
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
function Hero.MayNotBeIllusion(t)
    return not Hero.MustBeIllusion(t)
end
function Hero.GetUniqueHeroNumber(heroes)
    if #heroes == 0 then
        return 0
    end
    return Linq.Filter(heroes, Hero.MayNotBeIllusion):GroupBy(function(t)
        return t:GetPlayerID()
    end):Count()
end
function Hero.HasScepter(npc)
    return npc:HasScepter() or npc:HasModifier "modifier_wisp_tether_scepter" or npc:HasModifier "modifier_item_ultimate_scepter" or npc:HasModifier "modifier_item_ultimate_scepter_consumed_alchemist"
end
function Hero.HasBoughtScepter(npc)
    return npc:HasScepter() or npc:HasModifier "modifier_item_ultimate_scepter" or npc:HasModifier "modifier_item_ultimate_scepter_consumed_alchemist"
end
function Hero.PrintMode(npc)
    print("bot "..npc:GetUnitName().." in mode "..DotaExt.BotModeToString(npc:GetActiveMode())..", desire = "..npc:GetActiveModeDesire())
end
Hero.teleportAbilities = Linq.NewTable("furion_teleportation", "item_tpscroll")
function Hero.IsTeleporting(npc)
    return (function()
        local activeAbility = npc:GetCurrentActiveAbility()
        if activeAbility and Hero.teleportAbilities:Contains(activeAbility:GetName()) then
            return true
        else
            return false
        end
    end)()
end
local oldRoleUtils = require(GetScriptDirectory().."/util/RoleUtility")
local fun1 = require(GetScriptDirectory().."/util/AbilityAbstraction")
local ItemUse = {}
function ItemUse.GetItemInfo(bot, item)
    local itemAuxTable
    if bot.itemAuxTable then
        itemAuxTable = bot.itemAuxTable
    else
        itemAuxTable = {}
        bot.itemAuxTable = itemAuxTable
    end
    local thisItemTable
    local itemKey = tostring(item)
    if itemAuxTable[itemKey] then
        thisItemTable = itemAuxTable[itemKey]
    else
        itemAuxTable[itemKey] = {}
        thisItemTable = itemAuxTable[itemKey]
    end
    return thisItemTable
end
local primaryAbilityHasBonus = Linq.NewTable("obsidian_destroyer", "enchantress", "silencer", "drow_ranger")
local function GetWantedPowerTreadsAttribute(npcBot, info)
    local mode = npcBot:GetActiveMode()
    if mode == BOT_MODE_RETREAT and npcBot:WasRecentlyDamagedByAnyHero(3) then
        return ATTRIBUTE_STRENGTH, "MoreHealthWhenRetreat"
    elseif UnitFun.IsAttackingEnemies(npcBot) then
        local name = UnitFun.GetHeroShortName(npcBot:GetUnitName())
        if primaryAbilityHasBonus:Contains(name) then
            return npcBot:GetPrimaryAttribute(), "PrimaryWithAbilityBonus"
        else
            return ATTRIBUTE_AGILITY, "AgilityWhenAttacking"
        end
    elseif mode == BOT_MODE_LANING then
        return info.primAttr, "PrimaryForLH"
    elseif npcBot:WasRecentlyDamagedByAnyHero(2) then
        return ATTRIBUTE_STRENGTH, "StrengthWhenAttacked"
    else
        return info.primAttr, "PrimaryWhenIdle"
    end
end
local function UsePowerTreads(pt, bot, info)
    if bot:HasModifier "modifier_ice_blast" then
        return
    end
    if AbilInfo.HasAnyModifier(bot, AbilInfo.invisibleModifiers) and bot:UsingItemBreaksInvisibility() then
        if bot:HasModifier("modifier_item_dustofappearance") then
            bot:Action_UseAbility(pt)
            return "BreakInvisibility"
        end
        if not AbilInfo.HasAnyModifier(bot, AbilInfo.truesightModifiers) then
            return
        end
    end
    local wantedAttribute, reason = GetWantedPowerTreadsAttribute(bot, info)
    print(bot:GetUnitName().." want "..DotaExt.AttributeTypeToString(wantedAttribute)..", currently "..DotaExt.AttributeTypeToString(pt:GetPowerTreadsStat())..", reason = "..reason..", mode = "..DotaExt.BotModeToString(bot:GetActiveMode()))
    if wantedAttribute ~= pt:GetPowerTreadsStat() then
        return reason
    end
end
function ItemUseDefaultImpl.branch(item, bot, info)
end
local function CountInventoryItemCooldown(bot, inventoryItems)
    inventoryItems:ForEach(function(t)
        local r = ItemUse.GetItemInfo(bot, t)
        if r.cooldownFromBackpack then
            local __mira_locvar_1 = r
            __mira_locvar_1.cooldownFromBackpack = __mira_locvar_1.cooldownFromBackpack - deltaTime
            if r.cooldownFromBackpack <= 0 then
                r.cooldownFromBackpack = 0
            end
        end
    end)
end
local entityOnlyItems = Linq.NewTable()
local noTargetOnlyItems = Linq.NewTable("arcane_boots", "phase_boots", "power_treads")
local treeOnlyItems = Linq.NewTable()
local locationOnlyItems = Linq.NewTable("travel_boots", "travel_boots_2")
local function ConsiderAvailableItem(item, bot, itemUsageAuxiliaryInfo)
    local name = ItemFun.GetItemShortName(item:GetName())
    local itemFunc = bot.ItemUsage and bot.ItemUsage[name] or ItemUseDefaultImpl[name]
    if itemFunc == nil then
        GameLoop.EveryManySeconds(5, "NotifyUnimplementedItem "..name, function()
        end)
        return 0
    else
        local castTarget, targetType, cause
        local desire, b, c, d = itemFunc(item, bot, itemUsageAuxiliaryInfo)
        if noTargetOnlyItems:Contains(name) then
            castTarget, targetType, cause = nil, "none", b
        elseif treeOnlyItems:Contains(name) then
            castTarget, targetType, cause = b, "tree", c
        elseif locationOnlyItems:Contains(name) then
            castTarget, targetType, cause = b, "location", c
        elseif entityOnlyItems:Contains(name) then
            castTarget, targetType, cause = b, "entity", c
        else
            castTarget, targetType, cause = b, c, d
        end
        return desire, castTarget, targetType, cause
    end
end
local function UseAvailableItems(bot, inventoryItems)
    local itemUsageAuxiliaryInfo = Linq.NewTable()
    local info = itemUsageAuxiliaryInfo
    info.hp = bot:GetHealth()
    info.hpm = bot:GetMaxHealth()
    info.hpp = bot:GetHealth() / bot:GetMaxHealth()
    info.mn = bot:GetMana()
    info.mnm = bot:GetMaxMana()
    info.mnp = info.mn / info.mnm
    info.lev = bot:GetLevel()
    info.allEnemies1400 = DotaExt.GetNearbyHeroes(bot, 1400)
    info.e1400 = info.allEnemies1400:Filter(Hero.MayNotBeIllusion)
    info.ec1400 = Hero.GetUniqueHeroNumber(info.e1400)
    info.allEnemies1600 = DotaExt.GetNearbyHeroes(bot, 1600)
    info.e1600 = info.allEnemies1600:Filter(Hero.MayNotBeIllusion)
    info.ec1600 = Hero.GetUniqueHeroNumber(info.e1600)
    info.allEnemies1200 = DotaExt.GetNearbyHeroes(bot, 1200)
    info.e1200 = info.allEnemies1200:Filter(Hero.MayNotBeIllusion)
    info.ec1200 = Hero.GetUniqueHeroNumber(info.e1200)
    info.allEnemies900 = DotaExt.GetNearbyHeroes(bot, 900)
    info.e900 = info.allEnemies900:Filter(Hero.MayNotBeIllusion)
    info.ec900 = Hero.GetUniqueHeroNumber(info.e900)
    info.allEnemies650 = DotaExt.GetNearbyHeroes(bot, 650)
    info.e650 = info.allEnemies650:Filter(Hero.MayNotBeIllusion)
    info.ec650 = Hero.GetUniqueHeroNumber(info.e650)
    info.allAllies = DotaExt.GetNearbyHeroes(bot, 1500)
    info.allies = info.allAllies:Filter(Hero.MayNotBeIllusion)
    info.allyCount = Hero.GetUniqueHeroNumber(info.allies)
    info.nw = bot:GetNetWorth()
    info.bp = fun1:GetBattlePower(bot)
    info.primAttr = bot:GetPrimaryAttribute()
    info.blasted = bot:HasModifier "modifier_ice_blast"
    info.target = bot:GetTarget()
    local highDesireItem = inventoryItems:Map(function(t)
        local pack = { ConsiderAvailableItem(t, bot, itemUsageAuxiliaryInfo) }
        pack[5] = t
        return pack
    end):Filter(function(t)
        return t[1] > 0
    end):MaxKey(function(t)
        return t[1]
    end)
    do
        local t = highDesireItem
        if t then
            if t[3] == "none" then
                if t[5]:GetName() == "item_power_treads" then
                    print(bot:GetUnitName().." use power treads")
                end
                ItemFun.UseItemNoTarget(bot, t[5], t[4])
            elseif t[3] == "location" then
                ItemFun.UseItemOnLocation(bot, t[5], t[2], t[4])
            elseif t[3] == "tree" then
                ItemFun.UseItemOnTree(bot, t[5], t[2], t[4])
            else
                ItemFun.UseItemOnEntity(bot, t[5], t[2], t[4])
            end
        end
    end
end
function ItemUse.CanUseAnyItem(t)
    return not (fun1:IsMuted(t) or fun1:IsHypnosed(t) or fun1:IsFeared(t) or t:IsHexed() or t:IsChanneling())
end
function ItemUse.ItemUsageThink()
    local bot = GetBot()
    if not UnitFun.CanUseItem(bot) then
        return
    end
    GameLoop.EveryManySeconds(3, "SwapUsefulItems "..bot:GetUnitName(), function()
        return ItemFun.SwapUsefulOnes(bot)
    end)
    local inventoryItems = ItemFun.GetInventoryItems(bot)
    CountInventoryItemCooldown(bot, inventoryItems)
    if ItemUse.CanUseAnyItem(bot) then
        UseAvailableItems(bot, inventoryItems:Filter(function(t)
            return t:IsFullyCastable() and (not bot:IsIllusion() or bot:HasModifier "modifier_skeleton_king_reincarnation_active" or bot:HasModifier "modifier_vengefulspirit_hybrid_special" or bot:HasModifier "modifier_arc_warden_tempest_double") and ItemUse.GetItemInfo(bot, t).cooldownFromBackpack == nil
        end))
    end
end
local Role = {}
function Role.GetRoleValue(npc, role)
    return oldRoleUtils.hero_roles[npc:GetUnitName()][role]
end
function Role.Push(npc)
    return Role.GetRoleValue(npc, "pusher")
end
function Math.PointToPointDistance(a, b)
    local x = a.x - b.x
    local y = a.y - b.y
    return (x * x + y * y) ^ 0.5
end
local Push_impl = {}
function Push_impl.GetCarryRate(hero)
    return oldRoleUtils.hero_roles[hero:GetUnitName()].carry
end
function Push_impl.GetLane(nTeam, hHero)
    local vBot = GetLaneFrontLocation(nTeam, LANE_BOT, 0)
    local vTop = GetLaneFrontLocation(nTeam, LANE_TOP, 0)
    local vMid = GetLaneFrontLocation(nTeam, LANE_MID, 0)
    return (function()
        if GetUnitToLocationDistance(hHero, vBot) < 2500 then
            return LANE_BOT
        elseif GetUnitToLocationDistance(hHero, vTop) < 2500 then
            return LANE_TOP
        elseif GetUnitToLocationDistance(hHero, vMid) < 2500 then
            return LANE_MID
        else
            return LANE_NONE
        end
    end)()
end
function Push_impl.CreepRate(creep)
    local rate = 1
    rate = rate * (function()
        if string.match(t, "upgraded_mega") then
            return 3.5
        elseif string.match(t, "upgraded") then
            return 2
        else
            return 1
        end
    end)()
    rate = rate * (function()
        if string.match(t, "melee") then
            return 1
        elseif string.match(t, "ranged") then
            return 1.2
        else
            return 1.8
        end
    end)()
    return rate
end
function Push_impl.CreepReward(creep)
    local rate = 1
    rate = rate * (function()
        if string.match(t, "upgraded_mega") then
            return 0.25
        elseif string.match(t, "upgraded") then
            return 0.5
        else
            return 1
        end
    end)()
    rate = rate * (function()
        if string.match(t, "melee") then
            return 1
        elseif string.match(t, "ranged") then
            return 1.7
        else
            return 2
        end
    end)()
    return rate
end
function Push_impl.GetAllyTower(towerIndex)
    return GetTower(GetTeam(), towerIndex)
end
local allyTower1 = fun1:Map({
    TOWER_TOP_1,
    TOWER_MID_1,
    TOWER_BOT_1,
}, Push_impl.GetAllyTower)
local allyTower2 = fun1:Map({
    TOWER_TOP_2,
    TOWER_MID_2,
    TOWER_BOT_2,
}, Push_impl.GetAllyTower)
local allyTower3 = fun1:Map({
    TOWER_TOP_3,
    TOWER_MID_3,
    TOWER_BOT_3,
}, Push_impl.GetAllyTower)
local allyTower4 = fun1:Map({
    TOWER_BASE_1,
    TOWER_BASE_2,
}, Push_impl.GetAllyTower)
function Push_impl.TowerRate(tower)
    return (function()
        if allyTower1:Contains(tower) then
            return 1
        elseif allyTower2:Contains(tower) then
            return 1.5
        elseif allyTower3:Contains(tower) then
            return (function()
                if allyTower3:All(function(t)
                    return t:IsAlive()
                end) then
                    return 2
                else
                    return 1.5
                end
            end)()
        else
            return 1.7
        end
    end)()
end
function Push_impl.CleanLaneDesire(npc, lane)
    local front = GetLaneFrontLocation(GetTeam(), lane, 0)
    local allyTower = GetNearestBuilding(GetTeam(), front)
    local distanceToFront = GetUnitToUnitDistance(npc, allyTower:GetLocation())
    local creeps = fun1:Filter(GetUnitList(UNIT_LIST_ENEMY_CREEPS), function(t)
        return GetUnitToLocationDistance(t, front) <= 1500
    end)
    local allyCreeps = fun1:Filter(GetUnitList(UNIT_LIST_FRIEND_CREEPS), function(t)
        return GetUnitToLocationDistance(t, front) <= 1500
    end)
    local creepRateDiff = fun1:Aggregate(0, creeps:Map(Push_impl.CreepRate), function(opv_1, opv_2) return opv_1 + opv_2 end) - fun1:Aggregate(0, allyCreeps:Map(Push_impl.CreepRate), function(opv_1, opv_2) return opv_1 + opv_2 end)
    local desire = 0
    local necessity = 0
    if distanceToFront <= 3000 then
        if creepRateDiff >= DotaTime() / 300 and creepRateDiff >= 3 then
            necessity = necessity + creepRateDiff
        end
        if creepRateDiff >= 2 and creepRateDiff then
            desire = desire + fun1:Aggregate(0, creeps:Map(Push_impl.CreepReward), function(opv_1, opv_2) return opv_1 + opv_2 end)
        end
    end
    necessity = necessity * TowerRate(allyTower)
    desire = desire * TowerRate(allyTower)
    return desire, necessity
end
function Push_impl.DefendLaneDesire()
    return 0
end
function Push_impl.PushLaneDesire(npc, lane)
    local team = GetTeam()
    local teamPush = TeamPushLaneDesire(lane)
    local levelFactor = (function()
        if npc:GetLevel() < 6 then
            return 0
        else
            return 0.2
        end
    end)()
    local myLane = GetLane(team, npc)
    if myLane ~= LANE_NONE then
        if Push_impl.CleanLaneDesire(myLane) > Push_impl.CleanLaneDesire(lane) then
            return 0
        end
    end
    local healthRate = npcBot:GetHealth() / npcBot:GetMaxHealth() + fun1:GetLifeSteal(npc) * 2
    if healthRate > 1 then
        healthRate = 0
    end
    local manaRate = npcBot:GetMana() / npcBot:GetMaxMana()
    local stateFactor = healthRate * 0.7 + manaRate * 0.3
    if stateFactor < 0.6 then
        return 0
    end
    local roleFactor = (function()
        if Role.Push(npc) then
            return Role.Push(npc) * 0.2
        elseif Role.Support(npc) then
            return Role.Support(npc) * 0.1
        else
            return 0
        end
    end)()
    local laneFront = GetLaneFrontLocation(team, lane, 0)
    local distanceToFront = GetUnitToUnitDistance(npc, laneFront)
    local nearestBuilding = Push_impl.GetNearestBuilding(team, laneFront)
    local ddis = GetUnitToUnitDistance(nearestBuilding, laneFront)
    local tp = ItemFun.GetAvailableTp(npc)
    local canCastTp = ItemFun.CanUseAvailableTp(npc, tp)
    local distanceFactor = (function()
        if distanceToFront <= 1000 or canCastTp then
            return 1
        elseif distanceToFront - ddis >= 3000 and canCastTp then
            return (function()
                if ddis <= 1000 then
                    return 0.7
                elseif ddis >= 6000 then
                    return 0
                else
                    return -(ddis - 6000) * 0.7 / 5000
                end
            end)()
        elseif distanceToFront >= 10000 then
            return 0
        else
            return -(distanceToFront - 10000) / 9000
        end
    end)()
    local factor = 0.2 + levelFactor + roleFactor + 0.4 * distanceFactor + 0.2 * stateFactor
    if stateFactor < 1.2 then
        factor = factor * RemapVal(stateFactor, 0.6, 1.2, 0, 0.7)
    end
    return Clamp(factor, 0, 0.8)
end
function Push_impl.NoCreepsOnLane(npc, lane)
    local team = GetTeam()
    local laneFront = GetLaneFrontLocation(team, lane, 0)
    local allyTower = Push_impl.GetNearestBuilding(team, laneFront)
    local enemyTower = Push_impl.GetNearestBuilding(GetOpposingTeam(), laneFront)
    local enemySpawnLocation = Push_impl.GetEnemySpawnLocation()
    local maxDiveDistance = 400
    local towerToEnemyHomeDistance = GetUnitToLocationDistance(enemyTower, enemySpawnLocation)
    return towerToEnemyHomeDistance < GetUnitToUnitDistance(enemyTower, allyTower) and Math.PointToPointDistance(laneFront, enemySpawnLocation) < towerToEnemyHomeDistance - maxDiveDistance
end
function Push_impl.GetAttackBuildingLocation(npc, lane)
    local team = GetTeam()
    local laneFront = GetLaneFrontLocation(team, lane, 0)
    local allyTower = Push_impl.GetNearestBuilding(team, laneFront)
    local enemyTower = Push_impl.GetNearestBuilding(GetOpposingTeam(), laneFront)
    local enemySpawnLocation = Push_impl.GetEnemySpawnLocation()
    local maxDiveDistance = 400
    local towerToEnemyHomeDistance = GetUnitToLocationDistance(enemyTower, enemySpawnLocation)
    local distanceToTower = GetUnitToUnitDistance(npc, enemyTower)
    if distanceToTower < 1000 then
        return Push_impl.GetSafeLocation(npc, enemyTower)
    else
        if Math.PointToPointDistance(laneFront, enemySpawnLocation) < towerToEnemyHomeDistance - maxDiveDistance and npc:GetLevel() <= 11 then
            return Push_impl.GetSafeLocation(npc, allyTower)
        else
            return Push_impl.GetSafeLocation(npc, enemyTower)
        end
    end
end
function Push_impl.CreepAttackingTower(creeps, tower)
    return Linq.Any(creeps, function(t)
        return t:GetAttackTarget() == tower
    end)
end
function Push_impl.IsSafeToAttack(npc, lane, creeps)
    local team = GetTeam()
    local laneFront = GetLaneFrontLocation(team, lane, 0)
    local allyTower = Push_impl.GetNearestBuilding(team, laneFront)
    local enemyTower = Push_impl.GetNearestBuilding(GetOpposingTeam(), laneFront)
    local enemySpawnLocation = Push_impl.GetEnemySpawnLocation()
    local maxDiveDistance = 400
    local distanceToEnemyHome = GetUnitToLocationDistance(npc, enemySpawnLocation)
    local towerToEnemyHomeDistance = GetUnitToLocationDistance(enemyTower, enemySpawnLocation)
    local distanceToTower = GetUnitToUnitDistance(npc, enemyTower)
    local safe = distanceToTower > 1500 or GetUnitToUnitDistanceSqr(npc, allyTower) <= 490000
    local creepMinDistance = creeps:Min(function(t)
        return GetUnitToUnitDistanceSqr(t, enemyTower)
    end)
    if creepMinDistance and (distanceToTower < creepMinDistance or distanceToEnemyHome < towerToEnemyHomeDistance - maxDiveDistance) then
        safe = true
    end
    if enemyTower:GetAttackDamage() < 20 then
        safe = true
    end
    return safe
end
function Push_impl.TryTp(npc, lane)
    local team = GetTeam()
    local laneFront = GetLaneFrontLocation(team, lane, 0)
    local distanceToFront = GetUnitToLocationDistance(npc, laneFront)
    local nearestBuilding = Push_impl.GetNearestBuilding(team, laneFront)
    local distanceToNearestBuilding = GetUnitToLocationDistance(nearestBuilding, laneFront)
    local amount = Push_impl.GetAmountAlongLane(lane, npc:GetLocation())
    local tp = Push_impl.GetAvailableTp(npc)
    if distanceToFront > 3000 and distanceToFront - distanceToNearestBuilding > 3000 then
        npc.Push_impl_TryTp = GameLoop.StartCoroutine(function()
            return Push_impl.UseAvailableTp(npc, tp)
        end)
    end
end
function Push_impl.GetCreepsNearTower(npc, tower)
    return DotaExt.GetNearbyCreeps(npc, 1400, false):Filter(function(t)
        return GetUnitToLocationDistanceSqr(t, tower) < 640000
    end)
end
function Push.UnitPushLaneThink(npc, lane)
    if npc:IsChanneling() or npc:IsUsingAbility() or npc:GetQueuedActionType(0) == BOT_ACTION_TYPE_USE_ABILITY then
        return
    end
    if npc.Push_impl_TryTp then
        if coroutine.status(npc.Push_impl_TryTp) == "dead" then
            npc.Push_impl_TryTp = nil
        else
            return
        end
    else
        Push_impl.TryTp(npc, lane)
    end
    local team = GetTeam()
    local laneFront = GetLaneFrontLocation(team, lane, 0)
    local allyTower = Push_impl.GetNearestBuilding(team, laneFront)
    local enemyTower = Push_impl.GetNearestBuilding(GetOpposingTeam(), laneFront)
    local enemySpawnLocation = Push_impl.GetEnemySpawnLocation()
    local distanceToFront = GetUnitToLocationDistance(npc, laneFront)
    local nearestBuilding = Push_impl.GetNearestBuilding(team, laneFront)
    local distanceToNearestBuilding = GetUnitToLocationDistance(nearestBuilding, laneFront)
    local creeps = Push_impl.GetCreepsNearTower(npc, enemyTower)
    local targetLocation = Push_impl.GetTargetLocation(npc, lane)
    local buildingAttackedByTower = Push_impl.CreepAttackingTower(creeps, enemyTower)
    local isSafeToAttack = Push_impl.IsSafeToAttack(npc, lane, creeps)
    local noCreeps = Push_impl.NoCreepsOnLane(npc, lane)
    local enemies = DotaExt.GetNearbyHeroes(npc, 1200)
    local target = Push_impl.GetMyTarget(npc, lane, targetLocation)
    if target then
        targetLocation = Push_impl.GetSafeLocation(npc, target)
    end
    local goodSituation = true
    if (npc:GetLevel() >= 12 or npc:GetLevel() >= DotaTime() / 120) and npc:GetHealth() >= 700 and #enemeis == 0 then
        goodSituation = true
    end
    if (not isSafeToAttack or noCreeps) and (fun1:GetHealthPercent(enemyTower) >= 0.2 and enemyTower:GetAttackDamage() > 20) then
        goodSituation = false
    end
    if Push_impl.TooManyEnemies() then
        Push_impl.AssembleWithAlly(npc)
    elseif not goodSituation then
        Push_impl.StepBack(npc)
    end
end
M.Linq = Linq
M.Debug = Debug
M.Dota = DotaExt
M.Unit = UnitFun
M.Game = GameLoop
M.Item = ItemFun
M.ItemUse = ItemUse
M.Hero = Hero
M.Building = Building
return M
