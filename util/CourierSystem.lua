local BotsInit = require("game/botsinit")

local courierUtils = require(GetScriptDirectory() ..  "/util/CourierUtility");

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
local function IsOnlyInventoryFull(npcHero)
    for i = 0, 5 do
        if npcHero:GetItemInSlot(i) == nil then
            return false
        end
    end
    return true
end
local function CannotCarryOnBackpack(itemName)
    local items = {"item_gem", "item_rapier", "item_immortal"}
    for _,v in ipairs(itemName) do
        if v == items then
            return true
        end
    end
    return false
end
local function HasItemCannotCarryOnBackpack(courier)
    for i = 0, 5 do
        if CannotCarryOnBackpack(courier:GetItemInSlot(i):GetName()) then
            return true
        end
    end
    return false
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

function PrintCourierState(state)
	
    if state == 0 then
        print("COURIER_STATE_IDLE ");
    elseif state == 1 then
        print("COURIER_STATE_AT_BASE");
    elseif state == 2 then
        print("COURIER_STATE_MOVING");
    elseif state == 3 then
        print("COURIER_STATE_DELIVERING_ITEMS");
    elseif state == 4 then
        print("COURIER_STATE_RETURNING_TO_BASE");
    elseif state == 5 then
        print("COURIER_STATE_DEAD");
    else
        print("UNKNOWN");
    end
    
end

local npcBot = GetBot()

local courierTime = -90;
local cState = -1;
npcBot.SShopUser = false;
local returnTime = -90;
local apiAvailable = false;

npcBot.courierID = 0;
npcBot.courierAssigned = false;
-- local calibrateTime = DotaTime();
local checkCourier = false;
local define_courier = false;
local cr = nil;
local tm =  GetTeam();
local pIDs = GetTeamPlayers(tm);


local lastTransferredTime = -100
local lastTransferredTimeCourierItemNumber = 0
local returnToFountainWhenTransferFailed = false

function M.CourierUsageThink()
    local npcBot = GetBot()
    if GetGameMode() == 23 or npcBot:IsInvulnerable() or not npcBot:IsHero() or npcBot:IsIllusion() or npcBot:HasModifier("modifier_arc_warden_tempest_double") or GetNumCouriers() == 0 then
        return;
    end

    -- if GetTeam() == TEAM_DIRE then
        -- print(npcBot:GetUnitName().."----"..tostring(npcBot:GetPlayerID()));
        -- for i = 1, #pIDs do
            -- print(GetSelectedHeroName(pIDs[i])..":"..pIDs[i])
        -- end
    -- end

    -- if npcBot.courierAssigned == false then
        -- for i=1, #pIDs do
            -- if IsPlayernpcBot(pIDs[i]) == true then
                -- local mbr = GetTeamMember(i);
                -- if  npcBot == mbr then
                    -- npcBot.courierID = i - 1;
                    -- npcBot.courierAssigned = true;
                    -- print(npcBot:GetUnitName().." : Courier Successfully Assigned To Courier "..tostring(npcBot.courierID));
                -- end
            -- end
        -- end
    -- end

    if courierUtils.pIDInc < #pIDs + 1 and DotaTime() > -60 then
        if IsPlayerBot(pIDs[courierUtils.pIDInc]) == true then
            local currID = pIDs[courierUtils.pIDInc];
                if npcBot:GetPlayerID() == currID  then
                    if checkCourier == true and DotaTime() > courierUtils.calibrateTime + 5  then
                        local cst = GetCourierState(cr);
                        -- print(npcBot:GetUnitName());
                        if cst == COURIER_STATE_MOVING then
                            courierUtils.pIDInc = courierUtils.pIDInc + 1;
                            -- print(npcBot:GetUnitName().." : Courier Successfully Assigned ."..tostring(npcBot.courierID))
                            checkCourier = false;
                            npcBot.courierAssigned = true;
                            courierUtils.calibrateTime = DotaTime();
                            npcBot:ActionImmediate_Courier( cr, COURIER_ACTION_RETURN_STASH_ITEMS );
                            return;
                        elseif npcBot.courierID ~= nil then
                            --  print(npcBot:GetUnitName().. ": Failed to Assign Courier.")
                            npcBot.courierID = npcBot.courierID + 1;
                            checkCourier = false;
                            courierUtils.calibrateTime = DotaTime();
                        end
                    elseif checkCourier == false then
                        cr = GetBotCourier(npcBot);
                        npcBot:ActionImmediate_Courier( cr, COURIER_ACTION_SECRET_SHOP );
                        checkCourier = true;
                    end
                end
        else
            courierUtils.pIDInc = courierUtils.pIDInc + 1;
        end
    end

    if npcBot.courierAssigned == true then
        -- if npcBot:GetCourierValue( ) > 0 then

        -- print(npcBot:GetUnitName()..":"..tostring(npcBot:GetCourierValue( )));
        -- end
        local npcCourier = GetBotCourier(npcBot);
        -- local itm = npcCourier:GetItemInSlot(1);
        -- if itm ~= nil then
        -- print(itm:GetName());
        -- end

        local cState = GetCourierState( npcCourier );

        if cState == COURIER_STATE_DEAD then
            npcCourier.latestUser = nil;
            return
        end

        -- try to return courier to fountain when the hero's inventory and backpack are full and there are items in the courier and no high-level items can be created; or return courier to fountain and drop gems when the hero's inventory is full and there are gems or rapiers in the courier
        --local newDis = GetUnitToUnitDistance(npcBot, npcCourier)
        --if newDis <= 250 and cState == COURIER_STATE_DELIVERING_ITEMS then
        --    if lastTransferredTime == -100 then
        --        lastTransferredTime = DotaTime()
        --        lastTransferredTimeCourierItemNumber = 6-GetCourierEmptySlot(npcCourier)
        --    end
        --else
        --    lastTransferredTime = -100
        --end
        --if returnToFountainWhenTransferFailed then
        --    if not (cState == COURIER_STATE_AT_BASE or cState == COURIER_STATE_DELIVERING_ITEMS) then
        --
        --    else
        --        returnToFountainWhenTransferFailed = false
        --        lastTransferredTime = -100
        --    end
        --    return
        --end
        --if lastTransferredTime ~= -100 and DotaTime() - lastTransferredTime > 2 then
        --    if IsInvFull(npcBot) and GetCourierEmptySlot(npcCourier) < 6 then
        --        npcBot:ActionImmediate_Courier(npcCourier, COURIER_ACTION_RETURN)
        --        returnToFountainWhenTransferFailed = true
        --        return
        --    end
        --    if IsOnlyInventoryFull(npcBot) and HasItemCannotCarryOnBackpack(npcCourier) then
        --        npcBot:ActionImmediate_Courier(npcCourier, COURIER_ACTION_RETURN)
        --        returnToFountainWhenTransferFailed = true
        --        return
        --    end
        --end


        local courierPHP = npcCourier:GetHealth() / npcCourier:GetMaxHealth();

        if IsFlyingCourier(npcCourier) then
            -- local burst = npcCourier:GetAbilityByName('courier_shield');
            -- if IsTargetedByUnit(npcCourier) then
            --     if burst:IsFullyCastable() and apiAvailable == true
            --     then
            --         npcBot:ActionImmediate_Courier( npcCourier, COURIER_ACTION_BURST );
            --         return
            --     elseif DotaTime() > returnTime + 7.0
            --            --and not burst:IsFullyCastable() and not npcCourier:HasModifier('modifier_courier_shield')
            --     then
            --         npcBot:ActionImmediate_Courier( npcCourier, COURIER_ACTION_RETURN );
            --         returnTime = DotaTime();
            --         return
            --     end
            -- end
        else
            if IsTargetedByUnit(npcCourier) then
                if DotaTime() - returnTime > 7.0 then
                    npcBot:ActionImmediate_Courier( npcCourier, COURIER_ACTION_RETURN );
                    returnTime = DotaTime();
                    return
                end
            end
        end

        if ( IsCourierAvailable() and cState ~= COURIER_STATE_IDLE )  then
            npcCourier.latestUser = "temp";
        end

        if npcBot.SShopUser and ( not npcBot:IsAlive() or npcBot:GetActiveMode() == BOT_MODE_SECRET_SHOP or not npcBot.SecretShop  ) then
            --npcBot:ActionImmediate_Chat( "Releasing the courier to anticipate secret shop stuck", true );
            npcCourier.latestUser = "temp";
            npcBot.SShopUser = false;
            npcBot:ActionImmediate_Courier( npcCourier, COURIER_ACTION_RETURN_STASH_ITEMS );
            return
        end

        if cState == COURIER_STATE_AT_BASE or cState == COURIER_STATE_IDLE or cState == COURIER_STATE_RETURNING_TO_BASE  then
            if courierPHP < 1.0 then
                return;
            end

            --RETURN COURIER TO BASE WHEN IDLE
            if cState == COURIER_STATE_IDLE then
                npcBot:ActionImmediate_Courier( npcCourier, COURIER_ACTION_RETURN_STASH_ITEMS );
                return
            end

            --TAKE ITEM FROM STASH
            if  cState == COURIER_STATE_AT_BASE then
                local nCSlot = GetCourierEmptySlot(npcCourier);
                    if npcBot:IsAlive()
                    then
                        local nMSlot = GetNumStashItem(npcBot);
                        if nMSlot > 0 and nMSlot <= nCSlot
                        then
                            -- print("Transfer Item");
                            npcBot:ActionImmediate_Courier( npcCourier, COURIER_ACTION_TAKE_STASH_ITEMS );
                            nCSlot = nCSlot - nMSlot ;
                            courierTime = DotaTime();
                            return;
                        end
                    end
            end

            --MAKE COURIER GOES TO SECRET SHOP
            if  npcBot:IsAlive() and npcBot.SecretShop and npcCourier:DistanceFromFountain() < 7000 and IsInvFull(npcCourier) == false and DotaTime() > courierTime + 1.0 then
                --npcBot:ActionImmediate_Chat( "Using Courier for secret shop.", true );
                npcBot:ActionImmediate_Courier( npcCourier, COURIER_ACTION_SECRET_SHOP )
                npcCourier.latestUser = npcBot;
                npcBot.SShopUser = true;
                UpdateSShopUserStatus(npcBot);
                courierTime = DotaTime();
                -- print("Transfer Secret Shop");
                return
            end

            --TRANSFER ITEM IN COURIER
            if npcBot:IsAlive() and npcBot:GetCourierValue( ) > 0
            then
                npcBot:ActionImmediate_Courier( npcCourier, COURIER_ACTION_TRANSFER_ITEMS )
                npcCourier.latestUser = npcBot;
                courierTime = DotaTime();
                -- print("Transfer Item 2");
                return
            end

            --RETURN STASH ITEM WHEN DEATH
            if  not npcBot:IsAlive() and cState == COURIER_STATE_DELIVERING_ITEMS
                and npcBot:GetCourierValue( ) > 0 and DotaTime() > courierTime + 1.0
            then
                npcBot:ActionImmediate_Courier( npcCourier, COURIER_ACTION_RETURN_STASH_ITEMS );
                npcCourier.latestUser = npcBot;
                courierTime = DotaTime();
                -- print("Return Item");
                return
            end

        end

    end

end





return M
