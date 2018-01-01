local minionutils = dofile( GetScriptDirectory().."/NewMinionUtil" )

function MinionThink(  hMinionUnit ) 
	if minionutils.IsValidUnit(hMinionUnit) then
		if minionutils.IsHawk(hMinionUnit:GetUnitName()) then
			minionutils.HawkThink(hMinionUnit);
		elseif minionutils.IsMinionWithSkill(hMinionUnit:GetUnitName()) then
			minionutils.MinionWithSkillThink(hMinionUnit);	
		else
			minionutils.IllusionThink(hMinionUnit);
		end
	end
end	