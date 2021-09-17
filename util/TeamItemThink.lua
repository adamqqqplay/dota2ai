---------------------------------------------
-- Generated from Mirana Compiler version 1.6.1
-- Do not modify
-- https://github.com/AaronSong321/Mirana
---------------------------------------------
local M = {}
local fun1 = require(GetScriptDirectory().."/util/AbilityAbstraction")
M.ImplmentedTeamItems = { "item_mekansm" }
local roles = {
    abaddon = { 9 },
    abyssal_underlord = { 4 },
    alchemist = { 0 },
    ancient_apparition = { 2 },
    antimage = { 1 },
    arc_warden = { 0 },
    axe = { 2 },
    bane = { 3 },
    batrider = { 4 },
    beastmaster = { 0 },
    bloodseeker = { 1 },
    bounty_hunter = { 3 },
    brewmaster = { 0 },
    bristleback = { 4 },
    broodmother = { 5 },
    centaur = { 3 },
    chaos_knight = { 2 },
    chen = { 9 },
    clinkz = { 1 },
    crystal_maiden = { 8 },
    dark_seer = { 7 },
    dazzle = { 9 },
    death_prophet = { 5 },
    disruptor = { 6 },
    doom_bringer = { 1 },
    dragon_knight = { 0 },
    drow_ranger = { 0 },
    earth_spirit = { 6 },
    earthshaker = { 5 },
    ember_spirit = { 2 },
    enchantress = { 7 },
    enigma = { 8 },
    faceless_void = { 1 },
    furion = { 5 },
    gyrocopter = { 4 },
    hoodwink = { 5 },
    huskar = { 1 },
    jakiro = { 7 },
    juggernaut = { 0 },
    keeper_of_the_light = { 4 },
    kunkka = { 1 },
    legion_commander = { 1 },
    leshrac = { 4 },
    lich = { 5 },
    life_stealer = { 2 },
    lina = { 5 },
    lion = { 5 },
    luna = { 1 },
    lycan = { 4 },
    magnataur = { 0 },
    medusa = { 0 },
    mirana = { 1 },
    monkey_king = { 0 },
    naga_siren = { 4 },
    necrolyte = { 7 },
    nevermore = { 3 },
    night_stalker = { 2 },
    nyx_assassin = { 5 },
    obsidian_destroyer = { 4 },
    ogre_magi = { 4 },
    omniknight = { 8 },
    oracle = { 8 },
    phantom_assassin = { 1 },
    phantom_lancer = { 1 },
    pugna = { 5 },
    puck = { 4 },
    pudge = { 1 },
    queenofpain = { 3 },
    rattletrap = { 4 },
    razor = { 6 },
    riki = { 3 },
    sand_king = { 5 },
    shadow_demon = { 6 },
    shadow_shaman = { 8 },
    shredder = { 3 },
    silencer = { 6 },
    skeleton_king = { 1 },
    skywrath_mage = { 4 },
    slardar = { 2 },
    slark = { 1 },
    sniper = { 0 },
    spectre = { 4 },
    spirit_breaker = { 3 },
    sven = { 1 },
    templar_assassin = { 1 },
    terrorblade = { 1 },
    tidehunter = { 7 },
    tinker = { 0 },
    tiny = { 2 },
    treant = { 7 },
    troll_warlord = { 0 },
    tusk = { 4 },
    undying = { 6 },
    ursa = { 0 },
    vengefulspirit = { 5 },
    venomancer = { 7 },
    viper = { 6 },
    warlock = { 7 },
    weaver = { 2 },
    windrunner = { 4 },
    winter_wyvern = { 7 },
    witch_doctor = { 6 },
    zuus = { 3 },
}
local function heroItemMetaFunc(tb, key)
    if key == "mekansm" then
        return tb[1]
    end
    return 0
end
local heroItemMetatable = { __index = heroItemMetaFunc }
fun1:ForEachDic(roles, function(it)
    return setmetatable(it, heroItemMetatable)
end)
local zeroTable = {}
setmetatable(zeroTable, { __index = function(_)
    return 0
end })
setmetatable(roles, { __index = function(_, heroName)
    print(heroName.." doesn't have a table")
    return zeroTable
end })
local humanPlayers
local dustBuyers
local defaultDustBuyerNumber = 2
local teamMembers = {}
local gemPlayers
local nonDefaultGemPlayers
local enemyStates = fun1:NewTable()
local finishInit
local runned
local function TeamItemInit()
    if finishInit then
        return
    end
    finishInit = true
    fun1:Range(1, 5):ForEach(function(t)
        enemyStates[t] = {}
    end)
    humanPlayers = fun1:Range(1, 5):Filter(function(it)
        return not GetTeamMember(it):IsBot()
    end)
    dustBuyers = fun1:SortByMaxFirst(teamMembers, function()
        return math.random()
    end)
    dustBuyers = (function()
        if #dustBuyers >= defaultDustBuyerNumber then
            return dustBuyers:Take(defaultDustBuyerNumber)
        else
            return dustBuyers
        end
    end)()
end
local function IsLeaf(item)
    return next(GetItemComponents(item)) == nil
end
local function NextNodes(item)
    return GetItemComponents(item)[1]
end
function M.ExpandFirstLevel(item)
    if IsLeaf(item) then
        return {
            name = item,
            isSingleItem = true,
        }
    else
        return {
            name = item,
            recipe = NextNodes(item),
        }
    end
end
function M.ExpandOnce(item)
    local g = {}
    local expandSomething = false
    for _, v in ipairs(item.recipe) do
        if IsLeaf(v) then
            table.insert(g, v)
        else
            expandSomething = true
            for _, i in ipairs(NextNodes(v)) do
                table.insert(g, i)
            end
        end
    end
    item.recipe = g
    return expandSomething
end
function M.FullyExpandItem(itemName)
    local p = M.ExpandFirstLevel(itemName)
    while M.ExpandOnce(p) do
    end
    return p
end
local function AddBefore(tb, item, before)
    for index, v in ipairs(tb) do
        if not before(v) then
            table.insert(tb, index, item)
            return
        end
    end
    table.insert(tb, 1, item)
end
local function GenerateFilter(maxCost, putBefore, putAfter)
    return function(itemInfo)
        local itemName = itemInfo.name
        local shortName = string.sub(itemName, 6)
        return (function()
            if fun1:Contains(putAfter, shortName) then
                return false
            else
                return fun1:Contains(putBefore, shortName) or GetItemCost(itemName) < maxCost
            end
        end)()
    end
end
local teamItemEvents = fun1:NewTable()
local function NotifyTeam(npcBot, itemName)
    fun1:StartCoroutine(function()
        fun1:WaitForSeconds(math.random(0, 4))
        return table.insert(teamItemEvents, {
            npcBot,
            "I'll buy "..itemName,
            false,
        })
    end)
end
local function TeamItemEventThink()
    local index = 1
    while index <= #teamItemEvents do
        local b = teamItemEvents[index]
        if b[1] == GetBot() then
            b[1]:ActionImmediate_Chat(b[2], b[3])
            table.remove(teamItemEvents, index)
        else
            index = index + 1
        end
    end
end
local function AddMekansm()
    local AddMekansmBefore = GenerateFilter(2000, {
        "glimmer_cape",
        "ghost",
    }, {
        "travel_boots",
        "hand_of_midas",
        "bfury",
    })
    local function Rate(hero)
        local heroName = fun1:GetHeroShortName(hero:GetUnitName())
        local rate = roles[heroName].mekansm + math.random(0, 1.5)
        if hero:GetPrimaryAttribute() == ATTRIBUTE_INTELLECT and rate <= 7 then
            rate = rate + 1
        end
        return rate
    end
    local heroRates = fun1:Map(teamMembers, function(it)
        return {
            it,
            Rate(it),
        }
    end):SortByMaxFirst(function(it)
        return it[2]
    end)
    local function BuyMekansm(hero)
        NotifyTeam(hero, "mekansm")
        AddBefore(hero.itemInformationTable, M.FullyExpandItem "item_mekansm", AddMekansmBefore)
        fun1:Remove_Modify(hero.itemInformationTable, "item_urn_of_shadows")
    end
    if #heroRates >= 3 then
        local hero = heroRates[1][1]
        BuyMekansm(hero)
    elseif #heroRates == 2 then
        hero = heroRates[1]
        if hero[2] >= 5 then
            BuyMekansm(hero[1])
        end
    elseif #heroRate == 1 then
        if heroRates[1][2] >= 7.5 then
            BuyMekansm(heroRates[1][1])
        end
    end
end
local function IdToEnemyStateTableIndex(id)
    return (function()
        if id <= 4 then
            return id + 1
        else
            return id - 4
        end
    end)()
end
local RefreshEnemyRespawnTime = fun1:EveryManySeconds(1, function()
    return fun1:GroupBy(GetUnitList(UNIT_LIST_ENEMY_HEROES), function(t)
        return t:GetPlayerID()
    end, function(t)
        return t
    end, function(k, v)
        return {
            k,
            v,
        }
    end):Map(function(t)
        return {
            t[1],
            t[2]:Max(function(g)
                return g:GetRespawnTime()
            end):GetRespawnTime(),
        }
    end):ForEach(function(t)
        local index = IdToEnemyStateTableIndex(t[1])
        enemyStates[index].respawnTime = t[2]
    end)
end)
function M.GetEnemyRespawnTime(id)
    return (function()
        if id then
            return enemyStates[IdToEnemyStateTableIndex(id)].respawnTime or 0
        else
            return enemyStates:Map(function(t)
                return t.respawnTime
            end)
        end
    end)()
end
function M.EnemyReadyToFight(id)
    return (function()
        if id then
            return (enemyStates[IdToEnemyStateTableIndex(id)].respawnTime or 0) <= 8
        else
            return enemyStates:Count(function(_, id)
                return M.EnemyReadyToFight(id)
            end)
        end
    end)()
end
local function TeamStateThink()
    if not finishInit then
        return
    end
    RefreshEnemyRespawnTime()
end
local function GetOtherTeam()
    if GetTeam() == TEAM_RADIANT then
        return TEAM_DIRE
    else
        return TEAM_RADIANT
    end
end
local npcBot
local hasInvisibleEnemy
local CheckInvisibleEnemy = function()
    return fun1:Any(GetTeamPlayers(GetOtherTeam()) or {}, function(t)
        local heroName = fun1:GetHeroShortName(GetSelectedHeroName(t))
        return fun1.invisibilityHeroes[heroName] and fun1.invisibilityHeroes[heroName] == 1
    end) or fun1:GetUnitList(UNIT_LIST_ENEMY_HEROES):Filter(function(t)
        return fun1:MayNotBeIllusion(npcBot, t)
    end):Any(function(t)
        return fun1:HasInvisibility(t)
    end)
end
local RefreshInvisibleEnemies_One = fun1:EveryManySeconds(2, function()
    gemPlayers = fun1:Range(1, 5):Map(function(t)
        return GetTeamMember(t)
    end):Filter(function(t)
        return fun1:GetAvailableItem(t, "item_gem")
    end)
    nonDefaultGemPlayers = gemPlayers:Filter(function(t)
        return not dustBuyers:Contains(t)
    end)
    hasInvisibleEnemy = CheckInvisibleEnemy()
end)
local RefreshInvisibleEnemies = fun1:SingleForTeam(function()
    return RefreshInvisibleEnemies_One()
end)
local BuyDustIfInvisibleEnemies = fun1:EveryManySeconds(2, function()
    RefreshInvisibleEnemies()
    if dustBuyers:Take(defaultDustBuyerNumber - #nonDefaultGemPlayers):Contains(npcBot) and hasInvisibleEnemy then
        local items = fun1:GetAllBoughtItems(npcBot):Map(function(t)
            return t:GetName()
        end)
        if not items:Contains("item_gem") and not items:Contains("item_dust") then
            if npcBot:GetGold() >= 2 * GetItemCost("item_dust") then
                npcBot:ActionImmediate_PurchaseItem("item_dust")
                npcBot:ActionImmediate_PurchaseItem("item_dust")
                npcBot:ActionImmediate_Chat("Buying dusts", false)
            end
        end
    end
end)
M.CheckInvisibleEnemy = CheckInvisibleEnemy
function M.Think()
    if fun1:GameNotReallyStarting() then
        return
    end
    npcBot = GetBot()
    TeamItemInit()
    TeamItemEventThink()
    TeamStateThink()
    BuyDustIfInvisibleEnemies()
end
function M.TeamItemThink(npcBot)
    if npcBot:IsIllusion() then
        return
    end
    if not fun1:Contains(teamMembers, npcBot) then
        if npcBot.teamItemEvents == nil then
            npcBot.teamItemEvents = fun1:NewTable()
        end
        table.insert(teamMembers, npcBot)
    end
    fun1:StartCoroutine(function(it)
        while fun1:GameNotReallyStarting() do
            coroutine.yield()
        end
        if not finishInit then
            TeamItemInit()
        end
        if #teamMembers + #humanPlayers == 5 then
            if runned then
                return
            else
                runned = true
            end
            AddMekansm()
        end
    end)
end
return M
