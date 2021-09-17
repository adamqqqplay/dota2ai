local minionutils = dofile(GetScriptDirectory().."/util/NewMinionUtil")

function MinionThink(u)
	if minionutils.IsValidUnit(u) then
		if u:IsIllusion() then
			minionutils.IllusionThink(u)
		elseif u:GetUnitName() == "aghsfort_mars_bulwark_soldier" then
            minionutils.CantBeControlledThink(u)
		else
            minionutils.MinionThink(u)
			return
		end
	end
end
