----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
-------
_G._savedEnv = getfenv()
module( "mode_generic_rune", package.seeall )
----------
Runes={
    RUNE_POWERUP_1,
    RUNE_POWERUP_2,
    RUNE_BOUNTY_1,
    RUNE_BOUNTY_2,
    RUNE_BOUNTY_3,
    RUNE_BOUNTY_4
}
Runes2={}
Runes2[2]={
    RUNE_POWERUP_1,
    RUNE_POWERUP_2,
    RUNE_BOUNTY_1,
    RUNE_BOUNTY_2
}
Runes2[3]={
    RUNE_POWERUP_1,
    RUNE_POWERUP_2,
    RUNE_BOUNTY_3,
    RUNE_BOUNTY_4
}


function GetDesire()
	local npcBot=GetBot();
	
	local allys=npcBot:GetNearbyHeroes( 1600, false, BOT_MODE_NONE );
	local midhero=false
	for _,ally in pairs (allys)
	do
		if(ally~=npcBot)
		then
			if (ally:GetAssignedLane()==LANE_MID or ally:IsBot()==false)
			then
				midhero=true
				break
			end
		end
	end
	
	if DotaTime()>=-40 and DotaTime()<=0.5
	then
		if(DotaTime()>=-5)
		then
			if(npcBot:GetAssignedLane()~=LANE_MID and midhero==true)
			then
				return 0
			end
		end
		return 0.3
	end
	
	--[[local creeps=npcBot:GetNearbyCreeps(450,true);
	if creeps~=nil and #creeps>0 then
		return 0.0;
	end]]--
	
	local havebottle=false
	if(npcBot:FindItemSlot( "item_bottle" )>=0 and npcBot:FindItemSlot( "item_bottle" )<6)
	then
		havebottle=true
	end
	
	--[[if(npcBot.nrune~=nil)
	then
		local d=GetUnitToLocationDistance(npcBot,GetRuneSpawnLocation(npcBot.nrune))
		return (6000-d)/6000*0.4+0.2;
	end]]--
	
	for _,r in pairs(Runes2[GetTeam()]) do
		if GetRuneStatus(r)==RUNE_STATUS_UNKNOWN
		then
			if(havebottle==true and (DotaTime()%120>=115 or DotaTime()%120<=15) and DotaTime()<=20*60)
			then
				return 0.35
			end
		end
	end
	
	local TempRunes
	if DotaTime()<=20*60
	then
		TempRunes=Runes2[GetTeam()]
	else
		TempRunes=Runes
	end
	
	for _,r in pairs(TempRunes) do		
		local d=GetUnitToLocationDistance(npcBot,GetRuneSpawnLocation(r))
		if d<6000 and GetRuneStatus(r)==RUNE_STATUS_AVAILABLE
		then
			for _,hero in pairs(GetUnitList(UNIT_LIST_ALLIED_HEROES ))
			do
				local d2=GetUnitToLocationDistance(hero,GetRuneSpawnLocation(r))
				if(d>d2)
				then
					npcBot.nrune=nil
					return 0
				end
			end
			
			return (6000-d)/6000*0.6+0.2;
		end
	end
		
	return 0.0;
end

function Think()
	local npcBot=GetBot();
	
	if ( npcBot:IsUsingAbility() or npcBot:IsChanneling() )
	then 
		return
	end
	
	local allys=npcBot:GetNearbyHeroes( 1600, false, BOT_MODE_NONE );
	local midhero=false
	for _,ally in pairs (allys)
	do
		if(ally~=npcBot)
		then
			if (ally:GetAssignedLane()==LANE_MID or ally:IsBot()==false)
			then
				midhero=true
				break
			end
		end
	end
	
	if (DotaTime()>=-55 and DotaTime()<=0)
	then
		local d=10000
		local v
		for _,r in pairs(Runes)
		do
			if(_>2)
			then
				local d2=GetUnitToLocationDistance(npcBot,GetRuneSpawnLocation(r))
				if(d2<d)
				then
					v=GetRuneSpawnLocation(r)
					d=d2
				end
			end
		end
		if(npcBot.runetime==nil)
		then
			npcBot.runetime=DotaTime()
		end
		if(DotaTime()-npcBot.runetime>=1.5)
		then
			npcBot.runetime=nil
			if(npcBot:GetAssignedLane()==LANE_MID)
			then
				npcBot:Action_MoveToLocation(v)
			else
				npcBot:Action_MoveToLocation(v+RandomVector(400))
			end
		end
		return
	end
	
	--[[local creeps=npcBot:GetNearbyCreeps(450,true);
	if creeps~=nil and #creeps>0 then
		return
	end]]--
	
--------------------------------------------------------------------------------------------

	local min_distance=10000
	local rune=-1
	
	local TempRunes
	if DotaTime()<=20*60
	then
		TempRunes=Runes2[GetTeam()]
	else
		TempRunes=Runes
	end
	for _,r in pairs(TempRunes)
	do
		if(GetRuneStatus(r)==RUNE_STATUS_AVAILABLE)
		then
			if(npcBot:GetAssignedLane()==LANE_MID or midhero==false)
			then
				if(GetUnitToLocationDistance(npcBot,GetRuneSpawnLocation(r))<600)
				then
					npcBot:Action_PickUpRune(r);
				else
					npcBot:Action_MoveToLocation(GetRuneSpawnLocation(r))
				end
				return
			end
		end
		if(GetRuneStatus(r)==RUNE_STATUS_UNKNOWN)
		then
			local d=GetUnitToLocationDistance(npcBot,GetRuneSpawnLocation(r))
			if(d<min_distance)
			then
				min_distance=d
				rune=r
			end
		end
	end
	
	if(npcBot.nrune==nil)
	then
		if(GetRuneStatus(0)==RUNE_STATUS_UNKNOWN and GetRuneStatus(1)==RUNE_STATUS_UNKNOWN)
		then
			npcBot.nrune=RandomInt(0,1)
		else
			npcBot.nrune=rune
		end
	end

	if(GetRuneStatus(npcBot.nrune)==RUNE_STATUS_MISSING)
	then
		npcBot.nrune=nil
		return
	end
	
	if (GetRuneStatus(npcBot.nrune)==RUNE_STATUS_UNKNOWN) 
	then
		npcBot:Action_MoveToLocation(GetRuneSpawnLocation(npcBot.nrune))
	end

	if (GetRuneStatus(npcBot.nrune)==RUNE_STATUS_AVAILABLE) 
	then
		if(npcBot:GetAssignedLane()==LANE_MID or midhero==false)
		then
			npcBot:Action_PickUpRune(npcBot.nrune);
			return
		end
	end
		
	return
end
--------
for k,v in pairs( mode_generic_rune ) do	_G._savedEnv[k] = v end
