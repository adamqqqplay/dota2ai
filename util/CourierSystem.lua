local BotsInit = require("game/botsinit")

local M = BotsInit.CreateGeneric()

-- local function PrintCourierState(state)
--     if state == 0 then
--         print("COURIER_STATE_IDLE ")
--     elseif state == 1 then
--         print("COURIER_STATE_AT_BASE")
--     elseif state == 2 then
--         print("COURIER_STATE_MOVING")
--     elseif state == 3 then
--         print("COURIER_STATE_DELIVERING_ITEMS")
--     elseif state == 4 then
--         print("COURIER_STATE_RETURNING_TO_BASE")
--     elseif state == 5 then
--         print("COURIER_STATE_DEAD")
--     else
--         print("UNKNOWN")
--     end
-- end

local function IsHumanHaveItemInCourier()
    local numPlayer = GetTeamPlayers(GetTeam())
    for i = 1, #numPlayer do
        if not IsPlayerBot(numPlayer[i]) then
            local member = GetTeamMember(i)
            if member ~= nil and member:IsAlive() and member:GetCourierValue() > 0 then
                return true
            end
        end
    end
    return false
end

local function IsInvFull(npcHero)
    for i = 0, 8 do
        if (npcHero:GetItemInSlot(i) == nil) then
            return false
        end
    end
    return true
end

local function IsTheClosestToCourier(npcBot, npcCourier)
    local numPlayer = GetTeamPlayers(GetTeam())
    local closest = nil
    local closestD = 100000
    for i = 1, #numPlayer do
        local member = GetTeamMember(i)
        if
            member ~= nil and IsPlayerBot(numPlayer[i]) and member:IsAlive() and member:GetCourierValue() > 0 and
                not IsInvFull(member)
         then
            local dist = GetUnitToUnitDistance(member, npcCourier)
            if dist < closestD then
                closest = member
                closestD = dist
            end
        end
    end
    return closest ~= nil and closest == npcBot
end

local function GetBotCourier(npcBot)
	local BotCourier = GetCourier(0)
	local numPlayer = GetTeamPlayers(GetTeam())
	for i = 1, #numPlayer do
        local member = GetTeamMember(i)
        if member ~= nil and member:GetUnitName() == npcBot:GetUnitName() then
            BotCourier = GetCourier(i-1)
		end
    end
	return BotCourier
end

local function GetCourierEmptySlot(courier)
    local amount = 0
    for i = 0, 8 do
        if courier:GetItemInSlot(i) == nil then
            amount = amount + 1
        end
    end
    return amount
end

local function GetNumStashItem(unit)
    local amount = 0
    for i = 9, 14 do
        if unit:GetItemInSlot(i) ~= nil then
            amount = amount + 1
        end
    end
    return amount
end

local function UpdateSShopUserStatus(npcBot)
    local numPlayer = GetTeamPlayers(GetTeam())
    for i = 1, #numPlayer do
        local member = GetTeamMember(i)
        if member ~= nil and IsPlayerBot(numPlayer[i]) and member:GetUnitName() ~= npcBot:GetUnitName() then
            member.SShopUser = false
        end
    end
end

local function IsTargetedByUnit(courier)
    for i = 0, 10 do
        local tower = GetTower(GetOpposingTeam(), i)
        if tower ~= nil and tower:GetAttackTarget() == courier then
            return true
        end
    end
    for _, id in pairs(GetTeamPlayers(GetOpposingTeam())) do
        if IsHeroAlive(id) then
            local info = GetHeroLastSeenInfo(id)
            if info ~= nil then
                local dInfo = info[1]
                if
                    dInfo ~= nil and GetUnitToLocationDistance(courier, dInfo.location) <= 700 and
                        dInfo.time_since_seen < 0.5
                 then
                    return true
                end
            end
        end
    end
    return false
end

local function IsFlyingCourier(npcCourier)
    if (npcCourier ~= nil and npcCourier:GetMaxHealth() == 150) then
        return true
    end
    return false
end

local courierTime = -90
GetBot().SShopUser = false
local returnTime = -90
local apiAvailable = false
function M.CourierUsageThink()
    local npcBot = GetBot()
    if
        GetGameMode() == 23 or npcBot:IsInvulnerable() or not npcBot:IsHero() or npcBot:IsIllusion() or
            npcBot:HasModifier("modifier_arc_warden_tempest_double") or
            GetNumCouriers() == 0
     then
        return
    end

    local npcCourier = GetBotCourier(npcBot)
    local cState = GetCourierState(npcCourier)
    --PrintCourierState(cState);
    local courierPHP = npcCourier:GetHealth() / npcCourier:GetMaxHealth()

    if cState == COURIER_STATE_DEAD then
        npcCourier.latestUser = nil
        return
    end

    if IsFlyingCourier(npcCourier) then
        local burst = npcCourier:GetAbilityByName("courier_shield")
        if IsTargetedByUnit(npcCourier) then
            if burst:IsFullyCastable() and apiAvailable == true then
                npcBot:ActionImmediate_Courier(npcCourier, COURIER_ACTION_BURST)
                return
            elseif DotaTime() > returnTime + 7.0 then
                --and not burst:IsFullyCastable() and not npcCourier:HasModifier('modifier_courier_shield')
                npcBot:ActionImmediate_Courier(npcCourier, COURIER_ACTION_RETURN)
                returnTime = DotaTime()
                return
            end
        end
    else
        if IsTargetedByUnit(npcCourier) then
            if DotaTime() - returnTime > 7.0 then
                npcBot:ActionImmediate_Courier(npcCourier, COURIER_ACTION_RETURN)
                returnTime = DotaTime()
                return
            end
        end
    end

    if (IsCourierAvailable() and cState ~= COURIER_STATE_IDLE) then
        npcCourier.latestUser = "temp"
    end

    --FREE UP THE COURIER FOR HUMAN PLAYER
    if cState == COURIER_STATE_MOVING or IsHumanHaveItemInCourier() then
        npcCourier.latestUser = nil
    end

    if
        npcBot.SShopUser and
            (not npcBot:IsAlive() or npcBot:GetActiveMode() == BOT_MODE_SECRET_SHOP or
                not (npcBot.secretShopMode == true and npcBot:GetActiveMode() ~= BOT_MODE_SECRET_SHOP))
     then
        --npcBot:ActionImmediate_Chat( "Releasing the courier to anticipate secret shop stuck", true );
        npcCourier.latestUser = "temp"
        npcBot.SShopUser = false
        npcBot:ActionImmediate_Courier(npcCourier, COURIER_ACTION_RETURN)
        return
    end

    if
        npcCourier.latestUser ~= nil and (IsCourierAvailable() or cState == COURIER_STATE_RETURNING_TO_BASE) and
            DotaTime() - returnTime > 7.0
     then
        if cState == COURIER_STATE_AT_BASE and courierPHP < 1.0 then
            return
        end

        --RETURN COURIER TO BASE WHEN IDLE
        if cState == COURIER_STATE_IDLE then
            npcBot:ActionImmediate_Courier(npcCourier, COURIER_ACTION_RETURN)
            return
        end

        --TAKE ITEM FROM STASH
        if cState == COURIER_STATE_AT_BASE then
            local nCSlot = GetCourierEmptySlot(npcCourier)
            local numPlayer = GetTeamPlayers(GetTeam())
            local stashValue = npcBot:GetStashValue()
            for i = 1, #numPlayer do
                local member = GetTeamMember(i)
                if member ~= nil and IsPlayerBot(numPlayer[i]) and member:IsAlive() then
                    local nMSlot = GetNumStashItem(member)
                    if nMSlot > 0 and nMSlot <= nCSlot and stashValue >= 500 then
                        member:ActionImmediate_Courier(npcCourier, COURIER_ACTION_TAKE_STASH_ITEMS)
                        nCSlot = nCSlot - nMSlot
                        courierTime = DotaTime()
                    end
                end
            end
        end

        --MAKE COURIER GOES TO SECRET SHOP
        if
            npcBot:IsAlive() and (npcBot.secretShopMode == true and npcBot:GetActiveMode() ~= BOT_MODE_SECRET_SHOP) and
                npcCourier:DistanceFromFountain() < 7000 and
                DotaTime() > courierTime + 1.0
         then
            --npcBot:ActionImmediate_Chat( "Using Courier for secret shop.", true );
            npcBot:ActionImmediate_Courier(npcCourier, COURIER_ACTION_SECRET_SHOP)
            npcCourier.latestUser = npcBot
            npcBot.SShopUser = true
            UpdateSShopUserStatus(npcBot)
            courierTime = DotaTime()
            return
        end

        --TRANSFER ITEM IN COURIER
        if
            npcBot:IsAlive() and npcBot:GetCourierValue() > 0 and IsTheClosestToCourier(npcBot, npcCourier) and
                (npcCourier:DistanceFromFountain() < 7000 or GetUnitToUnitDistance(npcBot, npcCourier) < 1300) and
                DotaTime() > courierTime + 1.0
         then
            npcBot:ActionImmediate_Courier(npcCourier, COURIER_ACTION_TRANSFER_ITEMS)
            npcCourier.latestUser = npcBot
            courierTime = DotaTime()
            return
        end

        --RETURN STASH ITEM WHEN DEATH
        if
            not npcBot:IsAlive() and cState == COURIER_STATE_DELIVERING_ITEMS and npcBot:GetCourierValue() > 0 and
                DotaTime() > courierTime + 1.0
         then
            npcBot:ActionImmediate_Courier(npcCourier, COURIER_ACTION_RETURN_STASH_ITEMS)
            npcCourier.latestUser = npcBot
            courierTime = DotaTime()
            return
        end
    end
end

return M
