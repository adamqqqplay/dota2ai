local minionutils = dofile( GetScriptDirectory().."/util/NewMinionUtil" )
local AbilityExtensions = require(GetScriptDirectory().."/util/AbilityAbstraction")


local function DiveBombCanCast(target)
	return target ~= nil and AbilityExtensions:NormalCanCast(target, false) and not AbilityExtensions:IsSeverelyDisabled(target)
end

function HawkThink(minion)
	local diveBomb = minion:GetAbilityByName("beastmaster_hawk_dive")
	if diveBomb:IsHidden() or not diveBomb:IsFullyCastable() then
		return
	end

	local target = GetBot():GetTarget()
	if DiveBombCanCast(target) then
		minion:Action_UseAbilityOnEntity(diveBomb, target)
	end
	local nearbyEnemies = AbilityExtensions:Filter(AbilityExtensions:GetNearbyNonIllusionHeroes(minion), DiveBombCanCast)
	if #nearbyEnemies > 0 then
		minion:Action_UseAbilityOnEntity(nearbyEnemies[1], target)
	end
end


function MinionThink(  hMinionUnit ) 
	if minionutils.IsValidUnit(hMinionUnit) then
		if minionutils.IsHawk(hMinionUnit:GetUnitName()) then
			HawkThink(hMinionUnit)
		elseif minionutils.IsMinionWithSkill(hMinionUnit:GetUnitName()) then
			minionutils.MinionWithSkillThink(hMinionUnit);	
		else
			minionutils.IllusionThink(hMinionUnit)
		end
	end
end	