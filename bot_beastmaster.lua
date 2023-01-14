local minionutils = dofile(GetScriptDirectory() .. "/util/NewMinionUtil")
local AbilityExtensions = require(GetScriptDirectory() .. "/util/AbilityAbstraction")


local function DiveBombCanCast(target)
	return target ~= nil and AbilityExtensions:NormalCanCast(target, false) and
		not AbilityExtensions:IsSeverelyDisabled(target)
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

local hawkName = "npc_dota_beastmaster_hawk_"
local boarName = "npc_dota_beastmaster_boar_"

function MinionThink(u)
	if minionutils.IsValidUnit(u) then
		if string.sub(u:GetUnitName(), 1, #hawkName) == hawkName then
			HawkThink(u)
		elseif u:GetUnitName() == "npc_dota_beastmaster_axe" then
			minionutils.CantBeControlledThink(u)
		elseif minionutils.IsMinionWithSkill(u:GetUnitName()) then
			minionutils.MinionWithSkillThink(u)
		else
			minionutils.IllusionThink(u)
		end
	end
end
