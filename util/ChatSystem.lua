local BotsInit = require("game/botsinit")
local M = BotsInit.CreateGeneric()

local announceFlag = false
function M.SendVersionAnnouncement()
	if announceFlag == false then
		announceFlag = true
		for id = 1, 36, 1 do
			if (IsPlayerBot(id) == true) then
				if (GetTeamForPlayer(id) == GetTeam()) then
					local npcBot = GetBot()
					if (npcBot:GetPlayerID() == id) then
						npcBot:ActionImmediate_Chat(
							"Welcome to Ranked Matchmaking AI. The current version is 1.7.2, updated on April 14, 2021. If you have any questions or feedback, please leave message on steam workshop https://steamcommunity.com/sharedfiles/filedetails/?id=855965029 or contact Dota2RMMAI@outlook.com",
							true
						)
						npcBot:ActionImmediate_Chat(
							"Please use hard or unfair mode and do not play as Monkey king.",
							true
						)
					end
				end
				return
			end
		end
	end
end

return M
