local minionutils = dofile( GetScriptDirectory().."/util/NewMinionUtil" )

function MinionThink(  hMinionUnit ) 
	local name = hMinionUnit:GetUnitName()
	if name == "npc_dota_zeus_cloud" then
		return
	end
	if minionutils.IsValidUnit(hMinionUnit) then
		if hMinionUnit:IsIllusion() then
			minionutils.IllusionThink(hMinionUnit);
		elseif minionutils.IsAttackingWard(hMinionUnit:GetUnitName()) then
			minionutils.AttackingWardThink(hMinionUnit);
		else
			return;
		end
	end
end	