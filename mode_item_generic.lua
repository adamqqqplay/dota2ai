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