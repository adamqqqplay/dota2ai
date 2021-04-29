----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local utility = require( GetScriptDirectory().."/utility" ) 
local role = require(GetScriptDirectory() ..  "/util/RoleUtility")
local AbilityExtensions = require(GetScriptDirectory().."/util/AbilityAbstraction")
local HeroMode

function OnStart()

end

function GetDesire()
	local npcBot=GetBot()
	
	if(npcBot:IsAlive()==false)
	then
		return 0
	end
    if npcBot:IsChanneling() or npcBot:IsUsingAbility() then
        return npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM and 1 or 0
    end

	--local ShrineDesire=GetShrineDesire()
	local TeamRoamDesire=GetTeamRoamDesire()
	--local ShrineDesire=0
	--local TeamRoamDesire=0

	--if(ShrineDesire>TeamRoamDesire)
	--then
	--	HeroMode="Shrine"
	--	return ShrineDesire
	--else
	--	HeroMode="TeamRoam"
    return TeamRoamDesire
	--end
end

function Think()
	--if(HeroMode=="Shrine")
	--then
	--	ShrineThink()
	--else
    if(HeroMode=="TeamRoam")
	then
		TeamRoamThink()
	end
end

--function GetShrineDesire()
--	local npcBot=GetBot()
--
--	if ( npcBot:IsUsingAbility() or npcBot:IsChanneling())
--	then
--		return 0
--	end
--
--	local enemys = npcBot:GetNearbyHeroes(1600,true,BOT_MODE_NONE)
--
--	if(npcBot.ShrineTime==nil)
--	then
--		npcBot.ShrineTime=0
--	end
--
--	if(	npcBot:IsAlive()==false or
--		(npcBot:DistanceFromFountain()<=6000 and (npcBot:GetStashValue()>400 or npcBot:GetMaxMana()-npcBot:GetMana()>=400) and #enemys==0) or
--		(npcBot.GoingToShrine==true and GetShrineCooldown(npcBot.Shrine)>10 and IsShrineHealing(npcBot.Shrine)==false) or
--		npcBot:GetFactor()>1.8 or
--		(GetUnitToUnitDistance(npcBot,npcBot.Shrine)>7500) or
--		(npcBot.Shrine==nil or npcBot.GoingToShrine==false)
--	)
--	then
--		npcBot.GoingToShrine=false
--		npcBot.Shrine=nil
--	end
--
--	if(npcBot.GoingToShrine==false)
--	then
--		ConsiderShrine()
--	end
--
--	if(npcBot.GoingToShrine==true and (GetUnitToUnitDistance(npcBot,npcBot.Shrine)>=300 or IsShrineHealing(npcBot.Shrine)==false)
--		and DotaTime()+GetUnitToUnitDistance(npcBot,npcBot.Shrine)/npcBot:GetCurrentMovementSpeed() >= npcBot.ShrineTime)
--	then
--		local HealthFactor=npcBot:GetHealth()/npcBot:GetMaxHealth()
--		return 0.7+(1-HealthFactor)*0.3
--	end
--	return 0.0;
--end
--
--function ConsiderShrine()
--	local Shrines={	SHRINE_JUNGLE_1,
--					SHRINE_JUNGLE_2	}
--
--	local npcBot=GetBot()
--	local enemys = npcBot:GetNearbyHeroes(1600,true,BOT_MODE_NONE)
--
--	if(npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot.GoingToShrine~=true and
--		(npcBot:GetFactor()<1.2 or npcBot:GetMaxHealth()-npcBot:GetHealth()>=400) and
--		(npcBot:GetMaxMana()-npcBot:GetMana()<=400 and npcBot:GetMaxHealth()-npcBot:GetHealth()<=1000 or #enemys>0  ))
--	then
--		local TargetShrine
--		local min_distance=10000
--		for _,s in pairs(Shrines)
--		do
--			local shrine=GetShrine(GetTeam(),s)
--			if(shrine~=nil and shrine:IsAlive())
--			then
--				if(GetShrineCooldown(shrine)<10 or IsShrineHealing(shrine)==true)
--				then
--					d=GetUnitToUnitDistance(npcBot,shrine)
--					if(d<min_distance)
--					then
--						min_distance=d
--						TargetShrine=shrine
--					end
--				end
--			end
--		end
--		if(2*min_distance<npcBot:DistanceFromFountain())
--		then
--			local shrineLocation=TargetShrine:GetLocation()
--			local max_distance=GetUnitToUnitDistance(npcBot,TargetShrine)/npcBot:GetCurrentMovementSpeed()
--			local allys=GetUnitList(UNIT_LIST_ALLIED_HEROES)
--
--			for _,ally in pairs (allys)
--			do
--				allyfactor=ally:GetFactor()
--				if((allyfactor<1.6 or ally:GetMaxHealth()-ally:GetHealth()>=300) and GetUnitToUnitDistance(ally,TargetShrine)<=7500-allyfactor*1500) and ally:IsAlive()
--				then
--					ally.Shrine=TargetShrine
--					ally.GoingToShrine=true
--
--					local distance = GetUnitToUnitDistance(ally,TargetShrine)/ally:GetCurrentMovementSpeed()
--					if distance>max_distance
--					then
--						max_distance=distance
--					end
--				end
--			end
--
--
--			for _,ally in pairs (allys)
--			do
--				if(TargetShrine==ally.Shrine)
--				then
--					ally.ShrineTime=DotaTime()+max_distance
--					--npcBot:ActionImmediate_Chat("Enjoy together"..ally:GetUnitName()..ally.ShrineTime,false)
--				end
--			end
--
--			npcBot.Shrine=TargetShrine
--			npcBot.GoingToShrine=true
--
--			npcBot.ShrineTime=DotaTime()+max_distance
--			npcBot:ActionImmediate_Chat("I want to use Shrine,let's enjoy together! 我想要使用神泉，快来一起享用",false)
--			--npcBot:ActionImmediate_Ping(shrineLocation.x,shrineLocation.y,true)
--
--		end
--	end
--
--end
--
--function ShrineThink()
--	local npcBot=GetBot()
--
--	if ( npcBot:IsUsingAbility() or npcBot:IsChanneling())
--	then
--		return
--	end
--
--	if(npcBot.GoingToShrine==true and npcBot.Shrine~=nil)
--	then
--		if(GetUnitToUnitDistance(npcBot,npcBot.Shrine)<300 and GetShrineCooldown(npcBot.Shrine)<5)
--		then
--			local allys = npcBot:GetNearbyHeroes( 1600, false, BOT_MODE_NONE );
--			local enemys = npcBot:GetNearbyHeroes(1600,true,BOT_MODE_NONE)
--			local ready=true
--
--			if(#enemys>0)
--			then
--				ready=true
--			else
--				for _,ally in pairs(GetUnitList(UNIT_LIST_ALLIED_HEROES))
--				do
--					local allyfactor=ally:GetHealth()/ally:GetMaxHealth()+ally:GetMana()/ally:GetMaxMana()
--					local distance=GetUnitToUnitDistance(ally,npcBot.Shrine)
--					if(IsPlayerBot(ally:GetPlayerID())==false and distance>500 and allyfactor<1.6 and distance<6000)
--					then
--						if(ally.ShrineHuman==nil)
--						then
--							ally.ShrineHuman={}
--							ally.ShrineHuman.timer=DotaTime()
--							ally.ShrineHuman.distance=distance
--							ready=false
--						else
--							if(DotaTime()-ally.ShrineHuman.timer>5)
--							then
--								if(distance<ally.ShrineHuman.distance)
--								then
--									ready=false
--								else
--									ready=true
--									ally.ShrineHuman=nil
--								end
--							else
--								ready=false
--							end
--						end
--					end
--				end
--				for _,ally in pairs (GetUnitList(UNIT_LIST_ALLIED_HEROES))
--				do
--					if(IsPlayerBot(ally:GetPlayerID())==true)
--					then
--						if(ally.GoingToShrine==true and GetUnitToUnitDistance(ally,npcBot.Shrine)>500 and ally.Shrine==npcBot.Shrine)
--						then
--							ready=false
--						end
--					end
--				end
--			end
--
--			if(ready==true)
--			then
--				npcBot:Action_UseShrine(npcBot.Shrine)
--			else
--				npcBot:Action_MoveToUnit(npcBot.Shrine)
--			end
--		else
--			npcBot:Action_MoveToUnit(npcBot.Shrine)
--		end
--	end
--
--	-- if(IsShrineHealing(npcBot.Shrine)==true)
--	-- then
--		-- npcBot:Action_MoveToUnit(npcBot.Shrine)
--	-- end
--
--	-- local shrines2=npcBot:GetNearbyShrines(1600,false)
--	-- if(npcBot:GetHealth()/npcBot:GetMaxHealth()+npcBot:GetMana()/npcBot:GetMaxMana()<1.8)
--	-- then
--		-- for _,s in pairs(shrines2)
--		-- do
--			-- if(IsShrineHealing(s)==true and GetUnitToUnitDistance(npcBot,s)>=450)
--			-- then
--				-- npcBot:Action_MoveToLocation(s:GetLocation())
--				-- return
--			-- end
--		-- end
--	-- end
--
--end

function GetTeamRoamDesire()
	local npcBot=GetBot()

	if(CheckTimer==nil or CheckTimer>DotaTime())
	then
		CheckTimer=DotaTime()
	end

	if(DotaTime()-CheckTimer>5 and npcBot.TeamRoam~=true and npcBot.TeamRoamTimer==nil)
	then
		ConsiderTeamRoam()
		CheckTimer=DotaTime()
	end

	if(npcBot.TeamRoam==true)
	then
		return 0.7
	end

	return 0
end

function ConsiderTeamRoam()
	local npcBot=GetBot()
	local item_smoke = utility.IsItemAvailable("item_smoke_of_deceit")
	
	if(item_smoke~=nil and GetAllyFactor(npcBot)>=0.7)
	then
		local factor,target,allys=FindTarget()
		if(factor>0.7)
		then
			local nearBuilding = utility.GetNearestBuilding(GetTeam(), npcBot:GetLocation())
			local location = utility.GetUnitsTowardsLocation(nearBuilding,GetAncient(GetTeam()),600)
			npcBot.TeamRoamAssemblyPoint=location
			--npcBot:ActionImmediate_Chat("Let's Gank "..string.gsub(target:GetUnitName(),"npc_dota_hero_","").." together! ",false)
			--print(npcBot:GetPlayerID().." @TeamRoam@ Let's Gank together! Factor:"..factor.." target:"..target:GetUnitName())
			--npcBot:ActionImmediate_Ping(location.x,location.y,true)
			
			for _,npcAlly in pairs(allys)
			do
				local factor2=GetAllyFactor(npcAlly)
				if(factor2>0.7)
				then
					npcAlly.TeamRoam=true
					npcAlly.TeamRoamState="Assemble"
					npcAlly.TeamRoamTargetID=target:GetPlayerID()
					npcAlly.TeamRoamLeader=npcBot
					npcAlly.TeamRoamTimer=DotaTime()
					npcAlly:SetTarget(target)
					--npcBot:ActionImmediate_Chat(string.gsub(npcAlly:GetUnitName(),"npc_dota_hero_","").." come to Gank! Factor:"..factor2,false)
					--print(npcBot:GetPlayerID().." @TeamRoam@"..npcAlly:GetUnitName().." want to Gank together!Factor:"..factor2)
				end

			end
		end
	end
end

function GetAllyFactor(npcAlly)
	local npcBot=GetBot()
	local front = npcBot:GetLocation()
	local distance = GetUnitToLocationDistance( npcAlly, front )
	local nearBuilding = utility.GetNearestBuilding(GetTeam(), front)
	local distBuilding = GetUnitToLocationDistance( nearBuilding, front )
	local distFactor = 0
	local StateFactor=npcAlly:GetFactor()/2
	local powerFactor=math.min(npcAlly:GetOffensivePower()/npcAlly:GetMaxHealth(),1)
	
	local enemys=npcAlly:GetNearbyHeroes(1200,true,BOT_MODE_NONE)
	if((npcAlly:GetAssignedLane()==LANE_MID or role.IsCarry(npcAlly:GetUnitName()) or role.IsSupport(npcAlly:GetUnitName())==false) and npcAlly:GetLevel()<=6 )
	then
		return 0
	end
	
	if(#enemys>0)
	then
		return 0
	end
	
	local tp=utility.IsItemAvailable("item_tpscroll")
	if tp then
		tp = tp:IsFullyCastable()
	end
	tp=nil
	local travel = utility.IsItemAvailable("item_travel_boots")
	if travel then
		travel = travel:IsFullyCastable()
	end

	if distance <= 1000 then
		distFactor = 1
	elseif distance >= 6000 then
		distFactor = 0
	else
		distFactor = (6000-distance) / 6000
	end
	-- if distance <= 1000 or travel then
		-- distFactor = 1
	-- elseif distance - distBuilding >= 3000 and tp then
		-- if distBuilding <= 1000 then
			-- distFactor = 0.7
		-- elseif distBuilding >= 6000 then
			-- distFactor = 0
		-- else
			-- distFactor = -(distBuilding - 6000) * 0.7 / 5000
		-- end
	-- elseif distance >= 6000 then
		-- distFactor = 0
	-- else
		-- distFactor = (6000-distance) / 6000
	-- end

	local factor=StateFactor*0.7+distFactor*0.3--+powerFactor*0.4
	return factor
end

function GetEnemyFactor(npcEnemy,allys)
	local npcBot=GetBot()
	if(GetUnitToUnitDistance(npcBot,npcEnemy)>=3000)
	then
		local TowersCount=0
		local AllysCount=#allys
		local EnemysCount=0
		local damageFactor=0
		local distance=GetUnitToUnitDistance(npcBot,npcEnemy)
		local distFactor=math.max(0,(6000-distance)/6000)

		for j=0,8,1 do
			local tower=GetTower(utility.GetOtherTeam(),j);
			if NotNilOrDead(tower) and GetUnitToUnitDistance(npcEnemy,tower)<1600 then
				TowersCount=TowersCount+1;
			end
		end

		local enemys2=npcEnemy:GetNearbyHeroes(1600,false,BOT_MODE_NONE)

		for _,enemy in pairs (enemys2)
		do
			if(enemy:GetFactor()>=1.0)
			then
				EnemysCount=EnemysCount+1
			end
		end
	
		if(TowersCount>0 or EnemysCount-AllysCount>=1)
		then
			return 0,0
		end
		
		local sumdamage=0
		local suitableallys={}
		local allys3 = npcEnemy:GetNearbyHeroes( 1600, true, BOT_MODE_NONE );
		for i,npcAlly in pairs(allys3)
		do
			local IsIn=false
			for i,npcAlly2 in pairs(allys)
			do
				if(npcAlly:GetPlayerID()==npcAlly2:GetPlayerID())
				then
					IsIn=true
				end
			end
			if(IsIn==false)
			then
				table.insert(allys,npcAlly)
			end
			--print(npcBot:GetPlayerID().." [TeamRoam] Ally damage include/ "..npcAlly:GetUnitName())
		end
		
		for i,npcAlly in pairs(allys)
		do
			if(GetUnitToUnitDistance(npcAlly,npcEnemy)>=1600)
			then
				table.insert(suitableallys,npcAlly)
			end
			sumdamage=sumdamage+npcAlly:GetEstimatedDamageToTarget(true,npcEnemy,5.0,DAMAGE_TYPE_ALL)
		end
		
		damageFactor=math.min(sumdamage/npcEnemy:GetHealth(),1.25)/1.25
		local factor=damageFactor*0.7+distFactor*0.3
		if(npcEnemy:IsBot()==false)
		then
			factor=factor*1.2
		end
--[[		print(npcBot:GetPlayerID().." =[TeamRoam] Enemy/"..npcEnemy:GetUnitName().."/ sumdamage:"..sumdamage.."/ Factor:"..factor)]]
		return math.min(1.0,factor),suitableallys
	end
	return 0,0
end


function FindTarget()

	local npcBot=GetBot()
	local allys2= GetUnitList(UNIT_LIST_ALLIED_HEROES)
	local allys={}
	--print("---------------------------")
	for i,npcAlly in pairs(allys2)
	do
		local factor=GetAllyFactor(npcAlly)
		if(factor>=0.70)
		then
			--print(npcBot:GetPlayerID().." [TeamRoam] SearchAlly/ "..npcAlly:GetUnitName().." / Factor:"..factor)
			table.insert(allys,npcAlly)
		end
	end

	if(#allys==0)
	then
		return 0,0
	end

	local MaxFactor=0
	local BestTarget
	local BestAllys={}
	local enemys= GetUnitList(UNIT_LIST_ENEMY_HEROES)
	for _,npcEnemy in pairs(enemys)
	do
		local factor,suitableallys=GetEnemyFactor(npcEnemy,allys)
		if(factor>MaxFactor)
		then
			MaxFactor=factor
			BestTarget=npcEnemy
			BestAllys=suitableallys
		end
	end
	
	return MaxFactor,BestTarget,BestAllys

end

function GetLocationTowardsLocation(vMyLocation,vTargetLocation, nUnits)
	local tempvector=(vTargetLocation-vMyLocation)/utility.PointToPointDistance(vMyLocation,vTargetLocation)
	return vMyLocation+nUnits*tempvector
end

local wardTargets = {
    "npc_dota_techies_remote_mine",
    "npc_dota_techies_stasis_trap",
    "npc_dota_techies_land_mine",
    "npc_dota_techies_minefield_sign",
    "npc_dota_juggernaut_healing_ward",
	"npc_dota_phoenix_sun",
    "npc_dota_visage_familiar3",
	"npc_dota_unit_tombstone4",
	"npc_dota_pugna_nether_ward_4",
	"npc_dota_unit_tombstone3",
    "npc_dota_visage_familiar2",
	"npc_dota_pugna_nether_ward_43",
	"npc_dota_unit_tombstone2",
    "npc_dota_visage_familiar1",
	"npc_dota_pugna_nether_ward_2",
	"npc_dota_shadow_shaman_ward_3",
	"npc_dota_venomancer_plague_ward_4",
	"npc_dota_venomancer_plague_ward_3",
	"npc_dota_unit_tombstone1",
	"npc_dota_pugna_nether_ward_1",
	"npc_dota_shadow_shaman_ward_2",
	"npc_dota_shadow_shaman_ward_1",
	"npc_dota_venomancer_plague_ward_2",
	"npc_dota_venomancer_plague_ward_1",
}

local FindEnemyWardTargets

function TeamRoamThink()
	local npcBot=GetBot()

	local towers=npcBot:GetNearbyTowers(1000,true)

	if(npcBot.TeamRoam==true)
	then
		if(IsHeroAlive(npcBot.TeamRoamTargetID)==false or DotaTime()-npcBot.TeamRoamTimer>=40 or #towers>=1)
		then
			npcBot.TeamRoam=false
			return
		end
	end
    if npcBot:GetTarget() ~= nil and not npcBot:GetTarget():IsAlive() then
        npcBot:SetTarget()
    end

	if(npcBot.TeamRoamState=="Assemble")
	then
		if(npcBot.TeamRoamLeader:GetUnitName()==npcBot:GetUnitName())
		then
			local enemys=npcBot:GetNearbyHeroes(1000,true,BOT_MODE_NONE)
			local ready=true
			
			if(#enemys>0)
			then
				ready=false
				npcBot.TeamRoamAssemblyPoint=GetLocationTowardsLocation(npcBot.TeamRoamAssemblyPoint,GetAncient(GetTeam()):GetLocation(),100)
			end
			
			for _,npcAlly in pairs (GetUnitList(UNIT_LIST_ALLIED_HEROES ))
			do
				if(IsPlayerBot(npcAlly:GetPlayerID())==true and npcAlly.TeamRoam==true)
				then
					if(GetUnitToUnitDistance(npcBot,npcAlly)>1000)
					then
						ready=false
					end
				end
			end

			if(ready==true)
			then
				local item_smoke = utility.IsItemAvailable("item_smoke_of_deceit")
				if(npcBot:HasModifier("modifier_smoke_of_deceit")==false)
				then
					npcBot:Action_UseAbility(item_smoke)
					npcBot:ActionImmediate_Chat("smoke used!",false)
				end
			else
				npcBot:Action_MoveToLocation(npcBot.TeamRoamAssemblyPoint)
			end
		else
			if(GetUnitToUnitDistance(npcBot,npcBot.TeamRoamLeader)>300)
			then
				npcBot:Action_MoveToLocation(npcBot.TeamRoamLeader:GetLocation())
			end
		end

		if(npcBot:HasModifier("modifier_smoke_of_deceit"))
		then
			npcBot.TeamRoamState="Roaming"
			npcBot.TeamRoamTimer=DotaTime()
		end

	elseif(npcBot.TeamRoamState=="Roaming")
	then
		local enemys3=GetUnitList(UNIT_LIST_ENEMY_HEROES)
		local target
		for _,enemy in pairs(enemys3)
		do
			if(enemy:GetPlayerID()==npcBot.TeamRoamTargetID)
			then
				target=enemy
			end
		end

        local enemyStaticTargets = {}
        local myTeam = npcBot:GetTeam()
        if FindEnemyWardTargets == nil then
            FindEnemyWardTargets = AbilityExtensions:EveryManySeconds(1, function()
                enemyStaticTargets = GetUnitList(UNIT_LIST_ALL)
                enemyStaticTargets = AbilityExtensions:Filter(enemyStaticTargets, function(t)
                    return t:GetTeam() ~= myTeam and GetUnitToUnitDistance(npcBot, t) <= npcBot:GetAttackRange() + 150
                end)
                enemyStaticTargets = AbilityExtensions:Map(enemyStaticTargets, function(t)
                    return { t, AbilityExtensions:IndexOf(wardTargets, t:GetUnitName()) }
                end)
                enemyStaticTargets = AbilityExtensions:Filter(enemyStaticTargets, function(t) return t[2] ~= -1  end)
                enemyStaticTargets = AbilityExtensions:SortByMinFirst(enemyStaticTargets, function(t) return t[2]  end)
            end)
        end
        FindEnemyWardTargets()

		local seeninfo=GetHeroLastSeenInfo(npcBot.TeamRoamTargetID)
		if(seeninfo~=nil)
		then
			local seenpoint=seeninfo[1].location
			seenpoint=GetLocationTowardsLocation(seenpoint,GetAncient(utility.GetOtherTeam()):GetLocation(),1000)
			local seentime=seeninfo[1].time_since_seen

			if(seentime>5 and npcBot.TeamRoamLeader:GetUnitName()==npcBot:GetUnitName())
			then
				local factor,target2,ChangedAllys=FindTarget()
				if(factor>0.6)
				then
					npcBot.TeamRoamTargetID=target2:GetPlayerID()
					for i,npcAlly in pairs(ChangedAllys)
					do
						npcAlly.TeamRoamTargetID=target2:GetPlayerID()
					end
					--npcBot:ActionImmediate_Chat("Target Change to "..string.gsub(target2:GetUnitName(),"npc_dota_hero_",""),false)
					--print(npcBot:GetPlayerID().." Target Change！factor:"..factor.." target:"..target2:GetUnitName())
				else
					npcBot.TeamRoam=false
					for i,npcAlly in pairs(GetUnitList(UNIT_LIST_ALLIED_HEROES))
					do
						npcAlly.TeamRoam=false
					end
					--npcBot:ActionImmediate_Chat("Target disappear, Ganking stop",false)
					--print(npcBot:GetPlayerID().." Target disappear！Roaming stop")
				end
			end

            local dps = npcBot:GetAttackDamage() * 1 / npcBot:GetSecondsPerAttack()
            if AbilityExtensions:GetHealthPercent(target) >= 0.5 and AbilityExtensions:Any(enemyStaticTargets) then
                local selectedWardTarget = enemyStaticTargets[1]
                if string.match("npc_dota_techies_") then
                    if npcBot:GetAttackRange() > 500 then
                        npcBot:SetTarget(selectedWardTarget)
                        npcBot:Action_AttackUnit(selectedWardTarget, false)
                    end
                elseif string.match("npc_dota_venomancer_plague_ward") then
                    if selectedWardTarget:GetHealth() < selectedWardTarget:GetActualIncomingDamage(dps*2, DAMAGE_TYPE_PHYSICAL) then
                        npcBot:SetTarget(selectedWardTarget)
                        npcBot:Action_AttackUnit(selectedWardTarget, false)
                    end
                else
                    npcBot:SetTarget(selectedWardTarget)
                    npcBot:Action_AttackUnit(selectedWardTarget, false)
                end
                return
            end
			if(GetUnitToLocationDistance(npcBot,seenpoint)<=1200)
			then
				if(target~=nil)
				then
					npcBot:SetTarget(target)
					npcBot:Action_AttackUnit(target,false)
				else
					npcBot:Action_AttackMove(seenpoint)
				end
			else
				local ready=true
				for _,npcAlly in pairs (GetUnitList(UNIT_LIST_ALLIED_HEROES ))
				do
					if(IsPlayerBot(npcAlly:GetPlayerID())==true and npcAlly.TeamRoam==true)
					then
						if(GetUnitToUnitDistance(npcBot,npcBot.TeamRoamLeader)>500)
						then
							ready=false
						end
					end
				end

				if(ready==true)
				then
					npcBot:Action_MoveToLocation(seenpoint)
				else
					npcBot:Action_MoveToLocation(npcBot.TeamRoamLeader:GetLocation())
				end
			end
		end
	end
end

function OnEnd()
	local npcBot=GetBot()
	npcBot.TeamRoam=false
	npcBot.TeamRoamState=nil
	npcBot.TeamRoamTargetID=nil
	npcBot.TeamRoamLeader=nil
	npcBot.TeamRoamTimer=nil
end