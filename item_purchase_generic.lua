local bot = GetBot()

if bot:IsInvulnerable() or bot:IsHero() == false or bot:IsIllusion()
then
	return
end

local HeroInfoFile = "NOT IMPLEMENTED"

if bot:IsHero() then
	HeroInfoFile = require(GetScriptDirectory() .. "/hero/" .. string.gsub(GetBot():GetUnitName(), "npc_dota_hero_", ""));
end

-- TODO: Call ItemPurchaseSystem directly
function ItemPurchaseThink()
	HeroInfoFile.ItemPurchaseThink()
end