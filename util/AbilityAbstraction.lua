local M = {}

local targetType = {
    NoTarget = 0,
    EnemyHero = 1,
    EnemyCreep = 2,
    EnemyBuilding = 4,
    FriendHero = 8,
    Self = 16,
    FriendCreep = 32,
    FriendBuilding = 64,
    NeutralNormal = 128,
    NeutralHigh = 256,
    Roshan = 512,
    Location = 4096,
    Vector = 8192,
    Tree = 16384,

    AllFriends = FriendCreep | FriendHero | Self,
    AllNeutrals = NeutralNormal | NeutralHigh | Roshan,
    AllEnemies = EnemyHero | EnemyCreep | AllNeutrals,

}


local CheckEnumFlag = function(enumItem, flagToCheck) 
    return enumItem & flagToCheck ~= 0
end

M.TargetType = targetType

local CastOnEnemy = function(npcBot, ability, targetTypeEnum, desire, target) 
    if CheckEnumFlag(targetTypeEnum, targetType.AllEnemies) then
        return desire, target
    elseif CheckEnumFlag(targetTypeEnum, targetType.Location) then
        return desire, target:GetLocation()
    end
end

M.SeriouslyRetreatingStunSomeone = function(tb, npcBot, abilityIndex, ability, targetType)
    if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0
	end
	
	local CastRange = ability:GetCastRange()
	local Damage = ability:GetAbilityDamage()
	local Radius = ability:GetAOERadius()
	local CastPoint = ability:GetCastPoint()
	
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE )
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange+300,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)

	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH ) then
		for _,npcEnemy in pairs( enemys )
		do
			if ( npcBot:WasRecentlyDamagedByHero( npcEnemy, 2.0 ) ) 
			then
				if ( CanCast[abilityNumber]( npcEnemy ) ) 
				then
					return BOT_ACTION_DESIRE_LOW, npcEnemy:GetExtrapolatedLocation(CastPoint)
				end
			end
		end
	end
end

return M
