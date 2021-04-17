local M = {}

local binlib = require(GetScriptDirectory().."/util/BinDecHex")

M.Range = function(self, min, max, step)
    if step == nil then step = 1 end
    local g = {}
    for i = min, max, step do
        table.insert(g, i)
    end
    return g
end

M.Contains = function(self, tb, value, compare)
    compare = compare or function(a, b) return a == b end
    for _, v in ipairs(tb) do
        if compare(v, value) then
            return true
        end
    end
    return false
end

M.Filter = function(self, tb, filter)
    local g = {}
    for k, v in ipairs(tb) do
        if filter(v, k) then
            table.insert(g, v)
        end
    end
    return g
end
M.FilterNot = function(self, tb, filter)
    local g = {}
    for k, v in ipairs(tb) do
        if not filter(v, k) then
            table.insert(g, v)
        end
    end
    return g
end

M.Count = function(self, tb, filter)
    local g = 0
    for k, v in ipairs(tb) do
        if filter == nil or filter(v, k) then
            g = g + 1
        end
    end
    return g
end

M.Map = function(self, tb, transform)
    local g = {}
    for k, v in pairs(tb) do
        g[k] = transform(v)
    end
    return g
end

M.ForEach = function(self, tb, action)
    for k, v in pairs(tb) do
        action(v, k)
    end
end

M.Any = function(self, tb, filter)
    for k, v in pairs(tb) do
        if filter == nil or filter(v, k) then
            return true
        end
    end
    return false
end

M.All = function(self, tb, filter)
    for k, v in pairs(tb) do
        if not filter(v, k) then
            return false
        end
    end
    return true
end

M.Aggregate = function(self, seed, tb, aggregate)
    for k, v in pairs(tb) do
        seed = aggregate(seed, v, k)
    end
    return seed
end

M.ShallowCopy = function(self, tb)
    local g = {}
    for k, v in pairs(tb) do
        g[k] = v
    end
    return g
end

M.First = function(self, tb, filter)
    for k, v in ipairs(tb) do
        if filter == nil or filter(v, k) then
            return v
        end
    end
end

M.Skip = function(self, tb, number)
    local g = {}
    local i = 0
    for _, v in ipairs(tb) do
        i = i + 1
        if i > number then
            table.insert(g, v)
        end
    end
    return g
end

M.Take = function(self, tb, number)
    local g = {}
    local i = 0
    for _, v in ipairs(tb) do
        i = i + 1
        if i <= number then
            table.insert(g, v)
        else
            break
        end
    end
    return g
end

local function deepCopy(self, tb)
    local copiedTables = {}
    local g = {}
    table.insert(copiedTables, tb)
    for k, v in pairs(tb) do
        if type(v) ~= "table" then
            g[k] = v
        else
            if self:Contains(copiedTables, v) then
                print("Copy loop!")
                return {}
            end
            g[k] = deepCopy(self, v)
        end
    end
    return g
end
M.DeepCopy = deepCopy

M.Concat = function(self, a, b)
    if type(a) ~= "table" or type(b) ~= "table" then
        return a..b
    end
    local g = self:ShallowCopy(a)
    for _, v in ipairs(b) do
        table.insert(g, v)
    end
    return g
end

M.Remove = function(self, a, b)
    local g = self:ShallowCopy(a)
    for k,v in pairs(a) do
        if v == b then
            g[k] = nil
        end
    end
    return g
end
M.RemoveAll = function(self, a, b)
    local g = {}
    for _,v in pairs(a) do
        if not self:Contains(b, v) then
            table.insert(g, v)
        end
    end
    return g
end

M.Prepend = function(self, a, b)
    return self:Concat(b, a)
end

M.Distinct = function(self, tb, compare)
    compare = compare or function(a, b) return a == b end
    local g = {}
    for _, v in pairs(tb) do
        if not self:Contains(tb, v, compare) then
            table.insert(g, v)
        end
    end
    return g
end

M.Reverse = function(self, tb) 
    local g = {}
    for i = #tb, 1, -1 do
        table.insert(g, tb[i])
    end
    return g
end

M.Last = function(self, tb, filter)
    return self:First(self:Reverse(tb), filter)
end

M.Repeat = function(self, element, count)
    local g = {}
    for i = 1, count do
        table.insert(g, element)
    end
    return g 
end

M.Select = M.Map
M.SelectMany = function(self, tb, map, filter)
    local g = {}
    for _, source in ipairs(tb) do
        local collection = map(source)
        for index, value in ipairs(collection) do
            if filter == nil or filter(value, index) then
                table.insert(g, value)
            end
        end
    end
    return g
end

M.SkipLast = function(self, tb, number)
    return self:Skip(self:Reverse(tb), number)
end

M.Replace = function(self, tb, filter, map)
    local g = {}
    for k, v in ipairs(tb) do
        if filter(v, k) then
            table.insert(g, map(v, k))
        else
            table.insert(g, v)
        end
    end
    return g
end

M.Zip2 = function(self, tb1, tb2, map) 
    if map == nil then
        map = function(a, b)
            return {a, b}
        end
    end
    local g = {}
    for i = 1, #tb1 do
        table.insert(g, map(tb1[i], tb2[i]))
    end
    return g
end

M.ForEach2 = function(self, tb1, tb2, func)
    for i = 1, #tb1 do
        func(tb1[i], tb2[i])
    end
end

M.Map2 = function(self, tb1, tb2, map)
    local g = {}
    for i = 1, #tb1 do
        table.insert(g, map(tb1[i], tb2[i], i))
    end
    return g 
end

M.Filter2 = function(self, tb1, tb2, filter, map)
    if map == nil then
        map = function(a,b,c) return {a,b,c} end
    end
    local g = {}
    for i = 1, #tb1 do
        if filter(tb1[i], tb2[i], i) then
            table.insert(map(tb1[i], tb2[i], i))
        end
    end
    return g 
end

M.SlowSort = function(self, tb, sort)
    local g = self:ShallowCopy(tb)
    local len = #g
    if sort ~= nil then
        for i = 1, len-1 do
            for j = i+1, len do
                if sort(g[i], g[j]) > 0 then
                    g[i], g[j] = g[j], g[i]
                end
            end
        end
    else
        for i = 1, len-1 do
            for j = i+1, len do
                if g[i] > g[j] then
                    g[i], g[j] = g[j], g[i]
                end
            end
        end
    end
    return g
end

M.MergeSort = function(self, tb, sort)
    if sort == nil then
        sort = function(a, b) return a-b end
    end
    local function Merge(a, b)
        local g = {}
        local aLen = #a
        local bLen = #b
        local i = 1
        local j = 1
        while i <= aLen and j <= bLen do
            if sort(a[i], b[j]) > 0 then
                table.insert(g, b[j])
                j = j+1
            else
                table.insert(g, a[i])
                i = i+1
            end
        end
        if i <= aLen then
            for _ = i, aLen do
                table.insert(g, a[i])
            end
        end
        if j <= bLen then
            for _ = j, bLen do
                table.insert(g, b[j])
            end
        end
        return g
    end
    local function SortRec(tab)
        local tableLength = #tab
        if tableLength == 1 then
            return tab
        end
        local left = SortRec(self:Take(tab, tableLength/2))
        local right = SortRec(self:Skip(tab, tableLength/2))
        local merge = Merge(left, right)
        return merge
    end
    return SortRec(tb)
end

M.Sort = M.SlowSort
M.SortByMaxFirst = function(self, tb, map)
    return self:Sort(tb, function(a, b)
        return map(b) - map(a)
    end)
end
M.SortByMinFirst = function(self, tb, map)
    return self:Sort(tb, function(a, b)
        return map(a) - map(b)
    end)
end

M.SeriouslyRetreatingStunSomeone = function(self, npcBot, abilityIndex, ability, targetType)
    if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0
	end
	
	local CastRange = ability:GetCastRange()
	local Damage = ability:GetAbilityDamage()
	local Radius = ability:GetAOERadius()
	local CastPoint = ability:GetCastPoint()
	
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE )
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange+300,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)

	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH ) then
		for _,npcEnemy in pairs( enemys )
		do
			if ( npcBot:WasRecentlyDamagedByHero( npcEnemy, 2.0 ) ) 
			then
				if ( CanCast[abilityNumber]( npcEnemy ) ) 
				then
					return BOT_ACTION_DESIRE_LOW, npcEnemy:GetExtrapolatedLocation(CastPoint)
				end
			end
		end
	end
end

local Trim = function(v, left, right)
    if right >= left then
        if v > right then
            return right
        elseif v < left then
            return left
        else
            return v
        end
    else
        if v > left then
            return left
        elseif v < right then
            return right
        else
            return v
        end
    end
end

M.TrimDesire = function(self, desire)
    return Trim(desire, 0, 1)
end

M.GetAbilityImportance = function(self, cooldown)
    return Trim(cooldown/120, 0, 1)
end

M.IsFarmingOrPushing = function(self, npcBot)
    local mode = npcBot:GetActiveMode()
    return mode==BOT_MODE_FARM or mode==BOT_MODE_PUSH_TOWER_BOT or mode==BOT_MODE_PUSH_TOWER_MID or mode==BOT_MODE_PUSH_TOWER_TOP
end

M.IsAttackingEnemies = function(self, npcBot)
    local mode = npcBot:GetActiveMode()
    return mode == BOT_MODE_ROAM or mode == BOT_MODE_TEAM_ROAM or mode == BOT_MODE_ATTACK or mode ==  BOT_MODE_DEFEND_ALLY
end

M.IsRetreating = function(self, npcBot)
    return npcBot:GetActiveMode() == BOT_MODE_RETREAT
end
M.NotRetreating = function(self, npcBot)
    return npcBot:GetActiveMode() ~= BOT_MODE_RETREAT
end

M.HasEnoughManaToUseAttackAttachedAbility = function(self, npcBot, ability)
    local percent = self:GetManaPercent(npcBot)
    if percent >= 0.8 and npcBot:GetMana() >= 650 then
        return true
    end
    return percent >= 0.4 and npcBot:GetMana() >= 300 and npcBot:GetManaRegen() >= npcBot:GetAttackSpeed() / 100 * ability:GetManaCost() * 0.75
end

-- turn a function that returns true, false, nil to a function that decides whether to toggle the ability or not
M.ToggleFunctionToAction = function(self, npcBot, oldConsider, ability)
    return function()
        local value, target, castType = oldConsider()
        if type(value) == "number" then
            return value, target, castType
        end
        if value ~= ability:GetToggleState() and ability:IsFullyCastable() then
            print("in function ToggleFunctionToAction "..ability:GetName().." "..tostring(value).." "..tostring(ability:GetToggleState()))
            return BOT_ACTION_DESIRE_HIGH
        else
            return 0
        end
    end
end
M.ToggleFunctionToAutoCast = function(self, npcBot, oldConsider, ability)
    return function()
        local value, target, castType = oldConsider()
        if type(value) == "number" then
            return value, target, castType
        end
        if ability:IsFullyCastable() and value ~= ability:GetAutoCastState() then
            ability:ToggleAutoCast()
        end
        return 0
    end
end

M.IsChannelingItem = function(self, npc)
    return npc:HasModifier("modifier_item_meteor_hammer") or npc:HasModifier("modifier_teleporting") or npc:HasModifier("modifier_boots_of_travel_incoming")
end

M.IsChannelingAbility = function(self, npc)
    return npc:IsChanneling() and not self:IsChannelingItem(npc)
end

local GetOtherTeam = function(team)
    if team == TEAM_RADIANT then
        return TEAM_DIRE
    end
    if team == TEAM_DIRE then
        return TEAM_RADIANT
    end
end

M.RadiantPlayerId = GetTeamPlayers(TEAM_RADIANT)
M.DirePlayerId = GetTeamPlayers(TEAM_DIRE)

M.GetTeamPlayers = function(self, team)
    if team == TEAM_RADIANT then
        return self.RadiantPlayerId
    else
        return self.DirePlayerId
    end
end

M.MustBeIllusion = function(self, npcBot, target)
    if npcBot:GetTeam() == target:GetTeam() then
        return target:IsIllusion() and not target:HasModifier("modifier_skeleton_king_reincarnation_active")
    end
    if self:Contains(self:GetTeamPlayers(npcBot:GetTeam()), target:GetPlayerID()) then
        return true
    end
    return false
end
M.MayNotBeIllusion = function(self, npcBot, target) return not self:MustBeIllusion(npcBot, target) end

M.GetNearbyNonIllusionHeroes = function(self, npcBot, range, getEnemy, botModeMask)
    botModeMask = botModeMask or BOT_MODE_NONE
    local heroes = npcBot:GetNearbyHeroes(range, getEnemy, botModeMask)
    return self:Filter(heroes, function(t) return self:MayNotBeIllusion(npcBot, t) end)
end

M.GetNearbyAllUnits = function(self, npcBot, range)
    local h1 = npcBot:GetNearbyHeroes(range, true, BOT_MODE_NONE)
    local h2 = self:Remove(npcBot:GetNearbyHeroes(range, false, BOT_MODE_NONE), npcBot)
    local h3 = npcBot:GetNearbyCreeps(range, true)
    local h4 = npcBot:GetNearbyCreeps(range, false)
    return self:Concat(h1, h2, h3, h4)
end

M.GetEnemyHeroUnique = function(self, npcBot, enemies)
    local p = self:Filter(enemies, function(t) self:MayNotBeIllusion(npcBot, t) end)
    local g = {}
    local readNames = {}
    for _, enemy in pairs(p) do
        local name = enemy:GetUnitName()
        if not self:Contains(readNames, name) then
            table.insert(readNames, name)
            table.insert(g, enemy)
        end
    end
    return g
end

M.GetMovementSpeedPercent = function(self, npc)
    return npc:GetCurrentMovementSpeed() / npc:GetBaseMovementSpeed()
end
M.CanHardlyMove = function(self, npc)
    return npc:IsStunned() or npc:IsRooted() or npc:GetCurrentMovementSpeed() <= 150
end

M.GetModifierRemainingDuration = function(self, npc, modifierName)
    local mod = npc:GetModifierByName(modifierName)
    if mod ~= -1 then
        return npc:GetModifierRemainingDuration(mod)
    end
    return nil
end
M.ImprisonmentModifier = {
    "modifier_item_cyclone",
    "modifier_item_wind_waker",
    "modifier_shadow_demon_disruption",
    "modifier_obsidian_destroyer_astral_imprisonment_prison",
    "modifier_brewmaster_storm_cyclone",
    "modifier_invoker_tornado",
    --"modifier_x_marks_the_target",
}
M.GetImprisonmentRemainingDuration = function(self, npc)
    return self:First(self:Map(self.ImprisonmentModifier, function(t) return self:GetModifierRemainingDuration(npc, t)  end), function(t) return t ~= nil  end)
end

M.GetEnemyHeroNumber = function(self, npcBot, enemies)
    return #self:GetEnemyHeroUnique(npcBot, enemies)
end

M.GetAvailableItem = function(self, npc, itemName)
    for i = 0,6 do
        local item = npc:GetItemInSlot(i)
        if item ~= nil and item:GetName() == itemName then
            return item
        end
    end
end

M.GetAvailableBlink = function(self, npc)
    local blinks = {
        "item_blink",
        "item_overwhelming_blink",
        "item_swift_blink",
        "item_arcane_blink",
    }
    return self:Aggregate(nil, blinks, function(a, blinkName)
        return a or self:GetAvailableItem(blinkName)
    end)
end

M.GetEmptyItemSlots = function(self, npc)
    local g = 0
    for i = 0, 8 do
        if npc:GetItemInSlot(i) == nil then
            g = g+1
        end
    end
    return g
end

M.GetEmptyBackpackSlots = function(self, npc)
    local g = 0
    for i = 6, 8 do
        if npc:GetItemInSlot(i) == nil then
            g = g+1
        end
    end
    return g
end

M.SwapItemToBackpack = function(self, npc, itemIndex)
    for i = 6,8 do
        if npc:GetItemInSlot(i) == nil then
            npc:ActionImmediate_SwapItems(itemIndex, i)
            return true
        end
    end
    return false
end

M.GetCarriedItems = function(self, npc)
    local g = {}
    for i = 0, 8 do
        local item = npc:GetItemInSlot(i)
        if item ~= nil then
            item.slotIndex = i
            table.insert(g, item)
        end
    end
    return g
end

M.GetInventoryItems = function(self, npc)
    local g = {}
    for i = 0, 6 do
        local item = npc:GetItemInSlot(i)
        if item ~= nil then
            item.slotIndex = i
            table.insert(g, item)
        end
    end
    return g
end

M.IsBoots = function(self, item)
    if type(item) ~= "string" then
        item = item:GetName()
    end
    return string.match(item, "boots") or item == "item_guardian_greaves"
end

M.SwapCheapestItemToBackpack = function(self, npc)
    local cheapestItem = self:First(self:Sort(self:Filter(self:GetInventoryItems(npc), function(t) return not self:IsBoots(t) end), function(a, b) return GetItemCost(a:GetName()) - GetItemCost(b:GetName()) end))
    if cheapestItem == nil then
        print(npc:GetUnitName()..": only have shoes in inventory")
        return false
    end
    return self:SwapItemToBackpack(npc, cheapestItem.slotIndex)
end

M.SuitableForSilence = function(self, npc, target)
    return self:MayNotBeIllusion(npc, target) and not target:IsMagicImmune() and not target:IsInvulnerable()
end

local heroNameTable = {}
setmetatable(heroNameTable, {
    __index = function(tb, s) return "npc_dota_hero_"..s  end
})
M.GetHeroFullName = function(self, s)
    return "npc_dota_hero_"..s
end
M.GetHeroShortName = function(self, s)
    return string.sub(s, 12)
end

M.IsMeleeHero = function(self, npc)
    local range = npc:GetAttackRange()
    local name = npc:GetUnitName()
    return range <= 210 or name == self:GetHeroFullName("tiny") or name == self:GetHeroFullName("doom_bringer") or name == self:GetHeroFullName("pudge")
end

M.AttackPassiveAbilities = {
    "doom_bringer_infernal_blade",
    "drow_ranger_frost_arrows",
    "clinkz_fire_arrows",
    "viper_poison_attack",
    "obsidian_destroyer_arcane_orb",
}
M.OtherIgnoreAbilityBlockAbilities = {
    "batrider_flaming_lasso",
    "gyrocopter_homing_missle",
}
M.IgnoreAbilityBlockAbilities = {
    "dark_seer_ion_shell",
    "grimstroke_soulbind",
    "rubick_spell_steal",
    "spectre_spectral_dagger",
    "morphling_morph",
    "urn_of_shadows_soul_release",
    "spirit_vessel_soul_release",
    "medallion_of_courage_valor",
    "solar_crest_armor_shine",
}

M.IgnoreAbilityBlock = function(self, ability)
    local abilityName = ability:GetName()
    return self:Contains(self.AttackPassiveAbilities, abilityName) or self:Contains(self.IgnoreAbilityBlockAbilities, abilityName) or self:Contains(self.OtherIgnoreAbilityBlockAbilities, abilityName)
end

M.AbilityRetargetModifiers = {
    "modifier_antimage_counterspell",
    "modifier_item_lotus_orb_active",
    "modifier_nyx_assassin_spiked_carapace",
    "modifier_item_blade_mail",
}
M.HasAbilityRetargetModifier = function(self, npc)
    return self:Any(self.AbilityRetargetModifiers, function(t) return npc:HasModifier(t)  end)
end

M.DebugTable = function(self, tb)
    local msg = "{ "
    local DebugRec
    DebugRec = function(tc)
        for k,v in pairs(tc) do
            if type(v) == "number" or type(v) == "string" then
                msg = msg..k.." = "..v..", "
            elseif type(v) == "boolean" then
                msg = msg..k.." = "..tostring(v)..", "
            elseif type(v) == "table" then
                msg = msg..k.." = ".."{ "
                DebugRec(v)
                msg = msg.."}, "
            end
        end
    end
    DebugRec(tb)
    msg = msg.." }"
    print(msg)
end

M.DebugLongTable = function(self, tb)
    for k,v in pairs(tb) do
        if type(v) == "table" then
            print(tostring(k).." = ")
            self:DebugTable(v)
        else
            print(tostring(k).." = "..tostring(v))
        end
    end
end

M.DebugArray = function(self, tb)
    for k,v in ipairs(tb) do
        if type(v) == "table" then
            self:DebugTable(v)
        else
            print(v)
        end
    end
end

M.PrintAbilities = function(self, npcBot)
    local abilityNames = "{\n"
    for i = 0,30 do
        local abi = npcBot:GetAbilityInSlot(i)
        if abi ~= nil and abi:GetName() ~= "generic_hidden" then
            abilityNames = abilityNames.."\t\""..abi:GetName().."\",\n"
        end
    end
    abilityNames = abilityNames.."}"
    print(npcBot:GetUnitName())
    print(abilityNames)
end

M.SpecialBonusAttributes = "special_bonus_attributes"
M.TalentNamePrefix = "special_bonus_"
M.IncorrectAbilityName = "incorrect_name"

M.IsTalent = function(self, ability)
    if ability == nil then
        return false
    end
    if type(ability) ~= "string" then
        ability = ability:GetName()
    end
    return ability ~= "special_bonus_attributes" and #ability >= #self.TalentNamePrefix and string.sub(ability, 1, #self.TalentNamePrefix) == self.TalentNamePrefix
end

M.GetAbilities = function(self, npcBot)
    local g = {}
    for i = 0,25 do
        local abi = npcBot:GetAbilityInSlot(i)
        if abi ~= nil and abi:GetName() ~= "generic_hidden" then
            table.insert(g, abi)
        end
    end
    return g
end

M.GetAbilityNames = function(self, npcBot)
    return self:Map(self:GetAbilities(npcBot), function(t) return t:GetName() end)
end

M.GetTalents = function(self, npcBot)
    return self:Filter(self:GetAbilities(npcBot), function(t) return self:IsTalent(t) end)
end

M.GetAbilityLevelUpIndex = function(self, npcBot)
    return npcBot:GetLevel() - npcBot:GetAbilityPoints() + 1 + npcBot.abilityTable.incorrectAbilityLevelUpNumber
end

M.FillInAbilities = function(self, npcBot, abilityTable)
    local abilities = self:GetAbilityNames(npcBot)
    if #abilityTable == 19 then
        table.insert(abilityTable, 17, self.SpecialBonusAttributes)
        table.insert(abilityTable, 19, self.SpecialBonusAttributes)
        table.insert(abilityTable, 21, self.SpecialBonusAttributes)
        table.insert(abilityTable, 22, self.SpecialBonusAttributes)
        table.insert(abilityTable, 23, self.SpecialBonusAttributes)
        table.insert(abilityTable, 24, self.SpecialBonusAttributes)
        table.insert(abilityTable, 26, self.SpecialBonusAttributes)
    end
    for i = 1, 26 do
        if abilityTable[i] == "nil" then
            abilityTable[i] = self.SpecialBonusAttributes
        end
        if not self:Contains(abilities, abilityTable[i]) and abilityTable[i] ~= "talent" then
            print("Bot script "..npcBot:GetUnitName().." contains incorrect ability name: "..abilityTable[i])
            abilityTable[i] = self.IncorrectAbilityName
        end
    end
    if #abilityTable == 30 then
        return
    end

    local talents = self:Map(self:GetTalents(npcBot), function(t) return t:GetName()  end)
    local levelUpTalents = self:Filter(abilityTable, function(t) return self:IsTalent(t) end)
    local g = self:Concat(abilityTable, self:RemoveAll(talents, levelUpTalents))
    g.incorrectAbilityLevelUpNumber = self:Count(g, function(ability, index)
        return index < npcBot:GetLevel() - npcBot:GetAbilityPoints() + 1 and (ability == nil or not ability:CanAbilityBeUpgraded() or ability:GetName() == self.IncorrectAbilityName)
    end)
    npcBot.abilityTable = g
end

M.ExecuteAbilityLevelUp = function(self, npcBot)
    local abilityTable = npcBot.abilityTable
    if abilityTable.justLevelUpAbility then
        if abilityTable.abilityPoints == npcBot:GetAbilityPoints() then
            abilityTable.incorrectAbilityLevelUpNumber = abilityTable.incorrectAbilityLevelUpNumber + 1
        end
        abilityTable.justLevelUpAbility = false
    end
    abilityTable.abilityPoints = npcBot:GetAbilityPoints()
    if npcBot:GetAbilityPoints() < 1 + abilityTable.incorrectAbilityLevelUpNumber or GetGameState() ~= GAME_STATE_PRE_GAME and GetGameState() ~= GAME_STATE_GAME_IN_PROGRESS then
        return
    end
    local abilityName = abilityTable[self:GetAbilityLevelUpIndex(npcBot)]
    if abilityName == self.IncorrectAbilityName or abilityName == self.SpecialBonusAttributes then
        abilityTable.incorrectAbilityLevelUpNumber = abilityTable.incorrectAbilityLevelUpNumber + 1
    end
    npcBot:ActionImmediate_LevelAbility(abilityName)
    abilityTable.justLevelUpAbility = true
end

M.IsVector = function(self, object)
    return type(object)=="userdata" and type(object.x)=="number" and type(object.y)=="number" and type(object.z)=="number" and type(object.Length) == "function"
end
M.ToStringVector = function(self, object)
    return string.format("(%d,%d,%d)",object.x,object.y,object.z)
end

M.PreventAbilityAtIllusion = function(self, npcBot, oldConsiderFunction, ability)
    return function()
        local desire, target, targetTypeString = oldConsiderFunction()
        if desire == 0 or target == nil or target == 0 or self:IsVector(target) or targetTypeString == "Location" then
            return desire, target, targetTypeString
        end
        if self:MustBeIllusion(npcBot, target) then
            return 0
        end
        return desire, target, targetTypeString
    end
end

M.PreventEnemyTargetAbilityUsageAtAbilityBlock = function(self, npcBot, oldConsiderFunction, ability)
    local newConsider = function()
        -- TODO: do we consider the base cooldown or the modified cooldown (arcane rune, octarine orb)? Will you crack a sphere's spell block with an ultimate ability when you're on arcane rune?
        local desire, target, targetTypeString = oldConsiderFunction()
        if desire == 0 or target == nil or target == 0 or self:IsVector(target) or targetTypeString == "Location" then
            --if self:IsVector(target) then
            --    print("npcBot "..npcBot:GetUnitName().." lands target ability "..ability:GetName().." at location "..self:ToStringVector(target))
            --end
            return desire, target, targetTypeString
        end
        local oldDesire = desire
        if npcBot:GetTeam() ~= target:GetTeam() then -- some ability can cast to both allies and enemies (abbadon_mist_coil, etc)
            local cooldown = ability:GetCooldown()
            local abilityImportance = self:GetAbilityImportance(cooldown)

            if target:HasModifier("modifier_antimage_counterspell") then
                return 0
            end
            if target:HasModifier "modifier_item_sphere" or target:HasModifier("modifier_roshan_spell_block") or target:HasModifier("modifier_special_bonus_spell_block") then -- qop lv 25
                if cooldown >= 30 then
                    desire = desire - abilityImportance
                elseif cooldown <= 20 then
                    desire = desire + abilityImportance
                end
            end
            if target:HasModifier("modifier_item_sphere_target") then
                if cooldown >= 60 then
                    desire = 0
                elseif cooldown >= 30  then
                    desire = desire - abilityImportance + 0.1
                elseif cooldown <= 20 then
                    desire = desire + abilityImportance
                    if abilityImportance > 0.1 then
                        desire = desire - 0.1
                    end
                end
            end
            if target:HasModifier("modifier_item_lotus_orb_active") then
                if npcBot:GetActiveMode() == BOT_MODE_RETREAT then
                    desire = 0
                else
                    desire = desire - abilityImportance/2
                end
            end
            if target:HasModifier("modifier_mirror_shield_delay") then
                desire = desire - abilityImportance*1.5
            end

            desire = self:TrimDesire(desire)
        end
        if desire ~= oldDesire then
            print("desire modified from "..oldDesire.." to "..desire)
        end
        return desire, target, targetTypeString
    end
    return newConsider
end

M.GetUsedAbilityInfo = function(self, ability, abilityInfoTable, considerTarget)
    abilityInfoTable.lastUsedTime = DotaTime()
    abilityInfoTable.lastUsedCharge = ability:GetCurrentCharges()
    abilityInfoTable.lastUsedTarget = considerTarget
    abilityInfoTable.lastUsedRemainingCooldown = ability:GetCooldownTimeRemaining()
end

M.AddCooldownToChargeAbility = function(self, oldConsider, ability, abilityInfoTable, additionalCooldown)
    return function()
        if abilityInfoTable.lastUsedTime == nil then
            abilityInfoTable.lastUsedTime = DotaTime()
        end
        if not (ability:GetCurrentCharges() > 0 and ability:IsFullyCastable()) then
            return 0
        end
        if DotaTime() <= abilityInfoTable.lastUsedTime + additionalCooldown and abilityInfoTable.lastUsedCharge >= ability:GetCurrentCharges() and abilityInfoTable.lastUsedRemainingCooldown <= ability:GetCooldownTimeRemaining() then
            return 0
        end
        return oldConsider()
    end
end

        

M.AutoModifyConsiderFunction = function(self, npcBot, considers, abilitiesReal)
    for index, ability in pairs(abilitiesReal) do
        if not binlib.Test(ability:GetBehavior(), ABILITY_BEHAVIOR_PASSIVE) and considers[index] == nil then
            print("Missing consider function "..ability:GetName())
        elseif binlib.Test(ability:GetTargetTeam(), ABILITY_TARGET_TEAM_ENEMY) and binlib.Test(ability:GetTargetType(), binlib.Or(ABILITY_TARGET_TYPE_HERO, ABILITY_TARGET_TYPE_CREEP, ABILITY_TARGET_TYPE_BUILDING)) and binlib.Test(ability:GetBehavior(), ABILITY_BEHAVIOR_UNIT_TARGET) then
            considers[index] = self.PreventAbilityAtIllusion(self, npcBot, considers[index], ability)
            if not self:IgnoreAbilityBlock(ability) then
                considers[index] = self.PreventEnemyTargetAbilityUsageAtAbilityBlock(self, npcBot, considers[index], ability)
            end
        end
    end
end

M.CanMove = function(self, npc)
    return not npc:IsStunned() and not npc:IsRooted()
end

M.IsSeverlyDisabled = function(self, npc)
    return npc:IsStunned() or npc:IsHexed() or npc:IsRooted() or self:GetMovementSpeedPercent(npc) <= 0.4 or npc:IsNightmared()
end

M.EtherealModifiers = {
    "modifier_ghost_state",
    "modifier_item_ethereal_blade_slow",
    "modifier_necrolyte_death_seeker",
    "modifier_necrylte_sadist_active",
    "modifier_pugna_decrepify",
}
M.IsEthereal = function(self, npc)
    return self:Any(self.EtherealModifiers, function(t) return npc:HasModifier(t) end)
end

M.CannotBeAttacked = function(self, npc)
    return self:IsEthereal() or self:IsInvulnerable()
end

M.ShouldNotBeAttacked = function(self, npc)
    return self:CannotBeAttacked(npc) or self:Any(self.IgnoreDamageModifiers, function(t) return npc:HasModifier(t) end) or self:Any(self.IgnorePhysicalDamageModifiers, function(t) return npc:HasModifier(t) end)
end

M.IsPhysicalOutputDisabled = function(self, npc)
    return npc:IsDisarmed() or npc:IsBlind() or self:IsEthereal(npc)
end

M.GetHealthPercent = function(self, npc)
    return npc:GetHealth() / npc:GetMaxHealth()
end

M.GetManaPercent = function(self, npc)
    return npc:GetMana() / npc:GetMaxMana()
end

M.GetLine = function(self, a, b)
    if a.x == b.x then
        return { a = 1, b = 0, c = -a.x }
    end
    local k = (a.y-b.y)/(a.x-b.x)
    local bb = a.y-k*a.x
    return { a = k, b = -1, c = bb }
end

M.GetPointToLineDistance = function(self, point, line)
    local up = math.abs(line.a*point.x+line.b*point.y+line.c)
    local down = math.sqrt(line.a*line.a+line.b*line.b)
    return up/down
end

-- Get the location on the line determined by startPoint and endPoint, with distance from startPoint to the target location
M.GetPointFromLineByDistance = function(self, startPoint, endPoint, distance)
    local line = self:GetLine(startPoint, endPoint)
    local distanceTo = math.sqrt(math.pow(startPoint.x-endPoint.x, 2)+math.pow(startPoint.y-endPoint.y, 2))
    local divide = distanceTo / distance
    local point = { x = startPoint.x + divide*(endPoint.x-startPoint.x), y = startPoint.y + divide*(endPoint.y-endPoint.x), z = 0 }
    return point
end

M.GetTargetHealAmplifyPercent = function(self, npc)
    local modifiers = npc:FindAllModifiers()
    local amplify = 1
    for i, modifier in pairs(modifiers) do
        local a = (modifier:GetModifierHealAmplify_PercentageSource())
        if a ~= 0 then
            print("modifier: "..modifier:GetName()..", heal amplify source:"..a..", target:"..modifier:GetModifierHealAmplify_PercentageTarget())
        end
        local modifierName = modifier:GetName()
        if modifierName == "modifier_ice_blast" then
            return 0
        end
        if modifierName == "modifier_item_spirit_vessel_damage" then
            amplify = amplify - 0.45
        end
        if modifierName == "modifier_holy_blessing" then
            amplify = amplify + 0.3
        end
        if modifierName == "modifier_necrolyte_sadist_active" then -- ghost shroud
            amplify = amplify + 0.75
        end
        if modifierName == "modifier_wisp_tether_haste" then
            amplify = amplify + 0.6 -- 0.8/1/1.2
        end
        if modifierName == "modifier_oracle_false_promise" then
            amplify = amplify + 1
        end
    end
    return amplify
end

M.PreventHealAtHealSuppressTarget = function(self, npcBot, oldConsiderFunction, ability)
    return function()
        local desire, target, targetTypeString = oldConsiderFunction()
        if desire == 0 or target == nil or target == 0 or targetTypeString == "Location" then
            return desire, target, targetTypeString
        end
        if npcBot:GetTeam() == target:GetTeam() then
            desire = desire * self:GetTargetHealAmplifyPercent(target)
        end
        desire = self:TrimDesire(desire)
        return desire, target, targetTypeString
    end
end

M.PURCHASE_ITEM_OUT_OF_STOCK=82
M.PURCHASE_ITEM_INVALID_ITEM_NAME=33
M.PURCHASE_ITEM_DISALLOWED_ITEM=78
M.PURCHASE_ITEM_INSUFFICIENT_GOLD=63
M.PURCHASE_ITEM_NOT_AT_SECRET_SHOP=62
M.PURCHASE_ITEM_NOT_AT_HOME_SHOP=67
M.PURCHASE_ITEM_SUCCESS=-1
-- invalid order(3) unrecognised order name
-- invalid order(40) order not allowed for illusions
-- attempt to purchase "item_energy_booster" failed code 68

M.IgnoreDamageModifiers = {
    "modifier_abaddon_borrowed_time",
    "modifier_aeon_disk",
    "modifier_winter_wyvern_winters_curse",
    "modifier_winter_wyvern_winters_curse_aura",
    "modifier_skeleton_king_reincarnation_scepter_active",
}

M.IgnorePhysicalDamageModifiers = {
    "modifier_winter_wyvern_cold_embrace",
}
M.IgnoreMagicalDamageModifiers = {
    "modifier_oracle_fates_edict",
}

M.LastForAtLeastSeconds = function(self, predicate, time, infoTable)
    if infoTable.lastTrueTime == nil then
        infoTable.lastTrueTime = DotaTime()
    end
    if predicate() then
        if DotaTime() - infoTable.lastTrueTime >= time then
            return true
        else
            return false
        end
    else
        infoTable.lastTrueTime = nil
        return false
    end
end

M.GoodIllusionHero = {
    "antimage","spectre","terrorblade","naga_siren",
}
M.ModerateIllusionHero = {
    "abaddon","axe","chaos_knight","arc_warden","juggernaut","luna","medusa","morphling","phantom_lancer","sniper","wraith_king","phantom_assassin",
}
M.GetIllusionBattlePower = function(self, npc)
    local name = self:GetHeroShortName(npc:GetUnitName())
    if npc:HasModifier("modifier_arc_warden_tempest_double") or npc:HasModifier("modifier_skeleton_king_reincarnation_active") then
        return 0.8
    end
    local t = 0.1
    if self:Contains(self.GoodIllusionHero, name) then
        t = 0.25
    elseif self:Contains(self.ModerateIllusionHero, name) then
        t = 0.4
    elseif t:IsRanged() then
        t = t + t:GetAttackRange() / 600
    end
    local inventory = self:Map(self:GetInventoryItems(npc), function(t) return t:GetName() end)
    if self:Contains(inventory, "item_radiance") then
        t = t+0.07
    end
    if self:Contains(inventory, "item_diffusal_blade") then
        t = t+0.05
    end
    if self:Contains(inventory, "item_lesser_crit") then
        t = t+0.04
    end
    if self:Contains(inventory, "item_greater_crit") then
        t = t+0.08
    end
    if npc:HasModifier("modifier_special_bonus_mana_break") then-- mirana talent[5]
        t = t+0.04
    end
    return t 
end

M.GetNetWorth = function(self, npc, isEnemy)
    if isEnemy then
        local itemCost = self:Map(self:GetInventoryItems(npc), function(t) return GetItemCost(t:GetName()) end)
        return self:Aggregate(0, itemCost, function(a, b) return a+b end)
    else
        return npc:GetNetWorth()
    end
end

M.GetHeroGroupNetWorth = function(self, heroes, isEnemy)
    local function A(tb)
        tb = self:SortByMaxFirst(tb, function(t) return t:GetNetWorth() end)
        local f = self:Map(tb, function(t, index) return t:GetNetWorth() * 1.15-0.15*index end)
        local g = {}
        for _,v in ipairs(f) do
            g[v:GetUnitName()] = v 
        end
        return g
    end
    local enemyNetWorthMap = A(self:GetEnemyHeroUnique(heroes))
    local netWorth = 0
    local readNames = {}
    for _, enemy in pairs(heroes) do
        local name = enemy:GetUnitName()
        if not self:Contains(readNames, name) then
            table.insert(readNames, name)
            netWorth = netWorth + enemyNetWorthMap[name]
        else
            netWorth = netWorth + enemyNetWorthMap[name] * self:GetIllusionBattlePower(enemy)
        end
    end
    return netWorth
end

M.Outnumber = function(self, friends, enemies)
    return self:GetHeroGroupNetWorth(friends, false) >= self:GetHeroGroupNetWorth(enemies, true) * 1.8
end


M.CannotBeKilledNormally = function(self, target)
    return target:IsInvulnerable() or self:Any(self.IgnoreDamageModifiers, function(t) target:HasModifier(t) end) or target:HasModifier("modifier_dazzle_shallow_grave")
end

M.HasScepter = function(self, npc)
    return npc:HasScepter() or npc:HasModifier("modifier_wisp_tether_scepter")
end

return M
