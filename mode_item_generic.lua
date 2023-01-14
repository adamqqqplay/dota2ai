---------------------------------------------
-- Generated from Mirana Compiler version 1.6.2
-- Do not modify
-- https://github.com/AaronSong321/Mirana
---------------------------------------------
local fun1 = require(GetScriptDirectory() .. "/util/AbilityAbstraction")
local bot = GetBot()
local function PrintCarriedItems(bot)
    print(bot:GetUnitName() .. " has items:")
    for i = 0, 8 do
        do
            local item = bot:GetItemInSlot(i)
            if item then
                print(i .. " " .. item:GetName())
            end
        end
    end
end

function OnStart()
    bot = GetBot()
end

function OnEnd()
end
