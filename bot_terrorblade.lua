local minionutils = dofile( GetScriptDirectory().."/util/NewMinionUtil" )

function MinionThink(  hMinionUnit ) 
	if hMinionUnit:IsHero() and hMinionUnit:GetUnitName() ~= "npc_dota_hero_terrorblade" then
		-- reflection illusions only have modifier_illusion
		minionutils.CantBeControlledThink(hMinionUnit)
		return
	end
	if hMinionUnit:GetUnitName() == "npc_dota_metamorphosis_fear" then
		minionutils.CantBeControlledThink(hMinionUnit)
	elseif minionutils.IsValidUnit(hMinionUnit) then
		if hMinionUnit:IsIllusion() then
			minionutils.IllusionThink(hMinionUnit)
		end
	end
end	