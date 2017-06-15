----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
require(GetScriptDirectory() ..  "/utility")
function GetDesire()
	
	local npcBot = GetBot();

	local desire = 0.0;

	if ( npcBot.sideShopMode == true and npcBot:GetGold() >= npcBot:GetNextItemPurchaseValue()) then
		--utility.DebugTalk(npcBot:GetUnitName().." sideShop true")
		d=npcBot:DistanceFromSideShop()
		if d<2000
		then
			desire = (2000-d)/d*0.5+0.3;
			--utility.DebugTalk("npc:"..npcBot:GetUnitName().."goto sideShop,distance:".. d)
		end
	else
		npcBot.sideShopMode = false
		return 0
	end
	
	--utility.DebugTalk(d..".."..desire)
	return desire

end

function Think()
	local npcBot = GetBot();
	if ( npcBot:IsUsingAbility() or npcBot:IsChanneling() or npcBot:IsSilenced() )
	then 
		return
	end
	local shopLoc1 = GetShopLocation( GetTeam(), SHOP_SIDE );
	local shopLoc2 = GetShopLocation( GetTeam(), SHOP_SIDE2 );

	if ( GetUnitToLocationDistance(npcBot, shopLoc1) <= GetUnitToLocationDistance(npcBot, shopLoc2) ) then
		npcBot:Action_MoveToLocation( shopLoc1 );
	else
		npcBot:Action_MoveToLocation( shopLoc2 );
	end
end
----------------------------------------------------------------------------------------------------