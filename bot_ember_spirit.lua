local minionUtility = dofile( GetScriptDirectory().."/util/NewMinionUtil" )

function MinionThink(minion)
    if minion:IsIllusion() then
        minionUtility.IllusionThink(minion)
    elseif minion:GetUnitName() == "npc_dota_ember_spirit_remnant" then
        minionUtility.CantBeControlledThink(minion)
    end
end	
