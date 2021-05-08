local BotsInit = require("game/botsinit")
local M = BotsInit.CreateGeneric()

local version = "1.7.4"
local updateDate = "May 8, 2021"

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
							"Welcome to Ranked Matchmaking AI. The current version is "..version..", updated on "..updateDate..". If you have any questions or feedback, please leave message on steam workshop https://steamcommunity.com/sharedfiles/filedetails/?id=855965029 or contact Dota2RMMAI@outlook.com",
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
