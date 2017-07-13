----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
-------
_G._savedEnv = getfenv()
module( "ability_item_usage_generic", package.seeall )
require( GetScriptDirectory().."/utility" ) 
----------

function CourierUsageThink()
	ConsiderGlyph()
	UnImplementedItemUsage()

	local npcBot=GetBot()
	local courier=GetCourier(0)
	local state=GetCourierState(courier)
	if(npcBot:IsAlive()==false or npcBot:GetHealth()<=100 or courier==nil or npcBot:IsHero()==false)
	then
		return
	end
	
	if(courier:WasRecentlyDamagedByAnyHero(2) or courier:WasRecentlyDamagedByTower(2))
	then
		if(courier:GetMaxHealth()==150)
		then
			npcBot:ActionImmediate_Courier(courier, COURIER_ACTION_BURST)
		end
		npcBot:ActionImmediate_Courier(courier, COURIER_ACTION_RETURN)
		return
	end

	if((state==COURIER_STATE_IDLE or state==COURIER_STATE_RETURNING_TO_BASE)  and npcBot:GetCourierValue()>0)
	then
		npcBot:ActionImmediate_Courier(courier, COURIER_ACTION_TRANSFER_ITEMS)
		DebugTalk(npcBot:GetUnitName()..": courier is COURIER_ACTION_TRANSFER_ITEMS")
		if(courier:GetMaxHealth()==150)
		then
			npcBot:ActionImmediate_Courier(courier, COURIER_ACTION_BURST)
		end
		return
	end
    if (state == COURIER_STATE_AT_BASE and npcBot:GetStashValue() >= 400 and courier:DistanceFromSecretShop()>=100) 
	then
		if(courier:GetMaxHealth()==150)
		then
			npcBot:ActionImmediate_Courier(courier, COURIER_ACTION_BURST)
		end
	
		if(courier.time==nil)
		then
			courier.time=DotaTime()
		end
		if(courier.time+1<DotaTime())
		then
			npcBot:ActionImmediate_Courier(courier, COURIER_ACTION_TAKE_AND_TRANSFER_ITEMS)
			DebugTalk(npcBot:GetUnitName()..": courier is TAKE_AND_TRANSFER")
			courier.time=nil
		end
        return
    end
	if(state == COURIER_STATE_AT_BASE and npcBot.secretShopMode == true and npcBot:GetActiveMode() ~= BOT_MODE_SECRET_SHOP)
	then
		DebugTalk(npcBot:GetUnitName()..": courier is go to secret_shop")
		npcBot:ActionImmediate_Courier(courier, COURIER_ACTION_SECRET_SHOP)
        return
	end

	-- if(state == COURIER_STATE_DELIVERING_ITEMS and npcBot:GetCourierValue()==0 and GetUnitToUnitDistance(npcBot,courier)<=300)
	-- then
		-- npcBot:ActionImmediate_Courier(courier, COURIER_ACTION_RETURN)
		-- return
	-- end
	
	if(state==COURIER_STATE_IDLE)
	then
		if(courier.idletime==nil)
		then
			courier.idletime=GameTime()
		else
			DebugTalk(GameTime()-courier.idletime.." :idletime")
			if(GameTime()-courier.idletime>10)
			then
				npcBot:ActionImmediate_Courier(courier, COURIER_ACTION_RETURN)
				courier.idletime=nil
				return
			end
		end
	end
	
end

function AbilityLevelUpThink2(AbilityToLevelUp,TalentTree)
	local npcBot=GetBot()
	if (npcBot:GetAbilityPoints()<1 or #AbilityToLevelUp==0 or  (GetGameState()~=GAME_STATE_PRE_GAME and GetGameState()~= GAME_STATE_GAME_IN_PROGRESS))
	then
		return
	end
	
	local abilityname=AbilityToLevelUp[1]
	if abilityname=="nil"
	then
		table.remove( AbilityToLevelUp, 1 );
		return
	end
	if abilityname=="talent" 
	then
		local level=npcBot:GetLevel()
		for i,temp in pairs(AbilityToLevelUp)
		do
			if temp=="talent"
			then
				table.remove(AbilityToLevelUp,i)
				table.insert(AbilityToLevelUp,i,TalentTree[1]())
				table.remove(TalentTree,1)
				break
			end
		end
	end
	
	local ability=npcBot:GetAbilityByName(abilityname)

	if ability~=nil and ability:CanAbilityBeUpgraded()
	then
		npcBot:ActionImmediate_LevelAbility(abilityname);
		table.remove( AbilityToLevelUp, 1 );
	end
	
end

Towers={
    TOWER_TOP_1,
    TOWER_TOP_2,
    TOWER_TOP_3,
    TOWER_MID_1,
    TOWER_MID_2,
    TOWER_MID_3,
    TOWER_BOT_1,
    TOWER_BOT_2,
    TOWER_BOT_3,
    TOWER_BASE_1,
    TOWER_BASE_2
}

function ConsiderGlyph()
    for i, building_id in pairs(Towers) do
        local tower = GetTower(GetTeam(), building_id)
		if tower~=nil
		then
			-- local AttackByEnemy=false
			-- local enemysIDs=GetTeamPlayers(utility.GetOtherTeam())
			-- for _,i in pairs(enemysIDs)
			-- do
				-- if(tower:WasRecentlyDamagedByPlayer(i,2.5)==true)
				-- then
					-- AttackByEnemy=true
					-- break
				-- end
			-- end
			
				
			if tower:GetHealth() <=500 and tower:GetHealth() >=200 and tower:TimeSinceDamagedByAnyHero()+tower:TimeSinceDamagedByCreep() <= 5 --and AttackByEnemy
			then
				if GetGlyphCooldown() == 0  
				then
					GetBot():ActionImmediate_Glyph()
					break
				end
			end
		end
    end
end


function CanBuybackUpperRespawnTime( respawnTime )
	local npcBot=GetBot()
	if ( not npcBot:IsAlive() and respawnTime ~= nil and npcBot:GetRespawnTime() >= respawnTime
		and npcBot:GetBuybackCooldown() <= 0 and npcBot:GetGold() > npcBot:GetBuybackCost() ) then
		return true;
	end

	return false;

end
--GXC BUYBACK LOGIC	
function BuybackUsageThink() 
	local npcBot=GetBot()
	if npcBot:IsIllusion() then
		return;
	end	
	
	-- no buyback, no need to use GetUnitList() for performance considerations
	if ( not CanBuybackUpperRespawnTime(10) ) then
		return;
	end

	local tower_top_3 = GetTower( GetTeam(), TOWER_TOP_3 );
	local tower_mid_3 = GetTower( GetTeam(), TOWER_MID_3 );
	local tower_bot_3 = GetTower( GetTeam(), TOWER_BOT_3 );
	local tower_base_1 = GetTower( GetTeam(), TOWER_BASE_1 );
	local tower_base_2 = GetTower( GetTeam(), TOWER_BASE_2 );

	local barracks_top_melee = GetBarracks( GetTeam(), BARRACKS_TOP_MELEE );
	local barracks_mid_melee = GetBarracks( GetTeam(), BARRACKS_MID_MELEE );
	local barracks_bot_melee = GetBarracks( GetTeam(), BARRACKS_BOT_MELEE );

	local ancient = GetAncient( GetTeam() );

	local buildList = {
		tower_top_3, tower_mid_3, tower_bot_3, tower_base_1, tower_base_2,
		barracks_top_melee, 
		barracks_mid_melee,
		barracks_bot_melee, 
		ancient
	};

	for _, build in pairs(buildList) do
		local tableNearbyEnemyHeroes = build:GetNearbyHeroes( 1000, true, BOT_MODE_NONE );

		if ( tableNearbyEnemyHeroes ~= nil and #tableNearbyEnemyHeroes > 0 ) then
			if ( build:GetHealth() / build:GetMaxHealth() < 0.5
				and build:WasRecentlyDamagedByAnyHero(2.0) and CanBuybackUpperRespawnTime(30) ) then
				npcBot:ActionImmediate_Buyback();
				return;
			end
		end
	end

	if ( DotaTime() > 60 * 60 and CanBuybackUpperRespawnTime(30) ) then
		npcBot:ActionImmediate_Buyback();
	end

	
end

function InitAbility(Abilities,AbilitiesReal,Talents) 
	local npcBot=GetBot()
	for i=0,23,1 do
		local ability=npcBot:GetAbilityInSlot(i)
		if(ability~=nil)
		then
			if(ability:IsTalent()==true)
			then
				table.insert(Talents,ability:GetName())
			else
				table.insert(Abilities,ability:GetName())
				table.insert(AbilitiesReal,ability)
			end
		end
	end
end

function GetComboMana(AbilitiesReal)
	local npcBot=GetBot()
	local tempComboMana=0
	for i,ability in pairs(AbilitiesReal)
	do
		if ability:IsPassive()==false
		then
			if ability:IsUltimate()==false or ability:GetCooldownTimeRemaining()<=30
			then
				tempComboMana=tempComboMana+ability:GetManaCost()
			end
		end
	end
	return math.max(tempComboMana,300)

end

function GetComboDamage(AbilitiesReal)
	local npcBot=GetBot()
	local tempComboDamage=0
	for i,ability in pairs(AbilitiesReal)
	do
		if ability:IsPassive()==false
		then
			tempComboDamage=tempComboDamage+ability:GetAbilityDamage()
		end
	end
	return math.max(tempComboDamage,GetBot():GetOffensivePower())

end

function PrintDebugInfo(AbilitiesReal,cast)
	local npcBot=GetBot()
	for i=1,#AbilitiesReal
	do	
		if ( cast.Desire[i]~=nil and cast.Desire[i] > 0 ) 
		then
			if (cast.Type[i]==nil or cast.Type[i]=="target") and cast.Target[i]~=nil
			then
				utility.DebugTalk("try to use skill "..i.." at "..cast.Target[i]:GetUnitName().." Desire= "..cast.Desire[i])
			else
				utility.DebugTalk("try to use skill "..i.." Desire= "..cast.Desire[i])
			end
		end
	end		
end

function ConsiderAbility(AbilitiesReal,Consider)
	local npcBot=GetBot()
	local cast={} cast.Desire={} cast.Target={} cast.Type={}
	for i,ability in pairs(AbilitiesReal)
	do
		if ability:IsPassive()==false and Consider[i]~=nil
		then
			cast.Desire[i], cast.Target[i], cast.Type[i] = Consider[i]();
		end
	end
	return cast
end

function UseAbility(AbilitiesReal,cast)
	local npcBot=GetBot()
	
	local HighestDesire=0
	local HighestDesireAbility=0
	local HighestDesireAbilityBumber=0
	for i,ability in pairs(AbilitiesReal)
	do
		if (cast.Desire[i]~=nil and cast.Desire[i]>HighestDesire)
		then
			HighestDesire=cast.Desire[i]
			HighestDesireAbilityBumber=i
		end
	end
	if( HighestDesire>0)
	then
		local j=HighestDesireAbilityBumber
		local ability=AbilitiesReal[j]
		if(cast.Type[j]==nil)
		then
			if(utility.CheckFlag(ability:GetBehavior(),ABILITY_BEHAVIOR_NO_TARGET))
			then
				npcBot:Action_UseAbility( ability )
				return
			elseif(utility.CheckFlag(ability:GetBehavior(),ABILITY_BEHAVIOR_POINT))
			then
				npcBot:Action_UseAbilityOnLocation( ability , cast.Target[j])
				return
			else
				npcBot:Action_UseAbilityOnEntity( ability , cast.Target[j])
				return
			end
		else
			if(cast.Type[j]=="Target")
			then
				npcBot:Action_UseAbilityOnEntity( ability , cast.Target[j])
				return
			elseif(cast.Type[j]=="Location")
			then
				npcBot:Action_UseAbilityOnLocation( ability , cast.Target[j])
				return
			else
				npcBot:Action_UseAbility( ability )
				return
			end
		end
	end
end

function GiveToMidLaner()
	local teamPlayers = GetTeamPlayers(GetTeam())
	local target = nil;
	for k,v in pairs(teamPlayers)
	do
		local member = GetTeamMember(k);
		if member ~= nil and not member:IsIllusion() and member:IsAlive() then
			local num_stg = GetItemCount(member, "item_tango_single"); 
			local num_ff = GetItemCount(member, "item_faerie_fire"); 
			if num_ff > 0 and num_stg < 1 then
				return member;
			end
		end
	end
	return nil;
end

function GetItemCount(unit, item_name)
	local count = 0;
	for i = 0, 8 
	do
		local item = unit:GetItemInSlot(i)
		if item ~= nil and item:GetName() == item_name then
			count = count + 1;
		end
	end
	return count;
end

--BOT EXPER's code
function UnImplementedItemUsage()
	local npcBot=GetBot()
	if npcBot:IsChanneling() or npcBot:IsUsingAbility() or npcBot:IsInvisible() or npcBot:IsMuted( )  then
		return;
	end
	local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( 800, true, BOT_MODE_NONE );
	
	local npcTarget = npcBot:GetTarget();
	
	local itg=IsItemAvailable("item_tango");
	if(giveTime==nil)
	then
		giveTime=DotaTime()
	end
	if itg~=nil and itg:IsFullyCastable() then
		local tCharge = itg:GetCurrentCharges()
		if DotaTime() > -80 and DotaTime() < 0 and npcBot:DistanceFromFountain() == 0 
		   and npcBot:GetAssignedLane() ~= LANE_MID and tCharge > 3 and DotaTime() > giveTime + 2.0 then
			local target = GiveToMidLaner()
			if target ~= nil then
				npcBot:ActionImmediate_Chat(string.gsub(npcBot:GetUnitName(),"npc_dota_hero_","")..
						" giving tango to "..
						string.gsub(target:GetUnitName(),"npc_dota_hero_","")
						, false);
				npcBot:Action_UseAbilityOnEntity(itg, target);
				giveTime = DotaTime();
				return;
			end
		elseif npcBot:GetActiveMode() == BOT_MODE_LANING  and tCharge > 1 and DotaTime() > giveTime + 2.0 then
			local allies = npcBot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
			for _,ally in pairs(allies)
			do
				local tangoSlot = ally:FindItemSlot('item_tango');
				if ally:GetUnitName() ~= npcBot:GetUnitName() and not ally:IsIllusion() 
				   and tangoSlot == -1 and GetItemCount(ally, "item_tango_single") == 0 
				then
					npcBot:Action_UseAbilityOnEntity(itg, ally);
					giveTime = DotaTime();
					return
				end
			end
		end
	end
	
	-- local arm=IsItemAvailable("item_armlet");
	-- if arm~=nil and arm:IsFullyCastable() then
		-- if #tableNearbyEnemyHeroes == 0 and arm:GetToggleState( ) then
			-- npcBot:Action_UseAbility(arm);
			-- return;
		-- end
	-- end
	
	local mg=IsItemAvailable("item_enchanted_mango");
	if mg~=nil and mg:IsFullyCastable() then
		if npcBot:GetMana() < 100 
		then
			npcBot:Action_UseAbility(mg);
			return;
		end
	end
	
	local tok=IsItemAvailable("item_tome_of_knowledge");
	if tok~=nil and tok:IsFullyCastable() then
		npcBot:Action_UseAbility(tok);
		return;
	end
	
	local ff=IsItemAvailable("item_faerie_fire");
	if ff~=nil and ff:IsFullyCastable() then
		if  npcBot:GetActiveMode() == BOT_MODE_RETREAT and 
			npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH and 
			( npcBot:GetHealth() / npcBot:GetMaxHealth() ) < 0.15 
		then
			npcBot:Action_UseAbility(ff);
			return;
		end
	end
	
	local bst=IsItemAvailable("item_bloodstone");
	if bst ~= nil and bst:IsFullyCastable() then
		if  npcBot:GetActiveMode() == BOT_MODE_RETREAT and 
			npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH and 
			( npcBot:GetHealth() / npcBot:GetMaxHealth() ) < 0.10
		then
			npcBot:Action_UseAbilityOnLocation(bst, npcBot:GetLocation());
			return;
		end
	end
	
	local pb=IsItemAvailable("item_phase_boots");
	if pb~=nil and pb:IsFullyCastable() 
	then
		if ( npcBot:GetActiveMode() == BOT_MODE_ATTACK or
			 npcBot:GetActiveMode() == BOT_MODE_RETREAT or
			 npcBot:GetActiveMode() == BOT_MODE_ROAM or
			 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
			 npcBot:GetActiveMode() == BOT_MODE_GANK or
			 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY )
		then
			npcBot:Action_UseAbility(pb);
			return;
		end	
	end
	
	local bt=IsItemAvailable("item_bloodthorn");
	if bt~=nil and bt:IsFullyCastable() 
	then
		if ( npcBot:GetActiveMode() == BOT_MODE_ATTACK or
			 npcBot:GetActiveMode() == BOT_MODE_ROAM or
			 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
			 npcBot:GetActiveMode() == BOT_MODE_GANK or
			 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY )
		then
			local npcTarget = npcBot:GetTarget();
			if ( npcTarget ~= nil and npcTarget:IsHero() and CanCastOnTarget(npcTarget) and GetUnitToUnitDistance(npcTarget, npcBot) < 900 )
			then
			    npcBot:Action_UseAbilityOnEntity(bt,npcTarget);
				return
			end
		end
	end
	
	local sc=IsItemAvailable("item_solar_crest");
	if sc~=nil and sc:IsFullyCastable() 
	then
		if ( npcBot:GetActiveMode() == BOT_MODE_ATTACK or
			 npcBot:GetActiveMode() == BOT_MODE_ROAM or
			 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
			 npcBot:GetActiveMode() == BOT_MODE_GANK or
			 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY )
		then
			if ( npcTarget ~= nil and npcTarget:IsHero() and npcTarget:IsHero() and GetUnitToUnitDistance(npcTarget, npcBot) < 900 )
			then
			    npcBot:Action_UseAbilityOnEntity(sc,npcTarget);
				return
			end
		end
	end
	
	if sc~=nil and sc:IsFullyCastable() then
		local Allies=npcBot:GetNearbyHeroes(1000,false,BOT_MODE_NONE);
		for _,Ally in pairs(Allies) do
			if ( Ally:GetHealth()/Ally:GetMaxHealth() < 0.35 and tableNearbyEnemyHeroes ~= nil and #tableNearbyEnemyHeroes > 0 and CanCastOnTarget(Ally) ) or 
			   ( IsDisabled(Ally) and CanCastOnTarget(Ally) )
			then
				npcBot:Action_UseAbilityOnEntity(sc,Ally);
				return;
			end
		end
	end
	
	local se=IsItemAvailable("item_silver_edge");
    if se ~= nil and se:IsFullyCastable() then
		if npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH and 
			tableNearbyEnemyHeroes ~= nil and #tableNearbyEnemyHeroes > 0
		then
			npcBot:Action_UseAbility(se);
			return;
	    end
		if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
			 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
			 npcBot:GetActiveMode() == BOT_MODE_GANK )
		then
			if ( npcTarget ~= nil and npcTarget:IsHero() and GetUnitToUnitDistance(npcTarget, npcBot) > 1000 and  GetUnitToUnitDistance(npcTarget, npcBot) < 2500 )
			then
			    npcBot:Action_UseAbility(se);
				return;
			end
		end
	end
	
	local hood=IsItemAvailable("item_hood_of_defiance");
    if hood~=nil and hood:IsFullyCastable() and npcBot:GetHealth()/npcBot:GetMaxHealth()<0.8 
	then
		if tableNearbyEnemyHeroes ~= nil and #tableNearbyEnemyHeroes > 0 then
			npcBot:Action_UseAbility(hood);
			return;
		end
	end
	
	local lotus=IsItemAvailable("item_lotus_orb");
	if lotus~=nil and lotus:IsFullyCastable() 
	then
		if  ( npcBot:GetHealth()/npcBot:GetMaxHealth() < 0.45 and tableNearbyEnemyHeroes ~=nil and #tableNearbyEnemyHeroes > 0 ) or
			 npcBot:IsSilenced() or
		    ( tableNearbyEnemyHeroes ~= nil and #tableNearbyEnemyHeroes >= 3 and npcBot:GetHealth()/npcBot:GetMaxHealth() < 0.75 )
	    then
			npcBot:Action_UseAbilityOnEntity(lotus,npcBot);
			return;
		end
	end
	
	if lotus~=nil and lotus:IsFullyCastable() 
	then
		local Allies=npcBot:GetNearbyHeroes(1000,false,BOT_MODE_NONE);
		for _,Ally in pairs(Allies) do
			if ( Ally:GetHealth()/Ally:GetMaxHealth() < 0.35 and tableNearbyEnemyHeroes ~= nil and #tableNearbyEnemyHeroes > 0 )  or 
				 IsDisabled(Ally)
			then
				npcBot:Action_UseAbilityOnEntity(lotus,Ally);
				return;
			end
		end
	end
	
	local hurricanpike = IsItemAvailable("item_hurricane_pike");
	if hurricanpike~=nil and hurricanpike:IsFullyCastable() 
	then
		if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH )
		then
			for _,npcEnemy in pairs( tableNearbyEnemyHeroes )
			do
				if ( GetUnitToUnitDistance( npcEnemy, npcBot ) < 400 and CanCastOnTarget(npcEnemy) )
				then
					npcBot:Action_UseAbilityOnEntity(hurricanpike,npcEnemy);
					return
				end
			end
			if npcBot:IsFacingLocation(GetAncient(GetTeam()):GetLocation(),10) and npcBot:DistanceFromFountain() > 0 
			then
				npcBot:Action_UseAbilityOnEntity(hurricanpike,npcBot);
				return;
			end
		end
	end
	
	local glimer=IsItemAvailable("item_glimmer_cape");
	if glimer~=nil and glimer:IsFullyCastable() then
		if ( npcBot:GetHealth()/npcBot:GetMaxHealth() < 0.45 and ( tableNearbyEnemyHeroes~=nil and #tableNearbyEnemyHeroes>0) ) or 
		   ( tableNearbyEnemyHeroes~=nil and #tableNearbyEnemyHeroes >= 3 and npcBot:GetHealth()/npcBot:GetMaxHealth() < 0.65 )  	
		then	
			npcBot:Action_UseAbilityOnEntity(glimer,npcBot);
			return;
		end
	end
	
	local hod=IsItemAvailable("item_helm_of_the_dominator");
	if hod~=nil and hod:IsFullyCastable() 
	then
		local maxHP = 0;
		local NCreep = nil;
		local tableNearbyCreeps = npcBot:GetNearbyCreeps( 1000, true );
		if #tableNearbyCreeps >= 2 
		then
			for _,creeps in pairs(tableNearbyCreeps)
			do
				local CreepHP = creeps:GetHealth();
				if CreepHP > maxHP and ( creeps:GetHealth() / creeps:GetMaxHealth() ) > .75  and not creeps:IsAncientCreep()
				then
					NCreep = creeps;
					maxHP = CreepHP;
				end
			end
		end
		if NCreep ~= nil then
			npcBot:Action_UseAbilityOnEntity(hod,NCreep);
			return
		end	
	end
	
	if glimer~=nil and glimer:IsFullyCastable() then
		local Allies=npcBot:GetNearbyHeroes(1000,false,BOT_MODE_NONE);
		for _,Ally in pairs(Allies) do
			if ( Ally:GetHealth()/Ally:GetMaxHealth() < 0.35 and tableNearbyEnemyHeroes ~= nil and #tableNearbyEnemyHeroes > 0 and CanCastOnTarget(Ally) ) or 
			   ( IsDisabled(Ally) and CanCastOnTarget(Ally) )
			then
				npcBot:Action_UseAbilityOnEntity(glimer,Ally);
				return;
			end
		end
	end
	
	local guardian=IsItemAvailable("item_guardian_greaves");
	if guardian~=nil and guardian:IsFullyCastable() then
		local Allies=npcBot:GetNearbyHeroes(1000,false,BOT_MODE_NONE);
		for _,Ally in pairs(Allies) do
			if  Ally:GetHealth()/Ally:GetMaxHealth() < 0.35 and tableNearbyEnemyHeroes~=nil and #tableNearbyEnemyHeroes > 0 
			then
				npcBot:Action_UseAbility(guardian);
				return;
			end
		end
	end
	
	local satanic=IsItemAvailable("item_satanic");
	if satanic~=nil and satanic:IsFullyCastable() then
		if  npcBot:GetHealth()/npcBot:GetMaxHealth() < 0.50 and 
			tableNearbyEnemyHeroes~=nil and #tableNearbyEnemyHeroes > 0 and 
			npcBot:GetActiveMode() == BOT_MODE_ATTACK
		then
			npcBot:Action_UseAbility(satanic);
			return;
		end
	end
	
	-- local tango=IsItemAvailable("item_tango");
	-- if tango~=nil and tango:IsFullyCastable() then
		-- local allys = npcBot:GetNearbyHeroes( 1600, false, BOT_MODE_NONE );
		-- for _,ally in pairs(allys)
		-- do
			-- if((tango:GetCurrentCharges()==4 and DotaTime()>-30 and DotaTime()<0 or ally:GetHealth()-ally:GetMaxHealth()>200)  )
			-- then
				-- print("give")
				-- npcBot:Action_UseAbilityOnEntity(tango,Ally);
			-- end
		-- end
		
	-- end
	
	local WardList=GetUnitList(UNIT_LIST_ALLIED_WARDS)
	local HaveWard=false
	
	for _,ward in pairs(WardList)
	do
		if(GetUnitToUnitDistance(ward,npcBot)<=1500)
		then
			HaveWard=true
		end
	end
	
	local sentry=IsItemAvailable("item_ward_sentry");
	if sentry~=nil and sentry:IsFullyCastable() then
		
		local NearbyTowers = npcBot:GetNearbyTowers(1600,true)
		local NearbyTowers2 = npcBot:GetNearbyTowers(800,true)
		local NearbyTowers3 = npcBot:GetNearbyTowers(800,false)
		
		if  HaveWard==false
		then
			if (npcBot:GetActiveMode() == BOT_MODE_ATTACK)
			then
				npcBot:Action_UseAbilityOnLocation( sentry, npcBot:GetLocation() );
			end
			
			if npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or 
			 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or 
			 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT and #NearbyTowers2==0 and #NearbyTowers>0
			then
				npcBot:Action_UseAbilityOnLocation( sentry, npcBot:GetXUnitsInBehind(300) );
			end	 
			
			if npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
			 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
			 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT and #NearbyTowers3==0 
			then
				npcBot:Action_UseAbilityOnLocation( sentry, npcBot:GetXUnitsInFront(300) );
			end
			
		end
	end
	
end

function IsItemAvailable(item_name)
	local npcBot=GetBot()
    for i = 0, 5 do
        local item = npcBot:GetItemInSlot(i);
		if (item~=nil) then
			if(item:GetName() == item_name) then
				return item;
			end
		end
    end
    return nil;
end

function IsXItemAvailable(npcBot,item_name)

    for i = 0, 5 do
        local item = npcBot:GetItemInSlot(i);
		if (item~=nil) then
			if(item:GetName() == item_name) then
				return item;
			end
		end
    end
    return nil;
end

function CanCastOnTarget( npcTarget )
	return npcTarget:CanBeSeen() and not npcTarget:IsMagicImmune() and not npcTarget:IsInvulnerable();
end
function CanCastOnMagicImmuneTarget( npcTarget )
	return npcTarget:CanBeSeen() and not npcTarget:IsInvulnerable();
end

function IsDisabled(npcTarget)
	if npcTarget:IsRooted( ) or npcTarget:IsStunned( ) or npcTarget:IsHexed( ) or npcTarget:IsSilenced() or npcTarget:IsNightmared() then
		return true;
	end
	return false;
end

for k,v in pairs( ability_item_usage_generic ) do	_G._savedEnv[k] = v end
