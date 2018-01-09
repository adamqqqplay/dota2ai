----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
local IsChanneling=false

function GetDesire()
	local npcBot = GetBot();
	--local ability = npcBot:GetAbilityByName("keeper_of_the_light_illuminate")
	local enemys = npcBot:GetNearbyHeroes(1600,true,BOT_MODE_NONE)
	if((npcBot:IsUsingAbility() and npcBot:GetActiveMode() ~= BOT_MODE_WARD ) or npcBot:IsChanneling()) and enemys~=nil and #enemys>0
	then
		IsChanneling=true
		return 0.99
	else
		IsChanneling=false
	end
	return SideShopGetDesire()
end

function Think()
	if(IsChanneling==true)
	then
		--print("keeper of the light is avoid interupt channeling")
		--do nothing
	else
		SideShopThink();
	end
end

function SideShopGetDesire()

	local npcBot = GetBot();
	
	local desire = 0.0;
	
	local enemys = npcBot:GetNearbyHeroes(600,true,BOT_MODE_NONE)
	if ( npcBot:IsUsingAbility() or npcBot:IsChanneling() or npcBot:WasRecentlyDamagedByAnyHero(5.0) or #enemys>=1)		--不应打断持续施法
	then
		return 0
	end
	
	if ( npcBot.sideShopMode == true and npcBot:GetGold() >= npcBot:GetNextItemPurchaseValue()) then
		local d=npcBot:DistanceFromSideShop()
		if d<2500
		then
			desire = (2500-d)/2500*0.3+0.3;					--根据离边路商店的距离返回欲望值
		end
	end

	return desire

end

function SideShopThink()
	
	local npcBot = GetBot();
	
	local shopLoc1 = GetShopLocation( GetTeam(), SHOP_SIDE );
	local shopLoc2 = GetShopLocation( GetTeam(), SHOP_SIDE2 );

	if ( GetUnitToLocationDistance(npcBot, shopLoc1) <= GetUnitToLocationDistance(npcBot, shopLoc2) ) then	--选择前往距离自己更近的商店
		npcBot:Action_MoveToLocation( shopLoc1 );
	else
		npcBot:Action_MoveToLocation( shopLoc2 );
	end
end
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------