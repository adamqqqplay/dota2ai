local AbilityExtensions = require(GetScriptDirectory().."/util/AbilityAbstraction")

function GetDesire()
    local npc = GetBot()
    local activeMode = npc:GetActiveMode()
    local healthPercent = AbilityExtensions:GetHealthPercent(npc)
    local manaPercent = AbilityExtensions:GetManaPercent(npc)
    local desire = RemapValClamped(healthPercent, 0, 0.3, 0.85, 0.35)
    if activeMode == BOT_MODE_LANING then
        if healthPercent <= 0.25 and not (npc:GetUnitName() == "npc_dota_hero_huskar" and npc:GetAbility(3):GetLevel() >= 2) then
            desire = RemapValClamped(healthPercent, 0.1, 0.3, 1, 0.4)
        end
    end
    if activeMode == BOT_MODE_RETREAT and npc:DistanceFromFountain() <= 1000 and healthPercent >= 0.75 and manaPercent >= 0.85 then
        desire = 0.1
    end
    if npc:IsIllusion() or npc:HasModifier("modifier_skeleton_king_reincarnation_active") then
        desire = 0.05
    end
    return desire
end
