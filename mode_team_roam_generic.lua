----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
----------

function GetDesire()
	local npcBot=GetBot()
	local enemys = npcBot:GetNearbyHeroes(1600,true,BOT_MODE_NONE)
	
	if(npcBot.ShrineTime==nil)
	then
		npcBot.ShrineTime=0
	end
	
	if(npcBot:IsAlive()==false)
	then
		return
	end
	
	if(npcBot:DistanceFromFountain()<=6000 and (npcBot:GetStashValue()>400 or npcBot:GetMaxMana()-npcBot:GetMana()>=400) and #enemys==0)
	then
		npcBot.GoingToShrine=false
		npcBot.Shrine=nil
	end
	
	if(npcBot.GoingToShrine==true and GetShrineCooldown(npcBot.Shrine)>10 and IsShrineHealing(npcBot.Shrine)==false or npcBot:GetHealth()/npcBot:GetMaxHealth()+npcBot:GetMana()/npcBot:GetMaxMana()>1.8 or GetUnitToUnitDistance(npcBot,npcBot.Shrine)>7500)
	then
		npcBot.GoingToShrine=false
		npcBot.Shrine=nil
	end
	
	ConsiderShrine()
	if(npcBot.GoingToShrine==true and (GetUnitToUnitDistance(npcBot,npcBot.Shrine)>=300 or IsShrineHealing(npcBot.Shrine)==false) 
		and DotaTime()+GetUnitToUnitDistance(npcBot,npcBot.Shrine)/npcBot:GetCurrentMovementSpeed() >= npcBot.ShrineTime)
	then
		if(npcBot:GetHealth()/npcBot:GetMaxHealth() <=0.5)
		then
			return 0.9
		else
			return 0.7
		end
	end
	return 0.0;
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
	local enemys = npcBot:GetNearbyHeroes(1600,true,BOT_MODE_NONE)
	
	if(npcBot:DistanceFromFountain()<=6000 and (npcBot:GetStashValue()>400 or npcBot:GetMaxMana()-npcBot:GetMana()>=400) and #enemys==0)
	then
		return
	end
	
	if(npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot.GoingToShrine~=true and 
		(npcBot:GetHealth()/npcBot:GetMaxHealth()+npcBot:GetMana()/npcBot:GetMaxMana()<1.2 or npcBot:GetMaxHealth()-npcBot:GetHealth()>=400) and 
		(npcBot:GetMaxMana()-npcBot:GetMana()<=400 and npcBot:GetMaxHealth()-npcBot:GetHealth()<=1000 or #enemys>0  ))
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
			local shrineLocation=TargetShrine:GetLocation()
			local max_distance=GetUnitToUnitDistance(npcBot,TargetShrine)/npcBot:GetCurrentMovementSpeed()
			local allys=GetUnitList(UNIT_LIST_ALLIED_HEROES)
	
			for _,ally in pairs (allys)
			do
				allyfactor=ally:GetHealth()/ally:GetMaxHealth()+ally:GetMana()/ally:GetMaxMana()
				if((allyfactor<1.6 or ally:GetMaxHealth()-ally:GetHealth()>=300) and GetUnitToUnitDistance(ally,TargetShrine)<=7500-allyfactor*1500) and ally:IsAlive()
				then
					ally.Shrine=TargetShrine
					ally.GoingToShrine=true
					
					local distance = GetUnitToUnitDistance(ally,TargetShrine)/ally:GetCurrentMovementSpeed()
					if distance>max_distance
					then
						max_distance=distance
					end
				end
			end
			

			for _,ally in pairs (allys)
			do
				if(TargetShrine==ally.Shrine)
				then
					ally.ShrineTime=DotaTime()+max_distance
					--npcBot:ActionImmediate_Chat("Enjoy together"..ally:GetUnitName()..ally.ShrineTime,true)	
				end
			end
			
			npcBot.Shrine=TargetShrine
			npcBot.GoingToShrine=true
			npcBot.ShrineTime=DotaTime()+max_distance
			npcBot:ActionImmediate_Chat("I want to use Shrine,let's enjoy together! 我想要使用神泉，快来一起享用",false)	
			--npcBot:ActionImmediate_Ping(shrineLocation.x,shrineLocation.y,true)
		
		end
	end
	
end

function Think()
	local npcBot=GetBot()
	if ( npcBot:IsUsingAbility() or npcBot:IsChanneling())
	then 
		return
	end
	if(npcBot.GoingToShrine==true and npcBot.Shrine~=nil)
	then
		if(GetUnitToUnitDistance(npcBot,npcBot.Shrine)<300 and GetShrineCooldown(npcBot.Shrine)<5)
		then
			local allys = npcBot:GetNearbyHeroes( 1600, false, BOT_MODE_NONE );
			local enemys = npcBot:GetNearbyHeroes(1000,true,BOT_MODE_NONE)
			local ready=true
			for _,ally in pairs(allys)
			do
				local allyfactor=ally:GetHealth()/ally:GetMaxHealth()+ally:GetMana()/ally:GetMaxMana()
				if(IsPlayerBot(ally:GetPlayerID())==false)
				then
					if(GetUnitToUnitDistance(ally,npcBot.Shrine)>500 and allyfactor<1.6)
					then
						ready=false
					end
				end
			end
			for _,ally in pairs (GetUnitList(UNIT_LIST_ALLIED_HEROES ))
			do
				if(IsPlayerBot(ally:GetPlayerID())==true)
				then
					if(ally.GoingToShrine==true and GetUnitToUnitDistance(ally,npcBot.Shrine)>500 and ally.Shrine==npcBot.Shrine)
					then
						ready=false
					end
				end
			end
			if(#enemys>0)
			then
				ready=true
			end
			
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
		npcBot:Action_MoveToUnit(npcBot.Shrine)
	end
	
	local shrines2=npcBot:GetNearbyShrines(1600,false)
	if(npcBot:GetHealth()/npcBot:GetMaxHealth()+npcBot:GetMana()/npcBot:GetMaxMana()<1.8)
	then
		for _,s in pairs(shrines2)
		do
			if(IsShrineHealing(s)==true and GetUnitToUnitDistance(npcBot,s)>=450)
			then
				npcBot:Action_MoveToLocation(s:GetLocation())
				return
			end
		end
	end
end

