---------------------------------------------
-- Generated from Mirana Compiler version 1.6.1
-- Do not modify
-- https://github.com/AaronSong321/Mirana
---------------------------------------------
local role = require(GetScriptDirectory().."/util/RoleUtility")
local fun1 = require(GetScriptDirectory().."/util/AbilityAbstraction")
local function GetCarryRate(hero)
    return role.hero_roles[hero:GetUnitName()].carry
end
local function GetLane(nTeam, hHero)
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
local function CreepRate(creep)
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
local function CreepReward(creep)
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
local function GetAllyTower(towerIndex)
    return GetTower(GetTeam(), towerIndex)
end
local allyTower1 = fun1:Map({
    TOWER_TOP_1,
    TOWER_MID_1,
    TOWER_BOT_1,
}, GetAllyTower)
local allyTower2 = fun1:Map({
    TOWER_TOP_2,
    TOWER_MID_2,
    TOWER_BOT_2,
}, GetAllyTower)
local allyTower3 = fun1:Map({
    TOWER_TOP_3,
    TOWER_MID_3,
    TOWER_BOT_3,
}, GetAllyTower)
local allyTower4 = fun1:Map({
    TOWER_BASE_1,
    TOWER_BASE_2,
}, GetAllyTower)
local function TowerRate(tower)
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
local function CleanLaneDesire(npc, lane)
    local front = GetLaneFrontLocation(GetTeam(), lane, 0)
    local allyTower = GetNearestBuilding(GetTeam(), front)
    local distanceToFront = GetUnitToUnitDistance(npc, allyTower:GetLocation())
    local creeps = fun1:Filter(GetUnitList(UNIT_LIST_ENEMY_CREEPS), function(t)
        return GetUnitToLocationDistance(t, front) <= 1500
    end)
    local allyCreeps = fun1:Filter(GetUnitList(UNIT_LIST_FRIEND_CREEPS), function(t)
        return GetUnitToLocationDistance(t, front) <= 1500
    end)
    local creepRateDiff = creeps:Map(CreepRate):Aggregate(0, function(opv_1, opv_2) return opv_1 + opv_2 end) - allyCreeps:Map(CreepRate):Aggregate(0, function(opv_1, opv_2) return opv_1 + opv_2 end)
    local desire = 0
    local necessity = 0
    if distanceToFront <= 3000 then
        if creepRateDiff >= DotaTime() / 300 and creepRateDiff >= 3 then
            necessity = necessity + creepRateDiff
        end
        if creepRateDiff >= 2 and creepRateDiff then
            desire = desire + creeps:Map(CreepReward):Aggregate(0, function(opv_1, opv_2) return opv_1 + opv_2 end)
        end
    end
    necessity = necessity * TowerRate(allyTower)
    desire = desire * TowerRate(allyTower)
    return desire
end
local function DefendLaneDesire()
    return 0
end
