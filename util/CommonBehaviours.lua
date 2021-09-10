---------------------------------------------
-- Generated from Mirana Compiler version 1.5.1
-- Do not modify
-- https://github.com/AaronSong321/Mirana
---------------------------------------------
local fun1 = require(GetScriptDirectory().."/util/AbilityAbstraction")
local M = {}
local bot = GetBot()
local function AvoidWintersCurse()
    do
        local cursedOne = fun1:GetNearbyHeroes(bot, 800, false):First(function(t)
            t:HasModifier "modifier_winter_wyvern_winters_curse_aura"
        end)
        if cursedOne then
            local location = cursedOne:GetLocation()
            location.z = 525 + bot:GetBoundingRadius()
            local zone = AddAvoidanceZone(location)
            print("add zone "..tostring(zone))
            fun1:StartCoroutine(function(deltaTime)
                fun1:WaitForSeconds(cursedOne:GetModifierRemainingDuration "modifier_winter_wyvern_winters_curse_aura")
                RemoveAvoidanceZone(zone)
            end)
        end
    end
end
local Think = fun1:EveryManySeconds(0.5, function(deltaTime)
    AvoidWintersCurse()
end)
function M.Think()
    Think()
end
return M
