---------------------------------------------
-- Generated from Mirana Compiler version 1.6.2
-- Do not modify
-- https://github.com/AaronSong321/Mirana
---------------------------------------------
local M = {}
local ItemUsage = require(GetScriptDirectory().."/util/ItemUsage-New")
local fun1 = require(GetScriptDirectory().."/util/AbilityAbstraction")
<<<<<<< HEAD
=======
local A = require(GetScriptDirectory().."/util/MiraDota")
>>>>>>> fb1118d0d0092b991ad855021d58837357d90b5a
M.ImplmentedTeamItems = {
    "item_mekansm",
    "item_guardian_greaves",
}
local roles = {
<<<<<<< HEAD
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
    enchantress = { 3 },
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
    naga_siren = { 3 },
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
=======
    abaddon = {
        9,
        6,
    },
    abyssal_underlord = {
        4,
        7,
    },
    alchemist = {
        0,
        1,
    },
    ancient_apparition = {
        2,
        9,
    },
    antimage = {
        1,
        0,
    },
    arc_warden = {
        0,
        2,
    },
    axe = {
        2,
        2,
    },
    bane = {
        3,
        7,
    },
    batrider = {
        4,
        6,
    },
    beastmaster = {
        0,
        2,
    },
    bloodseeker = {
        1,
        1,
    },
    bounty_hunter = {
        3,
        5,
    },
    brewmaster = {
        0,
        1,
    },
    bristleback = {
        4,
        7,
    },
    broodmother = {
        5,
        1,
    },
    centaur = {
        3,
        3,
    },
    chaos_knight = {
        2,
        2,
    },
    chen = {
        9,
        8,
    },
    clinkz = {
        1,
        1,
    },
    crystal_maiden = {
        8,
        3,
    },
    dark_seer = {
        7,
        7,
    },
    dazzle = {
        9,
        5,
    },
    death_prophet = {
        5,
        6,
    },
    disruptor = {
        6,
        3,
    },
    doom_bringer = {
        1,
        2,
    },
    dragon_knight = {
        0,
        1,
    },
    drow_ranger = {
        0,
        0,
    },
    earth_spirit = {
        6,
        5,
    },
    earthshaker = {
        5,
        6,
    },
    ember_spirit = {
        2,
        2,
    },
    enchantress = {
        3,
        4,
    },
    enigma = {
        8,
        6,
    },
    faceless_void = {
        1,
        0,
    },
    furion = {
        5,
        0,
    },
    gyrocopter = {
        4,
        2,
    },
    hoodwink = {
        5,
        4,
    },
    huskar = {
        1,
        0,
    },
    jakiro = {
        7,
        5,
    },
    juggernaut = {
        0,
        0,
    },
    keeper_of_the_light = {
        4,
        0,
    },
    kunkka = {
        1,
        2,
    },
    legion_commander = {
        1,
        0,
    },
    leshrac = {
        4,
        6,
    },
    lich = {
        5,
        8,
    },
    life_stealer = {
        2,
        0,
    },
    lina = {
        5,
        6,
    },
    lion = {
        5,
        3,
    },
    luna = {
        1,
        1,
    },
    lycan = {
        4,
        0,
    },
    magnataur = {
        0,
        5,
    },
    medusa = {
        0,
        3,
    },
    mirana = {
        1,
        5,
    },
    monkey_king = {
        0,
        0,
    },
    naga_siren = {
        3,
        2,
    },
    necrolyte = {
        7,
        8,
    },
    nevermore = {
        3,
        2,
    },
    night_stalker = {
        2,
        0,
    },
    nyx_assassin = {
        5,
        7,
    },
    obsidian_destroyer = {
        4,
        0,
    },
    ogre_magi = {
        4,
        7,
    },
    omniknight = {
        8,
        7,
    },
    oracle = {
        8,
        8,
    },
    phantom_assassin = {
        1,
        0,
    },
    phantom_lancer = {
        1,
        1,
    },
    pugna = {
        5,
        8,
    },
    puck = {
        4,
        5,
    },
    pudge = {
        1,
        4,
    },
    queenofpain = {
        3,
        3,
    },
    rattletrap = {
        4,
        2,
    },
    razor = {
        6,
        0,
    },
    riki = {
        3,
        0,
    },
    sand_king = {
        5,
        7,
    },
    shadow_demon = {
        6,
        6,
    },
    shadow_shaman = {
        8,
        8,
    },
    shredder = {
        3,
        9,
    },
    silencer = {
        6,
        3,
    },
    skeleton_king = {
        1,
        0,
    },
    skywrath_mage = {
        4,
        9,
    },
    slardar = {
        2,
        1,
    },
    slark = {
        1,
        0,
    },
    sniper = {
        0,
        0,
    },
    spectre = {
        4,
        0,
    },
    spirit_breaker = {
        3,
        1,
    },
    sven = {
        1,
        2,
    },
    templar_assassin = {
        1,
        0,
    },
    terrorblade = {
        1,
        0,
    },
    tidehunter = {
        7,
        7,
    },
    tinker = {
        0,
        5,
    },
    tiny = {
        2,
        4,
    },
    treant = {
        7,
        7,
    },
    troll_warlord = {
        0,
        0,
    },
    tusk = {
        4,
        2,
    },
    undying = {
        6,
        8,
    },
    ursa = {
        0,
        0,
    },
    vengefulspirit = {
        5,
        6,
    },
    venomancer = {
        7,
        5,
    },
    viper = {
        6,
        1,
    },
    warlock = {
        7,
        8,
    },
    weaver = {
        2,
        1,
    },
    windrunner = {
        4,
        6,
    },
    winter_wyvern = {
        7,
        5,
    },
    witch_doctor = {
        6,
        5,
    },
    zuus = {
        3,
        9,
    },
>>>>>>> fb1118d0d0092b991ad855021d58837357d90b5a
}
local function heroItemMetaFunc(tb, key)
    return (function()
        if key == "mekansm" then
            return tb[1]
        elseif key == "arcaneBoots" then
            return tb[2]
        else
            return 0
        end
    end)()
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
    return (function()
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
    end)()
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
function M.ExpandTeamThinkItem(itemName)
    local p = M.FullyExpandItem(itemName)
    p.origin = "TeamItemThink"
    return p
end
local function AddBefore(tb, item, before)
    for index, v in ipairs(tb) do
        if before(v) then
            table.insert(tb, index, item)
            return
        end
    end
    table.insert(tb, #tb + 1, item)
end
local function GeneratePutBeforeFilter(maxCost, putBefore, putAfter)
    return function(itemInfo)
        local itemName = itemInfo.name
        local shortName = string.sub(itemName, 6)
        return (function()
            if fun1:Contains(putAfter, shortName) then
                return false
            else
                return fun1:Contains(putBefore, shortName) or GetItemCost(itemName) > maxCost
            end
        end)()
    end
end
local teamItemEvents = fun1:NewTable()
local function NotifyTeam(npcBot, itemName)
    fun1:StartCoroutine(function()
        fun1:WaitForSeconds(math.random(20, 28))
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
local function PrintItemInfoTableOf(npcBot)
    local tb = npcBot.itemInformationTable
    print(npcBot:GetUnitName().." items to buy: ")
    A.Linq.ForEach(tb, function(t, index)
        if t.isSingleItem then
            print(index..": "..t.name)
        else
            local s = ""
            A.Linq.ForEach(t.recipe, function(t1, t1Index)
                s = s..t1
                if t1Index ~= #t.recipe then
                    s = s..", "
                end
            end)
            print(index..": "..t.name.." { "..s.." }")
        end
    end)
end
local function AddMekansm()
    local AddMekansmBefore = GeneratePutBeforeFilter(2000, {
        "glimmer_cape",
        "ghost",
    }, {
        "travel_boots",
        "hand_of_midas",
        "bfury",
    })
    local function Rate(hero)
        local heroName = fun1:GetHeroShortName(hero:GetUnitName())
<<<<<<< HEAD
        local rate = roles[heroName].mekansm + math.random(0, 1.5)
=======
        local rate = roles[heroName].mekansm + math.random() * 1.5
>>>>>>> fb1118d0d0092b991ad855021d58837357d90b5a
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
<<<<<<< HEAD
        AddBefore(hero.itemInformationTable, M.FullyExpandItem "item_mekansm", AddMekansmBefore)
=======
        AddBefore(hero.itemInformationTable, M.ExpandTeamThinkItem "item_mekansm", AddMekansmBefore)
>>>>>>> fb1118d0d0092b991ad855021d58837357d90b5a
        local guardianGreavesTable = M.ExpandFirstLevel "item_guardian_greaves"
        fun1:Remove_Modify(guardianGreavesTable.recipe, "item_mekansm")
        do
            local arcaneBoots = fun1:First(hero.itemInformationTable, function(t)
                return t.name == "item_arcane_boots"
            end)
            if arcaneBoots then
                arcaneBoots.usedAsRecipeOf = guardianGreavesTable
<<<<<<< HEAD
                fun1:Remove_Modify(guardianGreavesTable, "item_arcane_boots")
=======
                fun1:Remove_Modify(guardianGreavesTable, function(t)
                    return t.name == "item_boots" or t.name == "item_energy_booster"
                end)
>>>>>>> fb1118d0d0092b991ad855021d58837357d90b5a
            end
        end
        while M.ExpandOnce(guardianGreavesTable) do
        end
<<<<<<< HEAD
        AddBefore(hero.itemInformationTable, guardianGreavesTable, GenerateFilter(4800, {}, {}))
        fun1:Remove_Modify(hero.itemInformationTable, "item_urn_of_shadows")
        fun1:Remove_Modify(hero.itemInformationTable, "item_spirit_vessel")
=======
        AddBefore(hero.itemInformationTable, guardianGreavesTable, GeneratePutBeforeFilter(4800, {}, {}))
        hero.itemInformationTable:Remove_Modify(function(t)
            return t.name == "item_urn_of_shadows"
        end)
        hero.itemInformationTable:Remove_Modify(function(t)
            return t.name == "item_spirit_vessel"
        end)
        PrintItemInfoTableOf(hero)
>>>>>>> fb1118d0d0092b991ad855021d58837357d90b5a
    end
    if #heroRates >= 3 then
        if heroRates[1][2] > 2.85 then
            local hero = heroRates[1][1]
            BuyMekansm(hero)
        end
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
<<<<<<< HEAD
=======
local function AddArcaneBoots()
    local AddArcaneBootsBefore = GeneratePutBeforeFilter(1200, {}, {})
    local function Rate(hero)
        local heroName = fun1:GetHeroShortName(hero:GetUnitName())
        local rate = roles[heroName].arcaneBoots + math.random() * 1.5
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
    local function IsUpgradedBoots(itemTable)
        return A.Item.IsBoots(itemTable.name) and itemTable.name ~= "item_boots" and not string.match(itemTable.name, "item_travel_boots")
    end
    local function RemoveItemsInNewItemTable(informationTable, newItemTable, newItemIndex)
        informationTable[newItemIndex] = newItemTable
        local function ShouldRemove(itemTable)
            return A.Linq.Contains(newItemTable.recipe, itemTable.name)
        end
        informationTable:Take(newItemIndex - 1):Filter(ShouldRemove):ForEach(function(t)
            t.usedAsRecipeOf = newItemTable
            return A.Linq.Remove_Modify(newItemTable.recipe, t.name)
        end)
    end
    local function BuyArcaneBoots(hero)
        NotifyTeam(hero, "arcane boots")
        local bootsToReplaceIndex = A.Linq.IndexOf(hero.itemInformationTable, IsUpgradedBoots)
        if bootsToReplaceIndex ~= -1 then
            local bootsToReplaceName = hero.itemInformationTable[bootsToReplaceIndex].name
            if bootsToReplaceName == "item_arcane_boots" then
            else
                local arcaneBoots = M.ExpandTeamThinkItem "item_arcane_boots"
                RemoveItemsInNewItemTable(hero.itemInformationTable, arcaneBoots, bootsToReplaceIndex)
            end
        else
            AddBefore(hero.itemInformationTable, M.ExpandTeamThinkItem "item_arcane_boots", AddArcaneBootsBefore)
        end
        PrintItemInfoTableOf(hero)
    end
    local function DontBuyArcaneBoots(heroRateTable)
        local hero = heroRateTable[1]
        local arcaneBootsIndex = A.Linq.IndexOf(hero.itemInformationTable, function(t)
            return t.name == "item_arcane_boots"
        end)
        if arcaneBootsIndex ~= -1 and not hero.itemInformationTable[arcaneBootsIndex].usedAsRecipeOf then
            local rd = math.random()
            local replaceBoots = (function()
                if rd <= 0.666667 then
                    return "item_power_treads"
                else
                    return "item_phase_boots"
                end
            end)()
            if heroRateTable[2] >= 6.65 and rd <= 0.22 then
                replaceBoots = "item_tranquil_boots"
            end
            NotifyTeam(hero, replaceBoots)
            local newBoots = M.ExpandTeamThinkItem(replaceBoots)
            RemoveItemsInNewItemTable(hero.itemInformationTable, newBoots, arcaneBootsIndex)
        end
        PrintItemInfoTableOf(hero)
    end
    local teamArcaneBootsNumber = (function()
        if #heroRates >= 4 then
            return 2
        elseif #heroRates >= 2 then
            return 1
        else
            return 0
        end
    end)()
    local buyArcaneBootsHeroIndex = 0
    if teamArcaneBootsNumber >= 1 then
        local hero = heroRates[1][1]
        BuyArcaneBoots(hero)
        buyArcaneBootsHeroIndex = buyArcaneBootsHeroIndex + 1
    end
    teamArcaneBootsNumber = teamArcaneBootsNumber - 1
    local function HighDesireOfBuyingArcaneBoots(heroRateTable)
        return heroRateTable[2] >= 7.55
    end
    if teamArcaneBootsNumber >= 1 then
        heroRates:Skip(buyArcaneBootsHeroIndex):Take(teamArcaneBootsNumber):Filter(HighDesireOfBuyingArcaneBoots):Map(function(t)
            return t[1]
        end):ForEach(function(t)
            BuyArcaneBoots(t)
            buyArcaneBootsHeroIndex = buyArcaneBootsHeroIndex + 1
        end)
    end
    heroRates:Skip(buyArcaneBootsHeroIndex):FilterNot(HighDesireOfBuyingArcaneBoots):ForEach(DontBuyArcaneBoots)
end
>>>>>>> fb1118d0d0092b991ad855021d58837357d90b5a
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
local function CheckInvisibleEnemy()
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
            if npcBot:GetGold() >= GetItemCost("item_dust") then
                npcBot:ActionImmediate_PurchaseItem("item_dust")
                if DotaTime() >= 8 * 60 and npcBot:GetGold() >= GetItemCost("item_dust") * 2 then
                    npcBot:ActionImmediate_PurchaseItem("item_dust")
                end
                npcBot:ActionImmediate_Chat("Buying dusts", false)
            end
        end
    end
end)
M.CheckInvisibleEnemy = CheckInvisibleEnemy
M.dustAoeRadius = 1050
M.dustDuration = 12
local dustTargets = fun1:NewTable()
local function UseDustThink()
    local enemies = fun1:GetPureHeroes(npcBot, M.dustAoeRadius)
    local invisibleEnemies = enemies:Filter(function(t)
        return fun1:HasAnyModifier(fun1.invisibleModifiers, t)
    end):Filter(function(t)
        return not fun1:HasAnyModifier(fun1.truesightModifiers) and fun1:GetPureHeroes(t, 800, true):All(function(t1)
            return not fun1:GetAvailableItem(t1, "item_gem")
        end)
    end)
    invisibleEnemies:Filter(function(t)
        return not dustTargets:Contains(t)
    end):ForEach(function(t)
        return dustTargets:InsertAfter_Modify(t)
    end)
    do
        local dust = fun1:GetAvailableItem(npcBot, "item_dust")
        if dust then
            local targets = dustTargets:Filter(function(t)
                return GetUnitToUnitDistance(npcBot, t) <= M.dustAoeRadius + t:GetBoundingRadius()
            end)
            if #targets > 0 and not npcBot:IsMuted() then
                ItemUsage.UseItemNoTarget(npcBot, dust)
                targets:ForEach(function(t)
                    return dustTargets:Remove_Modify(t)
                end)
            end
        end
    end
end
function M.Think()
    if fun1:GameNotReallyStarting() then
        return
    end
    npcBot = GetBot()
    TeamItemInit()
    TeamItemEventThink()
    TeamStateThink()
    BuyDustIfInvisibleEnemies()
    UseDustThink()
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
            AddArcaneBoots()
            AddMekansm()
        end
    end)
end
return M
