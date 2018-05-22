----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.3 New Structure
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
-------
_G._savedEnv = getfenv()
module( "ability_item_usage_generic", package.seeall )
local utility = require( GetScriptDirectory().."/utility" ) 
local role = require(GetScriptDirectory() ..  "/RoleUtility")
----------
function PrintCourierState(state)
	if state == 0 then
		print("COURIER_STATE_IDLE ");
	elseif state == 1 then
		print("COURIER_STATE_AT_BASE");
	elseif state == 2 then
		print("COURIER_STATE_MOVING");
	elseif state == 3 then
		print("COURIER_STATE_DELIVERING_ITEMS");
	elseif state == 4 then
		print("COURIER_STATE_RETURNING_TO_BASE");
	elseif state == 5 then
		print("COURIER_STATE_DEAD");
	else
		print("UNKNOWN");
	end	
end

local courierTime = -90;
local cState = -1;
GetBot().SShopUser = false;
local returnTime = -90;
local apiAvailable = false;
function CourierUsageThink()
	ConsiderGlyph()
	UnImplementedItemUsage()
	
	local npcBot=GetBot();
	if GetGameMode() == 23 or npcBot:IsInvulnerable() or not npcBot:IsHero() or npcBot:IsIllusion() or npcBot:HasModifier("modifier_arc_warden_tempest_double") or GetNumCouriers() == 0 then
		return;
	end
	
	local npcCourier = GetCourier(0);	
	local cState = GetCourierState( npcCourier );
	--PrintCourierState(cState);
	local courierPHP = npcCourier:GetHealth() / npcCourier:GetMaxHealth(); 
	
	if cState == COURIER_STATE_DEAD then
		npcCourier.latestUser = nil;
		return
	end
	
	if IsFlyingCourier(npcCourier) then
		local burst = npcCourier:GetAbilityByName('courier_shield');
		if IsTargetedByUnit(npcCourier) then
			if burst:IsFullyCastable() and apiAvailable == true 
			then
				npcBot:ActionImmediate_Courier( npcCourier, COURIER_ACTION_BURST );
				return
			elseif DotaTime() > returnTime + 7.0
			       --and not burst:IsFullyCastable() and not npcCourier:HasModifier('modifier_courier_shield') 
			then
				npcBot:ActionImmediate_Courier( npcCourier, COURIER_ACTION_RETURN );
				returnTime = DotaTime();
				return
			end
		end
	else	
		if IsTargetedByUnit(npcCourier) then
			if DotaTime() - returnTime > 7.0 then
				npcBot:ActionImmediate_Courier( npcCourier, COURIER_ACTION_RETURN );
				returnTime = DotaTime();
				return
			end
		end
	end
	
	if ( IsCourierAvailable() and cState ~= COURIER_STATE_IDLE )  then
		npcCourier.latestUser = "temp";
	end
	
	--FREE UP THE COURIER FOR HUMAN PLAYER
	if cState == COURIER_STATE_MOVING or IsHumanHaveItemInCourier() then
		npcCourier.latestUser = nil;
	end
	
	if npcBot.SShopUser and ( not npcBot:IsAlive() or npcBot:GetActiveMode() == BOT_MODE_SECRET_SHOP or not (npcBot.secretShopMode == true and npcBot:GetActiveMode() ~= BOT_MODE_SECRET_SHOP)  ) then
		--npcBot:ActionImmediate_Chat( "Releasing the courier to anticipate secret shop stuck", true );
		npcCourier.latestUser = "temp";
		npcBot.SShopUser = false;
		npcBot:ActionImmediate_Courier( npcCourier, COURIER_ACTION_RETURN );
		return
	end
	
	if npcCourier.latestUser ~= nil and ( IsCourierAvailable() or cState == COURIER_STATE_RETURNING_TO_BASE ) and DotaTime() - returnTime > 7.0  then 
		
		if cState == COURIER_STATE_AT_BASE and courierPHP < 1.0 then
			return;
		end
		
		--RETURN COURIER TO BASE WHEN IDLE 
		if cState == COURIER_STATE_IDLE then
			npcBot:ActionImmediate_Courier( npcCourier, COURIER_ACTION_RETURN );
			return
		end
		
		--TAKE ITEM FROM STASH
		if  cState == COURIER_STATE_AT_BASE then
			local nCSlot = GetCourierEmptySlot(npcCourier);
			local numPlayer =  GetTeamPlayers(GetTeam());
			local stashValue = npcBot:GetStashValue();
			for i = 1, #numPlayer
			do
				local member =  GetTeamMember(i);
				if member ~= nil and IsPlayerBot(numPlayer[i]) and member:IsAlive() 
				then
					local nMSlot = GetNumStashItem(member);
					if nMSlot > 0 and nMSlot <= nCSlot and stashValue>=500 then
						member:ActionImmediate_Courier( npcCourier, COURIER_ACTION_TAKE_STASH_ITEMS );
						nCSlot = nCSlot - nMSlot ;
						courierTime = DotaTime();
					end
				end
			end
		end
		
		--MAKE COURIER GOES TO SECRET SHOP
		if  npcBot:IsAlive() and (npcBot.secretShopMode == true and npcBot:GetActiveMode() ~= BOT_MODE_SECRET_SHOP) and npcCourier:DistanceFromFountain() < 7000 and DotaTime() > courierTime + 1.0 then
			--npcBot:ActionImmediate_Chat( "Using Courier for secret shop.", true );
			npcBot:ActionImmediate_Courier( npcCourier, COURIER_ACTION_SECRET_SHOP )
			npcCourier.latestUser = npcBot;
			npcBot.SShopUser = true;
			UpdateSShopUserStatus(npcBot);
			courierTime = DotaTime();
			return
		end
		
		--TRANSFER ITEM IN COURIER
		if npcBot:IsAlive() and npcBot:GetCourierValue( ) > 0 and IsTheClosestToCourier(npcBot, npcCourier)
		   and ( npcCourier:DistanceFromFountain() < 7000 or GetUnitToUnitDistance(npcBot, npcCourier) < 1300 ) and DotaTime() > courierTime + 1.0
		then
			npcBot:ActionImmediate_Courier( npcCourier, COURIER_ACTION_TRANSFER_ITEMS )
			npcCourier.latestUser = npcBot;
			courierTime = DotaTime();
			return
		end
		
		--RETURN STASH ITEM WHEN DEATH
		if  not npcBot:IsAlive() and cState == COURIER_STATE_DELIVERING_ITEMS  
			and npcBot:GetCourierValue( ) > 0 and DotaTime() > courierTime + 1.0
		then
			npcBot:ActionImmediate_Courier( npcCourier, COURIER_ACTION_RETURN_STASH_ITEMS );
			npcCourier.latestUser = npcBot;
			courierTime = DotaTime();
			return
		end
		
	
	end
end

function IsHumanHaveItemInCourier()
	local numPlayer =  GetTeamPlayers(GetTeam());
	for i = 1, #numPlayer
	do
		if not IsPlayerBot(numPlayer[i]) then
			local member = GetTeamMember(i);
			if member ~= nil and member:IsAlive() and member:GetCourierValue( ) > 0 
			then
				return true;
			end
		end
	end
	return false;
end

function IsTheClosestToCourier(npcBot, npcCourier)
	local numPlayer =  GetTeamPlayers(GetTeam());
	local closest = nil;
	local closestD = 100000;
	for i = 1, #numPlayer
	do
		local member =  GetTeamMember(i);
		if member ~= nil and IsPlayerBot(numPlayer[i]) and member:IsAlive() and member:GetCourierValue( ) > 0 and  not IsInvFull(member)
		then
			local dist = GetUnitToUnitDistance(member, npcCourier);
			if dist < closestD then
				closest = member;
				closestD = dist;
			end
		end
	end
	return closest ~= nil and closest == npcBot
end

function GetCourierEmptySlot(courier)
	local amount = 0;
	for i=0, 8 do
		if courier:GetItemInSlot(i) == nil then
			amount = amount + 1;
		end
	end
	return amount;
end

function GetNumStashItem(unit)
	local amount = 0;
	for i=9, 14 do
		if unit:GetItemInSlot(i) ~= nil then
			amount = amount + 1;
		end
	end
	return amount;
end

function UpdateSShopUserStatus(npcBot)
	local numPlayer =  GetTeamPlayers(GetTeam());
	for i = 1, #numPlayer
	do
		local member =  GetTeamMember(i);
		if member ~= nil and IsPlayerBot(numPlayer[i]) and  member:GetUnitName() ~= npcBot:GetUnitName() 
		then
			member.SShopUser = false;
		end
	end
end

function IsTargetedByUnit(courier)
	for i = 0, 10 do
	local tower = GetTower(GetOpposingTeam(), i)
		if tower ~= nil and tower:GetAttackTarget() == courier then
			return true;
		end
	end
	for i,id in pairs(GetTeamPlayers(GetOpposingTeam())) do
		if IsHeroAlive(id) then
			local info = GetHeroLastSeenInfo(id);
			if info ~= nil then
				local dInfo = info[1];
				if dInfo ~= nil and GetUnitToLocationDistance(courier, dInfo.location) <= 700 and dInfo.time_since_seen < 0.5 then
					return true;
				end
			end
		end
	end
	return false;
end

function IsInvFull(npcHero)
	for i=0, 8 do
		if(npcHero:GetItemInSlot(i) == nil) then
			return false;
		end
	end
	return true;
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
	if GetGlyphCooldown() > 0  
	then
		return false
	end
	
    for i, BuildingID in pairs(Towers) do
        local tower = GetTower(GetTeam(), BuildingID)
		if tower~=nil
		then
			local tableNearbyEnemyHeroes = utility.GetEnemiesNearLocation(tower:GetLocation(),700)
			if tower:GetHealth() >=200 and tower:GetHealth() <=1000 and #tableNearbyEnemyHeroes>=2
			then
				GetBot():ActionImmediate_Glyph()
				break
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
	if ( not CanBuybackUpperRespawnTime(20) ) then
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
		if DotaTime() > 25 * 60 and CanBuybackUpperRespawnTime(20) then
			if ( tableNearbyEnemyHeroes ~= nil and #tableNearbyEnemyHeroes > 1 ) then
				if (build:WasRecentlyDamagedByAnyHero(2.0) and CanBuybackUpperRespawnTime(20) ) then
					npcBot:ActionImmediate_Buyback();
					return;
				end
			end
		end
	end

	if ( DotaTime() > 35 * 60 and CanBuybackUpperRespawnTime(30) ) then
		npcBot:ActionImmediate_Buyback();
	end

	
end

function InitAbility(Abilities,AbilitiesReal,Talents) 
	local npcBot=GetBot()
	for i=0,25,1 do
		local ability=npcBot:GetAbilityInSlot(i)
		if(ability~=nil)
		then
			if(ability:GetName()~="generic_hidden")
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
			local ability=AbilitiesReal[i]
			if (cast.Type[i]==nil or cast.Type[i]=="Target") and cast.Target[i]~=nil and utility.CheckFlag(ability:GetBehavior(),ABILITY_BEHAVIOR_UNIT_TARGET)
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
			elseif(utility.CheckFlag(ability:GetTargetType(),ABILITY_TARGET_TYPE_TREE))
			then
				npcBot:Action_UseAbilityOnTree( ability , cast.Target[j])
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
			local num_sts = GetItemCount(member, "item_tango_single"); 
			local num_ff = GetItemCount(member, "item_faerie_fire"); 
			local num_stg = GetItemCharges(member, "item_tango");
			if  num_sts + num_stg <= 3 then
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

function GetItemCharges(unit, item_name)
	local count = 0;
	for i = 0, 8 
	do
		local item = unit:GetItemInSlot(i)
		if item ~= nil and item:GetName() == item_name then
			count = count + item:GetCurrentCharges();
		end
	end
	return count;
end

function CanSwitchPTStat(pt)
	local npcBot=GetBot()
	if npcBot:GetPrimaryAttribute() == ATTRIBUTE_STRENGTH and pt:GetPowerTreadsStat() ~= ATTRIBUTE_STRENGTH then
		return true;
	elseif npcBot:GetPrimaryAttribute() == ATTRIBUTE_AGILITY  and pt:GetPowerTreadsStat() ~= ATTRIBUTE_INTELLECT then
		return true;
	elseif npcBot:GetPrimaryAttribute() == ATTRIBUTE_INTELLECT and pt:GetPowerTreadsStat() ~= ATTRIBUTE_AGILITY then
		return true;
	end 
	return false;
end

--npcBot EXPER's code
local giveTime = -90;
function UnImplementedItemUsage()
	local npcBot=GetBot()
	if npcBot:IsChanneling() or npcBot:IsUsingAbility() or npcBot:IsInvisible() or npcBot:IsMuted( )  then
		return;
	end
	local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( 800, true, BOT_MODE_NONE );
	
	local npcTarget = npcBot:GetTarget();
	
	local pt = IsItemAvailable("item_power_treads");
	if pt~=nil and pt:IsFullyCastable() then
		if mode == BOT_MODE_RETREAT and pt:GetPowerTreadsStat() ~= ATTRIBUTE_STRENGTH and npcBot:WasRecentlyDamagedByAnyHero(5.0) then
			npcBot:Action_UseAbility(pt);
			return
		elseif mode == BOT_MODE_ATTACK and CanSwitchPTStat(pt) then
			npcBot:Action_UseAbility(pt);
			return
		else
			local enemies = npcBot:GetNearbyHeroes( 1300, true, BOT_MODE_NONE );
			if #enemies == 0 and  mode ~= BOT_MODE_RETREAT and CanSwitchPTStat(pt)  then
				npcBot:Action_UseAbility(pt);
				return
			end
		end
	end

	local bas = IsItemAvailable("item_ring_of_basilius");
	if bas~=nil and bas:IsFullyCastable() then
		if mode == BOT_MODE_LANING and not bas:GetToggleState() then
			npcBot:Action_UseAbility(bas);
			return
		elseif mode ~= BOT_MODE_LANING and bas:GetToggleState() then
			npcBot:Action_UseAbility(bas);
			return
		end
	end
	
	local aq = IsItemAvailable("item_ring_of_aquila");
	if aq~=nil and aq:IsFullyCastable() then
		if mode == BOT_MODE_LANING and not aq:GetToggleState() then
			npcBot:Action_UseAbility(aq);
			return
		elseif mode ~= BOT_MODE_LANING and aq:GetToggleState() then
			npcBot:Action_UseAbility(aq);
			return
		end
	end


	if ( DotaTime() > 7*60) then
		for i = 0, 14 do
			local sCurItem = npcBot:GetItemInSlot(i);
			if ( sCurItem ~= nil and sCurItem:GetName() == "item_tango" ) then
				local trees = npcBot:GetNearbyTrees(1000);
				if trees[1] ~= nil then
					npcBot:Action_UseAbilityOnTree(sCurItem, trees[1]);
					return;
				end
				--npcBot:Action_DropItem(sCurItem,npcBot:GetLocation());
			end
		end
	end

	local itg=IsItemAvailable("item_tango");
	if itg~=nil and itg:IsFullyCastable() then
		local tCharge = itg:GetCurrentCharges()
		if DotaTime() > -90 and DotaTime() < 0 and npcBot:DistanceFromFountain() <=100 and role.CanBeSupport(npcBot:GetUnitName())
		   and npcBot:GetAssignedLane() ~= LANE_MID and tCharge > 2 and DotaTime() > giveTime + 2.0 then
			local target = GiveToMidLaner()
			if target ~= nil then
				--[[npcBot:ActionImmediate_Chat(string.gsub(npcBot:GetUnitName(),"npc_dota_hero_","")..
						" giving tango to "..
						string.gsub(target:GetUnitName(),"npc_dota_hero_","")..
						"Don't ask why we only give you one tango. We are poor. 别问我们为什么只给一颗吃树了，我们穷。"
						, false);]]
				npcBot:ActionImmediate_Chat("Please use hard or unfair mode and not play Monkey king. 请使用困难或疯狂难度，不要使用齐天大圣。",false);
				npcBot:Action_UseAbilityOnEntity(itg, target);
				giveTime = DotaTime();
				return;
			end
		elseif DotaTime() > 0 and npcBot:GetActiveMode() == BOT_MODE_LANING and role.CanBeSupport(npcBot:GetUnitName()) and tCharge > 1 and DotaTime() > giveTime + 2.0 then
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
	
	--[[local its=IsItemAvailable("item_tango_single");
	if its~=nil and its:IsFullyCastable() and its:GetCooldownTimeRemaining() == 0 then
		if DotaTime() > 10*60 and npcBot:DistanceFromFountain() > 1300
		then
			local trees = npcBot:GetNearbyTrees(1300);
			if trees[1] ~= nil then
				npcBot:Action_UseAbilityOnTree(its, trees[1]);
				return;
			end
		end
	end]]
	


	if itg~=nil and itg:IsFullyCastable() and npcBot:DistanceFromFountain() > 1000 then
		if DotaTime() > 0 and not npcBot:HasModifier("modifier_tango_heal")
		then
			local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( 300, true, BOT_MODE_NONE );
			local trees = npcBot:GetNearbyTrees(1000);
			local num_sts = GetItemCount(npcBot, "item_tango_single"); 
			if trees[1] ~= nil  and (npcBot:GetHealth() / npcBot:GetMaxHealth())  < 0.7 and num_sts <= 0
				and ( IsLocationVisible(GetTreeLocation(trees[1])) or IsLocationPassable(GetTreeLocation(trees[1])) )
			   and #tableNearbyEnemyHeroes == 0
			then
				npcBot:Action_UseAbilityOnTree(itg, trees[1]);
				return;
			end
		end
	end

	local its=IsItemAvailable("item_tango_single");
	if its~=nil and its:IsFullyCastable() and npcBot:DistanceFromFountain() > 1000 then
		if DotaTime() > 0 and not npcBot:HasModifier("modifier_tango_heal")
		then
			local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( 300, true, BOT_MODE_NONE );
			local trees = npcBot:GetNearbyTrees(1000);
			if trees[1] ~= nil  and (npcBot:GetHealth() / npcBot:GetMaxHealth())  < 0.7 
				and ( IsLocationVisible(GetTreeLocation(trees[1])) or IsLocationPassable(GetTreeLocation(trees[1])) )
			   and #tableNearbyEnemyHeroes <= 1
			then
				npcBot:Action_UseAbilityOnTree(its, trees[1]);
				return;
			end
		end
	end

	if ( DotaTime() > 4*60) then
		for i = 0, 14 do
			local sCurItem = npcBot:GetItemInSlot(i);
			if ( sCurItem ~= nil and sCurItem:GetName() == "item_tango_single" ) then
				local trees = npcBot:GetNearbyTrees(1000);
				if trees[1] ~= nil then
					npcBot:Action_UseAbilityOnTree(sCurItem, trees[1]);
					return;
				end
				--npcBot:Action_DropItem(sCurItem,npcBot:GetLocation());
			end
		end
	end


	local ifl =IsItemAvailable("item_flask");
	if ifl~=nil and ifl:IsFullyCastable() and npcBot:DistanceFromFountain() > 1000 then
		if DotaTime() > 0 
		then
			local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( 650, true, BOT_MODE_NONE );
			if  (npcBot:GetHealth() / npcBot:GetMaxHealth())  < 0.35 
				and #tableNearbyEnemyHeroes == 0 
			then
				npcBot:Action_UseAbilityOnEntity(ifl, npcBot);
				return;
			end
		end
	end

	local icl =IsItemAvailable("item_clarity");
	if icl~=nil and icl:IsFullyCastable() and npcBot:DistanceFromFountain() > 1000 then
		if DotaTime() > 0 
		then
			local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( 550, true, BOT_MODE_NONE );
			if  (npcBot:GetMana() / npcBot:GetMaxMana())  < 0.35 
				and #tableNearbyEnemyHeroes == 0 
			then
				npcBot:Action_UseAbilityOnEntity(icl, npcBot);
				return;
			end
		end
	end

	
	local irt=IsItemAvailable("item_iron_talon");
	if irt~=nil and irt:IsFullyCastable() then
		if npcBot:GetActiveMode() == BOT_MODE_FARM 
		then
			local neutrals = npcBot:GetNearbyNeutralCreeps(500);
			local maxHP = 0;
			local target = nil;
			for _,c in pairs(neutrals) do
				local cHP = c:GetHealth();
				if cHP > maxHP and not c:IsAncientCreep() then
					maxHP = cHP;
					target = c;
				end
			end
			if target ~= nil then
				npcBot:Action_UseAbilityOnEntity(irt, target);
				return;
			end
		end
	end	
	
	local msh=IsItemAvailable("item_moon_shard");
	if msh~=nil and msh:IsFullyCastable() then
		if not npcBot:HasModifier("modifier_item_moon_shard_consumed")
		then
			print("use Moon")
			npcBot:Action_UseAbilityOnEntity(msh, npcBot);
			return;
		end
	end

	--[[local mg=IsItemAvailable("item_enchanted_mango");
	if mg~=nil and mg:IsFullyCastable() then
		if npcBot:GetMana() < 100 
		then
			npcBot:Action_UseAbility(mg);
			return;
		end
	end]]
	
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

	local sr=IsItemAvailable("item_soul_ring");
	if sr~=nil and sr:IsFullyCastable() then
		if  (npcBot:GetActiveMode() == BOT_MODE_LANING 
			or npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP 
			or npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID
			or npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT
			or npcBot:GetActiveMode() == BOT_MODE_FARM)
		then
			if ( (npcBot:GetHealth() / npcBot:GetMaxHealth()) > 0.7 and (npcBot:GetMana() / npcBot:GetMaxMana()) < 0.4)
			then
			npcBot:Action_UseAbility(sr);
			return;
			end
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
			if ( npcTarget ~= nil and npcTarget:IsHero() and GetUnitToUnitDistance(npcTarget, npcBot) < 900 )
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
	
	local ggr=IsItemAvailable("item_guardian_greaves");
	if ggr~=nil and ggr:IsFullyCastable() then
		local allys = npcBot:GetNearbyHeroes( 900, false, BOT_MODE_NONE );
		local factor=0

		for k,v in pairs(allys) do
			local allyFactor=(2-v:GetMana()/v:GetMaxMana()-v:GetHealth()/v:GetMaxHealth())*0.5
			factor=factor+allyFactor
		end

		if factor/#allys > 0.5-0.2*math.log( #allys )/math.log(6)
		then
			npcBot:Action_UseAbility(ggr);
			return;
		end
	end

	--[[local mgw=IsItemAvailable("item_magic_wand");
	if mgw~=nil and mgw:IsFullyCastable() then
		if npcBot:GetMana()/npcBot:GetMaxMana() - npcBot:GetHealth()/npcBot:GetMaxHealth() <= 1 and mgw:GetCurrentCharges()>=15
		then
			npcBot:Action_UseAbility(mgw);
			return;
		end
	end

	local mgs=IsItemAvailable("item_magic_stick");
	if mgs~=nil and mgs:IsFullyCastable() then
		if npcBot:GetMana()/npcBot:GetMaxMana() - npcBot:GetHealth()/npcBot:GetMaxHealth() <= 1 and mgs:GetCurrentCharges()>=8
		then
			npcBot:Action_UseAbility(mgs);
			return;
		end
	end]]
	
	local stick=IsItemAvailable("item_magic_stick");
	if stick ~=nil and stick:IsFullyCastable() then
		if DotaTime() > 0 
		then
			local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( 500, true, BOT_MODE_NONE );
			if ((npcBot:GetHealth()/npcBot:GetMaxHealth() < 0.4 or npcBot:GetMana()/npcBot:GetMaxMana() < 0.2) and #tableNearbyEnemyHeroes >= 1 )
				or ((npcBot:GetHealth()/npcBot:GetMaxHealth() < 0.7 and npcBot:GetMana()/npcBot:GetMaxMana() < 0.7) and GetItemCharges(npcBot,"item_magic_stick") >= 7 )
			then
				npcBot:Action_UseAbility(stick);
				return;
			end
		end
	end

	local wand=IsItemAvailable("item_magic_wand");
	if wand ~=nil and wand:IsFullyCastable() then
		if DotaTime() > 0 
		then
			local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( 500, true, BOT_MODE_NONE );
			if ((npcBot:GetHealth()/npcBot:GetMaxHealth() < 0.4 or npcBot:GetMana()/npcBot:GetMaxMana() < 0.2) and #tableNearbyEnemyHeroes >= 1 )
				or ((npcBot:GetHealth()/npcBot:GetMaxHealth() < 0.7 and npcBot:GetMana()/npcBot:GetMaxMana() < 0.7) and GetItemCharges(npcBot,"item_magic_wand") >= 12 )
			then
				npcBot:Action_UseAbility(wand);
				return;
			end
		end
	end

	local bottle =IsItemAvailable("item_bottle");
	if bottle ~=nil and bottle:IsFullyCastable()
	then
		local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( 650, true, BOT_MODE_NONE );
		if GetItemCharges(npcBot,"item_bottle") > 0 and not npcBot:HasModifier("modifier_bottle_regeneration") 
		then
			if ((npcBot:GetHealth() / npcBot:GetMaxHealth() < 0.65 and npcBot:GetMana()/npcBot:GetMaxMana() < 0.45) 
					or npcBot:GetHealth() / npcBot:GetMaxHealth() < 0.4 or npcBot:GetMana()/npcBot:GetMaxMana() < 0.2)
					and #tableNearbyEnemyHeroes == 0
			then
				npcBot:Action_UseAbilityOnEntity(bottle, npcBot);
				return;
			end
		end
	end

	local cyclone=IsItemAvailable("item_cyclone");
	if cyclone~=nil and cyclone:IsFullyCastable() then
		if npcTarget ~= nil and ( npcTarget:HasModifier('modifier_teleporting') or npcTarget:HasModifier('modifier_abaddon_borrowed_time') ) 
		   and CanCastOnTarget(npcTarget) and GetUnitToUnitDistance(npcBot, npcTarget) < 775
		then
			npcBot:Action_UseAbilityOnEntity(cyclone, npcTarget);
			return;
		end
	end
	
	local metham=IsItemAvailable("item_meteor_hammer");
	if metham~=nil and metham:IsFullyCastable() then
		local tableNearbyAttackingAlliedHeroes = npcBot:GetNearbyHeroes( 1000, false, BOT_MODE_ATTACK );
		if ( npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
			 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
			 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT) then
			local towers = npcBot:GetNearbyTowers(800, true);
			if #towers > 0 and towers[1] ~= nil and  towers[1]:IsInvulnerable() == false then 
				npcBot:Action_UseAbilityOnLocation(metham, towers[1]:GetLocation());
				return;
			end
		elseif ( #tableNearbyAttackingAlliedHeroes >= 2 ) then
			local locationAoE = npcBot:FindAoELocation( true, true, npcBot:GetLocation(), 600, 300, 0, 0 );
			if ( locationAoE.count >= 2 ) 
			then
				npcBot:Action_UseAbilityOnLocation(metham, locationAoE.targetloc);
				return;
			end
		elseif ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
				 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
				 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
				 npcBot:GetActiveMode() == BOT_MODE_ATTACK ) then	
			if npcTarget ~= nil and npcTarget:IsHero() and CanCastOnTarget(npcTarget) and GetUnitToUnitDistance(npcBot, npcTarget) < 800
			   and IsDisabled(true, npcTarget) == true	
			then
				npcBot:Action_UseAbilityOnLocation(metham, npcTarget:GetLocation());
				return;
			end
		end
	end
	
	local sv=IsItemAvailable("item_spirit_vessel");
	if sv~=nil and sv:IsFullyCastable() and sv:GetCurrentCharges() > 0
	then
		if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
			 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
			 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
			 npcBot:GetActiveMode() == BOT_MODE_ATTACK ) 
		then	
			if npcTarget ~= nil and npcTarget:IsHero() and CanCastOnTarget(npcTarget) and GetUnitToUnitDistance(npcBot, npcTarget) < 900
			   and npcTarget:HasModifier("modifier_item_spirit_vessel_damage") == false and npcTarget:GetHealth()/npcTarget:GetMaxHealth() < 0.65
			then
			    npcBot:Action_UseAbilityOnEntity(sv, npcTarget);
				return;
			end
		else
			local Allies=npcBot:GetNearbyHeroes(1150,false,BOT_MODE_NONE);
			for _,Ally in pairs(Allies) do
				if Ally:HasModifier('modifier_item_spirit_vessel_heal') == false and CanCastOnTarget(Ally) and
				   Ally:GetHealth()/Ally:GetMaxHealth() < 0.35 and #tableNearbyEnemyHeroes == 0 and Ally:WasRecentlyDamagedByAnyHero(2.5) == false   
				then
					npcBot:Action_UseAbilityOnEntity(sv,Ally);
					return;
				end
			end
		end
	end
	
	local null=IsItemAvailable("item_nullifier");
	if null~=nil and null:IsFullyCastable() 
	then
		if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
			 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
			 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
			 npcBot:GetActiveMode() == BOT_MODE_ATTACK ) 
		then	
			if npcTarget ~= nil and npcTarget:IsHero() and CanCastOnTarget(npcTarget) and GetUnitToUnitDistance(npcBot, npcTarget) < 800
			   and npcTarget:HasModifier("modifier_item_nullifier_mute") == false 
			then
			    npcBot:Action_UseAbilityOnEntity(null, npcTarget);
				return;
			end
		end
	end

	

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
	return npcTarget:CanBeSeen() and not npcTarget:IsMagicImmune() and not npcTarget:IsInvulnerable() and not npcTarget:IsIllusion()
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
