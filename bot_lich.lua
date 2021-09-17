local minionutils = dofile(GetScriptDirectory().."/util/NewMinionUtil")

function MinionThink(u)
	if minionutils.IsValidUnit(u) then
		if u:IsIllusion() then
			minionutils.IllusionThink(u)
		elseif u:GetUnitName() == "npc_dota_lich_ice_spire" then
            minionutils.CantBeControlledThink(u)
		else
            minionutils.MinionThink(u)
			return
		end
	end
end
