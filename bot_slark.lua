local minionutils = dofile(GetScriptDirectory() .. "/util/NewMinionUtil")

function MinionThink(hMinionUnit)
	if minionutils.IsValidUnit(hMinionUnit) then
		if hMinionUnit:IsIllusion() then
			minionutils.IllusionThink(hMinionUnit);
		elseif hMinionUnit:GetUnitName() == "npc_dota_slark_visual" then
			minionutils.CantBeControlledThink(hMinionUnit)
		else
			return;
		end
	end
end
