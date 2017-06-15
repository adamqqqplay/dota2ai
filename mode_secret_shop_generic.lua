----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

function GetDesire()
	
	local npcBot = GetBot();

	local desire = 0.0;

	if ( npcBot.secretShopMode == true and npcBot:GetGold() >= npcBot:GetNextItemPurchaseValue() and npcBot.secretShopMode~=true) then
		d=npcBot:DistanceFromSecretShop()
		if d<3000
		then
			desire = (3000-d)/d*0.8;
		end
		--print("npc:"..npcBot:GetUnitName().."goto secretShop,distance:".. d)
	else
		npcBot.secretShopMode = false
		return 0
	end
  
	--print("secret desire:"..desire .. " secretdistance:".. npcBot:DistanceFromSecretShop())
	return desire

end

----------------------------------------------------------------------------------------------------