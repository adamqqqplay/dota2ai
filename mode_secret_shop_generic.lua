----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

function GetDesire()
	
	local npcBot = GetBot();

	local desire = 0.0;
	
	if ( npcBot:IsUsingAbility() or npcBot:IsChanneling() )		--不应打断持续施法
	then
		return 0
	end
	
	if ( npcBot.secretShopMode == true and npcBot:GetGold() >= npcBot:GetNextItemPurchaseValue()) then
		local d=npcBot:DistanceFromSecretShop()
		if d<3000
		then
			desire = (3000-d)/3000*0.3+0.3;				--根据离边路商店的距离返回欲望值
		end
	end
  
	return desire

end

----------------------------------------------------------------------------------------------------