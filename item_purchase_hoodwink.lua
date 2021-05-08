----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: simonshm5	Email:simonshm5@gmail.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_branches",
	"item_branches",
    
	"item_tranquil_boots",
	"item_magic_wand",
	"item_aether_lens",
    "item_cyclone", 
    
	"item_blink",
	"item_octarine_core",

}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
