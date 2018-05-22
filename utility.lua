----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local utilityModule={}
---------------------------------------------------------------------------------------------------
------This is global utility library,include some useful function.------
---------------------------------------------------------------------------------------------------
function utilityModule.HasImmuneDebuff(npcEnemy)
	return npcEnemy:HasModifier("modifier_abaddon_borrowed_time") or 
		npcEnemy:HasModifier("modifier_winter_wyvern_winters_curse") or 
		npcEnemy:HasModifier("modifier_obsidian_destroyer_astral_imprisonment_prison") or
		npcEnemy:HasModifier("modifier_winter_wyvern_winters_curse_aura")
end

function utilityModule.NCanCast( npcEnemy )--normal judgement
	return npcEnemy:CanBeSeen() and not npcEnemy:IsMagicImmune() and not npcEnemy:IsInvulnerable() and not utilityModule.HasImmuneDebuff(npcEnemy) and not npcEnemy:IsIllusion()
end

function utilityModule.MiCanCast( npcEnemy )--magic immune
	return npcEnemy:CanBeSeen() and not npcEnemy:IsInvulnerable() and not utilityModule.HasImmuneDebuff(npcEnemy) and not npcEnemy:IsIllusion() and not npcEnemy:HasModifier("modifier_item_sphere") and not npcEnemy:HasModifier("modifier_item_sphere_target")
end

function utilityModule.UCanCast( npcEnemy )--magic immune
	return npcEnemy:CanBeSeen() and not npcEnemy:IsInvulnerable() and not utilityModule.HasImmuneDebuff(npcEnemy) and not npcEnemy:IsIllusion() and not npcEnemy:HasModifier("modifier_item_sphere") and not npcEnemy:HasModifier("modifier_item_sphere_target")
end

-- gxc's code
-- created by date: 2017/03/16
-- nBehavior = hAbility:GetTargetTeam, GetTargetType, GetTargetFlags or GetBehavior function utilityModule.utilityModule.returns
-- nFlag = Ability Target Teams, Ability Target Types, Ability Target Flags or Ability Behavior Bitfields constant
function utilityModule.CheckFlag( nBehavior, nFlag )

	if ( nFlag == 0 ) then
		if ( nBehavior == 0 ) then
			return true;
		else
			return false;
		end
	end

	return ( (nBehavior / nFlag) % 2 ) >= 1;

end

----------------- local utility functions reordered for lua local visibility--------
--Perry's code from http://dev.dota2.com/showthread.php?t=274837
function utilityModule.PerryGetHeroLevel()--???????? ????????????????????λ????????GetLevel()???
    local npcBot = GetBot();
    local respawnTable = {8, 10, 12, 14, 16, 26, 28, 30, 32, 34, 36, 46, 48, 50, 52, 54, 56, 66, 70, 74, 78,  82, 86, 90, 100};
    local nRespawnTime = npcBot:GetRespawnTime() +1 -- It gives 1 second lower values.
    for k,v in pairs (respawnTable) do
        if v == nRespawnTime then
        return k
        end
    end
end

function utilityModule.enemyDisabled(npcEnemy)
	if npcEnemy:IsRooted( ) or npcEnemy:IsStunned( ) or npcEnemy:IsHexed( ) then
		return true;
	end
	return false;
end

function utilityModule.allyDisabled(npcEnemy)
	if npcAlly:IsRooted( ) or npcEnemy:IsStunned( ) or npcEnemy:IsHexed( ) then
		return true;
	end
	return false;
end

function utilityModule.IsEnemy(hUnit)
	local ourTeam=GetTeam()
	local Team=GetTeamForPlayer(hUnit:GetPlayerID())
	if ourTeam==Team
	then
		return false
	else
		return true
	end
end

function utilityModule.PointToPointDistance(a,b)
	local x1=a.x
	local x2=b.x
	local y1=a.y
	local y2=b.y
	return math.sqrt(math.pow((y2-y1),2)+math.pow((x2-x1),2))
end

function utilityModule.GetDistance(a,b)
	return utilityModule.PointToPointDistance(a,b)
end


function CDOTA_Bot_Script:GetFactor()
	return self:GetHealth()/self:GetMaxHealth()+self:GetMana()/self:GetMaxMana()
end





----------------------------------------------------------------------------------------------------
--vector
--BOT EXPERIMENT's code from http://steamcommunity.com/sharedfiles/filedetails/?id=837040016
----------------------------------------------------------------------------------------------------

function CDOTA_Bot_Script:GetForwardVector()
    local radians = self:GetFacing() * math.pi / 180
    local forward_vector = Vector(math.cos(radians), math.sin(radians))
    return forward_vector
end

function CDOTA_Bot_Script:IsFacingUnit( hTarget, degAccuracy )
    local direction = (hTarget:GetLocation() - self:GetLocation()):Normalized()
    local dot = direction:Dot(self:GetForwardVector())
    local radians = degAccuracy * math.pi / 180
    return dot > math.cos(radians)
end

function CDOTA_Bot_Script:GetXUnitsTowardsLocation( vLocation, nUnits)
    local direction = (vLocation - self:GetLocation()):Normalized()
    return self:GetLocation() + direction * nUnits
end

function CDOTA_Bot_Script:GetXUnitsInFront( nUnits )
    return self:GetLocation() + self:GetForwardVector() * nUnits
end

function CDOTA_Bot_Script:GetXUnitsInBehind( nUnits )
    return self:GetLocation() - self:GetForwardVector() * nUnits
end

function CDOTA_Bot_Script:IsRoshan( )
    return string.find(self:GetUnitName(), "roshan")
end

----------------------------------------------------------------------------------------------------

function utilityModule.GetUnitsTowardsLocation(unit,target, nUnits)
	vMyLocation,vTargetLocation=unit:GetLocation(),target:GetLocation()
	local tempvector=(vTargetLocation-vMyLocation)/PointToPointDistance(vMyLocation,vTargetLocation)
	return vMyLocation+nUnits*tempvector
end

function utilityModule.RandomInCastRangePoint(unit,target,CastRange,distance)
	local i=0
	repeat
		l=utilityModule.GetUnitsTowardsLocation(unit,target,GetUnitToUnitDistance(unit,target)/2)+RandomVector(RandomInt(0,distance))
		d=GetUnitToLocationDistance(unit,l)
		i=i+1
	until( d<=CastRange or i>=10)
	if(i>=10)
	then
		return utilityModule.GetUnitsTowardsLocation(unit,target,distance)
	else
		return l
	end

end

function utilityModule.GetSafeVector(unit,distance)
	v=RandomVector(distance)
	if(unit:GetTeam()==TEAM_RADIANT)
	then
		if(v.x>0)
		then
			v.x=-v.x
		end
		if(v.y>0)
		then
			v.y=-v.y
		end
	else
		if(v.x<0)
		then
			v.x=-v.x
		end
		if(v.y<0)
		then
			v.y=-v.y
		end
	end
	return v
end

function utilityModule.GetEnemiesNearLocation(loc,dist)
	if loc ==nil then
		return {};
	end
	
	local Enemies={}
	
	for _,enemy in pairs(GetUnitList(UNIT_LIST_ENEMY_HEROES)) do
		if(GetUnitToLocationDistance(enemy,loc)<dist)
		then
			table.insert(Enemies,enemy)
		end
	end
	
	return Enemies;
end

function utilityModule.GetAlliesNearLocation(loc,dist)
	if loc ==nil then
		return {};
	end
	
	local Enemies={};
	
	for _,enID in pairs(GetTeamPlayers(GetTeam())) do
		local enemyInfo=GetHeroLastSeenInfo(enID)[1];
		if enemyInfo~=nil and enemyInfo['location']~=nil then
			if IsHeroAlive(enID) and utilityModule.GetDistance(enemyInfo['location'],loc)<=dist and (utilityModule.GetDistance(enemyInfo['location'],Vector(0,0))>10) and enemyInfo['time_since_seen']<10 then
				table.insert(Enemies,enID);
			end
		end
	end
	
	return Enemies;
end
----------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------
--
----------------------------------------------------------------------------------------------------
function utilityModule.Fountain(team)
	if team==TEAM_RADIANT then
		return Vector(-7093,-6542);
	end
	return Vector(7015,6534);
end

function utilityModule.GetOtherTeam()
	if GetTeam()==TEAM_RADIANT then
		return TEAM_DIRE;
	else
		return TEAM_RADIANT;
	end
end

function utilityModule.GetWeakestUnit(EnemyUnits)
	
	if EnemyUnits==nil or #EnemyUnits==0 then
		return nil,10000;
	end
	
	local WeakestUnit=nil;
	local LowestHealth=10000;
	for _,unit in pairs(EnemyUnits) 
	do
		if unit~=nil and unit:IsAlive() 
		then
			if unit:GetHealth()<LowestHealth 
			then
				LowestHealth=unit:GetHealth();
				WeakestUnit=unit;
			end
		end
	end
	
	return WeakestUnit,LowestHealth
end

function utilityModule.GetStrongestUnit(EnemyUnits)
	
	if EnemyUnits==nil or #EnemyUnits==0 then
		return nil,0;
	end
	
	local StrongestUnit=nil;
	local HighestHealth=0;
	for _,unit in pairs(EnemyUnits) 
	do
		if unit~=nil and unit:IsAlive() 
		then
			if unit:GetHealth()>HighestHealth
			then
				HighestHealth=unit:GetHealth();
				StrongestUnit=unit;
			end
		end
	end
	
	return StrongestUnit,HighestHealth
end

function utilityModule.GetNearestBuilding(team, location)
	local buildings = utilityModule.GetAllBuilding( team, location )
	local minDist = 16000 ^ 2
	local nearestBuilding = nil
	for k,v in pairs(buildings) do
		local dist = PointToPointDistance(location, v:GetLocation())^2
		if dist < minDist then
			minDist = dist
			nearestBuilding = v
		end
	end
	return nearestBuilding
end

function utilityModule.GetAllBuilding( team,location )
	local buildings = {}
	for i=0,10 do
		local tower = GetTower(team,i)
		if utilityModule.NotNilOrDead(tower) then
			table.insert(buildings,tower)
		end
	end

	for i=0,5 do
		local barrack = GetBarracks( team, i )
		if utilityModule.NotNilOrDead(barrack) then
			table.insert(buildings,barrack)
		end
	end

	for i=0,4 do
		local shrine = GetShrine(team, i) 
		if utilityModule.NotNilOrDead(shrine) then
			table.insert(buildings,shrine)
		end 
	end

	local ancient = GetAncient( team )
	table.insert(buildings,ancient)
	return buildings
end

function utilityModule.NotNilOrDead(unit)
	if unit==nil or unit:IsNull() then
		return false;
	end
	if unit:IsAlive() then
		return true;
	end
	return false;
end

--------------------------------------------------------------------------	ItemPurchase
function utilityModule.SellExtraItem(ItemsToBuy)
	local npcBot=GetBot()
	local level=npcBot:GetLevel()
	item_travel_boots = utilityModule.NoNeedTpscrollForTravelBoots();
	item_travel_boots_1 = item_travel_boots[1];
	item_travel_boots_2 = item_travel_boots[2];
	
	if(utilityModule.IsItemSlotsFull())
	then
		if(GameTime()>6*60 or level>=6)
		then
			utilityModule.SellSpecifiedItem("item_faerie_fire")
			utilityModule.SellSpecifiedItem("item_tango")
			utilityModule.SellSpecifiedItem("item_clarity")
			utilityModule.SellSpecifiedItem("item_flask")
		end
		if(GameTime()>25*60 or level>=10)
		then
			utilityModule.SellSpecifiedItem("item_stout_shield")
			utilityModule.SellSpecifiedItem("item_orb_of_venom")
			utilityModule.SellSpecifiedItem("item_enchanted_mango")
			--utilityModule.SellSpecifiedItem("item_poor_mans_shield")
		end
		if(GameTime()>35*60 or level>=15)
		then
			utilityModule.SellSpecifiedItem("item_branches")
			utilityModule.SellSpecifiedItem("item_bottle")
			utilityModule.SellSpecifiedItem("item_magic_wand")
			utilityModule.SellSpecifiedItem("item_magic_stick")
			utilityModule.SellSpecifiedItem("item_ancient_janggo")
			utilityModule.SellSpecifiedItem("item_ring_of_basilius")
			utilityModule.SellSpecifiedItem("item_ring_of_aquila")
			utilityModule.SellSpecifiedItem("item_quelling_blade")
			utilityModule.SellSpecifiedItem("item_soul_ring")

		end
		if(GameTime()>40*60 or level>=20)
		then
			utilityModule.SellSpecifiedItem("item_vladmir")
			utilityModule.SellSpecifiedItem("item_urn_of_shadows")
			utilityModule.SellSpecifiedItem("item_drums_of_endurance")
			utilityModule.SellSpecifiedItem("item_hand_of_midas")
			utilityModule.SellSpecifiedItem("item_dust")
		end
		if(GameTime()>40*60 and npcBot:GetGold()>2200 and (item_travel_boots[1]==nil and item_travel_boots[2]==nil) and npcBot.HaveTravelBoots~=true )
		then
			table.insert(ItemsToBuy,"item_boots")
			table.insert(ItemsToBuy,"item_recipe_travel_boots")
			npcBot.HaveTravelBoots=true
		end
	end	
	
	if(item_travel_boots[1]~=nil or item_travel_boots[2]~=nil)
	then
		SellSpecifiedItem("item_arcane_boots")
		SellSpecifiedItem("item_phase_boots")
		SellSpecifiedItem("item_power_treads_agi")
		SellSpecifiedItem("item_power_treads_int")
		SellSpecifiedItem("item_power_treads_str")
		SellSpecifiedItem("item_tranquil_boots")
		SellSpecifiedItem("item_tpscroll")
	end
	
end

function utilityModule.ItemPurchase(ItemsToBuy)

	local npcBot = GetBot();
	
	if(utilityModule.GetItemIncludeBackpack("item_courier") or DotaTime()<-80)
	then
		return;
	end

	-- buy item_tpscroll
	if(npcBot.secretShopMode~=true or npcBot:GetGold() >= 100)
	then
		utilityModule.WeNeedTpscroll();
	end

	if ( #ItemsToBuy == 0 )
	then
		npcBot:SetNextItemPurchaseValue( 0 );
		return;
	end

	local sNextItem = ItemsToBuy[1];
	npcBot:SetNextItemPurchaseValue( GetItemCost( sNextItem ) )
	
	utilityModule.SellExtraItem(ItemsToBuy)

	if(npcBot:DistanceFromFountain()<=2500 or npcBot:GetHealth()/npcBot:GetMaxHealth()<=0.35)
	then
		npcBot.secretShopMode = false;
		npcBot.sideShopMode = false;
	end
	
	if (IsItemPurchasedFromSideShop( sNextItem )==false and IsItemPurchasedFromSecretShop( sNextItem )==false)
	then
		npcBot.secretShopMode = false;
		npcBot.sideShopMode = false;
	end
	
	if ( npcBot:GetGold() >= GetItemCost( sNextItem ) )
	then
		if(npcBot.secretShopMode~=true and npcBot.sideShopMode ~=true)
		then
			if (IsItemPurchasedFromSideShop( sNextItem ) and npcBot:DistanceFromSideShop() <= 1800)  --????????·?????????????·???
			then
				npcBot.sideShopMode = true;
				npcBot.secretShopMode = false;
			end
			if (IsItemPurchasedFromSecretShop( sNextItem ) and sNextItem ~= "item_bottle") 
			then
				npcBot.secretShopMode = true;
				npcBot.sideShopMode = false;
			end
		end
		
		local PurchaseResult=-2		--???????????????????
		if(npcBot.sideShopMode == true)
		then
			if(npcBot:DistanceFromSideShop() <= 250)
			then
				PurchaseResult=npcBot:ActionImmediate_PurchaseItem( sNextItem )
			end
		elseif(npcBot.secretShopMode == true)		--???????????????????????????????
		then
			if(npcBot:DistanceFromSecretShop() <= 250)
			then
				PurchaseResult=npcBot:ActionImmediate_PurchaseItem( sNextItem )
			end
			
			local courier=GetCourier(0)
			
			--[[if(courier==nil)
			then
				local ItemCount=utilityModule.GetItemSlotsCount2(npcBot)
				if(ItemCount<6)
				then
					utilityModule.BuyCourier()		--???????????????????????????
				end
			else]]
			local ItemCount=utilityModule.GetItemSlotsCount2(courier)
			if(courier:DistanceFromSecretShop() <= 250 and ItemCount<9)		--???????????
			then
				PurchaseResult=GetCourier(0):ActionImmediate_PurchaseItem( sNextItem )
			end
		else
			PurchaseResult=npcBot:ActionImmediate_PurchaseItem( sNextItem )
		end
		
		if(PurchaseResult==PURCHASE_ITEM_SUCCESS)		--???????????????????????
		then
			npcBot.secretShopMode = false;
			npcBot.sideShopMode = false;
			table.remove( ItemsToBuy, 1 )
		end
		if(PurchaseResult==PURCHASE_ITEM_OUT_OF_STOCK)	--??????????????????????
		then
			SellSpecifiedItem("item_dust")
			SellSpecifiedItem("item_faerie_fire")
			SellSpecifiedItem("item_tango")
			SellSpecifiedItem("item_clarity")
			SellSpecifiedItem("item_flask")
		end
		if(PurchaseResult==PURCHASE_ITEM_INVALID_ITEM_NAME or PurchaseResult==PURCHASE_ITEM_DISALLOWED_ITEM)	--????????????????????
		then
			table.remove( ItemsToBuy, 1 )
		end
		if(PurchaseResult==PURCHASE_ITEM_INSUFFICIENT_GOLD )	--???????????????????????????????????????ж???????
		then
			npcBot.secretShopMode = false;
			npcBot.sideShopMode = false;
		end
		if(PurchaseResult==PURCHASE_ITEM_NOT_AT_SECRET_SHOP)	--?????????????????????
		then
			npcBot.secretShopMode = true
			npcBot.sideShopMode = false;
		end
		if(PurchaseResult==PURCHASE_ITEM_NOT_AT_SIDE_SHOP)		--?????·?????????????????????????·????????????????????
		then
			npcBot.sideShopMode = true
			npcBot.secretShopMode = false;
		end
		if(PurchaseResult==PURCHASE_ITEM_NOT_AT_HOME_SHOP)		--??????????????????????????????????????У????????????????????
		then
			npcBot.secretShopMode = false;
			npcBot.sideShopMode = false;
		end
		if(PurchaseResult>=-1)
		then
			--print(npcBot:GetPlayerID().."[ItemPurchase] purchaseResult is"..PurchaseResult)
		end
	else
		npcBot.secretShopMode = false;
		npcBot.sideShopMode = false;
	end

end

function utilityModule.BuyCourier()
	local npcBot=GetBot()
	local courier=GetCourier(0)
	if(courier==nil)
	then
		if(npcBot:GetGold()>=GetItemCost("item_courier"))
		then
			local info=npcBot:ActionImmediate_PurchaseItem("item_courier");
			if info ==PURCHASE_ITEM_SUCCESS then
				npcBot:ActionImmediate_Chat('I bought the courier 我买了鸡。',false);
			end
		end
	end
	--[[else
		if DotaTime()>60*3 and npcBot:GetGold()>=GetItemCost("item_flying_courier") and (courier:GetMaxHealth()==75) then
			local info=npcBot:ActionImmediate_PurchaseItem("item_flying_courier");
			if info ==PURCHASE_ITEM_SUCCESS then
				print(npcBot:GetUnitName()..' has upgraded the courier.',info);
			end
		end
	end]]
	
end

function utilityModule.NoNeedTpscrollForTravelBoots()

	local npcBot = GetBot();

	local item_travel_boots = {};

	local item_travel_boots_1 = nil;
	local item_travel_boots_2 = nil;
	for i = 0, 14 do
		local sCurItem = npcBot:GetItemInSlot(i);
		if ( sCurItem ~= nil and sCurItem:GetName() == "item_travel_boots_1" ) then
			item_travel_boots_1 = sCurItem;
		end

		if ( sCurItem ~= nil and sCurItem:GetName() == "item_travel_boots_2" ) then
			item_travel_boots_2 = sCurItem;
		end
	end

	if ( item_travel_boots_1 ~= nil or item_travel_boots_2 ~= nil) then
		for i = 0, 14 do
			local sCurItem = npcBot:GetItemInSlot(i);
			if ( sCurItem ~= nil and sCurItem:GetName() == "item_tpscroll" ) then
				npcBot:ActionImmediate_SellItem( "item_tpscroll" );
			end
		end
	end

	item_travel_boots[1] = item_travel_boots_1;
	item_travel_boots[2] = item_travel_boots_2;
	return item_travel_boots;

end

function utilityModule.WeNeedTpscroll()

	local npcBot = GetBot();
	

	
	-- Count current number of TP scrolls
	local iScrollCount = 0;
	for i = 0, 14 do
		local sCurItem = npcBot:GetItemInSlot(i);
		if ( sCurItem ~= nil and sCurItem:GetName() == "item_tpscroll" ) then
			iScrollCount = iScrollCount+sCurItem:GetCurrentCharges()
		end
	end

	-- If we are at the sideshop or fountain with no TPs, then buy one or two
	if ( iScrollCount <1 and item_travel_boots_1 == nil and item_travel_boots_2 == nil ) then
	
		if ( npcBot:DistanceFromSideShop() <= 200 or npcBot:DistanceFromFountain() <= 200 ) then

			if ( DotaTime() > 0 and DotaTime() < 20 * 60 ) then
				npcBot:ActionImmediate_PurchaseItem( "item_tpscroll" );
			elseif ( DotaTime() >= 20 * 60 ) then
				npcBot:ActionImmediate_PurchaseItem( "item_tpscroll" );
				npcBot:ActionImmediate_PurchaseItem( "item_tpscroll" );
			end
		--[[else
			if(npcBot.WeNeedTpscrollTimer==nil)
			then
				npcBot.WeNeedTpscrollTimer=DotaTime()
			end
			if(DotaTime()-npcBot.WeNeedTpscrollTimer>120)
			then
				npcBot:ActionImmediate_PurchaseItem( "item_tpscroll" );
				npcBot.WeNeedTpscrollTimer=DotaTime()
			end]]
		end
	end

end

function utilityModule.SellSpecifiedItem( item_name )

	local npcBot = GetBot();

	local itemCount = 0;
	local item = nil;

	for i = 0, 14 
	do
		local sCurItem = npcBot:GetItemInSlot(i);
		if ( sCurItem ~= nil ) 
		then
			itemCount = itemCount + 1;
			if ( sCurItem:GetName() == item_name ) 
			then
				item = sCurItem;
			end
		end
	end

	if ( item ~= nil and itemCount > 5 and (npcBot:DistanceFromFountain() <= 600 or npcBot:DistanceFromSideShop() <= 200 or npcBot:DistanceFromSecretShop() <= 200) ) then
		npcBot:ActionImmediate_SellItem( item );
	end

end

function utilityModule.GetItemSlotsCount2(npcBot)

	local itemCount = 0;
	local item = nil;

	for i = 0, 8
	do
		local sCurItem = npcBot:GetItemInSlot(i);
		if ( sCurItem ~= nil ) 
		then
			itemCount = itemCount + 1;
		end
	end
	
	return itemCount
end

function utilityModule.GetItemSlotsCount()
	local npcBot = GetBot();

	local itemCount = 0;
	local item = nil;

	for i = 0, 8
	do
		local sCurItem = npcBot:GetItemInSlot(i);
		if ( sCurItem ~= nil ) 
		then
			itemCount = itemCount + 1;
		end
	end
	
	return itemCount
end

function utilityModule.IsItemSlotsFull()
	local itemCount = utilityModule.GetItemSlotsCount();
	if(itemCount>=8)
	then
		return true
	else
		return false
	end
end

function utilityModule.checkItemBuild(ItemsToBuy)
	local ItemTableA=
	{
		"item_tango",
		"item_clarity",
		"item_faerie_fire",
		"item_enchanted_mango",
		"item_flask",
	}

	if(DotaTime()>0)
	then
		for _,item in pairs (ItemTableA)
		do
			for _1,item2 in pairs (ItemsToBuy)
			do
				if(item==item2)
				then
					table.remove(ItemsToBuy,_1)
				end
			end
		end
		
		local npcBot=GetBot()
		for _1,item2 in pairs (ItemsToBuy)
		do
			if(npcBot:FindItemSlot(item2)>0)
			then
				table.remove(ItemsToBuy,_1)
			end
		end
	end
end

invisibleHeroes = {
	--"npc_dota_hero_legion_commander",
	"npc_dota_hero_sand_king",
	"npc_dota_hero_treant",
	"npc_dota_hero_bounty_hunter",
	--"npc_dota_hero_broodmother",
	"npc_dota_hero_clinkz",
	--"npc_dota_hero_drow_ranger",
	"npc_dota_hero_mirana",
	"npc_dota_hero_nyx_assassin",
	"npc_dota_hero_riki",
	--"npc_dota_hero_nevermore",
	--"npc_dota_hero_slark",
	--"npc_dota_hero_sniper",
	"npc_dota_hero_templar_assassin",
	--"npc_dota_hero_viper",
	"npc_dota_hero_invoker",
	"npc_dota_hero_weaver",
};

-- function utilityModule.GetItemIncludeBackpack( item_name )

	-- local npcBot = GetBot();
	-- local item = nil;
	-- local i=-1
	-- i = npcBot:FindItemSlot(item_name)
	-- item = npcBot:GetItemInSlot(i)

	-- return item;
-- end

function utilityModule.GetItemIncludeBackpack(item_name)
	local npcBot=GetBot()
    for i = 0, 16 do
        local item = npcBot:GetItemInSlot(i);
		if (item~=nil) then
			if(item:GetName() == item_name) then
				return item;
			end
		end
    end
    return nil;
end

function utilityModule.IsItemAvailable(item_name)
    local npcBot = GetBot();

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

function utilityModule.CheckInvisibleEnemy()
		local enemyTeam=utilityModule.GetOtherTeam()
		if ( enemyTeam ~= nil ) then
			for _, id in pairs( GetTeamPlayers(enemyTeam) ) 
			do
				for _, invisibleHeroName in pairs(invisibleHeroes) 
				do
					if ( GetSelectedHeroName(id) == invisibleHeroName ) 
					then
						return true
					end
				end
			end
		end
		local enemys=GetUnitList(UNIT_LIST_ENEMY_HEROES)
		if ( enemys ~= nil ) then
			for _,npcEnemy in pairs(enemys)
			do
				if(npcEnemy:HasInvisibility(false))
				then
					return true
				end
			end
		end
		
		return false
end

hasInvisibleEnemy = false
BuySupportItem_Timer=DotaTime()
function utilityModule.BuySupportItem()
	local npcBot=GetBot()
	-- decide if there were several invisible enemy heroes.
	
	if(DotaTime()-BuySupportItem_Timer>=10)
	then
		BuySupportItem_Timer=DotaTime()
		hasInvisibleEnemy=utilityModule.CheckInvisibleEnemy()
	end
	
	if(utilityModule.GetItemSlotsCount()<7)
	then
		local item_ward_observer = utilityModule.GetItemIncludeBackpack( "item_ward_observer" );
		--local item_ward_sentry2 = utilityModule.GetItemIncludeBackpack( "item_ward_dispenser" )
		--local item_gem = utilityModule.GetItemIncludeBackpack( "item_gem" )
		--local item_smoke =  utilityModule.GetItemIncludeBackpack( "item_smoke_of_deceit")
		if ( DotaTime() >= 0 and hasInvisibleEnemy == true ) 
		then
			local item_dust = utilityModule.GetItemIncludeBackpack( "item_dust" );
			--local item_ward_sentry = utilityModule.GetItemIncludeBackpack( "item_ward_sentry" )
			if(item_gem==nil and utilityModule.HaveGem()==false)
			then
				if (item_dust==nil and item_ward_sentry==nil and item_ward_sentry2==nil and npcBot:GetGold() >= 2*GetItemCost("item_dust") and GetItemStockCount("item_gem") >= 1) then
					npcBot:ActionImmediate_PurchaseItem( "item_dust" );
				end
				
				--[[if(DotaTime()>=28*60 and npcBot:GetGold() >= GetItemCost("item_gem") and GetItemStockCount("item_gem") >= 1)
				then
					npcBot:ActionImmediate_PurchaseItem( "item_gem" );
				end]]
				
				-- if ( item_ward_observer==nil and item_dust==nil and item_ward_sentry==nil and item_ward_sentry2==nil and utilityModule.IsItemSlotsFull()==false and npcBot:GetGold() >= 2*GetItemCost("item_ward_sentry") ) then
					-- npcBot:ActionImmediate_PurchaseItem( "item_ward_sentry" );
				-- end
			end
		end
		
		--[[if(DotaTime()>=40*60 and npcBot:GetGold() >= GetItemCost("item_gem") and GetItemStockCount("item_gem") >= 1 and item_gem==nil and utilityModule.HaveGem()==false)
		then
			npcBot:ActionImmediate_PurchaseItem( "item_gem" );
		end]]
				--item_ward_observer==nil and
		if ( item_ward_observer==nil and item_ward_sentry2==nil and (GetItemStockCount("item_ward_observer") > 1 or DotaTime()<0) and npcBot:GetGold() >= GetItemCost("item_ward_observer")) 
		then
			npcBot:ActionImmediate_PurchaseItem( "item_ward_observer" );
		end
		
		--[[if(item_smoke==nil and GetItemStockCount("item_smoke_of_deceit") > 2 and npcBot:GetGold() >= GetItemCost("item_smoke_of_deceit"))
		then
			npcBot:ActionImmediate_PurchaseItem("item_smoke_of_deceit");
		end]]
	end
	
end

function utilityModule.HaveGem()
	for k,hero in pairs(GetUnitList( UNIT_LIST_ALLIED_HEROES ) )
	do
		local gem=hero:FindItemSlot( "item_gem" )
		if(gem>0)
		then
			return true
		end
	end
	return false
end

function utilityModule.CheckAbilityBuild(AbilityToLevelUp)
	local npcBot=GetBot()
	if #AbilityToLevelUp > 26-npcBot:GetLevel() then
		for i=1, npcBot:GetLevel() do
			print("remove"..AbilityToLevelUp[1])
			table.remove(AbilityToLevelUp, 1)
		end
	end
end

function utilityModule.DebugTalk(message)
	local debug_mode = false
	if(debug_mode==true)
	then
		local npcBot=GetBot()
		npcBot:ActionImmediate_Chat(message,true)
	end
end

function utilityModule.DebugTalk_Delay(message)

	local npcBot=GetBot()
	if(npcBot.LastSpeaktime==nil)
	then
		npcBot.LastSpeaktime=0
	end
	if(GameTime()-npcBot.LastSpeaktime>1)
	then
		npcBot:ActionImmediate_Chat(message,true)
		npcBot.LastSpeaktime=GameTime()
	end
end

function utilityModule.AreTreesBetween(loc,r)
	local npcBot=GetBot();
	
	local trees=npcBot:GetNearbyTrees(GetUnitToLocationDistance(npcBot,loc));
	--check if there are trees between us
	for _,tree in pairs(trees) do
		local x=GetTreeLocation(tree);
		local y=npcBot:GetLocation();
		local z=loc;
		
		if x~=y then
			local a=1;
			local b=1;
			local c=0;
		
			if x.x-y.x ==0 then
				b=0;
				c=-x.x;
			else
				a=-(x.y-y.y)/(x.x-y.x);
				c=-(x.y + x.x*a);
			end
		
			local d = math.abs((a*z.x+b*z.y+c)/math.sqrt(a*a+b*b));
			if d<=r and GetUnitToLocationDistance(npcBot,loc)>utilityModule.GetDistance(x,loc)+50 then
				return true;
			end
		end
	end
	return false;
end

function utilityModule.VectorTowards(s,t,d)
	local f=t-s;
	f=f / utilityModule.GetDistance(f,Vector(0,0));
	return s+(f*d);
end
--------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
return utilityModule;