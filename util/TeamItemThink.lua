---------------------------------------------
-- Generated from Mirana Compiler version 1.5.1
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
    setmetatable(it, heroItemMetatable)
end)
local zeroTable = {}
setmetatable(zeroTable, { __index = function()
    return 0
end })
<<<<<<< HEAD
setmetatable(roles, zeroTable)
local humanPlayers = {}
local teamMembers = {}
local function InitHumanPlayers()
    humanPlayers = fun1:Range(1, 5):Filter(function(it)
        return not GetTeamMember(it):IsBot()
    end)
end
local function AddMekansm()
    local function AddMekansmAfter(itemName)
        if itemName == "item_glimmer_cape" then
            return true
        end
        return GetItemCost(itemName) < 2000 or string.match(itemName, "boots") or itemName == "item_hand_of_midas" or itemName == "item_bfury"
=======
setmetatable(roles, { __index = function(heroName)    
    print(heroName.." doesn't exist in table roles")
    return zeroTable
end })
local humanPlayers
local finishInit
local runned
local function Init()
    if finishInit then
        return
    else
        finishInit = true
    end
    humanPlayers = fun1:Range(1, 5):Filter(function(it)
        return not GetTeamMember(it):IsBot()
    end)
end
local teamMembers = {}
local function AddBefore(tb, item, before)
    if type(before) ~= "function" then
        before = function(t) return t == before end
>>>>>>> p
    end
    for index, v in ipairs(tb) do
        if not before(item) then
            table.insert(tb, index, item)
            return
        end
    end
    table.insert(tb, 1, item)
end
local function GenerateFilter(maxCost, putBefore, putAfter)
    return function(itemName)        
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
        table.insert(teamItemEvents, {
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
    local AddMekansmAfter = GenerateFilter(2000, {
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
        if hero:GetPrimaryAttribute() == ATTRIBUTE_INTELLECT then
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
<<<<<<< HEAD
        print(hero:GetUnitName().." will buy mekansm")
        hero.itemInformationTable_Pre:InsertAfter_Modify("item_mekansm", AddMekansmAfter)
=======
        NotifyTeam(hero, "mekansm")
        AddBefore(hero.itemInformationTable_Pre, "item_mekansm", AddMekansmAfter)
>>>>>>> p
        hero.itemInformationTable_Pre:Remove_Modify("item_urn_of_shadows")
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
<<<<<<< HEAD
local addOnce
local function AddAllItems()
    if addOnce then
        return
    else
        addOnce = true
    end
    AddMekansm()
end
function M.Think(npcBot)
=======
function M.Think()
    TeamItemEventThink()
end
function M.TeamItemThink(npcBot)
>>>>>>> p
    if npcBot:IsIllusion() then
        return
    end
    if not fun1:Contains(teamMembers, npcBot) then
        if npcBot.teamItemEvents == nil then
            npcBot.teamItemEvents = fun1:NewTable()
        end
        table.insert(teamMembers, npcBot)
    end
    fun1:StartCoroutine(function()
<<<<<<< HEAD
        while DotaTime() <= -70 do
            coroutine.yield()
        end
        InitHumanPlayers()
        if #teamMembers + #humanPlayers == 5 then
            AddAllItems()
=======
        while DotaTime() <= -80 do
            coroutine.yield()
        end
        Init()
        if #teamMembers + #humanPlayers == 5 then
            if runned then
                return
            else
                runned = true
            end
            AddMekansm()
>>>>>>> p
        end
    end)
    return "reset", teamMembers
end
return M
