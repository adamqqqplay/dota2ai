----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
----------

function GetDesire()
	local npcBot=GetBot()
	if(npcBot:GetHealth()/npcBot:GetMaxHealth()<0.4 or npcBot.GoingToShrine==true)
	then
		return 0.66
	end
	return 0.0;
end

function Think()
	local npcBot=GetBot()
	if(npcBot:IsAlive()==false)
	then
		return
	end

	local min_distance=10000;
	local min_distance2=10000;
	local tower
	for i=1,3,1 do
		local t=GetAmountAlongLane(i,npcBot:GetLocation())
		local d=t.distance
		if(d<min_distance)
		then
			min_distance=d
		end
	end
	
	local enemys = npcBot:GetNearbyHeroes(900,true,BOT_MODE_NONE)
	
	if min_distance>1500 then
		ConsiderShrine()
	else
		if(#enemys==0)
		then
			ConsiderShrine()
		else
			for i=0,10,1 
			do
				local temptower=GetTower(GetTeam(),i)
				if temptower~=nil
				then
					local d=GetUnitToUnitDistance(npcBot,temptower)
					if(d<min_distance2)
					then
						min_distance2=d
						tower=temptower
					end

				end
			end
			print(npcBot:GetUnitName().." ")
			print(tower)
			if(tower~=nil)
			then
				npcBot:Action_MoveToLocation(tower:GetLocation())
			else
				ConsiderShrine()
			end
		end
	end

end

function ConsiderShrine()
	local Shrines={	SHRINE_BASE_1,
					SHRINE_BASE_2,
					SHRINE_BASE_3,
					SHRINE_BASE_4,
					SHRINE_BASE_5,
					SHRINE_JUNGLE_1,
					SHRINE_JUNGLE_2	}

	local npcBot=GetBot()
	
	if(npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot.GoingToShrine==false and (npcBot:GetHealth()/npcBot:GetMaxHealth()<0.4 or npcBot:GetMaxHealth()-npcBot:GetHealth()>=600))
	then
		local TargetShrine
		local min_distance=10000
		for _,s in pairs(Shrines)
		do
			local shrine=GetShrine(GetTeam(),s)
			if(shrine~=nil)
			then
				if(GetShrineCooldown(shrine)<10 or IsShrineHealing(shrine)==true)
				then
					d=GetUnitToUnitDistance(npcBot,shrine)
					if(d<min_distance)
					then
						min_distance=d
						TargetShrine=shrine
					end
				end
			end
		end
		if(2*min_distance<npcBot:DistanceFromFountain())
		then
			npcBot.Shrine=TargetShrine
			npcBot.GoingToShrine=true
			npcBot:ActionImmediate_Chat("I want to use Shrine,let's enjoy together! 我想要使用神泉，快来一起享用！",true)				
			for _,ally in pairs (GetUnitList(UNIT_LIST_ALLIED_HEROES ))
			do
				if((ally:GetHealth()/ally:GetMaxHealth()<0.7 or npcBot:GetMaxHealth()-npcBot:GetHealth()>=300 or ally:GetMana()/ally:GetMaxMana()<0.5) and GetUnitToUnitDistance(ally,npcBot.Shrine)<=6000)
				then
					ally.Shrine=TargetShrine
					ally.GoingToShrine=true
				end
			end
		else
			if GetTeam()==TEAM_RADIANT 
			then
				v=Vector(-7093,-6542)
			else
				v=Vector(7015,6534)		
			end
			npcBot:Action_MoveToLocation(v)
		end
	end
	
	if(npcBot.GoingToShrine==true and npcBot.Shrine~=nil)
	then
		if(GetUnitToUnitDistance(npcBot,npcBot.Shrine)<300 and GetShrineCooldown(npcBot.Shrine)<5)
		then
			local allys = npcBot:GetNearbyHeroes( 1600, false, BOT_MODE_NONE );
			local ready=true
			for _,ally in pairs(allys)
			do
				if(GetUnitToUnitDistance(ally,npcBot.Shrine)>500)
				then
					ready=false
				end
			end
			--[[for _,ally in pairs (GetUnitList(UNIT_LIST_ALLIED_HEROES ))
			do
				if(IsPlayerBot(ally:GetPlayerID())==true)
				then
					if(ally.GoingToShrine==true and GetUnitToUnitDistance(ally,npcBot.Shrine)>500)
					then
						ready=false
					end
				end
			end]]--
			
			if(ready==true)
			then
				npcBot:Action_UseShrine(npcBot.Shrine)
			else
				npcBot:Action_MoveToUnit(npcBot.Shrine)
			end
		else
			npcBot:Action_MoveToUnit(npcBot.Shrine)
		end
	else
		npcBot.GoingToShrine=false
		npcBot.Shrine=nil
	end
	
	if(IsShrineHealing(npcBot.Shrine)==true)
	then
		if(npcBot:NumQueuedActions()<=5)
		then
			npcBot:ActionQueue_MoveToUnit(npcBot.Shrine)
		end
	end
	
	if(npcBot.Shrine==nil or GetShrineCooldown(npcBot.Shrine)>10 or npcBot:GetHealth()/npcBot:GetMaxHealth()>0.6)
	then
		npcBot.GoingToShrine=false
		npcBot.Shrine=nil
	end
end
