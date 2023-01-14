local minionutils = dofile(GetScriptDirectory() .. "/util/NewMinionUtil")

function MinionThink(u)
	if minionutils.IsValidUnit(u) then
		if u:IsIllusion() then
			minionutils.IllusionThink(u)
		elseif u:GetUnitName() == "npc_dota_death_prophet_torment" or u:GetUnitName() == "dota_death_prophet_exorcism_spirit" then
			minionutils.CantBeControlledThink(u)
		else
			minionutils.MinionThink(u)
			return
		end
	end
end
