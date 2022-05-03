local minionutils = dofile( GetScriptDirectory().."/util/NewMinionUtil" )

local function CannotBeControlled(unit)
	local name = unit:GetUnitName():sub(#"npc_dota_unit_"+1)
	return name:match("tombstone[1234]") or name == "undying_zombie" or name == "undying_zombie_torso"
end

function MinionThink(  hMinionUnit ) 
	if minionutils.IsValidUnit(hMinionUnit) then
		if hMinionUnit:IsIllusion() then
			minionutils.IllusionThink(hMinionUnit)
		elseif CannotBeControlled(hMinionUnit:GetUnitName()) then
			return
		else
			print("unrecognised minion: "..hMinionUnit:GetUnitName())
			return
		end
	end
end

function CourierUsageThink()

end