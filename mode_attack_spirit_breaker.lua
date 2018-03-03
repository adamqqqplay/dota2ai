----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
local utility = require( GetScriptDirectory().."/utility" ) 

function Think()
	local npcBot = GetBot();
	if(npcBot:HasModifier("modifier_spirit_breaker_charge_of_darkness")==false)
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
	else
		local enemys = npcBot:GetNearbyHeroes(1200,true,BOT_MODE_NONE)
		local WeakestEnemy,HeroHealth=utility.GetWeakestUnit(enemys)
		local allys = npcBot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE );
		for i,npcAlly in pairs(allys) 
		do	
			local target=npcAlly:GetTarget()
			if(target~=nil)
			then
				npcBot:SetTarget(target)
				return
			end
		end
		if(npcBot:GetTarget()==nil and WeakestEnemy~=nil)
		then
			npcBot:SetTarget(WeakestEnemy)
		else
			npcBot:Action_AttackMove(npcBot:GetLocation())
		end
	end
	
	return
end
----------------------------------------------------------------------------------------------------