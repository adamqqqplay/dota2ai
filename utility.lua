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
	return utilityModule.UCanCast( npcEnemy )
end

function utilityModule.UCanCast( npcEnemy )--magic immune
	return npcEnemy:CanBeSeen() and not npcEnemy:IsInvulnerable() and not utilityModule.HasImmuneDebuff(npcEnemy) and not npcEnemy:IsIllusion() and not npcEnemy:HasModifier("modifier_item_sphere") and not npcEnemy:HasModifier("modifier_item_sphere_target")
end

function utilityModule.CanCastNoTarget()
    return true
end
function utilityModule.CanCastPassive()
    return true
end

function utilityModule.IsRoshan(npcTarget)
	return npcTarget ~= nil and npcTarget:IsAlive() and string.find(npcTarget:GetUnitName(), "roshan");
end

-- gxc's code
-- created by date: 2017/03/16
-- nBehavior = hAbility:GetTargetTeam, GetTargetType, GetTargetFlags or GetBehavior function returns
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
function utilityModule.enemyDisabled(npcEnemy)
	if npcEnemy:IsRooted( ) or npcEnemy:IsStunned( ) or npcEnemy:IsHexed( ) then
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
	local vMyLocation,vTargetLocation=unit:GetLocation(),target:GetLocation()
	local tempvector=(vTargetLocation-vMyLocation)/utilityModule.PointToPointDistance(vMyLocation,vTargetLocation)
	return vMyLocation+nUnits*tempvector
end

function utilityModule.RandomInCastRangePoint(unit,target,CastRange,distance)
	local i=0;
	local l,d;
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
	local v=RandomVector(distance)
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

function utilityModule.CheckAbilityBuild(AbilityToLevelUp)
	local npcBot=GetBot()
	if #AbilityToLevelUp > 26-npcBot:GetLevel() then
		for _=1, npcBot:GetLevel() do
			print("remove"..AbilityToLevelUp[1])
			table.remove(AbilityToLevelUp, 1)
		end
	end
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
	local buildings = utilityModule.GetAllBuilding( team )
	local minDist = 16000 ^ 2
	local nearestBuilding = nil
	for _,v in pairs(buildings) do
		local dist = utilityModule.PointToPointDistance(location, v:GetLocation())^2
		if dist < minDist then
			minDist = dist
			nearestBuilding = v
		end
	end
	return nearestBuilding
end

function utilityModule.GetAllBuilding( team )
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

function utilityModule.DebugTalk(message)
	local debug_mode = false
	if(debug_mode==true)
	then
		local npcBot=GetBot()
		npcBot:ActionImmediate_Chat(message,true)
	end
end

function utilityModule.DebugTable(tb)
	local msg = "{ "
	local DebugRec
	DebugRec = function(tb)
		for k,v in pairs(tb) do
			if type(v) == "number" or type(v) == "string" then
				msg = msg..k.." = "..v
				msg = msg..", "
			end
			if type(v) == "table" then
				msg = msg..k.." = ".."{ "
				DebugRec(v)
				msg = msg.."}, "
			end
		end
	end
	DebugRec(tb)
	msg = msg.." }"
	
	local npcBot=GetBot()
	npcBot:ActionImmediate_Chat(msg,true)
end

function utilityModule.ReverseTable(tb) 
	local g = {}
	for k,v in pairs(tb) do
		if type(v) == "number" or type(v) == "string" then
			g[v] = k
		end
	end
	return g
end

function utilityModule.PrintAbilityName(abilities) 
	local msg = "{ "
	for k,v in ipairs(abilities) do 
		msg = msg.."\""..v.."\", "
	end
	msg = string.sub(msg, 0, #msg-2) -- curtail the trailing comma
	msg = msg.." }"
	local npcBot=GetBot()
	npcBot:ActionImmediate_Chat(msg,true)
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
			local c;

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

local RadiantBase = Vector(-7174.000000, -6671.00000,  0.000000)
local DireBase = Vector(7023.000000, 6450.000000, 0.000000)

function utilityModule.GetEscapeLoc()
	local bot = GetBot();
	local team = GetTeam();
	if bot:DistanceFromFountain() > 2500 then
		return GetAncient(team):GetLocation();
	else
		if team == TEAM_DIRE then
			return DireBase;
		else
			return RadiantBase;
		end
	end
end

function utilityModule.IsStuck(npcBot)
	if npcBot.stuckLoc ~= nil and npcBot.stuckTime ~= nil then
		local attackTarget = npcBot:GetAttackTarget();
		local EAd = GetUnitToUnitDistance(npcBot, GetAncient(GetOpposingTeam()));
		local TAd = GetUnitToUnitDistance(npcBot, GetAncient(GetTeam()));
		local Et = npcBot:GetNearbyTowers(450, true);
		local At = npcBot:GetNearbyTowers(450, false);
		if npcBot:GetCurrentActionType() == BOT_ACTION_TYPE_MOVE_TO and attackTarget == nil and EAd > 2200 and TAd > 2200 and #Et == 0 and #At == 0
		   and DotaTime() > npcBot.stuckTime + 5.0 and GetUnitToLocationDistance(npcBot, npcBot.stuckLoc) < 25
		then
			print(npcBot:GetUnitName().." is stuck")
			return true;
		end
	end
	return false
end
--------------------------------------------------------------------------

local itemNameMetatable = {}
function itemNameMetatable.__index(tb, s)
	return "item_"..s 
end
local itemNametable = {}
setmetatable(itemNametable, itemNameMetatable)
utilityModule.items = itemNametable

---------------------------------------------------------------------------------------------------
return utilityModule;