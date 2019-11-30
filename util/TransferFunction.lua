local Transfer = {}

-- -- Table可视化，测试用
-- local function serializeTable(val, name, skipnewlines, depth)
--     skipnewlines = skipnewlines or false
--     depth = depth or 0

--     local tmp = string.rep(" ", depth)

--     if name then tmp = tmp .. name .. " = " end

--     if type(val) == "table" then
--         tmp = tmp .. "{" .. (not skipnewlines and "\n" or "")

--         for k, v in pairs(val) do
--             tmp =  tmp .. serializeTable(v, k, skipnewlines, depth + 1) .. "," .. (not skipnewlines and "\n" or "")
--         end

--         tmp = tmp .. string.rep(" ", depth) .. "}"
--     elseif type(val) == "number" then
--         tmp = tmp .. tostring(val)
--     elseif type(val) == "string" then
--         tmp = tmp .. string.format("%q", val)
--     elseif type(val) == "boolean" then
--         tmp = tmp .. (val and "true" or "false")
--     else
--         tmp = tmp .. "\"[inserializeable datatype:" .. type(val) .. "]\""
--     end

--     return tmp
-- end

-- -- API简单模拟，测试用
-- function GetItemComponents(item)
--     local output = {}
--     if item == "item_guardian_greaves" then
--         output = {{
--             "test1","test2","test3"
--         }
--         }
--     elseif item == "test1" then
--         output = {
--             {
--                 "test1_1","test1_2"
--             }
--         }
--     end
--     return output
-- end


-- 输入物品列表，输出含有全部配件的列表
function Transfer.Transfer(itemtable)
    local output = {}
    for key, value in pairs(itemtable) do
        if type(value) == "table" then
            for k,v in pairs(value) do
                local recipe = GetItemComponents(v)
                if next(recipe) == nil then
                    table.insert(output, v)
                else
                    local new = Transfer.Transfer(recipe)
                    for k2, v2 in pairs(new) do
                        table.insert(output, v2)
                    end
                end
            end
        else
            local recipe = GetItemComponents(value)
            if next(recipe) == nil then
                table.insert(output, value)
            else
                local new = Transfer.Transfer(recipe)
                for k3, v3 in pairs(new) do
                    table.insert(output, v3)
                end
            end
        end
    end
    return output
end

return Transfer