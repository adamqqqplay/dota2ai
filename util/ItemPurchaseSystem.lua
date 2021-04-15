local BotsInit = require("game/botsinit")
local M = BotsInit.CreateGeneric()
local utility = require( GetScriptDirectory().."/utility" )
local AbilityExtensions = require(GetScriptDirectory().."/util/AbilityAbstraction")

function M.SellExtraItem(ItemsToBuy)
	local npcBot=GetBot()
	local level=npcBot:GetLevel()
	local item_travel_boots = M.NoNeedTpscrollForTravelBoots();
	-- local item_travel_boots_1 = item_travel_boots[1];
	-- local item_travel_boots_2 = item_travel_boots[2];

	if(M.IsItemSlotsFull())
	then
		if(GameTime()>6*60 or level>=6)
		then
			M.SellSpecifiedItem("item_faerie_fire")
			M.SellSpecifiedItem("item_tango")
			M.SellSpecifiedItem("item_clarity")
			M.SellSpecifiedItem("item_flask")
		end
		if(GameTime()>25*60 or level>=10)
		then
			--M.SellSpecifiedItem("item_stout_shield")
			M.SellSpecifiedItem("item_orb_of_venom")
			M.SellSpecifiedItem("item_enchanted_mango")
			M.SellSpecifiedItem("item_bracer")
			M.SellSpecifiedItem("item_null_talisman")
			M.SellSpecifiedItem("item_wraith_band")
			--M.SellSpecifiedItem("item_poor_mans_shield")
		end
		if(GameTime()>35*60 or level>=15)
		then
			M.SellSpecifiedItem("item_branches")
			M.SellSpecifiedItem("item_bottle")
			M.SellSpecifiedItem("item_magic_wand")
			M.SellSpecifiedItem("item_flask")
			M.SellSpecifiedItem("item_ancient_janggo")
			M.SellSpecifiedItem("item_ring_of_basilius")
			M.SellSpecifiedItem("item_quelling_blade")
			M.SellSpecifiedItem("item_soul_ring")
			M.SellSpecifiedItem("item_buckler")
			M.SellSpecifiedItem("item_ring_of_basilius")
			M.SellSpecifiedItem("item_headdress")
			

		end
		if(GameTime()>40*60 or level>=20)
		then
			M.SellSpecifiedItem("item_vladmir")
			M.SellSpecifiedItem("item_urn_of_shadows")
			M.SellSpecifiedItem("item_drums_of_endurance")
			M.SellSpecifiedItem("item_hand_of_midas")
			M.SellSpecifiedItem("item_dust")
		end
		if(GameTime()>40*60 and npcBot:GetGold()>2500 and (item_travel_boots[1]==nil and item_travel_boots[2]==nil) and npcBot.HaveTravelBoots~=true )
		then
			table.insert(ItemsToBuy,"item_boots")
			table.insert(ItemsToBuy,"item_recipe_travel_boots")
			npcBot.HaveTravelBoots=true
            if npcBot:GetGold() >= 4500 then
                table.insert(ItemsToBuy, "item_recipe_travel_boots")
            end
		end
	end

	if(item_travel_boots[1]~=nil or item_travel_boots[2]~=nil)
	then
        M.SellSpecifiedItem("item_boots")
		M.SellSpecifiedItem("item_arcane_boots")
		M.SellSpecifiedItem("item_phase_boots")
		M.SellSpecifiedItem("item_power_treads_agi")
		M.SellSpecifiedItem("item_power_treads_int")
		M.SellSpecifiedItem("item_power_treads_str")
		M.SellSpecifiedItem("item_tranquil_boots")
	end

end

function isLeaf (Node)
    local recipe = GetItemComponents(Node)
    return next(recipe) == nil
end

function nextNodes (Node)
    local recipe = GetItemComponents(Node)
    return recipe[1]
end

M.ExpandItemRecipe = function(self, itemTable)
    local output = {}
    local expandItem
    expandItem = function(item)
        if isLeaf(item) then
            table.insert(output, item)
        else
            for _, v in pairs(nextNodes(item)) do
                expandItem(item)
            end
        end
    end
    for _, v in pairs(itemTable) do
        expandItem(v)
    end
    return output
end

function M.Transfer(itemtable)
    local output = {}
    for k1, v1 in pairs(itemtable) do
        if isLeaf(v1) then
            table.insert(output, v1)
        else
            for k2, v2 in pairs(nextNodes(v1)) do
                if isLeaf(v2) then
                    table.insert(output, v2)
                else
                    for k3, v3 in pairs(nextNodes(v2)) do
                        if isLeaf(v3) then
                            table.insert(output, v3)
                        else
                            for k4, v4 in pairs(nextNodes(v3)) do
                                if isLeaf(v4) then
                                    table.insert(output, v4)
                                else
                                    for k5, v5 in pairs(nextNodes(v4)) do
                                        if isLeaf(v5) then
                                            table.insert(output, v5)
                                        else
                                            for k6, v6 in pairs(nextNodes(v5)) do
                                                if isLeaf(v6) then
                                                    table.insert(output, v6)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return output
end

function M.ItemPurchase(ItemsToBuy)
    if GetGameState() == DOTA_GAMERULES_STATE_POSTGAME then
        return
    end
	local npcBot = GetBot();

	-- buy item_tpscroll
	if(npcBot.secretShopMode~=true or npcBot:GetGold() >= 100)
	then
		M.WeNeedTpscroll();
	end

	if ( #ItemsToBuy == 0 )
	then
		npcBot:SetNextItemPurchaseValue( 0 );
		return;
	end

	local sNextItem = ItemsToBuy[1]
	npcBot:SetNextItemPurchaseValue( GetItemCost( sNextItem ) )

	M.SellExtraItem(ItemsToBuy)

	if npcBot:DistanceFromFountain()<=2500 or npcBot:GetHealth()/npcBot:GetMaxHealth()<=0.35
	then
		npcBot.secretShopMode = false
	end

	if IsItemPurchasedFromSecretShop( sNextItem )==false
	then
		npcBot.secretShopMode = false
	end

	if ( npcBot:GetGold() >= GetItemCost( sNextItem ) )
	then
		if npcBot.secretShopMode~=true
		then
			if (IsItemPurchasedFromSecretShop( sNextItem ) and sNextItem ~= "item_bottle")
			then
				npcBot.secretShopMode = true
			end
		end

		local PurchaseResult=-2		--???????????????????
		if(npcBot.secretShopMode == true)		--???????????????????????????????
		then
			if(npcBot:DistanceFromSecretShop() <= 250)
			then
				PurchaseResult=npcBot:ActionImmediate_PurchaseItem( sNextItem )
			end

			local courier=GetCourier(0)

			--[[if(courier==nil)
			then
				local ItemCount=M.GetItemSlotsCount2(npcBot)
				if(ItemCount<6)
				then
					M.BuyCourier()		--???????????????????????????
				end
			else]]
			local ItemCount=M.GetItemSlotsCount2(courier)
			if(courier:DistanceFromSecretShop() <= 250 and ItemCount<9)		--???????????
			then
				PurchaseResult=GetCourier(0):ActionImmediate_PurchaseItem( sNextItem )
			end
		else
			PurchaseResult=npcBot:ActionImmediate_PurchaseItem( sNextItem )
		end

        if(PurchaseResult==PURCHASE_ITEM_SUCCESS)		--???????????????????????
        then
            npcBot.secretShopMode = false;
            table.remove( ItemsToBuy, 1 )
        elseif PurchaseResult ~= -2 then
            print("purchase item failed: "..ItemsToBuy[1]..", fail code: "..PurchaseResult)
        end

		if(PurchaseResult==PURCHASE_ITEM_OUT_OF_STOCK)	--??????????????????????
		then
			M.SellSpecifiedItem("item_dust")
			M.SellSpecifiedItem("item_faerie_fire")
			M.SellSpecifiedItem("item_tango")
			M.SellSpecifiedItem("item_clarity")
			M.SellSpecifiedItem("item_flask")
		end
		if(PurchaseResult==PURCHASE_ITEM_INVALID_ITEM_NAME or PurchaseResult==PURCHASE_ITEM_DISALLOWED_ITEM)	--????????????????????
		then
            print("invalid item purchase or disallowed purchase: "..ItemsToBuy[1])
			table.remove( ItemsToBuy, 1 )
		end
		if(PurchaseResult==PURCHASE_ITEM_INSUFFICIENT_GOLD )	--???????????????????????????????????????ж???????
		then
			npcBot.secretShopMode = false;
		end
		if(PurchaseResult==PURCHASE_ITEM_NOT_AT_SECRET_SHOP)	--?????????????????????
		then
			npcBot.secretShopMode = true
		end
		if(PurchaseResult==PURCHASE_ITEM_NOT_AT_HOME_SHOP)		--??????????????????????????????????????У????????????????????
		then
			npcBot.secretShopMode = false;
		end
		if(PurchaseResult>=-1)
		then
			--print(npcBot:GetPlayerID().."[ItemPurchase] purchaseResult is"..PurchaseResult)
		end
	else
		npcBot.secretShopMode = false;
	end

end

function M.BuyCourier()
	-- no longer need to buy courier
	
	-- local npcBot=GetBot()
	-- local courier=GetCourier(0)
	-- if(courier==nil)
	-- then
	-- 	if(npcBot:GetGold()>=GetItemCost("item_courier"))
	-- 	then
	-- 		local info=npcBot:ActionImmediate_PurchaseItem("item_courier");
	-- 		if info ==PURCHASE_ITEM_SUCCESS then
	-- 			npcBot:ActionImmediate_Chat('I bought the courier 我买了鸡。',false);
	-- 		end
	-- 	end
	-- end
	--[[else
		if DotaTime()>60*3 and npcBot:GetGold()>=GetItemCost("item_flying_courier") and (courier:GetMaxHealth()==75) then
			local info=npcBot:ActionImmediate_PurchaseItem("item_flying_courier");
			if info ==PURCHASE_ITEM_SUCCESS then
				print(npcBot:GetUnitName()..' has upgraded the courier.',info);
			end
		end
	end]]

end

function M.NoNeedTpscrollForTravelBoots()

	local npcBot = GetBot();

	local item_travel_boots = {};

	local item_travel_boots_1 = nil;
	local item_travel_boots_2 = nil;
	for i = 0, 14 do
		local sCurItem = npcBot:GetItemInSlot(i);
		if ( sCurItem ~= nil and sCurItem:GetName() == "item_travel_boots_1" ) then
			item_travel_boots_1 = sCurItem;
		end

		if ( sCurItem ~= nil and sCurItem:GetName() == "item_travel_boots_2" ) then
			item_travel_boots_2 = sCurItem;
		end
	end

	if ( item_travel_boots_1 ~= nil or item_travel_boots_2 ~= nil) then
		for i = 0, 14 do
			local sCurItem = npcBot:GetItemInSlot(i);
			if ( sCurItem ~= nil and sCurItem:GetName() == "item_tpscroll" ) then
				npcBot:ActionImmediate_SellItem( "item_tpscroll" );
			end
		end
	end

	item_travel_boots[1] = item_travel_boots_1;
	item_travel_boots[2] = item_travel_boots_2;
	return item_travel_boots;

end

function M.WeNeedTpscroll()

	local npcBot = GetBot();

	local item_travel_boots = M.NoNeedTpscrollForTravelBoots();
	local item_travel_boots_1 = item_travel_boots[1];
	local item_travel_boots_2 = item_travel_boots[2];

	-- Count current number of TP scrolls
	local iScrollCount = 0;
	for i = 0, 16 do
		local sCurItem = npcBot:GetItemInSlot(i);
		if ( sCurItem ~= nil and sCurItem:GetName() == "item_tpscroll" ) then
			iScrollCount = iScrollCount+sCurItem:GetCurrentCharges()
		end
	end

	-- If we are at the sideshop or fountain with no TPs, then buy one or two
	if ( iScrollCount <=2 and item_travel_boots_1 == nil and item_travel_boots_2 == nil ) then

		if ( npcBot:DistanceFromSideShop() <= 200 or npcBot:DistanceFromFountain() <= 200 ) then

			if ( DotaTime() > 2*60 and DotaTime() < 20 * 60 ) then
				npcBot:ActionImmediate_PurchaseItem( "item_tpscroll" );
			elseif ( DotaTime() >= 20 * 60 ) then
				npcBot:ActionImmediate_PurchaseItem( "item_tpscroll" );
				npcBot:ActionImmediate_PurchaseItem( "item_tpscroll" );
			end
		--[[else
			if(npcBot.WeNeedTpscrollTimer==nil)
			then
				npcBot.WeNeedTpscrollTimer=DotaTime()
			end
			if(DotaTime()-npcBot.WeNeedTpscrollTimer>120)
			then
				npcBot:ActionImmediate_PurchaseItem( "item_tpscroll" );
				npcBot.WeNeedTpscrollTimer=DotaTime()
			end]]
		else
			npcBot:ActionImmediate_PurchaseItem( "item_tpscroll" );
		end
	end

end

function M.SellSpecifiedItem( item_name )

	local npcBot = GetBot();

	local itemCount = 0;
	local item = nil;

	for i = 0, 14
	do
		local sCurItem = npcBot:GetItemInSlot(i);
		if ( sCurItem ~= nil )
		then
			itemCount = itemCount + 1;
			if ( sCurItem:GetName() == item_name )
			then
				item = sCurItem;
			end
		end
	end

	if ( item ~= nil and itemCount > 5 and (npcBot:DistanceFromFountain() <= 600 or npcBot:DistanceFromSideShop() <= 200 or npcBot:DistanceFromSecretShop() <= 200) ) then
		npcBot:ActionImmediate_SellItem( item );
	end

end

function M.GetItemSlotsCount2(npcBot)

	local itemCount = 0;

	for i = 0, 8
	do
		local sCurItem = npcBot:GetItemInSlot(i);
		if ( sCurItem ~= nil )
		then
			itemCount = itemCount + 1;
		end
	end

	return itemCount
end

function M.GetItemSlotsCount()
	local npcBot = GetBot();

	local itemCount = 0;

	for i = 0, 8
	do
		local sCurItem = npcBot:GetItemInSlot(i);
		if ( sCurItem ~= nil )
		then
			itemCount = itemCount + 1;
		end
	end

	return itemCount
end

function M.IsItemSlotsFull()
	local itemCount = M.GetItemSlotsCount();
	if(itemCount>=8)
	then
		return true
	else
		return false
	end
end

function M.checkItemBuild(ItemsToBuy)
	local ItemTableA=
	{
		"item_tango",
		"item_clarity",
		"item_faerie_fire",
		"item_enchanted_mango",
		"item_flask",
	}

	if(DotaTime()>0)
	then
		for _,item in pairs (ItemTableA)
		do
			for _1,item2 in pairs (ItemsToBuy)
			do
				if(item==item2)
				then
					table.remove(ItemsToBuy,_1)
				end
			end
		end

		local npcBot=GetBot()
		for _1,item2 in pairs (ItemsToBuy)
		do
			if(npcBot:FindItemSlot(item2)>0)
			then
				table.remove(ItemsToBuy,_1)
			end
		end
	end
end

local RoleUtility = require(GetScriptDirectory().."/util/RoleUtility")
local invisHeroes = RoleUtility.invisHeroes
local invisibleHeroes = {}
for heroName, _ in pairs(invisHeroes) do
    table.insert(invisibleHeroes, heroName)
end

-- function M.GetItemIncludeBackpack( item_name )

	-- local npcBot = GetBot();
	-- local item = nil;
	-- local i=-1
	-- i = npcBot:FindItemSlot(item_name)
	-- item = npcBot:GetItemInSlot(i)

	-- return item;
-- end

function M.GetItemIncludeBackpack(item_name)
	local npcBot=GetBot()
    for i = 0, 16 do
        local item = npcBot:GetItemInSlot(i);
		if (item~=nil) then
			if(item:GetName() == item_name) then
				return item;
			end
		end
    end
    return nil;
end

function M.IsItemAvailable(item_name)
    local npcBot = GetBot();

    for i = 0, 5, 1 do
        local item = npcBot:GetItemInSlot(i);
		if (item~=nil) then
			if(item:GetName() == item_name) then
				return item;
			end
		end
    end
    return nil;
end

function M.GetOtherTeam()
	if GetTeam()==TEAM_RADIANT then
		return TEAM_DIRE;
	else
		return TEAM_RADIANT;
	end
end

function M.CheckInvisibleEnemy()
    local enemyTeam=M.GetOtherTeam()
    if ( enemyTeam ~= nil ) then
        for _, id in pairs( GetTeamPlayers(enemyTeam) )
        do
            for _, invisibleHeroName in pairs(invisibleHeroes)
            do
                if ( GetSelectedHeroName(id) == invisibleHeroName )
                then
                    return true
                end
            end
        end
    end
    local enemys=GetUnitList(UNIT_LIST_ENEMY_HEROES)
    if ( enemys ~= nil ) then
        for _,npcEnemy in pairs(enemys)
        do
            if(npcEnemy:HasInvisibility(false))
            then
                return true
            end
        end
    end

    return false
end

local hasInvisibleEnemy = false
local BuySupportItem_Timer=DotaTime()
function M.BuySupportItem()
	local npcBot=GetBot()
	-- decide if there were several invisible enemy heroes.

	if(DotaTime()-BuySupportItem_Timer>=10)
	then
		BuySupportItem_Timer=DotaTime()
		hasInvisibleEnemy=M.CheckInvisibleEnemy()
	end

	if(M.GetItemSlotsCount()<7)
	then
		local item_ward_dispenser=M.GetItemIncludeBackpack( "item_ward_dispenser" );

		if(item_ward_dispenser~=nil)
		then
			local wardState=item_ward_dispenser:GetToggleState();

			local observerCount=item_ward_dispenser:GetCurrentCharges();
			local sentryCount=item_ward_dispenser:GetSecondaryCharges();
		end


		-- if(wardState== nil)
		-- then

		-- else

		-- end



		local item_ward_observer = M.GetItemIncludeBackpack( "item_ward_observer" );
		local item_ward_sentry = M.GetItemIncludeBackpack( "item_ward_dispenser" );
		local item_gem = M.GetItemIncludeBackpack( "item_gem" )
		local item_smoke =  M.GetItemIncludeBackpack( "item_smoke_of_deceit")
		if ( DotaTime() >= 0 and hasInvisibleEnemy == true )
		then
			local item_dust = M.GetItemIncludeBackpack( "item_dust" );
			--local item_ward_sentry = M.GetItemIncludeBackpack( "item_ward_sentry" )
			if(item_gem==nil and M.HaveGem()==false)
			then
				if (item_dust==nil and item_ward_sentry==nil  and npcBot:GetGold() >= 2*GetItemCost("item_dust") and GetItemStockCount("item_gem") >= 1) then
					npcBot:ActionImmediate_PurchaseItem( "item_dust" );
				end

				if (DotaTime()>=25*60 and npcBot:GetGold() >= GetItemCost("item_gem") and GetItemStockCount("item_gem") >= 1) and AbilityExtensions:GetEmptyItemSlots(npcBot) >= 1
				then
                    if AbilityExtensions:GetEmptyItemSlots(npcBot) >= 1 and AbilityExtensions:GetEmptyBackpackSlots(npcBot) == 0 then
                        npcBot:ActionImmediate_PurchaseItem( "item_gem" )
                    elseif AbilityExtensions:GetEmptyBackpackSlots(npcBot) >= 1 then
                        if AbilityExtensions:SwapCheapestItemToBackpack(npcBot) then
                            npcBot:ActionImmediate_PurchaseItem( "item_gem" )
                        end
                    else

                    end
				end

				-- if ( item_ward_observer==nil and item_dust==nil and item_ward_sentry==nil and M.IsItemSlotsFull()==false and npcBot:GetGold() >= 2*GetItemCost("item_ward_sentry") ) then
				-- 	npcBot:ActionImmediate_PurchaseItem( "item_ward_sentry" );
				-- end
			end
		end

		if(DotaTime()>=40*60 and npcBot:GetGold() >= GetItemCost("item_gem") and GetItemStockCount("item_gem") >= 1 and item_gem==nil and M.HaveGem()==false)
		then
			npcBot:ActionImmediate_PurchaseItem( "item_gem" );
		end
				--item_ward_observer==nil and
		if ( item_ward_observer==nil and item_ward_sentry==nil and (GetItemStockCount("item_ward_observer") > 1 or DotaTime()<0) and npcBot:GetGold() >= GetItemCost("item_ward_observer"))
		then
			npcBot:ActionImmediate_PurchaseItem( "item_ward_observer" );
		end

		if(item_smoke==nil and GetItemStockCount("item_smoke_of_deceit")>=1 and npcBot:GetGold() >= GetItemCost("item_smoke_of_deceit"))
		then
			npcBot:ActionImmediate_PurchaseItem("item_smoke_of_deceit");
		end
	end

end

function M.HaveGem()
	for _,hero in pairs(GetUnitList( UNIT_LIST_ALLIED_HEROES ) )
	do
		local gem=hero:FindItemSlot( "item_gem" )
		if(gem>0)
		then
			return true
		end
	end
	return false
end

local key = ""
function M.PrintTable(table , level)
  level = level or 1
  local indent = ""
  for i = 1, level do
    indent = indent.."  "
  end

  if key ~= "" then
    print(indent..key.." ".."=".." ".."{")
  else
    print(indent .. "{")
  end

  key = ""
  for k,v in pairs(table) do
     if type(v) == "table" then
        key = k
        PrintTable(v, level + 1)
     else
        local content = string.format("%s%s = %s", indent .. "  ",tostring(k), tostring(v))
      print(content)  
      end
  end
  print(indent .. "}")

end  ------function for printing table

M.ItemName = {}
setmetatable(M.ItemName,  {
    __index = function(tb, f) return "item_"..f end
})
M.Consumables = {
    "clarity",
    "mango",
    "faerie_fire",
    "tome_of_knowledge",
    "tango",
    "flask",
    "bottle",
    "tpscroll",
}
M.IsConsumableItem = function(self, item)
    return AbilityExtensions:Contains(self.Consumables, string.sub(item, 6))
end

M.GetAllBoughtItems = function(self)
    local g = {}
    local npcBot = GetBot()
    for i = 0, 15 do
        local item = npcBot:GetItemInSlot(i)
        if item then
            table.insert(g, item)
        end
    end
    local courier = GetCourier(0)
    if courier ~= nil then
        for i = 0, 5 do
            local item = courier:GetItemInSlot(i)
            if item then
                table.insert(g, item)
            end
        end
    end
    return g
end

M.CreateItemInformationTable = function(self, npcBot, itemTable)
    local function ExpandFirstLevel(item)
        if isLeaf(item) then
            return { name = item, isSingleItem = true }
        else
            return { name = item, recipe = nextNodes(item) }
        end
    end
    local function ExpandOnce(item)
        local g = {}
        local expandSomething = false
        for _,v in ipairs(item.recipe) do
            if isLeaf(v) then
                table.insert(g, v)
            else
                expandSomething = true
                for _, i in ipairs(nextNodes(v)) do
                    table.insert(g, i)
                end
            end
        end
        item.recipe = g
        return expandSomething
    end
    local function RemoveBoughtItems() -- used only when reloading scripts in game
        local boughtItems = AbilityExtensions:Map(self:GetAllBoughtItems(), function(t) return t:GetName()  end)
        local function TryRemoveItem(itemName, tbToRemoveFirst)
            if DotaTime() > -60 and self:IsConsumableItem(itemName) then
                table.remove(tbToRemoveFirst, 1)
                return true
            end
            for i, boughtItem in ipairs(boughtItems) do
                if boughtItem and boughtItem == itemName then
                    table.remove(boughtItems, i)
                    table.remove(tbToRemoveFirst, 1)
                    return true
                end
            end
        end
        local infoTable = GetBot().itemInformationTable
        while TryRemoveItem(infoTable[1].name, infoTable) do end
        if infoTable[1].recipe then
            while #infoTable[1].recipe > 0 and TryRemoveItem(infoTable[1].recipe[1], infoTable[1].recipe) do end
            if #infoTable[1].recipe == 0 then
                table.remove(infoTable, 1)
            end
        end
    end

    local g = {}
    for _, item in pairs(itemTable) do
        local itemInformation = ExpandFirstLevel(item)
        if itemInformation.isSingleItem then

        else
            ::h:: local recipe = itemInformation.recipe
            local deletedKeys = {}
            for _, boughtItem in pairs(g) do
                if not boughtItem.usedAsRecipeOf then
                    for componentIndex, componentName in ipairs(recipe) do
                        if componentName == boughtItem.name then
                            table.insert(deletedKeys, componentName)
                            boughtItem.usedAsRecipeOf = itemInformation.name
                            break
                        end
                    end
                end
            end
            for _, v in pairs(deletedKeys) do
                for t1,t2 in ipairs(recipe) do
                    if t2 == v then
                        table.remove(recipe, t1)
                        break
                    end
                end
            end
            if ExpandOnce(itemInformation) then
                goto h
            end
        end
        table.insert(g, itemInformation)
    end
    npcBot.itemInformationTable = g
    RemoveBoughtItems()
end

function M.SellExtraItemExtend()
    local npcBot=GetBot()
    local level=npcBot:GetLevel()
    local item_travel_boots = M.NoNeedTpscrollForTravelBoots();
    -- local item_travel_boots_1 = item_travel_boots[1];
    -- local item_travel_boots_2 = item_travel_boots[2];

    if(M.IsItemSlotsFull())
    then
        if(GameTime()>6*60 or level>=6) and AbilityExtensions:GetEmptyItemSlots(npcBot) < 2
        then
            M.SellSpecifiedItem("item_faerie_fire")
            M.SellSpecifiedItem("item_tango")
            M.SellSpecifiedItem("item_clarity")
            M.SellSpecifiedItem("item_flask")
        end
        if(GameTime()>25*60 or level>=10) and AbilityExtensions:GetEmptyItemSlots(npcBot) < 2
        then
            --M.SellSpecifiedItem("item_stout_shield")
            M.SellSpecifiedItem("item_orb_of_venom")
            M.SellSpecifiedItem("item_enchanted_mango")
            M.SellSpecifiedItem("item_bracer")
            M.SellSpecifiedItem("item_null_talisman")
            M.SellSpecifiedItem("item_wraith_band")
            --M.SellSpecifiedItem("item_poor_mans_shield")
        end
        if(GameTime()>35*60 or level>=15) and AbilityExtensions:GetEmptyItemSlots(npcBot) < 2
        then
            M.SellSpecifiedItem("item_branches")
            M.SellSpecifiedItem("item_bottle")
            M.SellSpecifiedItem("item_magic_wand")
            M.SellSpecifiedItem("item_flask")
            M.SellSpecifiedItem("item_ancient_janggo")
            M.SellSpecifiedItem("item_ring_of_basilius")
            M.SellSpecifiedItem("item_quelling_blade")
            M.SellSpecifiedItem("item_soul_ring")
            M.SellSpecifiedItem("item_buckler")
            M.SellSpecifiedItem("item_ring_of_basilius")
            M.SellSpecifiedItem("item_headdress")


        end
        if(GameTime()>40*60 or level>=20) and AbilityExtensions:GetEmptyItemSlots(npcBot) < 2
        then
            M.SellSpecifiedItem("item_vladmir")
            M.SellSpecifiedItem("item_urn_of_shadows")
            M.SellSpecifiedItem("item_drums_of_endurance")
            M.SellSpecifiedItem("item_hand_of_midas")
            M.SellSpecifiedItem("item_dust")
        end
        if(GameTime()>40*60 and npcBot:GetGold()>2500 and (item_travel_boots[1]==nil and item_travel_boots[2]==nil) and npcBot.HaveTravelBoots~=true )
        then
            table.insert(npcBot.itemInformationTable, { name = "item_travel_boots", recipe = {"item_boots", "item_recipe_travel_boots" }})
            npcBot.HaveTravelBoots = true
        end
        if GameTime()>45*60 and npcBot:GetGold()>2000 and (item_travel_boots[1]==nil and item_travel_boots[2]==nil) and not npcBot.HaveTravelBoots2 then
            table.insert(npcBot.itemInformationTable,  { name = "item_travel_boots_2", recipe = { "item_recipe_travel_boots" }})
            npcBot.HaveTravelBoots2 = true
        end
    end

    if(item_travel_boots[1]~=nil or item_travel_boots[2]~=nil)
    then
        M.SellSpecifiedItem("item_boots")
        M.SellSpecifiedItem("item_arcane_boots")
        M.SellSpecifiedItem("item_phase_boots")
        M.SellSpecifiedItem("item_power_treads_agi")
        M.SellSpecifiedItem("item_power_treads_int")
        M.SellSpecifiedItem("item_power_treads_str")
        M.SellSpecifiedItem("item_tranquil_boots")
    end

end

M.ItemPurchaseExtend = function(self, ItemsToBuy)
    local function GetTopItemToBuy()
        local itemInformationTable = GetBot().itemInformationTable
        if #itemInformationTable == 0 then
            return nil
        elseif itemInformationTable[1].isSingleItem then
            return itemInformationTable[1].name
        else
            return itemInformationTable[1].recipe[1]
        end
    end
    local function RemoveTopItemToBuy()
        local itemInformationTable = GetBot().itemInformationTable
        if itemInformationTable[1].isSingleItem then
            table.remove(itemInformationTable, 1)
        else
            table.remove(itemInformationTable[1].recipe, 1)
            if #itemInformationTable[1].recipe == 0 then
                table.remove(itemInformationTable, 1)
            end
        end
    end

    if GetGameState() == DOTA_GAMERULES_STATE_POSTGAME then
        return
    end
    local npcBot = GetBot();

    local function RemoveInvisibleItemsWhenBountyHunter()
        local enemies = AbilityExtensions:Filter(GetBot():GetNearbyHeroes(1500, true, BOT_MODE_NONE), function(t)
            return AbilityExtensions:MayNotBeIllusion(GetBot(), t)
        end)
        if AbilityExtensions:Any(enemies, function(t)
            return t:GetUnitName() == AbilityExtensions:GetHeroFullName("bounty_hunter") or t:GetUnitName() == AbilityExtensions:GetHeroFullName("slardar") or t:GetUnitName() == AbilityExtensions:GetHeroFullName("rattletrap") and t:GetLevel() >= 18
        end) then
            M:RemoveInvisibleItemPurchase(GetBot())
        end
    end

    if npcBot:IsIllusion() then
        return
    end
    if (npcBot.secretShopMode~=true or npcBot:GetGold() >= 100) then
        M.WeNeedTpscroll();
    end

    if #GetBot().itemInformationTable == 0 then
        npcBot:SetNextItemPurchaseValue( 0 )
        return
    end

    RemoveInvisibleItemsWhenBountyHunter()
    local sNextItem = GetTopItemToBuy()
    if sNextItem == nil then
        print(npcBot:GetUnitName()..": ".."purchase a nil item")
        return
    end
    npcBot:SetNextItemPurchaseValue( GetItemCost( sNextItem ) )

    M.SellExtraItemExtend(ItemsToBuy)

    if npcBot:DistanceFromFountain()<=2500 or npcBot:GetHealth()/npcBot:GetMaxHealth()<=0.35 then
        npcBot.secretShopMode = false
    end

    if IsItemPurchasedFromSecretShop( sNextItem )==false then
        npcBot.secretShopMode = false
    end

    if ( npcBot:GetGold() >= GetItemCost( sNextItem ) ) then
        if npcBot.secretShopMode~=true then
            if (IsItemPurchasedFromSecretShop( sNextItem ) and sNextItem ~= "item_bottle")
            then
                npcBot.secretShopMode = true
            end
        end

        local PurchaseResult=-2
        if(npcBot.secretShopMode == true) then
            if(npcBot:DistanceFromSecretShop() <= 250) then
                PurchaseResult=npcBot:ActionImmediate_PurchaseItem( sNextItem )
            end
            local courier=GetCourier(0)
            local ItemCount=M.GetItemSlotsCount2(courier)
            if(courier:DistanceFromSecretShop() <= 250 and ItemCount<9)	then
                PurchaseResult=GetCourier(0):ActionImmediate_PurchaseItem( sNextItem )
            end
        else
            PurchaseResult=npcBot:ActionImmediate_PurchaseItem( sNextItem )
        end

        if(PurchaseResult==PURCHASE_ITEM_SUCCESS) then
            npcBot.secretShopMode = false
            RemoveTopItemToBuy()
        elseif PurchaseResult ~= -2 then
            print("purchase item failed: "..sNextItem..", fail code: "..PurchaseResult)
        end

        if(PurchaseResult==PURCHASE_ITEM_OUT_OF_STOCK) then
            M.SellSpecifiedItem("item_dust")
            M.SellSpecifiedItem("item_faerie_fire")
            M.SellSpecifiedItem("item_tango")
            M.SellSpecifiedItem("item_clarity")
            M.SellSpecifiedItem("item_flask")
        elseif PurchaseResult==PURCHASE_ITEM_INVALID_ITEM_NAME or PurchaseResult==PURCHASE_ITEM_DISALLOWED_ITEM then
            print("invalid item purchase or disallowed purchase: "..sNextItem)
            RemoveTopItemToBuy()
        elseif (PurchaseResult==PURCHASE_ITEM_INSUFFICIENT_GOLD ) then
            npcBot.secretShopMode = false;
        elseif (PurchaseResult==PURCHASE_ITEM_NOT_AT_SECRET_SHOP) then
            npcBot.secretShopMode = true
        elseif (PurchaseResult==PURCHASE_ITEM_NOT_AT_HOME_SHOP) then
            npcBot.secretShopMode = false;
        end
    else
        npcBot.secretShopMode = false;
    end

end

M.RemoveItemPurchase = function(self, itemTable, itemName)
    local num = #itemTable
    local i = 1
    while i <= num do
        if itemTable[i].name == itemName then
            table.remove(itemTable, i)
            num = num - 1
        end
    end
end

M.InvisibleItemList = {
    "item_invis_sword",
    "item_silver_edge",
    "item_glimmer_cape",
}
M.RemoveInvisibleItemPurchase = function(self, itemTable)
    AbilityExtensions:ForEach(self.InvisibleItemList, function(t)
        self:RemoveItemPurchase(itemTable, t)
    end)
end

return M