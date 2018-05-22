----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
-------
_G._savedEnv = getfenv()
module( "mode_generic_rune", package.seeall )
local utility = require( GetScriptDirectory().."/utility" ) 
local role = require(GetScriptDirectory() ..  "/RoleUtility")
----------
local AllRunes={
    RUNE_POWERUP_1,
    RUNE_POWERUP_2,
    RUNE_BOUNTY_1,
    RUNE_BOUNTY_2,
    RUNE_BOUNTY_3,
    RUNE_BOUNTY_4,
}
local OurRunes={}
if(GetTeam()==TEAM_RADIANT)
then
	OurRunes={
	RUNE_POWERUP_1,
    RUNE_POWERUP_2,
    RUNE_BOUNTY_1,
    RUNE_BOUNTY_3,
	}
else
	OurRunes={
    RUNE_POWERUP_1,
    RUNE_POWERUP_2,
    RUNE_BOUNTY_2,
    RUNE_BOUNTY_4,
	}
end
if(GetTeam()==TEAM_RADIANT)
then
	OurRunes2={
    RUNE_BOUNTY_1,
    RUNE_BOUNTY_3,
	}
else
	OurRunes2={
    RUNE_BOUNTY_2,
    RUNE_BOUNTY_4,
	}
end
function IsNearRune()
	local npcBot=GetBot()
	for _,rune in pairs(AllRunes)
	do
		local d=GetUnitToLocationDistance(npcBot,GetRuneSpawnLocation(rune))
		if(d<=1200)
		then
			return true
		end
	end
	return false
end

function IsMidNearby()
	local npcBot=GetBot()
	if(IsNearRune()==true)
	then
		local allys=npcBot:GetNearbyHeroes( 1600, false, BOT_MODE_NONE );
		for _,ally in pairs(allys)
		do
			if(ally~=npcBot)
			then
				if (ally:GetAssignedLane()==LANE_MID or ally:IsBot()==false)
				then
					return true
				end
			end
		end
	end
	return false
end

function IsRuneAdaptHero(rune,npcHero)
	local allys=GetUnitList(UNIT_LIST_ALLIED_HEROES)
	local d=GetUnitToLocationDistance(npcHero, GetRuneSpawnLocation(rune))
	if(GetRuneStatus(rune)==RUNE_STATUS_UNKNOWN)
	then
		return false
	end

	if(GetRuneType(rune)==RUNE_REGENERATION and npcHero:GetHealth()/npcHero:GetMaxHealth()+npcHero:GetMana()/npcHero:GetMaxMana()>=1.5)
	then
		return false
	end

	if(GetRuneType(rune)==RUNE_INVISIBILITY and npcHero:HasInvisibility(false))
	then
		return false
	end

	if(GetRuneType(rune)==RUNE_HASTE and npcHero:GetCurrentMovementSpeed()>=450)
	then
		return false
	end

	if(GetRuneType(rune)==RUNE_BOUNTY and npcHero:GetAssignedLane()==LANE_MID and d>=1600)
	then
		return false
	end

	if(GetRuneType(rune)==RUNE_DOUBLEDAMAGE and npcHero:GetAttackDamage()<=50+3*npcHero:GetLevel() and role.IsCarry(npcHero:GetUnitName())==false)
	then
		return false
	end

	if(GetRuneType(rune)==RUNE_ARCANE and role.IsCarry(npcHero:GetUnitName())==false and role.IsNuker(npcHero:GetUnitName())==false)
	then
		return false
	end

	if(GetRuneType(rune)==RUNE_ILLUSION and npcHero:GetHealth()/npcHero:GetMaxHealth()+npcHero:GetMana()/npcHero:GetMaxMana()<=1.2)
	then
		return false
	end

	return true
end

function GetAllyHero()
	local allys={}
	local teamPlayers = GetTeamPlayers(GetTeam())
	for k,v in pairs(teamPlayers)
	do
		local member = GetTeamMember(k)
		if  member ~= nil and not member:IsIllusion() and member:IsAlive() then
			table.insert(allys,member)
		end
	end
	return allys
end

function GetTheClosestHero(rune)
	local minDist = 10000
	local closest
	for k,member in pairs(GetAllyHero())
	do
		local dist = GetUnitToLocationDistance(member, GetRuneSpawnLocation(rune));
		if dist < minDist then
			minDist = dist;
			closest = member;
		end
	end
	return closest
end

function GetTheBestHero(rune)
	local allys=GetAllyHero()
	local ClosestHero=GetTheClosestHero(rune)
	local BestHero
	local HighestFactor=0
	for i,ally in pairs(allys)
	do
		local distance=math.min(GetUnitToLocationDistance(ally,GetRuneSpawnLocation(rune)),6000)
		local DistanceFactor=(6000-distance)/6000;
		local Factor=DistanceFactor
		if(IsRuneAdaptHero(rune,ally))
		then
			Factor=Factor+0.25
		end
		if((role.CanBeSupport(ally:GetUnitName()) or role.IsSupport(ally:GetUnitName())) and rune~=RUNE_POWERUP_1 and rune~=RUNE_POWERUP_2)
		then
			Factor=Factor+0.2
		end
		local bottle=IsHeroHaveItem(ally,"item_bottle")
		if(bottle~=nil )
		then
			local charge = bottle:GetCurrentCharges()
			if(charge<=1)
			then
				Factor=Factor+0.1
			end
		end
		if(ally:GetAssignedLane()==LANE_MID and (rune==RUNE_POWERUP_1 or rune==RUNE_POWERUP_2))
		then
			Factor=Factor+0.1
		end
		if(ally:IsBot()==false)
		then
			Factor=Factor+0.1
		end
		if(Factor>=HighestFactor)
		then
			BestHero=ally
			HighestFactor=Factor
		end
	end
	if(BestHero~=nil)
	then
		-- if(printTimer==nil)
		-- then
			-- printTimer=DotaTime()
		-- end
		-- if(DotaTime()-printTimer>5)
		-- then
			-- print(GetBot():GetPlayerID().." [Rune] BestHero for "..rune.." is "..BestHero:GetUnitName())
		-- end
		return BestHero
	elseif(ClosestHero~=nil)
	then
		return ClosestHero
	end
end

function IsHeroHaveItem(npcBot,item_name)
    for i = 0, 5, 1 do
        local item = npcBot:GetItemInSlot(i);
		if (item~=nil) then
			if(item:GetName() == item_name) then
				return item;
			end
		end
    end
    return nil;
end

function GetDesire()
	local npcBot=GetBot();
	local enemys = npcBot:GetNearbyHeroes(1200,true,BOT_MODE_NONE)
	local allys = npcBot:GetNearbyHeroes(1200,false,BOT_MODE_NONE)

	if(#enemys>#allys and IsNearRune()==true)
	then
		return 0
	end

	if DotaTime()>=-40 and DotaTime()<=0.5
	then
		if(DotaTime()>=-5 and IsMidNearby()==true)
		then
			return 0
		else
			return 0.35
		end
	end

	-- if(npcBot.MyTargetRune~=nil)
	-- then
		-- local d=GetUnitToLocationDistance(npcBot,GetRuneSpawnLocation(npcBot.MyTargetRune))
		-- return (6000-d)/6000*0.3+0.3;
	-- end

	local HaveBottle=utility.IsItemAvailable("item_bottle")

	if DotaTime()>=60 and DotaTime()<=26*60
	then
		for _,r in pairs(OurRunes)
		do
			if(DotaTime()%300>290)
			then
				if ((HaveBottle~=nil or GetTheBestHero(r)==npcBot) and npcBot:GetAssignedLane()~=LANE_MID)
				then
					return 0.35
				end
			end
		end
	end

	local TargetRunes

	if DotaTime()<=60+50
	then
		TargetRunes=OurRunes2
	elseif DotaTime()<=26*60
	then
		TargetRunes=OurRunes
	else
		TargetRunes=OurRunes
		--TargetRunes=AllRunes
	end

	
	local BestRune
	local HighestFactor=0
	if(IsSuitableToPick())
	then
		for _,r in pairs(TargetRunes) do
			local d=GetUnitToLocationDistance(npcBot,GetRuneSpawnLocation(r))
			local factor=(6000-d)/6000*0.15+0.25;			
			if d<6000 and GetRuneStatus(r)~=RUNE_STATUS_MISSING
			then
				if(d<300)
				then
					factor=0.9
				end
				local BestHero=GetTheBestHero(r)
				if(factor>HighestFactor and npcBot==BestHero)
				then
					HighestFactor=factor
					BestRune=r
				end
			end
		end
	end
	
	return HighestFactor

end


function Think()
	local npcBot=GetBot();

	if ( npcBot:IsUsingAbility() or npcBot:IsChanneling() )
	then
		return
	end

	if (DotaTime()>=-55 and DotaTime()<=0)
	then
		local d=10000
		local RuneLocation
		for _,r in pairs(AllRunes)
		do
			if(_>2)
			then
				local d2=GetUnitToLocationDistance(npcBot,GetRuneSpawnLocation(r))
				if(d2<d)
				then
					RuneLocation=GetRuneSpawnLocation(r)
					d=d2
				end
			end
		end
		if(npcBot.runetimer==nil)
		then
			npcBot.runetimer=DotaTime()
		end
		if(DotaTime()-npcBot.runetimer>=1.5)
		then
			npcBot.runetimer=nil
			if(npcBot:GetAssignedLane()==LANE_MID)
			then
				npcBot:Action_MoveToLocation(RuneLocation)
			else
				npcBot:Action_MoveToLocation(RuneLocation+RandomVector(200))
			end
		end
		return
	end

--------------------------------------------------------------------------------------------
	local MinDistance=10000
	local ClosestRune
	if(npcBot.MyTargetRune==nil)
	then
		local TargetRunes
		if DotaTime()<=60+50
		then
			TargetRunes=OurRunes2
		elseif DotaTime()<=26*60
		then
			TargetRunes=OurRunes
		else
			TargetRunes=OurRunes
			--TargetRunes=AllRunes
		end
		for _,r in pairs(TargetRunes)
		do
			if(GetRuneStatus(r)~=RUNE_STATUS_MISSING)
			then
				if(GetTheBestHero(r)==npcBot)
				then
					if(GetUnitToLocationDistance(npcBot,GetRuneSpawnLocation(r))<1200 and GetRuneStatus(r)==RUNE_STATUS_AVAILABLE)
					then
						npcBot:Action_PickUpRune(r);
					else
						npcBot:Action_MoveToLocation(GetRuneSpawnLocation(r))
					end
					return
				end
			end
			-- if(GetRuneStatus(r)==RUNE_STATUS_AVAILABLE)
			-- then
				-- if(npcBot:GetAssignedLane()==LANE_MID or IsMidNearby()==false)
				-- then

				-- end
			-- end

			local d=GetUnitToLocationDistance(npcBot,GetRuneSpawnLocation(r))
			if(d<MinDistance and GetTheBestHero(r)==npcBot)
			then
				MinDistance=d
				ClosestRune=r
			end

		end
	end

	if(npcBot.MyTargetRune==nil and DotaTime()%300>=290)
	then
		if(GetRuneStatus(RUNE_POWERUP_1)==RUNE_STATUS_UNKNOWN and GetRuneStatus(RUNE_POWERUP_2)==RUNE_STATUS_UNKNOWN)
		then
			npcBot.MyTargetRune=RandomInt(0,1)
		else
			if(GetRuneStatus(RUNE_POWERUP_1)==RUNE_STATUS_AVAILABLE)
			then
				npcBot.MyTargetRune=RUNE_POWERUP_1
			elseif(GetRuneStatus(RUNE_POWERUP_2)==RUNE_STATUS_AVAILABLE)
			then
				npcBot.MyTargetRune=RUNE_POWERUP_2
			end
			npcBot.MyTargetRune=ClosestRune
		end
	end

	-- for _,hero in pairs(GetUnitList(UNIT_LIST_ALLIED_HEROES ))
	-- do
		-- local d2=GetUnitToLocationDistance(hero,GetRuneSpawnLocation(r))
		-- if(d>d2 and hero:GetActiveMode() == BOT_MODE_RUNE)
		-- then
			-- npcBot.MyTargetRune=nil
		-- end
	-- end

	if(npcBot.MyTargetRune~=nil)
	then
		--print(npcBot:GetPlayerID().." [Rune] MyTargetRune is RUNE"..npcBot.MyTargetRune)

		if(DotaTime()%300>=290)
		then
			npcBot:Action_MoveToLocation(GetRuneSpawnLocation(npcBot.MyTargetRune))
			return
		else
			npcBot.MyTargetRune=nil
		end

		-- if(GetRuneStatus(npcBot.MyTargetRune)==RUNE_STATUS_MISSING)
		-- then
			-- npcBot.MyTargetRune=nil
			-- return
		-- end

		-- if (GetRuneStatus(npcBot.MyTargetRune)==RUNE_STATUS_UNKNOWN)
		-- then
			-- npcBot:Action_MoveToLocation(GetRuneSpawnLocation(npcBot.MyTargetRune))
			-- return
		-- end

		-- if (GetRuneStatus(npcBot.MyTargetRune)==RUNE_STATUS_AVAILABLE)
		-- then
			-- if(npcBot:GetAssignedLane()==LANE_MID or IsMidNearby()==false)
			-- then
				-- npcBot:Action_PickUpRune(npcBot.MyTargetRune);
				-- return
			-- end
		-- end
	end

	return
end

function IsSuitableToPick()
	local npcBot=GetBot()
	local mode = npcBot:GetActiveMode();
	local Enemies = npcBot:GetNearbyHeroes(1300, true, BOT_MODE_NONE);
	if ( ( mode == npcBot_MODE_RETREAT and npcBot:GetActiveModeDesire() > BOT_MODE_NONE )
		or mode == npcBot_MODE_ATTACK
		or mode == npcBot_MODE_DEFEND_ALLY
		or mode == npcBot_MODE_DEFEND_TOWER_TOP
		or mode == npcBot_MODE_DEFEND_TOWER_MID
		or mode == npcBot_MODE_DEFEND_TOWER_BOT
		or mode == npcBot_MODE_PUSH_TOWER_TOP
		or mode == npcBot_MODE_PUSH_TOWER_MID
		or mode == npcBot_MODE_PUSH_TOWER_BOT
		or ( ( Enemies ~= nil or #Enemies >= 1 ) and npcBot:WasRecentlyDamagedByAnyHero(2.0) )
		) 
	then
		return false;
	end
	return true;
end
--------
for k,v in pairs( mode_generic_rune ) do	_G._savedEnv[k] = v end
