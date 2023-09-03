local fun1 = require(GetScriptDirectory() .. "/util/AbilityAbstraction")
local A = require(GetScriptDirectory() .. "/util/MiraDota")
local M = {}
local avoidCurseList = fun1:NewTable()
local bot
local AvoidWintersCurse = fun1:EveryManySeconds(0.3, function()
    local l = bot._commonBehaviours_alt
    do
        local cursedOne = fun1:GetNearbyHeroes(bot, 800, false):First(function(t)
            return t:HasModifier "modifier_winter_wyvern_winters_curse_aura"
        end)
        if cursedOne then
            if not bot:IsMagicImmune() and not l.avoidCurseList:Contains(cursedOne) then
                table.insert(l.avoidCurseList, cursedOne)
                local location = cursedOne:GetLocation()
            end
        end
    end
end)
local AvoidFirestorm = fun1:EveryManySeconds(1, function()
    local l = bot._commonBehaviours_alt
    return fun1:GetNearbyHeroes(bot, 800, false):Concat(fun1:GetNearbyCreeps(bot, 800, false)):All(function(t)
        return t:HasModifier "modifier_abyssal_underlord_firestorm_burn"
    end):ForEach(function(t)
        if not l.avoidFirestorm:Contains(t) then
            local location
            t:GetLocation()
            location.z = 500 + bot:GetBoundingRadius()
            local zone = AddAvoidanceZone(location)
            fun1:StartCoroutine(function()
                while t:HasModifier "modifier_winter_wyvern_winters_curse_aura" do
                    coroutine.yield()
                end
                RemoveAvoidanceZone(zone)
                return l.avoidFirestorm:Remove_Modify(t)
            end)
        end
    end)
end)
local Init = function()
    if bot._commonBehaviours_alt == nil then
        bot._commonBehaviours_alt = {
            avoidCurseList = fun1:NewTable(),
            avoidFirestorm = fun1:NewTable(),
        }
    end
end
local pushModes = A.Linq.NewTable(BOT_MODE_PUSH_TOWER_BOT, BOT_MODE_PUSH_TOWER_MID, BOT_MODE_PUSH_TOWER_TOP)
local function IsPushingMode(mode)
    return pushModes:Contains(mode)
end

local NoNearbyEnemiesWhenLaning = function()
    if bot:GetActiveMode() == BOT_MODE_LANING or
        IsPushingMode(bot:GetActiveMode()) and A.Dota.GetNearbyHeroes(bot, 1600):Count() == 0 then
        if bot.noNearbyEnemiesWhenLaningTime == nil then
            bot.noNearbyEnemiesWhenLaningTime = DotaTime()
        end
        if bot.noNearbyEnemiesWhenLaningTime - DotaTime() > 3 then
            bot.pushWhenNoEnemies = true
        end
    else
        bot.pushWhenNoEnemies = nil
    end
end
local Think = function()
    AvoidWintersCurse()
    NoNearbyEnemiesWhenLaning()
end
function M.Think()
    bot = GetBot()
    Init()
    Think()
end

return M
