local minionutils = dofile(GetScriptDirectory().."/util/NewMinionUtil")

function MinionThink(u)
	if minionutils.IsValidUnit(u) then
		if u:IsIllusion() then
			minionutils.IllusionThink(u)
		elseif u:GetUnitName() == "npc_dota_phantomassassin_gravestone" or u:GetUnitName() == "npc_dota_phantom_assassin_ground_dagger" then
            minionutils.CantBeControlledThink(u)
		else
            minionutils.MinionThink(u)
			return
		end
	end
end
