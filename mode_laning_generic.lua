----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
function GetDesire()

	--local npcBot = GetBot();
	if (DotaTime()>0 and DotaTime() <= 8*60) then
		return 0.34;
	else 
		return 0.2
	end

end
----------------------------------------------------------------------------------------------------
