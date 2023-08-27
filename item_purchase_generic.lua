local bot = GetBot()

if bot:IsInvulnerable() or bot:IsHero() == false or bot:IsIllusion()
then
	return
end

local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local HeroInfoFile = "NOT IMPLEMENTED"

if bot:IsHero() then
	HeroInfoFile = require(GetScriptDirectory() .. "/hero/items/" .. string.gsub(GetBot():GetUnitName(), "npc_dota_hero_", ""));
	ItemPurchaseSystem.CreateItemInformationTable(GetBot(), HeroInfoFile.ItemsToBuy)
end

-- TODO: Call ItemPurchaseSystem directly
function ItemPurchaseThink()
	ItemPurchaseSystem.ItemPurchaseExtend()
end