local minionutils = dofile( GetScriptDirectory().."/util/NewMinionUtil" )

function MinionThink(  hMinionUnit ) 
	if hMinionUnit:GetUnitName() ~= "npc_dota_hero_terrorblade" then
		-- reflection illusions only have modifier_illusion
		minionutils.CantBeControlledThink(hMinionUnit)
		return
	end
	if minionutils.IsValidUnit(hMinionUnit) then
		if hMinionUnit:IsIllusion() then
			minionutils.IllusionThink(hMinionUnit);
		else
			return
		end
	end
end	