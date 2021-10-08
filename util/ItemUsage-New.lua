---------------------------------------------
-- Generated from Mirana Compiler version 1.6.1
-- Do not modify
-- https://github.com/AaronSong321/Mirana
---------------------------------------------
local M = {}
local fun1 = require(GetScriptDirectory().."/util/AbilityAbstraction")
local BotsInit = require("game/botsinit")
local role = require(GetScriptDirectory().."/util/RoleUtility")
local A = require(GetScriptDirectory().."/util/MiraDota")
local function IsItemAvailable(item_name)
    return fun1:GetAvailableItem(GetBot(), item_name)
end
local function GetItemIfNotImplemented(itemName)
    do
        local item = IsItemAvailable(itemName)
        if item then
            do
                local itemTable = GetBot().itemUsage
                if itemTable then
                    do
                        local f = itemTable[itemName]
                        if f then
                            f()
                        end
                    end
                end
            end
            return item
        end
    end
end
local function GetItemCount(unit, item_name)
    local count = 0
    for i = 0, 8 do
        local item = unit:GetItemInSlot(i)
        if item ~= nil and item:GetName() == item_name then
            count = count + 1
        end
    end
    return count
end
local function GetItemCharges(unit, item_name)
    local count = 0
    for i = 0, 8 do
        local item = unit:GetItemInSlot(i)
        if item ~= nil and item:GetName() == item_name then
            count = count + item:GetCurrentCharges()
        end
    end
    return count
end
local function CanSwitchPTStat(pt)
    local npcBot = GetBot()
    if npcBot:GetPrimaryAttribute() == ATTRIBUTE_STRENGTH and pt:GetPowerTreadsStat() ~= ATTRIBUTE_STRENGTH then
        return true
    elseif npcBot:GetPrimaryAttribute() == ATTRIBUTE_AGILITY and pt:GetPowerTreadsStat() ~= ATTRIBUTE_INTELLECT then
        return true
    elseif npcBot:GetPrimaryAttribute() == ATTRIBUTE_INTELLECT and pt:GetPowerTreadsStat() ~= ATTRIBUTE_AGILITY then
        return true
    end
    return false
end
local function IsStuck(npcBot)
    if npcBot.stuckLoc ~= nil and npcBot.stuckTime ~= nil then
        local attackTarget = npcBot:GetAttackTarget()
        local EAd = GetUnitToUnitDistance(npcBot, GetAncient(GetOpposingTeam()))
        local TAd = GetUnitToUnitDistance(npcBot, GetAncient(GetTeam()))
        local Et = npcBot:GetNearbyTowers(450, true)
        local At = npcBot:GetNearbyTowers(450, false)
        if npcBot:GetCurrentActionType() == BOT_ACTION_TYPE_MOVE_TO and attackTarget == nil and EAd > 2200 and TAd > 2200 and #Et == 0 and #At == 0 and DotaTime() > npcBot.stuckTime + 5.0 and GetUnitToLocationDistance(npcBot, npcBot.stuckLoc) < 25 then
            print(npcBot:GetUnitName().." is stuck")
            return true
        end
    end
    return false
end
local myTeam = GetTeam()
local opTeam = GetOpposingTeam()
local function GetLaningTPLocation(nLane)
    local teamT1Top = GetTower(myTeam, TOWER_TOP_1)
    local teamT1Mid = GetTower(myTeam, TOWER_MID_1)
    local teamT1Bot = GetTower(myTeam, TOWER_BOT_1)
    if nLane == LANE_TOP and teamT1Top ~= nil then
        return teamT1Top:GetLocation()
    elseif nLane == LANE_MID and teamT1Mid ~= nil then
        return teamT1Mid:GetLocation()
    elseif nLane == LANE_BOT and teamT1Bot ~= nil then
        return teamT1Bot:GetLocation()
    end
    return Vector(0.000000, 0.000000, 0.000000)
end
local function GetDefendTPLocation(nLane)
    return GetLaneFrontLocation(opTeam, nLane, -1600)
end
local function GetPushTPLocation(nLane)
    return GetLaneFrontLocation(myTeam, nLane, 0)
end
local idlt = 0
local idlm = 0
local idlb = 0
local function printDefendLaneDesire()
    local npcBot = GetBot()
    local md = npcBot:GetActiveMode()
    local mdd = npcBot:GetActiveModeDesire()
    local dlt = GetDefendLaneDesire(LANE_TOP)
    local dlm = GetDefendLaneDesire(LANE_MID)
    local dlb = GetDefendLaneDesire(LANE_BOT)
    if npcBot:GetPlayerID() == 2 then
        if idlt ~= dlt then
            idlt = dlt
            print("DefendLaneDesire TOP: "..tostring(dlt))
        elseif idlm ~= dlm then
            idlm = dlm
            print("DefendLaneDesire MID: "..tostring(dlm))
        elseif idlb ~= dlb then
            idlb = dlb
            print("DefendLaneDesire TOP: "..tostring(dlb))
        end
        if md == BOT_MODE_DEFEND_TOWER_TOP then
            print("Def Tower Des TOP: "..tostring(mdd))
        elseif md == BOT_MODE_DEFEND_TOWER_MID then
            print("Def Tower Des MID: "..tostring(mdd))
        elseif md == BOT_MODE_DEFEND_TOWER_BOT then
            print("Def Tower Des npcBot: "..tostring(mdd))
        end
    end
end
local tpThreshold = 4500
local function ShouldTP()
    local npcBot = GetBot()
    local tpLoc = nil
    local mode = npcBot:GetActiveMode()
    local modDesire = npcBot:GetActiveModeDesire()
    local botLoc = npcBot:GetLocation()
    local enemies = npcBot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    if mode == BOT_MODE_LANING and #enemies == 0 then
        local assignedLane = npcBot:GetAssignedLane()
        if assignedLane == LANE_TOP then
            local botAmount = GetAmountAlongLane(LANE_TOP, botLoc)
            local laneFront = GetLaneFrontAmount(myTeam, LANE_TOP, false)
            if botAmount.distance > tpThreshold or botAmount.amount < laneFront / 5 then
                tpLoc = GetLaningTPLocation(LANE_TOP)
            end
        elseif assignedLane == LANE_MID then
            local botAmount = GetAmountAlongLane(LANE_MID, botLoc)
            local laneFront = GetLaneFrontAmount(myTeam, LANE_MID, false)
            if botAmount.distance > tpThreshold or botAmount.amount < laneFront / 5 then
                tpLoc = GetLaningTPLocation(LANE_MID)
            end
        elseif assignedLane == LANE_BOT then
            local botAmount = GetAmountAlongLane(LANE_BOT, botLoc)
            local laneFront = GetLaneFrontAmount(myTeam, LANE_BOT, false)
            if botAmount.distance > tpThreshold or botAmount.amount < laneFront / 5 then
                tpLoc = GetLaningTPLocation(LANE_BOT)
            end
        end
    elseif mode == BOT_MODE_DEFEND_TOWER_TOP and modDesire >= BOT_MODE_DESIRE_MODERATE and #enemies == 0 then
        local botAmount = GetAmountAlongLane(LANE_TOP, botLoc)
        local laneFront = GetLaneFrontAmount(myTeam, LANE_TOP, false)
        if botAmount.distance > tpThreshold or botAmount.amount < laneFront / 5 then
            tpLoc = GetDefendTPLocation(LANE_TOP)
        end
    elseif mode == BOT_MODE_DEFEND_TOWER_MID and modDesire >= BOT_MODE_DESIRE_MODERATE and #enemies == 0 then
        local botAmount = GetAmountAlongLane(LANE_MID, botLoc)
        local laneFront = GetLaneFrontAmount(myTeam, LANE_MID, false)
        if botAmount.distance > tpThreshold or botAmount.amount < laneFront / 5 then
            tpLoc = GetDefendTPLocation(LANE_MID)
        end
    elseif mode == BOT_MODE_DEFEND_TOWER_BOT and modDesire >= BOT_MODE_DESIRE_MODERATE and #enemies == 0 then
        local botAmount = GetAmountAlongLane(LANE_BOT, botLoc)
        local laneFront = GetLaneFrontAmount(myTeam, LANE_BOT, false)
        if botAmount.distance > tpThreshold or botAmount.amount < laneFront / 5 then
            tpLoc = GetDefendTPLocation(LANE_BOT)
        end
    elseif mode == BOT_MODE_PUSH_TOWER_TOP and modDesire >= BOT_MODE_DESIRE_MODERATE and #enemies == 0 then
        local botAmount = GetAmountAlongLane(LANE_TOP, botLoc)
        local laneFront = GetLaneFrontAmount(myTeam, LANE_TOP, false)
        if botAmount.distance > tpThreshold or botAmount.amount < laneFront / 5 then
            tpLoc = GetPushTPLocation(LANE_TOP)
        end
    elseif mode == BOT_MODE_PUSH_TOWER_MID and modDesire >= BOT_MODE_DESIRE_MODERATE and #enemies == 0 then
        local botAmount = GetAmountAlongLane(LANE_MID, botLoc)
        local laneFront = GetLaneFrontAmount(myTeam, LANE_MID, false)
        if botAmount.distance > tpThreshold or botAmount.amount < laneFront / 5 then
            tpLoc = GetPushTPLocation(LANE_MID)
        end
    elseif mode == BOT_MODE_PUSH_TOWER_BOT and modDesire >= BOT_MODE_DESIRE_MODERATE and #enemies == 0 then
        local botAmount = GetAmountAlongLane(LANE_BOT, botLoc)
        local laneFront = GetLaneFrontAmount(myTeam, LANE_BOT, false)
        if botAmount.distance > tpThreshold or botAmount.amount < laneFront / 5 then
            tpLoc = GetPushTPLocation(LANE_BOT)
        end
    elseif mode == BOT_MODE_DEFEND_ALLY and modDesire >= BOT_MODE_DESIRE_MODERATE and role.CanBeSupport(npcBot:GetUnitName()) == true and #enemies == 0 then
        local target = npcBot:GetTarget()
        if target ~= nil and target:IsHero() then
            local nearbyTower = target:GetNearbyTowers(1300, true)
            if nearbyTower ~= nil and #nearbyTower > 0 and npcBot:GetMana() > 0.25 * npcBot:GetMaxMana() then
                tpLoc = nearbyTower[1]:GetLocation()
            end
        end
    elseif mode == BOT_MODE_RETREAT then
        tpLoc = nil
    elseif IsStuck(npcBot) and #enemies == 0 then
        npcBot:ActionImmediate_Chat("I'm using tp while stuck.", true)
        tpLoc = GetAncient(GetTeam()):GetLocation()
    end
    if tpLoc ~= nil then
        return true, tpLoc
    end
    return false, nil
end
function M.UseItemNoTarget(npc, item)
    npc:Action_UseAbility(item)
end
function M.UseItemOnEntity(npc, item, entity)
    npc:Action_UseAbilityOnEntity(item, entity)
end
function M.UseItemOnLocation(npc, item, loc)
    npc:Action_UseAbilityOnLocation(item, loc)
end
function M.UseItemOnTree(npc, item, tree)
    npc:Action_UseAbilityOnTree(item, tree)
end
local CannotFade = function(t)
    if t:HasModifier "modifier_item_dustofappearance" or t:HasModifier "modifier_truesight" or t:HasModifier "modifier_bounty_hunter_track" or t:HasModifier "modifier_slardar_amplify_damage" then
        return true
    end
    return false
end
local DontUseItemIfBreakInvisibility = function(t)
    return t:IsInvisible() and (not CannotFade(t) or not t:UsingItemBreaksInvisibility())
end
local giveTime = -90
function M.ItemUsageThink()
    local npcBot = GetBot()
    if npcBot:IsChanneling() or npcBot:IsUsingAbility() or DontUseItemIfBreakInvisibility(npcBot) or npcBot:IsMuted() then
        return
    end
    local notBlasted = not npcBot:HasModifier("modifier_ice_blast")
    local tableNearbyEnemyHeroes = fun1:GetNearbyNonIllusionHeroes(npcBot, 800)
    local nearByTowers = npcBot:GetNearbyTowers(1000, true)
    local npcTarget = npcBot:GetTarget()
    local nearbyAllies = fun1:GetNearbyNonIllusionHeroes(npcBot, 900, false)
    local mode = npcBot:GetActiveMode()
    local healthPercent = fun1:GetHealthPercent(npcBot)
    local manaPercent = fun1:GetManaPercent(npcBot)
    local tps = npcBot:GetItemInSlot(15)
    if tps ~= nil and tps:IsFullyCastable() then
        local tpLoc
        local shouldTP
        shouldTP, tpLoc = ShouldTP()
        if shouldTP then
            M.UseItemOnLocation(npcBot, tps, tpLoc)
            return
        end
    end
    local function GetWantedPowerTreadsAttribute()
        if mode == BOT_MODE_RETREAT and npcBot:WasRecentlyDamagedByAnyHero(3) then
            return ATTRIBUTE_STRENGTH
        elseif fun1:IsAttackingEnemies(npcBot) then
            local name = npcBot:GetUnitName()
            name = fun1:GetHeroShortName(name)
            if fun1:Contains({
                "obsidian_destroyer",
                "silencer",
                "huskar",
                "drow_ranger",
            }, name) then
                return npcBot:GetPrimaryAttribute()
            else
                return ATTRIBUTE_AGILITY
            end
        elseif mode == BOT_MODE_LANING then
            return npcBot:GetPrimaryAttribute()
        else
            return npcBot:GetPrimaryAttribute()
        end
    end
    local function UsePowerTreads(treads)
        if math.floor(DotaTime()) / 4 ~= 0 then
            return
        end
        if npcBot:IsInvisible() and npcBot:UsingItemBreaksInvisibility() then
            if npcBot:HasModifier("modifier_item_dustofappearance") then
                M.UseItemNoTarget(npcBot, treads)
                return true
            end
            return
        end
        if GetWantedPowerTreadsAttribute() ~= treads:GetPowerTreadsStat() then
            M.UseItemNoTarget(npcBot, treads)
            return true
        end
    end
    local pt = GetItemIfNotImplemented("item_power_treads")
    if pt ~= nil and pt:IsFullyCastable() and notBlasted then
        if UsePowerTreads(pt) then
            return
        end
    end
    local its = GetItemIfNotImplemented("item_tango_single")
    local tango
    if its ~= nil then
        tango = its
    elseif itg ~= nil then
        tango = itg
    end
    if tango ~= nil and tango:IsFullyCastable() and npcBot:DistanceFromFountain() > 1000 then
        if DotaTime() > 0 and not npcBot:HasModifier("modifier_tango_heal") then
            local trees = npcBot:GetNearbyTrees(1000)
            if trees[1] ~= nil and healthPercent < 0.7 and (IsLocationVisible(GetTreeLocation(trees[1])) or IsLocationPassable(GetTreeLocation(trees[1]))) and #tableNearbyEnemyHeroes == 0 and #nearByTowers == 0 then
                M.UseItemOnTree(npcBot, tango, trees[1])
                return
            end
        end
    end
    local ifl = GetItemIfNotImplemented("item_flask")
    if ifl ~= nil and ifl:IsFullyCastable() and npcBot:DistanceFromFountain() > 1000 then
        local tableNearbyEnemyHeroes2 = #npcBot:GetNearbyHeroes(750, true, BOT_MODE_NONE) ~= 0
        if DotaTime() > 0 then
            if healthPercent < 0.35 and not npcBot:WasRecentlyDamagedByAnyHero(1.5) then
                M.UseItemOnEntity(npcBot, ifl, npcBot)
                return
            end
            do
                local weakestAlly = nearbyAllies:Filter(function(it)
                    return fun1:GetHealthPercent(it) < 0.25 and not it:WasRecentlyDamagedByAnyHero(1.5) and it:GetActiveMode() ~= BOT_MODE_RETREAT and (tableNearbyEnemyHeroes2 or it:HasModifier "modifier_templar_assassin_reflection_absorb" or fun1:HasAnyModifier(it, fun1.IgnoreDamageModifiers))
                end):SortByMinFirst(function(it)
                    return it:GetHealth()
                end):First()
                if weakestAlly then
                    M.UseItemOnEntity(npcBot, weakestAlly, npcBot)
                    return
                end
            end
        end
    end
    local icl = GetItemIfNotImplemented("item_clarity")
    if icl ~= nil and icl:IsFullyCastable() and npcBot:DistanceFromFountain() > 1000 then
        local tableNearbyEnemyHeroes2 = #npcBot:GetNearbyHeroes(650, true, BOT_MODE_NONE) ~= 0
        if DotaTime() > 0 then
            if (manaPercent) < 0.35 then
                M.UseItemOnEntity(npcBot, icl, npcBot)
                return
            end
            do
                local weakestAlly = nearbyAllies:Filter(function(it)
                    return fun1:GetManaPercent(it) < 0.4 and not it:WasRecentlyDamagedByAnyHero(3) and it:GetActiveMode() ~= BOT_MODE_RETREAT and (tableNearbyEnemyHeroes2 or it:HasModifier "modifier_templar_assassin_reflection_absorb" or fun1:HasAnyModifier(it, fun1.IgnoreDamageModifiers))
                end):SortByMinFirst(function(it)
                    return it:GetMana()
                end):First()
                if weakestAlly then
                    M.UseItemOnEntity(npcBot, weakestAlly, npcBot)
                    return
                end
            end
        end
    end
    local itemQuellingBlade = GetItemIfNotImplemented("item_quelling_blade") or GetItemIfNotImplemented("item_bfury")
    if itemQuellingBlade ~= nil and itemQuellingBlade:IsFullyCastable() then
        local trees = npcBot:GetNearbyTrees(250)
        if #trees >= 6 and fun1:Contains(npcBot:GetNearbyHeroes(900, true, BOT_MODE_NONE), function(t)
            return t:GetUnitName() == "npc_dota_hero_furion"
        end) then
            M.UseItemOnTree(npcBot, itemQuellingBlade, trees[1])
            return
        end
    end
    local msh = GetItemIfNotImplemented("item_moon_shard")
    if msh ~= nil and msh:IsFullyCastable() then
        if not npcBot:HasModifier("modifier_item_moon_shard_consumed") then
            print("use Moon")
            M.UseItemOnEntity(npcBot, msh, npcBot)
            return
        end
    end
    local mg = GetItemIfNotImplemented("item_enchanted_mango")
    if mg ~= nil and mg:IsFullyCastable() then
        if npcBot:GetMana() < 100 then
            M.UseItemNoTarget(npcBot, mg)
            return
        end
    end
    local tok = GetItemIfNotImplemented("item_tome_of_knowledge")
    if tok ~= nil and tok:IsFullyCastable() then
        M.UseItemNoTarget(npcBot, tok)
        return
    end
    local ff = GetItemIfNotImplemented("item_faerie_fire")
    if ff ~= nil and ff:IsFullyCastable() and notBlasted then
        if npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH and healthPercent < 0.15 and npcBot:WasRecentlyDamagedByAnyHero(3) then
            M.UseItemNoTarget(npcBot, ff)
            return
        end
    end
    local noDust = not fun1:GetNearbyNonIllusionHeroes(npcBot, 1100):Any(function(t)
        return fun1:GetCarriedItems(t):Any(function(t)
            return t:GetName() == "item_dust" or t:GetName() == "item_gem"
        end)
    end)
    local shadowAmulet = GetItemIfNotImplemented("item_shadow_amulet")
    if shadowAmulet and shadowAmulet:IsFullyCastable() then
        do
            local ally = fun1:GetNearbyNonIllusionHeroes(npcBot, shadowAmulet:GetCastRange() + 200, false):First(function(t)
                return t:IsChanneling() and not CannotFade(t)
            end)
            if ally then
                M.UseItemOnEntity(npcBot, shadowAmulet, ally)
            end
        end
    end
    local sr = GetItemIfNotImplemented("item_soul_ring")
    if sr ~= nil and sr:IsFullyCastable() and notBlasted then
        if npcBot:GetActiveMode() == BOT_MODE_LANING and fun1:IsFarmingOrPushing(npcBot) then
            if healthPercent > 0.7 and manaPercent < 0.4 then
                M.UseItemNoTarget(npcBot, sr)
                return
            end
        end
    end
    local bst = GetItemIfNotImplemented("item_bloodstone")
    if bst ~= nil and bst:IsFullyCastable() and notBlasted then
        if npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH and healthPercent < 0.3 then
            M.UseItemOnLocation(npcBot, bst, npcBot:GetLocation())
            return
        end
    end
    local pb = GetItemIfNotImplemented("item_phase_boots")
    if pb ~= nil and pb:IsFullyCastable() then
        if (npcBot:GetActiveMode() == BOT_MODE_ATTACK or npcBot:GetActiveMode() == BOT_MODE_RETREAT or npcBot:GetActiveMode() == BOT_MODE_ROAM or npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or npcBot:GetActiveMode() == BOT_MODE_GANK or npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY) and not fun1:IsSeverelyDisabled(npcBot) then
            M.UseItemNoTarget(npcBot, pb)
            return
        end
    end
    local bt = GetItemIfNotImplemented("item_bloodthorn")
    if bt ~= nil and bt:IsFullyCastable() then
        if npcBot:GetActiveMode() == BOT_MODE_ATTACK or npcBot:GetActiveMode() == BOT_MODE_ROAM or npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or npcBot:GetActiveMode() == BOT_MODE_GANK or npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY then
            if npcTarget ~= nil and npcTarget:IsHero() and fun1:NormalCanCast(npcTarget) and GetUnitToUnitDistance(npcTarget, npcBot) < 900 then
                M.UseItemOnEntity(npcBot, bt, npcTarget)
                return
            end
        end
    end
    local sc = GetItemIfNotImplemented("item_solar_crest") or GetItemIfNotImplemented("item_medallion_of_courage")
    if sc ~= nil and sc:IsFullyCastable() then
        if npcBot:GetActiveMode() == BOT_MODE_ROSHAN then
            local target = npcBot:GetTarget()
            if fun1:IsRoshan(target) then
                M.UseItemOnEntity(npcBot, sc, target)
                return
            end
        end
        do
            local ally = nearbyAllies:Filter(fun1.PhysicalCanCastFunction):Filter(function(t)
                return not t:HasModifier("modifier_item_medallion_of_courage_armor_addition") and not t:HasModifier("modifier_item_solar_crest_armor_addition")
            end):First(function(t)
                return fun1:IsSeverelyDisabledOrSlowed(t)
            end)
            if ally then
                M.UseItemOnEntity(npcBot, sc, ally)
                return
            end
        end
        if npcBot:GetActiveMode() == BOT_MODE_ATTACK or npcBot:GetActiveMode() == BOT_MODE_ROAM or npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or npcBot:GetActiveMode() == BOT_MODE_GANK or npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY then
            if npcTarget ~= nil and npcTarget:IsHero() and GetUnitToUnitDistance(npcTarget, npcBot) < 900 and not npcTarget:HasModifier("modifier_item_medallion_of_courage_armor_addition") and not npcTarget:HasModifier("modifier_item_medallion_of_courage_armor_reduction") then
                M.UseItemOnEntity(npcBot, sc, npcTarget)
                return
            end
        end
        do
            local ally = nearbyAllies:Filter(function(it)
                return (fun1:GetHealthPercent(it) < 0.35 and #tableNearbyEnemyHeroes > 0 or fun1:IsSeverelyDisabled(it)) and fun1:AllyCanCast(it)
            end)
            if ally then
                M.UseItemOnEntity(npcBot, sc, Ally)
                return
            end
        end
    end
    local se = GetItemIfNotImplemented("item_silver_edge") or IsItemAvailable "item_invis_sword"
    if se ~= nil and se:IsFullyCastable() then
        if npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH and tableNearbyEnemyHeroes ~= nil and #tableNearbyEnemyHeroes > 0 then
            M.UseItemNoTarget(npcBot, se)
            return
        end
        if npcBot:GetActiveMode() == BOT_MODE_ROAM or npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or npcBot:GetActiveMode() == BOT_MODE_GANK then
            if npcTarget and fun1:MayNotBeIllusion(npcBot, npcTarget) and npcTarget:IsHero() and GetUnitToUnitDistance(npcTarget, npcBot) > 1000 and GetUnitToUnitDistance(npcTarget, npcBot) < 2500 then
                M.UseItemNoTarget(npcBot, se)
                return
            end
        end
    end
    local hood = GetItemIfNotImplemented("item_hood_of_defiance") or GetItemIfNotImplemented("item_pipe")
    if hood ~= nil and hood:IsFullyCastable() and healthPercent < 0.8 then
        if tableNearbyEnemyHeroes ~= nil and #tableNearbyEnemyHeroes > 0 then
            M.UseItemNoTarget(npcBot, hood)
            return
        end
    end
    local lotus = GetItemIfNotImplemented("item_lotus_orb")
    if lotus ~= nil and lotus:IsFullyCastable() then
        if (healthPercent < 0.45 and tableNearbyEnemyHeroes ~= nil and #tableNearbyEnemyHeroes > 0) or npcBot:IsSilenced() or (tableNearbyEnemyHeroes ~= nil and #tableNearbyEnemyHeroes >= 3 and healthPercent < 0.75) then
            M.UseItemOnEntity(npcBot, lotus, npcBot)
            return
        end
    end
    if lotus ~= nil and lotus:IsFullyCastable() then
        local Allies = npcBot:GetNearbyHeroes(1000, false, BOT_MODE_NONE)
        for _, Ally in pairs(Allies) do
            if (Ally:GetHealth() / Ally:GetMaxHealth() < 0.35 and tableNearbyEnemyHeroes ~= nil and #tableNearbyEnemyHeroes > 0) or fun1:IsOrGoingToBeSeverelyDisabled(Ally) then
                M.UseItemOnEntity(npcBot, lotus, Ally)
                return
            end
        end
    end
    local hurricanpike = GetItemIfNotImplemented("item_hurricane_pike")
    if hurricanpike ~= nil and hurricanpike:IsFullyCastable() then
        if npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH then
            for _, npcEnemy in pairs(tableNearbyEnemyHeroes) do
                if GetUnitToUnitDistance(npcEnemy, npcBot) < 400 and fun1:NormalCanCast(npcEnemy) then
                    M.UseItemOnEntity(npcBot, hurricanpike, npcEnemy)
                    return
                end
            end
            if npcBot:IsFacingLocation(GetAncient(GetTeam()):GetLocation(), 10) and npcBot:DistanceFromFountain() > 0 then
                M.UseItemOnEntity(npcBot, hurricanpike, npcBot)
                return
            end
        end
    end
    local ghost = GetItemIfNotImplemented("item_ghost")
    if ghost and ghost:IsFullyCastable() then
        if npcBot:GetActiveMode() == BOT_MODE_ATTACK or npcBot:GetActiveMode() == BOT_MODE_RETREAT then
            if npcBot:WasRecentlyDamagedByAnyHero(2.0) and npcBot:GetHealth() / npcBot:GetMaxHealth() <= 0.6 then
                M.UseItemNoTarget(npcBot, ghost)
                return
            end
        end
    end
    local itemEtherealBlade = GetItemIfNotImplemented("item_ethereal_blade")
    if itemEtherealBlade and itemEtherealBlade:IsFullyCastable() then
        if npcTarget ~= nil and fun1:NormalCanCast(npcTarget) then
            M.UseItemOnEntity(npcBot, itemEtherealBlade, npcBot)
            return
        end
    end
    local itemDagon = fun1:Aggregate(GetItemIfNotImplemented("item_dagon"), fun1:Range(2, 5), function(seed, dagonLevelIndex)
        return seed or GetItemIfNotImplemented("item_dagon_"..dagonLevelIndex)
    end)
    if itemDagon and itemDagon:IsFullyCastable() then
        if npcTarget ~= nil and fun1:NormalCanCast(npcTarget) then
            M.UseItemOnEntity(npcBot, itemDagon, npcBot)
            return
        end
    end
    local glimmer = GetItemIfNotImplemented("item_glimmer_cape")
    if glimmer and glimmer:IsFullyCastable() then
        if (healthPercent < 0.45 and (tableNearbyEnemyHeroes ~= nil and #tableNearbyEnemyHeroes > 0)) or (tableNearbyEnemyHeroes ~= nil and #tableNearbyEnemyHeroes >= 3 and healthPercent < 0.65) then
            M.UseItemOnEntity(npcBot, glimmer, npcBot)
            return
        end
    end
    local hod = GetItemIfNotImplemented("item_helm_of_the_overlord") or GetItemIfNotImplemented("item_helm_of_the_dominator")
    if hod ~= nil and hod:IsFullyCastable() then
        local maxHP = 0
        local NCreep = nil
        local tableNearbyCreeps = npcBot:GetNearbyCreeps(1000, true)
        if #tableNearbyCreeps >= 2 then
            for _, creeps in pairs(tableNearbyCreeps) do
                local CreepHP = creeps:GetHealth()
                if CreepHP > maxHP and (creeps:GetHealth() / creeps:GetMaxHealth()) > .75 and not creeps:IsAncientCreep() then
                    NCreep = creeps
                    maxHP = CreepHP
                end
            end
        end
        if NCreep ~= nil then
            M.UseItemOnEntity(npcBot, hod, NCreep)
            return
        end
    end
    if glimer ~= nil and glimer:IsFullyCastable() then
        local Allies = npcBot:GetNearbyHeroes(1000, false, BOT_MODE_NONE)
        for _, Ally in pairs(Allies) do
            if (Ally:GetHealth() / Ally:GetMaxHealth() < 0.35 and tableNearbyEnemyHeroes ~= nil and #tableNearbyEnemyHeroes > 0 and fun1:NormalCanCast(Ally)) or (fun1:IsOrGoingToBeSeverelyDisabled(Ally) and fun1:NormalCanCast(Ally)) then
                M.UseItemOnEntity(npcBot, glimer, Ally)
                return
            end
        end
    end
    local satanic = GetItemIfNotImplemented("item_satanic")
    if satanic ~= nil and satanic:IsFullyCastable() and notBlasted then
        if healthPercent < 0.50 and tableNearbyEnemyHeroes ~= nil and #tableNearbyEnemyHeroes > 0 and npcBot:GetActiveMode() == BOT_MODE_ATTACK then
            M.UseItemNoTarget(npcBot, satanic)
            return
        end
    end
    local function NotSuitableForGuardianGreaves(t)
        return fun1:AllyCanCast(t) and not t:HasModifier("modifier_ice_blast") and not t:HasModifier("modifier_item_mekansm_noheal") and not t:HasModifier("modifier_item_guardian_greaves_noheal")
    end
    local mekansm = GetItemIfNotImplemented("item_mekansm")
    if mekansm and mekansm:IsFullyCastable() then
        local enemies = fun1:GetEnemyHeroNumber(npcBot, fun1:GetNearbyNonIllusionHeroes(npcBot))
        local function MekansmRate(t)
            local rate = 1
            if fun1:GetHealthPercent(t) < 0.35 or t:GetHealth() <= 360 then
                rate = rate + 0.6
            end
            if t:HasModifier "modifier_abaddon_borrowed_time" then
                rate = rate - 0.5
            end
            if t:GetHealthRegen() > 50 or fun1:GetLifeSteal(t) >= 0.15 then
                rate = rate * (function()
                    if enemies >= 1 then
                        return 0.5
                    else
                        return 0.9
                    end
                end)()
            end
            rate = rate * fun1:GetTargetHealAmplifyPercent(t)
            return rate
        end
        local radius = mekansm:GetAOERadius()
        local allAllys = fun1:GetPureHeroes(npcBot, 1450, false)
        local allys = fun1:GetPureHeroes(npcBot, radius, false):Filter(NotSuitableForGuardianGreaves):Filter(function(t)
            return t:GetHealth() < t:GetMaxHealth() - 450
        end)
        local rate = fun1:Aggregate(0, allys:Map(MekansmRate), function(opv_1, opv_2) return opv_1 + opv_2 end)
        if rate >= 2.6 and rate >= #allys * 1.1 then
            M.UseItemNoTarget(npcBot, mekansm)
            return
        end
        if fun1:IsRetreating(npcBot) and MekansmRate(npcBot) >= 1.6 then
            M.UseItemNoTarget(npcBot, mekansm)
            return
        end
    end
    local ggr = GetItemIfNotImplemented("item_guardian_greaves")
    if ggr ~= nil and ggr:IsFullyCastable() then
        local allys = npcBot:GetNearbyHeroes(900, false, BOT_MODE_NONE)
        allys = fun1:Filter(allys, NotSuitableForGuardianGreaves)
        local factor = 0
        for k, v in pairs(allys) do
            local allyFactor = (2 - v:GetMana() / v:GetMaxMana() - v:GetHealth() / v:GetMaxHealth()) * 0.5
            factor = factor + allyFactor
        end
        if factor / #allys > 0.5 - 0.2 * math.log(#allys) / math.log(6) then
            M.UseItemNoTarget(npcBot, ggr)
            return
        end
    end
    local stick = GetItemIfNotImplemented("item_magic_stick")
    if stick ~= nil and stick:IsFullyCastable() and stick:GetCurrentCharges() > 0 and notBlasted then
        if DotaTime() > 0 then
            local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes(500, true, BOT_MODE_NONE)
            if ((healthPercent < 0.4 or manaPercent < 0.2) and #tableNearbyEnemyHeroes >= 1 and GetItemCharges(npcBot, "item_magic_stick") >= 1) or ((healthPercent < 0.7 and manaPercent < 0.7) and GetItemCharges(npcBot, "item_magic_stick") >= 7) then
                M.UseItemNoTarget(npcBot, stick)
                return
            end
        end
    end
    local wand = GetItemIfNotImplemented("item_magic_wand")
    if wand ~= nil and wand:IsFullyCastable() and wand:GetCurrentCharges() > 0 and notBlasted then
        if DotaTime() > 0 then
            local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes(500, true, BOT_MODE_NONE)
            if ((healthPercent < 0.4 or manaPercent < 0.2) and #tableNearbyEnemyHeroes >= 1 and GetItemCharges(npcBot, "item_magic_wand") >= 1) or ((healthPercent < 0.7 and manaPercent < 0.7) and GetItemCharges(npcBot, "item_magic_wand") >= 12) then
                M.UseItemNoTarget(npcBot, wand)
                return
            end
        end
    end
    local holyLocket = GetItemIfNotImplemented("item_holy_locket")
    if holyLocket ~= nil and holyLocket:IsFullyCastable() and notBlasted then
        if DotaTime() > 0 then
            local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes(500, true, BOT_MODE_NONE)
            if ((healthPercent < 0.4 or manaPercent < 0.2) and #tableNearbyEnemyHeroes >= 1 and GetItemCharges(npcBot, "item_holy_locket") >= 1) or ((healthPercent < 0.7 and manaPercent < 0.7) and GetItemCharges(npcBot, "item_holy_locket") >= 12) then
                M.UseItemOnEntity(npcBot, wand, npcBot)
                return
            end
        end
    end
    local bottle = GetItemIfNotImplemented("item_bottle")
    if bottle ~= nil and bottle:IsFullyCastable() and notBlasted then
        local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes(650, true, BOT_MODE_NONE)
        if GetItemCharges(npcBot, "item_bottle") > 0 and not npcBot:HasModifier("modifier_bottle_regeneration") then
            if ((healthPercent < 0.65 and manaPercent < 0.45) or healthPercent < 0.4 or manaPercent < 0.2) and #tableNearbyEnemyHeroes == 0 then
                M.UseItemOnEntity(npcBot, bottle, npcBot)
                return
            end
        end
    end
    local cyclone = GetItemIfNotImplemented("item_cyclone") or GetItemIfNotImplemented("item_wind_waker")
    if cyclone ~= nil and cyclone:IsFullyCastable() then
        if npcTarget ~= nil and (npcTarget:IsChanneling() and not fun1:IsOrGoingToBeSeverelyDisabled(npcTarget) or fun1:CannotBeKilledNormally(npcTarget)) and fun1:NormalCanCast(npcTarget) and GetUnitToUnitDistance(npcBot, npcTarget) < 775 then
            M.UseItemOnEntity(npcBot, cyclone, npcTarget)
            return
        end
    end
    local metham = GetItemIfNotImplemented("item_meteor_hammer")
    if metham ~= nil and metham:IsFullyCastable() then
        local tableNearbyAttackingAlliedHeroes = npcBot:GetNearbyHeroes(1000, false, BOT_MODE_ATTACK)
        if npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT then
            local towers = npcBot:GetNearbyTowers(800, true)
            if #towers > 0 and towers[1] ~= nil and towers[1]:IsInvulnerable() == false then
                M.UseItemOnLocation(npcBot, metham, towers[1]:GetLocation())
                return
            end
        elseif #tableNearbyAttackingAlliedHeroes >= 2 then
            local locationAoE = npcBot:FindAoELocation(true, true, npcBot:GetLocation(), 600, 300, 0, 0)
            if locationAoE.count >= 2 then
                M.UseItemOnLocation(npcBot, metham, locationAoE.targetloc)
                return
            end
        elseif npcBot:GetActiveMode() == BOT_MODE_ROAM or npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or npcBot:GetActiveMode() == BOT_MODE_ATTACK then
            if npcTarget ~= nil and npcTarget:IsHero() and fun1:NormalCanCast(npcTarget) and GetUnitToUnitDistance(npcBot, npcTarget) < 800 and fun1:IsOrGoingToBeSeverelyDisabled(true, npcTarget) == true then
                M.UseItemOnLocation(npcBot, metham, npcTarget:GetLocation())
                return
            end
        end
    end
    local sv = GetItemIfNotImplemented("item_spirit_vessel")
    if sv ~= nil and sv:IsFullyCastable() and sv:GetCurrentCharges() > 0 then
        do
            local enemy = fun1:GetPureHeroes(npcBot, sv:GetCastRange() + 200):Filter(function(t)
                return fun1:NormalCanCast(t)
            end):First(function(t)
                return t:GetHealthRegen() >= 55
            end)
            if enemy then
                M.UseItemOnEntity(npcBot, sv, enemy)
            end
        end
        if npcBot:GetActiveMode() == BOT_MODE_ROAM or npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or npcBot:GetActiveMode() == BOT_MODE_ATTACK then
            if npcTarget ~= nil and npcTarget:IsHero() and fun1:MayNotBeIllusion(npcBot, npcTarget) and fun1:NormalCanCast(npcTarget) and GetUnitToUnitDistance(npcBot, npcTarget) < 900 and npcTarget:HasModifier("modifier_item_spirit_vessel_damage") == false and npcTarget:GetHealth() / npcTarget:GetMaxHealth() < 0.65 and not npcTarget:HasModifier("modifier_ice_blast") then
                M.UseItemOnEntity(npcBot, sv, npcTarget)
                return
            end
        else
            local Allies = npcBot:GetNearbyHeroes(1150, false, BOT_MODE_NONE)
            for _, Ally in pairs(Allies) do
                if not Ally:IsIllusion() and Ally:HasModifier("modifier_item_spirit_vessel_heal") == false and fun1:NormalCanCast(Ally) and Ally:GetHealth() / Ally:GetMaxHealth() < 0.35 and #tableNearbyEnemyHeroes == 0 and Ally:WasRecentlyDamagedByAnyHero(2.5) == false and not Ally:HasModifier("modifier_ice_blast") then
                    M.UseItemOnEntity(npcBot, sv, Ally)
                    return
                end
            end
        end
    end
    local nullifier = GetItemIfNotImplemented("item_nullifier")
    if nullifier ~= nil and nullifier:IsFullyCastable() then
        if npcBot:GetActiveMode() == BOT_MODE_ROAM or npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or npcBot:GetActiveMode() == BOT_MODE_ATTACK then
            if npcTarget ~= nil and npcTarget:IsHero() and fun1:NormalCanCast(npcTarget) and GetUnitToUnitDistance(npcBot, npcTarget) < 800 and npcTarget:HasModifier("modifier_item_nullifier_mute") == false then
                M.UseItemOnEntity(npcBot, nullifier, npcTarget)
                return
            end
        end
    end
    local WardList = GetUnitList(UNIT_LIST_ALLIED_WARDS)
    local HaveWard = false
    for _, ward in pairs(WardList) do
        if GetUnitToUnitDistance(ward, npcBot) <= 1500 then
            HaveWard = true
        end
    end
    local sentry = GetItemIfNotImplemented("item_ward_sentry")
    if sentry ~= nil and sentry:IsFullyCastable() and sentry:IsCooldownReady() then
        local NearbyTowers = npcBot:GetNearbyTowers(1600, true)
        local NearbyTowers2 = npcBot:GetNearbyTowers(800, true)
        local NearbyTowers3 = npcBot:GetNearbyTowers(800, false)
        if HaveWard == false then
            if npcBot:GetActiveMode() == BOT_MODE_ATTACK then
                M.UseItemOnLocation(npcBot, sentry, npcBot:GetLocation())
            end
            if npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT and #NearbyTowers2 == 0 and #NearbyTowers > 0 then
                M.UseItemOnLocation(npcBot, sentry, npcBot:GetXUnitsInBehind(300))
            end
            if npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT and #NearbyTowers3 == 0 then
                M.UseItemOnLocation(npcBot, sentry, npcBot:GetXUnitsInFront(300))
            end
        end
    end
end
return M
