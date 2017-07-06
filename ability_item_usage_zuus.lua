----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
require(GetScriptDirectory() ..  "/utility")
require(GetScriptDirectory() ..  "/ability_item_usage_generic")
--------------------------------------
-- Hero Area Local Variable Setting
--------------------------------------
local npcBot = GetBot()
local ComboMana = 0
local debugmode=utility.debug_mode

local Talents ={}
local Abilities ={}

for i=0,23,1 do
	local ability=npcBot:GetAbilityInSlot(i)
	if(ability~=nil)
	then
		if(ability:IsTalent()==true)
		then
			table.insert(Talents,ability:GetName())
		end
	end
end

local Abilities =
{
	"zuus_arc_lightning",
	"zuus_lightning_bolt",
	"zuus_static_field",
	"zuus_thundergods_wrath",
	"zuus_cloud"
}

local AbilitiesReal =
{
	npcBot:GetAbilityByName(Abilities[1]),
	npcBot:GetAbilityByName(Abilities[2]),
	npcBot:GetAbilityByName(Abilities[3]),
	npcBot:GetAbilityByName(Abilities[4]),
	npcBot:GetAbilityByName(Abilities[5])
}

local AbilityToLevelUp=
{
	Abilities[1],
	Abilities[3],
	Abilities[2],
	Abilities[2],
	Abilities[2],
	Abilities[4],
	Abilities[2],
	Abilities[1],
	Abilities[1],
	"talent",
	Abilities[1],
	Abilities[4],
	Abilities[3],
	Abilities[3],
	"talent",
	Abilities[3],
	"nil",
	Abilities[4],
	"nil",
	"talent",
	"nil",
	"nil",
	"nil",
	"nil",
	"talent",
}
local TalentTree={
	function()
		return Talents[1]
	end,
	function()
		return Talents[3]
	end,
	function()
		return Talents[5]
	end,
	function()
		return Talents[7]
	end
}
--------------------------------------
-- Level Ability and Talent
--------------------------------------

utility.CheckAbilityBuild(AbilityToLevelUp)

function AbilityLevelUpThink()
	ability_item_usage_generic.AbilityLevelUpThink2(AbilityToLevelUp,TalentTree)
end


local cast1Desire = 0;
local cast2Desire = 0;
local cast4Desire = 0;
local cast5Desire = 0;
----------------------------------------------------------------------------------------------------
local CanCast1=utility.NCanCast
local CanCast2=utility.NCanCast
local CanCast3=utility.NCanCast
local CanCast4=utility.UCanCast
local CanCast5=utility.UCanCast

----------------------------------------------------------------------------------------------------
local function GetComboDamage()

	local sum=0
	
	if AbilitiesReal[1]:IsFullyCastable()
	then
		sum=sum+AbilitiesReal[1]:GetAbilityDamage();
	end
	if AbilitiesReal[2]:IsFullyCastable()
	then
		sum=sum+AbilitiesReal[2]:GetAbilityDamage();
	end
	if AbilitiesReal[4]:IsFullyCastable()
	then
		sum=sum+125+100*AbilitiesReal[4]:GetLevel();
	end
	
	return sum
end

local function GetComboMana()
	
	local tempComboMana=0
	if AbilitiesReal[1]:IsFullyCastable()
	then
		tempComboMana=tempComboMana+AbilitiesReal[1]:GetManaCost()
	end
	if AbilitiesReal[2]:IsFullyCastable()
	then
		tempComboMana=tempComboMana+AbilitiesReal[2]:GetManaCost()
	end
	if AbilitiesReal[4]:IsFullyCastable() or AbilitiesReal[4]:GetCooldownTimeRemaining()<=30
	then
		tempComboMana=tempComboMana+AbilitiesReal[4]:GetManaCost()
	end
	
	if AbilitiesReal[1]:GetLevel()<1 or AbilitiesReal[2]:GetLevel()<1 or AbilitiesReal[4]:GetLevel()<1
	then
		tempComboMana=300;
	end
	
	ComboMana=tempComboMana
	return
end

function AbilityUsageThink()

	-- Check if we're already using an ability
	if ( npcBot:IsUsingAbility() or npcBot:IsChanneling() or npcBot:IsSilenced() )
	then 
		return
	end
	
	GetComboMana()
	AttackRange=npcBot:GetAttackRange()
	ManaPercentage=npcBot:GetMana()/npcBot:GetMaxMana()
	
	-- Consider using each ability
	cast1Desire, cast1Target = Consider1();
	cast2Desire, cast2Target,cast2TargetType = Consider2();
	cast4Desire = Consider4();
	cast5Desire, cast5Location = Consider5();
	--[[---------------------------------debug--------------------------------------------
	if(npcBot.LastSpeaktime==nil)
	then
		npcBot.LastSpeaktime=0
	end
	if(GameTime()-npcBot.LastSpeaktime>1)
	then
		if ( cast4Desire > 0 ) 
		then
			npcBot:ActionImmediate_Chat("try to use skill 4 Desire= "..cast4Desire,true)
			npcBot.LastSpeaktime=GameTime()
		end
		if ( cast5Desire > 0 ) 
		then
			npcBot:ActionImmediate_Chat("try to use skill 5 Desire= "..cast5Desire,true)
			npcBot.LastSpeaktime=GameTime()
		end
		if ( cast2Desire > 0 ) 
		then
			npcBot:ActionImmediate_Chat("try to use skill 2 at "..cast2Target:GetUnitName().." Desire= "..cast2Desire,true)
			npcBot.LastSpeaktime=GameTime()
		end
		if ( cast1Desire > 0 ) 
		then
			npcBot:ActionImmediate_Chat("try to use skill 1 at "..cast1Target:GetUnitName().." Desire= "..cast1Desire,true)
			npcBot.LastSpeaktime=GameTime()
		end
	end
	---------------------------------debug--------------------------------------------]]--
	if ( cast4Desire > 0 ) 
	then
		npcBot:Action_UseAbility( AbilitiesReal[4] );
		return
	end
	
	if ( cast5Desire > 0 ) 
	then
		npcBot:Action_UseAbilityOnLocation( AbilitiesReal[5], cast5Location );
		return
	end
	
	if ( cast2Desire > 0 ) 
	then
		if(cast2TargetType=="target")
		then
			npcBot:Action_UseAbilityOnEntity( AbilitiesReal[2], cast2Target );
			return
		elseif(cast2TargetType=="location")
		then
			npcBot:Action_UseAbilityOnLocation( AbilitiesReal[2], cast2Target );
			return
		end
	end
	
	if ( cast1Desire > 0 ) 
	then
		npcBot:Action_UseAbilityOnEntity(AbilitiesReal[1], cast1Target );
		return
	end

end

function Consider1()

	local ability=AbilitiesReal[1];
	
	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	local CastRange = ability:GetCastRange();
	local Damage = ability:GetAbilityDamage();
	
	local HeroHealth=10000
	local CreepHealth=10000
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyLaneCreeps(CastRange+300,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
	
	--try to kill enemy hero
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT ) 
	then
		if (WeakestEnemy~=nil)
		then
			if ( CanCast1( WeakestEnemy ) )
			then
				if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL)*3 or (HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana))
				then
					return BOT_ACTION_DESIRE_HIGH,WeakestEnemy; 
				end
			end
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	
	--teamfightUsing
	if(npcBot:GetActiveMode() == BOT_MODE_ATTACK ) 
	then
		if(ManaPercentage>0.4 or npcBot:GetMana()>ComboMana)
		then
			if (#enemys+#creeps>2)
			then
				if(WeakestCreep~=nil)
				then
					return BOT_ACTION_DESIRE_HIGH,WeakestCreep; 
				end
				if(WeakestEnemy~=nil)
				then
					if ( CanCast1( WeakestEnemy ) )
					then
						return BOT_ACTION_DESIRE_HIGH,WeakestEnemy; 
					end
				end
			end
		end
	end
	
	--Last hit
	if ( npcBot:GetActiveMode() == BOT_MODE_LANING ) 
	then
		if(WeakestCreep~=nil)
		then
			if((ManaPercentage>0.4 or npcBot:GetMana()>ComboMana) and GetUnitToUnitDistance(npcBot,WeakestCreep)>=AttackRange-ManaPercentage)
			then
				if(CreepHealth<=WeakestCreep:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL))
				then					
					return BOT_ACTION_DESIRE_LOW,WeakestCreep; 
				end
			end		
		end
	end
	
	-- If we're farming and can hit 2+ creeps and kill 1+ 
	if ( npcBot:GetActiveMode() == BOT_MODE_FARM )
	then
		if ( #creeps >= 2 ) 
		then
			if(CreepHealth<=WeakestCreep:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana)
			then
				return BOT_ACTION_DESIRE_LOW, WeakestCreep;
			end
		end
	end

	-- If we're pushing or defending a lane and can hit 3+ creeps, go for it
	if ( npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT ) 
	then
		if ( #enemys+#creeps >= 3 and ManaPercentage>0.4 or npcBot:GetMana()>ComboMana) 
		then
			if (WeakestEnemy~=nil)
			then
				if ( CanCast1( WeakestEnemy )and GetUnitToUnitDistance(npcBot,WeakestEnemy)< CastRange + 75*#allys )
				then
					return BOT_ACTION_DESIRE_LOW, WeakestEnemy;
				end
			end
			if (WeakestCreep~=nil)
			then
				if ( CanCast1( WeakestCreep )and GetUnitToUnitDistance(npcBot,WeakestCreep)< CastRange + 75*#allys )
				then
					return BOT_ACTION_DESIRE_LOW, WeakestCreep;
				end
			end
		end
	end

	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		 npcBot:GetActiveMode() == BOT_MODE_ATTACK ) 
	then
		local npcTarget = npcBot:GetTarget();
		
		if(ManaPercentage>0.4 or npcBot:GetMana()>ComboMana)
		then
			if ( npcTarget ~= nil ) 
			then
				if ( CanCast1( npcTarget )  and GetUnitToUnitDistance(npcBot,npcTarget)< CastRange + 75*#allys)
				then
					return BOT_ACTION_DESIRE_MODERATE, npcTarget;
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;
	
end

function Consider2()

	local ability=AbilitiesReal[2];
	
	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0 ,"nil";
	end
	
	local CastRange = ability:GetCastRange();
	local Damage = ability:GetAbilityDamage();
	
	local HeroHealth=10000
	local CreepHealth=10000
	local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
	local enemys = npcBot:GetNearbyHeroes(CastRange+300,true,BOT_MODE_NONE)
	local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange+300,true)
	local WeakestCreep,CreepHealth=utility.GetWeakestUnit(creeps)
	
	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------
	-- Check for a channeling enemy
	for _,enemy in pairs( enemys )
	do
		if ( enemy:IsChanneling() and CanCast2( enemy )) 
		then
			return BOT_ACTION_DESIRE_HIGH, enemy,"target";
		end
	end
	
	-- Kill enemy
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT )
	then
		if (WeakestEnemy~=nil)
		then
			if(HeroHealth<=WeakestEnemy:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL) or (HeroHealth<=WeakestEnemy:GetActualIncomingDamage(GetComboDamage(),DAMAGE_TYPE_MAGICAL) and npcBot:GetMana()>ComboMana))
			then
				if ( CanCast2( WeakestEnemy ) )
				then
					return BOT_ACTION_DESIRE_HIGH,WeakestEnemy,"target";
				end
			end
		end
	end
	
	--protect myself
	local enemys2 = npcBot:GetNearbyHeroes( 500, true, BOT_MODE_NONE );
	if(npcBot:WasRecentlyDamagedByAnyHero(5))
	then
		for _,enemy in pairs( enemys2 )
		do
			if ( CanCast2( enemy ) )
			then
				return BOT_ACTION_DESIRE_HIGH, enemy,"target"
			end
		end
	end
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	--ÏûºÄ
	--if ( npcBot:GetActiveMode() == BOT_MODE_LANING ) 
	--then
		if((ManaPercentage>0.4 or npcBot:GetMana()>ComboMana) and ability:GetLevel()>=2 )
		then
			if (WeakestEnemy~=nil)
			then
				if ( CanCast2( WeakestEnemy ) )
				then
					return BOT_ACTION_DESIRE_LOW,WeakestEnemy,"target";
				end
			end
		end
	--end

	-- If we're pushing or defending a lane and can hit 4+ creeps, go for it
	if ( npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT ) 
	then
		if (WeakestEnemy~=nil)
		then
			if ( CanCast2( WeakestEnemy )and GetUnitToUnitDistance(npcBot,WeakestEnemy)< CastRange + 75*#allys )
			then
				return BOT_ACTION_DESIRE_LOW,WeakestEnemy,"target";
			end
		end
	end

	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		 npcBot:GetActiveMode() == BOT_MODE_ATTACK ) 
	then
		local npcTarget = npcBot:GetTarget();

		if ( npcTarget ~= nil ) 
		then
			if ( CanCast2( npcTarget ) and GetUnitToUnitDistance(npcBot,npcTarget)< CastRange + 75*#allys)
			then
				return BOT_ACTION_DESIRE_MODERATE, npcTarget,"target";
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0 ,"nil";
end

function Consider4()
	
	local ability=AbilitiesReal[4]
	if not ability:IsFullyCastable() 
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local Damage = 125+100*ability:GetLevel()
	local WeakestEnemy=nil
	local LowestHP=10000.0
	
	for _,Enemy in pairs (GetUnitList(UNIT_LIST_ENEMY_HEROES)) 
	do
		if Enemy~=nil
		then
			if(GetUnitToUnitDistance(npcBot,Enemy)>AbilitiesReal[2]:GetCastRange() or not AbilitiesReal[2]:IsFullyCastable())
			then
				if Enemy:IsAlive() and Enemy:CanBeSeen() and CanCast4(Enemy)
				then
					if (LowestHP>Enemy:GetHealth())
					then
						WeakestEnemy=Enemy;
						LowestHP=Enemy:GetHealth();
					end
				end
			end
		end
	end
	
	if (WeakestEnemy==nil or LowestHP<1)
	then
		return BOT_ACTION_DESIRE_NONE
	end

	if LowestHP<=WeakestEnemy:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL)
	then
		--return BOT_ACTION_DESIRE_VERYHIGH
		local time_byname=WeakestEnemy:GetUnitName()
		local allys=WeakestEnemy:GetNearbyHeroes( 600, false, BOT_MODE_ATTACK );
		if(#allys==0 or allys[1]==npcBot)
		then
			return BOT_ACTION_DESIRE_VERYHIGH
		else
			if(npcBot.ult==nil)
			then
				npcBot.ult={}
			end
			if(npcBot.ult.time_byname==nil)
			then
				npcBot.ult.time_byname={DotaTime(),WeakestEnemy,WeakestEnemy:GetPlayerID()}
			end	
		end
	end
	
	if(npcBot.ult~=nil)
	then
		for _,i in pairs(npcBot.ult)
		do
			if(DotaTime()-i[1]>=3)
			then
				if(i[2]==nil or i[2]:IsNull() or i[2]:GetHealth()<=i[2]:GetActualIncomingDamage(Damage,DAMAGE_TYPE_MAGICAL) and IsHeroAlive(i[3]))
				then
					npcBot.ult=nil
					return BOT_ACTION_DESIRE_VERYHIGH
				end
			end
		end	
	end

	
	return BOT_ACTION_DESIRE_NONE
end

function Consider5()
	
	local ability=AbilitiesReal[5]
	if not ability:IsFullyCastable() 
	then
		return BOT_ACTION_DESIRE_NONE
	end
	
	local CastRange = ability:GetCastRange();
	
	local CreepHealth=10000;
	local enemys = npcBot:GetNearbyHeroes( CastRange + 300, true, BOT_MODE_NONE );
	local WeakestEnemy,CreepHealth=utility.GetWeakestUnit(enemys)
	
	local tower=nil
	
	if ( npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT )
	then
		local tower=npcBot:GetNearbyTowers(1500,false)
	end
	
	if (npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
		npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
		npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT ) 
	then
		local tower=npcBot:GetNearbyTowers(1000,true)
	end
	
	if(tower~=nil and GetUnitToUnitDistance(npcBot,tower[1])<CastRange+500)
	then
		return BOT_ACTION_DESIRE_LOW,tower[1]:GetLocation()
	end
	
	if (WeakestEnemy~=nil)
	then
		return BOT_ACTION_DESIRE_LOW,WeakestEnemy:GetLocation()
	end
	
	return BOT_ACTION_DESIRE_NONE,0
end
--[[
function CourierUsageThink()
	npcBot=GetBot();
	if (npcBot:IsAlive() and (npcBot:GetStashValue()>900 or npcBot:GetCourierValue()>0) and IsCourierAvailable()) and (npcBot.CourierTimer==nil or DotaTime()-npcBot.CourierTimer>2) then
		npcBot:Action_CourierDeliver();
		npcBot.CourierTimer=DotaTime();
	end
end]]--

function CourierUsageThink() 
	ability_item_usage_generic.CourierUsageThink()
end