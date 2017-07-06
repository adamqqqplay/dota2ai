----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
function GetDesire()
	local npcBot = GetBot();

	if(npcBot:HasModifier("modifier_spirit_breaker_charge_of_darkness") or npcBot.SBTarget~=nil)
	then
		return 0.95
	end
	
	return 0
end

function Think()
	local npcBot = GetBot();
	if(npcBot:HasModifier("modifier_spirit_breaker_charge_of_darkness")==false or (npcBot.SBTarget~=nil and npcBot.SBTarget:DistanceFromFountain()<=4000 and DotaTime()<=30*60))
	then
		npcBot.SBTarget=nil
	end
	
	if ( npcBot:IsUsingAbility() or npcBot:IsChanneling() or npcBot:HasModifier("modifier_spirit_breaker_charge_of_darkness") )
	then 
		return
	end
	
	local npcEnemy = npcBot:GetTarget();
	if ( npcEnemy ~= nil and npcEnemy:IsAlive()) 
	then
		local d=GetUnitToUnitDistance(npcBot,npcEnemy)
		if(d<600)
		then
			npcBot:Action_AttackUnit(npcEnemy,true);
		else
			npcBot:Action_MoveToUnit(npcEnemy);
		end
	end
	
	return
end
----------------------------------------------------------------------------------------------------