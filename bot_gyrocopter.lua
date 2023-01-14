local minionutils = dofile(GetScriptDirectory() .. "/util/NewMinionUtil")

local t = "npc_dota_gyrocopter_homing_missile"

function MinionThink(u)
	if minionutils.IsValidUnit(u) then
		if u:IsIllusion() then
			minionutils.IllusionThink(u)
		elseif string.sub(u:GetUnitName(), 1, #t) == t then
			minionutils.CantBeControlledThink(u)
		else
			minionutils.MinionThink(u)
			return
		end
	end
end
