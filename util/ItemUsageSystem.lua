local BotsInit = require("game/botsinit")
local role = require(GetScriptDirectory() .. "/util/RoleUtility")
local AbilityExtensions = require(GetScriptDirectory().."/util/AbilityAbstraction")


local M = BotsInit.CreateGeneric()

local function CanCastOnTarget(npcTarget)
    return npcTarget:CanBeSeen() and not npcTarget:IsMagicImmune() and not npcTarget:IsInvulnerable() and
        not npcTarget:IsIllusion()
end

local function CanCastOnMagicImmuneTarget(npcTarget)
    return npcTarget:CanBeSeen() and not npcTarget:IsInvulnerable()
end

local function IsDisabled(npcTarget)
    if
        npcTarget:IsRooted() or npcTarget:IsStunned() or npcTarget:IsHexed() or npcTarget:IsSilenced() or
            npcTarget:IsNightmared()
     then
        return true
    end
    return false
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

local function GiveToMidLaner()
    local teamPlayers = GetTeamPlayers(GetTeam())
    --local target = nil
    if DotaTime() <= 0 then return nil end
    for k, _ in pairs(teamPlayers) do
        local member = GetTeamMember(k)
        if member ~= nil and not member:IsIllusion() and member:IsAlive() and member:GetMaxHealth()-member:GetHealth() >= 200 then
            local num_sts = GetItemCount(member, "item_tango_single")
            local num_ff = GetItemCount(member, "item_faerie_fire")
            local num_stg = GetItemCharges(member, "item_tango")
            if num_sts + num_ff + num_stg == 0 then
                return member
            end
        end
    end
    return nil
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

local function IsItemAvailable(item_name)
    local npcBot = GetBot()
    for i = 0, 5 do
        local item = npcBot:GetItemInSlot(i)
        if (item ~= nil) then
            if (item:GetName() == item_name) and item:IsFullyCastable() then
                return item
            end
        end
    end
    return nil
end

local function IsXItemAvailable(npcBot, item_name)
    for i = 0, 5 do
        local item = npcBot:GetItemInSlot(i)
        if (item ~= nil) then
            if (item:GetName() == item_name) then
                return item
            end
        end
    end
    return nil
end

local function IsStuck(npcBot)
	if npcBot.stuckLoc ~= nil and npcBot.stuckTime ~= nil then
		local attackTarget = npcBot:GetAttackTarget();
		local EAd = GetUnitToUnitDistance(npcBot, GetAncient(GetOpposingTeam()));
		local TAd = GetUnitToUnitDistance(npcBot, GetAncient(GetTeam()));
		local Et = npcBot:GetNearbyTowers(450, true);
		local At = npcBot:GetNearbyTowers(450, false);
		if npcBot:GetCurrentActionType() == BOT_ACTION_TYPE_MOVE_TO and attackTarget == nil and EAd > 2200 and TAd > 2200 and #Et == 0 and #At == 0  
		   and DotaTime() > npcBot.stuckTime + 5.0 and GetUnitToLocationDistance(npcBot, npcBot.stuckLoc) < 25
		then
			print(npcBot:GetUnitName().." is stuck")
			return true;
		end
	end
	return false
end

--
-- TP usage
--

local myTeam = GetTeam()
local opTeam = GetOpposingTeam()

local function GetLaningTPLocation(nLane)
    local teamT1Top = GetTower(myTeam, TOWER_TOP_1)
    local teamT1Mid = GetTower(myTeam, TOWER_MID_1)
    local teamT1Bot = GetTower(myTeam, TOWER_BOT_1)
    -- local enemyT1Top = GetTower(opTeam, TOWER_TOP_1)
    -- local enemyT1Mid = GetTower(opTeam, TOWER_MID_1)
    -- local enemyT1Bot = GetTower(opTeam, TOWER_BOT_1)

    if nLane == LANE_TOP and teamT1Top~=nil then
        return teamT1Top:GetLocation()
    elseif nLane == LANE_MID and teamT1Mid~=nil  then
        return teamT1Mid:GetLocation()
    elseif nLane == LANE_BOT and teamT1Bot~=nil  then
        return teamT1Bot:GetLocation()
    end
    return Vector(0.000000, 0.000000, 0.000000);
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
            print("DefendLaneDesire TOP: " .. tostring(dlt))
        elseif idlm ~= dlm then
            idlm = dlm
            print("DefendLaneDesire MID: " .. tostring(dlm))
        elseif idlb ~= dlb then
            idlb = dlb
            print("DefendLaneDesire TOP: " .. tostring(dlb))
        end
        if md == BOT_MODE_DEFEND_TOWER_TOP then
            print("Def Tower Des TOP: " .. tostring(mdd))
        elseif md == BOT_MODE_DEFEND_TOWER_MID then
            print("Def Tower Des MID: " .. tostring(mdd))
        elseif md == BOT_MODE_DEFEND_TOWER_BOT then
            print("Def Tower Des npcBot: " .. tostring(mdd))
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
    elseif
        mode == BOT_MODE_DEFEND_ALLY and modDesire >= BOT_MODE_DESIRE_MODERATE and
            role.CanBeSupport(npcBot:GetUnitName()) == true and
            #enemies == 0
     then
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

--npcBot EXPER's code
local giveTime = -90
function M.UnImplementedItemUsage()
    local npcBot = GetBot()
    if npcBot:IsChanneling() or npcBot:IsUsingAbility() or npcBot:IsInvisible() or npcBot:IsMuted() then
        return
    end
    local notBlasted = not npcBot:HasModifier("modifier_ice_blast")
    local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes(800, true, BOT_MODE_NONE)
    local nearByTowers = npcBot:GetNearbyTowers(1000, true)

    local npcTarget = npcBot:GetTarget()
    local mode = npcBot:GetActiveMode()

    local tps = npcBot:GetItemInSlot(15)
    if tps ~= nil and tps:IsFullyCastable() then
        local tpLoc
        local shouldTP
        shouldTP, tpLoc = ShouldTP()
        if shouldTP then
            npcBot:Action_UseAbilityOnLocation(tps, tpLoc)
            return
        end
    end

    local function GetWantedPowerTreadsAttribute()
        if mode == BOT_MODE_RETREAT and npcBot:WasRecentlyDamagedByAnyHero(3) then
            return ATTRIBUTE_STRENGTH
        elseif AbilityExtensions:IsAttackingEnemies(npcBot) then
            local name = npcBot:GetUnitName()
            name = AbilityExtensions:GetHeroShortName(name)
            if AbilityExtensions:Contains({"obsidian_destroyer","enchantress","silencer"}, name) then
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
        if npcBot:IsInvisible() and npcBot:UsingItemBreakInvisibility() then
            if npcBot:HasModifier("modifier_item_dust") then
                npcBot:Action_UseAbility(treads)
                return true
            end
            return
        end
        if GetWantedPowerTreadsAttribute() ~= treads:GetPowerTreadsStat() then
            print(npcBot:GetUnitName()..": power treads attribute "..treads:GetPowerTreadsStat()..", but I want "..GetWantedPowerTreadsAttribute())
            npcBot:Action_UseAbility(treads)
            return true
        end
    end

    local pt = IsItemAvailable("item_power_treads")
    if pt ~= nil and pt:IsFullyCastable() and notBlasted then
        UsePowerTreads(pt)
    end

    --local ringOfBasilius = IsItemAvailable("item_ring_of_basilius")
    --if ringOfBasilius and ringOfBasilius:IsFullyCastable() then
    --    if (npcBot:GetActiveMode() == BOT_MODE_LANING) ~= ringOfBasilius:GetToggleState() then
    --        ringOfBasilius:ToggleAutoCast()
    --    end
    --end
    --
    --local buckler = IsItemAvailable("item_buckler")
    --if buckler and buckler:IsFullyCastable() then
    --    if (npcBot:GetActiveMode() == BOT_MODE_LANING) ~= buckler:GetToggleState() then
    --        buckler:ToggleAutoCast()
    --    end
    --end

    -- give tango to ally
    local itg = IsItemAvailable("item_tango")
    if itg ~= nil and itg:IsFullyCastable() then
        local tCharge = itg:GetCurrentCharges()
        if
            DotaTime() > -90 and DotaTime() < 0 and npcBot:DistanceFromFountain() <= 100 and
                role.CanBeSupport(npcBot:GetUnitName()) and
                npcBot:GetAssignedLane() ~= LANE_MID and
                tCharge > 2 and
                DotaTime() > giveTime + 2.0
         then
            local target = GiveToMidLaner()
            if target ~= nil then
                npcBot:Action_UseAbilityOnEntity(itg, target)
                giveTime = DotaTime()
                return
            end
        elseif
            DotaTime() > 0 and npcBot:GetActiveMode() == BOT_MODE_LANING and role.CanBeSupport(npcBot:GetUnitName()) and
                tCharge > 1 and
                DotaTime() > giveTime + 2.0
         then
            local allies = npcBot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
            for _, ally in pairs(allies) do
                local tangoSlot = ally:FindItemSlot("item_tango")
                if
                    ally:GetUnitName() ~= npcBot:GetUnitName() and not ally:IsIllusion() and tangoSlot == -1 and
                        GetItemCount(ally, "item_tango_single") == 0
                 then
                    npcBot:Action_UseAbilityOnEntity(itg, ally)
                    giveTime = DotaTime()
                    return
                end
            end
        end
    end

    local its = IsItemAvailable("item_tango_single")
    local tango
    if (its ~= nil) then
        tango = its
    elseif (itg ~= nil) then
        tango = itg
    end

    if tango ~= nil and tango:IsFullyCastable() and npcBot:DistanceFromFountain() > 1000 then
        if DotaTime() > 0 and not npcBot:HasModifier("modifier_tango_heal") then
            local trees = npcBot:GetNearbyTrees(1000)
            if
                trees[1] ~= nil and (npcBot:GetHealth() / npcBot:GetMaxHealth()) < 0.7 and
                    (IsLocationVisible(GetTreeLocation(trees[1])) or IsLocationPassable(GetTreeLocation(trees[1]))) and
                    #tableNearbyEnemyHeroes == 0 and
                    #nearByTowers == 0
             then
                npcBot:Action_UseAbilityOnTree(tango, trees[1])
                return
            end
        end
    end

    if (DotaTime() > 10 * 60) then
        local emptySlots = AbilityExtensions:GetEmptyInventorySlots(npcBot)
        if emptySlots < 2 then
            for i = 0, 5 do
                local tower = npcBot:GetNearbyTowers(1000, true)[1]
                local sCurItem = npcBot:GetItemInSlot(i)
                if (sCurItem ~= nil and (sCurItem:GetName() == "item_tango" or sCurItem:GetName() == "item_tango_single")) then
                    local trees = AbilityExtensions:Filter(npcBot:GetNearbyTrees(300), function(t)
                        if tower == nil then
                            return true
                        end
                        return GetUnitToLocationDistance(tower, GetTreeLocation(t)) > tower:GetAttackRange()
                    end)
                    if trees[1] ~= nil then
                        npcBot:Action_UseAbilityOnTree(sCurItem, trees[1])
                        return
                    end
                end
            end
        end
    end

    local ifl = IsItemAvailable("item_flask")
    if ifl ~= nil and ifl:IsFullyCastable() and npcBot:DistanceFromFountain() > 1000 then
        if DotaTime() > 0 then
            local tableNearbyEnemyHeroes2 = npcBot:GetNearbyHeroes(650, true, BOT_MODE_NONE)
            if (npcBot:GetHealth() / npcBot:GetMaxHealth()) < 0.35 and #tableNearbyEnemyHeroes2 == 0 then
                npcBot:Action_UseAbilityOnEntity(ifl, npcBot)
                return
            end
        end
    end

    local icl = IsItemAvailable("item_clarity")
    if icl ~= nil and icl:IsFullyCastable() and npcBot:DistanceFromFountain() > 1000 then
        if DotaTime() > 0 then
            local tableNearbyEnemyHeroes2 = npcBot:GetNearbyHeroes(550, true, BOT_MODE_NONE)
            if (npcBot:GetMana() / npcBot:GetMaxMana()) < 0.35 and #tableNearbyEnemyHeroes2 == 0 then
                npcBot:Action_UseAbilityOnEntity(icl, npcBot)
                return
            end
        end
    end

    local itemQuellingBlade = IsItemAvailable("item_quelling_blade") or IsItemAvailable("item_bfury")
    if itemQuellingBlade ~= nil and itemQuellingBlade:IsFullyCastable() then
        local trees = npcBot:GetNearbyTrees(250)
        if #trees >= 8 and AbilityExtensions:Contains(npcBot:GetNearbyHeroes(900, true, BOT_MODE_NONE), function(t) return t:GetUnitName() == "npc_dota_hero_furion" end) then
            npcBot:Action_UseAbilityOnTree(itemQuellingBlade, trees[1])
            return
        end
    end

    -- local irt = IsItemAvailable("item_iron_talon")
    -- if irt ~= nil and irt:IsFullyCastable() then
    --     if npcBot:GetActiveMode() == BOT_MODE_FARM then
    --         local neutrals = npcBot:GetNearbyNeutralCreeps(500)
    --         local maxHP = 0
    --         local target = nil
    --         for _, c in pairs(neutrals) do
    --             local cHP = c:GetHealth()
    --             if cHP > maxHP and not c:IsAncientCreep() then
    --                 maxHP = cHP
    --                 target = c
    --             end
    --         end
    --         if target ~= nil then
    --             npcBot:Action_UseAbilityOnEntity(irt, target)
    --             return
    --         end
    --     end
    -- end

    local msh = IsItemAvailable("item_moon_shard")
    if msh ~= nil and msh:IsFullyCastable() then
        if not npcBot:HasModifier("modifier_item_moon_shard_consumed") then
            print("use Moon")
            npcBot:Action_UseAbilityOnEntity(msh, npcBot)
            return
        end
    end

    --[[local mg=IsItemAvailable("item_enchanted_mango");
	if mg~=nil and mg:IsFullyCastable() then
		if npcBot:GetMana() < 100
		then
			npcBot:Action_UseAbility(mg);
			return;
		end
    end]]
    local tok = IsItemAvailable("item_tome_of_knowledge")
    if tok ~= nil and tok:IsFullyCastable() then
        npcBot:Action_UseAbility(tok)
        return
    end

    local ff = IsItemAvailable("item_faerie_fire")
    if ff ~= nil and ff:IsFullyCastable() and notBlasted then
        if
            npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH and
                (npcBot:GetHealth() / npcBot:GetMaxHealth()) < 0.15 and npcBot:WasRecentlyDamagedByAnyHero(3)
         then
            npcBot:Action_UseAbility(ff)
            return
        end
    end

    local sr = IsItemAvailable("item_soul_ring")
    if sr ~= nil and sr:IsFullyCastable() and notBlasted then
        if
            (npcBot:GetActiveMode() == BOT_MODE_LANING or npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
                npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
                npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or
                npcBot:GetActiveMode() == BOT_MODE_FARM)
         then
            if ((npcBot:GetHealth() / npcBot:GetMaxHealth()) > 0.7 and (npcBot:GetMana() / npcBot:GetMaxMana()) < 0.4) then
                npcBot:Action_UseAbility(sr)
                return
            end
        end
    end

    local bst = IsItemAvailable("item_bloodstone")
    if bst ~= nil and bst:IsFullyCastable() and notBlasted then
        if
            npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH and
                (npcBot:GetHealth() / npcBot:GetMaxHealth()) < 0.2
         then
            npcBot:Action_UseAbilityOnLocation(bst, npcBot:GetLocation())
            return
        end
    end

    local pb = IsItemAvailable("item_phase_boots")
    if pb ~= nil and pb:IsFullyCastable() then
        if
            (npcBot:GetActiveMode() == BOT_MODE_ATTACK or npcBot:GetActiveMode() == BOT_MODE_RETREAT or
                npcBot:GetActiveMode() == BOT_MODE_ROAM or
                npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
                npcBot:GetActiveMode() == BOT_MODE_GANK or
                npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY) and not AbilityExtensions:IsSeverelyDisabled(npcBot)
         then
            npcBot:Action_UseAbility(pb)
            return
        end
    end

    local bt = IsItemAvailable("item_bloodthorn")
    if bt ~= nil and bt:IsFullyCastable() then
        if
            (npcBot:GetActiveMode() == BOT_MODE_ATTACK or npcBot:GetActiveMode() == BOT_MODE_ROAM or
                npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
                npcBot:GetActiveMode() == BOT_MODE_GANK or
                npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY)
         then
            if
                (npcTarget ~= nil and npcTarget:IsHero() and CanCastOnTarget(npcTarget) and
                    GetUnitToUnitDistance(npcTarget, npcBot) < 900)
             then
                npcBot:Action_UseAbilityOnEntity(bt, npcTarget)
                return
            end
        end
    end

    --[[local IsUsingArmlet = npcBot:HasModifier("modifier_item_armlet_unholy_health")
    local itemArmlet = IsItemAvailable("item_armlet")
    if itemArmlet then
        if itemArmlet.lastOpenTime == nil and IsUsingArmlet then
            itemArmlet.lastOpenTime = DotaTime()
            return
        end
        if not IsUsingArmlet then
            itemArmlet.lastOpenTime = nil
            return
        end
    end
        
    if itemArmlet and itemArmlet:IsFullyCastable() and notBlasted then
        if AbilityExtensions:IsFarmingOrPushing(npcBot) then
            local target = npcBot:GetAttackTarget()
            if target and target:IsAlive() and (AbilityExtensions:GetHealthPercent(npcBot) >= 0.45 or npcBot:GetHealth() <= 400 or npcBot:GetUnitName() == "npc_bot_hero_huskar" and npcBot:GetLevel() >= 7) then
                if not IsUsingArmlet then
                    npcBot:Action_UseAbility(itemArmlet)
                    itemArmlet.lastOpenTime = DotaTime()
                    return
                else
                    if npcBot:GetHealth() <= 250 and not npcBot:WasRecentlyDamagedByAnyHero(0.8) then
                        npcBot:Action_UseAbility(itemArmlet)
                        itemArmlet.lastOpenTime = DotaTime()
                    end
                end
            else
                if IsUsingArmlet then
                    npcBot:Action_UseAbility(itemArmlet)
                    itemArmlet.lastOpenTime = nil
                    return
                end
            end
        elseif AbilityExtensions:IsAttackingEnemies(npcBot) or AbilityExtensions:IsRetreating(npcBot) then
            if not IsUsingArmlet then
                if #npcBot:GetNearbyHeroes(1599, true, BOT_MODE_NONE) > 0 or npcBot:WasRecentlyDamagedByAnyHero(2.5) then
                    npcBot:Action_UseAbility(itemArmlet)
                    itemArmlet.lastOpenTime = DotaTime()
                    return
                end
            else
                if npcBot:GetHealth() <= 300 then
                    local projectiles = npcBot:GetIncomingTrackingProjectiles()
                    if (#projectiles == 0 or AbilityExtensions:CannotBeKilledNormally(npcBot)) and DotaTime() - itemArmlet.lastOpenTime >= 0.6 then
                        npcBot:Action_UseAbility(itemArmlet)
                        npcBot:ActionQueue_UseAbility(itemArmlet)
                        itemArmlet.lastOpenTime = DotaTime()
                        return
                    end
                end
            end
        end
    end]]

    local sc = IsItemAvailable("item_solar_crest") or IsItemAvailable("item_medallion_of_courage")
    if sc ~= nil and sc:IsFullyCastable() then
        if npcBot:GetActiveMode() == BOT_MODE_ROSHAN then
            local target = npcBot:GetTarget()
            if AbilityExtensions:IsRoshan(target) then
                npcBot:Action_UseAbilityOnEntity(sc, target)
                return
            end
        end

        local allies = AbilityExtensions:GetNearbyNonIllusionHeroes(npcBot)
        allies = AbilityExtensions:Filter(allies, AbilityExtensions.PhysicalCanCastFunction)
        allies = AbilityExtensions:Filter(allies, function(t)
            return not t:HasModifier("modifier_item_medallion_of_courage_armor_addition")
        end)
        allies = AbilityExtensions:First(allies, function(t) return AbilityExtensions:IsSeverelyDisabledOrSlowed(t) end)
        if allies then
            npcBot:Action_UseAbilityOnEntity(sc, allies) 
            return
        end

        if
            (npcBot:GetActiveMode() == BOT_MODE_ATTACK or npcBot:GetActiveMode() == BOT_MODE_ROAM or
                npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
                npcBot:GetActiveMode() == BOT_MODE_GANK or
                npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY)
         then
            if (npcTarget ~= nil and npcTarget:IsHero() and GetUnitToUnitDistance(npcTarget, npcBot) < 900) and not npcTarget:HasModifier("modifier_item_medallion_of_courage_armor_addition") and not npcTarget:HasModifier("modifier_item_medallion_of_courage_armor_reduction") then
                npcBot:Action_UseAbilityOnEntity(sc, npcTarget)
                return
            end
        end
    end

    if sc ~= nil and sc:IsFullyCastable() then
        local Allies = npcBot:GetNearbyHeroes(1000, false, BOT_MODE_NONE)
        for _, Ally in pairs(Allies) do
            if
                (Ally:GetHealth() / Ally:GetMaxHealth() < 0.35 and tableNearbyEnemyHeroes ~= nil and
                    #tableNearbyEnemyHeroes > 0 and
                    CanCastOnTarget(Ally)) or
                    (IsDisabled(Ally) and CanCastOnTarget(Ally))
            then
                npcBot:Action_UseAbilityOnEntity(sc, Ally)
                return
            end
        end

    end

    local se = IsItemAvailable("item_silver_edge")
    if se ~= nil and se:IsFullyCastable() then
        if
            npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH and
                tableNearbyEnemyHeroes ~= nil and
                #tableNearbyEnemyHeroes > 0
         then
            npcBot:Action_UseAbility(se)
            return
        end
        if
            (npcBot:GetActiveMode() == BOT_MODE_ROAM or npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
                npcBot:GetActiveMode() == BOT_MODE_GANK)
         then
            if
                (npcTarget ~= nil and npcTarget:IsHero() and GetUnitToUnitDistance(npcTarget, npcBot) > 1000 and
                    GetUnitToUnitDistance(npcTarget, npcBot) < 2500) and not IsLocationVisible(npcBot)
             then
                npcBot:Action_UseAbility(se)
                return
            end
        end
    end

    local hood = IsItemAvailable("item_hood_of_defiance")
    if hood ~= nil and hood:IsFullyCastable() and npcBot:GetHealth() / npcBot:GetMaxHealth() < 0.8 then
        if tableNearbyEnemyHeroes ~= nil and #tableNearbyEnemyHeroes > 0 then
            npcBot:Action_UseAbility(hood)
            return
        end
    end

    local lotus = IsItemAvailable("item_lotus_orb")
    if lotus ~= nil and lotus:IsFullyCastable() then
        if
            (npcBot:GetHealth() / npcBot:GetMaxHealth() < 0.45 and tableNearbyEnemyHeroes ~= nil and
                #tableNearbyEnemyHeroes > 0) or
                npcBot:IsSilenced() or
                (tableNearbyEnemyHeroes ~= nil and #tableNearbyEnemyHeroes >= 3 and
                    npcBot:GetHealth() / npcBot:GetMaxHealth() < 0.75)
         then
            npcBot:Action_UseAbilityOnEntity(lotus, npcBot)
            return
        end
    end

    if lotus ~= nil and lotus:IsFullyCastable() then
        local Allies = npcBot:GetNearbyHeroes(1000, false, BOT_MODE_NONE)
        for _, Ally in pairs(Allies) do
            if
                (Ally:GetHealth() / Ally:GetMaxHealth() < 0.35 and tableNearbyEnemyHeroes ~= nil and
                    #tableNearbyEnemyHeroes > 0) or
                    IsDisabled(Ally)
             then
                npcBot:Action_UseAbilityOnEntity(lotus, Ally)
                return
            end
        end
    end

    local hurricanpike = IsItemAvailable("item_hurricane_pike")
    if hurricanpike ~= nil and hurricanpike:IsFullyCastable() then
        if (npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH) then
            for _, npcEnemy in pairs(tableNearbyEnemyHeroes) do
                if (GetUnitToUnitDistance(npcEnemy, npcBot) < 400 and CanCastOnTarget(npcEnemy)) then
                    npcBot:Action_UseAbilityOnEntity(hurricanpike, npcEnemy)
                    return
                end
            end
            if npcBot:IsFacingLocation(GetAncient(GetTeam()):GetLocation(), 10) and npcBot:DistanceFromFountain() > 0 then
                npcBot:Action_UseAbilityOnEntity(hurricanpike, npcBot)
                return
            end
        end
    end

    local ghost = IsItemAvailable("item_ghost")
    if ghost and ghost:IsFullyCastable() then
        if npcBot:GetActiveMode() == BOT_MODE_ATTACK or npcBot:GetActiveMode() == BOT_MODE_RETREAT then
            if npcBot:WasRecentlyDamagedByAnyHero(2.0) and npcBot:GetHealth()/npcBot:GetMaxHealth() <= 0.6 then -- TODO: get recent physical and magical damage
                npcBot:Action_UseAbility(ghost)
                return
            end
        end
    end

    local itemEtherealBlade = IsItemAvailable("item_ethereal_blade")
    if itemEtherealBlade and itemEtherealBlade:IsFullyCastable() then
        if npcTarget ~= nil and AbilityExtensions:NormalCanCast(npcTarget) then
            npcBot:Action_UseAbilityOnEntity(itemEtherealBlade, npcBot)
            return
        end
    end

    local itemDagon = AbilityExtensions:Aggregate(nil, AbilityExtensions:Range(1, 5), function(seed, dagonLevelIndex)
        return seed or IsItemAvailable("item_dagon_"..dagonLevelIndex)
    end)
    if itemDagon and itemDagon:IsFullyCastable() then
        if npcTarget ~= nil and AbilityExtensions:NormalCanCast(npcTarget) then
            npcBot:Action_UseAbilityOnEntity(itemDagon, npcBot)
            return
        end
    end

    local glimer = IsItemAvailable("item_glimmer_cape")
    if glimer ~= nil and glimer:IsFullyCastable() then
        if
            (npcBot:GetHealth() / npcBot:GetMaxHealth() < 0.45 and
                (tableNearbyEnemyHeroes ~= nil and #tableNearbyEnemyHeroes > 0)) or
                (tableNearbyEnemyHeroes ~= nil and #tableNearbyEnemyHeroes >= 3 and
                    npcBot:GetHealth() / npcBot:GetMaxHealth() < 0.65)
         then
            npcBot:Action_UseAbilityOnEntity(glimer, npcBot)
            return
        end
    end

    local hod = IsItemAvailable("item_helm_of_the_overlord") or IsItemAvailable("item_helm_of_the_dominator")
    if hod ~= nil and hod:IsFullyCastable() then
        local maxHP = 0
        local NCreep = nil
        local tableNearbyCreeps = npcBot:GetNearbyCreeps(1000, true)
        if #tableNearbyCreeps >= 2 then
            for _, creeps in pairs(tableNearbyCreeps) do
                local CreepHP = creeps:GetHealth()
                if
                    CreepHP > maxHP and (creeps:GetHealth() / creeps:GetMaxHealth()) > .75 and
                        not creeps:IsAncientCreep()
                 then
                    NCreep = creeps
                    maxHP = CreepHP
                end
            end
        end
        if NCreep ~= nil then
            npcBot:Action_UseAbilityOnEntity(hod, NCreep)
            return
        end
    end

    if glimer ~= nil and glimer:IsFullyCastable() then
        local Allies = npcBot:GetNearbyHeroes(1000, false, BOT_MODE_NONE)
        for _, Ally in pairs(Allies) do
            if
                (Ally:GetHealth() / Ally:GetMaxHealth() < 0.35 and tableNearbyEnemyHeroes ~= nil and
                    #tableNearbyEnemyHeroes > 0 and
                    CanCastOnTarget(Ally)) or
                    (IsDisabled(Ally) and CanCastOnTarget(Ally))
             then
                npcBot:Action_UseAbilityOnEntity(glimer, Ally)
                return
            end
        end
    end

    local function NotSuitableForGuardianGreaves(t)
        return not t:HasModifier("modifier_ice_blast") and not t:HasModifier("modifier_item_mekansm_noheal") and not t:HasModifier("modifier_item:guardian_greaves_noheal")
    end
    local guardian = IsItemAvailable("item_guardian_greaves")
    if guardian ~= nil and guardian:IsFullyCastable() then
        local allys = npcBot:GetNearbyHeroes(1000, false, BOT_MODE_NONE)
        allys = AbilityExtensions:Filter(allys, NotSuitableForGuardianGreaves)
        for _, ally in pairs(allys) do
            if ally:GetHealth() / ally:GetMaxHealth() < 0.35 and tableNearbyEnemyHeroes ~= nil and #tableNearbyEnemyHeroes > 0 then
                npcBot:Action_UseAbility(guardian)
                return
            end
        end
    end

    local satanic = IsItemAvailable("item_satanic")
    if satanic ~= nil and satanic:IsFullyCastable() and notBlasted then
        if
            npcBot:GetHealth() / npcBot:GetMaxHealth() < 0.50 and tableNearbyEnemyHeroes ~= nil and
                #tableNearbyEnemyHeroes > 0 and
                npcBot:GetActiveMode() == BOT_MODE_ATTACK
        then
            npcBot:Action_UseAbility(satanic)
            return
        end
    end

    local ggr = IsItemAvailable("item_guardian_greaves")
    if ggr ~= nil and ggr:IsFullyCastable() then
        local allys = npcBot:GetNearbyHeroes(900, false, BOT_MODE_NONE)
        allys = AbilityExtensions:Filter(allys, NotSuitableForGuardianGreaves)
        local factor = 0

        for k, v in pairs(allys) do
            local allyFactor = (2 - v:GetMana() / v:GetMaxMana() - v:GetHealth() / v:GetMaxHealth()) * 0.5
            factor = factor + allyFactor
        end

        if factor / #allys > 0.5 - 0.2 * math.log(#allys) / math.log(6) then
            npcBot:Action_UseAbility(ggr)
            return
        end
    end

    --[[local mgw=IsItemAvailable("item_magic_wand");
	if mgw~=nil and mgw:IsFullyCastable() then
		if npcBot:GetMana()/npcBot:GetMaxMana() - npcBot:GetHealth()/npcBot:GetMaxHealth() <= 1 and mgw:GetCurrentCharges()>=15
		then
			npcBot:Action_UseAbility(mgw);
			return;
		end
	end

	local mgs=IsItemAvailable("item_flask");
	if mgs~=nil and mgs:IsFullyCastable() then
		if npcBot:GetMana()/npcBot:GetMaxMana() - npcBot:GetHealth()/npcBot:GetMaxHealth() <= 1 and mgs:GetCurrentCharges()>=8
		then
			npcBot:Action_UseAbility(mgs);
			return;
		end
	end]]
    local stick = IsItemAvailable("item_magic_stick")
    if stick ~= nil and stick:IsFullyCastable() and stick:GetCurrentCharges() > 0 and notBlasted then
        if DotaTime() > 0 then
            local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes(500, true, BOT_MODE_NONE)
            if
                ((npcBot:GetHealth() / npcBot:GetMaxHealth() < 0.4 or npcBot:GetMana() / npcBot:GetMaxMana() < 0.2) and
                    #tableNearbyEnemyHeroes >= 1 and
                    GetItemCharges(npcBot, "item_magic_stick") >= 1) or
                    ((npcBot:GetHealth() / npcBot:GetMaxHealth() < 0.7 and npcBot:GetMana() / npcBot:GetMaxMana() < 0.7) and
                        GetItemCharges(npcBot, "item_magic_stick") >= 7)
             then
                npcBot:Action_UseAbility(stick)
                return
            end
        end
    end

    local wand = IsItemAvailable("item_magic_wand")
    if wand ~= nil and wand:IsFullyCastable() and wand:GetCurrentCharges() > 0 and notBlasted then
        if DotaTime() > 0 then
            local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes(500, true, BOT_MODE_NONE)
            if
                ((npcBot:GetHealth() / npcBot:GetMaxHealth() < 0.4 or npcBot:GetMana() / npcBot:GetMaxMana() < 0.2) and
                    #tableNearbyEnemyHeroes >= 1 and
                    GetItemCharges(npcBot, "item_magic_wand") >= 1) or
                    ((npcBot:GetHealth() / npcBot:GetMaxHealth() < 0.7 and npcBot:GetMana() / npcBot:GetMaxMana() < 0.7) and
                        GetItemCharges(npcBot, "item_magic_wand") >= 12)
             then
                npcBot:Action_UseAbility(wand)
                return
            end
        end
    end

    local holyLocket = IsItemAvailable("item_holy_locket")
    if holyLocket ~= nil and holyLocket:IsFullyCastable() and notBlasted then
        if DotaTime() > 0 then
            local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes(500, true, BOT_MODE_NONE)
            if
            ((npcBot:GetHealth() / npcBot:GetMaxHealth() < 0.4 or npcBot:GetMana() / npcBot:GetMaxMana() < 0.2) and
                    #tableNearbyEnemyHeroes >= 1 and
                    GetItemCharges(npcBot, "item_holy_locket") >= 1) or
                    ((npcBot:GetHealth() / npcBot:GetMaxHealth() < 0.7 and npcBot:GetMana() / npcBot:GetMaxMana() < 0.7) and
                            GetItemCharges(npcBot, "item_holy_locket") >= 12)
            then
                npcBot:Action_UseAbilityOnEntity(wand, npcBot)
                return
            end
        end
    end

    local bottle = IsItemAvailable("item_bottle")
    if bottle ~= nil and bottle:IsFullyCastable() and notBlasted then
        local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes(650, true, BOT_MODE_NONE)
        if GetItemCharges(npcBot, "item_bottle") > 0 and not npcBot:HasModifier("modifier_bottle_regeneration") then
            if
                ((npcBot:GetHealth() / npcBot:GetMaxHealth() < 0.65 and npcBot:GetMana() / npcBot:GetMaxMana() < 0.45) or
                    npcBot:GetHealth() / npcBot:GetMaxHealth() < 0.4 or
                    npcBot:GetMana() / npcBot:GetMaxMana() < 0.2) and
                    #tableNearbyEnemyHeroes == 0
             then
                npcBot:Action_UseAbilityOnEntity(bottle, npcBot)
                return
            end
        end
    end

    local cyclone = IsItemAvailable("item_cyclone") or IsItemAvailable("item_wind_waker")
    if cyclone ~= nil and cyclone:IsFullyCastable() then
        if
            npcTarget ~= nil and (npcTarget:IsChanneling() and not AbilityExtensions:IsOrGoingToBeSeverelyDisabled(npcTarget) or AbilityExtensions:CannotBeKilledNormally(npcTarget)) and
                CanCastOnTarget(npcTarget) and
                GetUnitToUnitDistance(npcBot, npcTarget) < 775
         then
            npcBot:Action_UseAbilityOnEntity(cyclone, npcTarget)
            return
        end
    end

    local metham = IsItemAvailable("item_meteor_hammer")
    if metham ~= nil and metham:IsFullyCastable() then
        local tableNearbyAttackingAlliedHeroes = npcBot:GetNearbyHeroes(1000, false, BOT_MODE_ATTACK)
        if
            (npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
                npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT)
         then
            local towers = npcBot:GetNearbyTowers(800, true)
            if #towers > 0 and towers[1] ~= nil and towers[1]:IsInvulnerable() == false then
                npcBot:Action_UseAbilityOnLocation(metham, towers[1]:GetLocation())
                return
            end
        elseif (#tableNearbyAttackingAlliedHeroes >= 2) then
            local locationAoE = npcBot:FindAoELocation(true, true, npcBot:GetLocation(), 600, 300, 0, 0)
            if (locationAoE.count >= 2) then
                npcBot:Action_UseAbilityOnLocation(metham, locationAoE.targetloc)
                return
            end
        elseif
            (npcBot:GetActiveMode() == BOT_MODE_ROAM or npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
                npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
                npcBot:GetActiveMode() == BOT_MODE_ATTACK)
         then
            if
                npcTarget ~= nil and npcTarget:IsHero() and CanCastOnTarget(npcTarget) and
                    GetUnitToUnitDistance(npcBot, npcTarget) < 800 and
                    IsDisabled(true, npcTarget) == true
             then
                npcBot:Action_UseAbilityOnLocation(metham, npcTarget:GetLocation())
                return
            end
        end
    end

    local sv = IsItemAvailable("item_spirit_vessel")
    if sv ~= nil and sv:IsFullyCastable() and sv:GetCurrentCharges() > 0 then
        if
            (npcBot:GetActiveMode() == BOT_MODE_ROAM or npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
                npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
                npcBot:GetActiveMode() == BOT_MODE_ATTACK)
         then
            if
                npcTarget ~= nil and npcTarget:IsHero() and AbilityExtensions:MayNotBeIllusion(npcBot, npcTarget) and CanCastOnTarget(npcTarget) and
                    GetUnitToUnitDistance(npcBot, npcTarget) < 900 and
                    npcTarget:HasModifier("modifier_item_spirit_vessel_damage") == false and
                    npcTarget:GetHealth() / npcTarget:GetMaxHealth() < 0.65 and
                    not npcTarget:HasModifier("modifier_ice_blast")
             then
                npcBot:Action_UseAbilityOnEntity(sv, npcTarget)
                return
            end
        else
            local Allies = npcBot:GetNearbyHeroes(1150, false, BOT_MODE_NONE)
            for _, Ally in pairs(Allies) do
                if
                    not Ally:IsIllusion() and Ally:HasModifier("modifier_item_spirit_vessel_heal") == false and CanCastOnTarget(Ally) and
                        Ally:GetHealth() / Ally:GetMaxHealth() < 0.35 and
                        #tableNearbyEnemyHeroes == 0 and
                        Ally:WasRecentlyDamagedByAnyHero(2.5) == false and
                        not Ally:HasModifier("modifier_ice_blast")
                 then
                    npcBot:Action_UseAbilityOnEntity(sv, Ally)
                    return
                end
            end
        end
    end

    local nullifier = IsItemAvailable("item_nullifier")
    if nullifier ~= nil and nullifier:IsFullyCastable() then
        if
            (npcBot:GetActiveMode() == BOT_MODE_ROAM or npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
                npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
                npcBot:GetActiveMode() == BOT_MODE_ATTACK)
         then
            if
                npcTarget ~= nil and npcTarget:IsHero() and CanCastOnTarget(npcTarget) and
                    GetUnitToUnitDistance(npcBot, npcTarget) < 800 and
                    npcTarget:HasModifier("modifier_item_nullifier_mute") == false
             then
                npcBot:Action_UseAbilityOnEntity(nullifier, npcTarget)
                return
            end
        end
    end

    -- test code --

    -- local wards=IsItemAvailable("item_ward_dispenser");

    -- if(wards~=nil)
    -- then
    -- 	local sentry=wards:GetSecondaryCharges();
    -- 	local observer= wards:GetCurrentCharges();
    -- 	local state=wards:GetToggleState();
    -- 	print(npcBot:GetUnitName().."2nd Charge:"..sentry.." 1st Charge"..observer);

    -- 	if(state==true)
    -- 	then
    -- 		npcBot:Action_UseAbilityOnEntity(wards,npcBot);
    -- 		print("state true")
    -- 	else
    -- 		npcBot:Action_UseAbilityOnEntity(wards,npcBot);
    -- 		print("state false")
    -- 	end

    -- end

    local WardList = GetUnitList(UNIT_LIST_ALLIED_WARDS)
    local HaveWard = false

    for _, ward in pairs(WardList) do
        if (GetUnitToUnitDistance(ward, npcBot) <= 1500) then
            HaveWard = true
        end
    end

    local sentry = IsItemAvailable("item_ward_sentry")
    if sentry ~= nil and sentry:IsFullyCastable() and sentry:IsCooldownReady() then
        local NearbyTowers = npcBot:GetNearbyTowers(1600, true)
        local NearbyTowers2 = npcBot:GetNearbyTowers(800, true)
        local NearbyTowers3 = npcBot:GetNearbyTowers(800, false)

        if HaveWard == false then
            if (npcBot:GetActiveMode() == BOT_MODE_ATTACK) then
                npcBot:Action_UseAbilityOnLocation(sentry, npcBot:GetLocation())
            end

            if
                npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
                    npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT and #NearbyTowers2 == 0 and #NearbyTowers > 0
             then
                npcBot:Action_UseAbilityOnLocation(sentry, npcBot:GetXUnitsInBehind(300))
            end

            if
                npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
                    npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
                    npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT and #NearbyTowers3 == 0
             then
                npcBot:Action_UseAbilityOnLocation(sentry, npcBot:GetXUnitsInFront(300))
            end
        end
    end
end

return M
