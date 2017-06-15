----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.0a
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
function Think()
	local npcBot = GetBot();
	
	if ( npcBot:IsUsingAbility() or npcBot:IsChanneling() )
	then 
		return
	end
	
	local npcEnemy = npcBot:GetTarget();
	local MaxDistance=npcBot:GetAttackRange()
	if(npcBot:HasModifier("modifier_razor_static_link_buff"))
	then
		MaxDistance=MaxDistance-100
	end
	if ( npcEnemy ~= nil and npcEnemy:IsAlive() and npcEnemy) 
	then
		local d=GetUnitToUnitDistance(npcBot,npcEnemy)
		if(d<MaxDistance)
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
				npcBot:Action_AttackUnit(target,true);
				return
			end
		end
		if(WeakestEnemy~=nil)
		then
			npcBot:SetTarget(WeakestEnemy)
			npcBot:Action_AttackUnit(WeakestEnemy,true);
		end
	end
	
	return
end
----------------------------------------------------------------------------------------------------