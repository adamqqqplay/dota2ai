local minionutils = dofile(GetScriptDirectory().."/util/NewMinionUtil")

function MinionThink(u)
	if minionutils.IsValidUnit(u) then
		if u:IsIllusion() then
			minionutils.IllusionThink(u)
		elseif u:GetUnitName() == "npc_dota_phoenix_sun" or u:GetUnitName() == "npc_dota_ignis_fatuus" then
            minionutils.CantBeControlledThink(u)
		else
            minionutils.MinionThink(u)
			return
		end
	end
end
