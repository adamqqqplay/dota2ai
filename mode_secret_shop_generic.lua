----------------------------------------------------------------------------------------------------
--- The Creation Come From: BOT EXPERIMENT Credit:FURIOUSPUPPY
--- BOT EXPERIMENT Author: Arizona Fauzie 2018.11.21
--- Link:http://steamcommunity.com/sharedfiles/filedetails/?id=837040016
----------------------------------------------------------------------------------------------------
if GetBot():IsInvulnerable() or not GetBot():IsHero() or not string.find(GetBot():GetUnitName(), "hero") or
	GetBot():IsIllusion() then
	return;
end

local bot = GetBot();
local X = {}
local preferedShop = nil;
local RAD_SECRET_SHOP = GetShopLocation(GetTeam(), SHOP_SECRET)
local DIRE_SECRET_SHOP = GetShopLocation(GetTeam(), SHOP_SECRET2)
local hasItemToSell = false;

function GetDesire()

	if not X.IsSuitableToBuy()
	then
		return BOT_MODE_DESIRE_NONE;
	end

	local invFull = true;

	for i = 0, 8 do
		if bot:GetItemInSlot(i) == nil then
			invFull = false;
		end
	end

	if invFull then
		if bot:GetLevel() > 11 and bot:FindItemSlot("item_aegis") < 0 then
			hasItemToSell, itemSlot = X.HaveItemToSell();
			if hasItemToSell then
				preferedShop = X.GetPreferedSecretShop();
				if preferedShop ~= nil then
					return RemapValClamped(GetUnitToLocationDistance(bot, preferedShop), 6000, 0, 0.75, 0.95);
				end
			end
		end
		return BOT_MODE_DESIRE_NONE;
	end

	local npcCourier = bot.theCourier
	local cState = GetCourierState(npcCourier);

	if bot.SecretShop and cState ~= COURIER_STATE_MOVING then
		preferedShop = X.GetPreferedSecretShop();
		if preferedShop ~= nil and cState == COURIER_STATE_DEAD then
			return RemapValClamped(GetUnitToLocationDistance(bot, preferedShop), 6000, 0, 0.7, 0.85);
		else
			if preferedShop ~= nil and GetUnitToLocationDistance(bot, preferedShop) <= 3200 then
				return RemapValClamped(GetUnitToLocationDistance(bot, preferedShop), 3200, 0, 0.7, 0.85);
			end
		end
	end

	return BOT_MODE_DESIRE_NONE

end

function OnStart()
	preferedShop = X.GetPreferedSecretShop();
end

function OnEnd()

end

local fullInvCheck = -90

local earlyGameItem = {
	"item_clarity",
	"item_faerie_fire",
	"item_tango",
	"item_flask",
	--		 "item_orb_of_venom",
	"item_bracer",
	"item_wraith_band",
	"item_null_talisman",
	"item_infused_raindrop",
	"item_bottle",
}

function Think()
	if bot:IsChanneling()
		or bot:NumQueuedActions() > 0
		or bot:IsCastingAbility()
		or bot:IsUsingAbility()
	then
		return
	end

	local botLevel = bot:GetLevel()
	local currentTime = DotaTime()
	local botWorth = bot:GetNetWorth()

	--卖掉一些早期的低端物品用来腾格子
	if (GetGameMode() ~= 23 and botLevel > 6 and currentTime > fullInvCheck + 1.0
			and (bot:DistanceFromFountain() <= 200 or bot:DistanceFromSecretShop() <= 200))
		or (GetGameMode() == 23 and botLevel > 9 and currentTime > fullInvCheck + 1.0)
	then
		local emptySlot = X.GetEmptyInventoryAmount(bot)
		local slotToSell = nil

		local preEmpty = 2
		if botLevel <= 17 then preEmpty = 1 end
		if emptySlot <= preEmpty - 1
		then
			for i = 1, #earlyGameItem
			do
				local itemName = earlyGameItem[i]
				local itemSlot = bot:FindItemSlot(itemName)
				if itemSlot >= 0 and itemSlot <= 8
				then
					slotToSell = itemSlot
					break
				end
			end
		end

		--避免过早卖掉大魔棒
		if botWorth > 9999
		then
			local wand = bot:FindItemSlot("item_magic_wand")
			local assitItem = bot:FindItemSlot("item_infused_raindrop")
			if assitItem < 0 then assitItem = bot:FindItemSlot("item_bracer") end
			if assitItem < 0 then assitItem = bot:FindItemSlot("item_null_talisman") end
			if assitItem < 0 then assitItem = bot:FindItemSlot("item_wraith_band") end
			if assitItem >= 0
				and wand >= 6
				and wand <= 8
			then
				slotToSell = assitItem
			end
		end

		if slotToSell ~= nil
		then
			bot:ActionImmediate_SellItem(bot:GetItemInSlot(slotToSell))
			return
		end

		fullInvCheck = currentTime
	end

	if bot:DistanceFromSecretShop() == 0
	then
		bot:Action_MoveToLocation(preferedShop + RandomVector(200))
		return;
	end

	if bot:DistanceFromSecretShop() > 0
	then
		bot:Action_MoveToLocation(preferedShop + RandomVector(20));
		return;
	end
end

function X.GetEmptyInventoryAmount( bot )

	local amount = 0
	for i = 0, 8
	do
		local item = bot:GetItemInSlot( i )
		if item == nil
		then
			amount = amount + 1
		end
	end

	return amount

end

--这些是AI会主动走到商店出售的物品
function X.HaveItemToSell()
	for _, item in pairs(earlyGameItem) do
		local slot = bot:FindItemSlot(item)
		if slot >= 0 and slot <= 8 then
			return true, slot;
		end
	end
	return false, nil;
end

function X.GetPreferedSecretShop()
	if GetTeam() == TEAM_RADIANT then
		if GetUnitToLocationDistance(bot, DIRE_SECRET_SHOP) <= 3800 then
			return DIRE_SECRET_SHOP;
		else
			return RAD_SECRET_SHOP;
		end
	elseif GetTeam() == TEAM_DIRE then
		if GetUnitToLocationDistance(bot, RAD_SECRET_SHOP) <= 3800 then
			return RAD_SECRET_SHOP;
		else
			return DIRE_SECRET_SHOP;
		end
	end
	return nil;
end

function X.IsSuitableToBuy()
	local mode = bot:GetActiveMode();
	local Enemies = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE);
	if not bot:IsAlive()
		or bot:HasModifier("modifier_item_shadow_amulet_fade")
		or (mode == BOT_MODE_RETREAT and bot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH)
		or mode == BOT_MODE_ATTACK
		or mode == BOT_MODE_DEFEND_ALLY
		or (Enemies ~= nil and #Enemies >= 2)
		or (Enemies[1] ~= nil and X.IsStronger(bot, Enemies[1]))
		or GetUnitToUnitDistance(bot, GetAncient(GetTeam())) < 2300
		or GetUnitToUnitDistance(bot, GetAncient(GetOpposingTeam())) < 3500
	then
		return false;
	end
	return true;
end

function X.IsStronger(bot, enemy)
	local BPower = bot:GetEstimatedDamageToTarget(true, enemy, 4.0, DAMAGE_TYPE_ALL);
	local EPower = enemy:GetEstimatedDamageToTarget(true, bot, 4.0, DAMAGE_TYPE_ALL);
	return EPower > BPower;
end
